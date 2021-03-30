# Copyright (C) 2014-2017 Andrey Antukh <niwi@niwi.nz>
# Copyright (C) 2014-2017 Jesús Espino <jespinog@gmail.com>
# Copyright (C) 2014-2017 David Barragán <bameda@dbarragan.com>
# Copyright (C) 2014-2017 Alejandro Alonso <alejandro.alonso@kaleidos.net>
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import requests
import json

from collections import namedtuple
from urllib.parse import urljoin

from django.conf import settings
from django.utils.translation import ugettext_lazy as _

from taiga.base.connectors.exceptions import ConnectorBaseException


class OpenIDApiError(ConnectorBaseException):
    pass


######################################################
# Data
######################################################

CLIENT_ID = getattr(settings, "OPENID_CLIENT_ID", None)
CLIENT_SECRET = getattr(settings, "OPENID_CLIENT_SECRET", None)
TOKEN_URL = getattr(settings, "OPENID_TOKEN_URL", None)
USER_URL = getattr(settings, "OPENID_USER_URL", None)

ID_FIELD  = getattr(settings, "OPENID_ID_FIELD", "sub")
USER_FIELD = getattr(settings, "OPENID_USERNAME_FIELD", "preferred_username")
NAME_FIELD = getattr(settings, "OPENID_FULLNAME_FIELD", "name")
EMAIL_FIELD = getattr(settings, "OPENID_EMAIL_FIELD", "email")

HEADERS = {"Accept": "application/json", }



AuthInfo = namedtuple("AuthInfo", ["access_token"])
User = namedtuple("User", ["id", "username", "full_name", "email"])

######################################################
# utils
######################################################


def _build_url(*args, **kwargs) -> str:
    """
    Return a valid url.
    """
    resource_url = API_RESOURCES_URLS
    for key in args:
        resource_url = resource_url[key]

    if kwargs:
        resource_url = resource_url.format(**kwargs)

    return urljoin(API_URL, resource_url)


def _get(url: str, headers: dict) -> dict:
    """
    Make a GET call.
    """
    response = requests.get(url, headers=headers)
    data = response.json()
    if response.status_code != 200:
        raise OpenIDApiError({"status_code": response.status_code,
                              "error": data.get("error", "")})
    return data


def _post(url: str, params: dict, headers: dict) -> dict:
    """
    Make a POST call.
    """
    response = requests.post(url, data=params, headers=headers)
    data = response.json()
    if response.status_code != 200 or "error" in data:
        raise OpenIDApiError({"status_code": response.status_code,
                              "error": data.get("error", "")})
    return data


######################################################
# Simple calls
######################################################

def login(access_code: str, token: str, redirect_uri: str, client_id: str = CLIENT_ID, client_secret: str = CLIENT_SECRET, headers: dict = HEADERS):
    """
    Get access_token fron an user authorized code, the client id and the client secret key.
    (See http://openid.net/specs/openid-connect-core-1_0.html#TokenEndpoint).
    """
    if not CLIENT_ID or not CLIENT_SECRET:
        raise OpenIDApiError({"error_message": _(
            "The OpenID Connect plugin isn't properly configured. Please contact your sysadmin.")})

    if token == "" or token == None:
        url = TOKEN_URL
        params = {"grant_type": "authorization_code",
                  "code": access_code,
                  "client_id": CLIENT_ID,
                  "client_secret": CLIENT_SECRET,
                  "redirect_uri": redirect_uri
                  }
        data = _post(url, params=params, headers=headers)
        return AuthInfo(access_token=data.get("access_token", None))
    else:
        return AuthInfo(access_token=token)


def get_user_profile(headers: dict = HEADERS):
    """
    Get authenticated user info.
    (See openid.net/specs/openid-connect-core-1_0.html#UserInfo).
    """

    url = USER_URL
    data = _get(url, headers=headers)
    username = None

    if data.get(USER_FIELD, None) != None :
        username = data.get(USER_FIELD, None)

    elif data.get("preferred_username", None) != None :
        username = data.get("preferred_username", None) 

    elif data.get("full_name", None) != None :
        username = data.get("full_name", None) 

    elif data.get("username", None) != None :
        username = data.get("username", None),
    
    user =  User(id=data.get(ID_FIELD, None),
                username=data.get(username, None),
                full_name=data.get(NAME_FIELD, None),
                email=data.get(EMAIL_FIELD, None),
                )
    print("USER: ")
    print(user)
    return user

######################################################
# Convined calls
######################################################


def me(access_code: str, token: str, redirect_uri: str) -> tuple:
    """
    Connect to a openid account and get all personal info (profile and the primary email).
    """
    auth_info = login(access_code, token, redirect_uri)
    headers = HEADERS.copy()
    headers["Authorization"] = "Bearer {}".format(auth_info.access_token)
    user = get_user_profile(headers=headers)
    return user
