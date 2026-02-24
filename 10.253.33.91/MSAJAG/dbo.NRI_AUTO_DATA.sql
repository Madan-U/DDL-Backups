-- Object: PROCEDURE dbo.NRI_AUTO_DATA
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE [dbo].[NRI_AUTO_DATA]
AS
BEGIN  
TRUNCATE TABLE NRI_SSRS_DATA  
SELECT A.CL_CODE,LONG_NAME,BRANCH_CD,SUB_BROKER,REGION,CL_TYPE,CL_STATUS,EXCHANGE,SEGMENT,ACTIVE_DATE,INACTIVE_FROM,
(case when InActive_From>GETDATE()then 'ACTIVE'ELSE 'INACTIVE'END)AS STATUS,DEACTIVE_REMARKS,DEACTIVE_VALUE,
LTRIM(RTRIM(L_ADDRESS1))as L_ADDRESS1,LTRIM(RTRIM(l_address2))as L_ADDRESS2,LTRIM(RTRIM(l_address3))as L_ADDRESS3
,LTRIM(RTRIM(l_city))as L_CITY,LTRIM(RTRIM(l_state))as L_STATE,LTRIM(RTRIM(l_zip))as L_ZIP,LTRIM(RTRIM(l_nation))as L_NATION
INTO #TEMP
 FROM CLIENT_DETAILS A WITH(NOLOCK),CLIENT_BROK_DETAILS B WITH(NOLOCK)
WHERE A.cl_code=B.Cl_Code
--AND cl_type='NRI'
AND sub_broker IN('BH','BHKWT')
---and Active_Date<GETDATE()-11
 
 UNION ALL
 
 SELECT A.CL_CODE,LONG_NAME,BRANCH_CD,SUB_BROKER,REGION,CL_TYPE,CL_STATUS,EXCHANGE,SEGMENT,ACTIVE_DATE,INACTIVE_FROM,
(case when InActive_From>GETDATE()then 'ACTIVE'ELSE 'INACTIVE'END)AS STATUS,DEACTIVE_REMARKS,DEACTIVE_VALUE,
LTRIM(RTRIM(L_ADDRESS1))as L_ADDRESS1,LTRIM(RTRIM(l_address2))as L_ADDRESS2,LTRIM(RTRIM(l_address3))as L_ADDRESS3
,LTRIM(RTRIM(l_city))as L_CITY,LTRIM(RTRIM(l_state))as L_STATE,LTRIM(RTRIM(l_zip))as L_ZIP,LTRIM(RTRIM(l_nation))as L_NATION
 FROM CLIENT_DETAILS A WITH(NOLOCK),CLIENT_BROK_DETAILS B WITH(NOLOCK)
WHERE A.cl_code=B.Cl_Code
--AND cl_type='NRI'
AND A.CL_cODE LIKE 'ZR%'
---and Active_Date<GETDATE()-11
 ORDER BY CL_CODE
 

BEGIN  
INSERT INTO NRI_SSRS_DATA  
SELECT DISTINCT *  FROM #TEMP WHERE Active_Date BETWEEN LEFT(GETDATE()-11,11) AND LEFT(GETDATE(),11)    
    
DECLARE @FILE VARCHAR(MAX),@PATH VARCHAR(MAX) = 'J:\BackOffice\Automation\NRI_DATA\'                         
SET @FILE = @PATH + 'NRI_DATA' +'_'+ CONVERT(VARCHAR(11),GETDATE() , 112) + '.csv' --Folder Name       
DECLARE @S VARCHAR(MAX)                                
SET @S = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''CL_CODE'''',''''LONG_NAME'''',''''BRANCH_CD'''',''''SUB_BROKER'''',''''REGION'''',''''CL_TYPE'''',''''CL_STATUS'''',''''EXCHANGE'''',''''SEGMENT'''',''''ACTIVE_DATE'''',''''INACTIVE_FROM'''',''''STATUS'''',''''DEACTIVE_REMARKS'''',''''DEACTIVE_VALUE'''',''''L_ADDRESS1'''',''''L_ADDRESS2'''',''''L_ADDRESS3'''',''''L_CITY'''',''''L_STATE'''',''''L_ZIP'''',''''L_NATION'''''    --Column Name      
SET @S = @S + ' UNION ALL SELECT  cast([CL_CODE] as varchar),cast([LONG_NAME] as varchar),cast([BRANCH_CD] as varchar),cast([SUB_BROKER] as varchar),cast([REGION] as varchar),cast([CL_TYPE] as varchar),cast([CL_STATUS] as varchar),cast([EXCHANGE] as varchar),cast([SEGMENT] as varchar),CONVERT (VARCHAR (11),ACTIVE_DATE,109) as ACTIVE_DATE,CONVERT (VARCHAR (11),INACTIVE_FROM,109) as INACTIVE_FROM,cast([STATUS] as varchar),cast([DEACTIVE_REMARKS] as varchar),cast([DEACTIVE_VALUE] as varchar),cast([L_ADDRESS1] as varchar),  cast([L_ADDRESS2] as varchar), cast([L_ADDRESS3] as varchar), cast([L_CITY] as varchar), cast([L_STATE] as varchar),cast([L_ZIP] as varchar),cast([L_NATION] as varchar)   FROM [MSAJAG].[dbo].[NRI_SSRS_DATA]    " QUERYOUT ' --Convert data type if required      
      
 +@file+ ' -c -SABVSNSECM.angelone.in -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'''       
--       PRINT  (@S)       
EXEC(@S)        
end  
 
 END

GO
