# Data Warehouse Project

This project demonstrates the design and implementation of a modern **SQL Data Warehouse** using the **Medallion Architecture (Bronze, Silver, Gold)**.

The pipeline ingests raw data from multiple sources, cleans and transforms it, and finally produces business-ready data models for analytics and reporting.

---

# Architecture

The project follows the **Medallion Data Architecture** 

## Bronze Layer
- Stores raw data ingested from source systems
- No transformations are applied
- Serves as the staging layer

Sources:
- CRM System
- ERP System

## Silver Layer
- Performs data cleaning and transformations
- Standardizes formats and fixes data quality issues
- Removes duplicates
- Validates and enriches the data

## Gold Layer
- Provides business-ready datasets
- Implements **Star Schema**
- Contains:
  - Dimension tables
  - Fact tables

This layer is optimized for **analytics and BI tools**.

---

# Data Model

The Gold layer implements a **Star Schema**:

Fact Table
- `fact_sales`

Dimension Tables
- `dim_customers`
- `dim_products`

---

# ETL Pipeline

The pipeline runs in the following order:

1. Create the Data Warehouse database
2. Load raw data into the **Bronze Layer**
3. Transform and clean data in the **Silver Layer**
4. Build analytical models in the **Gold Layer**
