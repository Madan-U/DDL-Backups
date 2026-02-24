-- Object: PROCEDURE citrus_usr.pr_trx_cdsl_response_bak_30102015
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------




create procedure [citrus_usr].[pr_trx_cdsl_response_bak_30102015]( @pa_exch          VARCHAR(20)  
									,@pa_login_name    VARCHAR(20)  
									,@pa_mode          VARCHAR(10)  	
									,@pa_tab           VARCHAR(25)
									,@pa_db_source     VARCHAR(250)  
									,@pa_excsm_id      int
									,@pa_batchno      varchar(25)
									,@pa_batchstatus   varchar(10)
									,@rowdelimiter     CHAR(4) =     '*|~*'    
									,@coldelimiter     CHAR(4) =     '|*~|'    
									,@pa_errmsg        VARCHAR(8000) output  
																							  )    
																																			                  
AS  
begin
--
declare  @L_DPM_ID numeric(10,0)
 SELECT @L_DPM_ID = DPM_ID FROM DP_MSTR WHERE DEFAULT_DP = @PA_EXCSM_ID AND DPM_DELETED_IND =1  
 
 
  IF @pa_mode = 'BULK'
		BEGIN
		--
       create table #tmp_dpmresponse_source(value varchar(8000))
							
       DECLARE @@ssql varchar(8000)
							SET @@ssql ='BULK INSERT DP.CITRUS_USR.#tmp_dpmresponse_source from ''' + @pa_db_source + ''' WITH 
							(
											ROWTERMINATOR = ''\n''	
							)'

							EXEC(@@ssql)
							
							update #tmp_dpmresponse_source set value = ltrim(rtrim(value)) 
							
							
							
							IF @pa_tab= 'OFFM'
							begin
							--
							  TRUNCATE TABLE TMP_OFFMKT_CDSL

							
							  insert into TMP_OFFMKT_CDSL 
							  select citrus_usr.fn_splitval_by(value,1,'~')
							        ,citrus_usr.fn_splitval_by(value,2,'~')
							        ,citrus_usr.fn_splitval_by(value,3,'~')
							        ,citrus_usr.fn_splitval_by(value,4,'~')
							        ,citrus_usr.fn_splitval_by(value,5,'~')
							        ,citrus_usr.fn_splitval_by(value,6,'~')
							        ,citrus_usr.fn_splitval_by(value,7,'~')
							        ,citrus_usr.fn_splitval_by(value,8,'~')
							        ,citrus_usr.fn_splitval_by(value,9,'~')
							        ,citrus_usr.fn_splitval_by(value,10,'~')
							        ,citrus_usr.fn_splitval_by(value,11,'~')
							        ,citrus_usr.fn_splitval_by(value,12,'~')
							        ,citrus_usr.fn_splitval_by(value,13,'~')
							        ,citrus_usr.fn_splitval_by(value,14,'~')
							        ,citrus_usr.fn_splitval_by(value,15,'~')
							        ,citrus_usr.fn_splitval_by(value,16,'~')
							        ,citrus_usr.fn_splitval_by(value,17,'~')
							   FROM  #tmp_dpmresponse_source   
							--
							END
							ELSE IF @pa_tab= 'ID'
							begin
							--
							  TRUNCATE TABLE TMP_INTERDP_CDSL
							
							  insert into TMP_INTERDP_CDSL 
							  select citrus_usr.fn_splitval_by(value,1,'~')
							        ,citrus_usr.fn_splitval_by(value,2,'~')
							        ,citrus_usr.fn_splitval_by(value,3,'~')
							        ,citrus_usr.fn_splitval_by(value,4,'~')
							        ,citrus_usr.fn_splitval_by(value,5,'~')
							        ,citrus_usr.fn_splitval_by(value,6,'~')
							        ,citrus_usr.fn_splitval_by(value,7,'~')
							        ,citrus_usr.fn_splitval_by(value,8,'~')
							        ,citrus_usr.fn_splitval_by(value,9,'~')
							        ,citrus_usr.fn_splitval_by(value,10,'~')
							        ,citrus_usr.fn_splitval_by(value,11,'~')
							        ,citrus_usr.fn_splitval_by(value,12,'~')
							        ,citrus_usr.fn_splitval_by(value,13,'~')
							        ,citrus_usr.fn_splitval_by(value,14,'~')
							   FROM  #tmp_dpmresponse_source   
							--
							END
							ELSE IF @pa_tab= 'EP'
							begin
							--
									TRUNCATE TABLE TMP_EP_CDSL

									insert into TMP_EP_CDSL 
									select citrus_usr.fn_splitval_by(value,1,'~')
															,citrus_usr.fn_splitval_by(value,2,'~')
															,citrus_usr.fn_splitval_by(value,3,'~')
															,citrus_usr.fn_splitval_by(value,4,'~')
															,citrus_usr.fn_splitval_by(value,5,'~')
															,citrus_usr.fn_splitval_by(value,6,'~')
															,citrus_usr.fn_splitval_by(value,7,'~')
															,citrus_usr.fn_splitval_by(value,8,'~')
															,citrus_usr.fn_splitval_by(value,9,'~')
															,citrus_usr.fn_splitval_by(value,10,'~')
															,citrus_usr.fn_splitval_by(value,11,'~')
															,citrus_usr.fn_splitval_by(value,12,'~')
										FROM  #tmp_dpmresponse_source   
							--
							END
	      ELSE IF @pa_tab= 'NP'
							begin
							--
									TRUNCATE TABLE TMP_ONMKT_CDSL

									insert into TMP_ONMKT_CDSL 
									select citrus_usr.fn_splitval_by(value,1,'~')
															,citrus_usr.fn_splitval_by(value,2,'~')
															,citrus_usr.fn_splitval_by(value,3,'~')
															,citrus_usr.fn_splitval_by(value,4,'~')
															,citrus_usr.fn_splitval_by(value,5,'~')
															,citrus_usr.fn_splitval_by(value,6,'~')
															,citrus_usr.fn_splitval_by(value,7,'~')
															,citrus_usr.fn_splitval_by(value,8,'~')
															,citrus_usr.fn_splitval_by(value,9,'~')
															,citrus_usr.fn_splitval_by(value,10,'~')
															,citrus_usr.fn_splitval_by(value,11,'~')
															,citrus_usr.fn_splitval_by(value,12,'~')
															,citrus_usr.fn_splitval_by(value,13,'~')
															,citrus_usr.fn_splitval_by(value,14,'~')
															,citrus_usr.fn_splitval_by(value,15,'~')
										FROM  #tmp_dpmresponse_source   
							--
							END							
							ELSE IF @pa_tab= 'DEMAT'
							begin
							--
									TRUNCATE TABLE TMP_demat_CDSL

									 insert into TMP_demat_CDSL 
									 select citrus_usr.fn_splitval_by(value,1,'~')
															,citrus_usr.fn_splitval_by(value,2,'~')
															,citrus_usr.fn_splitval_by(value,3,'~')
															,citrus_usr.fn_splitval_by(value,4,'~')
															,citrus_usr.fn_splitval_by(value,5,'~')
															,citrus_usr.fn_splitval_by(value,6,'~')
															,citrus_usr.fn_splitval_by(value,7,'~')
										FROM  #tmp_dpmresponse_source   
							--
							END						
							      
		--
		END

  IF @pa_tab= 'OFFM'
  BEGIN
  --
				UPDATE D 
				SET    DPTDC_TRANS_NO = TMPOFFMKT_CDSL_TXN_ID
										,DPTDC_STATUS   = case when TMPOFFMKT_CDSL_SETT_STAT_FLG = '0' then 'P' when TMPOFFMKT_CDSL_SETT_STAT_FLG = '1' then 'S' when TMPOFFMKT_CDSL_SETT_STAT_FLG = '2' then 'F' when TMPOFFMKT_CDSL_SETT_STAT_FLG = '4' then 'O'  end
										,DPTDC_ERRMSG   = TMPOFFMKT_CDSL_ERR_MESG
				FROM   DP_TRX_DTLS_CDSl D 
										,TMP_OFFMKT_CDSL  T  
				WHERE  DPTDC_ID             = convert(numeric,citrus_usr.fn_splitval_by(TMPOFFMKT_CDSL_INT_REFNO+'/',2,'/'))
				
				
				UPDATE BATCHNO_CDSL_MSTR SET BATCHC_STATUS = 'I'
				WHERE  BATCHC_NO = @PA_BATCHNO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_TRANS_TYPE = 'OFFM'
  --
  END
  IF @pa_tab= 'ID'
		BEGIN
		--
				UPDATE D 
				SET    DPTDC_TRANS_NO = TMPIDP_CDSL_SNDR_TXN_REFNO
										,DPTDC_STATUS   = case when ltrim(rtrim(TMPIDP_CDSL_ERR_MESG)) = ''  then 'S' else 'F'  end
										,DPTDC_ERRMSG   = TMPIDP_CDSL_ERR_MESG
				FROM   DP_TRX_DTLS_CDSl D 
										,TMP_INTERDP_CDSL  T  
				WHERE  DPTDC_ID              = convert(numeric,citrus_usr.fn_splitval_by(TMPIDP_CDSL_INT_REFNO+'/',2,'/')) 
				
				
				UPDATE BATCHNO_CDSL_MSTR SET BATCHC_STATUS = 'I'
				WHERE  BATCHC_NO = @PA_BATCHNO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_TRANS_TYPE = 'ID'
		--
  END
  IF @pa_tab= 'EP'
		BEGIN
		--
				UPDATE D 
				SET    DPTDC_TRANS_NO = TMPEP_CDSL_TXN_ID
										,DPTDC_STATUS   = case when ltrim(rtrim(TMPEP_CDSL_ERR_CODE)) = ''  then 'S' else 'F'  end
				FROM   DP_TRX_DTLS_CDSl D 
										,TMP_EP_CDSL  T  
				WHERE  DPTDC_ID              = convert(numeric,citrus_usr.fn_splitval_by(TMPEP_CDSL_INT_REFNO+'/',2,'/'))  
				
				UPDATE BATCHNO_CDSL_MSTR SET BATCHC_STATUS = 'I'
				WHERE  BATCHC_NO = @PA_BATCHNO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_TRANS_TYPE = 'EP'
		--
  END
  IF @pa_tab= 'NP'
		BEGIN
		--
				UPDATE D 
				SET    DPTDC_TRANS_NO = TMPONMKT_CDSL_TXN_ID
										,DPTDC_STATUS   = case when ltrim(rtrim(TMPONMKT_CDSL_ERR_MESG)) = ''  then 'S' else 'F'  end
										,DPTDC_ERRMSG   = TMPONMKT_CDSL_ERR_MESG
				FROM   DP_TRX_DTLS_CDSl D 
										,TMP_ONMKT_CDSL   T  
				WHERE  DPTDC_ID              = convert(numeric,citrus_usr.fn_splitval_by(TMPONMKT_CDSL_INT_REFNO+'/',2,'/'))   
				
				UPDATE BATCHNO_CDSL_MSTR SET BATCHC_STATUS = 'I'
				WHERE  BATCHC_NO = @PA_BATCHNO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_TRANS_TYPE = 'NP'
		--
  END
  IF @pa_tab= 'DEMAT'  -- for all common types updated here
		BEGIN
		--
--				UPDATE D 
--				SET  demrm_status   = case when ltrim(rtrim(TMPDMT_Err_Mesg)) = ''  then 'S' else 'F'  end
--					,demrm_converted_qty = case when ltrim(rtrim(TMPDMT_Err_Mesg)) = ''  then tmpdmt_drf_qty ELSE demrm_converted_qty END
--					,demrm_transaction_no= tmpdmt_drn
--					,demrm_errmsg   = tmpdmt_err_mesg
--				FROM   demat_request_mstr D 
--						,TMP_demat_CDSL   T  
--				WHERE  demrm_slip_serial_no = tmpdmt_drf_no
--
--				UPDATE BATCHNO_CDSL_MSTR SET BATCHC_STATUS = 'I'
--				WHERE  BATCHC_NO = @PA_BATCHNO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_TRANS_TYPE = 'DMAT'
				
		--common for DMAT
				UPDATE D 
				SET  demrm_status   = case when ltrim(rtrim(TMPC_ERROR_CODE)) = ''  then 'S' else 'F'  end
					,demrm_converted_qty = case when ltrim(rtrim(TMPC_ERROR_CODE)) = ''  then TMPC_QUANTITY ELSE demrm_converted_qty END
					,demrm_transaction_no= TMPC_TRX_NO
					,demrm_errmsg   = TMPC_ERROR_CODE
				FROM   demat_request_mstr D 
						,TMP_COMMON_TRX_RESP_MSTR   T  
				WHERE  demrm_slip_serial_no = case when citrus_usr.fn_splitval_by(TMPC_DMT_DESTAT_FORM_NO+'/',2,'/') <> '' then citrus_usr.fn_splitval_by(TMPC_DMT_DESTAT_FORM_NO+'/',2,'/')  else TMPC_DMT_DESTAT_FORM_NO end--citrus_usr.fn_splitval_by(TMPC_DMT_DESTAT_FORM_NO+'/',2,'/') 
				and TMPC_UPLOAD_TYPE = 1

				--UPDATE BATCHNO_CDSL_MSTR SET BATCHC_STATUS = 'I'
				--WHERE  BATCHC_NO = @PA_BATCHNO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_TRANS_TYPE = 'DMAT'
--end common for DMAT
								
				/*common file format updation for DESTAT*/
				UPDATE D 
				SET  demrm_status   = case when ltrim(rtrim(TMPC_ERROR_CODE)) = ''  then 'S' else 'F'  end
					,demrm_converted_qty = case when ltrim(rtrim(TMPC_ERROR_CODE)) = ''  then TMPC_QUANTITY ELSE TMPC_VERF_ACCP_QTY_MFAMT END
					,demrm_transaction_no= TMPC_TRX_NO
					,demrm_errmsg   = TMPC_ERROR_CODE
				FROM   demat_request_mstr D 
						,TMP_COMMON_TRX_RESP_MSTR   T  
				WHERE  demrm_slip_serial_no = TMPC_DMT_DESTAT_FORM_NO and demrm_typeofsec='MUTUAL FUND'
				and TMPC_UPLOAD_TYPE = 21

				UPDATE BATCHNO_CDSL_MSTR SET BATCHC_STATUS = 'I'
				WHERE  BATCHC_NO = abs(@PA_BATCHNO) AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_TRANS_TYPE = 'DESTAT'				
				/*common file format updation*/

		/*common file format updation for ID*/
		
				UPDATE D 
				SET    DPTDC_TRANS_NO = TMPC_TRX_NO
										,DPTDC_STATUS   = case when ltrim(rtrim(TMPC_ERROR_CODE)) = ''  then 'S' else 'F'  end
										,DPTDC_ERRMSG   = TMPC_ERROR_CODE
				FROM   DP_TRX_DTLS_CDSl D 
										,TMP_COMMON_TRX_RESP_MSTR  T  
				WHERE  DPTDC_ID              = convert(numeric,citrus_usr.fn_splitval_by(TMPC_INT_REF_NO+'/',2,'/')) 
				and TMPC_UPLOAD_TYPE = 4
				
				
				--UPDATE BATCHNO_CDSL_MSTR SET BATCHC_STATUS = 'I'
				--WHERE  BATCHC_NO = @PA_BATCHNO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_TRANS_TYPE = 'ID'

--UPDATE BATCHNO_CDSL_MSTR SET BATCHC_STATUS = 'I'
--				WHERE  BATCHC_NO = @PA_BATCHNO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_TRANS_TYPE = 'ALL'
			/*common file format updation for ID*/
	
			/*common for OFFM */
			

				UPDATE D 
				SET    DPTDC_TRANS_NO = TMPC_TRX_NO
										,DPTDC_STATUS   = case when TMPC_SETTLE_STATUS_FLG = '0' then 'P' when TMPC_SETTLE_STATUS_FLG = '1' then 'S' when TMPC_SETTLE_STATUS_FLG = '2' then 'F' when TMPC_SETTLE_STATUS_FLG = '4' then 'O'  end
										,DPTDC_ERRMSG   = TMPC_ERROR_CODE
				FROM   DP_TRX_DTLS_CDSl D 
										,TMP_COMMON_TRX_RESP_MSTR  T  
				WHERE  DPTDC_ID             = convert(numeric,citrus_usr.fn_splitval_by(TMPC_INT_REF_NO+'/',2,'/'))
				and TMPC_UPLOAD_TYPE = 5
				
				
				--UPDATE BATCHNO_CDSL_MSTR SET BATCHC_STATUS = 'I'
				--WHERE  BATCHC_NO = @PA_BATCHNO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_TRANS_TYPE = 'OFFM'

--UPDATE BATCHNO_CDSL_MSTR SET BATCHC_STATUS = 'I'
--				WHERE  BATCHC_NO = @PA_BATCHNO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_TRANS_TYPE = 'ALL'
			/*end of common for offm */

		--common for NP
		
		UPDATE D 
				SET    DPTDC_TRANS_NO = TMPC_TRX_NO
										,DPTDC_STATUS   = case when ltrim(rtrim(TMPC_ERROR_CODE)) = ''  then 'S' else 'F'  end
										,DPTDC_ERRMSG   = TMPC_ERROR_CODE
				FROM   DP_TRX_DTLS_CDSl D 
										,TMP_COMMON_TRX_RESP_MSTR   T  
				WHERE  DPTDC_ID              = convert(numeric,citrus_usr.fn_splitval_by(TMPC_INT_REF_NO+'/',2,'/'))   
				and TMPC_UPLOAD_TYPE = 3

				--UPDATE BATCHNO_CDSL_MSTR SET BATCHC_STATUS = 'I'
				--WHERE  BATCHC_NO = @PA_BATCHNO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_TRANS_TYPE = 'NP'
--end comon for NP
---common for pledge
	UPDATE D 
				SET  PLDTC_STATUS   = case when ltrim(rtrim(TMPC_ERROR_CODE)) = ''  then 'S' else 'F'  end					
					,PLDTC_TRANS_NO = TMPC_TRX_NO
				FROM cdsl_pledge_dtls D 
					  ,TMP_COMMON_TRX_RESP_MSTR   T  
				WHERE  PLDTC_ID = convert(numeric,citrus_usr.fn_splitval_by(TMPC_INT_REF_NO+'/',1,'/'))   
		and TMPC_UPLOAD_TYPE = 7
					--convert(numeric,citrus_usr.fn_splitval_by(TMPDPMPLDG_PLEDGOR_INTREFNO+'/',2,'/'))  --TMPDPMPLDG_PLEDGOR_INTREFNO
			
---end common for pledge

---common for EP

				UPDATE D 
				SET    DPTDC_TRANS_NO = TMPC_TRX_NO
				,DPTDC_STATUS   = case when ltrim(rtrim(TMPC_ERROR_CODE)) = ''  then 'S' else 'F'  end
				FROM   DP_TRX_DTLS_CDSl D 
					  ,TMP_COMMON_TRX_RESP_MSTR  T  
				WHERE  DPTDC_ID = convert(numeric,citrus_usr.fn_splitval_by(TMPC_INT_REF_NO+'/',2,'/')) 
				and TMPC_UPLOAD_TYPE = 10 
--end common for EP


--For Slip issuance only - 39
                UPDATE D 
				SET    SLIIM_SUCCESS_FLAG   = case when ltrim(rtrim(TMPC_ERROR_CODE)) = ''  then 'S' else 'F'  end
				,SLIIM_ERROR_CODE = ISNULL(TMPC_ERROR_CODE,'')
				,SLIIM_DT=TMPC_BUS_TRX_DT
				FROM   SLIP_ISSUE_MSTR D 
					  ,TMP_COMMON_TRX_RESP_MSTR  T  
				WHERE  SLIIM_DPAM_ACCT_NO = TMPC_BOID_PLEDGORBOID 
				--and TMPC_INT_REF_NO= SLIIM_SLIP_NO_TO-- isnull(citrus_usr.Fn_toSliptype_BookName(TMPC_CONF_ACCP_QTY,'',''),'')
				and TMPC_UPLOAD_TYPE = 39 
				and TMPC_VERF_REJ_QUY=SLIIM_SLIP_NO_FR and TMPC_CONF_ACCP_QTY=SLIIM_SLIP_NO_TO
				and ISNULL(SLIIM_SUCCESS_FLAG,'')=''
				and ISNULL(SLIIM_ERROR_CODE,'')=''
				
               	UPDATE D 
				SET    SLIIM_SUCCESS_FLAG   = case when ltrim(rtrim(TMPC_ERROR_CODE)) = ''  then 'S' else 'F'  end
				,SLIIM_ERROR_CODE = ISNULL(TMPC_ERROR_CODE,'')
				,SLIIM_DT=TMPC_BUS_TRX_DT
				FROM   SLIP_ISSUE_MSTR_POA D 
					  ,TMP_COMMON_TRX_RESP_MSTR  T  
				WHERE  SLIIM_DPAM_ACCT_NO = TMPC_BOID_PLEDGORBOID 
				--and TMPC_INT_REF_NO=SLIIM_SLIP_NO_TO --isnull(citrus_usr.Fn_toSliptype_BookName(TMPC_CONF_ACCP_QTY,'',''),'')
				and TMPC_UPLOAD_TYPE = 39 
				and TMPC_VERF_REJ_QUY=SLIIM_SLIP_NO_FR and TMPC_CONF_ACCP_QTY=SLIIM_SLIP_NO_TO
				and ISNULL(SLIIM_SUCCESS_FLAG,'')=''
				and ISNULL(SLIIM_ERROR_CODE,'')=''				
				
				UPDATE D 
				SET    USES_SUCCESS_FLAG   = case when ltrim(rtrim(TMPC_ERROR_CODE)) = ''  then 'S' else 'F'  end
				,USES_ERROR_CODE = ISNULL(TMPC_ERROR_CODE,'')
				,USES_CANCELLATION_DT=TMPC_BUS_TRX_DT
				FROM   USED_SLIP_BLOCK D 
					  ,TMP_COMMON_TRX_RESP_MSTR  T  
				WHERE  USES_DPAM_ACCT_NO = TMPC_BOID_PLEDGORBOID 
				--and TMPC_INT_REF_NO=USES_SLIP_NO_to --isnull(citrus_usr.Fn_toSliptype_BookName(TMPC_CONF_ACCP_QTY,'',''),'')
				and TMPC_UPLOAD_TYPE = 39 
				and TMPC_VERF_REJ_QUY=USES_SLIP_NO and TMPC_CONF_ACCP_QTY=USES_SLIP_NO_to
				and ISNULL(USES_SUCCESS_FLAG,'')=''
				and ISNULL(USES_ERROR_CODE,'')=''				
				
--For Slip issuance only - 39


				UPDATE BATCHNO_CDSL_MSTR SET BATCHC_STATUS = 'I'
				WHERE  BATCHC_NO = @PA_BATCHNO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_TRANS_TYPE = 'ALL'
		--
  END
  IF @pa_tab= 'DPMPLEDGE'
		BEGIN
		--
				UPDATE D 
				SET  PLDTC_STATUS   = case when ltrim(rtrim(TMPDPMPLDG_ERRMSG)) = ''  then 'S' else 'F'  end					
					,PLDTC_TRANS_NO = TMPDPMPLDG_Seq_No
				FROM cdsl_pledge_dtls D 
					  ,TMP_DPMPLEDGE_CDSL   T  
				WHERE  PLDTC_ID = convert(numeric,TMPDPMPLDG_PLEDGOR_INTREFNO)
					--convert(numeric,citrus_usr.fn_splitval_by(TMPDPMPLDG_PLEDGOR_INTREFNO+'/',2,'/'))  --TMPDPMPLDG_PLEDGOR_INTREFNO
select @PA_BATCHNO = PLDTC_BATCH_NO FROM cdsl_pledge_dtls D 
					  ,TMP_DPMPLEDGE_CDSL   T  
				WHERE  PLDTC_ID = convert(numeric,TMPDPMPLDG_PLEDGOR_INTREFNO)
--print @PA_BATCHNO
--print @L_DPM_ID
				UPDATE BATCHNO_CDSL_MSTR SET BATCHC_STATUS = 'I'
				WHERE  convert(varchar,BATCHC_NO) = @PA_BATCHNO AND BATCHC_DPM_ID =@L_DPM_ID AND BATCHC_TRANS_TYPE = 'BN'
		--
  END
set @PA_BATCHNO=''

--
END

GO
