alter proc Usp_Core_TransferFromFile
@TableName varchar(100),@FullPathDataFile varchar(250),@Features varchar(max)=''
as
begin
    begin try
	    --validate
	    if(len(@tableName)=0)
	    begin
	        raiserror('Table is not find',16,1)
	    end
		if(LEN(@fullPathDataFile)=0)
		begin
		    raiserror('Path Address for data file is not define',16,1)
		end
		if not exists (select top 1 1 from sys.tables where name = @TableName)
		begin
		    declare @DbName varchar(100) = Db_Name()
		    raiserror('The %s table is not exists in current database(%s)',16,1,@TableName,@DbName)
		end
		--end validate
		--create Main Script
		declare @CoreScript varchar(max),@FeaturesForScript varchar(max)=''
		--create Features for Core Script
		if LEN(@Features)>0
		begin   
			set @FeaturesForScript += isnull(',FIELDTERMINATOR = ''' + JSON_VALUE(@Features,'$.fieldterminator') + '''','')
			set @FeaturesForScript += ISNULL(',ROWTERMINATOR = ''' + JSON_VALUE(@features,'$.rowterminator') + '''','')
			set @FeaturesForScript += ISNULL(',FORMAT= '''+ JSON_VALUE(@Features,'$.format')+'''','')
			set @FeaturesForScript += isnull(',KEEPIDENTITY' + json_value(@features,'$.keepidentitu'),'')
			set @FeaturesForScript += ISNULL(',KEEPNULLS' + JSON_VALUE(@Features,'$.keepnulls'),'')
			if len(@FeaturesForScript)>0
			    set @FeaturesForScript = ' WITH ( ' + SUBSTRING(@featuresForScript,2,len(@featuresForScript)) + ')'
		end
		-- end create Features
		--create Core Script
		set @CoreScript = 'BULK INSERT ' + @TableName + ' FROM ''' + @FullPathDataFile+ '''' + @FeaturesForScript
		--end Core Script
		--end Main Script
		--select @CoreScript
		exec(@CoreScript)
		
	end try
	begin catch
	    declare @errorMessage varchar(250)
		set @errorMessage = ERROR_MESSAGE()
	    raiserror(@errorMessage,16,1)
	end catch
end