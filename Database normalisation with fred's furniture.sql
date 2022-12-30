/*
Codecademy - Design databases with Postgresql
Database normalisation at Fred's furniture solutions
*/
-- Would move columns customer_id, customer_phone, customer_email, item_1_price, item_2_price,item_3_price to separate tables
SELECT * FROM store
LIMIT 10;

--2. Check if any customers made more than one order
SELECT COUNT(DISTINCT order_id)
FROM store;
SELECT COUNT(DISTINCT customer_id)
FROM store;

--3. 
SELECT customer_id, customer_email, customer_phone
FROM store
WHERE customer_id = 1;

--4.
SELECT item_1_id, item_1_name, item_1_price
FROM store
Where item_1_id = 4;

--5. Create customers table
CREATE TABLE customers AS
SELECT DISTINCT customer_id, customer_phone, customer_email
FROM store;

--6. Add primary key
ALTER TABLE customers
ADD PRIMARY KEY (customer_id);

--7. Create items table
CREATE TABLE items AS
SELECT DISTINCT item_1_id AS item_id, item_1_name AS item_name, item_1_price AS item_price
FROM store
UNION 
SELECT DISTINCT item_2_id AS item_id, item_2_name AS item_name, item_2_price AS item_price
FROM store
WHERE item_2_id IS NOT NULL
UNION 
SELECT DISTINCT item_3_id AS item_id, item_3_name AS item_name, item_3_price AS item_price
FROM store
WHERE item_3_id IS NOT NULL;

--8. Designate primary key
ALTER TABLE items
ADD PRIMARY KEY (item_id);

--9. Create orders_items table
CREATE TABLE orders_items AS
SELECT order_id, item_1_id AS item_id
FROM store
UNION
SELECT order_id, item_2_id AS item_id
FROM store
WHERE item_2_id IS NOT NULL
UNION
SELECT order_id, item_3_id AS item_id
FROM store
WHERE item_3_id IS NOT NULL;

--10. Create orders table
CREATE TABLE orders AS
SELECT order_id, order_date, customer_id
FROM store;

--11. Designate primary key
ALTER TABLE orders
ADD PRIMARY KEY (order_id);

--12. and 13. Designate foreign keys
ALTER TABLE orders
ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id);
ALTER TABLE orders_items
ADD FOREIGN KEY (item_id) REFERENCES items(item_id);
ALTER TABLE orders_items
ADD FOREIGN KEY (order_id) REFERENCES orders(order_id);

--14.
SELECT customer_email
FROM store
WHERE order_date > '2019-07-25';

--15.
SELECT customers.customer_email
FROM orders
JOIN customers
ON orders.customer_id = customers.customer_id
WHERE orders.order_date > '2019-07-25';

--16. Query store table
WITH all_orders AS (
  SELECT order_id, item_1_id AS item_id
  FROM store
  UNION ALL
  SELECT order_id, item_2_id AS item_id
  FROM store
  WHERE item_2_id IS NOT NULL
  UNION ALL
  SELECT order_id, item_3_id AS item_id
  FROM store
  WHERE item_3_id IS NOT NULL
)
SELECT item_id, COUNT(order_id)
FROM all_orders
GROUP BY item_id;

--17. Query normalised database
SELECT item_id, COUNT(*)
FROM orders_items
GROUP BY item_id;

--18. Customers having made more than one order
SELECT customer_email, COUNT(*)
FROM customers
JOIN orders
ON customers.customer_id = orders.customer_id
GROUP BY customer_email
HAVING COUNT(*) > 1;
