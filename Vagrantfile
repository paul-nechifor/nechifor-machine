Vagrant.configure("2") do |config|
  vmname = "local"
  config.vm.define vmname.to_sym do |machine|
    machine.vm.box = "hashicorp/precise64"
    machine.vm.host_name = vmname
    machine.vm.network "private_network", ip: "10.10.10.10"
    machine.vm.provision "shell", path: "scripts/provision.sh"
    machine.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 1
    end
  end

  if File.file?('private/token')
    vmname = "nechifor-remote"
    config.vm.define vmname.to_sym do |machine|
      machine.vm.host_name = vmname
      machine.vm.provision "shell", path: "scripts/provision.sh"
      machine.vm.provider :digital_ocean do |provider, override|
        override.ssh.private_key_path = '~/.ssh/id_rsa'
        override.vm.box = 'digital_ocean'
        override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"

        provider.token = File.read('private/token').strip
        provider.image = 'Ubuntu 12.04.4 x64'
        provider.region = 'ams2'
        provider.size = '1gb'
      end
    end
  end
end
