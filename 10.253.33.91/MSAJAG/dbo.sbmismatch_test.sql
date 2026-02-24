-- Object: PROCEDURE dbo.sbmismatch_test
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

        
        -- exec [sbmismatch_test]      
              
              
CREATE PROC [dbo].[sbmismatch_test]        
AS              
BEGIN              
 SET NOCOUNT ON              
/*      
DECLARE  @file VARCHAR(2000)                      
DECLARE @s as varchar(1000)                      
DECLARE @s1 as varchar(1000)       */      
        
--  insert into  sub_broker_mismatch      
--  select sub_broker,Name,city from  SUBBROKERS with(nolock) where SUB_BROKER not in      
--(select Sub_Broker FROM  [196.1.115.241].msajag.dbo.vwGetSubBrokerDetail_dummY with(nolock))      
        
    IF EXISTS(SELECT 1 FROM DBA_ADMIN.SYS.TABLES WHERE NAME ='test_Table')        
      DROP TABLE DBA_ADMIN..test_Table       
      
select distinct sub_broker,name,city into DBA_ADMIN..test_Table from sub_broker_mismatch      
       
      
DECLARE @FILE VARCHAR(MAX),@PATH VARCHAR(MAX) = '\\172.29.19.15\Public\subbrokermismatch\'                
SET @FILE = @PATH + 'sbmismatch_DATA_' + CONVERT(VARCHAR(11), GETDATE(), 112) + '.xls'                
              
  --Use BCP to copy files in character format from the target directly into the table.       
--SET @sql = 'bcp [MyDB].[dbo].[MyTable] in ' + @path + 'bcpFile.dat -c -T'      
      
--EXEC master..xp_cmdshell @sql      
        
             
 DECLARE @S VARCHAR(MAX)               
  SET @S = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''sub_broker'''',''''Name'''',''''city'''''        
            
SET @S = @S + 'union all SELECT sub_broker,Name,city FROM DBA_ADMIN.dbo.test_Table" QUERYOUT '+@FILE+' -c -SAngelNseCM -UE21209 -PSql@user1'''            
       
        
         
         
PRINT (@S)                                    
EXEC(@S)        
    
EXEC MSDB.DBO.SP_SEND_DBMAIL                                
@PROFILE_NAME ='BO SUPPORT',                                
@RECIPIENTS ='devshree.pratap@angelbroking.com',             
--@COPY_RECIPIENTS='bi.dba@angelbroking.com;nivrutti.shelke@angelbroking.com;fareed.sarang@angelbroking.com',                                
               
--@FILE_ATTACHMENTS= @FILE,                               
@BODY = 'PLEASE FIND DP AND TRADING DETAILS SAVED IN \\172.29.19.15\Public\subbrokermismatch\sbmismatch_DATA_. ',                                
@BODY_FORMAT ='HTML',                                
@SUBJECT ='SB Mismatch Data'           
           
           
END          
          
SET NOCOUNT OFF

GO
