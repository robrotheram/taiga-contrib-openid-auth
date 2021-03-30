taiga-contrib-openid-auth
=========================
An OpenID / Keycloak Authentication Plugin. Heavily based off of
[taiga-contrib-github-auth](https://github.com/taigaio/taiga-contrib-github-auth).

Compatible with Taiga 4.2.1, 5.x, 6

# Installation

## Docker
This plugin is compatible with the offical taiga docker images 😃

https://github.com/taigaio/taiga-docker

This project builds 2 images based off the images provided by taiga. This should allow anyother customisations to continue to work.

The following will show the changes needed to the default docker-compose file to install the openid plugin.

### Config 
The 2 images:
 - robrotheram/taiga-front-openid
 - robrotheram/taiga-back-openid

Use the following environmental setting to configure the frontend conf.json and backed settings.py

```
ENABLE_OPENID: "True"
OPENID_URL : "https://{url-to-keycloak}/auth/realms/{realm}/protocol/openid-connect/auth"
OPENID_USER_URL : "https://{url-to-keycloak}/auth/realms/{realm}/protocol/openid-connect/userinfo"
OPENID_TOKEN_URL : "https://{url-to-keycloak}/auth/realms/{realm}/protocol/openid-connect/token"
OPENID_CLIENT_ID : "<CLient ID>"
OPENID_CLIENT_SECRET : "<CLient SECRET>"
OPENID_NAME: "Name you want to give your openid provider e.g keycloak"
```

### Docker-compose file modified from https://github.com/taigaio/taiga-docker
```
version: "3.5"

x-environment:
  &default-back-environment
  # Database settings
  POSTGRES_DB: taiga
  POSTGRES_USER: taiga
  POSTGRES_PASSWORD: taiga
  POSTGRES_HOST: taiga-db
  # Taiga settings
  TAIGA_SECRET_KEY: "taiga-back-secret-key"
  TAIGA_SITES_DOMAIN: "localhost:9000"
  TAIGA_SITES_SCHEME: "http"
  # Email settings. Uncomment following lines and configure your SMTP server
  # EMAIL_BACKEND: "django.core.mail.backends.smtp.EmailBackend"
  # DEFAULT_FROM_EMAIL: "no-reply@example.com"
  # EMAIL_USE_TLS: "False"
  # EMAIL_USE_SSL: "False"
  # EMAIL_HOST: "smtp.host.example.com"
  # EMAIL_PORT: 587
  # EMAIL_HOST_USER: "user"
  # EMAIL_HOST_PASSWORD: "password"
  # Rabbitmq settings
  # Should be the same as in taiga-async-rabbitmq and taiga-events-rabbitmq
  RABBITMQ_USER: taiga
  RABBITMQ_PASS: taiga
  
  # Telemetry settings
  ENABLE_TELEMETRY: "True"
  
  # Enable OpenID to allow to register users if they do not exist. Set to false to disable all signups
  PUBLIC_REGISTER_ENABLED: "True"

  # OpenID settings
  ENABLE_OPENID: "True"
  OPENID_USER_URL : "https://{url-to-keycloak}/auth/realms/{realm}/protocol/openid-connect/userinfo"
  OPENID_TOKEN_URL : "https://{url-to-keycloak}/auth/realms/{realm}/protocol/openid-connect/token"
  OPENID_CLIENT_ID : "<CLient ID>"
  OPENID_CLIENT_SECRET : "<CLient SECRET>"

x-volumes:
  &default-back-volumes
  - taiga-static-data:/taiga-back/static
  - taiga-media-data:/taiga-back/media
  # - ./config.py:/taiga-back/settings/config.py


services:
  taiga-db:
    image: postgres:12.3
    environment:
      POSTGRES_DB: taiga
      POSTGRES_USER: taiga
      POSTGRES_PASSWORD: taiga
    volumes:
      - taiga-db-data:/var/lib/postgresql/data
    networks:
      - taiga

  taiga-back:
    image: robrotheram/taiga-back-openid
    environment: *default-back-environment
    volumes: *default-back-volumes
    networks:
      - taiga
    depends_on:
      - taiga-db
      - taiga-events-rabbitmq
      - taiga-async-rabbitmq

  taiga-async:
    image: taigaio/taiga-back:latest
    entrypoint: ["/taiga-back/docker/async_entrypoint.sh"]
    environment: *default-back-environment
    volumes: *default-back-volumes
    networks:
      - taiga
    depends_on:
      - taiga-db
      - taiga-back
      - taiga-async-rabbitmq

  taiga-async-rabbitmq:
    image: rabbitmq:3-management-alpine
    environment:
      RABBITMQ_ERLANG_COOKIE: secret-erlang-cookie
      RABBITMQ_DEFAULT_USER: taiga
      RABBITMQ_DEFAULT_PASS: taiga
      RABBITMQ_DEFAULT_VHOST: taiga
    networks:
      - taiga

  taiga-front:
    image: robrotheram/taiga-front-openid
    environment:
      TAIGA_URL: "http://localhost:9000"
      TAIGA_WEBSOCKETS_URL: "ws://localhost:9000"
      ENABLE_OPENID: "true"
      OPENID_URL : "https://{url-to-keycloak}/auth/realms/{realm}/protocol/openid-connect/auth"
      OPENID_CLIENT_ID : "<ClientID>"
      OPENID_NAME: "Name you want to give your openid provider e.g keycloak"
    networks:
      - taiga
    # volumes:
    #   - ./conf.json:/usr/share/nginx/html/conf.json

  taiga-events:
    image: taigaio/taiga-events:latest
    environment:
      RABBITMQ_USER: taiga
      RABBITMQ_PASS: taiga
      TAIGA_SECRET_KEY: "taiga-back-secret-key"
    networks:
      - taiga
    depends_on:
      - taiga-events-rabbitmq

  taiga-events-rabbitmq:
    image: rabbitmq:3-management-alpine
    environment:
      RABBITMQ_ERLANG_COOKIE: secret-erlang-cookie
      RABBITMQ_DEFAULT_USER: taiga
      RABBITMQ_DEFAULT_PASS: taiga
      RABBITMQ_DEFAULT_VHOST: taiga
    networks:
      - taiga

  taiga-protected:
    image: taigaio/taiga-protected:latest
    environment:
      MAX_AGE: 360
      SECRET_KEY: "taiga-back-secret-key"
    networks:
      - taiga

  taiga-gateway:
    image: nginx:1.19-alpine
    ports:
      - "9000:80"
    volumes:
      - ./taiga-gateway/taiga.conf:/etc/nginx/conf.d/default.conf
      - taiga-static-data:/taiga/static
      - taiga-media-data:/taiga/media
    networks:
      - taiga
    depends_on:
      - taiga-front
      - taiga-back
      - taiga-events

volumes:
  taiga-static-data:
  taiga-media-data:
  taiga-db-data:

networks:
  taiga:
```

## Manual installation
### Taiga Backend

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

# Building

The make file contains the basic blocks to locally build the UI and docker containers.

```
make build
```

# Contributions
My thanks to all the people who have added to the plugin
@cristianlazarop 
@swedishborgie
@baloo42 
The whole taiga team who wrote the github plugin that this plugin is based off.

