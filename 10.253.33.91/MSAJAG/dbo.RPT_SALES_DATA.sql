-- Object: PROCEDURE dbo.RPT_SALES_DATA
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

 ---EXEC RPT_SALES_DATA 'MAY','2021'  
  
CREATE PROCEDURE [dbo].[RPT_SALES_DATA]  
(  
@MONTHNAME VARCHAR(20),  
@YEAR VARCHAR(20)  
)  
AS   
BEGIN   
truncate table SALES_DATA_RPT  
  
insert into SALES_DATA_RPT  
select party_code,cast(backofficeactivationdate as date) as CodeGenDate,cast(createdon as date) as LeadDate,  
  
datediff(day,createdon,backofficeactivationdate) as DayDiff,monthname,year,source,mx_Lead_Medium  
  
----INTO  SALES_DATA_RPT  
from [172.31.12.195].SALES_BI.DBO.tb_kyc  
  
where monthname =@MONTHNAME and year =@YEAR  
  
 DECLARE @FILE VARCHAR(MAX),@PATH VARCHAR(MAX) = '\\AngelNseCM\BackOffice\Automation\RPT_SALES_DATA\'      --Folder Name                     
SET @FILE = @PATH + 'SALES_DATA' +'_'+ CONVERT(VARCHAR(11),GETDATE() , 112) + '.csv' --FILE Name       
DECLARE @S VARCHAR(MAX)                                
SET @S = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''PARTY_CODE'''',''''CODEGENDATE'''',''''LEADDATE'''',''''DAYDIFF'''',''''MONTHNAME'''',''''YEAR'''',''''SOURCE'''',''''MX_LEAD_MEDIUM'''''    --Column Name      
SET @S = @S + ' UNION ALL SELECT   cast([PARTY_CODE] as varchar), CONVERT (VARCHAR (11),CODEGENDATE,109) as CODEGENDATE,CONVERT (VARCHAR (11),LEADDATE,109) as LEADDATE, cast([DAYDIFF] as varchar),cast([MONTHNAME] as varchar),cast([YEAR] as varchar),cast([
SOURCE] as varchar),cast([MX_LEAD_MEDIUM] as varchar)  FROM [MSAJAG].[dbo].[SALES_DATA_RPT]    " QUERYOUT ' --Convert data type if required      
      
 +@file+ ' -c -SAngelNseCM -Uclassmkt -Pdd$$gnfDTVs244648ysjgZAcc'''       
--       PRINT  (@S)       
EXEC(@S)   
   
END

GO
