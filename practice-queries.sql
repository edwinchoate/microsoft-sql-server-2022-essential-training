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
