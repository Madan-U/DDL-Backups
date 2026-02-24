-- Object: PROCEDURE citrus_usr.pr_ins_upd_intersetm_trx
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

/*
DPTD_ID
DPTD_DPAM_ID
DPTD_REQUEST_DT
DPTD_SLIP_NO
DPTD_ISIN
DPTD_BATCH_NO
DPTD_LINE_NO
DPTD_QTY
DPTD_INTERNAL_REF_NO
DPTD_TRANS_NO
DPTD_TRATM_ID
DPTD_MKT_TYPE
DPTD_SETTLEMENT_NO
DPTD_EXECUTION_DT
DPTD_OTHER_SETTLEMENT_TYPE
DPTD_OTHER_SETTLEMENT_NO
DPTD_COUNTER_DP_ID
DPTD_COUNTER_CMBP_ID
DPTD_COUNTER_DEMAT_ACCT_NO
DPTD_CREATED_BY
DPTD_CREATED_DT
DPTD_LST_UPD_BY
DPTD_LST_UPD_DT
DPTD_DELETED_IND 

-- InterSettlement Delivery

Trans_code = 907

Dp_id

CMBP_ID -- fetch client account no under above dp using cmbpid property = cmbpid

request_date

Execution_date

Sr_no

sett_type

sett_no

Target_Sett_type

Target_Sett_no

Isin + coldel + Qty + coldel + rowdel

 

 


*/
CREATE PROCEDURE [citrus_usr].[pr_ins_upd_intersetm_trx](@pa_id              VARCHAR(8000)  
													,@pa_action          VARCHAR(20)  
													,@pa_login_name      VARCHAR(20)  
													,@pa_dpm_dpid        VARCHAR(50)
													,@pa_cmbp_id         VARCHAR(50)
													,@pa_slip_no 	       VARCHAR(20) 
													,@pa_mkt_type        VARCHAR(20) 
													,@pa_settlm_no							VARCHAR(20) 
													,@pa_req_dt   						 VARCHAR(11)
													,@pa_exe_dt   						 VARCHAR(11)
													,@pa_tr_setm_type			 VARCHAR(20)
													,@pa_tr_setm_no					 VARCHAR(20)
													,@pa_values      				VARCHAR(8000) 
													,@pa_rmks           VARCHAR(50)
													,@pa_chk_yn          INT  
													,@rowdelimiter       CHAR(4)       = '*|~*'  
													,@coldelimiter       CHAR(4)       = '|*~|'  
																													,@pa_errmsg          VARCHAR(8000) output  
	)  
AS
/*
*********************************************************************************
 SYSTEM         : dp
 MODULE NAME    : pr_ins_upd_intersetm_trx
 DESCRIPTION    : this procedure will contain the maker checker facility for transaction details
 COPYRIGHT(C)   : marketplace technologies 
 VERSION HISTORY: 1.0
 VERS.  AUTHOR            DATE          REASON
 -----  -------------     ------------  --------------------------------------------------
 1.0    TUSHAR            05-DEC-2007   VERSION.
-----------------------------------------------------------------------------------*/
BEGIN
--
DECLARE @t_errorstr      VARCHAR(8000)
      , @l_error         BIGINT
      , @delimeter       VARCHAR(10)
      , @remainingstring VARCHAR(8000)
      , @currstring      VARCHAR(8000)
      , @foundat         INTEGER
      , @delimeterlength INT
      , @l_dptd_id      NUMERIC
      , @l_dptdm_id     NUMERIC
      , @delimeter_value varchar(10)
      , @delimeterlength_value varchar(10)
      , @remainingstring_value varchar(8000)
      , @currstring_value varchar(8000)
      , @l_access1      int
      , @l_access       int
      , @l_excm_id      numeric
      , @l_excm_cd      VARCHAR(500)
      , @l_dpm_id       NUMERIC
      , @l_deleted_ind  smallint
      , @l_dpam_id      numeric
      , @line_no        NUMERIC
      , @l_tr_dpid      VARCHAR(25) 
      , @l_tr_sett_type VARCHAR(50)
      , @l_tr_setm_no   VARCHAR(50)
      , @l_isin         VARCHAR(25) 
      , @l_qty          VARCHAR(25) 
      , @l_trastm_id    VARCHAR(25)
      , @l_action       VARCHAR(25)
      , @l_dtls_id      NUMERIC
      , @l_dpam_acct_no VARCHAR(20)
      , @l_id           varchar(20)
      , @l_dtlsm_id      NUMERIC
      ,@@c_access_cursor cursor
						,@c_deleted_ind    varchar(20)
      ,@c_dptd_id        varchar(20)
      ,@l_trastm_desc    varchar(20)
      , @l_max_high_val   numeric(18,5)
      ,@l_high_val_yn     char(1)  
      ,@l_val_yn     char(1)  
						      


  SELECT DISTINCT @l_dpam_acct_no = dpam_sba_no
										  FROM   account_properties
										     ,   dp_acct_mstr
										  WHERE  dpam_id = accp_clisba_id
										  AND    accp_accpm_prop_cd = 'CMBP_ID'
										  AND    accp_deleted_ind   = 1 
										  AND    accp_value         = @pa_cmbp_id

set @l_val_yn  = citrus_usr.fn_get_high_val('',0,'DORMANT',@l_dpam_acct_no,convert(datetime,@pa_req_dt,103))           

      
SET @l_trastm_id     = '907'
SET @l_trastm_desc   = 'ATO' 


