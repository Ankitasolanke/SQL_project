create database paytm_project;
use paytm_project;
-- What does the "Category_Grouped" column represent, and how many unique categories are there?
select distinct Category_Grouped 
from paytm_epurchase_data 
where Category_Grouped IS NOT NULL;

-- List the top 5 shipping cities in terms of the number of orders.
SELECT Shipping_city, COUNT(*) AS order_count
FROM paytm_epurchase_data
GROUP BY Shipping_city
ORDER BY order_count DESC
LIMIT 5;

-- Show me a table with all the data for products that belong to the "Electronics" category. 
-- IN OUR DATA SET THERE IS NO SUCH CATEGORY CALLED ELECTRONICS SO WE CAN REPLACE 
-- IT WITH WATCHES AS IT REFER TO ELECTRONICS
SELECT * 
FROM PAYTM_EPURCHASE_DATA  
WHERE CATEGORY="WATCHES";

-- 4. Filter the data to show only rows with a "Sale_Flag" of 'Yes'.
SELECT * 
FROM PAYTM_EPURCHASE_DATA 
WHERE SALE_FLAG='ON SALE';

-- 5. Sort the data by "Item_Price" in descending order. What is the most expensive item?
SELECT *, ITEM_PRICE AS Most_Expensive_ITEM 
FROM PAYTM_EPURCHASE_DATA 
ORDER BY ITEM_PRICE DESC; 
-- LIMIT 1;

-- 6. Apply conditional formatting to highlight all products with a "Special_Price_effective" value below $50 in red.
-- 50USD×75INR/USD=3750INR
SELECT * 
FROM PAYTM_EPURCHASE_DATA
WHERE SPECIAL_PRICE_EFFECTIVE <3750;
/* AS WE CANNOT DO CONDITIONAL FORMATTING IN SQL Conditional formatting is typically applied in presentation software
 like Excel rather than directly in SQL queries. However, if We're retrieving the data and want to visually represent 
 it with conditional formatting afterward,we can do it in our application or reporting tool.*/
SELECT *,
       CASE WHEN Special_Price_effective < 3750 THEN 'Red'
            ELSE 'Normal'
       END AS Formatting
FROM PAYTM_EPURCHASE_DATA;
-- 7. Create a pivot table to find the total sales value for each category.
SELECT Category, SUM(Item_Price) AS Total_Sales_Value
FROM PAYTM_EPURCHASE_DATA
GROUP BY Category
ORDER BY TOTAL_SALES_VALUE DESC;

-- 8. Create a bar chart to visualize the total sales for each category.
SELECT Category, SUM(Item_Price) AS Total_Sales_Value
FROM PAYTM_EPURCHASE_DATA
GROUP BY Category;
-- THEN WE CAN USE EXCEL TO REPRESENT BAR CHART

-- 9. Calculate the average "Quantity" sold for products in the "Clothing" category, grouped by "Product_Gender."
SELECT PRODUCT_GENDER, AVG(QUANTITY)
FROM PAYTM_EPURCHASE_DATA
WHERE CATEGORY_GROUPED='APPARELS'
GROUP BY PRODUCT_GENDER;
-- AS THERE IS NO CATEGORY LIKE CLOTHING IN THIS TABLE IT IS SHOWING EMPTY BUT IT HAS CATEGORY_GROUPED AS APPARELS

-- 10. Find the top 5 products with the highest "Value_CM1" and "Value_CM2" ratios. Create a chart to visualize this data. 
SELECT DISTINCT ITEM_NM,VALUE_CM1,VALUE_CM2,VALUE_CM1/VALUE_CM2 AS CM_RATIO
FROM PAYTM_EPURCHASE_DATA
ORDER BY CM_RATIO DESC 
LIMIT 5;

-- 11. Identify the top 3 "Class" categories with the highest total sales. 
-- Create a stacked bar chart to represent this data.
SELECT CLASS,SUM(ITEM_PRICE) AS HIGHEST_TOTAL_SALES
FROM PAYTM_EPURCHASE_DATA
GROUP BY CLASS
ORDER  BY HIGHEST_TOTAL_SALES DESC
LIMIT 3;
-- ORR WE CAN GET THIS  WITHOUT CLASS NULL VALUES
SELECT CLASS,SUM(ITEM_PRICE) AS HIGHEST_TOTAL_SALES
FROM PAYTM_EPURCHASE_DATA
WHERE CLASS IS NOT NULL
GROUP BY CLASS
ORDER  BY HIGHEST_TOTAL_SALES DESC
LIMIT 3;
-- 12. Find the total sales for each "Brand" and display the top 3 brands in terms of sales.

SELECT BRAND,SUM(ITEM_PRICE) AS TOTAL_SALES
FROM PAYTM_EPURCHASE_DATA
GROUP BY BRAND
ORDER  BY TOTAL_SALES DESC
LIMIT 3;

-- 13. Calculate the total revenue generated from "Electronics" category products with a "Sale_Flag" of 'Yes'.
SELECT CATEGORY AS ELECTRONICS,SUM(Item_Price) AS Total_Revenue
FROM PAYTM_EPURCHASE_DATA
WHERE Category = 'WATCHES' AND Sale_Flag = 'ON SALE';
//-- 
14. Identify the top 5 shipping cities based on the average order value 
-- (total sales amount divided by the number of orders) and display their average order values.
SELECT SHIPPING_CITY, SUM(ITEM_PRICE)/COUNT(QUANTITY) AS AVERAGE_ORDER_VALUE
FROM PAYTM_EPURCHASE_DATA
GROUP BY SHIPPING_CITY
ORDER BY AVERAGE_ORDER_VALUE DESC
LIMIT 5;

