ARG TAIGA_VERSION=latest
ARG RELEASE=master
FROM taigaio/taiga-front:${TAIGA_VERSION}
ENV OPENID_SCOPE="openid email"

COPY docker/front/conf.json.template /usr/share/nginx/html/conf.json.template
COPY docker/front/30_config_env_subst.sh /docker-entrypoint.d/30_config_env_subst.sh
COPY front/dist/. /tmp/

##Debugging
#RUN ls -alh /tmp

## Old Dockerfile
#RUN wget -O /tmp/taiga-contrib-openid-auth.tar.gz "https://github.com/robrotheram/taiga-contrib-openid-auth/archive/refs/heads/master.tar.gz" \
# && tar xzf /tmp/taiga-contrib-openid-auth.tar.gz -C /tmp \
# && mkdir -p /usr/share/nginx/html/plugins/openid-auth \
# && cp -r /tmp/taiga-contrib-openid-auth*/front/dist/* /usr/share/nginx/html/plugins/openid-auth

RUN mkdir -p /usr/share/nginx/html/plugins/openid-auth \
 && cp -r /tmp/* /usr/share/nginx/html/plugins/openid-auth
