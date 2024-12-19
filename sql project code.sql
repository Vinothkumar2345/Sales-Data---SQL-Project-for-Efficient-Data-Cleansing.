create table order2 (`ROW ID`text,
`ORDER_ID`text,
`ORDER_DATE`text,
`SHIP_DATE`text,
`SHIP_MODE`text,
`CUSTOMER_ID`text,
`CUSTOMER_NAME`text,
`SEGMENT`text,
`COUNTRY`text,
`CITY`text,
`STATE`text,
`POSTAL_CODE`text,
`REGION`text,
`PRODUCT_ID`text,
`CATEGORY`text,
`SUB_CATEGORY`text,
`PRODUCT_NAME`text,
`SALES`text,
`QUANTITY`text,
`DISCOUNT`text,
`PROFIT`text);


--  Disable Safe Update Mode Temporarily
SET SQL_SAFE_UPDATES = 0;

--  Remove Duplicate Records
WITH duplicate_removal AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY ORDER_ID, PRODUCT_ID, CUSTOMER_ID ORDER BY ROW_ID) AS row_num
    FROM order2
)
DELETE FROM order2
WHERE ROW_ID IN (
    SELECT ROW_ID
    FROM duplicate_removal
    WHERE row_num > 1
);

--  Re-Enable Safe Update Mode
SET SQL_SAFE_UPDATES = 1;

--  Verify Remaining Data (Optional)
SELECT * FROM order2;

-- Disable safe update mode temporarily
SET SQL_SAFE_UPDATES = 0;

--  Handle NULL or Missing Values
UPDATE order2
SET POSTAL_CODE = '00000'
WHERE POSTAL_CODE IS NULL OR POSTAL_CODE = '';

UPDATE order2
SET DISCOUNT = 0
WHERE DISCOUNT IS NULL;

UPDATE order2
SET PROFIT = 0
WHERE PROFIT IS NULL;

-- Disable safe update mode temporarily
SET SQL_SAFE_UPDATES = 0;

-- Correct ORDER_DATE Format
UPDATE order2
SET ORDER_DATE = STR_TO_DATE(ORDER_DATE, '%Y-%m-%d')
WHERE ORDER_DATE IS NOT NULL;

-- Correct SHIP_DATE Format
UPDATE order2
SET SHIP_DATE = STR_TO_DATE(SHIP_DATE, '%Y-%m-%d')
WHERE SHIP_DATE IS NOT NULL;

--  Correct Data Types and Standardize Date Formats

-- Temporarily disable safe update mode to allow updates
SET SQL_SAFE_UPDATES = 0;

-- Update ORDER_DATE to standardize format
UPDATE orders
SET order_date = STR_TO_DATE(order_date, '%Y-%m-%d')
WHERE order_date IS NOT NULL;

-- Update SHIP_DATE to standardize format
UPDATE orders
SET ship_date = STR_TO_DATE(ship_date, '%Y-%m-%d')
WHERE ship_date IS NOT NULL;

SET SQL_SAFE_UPDATES = 1;

--  Validate Numerical Columns

-- Temporarily disable safe update mode to allow updates
SET SQL_SAFE_UPDATES = 0;

-- Ensure DISCOUNT values are between 0 and 1
UPDATE order2
SET discount = 0
WHERE discount < 0 OR discount > 1;

-- Correct negative SALES values
UPDATE order2
SET sales = ABS(sales)
WHERE sales < 0;

-- Ensure QUANTITY is at least 1
UPDATE order2
SET quantity = 1
WHERE quantity <= 0;

SET SQL_SAFE_UPDATES = 1;

--  Recalculate PROFIT where necessary

SET SQL_SAFE_UPDATES = 0;

-- Recalculate PROFIT if it's NULL or negative
UPDATE order2
SET profit = (sales - (sales * discount))
WHERE profit IS NULL OR profit < 0;

SET SQL_SAFE_UPDATES = 1;

--  Standardize Text Columns

SET SQL_SAFE_UPDATES = 0;

-- Standardize CUSTOMER_NAME
UPDATE order2
SET customer_name = TRIM(UPPER(customer_name));

-- Standardize CITY
UPDATE order2
SET city = TRIM(UPPER(city));

-- Standardize STATE
UPDATE order2
SET state = TRIM(UPPER(state));

-- Standardize PRODUCT_NAME
UPDATE order2
SET product_name = TRIM(product_name);

SET SQL_SAFE_UPDATES = 1;

--  Validate Ship Mode and Segment Values

SET SQL_SAFE_UPDATES = 0;

-- Ensure SHIP_MODE has a default value
UPDATE order2
SET ship_mode = 'Standard Class'
WHERE ship_mode IS NULL OR ship_mode = '';

-- Ensure SEGMENT has a default value
UPDATE order2
SET segment = 'Consumer'
WHERE segment IS NULL OR segment = '';

SET SQL_SAFE_UPDATES = 1;

--  Check Final Cleaned Data

-- Verify the number of rows in the cleaned data
SELECT count(*) AS cleaned_row_count FROM order2;



select* from order2