-- 15. Determine the total number of orders and the total sales amount for each "Product_Gender" within the "Clothing" category.
SELECT Product_Gender,
COUNT(*) AS Total_Orders,
SUM(Item_Price) AS Total_Sales_Amount
FROM PAYTM_EPURCHASE_DATA
WHERE CATEGORY_GROUPED = 'APPARELS'
GROUP BY Product_Gender;

-- OR --

SELECT Product_Gender,
       SUM(Quantity) AS Total_Orders,
       SUM(Item_Price * Quantity) AS Total_Sales_Amount
FROM PAYTM_EPURCHASE_DATA
WHERE CATEGORY_GROUPED = 'APPARELS'
GROUP BY Product_Gender;
-- 16. Calculate the percentage contribution of each "Category" to the overall total sales.
WITH TOTALSALES AS (SELECT SUM(ITEM_PRICE) AS TOTAL FROM PAYTM_EPURCHASE_DATA)
SELECT CATEGORY,SUM(ITEM_PRICE) AS CATEGORY_TOTAL_SALES,
CONCAT((SUM(ITEM_PRICE) / (SELECT TOTAL FROM TOTALSALES)) * 100,'%') AS PERCENTAGE_CONTRIBUTION
FROM PAYTM_EPURCHASE_DATA
GROUP BY CATEGORY;

-- 17. Identify the "Category" with the highest average "Item_Price" and its corresponding average price.
SELECT CATEGORY, AVG(ITEM_PRICE) AS AVERAGE_ITEM_PRICE
FROM PAYTM_EPURCHASE_DATA
GROUP BY CATEGORY
ORDER BY AVERAGE_ITEM_PRICE DESC
LIMIT 1;
-- 18. Find the month with the highest total sales revenue.
SELECT FLOOR(MOD(S_NO, 12)) + 1 AS Month,SUM(Item_Price) AS Total_Sales_Revenue
FROM PAYTM_EPURCHASE_DATA
GROUP BY Month
ORDER BY Total_Sales_Revenue DESC
LIMIT 1;

-- 19. Calculate the total sales for each "Segment" and the average quantity sold per order for each segment
SELECT SEGMENT,COUNT(PAID_PR) AS TOTAL_SALES, AVG(QUANTITY)
FROM PAYTM_EPURCHASE_DATA
GROUP BY SEGMENT;


/*Item_Price: This column typically represents the price at which the item is sold to the customer. It's the price that customers pay for the product. Therefore, if you're interested in revenue generated from sales, the "Item_Price" column would be directly related.

Cost_Price: This column represents the cost incurred by the seller to acquire the product. It's the price at which the seller buys the product. While it's not directly related to sales, understanding the cost price is crucial for calculating profit margins and assessing the profitability of sales.

Paid_pr: This column might represent the price paid by the seller to the supplier or manufacturer for the product. It could be similar to the "Cost_Price" but may include additional costs or considerations. Like the "Cost_Price", it's not directly related to sales but is important for understanding profitability.

In most cases, when referring to "sales", you're interested in the revenue generated from selling products, so the "Item_Price" column would be the most directly related to sales. However, understanding the cost price (either "Cost_Price" or "Paid_pr") is crucial for calculating profit margins and assessing the overall profitability of sales.*/



/* Here, we define a CTE named TotalSales.
The TotalSales CTE calculates the total sales amount across all categories using the SUM(Item_Price) aggregation function applied to the Item_Price column of the table YourTableName.
The result of this subquery is stored in the total column within the CTE.
In the main query, we select the following columns:
Category: This column represents the category of products.
SUM(Item_Price) AS Category_Total_Sales: This calculates the total sales amount for each category by summing up the Item_Price column.
(SUM(Item_Price) / (SELECT total FROM TotalSales)) * 100 AS Percentage_Contribution: This calculates the percentage contribution of each category to the overall total sales.
It divides the total sales for each category (SUM(Item_Price)) by the total sales amount obtained from the TotalSales CTE ((SELECT total FROM TotalSales)).
Then, it multiplies the result by 100 to get the percentage value.
FROM YourTableName: This specifies the table from which the data is being retrieved.
GROUP BY Category: This groups the results by the Category column.
Overall, the query calculates the total sales for each category, calculates the overall total sales using a CTE, and then computes the percentage contribution of each category to the overall total sales.
*/
/*We use the MOD() function to calculate the remainder of the division of the order number (S.no) by 12. This effectively assigns each order to a month based on its order number.
The FLOOR() function rounds down the result of the division to the nearest integer.
We add 1 to ensure that the months are numbered from 1 to 12.
The results are grouped by the calculated month.
We order the results by the total sales revenue in descending order using ORDER BY.
Finally, we limit the result to only the first row using LIMIT 1, which gives us the month with the highest total sales revenue.
Please note that this approach assumes a uniform distribution of orders across months, which may not be accurate. If possible, it's always best to have a date column in your dataset to perform time-based analyses accurately.*/