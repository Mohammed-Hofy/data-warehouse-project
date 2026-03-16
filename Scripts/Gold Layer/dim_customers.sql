/*
  View: gold.dim_customers
  
  Description:
  This view creates the Customer Dimension in the Gold layer.
  It integrates customer data from CRM and ERP sources and provides
  a clean, business-ready customer dataset.
  
  The view generates a surrogate key (customer_key) and combines
  customer personal information, gender, country, and birth date
  to support analytics and reporting.
*/

create view gold.dim_customers as 
select 
	ROW_NUMBER() over (order by cst_id) as customer_key,
	ci.cst_id as customer_id,
	ci.cst_key as customer_number,
	ci.cst_firstname as first_name ,
	ci.cst_lastname as last_name ,
	la.CNTRY as country , 
	ci.cst_marital_status as marital_status ,
	CASE
		when ca.GEN is null then 'N/A'
		WHEN ci.cst_gndr IS NULL THEN ca.gen
		WHEN ci.cst_gndr IN ('F','Female') THEN 'Female'
		WHEN ci.cst_gndr IN ('M','Male') THEN 'Male'
	END AS gender ,
	ca.BDATE as birth_date , 
	ci.cst_create_date as create_date
	
	
from silver.crm_cust_info ci
left join silver.erp_CUST_AZ12 ca
on		   ci.cst_key = ca.CID
left join silver.erp_LOC_A101 la
on			ci.cst_key = la.CID
