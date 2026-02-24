-- Object: PROCEDURE citrus_usr.PR_CHK_APP_IMPORT_bak_21032016
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--PR_NSDL_IMP_TRX 'HO','01' ,''
--update tmp_dp_trx_dtls set tmpdptd_acct_id ='12345678' , TMPDPTD_INTERNAL_REF_NO = ''
--DELETE  FROM DPTD_MAK

create PROCEDURE [citrus_usr].[PR_CHK_APP_IMPORT_bak_21032016] 
(@PA_CDSL_NSDL VARCHAR(25)
,@PA_EXCSM_ID INT
,@PA_TRX_TAB  VARCHAR(25)
,@PA_LOGIN_NAME VARCHAR(25)
,@pa_auto_yn char(1)
,@pa_task_id numeric
,@PA_ERRMSG varchar(1000) output )   
AS   
BEGIN  
--  
  declare @l_errorstr varchar(8000)
          ,@l_error varchar(20) 
   
  IF @PA_CDSL_NSDL = 'CDSL'
  BEGIN
  --
    IF @PA_TRX_TAB = 'OFFM'
    BEGIN
    --
    

      if exists(select dptdc_id from dptdc_mak, TMP_OFFM_BRK_UPD where dptdc_id = TMPBRK_INT_REF_NO and dptdc_created_by = @pa_login_name)
      begin 
         UPDATE filetask
						SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Checker Login and Maker Login must be different.'
						,      STATUS = 'FAILED' 
						WHERE  task_id = @pa_task_id
         return 
      end 

  BEGIN TRANSACTION

      INSERT INTO DP_TRX_DTLS_CDSL
						    (DPTDC_ID
										,DPTDC_DPAM_ID
										,DPTDC_REQUEST_DT
										,DPTDC_SLIP_NO
										,DPTDC_ISIN
										,DPTDC_BATCH_NO
										,DPTDC_LINE_NO
										,DPTDC_QTY
										,DPTDC_INTERNAL_REF_NO
										,DPTDC_TRANS_NO
										,DPTDC_MKT_TYPE
										,DPTDC_SETTLEMENT_NO
										,DPTDC_EXECUTION_DT
										,DPTDC_OTHER_SETTLEMENT_TYPE
										,DPTDC_OTHER_SETTLEMENT_NO
										,DPTDC_COUNTER_DP_ID
										,DPTDC_COUNTER_CMBP_ID
										,DPTDC_COUNTER_DEMAT_ACCT_NO
										,DPTDC_CREATED_BY
										,DPTDC_CREATED_DT
										,DPTDC_LST_UPD_BY
										,DPTDC_LST_UPD_DT
										,DPTDC_DELETED_IND 
										,dptdC_trastm_cd
										,DPTDC_DTLS_ID
										,DPTDC_BOOKING_NARRATION
										,DPTDC_BOOKING_TYPE
										,DPTDC_CONVERTED_QTY
										,DPTDC_REASON_CD
										,DPTDC_STATUS
										,DPTDC_INTERNAL_TRASTM
										,DPTDC_RMKS
										,DPTDC_BROKERBATCH_NO
										,DPTDC_BROKER_INTERNAL_REF_NO
										,DPTDC_CASH_TRF
						    )
						    select DPTDC_ID
									,DPTDC_DPAM_ID
									,DPTDC_REQUEST_DT
									,DPTDC_SLIP_NO
									,DPTDC_ISIN
									,DPTDC_BATCH_NO
									,DPTDC_LINE_NO
									,DPTDC_QTY
									,DPTDC_INTERNAL_REF_NO
									,DPTDC_TRANS_NO
									,DPTDC_MKT_TYPE
									,DPTDC_SETTLEMENT_NO
									,DPTDC_EXECUTION_DT
									,DPTDC_OTHER_SETTLEMENT_TYPE
									,DPTDC_OTHER_SETTLEMENT_NO
									,DPTDC_COUNTER_DP_ID
									,DPTDC_COUNTER_CMBP_ID
									,DPTDC_COUNTER_DEMAT_ACCT_NO
									,DPTDC_CREATED_BY
									,DPTDC_CREATED_DT
									,@PA_LOGIN_NAME
									,DPTDC_LST_UPD_DT
									,case when @pa_auto_yn = 'N' then case when dptdc_deleted_ind = 0 then 1 when dptdc_deleted_ind =  -1 then 0 end 
									      when @pa_auto_yn = 'Y' then 1 end 
									,dptdC_trastm_cd
									,DPTDC_DTLS_ID
									,DPTDC_BOOKING_NARRATION
									,DPTDC_BOOKING_TYPE
									,DPTDC_CONVERTED_QTY
									,DPTDC_REASON_CD
									,DPTDC_STATUS
									,DPTDC_INTERNAL_TRASTM
									,DPTDC_RMKS
									,DPTDC_BROKERBATCH_NO
									,DPTDC_BROKER_INTERNAL_REF_NO
									,DPTDC_CASH_TRF
									from dptdC_mak 
			      where dptdC_id in (select TMPBRK_INT_REF_NO  from TMP_OFFM_BRK_UPD)
			      AND   DPTDC_INTERNAL_TRASTM IN ('CMCM','BOCM','CMBO','BOBO')
			      and   case when @pa_auto_yn = 'N' then dptdc_deleted_ind else 0 end = 0
			      
			      IF @pa_auto_yn = 'N'
			      BEGIN
			      --
			        update dptdC_mak
			        set    dptdc_deleted_ind = case when dptdc_deleted_ind = -1 then 0 when dptdc_deleted_ind = 0 then 1 end 
															  ,dptdc_mid_chk = case when dptdc_deleted_ind = -1 then @pa_login_name  when dptdc_deleted_ind = 0 then null end 
															  ,dptdc_lst_upd_dt = getdate()
															  ,dptdc_lst_upd_by = case when dptdc_deleted_ind = -1 then  dptdc_lst_upd_by  when dptdc_deleted_ind = 0 then  @pa_login_name end 
			        where  dptdc_deleted_ind in (-1,0)
			        and    dptdC_id in (select TMPBRK_INT_REF_NO  from TMP_OFFM_BRK_UPD)
			        AND    DPTDC_INTERNAL_TRASTM IN ('CMCM','BOCM','CMBO','BOBO')
			      --
			      END
			      IF @pa_auto_yn = 'Y'
									BEGIN
									--
											update dptdC_mak
											set    dptdc_deleted_ind = 1
											,dptdc_mid_chk     = case when dptdc_deleted_ind = -1 then 'HO' else null end
											,dptdc_lst_upd_by  = @pa_login_name
											, dptdc_lst_upd_dt  = getdate()
											where  dptdc_deleted_ind in (-1,0)
											and    dptdC_id in (select TMPBRK_INT_REF_NO  from TMP_OFFM_BRK_UPD)
											AND    DPTDC_INTERNAL_TRASTM IN ('CMCM','BOCM','CMBO','BOBO')
									--
			      END
			      
			     SET @l_error = @@error
								--

								IF @l_error > 0
								BEGIN
								--
										SET @l_errorstr = '#'+'could not Uploaded'
										--
										ROLLBACK TRANSACTION
								--
								END
								ELSE
								BEGIN
								--
								SET @l_errorstr = 'Successfuly Uploaded'
								--
								COMMIT TRANSACTION
								--
								END 
    --
    END
    ELSE IF @PA_TRX_TAB = 'INTERDP'
    BEGIN
    --
     
      

      if exists(select dptdc_id from dptdc_mak, TMP_INTDP_BRK_UPD where dptdc_id = TMPBRK_INT_REF_NO and dptdc_created_by = @pa_login_name)
      begin 
         UPDATE filetask
						SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Checker Login and Maker Login must be different.'
						,      STATUS = 'FAILED' 
						WHERE  task_id = @pa_task_id
         return 
      end 

 BEGIN TRANSACTION


      INSERT INTO DP_TRX_DTLS_CDSL
						    (DPTDC_ID
										,DPTDC_DPAM_ID
										,DPTDC_REQUEST_DT
										,DPTDC_SLIP_NO
										,DPTDC_ISIN
										,DPTDC_BATCH_NO
										,DPTDC_LINE_NO
										,DPTDC_QTY
										,DPTDC_INTERNAL_REF_NO
										,DPTDC_TRANS_NO
										,DPTDC_MKT_TYPE
										,DPTDC_SETTLEMENT_NO
										,DPTDC_EXECUTION_DT
										,DPTDC_OTHER_SETTLEMENT_TYPE
										,DPTDC_OTHER_SETTLEMENT_NO
										,DPTDC_COUNTER_DP_ID
										,DPTDC_COUNTER_CMBP_ID
										,DPTDC_COUNTER_DEMAT_ACCT_NO
										,DPTDC_CREATED_BY
										,DPTDC_CREATED_DT
										,DPTDC_LST_UPD_BY
										,DPTDC_LST_UPD_DT
										,DPTDC_DELETED_IND 
										,dptdC_trastm_cd
										,DPTDC_DTLS_ID
										,DPTDC_BOOKING_NARRATION
										,DPTDC_BOOKING_TYPE
										,DPTDC_CONVERTED_QTY
										,DPTDC_REASON_CD
										,DPTDC_STATUS
										,DPTDC_INTERNAL_TRASTM
										,DPTDC_RMKS
										,DPTDC_BROKERBATCH_NO
										,DPTDC_BROKER_INTERNAL_REF_NO
										,DPTDC_CASH_TRF
						    )
						    select DPTDC_ID
									,DPTDC_DPAM_ID
									,DPTDC_REQUEST_DT
									,DPTDC_SLIP_NO
									,DPTDC_ISIN
									,DPTDC_BATCH_NO
									,DPTDC_LINE_NO
									,DPTDC_QTY
									,DPTDC_INTERNAL_REF_NO
									,DPTDC_TRANS_NO
									,DPTDC_MKT_TYPE
									,DPTDC_SETTLEMENT_NO
									,DPTDC_EXECUTION_DT
									,DPTDC_OTHER_SETTLEMENT_TYPE
									,DPTDC_OTHER_SETTLEMENT_NO
									,DPTDC_COUNTER_DP_ID
									,DPTDC_COUNTER_CMBP_ID
									,DPTDC_COUNTER_DEMAT_ACCT_NO
									,DPTDC_CREATED_BY
									,DPTDC_CREATED_DT
									,@PA_LOGIN_NAME
									,DPTDC_LST_UPD_DT
									,case when @pa_auto_yn = 'N' then case when dptdc_deleted_ind = 0 then 1 when dptdc_deleted_ind =  -1 then 0 end 
									      when @pa_auto_yn = 'Y' then 1 end 
									,dptdC_trastm_cd
									,DPTDC_DTLS_ID
									,DPTDC_BOOKING_NARRATION
									,DPTDC_BOOKING_TYPE
									,DPTDC_CONVERTED_QTY
									,DPTDC_REASON_CD
									,DPTDC_STATUS
									,DPTDC_INTERNAL_TRASTM
	  						,DPTDC_RMKS
									,DPTDC_BROKERBATCH_NO
									,DPTDC_BROKER_INTERNAL_REF_NO
									,DPTDC_CASH_TRF
									from dptdC_mak 
			      where dptdC_id in (select TMPBRK_INT_REF_NO  from TMP_INTDP_BRK_UPD)
			      AND   DPTDC_INTERNAL_TRASTM IN ('ID')
			      and   case when @pa_auto_yn = 'N' then dptdc_deleted_ind else 0 end = 0
			      
			      
			       IF @pa_auto_yn = 'N'
										BEGIN
										--
												update dptdC_mak
												set   dptdc_deleted_ind = case when dptdc_deleted_ind = -1 then 0 when dptdc_deleted_ind = 0 then 1 end 
															  ,dptdc_mid_chk = case when dptdc_deleted_ind = -1 then @pa_login_name  when dptdc_deleted_ind = 0 then null end 
															  ,dptdc_lst_upd_dt = getdate()
															  ,dptdc_lst_upd_by = case when dptdc_deleted_ind = -1 then  dptdc_lst_upd_by  when dptdc_deleted_ind = 0 then  @pa_login_name end 
			         where  dptdc_deleted_ind in (-1,0)
												and    dptdC_id in (select TMPBRK_INT_REF_NO  from TMP_INTDP_BRK_UPD)
											 AND   DPTDC_INTERNAL_TRASTM IN ('ID')
										--
			       END
			       IF @pa_auto_yn = 'Y'
										BEGIN
										--
												update dptdC_mak
												set    dptdc_deleted_ind = 1
																		,dptdc_mid_chk     = case when dptdc_deleted_ind = -1 then 'HO' else null end
																		,dptdc_lst_upd_dt  = getdate()
																		,dptdc_lst_upd_by  = @pa_login_name
												where  dptdc_deleted_ind  in (-1,0)
												and    dptdC_id in (select TMPBRK_INT_REF_NO  from TMP_INTDP_BRK_UPD)
												AND   DPTDC_INTERNAL_TRASTM IN ('ID')
										--
			       END
			      
			      
			      
			      SET @l_error = @@error
									--

									IF @l_error > 0
									BEGIN
									--
											SET @l_errorstr = '#'+'could not Uploaded'
											--
											ROLLBACK TRANSACTION
									--
									END
									ELSE
									BEGIN
									--
									SET @l_errorstr ='Successfuly Uploaded'
									--
									COMMIT TRANSACTION
									--
								END 
    --
    END
    ELSE IF @PA_TRX_TAB = 'EP'
				    BEGIN
				    --

  if exists(select dptdc_id from dptdc_mak, TMP_EP_BRK_UPD where dptdc_id = TMPBRK_INT_REF_NO and dptdc_created_by = @pa_login_name)
      begin 
         UPDATE filetask
						SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Checker Login and Maker Login must be different.'
						,      STATUS = 'FAILED' 
						WHERE  task_id = @pa_task_id
         return 
      end 


				      BEGIN TRANSACTION
				      
				      INSERT INTO DP_TRX_DTLS_CDSL
										    (DPTDC_ID
														,DPTDC_DPAM_ID
														,DPTDC_REQUEST_DT
														,DPTDC_SLIP_NO
														,DPTDC_ISIN
														,DPTDC_BATCH_NO
														,DPTDC_LINE_NO
														,DPTDC_QTY
														,DPTDC_INTERNAL_REF_NO
														,DPTDC_TRANS_NO
														,DPTDC_MKT_TYPE
														,DPTDC_SETTLEMENT_NO
														,DPTDC_EXECUTION_DT
														,DPTDC_OTHER_SETTLEMENT_TYPE
														,DPTDC_OTHER_SETTLEMENT_NO
														,DPTDC_COUNTER_DP_ID
														,DPTDC_COUNTER_CMBP_ID
														,DPTDC_COUNTER_DEMAT_ACCT_NO
														,DPTDC_CREATED_BY
														,DPTDC_CREATED_DT
														,DPTDC_LST_UPD_BY
														,DPTDC_LST_UPD_DT
														,DPTDC_DELETED_IND 
														,dptdC_trastm_cd
														,DPTDC_DTLS_ID
														,DPTDC_BOOKING_NARRATION
														,DPTDC_BOOKING_TYPE
														,DPTDC_CONVERTED_QTY
														,DPTDC_REASON_CD
														,DPTDC_STATUS
														,DPTDC_INTERNAL_TRASTM
														,DPTDC_RMKS
														,DPTDC_BROKERBATCH_NO
														,DPTDC_BROKER_INTERNAL_REF_NO
														,DPTDC_CASH_TRF
														,dptdc_excm_id
														,dptdc_cm_id
										    )
										    select DPTDC_ID
													,DPTDC_DPAM_ID
													,DPTDC_REQUEST_DT
													,DPTDC_SLIP_NO
													,DPTDC_ISIN
													,DPTDC_BATCH_NO
													,DPTDC_LINE_NO
													,DPTDC_QTY
													,DPTDC_INTERNAL_REF_NO
													,DPTDC_TRANS_NO
													,DPTDC_MKT_TYPE
													,DPTDC_SETTLEMENT_NO
													,DPTDC_EXECUTION_DT
													,DPTDC_OTHER_SETTLEMENT_TYPE
													,DPTDC_OTHER_SETTLEMENT_NO
													,DPTDC_COUNTER_DP_ID
													,DPTDC_COUNTER_CMBP_ID
													,DPTDC_COUNTER_DEMAT_ACCT_NO
													,DPTDC_CREATED_BY
													,DPTDC_CREATED_DT
													,@PA_LOGIN_NAME
													,DPTDC_LST_UPD_DT
													,case when @pa_auto_yn = 'N' then case when dptdc_deleted_ind = 0 then 1 when dptdc_deleted_ind =  -1 then 0 end 
													      when @pa_auto_yn = 'Y' then 1 end 
													,dptdC_trastm_cd
													,DPTDC_DTLS_ID
													,DPTDC_BOOKING_NARRATION
													,DPTDC_BOOKING_TYPE
													,DPTDC_CONVERTED_QTY
													,DPTDC_REASON_CD
													,DPTDC_STATUS
													,DPTDC_INTERNAL_TRASTM
					  						,DPTDC_RMKS
													,DPTDC_BROKERBATCH_NO
													,DPTDC_BROKER_INTERNAL_REF_NO
													,DPTDC_CASH_TRF
													,dptdc_excm_id
													,dptdc_cm_id
													from dptdC_mak 
							      where dptdC_id in (select TMPBRK_INT_REF_NO  from TMP_EP_BRK_UPD)
							      AND   DPTDC_INTERNAL_TRASTM IN ('EP')
							      and   case when @pa_auto_yn = 'N' then dptdc_deleted_ind else 0 end = 0
							      
							      
							       IF @pa_auto_yn = 'N'
														BEGIN
														--
																update dptdC_mak
																set    dptdc_deleted_ind = case when dptdc_deleted_ind = -1 then 0 when dptdc_deleted_ind = 0 then 1 end 
															  ,dptdc_mid_chk = case when dptdc_deleted_ind = -1 then @pa_login_name  when dptdc_deleted_ind = 0 then null end 
															  ,dptdc_lst_upd_dt = getdate()
															  ,dptdc_lst_upd_by = case when dptdc_deleted_ind = -1 then  dptdc_lst_upd_by  when dptdc_deleted_ind = 0 then  @pa_login_name end 
							         where  dptdc_deleted_ind in (-1,0)
																and    dptdC_id in (select TMPBRK_INT_REF_NO  from TMP_EP_BRK_UPD)
															 AND   DPTDC_INTERNAL_TRASTM IN ('EP')
														--
							       END
							       IF @pa_auto_yn = 'Y'
														BEGIN
														--
																update dptdC_mak
																set    dptdc_deleted_ind = 1
																						,dptdc_mid_chk   =  case when dptdc_deleted_ind = -1 then 'HO' else null end
																						,dptdc_lst_upd_dt  = getdate()
																						,dptdc_lst_upd_by  = @pa_login_name
																where  dptdc_deleted_ind  in (-1,0)
																and    dptdC_id in (select TMPBRK_INT_REF_NO  from TMP_EP_BRK_UPD)
																AND   DPTDC_INTERNAL_TRASTM IN ('EP')
														--
							       END
							      
							      
							      
							      SET @l_error = @@error
													--
				
													IF @l_error > 0
													BEGIN
													--
															SET @l_errorstr = '#'+'could not Uploaded'
															--
															ROLLBACK TRANSACTION
													--
													END
													ELSE
													BEGIN
													--
													SET @l_errorstr ='Successfuly Uploaded'
													--
													COMMIT TRANSACTION
													--
												END 
				    --
    END
    ELSE IF @PA_TRX_TAB = 'NP'
				    BEGIN
				    --

 if exists(select dptdc_id from dptdc_mak, TMP_NP_BRK_UPD where dptdc_id = TMPBRK_INT_REF_NO and dptdc_created_by = @pa_login_name)
      begin 
         UPDATE filetask
						SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Checker Login and Maker Login must be different.'
						,      STATUS = 'FAILED' 
						WHERE  task_id = @pa_task_id
         return 
      end 


				      BEGIN TRANSACTION
				      
				      INSERT INTO DP_TRX_DTLS_CDSL
										    (DPTDC_ID
														,DPTDC_DPAM_ID
														,DPTDC_REQUEST_DT
														,DPTDC_SLIP_NO
														,DPTDC_ISIN
														,DPTDC_BATCH_NO
														,DPTDC_LINE_NO
														,DPTDC_QTY
														,DPTDC_INTERNAL_REF_NO
														,DPTDC_TRANS_NO
														,DPTDC_MKT_TYPE
														,DPTDC_SETTLEMENT_NO
														,DPTDC_EXECUTION_DT
														,DPTDC_OTHER_SETTLEMENT_TYPE
														,DPTDC_OTHER_SETTLEMENT_NO
														,DPTDC_COUNTER_DP_ID
														,DPTDC_COUNTER_CMBP_ID
														,DPTDC_COUNTER_DEMAT_ACCT_NO
														,DPTDC_CREATED_BY
														,DPTDC_CREATED_DT
														,DPTDC_LST_UPD_BY
														,DPTDC_LST_UPD_DT
														,DPTDC_DELETED_IND 
														,dptdC_trastm_cd
														,DPTDC_DTLS_ID
														,DPTDC_BOOKING_NARRATION
														,DPTDC_BOOKING_TYPE
														,DPTDC_CONVERTED_QTY
														,DPTDC_REASON_CD
														,DPTDC_STATUS
														,DPTDC_INTERNAL_TRASTM
														,DPTDC_RMKS
														,DPTDC_BROKERBATCH_NO
														,DPTDC_BROKER_INTERNAL_REF_NO
														,DPTDC_CASH_TRF
														,dptdc_excm_id
                                                        ,dptdc_cm_id
										    )
										    select DPTDC_ID
													,DPTDC_DPAM_ID
													,DPTDC_REQUEST_DT
													,DPTDC_SLIP_NO
													,DPTDC_ISIN
													,DPTDC_BATCH_NO
													,DPTDC_LINE_NO
													,DPTDC_QTY
													,DPTDC_INTERNAL_REF_NO
													,DPTDC_TRANS_NO
													,DPTDC_MKT_TYPE
													,DPTDC_SETTLEMENT_NO
													,DPTDC_EXECUTION_DT
													,DPTDC_OTHER_SETTLEMENT_TYPE
													,DPTDC_OTHER_SETTLEMENT_NO
													,DPTDC_COUNTER_DP_ID
													,DPTDC_COUNTER_CMBP_ID
													,DPTDC_COUNTER_DEMAT_ACCT_NO
													,DPTDC_CREATED_BY
													,DPTDC_CREATED_DT
													,@PA_LOGIN_NAME
													,DPTDC_LST_UPD_DT
													,case when @pa_auto_yn = 'N' then case when dptdc_deleted_ind = 0 then 1 when dptdc_deleted_ind =  -1 then 0 end 
													      when @pa_auto_yn = 'Y' then 1 end 
													,dptdC_trastm_cd
													,DPTDC_DTLS_ID
													,DPTDC_BOOKING_NARRATION
													,DPTDC_BOOKING_TYPE
													,DPTDC_CONVERTED_QTY
													,DPTDC_REASON_CD
													,DPTDC_STATUS
													,DPTDC_INTERNAL_TRASTM
					  						,DPTDC_RMKS
													,DPTDC_BROKERBATCH_NO
													,DPTDC_BROKER_INTERNAL_REF_NO
													,DPTDC_CASH_TRF
													,dptdc_excm_id
													,dptdc_cm_id
													from dptdC_mak 
							      where dptdC_id in (select TMPBRK_INT_REF_NO  from TMP_NP_BRK_UPD)
							      AND   DPTDC_INTERNAL_TRASTM IN ('NP')
							      and   case when @pa_auto_yn = 'N' then dptdc_deleted_ind else 0 end = 0
							      
							      
							       IF @pa_auto_yn = 'N'
														BEGIN
														--
																update dptdC_mak
																set     dptdc_deleted_ind = case when dptdc_deleted_ind = -1 then 0 when dptdc_deleted_ind = 0 then 1 end 
															  ,dptdc_mid_chk = case when dptdc_deleted_ind = -1 then @pa_login_name  when dptdc_deleted_ind = 0 then null end 
															  ,dptdc_lst_upd_dt = getdate()
															  ,dptdc_lst_upd_by = case when dptdc_deleted_ind = -1 then  dptdc_lst_upd_by  when dptdc_deleted_ind = 0 then  @pa_login_name end 
							                                  where  dptdc_deleted_ind in (-1,0)
																and    dptdC_id in (select TMPBRK_INT_REF_NO  from TMP_NP_BRK_UPD)
															 AND   DPTDC_INTERNAL_TRASTM IN ('NP')
														--
							       END
							       IF @pa_auto_yn = 'Y'
														BEGIN
														--
																update dptdC_mak
																set    dptdc_deleted_ind = 1
																						,dptdc_mid_chk     = case when dptdc_deleted_ind = -1 then 'HO' else null end
																						,dptdc_lst_upd_dt  = getdate()
																						,dptdc_lst_upd_by  = @pa_login_name
																where  dptdc_deleted_ind  in (-1,0)
																and    dptdC_id in (select TMPBRK_INT_REF_NO  from TMP_NP_BRK_UPD)
																AND   DPTDC_INTERNAL_TRASTM IN ('NP')
														--
							       END
							      
							      
							      
							      SET @l_error = @@error
													--
				
													IF @l_error > 0
													BEGIN
													--
															SET @l_errorstr = '#'+'could not Uploaded'
															--
															ROLLBACK TRANSACTION
													--
													END
													ELSE
													BEGIN
													--
													SET @l_errorstr ='Successfuly Uploaded'
													--
													COMMIT TRANSACTION
													--
												END 
				    --
    END
    
    
    
  --
  END
  ELSE IF @PA_CDSL_NSDL = 'NSDL'
  BEGIN
  --


 if exists(select dptdc_id from dptdc_mak, TMP_NSDL_BRK_UPD where dptdc_id = TMPBRK_INT_REF_NO and dptdc_created_by = @pa_login_name)
      begin 
         UPDATE filetask
						SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Checker Login and Maker Login must be different.'
						,      STATUS = 'FAILED' 
						WHERE  task_id = @pa_task_id
         return 
      end 

    BEGIN TRANSACTION
    
    INSERT INTO DP_TRX_DTLS
    (DPTD_ID
				,DPTD_DPAM_ID
				,DPTD_REQUEST_DT
				,DPTD_SLIP_NO
				,DPTD_ISIN
				,DPTD_BATCH_NO
				,DPTD_LINE_NO
				,DPTD_QTY
				,DPTD_INTERNAL_REF_NO
				,DPTD_TRANS_NO
				,DPTD_MKT_TYPE
				,DPTD_SETTLEMENT_NO
				,DPTD_EXECUTION_DT
				,DPTD_OTHER_SETTLEMENT_TYPE
				,DPTD_OTHER_SETTLEMENT_NO
				,DPTD_COUNTER_DP_ID
				,DPTD_COUNTER_CMBP_ID
				,DPTD_COUNTER_DEMAT_ACCT_NO
				,DPTD_CREATED_BY
				,DPTD_CREATED_DT
				,DPTD_LST_UPD_BY
				,DPTD_LST_UPD_DT
				,DPTD_DELETED_IND 
				,dptd_trastm_cd
				,DPTD_DTLS_ID
				,DPTD_BOOKING_NARRATION
				,DPTD_BOOKING_TYPE
				,DPTD_CONVERTED_QTY
				,DPTD_REASON_CD
				,DPTD_STATUS
				,DPTD_INTERNAL_TRASTM
				,dptd_others_cl_name
				,DPTD_RMKS
				,DPTD_BROKERBATCH_NO
				,DPTD_BROKER_INTERNAL_REF_NO
    )
    select DPTD_ID
			,DPTD_DPAM_ID
			,DPTD_REQUEST_DT
			,DPTD_SLIP_NO
			,DPTD_ISIN
			,DPTD_BATCH_NO
			,DPTD_LINE_NO
			,DPTD_QTY
			,DPTD_INTERNAL_REF_NO
			,DPTD_TRANS_NO
			,DPTD_MKT_TYPE
			,DPTD_SETTLEMENT_NO
			,DPTD_EXECUTION_DT
			,DPTD_OTHER_SETTLEMENT_TYPE
			,DPTD_OTHER_SETTLEMENT_NO
			,DPTD_COUNTER_DP_ID
			,DPTD_COUNTER_CMBP_ID
			,DPTD_COUNTER_DEMAT_ACCT_NO
			,DPTD_CREATED_BY
			,DPTD_CREATED_DT
			,@PA_LOGIN_NAME
			,DPTD_LST_UPD_DT
			,case when @pa_auto_yn = 'N' then case when dptd_deleted_ind = 0 then 1 when dptd_deleted_ind =  -1 then 0 end 
									      when @pa_auto_yn = 'Y' then 1 end 
			,dptd_trastm_cd
			,DPTD_DTLS_ID
			,DPTD_BOOKING_NARRATION
			,DPTD_BOOKING_TYPE
			,DPTD_CONVERTED_QTY
			,DPTD_REASON_CD
			,DPTD_STATUS
			,DPTD_INTERNAL_TRASTM
			,dptd_others_cl_name
			,DPTD_RMKS
			,DPTD_BROKERBATCH_NO
			,DPTD_BROKER_INTERNAL_REF_NO
			from dptd_mak 
			where dptd_id in (select TMPBRK_INT_REF_NO  from TMP_NSDL_BRK_UPD)
			and   case when @pa_auto_yn = 'N' then dptd_deleted_ind else 0 end = 0

			 IF @pa_auto_yn = 'N'
				BEGIN
				--
						update dptd_mak
						set    dptd_deleted_ind = case when dptd_deleted_ind = -1 then 0 when dptd_deleted_ind = 0 then 1 end 
						      ,dptd_mid_chk = case when dptd_deleted_ind = -1 then @pa_login_name  when dptd_deleted_ind = 0 then null end 
						      ,dptd_lst_upd_dt = getdate()
                              ,dptd_lst_upd_by = case when dptd_deleted_ind = -1 then  dptd_lst_upd_by  when dptd_deleted_ind = 0 then  @pa_login_name end 
						where  dptd_id in (select TMPBRK_INT_REF_NO  from TMP_NSDL_BRK_UPD)
                        and    dptd_deleted_ind in (-1,0)

				--
			 END
			 IF @pa_auto_yn = 'Y'
				BEGIN
				--
						update dptd_mak
						set    dptd_deleted_ind = 1
												,dptd_mid_chk = case when dptd_deleted_ind = -1 then 'HO' else null end
												,dptd_lst_upd_by = @pa_login_name
												,dptd_lst_upd_dt = getdate()
						where  dptd_deleted_ind  in (-1,0)
						and   dptd_id in (select TMPBRK_INT_REF_NO  from TMP_NSDL_BRK_UPD)

				--
			 END
			      
			      
    SET @l_error = @@error
				--

				IF @l_error > 0
				BEGIN
				--
						SET @l_errorstr = '#'+'could not Uploaded'
						--
						ROLLBACK TRANSACTION
				--
				END
				ELSE
				BEGIN
				--
				SET @l_errorstr = 'Successfuly Uploaded'
				--
				COMMIT TRANSACTION
				--
    END 

    
    
  --
  END
  
  set @pa_errmsg = @l_errorstr 
  
--  
END

GO
