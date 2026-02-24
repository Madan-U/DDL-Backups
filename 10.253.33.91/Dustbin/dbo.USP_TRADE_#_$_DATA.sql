-- Object: PROCEDURE dbo.USP_TRADE_#_$_DATA
-- Server: 10.253.33.91 | DB: Dustbin
--------------------------------------------------

---- // USE DUSTBIN   --- // ANAND1                      
---- // DESCRIPTION :- SHASHI SONI TRADE DETAIL OF $ AND # DATA. CREATED BY HRISHI                      
-- EXEC [USP_TRADE_#_$_DATA]
      
CREATE PROC [dbo].[USP_TRADE_#_$_DATA]
AS    
    
DECLARE @SQL VARCHAR (MAX) ,@SQL2 VARCHAR (MAX), @SQLFINAL VARCHAR (MAX) , @PATH VARCHAR (MAX)                             
SET @PATH='J:\Backoffice\SL_AUTO\RAVINDRA_R\TRADE_$_#_DATA\INPUT\DATE.TXT'                              
    
IF OBJECT_ID(N'tempdb..#FDATE') IS NOT NULL                        
DROP TABLE #FDATE    
CREATE TABLE #FDATE (FDATE VARCHAR(50))    
                            
SET @SQL='BULK INSERT #FDATE FROM ' + ''''+ @PATH +''''                            
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
                            
--SELECT TOP 10 * FROM #FDATE    
    
DECLARE @FDATE VARCHAR(11)    
SELECT @FDATE=FDATE FROM #FDATE              
PRINT @FDATE    

SELECT SAUDA_DATE,PARTY_CODE,BRANCH_CD,SUB_BROKER,ORDER_NO,ORDER_TIME,TRADE_NO,TRADE_TIME,SCRIPNAME,QTY,SELL_BUY,MARKETRATE,REMARK_ID,REMARK_DESC,EXCHANGE,SEGMENT,USER_ID
INTO #TEMP
FROM MSAJAG.DBO.COMMON_CONTRACT_DATA WHERE SAUDA_DATE =@FDATE AND REMARK_DESC <> '' AND TRADE_NO<>''

--SELECT * FROM #TEMP
  
IF OBJECT_ID(N'DUSTBIN..[TBL_TRADE_#_$_DATA]') IS NOT NULL                  
DROP TABLE DUSTBIN.DBO.TBL_TRADE_#_$_DATA        
      
SELECT CONVERT(VARCHAR(11),SAUDA_DATE) AS SAUDA_DATE,PARTY_CODE,BRANCH_CD,SUB_BROKER,ORDER_NO,ORDER_TIME,TRADE_NO,TRADE_TIME,SCRIPNAME,CONVERT(VARCHAR(20),QTY) AS QTY,SELL_BUY
,CONVERT(VARCHAR(20),MARKETRATE) AS MARKETRATE,REMARK_ID,REMARK_DESC,EXCHANGE,SEGMENT,USER_ID
INTO DUSTBIN.DBO.[TBL_TRADE_#_$_DATA]       
FROM #TEMP
      
--SELECT TOP 10 * FROM DUSTBIN.DBO.[TBL_TRADE_#_$_DATA] 
        
--DECLARE @RPT_DATE VARCHAR(30)=REPLACE(CONVERT(VARCHAR(10),GETDATE(),3),'/','')        
DECLARE @FILENAME VARCHAR(100) = 'J:\Backoffice\SL_AUTO\RAVINDRA_R\TRADE_$_#_DATA\OUTPUT\' +'TRADE_$_#_DATA' + '.CSV'      
DECLARE @ALL VARCHAR(MAX)        
        
SET @ALL = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''SAUDA_DATE'''',''''PARTY_CODE'''',''''BRANCH_CD'''',''''SUB_BROKER'''',''''ORDER_NO'''',''''ORDER_TIME'''',''''TRADE_NO'''',''''TRADE_TIME'''',''''SCRIPNAME'''',''''QTY'''',''''SELL_BUY'''',''''MARKETRATE'''',''''REMARK_ID'''',''''REMARK_DESC'''',''''EXCHANGE'''',''''SEGMENT'''',''''USER_ID'''''        
SET @ALL = @ALL+ ' UNION ALL SELECT * FROM DUSTBIN.DBO.[TBL_TRADE_#_$_DATA]'      
PRINT @ALL        
SET @ALL=@ALL+' " QUERYOUT ' +@FILENAME+ ' -c -t"," -c -t"," -r"\n" -T'', NO_OUTPUT'        
PRINT @ALL        
EXEC(@ALL)        
    
DROP TABLE #TEMP    
DROP TABLE #FDATE    
    
SELECT 'TRADE_$_# DATA FILE EXPORTED TO ' + @FILENAME AS 'REMARK'

GO
