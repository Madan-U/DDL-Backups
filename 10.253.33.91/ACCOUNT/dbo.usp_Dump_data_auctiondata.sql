-- Object: PROCEDURE dbo.usp_Dump_data_auctiondata
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROCEDURE [dbo].[usp_Dump_data_auctiondata]    
AS                  
BEGIN      
 Set nocount on     
 if exists (select 1 from sys.tables where name='auctiondata')    
 begin    
  Drop table auctiondata    
 end    
    
 SELECT CLTCODE,VAMT,DRCR,NARRATION,CONVERT(VARCHAR(10),VDT,120) AS VDT,'NSE'AS EXCHANGE  into auctiondata  FROM LEDGER    
  WHERE VTYP ='15' AND NARRATION LIKE '%FINAL%'    
  AND VDT >=CONVERT(VARCHAR(10),GETDATE(),120)    
  AND CLTCODE IN ( Select CL_CODE FROM MSAJAG.dbo.Client1 WHERE CL_TYPE ='NBF')    
 UNION ALL    
 SELECT CLTCODE,VAMT,DRCR,NARRATION,CONVERT(varchar(10),VDT,120) AS VDT,'BSE'AS EXCHANGE    
  FROM AngelBSECM.ACCOUNT_AB.DBO.LEDGER    
  WHERE VTYP ='15' AND NARRATION LIKE '%FINAL%'    
  AND VDT >=CONVERT(vARCHAR(10),GETDATE(),120)    
  AND CLTCODE IN ( Select CL_CODE FROM AngelBSECM.BSEDB_AB.dbo.Client1 WHERE CL_TYPE ='NBF')    
    
 -----------------------------------------------------------------------------------------------------    
 DECLARE @COUNT int,@FILE VARCHAR(2000),@S AS VARCHAR(1000),@S1 AS VARCHAR(1000),@attach as varchar(500)                   
 DECLARE @mess as varchar(4000),@email varchar(2000)     
     
 --Select * FROM auctiondata                
              
              
 SELECT @COUNT=COUNT(*) FROM auctiondata WITH(NOLOCK)                        
                     
 IF @COUNT>0                        
 BEGIN                        
                        
  SET @FILE = (SELECT 'AUCTIONDATA'+REPLACE(CONVERT(VARCHAR(12),GETDATE(),103),'/','')+'.XLS')                       
                                      
  SET @S = 'EXEC XP_CMDSHELL '+ '''' +'BCP  "select ''''CLTCODE'''',''''VAMT'''',''''DRCR'''',''''Narration'''',''''VDT'''',''''exchange''''  union all SELECT cltcode,cast(vamt as varchar(20)),DRCR,Narration,VDT,Exchange FROM Account.DBO.auctiondata" QUERYOUT '+'\\196.1.115.152\public\dba\'+@FILE+' -c -Sanand1 -Ue21209 -PSql@user1'                                    
                    
                                              
  SET @S1= @S+''''                                                                                                                                  
  exec (@S1)          
        
  set @attach='\\196.1.115.152\public\dba\'+@FILE --+''                  
  set @mess='Auction Data For the Date'+'  '+CONVERT(VARCHAR(11),GETDATE(),120)        
                                              
         
  set @email='sandip.tote@angelbroking.com;amol.salvi@angelbroking.com;krunald.patel@angelbroking.com;nbfchelpdesk@angelbroking.com'    
        
  exec msdb.dbo.sp_send_dbmail                                                                                                                                       
   @recipients  = @email,                                                                                                           
   @copy_recipients ='siva.kopparapu@angelbroking.com',                                                                            
   @blind_copy_recipients='',                    
   @profile_name = 'DBA',                                                                                                                                              
   @body_format ='html',                                                                          
   @subject = 'Auction data',                                                  
   @file_attachments =@attach,                                                                                                      
   @body =@mess     
    
 end    
 Set nocount off    
END

GO
