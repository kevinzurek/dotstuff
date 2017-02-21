#!/bin/bash

#Script for decrypting patient data

echo -e "Enter key filename: \c"
read -e key
echo -e "Enter encrypted filename: \c"
read -e inputFile

`openssl enc -aes-256-cbc -d -pass file:$key < $inputFile > ./data.tar.gz`

