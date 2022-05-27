ARG TAIGA_VERSION=latest
ARG RELEASE=master
FROM taigaio/taiga-back:${TAIGA_VERSION}
ENV OPENID_SCOPE="openid email"
ADD config.py.snippet /tmp
RUN python -c 'import urllib.request as r; r.urlretrieve("https://github.com/robrotheram/taiga-contrib-openid-auth/archive/refs/heads/master.tar.gz", "/tmp/taiga-contrib-openid-auth.tar.gz")' \
 && tar xzf /tmp/taiga-contrib-openid-auth.tar.gz -C /tmp \
 && pip install /tmp/taiga-contrib-openid-auth*/back \
 && rm -r /tmp/taiga-contrib-openid-auth* \
 && cat /tmp/config.py.snippet >> /taiga-back/settings/config.py
