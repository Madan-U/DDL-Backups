-- Object: PROCEDURE dbo.CLOSURE_DETAILS_KYC
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

    
    
CREATE PROC [dbo].[CLOSURE_DETAILS_KYC]     
    
AS    
    
  BEGIN   
    
  TRUNCATE TABLE CLOSURE_DATA_SSRS  
    
  INSERT INTO CLOSURE_DATA_SSRS  
    
SELECT DISTINCT(A.CL_CODE),      
MIN(ACTIVE_DATE)AS ACTIVE_DATE,    
MAX(INACTIVE_FROM)AS INACTIVE_FROM,     
LONG_NAME,      
BRANCH_CD,      
SUB_BROKER,    
DEACTIVE_VALUE  ,    
(case when b2c='y' then 'B2C' ELSE 'B2B'END)AS B2C,    
[DEACTIVE_REMARKS]=REPLACE(REPLACE(REPLACE(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(REPLACE(Replace(LEFT(Replace(Ltrim(Rtrim(DEACTIVE_REMARKS)), '"', '' ),100), ',',''),'|', ''),'{',''),'}',''),'''','
'),'#', ''),'_', ''),'/', ''),':', ''),'-', ''),'.', ''),'-', ''),'(', ''),')', ''),'..',''),'...',''),'\','')  
    
-----INTO CLOSURE_DATA_SSRS   
FROM CLIENT_BROK_DETAILS A WITH (NOLOCK), INTRANET.RISK.dbo.client_details  B WITH (NOLOCK)    
    
WHERE A.CL_CODE=B.CL_CODE      
AND INACTIVE_FROM<=GETDATE()      
AND Deactive_value='C'    
GROUP BY A.CL_CODE,long_name,branch_cd,SUB_BROKER,b2c,DEACTIVE_REMARKS,DEACTIVE_VALUE    
ORDER BY A.CL_CODE   
  
  
DECLARE @FILE VARCHAR(MAX),@PATH VARCHAR(MAX) = 'J:\BackOffice\Automation\CLOSURE_DATA\'                         
SET @FILE = @PATH + 'CLOSURE_DATA' +'_'+ CONVERT(VARCHAR(11),GETDATE() , 112) + '.csv' --Folder Name       
DECLARE @S VARCHAR(MAX)                                
SET @S = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''PARTY_CODE'''',''''ACTIVE_DATE'''',''''INACTIVE_FROM'''',''''LONG_NAME'''',''''BRANCH_CD'''',''''SUB_BROKER'''',''''DEACTIVE_VALUE'''',''''B2C'''',''''DEACTIVE_REMARKS'''''    --Column Name      
SET @S = @S + ' UNION ALL SELECT  cast([CL_CODE] as varchar),CONVERT (VARCHAR (11),ACTIVE_DATE,109) as ACTIVE_DATE,CONVERT (VARCHAR (11),INACTIVE_FROM,109) as INACTIVE_FROM, cast([LONG_NAME] as varchar), cast([BRANCH_CD] as varchar), cast([SUB_BROKER] as 
varchar), cast([DEACTIVE_VALUE] as varchar), cast([B2C] as varchar), cast([DEACTIVE_REMARKS] as varchar) FROM [MSAJAG].[dbo].[CLOSURE_DATA_SSRS]    " QUERYOUT ' --Convert data type if required      
      
 +@file+ ' -c -SABVSNSECM.angelone.in -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'''       
--       PRINT  (@S)       
EXEC(@S)        
end

GO
