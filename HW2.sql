-- 1
SELECT USER AS "ID", TO_CHAR(SYSDATE, 'DAY, MONTH YYYY HH24:MI') AS "Date and Time"
FROM dual;
 

-- 2
SELECT DISTINCT 
    s1.st_id, s1.fname || ' ' || s1.lname FULLNAME1,
    s2.st_id, s2.fname || ' ' || s2.lname FULLNAME2,
    s1.name, s1.building || ' ' || s1.room AS "LOCATION"
FROM 
    (SELECT * FROM student
        NATURAL JOIN loan
        NATURAL JOIN computer
        JOIN location ON loc_id = location_id 
        NATURAL JOIN item
    WHERE UPPER(manuf) = 'APPLE') s1
JOIN
    (SELECT * FROM student
        NATURAL JOIN loan
        NATURAL JOIN computer
        JOIN location ON loc_id = location_id 
        NATURAL JOIN item
    WHERE UPPER(manuf) = 'APPLE') s2 
    ON (s1.comp_id = s2.comp_id AND s1.st_id > s2.st_id)
ORDER BY s1.st_id;

-- 3
SELECT comp_id, name, TO_CHAR(purchase_date, 'YYYY') as "Year", model, building || ' ' || room AS "LOCATION", NVL(to_char(MAX(end_date)), '~~~~~') as "Last Date"
FROM loan
    NATURAL JOIN computer
    NATURAL JOIN item
    JOIN location ON loc_id = location_id
WHERE ROUND(SYSDATE - end_date) > 45
    AND comp_id NOT IN (SELECT comp_id 
        FROM loan
        NATURAL JOIN computer
      WHERE end_date IS NULL)
GROUP BY comp_id, name, TO_CHAR(purchase_date, 'YYYY'), model, building || ' ' || room
UNION
SELECT comp_id, name, TO_CHAR(purchase_date, 'YYYY') as "Year", model, building || ' ' || room AS "LOCATION",  '~~~~~' as "Last Date"
FROM computer
NATURAL JOIN item
JOIN location ON loc_id = location_id
WHERE comp_id NOT IN (select comp_id from computer join loan using(comp_id));


select comp_id from computer minus ;


-- 4
SELECT NVL(manuf, 'Total') as "Manuf",
    COUNT(DISTINCT comp_id) as "Computer Count", 
    COUNT(loan_id) as "Loan Count", 
    NVL(to_char(MIN(start_date)), '~~~~~~~~') as "Last Date"
FROM computer
    NATURAL JOIN item
    NATURAL LEFT JOIN loan
GROUP BY GROUPING SETS  (manuf, ());


-- 5

SELECT comp_id, name, COUNT(loan_id) as "Times Used", ROUND( SYSDATE - MAX(end_date) ) as "Last Date"
FROM computer
    NATURAL LEFT JOIN loan
WHERE comp_id NOT IN(
    SELECT comp_id 
    FROM computer
    NATURAL JOIN loan
    WHERE end_date IS NULL
)
GROUP BY comp_id, name;


-- 6
SELECT 
    st_id, fname || ' ' || lname FULLNAME1,
    comp_id, name, start_date, end_date,
    ROUND(end_date - start_date) Duration
FROM computer
    NATURAL JOIN loan
    NATURAL JOIN student
WHERE end_date - start_date < 12;

-- 7 
SELECT st_id, fname || ' ' || lname LOANER,
    comp_id, name, NVL(TO_CHAR(MAX(start_date)), 'Available') as "Last Date"
FROM (SELECT *
      FROM loan
      WHERE end_date IS NULL
    )
    NATURAL JOIN student
    NATURAL RIGHT JOIN computer
    NATURAL JOIN item
    JOIN location ON loc_id = location_id
WHERE UPPER(building) = 'HBH'
GROUP BY st_id, fname || ' ' || lname, comp_id, name;

-- 8
-- Campus Store                      2
-- Apple Store                       3
-- Best Buy                          1
-- Amazon.com
SELECT vendor, name, COUNT(comp_id) AS "Computer Count"
FROM computer
    NATURAL JOIN item
WHERE UPPER(manuf) <> UPPER(vendor)
GROUP BY vendor, name
ORDER BY vendor;