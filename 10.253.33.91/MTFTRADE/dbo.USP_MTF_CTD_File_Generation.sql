-- Object: PROCEDURE dbo.USP_MTF_CTD_File_Generation
-- Server: 10.253.33.91 | DB: MTFTRADE
--------------------------------------------------

  
CREATE procedure [dbo].[USP_MTF_CTD_File_Generation]                 
as                    
BEGIN                    
 SET NOCOUNT ON         
BEGIN TRY        
DECLARE @MESS AS VARCHAR(4000),@emailto as varchar(1000),@emailcc as varchar(1000),@emailbcc as varchar(1000),@sub as varchar(100)                                
  SELECT @emailto='paresh.natekar@angelbroking.com;darshit.kapadia@angelbroking.com;swapnils.tadge@angelbroking.com;csorm@angelbroking.com;Vishal@angelbroking.com;tushar.jorigal@angelbroking.com;anil.wandre@angelone.in;dashrath.mane@angelone.in;sushant.khandekar@angelone.in;himanshu.patil@angelone.in'       
  select @emailcc=''--'rahulc.shah@angelbroking.com'      
   select @emailbcc='neha.naiwar@angelbroking.com;pramod.jadhav@angelbroking.com'          
  
  truncate table tbl_MTF_CTD_file
select * into #final_party_MTF from mtf_ctd with(nolock)  where CAST(request_date as date)=CAST(GETDATE() as date)
and isnull(batchtime,'')='' and isfilegenerated=0
        
select a.party_code,c.scrip_cd as scrip,c.series,a.ISIN,a.qty,'12033200' as sourceDP,'1203320030135829' as Clientdp,b.bankid,b.cltdpid,  
'BTC' as cl_type  
 into #file_MTF from #final_party_MTF a 
left join ANGELDEMAT.msajag.dbo.multiisin c with(nolock) on a.isin=c.isin
left join  
msajag.dbo.client4 b with(nolock)  on a.party_code=b.cl_code   
 where  defdp=1 and Depository='CDSL'  
 
 insert into tbl_MTF_CTD_file
 SELECT  party_code,scrip,series,ISIN,qty as releasedQty,sourceDP,Clientdp,bankid,cltdpid,cl_type  from #file_MTF        
  
 if(select COUNT(1) from tbl_MTF_CTD_file)>0
 begin
    DECLARE @s VARCHAR(MAX) = ''                                        
   declare @FileName as varchar(100) = 'MTF_CTD'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                                               
      declare @FilePath varchar(200) ='' /* '\\196.1.115.183\d$\upload\CMS_Test\'+@FileName  */                       
      select @FilePath='\\INHOUSELIVEAPP1-FS.angelone.in\upload1\'+@FileName          
                                     
      SET @s = 'exec MASTER.dbo.xp_cmdshell ' + ''''                                         
      SET @s = @s + 'bcp "select * from mtftrade.dbo.tbl_MTF_CTD_file" queryout '+ @FilePath + ' -c -t, -SABVSNSECM.angelone.in -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                                                                          
       
     
           
      SET @s = @s + ''''            
      EXEC(@s)   
          
                                       
SET @MESS='Dear All,<br><Br>Good Evening!!!<br><Br>Please refer the attached file for MTF CTD File.<Br><Br>'                                        
SET @MESS=@MESS+'<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>Regards,<br><Br>(In-house system)'                                    
set @sub ='MTF Convert to Delivery(CTD) Release File'                       
                        
                          
 DECLARE @s1 varchar(500)                        
 SET @s1 = @FilePath                 
                          
 EXEC MSDB.DBO.SP_SEND_DBMAIL                                    
 @RECIPIENTS =@emailto,                                    
 @COPY_RECIPIENTS = @emailcc,                                    
 @blind_copy_recipients=@emailbcc,                          
 @PROFILE_NAME = 'AngelBroking',                                    
 @BODY_FORMAT ='HTML',                                    
 @SUBJECT = @sub ,                                    
 @FILE_ATTACHMENTS =@s1,                                    
 @BODY =@MESS                            
 End           
  drop table #final_party_MTF  
  drop table #file_MTF 

--update mtf_ctd set batchtime=GETDATE(),isfilegenerated=1 where CAST(request_date as date)=CAST(GETDATE() as date)

update a set batchtime=GETDATE(),isfilegenerated=1 from mtf_ctd a join tbl_MTF_CTD_file b on a.party_code=b.party_code and
a.isin=b.ISIN  where CAST(request_date as date)=CAST(GETDATE() as date)

  END TRY                                    
BEGIN CATCH                                    
                                                                                               
  insert into Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                                                
  select GETDATE(),'USP_MTF_CTD_File_Generation',ERROR_LINE(),ERROR_MESSAGE()                                                                
                          
  DECLARE @ErrorMessage NVARCHAR(4000);                       
  SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                            
  RAISERROR (@ErrorMessage , 16, 1);                                                                                          
                                    
END CATCH                 
 SET NOCOUNT OFF;                   
END

GO
