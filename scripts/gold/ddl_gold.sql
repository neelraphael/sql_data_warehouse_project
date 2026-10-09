/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
This script creates views for the Gold layer of the data warehouse.
The Gold layer represents the final dimension and fact views, organized
using a star schema to support analytical reporting and business analysis.

```
It performs the following actions:
  - Creates dimension views for customers and products.
  - Creates a fact view containing sales transactions and measures.
  - Connects the sales fact view to the customer and product dimensions.
  - Generates surrogate keys for the customer and product dimensions.
  - Drops existing views before recreating them.
```
.
Views:
gold.dim_customers
gold.dim_products
gold.fact_sales
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
USE DataWarehouse;
GO

IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT 
       ROW_NUMBER() over(order by cinfo.cst_id) as customer_key
       ,cinfo.cst_id AS customer_id
      ,cinfo.cst_key as customer_number
      ,cinfo.cst_firstname as first_name
      ,cinfo.cst_lastname as last_name
      ,cloc.cntry as country
      ,cinfo.cst_marital_status as marital_status
      ,CASE WHEN cinfo.cst_gndr != 'n/a' THEN cinfo.cst_gndr -- Data integration (CRM is the master for gender information)
            ELSE COALESCE(cdob.gen,'n/a') END AS gender
       ,cdob.bdate as birthdate
      ,cinfo.cst_create_date as create_date
      

FROM silver.crm_cust_info cinfo
LEFT JOIN silver.erp_cust_az12 cdob
ON cinfo.cst_key = cdob.cid
LEFT JOIN silver.erp_loc_a101 cloc
ON cinfo.cst_key = cloc.cid
GO


-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO
CREATE VIEW gold.dim_products AS
SELECT 
       ROW_NUMBER() OVER(ORDER BY pinfo.prd_start_dt,pinfo.prd_key) AS product_key
       ,pinfo.prd_id AS product_id
      ,pinfo.prd_key AS product_number 
      ,pinfo.prd_nm AS product_name
      ,pinfo.cat_id AS category_id
      ,pcat.cat AS category
      ,pcat.subcat AS subcategory
      ,pcat.maintenance 
      ,pinfo.prd_cost AS cost
      ,pinfo.prd_line AS product_line
      ,pinfo.prd_start_dt AS start_date
      
   FROM DataWarehouse.silver.crm_prd_info pinfo
  LEFT JOIN silver.erp_px_cat_g1v2 pcat ON
  pinfo.cat_id = pcat.id
  WHERE pinfo.prd_end_dt IS NULL -- filter out all historical data
GO

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT sd.sls_ord_num AS order_number
      ,pr.product_key
      ,cu.customer_key
      ,sd.sls_order_dt AS order_date
      ,sd.sls_ship_dt AS shipping_date
      ,sd.sls_due_dt AS due_date
      ,sd.sls_sales AS sales_amount
      ,sd.sls_quantity AS quantity
      ,sd.sls_price AS price
  FROM DataWarehouse.silver.crm_sales_details sd
  LEFT JOIN gold.dim_products pr
  ON sd.sls_prd_key = pr.product_number
  LEFT JOIN gold.dim_customers cu
  ON sd.sls_cust_id = cu.customer_id
GO
