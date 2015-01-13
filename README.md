rwanda-puppet
=============

Install script for provisioning a sync server

Log on as root
------------------
$ sudo su -


Install puppet
------------------
```
cd /tmp
wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb
dpkg -i puppetlabs-release-precise.deb
apt-get update
apt-get install puppet-common
puppet resource package puppet ensure=latest
```

Verify puppet has been installed
------------------
```
$ facter
```

Copy rwanda-puppet install package to /etc/puppet/
------------------
```
rm -rf /etc/puppet
cd /etc/

apt-get install git
git clone https://github.com/cioan/rwanda-puppet.git puppet

```


Run install
-----------
```
cd /etc/puppet
./install.sh
```
