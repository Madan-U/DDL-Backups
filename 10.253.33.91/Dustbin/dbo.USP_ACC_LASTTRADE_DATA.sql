-- Object: PROCEDURE dbo.USP_ACC_LASTTRADE_DATA
-- Server: 10.253.33.91 | DB: Dustbin
--------------------------------------------------

          
---- // USE DUSTBIN   --- // ANAND1                          
---- // DESCRIPTION :- ACCOUNT CREATION DATE AND LAST TRADING DATE. ---> CREATED BY HRISHI    
                          
CREATE PROC [dbo].[USP_ACC_LASTTRADE_DATA]
AS
DECLARE @SQL VARCHAR (MAX) ,@SQL2 VARCHAR (MAX), @SQLFINAL VARCHAR (MAX) , @PATH VARCHAR (MAX)                           
SET @PATH='J:\Backoffice\SL_AUTO\DHANESH_M\INPUT\CODE.CSV'                            
                       
 IF OBJECT_ID(N'tempdb..#CODE') IS NOT NULL                      
    DROP TABLE #CODE          
CREATE TABLE #CODE (CLTCODE VARCHAR(50))            
                          
SET @SQL='BULK INSERT #CODE FROM ' + ''''+ @PATH +''''          
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
          
--SELECT TOP 10 * FROM #CODE            
--SELECT TOP 10 * FROM #DATA        
    

IF OBJECT_ID(N'tempdb..#CHECK') IS NOT NULL                      
DROP TABLE #CHECK

SELECT CL_CODE,CONVERT(VARCHAR(10),MIN(ACTIVE_DATE),105) AS  ACTIVE_DATE, CONVERT(VARCHAR(10),'') AS  LAST_TRD_DT
INTO #CHECK
FROM #CODE , MSAJAG.DBO.CLIENT_BROK_DETAILS WHERE CL_CODE = CLTCODE
GROUP BY CL_CODE

IF OBJECT_ID(N'tempdb..#CHECK1') IS NOT NULL                      
DROP TABLE #CHECK1

SELECT  C.CLTCODE, CONVERT(VARCHAR(10),MAX(VDT),105) AS  LAST_TRD_DT
INTO #CHECK1
FROM #CODE C , ACCOUNT..LEDGER_ALL L WHERE C.CLTCODE = L.CLTCODE
GROUP BY  C.CLTCODE

UPDATE #CHECK SET LAST_TRD_DT = #CHECK1.LAST_TRD_DT FROM #CHECK1 WHERE CL_CODE = CLTCODE


IF OBJECT_ID(N'DUSTBIN..TBL_LASTTRADEDATE_DATA') IS NOT NULL                      
DROP TABLE TBL_LASTTRADEDATE_DATA 

SELECT * INTO DUSTBIN.DBO.TBL_LASTTRADEDATE_DATA FROM #CHECK

--SELECT TOP 10 * FROM DUSTBIN.DBO.TBL_LASTTRADEDATE_DATA


DECLARE @RPT_DATE VARCHAR(30)=REPLACE(CONVERT(VARCHAR(10),GETDATE(),3),'/','')            
DECLARE @FILENAME VARCHAR(100) = 'J:\Backoffice\SL_AUTO\DHANESH_M\OUTPUT\' +'LASTTRADE_DATA_' + @RPT_DATE + '.CSV'            
DECLARE @ALL VARCHAR(MAX)            
            
SET @ALL = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''CL_CODE'''',''''ACTIVE_DATE'''',''''LAST_TRD_DT'''''        
  
    
SET @ALL = @ALL+ ' UNION ALL SELECT * FROM DUSTBIN.DBO.TBL_LASTTRADEDATE_DATA'           
PRINT @ALL            
SET @ALL=@ALL+' " QUERYOUT ' +@FILENAME+ ' -c -t"," -c -t"," -r"\n" -T'', NO_OUTPUT'            
PRINT @ALL            
EXEC(@ALL)            

DROP TABLE #CODE             
DROP TABLE #CHECK            
DROP TABLE #CHECK1           
DROP TABLE DUSTBIN.DBO.TBL_LASTTRADEDATE_DATA            
                          
SELECT 'CLIENT CREATE AND LAST TRADE DATE DATA FILE EXPORTED TO ' + @FILENAME AS 'REMARK'

GO
