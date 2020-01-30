#!/bin/bash

# Run this script once to build secrets & configs


# remove any old secrest and configs
if [[ $(docker secret ls -f name=h5p -q) ]]; then
    docker secret rm $(docker secret ls -f name=h5p -q)
else
    echo "no files found"
fi


# create secrets for database
# alternative date |md5sum|awk '{print $1}' | docker secret create my_secret -
date |md5sum|awk '{print $1}' | docker secret create h5p_db_dba_password -

echo done...



# clean mounts
sudo rm -rf /mnt/nfs/nfsdlo/$STACK_NETWORK/$STACK_SERVICE/$STACK_VERSION/html
sudo rm -rf /mnt/nfs/nfsdlo/$STACK_NETWORK/$STACK_SERVICE/$STACK_VERSION/conf
sudo rm -rf /mnt/nfs/nfsdlo/$STACK_NETWORK/$STACK_SERVICE/$STACK_VERSION/src
sudo rm -rf /mnt/nfs/nfsdlo/$STACK_NETWORK/$STACK_SERVICE/$STACK_VERSION/tmp
sudo rm -rf /mnt/nfs/nfsdlo/$STACK_NETWORK/$STACK_SERVICE/$STACK_VERSION/data
sudo rm -rf /mnt/nfs/nfsdlo/$STACK_NETWORK/$STACK_SERVICE/$STACK_VERSION/psqldata

# create nfs mount
mkdir -p /mnt/nfs/nfsdlo/$STACK_NETWORK/$STACK_SERVICE/$STACK_VERSION/html
mkdir -p /mnt/nfs/nfsdlo/$STACK_NETWORK/$STACK_SERVICE/$STACK_VERSION/conf
mkdir -p /mnt/nfs/nfsdlo/$STACK_NETWORK/$STACK_SERVICE/$STACK_VERSION/src
mkdir -p /mnt/nfs/nfsdlo/$STACK_NETWORK/$STACK_SERVICE/$STACK_VERSION/tmp
mkdir -p /mnt/nfs/nfsdlo/$STACK_NETWORK/$STACK_SERVICE/$STACK_VERSION/data
mkdir -p /mnt/nfs/nfsdlo/$STACK_NETWORK/$STACK_SERVICE/$STACK_VERSION/psqldata

# copy config files from stack to NFS
cp ./conf/* /mnt/nfs/nfsdlo/$STACK_NETWORK/$STACK_SERVICE/$STACK_VERSION/conf/

# write data MOODLE
git clone -b MOODLE_37_STABLE https://github.com/moodle/moodle.git /mnt/nfs/nfsdlo/$STACK_NETWORK/$STACK_SERVICE/$STACK_VERSION/html

# write data moodle modules
mkdir /mnt/nfs/nfsdlo/$STACK_NETWORK/$STACK_SERVICE/$STACK_VERSION/html/mod 
/mnt/nfs/nfsdlo/$STACK_NETWORK/$STACK_SERVICE/$STACK_VERSION/html/mod
wget https://moodle.org/plugins/download.php/20122/mod_hvp_moodle37_2019081600.zip -O /mnt/nfs/nfsdlo/$STACK_NETWORK/$STACK_SERVICE/$STACK_VERSION/html/mod/temp.zip
unzip /mnt/nfs/nfsdlo/$STACK_NETWORK/$STACK_SERVICE/$STACK_VERSION/html/mod/temp.zip
rm /mnt/nfs/nfsdlo/$STACK_NETWORK/$STACK_SERVICE/$STACK_VERSION/html/mod/temp.zip
chmod 755 /mnt/nfs/nfsdlo/$STACK_NETWORK/$STACK_SERVICE/$STACK_VERSION/html/mod/hvp


# go prep db
docker stack deploy --with-registry-auth -c docker-compose-initial.yml $STACK_SERVICE
sleep 200

# go sidecar for DB initialization
docker stack deploy --with-registry-auth -c docker-compose-sidecar.yml $STACK_SERVICE
sleep 200
