/*
===============================================================================================
Stored Procedure : Load Silver Layer (Source -> Bronze)
===============================================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to populate the 'silver' schema tables from the 'bronze' schema.
    It perform the following actions:
      - Truncates the Silver table before loading data.
      - Inserts transformed and cleansed data from Bronze into Silver tables.

Parameters: None. 
        This stored procedure does not accept any parameters or return any values.

Usage Example:
     EXEC silver.load_silver
===============================================================================================
*/



CREATE OR ALTER   PROCEDURE [silver].[load_silver]
AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY

        SET @batch_start_time = GETDATE();
		PRINT'============================================';
		PRINT'Loading Silver Layer';
		PRINT'============================================';


		PRINT'--------------------------------------------';
		PRINT'Loading CRM Tables';
		PRINT'--------------------------------------------';

        -- Loading silver.crm_cust_info
        SET @start_time = GETDATE()


        PRINT '>> Truncating Table : silver.crm_cust_info'
        TRUNCATE TABLE silver.crm_cust_info;
        PRINT '>> Inserting data into silver.crm_cust_info'
        INSERT INTO silver.crm_cust_info(
              cst_id,
              cst_key,
              cst_firstname,
              cst_lastname,
              cst_marital_status,
              cst_gndr,
              cst_create_date)

        SELECT  [cst_id]
              ,[cst_key]
              ,TRIM(cst_firstname) AS [cst_firstname]
              ,TRIM(cst_lastname) AS [cst_lastname]
              ,CASE WHEN UPPER(TRIM(cst_marital_status)) ='M' THEN 'Married'
                    WHEN UPPER(TRIM(cst_marital_status)) ='S' THEN 'Single' ELSE 'n/a' END as cst_marital_status -- Normalize marital status value to readable format
              ,CASE WHEN UPPER(TRIM(cst_gndr)) ='M' THEN 'Male'
                    WHEN UPPER(TRIM(cst_gndr)) ='F' THEN 'Female' ELSE 'n/a' END as cst_gndr --  -- Normalize gender value to readable format
              ,[cst_create_date]
        FROM
              (SELECT *,
              ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS rn
              FROM [bronze].[crm_cust_info]) t WHERE rn = 1 AND cst_id IS NOT NULL  -- select the most recent record per customer

        
        SET @end_time = GETDATE()
		PRINT'>> LOAD DURATION: ' + CAST (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT'------------------'


        --Loading silver.crm_prd_info
		SET @start_time = GETDATE()



        PRINT '>> Truncating Table : silver.crm_prd_info'
        TRUNCATE TABLE silver.crm_prd_info;
        PRINT '>> Inserting data into silver.crm_prd_info'

        INSERT INTO silver.crm_prd_info(prd_id
              ,cat_id
              ,prd_key
              ,prd_nm
              ,prd_cost
              ,prd_line
              ,prd_start_dt
              ,prd_end_dt)
        SELECT prd_id
              ,REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id  -- Extract category id
              ,SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key    -- Extract product key
              ,prd_nm
              ,ISNULL(prd_cost,0) AS prd_cost
              , CASE UPPER(TRIM(prd_line))
                        WHEN 'M' THEN 'Mountain'
                        WHEN 'R' THEN 'Road'
                        WHEN 'S' THEN 'Other Sales'
                        WHEN 'T' THEN 'Touring'
                        ELSE 'n/a' END AS prd_line  -- Map product line codes to descriptive value
              ,CAST(prd_start_dt AS DATE) AS prd_start_dt
              ,CAST(LEAD(prd_start_dt) OVER( PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS DATE) AS prd_end_dt -- Calculate end date as one day before the next start date
        FROM DataWarehouse.bronze.crm_prd_info

        SET @end_time = GETDATE()
		PRINT'>> LOAD DURATION: ' + CAST (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT'------------------'


        --Loading silver.crm_sales_details
		SET @start_time = GETDATE()



        PRINT '>> Truncating Table : silver.crm_sales_details'
        TRUNCATE TABLE silver.crm_sales_details;
        PRINT '>> Inserting data into silver.crm_sales_details'
        INSERT INTO silver.crm_sales_details(
                sls_ord_num
              ,sls_prd_key
              ,sls_cust_id
              ,sls_order_dt
              ,sls_ship_dt
              ,sls_due_dt
              ,sls_sales
              ,sls_quantity
              ,sls_price )

        SELECT sls_ord_num
              ,sls_prd_key
              ,sls_cust_id
              , CASE WHEN len(sls_order_dt) != 8 or sls_order_dt = 0 THEN NULL   -- handling invalid data
              ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) END AS sls_order_dt  -- datatype casting
              , CASE WHEN len(sls_ship_dt) != 8 or sls_ship_dt = 0 THEN NULL
              ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) END AS sls_ship_dt
              , CASE WHEN len(sls_due_dt) != 8 or sls_due_dt = 0 THEN NULL
              ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) END AS sls_due_dt
              , CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
                      THEN sls_quantity * ABS(sls_price)
                      ELSE sls_sales  
                END AS sls_sales -- Recalculate sales if original value is missing or incorrect
              ,sls_quantity
              , CASE WHEN sls_price IS NULL OR sls_price <= 0
                    THEN sls_sales / NULLIF(sls_quantity,0)
                    ELSE sls_price 
                END AS  sls_price -- Derive price if original value is invalid
         FROM DataWarehouse.bronze.crm_sales_details
        
        SET @end_time = GETDATE()
		PRINT'>> LOAD DURATION: ' + CAST (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT'------------------'


        
		PRINT'--------------------------------------------';
		PRINT'Loading ERP Tables';
		PRINT'--------------------------------------------';


        -- Loading silver.erp_cust_az12
		SET @start_time = GETDATE()



        PRINT '>> Truncating Table : silver.erp_cust_az12'
        TRUNCATE TABLE silver.erp_cust_az12;
        PRINT '>> Inserting data into silver.erp_cust_az12'
        INSERT INTO silver.erp_cust_az12(
                cid
              ,bdate
              ,gen )

        SELECT  CASE WHEN cid like 'NAS%' THEN  --  Remove 'NAS' prefix if present
                SUBSTRING(cid,4,len(cid)) ELSE cid END AS cid
                , CASE WHEN bdate > GETDATE() -- set future birthdate to null
                THEN null
                ELSE bdate END AS bdate
              ,CASE WHEN upper(trim(gen)) in ('M','MALE') then 'Male' 
                    WHEN upper(trim(gen)) in ('F','FEMALE') then 'Female'
              ELSE 'n/a' END AS gen  -- Normalize gender values and handling unknown cases
        FROM bronze.erp_cust_az12

        SET @end_time = GETDATE()
		PRINT'>> LOAD DURATION: ' + CAST (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT'------------------'


        --Loading silver.erp_loc_a101
		SET @start_time = GETDATE()



        PRINT '>> Truncating Table : silver.erp_loc_a101'
        TRUNCATE TABLE silver.erp_loc_a101;
        PRINT '>> Inserting data into silver.erp_loc_a101'

        INSERT INTO silver.erp_loc_a101 (
          cid,
          cntry)
        SELECT  REPLACE(cid,'-','') AS cid -- Replaced invalid value
          ,CASE WHEN trim(cntry) = 'DE' THEN 'Germany'
                        WHEN trim(cntry) in ('USA','US') THEN 'United States'
                        WHEN trim(cntry) = '' or cntry is null THEN 'n/a'
                        ELSE trim(cntry) END AS cntry -- Normalize and handle missing or blank country codes
        FROM bronze.erp_loc_a101

        SET @end_time = GETDATE()
		PRINT'>> LOAD DURATION: ' + CAST (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT'------------------'


        --Loading silver.erp_px_cat_g1v2
		SET @start_time = GETDATE()


        PRINT '>> Truncating Table : silver.erp_px_cat_g1v2'
        TRUNCATE TABLE silver.erp_px_cat_g1v2;
        PRINT '>> Inserting data into silver.erp_px_cat_g1v2'

        INSERT INTO silver.erp_px_cat_g1v2(
                id
              ,cat
              ,subcat
              ,maintenance)

        SELECT id
              ,cat
              ,subcat
              ,maintenance
        FROM bronze.erp_px_cat_g1v2

        SET @end_time = GETDATE()
		PRINT'>> LOAD DURATION: ' + CAST (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT'------------------'



        SET @batch_end_time = GETDATE()
		PRINT'============================================'
		PRINT'Loading Silver Layer is Completed'
		PRINT'     - Total Load Duration : ' + CAST(DATEDIFF(second,@batch_start_time,@batch_end_time) AS NVARCHAR) + ' seconds'
		PRINT'============================================'

    END TRY
    BEGIN CATCH

        PRINT'==========================================';
		PRINT'ERROR OCCURED DURING LOADING SILVER LAYER';
		PRINT'==========================================';
		PRINT'Error Message' + ERROR_MESSAGE();
		PRINT'Error Number' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT'Error State' + CAST(ERROR_STATE() AS NVARCHAR);

    END CATCH
END
GO


