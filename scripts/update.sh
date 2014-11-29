#!/bin/bash

root="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

main() {
  cd $root/..
  vagrant rsync nechifor-remote
  vagrant ssh nechifor-remote -- -t 'sudo /vagrant/scripts/install-sites.py'
}

main $@
