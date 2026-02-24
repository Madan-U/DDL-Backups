-- Object: PROCEDURE citrus_usr.pr_ins_upd_digsign
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE procedure [citrus_usr].[pr_ins_upd_digsign]    
(    
	@pa_id   varchar(10)    
   ,@pa_action  varchar(20)    
   ,@pa_login_name varchar(20)     
   ,@pa_dpm_dpid varchar(25)	  
   ,@pa_signame  varchar(100)    
   ,@pa_signemail varchar(100)    
   ,@pa_fromdt  varchar(10)    
   ,@pa_todt  varchar(10)  
   ,@pa_user_name varchar(100)  
   ,@pa_ref_cur  varchar(8000) out    
)    
    
As    
    
BEGIN    
--    
 DECLARE  @ROWDELIMITER  CHAR(4)    
		, @DELIMETER        VARCHAR(10)    
        , @@REMAININGSTRING VARCHAR(8000)    
        , @@CURRSTRING      VARCHAR(8000)    
        , @@FOUNDAT         INTEGER    
	    , @@DELIMETERLENGTH INT    
	    , @l_id    numeric(10,0)     
	    , @l_error   int    
	    , @t_errorstr  varchar(200)         
   
 SET @ROWDELIMITER     = '*|~*'   
 SET @DELIMETER        = '%'+ @ROWDELIMITER + '%'    
 SET @@DELIMETERLENGTH = LEN(@ROWDELIMITER)    
 SET @@REMAININGSTRING = @pa_id  
  
WHILE @@REMAININGSTRING <> ''    
  BEGIN    
   --    
   SET @@FOUNDAT = 0    
   SET @@FOUNDAT =  PATINDEX('%'+@DELIMETER+'%',@@REMAININGSTRING)    
   --    
   IF @@FOUNDAT > 0    
   BEGIN    
     --    
     SET @@CURRSTRING      = SUBSTRING(@@REMAININGSTRING, 0,@@FOUNDAT)    
     SET @@REMAININGSTRING = SUBSTRING(@@REMAININGSTRING, @@FOUNDAT+@@DELIMETERLENGTH,LEN(@@REMAININGSTRING)- @@FOUNDAT+@@DELIMETERLENGTH)    
     --    
   END    
   ELSE    
   BEGIN    
     --    
     SET @@CURRSTRING      = @@REMAININGSTRING    
     SET @@REMAININGSTRING = ''    
     --    
   END    
   --      
  
 IF @PA_ACTION = 'INS'      
 BEGIN      
 --      
   SELECT @l_id = ISNULL(MAX(alwd_id),0) + 1 FROM allowed_signatory    
 --      
 END      
    IF @PA_ACTION = 'INS'      
 BEGIN    
    --    
  BEGIN TRANSACTION    
  --    
   BEGIN     
   --    
    INSERT INTO allowed_signatory     
    (   alwd_id    
       ,alwd_sign_name    
       ,alwd_sign_email    
       ,alwd_from_dt    
       ,alwd_to_dt           
       ,alwd_dpm_dpid
       ,alwd_user_name
       ,alwd_created_by    
       ,alwd_created_dt    
       ,alwd_lst_upd_by    
       ,alwd_lst_upd_dt    
       ,alwd_deleted_ind    
    )    
    VALUES    
    (   @l_id    
       ,@pa_signame    
       ,@pa_signemail    
       ,convert(datetime,@pa_fromdt,103)    
       ,convert(datetime,@pa_todt,103)        
	   ,@pa_dpm_dpid
       ,@pa_user_name
       ,@pa_login_name    
       ,getdate()      
       ,@pa_login_name      
       ,getdate()      
       ,1      
    )    
    
   --    
   END    
   SET @l_error = @@error    
   IF @l_error <> 0    
   BEGIN    
   --    
     ROLLBACK TRANSACTION     
    
     IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)    
     BEGIN    
     --    
       SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)    
     --    
     END    
     ELSE    
     BEGIN    
     --    
       SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'    
     --    
     END    
   --    
   END    
   ELSE    
    BEGIN    
    --    
     SELECT @t_errorstr = '1'    
     COMMIT TRANSACTION    
    --    
    END    
    --    
    END    
    ELSE    
    IF @PA_ACTION = 'DEL'    
    BEGIN    
	--    
	 BEGIN TRANSACTION  

	   DELETE FROM allowed_signatory    
	   WHERE alwd_id = CONVERT(INT,@@CURRSTRING)   
	   AND alwd_deleted_ind = 1    
	--    
	END    
    SET @l_error = @@error    
    IF @l_error <> 0    
    BEGIN    
    --    
     ROLLBACK TRANSACTION     
    
     IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)    
     BEGIN    
     --    
       SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)    
     --    
     END    
     ELSE    
     BEGIN    
     --    
       SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'    
     --    
     END    
  --    
    END    
    ELSE    
    BEGIN    
    --    
     SELECT @t_errorstr = '1'    
     COMMIT TRANSACTION    
    --    
    END    
   --  
   END  
 SET @pa_ref_cur = @t_errorstr    
--    
END

GO
