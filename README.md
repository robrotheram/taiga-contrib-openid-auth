Taiga contrib github auth
=========================

![Kaleidos Project](http://kaleidos.net/static/img/badge.svg "Kaleidos Project")
[![Managed with Taiga.io](https://img.shields.io/badge/managed%20with-TAIGA.io-709f14.svg)](https://tree.taiga.io/project/taiga/ "Managed with Taiga.io")

The Taiga plugin for github authentication.

Installation
------------
### Production env

#### Taiga Back

In your Taiga back python virtualenv install the pip package `taiga-contrib-github-auth` with:

```bash
  pip install taiga-contrib-github-auth
```

Modify your `settings/local.py` and include the line:

```python
  INSTALLED_APPS += ["taiga_contrib_github_auth"]

  # Get these from https://github.com/settings/developers
  GITHUB_API_CLIENT_ID = "YOUR-GITHUB-CLIENT-ID"
  GITHUB_API_CLIENT_SECRET = "YOUR-GITHUB-CLIENT-SECRET"
```

#### Taiga Front

Download in your `dist/plugins/` directory of Taiga front the `taiga-contrib-github-auth` compiled code (you need subversion in your system):

```bash
  cd dist/
  mkdir -p plugins
  cd plugins
  svn export "https://github.com/taigaio/taiga-contrib-github-auth/tags/$(pip show taiga-contrib-github-auth | awk '/^Version: /{print $2}')/front/dist"  "github-auth"
```

Include in your `dist/conf.json` in the 'contribPlugins' list the value `"/plugins/github-auth/github-auth.json"`:

```json
...
    "gitHubClientId": "YOUR-GITHUB-CLIENT-ID",
    "contribPlugins": [
        (...)
        "/plugins/github-auth/github-auth.json"
    ]
...
```

### Dev env

#### Taiga Back

Clone the repo and

```bash
  cd taiga-contrib-github-auth/back
  workon taiga
  pip install -e .
```

Modify `taiga-back/settings/local.py` and include the line:

```python
  INSTALLED_APPS += ["taiga_contrib_github_auth"]

  # Get these from https://github.com/settings/developers
  GITHUB_API_CLIENT_ID = "YOUR-GITHUB-CLIENT-ID"
  GITHUB_API_CLIENT_SECRET = "YOUR-GITHUB-CLIENT-SECRET"
```

#### Taiga Front

After clone the repo link `dist` in `taiga-front` plugins directory:

```bash
  cd taiga-front/dist
  mkdir -p plugins
  cd plugins
  ln -s ../../../taiga-contrib-github-auth/dist github-auth
```

Include in your `dist/conf.json` in the 'contribPlugins' list the value `"/plugins/github-auth/github-auth.json"`:

```json
...
    "gitHubClientId": "YOUR-GITHUB-CLIENT-ID",
    "contribPlugins": [
        (...)
        "/plugins/github-auth/github-auth.json"
    ]
...
```

In the plugin source dir `taiga-contrib-github-auth/front` run

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

