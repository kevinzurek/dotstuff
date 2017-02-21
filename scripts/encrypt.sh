#!/bin/bash

#Script for encrypting folder with patient data backups inside

#Get the filename that holds the key for encryption
echo -e "Enter key filename: \c"
read -e key
#Get the name of the file after encryption is done
echo -e "Enter name of encrypted output file (include .dat extension):"
read outputFile
#Get the name of the folder to compress and encrypt
echo -e "Enter foldername to encrypt (will compress first): \c"
read -e inputFolder

#Take the target folder and compress it
`tar -zcf data.tar.gz $inputFolder`

#Take the compressed folder and encrypt it using the name provided above
`openssl enc -aes-256-cbc -pass file:$key < data.tar.gz > $outputFile`

#Optionally upload the folder to AWS S3
 echo -e "Would you like to upload to AWS? (y/n)"
read -e response

if [ $response = "n" ]; then
  echo "Backup not sent to AWS!"
elif [ $response = "y" ]; then
  aws s3 cp $outputFile s3://femr-backup
else
  echo "Invalid response"
fi

