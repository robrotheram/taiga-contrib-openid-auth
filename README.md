Taiga contrib Openid auth
=========================

[![Kaleidos Project](http://kaleidos.net/static/img/badge.png)](https://github.com/kaleidos "Kaleidos Project")
[![Managed with Taiga.io](https://img.shields.io/badge/managed%20with-TAIGA.io-709f14.svg)](https://tree.taiga.io/project/taiga/ "Managed with Taiga.io")

Openid / Keycloak authentication plugin . Heavily based off the github one

##### warning:  extremely experimental built over 2 days to play around with tagia on my network with a keycloak idenity server. 
##### Production install will probably not work




Installation
------------
### Production env

#### Taiga Back

In your Taiga back python virtualenv install the pip package `taiga-contrib-openid-auth` with:

```bash
  pip install taiga-contrib-openid-auth
```

Modify your `settings/local.py` and include the line:

```python
  INSTALLED_APPS += ["taiga_contrib_openid_auth"]

OPENID_USER_URL = "open-id-url/auth/realms/{realm}/protocol/openid-connect/userinfo"
OPENID_TOKEN_URL = "open-id-url/auth/realms/{realm}/protocol/openid-connect/token"
OPENID_CLIENT_ID = 
OPENID_CLIENT_SECRET =

```

#### Taiga Front

Download in your `dist/plugins/` directory of Taiga front the `taiga-contrib-openid-auth` compiled code (you need subversion in your system):

```bash
  cd dist/
  mkdir -p plugins
  cd plugins
  svn export "https://github.com/taigaio/taiga-contrib-openid-auth/tags/$(pip show taiga-contrib-openid-auth | awk '/^Version: /{print $2}')/front/dist"  "openid-auth"
```

Include in your `dist/conf.json` in the 'contribPlugins' list the value `"/plugins/openid-auth/openid-auth.json"`:

```json
...
    "openidAuth" : "open-id-url/auth/realms/{realm}/protocol/openid-connect/auth",
    "openidName" : "keycloack" ] #optional paramater for the name on login button defaults to "openid-connect"
    "contribPlugins": [
        (...)
        openid-auth.json
    ]
...
```

### Dev env

#### Taiga Back

Clone the repo and

```bash
  cd taiga-contrib-openid-auth/back
  workon taiga
  pip install -e .
```

Modify `taiga-back/settings/local.py` and include the line:

```python
  INSTALLED_APPS += ["taiga_contrib_openid_auth"]

OPENID_USER_URL = "open-id-url/auth/realms/{realm}/protocol/openid-connect/userinfo"
OPENID_TOKEN_URL = "open-id-url/auth/realms/{realm}/protocol/openid-connect/token"
OPENID_CLIENT_ID = 
OPENID_CLIENT_SECRET =
```

#### Taiga Front

After clone the repo link `dist` in `taiga-front` plugins directory:

```bash
  cd taiga-front/dist
  mkdir -p plugins
  cd plugins
  ln -s ../../../taiga-contrib-openid-auth/dist openid-auth
```

Include in your `dist/conf.json` in the 'contribPlugins' list the value `"/plugins/openid-auth/github-auth.json"`:

```json
...
    "openidAuth" : "open-id-url/auth/realms/{realm}/protocol/openid-connect/auth",
    "openidName" : "keycloack" ] #optional paramater for the name on login button defaults to "openid-connect"
    "contribPlugins": [
        (...)
        "/plugins/openid-auth/openid-auth.json"
    ]
...
```

In the plugin source dir `taiga-contrib-openid-auth/front` run

```bash
npm install
```
and use:

- `gulp` to regenerate the source and watch for changes.
- `gulp build` to only regenerate the source.

Running tests
-------------

We only have backend tests, you have to add your `taiga-back` directory to the
PYTHONPATH environment variable, and run py.test, for example:

```bash
  cd back
  add2virtualenv /home/taiga/taiga-back/
  py.test
```

