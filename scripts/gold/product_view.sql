create view gold.dim_products as 
	SELECT
		ROW_NUMBER() over(order by prd_key ,prd_start_dt ) as product_key,
		pn.prd_id as product_id,
		pn.cat_id as category_id,
		pn.prd_nm as product_number,
		pn.prd_cost as product_cost,
		pn.prd_line as product_line,
		pn.prd_start_dt as product_start_date,
		pc.cat as category,
		pc.subcat as sub_category,
		pc.maintenance 
	FROM silver.crm_prd_info pn
	left join silver.erp_px_cat_g1v2 pc
	on pn.cat_id = pc.id
	where prd_end_dt is null
