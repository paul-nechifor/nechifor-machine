# Nechifor Machine

A Vagrant configuration for my [nechifor.net](http://nechifor.net) domain.

## Running it

Bring up the machine:

    vagrant up nechifor-local

Copy the projects into `sites/`. This step will need to be fixed since projects
are hardcoded to `/home/p/pro`.

    ./scripts/copy-sites.sh

Go in the machine:

    vagrant ssh nechifor-local

From inside the machine:

    sudo /vagrant/scripts/install-sites.py

See it at: [10.10.10.10](http://10.10.10.10).

## Deploying

The DigitalOcean token must be on a line in `private/token`. After that:

    vagrant plugin install vagrant-digitalocean
    vagrant up nechifor-remote --provider=digital_ocean

### Not automated yet:

In `/etc/nginx/nginx.conf` set this:

    http {
        ...
        server_names_hash_bucket_size 64;
        ...
    }

## License

MIT
