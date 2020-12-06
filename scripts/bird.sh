BIRD_RUN_USER=bird
BIRD_RUN_GROUP=bird
BIRD_RUN_DIR=/run/bird
BIRD_ARGS=""

apt-get update && apt-get install -y bird procps inetutils-traceroute
rm -rf /var/lib/apt/lists/*
 
mkdir -p ${BIRD_RUN_DIR} 
chown --silent ${BIRD_RUN_USER}:${BIRD_RUN_GROUP} ${BIRD_RUN_DIR} && \
chmod 775 ${BIRD_RUN_DIR}
chmod 775 /etc/bird/ && chmod 744 /etc/bird/bird.conf
sudo service bird restart
