-- 1. List the names of the shippers that shipped orders to London for orders
-- created in March, 2018.
SELECT DISTINCT companyname 
FROM orders JOIN shippers ON (shipvia = shipperid)
WHERE orderdate LIKE '%-MAR-18' AND LOWER(shipcity) LIKE 'london';
------------- or
SELECT DISTINCT companyname 
FROM orders JOIN shippers ON (shipvia = shipperid)
WHERE to_char(orderdate, 'MM-YYYY') = '03-2018' AND LOWER(shipcity) = 'london';

-- 2. List the number of products in each product category. As a last row,
-- add the total number of products.
SELECT categoryname, count(productid)
FROM products JOIN categories USING (categoryid)
GROUP BY categoryname
UNION
SELECT 'ZTotal Products' as categoryname, count(*) as count
FROM products;




-- 3. List customers that have ordered less than six unique products. Order
-- results from lowest to highest number of products.
SELECT companyname, count(DISTINCT productID) TOTAL
FROM orders JOIN customers USING (customerid)
            JOIN orderdetails USING(orderid)
GROUP BY companyname
HAVING count(DISTINCT productID) < 6
ORDER BY TOTAL;

-- 4. List orders with an individual product having value higher than 10,000.
-- List the order id and the value.
SELECT orderid, to_char(quantity * unitprice * (1-discount), '$99999.00') as Total
FROM orderdetails 
WHERE (quantity * unitprice * (1-discount)) >= 10000;


-- 5. Provide the total amount of sales in 2018 by each region.
SELECT rdescription, to_char(sum(unitprice*quantity*(1-discount)) , '$99999999.00')
FROM orders
    JOIN orderdetails using (orderid)
    JOIN employees USING(employeeid)
    JOIN region USING(regionid)
WHERE  extract(year FROM orderdate) = 2018
GROUP BY rdescription;

-- 6. For each shipper, list the total number of customers from the UK who placed
-- orders, the total number of orders placed from those customers, and the total
-- number of products ordered.
SELECT s.companyname,
    count(DISTINCT customerid) as "Customer Total",
    count(DISTINCT orderid) as "Order Totals", 
    count(DISTINCT productid) as "Product Total"
FROM shippers s 
    JOIN orders ON (shipvia = s.shipperid)
    JOIN customers USING (customerid)
    JOIN orderdetails using (orderid)
WHERE UPPER(country) = 'UK'
GROUP BY s.companyname;



-- 7. List suppliers that supplied at least 4 different products. Order results from
-- highest to lowest “number of products.”
SELECT supplierid, companyname, count(DISTINCT productid)
FROM suppliers
    JOIN products using(supplierid)
GROUP BY supplierid, companyname
HAVING count(productid) >= 4
Order BY count(productid) desc;

-- 8. For orders shipped in 2018, list the customer company names for customers
-- who used Federal Shipping, but have never used United Package.
SELECT customers.companyname
FROM orders 
    JOIN customers using (customerid)
    JOIN shippers on (shipvia = shipperid)
WHERE initcap(shippers.companyname) = 'Federal Shipping'
    AND extract(year from shippeddate) = 2018
MINUS
SELECT customers.companyname
FROM orders 
    JOIN customers using (customerid)
    JOIN shippers on (shipvia = shipperid)
WHERE initcap(shippers.companyname) = 'United Package'
    AND shippeddate IS NOT NULL;
