# Gold Layer Data Catalog

## 1. Overview

The Gold layer contains business-ready data organized for analytical queries and reporting. It follows a dimensional modeling approach, with dimension tables providing descriptive information and a fact table storing sales transaction details.

### Tables

| Table                | Type      | Description                                                    |
| -------------------- | --------- | -------------------------------------------------------------- |
| `gold.dim_customers` | Dimension | Contains customer attributes for customer-related analysis.    |
| `gold.dim_products`  | Dimension | Contains product attributes for product and category analysis. |
| `gold.fact_sales`    | Fact      | Contains sales transactions and measures for sales analysis.   |

## 2. Customer Dimension — `gold.dim_customers`

### Purpose

Stores customer information consolidated from the CRM and ERP source systems. It supports customer segmentation and sales analysis by customer attributes such as country, gender, and marital status.

### Column Details

| Column Name       | Data Type      | Description                                                |
| ----------------- | -------------- | ---------------------------------------------------------- |
| `customer_key`    | `BIGINT`       | Warehouse surrogate key identifying a customer record.     |
| `customer_id`     | `INT`          | Customer identifier originating from the source data.      |
| `customer_number` | `NVARCHAR(50)` | Business identifier used to identify the customer.         |
| `first_name`      | `NVARCHAR(50)` | Customer's first name.                                     |
| `last_name`       | `NVARCHAR(50)` | Customer's last name.                                      |
| `country`         | `NVARCHAR(50)` | Country associated with the customer.                      |
| `marital_status`  | `NVARCHAR(50)` | Customer's marital status.                                 |
| `gender`          | `NVARCHAR(50)` | Customer's gender as recorded in the source data.          |
| `birthdate`       | `DATE`         | Customer's date of birth.                                  |
| `create_date`     | `DATE`         | Date the customer record was created in the source system. |

## 3. Product Dimension — `gold.dim_products`

### Purpose

Stores descriptive product information, including product identifiers, category details, cost, and product line. It supports product-level analysis and sales reporting by product category and subcategory.

### Column Details

| Column Name      | Data Type      | Description                                                                              |
| ---------------- | -------------- | ---------------------------------------------------------------------------------------- |
| `product_key`    | `BIGINT`       | Warehouse surrogate key identifying a product record.                                    |
| `product_id`     | `INT`          | Product identifier originating from the source data.                                     |
| `product_number` | `NVARCHAR(50)` | Business identifier used to identify the product.                                        |
| `product_name`   | `NVARCHAR(50)` | Name of the product.                                                                     |
| `category_id`    | `NVARCHAR(50)` | Identifier associated with the product category.                                         |
| `category`       | `NVARCHAR(50)` | Product category.                                                                        |
| `subcategory`    | `NVARCHAR(50)` | Product subcategory.                                                                     |
| `maintenance`    | `NVARCHAR(50)` | Maintenance-related product attribute from the source data.                              |
| `cost`           | `INT`          | Product cost as stored in the warehouse.                                                 |
| `product_line`   | `NVARCHAR(50)` | Product line classification.                                                             |
| `start_date`     | `DATE`         | Date when the product became available for sale or use.                                  |

## 4. Sales Fact — `gold.fact_sales`

### Purpose

Stores sales transaction details, including customer and product keys, order dates, quantities, prices, and sales amounts. It supports analysis of sales performance, order activity, product sales, and customer purchasing patterns.

### Column Details

| Column Name     | Data Type      | Description                                                    |
| --------------- | -------------- | -------------------------------------------------------------- |
| `order_number`  | `NVARCHAR(50)` | Identifier of the sales order associated with the transaction. |
| `product_key`   | `BIGINT`       | Surrogate linking the sales record to `gold.dim_products`.     |
| `customer_key`  | `BIGINT`       | Surrogate linking the sales record to `gold.dim_customers`.    |
| `order_date`    | `DATE`         | Date the sales order was placed.                               |
| `shipping_date` | `DATE`         | Date the order was shipped.                                    |
| `due_date`      | `DATE`         | Due date associated with the sales order.                      |
| `sales_amount`  | `INT`          | Sales amount recorded for the transaction.                     |
| `quantity`      | `INT`          | Quantity of products sold in the transaction.                  |
| `price`         | `INT`          | Price recorded for the transaction.                            |

## 5. Relationships and Usage

* `gold.fact_sales` connects to `gold.dim_customers` through `customer_key`.
* `gold.fact_sales` connects to `gold.dim_products` through `product_key`.
* Customer and product dimensions provide descriptive attributes for filtering and grouping sales data.
* The fact table provides the measures used to calculate sales metrics and analyze trends.

These tables form the core analytical model of the Gold layer and can be queried together to support business reporting and analysis.
