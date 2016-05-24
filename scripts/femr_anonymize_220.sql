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

#Allow for the patient ID change to cascade to patient_encounters table
ALTER TABLE `patient_encounters` 
DROP FOREIGN KEY `fk_patient_encounter_patient_id_patients_id`;
ALTER TABLE `patient_encounters` 
ADD CONSTRAINT `fk_patient_encounter_patient_id_patients_id`
  FOREIGN KEY (`patient_id`)
  REFERENCES `patients` (`id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
#Change patient IDs
#TBD


#Revert patient_encounter table cascade setting change
ALTER TABLE `patient_encounters` 
DROP FOREIGN KEY `fk_patient_encounter_patient_id_patients_id`;
ALTER TABLE `patient_encounters` 
ADD CONSTRAINT `fk_patient_encounter_patient_id_patients_id`
  FOREIGN KEY (`patient_id`)
  REFERENCES `patients` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;
  
  
  
  
  
  
  
  
#Allow for the patient_encounter ID change to cascade to patient_encounter_vitals table
ALTER TABLE `patient_encounter_vitals` 
DROP FOREIGN KEY `fk_patient_encounter_vitals_patient_encounter_id`;
ALTER TABLE `patient_encounter_vitals` 
ADD CONSTRAINT `fk_patient_encounter_vitals_patient_encounter_id`
  FOREIGN KEY (`patient_encounter_id`)
  REFERENCES `patient_encounters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;

#Allow for the patient_encounter ID change to cascade to patient_prescriptions table
ALTER TABLE `patient_prescriptions` 
DROP FOREIGN KEY `fk_patient_prescriptions_encounter_id_patient_encounters_id`;
ALTER TABLE `patient_prescriptions` 
ADD CONSTRAINT `fk_patient_prescriptions_encounter_id_patient_encounters_id`
  FOREIGN KEY (`encounter_id`)
  REFERENCES `patient_encounters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
#Allow for the patient_encounter ID change to cascade to patient_encounter_photos table
ALTER TABLE `patient_encounter_photos` 
DROP FOREIGN KEY `patient_encounter_photos_ibfk_1`;
ALTER TABLE `patient_encounter_photos` 
ADD CONSTRAINT `patient_encounter_photos_ibfk_1`
  FOREIGN KEY (`patient_encounter_id`)
  REFERENCES `patient_encounters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;


#Change patient encounter IDs
#TBD




#Revert patient_encounter_vitals table cascade setting change
ALTER TABLE `patient_encounter_vitals` 
DROP FOREIGN KEY `fk_patient_encounter_vitals_patient_encounter_id`;
ALTER TABLE `patient_encounter_vitals` 
ADD CONSTRAINT `fk_patient_encounter_vitals_patient_encounter_id`
  FOREIGN KEY (`patient_encounter_id`)
  REFERENCES `patient_encounters` (`id`)
  ON UPDATE RESTRICT;

#Revert patient_prescriptions table cascade setting change
ALTER TABLE `patient_prescriptions` 
DROP FOREIGN KEY `fk_patient_prescriptions_encounter_id_patient_encounters_id`;
ALTER TABLE `patient_prescriptions` 
ADD CONSTRAINT `fk_patient_prescriptions_encounter_id_patient_encounters_id`
  FOREIGN KEY (`encounter_id`)
  REFERENCES `patient_encounters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;
  
#Revert patient_encounter_photos table cascade setting change
ALTER TABLE `patient_encounter_photos` 
DROP FOREIGN KEY `patient_encounter_photos_ibfk_1`;
ALTER TABLE `patient_encounter_photos` 
ADD CONSTRAINT `patient_encounter_photos_ibfk_1`
  FOREIGN KEY (`patient_encounter_id`)
  REFERENCES `patient_encounters` (`id`)
  ON UPDATE RESTRICT;
