-- Object: PROCEDURE citrus_usr.pr_ins_upd_demrm_bak07012012
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create PROCEDURE [citrus_usr].[pr_ins_upd_demrm_bak07012012](@pa_id              VARCHAR(8000)  
											, @pa_action         VARCHAR(20)  
											, @pa_login_name     VARCHAR(20) 
											, @pa_isin           VARCHAR(20)
											, @pa_dpm_dpid       VARCHAR(50)
											, @pa_dpam_acct_no   VARCHAR(50)
											, @pa_slp_sr_no      VARCHAR(50)
											, @pa_req_dt         VARCHAR(11)
											, @pa_qty            NUMERIC(18,3)
											, @pa_rmks           VARCHAR(11)
											, @pa_lockedin_yn    CHAR(1)
											--, @pa_dis_doc_id     VARCHAR(20)
                                            --, @pa_dis_doc_name   VARCHAR(30)
                                            --, @pa_dis_dt         VARCHAR(11)
                                            , @PA_INTERNAL_REJ   VARCHAR(10)
											, @PA_COMPANY_OBJ    VARCHAR(10)
											, @PA_CREDIT_RECD    VARCHAR(5)
											, @pa_lk_reason_cd   VARCHAR(20) 
											, @pa_lk_release_dt  VARCHAR(11)
											, @pa_values         VARCHAR(8000)
											, @pa_values_hld     VARCHAR(8000)
											, @pa_values_sur     VARCHAR(8000)
                                            , @pa_tot_cer        numeric
											, @pa_chk_yn         INT 
											, @pa_typeofsec		 varchar(50) 
											, @rowdelimiter      CHAR(4)       = '*|~*'  
											, @coldelimiter      CHAR(4)       = '|*~|'  
											, @pa_errmsg         VARCHAR(8000) output  
)  
AS
/*
*********************************************************************************
 SYSTEM         : dp
 MODULE NAME    : pr_mak_slibm
 DESCRIPTION    : this procedure will contain the maker checker facility for slip_book_mstr
 COPYRIGHT(C)   : marketplace technologies 
 VERSION HISTORY: 1.0
 VERS.  AUTHOR            DATE          REASON
 -----  -------------     ------------  --------------------------------------------------
 1.0    TUSHAR            29-NOV-2007   VERSION.
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
      , @l_demrm_id      NUMERIC
      , @l_demrmm_id     NUMERIC
      , @delimeter_value varchar(10)
      , @delimeterlength_value varchar(10)
      , @remainingstring_value varchar(8000)
      , @currstring_value varchar(8000)
      , @l_access1      int
      , @l_access       int
      , @l_excm_id      numeric
      , @l_excm_cd      VARCHAR(500)
      , @l_dpam_id      NUMERIC
      , @l_folio_no     VARCHAR(50)
      , @l_cert_no      VARCHAR(50)
      , @l_disct_no_fr  VARCHAR(20)
      , @l_disct_no_to  VARCHAR(20)
      , @l_qty          VARCHAR(20) 
      , @l_status	      VARCHAR(50)
      , @l_rej_cd       VARCHAR(25)
      , @l_rmks         VARCHAR(200)
      , @l_demrd_id     NUMERIC
      , @l_id           VARCHAR(20)
      , @l_action       VARCHAR(10)
      , @l_deleted_ind  numeric
      , @l_demrdm_id     numeric
     
      , @@c_access_cursor  CURSOR   
      , @l_delted_id1   NUMERIC
      , @C_demrd_id     NUMERIC
      , @L_COUNT_CERTI NUMERIC

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
				    select @l_dpam_id        = dpam_id  
								from   dp_acct_mstr        with(nolock)
													, dp_mstr             with(nolock) 
								where  dpm_id            = dpam_dpm_id 
								and    dpm_dpid          = @pa_dpm_dpid 
								and    dpam_sba_no      = @pa_dpam_acct_no
								and    dpam_deleted_ind  = 1
		      and    dpm_deleted_ind   = 1
		      
		      
				    IF @PA_ACTION = 'INS'
				    BEGIN
				    --
					  BEGIN TRANSACTION
											
				      SELECT @l_demrm_id   = ISNULL(MAX(demrm_id),0) + 1 FROM demat_request_mstr 
				      
				      INSERT INTO demat_request_mstr
				      (demrm_id
						,demrm_isin
						,demrm_dpam_id
						,demrm_slip_serial_no
						,demrm_request_dt
						,demrm_drf_no
						,demrm_qty
						,demrm_rmks
						,demrm_free_lockedin_yn
						,DEMRM_INTERNAL_REJ
						,DEMRM_COMPANY_OBJ
						,DEMRM_CREDIT_RECD       
						,demrm_lockin_reason_cd
						,demrm_lockin_release_dt
						,demrm_created_by
						,demrm_created_dt
						,demrm_lst_upd_by
						,demrm_lst_upd_dt
						,demrm_deleted_ind 
						,DEMRM_TOTAL_CERTIFICATES
						,demrm_typeofsec	
				      )VALUES
				      (@l_demrm_id   
				      ,@pa_isin
				      ,@l_dpam_id    
				      ,@pa_slp_sr_no
				      ,convert(datetime,@pa_req_dt,103)         
				      ,@l_demrm_id   
				  	  ,@pa_qty            
					  ,@pa_rmks 
					  ,@pa_lockedin_yn    
					  ,@PA_INTERNAL_REJ
                      ,@PA_COMPANY_OBJ
                      ,@PA_CREDIT_RECD       
					  ,@pa_lk_reason_cd   
                      ,convert(datetime,@pa_lk_release_dt,103)  
					  ,@pa_login_name
					  ,getdate()
				 	  ,@pa_login_name
				      ,getdate()
					  ,1,@pa_tot_cer,@pa_typeofsec 
				      )
				      
				      INSERT INTO DEMAT_TRAN_TRANM_DTLS
				      (demttd_demrm_id
										,demttd_hld1
										,demttd_hld2
										,demttd_hld3
										,demttd_surv1
										,demttd_surv2
										,demttd_surv3
										,demttd_created_by
										,demttd_created_dt
										,demttd_lst_upd_by
										,demttd_lst_upd_dt
										,demttd_deleted_ind 
										)
										select @l_demrm_id
										, citrus_usr.fn_splitval(@pa_values_hld,1)      
										, citrus_usr.fn_splitval(@pa_values_hld,2)      
										, citrus_usr.fn_splitval(@pa_values_hld,3)      
										, citrus_usr.fn_splitval(@pa_values_sur,1)      
										, citrus_usr.fn_splitval(@pa_values_sur,2)      
										, citrus_usr.fn_splitval(@pa_values_sur,3)
										, @pa_login_name
										, getdate()
										, @pa_login_name
										, getdate()
										, 1
				      
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
				    
				      UPDATE demat_request_mstr
				      SET    demrm_isin               = @pa_isin
																,demrm_dpam_id            = @l_dpam_id
																,demrm_slip_serial_no     = @pa_slp_sr_no
																,demrm_request_dt         = CONVERT(datetime,@pa_req_dt,103)
																,demrm_qty                = @pa_qty
																,demrm_rmks               = @pa_rmks
																,demrm_free_lockedin_yn   = @pa_lockedin_yn
																,DEMRM_INTERNAL_REJ = @PA_INTERNAL_REJ 
																,DEMRM_COMPANY_OBJ =@PA_COMPANY_OBJ
																,DEMRM_CREDIT_RECD =@PA_CREDIT_RECD 
                                                                ,demrm_lockin_reason_cd   = @pa_lk_reason_cd
																,demrm_lockin_release_dt  = CONVERT(datetime,@pa_lk_release_dt,103)
																,demrm_lst_upd_by         = @pa_login_name
																,demrm_lst_upd_dt         = getdate()
																,demrm_typeofsec		  = @pa_typeofsec
                                        ,DEMRM_TOTAL_CERTIFICATES = @pa_tot_cer 
										WHERE  demrm_id                 = CONVERT(INT,@currstring)					
										AND    demrm_deleted_ind        = 1
										
										
																

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
										 	UPDATE demat_tran_tranm_dtls
												SET    demttd_hld1     = citrus_usr.fn_splitval(@pa_values_hld,1)      
																		,demttd_hld2     = citrus_usr.fn_splitval(@pa_values_hld,2)      
																		,demttd_hld3     = citrus_usr.fn_splitval(@pa_values_hld,3)      
																		,demttd_surv1    = citrus_usr.fn_splitval(@pa_values_sur,1)      
																		,demttd_surv2    = citrus_usr.fn_splitval(@pa_values_sur,2)      
																		,demttd_surv3    = citrus_usr.fn_splitval(@pa_values_sur,3)
  										WHERE  demttd_demrm_id = CONVERT(INT,@currstring)			
										
										
												COMMIT TRANSACTION
												
												SELECT @L_COUNT_CERTI = COUNT(DISTINCT DEMRD_CERT_NO) FROM DEMAT_REQUEST_DTLS drd WHERE DEMRD_DEMRM_ID = CONVERT(INT,@currstring) AND DEMRD_DELETED_IND = 1
												UPDATE DEMAT_REQUEST_MSTR
												SET	DEMRM_TOTAL_CERTIFICATES = case when @pa_tot_cer = 0 then @L_COUNT_CERTI else @pa_tot_cer end 
												WHERE DEMRM_ID = CONVERT(INT,@currstring) 
												AND   DEMRM_DELETED_IND = 1
												SET @L_COUNT_CERTI = 0
										--
  								END
				    --
				    END
				    ELSE IF @PA_ACTION = 'DEL'
								BEGIN
								--
								  BEGIN TRANSACTION
								  
								  UPDATE demat_request_dtls
										SET    demrd_deleted_ind   = 0
																,demrd_lst_upd_dt    = getdate()
																,demrd_lst_upd_by    = @pa_login_name 
										FROM   demat_request_dtls
										      ,demat_request_mstr
										WHERE  demrm_id            = demrd_demrm_id 
										AND    demrm_id            = CONVERT(INT,@currstring)					
										AND    demrm_deleted_ind   = 1
										
										
										UPDATE demat_tran_tranm_dtls
										SET    demttd_deleted_ind   = 0
																,demttd_lst_upd_dt    = getdate()
																,demttd_lst_upd_by    = @pa_login_name 
										FROM   demat_tran_tranm_dtls
																,demat_request_mstr
										WHERE  demrm_id            = demttd_demrm_id 
										AND    demrm_id            = CONVERT(INT,@currstring)					
										AND    demrm_deleted_ind   = 1
										AND    demttd_deleted_ind   = 1 
										
								  
								  
								  UPDATE demat_request_mstr
										SET    demrm_deleted_ind   = 0
										      ,demrm_lst_upd_dt    = getdate()
										      ,demrm_lst_upd_by    = @pa_login_name 
										WHERE  demrm_id            = CONVERT(INT,@currstring)					
										AND    demrm_deleted_ind   = 1
										
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
												
												SELECT @L_COUNT_CERTI = COUNT(DISTINCT DEMRD_CERT_NO) FROM DEMAT_REQUEST_DTLS drd WHERE DEMRD_DEMRM_ID = CONVERT(INT,@currstring) AND DEMRD_DELETED_IND = 1
												UPDATE DEMAT_REQUEST_MSTR
												SET	DEMRM_TOTAL_CERTIFICATES = case when @pa_tot_cer = 0 then @L_COUNT_CERTI else @pa_tot_cer end 
												WHERE DEMRM_ID = CONVERT(INT,@currstring) 
												AND   DEMRM_DELETED_IND = 1
												SET @L_COUNT_CERTI = 0
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
																										  
										SELECT @l_demrm_id = ISNULL(MAX(demrm_id),0)+1
										FROM demat_request_mstr WITH (NOLOCK)
										--
										SELECT @L_demrmm_id = ISNULL(MAX(demrm_id),0)+1
										FROM demrm_mak WITH (NOLOCK)

										IF @l_demrmm_id > @l_demrm_id
										BEGIN
										--
												SET  @l_demrm_id = @l_demrmm_id
										--
										END

										INSERT INTO demrm_mak
										(demrm_id
										,demrm_isin
										,demrm_dpam_id
										,demrm_slip_serial_no
										,demrm_request_dt
										,demrm_drf_no
										,demrm_qty
										,demrm_rmks
										,demrm_free_lockedin_yn
										,DEMRM_INTERNAL_REJ 
                                        ,DEMRM_COMPANY_OBJ 
										,DEMRM_CREDIT_RECD 
										,demrm_lockin_reason_cd
										,demrm_lockin_release_dt
										,demrm_created_by
										,demrm_created_dt
										,demrm_lst_upd_by
										,demrm_lst_upd_dt
										,demrm_deleted_ind 
                                        ,DEMRM_TOTAL_CERTIFICATES,demrm_typeofsec
										)VALUES
										(@l_demrm_id   
										,@pa_isin
										,@l_dpam_id    
										,@pa_slp_sr_no
										,convert(datetime,@pa_req_dt,103)         
										,@l_demrm_id   
										,@pa_qty            
										,@pa_rmks 
										,@pa_lockedin_yn 
										,@PA_INTERNAL_REJ 
										,@PA_COMPANY_OBJ
										,@PA_CREDIT_RECD 
										,@pa_lk_reason_cd   
										,convert(datetime,@pa_lk_release_dt,103)  
										,@pa_login_name
										,getdate()
										,@pa_login_name
										,getdate()
										,0
                                        ,@pa_tot_cer
										,@pa_typeofsec 
				                        )
                                        
                                         INSERT INTO DEMAT_TRAN_TRANM_DTLS_mak
				                        (demttd_demrm_id
										,demttd_hld1
										,demttd_hld2
										,demttd_hld3
										,demttd_surv1
										,demttd_surv2
										,demttd_surv3
										,demttd_created_by
										,demttd_created_dt
										,demttd_lst_upd_by
										,demttd_lst_upd_dt
										,demttd_deleted_ind 
										)
										select @l_demrm_id
										, citrus_usr.fn_splitval(@pa_values_hld,1)      
										, citrus_usr.fn_splitval(@pa_values_hld,2)      
										, citrus_usr.fn_splitval(@pa_values_hld,3)      
										, citrus_usr.fn_splitval(@pa_values_sur,1)      
										, citrus_usr.fn_splitval(@pa_values_sur,2)      
										, citrus_usr.fn_splitval(@pa_values_sur,3)
										, @pa_login_name
										, getdate()
										, @pa_login_name
										, getdate()
										, 0

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
                                                SELECT @t_errorstr = 'GENERATED DRF NO :  '+CONVERT(VARCHAR,@l_demrm_id) 
												COMMIT TRANSACTION
										--
  								END
				    --
				    END
				    ELSE IF @PA_ACTION = 'EDT'
								BEGIN
								--
          BEGIN TRANSACTION
														      
										UPDATE demrm_mak
										SET    demrm_deleted_ind  = 2
															, demrm_lst_upd_dt   = getdate()
															, demrm_lst_upd_by   = @pa_login_name
										WHERE  demrm_id           = convert(numeric,@currstring)
										AND    demrm_deleted_ind  = 0
										
										/*UPDATE demrd_mak
										SET    demrd_deleted_ind  = 2
															, demrd_lst_upd_dt   = getdate()
															, demrd_lst_upd_by   = @pa_login_name
										WHERE  demrd_demrm_id     = convert(numeric,@currstring)
										AND    demrd_deleted_ind  = 0*/
										
										

										IF EXISTS(select * from demat_request_mstr where demrm_id = CONVERT(INT,@currstring) and demrm_deleted_ind = 1)
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
								  
								  
								  INSERT INTO demrm_mak
										(demrm_id
										,demrm_isin
										,demrm_dpam_id
										,demrm_slip_serial_no
										,demrm_request_dt
										,demrm_drf_no
										,demrm_qty
										,demrm_rmks
										,demrm_free_lockedin_yn
									    ,DEMRM_INTERNAL_REJ 
										,DEMRM_COMPANY_OBJ 
										,DEMRM_CREDIT_RECD 
										,demrm_lockin_reason_cd
										,demrm_lockin_release_dt
										,demrm_created_by
										,demrm_created_dt
										,demrm_lst_upd_by
										,demrm_lst_upd_dt
										,demrm_deleted_ind ,DEMRM_TOTAL_CERTIFICATES, DEMRM_TYPEOFSEC
										)VALUES
										(convert(numeric,@currstring)
										,@pa_isin
										,@l_dpam_id    
										,@pa_slp_sr_no
										,convert(datetime,@pa_req_dt,103)         
										,convert(numeric,@currstring)  
										,@pa_qty            
										,@pa_rmks 
										,@pa_lockedin_yn    
										,@PA_INTERNAL_REJ 
										,@PA_COMPANY_OBJ
										,@PA_CREDIT_RECD 
										,@pa_lk_reason_cd   
										,convert(datetime,@pa_lk_release_dt,103)  
										,@pa_login_name
										,getdate()
										,@pa_login_name
										,getdate()
										,@l_deleted_ind ,@pa_tot_cer ,@pa_typeofsec
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
                                           UPDATE demat_tran_tranm_dtls_mak
												SET    demttd_hld1     = citrus_usr.fn_splitval(@pa_values_hld,1)      
																		,demttd_hld2     = citrus_usr.fn_splitval(@pa_values_hld,2)      
																		,demttd_hld3     = citrus_usr.fn_splitval(@pa_values_hld,3)      
																		,demttd_surv1    = citrus_usr.fn_splitval(@pa_values_sur,1)      
																		,demttd_surv2    = citrus_usr.fn_splitval(@pa_values_sur,2)      
																		,demttd_surv3    = citrus_usr.fn_splitval(@pa_values_sur,3)
  										WHERE  demttd_demrm_id = CONVERT(INT,@currstring)

												COMMIT TRANSACTION
										--
  								END
								--
				    END
				    ELSE IF @PA_ACTION = 'DEL'
								BEGIN
				    --
				      IF EXISTS(select * from demat_request_mstr where demrm_id = CONVERT(INT,@currstring) and demrm_deleted_ind = 1)
				      BEGIN
	--add after confirmation
--	SELECT @l_demrm_id = ISNULL(MAX(demrm_id),0)+1
--											FROM demat_request_mstr WITH (NOLOCK)
--											--
--											SELECT @L_demrmm_id = ISNULL(MAX(demrm_id),0)+1
--											FROM demrm_mak WITH (NOLOCK)
--
--											IF @l_demrmm_id > @l_demrm_id
--											BEGIN
--											--
--													SET  @l_demrm_id = @l_demrmm_id
--											--
--											END
	--end
				      --
				         BEGIN TRANSACTION
				         
				         INSERT INTO demrm_mak
										(demrm_id
										,demrm_isin
										,demrm_dpam_id
										,demrm_slip_serial_no
										,demrm_request_dt
										,demrm_drf_no
										,demrm_qty
										,demrm_rmks
										,demrm_free_lockedin_yn
										,DEMRM_INTERNAL_REJ 
										,DEMRM_COMPANY_OBJ 
										,DEMRM_CREDIT_RECD 
										,demrm_lockin_reason_cd
										,demrm_lockin_release_dt
										,demrm_created_by
										,demrm_created_dt
										,demrm_lst_upd_by
										,demrm_lst_upd_dt
										,demrm_deleted_ind
										,demrm_typeofsec)
										   SELECT demrm_id
												,demrm_isin
												,demrm_dpam_id
												,demrm_slip_serial_no
												,demrm_request_dt
												,demrm_drf_no
												,demrm_qty
												,demrm_rmks
												,demrm_free_lockedin_yn
												,DEMRM_INTERNAL_REJ 
												,DEMRM_COMPANY_OBJ 
												,DEMRM_CREDIT_RECD 
												,demrm_lockin_reason_cd
												,demrm_lockin_release_dt
												,demrm_created_by
												,demrm_created_dt
												,demrm_lst_upd_by
												,demrm_lst_upd_dt
												,4
												,demrm_typeofsec
										   FROM   demat_request_mstr
										   WHERE  demrm_id           = CONVERT(INT,@currstring)
										   AND    demrm_deleted_ind  = 1  

                                          INSERT INTO DEMAT_TRAN_TRANM_DTLS_mak
				                        (demttd_demrm_id
										,demttd_hld1
										,demttd_hld2
										,demttd_hld3
										,demttd_surv1
										,demttd_surv2
										,demttd_surv3
										,demttd_created_by
										,demttd_created_dt
										,demttd_lst_upd_by
										,demttd_lst_upd_dt
										,demttd_deleted_ind 
										)
										select @l_demrm_id
										, citrus_usr.fn_splitval(@pa_values_hld,1)      
										, citrus_usr.fn_splitval(@pa_values_hld,2)      
										, citrus_usr.fn_splitval(@pa_values_hld,3)      
										, citrus_usr.fn_splitval(@pa_values_sur,1)      
										, citrus_usr.fn_splitval(@pa_values_sur,2)      
										, citrus_usr.fn_splitval(@pa_values_sur,3)
										, @pa_login_name
										, getdate()
										, @pa_login_name
										, getdate()
										, 1
                                         FROM   DEMAT_TRAN_TRANM_DTLS
										   WHERE  demttd_demrm_id           = CONVERT(INT,@currstring)
										   AND    demttd_deleted_ind  = 1  
										   
										   
										   
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
				      ELSE
				      BEGIN
				      --
				        DELETE FROM demrm_mak WHERE demrm_id = CONVERT(INT,@currstring)
				      --
				      END
				    --
				    END
				    ELSE IF @pa_action = 'APP'
				    BEGIN
				    --

				      SELECT @l_deleted_ind  = demrm_deleted_ind from demrm_mak where demrm_id = CONVERT(INT,@currstring) and demrm_deleted_ind in (0,4,6)
				      
				      IF @l_deleted_ind = 0 
				      BEGIN
				      --

				        BEGIN TRANSACTION
				        
												INSERT INTO demat_request_mstr
												(demrm_id
												,demrm_isin
												,demrm_dpam_id
												,demrm_slip_serial_no
												,demrm_request_dt
												,demrm_drf_no
												,demrm_qty
												,demrm_rmks
												,demrm_free_lockedin_yn
												 ,DEMRM_INTERNAL_REJ 
												,DEMRM_COMPANY_OBJ 
												,DEMRM_CREDIT_RECD 
												,demrm_lockin_reason_cd
												,demrm_lockin_release_dt
												,demrm_created_by
												,demrm_created_dt
												,demrm_lst_upd_by
												,demrm_lst_upd_dt
												,demrm_deleted_ind,DEMRM_TOTAL_CERTIFICATES,demrm_typeofsec)
												SELECT demrm_id
																		,demrm_isin
																		,demrm_dpam_id
																		,demrm_slip_serial_no
																		,demrm_request_dt
																		,demrm_drf_no
																		,demrm_qty
																		,demrm_rmks
																		,demrm_free_lockedin_yn
																		 ,DEMRM_INTERNAL_REJ 
																		,DEMRM_COMPANY_OBJ 
																		,DEMRM_CREDIT_RECD 
																		,demrm_lockin_reason_cd
																		,demrm_lockin_release_dt
																		,demrm_created_by
																		,demrm_created_dt
																		,@pa_login_name
																		,getdate()
																		,1,DEMRM_TOTAL_CERTIFICATES,demrm_typeofsec
												FROM   demrm_mak
												WHERE  demrm_id           = CONVERT(INT,@currstring)
												AND    demrm_deleted_ind  = 0  
												
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

												  INSERT INTO demat_request_dtls
														(demrd_id
														,demrd_demrm_id
														,demrd_folio_no
														,demrd_cert_no
														,demrd_distinctive_no_fr
														,demrd_distinctive_no_to
														,demrd_qty
														,demrd_status
														,demrd_rej_cd
														,demrd_rmks
														,demrd_created_by
														,demrd_created_dt
														,demrd_lst_upd_by
														,demrd_lst_upd_dt
														,demrd_deleted_ind 
														)
														SELECT demrd_id
														,demrd_demrm_id
														,demrd_folio_no
														,demrd_cert_no
														,demrd_distinctive_no_fr
														,demrd_distinctive_no_to
														,demrd_qty
														,demrd_status
														,demrd_rej_cd
														,demrd_rmks
														,demrd_created_by
														,demrd_created_dt
														,@pa_login_name
														,getdate()
														,1
														FROM  demrd_mak 
														WHERE demrd_deleted_ind = 0
														AND   demrd_demrm_id    = CONVERT(INT,@currstring)

                                                      
                                                   INSERT INTO DEMAT_TRAN_TRANM_DTLS
								                   (demttd_demrm_id
													,demttd_hld1
													,demttd_hld2
													,demttd_hld3
													,demttd_surv1
													,demttd_surv2
													,demttd_surv3
													,demttd_created_by
													,demttd_created_dt
													,demttd_lst_upd_by
													,demttd_lst_upd_dt
													,demttd_deleted_ind 
													)
													select demttd_demrm_id
													, DEMTTD_HLD1      
													, DEMTTD_HLD2     
													, DEMTTD_HLD3      
													, DEMTTD_SURV1      
													, DEMTTD_SURV2      
													, DEMTTD_SURV3
													, DEMTTD_CREATED_BY
													, DEMTTD_CREATED_DT
													, @pa_login_name
													, getdate()
													, 1
                                                   FROM  DEMAT_TRAN_TRANM_DTLS_mak 
												   WHERE DEMTTD_DELETED_IND = 0
												   AND   DEMTTD_DEMRM_ID    = CONVERT(INT,@currstring)
												
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
  												  
  												  
																UPDATE demrd_mak
																SET    demrd_deleted_ind = 1
																					, demrd_lst_upd_dt  = getdate()
																					, demrd_lst_upd_by  = @pa_login_name
																WHERE  demrd_demrm_id    = CONVERT(INT,@currstring)
  												  AND    demrd_deleted_ind = 0
  												  
  												  
																UPDATE demrm_mak
																SET    demrm_deleted_ind = 1
																					, demrm_lst_upd_dt  = getdate()
																					, demrm_lst_upd_by  = @pa_login_name
																WHERE  demrm_id    = CONVERT(INT,@currstring)
  												  AND    demrm_deleted_ind = 0

                                                           UPDATE DEMAT_TRAN_TRANM_DTLS_MAK
																SET    DEMTTD_DELETED_IND = 1
																					, DEMTTD_LST_UPD_DT  = getdate()
																					, DEMTTD_LST_UPD_BY  = @pa_login_name
																WHERE  DEMTTD_DEMRM_ID    = CONVERT(INT,@currstring)
  												  AND    DEMTTD_DELETED_IND = 0
  												--
  												END
												--
     							END
				      --
				      END
				      IF @l_deleted_ind = 4 
										BEGIN
										--
										  BEGIN TRANSACTION
										  
										  UPDATE demat_request_mstr 
										  SET    demrm_deleted_ind = 0
										       , demrm_lst_upd_dt  = getdate()
										       , demrm_lst_upd_by  = @pa_login_name
										  WHERE  demrm_id          = CONVERT(INT,@currstring)
										  
										  UPDATE demat_request_dtls
										  SET    demrd_deleted_ind = 0
																	, demrd_lst_upd_dt  = getdate()
																	, demrd_lst_upd_by  = @pa_login_name
												WHERE  demrd_demrm_id    = CONVERT(INT,@currstring)

                                         UPDATE DEMAT_TRAN_TRANM_DTLS
										 SET    DEMTTD_DELETED_IND = 0
										            					 , DEMTTD_LST_UPD_DT  = getdate()
																		, DEMTTD_LST_UPD_BY  = @pa_login_name
												WHERE  DEMTTD_DEMRM_ID    = CONVERT(INT,@currstring)
  												 
										  
										  
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
														
														
														UPDATE demrd_mak
														SET    demrd_deleted_ind = 5
														     , demrd_lst_upd_dt  = getdate()
														     , demrd_lst_upd_by  = @pa_login_name
												  WHERE  demrd_demrm_id    = CONVERT(INT,@currstring)
												  AND    demrd_deleted_ind = 4
												  
														UPDATE demrm_mak
														SET    demrm_deleted_ind = 5
																			, demrm_lst_upd_dt  = getdate()
																			, demrm_lst_upd_by  = @pa_login_name
														WHERE  demrm_id          = CONVERT(INT,@currstring)
												  AND    demrm_deleted_ind = 4

                                                 UPDATE DEMAT_TRAN_TRANM_DTLS_MAK
														SET    DEMTTD_DELETED_IND = 5
																			, DEMTTD_LST_UPD_DT  = getdate()
																			, DEMTTD_LST_UPD_BY  = @pa_login_name
														WHERE  DEMTTD_DEMRM_ID          = CONVERT(INT,@currstring)
												  AND    DEMTTD_DELETED_IND = 4
												--
  										END
										  
										--
				      END
				      IF @l_deleted_ind = 6 
										BEGIN
										--


										  BEGIN TRANSACTION
										  UPDATE demrm         
				        SET    demrm_isin               = demrmm.demrm_isin               
																		,demrm_dpam_id            = demrmm.demrm_dpam_id            
																		,demrm_slip_serial_no     = demrmm.demrm_slip_serial_no     
																		,demrm_request_dt         = demrmm.demrm_request_dt         
																		,demrm_qty                = demrmm.demrm_qty                
																		,demrm_rmks               = demrmm.demrm_rmks               
																		,demrm_free_lockedin_yn   = demrmm.demrm_free_lockedin_yn   
																		,DEMRM_INTERNAL_REJ       = demrmm.DEMRM_INTERNAL_REJ       
																		,DEMRM_COMPANY_OBJ        = demrmm.DEMRM_COMPANY_OBJ 
																		,DEMRM_CREDIT_RECD        = demrmm.DEMRM_CREDIT_RECD          
																		,demrm_lockin_reason_cd   = demrmm.demrm_lockin_reason_cd   
																		,demrm_lockin_release_dt  = demrmm.demrm_lockin_release_dt  
																		,demrm_lst_upd_by         = demrmm.demrm_lst_upd_by         
																		,demrm_lst_upd_dt         = demrmm.demrm_lst_upd_dt      
                                                                        ,DEMRM_TOTAL_CERTIFICATES = demrmm.DEMRM_TOTAL_CERTIFICATES
																		,demrm_typeofsec		  = demrmm.demrm_typeofsec
												FROM   demrm_mak                  demrmm
                  ,demat_request_mstr         demrm
										  WHERE  demrmm.demrm_id          = CONVERT(INT,@currstring)					
										  and    demrmm.demrm_id          = demrm.demrm_id
										  AND    demrmm.demrm_deleted_ind        = 6 
										  
										  
										  
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
										  
										  IF exists(SELECT * FROM demrd_mak WHERE demrd_demrm_id  = CONVERT(INT,@currstring) and demrd_deleted_ind in (0,4,6))
										  BEGIN
										  --



										    SET @@c_access_cursor =  CURSOR fast_forward FOR      
														SELECT demrd_id , demrd_deleted_ind  FROM demrd_mak WHERE demrd_demrm_id  = CONVERT(INT,@currstring) and demrd_deleted_ind in (0,4,6)
														
														--      
																OPEN @@c_access_cursor      
																FETCH NEXT FROM @@c_access_cursor INTO @c_demrd_id, @l_delted_id1      
																--      
																WHILE @@fetch_status = 0      
																BEGIN      
																--
																  IF @l_delted_id1 = 0
																		BEGIN
																		-- 
																					BEGIN TRANSACTION 

																					INSERT INTO demat_request_dtls
																					(demrd_id
																					,demrd_demrm_id
																					,demrd_folio_no
																					,demrd_cert_no
																					,demrd_distinctive_no_fr
																					,demrd_distinctive_no_to
																					,demrd_qty
																					,demrd_status
																					,demrd_rej_cd
																					,demrd_rmks
																					,demrd_created_by
																					,demrd_created_dt
																					,demrd_lst_upd_by
																					,demrd_lst_upd_dt
																					,demrd_deleted_ind 
																					)
																					SELECT demrd_id
																					,demrd_demrm_id
																					,demrd_folio_no
																					,demrd_cert_no
																					,demrd_distinctive_no_fr
																					,demrd_distinctive_no_to
																					,demrd_qty
																					,demrd_status
																					,demrd_rej_cd
																					,demrd_rmks
																					,demrd_created_by
																					,demrd_created_dt
																					,@pa_login_name
																		            ,getdate()
																					,1
																					FROM  demrd_mak 
																					WHERE demrd_deleted_ind = 0
																					AND   demrd_id          = @c_demrd_id 

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

																							UPDATE demrd_mak
																							SET    demrd_deleted_ind = 1
																												, demrd_lst_upd_dt  = getdate()
																												, demrd_lst_upd_by  = @pa_login_name
																							WHERE  demrd_id    = @c_demrd_id
																							AND    demrd_deleted_ind = 0
																					--
																					END
																		--
																		END
																		ELSE IF @l_delted_id1 = 4
																		BEGIN
																		--
																				UPDATE demat_request_dtls
																				SET    demrd_deleted_ind = 0
																									, demrd_lst_upd_dt  = getdate()
																									, demrd_lst_upd_by  = @pa_login_name
																				WHERE  demrd_id    = @c_demrd_id

																				UPDATE demrd_mak
																				SET    demrd_deleted_ind = 5
																									, demrd_lst_upd_dt  = getdate()
																									, demrd_lst_upd_by  = @pa_login_name
																				WHERE  demrd_id    = @c_demrd_id
																				AND    demrd_deleted_ind = 4
																		--
																		END
																		ELSE IF @l_delted_id1 = 6
																		BEGIN
																		--
																				UPDATE demat_request_dtls          
																				SET    demrd_folio_no           = demrdm.demrd_folio_no           
																										,demrd_cert_no            = demrdm.demrd_cert_no            
																										,demrd_distinctive_no_fr  = demrdm.demrd_distinctive_no_fr  
																										,demrd_distinctive_no_to  = demrdm.demrd_distinctive_no_to  
																										,demrd_qty                = demrdm.demrd_qty                
																										,demrd_status             = demrdm.demrd_status             
																										,demrd_rej_cd             = demrdm.demrd_rej_cd             
																										,demrd_rmks               = demrdm.demrd_rmks               
																				from   demrd_mak						            demrdm
																										,demat_request_dtls         demrd 
																				WHERE 	demrd.demrd_id                 = @c_demrd_id
																				AND    demrd.demrd_id           = demrdm.demrd_id
																				AND    demrdm.demrd_deleted_ind = 6

																				UPDATE demrd_mak
																				SET    demrd_deleted_ind = 7
																									, demrd_lst_upd_dt  = getdate()
																									, demrd_lst_upd_by  = @pa_login_name
																				WHERE  demrd_id    = @c_demrd_id
																				AND    demrd_deleted_ind = 6

																		--
										        END
																  
																
																		FETCH NEXT FROM @@c_access_cursor INTO @c_demrd_id, @l_delted_id1  
																--      
																END      
																CLOSE      @@c_access_cursor      
                DEALLOCATE @@c_access_cursor
										    
										    
										    
										    
										    
										  --
										  END
										  
            UPDATE demrm_mak
												SET    demrm_deleted_ind = 7
												 				, demrm_lst_upd_dt  = getdate()
																	, demrm_lst_upd_by  = @pa_login_name
												WHERE  demrm_id          = CONVERT(INT,@currstring)
												AND    demrm_deleted_ind = 6										  
										  
										--
										
										
										END
										
--										SELECT @L_COUNT_CERTI = COUNT(DISTINCT DEMRD_CERT_NO) FROM DEMAT_REQUEST_DTLS drd WHERE DEMRD_DEMRM_ID = CONVERT(INT,@currstring) AND DEMRD_DELETED_IND = 1
--										UPDATE DEMAT_REQUEST_MSTR
--										SET	DEMRM_TOTAL_CERTIFICATES = case when @pa_tot_cer = 0 then @L_COUNT_CERTI else @pa_tot_cer end 
--										WHERE DEMRM_ID = CONVERT(INT,@currstring) 
--										AND   DEMRM_DELETED_IND = 1
--										SET @L_COUNT_CERTI = 0
	                                    								
				    --
				    END
				    ELSE IF @pa_action = 'REJ'
								BEGIN
								--
								  BEGIN TRANSACTION
								  
										UPDATE demrm_mak
										SET    demrm_deleted_ind = 3
										WHERE  demrm_deleted_ind in (0,4,6)
										AND    demrm_id          = CONVERT(INT,@currstring) 
										
										UPDATE demrd_mak
										SET    demrd_deleted_ind = 3
										WHERE  demrd_deleted_ind in (0,4,6)
										AND    demrd_demrm_id    = CONVERT(INT,@currstring) 
                                        
                                        UPDATE DEMAT_TRAN_TRANM_DTLS_MAK
										SET    DEMTTD_DELETED_IND = 3
										WHERE  DEMTTD_DELETED_IND in (0,4,6)
										AND    DEMTTD_DEMRM_ID    = CONVERT(INT,@currstring) 


 delete from uses from used_slip uses, demrm_mak , dp_acct_mstr 
				where DPAM_ID  = dEMRM_DPAM_ID 
				and  USES_DPAM_ACCT_NO = dpam_sba_no 
				and dEMRM_SLIP_SERIAL_NO = ltrim(rtrim(USES_SERIES_TYPE))+ltrim(rtrim(USES_SLIP_NO))
				and demrm_id          = convert(numeric,@currstring)  and USES_TRANTM_ID =  '901'

										
										
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
								  SET @l_action          = citrus_usr.fn_splitval(@currstring_value,1)      
								  
								  IF @l_action  = 'A' OR @l_action  = 'E'
								  BEGIN
--


												SET @l_folio_no        = citrus_usr.fn_splitval(@currstring_value,2)      
												SET @l_cert_no         = citrus_usr.fn_splitval(@currstring_value,3)      
												SET @l_qty             = citrus_usr.fn_splitval(@currstring_value,4)   
												SET @l_disct_no_fr     = citrus_usr.fn_splitval(@currstring_value,5)      				     							  
												SET @l_id              = citrus_usr.fn_splitval(@currstring_value,6) 
                                                IF ISNUMERIC(@l_disct_no_fr)=1 
                                                BEGIN
                                                SET @l_disct_no_to     = convert(varchar,convert(numeric,@l_qty) + convert(numeric,@l_disct_no_fr) - 1)
                                                END
                                                ELSE
                                                BEGIN
                                                SET @l_disct_no_to     = 'M'
                                                END 
												
												SET @l_status          = ''
												SET @l_rej_cd          = ''
												SET @l_rmks            = ''
										--
										END
										ELSE
										BEGIN
										--
										  SET @l_id        = citrus_usr.fn_splitval(@currstring_value,2)      
										--
										END
										
										
										IF @pa_chk_yn = 0
										BEGIN
										--
										  IF @l_action = 'A'
										  BEGIN
										  --
										    BEGIN TRANSACTION
										    
              SELECT @l_demrd_id   = ISNULL(MAX(demrd_id),0) + 1 FROM demat_request_dtls							  
              
              IF @pa_action = 'EDT'
              BEGIN
              --
                SET @l_demrm_id = convert(numeric,@currstring)
                
              --
              END
print 'jitesh1'
              
              
             
										    INSERT INTO demat_request_dtls
										    (demrd_id
														,demrd_demrm_id
														,demrd_folio_no
														,demrd_cert_no
														,demrd_distinctive_no_fr
														,demrd_distinctive_no_to
														,demrd_qty
														,demrd_status
														,demrd_rej_cd
														,demrd_rmks
														,demrd_created_by
														,demrd_created_dt
														,demrd_lst_upd_by
														,demrd_lst_upd_dt
														,demrd_deleted_ind 
										    )VALUES
										    (@l_demrd_id
										    ,@l_demrm_id  
										    ,@l_folio_no  
										    ,@l_cert_no   
										    ,@l_disct_no_fr  
										    ,@l_disct_no_to 
										    ,convert(numeric(19,5),@l_qty)--@l_qty 
										    ,@l_status
										    ,@l_rej_cd
										    ,@l_rmks 
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
																
																SELECT @L_COUNT_CERTI = COUNT(DISTINCT DEMRD_CERT_NO) FROM DEMAT_REQUEST_DTLS drd WHERE DEMRD_DEMRM_ID = @l_demrm_id AND DEMRD_DELETED_IND = 1
																UPDATE DEMAT_REQUEST_MSTR
																SET	DEMRM_TOTAL_CERTIFICATES = case when @pa_tot_cer = 0 then @L_COUNT_CERTI else @pa_tot_cer end 
																WHERE DEMRM_ID = @l_demrm_id
																AND   DEMRM_DELETED_IND = 1
																SET @L_COUNT_CERTI = 0
														--
      								END
										  --
										  END
										  ELSE IF @l_action = 'E'
										  BEGIN
										  --
										    UPDATE demat_request_dtls
										    SET    demrd_folio_no           = @l_folio_no
																				,demrd_cert_no            = @l_cert_no 
																				,demrd_distinctive_no_fr  = @l_disct_no_fr
																				,demrd_distinctive_no_to  = @l_disct_no_to 
																				,demrd_qty                = convert(numeric(19,5),@l_qty)--@l_qty
																				,demrd_status             = @l_status  
																				,demrd_rej_cd             = @l_rej_cd
																				,demrd_rmks               = @l_rmks
														WHERE 	demrd_id					            = @l_id
														AND    demrd_deleted_ind        = 1
														
														
														SELECT @L_COUNT_CERTI = COUNT(DISTINCT DEMRD_CERT_NO) FROM DEMAT_REQUEST_DTLS drd WHERE DEMRD_DEMRM_ID = @l_demrm_id AND DEMRD_DELETED_IND = 1
																UPDATE DEMAT_REQUEST_MSTR
																SET	DEMRM_TOTAL_CERTIFICATES = case when @pa_tot_cer = 0 then @L_COUNT_CERTI else @pa_tot_cer end 
																WHERE DEMRM_ID = @l_demrm_id
																AND   DEMRM_DELETED_IND = 1
																SET @L_COUNT_CERTI = 0
														
										  --
										  END
										  ELSE IF @l_action = 'D'
										  BEGIN
										  --
										   
										    UPDATE demat_request_dtls
														SET    demrd_deleted_ind   = 0
														     , demrd_lst_upd_dt    = getdate() 
														     , demrd_lst_upd_by    = @pa_login_name
														WHERE 	demrd_id					       = @l_id
														AND    demrd_deleted_ind   = 1
														
														
														SELECT @L_COUNT_CERTI = COUNT(DISTINCT DEMRD_CERT_NO) FROM DEMAT_REQUEST_DTLS drd WHERE DEMRD_DEMRM_ID = @l_demrm_id AND DEMRD_DELETED_IND = 1


																UPDATE DEMAT_REQUEST_MSTR
																SET	DEMRM_TOTAL_CERTIFICATES = case when @pa_tot_cer = 0 then @L_COUNT_CERTI else @pa_tot_cer end 
																WHERE DEMRM_ID = @l_demrm_id
																AND   DEMRM_DELETED_IND = 1

																SET @L_COUNT_CERTI = 0
														
										  --
										  END
										  
										--
										END
										ELSE IF @pa_chk_yn = 1
										BEGIN
										--
										  IF @l_action = 'A'
												BEGIN
												--
														BEGIN TRANSACTION

																						  
              SELECT @l_demrd_id = ISNULL(MAX(demrd_id),0)+1
    										FROM demat_request_dtls WITH (NOLOCK)
    										--
														SELECT @L_demrdm_id = ISNULL(MAX(demrd_id),0)+1
														FROM demrd_mak WITH (NOLOCK)

														IF @l_demrdm_id > @l_demrd_id
														BEGIN
														--
																SET  @l_demrd_id = @l_demrdm_id
														--
														END
														
              IF @pa_action = 'EDT'
              BEGIN
              --
                SET @l_demrm_id = convert(numeric,@currstring)
              --
              END
print 'jitesh2'
 
													INSERT INTO demrd_mak
													(demrd_id
													,demrd_demrm_id
													,demrd_folio_no
													,demrd_cert_no
													,demrd_distinctive_no_fr
													,demrd_distinctive_no_to
													,demrd_qty
													,demrd_status
													,demrd_rej_cd
													,demrd_rmks
													,demrd_created_by
													,demrd_created_dt
													,demrd_lst_upd_by
													,demrd_lst_upd_dt
													,demrd_deleted_ind 
													)VALUES
													(@l_demrd_id
													,@l_demrm_id
													,@l_folio_no  
													,@l_cert_no   
													,@l_disct_no_fr  
													,@l_disct_no_to 
													,convert(numeric(19,5),@l_qty)--@l_qty 
													,@l_status
													,@l_rej_cd
													,@l_rmks 
													,@pa_login_name
													,getdate()
													,@pa_login_name
													,getdate()
													,0
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
												ELSE IF @l_action = 'E'
												BEGIN
												--
print 'pankaj'
												  BEGIN TRANSACTION
												  
												  UPDATE demrd_mak
												  SET    demrd_deleted_ind  = 2
																			, demrd_lst_upd_dt   = getdate()
																			, demrd_lst_upd_by   = @pa_login_name
												  WHERE  demrd_id           = @l_id
    										      AND    demrd_deleted_ind  = 0
										
														IF EXISTS(select * from demat_request_dtls where demrd_id = @l_id and demrd_deleted_ind = 1)
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
print '23232323223'
								      INSERT INTO demrd_mak
														(demrd_id
														,demrd_demrm_id
														,demrd_folio_no
														,demrd_cert_no
														,demrd_distinctive_no_fr
														,demrd_distinctive_no_to
														,demrd_qty
														,demrd_status
														,demrd_rej_cd
														,demrd_rmks
														,demrd_created_by
														,demrd_created_dt
														,demrd_lst_upd_by
														,demrd_lst_upd_dt
														,demrd_deleted_ind 
														)VALUES
														(@l_id
														,CONVERT(INT,@currstring)
														,@l_folio_no  
														,@l_cert_no   
														,@l_disct_no_fr  
														,@l_disct_no_to 
														,convert(numeric(19,5),@l_qty)--@l_qty 
														,@l_status
														,@l_rej_cd
														,@l_rmks 
														,@pa_login_name
														,getdate()
														,@pa_login_name
														,getdate()
														,@l_deleted_ind
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
												ELSE IF @l_action = 'D'
												BEGIN
												--
														IF EXISTS(select * from demat_request_dtls where demrd_demrm_id = CONVERT(INT,@currstring) and demrd_deleted_ind = 1)
														BEGIN
														--
														  BEGIN TRANSACTION 
														  
														  INSERT INTO demrd_mak
																(demrd_id
																,demrd_demrm_id
																,demrd_folio_no
																,demrd_cert_no
																,demrd_distinctive_no_fr
																,demrd_distinctive_no_to
																,demrd_qty
																,demrd_status
																,demrd_rej_cd
																,demrd_rmks
																,demrd_created_by
																,demrd_created_dt
																,demrd_lst_upd_by
																,demrd_lst_upd_dt
																,demrd_deleted_ind 
																)
																select demrd_id
																,demrd_demrm_id
																,demrd_folio_no
																,demrd_cert_no
																,demrd_distinctive_no_fr
																,demrd_distinctive_no_to
																,demrd_qty
																,demrd_status
																,demrd_rej_cd
																,demrd_rmks
																,demrd_created_by
																,demrd_created_dt
																,@pa_login_name
																,getdate()
																,4
													   FROM demat_request_dtls 
													   WHERE demrd_id =  @l_id
													   and demrd_deleted_ind = 1
													   
													   
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
														ELSE
														BEGIN
														--
														  DELETE FROM demrd_mak WHERE demrd_id = @l_id
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
		
		
  SET @pa_errmsg = isnull(@t_errorstr,'') 
  IF left(ltrim(rtrim(@pa_errmsg)),5) <> 'ERROR'
		BEGIN
  --

    exec pr_checkslipno_demat '','DEMRM_SEL', @pa_dpm_dpid,@pa_dpam_acct_no,@pa_slp_sr_no,@pa_login_name,''
  --
  END
  
--
END

GO
