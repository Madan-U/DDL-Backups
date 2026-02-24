-- Object: PROCEDURE dbo.RPT_MASTER_PARTYLEDGER
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

        
CREATE PROC RPT_MASTER_PARTYLEDGER        
 @FDATE VARCHAR(11),        
 @TDATE VARCHAR(11),        
 @STDDATE VARCHAR(11),        
 @LSTDATE VARCHAR(11),        
 @STATUSID VARCHAR(20),        
 @STATUSNAME VARCHAR(20),        
 @DISPLAYRPT VARCHAR(3),        
 @FPARTY VARCHAR(10),        
 @TPARTY VARCHAR(10),        
 @REPORTNAME varchar(15),        
 @SUMMARYOPT CHAR(1),  
 @SHOWZERO VARCHAR(1) = 'N'  
        
AS        
        
DECLARE        
@@CALLINGSP VARCHAR(100),        
@@SELECTQUERY VARCHAR(1000)        
        
        
 SELECT         
  @@CALLINGSP = CALLINGSP         
 FROM         
  TBL_MASTER_PARTYLEDGER        
 WHERE        
  REPORTNAME = @REPORTNAME        
  AND STATUSID = @STATUSID        
  AND SUMMARYOPT = @SUMMARYOPT        
      
        
SET @@SELECTQUERY = @@CALLINGSP + ' ''' + @FDATE + ''',''' + @TDATE + ''',''' + @STDDATE + ''',''' + @LSTDATE + ''',''' +  @STATUSID + ''',''' + @STATUSNAME + ''',''' + @DISPLAYRPT + ''',''' + @FPARTY + ''',''' + @TPARTY  + ''',''' + @REPORTNAME + ''''
print (@@SELECTQUERY)  
   
      
  
EXEC (@@SELECTQUERY)

GO
