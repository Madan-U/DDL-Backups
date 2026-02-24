-- Object: PROCEDURE dbo.SSRS_CLIENT_NCX
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  
   
  
 CREATE PROCEDURE [dbo].[SSRS_CLIENT_NCX]  
 AS   
 BEGIN  
   
 EXEC ABVSINSURANCEBO.msdb.DBO.SP_START_JOB 'KYC_DUMP_DATA_NCX'     
 WAITFOR DELAY '00:0:45';    
  
TRUNCATE TABLE SSRS_CLIENT_DUMP_DATA  
SELECT DISTINCT CL_cODE INTO #NCX FROM CLIENT_BROK_DETAILS WHERE EXCHANGE ='NCX'AND CL_cODE BETWEEN 'A'AND 'ZZZZZZZ'  
  
  
SELECT * INTO #CLI FROM #NCX WHERE CL_cODE NOT IN (SELECT * FROM SSIS_CLIENT_DUMP)  
  
INSERT INTO SSRS_CLIENT_DUMP_DATA  
SELECT CL_cODE,EXCHANGE,SEGMENT,Active_Date,InActive_From,Deactive_Remarks,Deactive_value   
 FROM CLIENT_BROK_DETAILS WHERE CL_CODE IN (SELECT * FROM #CLI)AND EXCHANGE='NCX'  
   
 ----FILE GENERATION  
  
DECLARE @FILE VARCHAR(MAX),@PATH VARCHAR(MAX) = 'J:\BackOffice\test\AUTOMATION\NCDX_DATA\'                           
SET @FILE = @PATH + 'NCDX_DATA_UCC' +'_'+ CONVERT(VARCHAR(11),GETDATE() , 112) + '.csv' --Folder Name         
DECLARE @S VARCHAR(MAX)                                  
SET @S = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''CL_cODE'''',''''EXCHANGE'''',''''SEGMENT'''',''''Active_Date'''',''''InActive_From'''',''''Deactive_Remarks'''',''''Deactive_value'''''    --Column Name        
SET @S = @S + ' UNION ALL SELECT    cast([CL_cODE] as varchar), cast([EXCHANGE] as varchar), cast([SEGMENT] as varchar),CONVERT (VARCHAR (11),Active_Date,109) as Active_Date,CONVERT (VARCHAR (11),InActive_From,109) as InActive_From, cast([Deactive_Remarks
] as varchar), cast([Deactive_value] as varchar) FROM [MSAJAG].[dbo].[SSRS_CLIENT_DUMP_DATA]    " QUERYOUT ' --Convert data type if required        
        
 +@file+ ' -c -SABVSNSECM.angelone.in -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'''         
--       PRINT  (@S)         
EXEC(@S)  
  
  
 END

GO
