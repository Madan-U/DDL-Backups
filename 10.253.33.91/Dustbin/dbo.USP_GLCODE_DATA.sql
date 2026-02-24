-- Object: PROCEDURE dbo.USP_GLCODE_DATA
-- Server: 10.253.33.91 | DB: Dustbin
--------------------------------------------------

---- // USE DUSTBIN   --- // ANAND1                      
---- // DESCRIPTION :- SWAPNIL KANK NEED FRONTEND FOR LEDGER DATA. CREATED BY HRISHI                      
-- EXEC [USP_GLCODE_DATA]
      
CREATE PROC [dbo].[USP_GLCODE_DATA]  
AS
    
DECLARE @SQL VARCHAR (MAX) ,@SQL2 VARCHAR (MAX), @SQLFINAL VARCHAR (MAX) , @PATH VARCHAR (MAX)                             
SET @PATH='J:\Backoffice\SL_AUTO\SWAPNIL_K\GLCODE_DATA\INPUT\DATE.txt'                              
    
IF OBJECT_ID(N'tempdb..#INPUT_DATA') IS NOT NULL                        
DROP TABLE #INPUT_DATA    
--CREATE TABLE #INPUT_DATA (GLCODE VARCHAR(50),FDATE DATE,TDATE DATE)  ---- COMENTED ON 26 FEB 2024
CREATE TABLE #INPUT_DATA (FDATE DATE,TDATE DATE)    
                            
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
                            
--SELECT TOP 10 * FROM #INPUT_DATA  

DECLARE @FDATE DATE , @TDATE DATE

SET @FDATE=(SELECT TOP 1 FDATE FROM #INPUT_DATA)
PRINT @FDATE
SELECT @TDATE=(SELECT TOP 1 TDATE FROM #INPUT_DATA)
PRINT @TDATE

select * INTO #TEMP
from ACCOUNT.DBO.Ledger L with (nolock) --INNER JOIN #INPUT_DATA I ON L.CLTCODE=I.GLCODE  ---- COMENTED ON 26 FEB 2024
where --vtyp='8' and  ---- COMENTED ON 26 FEB 2024
ENTEREDBY in ('e78077','B_E87195','B_e78077','e65199','B_e65199','E87195','cs0509','B_cs0509','M_e87195','M_e78077','M_e65199','e_cs0509') 
and CONVERT(DATE,VDT) Between @FDATE and @TDATE
and CHECKEDBY <>'Offline'
  
--  DROP TABLE #TEMP

--SELECT * FROM #TEMP
  
IF OBJECT_ID(N'DUSTBIN..TBL_GLCODE_DATA') IS NOT NULL                  
DROP TABLE DUSTBIN.DBO.TBL_GLCODE_DATA        
      
SELECT CONVERT(VARCHAR(20),VTYP) AS VTYP,VNO,CONVERT(VARCHAR(11),EDT) AS EDT,CONVERT(VARCHAR(20),LNO) AS LNO,ACNAME,DRCR,CONVERT(VARCHAR(30),VAMT) AS VAMT,CONVERT(VARCHAR(11),VDT) AS VDT,VNO1,REFNO,CONVERT(VARCHAR(30),BALAMT) AS BALAMT
,CONVERT(VARCHAR(20),NODAYS) AS NODAYS,CONVERT(VARCHAR(11),CDT) AS CDT,CLTCODE,BOOKTYPE,ENTEREDBY,CONVERT(VARCHAR,PDT) AS PDT,CHECKEDBY,CONVERT(VARCHAR(20),ACTNODAYS) AS ACTNODAYS,NARRATION
INTO DUSTBIN.DBO.TBL_GLCODE_DATA       
FROM #TEMP      
      
--SELECT TOP 10 * FROM DUSTBIN.DBO.TBL_GLCODE_DATA
        
--DECLARE @RPT_DATE VARCHAR(30)=REPLACE(CONVERT(VARCHAR(10),GETDATE(),3),'/','')        
DECLARE @FILENAME VARCHAR(100) = 'J:\Backoffice\SL_AUTO\SWAPNIL_K\GLCODE_DATA\OUTPUT\' +'GLCODE_DATA' + '.CSV'      
DECLARE @ALL VARCHAR(MAX)        
        
SET @ALL = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''VTYP'''',''''VNO'''',''''EDT'''',''''LNO'''',''''ACNAME'''',''''DRCR'''',''''VAMT'''',''''VDT'''',''''VNO1'''',''''REFNO'''',''''BALAMT'''',''''NODAYS'''',''''CDT'''',''''CLTCODE'''',''''BOOKTYPE'''',''''ENTEREDBY'''',''''PDT'''',''''CHECKEDBY'''',''''ACTNODAYS'''',''''NARRATION'''''        
SET @ALL = @ALL+ ' UNION ALL SELECT * FROM DUSTBIN.DBO.TBL_GLCODE_DATA'      
PRINT @ALL        
SET @ALL=@ALL+' " QUERYOUT ' +@FILENAME+ ' -c -t"," -c -t"," -r"\n" -T'', NO_OUTPUT'        
PRINT @ALL        
EXEC(@ALL)        
    
DROP TABLE #TEMP    
DROP TABLE #INPUT_DATA    
    
SELECT 'GLCODE DATA FILE EXPORTED TO ' + @FILENAME AS 'REMARK'

GO
