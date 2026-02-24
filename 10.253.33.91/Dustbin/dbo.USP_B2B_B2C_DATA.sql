-- Object: PROCEDURE dbo.USP_B2B_B2C_DATA
-- Server: 10.253.33.91 | DB: Dustbin
--------------------------------------------------

    
---- // USE DUSTBIN   --- // ANAND1                    
---- // DESCRIPTION :- B2B / B2C DATA. CREATED BY HRISHI                    
                    
CREATE PROC [dbo].[USP_B2B_B2C_DATA]  
AS    
DECLARE @SQL VARCHAR (MAX) ,@SQL2 VARCHAR (MAX), @SQLFINAL VARCHAR (MAX) , @PATH VARCHAR (MAX)                     
SET @PATH='J:\Backoffice\SL_AUTO\B2B_B2C\INPUT\B2B_B2C_CODE.CSV'                      
                 
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
      
IF OBJECT_ID(N'DUSTBIN..TBL_B2B_B2C_DATA') IS NOT NULL                
DROP TABLE TBL_B2B_B2C_DATA      
  
SELECT V.*   
INTO TBL_B2B_B2C_DATA  
FROM MSAJAG..VW_BTB_BTC V INNER JOIN #CODE C ON V.CL_CODE=C.CLTCODE  
      
--SELECT TOP 10 * FROM DUSTBIN.DBO.TBL_B2B_B2C_DATA        
      
DECLARE @RPT_DATE VARCHAR(30)=REPLACE(CONVERT(VARCHAR(10),GETDATE(),3),'/','')      
DECLARE @FILENAME VARCHAR(100) = 'J:\Backoffice\SL_AUTO\B2B_B2C\OUTPUT\' +'B2B_B2C_DATA_' + @RPT_DATE + '.CSV'      
DECLARE @ALL VARCHAR(MAX)      
      
SET @ALL = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''CL_CODE'''',''''B2B_B2C'''''      
SET @ALL = @ALL+ ' UNION ALL SELECT * FROM DUSTBIN.DBO.TBL_B2B_B2C_DATA'      
--SET @ALL = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT * FROM DUSTBIN.DBO.TBL_CALLING_DATA'      
PRINT @ALL      
SET @ALL=@ALL+' " QUERYOUT ' +@FILENAME+ ' -c -t"," -c -t"," -r"\n" -T'', NO_OUTPUT'      
PRINT @ALL      
EXEC(@ALL)      
                    
DROP TABLE #CODE      
DROP TABLE DUSTBIN.DBO.TBL_B2B_B2C_DATA      
                    
SELECT 'B2B / B2C DATA FILE EXPORTED TO ' + @FILENAME AS 'REMARK'

GO
