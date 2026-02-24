-- Object: PROCEDURE dbo.AUTO_AWS_MARGIN_STAT_BILL_BKP_22AUG2025_SRE-39582
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




CREATE  PROC [dbo].[AUTO_AWS_MARGIN_STAT_BILL_BKP_22AUG2025_SRE-39582]     
( @MARGIN VARCHAR(20),    
@D  VARCHAR(11)    
)    
AS    
 BEGIN     
     
  INSERT INTO AUTO_AWS_MARGIN_STATE_BILL_LOG     
  SELECT @MARGIN,@D,GETDATE(),'START'    
    
 IF @MARGIN ='MARGIN'     
    
 BEGIN     
 TRUNCATE TABLE TBL_CN_MAR_BILL_DATE    
 INSERT INTO TBL_CN_MAR_BILL_DATE    
 SELECT @D,'M'    
      
  EXEC msdb.DBO.SP_START_JOB 'AUTO_AWS_CN_MAR_BILL'     
 WAITFOR DELAY '00:09:15';     
       
DECLARE @C varchar(11)        
SELECT @C=COUNT(DISTINCT PARTY_CODE)  FROM MARGIN_PROCESS WHERE SNO=1    
  SELECT 'MARGIN STATEMENT PROCESS FOR '+ @D + ' WITH COUNT OF '+@C+' COMPLETED SUCESSFULLY...!!!     
    
  Kindly Find the File ON Below Path: 
		\\ABVSNSECM.angelone.in\j\Comb_Margin  ....!!!' AS STATUS    
      
      
 END    
     
 IF @MARGIN ='BILL'      
    
 BEGIN     
 TRUNCATE TABLE TBL_CN_MAR_BILL_DATE    
 INSERT INTO TBL_CN_MAR_BILL_DATE    
 SELECT @D,'M'    
      
  EXEC [AngelCommodity].msdb.DBO.SP_START_JOB 'AUTO_AWS_CN_MAR_BILL'     
 WAITFOR DELAY '00:02:15';     
       
DECLARE @COM varchar(11)        
SELECT @COM=COUNT(DISTINCT PARTY_CODE)  FROM [AngelCommodity].MCDX.DBO.COMM_BILL_PROCESS WHERE SNO=1    
  SELECT 'COMMODITY CONTRACT BILL PROCESS FOR '+ @D + ' WITH COUNT OF '+@COM+' COMPLETED SUCESSFULLY...!!!     
    
  Kindly Find the File ON Below Path: 
		\\ANGELCOMMODITY\Backoffice\Commbill  ....!!!' AS STATUS     
    
      
 END    
    
 IF @MARGIN IS NULL    
    
 BEGIN     
    
  SELECT ' PROCESS TESTED COMPLETED SUCCESSFULLY.....!!!!' AS [STATUS]    
    
 END    
    
     
 END

GO
