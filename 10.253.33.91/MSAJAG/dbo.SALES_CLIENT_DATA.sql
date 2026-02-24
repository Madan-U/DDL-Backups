-- Object: PROCEDURE dbo.SALES_CLIENT_DATA
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE [dbo].[SALES_CLIENT_DATA]  
  
AS   
BEGIN   
TRUNCATE TABLE SALES_SSIS_DATA  
  
  
INSERT INTO SALES_SSIS_DATA  
select party_code ,clientname,Zone , region, BackofficeActivationdate,Final_Introducer,Emp_name,TSM_Code,TSM_Name,CH_Code,CH_Name from [172.31.12.195].sales_bi.dbo.tb_kyc where monthname ='MAY' and year = 2021  
  
DECLARE @FILE VARCHAR(MAX),@PATH VARCHAR(MAX) = ' \\AngelNseCM\BackOffice\Automation\SALES_REPORT\'                         
SET @FILE = @PATH + 'SALES_DATA' +'_'+ CONVERT(VARCHAR(11),GETDATE() , 112) + '.csv' --Folder Name       
DECLARE @S VARCHAR(MAX)                                
SET @S = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''PARTY_CODE'''',''''CLIENTNAME'''',''''ZONE'''',''''REGION'''',''''BackofficeActivationdate'''',''''Final_Introducer'''',''''Emp_name'''',''''TSM_Code'''',''''TSM_Name'''',''''CH_Code'''',''''CH_Name'''''  --Column Name      
SET @S = @S + ' UNION ALL SELECT cast([PARTY_CODE] as varchar),cast([CLIENTNAME] as varchar),cast([ZONE] as varchar),cast([REGION] as varchar),CONVERT (VARCHAR (11),BackofficeActivationdate,109) as BackofficeActivationdate,cast([Final_Introducer] as varch
ar),cast([Emp_name] as varchar),cast([TSM_Code] as varchar),cast([TSM_Name] as varchar),cast([CH_Code] as varchar),cast([CH_Name] as varchar) FROM [MSAJAG].[dbo].[SALES_SSIS_DATA]    " QUERYOUT ' --Convert data type if required          
 +@file+ ' -c -SAngelNseCM -Uclassmkt -Pdd$$gnfDTVs244648ysjgZAcc'''       
--       PRINT  (@S)       
EXEC(@S)    
END

GO
