/*
Codecademy - design databases
Improving parts tracking solutions
*/

SELECT * FROM parts
LIMIT 10;

--2. Alter code column to be unique and not empty
ALTER TABLE parts
ALTER COLUMN code SET NOT NULL;
ALTER TABLE parts 
ADD UNIQUE (code);

--3. Fill is values for NULL values in description column
UPDATE parts
SET description = 'no description'
WHERE description IS NULL;

--4. Add constraint to description column
ALTER TABLE parts
ALTER COLUMN description SET NOT NULL;

--5. 
INSERT INTO parts (id, description, code, manufacturer_id)
VALUES (54, 'Full-color LED SMD modules', 'V1-009', 9);

--6. Alter columns to be not empty
ALTER TABLE reorder_options
ALTER COLUMN price_usd SET NOT NULL,
ALTER COLUMN quantity SET NOT NULL;

--7. Ensure price_usd and quantity columns are positive
ALTER TABLE reorder_options
ADD CHECK (price_usd > 0 AND quantity > 0);

--8. Add constraint to limit price per unit 
ALTER TABLE reorder_options
ADD CHECK (price_usd / quantity > 0.02 AND price_usd / quantity < 25);

--9. Ensure all parts in reorder_options column refer to parts in parts column
ALTER TABLE parts
ADD PRIMARY KEY (id);
ALTER TABLE reorder_options
ADD FOREIGN KEY (part_id) REFERENCES parts(id);

--10. Ensure qty column is more than 0
ALTER TABLE locations
ADD CHECK (qty > 0);

--11. ENsure combination of location and part records only one row
ALTER TABLE locations
ADD UNIQUE (part_id, location);

--12. Form a relationship between locations and parts
ALTER TABLE locations
ADD FOREIGN KEY (part_id) REFERENCES parts(id);

--13. Form a relationship between parts and manufacturers
ALTER TABLE parts
ADD FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(id);

--14. Test the constraint
INSERT INTO manufacturers
VALUES (11, 'Pip-NNC Industrial');

--15. 
UPDATE parts
SET manufacturer_id = 11
WHERE manufacturer_id IN (1,2);
