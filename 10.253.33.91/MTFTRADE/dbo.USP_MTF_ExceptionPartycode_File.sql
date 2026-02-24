-- Object: PROCEDURE dbo.USP_MTF_ExceptionPartycode_File
-- Server: 10.253.33.91 | DB: MTFTRADE
--------------------------------------------------

    
CREATE procedure [dbo].[USP_MTF_ExceptionPartycode_File]                   
as                      
BEGIN                      
 SET NOCOUNT ON           
BEGIN TRY          
DECLARE @MESS AS VARCHAR(4000),@emailto as varchar(1000),@emailcc as varchar(1000),@emailbcc as varchar(1000),@sub as varchar(100)                                  
  SELECT @emailto='rohan.shah@angelbroking.com;rahulc.shah@angelbroking.com;paresh.natekar@angelbroking.com'         
  select @emailcc=''--'rahulc.shah@angelbroking.com'        
   select @emailbcc='neha.naiwar@angelbroking.com;pramod.jadhav@angelbroking.com'            
    
  
select distinct * into ##party from mtf_ctd_exception with(nolock)   where CAST(request_date as date)=CAST(GETDATE() as date)         
    
 if(select COUNT(1) from ##party)>0  
 begin  
    DECLARE @s VARCHAR(MAX) = ''                                          
   declare @FileName as varchar(100) = 'Exception_Partycode'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                                                 
      declare @FilePath varchar(200) ='' /* '\\196.1.115.183\d$\upload\CMS_Test\'+@FileName  */                         
      select @FilePath='\\INHOUSELIVEAPP1-FS.angelone.in\upload1\'+@FileName            
                                       
      SET @s = 'exec MASTER.dbo.xp_cmdshell ' + ''''                                           
      SET @s = @s + 'bcp "select * from ##party" queryout '+ @FilePath + ' -c -t, -SABVSNSECM.angelone.in -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                                                                            
         
       
             
      SET @s = @s + ''''              
      EXEC(@s)     
            
                                         
SET @MESS='Dear All,<br><Br>Good Evening!!!<br><Br>Please refer the attached file of exception clients.<Br><Br>'                                          
SET @MESS=@MESS+'<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>Regards,<br><Br>(In-house system)'                                      
set @sub ='Exception Clients of MTF CTD'                         
                          
                            
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
  drop table ##party    
  
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
