-- Object: PROCEDURE dbo.BO_LEDGER_ENTRIES
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

--EXEC BO_LEDGER_ENTRIES 'JAN 13 2021'  
  
  
CREATE PROCEDURE [dbo].[BO_LEDGER_ENTRIES]  
  
(  
@DATE VARCHAR(20)  
)  
AS BEGIN  
TRUNCATE TABLE SSRS_LED_DP  
SELECT DISTINCT(VNO) INTO #VNO FROM ACCOUNT..LEDGER WITH(NOLOCK)  
 WHERE VTYP=8 AND VDT>=@DATE AND CLTCODE='42000012'  
   
   
   
 INSERT INTO  SSRS_LED_DP  
 SELECT   
 [VNO]=Replace(Ltrim(Rtrim(VNO)), ' ', ''),     
   VDT,  
 [ACNAME]=Replace(Ltrim(Rtrim(ACNAME)), ' ', ''),  
 [DRCR]=Replace(Ltrim(Rtrim(DRCR)), ' ', ''),   
 [VAMT]=Replace(Ltrim(Rtrim(VAMT)), ' ', ''),     
 [CLTCODE]=Replace(Ltrim(Rtrim(cltcode)), ' ', ''),    
[NARRATION]=replace(replace(replace(replace(replace(replace(replace(replace(replace(REPLACE(Replace(LEFT(Replace(Ltrim(Rtrim(narration)), '"', '' ),100), ',',''),'|', ''),'{',''),'}',''),'''',''),'#', ''),'_', ''),'/', ''),':', ''),'-', '')  
,'.', '')   
    
  FROM ACCOUNT..LEDGER WITH(NOLOCK) WHERE VTYP=8 AND VNO IN (SELECT * FROM #VNO)  
    
    
  DECLARE @FILE1 VARCHAR(MAX),@PATH1 VARCHAR(MAX) = 'J:\BackOffice\42000012_ENTRIES\'                         
SET @FILE1 = @PATH1 + 'LEDGER_ENTRIES' +'_'+ CONVERT(VARCHAR(11),'@DATE' , 112) + '.csv' --Folder Name       
DECLARE @S1 VARCHAR(MAX)                                
SET @S1 = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''VNO'''',''''VDT'''',''''ACNAME'''',''''DRCR'''',''''VAMT'''',''''CLTCODE'''',''''NARRATION'''''    --Column Name      
SET @S1 = @S1 + ' UNION ALL SELECT  cast([VNO] as varchar),CONVERT (VARCHAR (11),VDT,109) as VDT, cast([ACNAME] as varchar), cast([DRCR] as varchar), cast([VAMT] as varchar), cast([CLTCODE] as varchar), cast([NARRATION] as varchar) FROM [MSAJAG].[dbo].[SS
RS_LED_DP]    " QUERYOUT ' --Convert data type if required      
+@file1+ ' -c -SABVSNSECM.angelone.in -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'''       
--       PRINT  (@S)       
EXEC(@S1)   
END

GO
