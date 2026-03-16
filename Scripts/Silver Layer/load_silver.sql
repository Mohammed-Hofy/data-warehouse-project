/*
  Procedure: silver.load_silver
  
  Description:
  Loads and transforms data from the Bronze layer into the Silver layer.
  This process performs data cleansing, standardization, and basic transformations.
  
  Key operations include:
  - Removing duplicates .
  - Trimming and standardizing text fields.
  - Converting data types (e.g., integers to dates).
  - Handling NULL and invalid values.
  - Deriving new columns (e.g., category id, corrected sales values).
  
  
  Usage Example:
      EXEC silver.load_silver;
*/




CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN

TRUNCATE TABLE silver.crm_cust_info;
with ranked_customers as
(
	select *,
	ROW_NUMBER() over (partition by cst_id  order by cst_create_date desc) as row_num
	from bronze.crm_cust_info
	WHERE cst_id IS NOT NULL
)


insert into silver.crm_cust_info
(
	cst_id ,
	cst_key,
	cst_firstname ,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date
)

select
	cst_id ,
	cst_key,
	trim(cst_firstname) as cst_firstname,
	trim(cst_lastname) as cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date
from ranked_customers
where row_num = 1



TRUNCATE TABLE silver.crm_prd_info
insert into silver.crm_prd_info
(
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt

)

select
	prd_id,
	replace(substring(prd_key,1,5) ,'-','_' )as cat_id,
	substring(prd_key,7,len(prd_key)) as prd_key,
	prd_nm,
	isnull(prd_cost,0) as prd_cost,
	case when upper(prd_line) = 'M' then 'Mountain'
		 when upper(prd_line) = 'R' then 'Road'
		 when upper(prd_line) = 'S' then 'Other sales'
		 when upper(prd_line) = 'T' then 'Touring'
		 else 'n/a'
	end as prd_line ,
	cast (prd_start_dt as date) as prd_start_dt,
	cast(LEAD(prd_end_dt) over (partition by prd_key order by prd_start_dt)as date) as prd_end_dt
from bronze.crm_prd_info




TRUNCATE TABLE silver.crm_sales_details
insert into silver.crm_sales_details(
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price

)

select
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	case when  sls_order_dt <=0  or len(sls_order_dt) != 8  then null
	else  cast(cast(sls_order_dt as varchar) as date)
	end  as sls_order_dt ,

	case when  sls_ship_dt <=0  or len(sls_ship_dt) != 8  then null
	else  cast(cast(sls_ship_dt as varchar) as date)
	end  as sls_ship_dt ,

	case when  sls_due_dt <=0  or len(sls_due_dt) != 8  then null
	else  cast(cast(sls_due_dt as varchar) as date)
	end  as sls_due_dt ,
	case when  sls_sales is null or sls_sales <=0 or sls_sales !=  sls_quantity * abs(sls_price)
		 then sls_quantity * abs(sls_price)
		 else sls_sales
	end as sls_sales,
	sls_quantity,
	case when sls_price is null or sls_price <=0
		then  sls_sales /  nullif(sls_quantity,0)
		else sls_price
	end as sls_price

from bronze.crm_sales_details







TRUNCATE TABLE silver.erp_CUST_AZ12
insert into silver.erp_CUST_AZ12(
	CID,
	BDATE,
	GEN
)

select
	case when CID Like  'NAS%' then substring(CID , 4 , len(cid))
	     else CID
	end as CID ,
	case when  BDATE > GETDATE() then null
		 else BDATE
	end as BDATE ,
	case when upper(trim(gen)) in ('M','MALE') then 'Male'
		 when upper(trim(gen)) in ('F','FEMALE') then 'Female'
		 else 'N/A'
		 end as GEN
from bronze.erp_cust_az12


TRUNCATE TABLE silver.erp_LOC_A101
insert into silver.erp_LOC_A101(
	CID ,
	CNTRY
)
select
	 REPLACE(CID,'-' , '') as CID ,
	 case when trim(CNTRY) = 'DE' then 'Germany'
		  when trim(CNTRY) in ('US' , 'USA') then 'United States'
		  when trim(CNTRY) is null or trim(CNTRY) = '' then 'N/A'
		  else trim(CNTRY)
	 end as CNTRY
from bronze.erp_LOC_A101


TRUNCATE TABLE silver.erp_PX_CAT_G1V2
insert into silver.erp_PX_CAT_G1V2
(
	id,
	cat,
	subcat,
	maintenance
)

select
	id,
	cat,
	subcat,
	maintenance
from bronze.erp_PX_CAT_G1V2

end
