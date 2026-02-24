-- Object: PROCEDURE citrus_usr.pr_select_trxgen_cdsl_bak10072020
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


--begin tran
--select * from dp_mstr where default_dp=dpm_excsm_id
--pr_select_trxgen_cdsl 'OFFM','25/11/2008','25/11/2008','1','BN',3,'HO','','N','*|~*','|*~|',''
--rollback
create PROCEDURE [citrus_usr].[pr_select_trxgen_cdsl_bak10072020]  
(  
@PA_TRX_TAB VARCHAR(8000),  
@PA_FROM_DT VARCHAR(20),  
@PA_TO_DT VARCHAR(20),  
@PA_BATCH_NO VARCHAR(10),  
@PA_BATCH_TYPE VARCHAR(4),  
@PA_EXCSM_ID INT,  
@PA_LOGINNAME VARCHAR(20),  
@PA_POOL_ACCTNO VARCHAR(16),
@pa_broker_yn CHAR(1), 
@ROWDELIMITER VARCHAR(20),  
@COLDELIMITER VARCHAR(20),  
@pa_output VARCHAR(20) output  
)  
AS  
BEGIN  
--  
/*  
p-pending  
o-overduwe  
s-upload success  
f-fail  
e-execute  
r-reject  
0-intial  
*/  
  DECLARE @@L_TRX_CD VARCHAR(5)  
  ,@L_QTY varchar(100)  
  ,@L_TOTQTY VARCHAR(100)   
  ,@L_SQL VARCHAR(8000)  
  ,@l_TRX_TAB varchar(8000)  
  ,@remainingstring varchar(8000)  
  ,@foundat int  
  ,@delimeter  varchar(50)  
  ,@currstring  varchar(500)  
        ,@delimeterlength int  
        ,@l_dpm_id int   
        ,@L_TOT_REC int  
        ,@L_TRANS_TYPE VARCHAR(8000)   
       SET @delimeter        = '%'+ @ROWDELIMITER + '%'  
      SET @delimeterlength = LEN(@ROWDELIMITER)  
      SET @remainingstring = @PA_TRX_TAB    
   SELECT @L_DPM_ID = DPM_ID FROM DP_MSTR WHERE DEFAULT_DP = @PA_EXCSM_ID AND DPM_DELETED_IND =1     
  SET @L_TOT_REC = 0
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
      SET @l_TRX_TAB = citrus_usr.fn_splitval(@currstring,1)  
    
    if @pa_broker_yn = 'Y' 
    begin
						IF @l_TRX_TAB = 'EP'  
						BEGIN  
							--  
										--for exch filelookup  
										--settlemnt lookup + other settl_no  
								IF @PA_BATCH_TYPE = 'BN'  
								BEGIN  
										Select convert(char(2),isnull(excm_short_name,0))  
															+ convert(char(2),isnull(fillm_file_value,''))  
														+ convert(char(8),isnull(convert(varchar,dptdc_cm_id),''))  
														+ convert(char(13),isnull(case when settm_type_cdsl = 'TT' then 'W' when settm_type_cdsl = 'NR' then 'N' when settm_type_cdsl = 'NA' then 'A' else settm_type_cdsl end,0)+isnull(dptdc_other_settlement_no,''))  
														+ convert(char(16),isnull(dpam_sba_no,''))  
														+ convert(char(12),isnull(dptdc_isin,'') )  
																	+ convert(varchar(16),citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(dptdc_qty)),13,3,'L','0'))    
														+ convert(char(16),isnull(dptdc_counter_demat_acct_no,''))  
														+ convert(char(16),DPTDC_SLIP_NO+'/'+dptdc_internal_ref_no)
														+ convert(char(8),replace(convert(varchar(11),dptdc_execution_dt,103),'/',''))  DETAILS
														, abs(dptdc_qty) qty
												FROM   dp_trx_dtls_cdsl   
												left outer join  settlement_type_mstr  on convert(varchar,settm_id) = dptdc_other_settlement_type and dptdc_other_settlement_type <> ''
													, dp_acct_mstr  
													
													, exchange_mstr  
													, cc_mstr  
													, Exch_Seg_Mstr  
													, bitmap_ref_mstr
													, file_lookup_mstr 
												WHERE  dpam_id      = dptdc_dpam_id  
												AND    excm_id      = dptdc_excm_id  
												and    FILLM_DB_VALUE = excm_short_name
												and    fillm_file_name = 'CH_CDSL'
												AND    dpam_deleted_ind   = 1  
												AND    dptdc_deleted_ind  = 1  
												--AND    settm_deleted_ind  = 1  
												--AND    settm_id           = case when isnull(dptdc_other_settlement_type,'') = '' then settm_id   else  dptdc_other_settlement_type end    
												AND    excm_cd            = excsm_exch_cd  
												AND    excsm_desc         = bitrm_child_cd  
												AND    convert(int,ccm_excsm_bit) & POWER(2,bitrm_bit_location-1) >0  
												AND    excsm_deleted_ind  = 1  
												AND    ccm_deleted_ind  = 1  
												AND    isnull(dptdc_status,'P')='P'  
												AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
												AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
												AND    dptdc_internal_trastm = @l_TRX_TAB  
												AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
												AND    isnull(DPTDC_BROKERBATCH_NO,'') <> ''

															SELECT @L_TOT_REC = COUNT(DPTDC_ID) FROM dp_trx_dtls_cdsl ,dp_acct_mstr  
																																							WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
															AND    dpam_dpm_id   = @l_dpm_id    
															AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
															AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
															AND    dptdc_internal_trastm = @l_TRX_TAB  
															AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 

															IF @L_TOT_REC > 0   
															BEGIN   
																	/* Update in dp_trx_dtls_cdsl*/ 

															SELECT @L_TRANS_TYPE = dptdc_internal_trastm FROM dp_trx_dtls_cdsl ,dp_acct_mstr  
															WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
															AND    dpam_dpm_id   = @l_dpm_id    
															AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
															AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
															AND    dptdc_internal_trastm = @l_TRX_TAB   
															AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
															AND    isnull(DPTDC_BROKERBATCH_NO,'') <> ''

															UPDATE D1 Set dptdc_batch_no=@pa_batch_no FROM dp_trx_dtls_cdsl D1 ,dp_acct_mstr D2  
															WHERE  dptdc_dpam_id = dpam_id   
															AND    dpam_dpm_id   = @l_dpm_id    
															AND    isnull(dptdc_status,'P')='P'  
															AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
															AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
															AND    dptdc_internal_trastm = @l_TRX_TAB   
															AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
															AND    isnull(DPTDC_BROKERBATCH_NO,'') <> ''


															/* Update in Bitmap ref mstr*/   
															UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
															WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  

															/* insert into batch table*/  



																	IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@l_TRX_TAB)  
																	BEGIN  
																		INSERT INTO BATCHNO_CDSL_MSTR                                       
																		(    
																			BATCHC_DPM_ID,  
																			BATCHC_NO,  
																			BATCHC_RECORDS ,  
																			BATCHC_TRANS_TYPE,          
																			BATCHC_TYPE,  
																			BATCHC_FILEGEN_DT,
																			BATCHC_STATUS,  
																			BATCHC_CREATED_BY,  
																			BATCHC_CREATED_DT ,  
																			BATCHC_DELETED_IND  
																		)  
																		VALUES  
																		(  
																			@L_DPM_ID,  
																			@PA_BATCH_NO,  
																			@L_TOT_REC,  
																			@L_TRANS_TYPE,  
																			'T',  
																			CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',
																			'P',  
																			@PA_LOGINNAME,  
																			GETDATE(),  
																			1  
																		)      
																																																											END  
																	END  

																						END     
																						ELSE  
								BEGIN  
										Select convert(char(2),isnull(EXCM_SHORT_NAME,0))  
														+ convert(char(2),isnull(fillm_file_value,''))  
														+ convert(char(8),isnull(convert(varchar,dptdc_cm_id),''))  
														+ convert(char(13),isnull(case when settm_type_cdsl = 'TT' then 'W' when settm_type_cdsl = 'NR' then 'N' when settm_type_cdsl = 'NA' then 'A' else settm_type_cdsl end,0)+isnull(dptdc_other_settlement_no,''))  
														+ convert(char(16),isnull(dpam_sba_no,''))  
														+ convert(char(12),isnull(dptdc_isin,'') )  
														+ convert(varchar(16),citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(dptdc_qty)),13,3,'L','0'))    
														+ convert(char(16),isnull(dptdc_counter_demat_acct_no,''))  
														+ convert(char(16),DPTDC_SLIP_NO+'/'+dptdc_internal_ref_no)
														+ convert(char(8),replace(convert(varchar(11),dptdc_execution_dt,103),'/',''))  DETAILS
														, abs(dptdc_qty) qty
												FROM   dp_trx_dtls_cdsl   
												left outer join  settlement_type_mstr  on convert(varchar,settm_id) = dptdc_other_settlement_type and dptdc_other_settlement_type <> ''
													, dp_acct_mstr  
												
													, exchange_mstr  
													, cc_mstr  
													, Exch_Seg_Mstr  
													, bitmap_ref_mstr  
													, file_lookup_mstr 
												WHERE  dpam_id      = dptdc_dpam_id  
												AND    excm_id      = dptdc_excm_id 
												and    FILLM_DB_VALUE = excm_short_name
												and    fillm_file_name = 'CH_CDSL'
												AND    dpam_deleted_ind   = 1  
												AND    dptdc_deleted_ind  = 1  
												--AND    settm_deleted_ind  = 1  
												--AND    settm_id           = case when isnull(dptdc_other_settlement_type,'') = '' then settm_id   else  dptdc_other_settlement_type end    
												AND    excm_cd            = excsm_exch_cd  
												AND    excsm_desc         = bitrm_child_cd  
												AND    convert(int,ccm_excsm_bit) & POWER(2,bitrm_bit_location-1) >0  
																																										AND    isnull(dptdc_status,'P') = 'P'  
																																										AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = @pa_batch_no  
												AND    excsm_deleted_ind  = 1  
												AND    ccm_deleted_ind  = 1  
												AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
												AND    dptdc_internal_trastm = @l_TRX_TAB  
												AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
												AND    isnull(DPTDC_BROKERBATCH_NO,'') <> ''

									END   
							--  
						END  
						IF @l_TRX_TAB = 'NP'  
						BEGIN  
						--  
								--for exch filelookup  
								--settlemnt lookup + other settl_no  
																						IF @PA_BATCH_TYPE = 'BN'  
								BEGIN  
								select 'D'+ convert(char(2),'01')  
													+ convert(char(2),isnull(fillm_file_value,''))  
													+ convert(char(2),isnull(EXCM_SHORT_NAME,0))  
													+ convert(char(13),isnull(case when settm_type_cdsl = 'TT' then 'W' when settm_type_cdsl = 'NR' then 'N' when settm_type_cdsl = 'NA' then 'A' else settm_type_cdsl end,0)+isnull(dptdc_other_settlement_no,''))  
													+ convert(char(6),isnull(right(dpm_dpid,6),''))  
													+ convert(char(8),isnull(convert(varchar,dptdc_cm_id),'') )  
													+ convert(char(16),isnull(dpam_sba_no,'') )  
													+ convert(char(12),isnull(dptdc_isin,'') ) 

													+ convert(char(6),'000000')  
													+ convert(char(4),'0000')  
													+ convert(varchar(16),citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(dptdc_qty)),13,3,'L','0'))    
													+ 'S'  
													+ convert(char(16),DPTDC_SLIP_NO+'/'+dptdc_internal_ref_no)  DETAILS
													, abs(dptdc_qty) qty
								FROm  dp_trx_dtls_cdsl   
								left outer join  settlement_type_mstr  on convert(varchar,settm_id) = dptdc_other_settlement_type and dptdc_other_settlement_type <> ''
													, dp_acct_mstr  
								
													, exchange_mstr  
													, cc_mstr  
													, Exch_Seg_Mstr  
													, bitmap_ref_mstr  
													,dp_mstr 
													, file_lookup_mstr
								WHERE  dpam_id      = dptdc_dpam_id  
								and    dpam_dpm_id  = dpm_id
								and    FILLM_DB_VALUE = excm_short_name
								and    fillm_file_name = 'CH_CDSL'
								AND    excm_id      = dptdc_excm_id  
								AND    dpam_deleted_ind   = 1  
								AND    dptdc_deleted_ind  = 1  
								--AND    settm_deleted_ind  = 1  
								--AND    settm_id           = case when isnull(dptdc_other_settlement_type,'') = '' then settm_id   else  dptdc_other_settlement_type end    
								AND    excm_cd            = excsm_exch_cd  
								AND    excsm_desc         = bitrm_child_cd  
								AND    convert(int,ccm_excsm_bit) & POWER(2,bitrm_bit_location-1) >0  
								AND    excsm_deleted_ind  = 1  
								AND    ccm_deleted_ind  = 1  
								AND    isnull(dptdc_status,'P')='P'  
								AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
								AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
								AND    dptdc_internal_trastm = @l_TRX_TAB  
								AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
								AND    isnull(DPTDC_BROKERBATCH_NO,'') <> ''


									SELECT @L_TOT_REC = COUNT(DPTDC_ID) FROM dp_trx_dtls_cdsl ,dp_acct_mstr  
																														WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
																														AND    dpam_dpm_id   = @l_dpm_id    
									AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
									AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
									AND    dptdc_internal_trastm = @l_TRX_TAB    
									AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
									AND    isnull(DPTDC_BROKERBATCH_NO,'') <> ''

									IF @L_TOT_REC > 0   
									BEGIN   
												/* Update in dp_trx_dtls_cdsl*/  

												SELECT @L_TRANS_TYPE = dptdc_internal_trastm FROM dp_trx_dtls_cdsl ,dp_acct_mstr  
												WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
												AND    dpam_dpm_id   = @l_dpm_id    
												AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
												AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
												AND    dptdc_internal_trastm = @l_TRX_TAB 
												AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  
												AND    isnull(DPTDC_BROKERBATCH_NO,'') <> ''

												UPDATE D1 Set dptdc_batch_no=@pa_batch_no FROM dp_trx_dtls_cdsl D1 ,dp_acct_mstr D2  
												WHERE  dptdc_dpam_id = dpam_id   
												AND    dpam_dpm_id   = @l_dpm_id    
												AND    isnull(dptdc_status,'P')='P'  
												AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
												AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
												AND    dptdc_internal_trastm = @l_TRX_TAB  
												AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
												AND    isnull(DPTDC_BROKERBATCH_NO,'') <> ''

															/* Update in Bitmap ref mstr*/   
												UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
												WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND  BITRM_CHILD_CD= @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  

												/* insert into batch table*/  



																IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@l_TRX_TAB)  
																	BEGIN  
																		INSERT INTO BATCHNO_CDSL_MSTR                                       
																		(    
																			BATCHC_DPM_ID,  
																			BATCHC_NO,  
																			BATCHC_RECORDS ,  
																			BATCHC_TRANS_TYPE,
																			BATCHC_FILEGEN_DT,           
																			BATCHC_TYPE,  
																			BATCHC_STATUS,  
																			BATCHC_CREATED_BY,  
																			BATCHC_CREATED_DT ,  
																			BATCHC_DELETED_IND  
																		)  
																		VALUES  
																		(  
																			@L_DPM_ID,  
																			@PA_BATCH_NO,  
																			@L_TOT_REC,  
																			@L_TRANS_TYPE,
																			CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',  
																			'T',  
																			'P',  
																			@PA_LOGINNAME,  
																			GETDATE(),  
																			1  
																		)      
																																																											END  

									END  

																										END  
																						ELSE   
																										BEGIN  
								select 'D'+convert(char(2),'01')  
													+ convert(char(2),isnull(fillm_file_value,''))  
													+ convert(char(2),isnull(EXCM_SHORT_NAME,0))  
													+ convert(char(13),isnull(case when settm_type_cdsl = 'TT' then 'W' when settm_type_cdsl = 'NR' then 'N' when settm_type_cdsl = 'NA' then 'A' else settm_type_cdsl end,0)+isnull(dptdc_other_settlement_no,''))  
													+ convert(char(6),isnull(right(dpm_dpid,6),''))   
													+ convert(char(8),isnull(convert(varchar,dptdc_cm_id),'') ) 
													+ convert(char(16),isnull(dpam_sba_no,'') )  
													+ convert(char(12),isnull(dptdc_isin,'') )  
													+ convert(char(6),'000000')  
													+ convert(char(4),'0000')  
													+ convert(varchar(16),citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(dptdc_qty)),13,3,'L','0'))    
													+ 'S'  
													+ convert(char(16),DPTDC_SLIP_NO+'/'+dptdc_internal_ref_no)  DETAILS
													, abs(dptdc_qty) qty
								FROm  dp_trx_dtls_cdsl   
								left outer join  settlement_type_mstr  on convert(varchar,settm_id) = dptdc_other_settlement_type and dptdc_other_settlement_type <> ''
													, dp_acct_mstr  
								
													, exchange_mstr  
													, cc_mstr  
													, Exch_Seg_Mstr  
													, bitmap_ref_mstr  
														,dp_mstr
														, file_lookup_mstr
								WHERE  dpam_id      = dptdc_dpam_id  
								and    dpam_dpm_id      = dpm_id 
								and    FILLM_DB_VALUE = excm_short_name
								and    fillm_file_name = 'CH_CDSL'
								AND    excm_id      = dptdc_excm_id  
								AND    dpam_deleted_ind   = 1  
								AND    dptdc_deleted_ind  = 1  
								--AND    settm_deleted_ind  = 1  
								--  AND    settm_id           = case when isnull(dptdc_other_settlement_type,'') = '' then settm_id   else  dptdc_other_settlement_type end    
								AND    excm_cd            = excsm_exch_cd  
								AND    excsm_desc         = bitrm_child_cd  
								AND    convert(int,ccm_excsm_bit) & POWER(2,bitrm_bit_location-1) >0  
								AND    excsm_deleted_ind  = 1  
								AND    ccm_deleted_ind  = 1  
								AND    isnull(DPTDC_BROKERBATCH_NO,'') <> ''
																										AND    isnull(dptdc_status,'P')='P'  
												AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = @PA_BATCH_NO  
								AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
								AND    dptdc_internal_trastm = @l_TRX_TAB  
								AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END

								END   
						--  
						END  
						IF @l_TRX_TAB in ('OFFM')  
						BEGIN  
						--   
									-- in case of request for off market  
								IF @PA_BATCH_TYPE = 'BN'  
									BEGIN  
										SELECT distinct replace(convert(varchar(11),dptdc_execution_dt,103),'/','')  
																+ isnull(dpam_sba_no,'')  
																+ isnull(dptdc_counter_dp_id,'') + isnull(dptdc_counter_demat_acct_no,'')  
																+ isnull(convert(char(12),dptdc_isin),'')  
																+ convert(varchar(16),citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(dptdc_qty)),12,3,'L','0'))    
																+ case  when dptdc_internal_trastm in('BOCM','CMCM') then 'S' when dptdc_internal_trastm = 'CMBO' then 'S' else 'S' end  
																+ isnull(dptdc_cash_trf,'')  
																+ isnull(convert(varchar(10),dptdc_reason_cd),'2')  
																+ convert(char(16),DPTDC_SLIP_NO+'/'+dptdc_internal_ref_no)
																+  case when isnull(dptdc_settlement_no,'') <> '' then convert(char(13),isnull(citrus_usr.GetCDSLinterdpSettType('',dptdc_settlement_no,settm_type_cdsl),'')   +isnull(dptdc_settlement_no,''))  else convert(char(13),'') end 
                                                                   DETAILS--space(13) DETAILS  
																, abs(dptdc_qty) qty
											FROm   dp_trx_dtls_cdsl   
                                                   left outer join  settlement_type_mstr  on convert(varchar,settm_id) = dptdc_mkt_type and dptdc_mkt_type <> ''
																, dp_acct_mstr  
											WHERE  dpam_id  = dptdc_dpam_id  
											AND    dpam_deleted_ind  = 1  
											AND    isnull(dptdc_status,'P')='P'  
											AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
											AND    dptdc_deleted_ind  = 1  
											AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
											AND    dptdc_internal_trastm in ('CMBO','CMCM','BOBO','BOCM')  
											AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
											AND    isnull(DPTDC_BROKERBATCH_NO,'') <> ''

											SELECT @L_TOT_REC = COUNT(DPTDC_ID) FROM dp_trx_dtls_cdsl ,dp_acct_mstr  
											WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
											AND    dpam_dpm_id   = @l_dpm_id    
											AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
											AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
											AND    dptdc_internal_trastm in ('CMBO','CMCM','BOBO','BOCM')  
											AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  
											AND    isnull(DPTDC_BROKERBATCH_NO,'') <> ''

											IF @L_TOT_REC > 0   
												BEGIN  
															/* Update in dp_trx_dtls_cdsl*/ 

															SELECT @L_TRANS_TYPE = dptdc_internal_trastm FROM dp_trx_dtls_cdsl ,dp_acct_mstr  
															WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
															AND    dpam_dpm_id   = @l_dpm_id    
															AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
															AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
															AND    dptdc_internal_trastm in ('CMBO','CMCM','BOBO','BOCM')  
															AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  
															AND    isnull(DPTDC_BROKERBATCH_NO,'') <> ''

															UPDATE D1 Set dptdc_batch_no=@pa_batch_no FROM dp_trx_dtls_cdsl D1 ,dp_acct_mstr D2  
															WHERE  dptdc_dpam_id = dpam_id   
															AND    dpam_dpm_id   = @l_dpm_id    
															AND    isnull(dptdc_status,'P')='P'  
															AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
															AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
															AND    dptdc_internal_trastm in ('CMBO','CMCM','BOBO','BOCM')  
															AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
															AND    isnull(DPTDC_BROKERBATCH_NO,'') <> ''


															/* Update in Bitmap ref mstr*/   
															UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
															WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND  BITRM_CHILD_CD = @L_DPM_ID 
															AND BITRM_BIT_LOCATION = @PA_EXCSM_ID   




															/* insert into batch table*/              

																IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@l_TRX_TAB)  
																	BEGIN  

																		INSERT INTO BATCHNO_CDSL_MSTR                                       
																		(    
																			BATCHC_DPM_ID,  
																			BATCHC_NO,  
																			BATCHC_RECORDS ,  
																			BATCHC_TRANS_TYPE, 
																			BATCHC_FILEGEN_DT,          
																			BATCHC_TYPE,  
																			BATCHC_STATUS,  
																			BATCHC_CREATED_BY,  
																			BATCHC_CREATED_DT ,  
																			BATCHC_DELETED_IND  
																		)  
																		VALUES  
																		(  
																			@L_DPM_ID,  
																			@PA_BATCH_NO,  
																			@L_TOT_REC,  
																			@l_TRX_TAB,--@L_TRANS_TYPE,
																			CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',  
																			'T',  
																			'P',  
																			@PA_LOGINNAME,  
																			GETDATE(),  
																			1  
																		)      
																			END  
												END              

									END  
																										ELSE  
									BEGIN   
										SELECT distinct replace(convert(varchar(11),dptdc_execution_dt,103),'/','')  
																+ isnull(dpam_sba_no,'')  
																+ isnull(dptdc_counter_dp_id,'') + isnull(dptdc_counter_demat_acct_no,'')  
																+ isnull(convert(char(12),dptdc_isin),'')  
																+ convert(varchar(16),citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(dptdc_qty)),12,3,'L','0'))    
																+ case  when dptdc_internal_trastm in('BOCM','CMCM') then 'S' when dptdc_internal_trastm = 'CMBO' then 'S' else 'S' end  
																+ isnull(dptdc_cash_trf,'')  
																+ isnull(convert(varchar(10),dptdc_reason_cd),'2')  
																+ convert(char(16),DPTDC_SLIP_NO+'/'+dptdc_internal_ref_no)
																+  case when isnull(dptdc_settlement_no,'') <> '' then convert(char(13),isnull(citrus_usr.GetCDSLinterdpSettType('',dptdc_settlement_no,settm_type_cdsl),'')   +isnull(dptdc_settlement_no,''))  else convert(char(13),'') end  DETAILS
																, abs(dptdc_qty) qty
											FROm   dp_trx_dtls_cdsl   
                                                   left outer join  settlement_type_mstr  on convert(varchar,settm_id) = dptdc_mkt_type and dptdc_mkt_type <> ''
																, dp_acct_mstr  
											WHERE  dpam_id  = dptdc_dpam_id  
											AND    dpam_deleted_ind  = 1  
											AND    dptdc_deleted_ind  = 1  
											AND    isnull(dptdc_status,'P')='P'  
											AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = @PA_BATCH_NO  
											AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
											AND    dptdc_internal_trastm in ('CMBO','CMCM','BOBO','BOCM')  
											AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
											AND    isnull(DPTDC_BROKERBATCH_NO,'') <> ''

									END   

						--  
						END  
						IF @l_TRX_TAB = 'ID'  
						BEGIN  
						--  
								--pool dpam_acct_no pool 'B' else 'S'  
								--settlemnt lookup + other settl_no  
								IF @PA_BATCH_TYPE = 'BN'  
									BEGIN  
												Select convert(char(8),replace(convert(varchar(11),dptdc_execution_dt,103),'/',''))  
																+ convert(char(16),isnull(dpam_sba_no,space(8)))  
																+ convert(char(12),isnull(dptdc_isin,''))  
																+ convert(char(15),citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(dptdc_qty)),12,3,'L','0'))    
																+ 'S' --CASE  WHEN isnull(citrus_usr.fn_acct_entp(dpam_id,'CMBP_ID'),'') = '' THEN 'S' ELSE 'B'END  
																+ isnull(dptdc_cash_trf,'X')  
																+ case when ltrim(rtrim(isnull(dptdc_counter_cmbp_id,''))) <> '' then  convert(char(8),'') else convert(char(8),isnull(dptdc_counter_demat_acct_no,'')) end 
																+ case when convert(char(8),isnull(dptdc_counter_cmbp_id,'')) <> '' then convert(char(8),isnull(dptdc_counter_cmbp_id,'')) else  convert(char(8),isnull(dptdc_counter_dp_id,'')) end  
																+ case when isnull(dptdc_other_settlement_no,'') <> '' then convert(char(9),isnull(citrus_usr.GetCDSLinterdpSettType('',dptdc_other_settlement_no,settm_type_cdsl),'')   +isnull(dptdc_other_settlement_no,''))  else convert(char(9),'') end
																+ convert(char(16),DPTDC_SLIP_NO+'/'+dptdc_internal_ref_no)  DETAILS  
															, abs(dptdc_qty) qty
											FROM   dp_trx_dtls_cdsl   
																		left outer join settlement_type_mstr  on convert(varchar,settm_id) = dptdc_other_settlement_type and dptdc_other_settlement_type <> ''
																, dp_acct_mstr  

											WHERE  dpam_id            = dptdc_dpam_id  
											AND    dpam_deleted_ind   = 1  
											AND    dptdc_deleted_ind  = 1  
											AND    isnull(dptdc_status,'P')='P'  
											AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
											AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
											AND    dptdc_internal_trastm = @l_TRX_TAB 
											AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
											AND    isnull(DPTDC_BROKERBATCH_NO,'') <> ''

											SELECT @L_TOT_REC = COUNT(DPTDC_ID) FROM dp_trx_dtls_cdsl,dp_acct_mstr   
											WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
											AND    dpam_dpm_id   = @l_dpm_id    
											AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
											AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
											AND    dptdc_internal_trastm = @l_TRX_TAB   
											AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
											AND    isnull(DPTDC_BROKERBATCH_NO,'') <> ''
											IF @L_TOT_REC > 0  
											BEGIN   

															/* Update in dp_trx_dtls_cdsl*/  

															SELECT @L_TRANS_TYPE = dptdc_internal_trastm FROM dp_trx_dtls_cdsl ,dp_acct_mstr  
															WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
															AND    dpam_dpm_id   = @l_dpm_id    
															AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
															AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
															AND    dptdc_internal_trastm = @l_TRX_TAB  
															AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
															AND    isnull(DPTDC_BROKERBATCH_NO,'') <> ''

															UPDATE D1 Set dptdc_batch_no=@pa_batch_no FROM dp_trx_dtls_cdsl D1 ,dp_acct_mstr D2  
															WHERE  dptdc_dpam_id = dpam_id   
															AND    dpam_dpm_id   = @l_dpm_id    
															AND    isnull(dptdc_status,'P')='P'  
															AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
															AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
															AND    dptdc_internal_trastm = @l_TRX_TAB   
															AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
															AND    isnull(DPTDC_BROKERBATCH_NO,'') <> ''


															/* Update in Bitmap ref mstr*/   
															UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
															WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND  BITRM_CHILD_CD= @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  

															/* insert into batch table*/  



																IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@l_TRX_TAB)  
																	BEGIN  
																		INSERT INTO BATCHNO_CDSL_MSTR                                       
																		(    
																			BATCHC_DPM_ID,  
																			BATCHC_NO,  
																			BATCHC_RECORDS ,  
																			BATCHC_TRANS_TYPE,
																			BATCHC_FILEGEN_DT,
																			BATCHC_TYPE,  
																			BATCHC_STATUS,  
																			BATCHC_CREATED_BY,  
																			BATCHC_CREATED_DT ,  
																			BATCHC_DELETED_IND  
																		)  
																		VALUES  
																		(  
																			@L_DPM_ID,  
																			@PA_BATCH_NO,  
																			@L_TOT_REC,  
																			@L_TRANS_TYPE,
																			CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',  
																			'T',  
																			'P',  
																			@PA_LOGINNAME,  
																			GETDATE(),  
																			1  
																		)      
																																																											END    
											END   
									END  
																										ELSE  
									BEGIN   
											Select convert(char(8),replace(convert(varchar(11),dptdc_execution_dt,103),'/',''))  
																+ convert(char(16),isnull(dpam_sba_no,''))  
																+ convert(char(12),isnull(dptdc_isin,''))  
																+ convert(char(15),citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(dptdc_qty)),12,3,'L','0'))    
																+ 'S' --CASE  WHEN isnull(citrus_usr.fn_acct_entp(dpam_id,'CMBP_ID'),'') = '' THEN 'S' ELSE 'B'END  
																+ isnull(dptdc_cash_trf,'X')  
																+ case when ltrim(rtrim(isnull(dptdc_counter_cmbp_id,''))) <> '' then  convert(char(8),'') else convert(char(8),isnull(dptdc_counter_demat_acct_no,'')) end 
																+ case when convert(char(8),isnull(dptdc_counter_cmbp_id,'')) <> '' then convert(char(8),isnull(dptdc_counter_cmbp_id,'')) else  convert(char(8),isnull(dptdc_counter_dp_id,'')) end  
																+ case when isnull(dptdc_other_settlement_no,'') <> '' then convert(char(9),isnull(citrus_usr.GetCDSLinterdpSettType('',dptdc_other_settlement_no,settm_type_cdsl),'')   +isnull(dptdc_other_settlement_no,''))  else convert(char(9),'') end
																+ convert(char(16),DPTDC_SLIP_NO+'/'+dptdc_internal_ref_no)  DETAILS  
																, abs(dptdc_qty) qty
											FROm   dp_trx_dtls_cdsl   
												left outer join  settlement_type_mstr  on convert(varchar,settm_id) = dptdc_other_settlement_type and dptdc_other_settlement_type <> ''
																, dp_acct_mstr  

											WHERE  dpam_id            = dptdc_dpam_id  
											AND    dpam_deleted_ind   = 1  
											AND    dptdc_deleted_ind  = 1  
											AND    isnull(dptdc_status,'P')='P'  
											AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = @PA_BATCH_NO  
											AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
											AND    dptdc_internal_trastm = @l_TRX_TAB 
											AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
											AND    isnull(DPTDC_BROKERBATCH_NO,'') <> ''

									END   

						--  
						END  
						IF @l_TRX_TAB= 'DMAT'  
						BEGIN  
						--  
								/*BO ID  --acct_no  
								ISIN   --isin  
								DRF QTY --demrm_qty  
								DRF NUMB --DEMRM_DRF_NO  
								DISPATCH DOC ID --later on   
								DISPATCH NAME --later on   
								DISPATCH DATE --later on   
								NUMBER OF CERTIFICATES--DEMRM_TOTAL_CERTIFICATES  
								LOCKIN STATUS --demed_status  
								LOCKIN CODE--DEMRM_LOCKIN_REASON_CD  
								LOCKIN REMARK --DEMRD_RMKS  
								LOCKIN EXPIRY DATE --later on */  
								--count total certi from procedure  
								IF @PA_BATCH_TYPE = 'BN'  
									BEGIN  
										Select convert(char(16),isnull(dpam_sba_no,''))  
										+ convert(char(12),isnull(demrm_isin,''))  
										+ convert(char(16),citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(demrm_qty)),13,3,'L','0'))   
										+ convert(char(16),isnull(demrm_slip_serial_no,''))   
										+ convert(char(20),convert(varchar(20),case when isnull(disp_doc_id,0) =0 then '' else convert(varchar(20),disp_doc_id) end))  
										+ convert(char(30),isnull(disp_name,''))  
										+ case when convert(char(8),replace(convert(varchar(11),isnull(Disp_dt,space(8)),103),'/','')) = '01011900' then  convert(char(8),'00000000') else convert(char(8),replace(convert(varchar(11),isnull(Disp_dt,space(8)),103),'/','')) end 
										+ convert(char(5),citrus_usr.FN_FORMATSTR(CONVERT(VARCHAR(5),isnull(demrm_total_certificates,'0')),5,0,'L','0'))  
										+ convert(char(1),isnull(demrm_free_lockedin_yn,''))  
										+ convert(char(2),isnull(demrm_lockin_reason_cd,''))  
										+ convert(char(50),case when ltrim(rtrim(isnull(DEMRM_RMKS,'')))='' then space(50) else ltrim(rtrim(isnull(DEMRM_RMKS,''))) end ) 
										+ case when convert(char(8),replace(convert(varchar(11),isnull(DEMRM_LOCKIN_RELEASE_DT,space(8)),103),'/','')) = '01011900' or isnull(demrm_free_lockedin_yn,'N')='N'  then  convert(char(8),'00000000') else convert(char(8),replace(convert(varchar(11),isnull(DEMRM_LOCKIN_RELEASE_DT,space(8)),103),'/','')) end  DETAILS
										,abs(demrm_qty) qty
										FROM demat_request_mstr  
										 left outer join dmat_dispatch on demrm_id=disp_demrm_id
										,dp_acct_mstr  
											WHERE demrm_dpam_id     = dpam_id   
											AND   dpam_deleted_ind  = 1  
											AND   demrm_deleted_ind = 1  
											AND    isnull(demrm_status,'P')='P'  
											AND    ltrim(rtrim(isnull(demrm_batch_no,''))) = ''  
											AND   demrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'       
											AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END

											SELECT @L_TOT_REC = COUNT(demrm_ID) FROM demat_request_mstr left outer join dmat_dispatch on demrm_id=disp_demrm_id ,dp_acct_mstr
                                            ,demat_request_dtls
											WHERE  isnull(demrm_status,'P')='P' and demrm_dpam_id = dpam_id and demrm_id= demrd_demrm_id    
											AND    dpam_dpm_id      = @l_dpm_id    
											AND    ltrim(rtrim(isnull(demrm_batch_no,''))) = ''  
											AND    demrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																		AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END

											IF @L_TOT_REC > 0  
											BEGIN   

														/* Update in Demat_request_mstr*/   
														UPDATE D1 Set demrm_batch_no=@pa_batch_no FROM demat_request_mstr D1 ,dp_acct_mstr D2  
														WHERE  demrm_dpam_id = dpam_id   
														AND    dpam_dpm_id   = @l_dpm_id    
														AND    isnull(demrm_status,'P')='P'  
														AND    ltrim(rtrim(isnull(demrm_batch_no,''))) = ''  
														AND    demrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
														AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  
														/* Update in Bitmap ref mstr*/   
														UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
														WHERE   BITRM_PARENT_CD = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  

														/* insert into batch table*/                    
																IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@l_TRX_TAB)  
																	BEGIN  
																		INSERT INTO BATCHNO_CDSL_MSTR                                       
																		(    
																			BATCHC_DPM_ID,  
																			BATCHC_NO,  
																			BATCHC_RECORDS ,  
																			BATCHC_TRANS_TYPE,
																			BATCHC_FILEGEN_DT,           
																			BATCHC_TYPE,  
																			BATCHC_STATUS,  
																			BATCHC_CREATED_BY,  
																			BATCHC_CREATED_DT ,  
																			BATCHC_DELETED_IND  
																		)  
																		VALUES  
																		(  
																			@L_DPM_ID,  
																			@PA_BATCH_NO,  
																			@L_TOT_REC,  
																			@l_TRX_TAB,
																			CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'  ,
																			'T',  
																			'P',  
																			@PA_LOGINNAME,  
																			GETDATE(),  
																			1  
																		)      
																	END  
											END   

									END  
									ELSE  
									BEGIN   
										Select convert(char(16),isnull(dpam_sba_no,''))  
												+ convert(char(12),isnull(demrm_isin,''))  
												+ convert(char(16),citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(demrm_qty)),13,3,'L','0'))   
												+ convert(char(16),isnull(demrm_slip_serial_no,''))   
												+ convert(char(20),convert(varchar(20),case when isnull(disp_doc_id,0) =0 then '' else convert(varchar(20),disp_doc_id) end))  
												+ convert(char(30),isnull(disp_name,''))  
												+ case when convert(char(8),replace(convert(varchar(11),isnull(Disp_dt,space(8)),103),'/','')) = '01011900' then  convert(char(8),'00000000') else convert(char(8),replace(convert(varchar(11),isnull(Disp_dt,space(8)),103),'/','')) end
												+ convert(char(5),citrus_usr.FN_FORMATSTR(CONVERT(VARCHAR(5),isnull(demrm_total_certificates,'0')),5,0,'L','0'))    
												+ convert(char(1),isnull(demrm_free_lockedin_yn,''))  
												+ convert(char(2),isnull(demrm_lockin_reason_cd,''))  
												+ convert(char(50),case when ltrim(rtrim(isnull(DEMRM_RMKS,'')))='' then space(50) else ltrim(rtrim(isnull(DEMRM_RMKS,''))) end ) 
												+ case when convert(char(8),replace(convert(varchar(11),isnull(DEMRM_LOCKIN_RELEASE_DT,space(8)),103),'/','')) = '01011900'  or isnull(demrm_free_lockedin_yn,'N')='N' then  convert(char(8),'00000000') else convert(char(8),replace(convert(varchar(11),isnull(DEMRM_LOCKIN_RELEASE_DT,space(8)),103),'/','')) end  DETAILS
											,abs(demrm_qty) qty
											FROM  demat_request_mstr  
												  left outer join dmat_dispatch on demrm_id=disp_demrm_id
												,dp_acct_mstr  
											WHERE demrm_dpam_id     = dpam_id   
											AND   dpam_deleted_ind  = 1  
											AND   demrm_deleted_ind = 1  
											AND   isnull(demrm_status,'P')='P'  
											AND   ltrim(rtrim(isnull(demrm_batch_no,''))) = @pa_batch_no  
											AND   demrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'       
											AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
									END   


						--  
						END  
