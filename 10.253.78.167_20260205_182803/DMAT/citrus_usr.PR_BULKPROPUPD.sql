-- Object: PROCEDURE citrus_usr.PR_BULKPROPUPD
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------



create  PROC [CITRUS_USR].[PR_BULKPROPUPD](@PA_FILE_PATH VARCHAR(200),@PA_FILLER1 VARCHAR(200),@PA_REF_CUR VARCHAR(8000) OUTPUT)                      
AS                      
BEGIN                      

DECLARE @@SSQL VARCHAR(1000),@@DP_ID VARCHAR(16),@@TRX_DT DATETIME,@@FILE_DATE DATETIME                      

DELETE FROM TMP_PROP_BULK                      
SET @@SSQL = 'BULK INSERT TMP_PROP_BULK FROM '''       

--+ 'C:\BULKINSDBFOLDER\30092013 SOH.TXT' +  ''' WITH                      

+ @PA_FILE_PATH +  ''' WITH                      

    (                      

      FIELDTERMINATOR='','',                      

      ROWTERMINATOR = ''\n''                        

    )'                      

EXEC(@@SSQL)                      

                    
                      
EXEC PR_BULK_PROP @PA_FILLER1
                      

END

GO
