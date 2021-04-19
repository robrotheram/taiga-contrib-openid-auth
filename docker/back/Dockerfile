ARG TAIGA_VERSION=latest
ARG RELEASE=master
FROM taigaio/taiga-back:${TAIGA_VERSION}
RUN apt-get update && apt-get install git -y
RUN git clone https://github.com/robrotheram/taiga-contrib-openid-auth && cd taiga-contrib-openid-auth && git checkout ${RELEASE}
RUN cd taiga-contrib-openid-auth/back; pip install -e .
COPY config.py /taiga-back/settings/config.py
ENV OPENID_SCOPE="openid email"