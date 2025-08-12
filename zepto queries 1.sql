RENAME TABLE zepto_v2 TO zepto_products;
SELECT * FROM zepto_products;

CREATE TABLE zepto_products(
    sku_id SERIAL PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp NUMERIC(8,2),
    discount_Percent NUMERIC(5,2),
    availableQuantity INTEGER,
    discounted_Price NUMERIC(8,2),
    weight_in_Gms INTEGER,
    outOfStock BOOLEAN,
    quantity INTEGER
);

ALTER TABLE zepto_products
RENAME COLUMN ï»¿Category TO Category;

ALTER TABLE zepto_products
RENAME COLUMN weightInGms  TO weight_in_gms;

ALTER TABLE zepto_products
RENAME COLUMN discountPercent TO discount_percent;

ALTER TABLE zepto_products
RENAME COLUMN discountedSellingPrice TO discounted_price;

--data exploration

1) Count of Rows
SELECT COUNT(*) FROM zepto_products;

2) Sample Data
SELECT * FROM zepto_products LIMIT 10;

3) Null Values
SELECT * FROM zepto_products
WHERE name IS NULL
OR
Category IS NULL 
 OR 
 mrp IS NULL 
 OR
 discount_Percent IS NULL
 OR
 discounted_Price IS NULL 
 OR
 weight_in_Gms IS NULL
 OR 
availableQuantity IS NULL 
 OR
 outOfStock IS NULL
 OR
 quantity IS NULL;
 
4) Distinct Product Categories
SELECT DISTINCT Category  FROM zepto_products ORDER BY Category; 

5) Products In Stock vs Out of Stock
SELECT outofstock, COUNT(*) AS count
FROM zepto_products
GROUP BY outofstock;

6)  Duplicate Product Names
SELECT name, COUNT(*) AS  occurrences
FROM zepto_products
GROUP BY name
HAVING COUNT(*) > 1
order by occurrences  desc;

---- data cleaning 

1) Products with MRP or Selling Price = 0
SELECT * FROM zepto_products WHERE mrp = 0 OR discounted_Price = 0;

2) Delete Products with MRP = 0
SET SQL_SAFE_UPDATES = 0;
DELETE FROM zepto_products WHERE mrp = 0;
SET SQL_SAFE_UPDATES = 1;

3) Convert Paise to Rupees
SET SQL_SAFE_UPDATES = 0;
UPDATE zepto_products
SET mrp = mrp / 100.0,
    discounted_Price = discounted_Price / 100.0;
    
4) Check data types
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'zepto_products';

5)-- View inconsistent categories (extra spaces, cases)
SELECT DISTINCT TRIM(LOWER(category)) FROM zepto_products;



--- insights queries

1) Top 10 Best-Value Products (Discount %)
SELECT DISTINCT name, mrp, discount_Percent
FROM zepto_products ORDER BY discount_Percent DESC LIMIT 10;

2)  MRP But Out of Stock
SELECT distinct name, mrp
FROM zepto_products
WHERE outOfStock ='TRUE' and mrp > 300
ORDER BY mrp desc;

3) Estimated Revenue by Category
SELECT category,
SUM(discounted_Price * availableQuantity) AS total_revenue
FROM zepto_products GROUP BY category ORDER BY total_revenue DESC;

4) MRP  with Low Discount
SELECT DISTINCT name, mrp, discount_Percent
FROM zepto_products WHERE mrp> 500 AND discount_Percent < 10
ORDER BY mrp DESC;

5) Top 5 Categories by Avg Discount
SELECT category,
ROUND(AVG(discount_Percent),2) AS avg_discount
FROM zepto_products GROUP BY category ORDER BY avg_discount DESC LIMIT 5;

6)  Price Per Gram (Best Value)
SELECT DISTINCT name, weight_in_Gms, discounted_Price,
ROUND(discounted_Price / weight_in_Gms, 2) AS price_per_gram
FROM zepto_products WHERE weight_in-Gms >= 100 ORDER BY price_per_gram;

7) Group Products by Weight Category
SELECT DISTINCT name, weight_in_Gms,
CASE WHEN weight_in_Gms < 1000 THEN 'Low'
     WHEN weight_in_Gms < 5000 THEN 'Medium'
     ELSE 'Bulk' END AS weight_category
FROM zepto_products;

