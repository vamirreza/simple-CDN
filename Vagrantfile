Vagrant.configure("2") do |config|

  config.vm.define "webserver" do |webserver|
    webserver.vm.box = "hashicorp/bionic64"
    webserver.vm.hostname = "webserver"
    webserver.vm.network "private_network", ip: "192.168.10.2", virtualbox__intnet: "back"
    webserver.vm.synced_folder "./blog/", "/srv/blog"
    webserver.vm.provision "shell", path: "scripts/docker.sh"
    webserver.vm.provision "shell", inline: <<-SHELL
      cd /srv/blog && docker-compose up -d 
    SHELL
  end

  config.vm.define "logger" do |logger|
    logger.vm.provider "virtualbox" do |v|
      v.memory = 4096
    end
    logger.vm.box = "hashicorp/bionic64"
    logger.vm.hostname = "logger"
    logger.vm.network "private_network", ip: "192.168.10.4", virtualbox__intnet: "back"
    logger.vm.synced_folder "./elk/", "/srv/elk"
    logger.vm.provision "shell", path: "scripts/docker.sh"
    logger.vm.provision "shell", inline: <<-SHELL
      sudo crontab /srv/elk/croncleanup
      sudo sysctl -w vm.max_map_count=262144
      cd /srv/elk && docker-compose build && docker-compose up -d
    SHELL
  end

  config.vm.define "edge" do |edge|
    edge.vm.box = "hashicorp/bionic64"
    edge.vm.hostname = "EDGE"
    edge.vm.network "private_network", ip: "192.168.10.3", virtualbox__intnet: "back"
    edge.vm.network "private_network", ip: "10.0.10.10", virtualbox__intnet: "bgp"
    edge.vm.synced_folder "./bgp.conf/edge", "/etc/bird", owner: "root", group: "root"
    edge.vm.synced_folder "./edge/nginx", "/etc/nginx/conf.d", owner: "root", group: "root"
    edge.vm.synced_folder "./edge/purge", "/home/vagrant"
    edge.vm.provision "shell", path: "scripts/bird.sh"
    edge.vm.provision "shell", inline: <<-SHELL
      sudo chmod +x /home/vagrant/purge.sh 
      sudo apt update
      sudo apt install nginx -y
      sudo mkdir /var/cache/nginx
      sudo chmod -R 777 /var/cache/nginx
      sudo service nginx restart
    SHELL
  end

  config.vm.define "isp" do |isp|
    isp.vm.box = "hashicorp/bionic64"
    isp.vm.hostname = "isp"
    isp.vm.network "private_network", ip: "10.0.10.11", virtualbox__intnet: "bgp"
    isp.vm.network "private_network", ip: "172.20.0.10", virtualbox__intnet: "front"
    isp.vm.synced_folder "./bgp.conf/isp", "/etc/bird", owner: "root", group: "root"
    isp.vm.provision "shell", path: "scripts/bird.sh"
    isp.vm.provision "shell",
      run: "always",
      inline: "sudo sysctl -w net.ipv4.ip_forward=1"
  end

  config.vm.define "client" do |client|
    client.vm.box = "hashicorp/bionic64"
    client.vm.hostname = "client"
    client.vm.network "private_network", ip: "172.20.0.20", virtualbox__intnet: "front"
    client.vm.provision "shell", inline: <<-SHELL
      sudo route delete default gw 10.0.2.2
      sudo route add default gw 172.20.0.10
      echo "10.0.10.10  blog.digikala.com" >> /etc/hosts
    SHELL
  end

end
