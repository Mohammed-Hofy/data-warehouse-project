/*
  Procedure: bronze.load_bronze
  
  Description:
  Loads raw data from CSV source files (CRM and ERP systems) into the Bronze layer tables.
  Each table is truncated before loading to ensure a fresh full reload of the data.
  
  The Bronze layer stores raw, untransformed data exactly as received from source systems.
  This layer acts as the staging area before data cleaning and transformation in the Silver layer.
  
  Usage Example:
      EXEC bronze.load_bronze;
*/


create or alter procedure bronze.load_bronze as
begin
print 'Loading bronze layer '
truncate table bronze.crm_cust_info
bulk insert bronze.crm_cust_info
from '/home/mohammed/Desktop/Learn/Data Eng/Data Warehouse/Data - braa/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
with(
firstrow = 2,
fieldterminator = ',',
tablock
);

truncate table bronze.crm_prd_info
bulk insert bronze.crm_prd_info
from '/home/mohammed/Desktop/Learn/Data Eng/Data Warehouse/Data - braa/sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
with(
firstrow = 2,
fieldterminator = ',',
tablock
);


truncate table bronze.crm_sales_details
bulk insert bronze.crm_sales_details
from '/home/mohammed/Desktop/Learn/Data Eng/Data Warehouse/Data - braa/sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
with(
firstrow = 2,
fieldterminator = ',',
tablock
);

truncate table bronze.erp_CUST_AZ12
bulk insert bronze.erp_CUST_AZ12
from '/home/mohammed/Desktop/Learn/Data Eng/Data Warehouse/Data - braa/sql-data-warehouse-project/datasets/source_erp\CUST_AZ12.csv'
with(
firstrow = 2,
fieldterminator = ',',
tablock
);

truncate table  bronze.erp_LOC_A101
bulk insert bronze.erp_LOC_A101
from '/home/mohammed/Desktop/Learn/Data Eng/Data Warehouse/Data - braa/sql-data-warehouse-project/datasets/source_erp\LOC_A101.csv'
with(
firstrow = 2,
fieldterminator = ',',
tablock
);

truncate table  bronze.erp_PX_CAT_G1V2
bulk insert bronze.erp_PX_CAT_G1V2
from '/home/mohammed/Desktop/Learn/Data Eng/Data Warehouse/Data - braa/sql-data-warehouse-project/datasets/source_erp\PX_CAT_G1V2.csv'
with(
firstrow = 2,
fieldterminator = ',',
tablock
);
end
