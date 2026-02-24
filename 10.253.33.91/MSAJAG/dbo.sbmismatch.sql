-- Object: PROCEDURE dbo.sbmismatch
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

                    
    
CREATE PROC [dbo].[sbmismatch]    
    
AS    
    
BEGIN    
    
SET NOCOUNT ON    
    
truncate table sub_broker_mismatch --to clear previous data    
    
     --select * from    sub_broker_mismatch      
    
  insert into  sub_broker_mismatch            
    
  select sub_broker,Name,city,branch_code from  SUBBROKERS with(nolock) where SUB_BROKER not in            
    
(select Sub_Broker FROM  vwGetSubBrokerDetail_dummY with(nolock))            
    
    IF EXISTS(SELECT 1 FROM DBA_ADMIN.SYS.TABLES WHERE NAME ='test_Table')              
    
      DROP TABLE DBA_ADMIN..test_Table             
    
select distinct sub_broker,name,city,branch_code into DBA_ADMIN..test_Table from sub_broker_mismatch            
      
    
DECLARE @FILE VARCHAR(MAX),@PATH VARCHAR(MAX) = '\\172.29.19.16\Public\subbrokermismatch\'                      
    
SET @FILE = @PATH + 'sbmismatch_DATA_' + CONVERT(VARCHAR(11), GETDATE(), 112) + '.xls'                      
    
    
 DECLARE @S VARCHAR(MAX)                     
    
  SET @S = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''sub_broker'''',''''Name'''',''''city'''',''''branch_code'''''              
    
SET @S = @S + 'union all SELECT sub_broker,Name,city,branch_code FROM DBA_ADMIN.dbo.test_Table" QUERYOUT '+@FILE+' -c -SAngelNseCM -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'''                  
    
            
    
PRINT (@S)                                          
    
EXEC(@S)              
    
          
EXEC MSDB.DBO.SP_SEND_DBMAIL                                      
    
@PROFILE_NAME ='BO SUPPORT',                                      
    
@RECIPIENTS ='shashi.soni@angelbroking.com;Lalitendu.Acharya@angelbroking.com;parag.parab@angelbroking.com;updationteam@angelbroking.com',                  

                     
    
--@FILE_ATTACHMENTS= @FILE,                                     
    
@BODY = 'PLEASE FIND SB MISMATCH DETAILS SAVED IN \\172.29.19.16\Public\subbrokermismatch\sbmismatch_DATA_. ' ,                                     
    
@BODY_FORMAT ='HTML',                                     
    
@SUBJECT ='SB Mismatch Data'                 
    
                
    
                 
    
END                
    
                
    
SET NOCOUNT OFF

GO