8) Total Inventory Weight by Category
SELECT category,
SUM(weight_in_Gms * availableQuantity) AS total_weight
FROM zepto_products GROUP BY category ORDER BY total_weight DESC;

9) Price Deviation from Category Average
SELECT name, category, mrp,
       ROUND(mrp - AVG(mrp) OVER (PARTITION BY category), 2) AS deviation_from_avg
FROM zepto_products ORDER BY ABS(mrp - AVG(mrp) OVER (PARTITION BY category)) DESC
LIMIT 10;

10)  Weighted Discount Impact (High Discount x Stock)
SELECT name, discount_Percent, availableQuantity,
       ROUND(discount_Percent * availableQuantity, 2) AS weighted_discount_impact
FROM zepto_products WHERE outOfStock = FALSE
ORDER BY weighted_discount_impact DESC LIMIT 10;


11)  Most and Least Cost-Efficient Products (Price/Gram)
SELECT name, weight_in_Gms, discounted_Price,
ROUND(discounted_Price / NULLIF(weight_In_Gms, 0), 2) AS price_per_gram
FROM zepto_products WHERE weight_in_Gms IS NOT NULL
ORDER BY price_per_gram DESC LIMIT 5;

12)  Availability Ratio per Category
SELECT category,
       SUM(CASE WHEN outOfStock = FALSE THEN quantity ELSE 0 END) * 100.0 / SUM(quantity) AS availability_ratio
FROM zepto_products GROUP BY category ORDER BY availability_ratio DESC;

13)  Lost Revenue from Out-of-Stock Discounted Products
SELECT SUM((mrp - discounted_Price) * quantity) AS lost_discount_revenue
FROM zepto_products WHERE outOfStock = TRUE;

14)  Products with Discount > 90%
SELECT name, mrp, discounted_Price, discount_Percent
FROM zepto_products WHERE discount_Percent = '>90'ORDER BY discount_Percent DESC;

15) Discount Distribution Brackets
SELECT
  CASE 
    WHEN discount_Percent < 10 THEN '0-10%'
    WHEN discount_Percent < 20 THEN '10-20%'
    WHEN discount_Percent < 30 THEN '20-30%'
    WHEN discount_Percent < 50 THEN '30-50%'
    ELSE '50%+' END AS discount_bracket,
  COUNT(*) AS total_products
FROM zepto_products GROUP BY discount_bracket ORDER BY total_products DESC;

16) Revenue Contribution % per Category
WITH revenue_cte AS (
  SELECT category,
         SUM(discounted_Price * availableQuantity) AS category_revenue
  FROM zepto_products GROUP BY category
)
SELECT category,
       category_revenue,
       ROUND(category_revenue * 100.0 / SUM(category_revenue) OVER (), 2) AS revenue_pct
FROM revenue_cte ORDER BY revenue_pct DESC;

17)  MRP Lower than Discounted Price (Data Validation)
SELECT name, mrp, discounted_Price
FROM zepto_products WHERE discounted_Price ='> mrp';

18) Out-of-Stock Rate per Category
SELECT category,
  COUNT(CASE WHEN outOfStock = TRUE THEN 1 END) * 100.0 / COUNT(*) AS out_of_stock_rate
FROM zepto_products
GROUP BY category
ORDER BY out_of_stock_rate DESC;

19) Price Range Segments
SELECT 
  CASE 
    WHEN discounted_Price < 100 THEN '< ₹100'
    WHEN discounted_Price BETWEEN 100 AND 300 THEN '₹100–₹300'
    WHEN discounted_Price BETWEEN 301 AND 500 THEN '₹301–₹500'
    ELSE '> ₹500' 
  END AS price_range,
  COUNT(*) AS product_count
FROM zepto_products
GROUP BY price_range
ORDER BY product_count DESC;

20) Top 10 Heaviest Products
SELECT name, category, weight_in_Gms
FROM zepto_products
ORDER BY weight_in_Gms DESC
LIMIT 10;

 21) Average Discount by Weight Category
SELECT 
  CASE WHEN weight_in_Gms < 1000 THEN 'Low'
       WHEN weight_in_Gms < 5000 THEN 'Medium'
       ELSE 'Bulk' END AS weight_category,
  ROUND(AVG(discount_Percent), 2) AS avg_discount
FROM zepto_products
GROUP BY weight_category;







