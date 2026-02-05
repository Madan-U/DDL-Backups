-- Object: PROCEDURE citrus_usr.pr_ins_dp_charge
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

/*
DPC_ID
DPC_DPM_ID
DPC_PROFILE_ID
DPC_EFF_FROM_DT
DPC_EFF_TO_DT
DPC_CREATED_BY
DPC_CREATED_DT
DPC_LST_UPD_BY
DPC_LST_UPD_DT
DPC_DELETED_IND
*/
create PROCEDURE [citrus_usr].[pr_ins_dp_charge](@pa_id               VARCHAR(8000)  
																																	,@pa_action          VARCHAR(20)  
																																	,@pa_login_name      VARCHAR(20)  
																																	,@pa_dpm_id          VARCHAR(10)
																																	,@pa_profile_id      NUMERIC   
																																	,@pa_eff_from_dt     VARCHAR(11)
																																	--,@pa_eff_to_dt       VARCHAR(11)
																																	,@pa_postedtoacct    NUMERIC
																																	,@pa_chk_yn          INT  
																																	,@rowdelimiter       CHAR(4)       = '*|~*'  
																																	,@coldelimiter       CHAR(4)       = '|*~|'  
																																	,@pa_errmsg          VARCHAR(8000) output 
																																	)
AS
/*
*********************************************************************************
 SYSTEM         : dp
 MODULE NAME    : pr_ins_dp_charge
 DESCRIPTION    : this procedure will contain the maker checker facility for dp charge
 COPYRIGHT(C)   : marketplace technologies 
 VERSION HISTORY: 1.0
 VERS.  AUTHOR            DATE          REASON
 -----  -------------     ------------  --------------------------------------------------
 1.0    TUSHAR            19-JAN-2008   VERSION.
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
								, @delimeter_value varchar(10)
								, @delimeterlength_value varchar(10)
								, @remainingstring_value varchar(8000)
								, @currstring_value varchar(8000)
								, @L_DPC_ID         numeric(10,0)  
								, @l_excsm_id       numeric(10,0)
								, @l_dpm_id         numeric(10,0)
								, @l_holding_date   datetime
								, @l_eff_from_date  datetime
  SET @pa_errmsg = @t_errorstr
  
  
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
				    IF @PA_CHK_YN = 0
				    BEGIN
				    --
				      IF @PA_ACTION = 'INS'
				      BEGIN
				      --
				        SELECT @L_DPC_ID   = ISNULL(MAX(DPC_ID),0) + 1 FROM dp_charges_mstr
				        
				        --SELECT top 1 @l_excsm_id = excsm_id from exch_seg_mstr  where excsm_exch_cd = @pa_excsm_cd order by 1 
				        SELECT @l_dpm_id = dpm_id from dp_mstr where dpm_dpid = @pa_dpm_id  and dpm_deleted_ind = 1 
				        
				        
				        
				        BEGIN TRANSACTION
				        
				        INSERT INTO dp_charges_mstr
				        (dpc_id
												,dpc_dpm_id
												,dpc_profile_id
												,dpc_eff_from_dt
												,dpc_eff_to_dt
												,dpc_post_toacct
												,dpc_created_by
												,dpc_created_dt
												,dpc_lst_upd_by
												,dpc_lst_upd_dt
												,dpc_deleted_ind
				        )
				        values
				        (@l_dpc_id
				        ,@l_dpm_id 
				        ,@pa_profile_id
				        ,convert(datetime,@pa_eff_from_dt,103)
				        ,convert(datetime,'01/01/2100',103)
				        ,@pa_postedtoacct
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
												--
												END
				      --
				      END
				      IF @PA_ACTION = 'DEL'
										BEGIN
										--
										  IF left(@pa_dpm_id,2) ='IN' 
										  BEGIN
										  --
												  SELECT top 1 @l_holding_date = nsdhmd_transaction_dt from nsdl_holding_dtls_daily 
												--
												END
												ELSE 
												BEGIN
												--
												  SELECT top 1 @l_holding_date = cdshmd_tras_dt from tmp_cdsl_holding_dtls 
												--
												END
												
												SELECT @l_eff_from_date = dpc_eff_from_dt from dp_charges_mstr where dpc_id = @pa_id
												
												
												
												
												
												IF @l_holding_date < @l_eff_from_date
												BEGIN
												--
												  SET @t_errorstr = 'ERROR '+' : Can not process'
												--
												END
												ELSE
												BEGIN
												--
												  UPDATE dp_charges_mstr
												  SET    dpc_deleted_ind = 0
												       , dpc_lst_upd_dt  = getdate()
												       , dpc_lst_upd_by  = @pa_login_name
												  WHERE  dpc_id          = @pa_id
												--
												END

												
										--
				      END
				    --
				    END
				    IF @PA_CHK_YN = 1
								BEGIN
								--
								  PRINT '1'
								--
				    END
				    
				  --
				  END
				--
				END
  
--
END

GO
