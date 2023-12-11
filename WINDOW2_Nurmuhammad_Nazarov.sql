CREATE INDEX salesdata_idx_prodsubcategory ON "SalesData" ("ProdSubcategory");
WITH AnnualSales AS (
    SELECT 
        ProdSubcategory, 
        Year, 
        SUM(SalesAmount) AS TotalSales
    FROM SalesData
    WHERE Year BETWEEN 1997 AND 2001
    GROUP BY ProdSubcategory, Year
),
YearOverYearGrowth AS (
    SELECT 
        ProdSubcategory, 
        Year, 
        TotalSales,
        LAG(TotalSales) OVER (PARTITION BY ProdSubcategory ORDER BY Year) AS PreviousYearSales
    FROM AnnualSales
)
SELECT DISTINCT 
    ProdSubcategory
FROM YearOverYearGrowth
WHERE Year BETWEEN 1998 AND 2001
AND TotalSales > PreviousYearSales
GROUP BY ProdSubcategory
HAVING COUNT(*) = 4;
