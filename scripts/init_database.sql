/*
===============================================================================
Script:      init_database.sql
Description: Initializes the DataWarehouse database and creates the
             Bronze, Silver, and Gold schemas.

Purpose:
    - Switch to the master database
    - Drop the DataWarehouse database if it already exists
    - Create a new DataWarehouse database
    - Create the Bronze, Silver, and Gold schemas

Warning:
    This script drops the existing DataWarehouse database and all of its data.
    Use this script only when creating or resetting the development database.

===============================================================================
*/


USE master;
GO


-- Drop the database if it already exists
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO


-- Create the DataWarehouse database
CREATE DATABASE DataWarehouse;
GO


-- Switch to the DataWarehouse database
USE DataWarehouse;
GO


-- Create schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
