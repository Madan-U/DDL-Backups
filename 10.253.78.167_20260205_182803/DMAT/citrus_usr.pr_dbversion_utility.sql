-- Object: PROCEDURE citrus_usr.pr_dbversion_utility
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

/*

LEVEL 1 : missing procedure , function , views, triggers
EXEC pr_dbversion_utility @pa_id = 1,@pa_server_name = '',@pa_owner = 'dbo',@pa_SRC_db_name = 'DMAT_VERSION',@pa_trg_db_name= 'Sajag_Dmat',@pa_target_path = 'C:\Version_Gap_remain\'

LEVEL 2 : missing tables 
EXEC pr_dbversion_utility @pa_id = 2,@pa_server_name = '',@pa_owner = 'citrus_usr',@pa_SRC_db_name = 'DMAT_VERSION',@pa_trg_db_name= 'Sajag_Dmat',@pa_target_path = 'C:\Version_Gap_remain\'

LEVEL 3 : missing columns 
EXEC pr_dbversion_utility @pa_id = 3,@pa_server_name = '',@pa_owner = 'dbo',@pa_SRC_db_name = 'DMAT_VERSION',@pa_trg_db_name= 'Sajag_Dmat',@pa_target_path = 'C:\Version_Gap\'

LEVEL 4 : changed columns(datatype, size)
EXEC pr_dbversion_utility @pa_id = 4,@pa_server_name = '',@pa_owner = 'dbo',@pa_SRC_db_name = 'DMAT_VERSION',@pa_trg_db_name= 'Sajag_Dmat',@pa_target_path = 'C:\Version_Gap\'


COMMENTS : 
1.Target path Working excluding table script , table script copy manually from output window. 
2.All Parameter are mandatory excluding @pa_server_name make it black if both database on same server.
 


*/
CREATE procedure [citrus_usr].[pr_dbversion_utility](@pa_id numeric,@pa_server_name varchar(1000),@pa_owner varchar(500),@pa_SRC_db_name varchar(1000),@pa_trg_db_name varchar(1000),@pa_target_path varchar(8000))
as
begin

SET NOCOUNT ON


