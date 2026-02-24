-- Object: PROCEDURE dbo.USP_CLOSURE_DATA_SSRS_NEW_BKP
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------- // CREATED BY HRISHI ON 12-04-2023 MAIL SUB:- ACCOUNT CLOSURE CLIENT SQL QUERY
------- // DISCRIPTION :- TO CREATE FILE ON 196 SERVER 

CREATE PROC [dbo].[USP_CLOSURE_DATA_SSRS_NEW_BKP]
AS

BEGIN

IF OBJECT_ID(N'dbo.CLOSURE_DATA_SSRS_NEW', N'U') IS NOT NULL  
   DROP TABLE [dbo].[CLOSURE_DATA_SSRS_NEW];


SELECT DISTINCT(A.CL_CODE),      
MIN(ACTIVE_DATE)AS ACTIVE_DATE,    
MAX(INACTIVE_FROM)AS INACTIVE_FROM,    
LONG_NAME,      
BRANCH_CD,      
SUB_BROKER,    
DEACTIVE_VALUE  ,    
(case when b2c='y' then 'B2C' ELSE 'B2B'END)AS B2C,    
DEACTIVE_REMARKS  
  
INTO CLOSURE_DATA_SSRS_NEW

FROM CLIENT_BROK_DETAILS A WITH (NOLOCK), [196.1.115.132].RISK.dbo.client_details  B WITH (NOLOCK)    
WHERE A.CL_CODE=B.CL_CODE      
AND INACTIVE_FROM<=GETDATE()      
AND Deactive_value='C'    
GROUP BY A.CL_CODE,long_name,branch_cd,SUB_BROKER,b2c,DEACTIVE_REMARKS,DEACTIVE_VALUE
ORDER BY A.CL_CODE


DECLARE @NSEQUERY VARCHAR(MAX)
SET @NSEQUERY = ' bcp " select TOP 10 * '        
SET @NSEQUERY = @NSEQUERY + ' from [MSAJAG].DBO.CLOSURE_DATA_SSRS_NEW " queryout J:\Backoffice\AUTOMATION\CLOSURE_DATA\CLOSURE_DATA_'+ Replace(CONVERT(VARCHAR(10),getdate(),3),'/','
') +'.xlsx -c -t"," -SABMUMBODBN03 -Uclassmkt -Pdd$$gnfDTVs244648ysjgZAcc'        
SET @NSEQUERY = '''' + @NSEQUERY + ''''        
SET @NSEQUERY = 'EXEC MASTER.DBO.XP_CMDSHELL '+ @NSEQUERY
PRINT @NSEQUERY         
EXEC (@NSEQUERY)

END

GO
