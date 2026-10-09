# Data Warehouse and Analytics Project

This project is a hands-on implementation of a modern data warehouse and analytics solution using SQL Server.

The project demonstrates the end-to-end process of building a data warehouse, starting from raw data ingestion and progressing through data cleaning, transformation, dimensional modeling, and analytical reporting.

The data is organized into Bronze, Silver, and Gold layers to support a structured and maintainable data pipeline. The project also covers data quality checks, ETL processes, fact and dimension tables, and SQL-based analytical queries.

This project is being developed as a learning exercise to gain practical experience with data warehousing, ETL, dimensional modeling, and analytics concepts.

## Architecture

This project follows the **Medallion Architecture**, which organizes data
into three layers: Bronze, Silver, and Gold.

![Data Warehouse Architecture](docs/architecture_dw.jpg)

### Bronze Layer

The Bronze layer contains the **raw data** loaded from the source systems.

The data is stored with minimal transformation so that the original source data is preserved. This layer serves as the initial landing area for the data and provides a reliable source for downstream processing.

### Silver Layer

The Silver layer contains **cleaned and transformed data**.

Data from the Bronze layer is validated, standardized, cleaned, and transformed to improve its quality and consistency. Issues such as invalid values, duplicates, inconsistent formats, and missing data are handled at this stage.

### Gold Layer

The Gold layer contains **business-ready data** designed for analytics and reporting.

The transformed data is organized into **fact and dimension tables**, forming a dimensional model that makes it easier to perform analytical queries and generate business insights.

### Data Flow

The overall data flow can be summarized as:

**Source Systems → Bronze → Silver → Gold → Analytics**

This layered approach separates raw data from transformed and business-ready data, making the data pipeline easier to understand, maintain, and extend.

---
## Project Overview

This project covers the development of a modern data warehouse and analytics solution using SQL Server.

The main components of the project include:

1. **Data Architecture**: Designing a data warehouse using the Medallion Architecture with Bronze, Silver, and Gold layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the data warehouse.
3. **Data Modeling**: Designing fact and dimension tables to support analytical queries and reporting.
4. **Analytics and Reporting**: Developing SQL-based analyses to generate meaningful business insights.

---
## Project Requirements

### 1. Building the Data Warehouse

#### Objective

The objective is to build a modern data warehouse using SQL Server that consolidates sales-related data from multiple source systems and prepares it for analytical reporting.

#### Requirements

- **Data Sources**: Load data from two source systems, ERP and CRM, provided as CSV files.
- **Data Quality**: Identify and resolve data quality issues before the data is used for analysis.
- **Data Integration**: Combine data from both source systems into a consistent and user-friendly analytical data model.
- **Data Scope**: The project focuses on the latest available dataset. Historical data tracking is outside the scope of this project.
- **Documentation**: Document the data model and the overall solution to make it understandable for both technical and business users.

### 2. Analytics and Reporting

#### Objective

The objective is to develop SQL-based analytical queries that provide insights into key business areas, including:

- **Customer Behavior**
- **Product Performance**
- **Sales Trends**

The resulting analysis provides business metrics that can be used to understand sales performance and customer and product trends.

## Repository Structure

The repository is organized into folders for source datasets, project documentation, SQL scripts, and data quality checks.

```text
sql_data_warehouse_project/
│
├── datasets/
│   ├── source_crm/
│   └── source_erp/
│
├── docs/
│   ├── architecture_dw.jpg
│   ├── data_catalog.md
│   ├── data_integration.jpg
│   ├── data_model.jpg
│   ├── dataflow_diagram.jpg
│   └── naming_conventions.md
│
├── scripts/
│   ├── bronze/
│   ├── silver/
│   ├── gold/
│   └── init_database.sql
│
├── tests/
│   ├── quality_checks_silver.sql
│   └── quality_checks_gold.sql
│
└── README.md
```

### Folder Description

| Folder      | Description                                                                                                                         |
| ----------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| `datasets/` | Contains the source datasets from the CRM and ERP systems.                                                                          |
| `docs/`     | Contains the data warehouse architecture, data integration, dataflow and data model diagrams, data catalog, and naming conventions. |
| `scripts/`  | Contains SQL scripts for database initialization and the Bronze, Silver, and Gold layers.                                           |
| `tests/`    | Contains SQL scripts used to validate data quality in the Silver and Gold layers.                                                   |


## Important Links

* **Source Datasets**

  * [CRM Source Data](datasets/source_crm/)
  * [ERP Source Data](datasets/source_erp/)

* **Project Documentation**

  * [Data Warehouse Architecture](docs/architecture_dw.jpg)
  * [Data Integration Diagram](docs/data_integration.jpg)
  * [Dataflow Diagram](docs/dataflow_diagram.jpg)
  * [Data Model](docs/data_model.jpg)
  * [Data Catalog](docs/data_catalog.md)
  * [Naming Conventions](docs/naming_conventions.md)

* **SQL Scripts**

  * [Database Initialization](scripts/init_database.sql)
  * [Bronze Layer Scripts](scripts/bronze/)
  * [Silver Layer Scripts](scripts/silver/)
  * [Gold Layer Scripts](scripts/gold/)

* **Data Quality Checks**

  * [Silver Layer Quality Checks](tests/quality_checks_silver.sql)
  * [Gold Layer Quality Checks](tests/quality_checks_gold.sql)

* **Project Implementation Steps**

  * [Project Steps in Notion](https://app.notion.com/p/Data-Warehouse-Project-3e2a4ebfd161802ca172cd1e5bbc85f0?source=copy_link)

## Technologies Used

* **SQL Server Express** – Used as the database engine to create and manage the data warehouse.
* **SQL Server Management Studio (SSMS)** – Used to execute SQL scripts, create database objects, and perform data validation.
* **T-SQL** – Used to define database objects, implement data transformations, create views, and perform data quality checks.
* **Draw.io** – Used to create the data warehouse architecture, data integration, dataflow, and data model diagrams.
* **GitHub** – Used to host the project repository and maintain SQL scripts, diagrams, and project documentation.


## Acknowledgements

This project was developed as a hands-on learning exercise based on the Data Warehouse and Analytics Project tutorial by [DataWithBaraa](https://youtu.be/9GVqKuTVANE?si=G4Nu5qyBrvXMeXFw).

The tutorial provided guidance on the data warehouse architecture, Medallion approach, and implementation workflow. This repository documents my learning and implementation of these concepts, including the SQL scripts, diagrams, and project documentation.