IF @PA_ACTION <> 'app'  AND @PA_ACTION <> 'rej'       
BEGIN
--
  CREATE TABLE #dptd_mak
  (dptd_id numeric
		,dptd_dtls_id numeric
		,dptd_dpam_id numeric
		,dptd_request_dt datetime
		,dptd_execution_dt datetime
		,dptd_slip_no varchar(50)
		,dptd_isin    varchar(20)
		,dptd_line_no varchar(20)
		,dptd_qty     numeric
		,dptd_trastm_cd varchar(20)
		,dptd_mkt_type varchar(20)
		,dptd_settlement_no varchar(20)
		,dptd_other_settlement_type varchar(20)
		,dptd_other_settlement_no varchar(20)
		,dptd_status char 
		,dptd_internal_trastm varchar(20)
		,dptd_rmks   varchar(250)
		,dptd_created_by varchar(20)
		,dptd_created_dt datetime
		,dptd_lst_upd_by varchar(20)
		,dptd_lst_upd_dt datetime
		,dptd_deleted_ind  smallint
  )
  
  INSERT INTO #dptd_mak
  (dptd_id
		,dptd_dtls_id
		,dptd_dpam_id
		,dptd_request_dt
		,dptd_execution_dt
		,dptd_slip_no
		,dptd_isin
		,dptd_line_no
		,dptd_qty
		,dptd_trastm_cd
		,dptd_mkt_type
		,dptd_settlement_no
		,dptd_other_settlement_type
		,dptd_other_settlement_no
		,dptd_status
		,dptd_internal_trastm
		,dptd_rmks
		,dptd_created_by
		,dptd_created_dt
		,dptd_lst_upd_by
		,dptd_lst_upd_dt
		,dptd_deleted_ind )
		SELECT dptd_id
		,dptd_dtls_id
		,dptd_dpam_id
		,dptd_request_dt
		,dptd_execution_dt
		,dptd_slip_no
		,dptd_isin
		,dptd_line_no
		,dptd_qty
		,dptd_trastm_cd
		,dptd_mkt_type
		,dptd_settlement_no
		,dptd_other_settlement_type
		,dptd_other_settlement_no
			,dptd_status
		,dptd_internal_trastm
		,dptd_rmks
		,dptd_created_by
		,dptd_created_dt
		,dptd_lst_upd_by
		,dptd_lst_upd_dt
		,dptd_deleted_ind 
		FROM dptd_mak 
		where dptd_dtls_id = @pa_id

  
--
END
IF @pa_action = 'INS' or @pa_action = 'EDT'
BEGIN
--
  
  /*SELECT @l_dtls_id   = ISNULL(MAX(dptd_dtls_id),0) + 1 FROM dp_trx_dtls  
																
		SELECT @l_dtlsm_id   = ISNULL(MAX(dptd_dtls_id),0) + 1 FROM dptd_mak
		
		IF @l_dtlsm_id  > @l_dtls_id   
		BEGIN
		--
		  set @l_dtls_id = @l_dtlsm_id   
		--
		END
		
		IF @pa_chk_yn = 0
		BEGIN
		--
		  SELECT @l_dtls_id = ISNULL(MAX(dptd_dtls_id),0) + 1 from  dp_trx_dtls WHERE dptd_trastm_cd =@l_trastm_id     
		--
		END*/


declare @l_count_row   bigint
        set @l_count_row    = citrus_usr.ufn_countstring(@pa_values,'*|~*')


		begin transaction
		
		update bitmap_ref_mstr with(tablock)
		set    bitrm_deleted_ind = 1 
		where  bitrm_id = 1 
		and    bitrm_deleted_ind = 1 
		
	IF @pa_action = 'INS'	
	begin	
		  select @l_dtls_id = BITRM_BIT_LOCATION 
		  from  bitmap_ref_mstr 
		  where BITRM_PARENT_CD = 'DPTD_DTLS_ID'
		
		  update bitmap_ref_mstr with(tablock)
		  set    BITRM_BIT_LOCATION  = BITRM_BIT_LOCATION  + 1 
		  where BITRM_PARENT_CD = 'DPTD_DTLS_ID'
	end	
		
		  select @l_dptd_id = BITRM_BIT_LOCATION 
		  from  bitmap_ref_mstr 
		  where BITRM_PARENT_CD = 'DPTD_ID'
		
		  update bitmap_ref_mstr with(tablock)
		  set    BITRM_BIT_LOCATION  = BITRM_BIT_LOCATION + @l_count_row 
		  where BITRM_PARENT_CD = 'DPTD_ID'
		
		set @l_count_row = 0
		
  commit transaction

--
END
ELSE IF @pa_action = 'EDT' 
BEGIN
--
  IF @pa_chk_yn = 0
  BEGIN
  --
    SELECT @l_dtls_id = dptd_dtls_id FROM  dp_trx_dtls WHERE dptd_dtls_id = convert(numeric,@pa_id) AND dptd_trastm_cd = @l_trastm_id     
  --
  END
  ELSE
  BEGIN
  --
    SELECT @l_dtls_id = dptd_dtls_id FROM  dptd_mak WHERE dptd_dtls_id = convert(numeric,@pa_id) AND dptd_trastm_cd = @l_trastm_id     
  --
  END
-- 
END

DECLARE @l_str1 VARCHAR(8000)
,@l_str2 VARCHAR(500)
,@l_counter INT
,@l_max_counter INT
CREATE TABLE #temp_id (id INT)

