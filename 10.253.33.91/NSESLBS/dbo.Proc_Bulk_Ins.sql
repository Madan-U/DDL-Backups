-- Object: PROCEDURE dbo.Proc_Bulk_Ins
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Proc_Bulk_Ins (@TableName varchar(100), @FileName varchar(200), @ParseString Varchar(2) = ',') AS 

Declare @strSql varchar(500)

Set @strSql = 'Truncate table ' + @TableName
Exec(@strSql)

Set @strSql = 'Bulk insert  ' + @TableName + ' from ''' + @FileName  + '''  with ( FIELDTERMINATOR = ''' + @ParseString + ''', ROWTERMINATOR = ''\n'' )'
Exec(@strSql)

GO
