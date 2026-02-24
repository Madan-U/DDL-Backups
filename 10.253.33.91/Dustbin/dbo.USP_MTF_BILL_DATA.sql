-- Object: PROCEDURE dbo.USP_MTF_BILL_DATA
-- Server: 10.253.33.91 | DB: Dustbin
--------------------------------------------------

---- // USE DUSTBIN   --- // ANAND1                    
---- // DESCRIPTION :- ANAND GOLATKAR NEED MTF BILL DATA. CREATED BY HRISHI                    
-- EXEC [USP_MTF_BILL_DATA] 'FEB  8 2024'    
    
CREATE PROC [dbo].[USP_MTF_BILL_DATA]
AS  
  
DECLARE @SQL VARCHAR (MAX) ,@SQL2 VARCHAR (MAX), @SQLFINAL VARCHAR (MAX) , @PATH VARCHAR (MAX)                           
SET @PATH='J:\Backoffice\SL_AUTO\ANAND_G\MTF_BILL_DATA\INPUT\DATE.TXT'                            
  
IF OBJECT_ID(N'tempdb..#MTF_DATE') IS NOT NULL                      
DROP TABLE #MTF_DATE  
CREATE TABLE #MTF_DATE (FDATE VARCHAR(50))  
                          
SET @SQL='BULK INSERT #MTF_DATE FROM ' + ''''+ @PATH +''''                          
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
                          
--SELECT TOP 10 * FROM #MTF_DATE  
  
DECLARE @FDATE VARCHAR(11)  
SELECT @FDATE=FDATE FROM #MTF_DATE            
PRINT @FDATE  

SELECT PARTY_CODE, COLL=SUM(NETAMT),LED=MAX(MTFLEDBAL)
INTO #TEMP
FROM MTFTRADE.DBO.TBL_MTF_DATA WHERE SAUDA_DATE =@FDATE
GROUP BY PARTY_CODE


IF OBJECT_ID(N'DUSTBIN..TBL_MTF_BILL_DATA') IS NOT NULL                
DROP TABLE DUSTBIN.DBO.TBL_MTF_BILL_DATA      
    
SELECT PARTY_CODE, CONVERT(VARCHAR(20),COLL) AS COLL, CONVERT(VARCHAR(20),LED) AS LED
INTO DUSTBIN.DBO.TBL_MTF_BILL_DATA     
FROM #TEMP    
    
--SELECT TOP 10 * FROM DUSTBIN.DBO.TBL_MTF_BILL_DATA
      
--DECLARE @RPT_DATE VARCHAR(30)=REPLACE(CONVERT(VARCHAR(10),GETDATE(),3),'/','')      
DECLARE @FILENAME VARCHAR(100) = 'J:\Backoffice\SL_AUTO\ANAND_G\MTF_BILL_DATA\OUTPUT\' +'MTF_BILL_DATA' + '.CSV'    
DECLARE @ALL VARCHAR(MAX)      
      
SET @ALL = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''PARTY_CODE'''',''''COLL'''',''''LED'''''      
SET @ALL = @ALL+ ' UNION ALL SELECT * FROM DUSTBIN.DBO.TBL_MTF_BILL_DATA'    
PRINT @ALL      
SET @ALL=@ALL+' " QUERYOUT ' +@FILENAME+ ' -c -t"," -c -t"," -r"\n" -T'', NO_OUTPUT'      
PRINT @ALL      
EXEC(@ALL)      
  
DROP TABLE #TEMP  
DROP TABLE #MTF_DATE  
  
SELECT 'MTF BILL DATA FILE EXPORTED TO ' + @FILENAME AS 'REMARK'

GO
