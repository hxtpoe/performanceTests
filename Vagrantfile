# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "performanceTestVM"
  config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130731.box"
  config.vm.network :forwarded_port, guest: 80, host: 8282
  config.vm.network :forwarded_port, guest: 22, host: 2202
  config.vm.network :private_network, ip: "192.168.33.11"
  config.vm.synced_folder "files/", "/vagrant_files/"
  
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "init.pp"
  end
  
end
