-- Object: PROCEDURE dbo.AUTO_PROC_CM_MARGIN_DWLOAD
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

    
CREATE PROC [dbo].[AUTO_PROC_CM_MARGIN_DWLOAD]     
AS    
---AUTHOR : PUNIT VERMA    
BEGIN    
    
DECLARE @SAUDA VARCHAR(11)    
    
SELECT @SAUDA = SAUDA FROM tbl_AUTO_CM_MARGIN_DWLOAD    
    
  TRUNCATE TABLE AUTO_CM_MARGIN_DWLOAD    
  INSERT INTO AUTO_CM_MARGIN_DWLOAD    
  EXEC PROC_CM_MARGIN_DWLOAD @SAUDA    
    
DECLARE @BATCH_NO VARCHAR(11)    
DECLARE @A VARCHAR(10)    
DECLARE @B VARCHAR(10)    
DECLARE @C VARCHAR(10)    
SELECT @A =DATEPART(DD,@SAUDA)      
SELECT @B= DATEPART(MM,@SAUDA)    
SELECT @C =DATEPART(YYYY,@SAUDA)    
SELECT @BATCH_NO = BATCH_NO FROM tbl_AUTO_CM_MARGIN_DWLOAD    
    
    
DECLARE @FILE VARCHAR(MAX),@PATH VARCHAR(MAX) = 'J:\Backoffice\AUTOMATION\UPDATION\MARGIN_EXCHANGE_REPORTING\'                       
SET @FILE = @PATH +'C_MRG_TM_' + @A +'0'+@B+@C+'_0'+@BATCH_NO+ '.CSV' --Folder Name     
--DECLARE @D VARCHAR(100)    
--SET @D = 'MTF_SCRIP AUTOMATION' + ' ' + CONVERT (VARCHAR (11),GETDATE(),109)    
    
DECLARE @S VARCHAR(MAX)                              
    
SET @S = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "'    --Column Name    
    
      
SET @S = @S + 'SELECT EXCH_DATA  FROM [MSAJAG].[dbo].[AUTO_CM_MARGIN_DWLOAD] WHERE PARTY_CODE<>''''12798''''  " QUERYOUT ' --Convert data type if required    
    
 +@file+ ' -c -SABVSNSECM.angelone.in -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'''           
    
          
PRINT (@S)                                    
    
EXEC(@S)       
    
    
END

GO
