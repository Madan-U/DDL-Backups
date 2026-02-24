-- Object: PROCEDURE citrus_usr.pr_main_execute_multislip_cdsl
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--begin transaction
--rollback
--pr_main_execute_multislip_cdsl '0','INS','HO','12054100','1205410000000237','994','05/11/2008','05/11/2008','A|*~|BOCM|*~|IN0019980336|*~|12|*~|3|*~|11|*~||*~|1|*~|Y|*~|0|*~||*~|12054100|*~|45454545|*~|0|*~|*|~*','NEW RECORTD',1,'*|~*','|*~|',''
--pr_main_execute_multislip_cdsl '262','EDT','HO','12054100','1205410000000013','4','29/09/2008','29/09/2008','E|*~|BOBO|*~|INE074F01016|*~|1500.00000|*~|0|*~|0|*~||*~|1|*~|Y|*~|0|*~|12888E45|*~|12054100|*~|344534ER|*~|1001|*~|*|~*D|*~||*~||*~||*~|0|*~||*~||*~||*~||*~|0|*~||*~||*~||*~|1003|*~|*|~*E|*~|BOCM|*~|INE020D01014|*~|240.00000|*~|6|*~|22|*~|33334567|*~|2|*~|Y|*~|0|*~|12132342|*~|12054100|*~|89898989|*~|1002|*~|*|~*','REMARKS FRENT RGR NJHNTJ EDITED',1,'*|~*','|*~|',''
--pr_main_execute_multislip_cdsl '258*|~*','APP','SOPAN','','','','','','|*~||*~||*~||*~|0|*~||*~||*~||*~||*~|0|*~||*~||*~||*~||*~|*|~*','',1,'*|~*','|*~|',''
CREATE PROCEDURE [citrus_usr].[pr_main_execute_multislip_cdsl](@pa_id          VARCHAR(8000) 
                                               ,@pa_action      VARCHAR(20)  
                                               ,@pa_login_name      VARCHAR(20)    
                                               ,@pa_dpm_dpid        VARCHAR(50)
                                               ,@pa_dpam_acct_no    VARCHAR(50)  
                                               ,@pa_slip_no         VARCHAR(20)
                                               ,@pa_req_dt          VARCHAR(11)       
                                               ,@pa_exe_dt          VARCHAR(11)  
                                               ,@pa_values      VARCHAR(8000)
                                               ,@pa_rmks            VARCHAR(250)    
                                               ,@pa_chk_yn          INT   
                                               ,@pa_sp_flg      varchar(25)  
                                               ,@rowdelimiter   char(4)  = '*|~*'      
                                               ,@coldelimiter   char(4)  = '|*~|'
                                               ,@pa_errmsg          VARCHAR(8000) output    )