DECLARE @pathProc VARCHAR(255),
				@pathFunc VARCHAR(255),
				@pathTrig VARCHAR(255),
				@pathView VARCHAR(255),
				@cmd NVARCHAR(4000),
				@pathBase VARCHAR(256),
                @pathtable varchar(255),
                @paaltercolscript varchar(255), 
                @paaddcolscript varchar(255) 

		SELECT  @pathBase = @pa_target_path,
				@pathProc = @pathBase + 'Stored Procedures\',
				@pathFunc = @pathBase + 'Functions\',
				@pathTrig = @pathBase + 'Triggers\',
				@pathView = @pathBase + 'Views\',
                @pathtable = @pathBase + 'Table\',
                @paaltercolscript = @pathBase + 'AltercolScript\',
                @paaddcolscript  = @pathBase + 'AddcolScript\'

		SET     @cmd = 'md "' + @pathProc + '"'
		EXEC    master..xp_cmdshell @cmd, no_output

		SET     @cmd = 'md "' + @pathFunc + '"'
		EXEC    master..xp_cmdshell @cmd, no_output

		SET     @cmd = 'md "' + @pathTrig + '"'
		EXEC    master..xp_cmdshell @cmd, no_output

		SET     @cmd = 'md "' + @pathView + '"'
		EXEC    master..xp_cmdshell @cmd, no_output

        SET     @cmd = 'md "' + @pathtable + '"'
		EXEC    master..xp_cmdshell @cmd, no_output

        SET     @cmd = 'md "' + @paaltercolscript + '"'
		EXEC    master..xp_cmdshell @cmd, no_output

        SET     @cmd = 'md "' + @paaddcolscript + '"'
		EXEC    master..xp_cmdshell @cmd, no_output


     if @pa_id = 1
     begin

		

		/*******************************************************************************
		 Stage all existing relevant code
		*******************************************************************************/

		CREATE TABLE  TempDB..CodeOut
					  (
							 spID INT,
							 [uID] INT,
							 colID INT,
							 codeText NTEXT,
							 isProc TINYINT,
							 isFunc TINYINT,
							 isTrig TINYINT,
							 isView TINYINT
					  )

        declare @l_sql1 varchar(8000)
        
		set @l_sql1 = 'INSERT        TempDB..CodeOut'
		set @l_sql1 = @l_sql1 + '			  ('
 		set @l_sql1 = @l_sql1 + '					 spID,'
		set @l_sql1 = @l_sql1 + '					 [uID],'
		set @l_sql1 = @l_sql1 + '					 colID,'
		set @l_sql1 = @l_sql1 + '					 codeText,'
		set @l_sql1 = @l_sql1 + '					 isProc,'
		set @l_sql1 = @l_sql1 + '					 isFunc,'
		set @l_sql1 = @l_sql1 + '					 isTrig,'
		set @l_sql1 = @l_sql1 + '					 isView'
		set @l_sql1 = @l_sql1 + '			  ) '
		set @l_sql1 = @l_sql1 + 'SELECT        so.id as spID, '
		set @l_sql1 = @l_sql1 + '			  so.[uid] AS [uID], '
		set @l_sql1 = @l_sql1 + '			  sc.colid AS colID, '
		set @l_sql1 = @l_sql1 + '			  sc.text AS codeText, ' 
		set @l_sql1 = @l_sql1 + '			  objectproperty(so.id, ''IsProcedure'') AS isProc, ' 
		set @l_sql1 = @l_sql1 + '			  objectproperty(so.id, ''IsScalarFunction'') | objectproperty(so.id, ''IsTableFunction'') AS isFunc, ' 
		set @l_sql1 = @l_sql1 + '			  objectproperty(so.id, ''IsTrigger'') AS isTrig, '
		set @l_sql1 = @l_sql1 + '			  objectproperty(so.id, ''IsView'')   AS isView '
		set @l_sql1 = @l_sql1 + ' FROM          syscomments AS sc '
		set @l_sql1 = @l_sql1 + ' INNER JOIN    sysobjects  AS so ON so.id = sc.id ' 
		set @l_sql1 = @l_sql1 + ' WHERE         objectproperty(so.id, ''IsEncrypted'') = 0 '
		set @l_sql1 = @l_sql1 + '			  AND objectproperty(so.id, ''IsMSShipped'') = 0 '
		set @l_sql1 = @l_sql1 + '			  AND objectproperty(so.id, ''IsExecuted'') = 1 ' 
		set @l_sql1 = @l_sql1 + ' and   not exists (select so_dst.name from  ' 
        set @l_sql1 = @l_sql1 + case when @pa_server_name <> '' then @pa_server_name+'.' else '' end + @pa_trg_db_name +'.'+ 'dbo.sysobjects  as so_dst where so_dst.name = so.name) ' 
        set @l_sql1 = @l_sql1 + 'ORDER BY      so.id, ' 
		set @l_sql1 = @l_sql1 +  'sc.colid '


exec(@L_SQL1)
		CREATE UNIQUE CLUSTERED INDEX IX_Code ON TempDB..CodeOut(spID, colID)

		SELECT COUNT(DISTINCT CASE WHEN isProc = 1 THEN spID ELSE NULL END) AS isProc,
			   COUNT(DISTINCT CASE WHEN isFunc = 1 THEN spID ELSE NULL END) AS isFunc,
			   COUNT(DISTINCT CASE WHEN isTrig = 1 THEN spID ELSE NULL END) AS isTrig,
			   COUNT(DISTINCT CASE WHEN isView = 1 THEN spID ELSE NULL END) AS isView
		FROM   TempDB..CodeOut

		/******************************************************************************
		 Initialize code variables
		*******************************************************************************/

		DECLARE @SQL NVARCHAR(4000),
				@spID INT,
				@fileName NVARCHAR(512),
				@objectName SYSNAME,
				@header NVARCHAR(1000),
				@static NVARCHAR(1000),
				@type NVARCHAR(20),
				@owner SYSNAME

