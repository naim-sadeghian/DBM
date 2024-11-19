-- 1 Pivot table with years as pivot
SELECT DECODE(country, NULL, 'Country Total:',country) Country,
    COUNT(DECODE(EXTRACT(year FROM orderdate), 2017, 1)) as "2017",
    COUNT(DECODE(EXTRACT(year FROM orderdate), 2018, 1)) as "2018",
    COUNT(DECODE(EXTRACT(year FROM orderdate), 2019, 1)) as "2019",
    COUNT(orderid) as "Country Total"
FROM orders
    JOIN customers USING(customerid)
GROUP BY ROLLUP (country);

-- Another way:

SELECT NVL(country, 'Country Total:') Country,
    SUM(DECODE(EXTRACT(year FROM orderdate), 2017, 1, 0)) as "2017",
    SUM(DECODE(EXTRACT(year FROM orderdate), 2018, 1, 0)) as "2018",
    SUM(DECODE(EXTRACT(year FROM orderdate), 2019, 1, 0)) as "2019",
    COUNT(orderid) as "Country Total"
FROM orders
    JOIN customers USING(customerid)
GROUP BY GROUPING SETS (country, ());

-- 2
SELECT DISTINCT firstname, lastname, productname
FROM orders
    JOIN employees USING(employeeid)
    JOIN orderdetails USING(orderid)
    JOIN products USING(productid)
WHERE productid IN
    (SELECT productid
    FROM orderdetails
    GROUP BY productid
    HAVING SUM(quantity) = 
        (SELECT MAX(SUM(quantity)) total
        FROM orderdetails
        GROUP BY productid)
    )
    AND TO_CHAR(orderdate, 'MM-YYYY') = '12-2017';


-- 3
SELECT companyname, city as "Customer City", shipcity as "Ship City", COUNT(orderid)
FROM customers
    JOIN orders USING(customerid)
WHERE UPPER(shipcity) IN 
    (SELECT DISTINCT UPPER(shipcity) FROM orders
    MINUS
    SELECT UPPER(city) FROM customers)
GROUP BY companyname, city, shipcity;


-- 4
SELECT DISTINCT customerid, companyname
FROM customers
    JOIN orders USING(customerid)
    JOIN employees USING(employeeid)
WHERE regionid IN 
    (SELECT regionid
    FROM orders 
        JOIN employees USING(employeeid)
    GROUP BY regionid
    HAVING COUNT(orderid) = 
        (SELECT MAX(COUNT(orderid)) 
        FROM orders
            JOIN employees USING(employeeid)
        GROUP BY regionid)
    );

-- Another answer where there can be ties
SELECT DISTINCT customerid, companyname
FROM customers
    JOIN orders USING(customerid)
    JOIN employees USING(employeeid)
WHERE regionid IN 
    (SELECT regionid FROM
        (SELECT regionid, count(*)
        FROM orders JOIN employees USING(employeeid)
        GROUP BY regionid
        ORDER BY 2));

-- 5 

SELECT EXTRACT(YEAR FROM orderdate) as "Year", 
    TO_CHAR( SUM(unitprice * quantity * (1-discount)) , '$999999.00')as "Revenue",
    COUNT(orderid) AS "Order Count",
    COUNT( DISTINCT(EXTRACT(MONTH FROM orderdate)) ) AS "Months"
FROM orderdetails
    JOIN orders USING(orderid)
GROUP BY EXTRACT(YEAR FROM orderdate);


-- 6
COLUMN employee format 'A50'
SELECT LEVEL, 
    LPAD(' ', 4*(LEVEL-1) ) || employeeid || ' - ' || firstname || ' ' || lastname || ' ' || title as employee,
    reportsto
FROM employees
START with employeeid = 2
CONNECT BY PRIOR employeeid =reportsto
ORDER SIBLINGS BY employeeid;

-- 7
SELECT rownum as b_mon
FROM dual CONNECT BY rownum <= 12;

-- Table connects with itself until we get 12 rowns 
SELECT to_char(to_date(b_mon, 'MM'), 'MONTH') as Months,
    NVL(noorders, 0) as noorders
FROM (
    select extract(month from orderdate) as a_mon,
        count(orderid) noorders
    FROM orders
    WHERE extract(year from orderdate) = 2018
    GROUP BY extract(month from orderdate))
RIGHT JOIN (
    SELECT rownum as b_mon
    FROM dual CONNECT BY rownum <= 12
) ON a_mon = b_mon
ORDER BY b_mon;

