-- Object: PROCEDURE dbo.PROC_SHORT_MARGIN_ICCL_UPLOAD
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE PROC [dbo].[PROC_SHORT_MARGIN_ICCL_UPLOAD] (@FilePath Varchar(100),@PROCID VARCHAR(50)='') AS            

DECLARE @ParseString Varchar(2) 
DECLARE @ROWTERMINATOR VARCHAR(10)

SET @ROWTERMINATOR = CHAR(10)
SET @ParseString = ','

TRUNCATE TABLE TBL_SHORT_ALLOC_ICCL_TMP
 
Declare @strSql varchar(500)
Set @strSql = LOWER('Bulk insert TBL_SHORT_ALLOC_ICCL_TMP from ''' + @FilePath  + '''  with ( FIELDTERMINATOR = ''' + @ParseString + ''', ROWTERMINATOR = ''' + @ROWTERMINATOR + ''',FIRSTROW=2 )')
Exec(@strSql)
 
UPDATE TBL_SHORT_ALLOC_ICCL_TMP SET CPCODE = ISNULL(CPCODE,'')

GO
