#! /bin/bash

echo "Enter mysql username: "
read username
echo "Enter mysql password: "
read -s password
echo "Enter the name of the current SQL script: "
read -e script

#while ! mysql -u $username -p$password ; do
#	read -s -p "Try another password?: " password
#done	

mysql -u $username -p$password << TOKEN_FOR_ENDING_MYSQL_INPUT

DROP DATABASE IF EXISTS femr_temp;
CREATE DATABASE femr_temp;

TOKEN_FOR_ENDING_MYSQL_INPUT

mysql -u $username -p$password femr_temp < $script