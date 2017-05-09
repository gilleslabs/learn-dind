# -*- mode: ruby -*-
# vi: set ft=ruby :

################################################################################################################
#                                                                                                              #
# Vagrantfile for provisioning ready-to-go DIND VMs#
#                                                                                                              #
# Author: Gilles Tosi                                                                                          #
#                                                                                                              #
# The up-to-date version and associated dependencies/project documentation is available at:                    #
#                                                                                                              #
# https://github.com/gilleslabs/learn-dind                                                                     #
#                                                                                                              #
################################################################################################################


Vagrant.configure(2) do |config|

	config.vm.define "dind" do |dind|
        dind.vm.box = "ubuntu/trusty64"
			config.vm.provider "virtualbox" do |v|
				v.cpus = 4
				v.memory = 8192
			end
        dind.vm.hostname ="dind"
		dind.vm.network "private_network", ip: "192.168.99.10"
		dind.vm.provision :shell, path: "install-docker.sh"
		dind.vm.provision :shell, path: "install-dind.sh"
    end
	
end