/* Use to list sorted table sizes in MySQL database */
-- Remove WHERE clause to hit all databases
-- Change WHERE clause to the database you want to hit

SELECT 
     table_schema as `Database`, 
     table_name AS `Table`, 
     round(((data_length + index_length) / 1024 / 1024 ), 5) `Size in MB` 
FROM information_schema.TABLES 
-- WHERE table_schema = 'test'
WHERE table_schema = 'e1_1h1_8'
AND table_name = 'photos'
ORDER BY (data_length + index_length) DESC;
