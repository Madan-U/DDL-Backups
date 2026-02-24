-- Object: PROCEDURE dbo.RPT_CLIENT_TAXES_MISMATCH_NSE
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE PROCEDURE [dbo].[RPT_CLIENT_TAXES_MISMATCH_NSE]     
AS    
    
    
BEGIN    
    
DECLARE @RECORDCOUNT INT     
    
      
    
 select @RECORDCOUNT = ISNULL(COUNT(*), 0)  from msajag..Clienttaxes_New   where getdate() between fromdate and todate
and Turnover_Tax<>'0.003250'and Sebiturn_Tax='0.000150'    
    


IF (@RECORDCOUNT > 0)    
BEGIN    
    
    
    
EXEC MSDB.DBO.SP_SEND_DBMAIL    
    @PROFILE_NAME = 'CLASS AUTO PROCESS TEST PROFILE',    
    @RECIPIENTS = 'updationteam@angelbroking.com',    
  
    @QUERY = 'select exchange,party_code,Turnover_Tax,Sebiturn_Tax from msajag..clienttaxes_new   where getdate() between fromdate and todate
and Turnover_Tax<>''0.003250''and Sebiturn_Tax=''0.000150'' ' ,  
   
      @SUBJECT = 'CLIENT  TURNOVER/SEBI TAXES  ISSUE NSE',    
       @BODY = 'CLIENTS TAXES ISSUE ' ,    
    @ATTACH_QUERY_RESULT_AS_FILE = 1 ;    
    
END    
ELSE    
BEGIN    
    
      EXEC MSDB.DBO.SP_SEND_DBMAIL    
      @PROFILE_NAME = 'CLASS AUTO PROCESS TEST PROFILE',    
       @RECIPIENTS = 'updationteam@angelbroking.com',     
            @BODY = 'CLIENTS TAXES ISSUE ',     
            @SUBJECT = 'CLIENT TURNOVER/SEBI TAXES ISSUE NSE'    
    
END    
END;

GO
