truncate table silver.crm_prd_info


insert into [silver].[crm_prd_info](
[prd_id],
[cat_id],
[prd_key],
[prd_nm],
[prd_cost],
[prd_line],
[prd_start_dt],
[prd_end_dt]
)
select
[prd_id],
replace(SUBSTRING(prd_key,1,5),'-','_') as cat_id, --derived new column
SUBSTRING(prd_key,7,len(prd_key)) as prd_key, --derived new column
[prd_nm],
isnull([prd_cost],0) as prd_cost, --handing missing data 
case
	when UPPER(trim(prd_line)) = 'M' then 'Mountain'
	when UPPER(trim(prd_line)) = 'R' then 'Road'
	when UPPER(trim(prd_line)) = 'S' then 'Other Sales'
	when UPPER(trim(prd_line)) = 'T' then 'Toruing'
	else 'n/a'
end
prd_line,          -- data normalization 
cast([prd_start_dt]as date) prd_start_dt,       -- data transformation 
cast( 
lead(prd_start_dt) over(partition by prd_key order by cast(prd_start_dt as date))-1 as date 
) as prd_end_dt -- data enrichment (adding new relevent data to the data set) 
from bronze.crm_prd_info
