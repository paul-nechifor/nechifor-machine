Vagrant.configure('2') do |config|
  config.vm.synced_folder 'synced/', '/opt/nechifor-machine'

  vmname = 'local'
  config.vm.define vmname.to_sym do |machine|
    machine.vm.box = 'ubuntu/xenial64'
    machine.vm.host_name = vmname
    machine.vm.network 'private_network', ip: '10.10.10.10'
    machine.vm.provision 'shell', path: 'synced/provision.sh'
    machine.vm.provider 'virtualbox' do |v|
      v.memory = 1024
      v.cpus = 1
    end
  end
end
