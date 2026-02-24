-- Object: PROCEDURE dbo.RPT_RETURNFIELDS_new
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------


Create PROC [dbo].[RPT_RETURNFIELDS_new]      
 @STATUSID VARCHAR(20),      
 @SUMMARYOPT CHAR(1),      
 @REPORTNAME VARCHAR(15)  
  
AS      
      
DECLARE      
@@RETURNFIELDS AS VARCHAR(1000)      
      
 SELECT  
  RETURNFIELDS
 FROM      
   TBL_MASTER_PARTYLEDGER_new      
 WHERE      
   REPORTNAME = @REPORTNAME      
   AND STATUSID = @STATUSID      
   AND SUMMARYOPT = @SUMMARYOPT

GO
