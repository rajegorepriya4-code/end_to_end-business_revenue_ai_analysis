-- which city earn the most
SELECT c.City, SUM(s.Revenue) AS Total_Revenue
FROM Customers c
INNER JOIN Sales s ON c.Customer_ID = s.Customer_ID
WHERE s.Order_Status = 'Completed'
GROUP BY c.City
ORDER BY Total_Revenue DESC;
-- loss analysis how much money is the company losing due to cancelled order diff product catageory
SELECT Category, COUNT(Order_ID) AS Cancelled_Orders, SUM(Revenue) AS Lost_Revenue
FROM Sales
WHERE Order_Status = 'Cancelled'
GROUP BY Category;
-- top  3 customer use limit
 SELECT c.Customer_Name, c.City, SUM(s.Revenue) AS Total_Spent
FROM Customers c
JOIN Sales s ON c.Customer_ID = s.Customer_ID
WHERE s.Order_Status = 'Completed'
GROUP BY c.Customer_Name, c.City
ORDER BY Total_Spent DESC
LIMIT 3;
-- customer segment  (case when)
-- how can we catageory our customer into tiers based on their total spending so the marketing team knows who to prioritize
SELECT c.Customer_Name, SUM(s.Revenue) AS Total_Spent,
CASE 
    WHEN SUM(s.Revenue) >= 40000 THEN 'VIP Tier'
    WHEN SUM(s.Revenue) >= 15000 THEN 'Regular Tier'
    ELSE 'Basic Tier'
END AS Customer_Segment
FROM Customers c
JOIN Sales s ON c.Customer_ID = s.Customer_ID
WHERE s.Order_Status = 'Completed'
GROUP BY c.Customer_Name;
-- top customer in each city
WITH CityCustomerSpending AS (
    SELECT 
        c.City,
        c.Customer_Name,
        SUM(s.Revenue) AS Total_Spent,
        RANK() OVER(PARTITION BY c.City ORDER BY SUM(s.Revenue) DESC) AS City_Rank
    FROM Customers c
    JOIN Sales s ON c.Customer_ID = s.Customer_ID
    WHERE s.Order_Status = 'Completed'
    GROUP BY c.City, c.Customer_Name
)
SELECT * FROM CityCustomerSpending
WHERE City_Rank = 1;

-- catagory cancellation rate percentage

SELECT 
    Category,
    COUNT(Order_ID) AS Total_Orders,
    SUM(CASE WHEN Order_Status = 'Cancelled' THEN 1 ELSE 0 END) AS Cancelled_Count,
    ROUND((SUM(CASE WHEN Order_Status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0) / COUNT(Order_ID), 2) AS Cancellation_Rate_Pct
FROM Sales
GROUP BY Category;
-- automated reporting 
-- 1. Create a View for Management Reporting
CREATE VIEW Executive_Sales_Summary AS
SELECT c.City, s.Category, COUNT(s.Order_ID) AS Total_Orders, SUM(s.Revenue) AS Net_Revenue
FROM Customers c
JOIN Sales s ON c.Customer_ID = s.Customer_ID
WHERE s.Order_Status = 'Completed'
GROUP BY c.City, s.Category;

-- Run the View:
SELECT * FROM Executive_Sales_Summary;

-- 2. Create a Stored Procedure for On-Demand City Reports
DELIMITER //
CREATE PROCEDURE GetCityPerformance(IN target_city VARCHAR(50))
BEGIN
    SELECT c.Customer_Name, s.Category, s.Revenue, s.Order_Status
    FROM Customers c
    JOIN Sales s ON c.Customer_ID = s.Customer_ID
    WHERE c.City = target_city;
END //
DELIMITER ;

-- Execute the Stored Procedure:
CALL GetCityPerformance('Pune');
-- month over month growth
WITH MonthlySales AS (
    SELECT 
        DATE_FORMAT(Order_Date, '%Y-%m') AS Order_Month,
        SUM(Revenue) AS Monthly_Revenue
    FROM Sales
    WHERE Order_Status = 'Completed'
    GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
)
SELECT 
    Order_Month,
    Monthly_Revenue,
    LAG(Monthly_Revenue) OVER (ORDER BY Order_Month) AS Previous_Month_Revenue,
    ROUND(((Monthly_Revenue - LAG(Monthly_Revenue) OVER (ORDER BY Order_Month)) / 
           LAG(Monthly_Revenue) OVER (ORDER BY Order_Month)) * 100, 2) AS MoM_Growth_Pct
FROM MonthlySales;