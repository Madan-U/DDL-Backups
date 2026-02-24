-- Object: PROCEDURE dbo.USP_RPT_CLIENT_DATA
-- Server: 10.253.33.91 | DB: Dustbin
--------------------------------------------------

---- // USE DUSTBIN   --- // .91                                
---- // DESCRIPTION :- REQUEST FROM DARSHANA GOGRI (COMPLIANCE TEAM). CREATED BY HRISHI                                
-- EXEC [USP_CLIENT_DATA]          
                
CREATE PROC [dbo].[USP_RPT_CLIENT_DATA]        
AS
              
DECLARE @SQL VARCHAR (MAX) ,@SQL2 VARCHAR (MAX), @SQLFINAL VARCHAR (MAX) , @PATH VARCHAR (MAX)                                       
SET @PATH='J:\BACKOFFICE\SL_AUTO\PMLA_REPORTS\CLIENT_DATA\INPUT\INPUT.TXT'                                        
              
IF OBJECT_ID(N'TEMPDB..#INPUT_DATA') IS NOT NULL                                  
DROP TABLE #INPUT_DATA        
        
CREATE TABLE #INPUT_DATA (CODE VARCHAR (100))        
                                      
SET @SQL='BULK INSERT #INPUT_DATA FROM ' + ''''+ @PATH +''''                                      
SET @SQL2=' WITH                                        
    (                                        
           FIRSTROW = 1,                                        
           FIELDTERMINATOR = '','',  --CSV FIELD DELIMITER                                        
           ROWTERMINATOR = ''\n'',   --USE TO SHIFT THE CONTROL TO NEXT ROW                                        
           TABLOCK                                        
    )'                                        
        
SET @SQLFINAL= @SQL + @SQL2        
PRINT @SQLFINAL        
EXEC (@SQLFINAL)        
          
            
IF OBJECT_ID(N'DUSTBIN..TBL_CL_DETAILS_DATA') IS NOT NULL                            
DROP TABLE DUSTBIN.DBO.TBL_CL_DETAILS_DATA                  
        
--SELECT C.CL_CODE,C.LONG_NAME,CONVERT(VARCHAR(11),C.DOB,103) AS DOB,C.L_STATE       
--INTO DUSTBIN.DBO.TBL_CL_DETAILS_DATA        
--FROM MSAJAG.DBO.CLIENT_DETAILS C INNER JOIN #INPUT_DATA I ON C.CL_CODE=I.CODE   

--PII DATA FIELD LIKE DOB, MOBILE NO,PAN NO AND EMAIL CANNOT BE GIVEN AS PER COMPLIANCE.



SELECT C.CL_CODE,(CASE WHEN B.B2C='Y'THEN 'B2C'ELSE 'B2B'END)AS B2B_B2C ,C.BRANCH_CD,C.SUB_BROKER,C.LONG_NAME,
REPLACE(C.L_ADDRESS1, ',', ' ') AS ADDRESS1,REPLACE(C.L_ADDRESS2, ',', ' ') AS ADDRESS2,REPLACE(C.L_ADDRESS3, ',', ' ') AS ADDRESS3,C.L_CITY,C.L_STATE,C.L_ZIP,C.CL_TYPE
,C.CL_STATUS,C.GST_NO,PAN_GIR_NO='',MOBILE_PAGER='',EMAIL='',DOB='' 
INTO DUSTBIN.DBO.TBL_CL_DETAILS_DATA        
FROM MSAJAG.DBO.CLIENT_DETAILS C INNER JOIN #INPUT_DATA I ON C.CL_CODE=I.CODE 
INNER JOIN [INTRANET].RISK.DBO.CLIENT_DETAILS B ON B.CL_CODE=I.CODE


--SELECT TOP 10 * FROM [INTRANET].RISK.DBO.CLIENT_DETAILS        

--DECLARE @RPT_DATE VARCHAR(30)=REPLACE(CONVERT(VARCHAR(10),GETDATE(),3),'/','')        
DECLARE @FILENAME VARCHAR(100) = 'J:\BACKOFFICE\SL_AUTO\PMLA_REPORTS\CLIENT_DATA\OUTPUT\' +'CLIENT_DATA' + '.CSV'        
DECLARE @ALL VARCHAR(MAX)                  
                  
SET @ALL = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''CL_CODE'''',''''B2B_B2C'''',''''BRANCH_CD'''',''''SUB_BROKER'''',''''LONG_NAME'''',''''L_ADDRESS1'''',''''L_ADDRESS2'''',''''L_ADDRESS3'''',''''L_CITY'''',''''L_STATE'''',''''L_ZIP'''',''''CL_TYPE'''',''''CL_STATUS'''',''''GST_NO'''',''''PAN_GIR_NO'''',''''MOBILE_PAGER'''',''''EMAIL'''',''''DOB'''''
SET @ALL = @ALL+ ' UNION ALL SELECT * FROM DUSTBIN.DBO.TBL_CL_DETAILS_DATA'                
PRINT @ALL                  
set @all=@all+' " queryout ' +@filename+ ' -c -t"," -c -t"," -r"\n" -T'', NO_OUTPUT'
PRINT @ALL                  
EXEC(@ALL)                  
        
DROP TABLE #INPUT_DATA              
              
SELECT 'CLIENT DETAILS DATA FILE EXPORTED TO ' + @FILENAME AS 'REMARK'

GO