AS
BEGIN
	DECLARE @t_errorstr            varchar(8000)      
        , @l_error               bigint      
        , @delimeter             varchar(5)      
        , @remainingstring       varchar(8000)      
        , @currstring            varchar(8000)      
        , @remainingstring2      varchar(8000)      
        , @currstring2           varchar(8000)      
        , @foundat               integer      
        , @delimeterlength       int      
        , @l_counter             int      
        , @l_flg                 INT
        , @l_count               NUMERIC
        , @l_dtls_id             VARCHAR(8000)
        , @l_dtls_values VARCHAR(8000)
        , @l_values VARCHAR(8000)
        
        , @l_error_msg varchar(8000)
        , @pa_tab             VARCHAR(20)  
        , @pa_mkt_type        VARCHAR(20)   
        , @pa_settlm_no       VARCHAR(20)  
        , @pa_cm_id           numeric  
        , @pa_excm_id         numeric  
        , @pa_cash_trf        char(2)  
        , @pa_tr_cmbpid       VARCHAR(20)
        , @pa_tr_dp_id        VARCHAR(20)  
        , @pa_tr_setm_type    VARCHAR(20)  
        , @pa_tr_setm_no      VARCHAR(20)  
        , @pa_tr_acct_no      VARCHAR(20)  
        , @pa_trdReasoncd     varchar(30)  
        
         SET @l_error           = 0      
    SET @t_errorstr        = ''      
    SET @delimeter          = '%'+ @rowdelimiter + '%'      
    SET @delimeterlength   = len(@rowdelimiter)      
    SET @remainingstring2  = @pa_id      
    --      
    WHILE @remainingstring2 <> ''      
    BEGIN      
    --      
      SET @foundat        = 0      
      SET @foundat        =  patindex('%'+@delimeter+'%',@remainingstring2)      
      --      
      IF @foundat > 0      
      BEGIN      
      --      
        SET @currstring2      = substring(@remainingstring2, 0,@foundat)      
        SET @remainingstring2 = substring(@remainingstring2, @foundat+@delimeterlength,len(@remainingstring2)- @foundat+@delimeterlength)      
      --      
      END      
      ELSE      
      BEGIN      
      --      
        SET @currstring2      = @remainingstring2      
        SET @remainingstring2 = ''      
      --      
      END      
      --      
      IF @currstring2 <> ''      
      BEGIN--curr_id      
      --pa_id--      
        SET @delimeter        = '%'+ @rowdelimiter + '%'      
        SET @delimeterlength = len(@rowdelimiter)      
        SET @remainingstring = @pa_values      
        -- 
        SELECT @l_count = citrus_usr.ufn_CountString(@remainingstring,'*|~*')
        SET @l_counter = 1     
        
             
            WHILE @l_counter <= @l_count
            BEGIN
            
               SET @l_dtls_id = '0' 
               SELECT @l_values = citrus_usr.FN_SPLITVAL_ROW(@remainingstring,@l_counter)
                              
               IF @PA_ACTION not in ('APP','REJ')
               BEGIN
				   IF @pa_chk_yn = 0 AND EXISTS(SELECT dptdc_dtls_id FROM citrus_usr.DP_TRX_DTLS_CDSL WHERE dptdc_slip_no = @pa_slip_no AND dptdc_deleted_ind = 1) AND @pa_action IN('EDT','INS')
				   BEGIN
				   SELECT @l_dtls_id = 	CONVERT(VARCHAR(200),dptdc_dtls_id) FROM citrus_usr.DP_TRX_DTLS_CDSL WHERE dptdc_slip_no = @pa_slip_no AND dptdc_deleted_ind = 1
				   SET @pa_action = 'EDT'
				   END
				   ELSE IF @pa_chk_yn = 1 AND EXISTS(SELECT dptdc_dtls_id FROM citrus_usr.dptdc_mak WHERE dptdc_slip_no = @pa_slip_no AND dptdc_deleted_ind = 0) AND @pa_action IN('EDT','INS')
				   BEGIN
				   SELECT @l_dtls_id = 	CONVERT(VARCHAR(200),dptdc_dtls_id) FROM citrus_usr.dptdc_mak WHERE dptdc_slip_no = @pa_slip_no AND dptdc_deleted_ind = 0
				   SET @pa_action = 'EDT'
				   END
				   ELSE IF @pa_chk_yn = 1 AND EXISTS(SELECT dptdc_dtls_id FROM citrus_usr.dp_trx_dtls_cdsl WHERE dptdc_slip_no = @pa_slip_no AND dptdc_deleted_ind = 1) AND @pa_action IN('EDT','INS')
				   BEGIN
				   
				   SELECT @l_dtls_id = 	CONVERT(VARCHAR(200),dptdc_dtls_id) FROM citrus_usr.dp_trx_dtls_cdsl WHERE dptdc_slip_no = @pa_slip_no AND dptdc_deleted_ind = 1
				   SET @pa_action = 'EDT'
				   END
				   ELSE IF @pa_action = 'DEL' 
				   BEGIN
			   		SET @l_dtls_id = @pa_id
			   		SET @pa_action = 'DEL'
				   END
				   ELSE 
				   BEGIN
			   		SET @l_dtls_id = '0' 
			   		SET @pa_action = 'INS'
				   END
                END
                ELSE 
                BEGIN
                  SET @l_dtls_id = @pa_id
                  SET @l_dtls_values    ='0'
			   	  
                END 
                             
               SET @pa_tab         = citrus_usr.FN_SPLITVAL(@l_values,2)
               SET @pa_mkt_type    = citrus_usr.FN_SPLITVAL(@l_values,6)   
			   SET @pa_settlm_no   = citrus_usr.FN_SPLITVAL(@l_values,7)  
			   SET @pa_cm_id       = case when citrus_usr.FN_SPLITVAL(@l_values,10)   ='' then '0' else citrus_usr.FN_SPLITVAL(@l_values,10) end 
			   SET @pa_excm_id     = case when citrus_usr.FN_SPLITVAL(@l_values,5)    = '' then '0' else citrus_usr.FN_SPLITVAL(@l_values,5)     end 
			   SET @pa_cash_trf    = citrus_usr.FN_SPLITVAL(@l_values,9) 
			   SET @pa_tr_cmbpid   = citrus_usr.FN_SPLITVAL(@l_values,11)
			   SET @pa_tr_dp_id    = citrus_usr.FN_SPLITVAL(@l_values,12)
			   SET @pa_tr_acct_no  = citrus_usr.FN_SPLITVAL(@l_values,13)
               SET @pa_tr_setm_type = citrus_usr.FN_SPLITVAL(@l_values,14)
               SET @pa_tr_setm_no = citrus_usr.FN_SPLITVAL(@l_values,15)
			   SET @pa_trdReasoncd = case when citrus_usr.FN_SPLITVAL(@l_values,8)='' then '0' else citrus_usr.FN_SPLITVAL(@l_values,8) end
			   
			   SELECT citrus_usr.FN_SPLITVAL(@l_values,1)
           			   
			    IF citrus_usr.FN_SPLITVAL(@l_values,1) = 'A' OR citrus_usr.FN_SPLITVAL(@l_values,1) = 'E'
				BEGIN  
				--  
					SET @l_dtls_values       = citrus_usr.FN_SPLITVAL(@l_values,1)+'|*~|'+citrus_usr.FN_SPLITVAL(@l_values,3)+'|*~|'+citrus_usr.FN_SPLITVAL(@l_values,4)+'|*~|'+citrus_usr.FN_SPLITVAL(@l_values,16)+'|*~|*|~*'				--  
                
				END  
				ELSE  IF citrus_usr.FN_SPLITVAL(@l_values,1) = 'D'
				BEGIN  
				--  
				  SET @l_dtls_values       =  citrus_usr.FN_SPLITVAL(@l_values,1)+'|*~|'+citrus_usr.FN_SPLITVAL(@l_values,16)+'|*~|*|~*'				--  
				  
				  
				--  
				END
			
			 
               IF @pa_sp_flg = 'N'
               EXEC pr_ins_upd_trx_cdsl_multislip @l_dtls_id,@pa_tab
                                                 ,@pa_action,@pa_login_name
                                                 ,@pa_dpm_dpid,@pa_dpam_acct_no
                                                 ,@pa_slip_no,@pa_mkt_type
                                                 ,@pa_settlm_no,@pa_req_dt
                                                 ,@pa_cm_id ,@pa_excm_id
                                                 ,@pa_cash_trf,@pa_exe_dt
                                                 ,@pa_tr_cmbpid,@pa_tr_dp_id
                                                 ,@pa_tr_setm_type,@pa_tr_setm_no
                                                 ,@pa_tr_acct_no,@l_dtls_values
                                                 ,@pa_rmks,@pa_trdReasoncd
                                                 ,@pa_chk_yn,@rowdelimiter
                                                 ,@coldelimiter,@pa_errmsg = @l_error_msg output

                IF @pa_sp_flg = 'Y'
                EXEC pr_ins_upd_trx_cdsl_multislip_sp @l_dtls_id,@pa_tab
                                                 ,@pa_action,@pa_login_name
                                                 ,@pa_dpm_dpid,@pa_dpam_acct_no
                                                 ,@pa_slip_no,@pa_mkt_type
                                                 ,@pa_settlm_no,@pa_req_dt
                                                 ,@pa_cm_id ,@pa_excm_id
                                                 ,@pa_cash_trf,@pa_exe_dt
                                                 ,@pa_tr_cmbpid,@pa_tr_dp_id
                                                 ,@pa_tr_setm_type,@pa_tr_setm_no
                                                 ,@pa_tr_acct_no,@l_dtls_values
                                                 ,@pa_rmks,@pa_trdReasoncd
                                                 ,@pa_chk_yn,@rowdelimiter
                                                 ,@coldelimiter,@pa_errmsg = @l_error_msg output
        
				   SET @pa_tab         = ''
				   SET @pa_mkt_type    = ''
				   SET @pa_settlm_no   = ''
				   SET @pa_cm_id       = 0
				   SET @pa_excm_id     = 0
				   SET @pa_cash_trf    = ''
				   SET @pa_tr_cmbpid   = ''
				   SET @pa_tr_dp_id    = ''
				   SET @pa_tr_acct_no  = ''
				   SET @pa_trdReasoncd = ''
				   SET @l_dtls_values  =''
			                                                        
                                                 
              SET @l_counter = @l_counter + 1
             END
      --
      END   
    --
    END 
  set @pa_errmsg=convert(varchar,@l_error_msg) 
  IF left(ltrim(rtrim(@pa_errmsg)),5) <> 'ERROR'  
  BEGIN  
    exec pr_checkslipno '','1', @pa_dpm_dpid,@pa_dpam_acct_no,@pa_slip_no,@pa_login_name,''  
  END  
END

GO
