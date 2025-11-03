select * 
from bronze.erp_loc_a101
where cid not in (select cid from silver.crm_cust_info)

------------------------
insert into silver.erp_loc_a101 (
[cid],
[cntry]
)
select
cid,
case
	when upper(trim(cntry)) = 'DE' then 'Germany'
	when upper(trim(cntry)) in ('USA','US') then 'United States'
	when upper(trim(cntry)) ='' or upper(trim(cntry)) is null then 'n/a'
	else trim(cntry)
end cntry
from bronze.erp_loc_a101