--						IF @l_TRX_TAB= 'CLSR_ACCT_GEN'   
--						BEGIN  
--							SELECT * FROM CLOSURE_ACCT_MSTR WHERE  CLSR_DATE BETWEEN   
--							CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT ,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'     
--							AND CLSR_DELETED_IND=1  
--						END   
IF @L_TRX_TAB= 'CLSR_ACCT_GEN'         
BEGIN  
           
Print 'Y'

 SELECT CONVERT(VARCHAR(16),ISNULL(CLSR_BO_ID,''))AS CLSR_BO_ID ,
		CONVERT(VARCHAR(1),ISNULL(CLSR_TRX_TYPE,''))AS CLSR_TRX_TYPE,
		CONVERT(VARCHAR(1),ISNULL(CLSR_INI_BY,'0'))AS CLSR_INI_BY ,
		CONVERT(VARCHAR(2),ISNULL(CLSR_REASON_CD,'00')) AS CLSR_REASON_CD ,
		CONVERT(VARCHAR(1),ISNULL(CLSR_REMAINING_BAL,''))AS CLSR_REMAINING_BAL ,
		CONVERT(VARCHAR(16),ISNULL(CLSR_NEW_BO_ID,''))AS CLSR_NEW_BO_ID ,
		CONVERT(VARCHAR(100),LTRIM(RTRIM(ISNULL(CLSR_RMKS,'')))) AS CLSR_RMKS,
		CONVERT(VARCHAR(16),ISNULL(CLSR_ID,0)) AS CLSR_REQ_INT_REFNO  ,
		REPLACE(CONVERT(VARCHAR(10), CLSR_DATE, 103), '/', '')+LEFT(REPLACE(CONVERT(VARCHAR(12), CLSR_CREATED_DT, 114),':','') ,6) CLSR_DATE
		FROM CLOSURE_ACCT_CDSL 
		WHERE CONVERT(DATETIME,CONVERT(VARCHAR(11),CLSR_DATE,109)) BETWEEN @PA_FROM_DT  AND @PA_TO_DT       
  	    and CLSR_DPM_ID = @L_DPM_ID
        and isnull(CLSR_BATCH_NO,0) =0

		SELECT @L_TOT_REC = COUNT(CLSR_ID) FROM CLOSURE_ACCT_CDSL      
		WHERE CONVERT(DATETIME,CONVERT(VARCHAR(11),CLSR_DATE,109)) BETWEEN @PA_FROM_DT  AND @PA_TO_DT       
        and CLSR_DPM_ID = @L_DPM_ID
        and isnull(CLSR_BATCH_NO,0) =0

