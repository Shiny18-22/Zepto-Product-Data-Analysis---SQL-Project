# Zepto Product Data Analysis - SQL Project

## Overview  
This project analyzes product-level data from Zepto, a fast-growing quick-commerce platform, using SQL. It simulates a real-world business analysis workflow involving data cleaning, exploration, and extraction of actionable insights on product performance, pricing strategy, inventory health, and revenue opportunities.

## Tools & Technologies  
- SQL Workbench  
- Excel  

## Dataset Description  
The dataset (`zepto_products`) contains product listings with these fields:  
- `category`: Product category  
- `name`: Product name  
- `mrp`: Maximum Retail Price (in ₹)  
- `discount_percent`: Discount offered (%)  
- `available_quantity`: Units available in stock  
- `discounted_price`: Final selling price after discount (₹)  
- `weight_in_gms`: Product weight in grams  
- `outofstock`: Stock status (boolean)  
- `quantity`: Total quantity (sold or planned)  

## Data Cleaning Steps  
- Renamed inconsistent columns for clarity and standardization.  
- Removed rows with zero MRP or discounted price.  
- Converted monetary values from paise to rupees where necessary.  
- Trimmed and normalized inconsistent category names.  
- Identified and handled duplicate product entries.  

## Data Exploration Queries  
- Total record count  
- Sample product data extraction  
- Null value checks in key columns  
- List distinct product categories  
- Count of in-stock vs out-of-stock products  
- Duplicate product name detection  

## Business Insights Queries  
- Discount and pricing trend analysis  
- Pricing anomaly detection  
- Inventory and stock availability assessment  
- Revenue estimates per category  
- Advanced insights: price deviation, weighted discount impact, cost-efficiency analysis  

## Key Insights & Observations  
- Some products have extremely high discounts (>90%), suggesting pricing irregularities.  
- Certain high-MRP products are frequently out of stock, indicating supply or demand issues.  
- Revenue is disproportionately contributed by a few product categories, beneficial for marketing focus.  
- Price per gram analysis identifies best value products, aiding pricing strategies.  

## Future Enhancements  
- Introduce supplier and location granularity for more detailed analysis.  
- Automate common analytics via stored procedures or views.  
- Incorporate time-series data for trend analyses on a weekly or monthly basis.  

## Outcome  
This project showcases practical business problem-solving with SQL through comprehensive data cleaning, validation, exploratory analysis, and strategic insights. It supports inventory planning, pricing decisions, and category management for e-commerce platforms like Zepto.
