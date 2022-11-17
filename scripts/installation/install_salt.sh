if [ $1 = 'Nmaster' ]
then
	export DEBIAN_FRONTEND=noninteractive
	echo '192.168.160.10 master' >>  /etc/hosts
	echo 'nameserver 8.8.8.8' > /etc/resolv.conf
	cd /tmp/scripts/salt/files
	tar xvzf salt-master.tar.gz
	cd salt-master
	dpkg -i *.deb
	cd ../
	rm -r salt-master
	echo -e  "master: 192.168.160.10\nid: master" > /etc/salt/minion
	sudo systemctl restart salt-minion
	sudo mkdir -p /srv/salt /srv/pillar
	echo -e "file_roots:\n   base:\n     - /srv/salt/\npillar_roots:\n  base:\n    - /srv/salt/pillar" > /etc/salt/master
	sudo systemctl restart salt-master
	cp  -r  /tmp/scripts/salt/*  /srv/salt
	ln -sf /usr/share/zoneinfo/Asia/Tehran /etc/localtime
	apt install -y ntp
	ntpq -p
	sleep 10
	sudo salt-key -A -y
	sleep 15
	cp /tmp/scripts/salt/files/gpgkeys.tar.gz /etc/salt
	cd /etc/salt
	tar xvzf gpgkeys.tar.gz
	gpg-agent --homedir /etc/salt/gpgkeys --use-standard-socket --daemon
	salt '*' test.ping 
	salt '*' saltutil.refresh_pillar
	#salt-run state.orchestrate install_web
	#salt-run state.orchestrate install_mysql
	salt-run state.orchestrate install_memcache
	#salt-run state.orchestrate install_redis
	salt-run state.orchestrate install_mcrouter
	#salt-run state.orchestrate install_elk
else
	export DEBIAN_FRONTEND=noninteractive
	echo 'nameserver 8.8.8.8' > /etc/resolv.conf
	echo '192.168.160.10 master' >>  /etc/hosts
	cd /tmp
	tar xvzf salt-minion.tar.gz
	cd salt-minion
	dpkg -i *.deb
	echo -e  "master: 192.168.160.10\nid: $1" > /etc/salt/minion
	sudo systemctl restart salt-minion
	ln -sf /usr/share/zoneinfo/Asia/Tehran /etc/localtime
	apt install -y  ntp
	ntpq -p
fi
