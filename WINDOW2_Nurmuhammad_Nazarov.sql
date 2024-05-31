CREATE TABLE sales (
    prod_subcategory VARCHAR(50),
    sale_amount DECIMAL,
    sale_date DATE
);

INSERT INTO sales (prod_subcategory, sale_amount, sale_date) VALUES
('subcategory1', 100.00, '1998-01-15'),
('subcategory1', 150.00, '1999-02-20'),
('subcategory1', 200.00, '2000-03-10'),
('subcategory1', 250.00, '2001-04-25'),
('subcategory2', 200.00, '1998-05-30'),
('subcategory2', 190.00, '1999-06-05'),
('subcategory2', 210.00, '2000-07-20'),
('subcategory2', 220.00, '2001-08-25');



-- Step 1: Calculating total sales per subcategory per year
WITH SubcategorySales AS (
    SELECT
        prod_subcategory,
        EXTRACT(YEAR FROM sale_date) AS sale_year,
        SUM(sale_amount) AS total_sales
    FROM
        sales
    WHERE
        EXTRACT(YEAR FROM sale_date) BETWEEN 1998 AND 2001
    GROUP BY
        prod_subcategory,
        EXTRACT(YEAR FROM sale_date)
),

-- Step 2: Using LAG to compare current year sales with the previous year
RankedSubcategories AS (
    SELECT
        prod_subcategory,
        sale_year,
        total_sales,
        LAG(total_sales) OVER (PARTITION BY prod_subcategory ORDER BY sale_year) AS previous_year_sales
    FROM
        SubcategorySales
),

-- Step 3: Identifying subcategories with consistently higher sales compared to the previous year
ConsistentGrowth AS (
    SELECT
        prod_subcategory,
        sale_year,
        total_sales,
        previous_year_sales
    FROM
        RankedSubcategories
    WHERE
        total_sales > previous_year_sales
)

-- Step 4: Selecting distinct subcategories
SELECT DISTINCT
    prod_subcategory
FROM
    ConsistentGrowth
WHERE
    sale_year BETWEEN 1999 AND 2001
ORDER BY
    prod_subcategory;


