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

