Taiga contrib github auth
=========================

The Taiga plugin for github authentication.

Installation
------------

### Taiga Back

In your Taiga back python virtualenv install the pip package `taiga-contrib-github-auth` with:

```bash
  pip install taiga-contrib-github-auth
```

Modify your settings/local.py and include the line:

```python
  INSTALLED_APPS += ["taiga_contrib_github_auth"]
```

### Taiga Front

Download in your `dist/js/` directory of Taiga front the `taiga-contrib-github-auth` compiled code:

```bash
  cd dist/js
  wget "https://raw.githubusercontent.com/taigaio/taiga-contrib-github-auth/stable/front/dist/github_auth.js"
```

Download in your `dist/images/contrib` directory of Taiga front the `taiga-contrib-github-auth` github icon:

```bash
  cd dist/images/contrib
  wget "https://raw.githubusercontent.com/taigaio/taiga-contrib-github-auth/stable/front/images/contrib/github-logo.png"
```

Include in your dist/js/conf.json in the contribPlugins list the value `"/js/github_auth.js"`:

```json
...
    "contribPlugins": ["/js/github_auth.js"]
...
```
