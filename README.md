taiga-contrib-openid-auth
=========================
An OpenID / Keycloak Authentication Plugin. Heavily based off of
[taiga-contrib-github-auth](https://github.com/taigaio/taiga-contrib-github-auth).

Compatible with Taiga 4.2.1

# Installation
## Taiga Backend

Clone the repo and

```bash
cd taiga-contrib-openid-auth/back
workon taiga
pip install -e .
```

Modify `taiga-back/settings/local.py` and include the line:

```python
INSTALLED_APPS += ["taiga_contrib_openid_auth"]
OPENID_USER_URL = "https://{url-to-keycloak}/auth/realms/{realm}/protocol/openid-connect/userinfo"
OPENID_TOKEN_URL = "https://{url-to-keycloak}/auth/realms/{realm}/protocol/openid-connect/token"
OPENID_CLIENT_ID = "{client id}"
OPENID_CLIENT_SECRET = "{client secret}"
```

## Taiga Frontend

Clone the repo and then link `dist` to the `taiga-front` plugins directory:

```bash
mkdir {path-to-taiga-frontend}/plugins
ln -s {path-to-taiga-contrib-openid-auth}/dist {path-to-taiga-frontend}/plugins/openid-auth
```

Add the following values to `{path-to-taiga-frontend}/conf.json`:

```json
{
  "openidAuth" : "https://{url-to-keycloak}/auth/realms/{realm}/protocol/openid-connect/auth",
  "openidName" : "{name-for-login-button}",
  "openidClientId": "{client_id}",
  "contribPlugins": [
      "/plugins/openid-auth/openid-auth.json"
  ]
}
```

In the plugin source dir `taiga-contrib-openid-auth/front` run

```bash
# To install dependencies:
npm install
# To rebuild front-end code:
gulp build
# To rebuild and watch front-end code for changes:
gulp
```
