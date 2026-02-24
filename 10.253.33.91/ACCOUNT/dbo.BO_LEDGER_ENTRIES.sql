-- Object: PROCEDURE dbo.BO_LEDGER_ENTRIES
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

--EXEC BO_LEDGER_ENTRIES 'JAN 13 2021'  
  
  
CREATE PROCEDURE [dbo].[BO_LEDGER_ENTRIES]  
  
(  
@DATE VARCHAR(20)  
)  
AS BEGIN  
 TRUNCATE TABLE SSRS_LED_DP  
TRUNCATE TABLE RPT_VNO  
   
INSERT INTO RPT_VNO  
SELECT DISTINCT(VNO)   FROM  LEDGER    
 WHERE VTYP=8 AND VDT>=@DATE AND CLTCODE='42000012'  
  
INSERT INTO SSRS_LED_DP    
 SELECT  DRCR,  VAMT,CLTCODE,NARRATION   FROM  LEDGER   WHERE VTYP=8 AND VNO IN (SELECT * FROM RPT_VNO)  
    
DECLARE @FILE1 VARCHAR(MAX),@PATH1 VARCHAR(MAX) = 'J:\BackOffice\UPDATION\42000012_ENTRIES\'                         
SET @FILE1 = @PATH1 + 'LED_DATA_GL' +'_'+ CONVERT(VARCHAR(11),@DATE , 112) + '.csv' --Folder Name       
DECLARE @S1 VARCHAR(MAX)                                
SET @S1 = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''DRCR'''',''''VAMT'''',''''CLTCODE'''',''''NARRATION'''''    --Column Name      
SET @S1 = @S1 + ' UNION ALL SELECT    cast([DRCR] as varchar), cast([VAMT] as varchar),  cast([CLTCODE] as varchar), cast([NARRATION] as varchar) FROM [ACCOUNT].[dbo].[SSRS_LED_DP]    " QUERYOUT ' --Convert data type if required      
      
 +@file1+ ' -c -SABVSNSECM.angelone.in -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'''       
--       PRINT  (@S)       
EXEC(@S1)        
end

GO
