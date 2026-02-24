-- Object: PROCEDURE dbo.SP_API_BULK_INSERT
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROCEDURE SP_API_BULK_INSERT
 (
  @FILEPATH VARCHAR(200),
  @FROM VARCHAR(1)
 )
 AS
 BEGIN 
	Declare @strSql varchar(500)
	IF @FROM='1'
	BEGIN
	TRUNCATE TABLE TBL_API_NSE_HOLDING_TEMP
	Set @strSql = 'Bulk insert  TBL_API_NSE_HOLDING_TEMP from ''' + @FILEPATH  + '''  with (fieldterminator='','',ROWTERMINATOR = ''\n'' )' 	 
	END
	ELSE
	BEGIN
	TRUNCATE TABLE HOLDING_UPLOAD_STATUS
	Set @strSql = 'Bulk insert  HOLDING_UPLOAD_STATUS from ''' + @FILEPATH  + '''  with (fieldterminator=''~'',ROWTERMINATOR = ''\n'' )' 	 
	END
	Exec(@strSql)
 END

GO
