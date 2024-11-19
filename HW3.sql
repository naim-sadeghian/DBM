SELECT USER AS "ID", TO_CHAR(SYSDATE, 'DAY, MONTH YYYY HH24:MI') AS "Date and Time"
FROM dual;


-- 2
SELECT * FROM (
    SELECT name, comp_id,
        ROW_NUMBER() OVER (ORDER BY purchase_date) Rank,
        purchase_date,
        COUNT(loan_id) LoanCount
    FROM computer
        NATURAL JOIN loan
    GROUP BY name, comp_id,  purchase_date
    ORDER BY 4, 5
)
WHERE rank <= 3;

-- 3
SELECT * FROM (
    SELECT name, comp_id,
    building || ' ' || room AS "LOCATION",
    ROUND(SUM(end_date - start_date)) TotalDays
    FROM computer
        NATURAL JOIN loan
        JOIN location ON loc_id = location_id 
    GROUP BY name, comp_id, building || ' ' || room
    ORDER BY 4 DESC
)
WHERE rownum <= 5 AND TotalDays IS NOT NULL
ORDER BY 3, 4;

-- 4
SELECT s.*, (LoanRank + TotalDayRank) "Rank Total"
FROM
(
    SELECT
        st_id, fname || ' ' || lname FULLNAME,
        COUNT(loan_id) Loans,
        RANK() OVER ( ORDER BY COUNT(loan_id) ) LoanRank,
        ROUND( SUM(end_date - start_date) ) TotalDays,
        RANK() OVER ( ORDER BY SUM(end_date - start_date) ) TotalDayRank
    FROM student
        NATURAL JOIN loan
    GROUP BY st_id, fname || ' ' || lname
) s
ORDER BY "Rank Total";

-- 5
SELECT s.*, (LoanRank + TotalDayRank) "Rank Total"
FROM
(
    SELECT
        st_id, fname || ' ' || lname FULLNAME,
        COUNT(loan_id) Loans,
        RANK() OVER ( ORDER BY COUNT(loan_id) ) LoanRank,
        ROUND( SUM(end_date - start_date) ) TotalDays,
        RANK() OVER ( ORDER BY SUM(end_date - start_date) ) TotalDayRank
    FROM student
        NATURAL LEFT JOIN loan
    WHERE end_date IS NOT NULL
    GROUP BY st_id, fname || ' ' || lname
) s
ORDER BY "Rank Total";