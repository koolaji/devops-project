# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

server = {
  "Nnode01" =>  { :ip => "192.168.160.11", :cpus => 2, :mem => "2048"},
  "Nnode02" =>  { :ip => "192.168.160.12", :cpus => 2, :mem => "2048"},
  "Nnode03" =>  { :ip => "192.168.160.13", :cpus => 2, :mem => "2048"},
  "Nnode04" =>  { :ip => "192.168.160.14", :cpus => 2, :mem => "2048"},
  "Nmaster" =>  { :ip => "192.168.160.10", :cpus => 8, :mem => "2048"},
}
 

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  server.each_with_index do |(hostname, info), index|

    config.vm.define hostname do |cfg|
      cfg.vm.provider :virtualbox do |node, override|
        config.vm.box = "bento/ubuntu-20.04"
        override.vm.network  "public_network", ip: "#{info[:ip]}", bridge: "wlo1"
        override.vm.hostname = hostname
        node.name = hostname
        node.customize ["modifyvm", :id, "--memory", info[:mem] ]
        node.customize ["modifyvm", :id, "--cpus", info[:cpus] ]
        node.customize ["modifyvm", :id, "--hwvirtex", "on" ]
	if hostname == "Nmaster" 
		override.vm.provision "file", source: "scripts/", destination: "/tmp/scripts"
	end #end if
	if hostname != "Nmaster" 
		  override.vm.disk :disk, size: "2GB", name: "extra_storage1"
		  override.vm.disk :disk, size: "2GB", name: "extra_storage1"
	end #end if

        override.vm.provision "file", source: "scripts/salt/files/salt-minion.tar.gz", destination: "/tmp/"
     	override.vm.provision "shell" do |s| 
        	s.path = "scripts/installation/install_salt.sh"
        	s.args = hostname
      	end #shell
      end # end provider
    end # end config

  end # end server
end
