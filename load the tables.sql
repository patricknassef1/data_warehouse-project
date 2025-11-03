create or alter procedure bronze.load_bronze as
begin
	declare @start_time datetime , @end_time datetime
	begin try
		print 'loading the bronze layer'
		set @start_time = getdate();
		truncate table [bronze].[crm_cust_info];
		bulk insert [bronze].[crm_cust_info]
		from 'D:\Dataware House\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock 
		);
		set @end_time = getdate();
		print '>> load the duration: ' + cast(datediff(second,@start_time,@end_time) as varchar) + 'seconds'
		truncate table [bronze].[crm_prd_info];
		bulk insert [bronze].[crm_prd_info]
		from 'D:\Dataware House\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with (
			firstrow = 2,
			fieldterminator= ',',
			tablock
		);

		truncate table [bronze].[crm_sales_details]
		bulk insert [bronze].[crm_sales_details]
		from 'D:\Dataware House\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		with(
			firstrow = 2,
			fieldterminator=',',
			tablock
			);

		truncate table [bronze].[erp_cust_az12]
		bulk insert [bronze].[erp_cust_az12]
		from 'D:\Dataware House\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		with(
			firstrow=2,
			fieldterminator = ',',
			tablock)


		truncate table [bronze].[erp_loc_a101]
		bulk insert [bronze].[erp_loc_a101]
		from 'D:\Dataware House\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		with(firstrow=2,
			fieldterminator=',',
			tablock);

		truncate table [bronze].[erp_px_cat_g1v2]
		bulk insert [bronze].[erp_px_cat_g1v2]
		from 'D:\Dataware House\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		with (firstrow=2,
			fieldterminator=',',
			tablock)
	End try
	begin catch 
	print 'error while loading the data'
	print 'the error is ' + error_message()
	print 'the error number ' + cast(error_number()as varchar)
	print cast(error_state()as varchar)
	end catch
end