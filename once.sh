#!/bin/bash

# Run this script once to build secrets & configs

echo "Choose new database root password:"
read dbrootpwd
printf $dbrootpwd | docker secret create h5p_db_dba_password -
echo done...

echo done...

