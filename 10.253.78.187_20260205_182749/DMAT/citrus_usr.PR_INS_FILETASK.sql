-- Object: PROCEDURE citrus_usr.PR_INS_FILETASK
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--BEGIN TRAN  
--PR_INS_FILETASK 135,'EDT','HO','DPM SOT FILE - NSDL-IN300175','COMPLETED','','','Dec 18 2007'  
--SELECT * FROM FILETASK WHERE STATUS='RUNNING'  
--ROLLBACK  
  
CREATE PROCEDURE [citrus_usr].[PR_INS_FILETASK]( @PA_ID          VARCHAR(20) OUT  
                                ,@PA_ACTION      VARCHAR(20)        
                                ,@PA_LOGIN_NAME  VARCHAR(20)        
                                ,@PA_TASK_NAME   VARCHAR(50)   = ''         
                                ,@PA_STATUS      VARCHAR(20)  
                                ,@PA_ERRMSG      VARCHAR(500)    
                                ,@PA_SYSGENMSG      VARCHAR(500)    
                                ,@PA_FILEDATE    VARCHAR(18)  
                                )        
AS        
/*        
*********************************************************************************        
 SYSTEM         : CLASS        
 MODULE NAME    : PR_INS_FILETASK        
 DESCRIPTION    :         
 COPYRIGHT(C)   :         
 VERSION HISTORY: 1.0        
 VERS.  AUTHOR            DATE          REASON        
 -----  -------------     ------------  --------------------------------------------------        
 1.0    TUSHAR            16-OCT-2007    VERSION.        
-----------------------------------------------------------------------------------*/        
--        
BEGIN        
--  
  DECLARE @l_task_id NUMERIC  
    
  IF @pa_action ='INS'        
  BEGIN        
  --  
        
    SELECT @l_task_id = ISNULL(MAX(task_id),0) + 1 FROM filetask  
    
    INSERT INTO filetask        
    (task_id  
    ,task_name        
    ,task_start_dt        
    ,task_end_date        
    ,status        
    ,logn_name  
    ,task_filedate        
    )        
    VALUES        
    (@l_task_id  
    ,@pa_task_name        
    ,Getdate()        
    ,null       
    ,@pa_status        
    ,@pa_login_name    
    ,convert(datetime,@PA_FILEDATE,103)      
    )        
      
    SET @PA_ID = CONVERT(VARCHAR,@l_task_id)  
  --        
  END        
  IF @pa_action ='EDT'        
  BEGIN        
  --
	IF @PA_FILEDATE = 'BULK'        
	BEGIN
			IF @PA_SYSGENMSG = 'U'   
			BEGIN   
					UPDATE FILETASK          
					SET    TASK_END_DATE  = GETDATE()        
					, STATUS         = @PA_STATUS          
					, ERRMSG         = @PA_ERRMSG   
					, USERMSG        = @PA_ERRMSG  
					--, TASK_FILEDATE  = GETDATE()
					WHERE  LOGN_NAME      = @PA_LOGIN_NAME          
					AND    TASK_NAME      = @PA_TASK_NAME             
					AND    TASK_END_DATE    IS NULL               
					AND    STATUS         = 'RUNNING'  
			END   
			ELSE  
			BEGIN   
					UPDATE FILETASK          
					SET    TASK_END_DATE  = GETDATE()        
					, STATUS         = @PA_STATUS          
					, ERRMSG         = @PA_ERRMSG   
					--, TASK_FILEDATE  = GETDATE() 
					WHERE  LOGN_NAME      = @PA_LOGIN_NAME          
					AND    TASK_NAME      = @PA_TASK_NAME             
					AND    TASK_END_DATE    IS NULL   
					AND    STATUS         = 'RUNNING'  
			END   
	END
	ELSE
	BEGIN
			IF @PA_SYSGENMSG = 'U'   
			BEGIN   
					UPDATE FILETASK          
					SET    TASK_END_DATE  = GETDATE()        
					, STATUS         = @PA_STATUS          
					, ERRMSG         = @PA_ERRMSG   
					, USERMSG        = @PA_ERRMSG  
					, TASK_FILEDATE  = convert(datetime,@PA_FILEDATE,103)  
					WHERE  LOGN_NAME      = @PA_LOGIN_NAME          
					AND    TASK_NAME      = @PA_TASK_NAME             
					AND    TASK_END_DATE    IS NULL               
					AND    STATUS         = 'RUNNING'  
			END   
			ELSE  
			BEGIN   
					UPDATE FILETASK          
					SET    TASK_END_DATE  = GETDATE()        
					, STATUS         = @PA_STATUS          
					, ERRMSG         = @PA_ERRMSG   
					, TASK_FILEDATE  = convert(datetime,@PA_FILEDATE,103)   
					WHERE  LOGN_NAME      = @PA_LOGIN_NAME          
					AND    TASK_NAME      = @PA_TASK_NAME             
					AND    TASK_END_DATE    IS NULL   
					AND    STATUS         = 'RUNNING'  
			END 
	END
  
   SET @PA_ID = CONVERT(VARCHAR,@PA_ID)  
  --        
  END        
          
--             
END

GO