--changed for maker master edit
if @pa_action = 'EDT' and @pa_values <> '0' and @pa_chk_yn = 1 and exists(select dptd_id from dp_trx_dtls where dptd_dtls_id = @pa_id and dptd_deleted_ind = 1)
begin 
--
		SET @l_counter = 1
		SET @l_str1 = @pa_values
		SET @l_max_counter = citrus_usr.ufn_countstring(@l_str1,'*|~*')
		WHILE @l_counter  <= @l_max_counter
		BEGIN
		-- 
	  	SELECT @l_str2 = citrus_usr.FN_SPLITVAL_ROW(@l_str1,@l_counter)
	  	INSERT INTO #temp_id VALUES(citrus_usr.FN_SPLITVAL(@l_str2,4))
	  	
		  SET @l_counter   = @l_counter   + 1
		--  
		END
		
		INSERT INTO DPTD_MAK    
		(dptd_id
		,dptd_dtls_id
		,dptd_internal_ref_no
		,dptd_dpam_id
		,dptd_request_dt
		,dptd_execution_dt
		,dptd_slip_no
		,dptd_isin
		,dptd_line_no
		,dptd_qty
		,dptd_trastm_cd
		,dptd_mkt_type
		,dptd_settlement_no
		,dptd_other_settlement_type
		,dptd_other_settlement_no
		,dptd_status
		,dptd_internal_trastm
		,dptd_rmks
		,dptd_created_by
		,dptd_created_dt
		,dptd_lst_upd_by
		,dptd_lst_upd_dt
		,dptd_deleted_ind  
		)     
		select dptd_id    
		,dptd_dtls_id    
		,dptd_id
		,dptd_dpam_id    
		,convert(datetime,@pa_req_dt,103)    
		,convert(datetime,@pa_exe_dt,103)    
			,@pa_slip_no    
		,dptd_isin    
		,dptd_line_no    
		,dptd_qty    
		,dptd_trastm_cd    
		,@pa_mkt_type    
		,@pa_settlm_no    
		,@pa_tr_setm_type    
		,@pa_tr_setm_no    
		,'P'    
		,@l_trastm_desc    
		,@pa_rmks    
		,dptd_created_by    
		,dptd_created_dt    
		,@pa_login_name    
		,getdate()    
		,6
		FROM  dp_trx_dtls    
		WHERE dptd_id       not in (select id from #temp_id)
		and   dptd_dtls_id  = @pa_id
		AND   dptd_deleted_ind   =  1 
		
		
--
end
else IF @pa_action = 'EDT' and @pa_values <> '0' and @pa_chk_yn = 1 and NOT exists(select dptd_id from dp_trx_dtls where dptd_dtls_id = @pa_id and dptd_deleted_ind = 1)
begin
--
 
		SET @l_counter = 1
		SET @l_str1 = @pa_values
		SET @l_max_counter = citrus_usr.ufn_countstring(@l_str1,'*|~*')
		WHILE @l_counter  <= @l_max_counter
		BEGIN
		-- 
				SELECT @l_str2 = citrus_usr.FN_SPLITVAL_ROW(@l_str1,@l_counter)
				INSERT INTO #temp_id VALUES(citrus_usr.FN_SPLITVAL(@l_str2,4))

				SET @l_counter   = @l_counter   + 1
		--  
		END
			
		delete from 		 dptd_mak    
		WHERE dptd_id       not in (select id from #temp_id)	
		and   dptd_dtls_id  = @pa_id
		AND   dptd_deleted_ind   in (0,4,6,-1)
			
		INSERT INTO DPTD_MAK    
		(dptd_id
		,dptd_dtls_id
		,dptd_internal_ref_no
		,dptd_dpam_id
		,dptd_request_dt
		,dptd_execution_dt
		,dptd_slip_no
		,dptd_isin
		,dptd_line_no
		,dptd_qty
		,dptd_trastm_cd
		,dptd_mkt_type
		,dptd_settlement_no
		,dptd_other_settlement_type
		,dptd_other_settlement_no
		,dptd_status
		,dptd_internal_trastm
		,dptd_rmks
		,dptd_created_by
		,dptd_created_dt
		,dptd_lst_upd_by
		,dptd_lst_upd_dt
		,dptd_deleted_ind    
		)     
		select dptd_id    
		,dptd_dtls_id    
		,dptd_id
		,dptd_dpam_id    
		,convert(datetime,@pa_req_dt,103)    
		,convert(datetime,@pa_exe_dt,103)    
			,@pa_slip_no    
		,dptd_isin    
		,dptd_line_no    
		,dptd_qty    
		,dptd_trastm_cd    
		,@pa_mkt_type    
		,@pa_settlm_no    
		,@pa_tr_setm_type    
		,@pa_tr_setm_no    
		,'P'    
		,@l_trastm_desc    
		,@pa_rmks    
		,dptd_created_by    
		,dptd_created_dt    
		,@pa_login_name    
		,getdate()    
		,0
		FROM  #dptd_mak    
		WHERE dptd_id       not in (select id from #temp_id)
		and   dptd_dtls_id  = @pa_id
		AND   dptd_deleted_ind   in (0,4,6,-1)
--
end


declare @c_access_cursor cursor
set @l_excm_cd = ''
set @l_access1       = 0 
SET @l_error         = 0
SET @t_errorstr      = ''
SET @delimeter        = '%'+ @ROWDELIMITER + '%'
SET @delimeterlength = LEN(@ROWDELIMITER)
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
				--
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
								--
								IF @currstring_value <> ''
								BEGIN
								--
								  set @line_no = @line_no + 1
								  --Target_client_id (16 characters) + coldel + Target_Sett_type + coldel + Target_Sett_no + coldel + Isin + coldel + Qty + coldel + rowdel
          print @currstring_value								
								  SET @l_action             = citrus_usr.fn_splitval(@currstring_value,1)      
																		  
										IF @l_action = 'A' OR @l_action ='E'
										BEGIN
										--
										  
												SET @l_isin               = citrus_usr.fn_splitval(@currstring_value,2)      				     							  
												SET @l_qty                = citrus_usr.fn_splitval(@currstring_value,3) 
												SET @l_id                 = citrus_usr.fn_splitval(@currstring_value,4) 
												SET @l_qty               = CONVERT(VARCHAR(25),CONVERT(NUMERIC(10,5),-1*citrus_usr.fn_splitval(@currstring_value,3))) 
												set @l_high_val_yn        = case when @l_val_yn = 'Y' then 'Y' else citrus_usr.fn_get_high_val(@l_isin,abs(@l_qty),'HIGH_VALUE','','') end
										--
										END
										ELSE
										BEGIN
										--
												SET @l_id                = citrus_usr.fn_splitval(@currstring_value,2) 
										--
										END
										
									 IF @pa_chk_yn = 0
										BEGIN
										--
										  SELECT DISTINCT @l_dpam_acct_no = dpam_sba_no
										  FROM   account_properties
										     ,   dp_acct_mstr
										  WHERE  dpam_id = accp_clisba_id
										  AND    accp_accpm_prop_cd = 'CMBP_ID'
										  AND    accp_deleted_ind   = 1 
										  AND    accp_value         = @pa_cmbp_id
										  
										  
												SELECT @l_dpam_id     = dpam_id FROM dp_acct_mstr, dp_mstr WHERE dpm_deleted_ind = 1   and dpm_id = dpam_dpm_id and dpm_dpid = @pa_dpm_dpid and dpam_sba_no = @l_dpam_acct_no

												IF @PA_ACTION = 'INS' OR @l_action = 'A'
												BEGIN
												--
														BEGIN TRANSACTION

														--SELECT @l_dptd_id   = ISNULL(MAX(dptd_id),0) + 1 FROM dp_trx_dtls  
set @l_dptd_id = @l_dptd_id + 1
														
														INSERT INTO DP_TRX_DTLS
              (dptd_id
              ,dptd_dtls_id
              ,dptd_internal_ref_no
														,dptd_dpam_id
														,dptd_request_dt
														,dptd_execution_dt
														,dptd_slip_no
														,dptd_isin
														,dptd_line_no
														,dptd_qty
														,dptd_trastm_cd
														,dptd_mkt_type
														,dptd_settlement_no
														,dptd_other_settlement_type
														,dptd_other_settlement_no
														,dptd_status
		            ,dptd_internal_trastm
		            ,dptd_rmks
														,dptd_created_by
														,dptd_created_dt
														,dptd_lst_upd_by
														,dptd_lst_upd_dt
														,dptd_deleted_ind 
              )VALUES 
              (@l_dptd_id 
              ,@l_dtls_id
              ,@l_dptd_id 
              ,@l_dpam_id
              ,convert(datetime,@pa_req_dt,103)
              ,convert(datetime,@pa_exe_dt,103)
              ,@pa_slip_no
              ,@l_isin
              ,@line_no
              ,@l_qty
              ,@l_trastm_id
              ,@pa_mkt_type
              ,@pa_settlm_no
              ,@pa_tr_setm_type
              ,@pa_tr_setm_no
              ,'P'
              ,@l_trastm_desc
              ,@pa_rmks
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
																SET @t_errorstr = convert(varchar,@l_dtls_id) 
																COMMIT TRANSACTION
														--
														END

												--
												END
												IF @PA_ACTION = 'EDT' OR @l_action = 'E'
												BEGIN
												--
														BEGIN TRANSACTION

              IF @pa_action = 'EDT' 
              BEGIN
              --
              		UPDATE  dp_trx_dtls 
																SET     dptd_dpam_id              = @l_dpam_id
																							,dptd_request_dt           = convert(datetime,@pa_req_dt,103)
																							,dptd_execution_dt         = convert(datetime,@pa_exe_dt,103)
																							,dptd_slip_no              = @pa_slip_no
																							,dptd_mkt_type             = @pa_mkt_type
																							,dptd_settlement_no        = @pa_settlm_no
																							,dptd_other_settlement_type= @pa_tr_setm_type
																							,dptd_other_settlement_no  = @pa_tr_setm_no
																							,dptd_rmks																	=	@Pa_rmks			
																							,dptd_lst_upd_dt           = getdate()
																							,dptd_lst_upd_by           = @pa_login_name
																WHERE   dptd_dtls_id              = convert(INT,@currstring)
																AND     dptd_deleted_ind          = 1
														--
														END
														IF @l_action = 'E'
														BEGIN
														--
														  
														  UPDATE  dp_trx_dtls 
																SET     dptd_dpam_id              = @l_dpam_id
																							,dptd_request_dt           = convert(datetime,@pa_req_dt,103)
																							,dptd_execution_dt         = convert(datetime,@pa_exe_dt,103)
																							,dptd_slip_no              = @pa_slip_no
																							,dptd_isin                 = @l_isin
																							,dptd_qty                  = @l_qty
																							,dptd_mkt_type             = @pa_mkt_type
																							,dptd_settlement_no        = @pa_settlm_no
																							,dptd_other_settlement_type= @pa_tr_setm_type
																							,dptd_other_settlement_no  = @pa_tr_setm_no
																							,dptd_rmks																	=	@Pa_rmks
																							,dptd_lst_upd_dt           = getdate()
																							,dptd_lst_upd_by           = @pa_login_name
																WHERE   dptd_id                   = @l_id 
																AND     dptd_deleted_ind          = 1
														--
														END
              
              
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
												IF @PA_ACTION = 'DEL' OR @l_action = 'D'
												BEGIN
												--
														BEGIN TRANSACTION

              IF @pa_action = 'DEL'
														BEGIN
														--
																UPDATE dp_trx_dtls
																SET    dptd_deleted_ind = 0
																					, dptd_lst_upd_dt  = getdate()
																					, dptd_lst_upd_by  = @pa_login_name
																WHERE  dptd_deleted_ind = 1
																AND    dptd_dtls_id     = convert(INT,@currstring)
																
																
																UPDATE USES
																SET    USES_DELETED_IND = 0
																						,USES_LST_UPD_BY  = @PA_LOGIN_NAME
																						,USES_LST_UPD_DT  = GETDATE()
																FROM   USED_SLIP USES
																						,DP_TRX_DTLS   DPTD
																WHERE  dptd_deleted_ind = 1
																AND    dptd_dtls_id     = convert(INT,@currstring)
																AND    dptd_slip_no     = uses_slip_no
																and    uses_deleted_ind = 1 
																
																
														--
														END
														IF @l_action = 'D'
														BEGIN
														--
																UPDATE dp_trx_dtls
																SET    dptd_deleted_ind = 0
																					, dptd_lst_upd_dt  = getdate()
																					, dptd_lst_upd_by  = @pa_login_name
																WHERE  dptd_deleted_ind = 1
																AND    dptd_id     = @l_id
														--
														END
               
               
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
										ELSE IF @pa_chk_yn = 1
										BEGIN
										--
										
										  SELECT DISTINCT @l_dpam_acct_no = dpam_sba_no
												FROM   account_properties
															,   dp_acct_mstr
												WHERE  dpam_id = accp_clisba_id
												AND    accp_accpm_prop_cd = 'CMBP_ID'
												AND  		accp_deleted_ind   = 1 
												AND    accp_value  = @pa_cmbp_id 
																						  
												SELECT @l_dpam_id     = dpam_id FROM dp_acct_mstr, dp_mstr WHERE dpm_deleted_ind = 1   and dpm_id = dpam_dpm_id and dpm_dpid = @pa_dpm_dpid and dpam_sba_no = @l_dpam_acct_no
												
												
												IF @PA_ACTION = 'INS'
												BEGIN
												--

														BEGIN TRANSACTION
														
														
--														SELECT @l_dptd_id   = ISNULL(MAX(dptd_id),0) + 1 FROM dp_trx_dtls  
--														
--														SELECT @l_dptdm_id   = ISNULL(MAX(dptd_id),0) + 1 FROM dptd_mak
--														
--														IF @l_dptdm_id   > @l_dptd_id   
--														BEGIN
--														--
--														  SET @l_dptd_id = @l_dptdm_id   
--														--
--														END

set @l_dptd_id = @l_dptd_id + 1
														
														INSERT INTO DPTD_MAK
														(dptd_id
														,dptd_dtls_id
														,dptd_internal_ref_no
														,dptd_dpam_id
														,dptd_request_dt
														,dptd_execution_dt
														,dptd_slip_no
														,dptd_isin
														,dptd_line_no
														,dptd_qty
														,dptd_trastm_cd
														,dptd_mkt_type
														,dptd_settlement_no
														,dptd_other_settlement_type
														,dptd_other_settlement_no
															,dptd_status
		            ,dptd_internal_trastm
		            ,dptd_rmks
														,dptd_created_by
														,dptd_created_dt
														,dptd_lst_upd_by
														,dptd_lst_upd_dt
														,dptd_deleted_ind 
														)VALUES 
														(@l_dptd_id
														,@l_dtls_id
														,@l_dptd_id
														,@l_dpam_id
														,convert(datetime,@pa_req_dt,103)
              ,convert(datetime,@pa_exe_dt,103)
														,@pa_slip_no
														,@l_isin
														,@line_no
														,@l_qty
														,@l_trastm_id
														,@pa_mkt_type
														,@pa_settlm_no
														,@pa_tr_setm_type
														,@pa_tr_setm_no
														,'P'
              ,@l_trastm_desc
              ,@pa_rmks
														,@pa_login_name
														,getdate()
														,@pa_login_name
														,getdate()
														,case when @l_high_val_yn = 'Y' then -1 else 0 end  
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
														  SET @t_errorstr = convert(varchar,@l_dtls_id) 
														  
														  
																COMMIT TRANSACTION
														--
														END
												--
												END
												ELSE IF @PA_ACTION = 'EDT'  or @l_action ='E'
												BEGIN
												--

														BEGIN TRANSACTION
 
              IF @pa_values = '0'
														BEGIN
														--
																	UPDATE dptd_mak 
																SET    dptd_deleted_ind = 2
																					, dptd_lst_upd_dt  = getdate()
																					, dptd_lst_upd_by  = @pa_login_name
																WHERE  dptd_dtls_id  = CONVERT(INT,@currstring)
                                                                --DELETE FROM dptd_mak WHERE  dptd_dtls_id  = CONVERT(INT,@currstring)

														--
														END
														ELSE
														BEGIN
														--
														  IF @l_id <> ''
																BEGIN
														  --
														    UPDATE dptd_mak 
																  SET    dptd_deleted_ind = 2
																  					, dptd_lst_upd_dt  = getdate()
																  					, dptd_lst_upd_by  = @pa_login_name
																  WHERE  dptd_id          = @l_id
																--
																END  
														--
              END
              
              IF EXISTS(select * from dp_trx_dtls where dptd_dtls_id = CONVERT(INT,@currstring) and dptd_deleted_ind = 1)
														BEGIN
														--
																SET @l_deleted_ind = 6
																
																if @PA_VALUES ='0'
																BEGIN
																--
																  INSERT INTO DPTD_MAK
																		(dptd_id
																		,dptd_dtls_id
																		,dptd_dpam_id
																		,dptd_request_dt
																		,dptd_execution_dt
																		,dptd_slip_no
																		,dptd_isin
																		,dptd_line_no
																		,dptd_qty
																		,dptd_trastm_cd
																		,dptd_mkt_type
																		,dptd_settlement_no
																		,dptd_other_settlement_type
																		,dptd_other_settlement_no
																		,dptd_status
		                ,dptd_internal_trastm 
		                ,dptd_rmks  
																		,dptd_created_by
																		,dptd_created_dt
																		,dptd_lst_upd_by
																		,dptd_lst_upd_dt
																		,dptd_deleted_ind 
																		)
																	 SELECT dptd_id
																		,dptd_dtls_id
																		,dptd_dpam_id
																		,dptd_request_dt
																		,dptd_execution_dt
																		,@pa_slip_no
																		,dptd_isin
																		,dptd_line_no
																		,dptd_qty
																		,dptd_trastm_cd
																	 ,@pa_mkt_type
																		,@pa_settlm_no
																		,@pa_tr_setm_type
														    ,@pa_tr_setm_no
														    ,'P'
                  ,@l_trastm_desc
                  ,@pa_rmks
																		,dptd_created_by
																		,dptd_created_dt
																		,dptd_lst_upd_by
																		,dptd_lst_upd_dt
																		,dptd_deleted_ind 
                  FROM  dp_trx_dtls
																		WHERE dptd_dtls_id       =  CONVERT(INT,@currstring)
																		AND   dptd_deleted_ind   =  1 
																--
																END
																ELSE
																BEGIN
																--
																  IF @l_action = 'A'
																		BEGIN
																		--
																				--select @l_id = ISNULL(MAX(dptd_id),0) + 1 FROM dptd_mak
 set @l_id = @l_dptd_id + 1																				
                    set @l_dptd_id = @l_dptd_id + 1				
																				set  @l_deleted_ind = 0
																		--
																  END
																  
																  INSERT INTO DPTD_MAK
																		(dptd_id
																		,dptd_dtls_id
																		,dptd_dpam_id
																		,dptd_request_dt
																		,dptd_execution_dt
																		,dptd_slip_no
																		,dptd_isin
																		,dptd_line_no
																		,dptd_qty
																		,dptd_trastm_cd
																		,dptd_mkt_type
																		,dptd_settlement_no
																		,dptd_other_settlement_type
																		,dptd_other_settlement_no
																			,dptd_status
		                ,dptd_internal_trastm
		                ,dptd_rmks
																		,dptd_created_by
																		,dptd_created_dt
																		,dptd_lst_upd_by
																		,dptd_lst_upd_dt
																		,dptd_deleted_ind 
																		)VALUES 
																		(convert(int,@l_id )
																		,CONVERT(INT,@currstring)
																		,@l_dpam_id
																 	,convert(datetime,@pa_req_dt,103)
																		,convert(datetime,@pa_exe_dt,103)
																		,@pa_slip_no
																		,@l_isin
																		,@line_no
																		,@l_qty
																		,@l_trastm_id
																		,@pa_mkt_type
																		,@pa_settlm_no
																		,@pa_tr_setm_type
																		,@pa_tr_setm_no
																		,'P'
                  ,@l_trastm_desc
                  ,@pa_rmks
                  ,@pa_login_name
																		,getdate()
																		,@pa_login_name
																		,getdate()
																		,@l_deleted_ind
                  )
																  
																--
																END
														--
														END
														ELSE
														BEGIN
														--
																SET @l_deleted_ind = 0
																
																IF @pa_values = '0' 
																BEGIN
																--
																  INSERT INTO DPTD_MAK
																		(dptd_id
																		,dptd_dtls_id
																		,dptd_dpam_id
																		,dptd_request_dt
																		,dptd_execution_dt
																		,dptd_slip_no
																		,dptd_isin
																		,dptd_line_no
																		,dptd_qty
																		,dptd_trastm_cd
																		,dptd_mkt_type
																		,dptd_settlement_no
																		,dptd_other_settlement_type
																		,dptd_other_settlement_no
																		,dptd_status
		                ,dptd_internal_trastm
		                ,dptd_rmks
																		,dptd_created_by
																		,dptd_created_dt
																		,dptd_lst_upd_by
																		,dptd_lst_upd_dt
																		,dptd_deleted_ind 
																		)
																	 SELECT dptd_id
																		,dptd_dtls_id
																		,dptd_dpam_id
																	 ,convert(datetime,@pa_req_dt,103)
																		,convert(datetime,@pa_exe_dt,103)
																		,@pa_slip_no
																		,dptd_isin
																		,dptd_line_no
																		,dptd_qty
																		,dptd_trastm_cd
																	 ,@pa_mkt_type
																		,@pa_settlm_no
																		,@pa_tr_setm_type
														    ,@pa_tr_setm_no
														    ,'P'
                  ,@l_trastm_desc
                  ,@pa_rmks
																		,dptd_created_by
																		,dptd_created_dt
																		,dptd_lst_upd_by
																		,dptd_lst_upd_dt
																		,dptd_deleted_ind 
                  FROM  #dptd_mak
																		WHERE dptd_dtls_id       =  CONVERT(INT,@currstring)
																		AND   dptd_deleted_ind   in (0,-1)
																		
																--
																END
																ELSE
																BEGIN
																--
																  IF @l_action = 'A'
																		BEGIN
																		--
																				--select @l_id = ISNULL(MAX(dptd_id),0) + 1 FROM dptd_mak
                    set @l_id = @l_dptd_id + 1																				
                    set @l_dptd_id = @l_dptd_id + 1				
																		--
																		END
																		
																		IF @l_action <> 'D'
																		BEGIN
																  --
																     INSERT INTO DPTD_MAK
																					(dptd_id
																					,dptd_dtls_id
																					,dptd_dpam_id
																					,dptd_request_dt
																					,dptd_execution_dt
																					,dptd_slip_no
																					,dptd_isin
																					,dptd_line_no
																					,dptd_qty
																					,dptd_trastm_cd
																					,dptd_mkt_type
																					,dptd_settlement_no
																					,dptd_other_settlement_type
																					,dptd_other_settlement_no
																						,dptd_status
		                   ,dptd_internal_trastm
		                   ,dptd_rmks
																					,dptd_created_by
																					,dptd_created_dt
																					,dptd_lst_upd_by
																					,dptd_lst_upd_dt
																					,dptd_deleted_ind 
																					)VALUES 
																					(CONVERT(INT,@l_id)
																				 ,CONVERT(INT,@currstring)
																					,@l_dpam_id
																				 ,convert(datetime,@pa_req_dt,103)
																					,convert(datetime,@pa_exe_dt,103)
																					,@pa_slip_no
																					,@l_isin
																					,@line_no
																					,@l_qty
																					,@l_trastm_id
																					,@pa_mkt_type
																					,@pa_settlm_no
																					,@pa_tr_setm_type
																					,@pa_tr_setm_no
																					,'P'
                     ,@l_trastm_desc
                     ,@pa_rmks
																					,@pa_login_name
																					,getdate()
																					,@pa_login_name
																					,getdate()
																					,case when @l_high_val_yn = 'Y' then -1 else 0 end 
                     )
																  --
																  END
																--
																END
														--
														END
														
              
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
												ELSE IF @PA_ACTION = 'DEL'  or @l_action = 'D' 
												BEGIN
												--
              
              
														IF exists(SELECT * FROM dptd_mak WHERE dptd_dtls_id = convert(numeric,@currstring) and dptd_deleted_ind in (0,-1))
														BEGIN
														--
														  if @l_action = 'D' 
																BEGIN
																--
																		DELETE FROM dptd_mak
																		WHERE  dptd_deleted_ind = 0
																		AND    dptd_id          = convert(numeric,@l_id)
																--
																END
																ELSE
																BEGIN
																--

																	DELETE USES 
																	FROM USED_SLIP uses , dptd_mak , DP_ACCT_MSTR 
																	WHERE DPTD_DPAM_ID = DPAM_ID AND DPAM_SBA_NO =  USES_DPAM_ACCT_NO and isnumeric(REPLACE(DPTD_SLIP_NO,USES_SERIES_TYPE,'')) =1  
																	AND USES_SERIES_TYPE + REPLACE(DPTD_SLIP_NO,USES_SERIES_TYPE,'')   = USES_SERIES_TYPE + USES_SLIP_NO
																	AND    dptd_dtls_id          = convert(numeric,@currstring)
																	and left(dptd_trastm_Cd,3) = left(uses_trantm_id,3)



																		DELETE FROM dptd_mak
																		WHERE  dptd_deleted_ind in (0,-1)
																		AND    dptd_dtls_id          = convert(numeric,@currstring)
																--
																END
             	--
														END
														ELSE
														BEGIN
														--
														  begin transaction
														  if @l_action = 'D' 
														  BEGIN
														  --
														  
																		INSERT INTO DPTD_MAK
																		(dptd_id
																		,dptd_dtls_id
																		,dptd_dpam_id
																		,dptd_request_dt
																		,dptd_execution_dt
																		,dptd_slip_no
																		,dptd_isin
																		,dptd_line_no
																		,dptd_qty
																		,dptd_trastm_cd
																		,dptd_mkt_type
																		,dptd_settlement_no
																		,dptd_other_settlement_type
																		,dptd_other_settlement_no
																		,dptd_status
																		,dptd_internal_trastm
																		,dptd_rmks
																		,dptd_created_by
																		,dptd_created_dt
																		,dptd_lst_upd_by
																		,dptd_lst_upd_dt
																		,dptd_deleted_ind)
																		SELECT 
																			dptd_id 
																		,dptd_dtls_id
																		,dptd_dpam_id
																		,dptd_request_dt
																		,dptd_execution_dt
																		,dptd_slip_no
																		,dptd_isin
																		,dptd_line_no
																		,dptd_qty
																		,dptd_trastm_cd
																		,dptd_mkt_type
																		,dptd_settlement_no
																		,dptd_other_settlement_type
																		,dptd_other_settlement_no
																		,dptd_status
																		,@l_trastm_desc
																		,dptd_rmks
																		,dptd_created_by
																		,dptd_created_dt
																		,dptd_lst_upd_by
																		,dptd_lst_upd_dt
																		,4
																		FROM DP_TRX_DTLS
																		WHERE dptd_deleted_ind = 1 
																		AND   dptd_dtls_id          = convert(numeric,@currstring)
																		AND   dptd_id               = convert(numeric,@l_id)
																		
																--
																END
																ELSE
																BEGIN
																--
																  INSERT INTO DPTD_MAK
																		(dptd_id
																		,dptd_dtls_id
																		,dptd_dpam_id
																		,dptd_request_dt
																		,dptd_execution_dt
																		,dptd_slip_no
																		,dptd_isin
																		,dptd_line_no
																		,dptd_qty
																		,dptd_trastm_cd
																		,dptd_mkt_type
																		,dptd_settlement_no
																		,dptd_other_settlement_type
																		,dptd_other_settlement_no
																		,dptd_status
																		,dptd_internal_trastm
																		,dptd_rmks
																		,dptd_created_by
																		,dptd_created_dt
																		,dptd_lst_upd_by
																		,dptd_lst_upd_dt
																		,dptd_deleted_ind)
																		SELECT 
																			dptd_id 
																		,dptd_dtls_id
																		,dptd_dpam_id
																		,dptd_request_dt
																		,dptd_execution_dt
																		,dptd_slip_no
																		,dptd_isin
																		,dptd_line_no
																		,dptd_qty
																		,dptd_trastm_cd
																		,dptd_mkt_type
																		,dptd_settlement_no
																		,dptd_other_settlement_type
																		,dptd_other_settlement_no
																		,dptd_status
																		,@l_trastm_desc
																		,dptd_rmks
																		,dptd_created_by
																		,dptd_created_dt
																		,dptd_lst_upd_by
																		,dptd_lst_upd_dt
																		,4
																		FROM DP_TRX_DTLS
																		WHERE dptd_deleted_ind = 1 
																		AND   dptd_DTLS_id          = convert(numeric,@currstring)
																--
																END
														  
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
												ELSE IF @PA_ACTION = 'APP'
												BEGIN
												--
              SET @@c_access_cursor =  CURSOR fast_forward FOR      
														SELECT dptd_id, dptd_deleted_ind  FROM dptd_mak where dptd_dtls_id = convert(numeric,@currstring) and dptd_deleted_ind in (0,4,6,-1)
														--      
														OPEN @@c_access_cursor      
														FETCH NEXT FROM @@c_access_cursor INTO @c_dptd_id, @c_deleted_ind 
														--      
														WHILE @@fetch_status = 0      
														BEGIN      
														--   
														
																BEGIN TRANSACTION

																IF EXISTS(select * from dptd_mak  where dptd_id = convert(numeric,@c_dptd_id) and dptd_deleted_ind = 6)
																BEGIN
																--


																		UPDATE  dp_trx_dtls 
																		SET     dptd_dpam_id              = dptdm.dptd_dpam_id              
																									,dptd_request_dt           = dptdm.dptd_request_dt           
																									,dptd_execution_dt         = dptdm.dptd_execution_dt         
																									,dptd_slip_no              = dptdm.dptd_slip_no              
																									,dptd_isin                 = dptdm.dptd_isin                 
																									,dptd_qty                  = dptdm.dptd_qty                  
																									,dptd_mkt_type             = dptdm.dptd_mkt_type             
																									,dptd_settlement_no        = dptdm.dptd_settlement_no        
																									,dptd_other_settlement_type= dptdm.dptd_other_settlement_type
																									,dptd_other_settlement_no  = dptdm.dptd_other_settlement_no 
																									,dptd_rmks																	=	dptdm.dptd_rmks	
																									,dptd_lst_upd_dt           = getdate()
																									,dptd_lst_upd_by           = @pa_login_name
																		FROM    dptd_mak                    dptdm						
																		       ,dptd_mak                    dptd	
																		WHERE   dptdm.dptd_id        = convert(numeric,@c_dptd_id) 
																		AND     dptdm.dptd_dtls_id   = dptd.dptd_dtls_id  
																		AND     dptdm.dptd_deleted_ind          = 6



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
																				UPDATE dptd_mak 
																				SET    dptd_deleted_ind = 7
																									, dptd_lst_upd_dt  = getdate()
																									, dptd_lst_upd_by  = @pa_login_name
																				WHERE  dptd_id     = convert(numeric,@c_dptd_id)
																				AND    dptd_deleted_ind = 6

																				COMMIT TRANSACTION
																		--
																		END
																--
																END
																ELSE IF exists(select * from dptd_mak  where dptd_dtls_id = convert(numeric,@currstring) and dptd_deleted_ind in (0,-1))
																BEGIN
																--

																		INSERT INTO DP_TRX_DTLS
																		(dptd_id
																		,dptd_dtls_id
																		,dptd_dpam_id
																		,dptd_request_dt
																		,dptd_execution_dt
																		,dptd_slip_no
																		,dptd_isin
																		,dptd_line_no
																		,dptd_qty
																		,dptd_trastm_cd
																		,dptd_mkt_type
																		,dptd_settlement_no
																		,dptd_other_settlement_type
																		,dptd_other_settlement_no
																			,dptd_status
		                ,dptd_internal_trastm
		                ,dptd_rmks
																		,dptd_created_by
																		,dptd_created_dt
																		,dptd_lst_upd_by
																		,dptd_lst_upd_dt
																		,dptd_deleted_ind)
																		SELECT 
																			dptd_id 
																		,dptd_dtls_id
																		,dptd_dpam_id
																		,dptd_request_dt
																		,dptd_execution_dt
																		,dptd_slip_no
																		,dptd_isin
																		,dptd_line_no
																		,dptd_qty
																		,dptd_trastm_cd
																		,dptd_mkt_type
																		,dptd_settlement_no
																		,dptd_other_settlement_type
																		,dptd_other_settlement_no
																		,dptd_status
                  ,@l_trastm_desc
                  ,dptd_rmks
																		,dptd_created_by
																		,dptd_created_dt
																		,dptd_lst_upd_by
																		,dptd_lst_upd_dt
																		,1
																		FROM  DPTD_MAK
																		WHERE dptd_deleted_ind = 0
																		AND   dptd_id     = convert(numeric,@c_dptd_id)

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

																				if exists(select dptd_id from dptd_mak where dptd_id = convert(numeric,@c_dptd_id) AND dptd_deleted_ind = 0 )
																				begin
																				--
																						UPDATE dptd_mak     
																						SET    dptd_deleted_ind = 1    
																											, dptd_lst_upd_dt  = getdate()    
																											, dptd_lst_upd_by  = @pa_login_name    
																						WHERE  dptd_id          = convert(numeric,@c_dptd_id)    
																						AND    dptd_deleted_ind = 0    
																				--
																				end
																				else
																				begin
																				--
																						UPDATE dptd_mak     
																						SET    dptd_deleted_ind = 0    
																											, dptd_lst_upd_dt  = getdate()    
																											, dptd_mid_chk  = @pa_login_name    
																						WHERE  dptd_id          = convert(numeric,@c_dptd_id)    
																						AND    dptd_deleted_ind = -1 
																				--
                     end

																				COMMIT TRANSACTION
																		--
																		END
																--
																END
																ELSE 
																BEGIN
																--

 DELETE USES 
                                                                        FROM USED_SLIP uses, DP_TRX_DTLS , DP_ACCT_MSTR 
                                                                        WHERE DPTD_DPAM_ID = DPAM_ID AND DPAM_SBA_NO =  USES_DPAM_ACCT_NO and isnumeric(REPLACE(DPTD_SLIP_NO,USES_SERIES_TYPE,'')) =1  
																		AND USES_SERIES_TYPE + REPLACE(DPTD_SLIP_NO,USES_SERIES_TYPE,'')   = USES_SERIES_TYPE + USES_SLIP_NO
                                                                        AND    dptd_id          =  convert(numeric,@c_dptd_id)
																		and left(dptd_trastm_Cd,3) = left(uses_trantm_id,3)


																		UPDATE dp_trx_dtls
																		SET    dptd_deleted_ind = 0
																							, dptd_lst_upd_dt  = getdate()
																							, dptd_lst_upd_by  = @pa_login_name
																		WHERE  dptd_id     = convert(numeric,@c_dptd_id)
																		AND    dptd_deleted_ind = 1

																		UPDATE dptd_mak 
																		SET    dptd_deleted_ind = 5
																							, dptd_lst_upd_dt  = getdate()
																							, dptd_lst_upd_by  = @pa_login_name
																		WHERE  dptd_id     = convert(numeric,@c_dptd_id)
																		AND    dptd_deleted_ind = 4

																		COMMIT TRANSACTION
																--
																END
																FETCH NEXT FROM @@c_access_cursor INTO @c_dptd_id, @c_deleted_ind     
																--      
																END      
																												
														CLOSE      @@c_access_cursor      
												  DEALLOCATE @@c_access_cursor   
												--
												END
												ELSE IF @PA_ACTION = 'REJ'
												BEGIN
												--

														BEGIN TRANSACTION

               UPDATE dptd_mak 
															SET    dptd_deleted_ind = 3
																				, dptd_lst_upd_dt  = getdate()
																				, dptd_lst_upd_by  = @pa_login_name
															WHERE  dptd_dtls_id     = convert(numeric,@currstring)
															AND    dptd_deleted_ind in (0,4,6,-1)

   DELETE USES 
                                                                        FROM USED_SLIP uses , DPTD_MAK , DP_ACCT_MSTR 
                                                                        WHERE DPTD_DPAM_ID = DPAM_ID AND DPAM_SBA_NO =  USES_DPAM_ACCT_NO and isnumeric(REPLACE(DPTD_SLIP_NO,USES_SERIES_TYPE,'')) =1  
                                                                        AND USES_SERIES_TYPE + REPLACE(DPTD_SLIP_NO,USES_SERIES_TYPE,'')   = USES_SERIES_TYPE + USES_SLIP_NO
                                                                        AND dptd_dtls_id     = convert(numeric,@currstring)
																		and left(dptd_trastm_Cd,3) = left(uses_trantm_id,3)



															
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
												END
										--
										END
								--		
        END  
						--
						END
						
				--
				END
		--
		END
  SET @pa_errmsg = @t_errorstr
  IF left(ltrim(rtrim(@pa_errmsg)),5) <> 'ERROR'
		BEGIN
  --

    exec pr_checkslipno '','INTERSETM_TRX_SEL', @pa_dpm_dpid,@l_dpam_acct_no,@pa_slip_no,@pa_login_name,''
  --
  END
--
END

GO
