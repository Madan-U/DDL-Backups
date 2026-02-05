-- Object: PROCEDURE citrus_usr.pr_block_clients
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--[pr_block_clients]	'0','INS','VISHAL','12345678','A|*~|E|*~|TRANSACTION|*~|client|*~|10000029|*~|*|~*',0,1,'*|~*','|*~|',''	 

CREATE proc [citrus_usr].[pr_block_clients]        
(        
@pa_id            VARCHAR(8000)               
,@pa_action       VARCHAR(20)               
,@pa_login_name      VARCHAR(20)              
,@pa_dpmdpid      VARCHAR(20)              
,@pa_values          VARCHAR(8000)                 
,@pa_chk_yn          INT  
,@pa_login_pr_entm_id numeric                
,@rowdelimiter       CHAR(4)       = '*|~*'                  
,@coldelimiter       CHAR(4)       = '|*~|'                  
,@pa_errmsg          VARCHAR(8000)  OUTPUT              
)        
as        
BEGIN        
   --        
  DECLARE @t_errorstr      VARCHAR(8000)                
      , @l_error         BIGINT                
      , @delimeter       VARCHAR(10)                
      , @remainingstring VARCHAR(8000)                
      , @currstring      VARCHAR(8000)                
      , @foundat         INT                
      , @delimeterlength INT             
      , @l_dpm_id        NUMERIC            
      , @l_dpam_id       NUMERIC               
      , @line_no         NUMERIC                
      , @delimeter_value VARCHAR(10)                
      , @delimeterlength_value VARCHAR(10)                
      , @remainingstring_value VARCHAR(8000)                
      , @currstring_value VARCHAR(8000)               
	  , @l_blkfor         VARCHAR(10)	
      , @l_rptname         VARCHAR(20)                 
      , @l_entitytype     VARCHAR(10)               
      , @l_entityid       varchar(20)              
      , @l_action  CHAR(1)              
      , @l_id     int      
      , @l_intid     int        
        
    SET @l_error         = 0                
    SET @t_errorstr      = ''                
    SET @delimeter        = '%'+ @ROWDELIMITER + '%'                
    SET @delimeter        = '%'+ @ROWDELIMITER + '%'                
    SET @remainingstring = @pa_id                   
            
    WHILE @remainingstring <> ''               
 BEGIN              
  --              
  SET @foundat = 0                
  SET @foundat =  PATINDEX('%'+@delimeter+'%',@remainingstring)              
  --              
  IF @foundat > 0                
  BEGIN                
   --                
   SET @currstring      = SUBSTRING(@remainingstring, 0,@foundat)                
   SET @remainingstring = SUBSTRING(@remainingstring, @foundat+@delimeterlength,LEN(@remainingstring)- @foundat+@delimeterlength)                
   --                
  END              
  ELSE                
  BEGIN                
   --                
   SET @currstring      = @remainingstring                
   SET @remainingstring = ''                
   --                
  END               
  IF @currstring <> ''                
  BEGIN                
   --                
   SET @delimeter_value        = '%'+ @rowdelimiter + '%'                
   SET @delimeterlength_value = LEN(@rowdelimiter)                
   SET @remainingstring_value = @pa_values              
   --               
   WHILE @remainingstring_value <> ''                
   BEGIN                
    --              
    SET @foundat = 0                
    SET @foundat = PATINDEX('%'+@delimeter_value+'%',@remainingstring_value)                
 --                
    IF @foundat > 0                
    BEGIN                
     --                
     SET @currstring_value      = SUBSTRING(@remainingstring_value, 0,@foundat)                
     SET @remainingstring_value = SUBSTRING(@remainingstring_value, @foundat+@delimeterlength_value,LEN(@remainingstring_value)- @foundat+@delimeterlength_value)                
     --                
    END                
    ELSE                
    BEGIN                
     --                
     SET @CURRSTRING_VALUE = @REMAININGSTRING_VALUE                
     SET @REMAININGSTRING_VALUE = ''                
     --                
    END               
    IF @currstring_value <> ''                
    BEGIN                
     --              
     SET @line_no = @line_no + 1                
     PRINT @currstring_value              
    SET @l_action             = citrus_usr.fn_splitval(@currstring_value,1)              
     IF @l_action = 'A' OR @l_action ='E'                
     BEGIN              
      --            
	  SET @l_blkfor		   = citrus_usr.fn_splitval(@currstring_value,2)                                        		  
      SET @l_rptname       = citrus_usr.fn_splitval(@currstring_value,3)                                        
      SET @l_entitytype    = CASE WHEN citrus_usr.fn_splitval(@currstring_value,4) = 'ENTITY' THEN 'E' ELSE 'C' END                                       
      SET @l_entityid      = citrus_usr.fn_splitval(@currstring_value,5)         
      SET @l_id            = citrus_usr.fn_splitval(@currstring_value,6)              
                               
     --              
     END              
     ELSE                
     BEGIN                
      --         
	  SET @l_blkfor		   = citrus_usr.fn_splitval(@currstring_value,5)    	       
      SET @l_rptname       = citrus_usr.fn_splitval(@currstring_value,2)  	
      SET @l_id           = citrus_usr.fn_splitval(@currstring_value,4)                 
      --                
     END               
            
	IF @l_blkfor = 'E'            
	BEGIN
	--
		IF @PA_ACTION = 'INS' OR @l_action = 'A'               
		BEGIN              
		  --          
			 select @l_intid = isnull(max(blkce_id),0) + 1 from blk_client_email      
			 begin transaction      
			 insert into blk_client_email      
				(        
			 blkce_id      
			 ,blkce_dpmdpid      
			 ,blkce_rptname      
			 ,blkce_entity_type      
			 ,blkce_entity_id      
			 ,blkce_created_by      
			 ,blkce_created_dt      
			 ,blkce_lst_upd_by      
			 ,blkce_lst_upd_dt      
			 ,blkce_deleted_ind      
				 )values      
			 (      
			 @l_intid      
			 ,@pa_dpmdpid      
			 ,@l_rptname      
			 ,@l_entitytype      
			 ,@l_entityid      
			 ,@pa_login_name      
			 ,getdate()      
			 ,@pa_login_name      
			 ,getdate()      
			 ,1      
			 )      
			 SET @l_error = @@error              
			 IF @l_error <> 0              
			 BEGIN              
			 --              
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
			       
			 ROLLBACK TRANSACTION               
			 --              
			 END              
			 ELSE              
			 BEGIN              
			 --              
			 COMMIT TRANSACTION

			 exec Pr_blocked_emailclients  @pa_dpmdpid,@l_rptname,@l_blkfor,@pa_login_pr_entm_id             
			 --              
			 END              
		--              
		END      ---INS ends             
	               
		IF @pa_action ='DEL' OR @l_action = 'D'              
		BEGIN            
		--      
			 begin transaction 
		      
			update blk_client_email    
			set blkce_deleted_ind = 0    
			,blkce_lst_upd_by = @pa_login_name    
			,blkce_lst_upd_dt = getdate()    
			where blkce_id = convert(int,@l_id)    
			and blkce_deleted_ind = 1 
			
			SET @l_error = @@error              
			 IF @l_error <> 0              
			 BEGIN              
			 --              
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
			       
			 ROLLBACK TRANSACTION               
			 --              
			 END              
			 ELSE              
			 BEGIN              
			 --              
			 COMMIT TRANSACTION
			 exec Pr_blocked_emailclients  @pa_dpmdpid,@l_rptname,@l_blkfor,@pa_login_pr_entm_id             
			 --              
			 END         
		--            
		END             
	 --
	--
	END
	ELSE
	BEGIN
	--
		IF @PA_ACTION = 'INS' OR @l_action = 'A'               
		BEGIN              
		  --          
			 select @l_intid = isnull(max(blkcp_id),0) + 1 from blk_client_print 
			 begin transaction      
			 insert into blk_client_print      
				(        
			 blkcp_id      
			 ,blkcp_dpmdpid      
			 ,blkcp_rptname      
			 ,blkcp_entity_type      
			 ,blkcp_entity_id      
			 ,blkcp_created_by      
			 ,blkcp_created_dt      
			 ,blkcp_lst_upd_by      
			 ,blkcp_lst_upd_dt      
			 ,blkcp_deleted_ind      
				 )values      
			 (      
			 @l_intid      
			 ,@pa_dpmdpid      
			 ,@l_rptname      
			 ,@l_entitytype      
			 ,@l_entityid      
			 ,@pa_login_name      
			 ,getdate()      
			 ,@pa_login_name      
			 ,getdate()      
			 ,1      
			 )      
			 SET @l_error = @@error              
			 IF @l_error <> 0              
			 BEGIN              
			 --              
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
			       
			 ROLLBACK TRANSACTION               
			 --              
			 END              
			 ELSE              
			 BEGIN              
			 --              
			 COMMIT TRANSACTION
			 exec Pr_blocked_emailclients  @pa_dpmdpid,@l_rptname,@l_blkfor,@pa_login_pr_entm_id             
			 --              
			 END              
		--              
		END      ---INS ends             
	               
		IF @pa_action ='DEL' OR @l_action = 'D'              
		BEGIN            
		--      
			 begin transaction 
		      
			update blk_client_print  
			set blkcp_deleted_ind = 0    
			,blkcp_lst_upd_by = @pa_login_name    
			,blkcp_lst_upd_dt = getdate()    
			where blkcp_id = convert(int,@l_id)    
			and blkcp_deleted_ind = 1 
			
			SET @l_error = @@error              
			 IF @l_error <> 0              
			 BEGIN              
			 --              
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
			       
			 ROLLBACK TRANSACTION               
			 --              
			 END              
			 ELSE              
			 BEGIN              
			 --              
			 COMMIT TRANSACTION
			 exec Pr_blocked_emailclients  @pa_dpmdpid,@l_rptname,@l_blkfor,@pa_login_pr_entm_id             
			 --              
			 END         
		--            
		END 
	--
	END              
	END    --end nomaker checker              
	            
	              
	END --end while              
	                  
	END              
	                  
END        
SET @pa_errmsg=@t_errorstr           
   --        
END

GO
