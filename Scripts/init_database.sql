/*
    This script initializes the Data Warehouse environment.
    It drops the existing DataWarehouse database if it exists, 
    creates a new one, and sets up the three main layers 
    (bronze, silver, gold) used in the medallion architecture.
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouse' database
DROP DATABASE IF EXISTS DataWarehouse;


-- Create the "DataWarehouse" database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
