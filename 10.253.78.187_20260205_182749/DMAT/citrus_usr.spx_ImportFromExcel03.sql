-- Object: PROCEDURE citrus_usr.spx_ImportFromExcel03
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[spx_ImportFromExcel03]

    @SheetName varchar(20),

    @FilePath varchar(100),

    @HDR varchar(3),

    @TableName varchar(50)

AS

BEGIN

    DECLARE @SQL nvarchar(1000)

           

    IF OBJECT_ID (@TableName,'U') IS NOT NULL

      SET @SQL = 'INSERT INTO ' + @TableName + ' SELECT * FROM OPENDATASOURCE'

    ELSE

      SET @SQL = 'SELECT * INTO ' + @TableName + ' FROM OPENDATASOURCE'

 

    SET @SQL = @SQL + '(''Microsoft.Jet.OLEDB.4.0'',''Data Source='

    SET @SQL = @SQL + @FilePath + ';Extended Properties=''''Excel 8.0;HDR='

    SET @SQL = @SQL + @HDR + ''''''')...['

    SET @SQL = @SQL + @SheetName + ']'

    EXEC sp_executesql @SQL

END

GO
