-- Object: PROCEDURE citrus_usr.pr_ins_destroy_slip
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_ins_destroy_slip](@pa_id              VARCHAR(8000)    
                                    ,@pa_action          VARCHAR(20)    
                                    ,@pa_login_name      VARCHAR(20)    
                                    ,@pa_dpm_dpid        VARCHAR(50)  
                                    ,@pa_trantm_id       VARCHAR(50)  
                                    ,@pa_series_type       VARCHAR(50)  
                                    ,@pa_dpam_acct_no    VARCHAR(50)  
                                    ,@pa_slip_no_fr         VARCHAR(20)  
                                    ,@pa_slip_no_to         VARCHAR(20)  
                                    ,@pa_values          VARCHAR(8000)   
                                    ,@pa_rmks            VARCHAR(250)    
                                    ,@pa_chk_yn          INT    
                                    ,@rowdelimiter       CHAR(4)       = '*|~*'    
                                    ,@coldelimiter       CHAR(4)       = '|*~|'    
                                    ,@pa_errmsg          VARCHAR(8000) output    
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
        , @delimeter_value VARCHAR(10)  
        , @delimeterlength_value VARCHAR(10)  
        , @remainingstring_value VARCHAR(8000)  
        , @currstring_value VARCHAR(8000)    
        , @l_dpm_id       NUMERIC  
        , @l_id           VARCHAR(20)  
        , @l_trastm_cd     VARCHAR(20)  
        , @l_count         NUMERIC  
        , @l_slipno         varchar(50)  
     
	declare	@l_counter numeric  
		   ,@l_count1 numeric        
          
  SELECT @l_dpm_id = dpm_id FROM dp_mstr WHERE dpm_dpid = @pa_dpm_dpid AND dpm_deleted_ind =1  
  --SELECT @l_trastm_cd = CASE WHEN TRASTM_CD = '925' THEN '904_act' ELSE TRASTM_CD END  FROM TRANSACTION_SUB_TYPE_MSTR WHERE TRASTM_ID =CONVERT(INT,@pa_trantm_id) AND TRASTM_DELETED_IND = 1  
  set @l_trastm_cd = @pa_trantm_id
    
  IF @pa_action = 'INS'   --start  
  BEGIN  
  --  
     IF convert(numeric,@pa_slip_no_fr) = convert(numeric,@pa_slip_no_to)  
     BEGIN  
     --  

       SET @l_count = 1  
       set @l_slipno = @pa_slip_no_fr  

     --  
     END  
     ELSE  
     BEGIN   
     --  
       SET @l_count = convert(numeric,@pa_slip_no_to) - convert(numeric,@pa_slip_no_fr)  
       set @l_count = @l_count + 1  
       set @l_slipno = @pa_slip_no_fr  
     --    
     END  
       
     WHILE @l_count <> 0  
     BEGIN  
     --  
       IF EXISTS(SELECT TOP 1 USES_ID FROM USED_SLIP WHERE  USES_SERIES_TYPE = @pa_series_type AND USES_SLIP_NO = @l_slipno  AND USES_USED_DESTR = 'U' AND USES_TRANTM_ID = @l_trastm_cd AND USES_DELETED_IND = 1)  
       BEGIN  
       --  
         SET @pa_errmsg = 'ERROR:' +  'Slip no: ' + convert(varchar,@l_slipno) + '  is already Used'  
         RETURN  
       --  
       END  
       ELSE IF EXISTS(SELECT TOP 1 USES_ID FROM USED_SLIP WHERE  USES_SERIES_TYPE = @pa_series_type AND USES_SLIP_NO = @l_slipno  AND USES_USED_DESTR = 'B' AND USES_TRANTM_ID = @l_trastm_cd  AND USES_DELETED_IND = 1)  
       BEGIN  
       --  
         SET @pa_errmsg = 'ERROR:' +  'Slip no: ' + convert(varchar,@l_slipno) + '  is already  Blocked '  
         RETURN  
       --  
       END  
       ELSE  
       IF EXISTS(SELECT TOP 1 USES_ID FROM USED_SLIP WHERE  USES_SERIES_TYPE = @pa_series_type AND USES_SLIP_NO = @l_slipno  AND USES_USED_DESTR ='D'  AND USES_TRANTM_ID = @l_trastm_cd  AND USES_DELETED_IND = 1)  
       BEGIN  
       --  
          SET @pa_errmsg = 'ERROR:' +  'Slip no: ' + convert(varchar,@l_slipno) + '  is already Destroyed'  
          RETURN  
       --  
       END  
         
       SELECT @l_id = ISNULL(MAX(USES_ID),0) + 1 FROM used_slip  
         
       INSERT INTO used_slip  
       (USES_ID  
        ,USES_DPM_ID  
        ,USES_DPAM_ACCT_NO  
        ,USES_SLIP_NO  
        ,USES_TRANTM_ID  
        ,USES_SERIES_TYPE  
        ,USES_USED_DESTR  
        ,USES_CREATED_BY  
        ,USES_CREATED_DT  
        ,USES_LST_UPD_BY  
        ,USES_LST_UPD_DT  
        ,USES_DELETED_IND   
       )VALUES  
       (@l_id  
        ,@l_dpm_id  
        ,@pa_dpam_acct_no   
        ,@l_slipno  
        ,@l_trastm_cd  
        ,@pa_series_type  
        ,@pa_values  
        ,@pa_login_name  
        ,getdate()  
        ,@pa_login_name  
        ,getdate()  
        ,1  
       )  
         
       SET @l_slipno = @l_slipno + 1  
       SET @l_count = @l_count - 1  
     --  
     END --end while  
  --  
  END --end  
  ELSE IF @PA_ACTION = 'EDT'  
  BEGIN  
  --  
    BEGIN TRANSACTION  
              
    UPDATE used_slip  
    SET   USES_DPM_ID    = @l_dpm_id  
         ,USES_DPAM_ACCT_NO =@pa_dpam_acct_no  
         ,USES_SLIP_NO      =@pa_slip_no_fr  
         ,USES_TRANTM_ID    =@l_trastm_cd   
         ,USES_SERIES_TYPE  =@pa_series_type  
         ,USES_USED_DESTR   = @pa_values  
         ,USES_LST_UPD_BY   =@pa_login_name  
         ,USES_LST_UPD_DT   =getdate()  
        
    WHERE  USES_ID            = CONVERT(INT,@pa_id)       
    AND    USES_DELETED_IND   = 1  
  
    SET @l_error = @@error  
    IF @l_error <> 0  
    BEGIN  
    --  
      IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)  
      BEGIN  
      --  
        SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)  
        SET @pa_errmsg = @t_errorstr  
      --  
      END  
      ELSE  
      BEGIN  
      --  
        SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'  
        SET @pa_errmsg = @t_errorstr  
      --  
      END  
  
      ROLLBACK TRANSACTION   
  
      RETURN  
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
  ELSE IF @PA_ACTION = 'DEL'  
  BEGIN  
  --  
    BEGIN TRANSACTION  
             
	print 'ssss'
  
	--set @l_counter  = 1  
	--set @l_count1 = citrus_usr.ufn_countstring(@pa_id ,'|*~|')  

	--while @l_count1 >= @l_counter  
	--begin   
  
	--	if isnumeric(citrus_usr.fn_splitval(@pa_id,@l_counter)) = 1
	--	begin 
   print 'dddd'
			UPDATE used_slip  
			SET   USES_DELETED_IND   = 0  
				 ,USES_LST_UPD_BY   =@pa_login_name  
				 ,USES_LST_UPD_DT   =getdate()  
			--WHERE  USES_ID            = @pa_trantm_id  --CONVERT(INT,citrus_usr.fn_splitval(@pa_id,@l_counter))       
			WHERE  USES_ID            = CONVERT(INT,@pa_trantm_id)   
			AND    USES_DELETED_IND   = 1  
	--	end
	--		set @l_counter= @l_counter +1 
	--end

    SET @l_error = @@error  
    IF @l_error <> 0  
    BEGIN  
    --  
      IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)  
      BEGIN  
      --  
        SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)  
        SET @pa_errmsg = @t_errorstr  
      --  
      END  
      ELSE  
      BEGIN  
      --  
        SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'  
        SET @pa_errmsg = @t_errorstr  
      --  
      END  
  
      ROLLBACK TRANSACTION   
  
      RETURN  
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

GO
