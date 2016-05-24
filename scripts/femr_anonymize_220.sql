#Script to anonymize a 2.2.0 fEMR database

#patients
#Changes the values for first name, last name, address to an anonymous string.
#Changes the photo Id column to null.
#Changes the age date to keep the year but set month/date to 01/01.
SET @incrementalPatientNumber = 0;
UPDATE patients
SET first_name = concat("first_Anonmon", @incrementalPatientNumber := @incrementalPatientNumber + 1),
last_name = concat("last_Anonmon", @incrementalPatientNumber),
address = concat("address_Anonmon", @incrementalPatientNumber),
photo_id = NULL,
age = DATE_FORMAT(age, '%Y-01-01');

#patient_encounters
#Changes the triage visit date to keep the year and month but set day to 01.
#Changes the medical visit date to keep the year and month but set day to 01.
#Changes the pharmacy visit date to keep the year and month but set day to 01.
UPDATE patient_encounters
SET date_of_triage_visit = DATE_FORMAT(date_of_triage_visit, '%Y-%m-01'),
date_of_medical_visit = DATE_FORMAT(date_of_medical_visit, '%Y-%m-01'),
date_of_pharmacy_visit = DATE_FORMAT(date_of_pharmacy_visit, '%Y-%m-01');

#login_attempts
#Mask the ip_address logger
#Mask the text being used to attempt to sign in with
UPDATE login_attempts 
SET ip_address = '1111111111111111',
username_attempt = "attempt_Anonmon";

#users
#Change the values for first name and last name to an anonymous string.
#Change the password so none are valid any longer
#Set the notes field to null
SET @incrementalUserNumber = 0;
UPDATE users
SET first_name = concat("Anonmon", @incrementalUserNumber := @incrementalUserNumber + 1),
last_name = concat("Anonmon", @incrementalUserNumber),
`password` = "anon",
notes = NULL;




SET SQL_SAFE_UPDATES=0;