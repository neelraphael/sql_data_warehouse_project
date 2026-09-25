# Naming Conventions

This document defines the naming standards used throughout the data warehouse. Consistent naming makes database objects easier to understand, maintain, and use across the Bronze, Silver, and Gold layers.

## Table of Contents

1. [General Principles](#general-principles)
2. [Table Naming](#table-naming)

   * [Bronze Layer](#bronze-layer)
   * [Silver Layer](#silver-layer)
   * [Gold Layer](#gold-layer)
3. [Column Naming](#column-naming)

   * [Surrogate Keys](#surrogate-keys)
   * [Technical Columns](#technical-columns)
4. [Stored Procedure Naming](#stored-procedure-naming)

---

## General Principles

* Use **snake_case** with lowercase letters and underscores to separate words.
* Use **English** for database object names.
* Avoid using SQL reserved keywords as object names.
* Use names that clearly describe the purpose or business meaning of the object.
* Apply the same naming pattern consistently across the warehouse.

---

## Table Naming

### Bronze Layer

Bronze tables represent data loaded from the source systems. The source system is included in the table name to make the origin of the data clear.

**Pattern:**

```text
<sourcesystem>_<entity>
```

* `<sourcesystem>` represents the originating system, such as `crm` or `erp`.
* `<entity>` represents the corresponding source table or entity.

**Examples:**

```text
crm_customer_info
crm_sales_details
erp_customer
erp_product
```

The Bronze layer preserves the structure and meaning of the source data as much as possible.

### Silver Layer

Silver tables contain cleaned and transformed data derived from the Bronze layer.

The source system prefix is retained where it helps identify the origin of the data.

**Pattern:**

```text
<sourcesystem>_<entity>
```

For example:

```text
crm_customer_info
erp_product
```

The data within these tables may differ from the original source because data cleaning, standardization, validation, and transformation are performed in the Silver layer.

### Gold Layer

Gold tables contain business-ready data designed for analytics and reporting.

Tables use a prefix that indicates their role in the dimensional model.

**Pattern:**

```text
<category>_<entity>
```

Examples:

```text
dim_customer
dim_product
fact_sales
```

#### Category Prefixes

| Prefix    | Purpose                 | Example                |
| --------- | ----------------------- | ---------------------- |
| `dim_`    | Dimension table         | `dim_customer`         |
| `fact_`   | Fact table              | `fact_sales`           |
| `report_` | Reporting/summary table | `report_monthly_sales` |

---

## Column Naming

### Surrogate Keys

Surrogate keys in dimension tables use the `_key` suffix.

**Pattern:**

```text
<entity>_key
```

Example:

```text
customer_key
product_key
```

These keys uniquely identify records within the data warehouse and are independent of the original source-system identifiers.

### Technical Columns

System-generated metadata columns use the `dwh_` prefix.

**Pattern:**

```text
dwh_<column_name>
```

Examples:

```text
dwh_load_date
dwh_create_date
```

These columns store technical information related to warehouse processing rather than business data.

---

## Stored Procedure Naming

Stored procedures responsible for loading warehouse layers follow this pattern:

```text
load_<layer>
```

Examples:

```text
load_bronze
load_silver
load_gold
```

The `<layer>` portion identifies the warehouse layer being populated.

---

## Summary

The naming convention can be summarized as follows:

| Object           | Convention          | Example             |
| ---------------- | ------------------- | ------------------- |
| Bronze table     | `<source>_<entity>` | `crm_customer_info` |
| Silver table     | `<source>_<entity>` | `crm_customer_info` |
| Dimension        | `dim_<entity>`      | `dim_customer`      |
| Fact             | `fact_<entity>`     | `fact_sales`        |
| Surrogate key    | `<entity>_key`      | `customer_key`      |
| Technical column | `dwh_<name>`        | `dwh_load_date`     |
| Load procedure   | `load_<layer>`      | `load_bronze`       |
