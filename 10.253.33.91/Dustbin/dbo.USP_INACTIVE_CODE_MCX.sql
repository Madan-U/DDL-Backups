-- Object: PROCEDURE dbo.USP_INACTIVE_CODE_MCX
-- Server: 10.253.33.91 | DB: Dustbin
--------------------------------------------------

    
---- // USE DUSTBIN   --- // ANAND1                    
---- // DESCRIPTION :- VISHAL J RAUT REQUIRED DP DATA. CREATED BY HRISHI                    
                    
CREATE PROC [dbo].[USP_INACTIVE_CODE_MCX]    
AS    
DECLARE @SQL VARCHAR (MAX) ,@SQL2 VARCHAR (MAX), @SQLFINAL VARCHAR (MAX) , @PATH VARCHAR (MAX)                     
SET @PATH='J:\Backoffice\SL_AUTO\INACTIVE_CODE\MCX\INPUT\INACTIVE_CODE.CSV'                      
                 
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
      
IF OBJECT_ID(N'DUSTBIN..TBL_INACTIVE_CODE_MCX') IS NOT NULL                
DROP TABLE TBL_INACTIVE_CODE_MCX      
      
SELECT DISTINCT A.CL_CODE,A.SHORT_NAME, B.Exchange, B.Segment, CONVERT(VARCHAR,B.ACTIVE_DATE,101) AS ACTIVE_DATE,CONVERT(VARCHAR,B.INACTIVE_FROM,101) AS INACTIVE_FROM, (CASE WHEN b.INACTIVE_FROM LIKE '%2049%' THEN 'ACTIVE' ELSE 'INACTIVE' END) AS STATUS,
B.Deactive_Remarks , B.Deactive_value
INTO TBL_INACTIVE_CODE_MCX   
FROM MSAJAG.DBO.CLIENT_DETAILS A INNER JOIN MSAJAG.DBO.CLIENT_BROK_DETAILS B ON A.CL_CODE = B.CL_CODE 
INNER JOIN #CODE C ON C.CLTCODE=A.CL_CODE and B.Exchange in ('MCX') and  B.Segment='FUTURES'

Alter table TBL_INACTIVE_CODE_MCX add  last_trade_date varchar(12)

--Alter table TBL_INACTIVE_CODE_MCX  ALTER COLUMN  last_trade_date varchar(12)



SELECT PARTY_CODE,LAST_TRADE_DATE=MAX(SAUDA_DATE)  into #last_trade_mcx 
FROM ANGELCOMMODITY.MCDX.DBO.FOBILLVALAN WITH (NOLOCK)  
WHERE PARTY_CODE IN (SELECT * FROM #CODE)-- AND EXCHANGE='BSXFO'  
GROUP BY PARTY_CODE  



update M  set M.last_trade_date=N.LAST_TRADE_DATE from TBL_INACTIVE_CODE_MCX  M ,#last_trade_mcx N
where M.CL_CODE=N.PARTY_CODE



  
  --SELECT TOP 10 * FROM  MSAJAG.DBO.CLIENT_BROK_DETAILS 
      
--SELECT distinct  last_trade_date FROM DUSTBIN.DBO.TBL_INACTIVE_CODE_MCX  where   last_trade_date is null    
      
DECLARE @RPT_DATE VARCHAR(30)=REPLACE(CONVERT(VARCHAR(10),GETDATE(),3),'/','')      
DECLARE @FILENAME VARCHAR(100) = 'J:\Backoffice\SL_AUTO\INACTIVE_CODE\MCX\OUTPUT\' +'INACTIVE_CODE_MCX_' + @RPT_DATE + '.CSV'      
DECLARE @ALL VARCHAR(MAX)      
      
SET @ALL = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''CL_CODE'''',''''SHORT_NAME'''',''''Exchange'''',''''Segment'''',''''ACTIVE_DATE'''',''''INACTIVE_FROM'''',''''STATUS'''',''''Deactive_Remarks'''',''''Deactive_value'''',''''Last_Trade_Date'''''      
SET @ALL = @ALL+ ' UNION ALL SELECT * FROM DUSTBIN.DBO.TBL_INACTIVE_CODE_MCX'      
--SET @ALL = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT * FROM DUSTBIN.DBO.TBL_CALLING_DATA'      
PRINT @ALL      
SET @ALL=@ALL+' " QUERYOUT ' +@FILENAME+ ' -c -t"," -c -t"," -r"\n" -T'', NO_OUTPUT'      
PRINT @ALL      
EXEC(@ALL)      
                    
--DROP TABLE #CODE      
--DROP TABLE TBL_INACTIVE_CODE_MCX      
                    
SELECT 'INACTIVE CODE MCX DATA FILE EXPORTED TO ' + @FILENAME AS 'REMARK'

GO
