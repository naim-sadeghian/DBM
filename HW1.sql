
/*-----------------------------------------*/
INSERT INTO item values ('26', 'Asus', 'ROG', 'Gaming Laptop: Intel i9, nvidia gtx 1080, 16 GB RAM, 16 inch display');
INSERT INTO item values ('27', 'HP', 'OMEN', 'Gaming Laptop: Intel i7, nvidia rtx 4090, 32 GB RAM, 22 inch display');

/*
For computers that cost more than $1500, list their ID, name, date when they were purchased,
purchase price, and manufacturer’s name.
*/
SELECT comp_id, name, purchase_date, price, manuf
FROM computer NATURAL JOIN item
WHERE price > 1500;

/*
2. List the ID and name of every doctoral student (concatenate the ID, last name, and first name) who
started a computer loan in second half of 2024. Include only computers purchased in 2023. Order
the list by student’s last name.
*/
SELECT st_id || ' ' || fname || ' ' || lname as "STUDENT INFO"
FROM student NATURAL JOIN loan NATURAL JOIN computer
WHERE start_date BETWEEN '01-JUL-24' and '31-DEC-24' and purchase_date like '__-___-23'
ORDER BY lname;


/*
3. For each computer that has never been used, provide the computer ID, computer name, manufacturer,
model, and the purchase date.
*/
SELECT comp_id, name, manuf, model, purchase_date
FROM computer NATURAL JOIN item
MINUS
SELECT DISTINCT comp_id, name, manuf, model, purchase_date
FROM computer NATURAL JOIN item NATURAL JOIN loan;

/*
4. List the name and model computers that were on loan within 2023 (borrowed and returned within
2023). Include the location of those computers.
*/
SELECT DISTINCT name, model, building || ' ' || room as "LOCATION"
FROM computer 
    JOIN location ON loc_id = location_id 
    JOIN item USING(item_id) 
    JOIN loan USING(comp_id)
WHERE start_date LIKE '__-___-23' AND end_date LIKE '__-___-23';

/*
5. Create a list of students who have never borrowed any computers. List student ID, name, and email
concatenated together into one string. Sort the list by student last name.
*/
SELECT lname || ' ' || fname || ' ' || st_id || ' ' || email AS "STUDENT INFO"
FROM student
MINUS
SELECT lname || ' ' || fname || ' ' || st_id || ' ' || email AS "STUDENT INFO2"
FROM student NATURAL JOIN loan 
ORDER BY "STUDENT INFO";


/* 6. List students (their IDs and names concatenated together) who currently have a computer on loan
that was initiated/started in August 2024. Also, provide the student’s program name, the loan ID, and
start date of the loan. Sort the list by student’s last name.*/
SELECT st_id || ' ' || fname || ' ' || lname as "STUDENT INFO", name, loan_id, start_date
FROM student NATURAL JOIN loan JOIN program ON program_code = prog_id
WHERE start_date LIKE '__-AUG-24' AND end_date IS NULL
ORDER BY lname;

/*7. List the ID and name of every doctoral student who have had loan in the past (but does not have any
loan currently). Also, provide the student’s program name.*/
SELECT DISTINCT St_ID, fname || ' ' || lname FULLNAME, name
FROM student JOIN program ON program_code = prog_id NATURAL JOIN loan
WHERE End_Date IS NOT NULL
MINUS
SELECT St_ID, fname || ' ' || lname FULLNAME, name
FROM student JOIN program ON program_code = prog_id NATURAL JOIN loan
WHERE End_Date IS NULL;

/*8. List ID and name of the computers that were on loan in 2023 but not in 2024. Also, include model
and manufacturer of those computers.*/

SELECT DISTINCT comp_id, name, model, manuf
FROM computer
    NATURAL JOIN item
    NATURAL JOIN loan
WHERE start_date LIKE '__-___-23' OR end_date LIKE '__-___-23'
MINUS
SELECT comp_id, name, model, manuf
FROM computer
    NATURAL JOIN item    
    NATURAL JOIN loan
WHERE start_date LIKE '__-___-24' OR end_date LIKE '__-___-24' OR end_date IS NULL;

