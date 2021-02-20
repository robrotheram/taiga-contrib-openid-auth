FROM taigaio/taiga-back:latest
RUN apt-get update && apt-get install git -y
RUN git clone https://github.com/robrotheram/taiga-contrib-openid-auth && cd taiga-contrib-openid-auth && git checkout master
RUN cd taiga-contrib-openid-auth/back; pip install -e .
COPY config.py /taiga-back/settings/config.py
