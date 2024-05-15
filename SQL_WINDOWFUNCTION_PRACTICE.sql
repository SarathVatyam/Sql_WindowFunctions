SELECT SUM(sales) AS Toatl_sales from sales1;

SELECT AVG(sales) AS Avg_sales, order_id
FROM sales1
GROUP BY order_id
ORDER BY AVG(sales)DESC;

SELECT SUM(quantity) AS Total_quant,segment FROM sales1 GROUP BY segment;

SELECT sum(profit) AS Total_profit FROM sales1;

SELECT SUM(shipping_cost) AS T_SHIP_CST FROM sales1;

SELECT 
    DISTINCT(region),
    SUM(sales) OVER (PARTITION BY region) as segment_wise
FROM 
    sales1
ORDER BY 
    segment_wise DESC;
    
#What is the average sales amount for each product category, partitioned by region?

SELECT region,category,
AVG(sales) AS AVG_sales
FROM sales1
GROUP BY 1,2
ORDER BY AVG_sales DESC;


#What is the top 3 products by sales amount in each region?
SELECT product_name, region ,s_rank
 FROM (SELECT product_name, region ,
DENSE_RANK()OVER(PARTITION BY region ORDER BY SUM(sales)DESC) AS s_rank
FROM sales1
GROUP BY 1,2) AS S_SUMMARY
HAVING s_rank IN (1,2,3);

#What is the running total of sales amount for each order?
SELECT order_id,order_date,
SUM(sales)OVER(ORDER BY  order_id,order_date) as R_sales
FROM sales1;

#What is the cumulative sum of quantity sold for each product?
SELECT product_name,sub_category,
SUM(quantity)OVER(PARTITION BY product_name ROWS UNBOUNDED PRECEDING) AS cum_qty
FROM sales1;

SELECT SUM(sales) as total_sales
FROM sales1;


#Cummulative sales by order_date
SELECT order_date,
SUM(sales)OVER(ORDER BY order_date ROWS UNBOUNDED PRECEDING) AS cum_sales
FROM sales1;

#What is the cumulative sum of quantity sold for each product?
SELECT quantity, product_name,
SUM(quantity)OVER(ORDER BY product_name ROWS UNBOUNDED PRECEDING) as CUM_QTY
from sales1;

#What is the percentage of total sales for each product category?
    
WITH TotalSales AS (
    SELECT 
        SUM(sales) AS total_sales
    FROM 
        sales1
),
CategorySales AS (
    SELECT 
        category,
        SUM(sales) AS category_sales
    FROM 
        sales1
    GROUP BY 
        category
)
SELECT 
    cs.category,
    cs.category_sales,
    ((cs.category_sales / ts.total_sales) * 100) AS category_percentage
FROM 
    CategorySales cs
CROSS JOIN
TotalSales ts;


##What is the moving average of sales amount for each order, with a window size of 3?
SELECT order_id,sales,order_date,
avg(sales)OVER(ORDER BY order_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MVG_AVG
FROM sales1;

#What is the lag in sales amount for each order, compared to the previous order?

SELECT order_id,order_date,sales,
sales-LAG(SALES,1)over(ORDER BY order_date) as diff_lag
FROM sales1;



SELECT 
    order_id,
    order_date,
    sales,
    LAG(sales, 1) OVER (PARTITION BY order_id ORDER BY order_date) AS lagged_sales
FROM 
    sales1;



