-- Object: PROCEDURE dbo.TRADED_CLIENT_MONTH
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE [dbo].[TRADED_CLIENT_MONTH]        
AS        
BEGIN        
        
TRUNCATE TABLE TRADED_CLIENT_MONTH_SSRS        
        
SELECT DISTINCT(PARTY_CODE) INTO #CLIENT2 FROM CMBILLVALAN WITH(NOLOCK) WHERE SAUDA_dATE>=GETDATE()-31        
UNION         
SELECT DISTINCT(PARTY_CODE) FROM [AngelBSECM].BSEDB_AB.DBO.CMBILLVALAN WITH(NOLOCK) WHERE SAUDA_dATE>=GETDATE()-31        
UNION         
SELECT DISTINCT(PARTY_CODE) FROM [AngelFO].NSEFO.DBO.FOBILLVALAN WITH(NOLOCK) WHERE SAUDA_dATE>=GETDATE()-31 AND TRADETYPE='BT'        
UNION         
SELECT DISTINCT(PARTY_CODE) FROM [AngelFO].NSECURFO.DBO.FOBILLVALAN WITH(NOLOCK) WHERE SAUDA_dATE>=GETDATE()-31 AND TRADETYPE='BT'        
UNION         
SELECT DISTINCT(PARTY_CODE) FROM [AngelCommodity].MCDX.DBO.FOBILLVALAN WITH(NOLOCK) WHERE SAUDA_dATE>=GETDATE()-31 AND TRADETYPE='BT'        
UNION         
SELECT DISTINCT(PARTY_CODE) FROM [AngelCommodity].NCDX.DBO.FOBILLVALAN WITH(NOLOCK) WHERE SAUDA_dATE>=GETDATE()-31 AND TRADETYPE='BT'        
        
        
SELECT DISTINCT(CL_CODE) INTO #CLIENT3 FROM CLIENT_BROK_DETAILS  WHERE Cl_Code IN (SELECT * FROM #CLIENT2) and InActive_From>GETDATE()        
        
        
INSERT INTO TRADED_CLIENT_MONTH_SSRS        
        
SELECT         
[CL_CODE]=Replace(Ltrim(Rtrim(CL_CODE)), ' ', ''),         
[SHORT_NAME]=replace(replace(replace(replace(replace(replace(replace(replace(replace(REPLACE(Replace(LEFT(Replace(Ltrim(Rtrim(SHORT_NAME)), '"', '' ),100), ',',''),'|', ''),'{',''),'}',''),'''',''),'#', ''),'_', ''),'/', ''),':', ''),'-', ''),'.', ''),   
  
    
      
       
[MOBILE_PAGER]=ISNULL(Replace(Ltrim(Rtrim(MOBILE_PAGER)), ' ', ''),''),        
(CASE WHEN B2C='Y'THEN 'B2C'ELSE 'B2B'END)AS B2B_B2C,        
[EMAIL]=replace(replace(replace(replace(replace(replace(replace(replace(replace(REPLACE(Replace(LEFT(Replace(Ltrim(Rtrim(EMAIL)), '"', '' ),100), ',',''),'|', ''),'{',''),'}',''),'''',''),'#', ''),'_', ''),'/', ''),':', ''),'-', ''),'.', '')        
        
---INTO TRADED_CLIENT_MONTH_SSRS        
 FROM [196.1.115.132].RISK.DBO.CLIENT_DETAILS WITH(NOLOCK) WHERE         
 CL_cODE IN (SELECT  * FROM #CLIENT3)         
         
         
 ----SELECT TOP 2 * FROM TRADED_CLIENT_MONTH_SSRS        
         
 DECLARE @FILE VARCHAR(MAX),@PATH VARCHAR(MAX) = 'J:\BackOffice\Automation\TRADED_CLIENTS\'      --Folder Name                         
SET @FILE = @PATH + 'TRADED_CLIENTS' +'_'+ CONVERT(VARCHAR(11),GETDATE() , 112) + '.csv' --FILE Name           
DECLARE @S VARCHAR(MAX)                                    
SET @S = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''CL_CODE'''',''''SHORT_NAME'''',''''MOBILE_PAGER'''',''''B2B_B2C'''',''''EMAIL'''''    --Column Name          
SET @S = @S + ' UNION ALL SELECT   cast([CL_CODE] as varchar), cast([SHORT_NAME] as varchar), cast([MOBILE_PAGER] as varchar), cast([B2B_B2C] as varchar),cast([EMAIL] as varchar)  FROM [MSAJAG].[dbo].[TRADED_CLIENT_MONTH_SSRS]    " QUERYOUT ' --Convert data type if required          
          
 +@file+ ' -c -SABVSNSECM.angelone.in -Uclassmkt -Pdd$$gnfDTVs244648ysjgZAcc'''           
--       PRINT  (@S)           
EXEC(@S)            
end

GO
