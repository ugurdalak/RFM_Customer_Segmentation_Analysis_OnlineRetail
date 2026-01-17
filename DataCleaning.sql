-- Data Check
	SELECT
	*
FROM
	online_retail t;
-- unit_price is VARCHAR and the separator is comma. now it will be converted to dot.
	UPDATE
	online_retail
SET
	unit_price = REPLACE(unit_price, ',', '.');

ALTER TABLE online_retail 
ALTER COLUMN unit_price TYPE NUMERIC
USING unit_price::NUMERIC;
-- Find rows where ANY column is blank
SELECT
	SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS cust_id_nulls,
	SUM(CASE WHEN description IS NULL THEN 1 ELSE 0 END) AS desc_nulls,
	SUM(CASE WHEN invoice_no IS NULL THEN 1 ELSE 0 END) AS inv_no_nulls,
	SUM(CASE WHEN invoice_date IS NULL THEN 1 ELSE 0 END) AS inv_date_nulls,
	SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_nulls,
	SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS qt_nulls,
	SUM(CASE WHEN unit_price IS NULL THEN 1 ELSE 0 END) AS uprice_nulls,
	SUM(CASE WHEN stock_code IS NULL THEN 1 ELSE 0 END) AS stcode_nulls
FROM
	online_retail;
-- there are 135,080 transactions which we are not able to identify customer_ids.
SELECT
	customer_id IS NULL AS is_null,
	COUNT(*) AS transactions,
	SUM(quantity * unit_price) AS total_revenue,
	ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_transactions,
	ROUND(100.0 * SUM(quantity * unit_price::NUMERIC) / SUM(SUM(quantity * unit_price::NUMERIC)) OVER (), 1) AS pct_revenue
FROM
	online_retail
GROUP BY
	customer_id IS NULL;
-- these transactions are 25% of the transaction volume and 15% of the total revenue. 
-- so it is significant amount of the data which we can not delete them. but we can keep these blank values as guests. 
UPDATE
	online_retail
SET
	customer_id = 'Guest'
WHERE
	customer_id IS NULL;
-- Check cancelled invoices that a identifier as C in invoice_no column
SELECT COUNT(DISTINCT invoice_no)
FROM online_retail
WHERE invoice_no LIKE 'C%';
-- There are 9.2 k rows for the invoices that were cancelled
-- Add a column that shows the cancellation status for any invoice

ALTER TABLE online_retail
ADD COLUMN invoice_cancelled boolean;

UPDATE online_retail
SET invoice_cancelled  = TRUE WHERE invoice_no LIKE 'C%';

UPDATE online_retail
SET invoice_cancelled  = FALSE WHERE invoice_no NOT LIKE 'C%';

--Check other dependencies like damage, check, missing or wrong codes or blanks, etc.
SELECT invoice_no,description, quantity, unit_price
FROM online_retail
WHERE invoice_cancelled IS FALSE AND quantity < 0;
-- All these rows' unit_price value is 0.
ALTER TABLE online_retail
ADD COLUMN unit_price_0 boolean;

UPDATE online_retail
SET unit_price_0 = TRUE WHERE unit_price = 0;

UPDATE online_retail
SET unit_price_0 = FALSE WHERE unit_price <> 0;
-- description check by using stock code
SELECT description, COUNT(description) AS count_desc
FROM online_retail 
WHERE stock_code ~ '^[A-Za-z]+$'
GROUP BY description;
--AMAZON FEE -- should be excluded
--Adjust bad debt -- should be excluded
--BOYS PARTY BAG 
--CRUK Commission -- should be excluded
--DOTCOM POSTAGE -- should be excluded
--Discount -- should be excluded
--GIRLS PARTY BAG
--Manual -- should be excluded
--PADS TO MATCH ALL CUSHIONS
--POSTAGE -- should be excluded
--SAMPLES-- should be excluded

--BOYS PARTY BAG, GIRLS PARTY BAG AND CUSHION PAD should be included in data since these are real products. 
--The other ones should be excluded since these are all price adjustments
--Creating a new column that shows if the transaction is a price adjustment or not.
ALTER TABLE online_retail
ADD COLUMN is_adjustment boolean;
UPDATE online_retail
SET is_adjustment = 
    CASE
        WHEN description ILIKE ANY (
            ARRAY[
                '%AMAZON FEE%', 
                '%Adjust bad debt%', 
                '%CRUK Commission%', 
                '%DOTCOM POSTAGE%', 
                '%Discount%', 
                '%Manual%', 
                '%POSTAGE%', 
                '%SAMPLES%'
            ]
        ) THEN TRUE
        ELSE FALSE
    END;

-- create an invoice_hour column to put HH24:MI information in it.
ALTER TABLE online_retail
ADD COLUMN invoice_hour VARCHAR(5);

UPDATE online_retail
SET invoice_hour= TO_CHAR(invoice_date, 'HH24:MI');

-- update invoice_date column as only date column

ALTER TABLE online_retail
ALTER COLUMN invoice_date
SET DATA TYPE DATE
USING (invoice_date::timestamp)::date;

-- Data Check
SELECT *
FROM online_retail;

