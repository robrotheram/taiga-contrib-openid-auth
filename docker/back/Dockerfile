ARG TAIGA_VERSION=latest
ARG RELEASE=master
FROM taigaio/taiga-back:${TAIGA_VERSION}
ENV OPENID_SCOPE="openid email"
ADD docker/back/config.py.snippet /tmp
COPY back/. /tmp/

#some debug-hack!
#ADD docker/back/copied_services.py /taiga-back/taiga/projects/tasks/services.py 
#RUN ls -alh /tmp
#RUN ls -alh /taiga-back/taiga/projects/tasks

#old Dockerfile
#RUN python -c 'import urllib.request as r; r.urlretrieve("https://github.com/robrotheram/taiga-contrib-openid-auth/archive/refs/heads/master.tar.gz", "/tmp/taiga-contrib-openid-auth.tar.gz")' \
# && tar xzf /tmp/taiga-contrib-openid-auth.tar.gz -C /tmp \
# && pip install /tmp/taiga-contrib-openid-auth*/back \
# && rm -r /tmp/taiga-contrib-openid-auth* \
# && cat /tmp/config.py.snippet >> /taiga-back/settings/config.py

RUN pip install /tmp \
 && cat /tmp/config.py.snippet >> /taiga-back/settings/config.py