---Select * from CLOSURE_ACCT_CDSL 

--SELECT @L_TOT_REC = COUNT(CLSR_ID) FROM CLOSURE_ACCT_CDSL      
--WHERE  CLSR_DATE BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)  AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)        
				 
PRINT(@L_TOT_REC)
	IF @L_TOT_REC > 0 
    BEGIN         
          /* UPDATE IN BITMAP_REF_MSTR TABLE */         
          if @PA_BATCH_TYPE = 'CDSL'
          Begin

 		    UPDATE BITMAP_REF_MSTR SET BITRM_VALUES = CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))             
            WHERE   BITRM_PARENT_CD = 'CDSL_BTCH_CLOSURE_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID 
 	      print(@PA_BATCH_NO)
		   UPDATE CLOSURE_ACCT_CDSL SET CLSR_BATCH_NO =  @PA_BATCH_NO 
		   WHERE CONVERT(DATETIME,CONVERT(VARCHAR(11),CLSR_DATE,109)) BETWEEN @PA_FROM_DT  AND @PA_TO_DT       
 			and CLSR_DPM_ID = @L_DPM_ID
            and isnull(CLSR_BATCH_NO,0) =0

--           UPDATE CLOSURE_ACCT_CDSL SET CLSR_BATCH_NO = @PA_BATCH_NO 
--		   WHERE CLSR_DATE BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106) AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)        
-- 			
-- 
          /* INSERT INTO BATCHNO_CDSL_MSTR */                          
				
			IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_TYPE = 'AC' AND BATCHC_TRANS_TYPE = 'ACCOUNT CLOSURE' AND BATCHC_DELETED_IND =1)        
                 BEGIN        
                  INSERT INTO BATCHNO_CDSL_MSTR                                             
                  (          
                   BATCHC_DPM_ID,        
                   BATCHC_NO,        
                   BATCHC_RECORDS,
                   BATCHC_STATUS,          
                   BATCHC_TRANS_TYPE,      
                   BATCHC_FILEGEN_DT,                 
                   BATCHC_CREATED_BY,        
                   BATCHC_CREATED_DT ,        
                   BATCHC_DELETED_IND, 
                   BATCHC_TYPE       
                  )        
                  VALUES        
                  (        
                   @L_DPM_ID,        
                   @PA_BATCH_NO,        
                   CONVERT(NUMERIC,@L_TOT_REC),
                   'P',       
				   'ACCOUNT CLOSURE',      
                   CONVERT(VARCHAR,CONVERT(DATETIME,@PA_FROM_DT,103),106)+' 00:00:00'  ,      
                   @PA_LOGINNAME,        
                   GETDATE(),        
                   1 ,
                   'AC'       
                  ) 
  
            END
		END 
	
        else
        Begin
            UPDATE BITMAP_REF_MSTR SET BITRM_VALUES = CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))             
            WHERE   BITRM_PARENT_CD = 'NSDL_BTCH_CLOSURE_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID 
 	  print 'sac'
 	      print(@PA_BATCH_NO)
		   UPDATE CLOSURE_ACCT_CDSL SET CLSR_BATCH_NO =  @PA_BATCH_NO 
		   WHERE CONVERT(DATETIME,CONVERT(VARCHAR(11),CLSR_DATE,109)) BETWEEN @PA_FROM_DT  AND @PA_TO_DT       
 			and CLSR_DPM_ID = @L_DPM_ID
 
--           UPDATE CLOSURE_ACCT_CDSL SET CLSR_BATCH_NO = @PA_BATCH_NO 
--		   WHERE CLSR_DATE BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106) AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)        
-- 			
-- 
          /* INSERT INTO BATCHNO_CDSL_MSTR */                          
				
			IF NOT EXISTS(SELECT BATCHN_NO FROM BATCHNO_NSDL_MSTR   WHERE BATCHN_NO  = @PA_BATCH_NO AND BATCHN_DPM_ID = @L_DPM_ID AND BATCHN_TYPE = 'AC' AND BATCHN_TRANS_TYPE = 'ACCOUNT CLOSURE' AND BATCHN_DELETED_IND =1)        
                 BEGIN        
                  INSERT INTO BATCHNO_NSDL_MSTR                                             
                  (          
                   BATCHN_DPM_ID,        
                   BATCHN_NO,        
                   BATCHN_RECORDS,        
                   BATCHN_STATUS,      
                   BATCHN_TRANS_TYPE,                 
                   BATCHN_FILEGEN_DT,        
                   BATCHN_CREATED_BY,        
                   BATCHN_CREATED_DT ,
                   BATCHN_DELETED_IND,
                   BATCHN_TYPE        
                  )        
                  VALUES        
                  (        
                   @L_DPM_ID,        
                   @PA_BATCH_NO,        
                   CONVERT(NUMERIC,@L_TOT_REC),       
				   'P',
                   'ACCOUNT CLOSURE', 
                   CONVERT(VARCHAR,CONVERT(DATETIME,@PA_FROM_DT,103),106)+' 00:00:00',     
                   @PA_LOGINNAME,
                   getdate() , 
                   1,
                   'AC'        
                  ) 
  
				END 
           END               
		END
END
    --
    END
    ELSE IF @pa_broker_yn = 'N'
    BEGIN
    --
      						IF @l_TRX_TAB = 'EP'  
												BEGIN  
													--  
																--for exch filelookup  
																--settlemnt lookup + other settl_no  
														IF @PA_BATCH_TYPE = 'BN'  
														BEGIN  
																Select convert(char(2),isnull(excm_short_name,0))  
																					+ convert(char(2),isnull(fillm_file_value,''))  
																				+ convert(char(8),isnull(convert(varchar,dptdc_cm_id),''))  
																				+ convert(char(13),isnull(case when settm_type_cdsl = 'TT' then 'W' when settm_type_cdsl = 'NR' then 'N' when settm_type_cdsl = 'NA' then 'A' else settm_type_cdsl end,0)+isnull(dptdc_other_settlement_no,''))  
																				+ convert(char(16),isnull(dpam_sba_no,''))  
																				+ convert(char(12),isnull(dptdc_isin,'') )  
																							+ convert(varchar(16),citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(dptdc_qty)),13,3,'L','0'))    
																				+ convert(char(16),isnull(dptdc_counter_demat_acct_no,''))  
																				+ convert(char(16),DPTDC_SLIP_NO+'/'+dptdc_internal_ref_no)  
																				+ convert(char(8),replace(convert(varchar(11),dptdc_execution_dt,103),'/',''))  DETAILS
																			, abs(dptdc_qty) qty
																		FROM   dp_trx_dtls_cdsl   
																		left outer join  settlement_type_mstr  on convert(varchar,settm_id) = dptdc_other_settlement_type and dptdc_other_settlement_type <> ''
																			, dp_acct_mstr  
																		
																			, exchange_mstr  
																			, cc_mstr  
																			, Exch_Seg_Mstr  
																			, bitmap_ref_mstr
																			, file_lookup_mstr 
																		WHERE  dpam_id      = dptdc_dpam_id  
																		AND    excm_id      = dptdc_excm_id  
																		and    FILLM_DB_VALUE = excm_short_name
																		and    fillm_file_name = 'CH_CDSL'
																		AND    dpam_deleted_ind   = 1  
																		AND    dptdc_deleted_ind  = 1  
																		--AND    settm_deleted_ind  = 1  
																		--AND    settm_id           = case when isnull(dptdc_other_settlement_type,'') = '' then settm_id   else  dptdc_other_settlement_type end    
																		AND    excm_cd            = excsm_exch_cd  
																		AND    excsm_desc         = bitrm_child_cd  
																		AND    convert(int,ccm_excsm_bit) & POWER(2,bitrm_bit_location-1) >0  
																		AND    excsm_deleted_ind  = 1  
																		AND    ccm_deleted_ind  = 1  
																		AND    isnull(dptdc_status,'P')='P'  
																		AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
																		AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																		AND    dptdc_internal_trastm = @l_TRX_TAB  
																		AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																		AND isnull(DPTDC_BROKERBATCH_NO,'') = ''
						
																					SELECT @L_TOT_REC = COUNT(DPTDC_ID) FROM dp_trx_dtls_cdsl ,dp_acct_mstr  
																																													WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
																					AND    dpam_dpm_id   = @l_dpm_id    
																					AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
																					AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																					AND    dptdc_internal_trastm = @l_TRX_TAB  
																					AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																					AND isnull(DPTDC_BROKERBATCH_NO,'') = ''
						
																					IF @L_TOT_REC > 0   
																					BEGIN   
																							/* Update in dp_trx_dtls_cdsl*/ 
						
																					SELECT @L_TRANS_TYPE = dptdc_internal_trastm FROM dp_trx_dtls_cdsl ,dp_acct_mstr  
																					WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
																					AND    dpam_dpm_id   = @l_dpm_id    
																					AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
																					AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																					AND    dptdc_internal_trastm = @l_TRX_TAB   
																					AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																					AND isnull(DPTDC_BROKERBATCH_NO,'') = ''
						
																					UPDATE D1 Set dptdc_batch_no=@pa_batch_no FROM dp_trx_dtls_cdsl D1 ,dp_acct_mstr D2  
																					WHERE  dptdc_dpam_id = dpam_id   
																					AND    dpam_dpm_id   = @l_dpm_id    
																					AND    isnull(dptdc_status,'P')='P'  
																					AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
																					AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																					AND    dptdc_internal_trastm = @l_TRX_TAB   
																					AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																					AND isnull(DPTDC_BROKERBATCH_NO,'') = ''
						
						
																					/* Update in Bitmap ref mstr*/   
																					UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
																					WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  
						
																					/* insert into batch table*/  
						
						
						
																							IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@l_TRX_TAB)  
																							BEGIN  
																								INSERT INTO BATCHNO_CDSL_MSTR                                       
																								(    
																									BATCHC_DPM_ID,  
																									BATCHC_NO,  
																									BATCHC_RECORDS ,  
																									BATCHC_TRANS_TYPE,           
																									BATCHC_TYPE,  
																									BATCHC_FILEGEN_DT,
																									BATCHC_STATUS,  
																									BATCHC_CREATED_BY,  
																									BATCHC_CREATED_DT ,  
																									BATCHC_DELETED_IND  
																								)  
																								VALUES  
																								(  
																									@L_DPM_ID,  
																									@PA_BATCH_NO,  
																									@L_TOT_REC,  
																									@L_TRANS_TYPE,  
																									'T', 
																									CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00', 
																									'P',  
																									@PA_LOGINNAME,  
																									GETDATE(),  
																									1  
																								)      
																																																																	END  
																								END  
						
																												END     
																												ELSE  
														BEGIN  
																Select convert(char(2),isnull(EXCM_SHORT_NAME,0))  
																					+ convert(char(2),isnull(fillm_file_value,''))  
																				+ convert(char(8),isnull(convert(varchar,dptdc_cm_id),''))  
																				+ convert(char(13),isnull(case when settm_type_cdsl = 'TT' then 'W' when settm_type_cdsl = 'NR' then 'N' when settm_type_cdsl = 'NA' then 'A' else settm_type_cdsl end,0)+isnull(dptdc_other_settlement_no,''))  
																				+ convert(char(16),isnull(dpam_sba_no,''))  
																				+ convert(char(12),isnull(dptdc_isin,'') )  
																							+ convert(varchar(16),citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(dptdc_qty)),13,3,'L','0'))    
																				+ convert(char(16),isnull(dptdc_counter_demat_acct_no,''))  
																				+ convert(char(16),DPTDC_SLIP_NO+'/'+dptdc_internal_ref_no) 
																				+ convert(char(8),replace(convert(varchar(11),dptdc_execution_dt,103),'/',''))  DETAILS
																				, abs(dptdc_qty) qty
																		FROM   dp_trx_dtls_cdsl   
																		       left outer join  settlement_type_mstr  on convert(varchar,settm_id) = dptdc_other_settlement_type and dptdc_other_settlement_type <> ''
																			, dp_acct_mstr  
																			, exchange_mstr  
																			, cc_mstr  
																			, Exch_Seg_Mstr  
																			, bitmap_ref_mstr  
																			, file_lookup_mstr 
																		WHERE  dpam_id      = dptdc_dpam_id  
																		AND    excm_id      = dptdc_excm_id 
																		and    FILLM_DB_VALUE = excm_short_name
																		and    fillm_file_name = 'CH_CDSL'
																		AND    dpam_deleted_ind   = 1  
																		AND    dptdc_deleted_ind  = 1  
																		--AND    settm_deleted_ind  = 1  
																		--AND    settm_id           = case when isnull(dptdc_other_settlement_type,'') = '' then settm_id   else  dptdc_other_settlement_type end    
																		AND    excm_cd            = excsm_exch_cd  
																		AND    excsm_desc         = bitrm_child_cd  
																		AND    convert(int,ccm_excsm_bit) & POWER(2,bitrm_bit_location-1) >0  
																																																AND    isnull(dptdc_status,'P') = 'P'  
																																																AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = @pa_batch_no  
																		AND    excsm_deleted_ind  = 1  
																		AND    ccm_deleted_ind  = 1  
																		AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																		AND    dptdc_internal_trastm = @l_TRX_TAB  
																		AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																		AND isnull(DPTDC_BROKERBATCH_NO,'') = ''
						
															END   
													--  
												END  
												IF @l_TRX_TAB = 'NP'  
												BEGIN  
												--  
														--for exch filelookup  
														--settlemnt lookup + other settl_no  
														IF @PA_BATCH_TYPE = 'BN'  
														BEGIN  
														select 'D'+ convert(char(2),'01')  
																			+ convert(char(2),isnull(fillm_file_value,''))  
																			+ convert(char(2),isnull(EXCM_SHORT_NAME,0))  
																		 + convert(char(13),isnull(case when settm_type_cdsl = 'TT' then 'W' when settm_type_cdsl = 'NR' then 'N' when settm_type_cdsl = 'NA' then 'A' else settm_type_cdsl end,0)+isnull(dptdc_other_settlement_no,''))  
																		 + convert(char(6),isnull(right(dpm_dpid,6),''))   
																			+ convert(char(8),isnull(convert(varchar,dptdc_cm_id),'') )  
																			+ convert(char(16),isnull(dpam_sba_no,'') )  
																			+ convert(char(12),isnull(dptdc_isin,'') ) 
						
																			+ convert(char(6),'000000')  
																			+ convert(char(4),'0000')  
																			+ convert(varchar(16),citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(dptdc_qty)),13,3,'L','0'))    
																			+ 'S'  
																			+ convert(char(16),DPTDC_SLIP_NO+'/'+dptdc_internal_ref_no)  DETAILS
																			, abs(dptdc_qty) qty
														FROm  dp_trx_dtls_cdsl   
														      left outer join  settlement_type_mstr  on convert(varchar,settm_id) = dptdc_other_settlement_type and dptdc_other_settlement_type <> ''
																			, dp_acct_mstr  
																			, exchange_mstr  
																			, cc_mstr  
																			, Exch_Seg_Mstr  
																			, bitmap_ref_mstr  
																			,dp_mstr 
																			, file_lookup_mstr
														WHERE  dpam_id      = dptdc_dpam_id  
														and    dpam_dpm_id  = dpm_id
														and    FILLM_DB_VALUE = excm_short_name
														and    fillm_file_name = 'CH_CDSL'
														AND    excm_id      = dptdc_excm_id  
														AND    dpam_deleted_ind   = 1  
														AND    dptdc_deleted_ind  = 1  
														--AND    settm_deleted_ind  = 1  
														--AND    settm_id           = case when isnull(dptdc_other_settlement_type,'') = '' then settm_id   else  dptdc_other_settlement_type end    
														AND    excm_cd            = excsm_exch_cd  
														AND    excsm_desc         = bitrm_child_cd  
														AND    convert(int,ccm_excsm_bit) & POWER(2,bitrm_bit_location-1) >0  
														AND    excsm_deleted_ind  = 1  
														AND    ccm_deleted_ind  = 1  
														AND    isnull(dptdc_status,'P')='P'  
														AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
														AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
														AND    dptdc_internal_trastm = @l_TRX_TAB  
														AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
														AND isnull(DPTDC_BROKERBATCH_NO,'') = ''
						
						
															SELECT @L_TOT_REC = COUNT(DPTDC_ID) FROM dp_trx_dtls_cdsl ,dp_acct_mstr  
																																				WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
																																				AND    dpam_dpm_id   = @l_dpm_id    
															AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
															AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
															AND    dptdc_internal_trastm = @l_TRX_TAB    
															AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
															AND isnull(DPTDC_BROKERBATCH_NO,'') = ''
						
															IF @L_TOT_REC > 0   
															BEGIN   
																		/* Update in dp_trx_dtls_cdsl*/  
						
																		SELECT @L_TRANS_TYPE = dptdc_internal_trastm FROM dp_trx_dtls_cdsl ,dp_acct_mstr  
																		WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
																		AND    dpam_dpm_id   = @l_dpm_id    
																		AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
																		AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																		AND    dptdc_internal_trastm = @l_TRX_TAB 
																		AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  
																		AND isnull(DPTDC_BROKERBATCH_NO,'') = ''
						
																		UPDATE D1 Set dptdc_batch_no=@pa_batch_no FROM dp_trx_dtls_cdsl D1 ,dp_acct_mstr D2  
																		WHERE  dptdc_dpam_id = dpam_id   
																		AND    dpam_dpm_id   = @l_dpm_id    
																		AND    isnull(dptdc_status,'P')='P'  
																		AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
																		AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																		AND    dptdc_internal_trastm = @l_TRX_TAB  
																		AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																		AND isnull(DPTDC_BROKERBATCH_NO,'') = ''
						
																					/* Update in Bitmap ref mstr*/   
																		UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
																		WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND  BITRM_CHILD_CD= @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  
						
																		/* insert into batch table*/  
						
						
						
																						IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@l_TRX_TAB)  
																							BEGIN  
																								INSERT INTO BATCHNO_CDSL_MSTR                                       
																								(    
																									BATCHC_DPM_ID,  
																									BATCHC_NO,  
																									BATCHC_RECORDS ,  
																									BATCHC_TRANS_TYPE,
																									BATCHC_FILEGEN_DT,           
																									BATCHC_TYPE,  
																									BATCHC_STATUS,  
																									BATCHC_CREATED_BY,  
																									BATCHC_CREATED_DT ,  
																									BATCHC_DELETED_IND  
																								)  
																								VALUES  
																								(  
																									@L_DPM_ID,  
																									@PA_BATCH_NO,  
																									@L_TOT_REC,  
																									@L_TRANS_TYPE,
																									CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',  
																									'T',  
																									'P',  
																									@PA_LOGINNAME,  
																									GETDATE(),  
																									1  
																								)      
																																																																	END  
						
															END  
						
																																END  
																												ELSE   
																																BEGIN  
														select 'D'+convert(char(2),'01')  
																			+ convert(char(2),isnull(fillm_file_value,''))  
																			+ convert(char(2),isnull(EXCM_SHORT_NAME,0))  
																			+ convert(char(13),isnull(case when settm_type_cdsl = 'TT' then 'W' when settm_type_cdsl = 'NR' then 'N' when settm_type_cdsl = 'NA' then 'A' else settm_type_cdsl end,0)+isnull(dptdc_other_settlement_no,''))  
																			+ convert(char(6),isnull(right(dpm_dpid,6),''))    
																			+ convert(char(8),isnull(convert(varchar,dptdc_cm_id),'') ) 
																			+ convert(char(16),isnull(dpam_sba_no,'') )  
																			+ convert(char(12),isnull(dptdc_isin,'') )  
																			+ convert(char(6),'000000')  
																			+ convert(char(4),'0000')  
																			+ convert(varchar(16),citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(dptdc_qty)),13,3,'L','0'))    
																			+ 'S'  
																			+ convert(char(16),DPTDC_SLIP_NO+'/'+dptdc_internal_ref_no)  DETAILS
																			, abs(dptdc_qty) qty
														FROm  dp_trx_dtls_cdsl   
														      left outer join settlement_type_mstr  on convert(varchar,settm_id) = dptdc_other_settlement_type and dptdc_other_settlement_type <> ''
																			, dp_acct_mstr  
																			
																			, exchange_mstr  
																			, cc_mstr  
																			, Exch_Seg_Mstr  
																			, bitmap_ref_mstr  
																				,dp_mstr
																				, file_lookup_mstr
														WHERE  dpam_id      = dptdc_dpam_id  
														and    dpam_dpm_id      = dpm_id 
														and    FILLM_DB_VALUE = excm_short_name
														and    fillm_file_name = 'CH_CDSL'
														AND    excm_id      = dptdc_excm_id  
														AND    dpam_deleted_ind   = 1  
														AND    dptdc_deleted_ind  = 1  
														--AND    settm_deleted_ind  = 1  
														--AND    settm_id           = case when isnull(dptdc_other_settlement_type,'') = '' then settm_id   else  dptdc_other_settlement_type end    
														AND    excm_cd            = excsm_exch_cd  
														AND    excsm_desc         = bitrm_child_cd  
														AND    convert(int,ccm_excsm_bit) & POWER(2,bitrm_bit_location-1) >0  
														AND    excsm_deleted_ind  = 1  
														AND    ccm_deleted_ind  = 1  
																																AND    isnull(dptdc_status,'P')='P'  
																		AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = @PA_BATCH_NO  
														AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
														AND    dptdc_internal_trastm = @l_TRX_TAB  
														AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
														AND isnull(DPTDC_BROKERBATCH_NO,'') = ''
						
														END   
												--  
												END  
												IF @l_TRX_TAB in ('OFFM')  
												BEGIN  
												--   
															-- in case of request for off market  
														IF @PA_BATCH_TYPE = 'BN'  
															BEGIN  
																SELECT distinct replace(convert(varchar(11),dptdc_execution_dt,103),'/','')  
																						+ isnull(dpam_sba_no,'')  
																						+ isnull(dptdc_counter_dp_id,'') + isnull(dptdc_counter_demat_acct_no,'')  
																						+ isnull(convert(char(12),dptdc_isin),'')  
																						+ convert(varchar(16),citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(dptdc_qty)),12,3,'L','0'))    
																						+ case  when dptdc_internal_trastm in('BOCM','CMCM') then 'S' when dptdc_internal_trastm = 'CMBO' then 'S' else 'S' end  
																						+ isnull(dptdc_cash_trf,'')  
																						+ isnull(convert(varchar(10),dptdc_reason_cd),'0')  
																						+ convert(char(16),DPTDC_SLIP_NO+'/'+dptdc_internal_ref_no)
																						+  case when isnull(dptdc_settlement_no,'') <> '' then convert(char(13),isnull(citrus_usr.GetCDSLinterdpSettType('',dptdc_settlement_no,settm_type_cdsl),'')   +isnull(dptdc_settlement_no,''))  else convert(char(13),'') end  DETAILS  
																					    , abs(dptdc_qty) qty
																	FROm   dp_trx_dtls_cdsl   
																			left outer join  settlement_type_mstr  on convert(varchar,settm_id) = dptdc_mkt_type and dptdc_mkt_type <> ''
																						, dp_acct_mstr  
																	WHERE  dpam_id  = dptdc_dpam_id  
																	AND    dpam_deleted_ind  = 1  
																	AND    isnull(dptdc_status,'P')='P'  
																	AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
																	AND    dptdc_deleted_ind  = 1  
																	AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																	AND    dptdc_internal_trastm in ('CMBO','CMCM','BOBO','BOCM')  
																	AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
						                                            AND isnull(DPTDC_BROKERBATCH_NO,'') = ''


																	SELECT @L_TOT_REC = COUNT(DPTDC_ID) FROM dp_trx_dtls_cdsl ,dp_acct_mstr  
																	WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
																	AND    dpam_dpm_id   = @l_dpm_id    
																	AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
																	AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																	AND    dptdc_internal_trastm in ('CMBO','CMCM','BOBO','BOCM')  
																	AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  
																	AND isnull(DPTDC_BROKERBATCH_NO,'') = ''
						
																	IF @L_TOT_REC > 0   
																		BEGIN  
																					/* Update in dp_trx_dtls_cdsl*/ 
						
																					SELECT @L_TRANS_TYPE = dptdc_internal_trastm FROM dp_trx_dtls_cdsl ,dp_acct_mstr  
																					WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
																					AND    dpam_dpm_id   = @l_dpm_id    
																					AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
																					AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																					AND    dptdc_internal_trastm in ('CMBO','CMCM','BOBO','BOCM')  
																					AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  
																					AND isnull(DPTDC_BROKERBATCH_NO,'') = ''
						
																					UPDATE D1 Set dptdc_batch_no=@pa_batch_no FROM dp_trx_dtls_cdsl D1 ,dp_acct_mstr D2  
																					WHERE  dptdc_dpam_id = dpam_id   
																					AND    dpam_dpm_id   = @l_dpm_id    
																					AND    isnull(dptdc_status,'P')='P'  
																					AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
																					AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																					AND    dptdc_internal_trastm in ('CMBO','CMCM','BOBO','BOCM')  
																					AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																					AND isnull(DPTDC_BROKERBATCH_NO,'') = ''
						
						
																					/* Update in Bitmap ref mstr*/   
																					UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
																					WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND  BITRM_CHILD_CD = @L_DPM_ID 
																					AND BITRM_BIT_LOCATION = @PA_EXCSM_ID   
						
						
						
						
																					/* insert into batch table*/              
						
																						IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@l_TRX_TAB)  
																							BEGIN  
						
																								INSERT INTO BATCHNO_CDSL_MSTR                                       
																								(    
																									BATCHC_DPM_ID,  
																									BATCHC_NO,  
																									BATCHC_RECORDS ,  
																									BATCHC_TRANS_TYPE, 
																									BATCHC_FILEGEN_DT,          
																									BATCHC_TYPE,  
																									BATCHC_STATUS,  
																									BATCHC_CREATED_BY,  
																									BATCHC_CREATED_DT ,  
																									BATCHC_DELETED_IND  
																								)  
																								VALUES  
																								(  
																									@L_DPM_ID,  
																									@PA_BATCH_NO,  
																									@L_TOT_REC,  
																									@l_TRX_TAB,--@L_TRANS_TYPE,
																									CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',  
																									'T',  
																									'P',  
																									@PA_LOGINNAME,  
																									GETDATE(),  
																									1  
																								)      
																									END  
																		END              
						
															END  
																																ELSE  
															BEGIN   
																SELECT distinct replace(convert(varchar(11),dptdc_execution_dt,103),'/','')  
																						+ isnull(dpam_sba_no,'')  
																						+ isnull(dptdc_counter_dp_id,'') + isnull(dptdc_counter_demat_acct_no,'')  
																						+ isnull(convert(char(12),dptdc_isin),'')  
																						+ convert(varchar(16),citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(dptdc_qty)),12,3,'L','0'))    
																						+ case  when dptdc_internal_trastm in('BOCM','CMCM') then 'S' when dptdc_internal_trastm = 'CMBO' then 'S' else 'S' end  
																						+ isnull(dptdc_cash_trf,'')  
																						+ isnull(convert(varchar(10),dptdc_reason_cd),'0')  
																						+ convert(char(16),DPTDC_SLIP_NO+'/'+dptdc_internal_ref_no) 
																						+  case when isnull(dptdc_settlement_no,'') <> '' then convert(char(13),isnull(citrus_usr.GetCDSLinterdpSettType('',dptdc_settlement_no,settm_type_cdsl),'')   +isnull(dptdc_settlement_no,''))  else convert(char(13),'') end  DETAILS
																					     , abs(dptdc_qty) qty
																	FROm   dp_trx_dtls_cdsl   
																	left outer join  settlement_type_mstr  on convert(varchar,settm_id) = dptdc_mkt_type and dptdc_mkt_type <> ''
																						, dp_acct_mstr  
																	WHERE  dpam_id  = dptdc_dpam_id  
																	AND    dpam_deleted_ind  = 1  
																	AND    dptdc_deleted_ind  = 1  
																	AND    isnull(dptdc_status,'P')='P'  
																	AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = @PA_BATCH_NO  
																	AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																	AND    dptdc_internal_trastm in ('CMBO','CMCM','BOBO','BOCM')  
																	AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																	AND isnull(DPTDC_BROKERBATCH_NO,'') = ''
						
															END   
						
												--  
												END  
												IF @l_TRX_TAB = 'ID'  
												BEGIN  
												--  
														--pool dpam_acct_no pool 'B' else 'S'  
														--settlemnt lookup + other settl_no  
														IF @PA_BATCH_TYPE = 'BN'  
															BEGIN  
																		Select convert(char(8),replace(convert(varchar(11),dptdc_execution_dt,103),'/',''))  
																						+ convert(char(16),isnull(dpam_sba_no,space(8)))  
																						+ convert(char(12),isnull(dptdc_isin,''))  
																						+ convert(char(15),citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(dptdc_qty)),12,3,'L','0'))    
																						+ 'S' --CASE  WHEN isnull(citrus_usr.fn_acct_entp(dpam_id,'CMBP_ID'),'') = '' THEN 'S' ELSE 'B'END  
																						+ isnull(dptdc_cash_trf,'X')  
																						+ case when ltrim(rtrim(isnull(dptdc_counter_cmbp_id,''))) <> '' then  convert(char(8),'') else convert(char(8),isnull(dptdc_counter_demat_acct_no,'')) end 
																						+ case when convert(char(8),isnull(dptdc_counter_cmbp_id,'')) <> '' then convert(char(8),isnull(dptdc_counter_cmbp_id,'')) else  convert(char(8),isnull(dptdc_counter_dp_id,'')) end  
																						+ case when isnull(dptdc_other_settlement_no,'') <> '' then convert(char(9),isnull(citrus_usr.GetCDSLinterdpSettType('',dptdc_other_settlement_no,settm_type_cdsl),'')   +isnull(dptdc_other_settlement_no,''))  else convert(char(9),'') end
																						+ convert(char(16),DPTDC_SLIP_NO+'/'+dptdc_internal_ref_no)  DETAILS  
																					, abs(dptdc_qty) qty
																	FROM   dp_trx_dtls_cdsl   
																    left outer join settlement_type_mstr  on convert(varchar,settm_id) = dptdc_other_settlement_type and dptdc_other_settlement_type <> ''
																    , dp_acct_mstr  
						
																	WHERE  dpam_id            = dptdc_dpam_id  
																	AND    dpam_deleted_ind   = 1  
																	AND    dptdc_deleted_ind  = 1  
																	AND    isnull(dptdc_status,'P')='P'  
																	AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
																	AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																	AND    dptdc_internal_trastm = @l_TRX_TAB 
																	AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																	AND isnull(DPTDC_BROKERBATCH_NO,'') = ''
						
																	SELECT @L_TOT_REC = COUNT(DPTDC_ID) FROM dp_trx_dtls_cdsl,dp_acct_mstr   
																	WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
																	AND    dpam_dpm_id   = @l_dpm_id    
																	AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
																	AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																	AND    dptdc_internal_trastm = @l_TRX_TAB   
																	AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																	AND isnull(DPTDC_BROKERBATCH_NO,'') = ''
																	IF @L_TOT_REC > 0  
																	BEGIN   
						
																					/* Update in dp_trx_dtls_cdsl*/  
						
																					SELECT @L_TRANS_TYPE = dptdc_internal_trastm FROM dp_trx_dtls_cdsl ,dp_acct_mstr  
																					WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
																					AND    dpam_dpm_id   = @l_dpm_id    
																					AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
																					AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																					AND    dptdc_internal_trastm = @l_TRX_TAB  
																					AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
						               AND isnull(DPTDC_BROKERBATCH_NO,'') = ''
						
																					UPDATE D1 Set dptdc_batch_no=@pa_batch_no FROM dp_trx_dtls_cdsl D1 ,dp_acct_mstr D2  
																					WHERE  dptdc_dpam_id = dpam_id   
																					AND    dpam_dpm_id   = @l_dpm_id    
																					AND    isnull(dptdc_status,'P')='P'  
																					AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
																					AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																					AND    dptdc_internal_trastm = @l_TRX_TAB   
																					AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																					AND isnull(DPTDC_BROKERBATCH_NO,'') = ''
						
						
																					/* Update in Bitmap ref mstr*/   
																					UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
																					WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND  BITRM_CHILD_CD= @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  
						
																					/* insert into batch table*/  
						
						
						
																						IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@l_TRX_TAB)  
																							BEGIN  
																								INSERT INTO BATCHNO_CDSL_MSTR                                       
																								(    
																									BATCHC_DPM_ID,  
																									BATCHC_NO,  
																									BATCHC_RECORDS ,  
																									BATCHC_TRANS_TYPE,
																									BATCHC_FILEGEN_DT,
																									BATCHC_TYPE,  
																									BATCHC_STATUS,  
																									BATCHC_CREATED_BY,  
																									BATCHC_CREATED_DT ,  
																									BATCHC_DELETED_IND  
																								)  
																								VALUES  
																								(  
																									@L_DPM_ID,  
																									@PA_BATCH_NO,  
																									@L_TOT_REC,  
																									@L_TRANS_TYPE,
																									CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',  
																									'T',  
																									'P',  
																									@PA_LOGINNAME,  
																									GETDATE(),  
																									1  
																								)      
																																																																	END    
																	END   
															END  
																																ELSE  
															BEGIN   
																	Select convert(char(8),replace(convert(varchar(11),dptdc_execution_dt,103),'/',''))  
																						+ convert(char(16),isnull(dpam_sba_no,''))  
																						+ convert(char(12),isnull(dptdc_isin,''))  
																						+ convert(char(15),citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(dptdc_qty)),12,3,'L','0'))    
																						+ 'S' --CASE  WHEN isnull(citrus_usr.fn_acct_entp(dpam_id,'CMBP_ID'),'') = '' THEN 'S' ELSE 'B'END  
																						+ isnull(dptdc_cash_trf,'X')  
																						+ case when ltrim(rtrim(isnull(dptdc_counter_cmbp_id,''))) <> '' then  convert(char(8),'') else convert(char(8),isnull(dptdc_counter_demat_acct_no,'')) end 
																						+ case when convert(char(8),isnull(dptdc_counter_cmbp_id,'')) <> '' then convert(char(8),isnull(dptdc_counter_cmbp_id,'')) else  convert(char(8),isnull(dptdc_counter_dp_id,'')) end  
																						+ case when isnull(dptdc_other_settlement_no,'') <> '' then convert(char(9),isnull(citrus_usr.GetCDSLinterdpSettType('',dptdc_other_settlement_no,settm_type_cdsl),'')   +isnull(dptdc_other_settlement_no,''))  else convert(char(9),'') end
																						+ convert(char(16),DPTDC_SLIP_NO+'/'+dptdc_internal_ref_no)  DETAILS  
																						, abs(dptdc_qty) qty
																	FROm   dp_trx_dtls_cdsl   
																		left outer join  settlement_type_mstr  on convert(varchar,settm_id) = dptdc_other_settlement_type and dptdc_other_settlement_type <> ''
																						, dp_acct_mstr  
						
																	WHERE  dpam_id            = dptdc_dpam_id  
																	AND    dpam_deleted_ind   = 1  
																	AND    dptdc_deleted_ind  = 1  
																	AND    isnull(dptdc_status,'P')='P'  
																	AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = @PA_BATCH_NO  
																	AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																	AND    dptdc_internal_trastm = @l_TRX_TAB 
																	AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																	AND isnull(DPTDC_BROKERBATCH_NO,'') = ''
						
															END   
						
												--  
												END  
												IF @l_TRX_TAB= 'DMAT'  
												BEGIN  
												--  
														/*BO ID  --acct_no  
														ISIN   --isin  
														DRF QTY --demrm_qty  
														DRF NUMB --DEMRM_DRF_NO  
														DISPATCH DOC ID --later on   
														DISPATCH NAME --later on   
														DISPATCH DATE --later on   
														NUMBER OF CERTIFICATES--DEMRM_TOTAL_CERTIFICATES  
														LOCKIN STATUS --demed_status  
														LOCKIN CODE--DEMRM_LOCKIN_REASON_CD  
														LOCKIN REMARK --DEMRD_RMKS  
														LOCKIN EXPIRY DATE --later on */  
														--count total certi from procedure  
														IF @PA_BATCH_TYPE = 'BN'  
															BEGIN  
																Select convert(char(16),isnull(dpam_sba_no,''))  
																+ convert(char(12),isnull(demrm_isin,''))  
																+ convert(char(16),citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(demrm_qty)),13,3,'L','0'))   
																+ convert(char(16),isnull(demrm_slip_serial_no,''))   
                                                                + convert(char(20),convert(varchar(20),case when isnull(disp_doc_id,0) =0 then '' else convert(varchar(20),disp_doc_id) end))  
										                        + convert(char(30),isnull(disp_name,''))
																+ case when convert(char(8),replace(convert(varchar(11),isnull(Disp_dt,space(8)),103),'/','')) = '01011900' then  convert(char(8),'00000000') else convert(char(8),replace(convert(varchar(11),isnull(Disp_dt,space(8)),103),'/','')) end  
										                        + convert(char(5),citrus_usr.FN_FORMATSTR(CONVERT(VARCHAR(5),isnull(demrm_total_certificates,'0')),5,0,'L','0'))    
																+ convert(char(1),isnull(demrm_free_lockedin_yn,''))  
																+ convert(char(2),isnull(demrm_lockin_reason_cd,''))  
																+ convert(char(50),case when ltrim(rtrim(isnull(DEMRM_RMKS,'')))='' then space(50) else ltrim(rtrim(isnull(DEMRM_RMKS,''))) end ) 
																+ case when convert(char(8),replace(convert(varchar(11),isnull(DEMRM_LOCKIN_RELEASE_DT,space(8)),103),'/','')) = '01011900'  or isnull(demrm_free_lockedin_yn,'N')='N' then  convert(char(8),'00000000') else convert(char(8),replace(convert(varchar(11),isnull(DEMRM_LOCKIN_RELEASE_DT,space(8)),103),'/','')) end  DETAILS
                                                                ,abs(demrm_qty) qty
																	FROM  demat_request_mstr  
																	left outer join dmat_dispatch on demrm_id=disp_demrm_id
																	,dp_acct_mstr  
																	WHERE demrm_dpam_id     = dpam_id   
																	AND   dpam_deleted_ind  = 1  
																	AND   demrm_deleted_ind = 1  
																	AND    isnull(demrm_status,'P')='P'  
																	AND    ltrim(rtrim(isnull(demrm_batch_no,''))) = ''
																	AND	  ISNULL(DEMRM_INTERNAL_REJ,'') = ''   
																	AND   demrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'       
																	AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
						
																	SELECT @L_TOT_REC = COUNT(demrm_ID) FROM demat_request_mstr left outer join dmat_dispatch on demrm_id=disp_demrm_id ,dp_acct_mstr,demat_request_dtls  
																	WHERE  isnull(demrm_status,'P')='P' and demrm_dpam_id = dpam_id   and demrm_id= demrd_demrm_id    
																	AND    dpam_dpm_id      = @l_dpm_id    
																	AND    ltrim(rtrim(isnull(demrm_batch_no,''))) = '' 
																	AND	  ISNULL(DEMRM_INTERNAL_REJ,'') = '' 
																	AND    demrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																								AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
						
																	IF @L_TOT_REC > 0  
																	BEGIN   
						
																				/* Update in Demat_request_mstr*/   
																				UPDATE D1 Set demrm_batch_no=@pa_batch_no FROM demat_request_mstr D1 ,dp_acct_mstr D2  
																				WHERE  demrm_dpam_id = dpam_id   
																				AND    dpam_dpm_id   = @l_dpm_id    
																				AND    isnull(demrm_status,'P')='P'  
																				AND    ltrim(rtrim(isnull(demrm_batch_no,''))) = ''
																				AND	  ISNULL(DEMRM_INTERNAL_REJ,'') = ''  
																				AND    demrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																				AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  
																				/* Update in Bitmap ref mstr*/   
																				UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
																				WHERE   BITRM_PARENT_CD = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  
						
																				/* insert into batch table*/                    
																						IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@l_TRX_TAB)  
																							BEGIN  
																								INSERT INTO BATCHNO_CDSL_MSTR                                       
																								(    
																									BATCHC_DPM_ID,  
																									BATCHC_NO,  
																									BATCHC_RECORDS ,  
																									BATCHC_TRANS_TYPE,
																									BATCHC_FILEGEN_DT,           
																									BATCHC_TYPE,  
																									BATCHC_STATUS,  
																									BATCHC_CREATED_BY,  
																									BATCHC_CREATED_DT ,  
																									BATCHC_DELETED_IND  
																								)  
																								VALUES  
																								(  
																									@L_DPM_ID,  
																									@PA_BATCH_NO,  
																									@L_TOT_REC,  
																									@l_TRX_TAB,
																									CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'  ,
																									'T',  
																									'P',  
																									@PA_LOGINNAME,  
																									GETDATE(),  
																									1  
																								)      
																																																																	END  
																	END   
						
															END  
																																ELSE  
															BEGIN   
																Select convert(char(16),isnull(dpam_sba_no,''))  
																	+ convert(char(12),isnull(demrm_isin,''))  
																	+ convert(char(16),citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(demrm_qty)),13,3,'L','0'))   
																	+ convert(char(16),isnull(demrm_slip_serial_no,''))   
                                                                    + convert(char(20),convert(varchar(20),case when isnull(disp_doc_id,0) =0 then '' else convert(varchar(20),disp_doc_id) end))  
											                        + convert(char(30),isnull(disp_name,''))  
																	+ case when convert(char(8),replace(convert(varchar(11),isnull(Disp_dt,space(8)),103),'/','')) = '01011900' then  convert(char(8),'00000000') else convert(char(8),replace(convert(varchar(11),isnull(Disp_dt,space(8)),103),'/','')) end
        															+ convert(char(5),citrus_usr.FN_FORMATSTR(CONVERT(VARCHAR(5),isnull(demrm_total_certificates,'0')),5,0,'L','0'))    
																	+ convert(char(1),isnull(demrm_free_lockedin_yn,''))  
																	+ convert(char(2),isnull(demrm_lockin_reason_cd,''))  
																	+ convert(char(50),case when ltrim(rtrim(isnull(DEMRM_RMKS,'')))='' then space(50) else ltrim(rtrim(isnull(DEMRM_RMKS,''))) end ) 
																	+ case when convert(char(8),replace(convert(varchar(11),isnull(DEMRM_LOCKIN_RELEASE_DT,space(8)),103),'/','')) = '01011900'  or isnull(demrm_free_lockedin_yn,'N')='N' then  convert(char(8),'00000000') else convert(char(8),replace(convert(varchar(11),isnull(DEMRM_LOCKIN_RELEASE_DT,space(8)),103),'/','')) end  DETAILS
                                                                    ,abs(demrm_qty) qty
																	FROM  demat_request_mstr  
																    left outer join dmat_dispatch on demrm_id=disp_demrm_id
																	,dp_acct_mstr  
																	WHERE demrm_dpam_id     = dpam_id   
																	AND   dpam_deleted_ind  = 1  
																	AND   demrm_deleted_ind = 1  
																	AND   isnull(demrm_status,'P')='P' 
																	AND	  ISNULL(DEMRM_INTERNAL_REJ,'') = '' 
																	AND   ltrim(rtrim(isnull(demrm_batch_no,''))) = @pa_batch_no  
																	AND   demrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'       
																	AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
															END   
						
						
												--  
												END 

----PLEDGE

						IF @l_TRX_TAB= 'PLEDGE'  
						BEGIN  
						--  
								IF @PA_BATCH_TYPE = 'BN'  
									BEGIN  
										Select convert(char(1),case when pldtc_trastm_cd in('CRTE','CONF') then 'P'  when pldtc_trastm_cd in('CLOS') then 'U' else '' end )--'P','U','C','A'  
										 + convert(char(1),case when pldtc_trastm_cd = 'CRTE' and isnull(PLDTC_SUB_STATUS,'') = '' then 'S'
															  when pldtc_trastm_cd = 'CONF' and isnull(PLDTC_SUB_STATUS,'') = '' then 'A'
															  when pldtc_trastm_cd = 'CLOS' and isnull(PLDTC_SUB_STATUS,'') = '' then 'S'
															  when isnull(PLDTC_SUB_STATUS,'') <> '' then isnull(PLDTC_SUB_STATUS,'') 
															  else '' end ) --'P' THEN 'S','A','R','C','E' --   'U' THEN 'S','A','R','C','E'--'A' THEN 'S','E'--'C' THEN 'S','E'
										 + convert(char(1),case when pldtc_trastm_cd = 'CRTE' and isnull(PLDTC_SUB_STATUS,'') = '' then isnull(PLDTC_SECURITTIES,'') else '' end)--'P''S' THEN 'F','L'   
										 + convert(char(16),isnull(A.DPAM_SBA_NO,'')) --'P''S''L'   
										 + convert(char(8),case when pldtc_trastm_cd = 'CRTE' and isnull(PLDTC_SUB_STATUS,'') = '' then '00000000' else isnull(PLDTC_PSN,'') end)  --'P''S' THEN '00000000' ELSE MEND PLDTC_PSN
										 + convert(char(16),isnull(A.DPAM_SBA_NO,''))  
											+ convert(char(16),isnull(PLDTC_PLDG_CLIENTID,''))  
										 + convert(char(12),isnull(PLDTC_ISIN,''))  
										 + convert(char(16),citrus_usr.FN_FORMATSTR(abs(PLDTC_QTY),13,3,'L','0'))--'P' OR ZEROS
									     --+ convert(char(15),citrus_usr.FN_FORMATSTR(abs(PLDTC_QTY),13,3,'L','0'))--'P' OR ZEROS--PLEDGE VALUE?????????
										 + convert(char(15),citrus_usr.FN_FORMATSTR(abs(CLOPM_CDSL_RT*PLDTC_QTY),13,3,'L','0'))--'P' OR ZEROS--PLEDGE VALUE?????????
										 + convert(char(8),case when pldtc_trastm_cd = 'CRTE' and isnull(PLDTC_SUB_STATUS,'') = '' then replace(convert(varchar(11),PLDTC_EXPIRY_DT,103),'/','') else '00000000' end) --'P''S' ELSE ZEROS 
										 + convert(char(16),case when pldtc_trastm_cd = 'CONF'  then PLDTC_ID else '' end )  --'PLEDGEE DP INTERNAL REF NO'
									     + convert(char(16),case when pldtc_trastm_cd = 'CRTE'  then PLDTC_ID else '' end ) --'PLEDGEE DP INTERNAL REF NO'  
										 + convert(char(20),PLDTC_AGREEMENT_NO)  --'P''S'
										 + convert(char(4),'0000') 
										 + convert(char(16),citrus_usr.FN_FORMATSTR(abs(PLDTC_QTY),13,3,'L','0'))--UNPLEDGE / AUTO UNPLEDGE / CONFISCATE PART QUANTITY
										 + convert(char(100),PLDTC_RMKS)  DETAILS
										,citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(PLDTC_QTY)),13,3,'L','0') QTY
										FROM  cdsl_pledge_dtls, closing_price_mstr_cdsl
										,dp_acct_mstr  A
										WHERE PLDTC_DPAM_ID = A.dpam_id  
										and   CLOPM_ISIN_CD =   PLDTC_ISIN
										and   PLDTC_REQUEST_DT = CLOPM_DT 
										AND   A.dpam_deleted_ind  = 1  
										AND   pldtc_deleted_ind = 1  
										AND   isnull(pldtc_status,'P')='P'  
										AND   ltrim(rtrim(isnull(pldtc_batch_no,''))) = ''  
										AND   pldtc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'       
										AND   dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
										 
						
										SELECT @L_TOT_REC = COUNT(pldtc_id) FROM cdsl_pledge_dtls ,dp_acct_mstr  
										WHERE  isnull(pldtc_status,'P')='P' and PLDTC_DPAM_ID = dpam_id   
										AND    dpam_dpm_id      = @l_dpm_id    
										AND    ltrim(rtrim(isnull(pldtc_batch_no,''))) = ''  
										AND    pldtc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
										AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END

										IF @L_TOT_REC > 0  
										BEGIN   
										/* Update in Demat_request_mstr*/   
										UPDATE D1 Set pldtc_batch_no=@pa_batch_no FROM cdsl_pledge_dtls D1 ,dp_acct_mstr D2  
										WHERE  PLDTC_DPAM_ID = dpam_id   
										AND    dpam_dpm_id   = @l_dpm_id    
										AND    isnull(pldtc_status,'P')='P'  
										AND    ltrim(rtrim(isnull(pldtc_batch_no,''))) = ''  
										AND    pldtc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
										AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  

										/* Update in Bitmap ref mstr*/   
										UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
										WHERE   BITRM_PARENT_CD = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  
										  
														/* insert into batch table*/                    
																IF NOT EXISTS(SELECT BATCHN_NO FROM BATCHNO_NSDL_MSTR   WHERE BATCHN_NO  = @PA_BATCH_NO AND BATCHN_DPM_ID = @L_DPM_ID AND BATCHN_DELETED_IND =1)  
																	BEGIN  
																		INSERT INTO BATCHNO_CDSL_MSTR                                       
																		(    
																			BATCHC_DPM_ID,  
																			BATCHC_NO,  
																			BATCHC_RECORDS ,  
																			BATCHC_TRANS_TYPE,
																			BATCHC_FILEGEN_DT,           
																			BATCHC_TYPE,  
																			BATCHC_STATUS,  
																			BATCHC_CREATED_BY,  
																			BATCHC_CREATED_DT ,  
																			BATCHC_DELETED_IND  
																		)  
																		VALUES  
																		(  
																			@L_DPM_ID,  
																			@PA_BATCH_NO,  
																			@L_TOT_REC,  
																			@PA_BATCH_TYPE,
																			CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'  ,
																			'T',  
																			'P',  
																			@PA_LOGINNAME,  
																			GETDATE(),  
																			1  
																		)      
																																																											END  
											END   

									END  
																										ELSE  
									BEGIN   
										Select convert(char(1),case when pldtc_trastm_cd in('CRTE','CONF') then 'P'  when pldtc_trastm_cd in('CLOS') then 'U' else '' end )--'P','U','C','A'  
										 + convert(char(1),case when pldtc_trastm_cd = 'CRTE' and isnull(PLDTC_SUB_STATUS,'') = '' then 'S'
										   when pldtc_trastm_cd = 'CONF' and isnull(PLDTC_SUB_STATUS,'') = '' then 'A'
										   when pldtc_trastm_cd = 'CLOS' and isnull(PLDTC_SUB_STATUS,'') = '' then 'S'
										   when isnull(PLDTC_SUB_STATUS,'') <> '' then isnull(PLDTC_SUB_STATUS,'') 
										   else '' end ) --'P' THEN 'S','A','R','C','E' --   'U' THEN 'S','A','R','C','E'--'A' THEN 'S','E'--'C' THEN 'S','E'
										 + convert(char(1),case when pldtc_trastm_cd = 'CRTE' and isnull(PLDTC_SUB_STATUS,'') = '' then isnull(PLDTC_SECURITTIES,'') else '' end)--'P''S' THEN 'F','L'   
										 + convert(char(16),isnull(A.DPAM_SBA_NO,'')) --'P''S''L'   
										 + convert(char(8),case when pldtc_trastm_cd = 'CRTE' and isnull(PLDTC_SUB_STATUS,'') = '' then '00000000' else isnull(PLDTC_PSN,'') end)  --'P''S' THEN '00000000' ELSE MEND PLDTC_PSN
										 + convert(char(16),isnull(A.DPAM_SBA_NO,''))  
											+ convert(char(16),isnull(PLDTC_PLDG_CLIENTID,''))  
										 + convert(char(12),isnull(PLDTC_ISIN,''))  
										 + convert(char(16),citrus_usr.FN_FORMATSTR(abs(PLDTC_QTY),13,3,'L','0'))--'P' OR ZEROS
											--+ convert(char(15),citrus_usr.FN_FORMATSTR(abs(PLDTC_QTY),13,3,'L','0'))--'P' OR ZEROS--PLEDGE VALUE?????????
										+ convert(char(15),citrus_usr.FN_FORMATSTR(abs(CLOPM_CDSL_RT*PLDTC_QTY),13,3,'L','0'))--'P' OR ZEROS--PLEDGE VALUE?????????
										 + convert(char(8),case when pldtc_trastm_cd = 'CRTE' and isnull(PLDTC_SUB_STATUS,'') = '' then replace(convert(varchar(11),PLDTC_EXPIRY_DT,103),'/','') else '00000000' end) --'P''S' ELSE ZEROS 
										 + convert(char(16),case when pldtc_trastm_cd = 'CONF'  then PLDTC_ID else '' end )  --'PLEDGEE DP INTERNAL REF NO'
									     + convert(char(16),case when pldtc_trastm_cd = 'CRTE'  then PLDTC_ID else '' end ) --'PLEDGEE DP INTERNAL REF NO'  
										 + convert(char(20),PLDTC_AGREEMENT_NO)  --'P''S'
										 + convert(char(4),'0000') --'UNPLEDGE / AUTO UNPLEDGE / CONFISCATE PART COUNTER' 
											+ convert(char(16),citrus_usr.FN_FORMATSTR(abs(PLDTC_QTY),13,3,'L','0'))--UNPLEDGE / AUTO UNPLEDGE / CONFISCATE PART QUANTITY
										 + convert(char(100),PLDTC_RMKS)  DETAILS
										,citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(PLDTC_QTY)),13,3,'L','0') QTY
										FROM  cdsl_pledge_dtls,closing_price_mstr_cdsl
										,dp_acct_mstr  A
										WHERE PLDTC_DPAM_ID = A.dpam_id  
										and   CLOPM_ISIN_CD =   PLDTC_ISIN
										and   PLDTC_REQUEST_DT = CLOPM_DT  
										AND   A.dpam_deleted_ind  = 1  
										AND   pldtc_deleted_ind = 1  
										AND   isnull(pldtc_status,'P')='P'  
										AND   ltrim(rtrim(isnull(pldtc_batch_no,''))) = @PA_BATCH_NO
										AND   pldtc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'       
										AND   dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
										 
									END   


						--  
						END  
---PLEDGE
---FRZ
						IF @l_TRX_TAB= 'FRZ'  
						BEGIN  
						--  
								IF @PA_BATCH_TYPE = 'BN'  
									BEGIN  
										
												SELECT   isnull(fre_trans_type,space(1)) 
												+ convert(char(8),citrus_usr.FN_FORMATSTR(fre_id,8,0,'L','0'))
												+ isnull(fre_level,space(1))
												+ isnull(convert(varchar(1),fre_initiated_by),'0')
												+ isnull(convert(varchar(1),fre_sub_option),'0')
												+ convert(char(16),isnull(dpam_sba_no,''))
												+ convert(char(12),isnull(fre_isin,''))
												+ convert(char(1),isnull(fre_qty_type,''))
												+ convert(char(16),citrus_usr.FN_FORMATSTR(abs(fre_qty),16,3,'L','0'))
												+ convert(char(1),isnull(fre_frozen_for,''))
												+ isnull(convert(varchar(1),fre_activation_type),'0')
												+ case when fre_activation_type = 1 then '00000000' else REPLACE(CONVERT(VARCHAR(11),fre_activation_dt,102),'.','') end
												+ REPLACE(CONVERT(VARCHAR(11),fre_expiry_dt,102),'.','')
												+ right('0' +isnull(convert(char(2),fre_reason_cd),'00'),2)
												+ convert(char(16),isnull(fre_int_ref_no,''))
												+ convert(char(100),isnull(fre_rmks,'')) DETAILS
												,abs(fre_qty) qty
												FROM freeze_Unfreeze_dtls_cdsl D1 
											       , DP_ACCT_MSTR D2   
												WHERE D1.fre_Dpam_id = convert(varchar,D2.DPAM_ID) AND DPAM_DPM_ID = @L_DPM_ID   
												AND D1.fre_activation_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  																								  
												AND LTRIM(RTRIM(ISNULL(D1.FRE_BATCH_NO,'0'))) = '0' 
												AND d1.fre_trans_type='S'
												AND isnull(D1.fre_upload_status,'P')='P'
												AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
												AND D1.fre_deleted_ind = 1   
												
						
										SELECT @L_TOT_REC = COUNT(fre_id) FROM freeze_Unfreeze_dtls_cdsl ,dp_acct_mstr  
										WHERE  isnull(fre_upload_status,'P')='P' and fre_DPAM_ID = convert(varchar,dpam_id)   
										AND    dpam_dpm_id      = @l_dpm_id    
										AND    ltrim(rtrim(isnull(fre_batch_no,'0'))) = '0'  
										AND    fre_activation_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
										AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END

										IF @L_TOT_REC > 0  
										BEGIN   
										/*Update in Demat_request_mstr*/   
										UPDATE D1 Set fre_batch_no=@pa_batch_no FROM freeze_Unfreeze_dtls_cdsl D1 ,dp_acct_mstr D2  
										WHERE  fre_DPAM_ID = convert(varchar,dpam_id)  
										AND    dpam_dpm_id   = @l_dpm_id    
										AND    isnull(fre_status,'P')='P'  
										AND    ltrim(rtrim(isnull(fre_batch_no,'0'))) = '0'  
										AND    fre_activation_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
										AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  

										/* Update in Bitmap ref mstr*/   
										UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
										WHERE   BITRM_PARENT_CD = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  
										  
														/* insert into batch table*/                    
																IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1)  
																	BEGIN  
																		INSERT INTO BATCHNO_CDSL_MSTR                                       
																		(    
																			BATCHC_DPM_ID,  
																			BATCHC_NO,  
																			BATCHC_RECORDS ,  
																			BATCHC_TRANS_TYPE,
																			BATCHC_FILEGEN_DT,           
																			BATCHC_TYPE,  
																			BATCHC_STATUS,  
																			BATCHC_CREATED_BY,  
																			BATCHC_CREATED_DT ,  
																			BATCHC_DELETED_IND  
																		)  
																		VALUES  
																		(  
																			@L_DPM_ID,  
																			@PA_BATCH_NO,  
																			@L_TOT_REC,  
																			@PA_BATCH_TYPE,
																			CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'  ,
																			'T',  
																			'P',  
																			@PA_LOGINNAME,  
																			GETDATE(),  
																			1  
																		)      
																																																											END  
											END   

									END  
																										ELSE  
									BEGIN   
												SELECT   isnull(fre_trans_type,space(1)) 
												+ convert(char(8),citrus_usr.FN_FORMATSTR(fre_id,8,0,'L','0'))
												+ isnull(fre_level,space(1))
												+ isnull(convert(varchar(1),fre_initiated_by),'0')
												+ isnull(convert(varchar(1),fre_sub_option),'0')
												+ convert(char(16),isnull(dpam_sba_no,''))
												+ convert(char(12),isnull(fre_isin,''))
												+ convert(char(1),isnull(fre_qty_type,''))
												+ convert(char(16),citrus_usr.FN_FORMATSTR(abs(fre_qty),16,3,'L','0'))
												+ convert(char(1),isnull(fre_frozen_for,''))
												+ isnull(convert(varchar(1),fre_activation_type),'0')
												+ case when fre_activation_type = 1 then '00000000' else REPLACE(CONVERT(VARCHAR(11),fre_activation_dt,102),'.','') end
												+ REPLACE(CONVERT(VARCHAR(11),fre_expiry_dt,102),'.','')
												+ right('0' +isnull(convert(char(2),fre_reason_cd),'00'),2)
												+ convert(char(16),isnull(fre_int_ref_no,''))
												+ convert(char(100),isnull(fre_rmks,'')) DETAILS
												,abs(fre_qty) qty
												FROM freeze_Unfreeze_dtls_cdsl D1 
											       , DP_ACCT_MSTR D2   
												WHERE D1.fre_Dpam_id = convert(varchar,D2.DPAM_ID) AND DPAM_DPM_ID = @L_DPM_ID   
												AND D1.fre_activation_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  																							  
												AND LTRIM(RTRIM(ISNULL(D1.FRE_BATCH_NO,'0'))) = '0' 
                                                AND d1.fre_trans_type='S'
                                                AND isnull(D1.fre_upload_status,'P')='P'
												AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
												AND D1.fre_deleted_ind = 1  

									END   


						--  
						END  
---FRZ

--UNFRZ
						IF @l_TRX_TAB= 'UNFRZ'  
						BEGIN  
						--  
								IF @PA_BATCH_TYPE = 'BN'  
									BEGIN  
										
												select isnull(d2.fre_trans_type,space(1)) 
													+ convert(char(8),citrus_usr.FN_FORMATSTR(d2.fre_id,8,0,'L','0'))
													+' 00                             0000000000000000 0                00                '
													+ convert(char(100),isnull(D2.fre_rmks,'')) DETAILS
													,abs(d1.fre_qty) qty
												from freeze_Unfreeze_dtls_cdsl d1
													,freeze_Unfreeze_dtls_cdsl d2
													,DP_ACCT_MSTR D3
												where d1.fre_id = d2.fre_id
													and d1.fre_dpam_id = d3.dpam_id
													and d2.fre_trans_type ='U'
													and d1.fre_status ='I'
													and d2.fre_status ='A'
												AND D2.fre_lst_upd_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  																								  
												AND LTRIM(RTRIM(ISNULL(D1.FRE_BATCH_NO,'0'))) = '0' 
												AND isnull(D1.fre_upload_status,'P')='P'
												AND D3.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
												and d2.fre_deleted_ind = 1
												and d1.fre_deleted_ind = 1
												and d3.dpam_deleted_ind = 1 
						
										SELECT @L_TOT_REC = COUNT(fre_id) FROM freeze_Unfreeze_dtls_cdsl ,dp_acct_mstr  
										WHERE  isnull(fre_upload_status,'P')='P' and fre_DPAM_ID = convert(varchar,dpam_id)   
										AND    dpam_dpm_id      = @l_dpm_id    
										AND    ltrim(rtrim(isnull(fre_batch_no,'0'))) = '0'  
										AND    fre_created_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
										AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END

										IF @L_TOT_REC > 0  
										BEGIN   
										/* Update in Demat_request_mstr*/   
										UPDATE D1 Set fre_batch_no=@pa_batch_no FROM freeze_Unfreeze_dtls_cdsl D1 ,dp_acct_mstr D2  
										WHERE  fre_DPAM_ID = convert(varchar,dpam_id)   
										AND    dpam_dpm_id   = @l_dpm_id    
										AND    isnull(fre_status,'P')='P'  
										AND    ltrim(rtrim(isnull(fre_batch_no,'0'))) = '0'  
										AND    fre_created_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
										AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  

										/* Update in Bitmap ref mstr*/   
										UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
										WHERE   BITRM_PARENT_CD = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  
										  
														/* insert into batch table*/                    
																IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1)  
																	BEGIN  
																		INSERT INTO BATCHNO_CDSL_MSTR                                       
																		(    
																			BATCHC_DPM_ID,  
																			BATCHC_NO,  
																			BATCHC_RECORDS ,  
																			BATCHC_TRANS_TYPE,
																			BATCHC_FILEGEN_DT,           
																			BATCHC_TYPE,  
																			BATCHC_STATUS,  
																			BATCHC_CREATED_BY,  
																			BATCHC_CREATED_DT ,  
																			BATCHC_DELETED_IND  
																		)  
																		VALUES  
																		(  
																			@L_DPM_ID,  
																			@PA_BATCH_NO,  
																			@L_TOT_REC,  
																			@PA_BATCH_TYPE,
																			CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'  ,
																			'T',  
																			'P',  
																			@PA_LOGINNAME,  
																			GETDATE(),  
																			1  
																		)      
																																																											END  
											END   

									END  
									ELSE  
									BEGIN   
									select isnull(d2.fre_trans_type,space(1)) 
											+ convert(char(8),citrus_usr.FN_FORMATSTR(d2.fre_id,8,0,'L','0'))
											+' 00                             0000000000000000 0                00                '
											+ convert(char(100),isnull(D2.fre_rmks,'')) DETAILS
											,abs(d1.fre_qty) qty
									from freeze_Unfreeze_dtls_cdsl d1
										,freeze_Unfreeze_dtls_cdsl d2
										,DP_ACCT_MSTR D3
									where d1.fre_id = d2.fre_id
										and d1.fre_dpam_id = d3.dpam_id
										and d2.fre_trans_type ='U'
										and d1.fre_status ='I'
										and d2.fre_status ='A'
									AND D2.fre_lst_upd_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  																								  
									AND LTRIM(RTRIM(ISNULL(D1.FRE_BATCH_NO,'0'))) = '0' 
									AND isnull(D1.fre_upload_status,'P')='P'
									AND D3.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
									and d2.fre_deleted_ind = 1
									and d1.fre_deleted_ind = 1
									and d3.dpam_deleted_ind = 1

									END   


						--  
						END  

--UNFRZ

 
--												IF @l_TRX_TAB= 'CLSR_ACCT_GEN'   
--												BEGIN  
--													SELECT * FROM CLOSURE_ACCT_MSTR WHERE  CLSR_DATE BETWEEN   
--													CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT ,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'     
--													AND CLSR_DELETED_IND=1  
--												END   
IF @L_TRX_TAB= 'CLSR_ACCT_GEN'         
      BEGIN  
           
Print 'N'

 SELECT CONVERT(VARCHAR(16),ISNULL(CLSR_BO_ID,''))AS CLSR_BO_ID ,
		CONVERT(VARCHAR(1),ISNULL(CLSR_TRX_TYPE,''))AS CLSR_TRX_TYPE,
		CONVERT(VARCHAR(2),ISNULL(CLSR_INI_BY,''))AS CLSR_INI_BY ,
		CONVERT(VARCHAR(2),ISNULL(CLSR_REASON_CD,'')) AS CLSR_REASON_CD ,
		CONVERT(VARCHAR(1),ISNULL(CLSR_REMAINING_BAL,''))AS CLSR_REMAINING_BAL ,
		CONVERT(VARCHAR(16),ISNULL(CLSR_NEW_BO_ID,''))AS CLSR_NEW_BO_ID ,
		CONVERT(VARCHAR(100),LTRIM(RTRIM(ISNULL(CLSR_RMKS,'')))) AS CLSR_RMKS,
		CONVERT(VARCHAR(16),ISNULL(CLSR_ID,0)) AS CLSR_REQ_INT_REFNO  
		FROM CLOSURE_ACCT_CDSL 
		WHERE CONVERT(DATETIME,CONVERT(VARCHAR(11),CLSR_DATE,109)) BETWEEN @PA_FROM_DT  AND @PA_TO_DT       
  	    and CLSR_DPM_ID = @L_DPM_ID

		SELECT @L_TOT_REC = COUNT(CLSR_ID) FROM CLOSURE_ACCT_CDSL      
		WHERE CONVERT(DATETIME,CONVERT(VARCHAR(11),CLSR_DATE,109)) BETWEEN @PA_FROM_DT  AND @PA_TO_DT       
        and CLSR_DPM_ID = @L_DPM_ID
        and isnull(CLSR_BATCH_NO,0) =0

---Select * from CLOSURE_ACCT_CDSL 

--SELECT @L_TOT_REC = COUNT(CLSR_ID) FROM CLOSURE_ACCT_CDSL      
--WHERE  CLSR_DATE BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)  AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)        
				 
PRINT(@L_TOT_REC)
	IF @L_TOT_REC > 0 
	
BEGIN         
          /* UPDATE IN BITMAP_REF_MSTR TABLE */         
          if @PA_BATCH_TYPE = 'CDSL'
          Begin
 		    UPDATE BITMAP_REF_MSTR SET BITRM_VALUES = CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))             
            WHERE   BITRM_PARENT_CD = 'CDSL_BTCH_CLOSURE_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID 
 	  print 'hetal'
 	      print(@PA_BATCH_NO)
		   UPDATE CLOSURE_ACCT_CDSL SET CLSR_BATCH_NO =  @PA_BATCH_NO 
		   WHERE CONVERT(DATETIME,CONVERT(VARCHAR(11),CLSR_DATE,109)) BETWEEN @PA_FROM_DT  AND @PA_TO_DT       
 			and CLSR_DPM_ID = @L_DPM_ID
            and isnull(CLSR_BATCH_NO,0) =0

--           UPDATE CLOSURE_ACCT_CDSL SET CLSR_BATCH_NO = @PA_BATCH_NO 
--		   WHERE CLSR_DATE BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106) AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)        
-- 			
-- 
          /* INSERT INTO BATCHNO_CDSL_MSTR */                          
				
			IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1)        
                 BEGIN        
                  INSERT INTO BATCHNO_CDSL_MSTR                                             
                  (          
                   BATCHC_DPM_ID,        
                   BATCHC_NO,        
                   BATCHC_RECORDS,        
                   BATCHC_TRANS_TYPE,      
                   BATCHC_FILEGEN_DT,                 
                   BATCHC_TYPE,        
                   BATCHC_STATUS,        
                   BATCHC_CREATED_BY,        
                   BATCHC_CREATED_DT ,        
                   BATCHC_DELETED_IND        
                  )        
                  VALUES        
                  (        
                   @L_DPM_ID,        
                   @PA_BATCH_NO,        
                   CONVERT(NUMERIC,@L_TOT_REC),       
				   'ACCOUNT CLOSURE',      
                   CONVERT(VARCHAR,CONVERT(DATETIME,@PA_FROM_DT,103),106)+' 00:00:00'  ,      
                   'T',        
                   'AC',        
                   @PA_LOGINNAME,        
                   GETDATE(),        
                   1        
                  ) 
  
            END
			END  
        else
        Begin
            UPDATE BITMAP_REF_MSTR SET BITRM_VALUES = CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))             
            WHERE   BITRM_PARENT_CD = 'NSDL_BTCH_CLOSURE_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID 
 	  
 	      print(@PA_BATCH_NO)
		   UPDATE CLOSURE_ACCT_CDSL SET CLSR_BATCH_NO =  @PA_BATCH_NO 
		   WHERE CONVERT(DATETIME,CONVERT(VARCHAR(11),CLSR_DATE,109)) BETWEEN @PA_FROM_DT  AND @PA_TO_DT       
 			and CLSR_DPM_ID = @L_DPM_ID
 
--           UPDATE CLOSURE_ACCT_CDSL SET CLSR_BATCH_NO = @PA_BATCH_NO 
--		   WHERE CLSR_DATE BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106) AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)        
-- 			
-- 
          /* INSERT INTO BATCHNO_CDSL_MSTR */                          
				
			IF NOT EXISTS(SELECT BATCHN_NO FROM BATCHNO_NSDL_MSTR   WHERE BATCHN_NO  = @PA_BATCH_NO AND BATCHN_DPM_ID = @L_DPM_ID AND BATCHN_DELETED_IND =1)        
                 BEGIN        
                  INSERT INTO BATCHNO_NSDL_MSTR                                             
                  (          
                   BATCHN_DPM_ID,        
                   BATCHN_NO,        
                   BATCHN_RECORDS,        
                   BATCHN_STATUS,      
                   BATCHN_TRANS_TYPE,                 
                   BATCHN_FILEGEN_DT,        
                   BATCHN_CREATED_BY,        
                   BATCHN_CREATED_DT ,
                   BATCHN_DELETED_IND,
                   BATCHN_TYPE        
                  )        
                  VALUES        
                  (        
                   @L_DPM_ID,        
                   @PA_BATCH_NO,        
                   CONVERT(NUMERIC,@L_TOT_REC),       
				   'P',
                   'ACCOUNT CLOSURE', 
                   CONVERT(VARCHAR,CONVERT(DATETIME,@PA_FROM_DT,103),106)+' 00:00:00',     
                   @PA_LOGINNAME,
                   getdate() , 
                   1,
                   'AC'        
                  ) 
  
				END 
           END               
		END
	END 


    --
    END
  --  
  END  
  --  
  END  
    
--  
END

GO
