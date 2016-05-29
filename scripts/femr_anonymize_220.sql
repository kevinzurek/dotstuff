##### Script to anonymize a 2.2.0 fEMR database #####

/* Note */
#primary key updates to patients and patient_encounters do not check if the primary key 
#already exists, but the ratio of generated values to records is so large that no issues 
#are encountered right now.

/* Anonymize patient table data */

###TABLE: patients
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


/* Anonymize patient_encounters table data */

###TABLE: patient_encounters
#Changes the triage visit date to keep the year and month but set day to 01.
#Changes the medical visit date to keep the year and month but set day to 01.
#Changes the pharmacy visit date to keep the year and month but set day to 01.
UPDATE patient_encounters
SET date_of_triage_visit = DATE_FORMAT(date_of_triage_visit, '%Y-%m-01'),
date_of_medical_visit = DATE_FORMAT(date_of_medical_visit, '%Y-%m-01'),
date_of_pharmacy_visit = DATE_FORMAT(date_of_pharmacy_visit, '%Y-%m-01');


/* Anonymize login_attempts table data */

###TABLE: login_attempts
#Mask the ip_address logger
#Mask the text being used to attempt to sign in with
UPDATE login_attempts 
SET ip_address = '1111111111111111',
username_attempt = "attempt_Anonmon";

/* Anonymize users table data */

###TABLE: users
#Change the values for first name and last name to an anonymous string.
#Change the password so none are valid any longer
#Set the notes field to null
SET @incrementalUserNumber = 0;
UPDATE users
SET first_name = concat("Anonmon", @incrementalUserNumber := @incrementalUserNumber + 1),
last_name = concat("Anonmon", @incrementalUserNumber),
`password` = "anon",
notes = NULL
WHERE email <> "admin" AND email <> "superuser";

###TABLE: users
#Set the password for admin and superuser accounts equal to the hashed equivalent of "Password1"
UPDATE users
SET `password` = "$2a$10$vQKZmTaPgHTxUwFMKZSfC.43AlGRoZhBhiL9dStu/Mc.M5NIBxH5q"
WHERE email = "admin" OR email = "superuser";


/* Anonymize patient primary keys */

###TABLE: patient_encounters
#Allow for a patient primary key Id change to cascade to patient_encounters table
ALTER TABLE `patient_encounters` 
DROP FOREIGN KEY `fk_patient_encounter_patient_id_patients_id`;

ALTER TABLE `patient_encounters`
ADD CONSTRAINT `fk_patient_encounter_patient_id_patients_id`
  FOREIGN KEY (`patient_id`)
  REFERENCES `patients` (`id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;

###TABLE: patients
#update id to equal a number between 1 and 1 minus the largest possible INT value
UPDATE patients
SET id = FLOOR( 1 + RAND( ) * 2147483646 );

###TABLE: patient_encounters
#Revert patient_encounters table cascade foreign key constraint
ALTER TABLE `patient_encounters` 
DROP FOREIGN KEY `fk_patient_encounter_patient_id_patients_id`;

ALTER TABLE `patient_encounters`
ADD CONSTRAINT `fk_patient_encounter_patient_id_patients_id`
  FOREIGN KEY (`patient_id`)
  REFERENCES `patients` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;


/* Anonymize patient_encounters primary keys */
  
###TABLE: patient_encounter_vitals
#Allow for the patient_encounter ID change to cascade to patient_encounter_vitals table
ALTER TABLE `patient_encounter_vitals` 
DROP FOREIGN KEY `fk_patient_encounter_vitals_patient_encounter_id`;

ALTER TABLE `patient_encounter_vitals` 
ADD CONSTRAINT `fk_patient_encounter_vitals_patient_encounter_id`
  FOREIGN KEY (`patient_encounter_id`)
  REFERENCES `patient_encounters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;

###TABLE: patient_prescriptions
#Allow for the patient_encounter ID change to cascade to patient_prescriptions table
ALTER TABLE `patient_prescriptions` 
DROP FOREIGN KEY `fk_patient_prescriptions_encounter_id_patient_encounters_id`;

ALTER TABLE `patient_prescriptions` 
ADD CONSTRAINT `fk_patient_prescriptions_encounter_id_patient_encounters_id`
  FOREIGN KEY (`encounter_id`)
  REFERENCES `patient_encounters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
###TABLE: patient_encounter_photos
#Allow for the patient_encounter ID change to cascade to patient_encounter_photos table
ALTER TABLE `patient_encounter_photos` 
DROP FOREIGN KEY `patient_encounter_photos_ibfk_1`;

ALTER TABLE `patient_encounter_photos` 
ADD CONSTRAINT `patient_encounter_photos_ibfk_1`
  FOREIGN KEY (`patient_encounter_id`)
  REFERENCES `patient_encounters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;

###TABLE: patient_encounters
#update id to equal a number between 1 and 1 minus the largest possible INT value
UPDATE patient_encounters
SET id = FLOOR( 1 + RAND( ) * 2147483646 );

###TABLE: patient_encounter_vitals
#Revert patient_encounter_vitals table cascade setting change
ALTER TABLE `patient_encounter_vitals` 
DROP FOREIGN KEY `fk_patient_encounter_vitals_patient_encounter_id`;

ALTER TABLE `patient_encounter_vitals` 
ADD CONSTRAINT `fk_patient_encounter_vitals_patient_encounter_id`
  FOREIGN KEY (`patient_encounter_id`)
  REFERENCES `patient_encounters` (`id`)
  ON UPDATE RESTRICT;

###TABLE: patient_prescriptions
#Revert patient_prescriptions table cascade setting change
ALTER TABLE `patient_prescriptions` 
DROP FOREIGN KEY `fk_patient_prescriptions_encounter_id_patient_encounters_id`;

ALTER TABLE `patient_prescriptions` 
ADD CONSTRAINT `fk_patient_prescriptions_encounter_id_patient_encounters_id`
  FOREIGN KEY (`encounter_id`)
  REFERENCES `patient_encounters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;
  
###TABLE: patient_encounter_photos
#Revert patient_encounter_photos table cascade setting change
ALTER TABLE `patient_encounter_photos` 
DROP FOREIGN KEY `patient_encounter_photos_ibfk_1`;

ALTER TABLE `patient_encounter_photos` 
ADD CONSTRAINT `patient_encounter_photos_ibfk_1`
  FOREIGN KEY (`patient_encounter_id`)
  REFERENCES `patient_encounters` (`id`)
  ON UPDATE RESTRICT;