--		SET    @static = 'USE ' + 'DMAT '
--					  + CHAR(13) + CHAR(10) + 'GO'
--					  + CHAR(13) + CHAR(10) + 'IF OBJECT_ID(''$owner.$object'') IS NOT NULL'
--					  + CHAR(13) + CHAR(10) + CHAR(9) + 'BEGIN'
--					  + CHAR(13) + CHAR(10) + CHAR(9) + CHAR(9) + 'PRINT ''DROP $type $owner.$object'''
--					  + CHAR(13) + CHAR(10) + CHAR(9) + CHAR(9) + 'DROP $type $owner.$object'
--					  + CHAR(13) + CHAR(10) + CHAR(9) + 'END'
--					  + CHAR(13) + CHAR(10) + 'PRINT ''CREATE $type $owner.$object'''
--					  + CHAR(13) + CHAR(10) + 'GO'
--					  + CHAR(13) + CHAR(10) 

		SELECT  @spID = MIN(spID)
		FROM    TempDB..CodeOut

		/*******************************************************************************
		 Loop all code parts
		*******************************************************************************/

		WHILE @spID IS NOT NULL
			   BEGIN
					  SELECT TOP 1  @objectName = OBJECT_NAME(@spID),
									@fileName =  CASE 1
													   WHEN w.isProc THEN @pathProc
													   WHEN w.isFunc THEN @pathFunc
													   WHEN w.isTrig THEN @pathTrig
													   WHEN w.isView THEN @pathView
												 END + COALESCE(su.name + '.', '') + PARSENAME(@objectName, 1) + '.sql',
								   @type =       CASE 1
												 WHEN isProc THEN 'PROCEDURE'
												 WHEN isFunc THEN 'FUNCTION'
												 WHEN isTrig THEN 'TRIGGER'
												 WHEN isView THEN 'VIEW'
										  END,
								   @owner = QUOTENAME(su.name)
					  FROM         TempDB..CodeOut AS w
					  INNER JOIN   sysusers AS su ON su.uid = w.uid
					  WHERE        w.spID = @spID

					  SELECT  @header = REPLACE(@static, '$type', @type),
							  @header = REPLACE(@header, '$owner', @owner),
							  @header = REPLACE(@header, '$object', QUOTENAME(@objectName))

					  INSERT  TempDB..CodeOut
							  (
								   spID,
								   colID,
								   codeText
							  )
					  SELECT  @spID,
							  0,
							  @header

print @header

					  SELECT  @SQL = 'SELECT codeText FROM TempDB..CodeOut WHERE spID = ' + CAST(@spID AS NVARCHAR(12)) + ' ORDER BY colID',
							  @cmd = 'BCP "' + @SQL + '" queryout "' + @filename + '" -S' + @@SERVERNAME + ' -T -CACP -w -t"" -r""'

					  EXEC    master..xp_cmdshell @cmd, no_output

					  SELECT  @spID = MIN(spID)
					  FROM    TempDB..CodeOut
					  WHERE   spID > @spID
			   END

		/*******************************************************************************
		 Clean up
		*******************************************************************************/
		DROP TABLE    TempDB..CodeOut
   end  

   if @pa_id = 2
   begin

        drop table  ##temp_missing_table

        create table ##temp_missing_table(tab_name varchar(1000))

        declare @l_sql_missin_tab varchar(8000)
               ,@l_table_name varchar(1000)
        select @l_sql_missin_tab  = 'insert into ##temp_missing_table select src.name from sysobjects src where not exists (select dst.name from ' + case when @pa_server_name <> '' then @pa_server_name+'.' else '' end + @pa_trg_db_name +'.'+ 'dbo.sysobjects dst where dst.name = src.name) and xtype = ''U'''

        exec(@l_sql_missin_tab)

if exists(select name from sysobjects where name = 'Temp_table_script')
drop table Temp_table_script

create table Temp_table_script(script varchar(8000))


        declare @c_cursor cursor 
        SET @c_cursor =  CURSOR fast_forward FOR            
        select * from ##temp_missing_table

			OPEN @c_cursor            
			FETCH NEXT FROM @c_cursor   
			into @l_table_name 

			WHILE @@fetch_status = 0            
			BEGIN            
			-- 

set @cmd = ''
					declare @sql_tab varchar(8000),@col varchar(8000),@tablename varchar(50)

					select @tablename = @l_table_name

					SELECT @col= COALESCE(@col + ', ', '') +'['+COLUMN_NAME+']'+char(9)+data_type+case when data_type in('datetime','int','bigint','smallint','integer','float','money') then '' else '(' end 
					+ case when data_type  <> 'datetime' and data_type  = 'numeric' then convert(varchar,numeric_precision) + ','+ convert(varchar,numeric_scale ) 
					when  data_type in('datetime','int','bigint','smallint','integer','float','money')  then ''
					else  convert(varchar,isnull(abs(character_maximum_length),''))  end + case when data_type in('datetime','money','int','bigint','smallint','integer','float') then '' else ')' end  +char(13) FROM INFORMATION_SCHEMA.COLUMNS where table_name =@tablename

 

  

					select @sql_tab = 'insert into Temp_table_script select ''CREATE TABLE '+char(9)+@pa_owner+'.'+@tablename+'('

					select @sql_tab=@sql_tab+ case when left(@col,1)=',' then substring(@col,2,len(@col)) else @col end

					select @sql_tab = @sql_tab+char(13)+') '''

