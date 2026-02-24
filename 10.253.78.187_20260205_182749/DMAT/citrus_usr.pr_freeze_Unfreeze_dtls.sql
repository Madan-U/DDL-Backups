-- Object: PROCEDURE citrus_usr.pr_freeze_Unfreeze_dtls
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

/*

exec pr_freeze_Unfreeze_dtls '0','INS','HO','12345678','A|*~|00000030|*~|IN2219980025|*~|100|*~|06/11/2009|*~|FREEZE|*~|D|*~|01|*~||*~|*|~*','all',1,'*|~*','|*~|',''	 

*/

CREATE  PROCEDURE [citrus_usr].[pr_freeze_Unfreeze_dtls]
(
 @pa_id            VARCHAR(8000)     
,@pa_action       VARCHAR(20)     
,@pa_login_name   VARCHAR(20)    
,@pa_fre_dpmid    VARCHAR(20)    
,@pa_values       VARCHAR(8000)
,@pa_rmks         varchar(20)         
,@pa_chk_yn       INT        
,@rowdelimiter    CHAR(4)       = '*|~*'        
,@coldelimiter    CHAR(4)       = '|*~|'        
,@pa_errmsg       VARCHAR(8000)  OUTPUT    
)                                         
AS                                            

BEGIN    
--    
DECLARE @t_errorstr      VARCHAR(8000)      
      , @l_error         BIGINT      
      , @delimeter       VARCHAR(10)      
      , @remainingstring VARCHAR(8000)      
      , @currstring      VARCHAR(8000)      
      , @foundat         INTEGER      
      , @delimeterlength INT   
      , @l_dpm_id        NUMERIC  
      , @l_dpam_id       NUMERIC     
      , @line_no         NUMERIC      
      , @delimeter_value VARCHAR(10)      
      , @delimeterlength_value VARCHAR(10)      
      , @remainingstring_value VARCHAR(8000)      
      , @currstring_value VARCHAR(8000)     
      , @l_isin         VARCHAR(25)       
      , @l_qty          VARCHAR(25)     
      , @l_acct_no      varchar(20)    
      , @l_fre_action  CHAR(1)    
      , @l_fre_type CHAR(1)   
	  , @l_fre_for varchar(3) 
      , @l_fre_level   CHAR(1)    
      , @l_fre_exec_dt VARCHAR(11)    
      , @l_fre_id      INT   
      , @l_fre_idm      INT   
      , @l_total_qty   BIGINT    
      , @l_id           varchar(20)  
      , @l_action       VARCHAR(25)  
      , @c_fre_id       varchar(25)  
      , @c_fre_deleted_ind VARCHAR(25)  
      , @@c_access_cursor  cursor  
      , @l_deleted_ind   INT  
          
          
 IF @pa_action = 'INS'     
 BEGIN    
  --    
  SELECT @l_fre_id =ISNULL(MAX(fre_id),0) + 1 FROM  freeze_Unfreeze_dtls    
  SELECT @l_fre_idm =ISNULL(MAX(fre_id),0) + 1 FROM  freeze_Unfreeze_dtls_mak  
  IF @l_fre_idm > @l_fre_id    
  BEGIN  
    --  
    SET @l_fre_id  = @l_fre_idm   
    --  
  END  
  IF @pa_chk_yn = 0     
  BEGIN  
    --  
    SELECT @l_fre_id =ISNULL(MAX(fre_id),0) + 1 FROM  freeze_Unfreeze_dtls    
    --  
  END    
  --    
 END     
   
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
    -- PRINT @currstring_value    
     SET @l_action   = citrus_usr.fn_splitval(@currstring_value,1)    
     IF @l_action = 'A' OR @l_action ='E'      
     BEGIN    
      --    
      SET @l_acct_no           = right(citrus_usr.fn_splitval(@currstring_value,2),8)   
set   @l_acct_no = @l_acct_no --@pa_fre_dpmid + @l_acct_no      
print @l_acct_no                    
      SET @l_isin              = citrus_usr.fn_splitval(@currstring_value,3)                              
      SET @l_qty               = CASE WHEN citrus_usr.fn_splitval(@currstring_value,4) ='' THEN '0' ELSE citrus_usr.fn_splitval(@currstring_value,4) END   
      SET @l_fre_exec_dt       = citrus_usr.fn_splitval(@currstring_value,5)   
      SET @l_fre_action        = citrus_usr.fn_splitval(@currstring_value,6)    
      SET @l_fre_type          = citrus_usr.fn_splitval(@currstring_value,7)    
      SET @l_fre_for           = citrus_usr.fn_splitval(@currstring_value,8)    
     SET @l_id                 = citrus_usr.fn_splitval(@currstring_value,9)    
                     
     --    
     END    
     ELSE      
     BEGIN      
      --   
	if @l_action = 'D'
	begin   
      SET @l_id                 = citrus_usr.fn_splitval(@currstring_value,2)       --citrus_usr.fn_splitval(@currstring_value,8)       
	  SET @l_fre_exec_dt        = citrus_usr.fn_splitval(@currstring_value,5)  


    end
      --      
     END     
              
    IF @pa_chk_yn = 0            
        BEGIN          
         --          
          SELECT @l_dpm_id = dpm_id from dp_mstr where dpm_dpid =@pa_fre_dpmid and dpm_deleted_ind = 1      
          IF @l_acct_no <> ''          
          BEGIN          
          --       
print '1'   
                 SELECT  @l_dpam_id  = dpam_id FROM dp_acct_mstr ,dp_mstr WHERE dpm_deleted_ind = 1  and dpm_id = dpam_dpm_id and dpm_dpid = @pa_fre_dpmid and dpam_sba_no  LIKE CASE WHEN ISNULL(@l_acct_no,'') = '' THEN '%' ELSE @l_acct_no END           
          --          
          END          
          ELSE          
          BEGIN          
          --          
print '2'
               SET @l_dpam_id = 0          
          --          
          END           
     --   

    IF @PA_ACTION = 'INS' OR @l_action = 'A'     
    BEGIN    
      --    
      IF @l_acct_no <> '' AND  @l_isin =''     
      BEGIN    
       --    

       IF EXISTS(SELECT fre_id FROM freeze_Unfreeze_dtls WHERE fre_exec_date <= CONVERT(DATETIME,@l_fre_exec_dt,103)   AND fre_status = 'A' AND fre_action = 'fre_dpm_id=@l_dpm_id' AND fre_Dpam_id=@l_dpam_id  AND fre_deleted_ind =1) OR EXISTS(SELECT fre_id
 FROM freeze_Unfreeze_dtls WHERE fre_Dpam_id=@l_dpam_id AND fre_status = 'A' AND fre_action = 'F' AND  CONVERT(DATETIME,@l_fre_exec_dt,103) <=  fre_exec_date  AND fre_deleted_ind =1)  
       BEGIN    
        --    
        SET  @t_errorstr  = 'ERROR:-' +  convert(varchar,@l_acct_no) + 'Account No. is already freezed'  
        --    
       END   
     ELSE    
     BEGIN    
      --    
      BEGIN TRANSACTION   
