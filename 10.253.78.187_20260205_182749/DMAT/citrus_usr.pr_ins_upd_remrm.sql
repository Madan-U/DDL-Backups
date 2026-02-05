-- Object: PROCEDURE citrus_usr.pr_ins_upd_remrm
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

/*
REMRM_ID
REMRM_DPAM_ID
REMRM_RRF_NO
REMRM_SLIP_SERIAL_NO
REMRM_REQUEST_DT
REMRM_EXECUTION_DT
REMRM_RESPONSE_DT
REMRM_LOT_TYPE
REMRM_QTY
REMRM_FREE_LOCKEDIN_YN
REMRM_LOCKIN_REASON_CD
REMRM_LOCKIN_REASON_DT
REMRM_CONVERTED_QTY
REMRM_STATUS
REMRM_REJECTION_CD
REMRM_RMKS
REMRM_CERTIFICATE_NO
REMRM_CREATED_BY
REMRM_CREATED_DT
REMRM_LST_UPD_BY
REMRM_LST_UPD_DT
REMRM_DELETED_IND
REMRM_ISIN
*/
CREATE PROCEDURE [citrus_usr].[pr_ins_upd_remrm](@pa_id             VARCHAR(8000)  
												,@pa_action          VARCHAR(20)  
												,@pa_login_name      VARCHAR(20)  
												,@pa_dpm_dpid        VARCHAR(50)
												,@pa_dpam_acct_no    VARCHAR(50)
												,@pa_slip_sr_no 	    VARCHAR(20) 
												,@pa_request_dt 	    VARCHAR(11) 
												,@pa_lot_type        VARCHAR(1)
												,@pa_qty             VARCHAR(20)
												,@pa_fr_lockedin_yn  CHAR(1)
												,@PA_INTERNAL_REJ   VARCHAR(10)
												,@PA_COMPANY_OBJ    VARCHAR(10)
												,@PA_CREDIT_RECD    VARCHAR(5)
												,@pa_lockin_rsn_cd   VARCHAR(20)
												,@pa_lockin_rsn_dt   VARCHAR(11)
												,@pa_lockin_qty     VARCHAR(20)
												,@pa_rmks            VARCHAR(200) 
												,@pa_isin            VARCHAR(20)
												,@pa_noof_certificate     numeric                 
            ,@PA_REPURCHASE_FLG  CHAR(1)
												,@pa_chk_yn          INT  
												,@rowdelimiter       CHAR(4)       = '*|~*'  
												,@coldelimiter       CHAR(4)       = '|*~|'  
												,@pa_errmsg          VARCHAR(8000) output  
)  
AS
/*
*********************************************************************************
 SYSTEM         : dp
 MODULE NAME    : pr_ins_upd_remrm
 DESCRIPTION    : this procedure will contain the maker checker facility for remat request mstr 
 COPYRIGHT(C)   : marketplace technologies 
 VERSION HISTORY: 1.0
 VERS.  AUTHOR            DATE          REASON
 -----  -------------     ------------  --------------------------------------------------
 1.0    TUSHAR            03-DEC-2007   VERSION.
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
      , @l_remrm_id      NUMERIC
      , @l_remrmm_id     NUMERIC
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
				  IF @pa_chk_yn = 0
				  BEGIN
				  --
				    SELECT @l_dpam_id     = dpam_id FROM dp_acct_mstr, dp_mstr WHERE dpm_deleted_ind = 1   and dpm_id = dpam_dpm_id and dpm_dpid = @pa_dpm_dpid and dpam_sba_no = @pa_dpam_acct_no
				     
				    IF @PA_ACTION = 'INS'
				    BEGIN
				    --
										BEGIN TRANSACTION
											
				      SELECT @l_remrm_id   = ISNULL(MAX(remrm_id),0) + 1 FROM remat_request_mstr WHERE remrm_deleted_ind = 1  
				      
				      
				      
				      INSERT INTO remat_request_mstr
				      (remrm_id
										,remrm_dpam_id
										,remrm_isin
										,remrm_slip_serial_no
										,remrm_request_dt
										,remrm_lot_type
										,remrm_qty
										,remrm_rrf_no
										,remrm_free_lockedin_yn
										,REMRM_INTERNAL_REJ
									    ,REMRM_COMPANY_OBJ
										,REMRM_CREDIT_RECD       
										,remrm_lockin_reason_cd
										,remrm_lockin_reason_dt
										,remrm_lockin_qty
										,remrm_rmks
										,remrm_certificate_no
										,remrm_created_by
										,remrm_created_dt
										,remrm_lst_upd_by
										,remrm_lst_upd_dt
										,remrm_deleted_ind , REMRM_REPURCHASE_FLG  
				      )VALUES
				      (@l_remrm_id 
				      ,@l_dpam_id 
									 ,@pa_isin
										,@pa_slip_sr_no 	    
										,convert(datetime,@pa_request_dt,103) 	    
										,@pa_lot_type        
										,convert(numeric(18,3),@pa_qty)
										,@l_remrm_id 
										,@pa_fr_lockedin_yn  
										,@PA_INTERNAL_REJ
										,@PA_COMPANY_OBJ
										,@PA_CREDIT_RECD  
										,@pa_lockin_rsn_cd   
										,convert(datetime,@pa_lockin_rsn_dt,103)   
										,ISNULL(convert(numeric,@pa_lockin_qty)  ,0) 
										,@pa_rmks  
										,ISNULL(@pa_noof_certificate,0)          
										,@pa_login_name
										,getdate()
										,@pa_login_name
										,getdate()
										,1, @PA_REPURCHASE_FLG  
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
				    ELSE IF @PA_ACTION = 'EDT'
				    BEGIN
				    --
				      BEGIN TRANSACTION
				    
				      UPDATE remat_request_mstr
				      SET    remrm_dpam_id             = @l_dpam_id
									,remrm_isin                = @pa_isin 
									,remrm_slip_serial_no      = @pa_slip_sr_no 
									,remrm_request_dt          = convert(datetime,@pa_request_dt,103) 
									,remrm_lot_type            = @pa_lot_type
									,remrm_qty                 = convert(numeric(18,3),@pa_qty)
									,remrm_free_lockedin_yn    = @pa_fr_lockedin_yn
									,REMRM_INTERNAL_REJ = @PA_INTERNAL_REJ 
									,REMRM_COMPANY_OBJ = @PA_COMPANY_OBJ
									,REMRM_CREDIT_RECD = @PA_CREDIT_RECD 
									,remrm_lockin_reason_cd    = @pa_lockin_rsn_cd  
									,remrm_lockin_reason_dt    = convert(datetime,@pa_lockin_rsn_dt,103) 
									,remrm_lockin_qty       = ISNULL(convert(numeric,@pa_lockin_qty)  ,0)
									,remrm_rmks                = @pa_rmks 
									,remrm_certificate_no = ISNULL(@pa_noof_certificate,0)  
																,REMRM_REPURCHASE_FLG   = @PA_REPURCHASE_FLG  
										WHERE  remrm_id            = CONVERT(INT,@currstring)					
										AND    remrm_deleted_ind   = 1
										
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
				    ELSE IF @PA_ACTION = 'DEL'
								BEGIN
								--
								  BEGIN TRANSACTION
								  
								  UPDATE remat_request_mstr
										SET    remrm_deleted_ind   = 0
										      ,remrm_lst_upd_dt    = getdate()
										      ,remrm_lst_upd_by    = @pa_login_name 
										WHERE  remrm_id            = CONVERT(INT,@currstring)					
										AND    remrm_deleted_ind   = 1
										
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
				    SELECT @l_dpam_id     = dpam_id FROM dp_acct_mstr, dp_mstr WHERE dpm_deleted_ind = 1   and dpm_id = dpam_dpm_id and dpm_dpid = @pa_dpm_dpid and dpam_sba_no = @pa_dpam_acct_no
				    
				    IF @PA_ACTION = 'INS'
					BEGIN
				    --
				      BEGIN TRANSACTION
																  
										SELECT @l_remrm_id = ISNULL(MAX(remrm_id),0)+1
										FROM remat_request_mstr WITH (NOLOCK)
										--
										SELECT @L_remrmm_id = ISNULL(MAX(remrm_id),0)+1
										FROM remrm_mak WITH (NOLOCK)


										

										IF @l_remrmm_id > @l_remrm_id
										BEGIN
										--
												SET  @l_remrm_id = @l_remrmm_id
										--
                                        END
          
          INSERT INTO remrm_mak 
										(remrm_id
										,remrm_dpam_id
										,remrm_isin
										,remrm_slip_serial_no
										,remrm_request_dt
										,remrm_lot_type
										,remrm_rrf_no 
										,remrm_qty
										,remrm_free_lockedin_yn
									    ,REMRM_INTERNAL_REJ 
                                        ,REMRM_COMPANY_OBJ 
										,REMRM_CREDIT_RECD 
										,remrm_lockin_reason_cd
										,remrm_lockin_reason_dt
										,remrm_lockin_qty
										,remrm_rmks
										,remrm_certificate_no
										,remrm_created_by
										,remrm_created_dt
										,remrm_lst_upd_by
										,remrm_lst_upd_dt
										,remrm_deleted_ind,REMRM_REPURCHASE_FLG  
										)VALUES
										(@l_remrm_id 
										,@l_dpam_id 
										,@pa_isin
										,@pa_slip_sr_no 	    
										,convert(datetime,@pa_request_dt,103) 	    
										,@pa_lot_type        
										,@l_remrm_id  
										,convert(numeric(18,3),@pa_qty)
										,@pa_fr_lockedin_yn  
										,@PA_INTERNAL_REJ 
										,@PA_COMPANY_OBJ
										,@PA_CREDIT_RECD 
										,@pa_lockin_rsn_cd   
										,convert(datetime,@pa_lockin_rsn_dt,103)   
										,ISNULL(convert(numeric,@pa_lockin_qty)  ,0)
										,@pa_rmks 
										,ISNULL(@pa_noof_certificate,0)           
										,@pa_login_name
										,getdate()
										,@pa_login_name
										,getdate()
										,0 , @PA_REPURCHASE_FLG  
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
				    ELSE IF @PA_ACTION = 'EDT'
								BEGIN
				    --
				    
				      BEGIN TRANSACTION
				      
				      UPDATE remrm_mak
										SET    remrm_deleted_ind  = 2
															, remrm_lst_upd_dt   = getdate()
															, remrm_lst_upd_by   = @pa_login_name
										WHERE  remrm_id           = convert(numeric,@currstring)
										AND    remrm_deleted_ind  = 0
				    
				      IF EXISTS(select * from remat_request_mstr where remrm_id = CONVERT(INT,@currstring) and remrm_deleted_ind = 1)
										BEGIN
										--
												SET @l_deleted_ind = 6
										--
										END
										ELSE
										BEGIN
										--
												SET @l_deleted_ind = 0
										--
								  END
								  
								  INSERT INTO remrm_mak 
										(remrm_id
										,remrm_dpam_id
										,remrm_isin
										,remrm_slip_serial_no
										,remrm_request_dt
										,remrm_lot_type
										,remrm_rrf_no 
										,remrm_qty
										,remrm_free_lockedin_yn
										,REMRM_INTERNAL_REJ 
										,REMRM_COMPANY_OBJ 
										,REMRM_CREDIT_RECD 
										,remrm_lockin_reason_cd
										,remrm_lockin_reason_dt
										,remrm_lockin_qty
										,remrm_rmks
										,remrm_certificate_no
										,remrm_created_by
										,remrm_created_dt
										,remrm_lst_upd_by
										,remrm_lst_upd_dt
										,remrm_deleted_ind, REMRM_REPURCHASE_FLG  
										)VALUES
										(CONVERT(INT,@currstring)
										,@l_dpam_id 
										,@pa_isin
										,@pa_slip_sr_no 	    
										,convert(datetime,@pa_request_dt,103) 	    
										,@pa_lot_type   
										,CONVERT(INT,@currstring) 
										,convert(numeric(18,3),@pa_qty)
										,@pa_fr_lockedin_yn 
										,@PA_INTERNAL_REJ 
										,@PA_COMPANY_OBJ
										,@PA_CREDIT_RECD  
										,@pa_lockin_rsn_cd   
										,convert(datetime,@pa_lockin_rsn_dt,103)   
										,ISNULL(convert(numeric,@pa_lockin_qty)  ,0)
										,@pa_rmks  
										,ISNULL(@pa_noof_certificate,0)          
										,@pa_login_name
										,getdate()
										,@pa_login_name
										,getdate()
										,@l_deleted_ind,@PA_REPURCHASE_FLG  
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
				    ELSE IF @PA_ACTION = 'DEL'
								BEGIN
				    --
				      
				      IF exists(SELECT * FROM remrm_mak WHERE remrm_id = convert(numeric,@currstring) and remrm_deleted_ind in(0,4))
										BEGIN
										--
												DELETE FROM remrm_mak
												WHERE remrm_id = convert(numeric,@currstring)
												AND   remrm_deleted_ind = 0
										--
										END
										ELSE
										BEGIN
										--
												INSERT INTO remrm_mak 
												(remrm_id
												,remrm_dpam_id
												,remrm_isin
												,remrm_slip_serial_no
												,remrm_request_dt
												,remrm_lot_type
												,remrm_qty
												,remrm_free_lockedin_yn
												,REMRM_INTERNAL_REJ 
												,REMRM_COMPANY_OBJ 
												,REMRM_CREDIT_RECD 
												,remrm_lockin_reason_cd
												,remrm_lockin_reason_dt
												,remrm_lockin_qty
												,remrm_rmks
												,remrm_certificate_no
												,remrm_created_by
												,remrm_created_dt
												,remrm_lst_upd_by
												,remrm_lst_upd_dt
												,remrm_deleted_ind,REMRM_REPURCHASE_FLG  
										  )
												SELECT remrm_id
																		,remrm_dpam_id
																		,remrm_isin
																		,remrm_slip_serial_no
																		,remrm_request_dt
																		,remrm_lot_type
																		,remrm_qty
																		,remrm_free_lockedin_yn
																		,REMRM_INTERNAL_REJ 
																		,REMRM_COMPANY_OBJ 
																		,REMRM_CREDIT_RECD 
																		,remrm_lockin_reason_cd
																		,remrm_lockin_reason_dt
																		,remrm_converted_qty
																		,remrm_rmks
																		,remrm_certificate_no
																		,remrm_created_by
																		,remrm_created_dt
																		,@pa_login_name
																		,getdate()
																		,4,REMRM_REPURCHASE_FLG
												FROM  remat_request_mstr
												WHERE remrm_id          = convert(numeric,@currstring)
												AND   remrm_deleted_ind = 1
										--
  								END
				    --
				    END
				    ELSE IF @PA_ACTION = 'APP'
								BEGIN
				    --
				    
				      BEGIN TRANSACTION
				      
				      IF EXISTS(select * from remrm_mak where remrm_id = convert(numeric,@currstring) and remrm_deleted_ind = 6)
										BEGIN
										--
												UPDATE remat_request_mstr
												SET    remrm_dpam_id             = remrmm.remrm_dpam_id             
														,remrm_isin                = remrmm.remrm_isin                
														,remrm_slip_serial_no      = remrmm.remrm_slip_serial_no 
														,remrm_request_dt          = remrmm.remrm_request_dt          
														,remrm_lot_type            = remrmm.remrm_lot_type            
														,remrm_qty                 = remrmm.remrm_qty                 
														,remrm_free_lockedin_yn    = remrmm.remrm_free_lockedin_yn 
														,REMRM_INTERNAL_REJ        = remrmm.REMRM_INTERNAL_REJ
														,REMRM_COMPANY_OBJ         = remrmm.REMRM_COMPANY_OBJ
														,REMRM_CREDIT_RECD 		   = remrmm.REMRM_CREDIT_RECD 											
														,remrm_lockin_reason_cd    = remrmm.remrm_lockin_reason_cd    
														,remrm_lockin_reason_dt    = remrmm.remrm_lockin_reason_dt    
														,remrm_lockin_qty       = remrmm.remrm_converted_qty       
														,remrm_rmks                = remrmm.remrm_rmks 
														,remrm_certificate_no      = remrmm.remrm_certificate_no    , REMRM_REPURCHASE_FLG       = REMRMM.REMRM_REPURCHASE_FLG    
												FROM   remrm_mak                   remrmm
												      ,remat_request_mstr          remrm
												WHERE  remrmm.remrm_id           = convert(numeric,@currstring)
												AND    remrm.remrm_id            = remrmm.remrm_id
												AND    remrmm.remrm_deleted_ind   = 6 

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
														UPDATE remrm_mak
														SET    remrm_deleted_ind = 7
																			, remrm_lst_upd_by  = @pa_login_name
																			, remrm_lst_upd_dt  = getdate()
														WHERE  remrm_id          = convert(numeric,@currstring)
														AND    remrm_deleted_ind = 6

														COMMIT TRANSACTION
												--
												END
										--
						    END
						    ELSE IF exists(select * from remrm_mak where remrm_id = convert(numeric,@currstring) and remrm_deleted_ind = 0)
										BEGIN
										--
												INSERT INTO remat_request_mstr 
												(remrm_id
												,remrm_dpam_id
												,remrm_isin
												,remrm_slip_serial_no
												,remrm_request_dt
												,remrm_lot_type
												,remrm_rrf_no
												,remrm_qty
												,remrm_free_lockedin_yn
												,rEMRM_INTERNAL_REJ 
												,rEMRM_COMPANY_OBJ 
												,rEMRM_CREDIT_RECD 
												,remrm_lockin_reason_cd
												,remrm_lockin_reason_dt
												,remrm_lockin_qty
												,remrm_rmks
												,remrm_certificate_no
												,remrm_created_by
												,remrm_created_dt
												,remrm_lst_upd_by
												,remrm_lst_upd_dt
												,remrm_deleted_ind,REMRM_REPURCHASE_FLG
										  )
												SELECT remrm_id
																		,remrm_dpam_id
																		,remrm_isin
																		,remrm_slip_serial_no
																		,remrm_request_dt
																		,remrm_lot_type
																		,remrm_rrf_no
																		,remrm_qty
																		,remrm_free_lockedin_yn
																		,rEMRM_INTERNAL_REJ 
																		,rEMRM_COMPANY_OBJ 
																		,rEMRM_CREDIT_RECD 
																		,remrm_lockin_reason_cd
																		,remrm_lockin_reason_dt
																		,remrm_converted_qty
																		,remrm_rmks
																		,remrm_certificate_no
																		,remrm_created_by
																		,remrm_created_dt
																		,@pa_login_name
																		,getdate()
																		,1,REMRM_REPURCHASE_FLG
												FROM  remrm_mak
												WHERE remrm_id          = convert(numeric,@currstring)
												AND   remrm_deleted_ind = 0

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
														UPDATE remrm_mak
														SET    remrm_deleted_ind = 1
																			, remrm_lst_upd_by  = @pa_login_name
																			, remrm_lst_upd_dt  = getdate()
														WHERE  remrm_id          = convert(numeric,@currstring)
														AND    remrm_deleted_ind = 0


														COMMIT TRANSACTION
												--
												END
										--
						    END
						    ELSE 
										BEGIN
										--
												UPDATE remat_request_mstr
												SET    remrm_deleted_ind = 0
																	, remrm_lst_upd_by  = @pa_login_name
																	, remrm_lst_upd_dt  = getdate()
												WHERE  remrm_id          = convert(numeric,@currstring)
												AND    remrm_deleted_ind = 1

												UPDATE remrm_mak
												SET    remrm_deleted_ind = 5
																	, remrm_lst_upd_by  = @pa_login_name
																	, remrm_lst_upd_dt  = getdate()
												WHERE  remrm_id          = convert(numeric,@currstring)
												AND    remrm_deleted_ind = 4

												COMMIT TRANSACTION
										--
  						  END
				    --
				    END
				    ELSE IF @PA_ACTION = 'REJ'
								BEGIN
								--
								  
          BEGIN TRANSACTION
          
          
          UPDATE remrm_mak
										SET    remrm_deleted_ind = 3
															, remrm_lst_upd_by  = @pa_login_name
															, remrm_lst_upd_dt  = getdate()
										WHERE  remrm_id          = convert(numeric,@currstring)
										AND    remrm_deleted_ind in (0,4,6)


          delete from uses from used_slip uses, remrm_mak , dp_acct_mstr 
				where DPAM_ID  = REMRM_DPAM_ID 
				and  USES_DPAM_ACCT_NO = dpam_sba_no 
				and REMRM_SLIP_SERIAL_NO = ltrim(rtrim(USES_SERIES_TYPE))+ltrim(rtrim(USES_SLIP_NO))
				and remrm_id          = convert(numeric,@currstring)  and USES_TRANTM_ID =  '902'

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
  SET @pa_errmsg = @t_errorstr
  IF left(ltrim(rtrim(@pa_errmsg)),5) <> 'ERROR'
		BEGIN
		--
				exec pr_checkslipno '','REMRM_SEL', @pa_dpm_dpid,@pa_dpam_acct_no,@pa_slip_sr_no,@pa_login_name,''
		--
  END
--
END

GO
