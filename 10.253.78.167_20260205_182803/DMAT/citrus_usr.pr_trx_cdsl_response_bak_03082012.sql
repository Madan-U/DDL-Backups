-- Object: PROCEDURE citrus_usr.pr_trx_cdsl_response_bak_03082012
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create procedure [citrus_usr].[pr_trx_cdsl_response_bak_03082012]( @pa_exch          VARCHAR(20)  
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
  IF @pa_tab= 'DEMAT'
		BEGIN
		--
				UPDATE D 
				SET  demrm_status   = case when ltrim(rtrim(TMPDMT_Err_Mesg)) = ''  then 'S' else 'F'  end
					,demrm_converted_qty = case when ltrim(rtrim(TMPDMT_Err_Mesg)) = ''  then tmpdmt_drf_qty ELSE demrm_converted_qty END
					,demrm_transaction_no= tmpdmt_drn
					,demrm_errmsg   = tmpdmt_err_mesg
				FROM   demat_request_mstr D 
						,TMP_demat_CDSL   T  
				WHERE  demrm_slip_serial_no = tmpdmt_drf_no

				UPDATE BATCHNO_CDSL_MSTR SET BATCHC_STATUS = 'I'
				WHERE  BATCHC_NO = @PA_BATCHNO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_TRANS_TYPE = 'DMAT'
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
