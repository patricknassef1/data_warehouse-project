select *
from bronze.crm_prd_info

--checking for the dublicates 
-- there is no dublicates in the prd_id
select prd_id,
count(prd_id)
from [silver].[crm_prd_info]
group by prd_id
having count(prd_id) > 1 or prd_id is null

--splitting the prd_key 
select * from bronze.erp_px_cat_g1v2
select * from bronze.crm_sales_details

select
[prd_id],
[prd_key],
replace(SUBSTRING(prd_key,1,5),'-','_') as cat_id,
SUBSTRING(prd_key,7,len(prd_key)) as prd_key,
[prd_nm],
[prd_cost],
[prd_line],
[prd_start_dt],
[prd_end_dt]
from bronze.crm_prd_info

--checking unwanted spaces in the prd_nm
--no result 
select prd_nm
from [silver].[crm_prd_info]
where prd_nm != trim(prd_nm)

--checking in the cost negative
--checking for the nulls (replaced with 0)
select
isnull([prd_cost],0) as prd_cost
from [silver].[crm_prd_info]
where prd_cost < 0 or prd_cost is null



--product line Normalization 

select
case
	when UPPER(trim(prd_line)) = 'M' then 'Mountain'
	when UPPER(trim(prd_line)) = 'R' then 'Road'
	when UPPER(trim(prd_line)) = 'S' then 'Other Sales'
	when UPPER(trim(prd_line)) = 'T' then 'Toruing'
	else 'n/a'
end
prd_line
from bronze.crm_prd_info


-- start and end dates
select *,
prd_start_dt,
prd_end_dt,
lead(prd_start_dt) over(partition by prd_key order by prd_start_dt)-1 as prd_end_dt_test
from bronze.crm_prd_info
where prd_key in ('AC-HE-HL-U509-R','AC-HE-HL-U509')

