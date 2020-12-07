# simple-CDN
Simple CDN configured by Linux, Vagrant, Bird, Bash, Nginx, ELK stack

## setup environment 

Make ready all VMs:

```command
vagrant up
```

This command start five machines:

⋅⋅* webserver
⋅⋅* logger
⋅⋅* edge
⋅⋅* isp
⋅⋅* client 

### webserver

Wordpress instal by docker and docker-compose 

### logger

ELK stack installed by docker and docker-compose. logstash collect log by syslog from edge server.

### edge

As BGP router communicate with isp server by Bird. As proxy forward requests to webserver machine. 
act like CDN by use nginx rules and config.

#### purge file from CDN

Run this command in edge server(/home/vagrant):

```command
./purge.sh <file url>
```

### isp

As BGP router communicate with edge server by Bird. As gateway connect client to network.

### client 

For sending and testing web content.

```command
curl -v http://blog.digikala.com
```






