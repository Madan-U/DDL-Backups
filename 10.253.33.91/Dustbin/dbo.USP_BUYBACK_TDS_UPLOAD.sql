-- Object: PROCEDURE dbo.USP_BUYBACK_TDS_UPLOAD
-- Server: 10.253.33.91 | DB: Dustbin
--------------------------------------------------


/*
DEVELOPED BY:- HRISHI ON 06-11-2025  ORE-4961
DESCRIPTION:- TO UPLOAD TDS FILE FOR BUYBACK LEC
*/


CREATE PROC [USP_BUYBACK_TDS_UPLOAD]  ( @FILENAME AS VARCHAR(50) )
AS

BEGIN

--DECLARE @FILENAME VARCHAR(50) ='TANLA_TDS.xls'

TRUNCATE TABLE TBL_TDS_UPLOAD_BUYBACK_LEC

DECLARE @FILEPATH VARCHAR(500)=''
SET @FILEPATH ='\\INHOUSELIVEAPP1-FS.ANGELONE.IN\D\UPLOAD1\NRIFiles\BUYBACK_LEC_TDS\'+@FILENAME+''

declare @sql nvarchar(4000) = 'bulk insert tbl_tds_upload_buyback_lec from ''' + @filepath + ''' with ( fieldterminator ='','', rowterminator =''\n'',firstrow=2 )';
PRINT @SQL
EXEC(@SQL)

SELECT 'FILE UPLOAD SUCCESSFULLY...'

END

GO
