/*
  View: gold.dim_products
  
  Description:
  This view creates the Product Dimension in the Gold layer.
  It combines product information from CRM with category data from ERP
  to produce a clean, analytics-ready product dataset.
  
  A surrogate key (product_key) is generated and only the current
  active products are included (where prd_end_dt is NULL).
*/

create view gold.dim_products as 
select 
	ROW_NUMBER() over(order by pn.prd_start_dt , pn.prd_key ) as product_key,
	pn.prd_id as product_id,
	pn.prd_key as product_number,
	pn.prd_nm as product_name,
	pn.cat_id as category_id,
	pc.cat as category ,
	pc.subcat as subcategory, 
	pc.maintenance ,
	pn.prd_cost as cost ,
	pn.prd_line as product_line , 
	pn.prd_start_dt as start_date
	
from silver.crm_prd_info pn
left join silver.erp_px_cat_g1v2 pc
on pn.cat_id = pc.id
where prd_end_dt is null
