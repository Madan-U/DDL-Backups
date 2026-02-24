-- Object: PROCEDURE dbo.USP_STANDARD_LEDGER
-- Server: 10.253.33.91 | DB: scratchpad
--------------------------------------------------

         
---- // DESCRIPTION :- PRAMILA SHELAR REQUIRED Standard Ledger DATA. CREATED BY Akshay M              
              
CREATE PROC [dbo].[USP_STANDARD_LEDGER]    
(@FROMDATE varchar(11),@TODATE varchar(11))
AS        
DECLARE @SQL VARCHAR (MAX) ,@SQL2 VARCHAR (MAX), @SQLFINAL VARCHAR (MAX) , @PATH VARCHAR (MAX)
SET @PATH='J:\BACKOFFICE\Export\nayan\INPUT\StandardLedger.CSV'                
           
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

ALTER table #CODE
ADD SNO int identity(1,1)


DECLARE @CNT INT, @FROMCNT INT , @clcode varchar(50),@maxcount int
 select @maxcount=MAX(SNO) from #CODE
SET @FROMCNT =1 
 
 WHILE(@FROMCNT<=@maxcount) 
		
 BEGIN 

Select @clcode =CLTCODE from #CODE WHERE SNO= @FROMCNT

IF OBJECT_ID(N'DUSTBIN..led_sebi') IS NOT NULL  
DROP TABLE DUSTBIN.DBO.led_sebi
  
EXEC DUSTBIN..API_CLIENT_FUNDS_REPORTING_for_Sebi @FROMDATE,@TODATE,@clcode,@clcode  

DECLARE @SQL1 VARCHAR(8000)
SELECT @SQL1 = ' BCP " SELECT DATA = DATA  FROM DUSTBIN.DBO.led_sebi ORDER BY SNO" QUERYOUT J:\\backoffice\Export\nayan\' + CONVERT(VARCHAR(11),@clcode)+'.CSV -r 0x0a -c -t "," -Sanand1 -UAOLINHOUSE -Pe$$gnfDTVs2455GZAcc'
		
EXEC MASTER.DBO.XP_CMDSHELL @SQL1, NO_OUTPUT 
 SET @FROMCNT=@FROMCNT+1

 	
 END
 
 SELECT 'STANDARD LEDGER DATA FILE EXPORTED TO J:\\backoffice\Export\nayan\' AS 'REMARK'

GO
