-- Object: PROCEDURE dbo.AUTO_AWS_CONTRACT_NOTES
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC [dbo].[AUTO_AWS_CONTRACT_NOTES]     
( @EXCHANGE VARCHAR(20),    
@D  VARCHAR(11)    
)    
AS    
 BEGIN     
     
  INSERT INTO AUTO_TBL_AWS_CONTRACT_NOTES_LOG     
  SELECT @EXCHANGE,@D,GETDATE(),'START'    
    
 IF @EXCHANGE ='CASH'     
    
 BEGIN     
 TRUNCATE TABLE TBL_CN_DATE    
 INSERT INTO TBL_CN_DATE    
 SELECT @D,'C'    
      
  EXEC msdb.DBO.SP_START_JOB 'AUTO_AWS_CN'     
  WAITFOR DELAY '00:25:15';     
       
DECLARE @CASH varchar(11)        
SELECT @CASH=COUNT(DISTINCT PARTY_CODE)  FROM nse_bulk_process WHERE SNO=1    
  SELECT 'CONTRACT NOTE PROCESS FOR '+ @D + 'WITH COUNT OF '+@CASH+' COMPLETED SUCESSFULLY...!!!     
    
  Kindly Find the File ON Below Path:     
  \\AngelNseCM\j\Contract_Note  ....!!!' AS [STATUS]    
      
 END    
     
    
 IF @EXCHANGE ='FO'     
 BEGIN    
  TRUNCATE TABLE TBL_CN_DATE    
  INSERT INTO TBL_CN_DATE    
  SELECT @D,'F'    
      
  EXEC msdb.DBO.SP_START_JOB 'AUTO_AWS_CN'     
   WAITFOR DELAY '00:25:15';     
       
DECLARE @FO varchar(11)        
SELECT @FO=COUNT(DISTINCT PARTY_CODE)  FROM nse_bulk_process WHERE SNO=1    
  SELECT 'CONTRACT NOTE PROCESS FOR '+ @D + 'WITH COUNT OF '+@FO+' COMPLETED SUCESSFULLY...!!!     
    
  Kindly Find the File ON Below Path:     
  \\AngelNseCM\j\Contract_Note  ....!!!' AS [STATUS]    
 END    
    
 IF @EXCHANGE ='CASHFO'     
 BEGIN    
  TRUNCATE TABLE TBL_CN_DATE    
  INSERT INTO TBL_CN_DATE    
  SELECT @D,'A'    
      
  EXEC msdb.DBO.SP_START_JOB 'AUTO_AWS_CN'     
   WAITFOR DELAY '00:25:15';     
       
DECLARE @CASHFO varchar(11)        
SELECT @CASHFO=COUNT(DISTINCT PARTY_CODE)  FROM nse_bulk_process WHERE SNO=1    
  SELECT 'CONTRACT NOTE PROCESS FOR '+ @D + 'WITH COUNT OF '+@CASHFO+' COMPLETED SUCESSFULLY...!!!     
    
  Kindly Find the File ON Below Path:     
  \\AngelNseCM\j\Contract_Note  ....!!!' AS [STATUS]    
      
 END    
    
    
 IF @EXCHANGE ='CURR'     
    
 BEGIN     
  TRUNCATE TABLE TBL_CN_DATE    
  INSERT INTO TBL_CN_DATE    
  SELECT @D,'CUR'    
    
  EXEC msdb.DBO.SP_START_JOB 'CN_CURR'     
   WAITFOR DELAY '00:02:02';     
       
DECLARE @C varchar(11)        
SELECT @C=COUNT(DISTINCT PARTY_CODE)  FROM CUR_BULK_PROCESS WHERE SNO=1    
  SELECT 'CURRENCY CONTRACT NOTE PROCESS FOR '+ @D + 'WITH COUNT OF '+@C+' COMPLETED SUCESSFULLY...!!!     
      
  Kindly Find the File ON Below Path:     
  \\AngelNseCM\j\Contract_Note  ....!!!' AS [STATUS]    
 END    
     
    
 IF @EXCHANGE ='COMM'     
    
 BEGIN     
   TRUNCATE TABLE TBL_CN_DATE    
  INSERT INTO TBL_CN_DATE    
  SELECT @D,'COMM'    
    
  EXEC [AngelCommodity].msdb.DBO.SP_START_JOB 'AUTO_AWS_CN_COMM'     
  WAITFOR DELAY '00:03:02';     
       
DECLARE @COM varchar(11)        
SELECT @COM=COUNT(DISTINCT PARTY_CODE)  FROM [AngelCommodity].MCDX.DBO.COMM_BULK_PROCESS WHERE SNO=1    
  SELECT 'COMMODITY CONTRACT NOTE PROCESS FOR '+ @D + 'WITH COUNT OF '+@COM+' COMPLETED SUCESSFULLY...!!!     
      
  Kindly Find the File ON Below Path:     
  \\AngelCommodity\D:\Backoffice\Contract_Note  ....!!!' AS [STATUS]    
 END    
     
    
 IF @EXCHANGE IS NULL    
    
 BEGIN     
    
  SELECT ' PROCESS TESTED COMPLETED SUCCESSFULLY.....!!!!' AS [STATUS]    
    
 END    
    
     
 END

GO
