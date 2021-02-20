# Changelog 

## 0.0.1 (2018-08-07)
- Compatible with Taiga 3.0.0
- Initial release.
- Forked from https://github.com/taigaio/taiga-contrib-github-auth

## 0.0.2 (2019-04-02)
- Compatible with Taiga 4.2.1
- Fixed several references to the Github contrib plugin for Taiga.
- Fixed missing OpenID button image.
- Added the ability to pass the access token to the front end to support authenticating reverse proxies like [keycloak-gatekeeper](https://github.com/keycloak/keycloak-gatekeeper).

## 0.0.2 (2019-04-02)
- Compatible with Taiga 4.2.1
- Fixed several references to the Github contrib plugin for Taiga.
- Fixed missing OpenID button image.
- Added the ability to pass the access token to the front end to support authenticating reverse proxies like [keycloak-gatekeeper](https://github.com/keycloak/keycloak-gatekeeper).


## 6.0.2 (2021-02-20)
- Compatible with Taiga 6.0.2
- Mereged work done by @cristianlazarop 
- Added back in required features (user signups)
- Breaking change. To allow registrations backend needs to have 'PUBLIC_REGISTER_ENABLED=True' see Readme.md
- Added Docker Files to allow the plugin to work with the offical taiga images for 6