print @sql_tab
			        exec(@sql_tab)
			        
                    set @sql_tab = ' " select * from '+ @pa_SRC_db_name +'.DBO.Temp_table_script " '
                    
         	        set @cmd = 'bcp ' + @sql_tab + ' queryout ' + @pathtable + 'MISSING_TABLE_SCRIPT.sql' + ' -c -q -t, -T -S' + @@servername       
    
                    EXEC    master..xp_cmdshell @cmd, no_output
             set @col = ''
			FETCH NEXT FROM @c_cursor   
			into @l_table_name 

			end 
		
   end
   if @pa_id = 3
   begin

set @cmd = ''
        declare @l_sql_missing_column varchar(8000)

        if exists(select name from sysobjects where xtype ='v' and name = 'v2_sql_missing_column' )
        drop view v2_sql_missing_column 
  
        set @l_sql_missing_column  =   'create view v2_sql_missing_column as SELECT ''ALTER TABLE ''+  SRC_TAB.NAME + '' ADD  ''  + src_col.name + '' '' + src_type.name  ' 
		set @l_sql_missing_column  =  @l_sql_missing_column + ' + CASE  WHEN  src_type.name in (''datetime'',''numeric'',''bigint'',''smallint'',''int'',''integer'',''float'',''money'') THEN '''' ELSE ''('' END + case when src_type.name in( ''datetime'',''numeric'',''bigint'',''smallint'',''int'',''integer'',''float'',,''money'') THEN '''' '
		set @l_sql_missing_column  =  @l_sql_missing_column + '	when src_type.name = ''numeric'' then CONVERT(VARCHAR,src_col.xprec) +'','' +CONVERT(VARCHAR,src_col.xscale)  else CONVERT(VARCHAR,src_col.length) end+CASE  WHEN  src_type.name in (''datetime'',''numeric'',''bigint'',''smallint'',''int'',''integer'',''money'',''float'') THEN '''' ELSE '') '' END  + ''  '''
		set @l_sql_missing_column  =  @l_sql_missing_column + '	as script FROM '
		set @l_sql_missing_column  =  @l_sql_missing_column + '	 dbo.sysobjects src_tab  '
		set @l_sql_missing_column  =  @l_sql_missing_column + '	, dbo.syscolumns src_col '
		set @l_sql_missing_column  =  @l_sql_missing_column + '	, dbo.systypes src_type '
		set @l_sql_missing_column  =  @l_sql_missing_column + '	WHERE src_tab.id = src_col.id  '
		set @l_sql_missing_column  =  @l_sql_missing_column + '	and src_type.xtype = src_col.xtype  '
		set @l_sql_missing_column  =  @l_sql_missing_column + '	AND src_tab.XTYPE =''U'' '
		set @l_sql_missing_column  =  @l_sql_missing_column + '	 AND EXISTS (SELECT DST_TAB.NAME FROM ' + case when @pa_server_name <> '' then @pa_server_name+'.' else '' end + @pa_trg_db_name +'.'+ 'dbo.sysobjects dst_tab WHERE src_tab.name = dst_tab.name ) '
		set @l_sql_missing_column  =  @l_sql_missing_column + ' AND NOT EXISTS (SELECT DST_TAB.NAME,DST_COL.NAME FROM ' + case when @pa_server_name <> '' then @pa_server_name+'.' else '' end + @pa_trg_db_name +'.'+ 'dbo.sysobjects  dst_tab , '   + case when @pa_server_name <> '' then @pa_server_name+'.' else '' end + @pa_trg_db_name +'.'+ 'dbo.syscolumns dst_col WHERE src_tab.name = dst_tab.name AND  src_col.name = dst_col.name) '


		print @l_sql_missing_column
        exec(@l_sql_missing_column)
        set @l_sql_missing_column = ' " select * from '+ @pa_SRC_db_name +'.DBO.v2_sql_missing_column" '

        set @cmd = 'bcp ' + @l_sql_missing_column + ' queryout ' + @paaddcolscript + 'MISSING_COLUMN_SCRIPT' + '.sql' + ' -c -q -t, -T -S' + @@servername       
    
        EXEC    master..xp_cmdshell @cmd, no_output

   end
   if @pa_id = 4
   begin

		set @cmd = ''

		declare @l_sql_chgdatatype_column varchar(8000)

    if exists(select name from sysobjects where xtype ='v' and name = 'v2_chgdatatype_column' )
        drop view v2_chgdatatype_column 

			set @l_sql_chgdatatype_column = ' create view v2_chgdatatype_column as select distinct  ''ALTER TABLE '' +  src_tab.name + '' ALTER COLUMN '' + src_col.name + '' '' + src_type.name '
			set @l_sql_chgdatatype_column = @l_sql_chgdatatype_column + ' + CASE  WHEN  src_type.name in (''datetime'',''numeric'',''bigint'',''smallint'',''int'',''integer'',''float'',''money'') THEN '''' ELSE ''('' END + case when src_type.name in( ''datetime'',''numeric'',''bigint'',''smallint'',''int'',''integer'',''float'',''money'') THEN '''' '
			set @l_sql_chgdatatype_column = @l_sql_chgdatatype_column + ' when src_type.name = ''numeric'' then CONVERT(VARCHAR,src_col.xprec) +'','' +CONVERT(VARCHAR,src_col.xscale)  else CONVERT(VARCHAR,src_col.length) end+CASE  WHEN  src_type.name in (''datetime'',''numeric'',''bigint'',''smallint'',''int'',''integer'',''float'',''money'') THEN '''' ELSE '')'' END + '' ''' 
			set @l_sql_chgdatatype_column = @l_sql_chgdatatype_column + ' as script  from dbo.sysobjects src_tab '
			set @l_sql_chgdatatype_column = @l_sql_chgdatatype_column + ' , ' + case when @pa_server_name <> '' then @pa_server_name+'.' else '' end + @pa_trg_db_name +'.'+ 'dbo.sysobjects  dst_tab '
			set @l_sql_chgdatatype_column = @l_sql_chgdatatype_column + ' ,  dbo.syscolumns src_col '
			set @l_sql_chgdatatype_column = @l_sql_chgdatatype_column + ' , '  + case when @pa_server_name <> '' then @pa_server_name+'.' else '' end + @pa_trg_db_name +'.'+ 'dbo.syscolumns dst_col '
			set @l_sql_chgdatatype_column = @l_sql_chgdatatype_column + ' , dmat_version.dbo.systypes src_type  '
			set @l_sql_chgdatatype_column = @l_sql_chgdatatype_column + ' , '  + case when @pa_server_name <> '' then @pa_server_name+'.' else '' end + @pa_trg_db_name +'.'+ 'dbo.systypes dst_type  '
			set @l_sql_chgdatatype_column = @l_sql_chgdatatype_column + ' where src_tab.name = dst_tab.name  '
			set @l_sql_chgdatatype_column = @l_sql_chgdatatype_column + ' and src_tab.id = src_col.id '
			set @l_sql_chgdatatype_column = @l_sql_chgdatatype_column + ' and dst_tab.id = dst_col.id '
			set @l_sql_chgdatatype_column = @l_sql_chgdatatype_column + ' and src_col.name = dst_col.name '
			set @l_sql_chgdatatype_column = @l_sql_chgdatatype_column + ' and src_type.xtype = src_col.xtype '
			set @l_sql_chgdatatype_column = @l_sql_chgdatatype_column + ' and dst_type.xtype = dst_col.xtype '
			set @l_sql_chgdatatype_column = @l_sql_chgdatatype_column + ' and (src_col.xtype <> dst_col.xtype or src_col.length <> dst_col.length) '
			set @l_sql_chgdatatype_column = @l_sql_chgdatatype_column + ' AND src_tab.XTYPE =''U'' '
		   
		    print @l_sql_chgdatatype_column
		    exec(@l_sql_chgdatatype_column )
            set @l_sql_chgdatatype_column = ' "select * from '+ @pa_SRC_db_name +'.DBO.v2_chgdatatype_column " '

          set @cmd = 'BCP ' + @l_sql_chgdatatype_column + ' queryout ' + @paaltercolscript + 'ALTER_COLUMN_SCRIPT' + '.sql' + ' -c -q -t, -T -S' + @@servername       
         
          EXEC    master..xp_cmdshell @cmd, no_output

   end



end

GO
