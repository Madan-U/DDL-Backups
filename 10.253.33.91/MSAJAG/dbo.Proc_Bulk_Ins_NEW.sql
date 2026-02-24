-- Object: PROCEDURE dbo.Proc_Bulk_Ins_NEW
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




create Proc [dbo].[Proc_Bulk_Ins_NEW] (@TableName varchar(100), @FileName varchar(200), @ParseString Varchar(2) = ',') AS 

Declare @strSql varchar(500)

Set @strSql = 'Truncate table ' + @TableName
Exec(@strSql)

IF @TABLENAME LIKE '%TBL_EXCHG_SCRIP_MAP_TMP%'
BEGIN

 PRINT @TableName
  PRINT @FileName
  PRINT @ParseString
 
	Set @strSql = 'Bulk insert  ' + @TableName + ' from ''' + @FileName  + '''  with ( FIELDTERMINATOR = ''' + @ParseString + ''', ROWTERMINATOR = ''\n'',FIRSTROW=2 )'
	Exec(@strSql)
	PRINT 'Y'
	PRINT (@strSql)
END
ELSE
BEGIN
	Set @strSql = 'Bulk insert  ' + @TableName + ' from ''' + @FileName  + '''  with ( FIELDTERMINATOR = ''' + @ParseString + ''', ROWTERMINATOR = ''\n'' )'
	Exec(@strSql)
	PRINT (@strSql)
END

GO