print '3'  
    print @l_dpam_id
           
      INSERT INTO freeze_Unfreeze_dtls    
      (fre_id    
       ,fre_action    
       ,fre_type     
       ,fre_exec_date    
       ,fre_dpmid    
       ,fre_dpam_id    
       ,fre_isin_code    
       ,fre_qty    
       ,fre_status    
       ,fre_level    
       ,fre_created_by    
       ,fre_created_dt    
       ,fre_lst_upd_by    
       ,fre_lst_upd_dt    
       ,fre_deleted_ind 
	   ,fre_rmks   
	 , FRE_REQ_INT_BY	
	 ,fre_for
      )    
      VALUES    
      (@l_fre_id    
       ,'F'     
       ,@l_fre_type    
       ,CONVERT(DATETIME,@l_fre_exec_dt,103)    
       ,@l_dpm_id   
       ,@l_dpam_id     
       ,@l_isin    
       ,@l_qty    
       ,'A'    
       ,'A'    
       ,@pa_login_name    
       ,getdate()    
       ,@pa_login_name    
       ,getdate()    
       ,1
       ,@pa_rmks 
    ,@l_fre_type
		 ,@l_fre_for
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
       --      
      END      
         --    
      END  
        
    END  
    ELSE IF @l_isin <> '' AND @l_acct_no = ''        
    BEGIN    
     --    
          
    IF EXISTS(SELECT fre_id FROM freeze_Unfreeze_dtls WHERE fre_dpmid=@l_dpm_id AND fre_status = 'A' AND fre_action = 'F' AND  fre_Isin_code =@l_isin AND fre_exec_date <=CONVERT(DATETIME,@l_fre_exec_dt,103) AND fre_deleted_ind =1)  OR 
	EXISTS(SELECT fre_id FROM freeze_Unfreeze_dtls WHERE fre_dpmid=@l_dpm_id AND fre_status = 'A' AND fre_action = 'F' AND  fre_Isin_code =@l_isin AND CONVERT(DATETIME,@l_fre_exec_dt,103) <=  fre_exec_date  AND fre_deleted_ind =1)  
    BEGIN    
     --    
     SET @t_errorstr='ERROR:-'+ convert(varchar,@l_isin) + ' ISIN CODE  is already freezed for all Accounts'   
     --    
    END     
    ELSE    
    BEGIN    
     --   
     BEGIN TRANSACTION    
     INSERT INTO freeze_Unfreeze_dtls    
     (fre_id    
     ,fre_action    
     ,fre_type     
     ,fre_exec_date    
     ,fre_dpmid    
     ,fre_dpam_id    
     ,fre_isin_code    
     ,fre_qty    
     ,fre_status    
     ,fre_level    
     ,fre_created_by    
     ,fre_created_dt    
     ,fre_lst_upd_by    
     ,fre_lst_upd_dt    
     ,fre_deleted_ind
     ,fre_rmks  
	 ,FRE_REQ_INT_BY	
	 ,fre_for  
     )    
     VALUES    
     (@l_fre_id    
     ,'F'    
     ,@l_fre_type    
     ,CONVERT(DATETIME,@l_fre_exec_dt,103)    
     ,@l_dpm_id    
     ,@l_dpam_id     
     ,@l_isin    
     ,@l_qty    
     ,'A'    
     ,'I'    
     ,@pa_login_name    
     ,getdate()    
     ,@pa_login_name    
     ,getdate()    
     ,1
     ,@pa_rmks   
  ,@l_fre_type
		 ,@l_fre_for
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
       --      
      END      
      --    
    END    
       --    
  END    
    
        
  IF @l_acct_no <> '' AND @l_isin <> '' AND @l_qty = '0'  
  BEGIN    
    --   
          
   /* IF EXISTS(SELECT fre_id FROM freeze_Unfreeze_dtls  WHERE  fre_QTY = 0 AND fre_status = 'A' AND fre_Dpam_id=@l_dpam_id AND fre_Isin_code =@l_isin  AND fre_action = 'F'  AND fre_exec_date <=CONVERT(DATETIME,@l_fre_exec_dt,103) AND fre_deleted_ind =1) 
OR EXISTS(SELECT fre_id FROM freeze_Unfreeze_dtls WHERE fre_dpmid=@l_dpm_id AND fre_status = 'A' AND fre_action = 'F' AND  fre_Isin_code =@l_isin AND CONVERT(DATETIME,@l_fre_exec_dt,103) <=  fre_exec_date  AND fre_deleted_ind =1)   
    BEGIN    
      --    
      SET  @t_errorstr  = 'ERROR:- Account is already freezed'                
      --   
      UPDATE freeze_Unfreeze_dtls    
      SET fre_status ='I'    
          ,fre_lst_upd_by = @pa_login_name  
          ,fre_lst_upd_dt = getdate()  
      WHERE fre_Dpam_id=@l_dpam_id     
      AND fre_Isin_code =@l_isin     
      AND fre_QTY = 0     
      AND fre_action = 'F'    
      AND fre_deleted_ind =1    
      AND fre_status ='A'   
  
      INSERT INTO freeze_Unfreeze_dtls    
      (fre_id    
      ,fre_action    
      ,fre_type     
      ,fre_exec_date    
      ,fre_dpmid    
      ,fre_dpam_id    
      ,fre_isin_code    
      ,fre_qty    
      ,fre_status    
      ,fre_level    
      ,fre_created_by    
      ,fre_created_dt    
      ,fre_lst_upd_by    
      ,fre_lst_upd_dt    
      ,fre_deleted_ind    
      )    
      VALUES    
      (@l_fre_id    
      ,'F'    
      ,@l_fre_type    
      ,CONVERT(DATETIME,@l_fre_exec_dt,103)    
      ,@l_dpm_id    
      ,@l_dpam_id     
      ,@l_isin    
      ,@l_qty    
      ,'A'    
      ,'A'    
      ,@pa_login_name    
      ,getdate()    
      ,@pa_login_name    
      ,getdate()    
      ,1    
       )   
     --     
    END  
         
   ELSE    
   BEGIN  */   
     --   
     IF EXISTS(SELECT fre_id FROM freeze_Unfreeze_dtls WHERE fre_exec_date <= CONVERT(DATETIME,@l_fre_exec_dt,103)   AND fre_status = 'A' AND fre_action = 'fre_dpm_id=@l_dpm_id' AND fre_Dpam_id=@l_dpam_id  AND fre_deleted_ind =1) OR 
EXISTS(SELECT fre_id FROM freeze_Unfreeze_dtls WHERE fre_Dpam_id=@l_dpam_id AND fre_status = 'A' AND fre_action = 'F' AND  CONVERT(DATETIME,@l_fre_exec_dt,103) <=  fre_exec_date  AND fre_deleted_ind =1)  
     BEGIN  
      --  
      SET  @t_errorstr  = 'ERROR:-' + convert(varchar,@l_acct_no) + ' Account No is already freezed'                
      --  
     END  
     ELSE IF EXISTS(SELECT fre_id FROM freeze_Unfreeze_dtls WHERE fre_dpmid=@l_dpm_id AND fre_status = 'A' AND fre_action = 'F' AND  fre_Isin_code =@l_isin AND fre_exec_date <=CONVERT(DATETIME,@l_fre_exec_dt,103) AND fre_deleted_ind =1)  OR EXISTS(SELECT 
fre_id FROM freeze_Unfreeze_dtls WHERE fre_dpmid=@l_dpm_id AND fre_status = 'A' AND fre_action = 'F' AND  fre_Isin_code =@l_isin AND CONVERT(DATETIME,@l_fre_exec_dt,103) <=  fre_exec_date  AND fre_deleted_ind =1)  
     BEGIN   
       --  
       SET  @t_errorstr  = 'ERROR:-' + convert(varchar,@l_isin) + ' ISIN CODE  is already freezed for all Accounts '                
       --  
     END  
     ELSE     
     BEGIN  
       --  
       INSERT INTO freeze_Unfreeze_dtls    
       (fre_id    
       ,fre_action    
       ,fre_type     
       ,fre_exec_date    
       ,fre_dpmid    
       ,fre_dpam_id    
       ,fre_isin_code    
       ,fre_qty    
       ,fre_status    
       ,fre_level    
       ,fre_created_by    
       ,fre_created_dt    
       ,fre_lst_upd_by    
       ,fre_lst_upd_dt    
       ,fre_deleted_ind
	   ,fre_rmks 
	   ,FRE_REQ_INT_BY	
	 ,fre_for   
       )    
       VALUES    
       (@l_fre_id    
       ,'F'     
       ,@l_fre_type    
       ,CONVERT(DATETIME,@l_fre_exec_dt,103)    
       ,@l_dpm_id    
       ,@l_dpam_id     
       ,@l_isin    
       ,@l_qty    
       ,'A'    
       ,'A'    
       ,@pa_login_name    
       ,getdate()    
       ,@pa_login_name    
       ,getdate()    
       ,1
       ,@pa_rmks 
 ,@l_fre_type
		 ,@l_fre_for   
       )    
       --  
      END  
     --   
  --END  
    --     
   END    
         
   IF @l_acct_no <> '' AND @l_isin <> '' AND @l_qty <> '0'    
   BEGIN    
     --    
     /* IF EXISTS(SELECT TOP 1 fre_id FROM freeze_Unfreeze_dtls WHERE fre_dpmid=@l_dpm_id AND fre_Dpam_id=@l_dpam_id  AND fre_action = 'F'  AND fre_Isin_code =@l_isin AND fre_QTY <> 0  AND fre_exec_date <=CONVERT(DATETIME,@l_fre_exec_dt,103) AND fre_statu
s='A' AND fre_deleted_ind =1)  OR EXISTS(SELECT TOP 1 fre_id FROM freeze_Unfreeze_dtls WHERE fre_dpmid=@l_dpm_id AND fre_status = 'A' AND fre_action = 'F' AND  fre_Isin_code =@l_isin AND CONVERT(DATETIME,@l_fre_exec_dt,103) <=  fre_exec_date AND fre_Dpam_
id=@l_dpam_id  AND fre_deleted_ind =1)  
     BEGIN    
       --    
  
       SET @t_errorstr ='ERROR:-'  +  'Account is already freezed .Quantity is updated for this account'     
  
       UPDATE freeze_Unfreeze_dtls    
       SET fre_status ='I'  
           ,fre_lst_upd_by = @pa_login_name  
           , fre_lst_upd_dt = getdate()  
       WHERE fre_Dpam_id=@l_dpam_id   
       AND fre_dpmid=@l_dpm_id  
       AND fre_Isin_code =@l_isin     
       AND fre_action = 'F'    
       AND fre_deleted_ind =1    
       AND fre_status ='A'  
  
  
       INSERT INTO freeze_Unfreeze_dtls    
       (fre_id    
       ,fre_action    
       ,fre_type     
       ,fre_exec_date    
       ,fre_dpmid    
       ,fre_dpam_id    
       ,fre_isin_code    
       ,fre_qty    
       ,fre_status    
       ,fre_level    
       ,fre_created_by    
       ,fre_created_dt    
       ,fre_lst_upd_by    
       ,fre_lst_upd_dt    
       ,fre_deleted_ind    
       )    
      VALUES    
      (@l_fre_id    
      ,'F'     
      ,@l_fre_type    
      ,CONVERT(DATETIME,@l_fre_exec_dt,103)    
      ,@l_dpm_id    
      ,@l_dpam_id     
      ,@l_isin    
      ,@l_qty    
      ,'A'    
      ,'A'    
      ,@pa_login_name    
      ,getdate()    
      ,@pa_login_name    
      ,getdate()    
      ,1    
     )    
    --    
   END  
          
   ELSE    
   BEGIN */     
     --     
     IF EXISTS(SELECT fre_id FROM freeze_Unfreeze_dtls WHERE fre_exec_date <= CONVERT(DATETIME,@l_fre_exec_dt,103)   AND fre_status = 'A' AND fre_action = 'fre_dpm_id=@l_dpm_id' AND fre_Dpam_id=@l_dpam_id  AND fre_deleted_ind =1) OR 
     EXISTS(SELECT fre_id FROM freeze_Unfreeze_dtls WHERE fre_Dpam_id=@l_dpam_id AND fre_status = 'A' AND fre_action = 'F' AND  CONVERT(DATETIME,@l_fre_exec_dt,103) <=  fre_exec_date  AND fre_deleted_ind =1)  
          BEGIN  
           --  
           SET  @t_errorstr  = 'ERROR:-' + convert(varchar,@l_acct_no) + ' Account No is already freezed'                
           --  
          END  
          ELSE IF EXISTS(SELECT fre_id FROM freeze_Unfreeze_dtls WHERE fre_dpmid=@l_dpm_id AND fre_status = 'A' AND fre_action = 'F' AND  fre_Isin_code =@l_isin AND fre_exec_date <=CONVERT(DATETIME,@l_fre_exec_dt,103) AND fre_deleted_ind =1)  OR 
          EXISTS(SELECT fre_id FROM freeze_Unfreeze_dtls WHERE fre_dpmid=@l_dpm_id AND fre_status = 'A' AND fre_action = 'F' AND  fre_Isin_code =@l_isin AND CONVERT(DATETIME,@l_fre_exec_dt,103) <=  fre_exec_date  AND fre_deleted_ind =1)  
          BEGIN   
            --  
            SET  @t_errorstr  = 'ERROR:-' + convert(varchar,@l_isin) + ' ISIN CODE  is already freezed for all Accounts '                
            --  
     END  
     ELSE  
      BEGIN  
        --  
        INSERT INTO freeze_Unfreeze_dtls    
         (fre_id    
         ,fre_action    
         ,fre_type     
         ,fre_exec_date    
         ,fre_dpmid    
         ,fre_dpam_id    
         ,fre_isin_code    
         ,fre_qty    
         ,fre_status    
         ,fre_level    
         ,fre_created_by    
         ,fre_created_dt    
         ,fre_lst_upd_by    
         ,fre_lst_upd_dt    
         ,fre_deleted_ind
		 ,fre_rmks  
		 , FRE_REQ_INT_BY	
	 ,fre_for  
         )    
        VALUES    
        (@l_fre_id    
        ,'F'     
        ,@l_fre_type    
        ,CONVERT(DATETIME,@l_fre_exec_dt,103)    
        ,@l_dpm_id    
        ,@l_dpam_id     
        ,@l_isin    
        ,@l_qty    
        ,'A'    
        ,'A'    
        ,@pa_login_name    
        ,getdate()    
        ,@pa_login_name    
        ,getdate()    
        ,1
        ,@pa_rmks 
 ,@l_fre_type
		 ,@l_fre_for   
       )    
      --   
      END  
   --END    
        --      
 END    
     
END      ---INS ends   
  
  
  IF @PA_ACTION = 'EDT' OR @l_action = 'E'    
  BEGIN    
   --    
print @pa_rmks
print @l_fre_exec_dt
print CONVERT(varchar(11),@l_fre_exec_dt,109)  

    UPDATE freeze_Unfreeze_dtls  
    SET    --fre_action = 'U'  
           fre_exec_date = CONVERT(varchar(11),@l_fre_exec_dt,103)  
           ,fre_lst_upd_by = @pa_login_name  
           ,fre_lst_upd_dt = getdate()  
           ,fre_rmks = @pa_rmks
    WHERE  fre_id = convert(INT,@l_id)  
    AND    fre_deleted_ind = 1  
    AND    fre_status = 'A'  
    AND    fre_action ='F'  
    --  
  END   
    
    
  IF @pa_action ='DEL' OR @l_action = 'D'    
  BEGIN  
   --  
print 'ff'
   UPDATE freeze_Unfreeze_dtls  
   SET fre_deleted_ind =0  
       ,fre_lst_upd_by = @pa_login_name  
       ,fre_lst_upd_dt = getdate()  
    WHERE  fre_id  = CONVERT(INT,@l_id)    
    AND fre_status='A'  
    AND fre_deleted_ind =1   
    --  
   END   
     
 --    
END    --end nomaker checker    
  
ELSE IF @pa_chk_yn = 1      
    BEGIN    
     --    
      SELECT @l_dpm_id = dpm_id from dp_mstr where dpm_dpid =@pa_fre_dpmid and dpm_deleted_ind = 1      
               IF @l_acct_no <> ''          
               BEGIN          
               --     
                      SELECT  @l_dpam_id  = dpam_id FROM dp_acct_mstr ,dp_mstr WHERE dpm_deleted_ind = 1  and dpm_id = dpam_dpm_id and dpm_dpid = @pa_fre_dpmid and dpam_sba_no  LIKE CASE WHEN @pa_fre_dpmid + ISNULL(@l_acct_no,'') = '' THEN '%' ELSE @pa_fre_dpmid + @l_acct_no END        
   
               --          
               END          
               ELSE          
               BEGIN          
               --          
                    SET @l_dpam_id = 0          
               --          
          END           
     --    
     IF @PA_ACTION = 'INS' OR @l_action = 'A'     
     BEGIN    
      --    
      SELECT @l_fre_id =ISNULL(MAX(fre_id),0) + 1 FROM  freeze_Unfreeze_dtls  WITH (NOLOCK)  
      SELECT @l_fre_idm =ISNULL(MAX(fre_id),0) + 1 FROM  freeze_Unfreeze_dtls_mak WITH (NOLOCK)  
        
      IF @l_fre_idm > @l_fre_id    
      BEGIN  
        --  
        SET @l_fre_id  = @l_fre_idm   
        --  
      END  
   
      IF @l_acct_no <> '' AND @l_isin =''     
      BEGIN    
       --    
        IF EXISTS(SELECT TOP 1 fre_id FROM  freeze_Unfreeze_dtls_mak WHERE fre_dpm_id=@l_dpm_id AND  fre_exec_dt <= CONVERT(DATETIME,@l_fre_exec_dt,103) AND fre_status = 'A' AND fre_action = 'F' AND fre_Dpam_id=@l_dpam_id  AND fre_deleted_ind in (0,4,6)) 
 OR EXISTS(SELECT TOP 1 fre_id FROM freeze_Unfreeze_dtls_mak WHERE  CONVERT(DATETIME,@l_fre_exec_dt,103) <= fre_exec_dt  AND fre_status = 'A' AND fre_action = 'F' AND fre_Dpam_id=@l_dpam_id  AND fre_deleted_ind in (0,4,6))    
        BEGIN    
          --    
          SET  @t_errorstr  = 'ERROR : -'+ convert(varchar,@l_acct_no) +' Account No. is already freezed'   
        END  
        --    
        ELSE   
        BEGIN    
        --    
              
        BEGIN TRANSACTION     

        INSERT INTO freeze_Unfreeze_dtls_mak    
        (fre_id    
         ,fre_action    
         ,fre_type     
         ,fre_exec_dt    
         ,fre_dpm_id    
         ,fre_dpam_id    
         ,fre_isin_cd    
         ,fre_qty    
         ,fre_status    
         ,fre_level    
         ,fre_created_by    
         ,fre_created_dt    
         ,fre_lst_upd_by    
         ,fre_lst_upd_dt    
         ,fre_deleted_ind
         ,fre_rmks    
		 ,FRE_REQ_INT_BY
		 ,fre_for
        )    
        VALUES    
        (@l_fre_id    
         ,'F'     
         ,@l_fre_type    
         ,CONVERT(DATETIME,@l_fre_exec_dt,103)    
         ,@l_dpm_id    
         ,@l_dpam_id     
         ,@l_isin    
         ,@l_qty    
         ,'A'    
         ,'A'    
         ,@pa_login_name    
         ,getdate()    
         ,@pa_login_name    
         ,getdate()    
         ,0
         ,@pa_rmks    
		 ,@l_fre_type
		 ,@l_fre_for
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
          --      
        END      
         --    
      END  
        
      END   
        
      ELSE  IF @l_acct_no = '' AND @l_isin <> ''       
      BEGIN    
        --    
        IF EXISTS(SELECT fre_id FROM freeze_Unfreeze_dtls_mak  WHERE   fre_exec_dt <= CONVERT(DATETIME,@l_fre_exec_dt,103)  AND fre_dpm_id=@l_dpm_id AND fre_status = 'A' AND fre_action = 'F' AND  fre_Isin_cd =@l_isin  AND fre_deleted_ind in (0,4,6))  OR 
EXISTS(SELECT fre_id FROM freeze_Unfreeze_dtls_mak WHERE  CONVERT(DATETIME,@l_fre_exec_dt,103) <= fre_exec_dt   AND     fre_dpm_id= @l_dpm_id AND fre_status = 'A' AND fre_action = 'F' AND  fre_Isin_cd =@l_isin  AND fre_deleted_ind in (0,4,6))    
        BEGIN    
          --    
          SET @t_errorstr='ERROR :- ' +  convert(varchar,@l_isin) + ' ISIN code is already freezed for all Accounts'  
          --    
        END     
        ELSE    
        BEGIN    
          --    
          BEGIN TRANSACTION    
            
          INSERT INTO freeze_Unfreeze_dtls_mak    
           (fre_id    
           ,fre_action    
           ,fre_type     
           ,fre_exec_dt  
           ,fre_dpm_id    
           ,fre_dpam_id    
           ,fre_isin_cd  
           ,fre_qty    
           ,fre_status    
           ,fre_level    
           ,fre_created_by    
           ,fre_created_dt    
           ,fre_lst_upd_by    
           ,fre_lst_upd_dt    
           ,fre_deleted_ind
           ,fre_rmks  
		   ,FRE_REQ_INT_BY
		   ,fre_for  
           )    
           VALUES    
           (@l_fre_id    
           ,'F'     
           ,@l_fre_type    
           ,CONVERT(DATETIME,@l_fre_exec_dt,103)    
           ,@l_dpm_id    
           ,@l_dpam_id     
           ,@l_isin    
           ,@l_qty    
           ,'A'    
           ,'I'    
           ,@pa_login_name    
           ,getdate()    
           ,@pa_login_name    
           ,getdate()    
           ,0
           ,@pa_rmks   
		,@l_fre_type
		,@l_fre_for 
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
             --      
            END      
            --    
            END    
          --    
         END    
           
       IF @l_acct_no <> '' AND @l_isin <> '' AND @l_qty = '0'  
       BEGIN    
         --    
         /*IF EXISTS(SELECT fre_id FROM freeze_Unfreeze_dtls_mak WHERE fre_QTY = 0 AND fre_dpm_id=@l_dpm_id  AND fre_status = 'A' AND fre_Dpam_id=@l_dpam_id AND fre_Isin_cd =@l_isin  AND fre_action = 'F' AND fre_deleted_ind in (0,4,6) AND fre_exec_dt <= C
ONVERT(DATETIME,@l_fre_exec_dt,103) )  OR EXISTS(SELECT fre_id FROM freeze_Unfreeze_dtls_mak WHERE fre_QTY = 0  AND fre_dpm_id=@l_dpm_id  AND fre_status = 'A' AND fre_Dpam_id=@l_dpam_id AND fre_Isin_cd =@l_isin  AND fre_action = 'F' AND fre_deleted_ind in
 (0,4,6) AND CONVERT(DATETIME,@l_fre_exec_dt,103) <= fre_exec_dt)  
         BEGIN    
          --    
          SET  @t_errorstr  = 'ERROR : - Account is already freezed'  
          --   
          UPDATE freeze_Unfreeze_dtls_mak     
          SET fre_status ='I'       
              ,fre_lst_upd_by = @pa_login_name  
              ,fre_lst_upd_dt = getdate()  
          WHERE  fre_qty = 0    
          AND fre_status = 'A'     
          AND fre_Dpam_id=@l_dpam_id     
          AND fre_Isin_cd =@l_isin     
          AND fre_action = 'F'    
          AND fre_deleted_ind in (0,4,6)  
            
          INSERT INTO freeze_Unfreeze_dtls_mak    
          (fre_id    
          ,fre_action    
          ,fre_type     
          ,fre_exec_dt    
          ,fre_dpm_id    
          ,fre_dpam_id    
          ,fre_isin_cd   
          ,fre_qty    
          ,fre_status    
          ,fre_level    
          ,fre_created_by    
          ,fre_created_dt    
          ,fre_lst_upd_by    
          ,fre_lst_upd_dt    
          ,fre_deleted_ind    
          )    
          VALUES    
          (@l_fre_id    
          ,'F'     
          ,@l_fre_type    
          ,CONVERT(DATETIME,@l_fre_exec_dt,103)    
          ,@l_dpm_id    
          ,@l_dpam_id     
          ,@l_isin    
          ,@l_qty    
          ,'A'    
          ,'A'    
          ,@pa_login_name    
          ,getdate()    
          ,@pa_login_name    
          ,getdate()    
          ,0    
         )    
            
         END    
         ELSE   
         BEGIN */    
           --    
          If EXISTS(SELECT TOP 1 fre_id FROM  freeze_Unfreeze_dtls_mak WHERE fre_dpm_id=@l_dpm_id AND  fre_exec_dt <= CONVERT(DATETIME,@l_fre_exec_dt,103) AND fre_status = 'A' AND fre_action = 'F' AND fre_Dpam_id=@l_dpam_id  AND fre_deleted_ind in (0,4,6)
)  OR EXISTS(SELECT TOP 1 fre_id FROM freeze_Unfreeze_dtls_mak WHERE  CONVERT(DATETIME,@l_fre_exec_dt,103) <= fre_exec_dt  AND fre_status = 'A' AND fre_action = 'F' AND fre_Dpam_id=@l_dpam_id  AND fre_deleted_ind in (0,4,6))    
          BEGIN  
            --  
            SET  @t_errorstr  = 'ERROR:-' + convert(varchar,@l_acct_no) +' Account No. is already freezed'                
            --  
          END  
          ELSE IF EXISTS(SELECT fre_id FROM freeze_Unfreeze_dtls_mak  WHERE   fre_exec_dt <= CONVERT(DATETIME,@l_fre_exec_dt,103)  AND fre_dpm_id=@l_dpm_id AND fre_status = 'A' AND fre_action = 'F' AND  fre_Isin_cd =@l_isin  AND fre_deleted_ind in (0,4,6)
)  OR EXISTS(SELECT fre_id FROM freeze_Unfreeze_dtls_mak WHERE  CONVERT(DATETIME,@l_fre_exec_dt,103) <= fre_exec_dt   AND     fre_dpm_id= @l_dpm_id AND fre_status = 'A' AND fre_action = 'F' AND  fre_Isin_cd =@l_isin  AND fre_deleted_ind in (0,4,6))    
          BEGIN   
            --  
            SET  @t_errorstr  = 'ERROR:- ' + convert(varchar,@l_isin) + ' ISIN CODE is already freezed for all Accounts'                
            --  
          END  
          ELSE  
          BEGIN  
           --  
          INSERT INTO freeze_Unfreeze_dtls_mak    
          (fre_id    
          ,fre_action    
          ,fre_type     
          ,fre_exec_dt    
          ,fre_dpm_id    
          ,fre_dpam_id    
          ,fre_isin_cd   
          ,fre_qty    
          ,fre_status    
          ,fre_level    
          ,fre_created_by    
          ,fre_created_dt    
          ,fre_lst_upd_by    
          ,fre_lst_upd_dt    
          ,fre_deleted_ind
		  ,fre_rmks  
		  ,FRE_REQ_INT_BY
		  ,fre_for  
          )    
          VALUES    
          (@l_fre_id    
          ,'F'     
          ,@l_fre_type    
          ,CONVERT(DATETIME,@l_fre_exec_dt,103)    
          ,@l_dpm_id    
          ,@l_dpam_id     
          ,@l_isin    
          ,@l_qty    
          ,'A'    
          ,'A'    
          ,@pa_login_name    
          ,getdate()    
          ,@pa_login_name    
          ,getdate()    
          ,0
          ,@pa_rmks 
		 ,@l_fre_type
		 ,@l_fre_for    
          )    
        --    
        END  
          
       --END   
          
      END    
       
      
       IF @l_acct_no <> '' AND @l_isin <> '' AND @l_qty <> '0'    
        /*BEGIN    
        --    
        IF EXISTS(SELECT fre_id FROM freeze_Unfreeze_dtls_mak WHERE fre_Dpam_id=@l_dpam_id AND fre_dpm_id=@l_dpm_id  AND fre_action = 'F'  AND fre_Isin_cd =@l_isin AND fre_QTY <> 0 AND fre_status='A' AND fre_exec_dt <= CONVERT(DATETIME,@l_fre_exec_dt,103)
  AND fre_deleted_ind in (0,4,6)) OR EXISTS(SELECT fre_id FROM freeze_Unfreeze_dtls_mak WHERE fre_Dpam_id=@l_dpam_id AND fre_dpm_id=@l_dpm_id  AND fre_action = 'F'  AND fre_Isin_cd =@l_isin AND fre_QTY <> 0 AND fre_status='A' AND  CONVERT(DATETIME,@l_fre_
exec_dt,103) <= fre_exec_dt   AND fre_deleted_ind in (0,4,6))     
        BEGIN    
         --    
            
          SET @t_errorstr ='ERROR:-'  +  'Account is already freezed , Quantity is updated'     
              
          UPDATE freeze_Unfreeze_dtls_mak    
          SET fre_status ='I'  
              ,fre_lst_upd_by = @pa_login_name  
              ,fre_lst_upd_dt = getdate()   
          WHERE fre_Dpam_id=@l_dpam_id     
          AND fre_Isin_cd =@l_isin     
          AND fre_QTY <> 0     
          AND fre_action = 'F'   
          AND fre_deleted_ind in (0,4,6)    
          AND fre_status ='A'    
    
    INSERT INTO freeze_Unfreeze_dtls_mak    
          (fre_id    
          ,fre_action    
          ,fre_type     
          ,fre_exec_dt   
          ,fre_dpm_id    
          ,fre_dpam_id    
          ,fre_isin_cd    
          ,fre_qty    
          ,fre_status    
          ,fre_level    
          ,fre_created_by    
          ,fre_created_dt    
          ,fre_lst_upd_by    
          ,fre_lst_upd_dt    
          ,fre_deleted_ind    
          )    
         VALUES    
         (@l_fre_id    
         ,'F'     
         ,@l_fre_type    
         ,CONVERT(DATETIME,@l_fre_exec_dt,103)    
         ,@l_dpm_id    
         ,@l_dpam_id     
         ,@l_isin    
         ,@l_qty    
         ,'A'    
         ,'A'    
         ,@pa_login_name    
         ,getdate()    
         ,@pa_login_name    
         ,getdate()    
         ,0   
        )    
         --    
        END    
        ELSE */   
        BEGIN    
         --    
       If EXISTS(SELECT TOP 1 fre_id FROM  freeze_Unfreeze_dtls_mak WHERE fre_dpm_id=@l_dpm_id AND  fre_exec_dt <= CONVERT(DATETIME,@l_fre_exec_dt,103) AND fre_status = 'A' AND fre_action = 'F' AND fre_Dpam_id=@l_dpam_id  AND fre_deleted_ind in (0,4,6))  
OR EXISTS(SELECT TOP 1 fre_id FROM freeze_Unfreeze_dtls_mak WHERE  CONVERT(DATETIME,@l_fre_exec_dt,103) <= fre_exec_dt  AND fre_status = 'A' AND fre_action = 'F' AND fre_Dpam_id=@l_dpam_id  AND fre_deleted_ind in (0,4,6))    
                 BEGIN  
                   --  
                   SET  @t_errorstr  = 'ERROR:-' + convert(varchar,@l_acct_no) +' Account No. is already freezed'                
                   --  
                 END  
                 ELSE IF EXISTS(SELECT fre_id FROM freeze_Unfreeze_dtls_mak  WHERE   fre_exec_dt <= CONVERT(DATETIME,@l_fre_exec_dt,103)  AND fre_dpm_id=@l_dpm_id AND fre_status = 'A' AND fre_action = 'F' AND  fre_Isin_cd =@l_isin  AND fre_deleted_ind in 
(0,4,6))  OR EXISTS(SELECT fre_id FROM freeze_Unfreeze_dtls_mak WHERE  CONVERT(DATETIME,@l_fre_exec_dt,103) <= fre_exec_dt   AND     fre_dpm_id= @l_dpm_id AND fre_status = 'A' AND fre_action = 'F' AND  fre_Isin_cd =@l_isin  AND fre_deleted_ind in (0,4,6))
    
                 BEGIN   
                   --  
                   SET  @t_errorstr  = 'ERROR:- ' + convert(varchar,@l_isin) + ' ISIN CODE is already freezed for all Accounts'                
                   --  
          END  
           
        ELSE       
        BEGIN  
         --  
         INSERT INTO freeze_Unfreeze_dtls_mak    
          (fre_id    
          ,fre_action    
          ,fre_type     
          ,fre_exec_dt    
          ,fre_dpm_id    
          ,fre_dpam_id    
          ,fre_isin_cd    
          ,fre_qty    
          ,fre_status    
          ,fre_level    
          ,fre_created_by    
          ,fre_created_dt    
          ,fre_lst_upd_by    
          ,fre_lst_upd_dt    
          ,fre_deleted_ind
          ,fre_rmks
          ,FRE_REQ_INT_BY
		  ,fre_for  
          )    
         VALUES    
         (@l_fre_id    
         ,'F'     
         ,@l_fre_type    
         ,CONVERT(DATETIME,@l_fre_exec_dt,103)    
         ,@l_dpm_id    
         ,@l_dpam_id     
         ,@l_isin    
         ,@l_qty    
         ,'A'    
         ,'A'    
         ,@pa_login_name    
         ,getdate()    
         ,@pa_login_name    
         ,getdate()    
         ,0
         ,@pa_rmks   
		,@l_fre_type
		,@l_fre_for  
        )    
         --   
       END  
       --END    
        --      
     END    
   END    
  IF @PA_ACTION = 'EDT' OR @l_action = 'E'    
  BEGIN    
   --    
print 'EDT'
    UPDATE freeze_Unfreeze_dtls_mak  
    SET    --fre_action = 'U'  
           fre_exec_dt = CONVERT(DATETIME,@l_fre_exec_dt,103)   
           ,fre_deleted_ind = 2  
           ,fre_lst_upd_by = @pa_login_name  
           ,fre_lst_upd_dt =getdate()  
		   ,fre_rmks = @pa_rmks	
    WHERE  fre_id = convert(INT,@l_id)  
    AND    fre_deleted_ind = 0  
    AND    fre_status = 'A'  
    AND    fre_action ='F'  
    --  
   IF EXISTS(SELECT * FROM freeze_Unfreeze_dtls WHERE fre_id = CONVERT(INT,@l_id) AND fre_status = 'A' AND fre_action ='F' AND fre_deleted_ind = 1 )  
    BEGIN  
     --  
     SET @l_deleted_ind = 6  
     INSERT INTO freeze_Unfreeze_dtls_mak    
          (fre_id    
          ,fre_action    
          ,fre_type     
          ,fre_exec_dt    
          ,fre_dpm_id    
          ,fre_dpam_id    
          ,fre_isin_cd    
          ,fre_qty    
          ,fre_status    
          ,fre_level    
          ,fre_created_by    
          ,fre_created_dt    
          ,fre_lst_upd_by    
          ,fre_lst_upd_dt    
          ,fre_deleted_ind
		  ,fre_rmks 
		  ,FRE_REQ_INT_BY
		  ,fre_for     
          )    
          VALUES    
          (  
           CONVERT(INT,@l_id)  
          ,'U'     
          ,@l_fre_type    
          ,CONVERT(DATETIME,@l_fre_exec_dt,103)    
          ,@l_dpm_id    
          ,@l_dpam_id     
          ,@l_isin    
          ,@l_qty    
          ,'A'    
          ,'A'    
          ,@pa_login_name    
          ,getdate()    
          ,@pa_login_name    
          ,getdate()    
          ,@l_deleted_ind
          ,@pa_rmks   
		  ,@l_fre_type
		  ,@l_fre_for   
    )   
      
    --  
    END  
    ELSE  
    BEGIN  
     --  
     SET @l_deleted_ind = 0  
     --  
    END   
   --   
  END   --EDIT ends   
  IF @pa_action ='DEL'  
  BEGIN  
   --  
print 'dd'
print @l_id
   IF EXISTS(SELECT fre_id FROM freeze_Unfreeze_dtls_mak where fre_id= CONVERT(INT,@l_id) and fre_deleted_ind=0 )  
   BEGIN  
   --  
   DELETE FROM freeze_Unfreeze_dtls_mak   
     
   WHERE fre_id=CONVERT(numeric,@l_id)   
   AND   fre_deleted_ind = 0  
   --  
   END  
   ELSE  
   BEGIN  
    --  
    BEGIN TRANSACTION  
      
    INSERT INTO freeze_Unfreeze_dtls_mak  
    (  
    fre_id    
    ,fre_action    
    ,fre_type     
    ,fre_exec_dt    
    ,fre_dpm_id    
    ,fre_dpam_id    
    ,fre_isin_cd   
    ,fre_qty    
    ,fre_status    
    ,fre_level    
    ,fre_created_by    
    ,fre_created_dt    
    ,fre_lst_upd_by    
    ,fre_lst_upd_dt    
    ,fre_deleted_ind
    ,fre_rmks  
	,FRE_REQ_INT_BY
	,fre_for    
    )  
    SELECT  
     fre_id    
     ,'U'    
     ,fre_type     
     ,convert(datetime,@l_fre_exec_dt,103)                  
     ,fre_dpmid    
     ,fre_dpam_id    
     ,fre_isin_code    
     ,fre_qty    
     ,fre_status    
     ,fre_level    
     ,fre_created_by    
     ,fre_created_dt    
     ,fre_lst_upd_by    
     ,fre_lst_upd_dt    
     ,4
     ,'UNFREEZED' 
,@l_fre_type
		,@l_fre_for   
     FROM freeze_Unfreeze_dtls  
     WHERE fre_id=CONVERT(numeric,@l_id)  
     AND   fre_deleted_ind = 1  
       
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
       --    
      END    
    --  
   END  
      
   --  
  END  
    
  ELSE IF @pa_action ='APP'          --starts  
  BEGIN  
   --  
   SET @@c_access_cursor =  CURSOR fast_forward FOR   
   SELECT fre_id,fre_deleted_ind FROM freeze_unfreeze_dtls_mak WHERE fre_id =CONVERT(NUMERIC,@currstring) and fre_deleted_ind in (0,4,6)  
   OPEN @@c_access_cursor    
   FETCH NEXT FROM @@c_access_cursor INTO @c_fre_id, @c_fre_deleted_ind    
     
   WHILE @@fetch_status = 0   
   BEGIN  
    --  
    BEGIN TRANSACTION   
      
    IF EXISTS(select * from freeze_unfreeze_dtls_mak where fre_id=CONVERT(NUMERIC,@c_fre_id) and fre_deleted_ind =6)  
    BEGIN  
      --  
      UPDATE freeze_unfreeze_dtls  
      SET  fre_action       = frzufrzm.fre_action     
           ,fre_type        = frzufrzm.fre_type  
           ,fre_exec_date   = frzufrzm.fre_exec_dt  
           ,fre_dpmid       = frzufrzm.fre_dpm_id  
           ,fre_dpam_id     = frzufrzm.fre_dpam_id  
           ,fre_isin_code   = frzufrzm.fre_isin_cd  
           ,fre_qty         = frzufrzm.fre_qty  
           ,fre_status      = frzufrzm.fre_status  
           ,fre_level       = frzufrzm.fre_level  
           ,fre_lst_upd_by  = @pa_login_name  
           ,fre_lst_upd_dt   = getdate()  
           ,fre_rmks = ''
  
  
      FROM freeze_unfreeze_dtls frzufrz  
           ,freeze_unfreeze_dtls_mak frzufrzm  
      WHERE frzufrzm.fre_id=convert(numeric,@c_fre_id)       
      AND   frzufrz.fre_id =frzufrzm.fre_id  
      AND   frzufrzm.fre_deleted_ind =6  
      --  
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
        UPDATE freeze_unfreeze_dtls_mak  
        SET    fre_deleted_ind =7  
              ,fre_lst_upd_by  =@pa_login_name  
              ,fre_lst_upd_dt  =getdate()  
        WHERE  fre_id = CONVERT(NUMERIC,@c_fre_id)        
        AND    fre_deleted_ind  = 6  
        COMMIT TRANSACTION  
        --  
       END  
    END  
    ELSE IF EXISTS(SELECT * FROM  freeze_unfreeze_dtls_mak where fre_id=CONVERT(NUMERIC,@currstring) and fre_deleted_ind =0)  
    BEGIN  
      --  
      INSERT INTO freeze_unfreeze_dtls  
      (   
      fre_id    
     ,fre_action    
     ,fre_type     
     ,fre_exec_date  
     ,fre_dpmid    
     ,fre_dpam_id    
     ,fre_isin_code    
     ,fre_qty    
     ,fre_status    
     ,fre_level    
     ,fre_created_by    
     ,fre_created_dt    
     ,fre_lst_upd_by    
     ,fre_lst_upd_dt    
     ,fre_deleted_ind
     ,fre_rmks  
	 ,FRE_REQ_INT_BY	
	 ,fre_for   
      )  
      SELECT  
       fre_id  
      ,fre_action    
      ,fre_type     
      ,fre_exec_dt    
      ,fre_dpm_id    
      ,fre_dpam_id    
      ,fre_isin_cd   
      ,fre_qty    
      ,fre_status    
      ,fre_level    
      ,fre_created_by    
      ,fre_created_dt    
      ,fre_lst_upd_by    
      ,fre_lst_upd_dt    
      ,1
      ,fre_rmks   
      ,FRE_REQ_INT_BY	
	 ,fre_for  
      FROM freeze_unfreeze_dtls_mak  
      WHERE fre_id= CONVERT(NUMERIC,@c_fre_id)  
      AND   fre_deleted_ind =0  
        
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
         UPDATE freeze_unfreeze_dtls_mak  
         SET    fre_deleted_ind =1  
              ,fre_lst_upd_by  =@pa_login_name  
              ,fre_lst_upd_dt  =getdate()  
         WHERE  fre_id = CONVERT(NUMERIC,@c_fre_id)        
         AND    fre_deleted_ind  = 0  
           
         COMMIT TRANSACTION    
         --  
       END  
        
      --  
    END  
    ELSE  
    BEGIN  
      --  
      UPDATE freeze_unfreeze_dtls  
      SET    fre_deleted_ind =0  
           ,fre_lst_upd_by  =@pa_login_name  
           ,fre_lst_upd_dt  =getdate()  
      WHERE  fre_id = CONVERT(NUMERIC,@c_fre_id)        
      AND    fre_deleted_ind  = 1  
           
      UPDATE freeze_unfreeze_dtls_mak  
      SET    fre_deleted_ind =5  
           ,fre_lst_upd_by  =@pa_login_name  
           ,fre_lst_upd_dt  =getdate()  
      WHERE  fre_id = CONVERT(NUMERIC,@c_fre_id)        
      AND    fre_deleted_ind  = 4  
        
      COMMIT TRANSACTION       
      --  
    END  
      
   FETCH NEXT FROM @@c_access_cursor INTO @c_fre_id, @c_fre_deleted_ind     
    --  
   END  
    CLOSE      @@c_access_cursor          
    DEALLOCATE @@c_access_cursor     
   --  
  END                                --ends  
    
  ELSE IF @pa_action = 'REJ'        --starts  
  BEGIN  
   --  
   BEGIN TRANSACTION  
   UPDATE freeze_unfreeze_dtls_mak  
   SET    fre_deleted_ind =3  
          ,fre_lst_upd_by  =@pa_login_name  
          ,fre_lst_upd_dt  =getdate()  
   WHERE  fre_id = CONVERT(NUMERIC,@currstring)        
   AND    fre_deleted_ind  in (0,4,6)  
     
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
     COMMIT TRANSACTION  
     --  
   END  
     
   --  
  END                               --ends  
     
 --  
 END  
  
END     
END --end while    
        
END    
        
END     
      
SET @pa_errmsg=@t_errorstr    
 --    
END

GO
