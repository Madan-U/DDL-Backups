-- Object: PROCEDURE citrus_usr.Sp_LogErrors
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE Proc [citrus_usr].[Sp_LogErrors]          
@Pa_Errorcode varchar(100),          
@Pa_ErrorDescp varchar(8000),          
@Pa_ErrorModule Varchar(8000),          
@Pa_Userid varchar(100),      
@PA_ErrMsg varchar(1000) OUTPUT         
as          
begin          
 set nocount on          
          
 if not exists(select err_code from tblerror where err_code = @Pa_Errorcode)          
 begin       
  --     
  INSERT INTO tblerror VALUES(@Pa_Errorcode,@Pa_ErrorDescp)          
  --  
 end          
 INSERT INTO ErrorLog (Error_code,Error_DateTime,Error_Module,Error_Created_By) VALUES(@Pa_Errorcode,getdate(),@Pa_ErrorModule,@Pa_Userid)          
        
 select top 1 @PA_ErrMsg = Err_Description from tblerror where err_code = @Pa_Errorcode          
 
end

GO
