/*
  View: gold.fact_sales
  
  Description:
  This view creates the Sales Fact table in the Gold layer.
  It combines sales transaction data with product and customer
  dimensions to build a star schema for analytics.
  
  The fact table stores measurable metrics such as sales, quantity,
  and price, and links them to the related product and customer keys.
*/


create view gold.fact_sales as 
select 
	sd.sls_ord_num  as order_number,
	pr.product_key ,
	cu.customer_id,
	sd.sls_order_dt as order_date,
	sd.sls_ship_dt as shipping_date,
	sd.sls_due_dt as due_date,
	sd.sls_sales as sales,
	sd.sls_quantity as quantity,
	sd.sls_price as  price

from silver.crm_sales_details sd
left join gold.dim_products pr
on sd.sls_prd_key = pr.product_number
left join gold.dim_customers cu
on sd.sls_cust_id =  cu.customer_id
