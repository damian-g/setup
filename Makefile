USER = $(shell whoami)
KERNEL = $(shell uname -s)
MACHINE = $(shell uname -m)

run:
	sudo apt-get update
	@make git
	@make utilities
	@make apport
	@make numix
	@make phpstorm
	@make spotify
	@make docker
	@make vim
	@make git-lfs
	@make dnsmasq
	@make startup
	@make latex
	reboot
	
docker:
	wget -qO- https://get.docker.com/ | sh
	sudo usermod -aG docker $(USER)
	sudo sh -c "curl -L https://github.com/docker/compose/releases/download/1.8.0/docker-compose-$(KERNEL)-$(MACHINE) > /usr/local/bin/docker-compose"
	sudo chmod +x /usr/local/bin/docker-compose

numix:
	sudo add-apt-repository ppa:numix/ppa -y
	sudo apt-get update
	sudo apt-get install -y numix-icon-theme-circle
	sudo apt-get install -y numix-gtk-theme

apport:
	sudo sed -i s/enabled=1/enabled=0/g /etc/default/apport

utilities:
	sudo apt-get install -y keepassx
	sudo apt-get install -y vlc
	sudo apt-get install -y gparted
	sudo apt-get install -y nautilus-dropbox
	sudo apt-get install -y chromium-browser
	sudo apt-get install -y guake
	sudo apt-get install -y curl
	sudo apt-get install -y rar
	sudo apt-get install -y htop
	sudo apt-get install -y thunderbird
	sudo apt-get install -y openjdk-8-jre
	sudo apt-get install -y livestreamer
	sudo apt-get install -y filezilla
	sudo apt-get install -y gimp
	
git:
	sudo apt-get install -y git
	git config --global log.abbrevCommit yes
	git config --global core.abbrev 8
	git config --global core.fileMode false

git-lfs:
	curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash

vim:
	sudo apt-get install -y vim
	dconf read /org/gnome/desktop/input-sources/xkb-options
	dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape']"

phpstorm:
	wget -O PhpStorm.tar.gz https://download.jetbrains.com/webide/PhpStorm-2016.2.tar.gz
	mkdir PhpStorm
	tar -C PhpStorm -xvf PhpStorm.tar.gz
	sudo rm -fr /usr/local/bin/PhpStorm
	sudo mv PhpStorm/*/ /usr/local/bin/PhpStorm
	rm -rf PhpStorm.tar.gz PhpStorm
	sh /usr/local/bin/PhpStorm/bin/phpstorm.sh

latex:
	sudo apt-get install -y texlive-full

dnsmasq:
	sudo apt-get install -y dnsmasq
	echo 'address=/.dev/127.0.0.1' | sudo tee -a /etc/dnsmasq.conf
	sudo service dnsmasq restart

spotify:
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D2C19886
	echo deb http://repository.spotify.com testing non-free | sudo tee /etc/apt/sources.list.d/spotify.list
	sudo apt-get update
	sudo apt-get install -y spotify-client

startup:
	printf "[Desktop Entry]\nName=Guake\nExec=guake\nTerminal=false\nType=Application\nStartupNotify=false\n" > ~/.config/autostart/guake.desktop
	printf "[Desktop Entry]\nName=Thunderbird\nExec=thunderbird\nTerminal=false\nType=Application\nStartupNotify=false\n" > ~/.config/autostart/thunderbird.desktop

