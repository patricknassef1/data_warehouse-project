insert into silver.erp_cust_az12(
[cid],
[bdate],
[gen]
)
select 
case
	when cid like 'NAS%' then SUBSTRING(cid,4,len(cid))
	else cid
	
end cid,
 case 
	when bdate > GETDATE() then null
	else bdate
end bdate,
case
	when upper(trim(gen)) in ('F','FEMALE') then 'Female'
	when upper(trim(gen)) in ('M', 'MALE') then 'Male'
	else 'n/a'
end gen
from bronze.erp_cust_az12
