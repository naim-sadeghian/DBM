-- 1
SELECT productname, categoryname, companyname
FROM products NATURAL JOIN categories NATURAL JOIN suppliers
WHERE unitprice > 100;

-- 2
SELECT DISTINCT e1.employeeid, e1.title
FROM employees e1 JOIN employees e2 ON e1.employeeid = e2.reportsto;

-- 3 
SELECT companyname, contacttitle, city, country
FROM customers
WHERE country IN ('Germany', 'Spain', 'Brazil') AND contacttitle LIKE '%Sales%';

-- 4
SELECT distinct productname
FROM orders NATURAL JOIN orderdetails NATURAL JOIN products NATURAL JOIN categories
WHERE categoryname = 'Beverages'
MINUS
SELECT distinct productname
FROM orders NATURAL JOIN orderdetails NATURAL JOIN products NATURAL JOIN categories
WHERE categoryname = 'Beverages' AND orderdate LIKE '%-MAY-19';

-- 6
SELECT 'CUSTOMER' as type, customerid || ' ' || companyname as company, phone
FROM customers
UNION
SELECT 'SUPPLIEAR' as type, supplierid || ' ' || companyname as company, phone
FROM suppliers
UNION
SELECT 'SHIPPER' as type, shipperid || ' ' || companyname as company, phone
FROM shippers;