SELECT * FROM blinkit
USE blinkit

UPDATE blinkit
SET Item_Fat_Content = 
    CASE 
        WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat'
        WHEN Item_Fat_Content = 'reg' THEN 'Regular'
        ELSE Item_Fat_Content
    END;

--A. KPI’s
--1. TOTAL SALES:
SELECT CAST(SUM(Total_Sales) / 1000000.0 
AS DECIMAL(10,2)) AS Total_Sales_Million
FROM blinkit;
 
--2. AVERAGE SALES
SELECT CAST(AVG(Total_Sales) AS INT) AS Avg_Sales
FROM blinkit;
 
--3. NO OF ITEMS
SELECT COUNT(*) AS No_of_Orders
FROM blinkit;
 
--4. AVG RATING
SELECT CAST(AVG(Rating) AS DECIMAL(10,1)) 
AS Avg_Rating
FROM blinkit;


--B. Total Sales by Fat Content:
SELECT Item_Fat_Content, CAST(SUM(Total_Sales) 
AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit
GROUP BY Item_Fat_Content


--C. Total Sales by Item Type
SELECT Item_Type, CAST(SUM(Total_Sales)
AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit
GROUP BY Item_Type
ORDER BY Total_Sales DESC


--D. Fat Content by Outlet for Total Sales
SELECT Outlet_Location_Type, 
       ISNULL([Low Fat], 0) AS Low_Fat, 
       ISNULL([Regular], 0) AS Regular
FROM 
(
    SELECT Outlet_Location_Type, Item_Fat_Content, 
           CAST(SUM(Total_Sales) 
           AS DECIMAL(10,2)) AS Total_Sales
    FROM blinkit
    GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT 
(
    SUM(Total_Sales) 
    FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;


--E. Total Sales by Outlet Establishment
SELECT Outlet_Establishment_Year, 
CAST(SUM(Total_Sales) 
AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year
 

--F. Percentage of Sales by Outlet Size
SELECT 
    Outlet_Size, 
    CAST(SUM(Total_Sales) 
    AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Total_Sales) * 100.0 / 
    SUM(SUM(Total_Sales)) OVER()) 
    AS DECIMAL(10,2)) AS Sales_Percentage
FROM blinkit
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;


--G. Sales by Outlet Location
SELECT Outlet_Location_Type, 
CAST(SUM(Total_Sales) 
AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC
 



--H.    
SELECT Outlet_Type, 
CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
		CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS Avg_Sales,
		COUNT(*) AS No_Of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating,
		CAST(AVG(Item_Visibility) AS DECIMAL(10,2)) AS Item_Visibility
FROM blinkit
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC
