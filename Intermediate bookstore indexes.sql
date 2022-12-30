/* 
Codecademy - Design databases with Postgresql
Intermediate book store indexes project solutions
*/

--1.
SELECT * FROM customers
LIMIT 10;
SELECT * FROM orders
LIMIT 10;
SELECT * FROM books
LIMIT 10;

--2. Check indexes that exist
SELECT * FROM pg_indexes
WHERE tablename = 'customers';
SELECT * FROM pg_indexes
WHERE tablename = 'books';
SELECT * FROM pg_indexes
WHERE tablename = 'orders';

--3. Check time taken to execute query
EXPLAIN ANALYZE
SELECT customer_id, quantity
FROM orders
WHERE quantity > 18;

--4. Create an index on quantity greater than 18
CREATE INDEX orders_quantity_idx ON orders(quantity)
WHERE quantity > 18;

--5.
EXPLAIN ANALYZE
SELECT customer_id, quantity
FROM orders
WHERE quantity > 18;

--6. Create primary key 
EXPLAIN ANALYZE
SELECT * FROM customers
WHERE customer_id < 1000;

ALTER TABLE customers
ADD PRIMARY KEY (customer_id);

EXPLAIN ANALYZE
SELECT * FROM customers
WHERE customer_id < 1000;

--7. Cluster customers table using primary key
CLUSTER customers USING customers_pkey;
SELECT * FROM customers
LIMIT 10;

--8. Create multicolumn index
CREATE INDEX orders_customer_id_book_id_idx ON orders(customer_id, book_id);

--9. Create multicolumn index
DROP INDEX IF EXISTS orders_customer_id_book_id_idx;

CREATE INDEX orders_customer_id_book_id_quantity_idx ON orders(customer_id, book_id, quantity);

--10. Combining indexes for books 
CREATE INDEX books_author_title_idx ON books(author, title);

--11.
EXPLAIN ANALYZE
SELECT * FROM orders
WHERE (quantity * price_base) > 100;

--12.
CREATE INDEX total_price_idx ON orders((quantity*price_base));

EXPLAIN ANALYZE
SELECT * FROM orders
WHERE (quantity * price_base) > 100;

--14. Add or remove indexes to make the system more efficient
SELECT * FROM pg_Indexes
WHERE tablename IN ('customers', 'orders', 'books');

DROP INDEX books_author_idx;

CREATE INDEX customers_last_name_first_name ON customers(last_name,first_name);
CREATE INDEX orders_order_date_ship_date ON orders(order_date, ship_date);
