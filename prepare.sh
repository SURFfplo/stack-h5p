#!/bin/bash

# create nfs mount
mkdir -p /mnt/nfs/nfsdlo/$STACK_NETWORK/$STACK_SERVICE/$STACK_VERSION/data

# remove any old secrest and configs
if [[ $(docker secret ls -f name=h5p -q) ]]; then
    docker secret rm $(docker secret ls -f name=h5P -q)
else
    echo "no files found"
fi


# create secrets for database
# alternative date |md5sum|awk '{print $1}' | docker secret create my_secret -
date |md5sum|awk '{print $1}' | docker secret create h5p_db_dba_password -
date |md5sum|awk '{print $1}' | docker secret create h5p_password -

