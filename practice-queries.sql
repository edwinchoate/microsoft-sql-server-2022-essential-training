-- Practice SQL Queries (from the sql-practice.com challenges)


-- String matching with wildcards
SELECT first_name
FROM patients
WHERE first_name LIKE 'C%';


-- Numerical ranges 
SELECT first_name, last_name
FROM patients 
WHERE weight BETWEEN 100 AND 120;


-- Basic UPDATE
UPDATE patients 
SET allergies = 'NKA'
WHERE allergies IS NULL;


-- Concatenate two columns 
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM patients;


-- Basic join
SELECT first_name, last_name, province_name
FROM patients
JOIN province_names
ON patients.province_id = province_names.province_id;


-- Basic aggregate function
SELECT first_name, last_name, MAX(height)
FROM patients;


-- Get year from date 
SELECT COUNT(*)
FROM patients
WHERE YEAR(birth_date) = 2010;


-- Check a list of values 
SELECT *
FROM patients
WHERE patient_id IN (1, 45, 534, 879, 1000);


-- Show unique values with no repeats 
SELECT DISTINCT city
FROM patients
WHERE province_id = 'NS';


-- Basic sort 
SELECT DISTINCT YEAR(birth_date) AS birth_year
FROM patients
ORDER BY birth_year ASC;


-- Basic aggregate grouping and filtering
SELECT first_name
FROM patients
GROUP BY first_name
HAVING COUNT(*) = 1;


-- Get length of a string 
SELECT first_name 
FROM patients 
WHERE LEN(first_name) >= 6;


-- Sorting multiple columns 
SELECT first_name
FROM patients
ORDER BY LEN(first_name), first_name;


-- Nested query using aggregate functions
SELECT (
	SELECT COUNT(*) 
  	FROM patients
  	WHERE gender = 'M'
) AS total_males, (
	SELECT COUNT(*) 
  	FROM patients
  	WHERE gender = 'F'
) AS total_females;


-- Using GROUP BY on more than one column
SELECT patient_id, diagnosis
FROM admissions
GROUP BY patient_id, diagnosis
HAVING COUNT(*) > 1;


-- Inserting hard-coded value on the fly 
SELECT first_name, last_name, 'Patient' AS role
FROM patients;


-- Combining together the rows from two SELECT statements with similar column structure 
SELECT first_name, last_name, 'Patient' AS role FROM patients
UNION ALL
SELECT first_name, last_name, 'Doctor' AS role FROM doctors;


-- Sum 
SELECT SUM(height) AS total_height
FROM patients;


-- Limit
SELECT * 
FROM admissions
LIMIT 1;


-- You can use LIKE on INT data too
SELECT *
FROM admissions
WHERE attending_doctor_id LIKE '%2%'; -- this id is an INT and this still works