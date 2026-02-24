-- Object: PROCEDURE citrus_usr.pr_select_trxgen_cdsl_SP_bak_14022020
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------









--begin tran
--select * from dp_mstr where default_dp=dpm_excsm_id
--pr_select_trxgen_cdsl_sp 'OFFM','25/11/2008','25/11/2008','1','BN',3,'HO','','A','*|~*','|*~|',''
--rollback
CREATE PROCEDURE [citrus_usr].[pr_select_trxgen_cdsl_SP_bak_14022020]  
(  
@PA_TRX_TAB VARCHAR(8000),  
@PA_FROM_DT VARCHAR(20),  
@PA_TO_DT VARCHAR(20),  
@PA_BATCH_NO VARCHAR(10),  
@PA_BATCH_TYPE VARCHAR(2),  
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


declare @PA_FROM_DT_Miss varchar(11),@PA_TO_DT_Miss varchar(11)
set @PA_FROM_DT_Miss = CONVERT(varchar(11),convert(datetime,@PA_FROM_DT,103),109)
set @PA_TO_DT_Miss = CONVERT(varchar(11),convert(datetime,@PA_FROM_DT,103)+1,109)
exec pr_insert_missing_slip @PA_FROM_DT_Miss,@PA_TO_DT_Miss


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
														--+ convert(char(16),isnull(dptdc_counter_demat_acct_no,''))  
                                                        + case when len(dptdc_counter_demat_acct_no)=16 then convert(char(16),isnull(dptdc_counter_demat_acct_no,''))  else convert(char(8),isnull(dptdc_counter_dp_id,'')) + convert(char(8),isnull(dptdc_counter_demat_acct_no,'')) end
														+ convert(char(16),DPTDC_SLIP_NO+'/'+dptdc_internal_ref_no)
														+ convert(char(8),replace(convert(varchar(11),dptdc_execution_dt,103),'/',''))  DETAILS
														, abs(dptdc_qty) qty, 'N' TRXEFLG ,citrus_usr.fn_get_slip_no_export(dpam_sba_no,dptdc_slip_no) dptdc_slip_no , dptdc_created_by , case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')='' then dptdc_lst_upd_by else isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'') end dptdc_lst_upd_by , case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')<>'' then dptdc_lst_upd_by else '' end verifier
														,dptdc_id  as USN,''
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
												--AND    dpam_dpm_id =@l_dpm_id
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
												order by dptdc_lst_upd_dt 

															SELECT @L_TOT_REC = COUNT(DPTDC_ID) FROM dp_trx_dtls_cdsl ,dp_acct_mstr  
																																							WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
															--AND    dpam_dpm_id   = @l_dpm_id    
															AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
															AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
															AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
															AND    dptdc_internal_trastm = @l_TRX_TAB  
															AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 

															IF @L_TOT_REC > 0   
															BEGIN   
																	/* Update in dp_trx_dtls_cdsl*/ 

															SELECT @L_TRANS_TYPE = dptdc_internal_trastm FROM dp_trx_dtls_cdsl ,dp_acct_mstr  
															WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
															--AND    dpam_dpm_id   = @l_dpm_id    
															AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
															AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
															AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
															AND    dptdc_internal_trastm = @l_TRX_TAB   
															AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
															AND    isnull(DPTDC_BROKERBATCH_NO,'') <> ''

															UPDATE D1 Set dptdc_batch_no=@pa_batch_no FROM dp_trx_dtls_cdsl D1 ,dp_acct_mstr D2  
															WHERE  dptdc_dpam_id = dpam_id   
															--AND    dpam_dpm_id   = @l_dpm_id    
															AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
															AND    isnull(dptdc_status,'P')='P'  
															AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
															AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
															AND    dptdc_internal_trastm = @l_TRX_TAB   
															AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
															AND    isnull(DPTDC_BROKERBATCH_NO,'') <> ''


															/* Update in Bitmap ref mstr*/   
--															UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
--															WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' 
--															AND BITRM_CHILD_CD = @L_DPM_ID 
--															AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  

															/* insert into batch table*/  



--																	IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@l_TRX_TAB)  
--																	BEGIN  
--																		INSERT INTO BATCHNO_CDSL_MSTR                                       
--																		(    
--																			BATCHC_DPM_ID,  
--																			BATCHC_NO,  
--																			BATCHC_RECORDS ,  
--																			BATCHC_TRANS_TYPE,          
--																			BATCHC_TYPE,  
--																			BATCHC_FILEGEN_DT,
--																			BATCHC_STATUS,  
--																			BATCHC_CREATED_BY,  
--																			BATCHC_CREATED_DT ,  
--																			BATCHC_DELETED_IND  
--																		)  
--																		VALUES  
--																		(  
--																			@L_DPM_ID,  
--																			@PA_BATCH_NO,  
--																			@L_TOT_REC,  
--																			@L_TRANS_TYPE,  
--																			'T',  
--																			CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',
--																			'P',  
--																			@PA_LOGINNAME,  
--																			GETDATE(),  
--																			1  
--																		)      
--																																																											END  
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
														--+ convert(char(16),isnull(dptdc_counter_demat_acct_no,''))  
                                                        + case when len(dptdc_counter_demat_acct_no)=16 then convert(char(16),isnull(dptdc_counter_demat_acct_no,''))  else convert(char(8),isnull(dptdc_counter_dp_id,'')) + convert(char(8),isnull(dptdc_counter_demat_acct_no,'')) end
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
												--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end

												order by dptdc_lst_upd_dt 

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
													, case when dpam_sba_no=dptdc_created_by then 'Y' else  'N' end  TRXEFLG --'N'
													,citrus_usr.fn_get_slip_no_export(dpam_sba_no,dptdc_slip_no) dptdc_slip_no , dptdc_created_by , case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')='' then dptdc_lst_upd_by else isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'') end dptdc_lst_upd_by , case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')<>'' then dptdc_lst_upd_by else '' end verifier
													,dptdc_id   as USN,''
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
								--AND		dpam_dpm_id   = @L_DPM_ID
								AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
								order by dptdc_lst_upd_dt 
 


									SELECT @L_TOT_REC = COUNT(DPTDC_ID) FROM dp_trx_dtls_cdsl ,dp_acct_mstr  
																														WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
																														--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
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
												--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
												AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
												AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
												AND    dptdc_internal_trastm = @l_TRX_TAB 
												AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  
												AND    isnull(DPTDC_BROKERBATCH_NO,'') <> ''

												UPDATE D1 Set dptdc_batch_no=@pa_batch_no FROM dp_trx_dtls_cdsl D1 ,dp_acct_mstr D2  
												WHERE  dptdc_dpam_id = dpam_id   
												--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
												AND    isnull(dptdc_status,'P')='P'  
												AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
												AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
												AND    dptdc_internal_trastm = @l_TRX_TAB  
												AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
												AND    isnull(DPTDC_BROKERBATCH_NO,'') <> ''

															/* Update in Bitmap ref mstr*/   
--												UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
--												WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND  BITRM_CHILD_CD= @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  

												/* insert into batch table*/  



--																IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@l_TRX_TAB)  
--																	BEGIN  
--																		INSERT INTO BATCHNO_CDSL_MSTR                                       
--																		(    
--																			BATCHC_DPM_ID,  
--																			BATCHC_NO,  
--																			BATCHC_RECORDS ,  
--																			BATCHC_TRANS_TYPE,
--																			BATCHC_FILEGEN_DT,           
--																			BATCHC_TYPE,  
--																			BATCHC_STATUS,  
--																			BATCHC_CREATED_BY,  
--																			BATCHC_CREATED_DT ,  
--																			BATCHC_DELETED_IND  
--																		)  
--																		VALUES  
--																		(  
--																			@L_DPM_ID,  
--																			@PA_BATCH_NO,  
--																			@L_TOT_REC,  
--																			@L_TRANS_TYPE,
--																			CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',  
--																			'T',  
--																			'P',  
--																			@PA_LOGINNAME,  
--																			GETDATE(),  
--																			1  
--																		)      
--																																																											END  

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
								--AND		dpam_dpm_id   = @L_DPM_ID
								AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
								order by dptdc_lst_upd_dt 

								END   
						--  
						END  
						IF @l_TRX_TAB in ('OFFM')  
						BEGIN  
						--   
									-- in case of request for off market  
								IF @PA_BATCH_TYPE = 'BN'  
									BEGIN  
										SELECT  replace(convert(varchar(11),dptdc_execution_dt,103),'/','')  
												+ isnull(dpam_sba_no,'')  
												+ isnull(dptdc_counter_dp_id,'') + case when dpam_sba_no=dptdc_created_by then case when len(dptdc_counter_demat_acct_no)=8 then  right(isnull(dptdc_counter_demat_acct_no,''),8) else dptdc_counter_demat_acct_no end when (LEN(dptdc_counter_demat_acct_no)>8 and LEN(dptdc_counter_demat_acct_no)<>'16') then ISNULL(dptdc_counter_demat_acct_no,'')+ SPACE(1) else isnull(dptdc_counter_demat_acct_no,'') end  
												+ isnull(convert(char(12),dptdc_isin),'')  
												+ convert(varchar(16),citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(dptdc_qty)),12,3,'L','0'))    
												+ case  when dptdc_internal_trastm in('BOCM','CMCM') then 'S' when dptdc_internal_trastm = 'CMBO' then 'S' else 'S' end  
												+ isnull(dptdc_cash_trf,'') 
												--------rohan changes done for old format ---------------------------- need to revert  
												----+ case when isnull(convert(varchar(10),dptdc_reason_cd),'2')=0 then '2' else isnull(convert(varchar(10),dptdc_reason_cd),'2')  end--isnull(convert(varchar(10),dptdc_reason_cd),'2')  
												+ case when isnull(convert(varchar(10),dptdc_reason_cd),'2')=0 then SPACE(1) else isnull(convert(varchar(10),dptdc_reason_cd),'2')  end--isnull(convert(varchar(10),dptdc_reason_cd),'2')  
												
												+ convert(char(16),'/'+dptdc_internal_ref_no)--+ convert(char(16),ltrim(rtrim(DPTDC_SLIP_NO))+'/'+dptdc_internal_ref_no)
												--+ case when isnull(dptdc_settlement_no,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',dptdc_settlement_no,A.settm_type_cdsl),'')   +isnull(dptdc_settlement_no,''))  else convert(char(13),'') end 
                                                --+ case when isnull(DPTDC_OTHER_SETTLEMENT_NO,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',DPTDC_OTHER_SETTLEMENT_NO,B.settm_type_cdsl),'')   +isnull(DPTDC_OTHER_SETTLEMENT_NO,''))  else convert(char(13),'') end 
												+ case when dptdc_internal_trastm in ('CMCM') then case when isnull(DPTDC_OTHER_SETTLEMENT_NO,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',DPTDC_OTHER_SETTLEMENT_NO,B.settm_type_cdsl),'')   +isnull(DPTDC_OTHER_SETTLEMENT_NO,''))  else convert(char(13),'') end  else case when isnull(dptdc_settlement_no,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',dptdc_settlement_no,A.settm_type_cdsl),'')   +isnull(dptdc_settlement_no,''))  else convert(char(13),'') end end
                                                + case when dptdc_internal_trastm in ('CMCM') then case when isnull(dptdc_settlement_no,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',dptdc_settlement_no,A.settm_type_cdsl),'')   +isnull(dptdc_settlement_no,''))  else convert(char(13),'') end else case when isnull(DPTDC_OTHER_SETTLEMENT_NO,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',DPTDC_OTHER_SETTLEMENT_NO,B.settm_type_cdsl),'')   +isnull(DPTDC_OTHER_SETTLEMENT_NO,''))  else convert(char(13),'') end end
                                                
													+ convert(char(1),ltrim(rtrim(case when DPTDC_PAYMODE='Cheque Payment' then '1' when DPTDC_PAYMODE='Electronic Payment' then '2' when DPTDC_PAYMODE='Cash Payment' then '3' else '' end )))
	+ convert(char(35),isnull(DPTDC_BANKACNO,''))
	+ convert(char(100),isnull(DPTDC_BANKACNAME,''))
	+ convert(char(100),isnull(DPTDC_BANKBRNAME,''))
	+ convert(char(150),isnull(DPTDC_TRANSFEREENAME,''))
	+ case when convert(char(8),isnull(replace(convert(varchar(11),DPTDC_DOI,103),'/','')  ,''))='01011900' then SPACE(8) else convert(char(8),isnull(replace(convert(varchar(11),DPTDC_DOI,103),'/','')  ,'')) end --convert(char(8),isnull(replace(convert(varchar(11),DPTDC_DOI,103),'/','')  ,''))
	+ convert(char(22),isnull(DPTDC_CHQ_REFNO,''))
                                                   DETAILS--space(13) DETAILS  
												, abs(dptdc_qty) qty 
												, case when dpam_sba_no=dptdc_created_by then 'Y' else  'N' end TRXEFLG --'N' TRXEFLG 
												,citrus_usr.fn_get_slip_no_export(dpam_sba_no,dptdc_slip_no) dptdc_slip_no , dptdc_created_by , case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')='' then dptdc_lst_upd_by else isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'') end dptdc_lst_upd_by , case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')<>'' then dptdc_lst_upd_by else '' end verifier
												,dptdc_id   as USN,''

											FROm   dp_trx_dtls_cdsl   
                                                   left outer join  settlement_type_mstr  A on convert(varchar,A.settm_id) = dptdc_mkt_type and dptdc_mkt_type <> ''
                                                   left outer join  settlement_type_mstr  B on convert(varchar,B.settm_id) = DPTDC_OTHER_SETTLEMENT_TYPE and DPTDC_OTHER_SETTLEMENT_TYPE <> ''
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
											--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
                                            order by dptdc_lst_upd_dt 
 
											

											SELECT @L_TOT_REC = COUNT(DPTDC_ID) FROM dp_trx_dtls_cdsl ,dp_acct_mstr  
											WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
											--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
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
															--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
															AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
															AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
															AND    dptdc_internal_trastm in ('CMBO','CMCM','BOBO','BOCM')  
															AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  
															AND    isnull(DPTDC_BROKERBATCH_NO,'') <> ''

															UPDATE D1 Set dptdc_batch_no=@pa_batch_no FROM dp_trx_dtls_cdsl D1 ,dp_acct_mstr D2  
															WHERE  dptdc_dpam_id = dpam_id   
															--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
															AND    isnull(dptdc_status,'P')='P'  
															AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
															AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
															AND    dptdc_internal_trastm in ('CMBO','CMCM','BOBO','BOCM')  
															AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
															AND    isnull(DPTDC_BROKERBATCH_NO,'') <> ''


															/* Update in Bitmap ref mstr*/   
--															UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
--															WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND  BITRM_CHILD_CD = @L_DPM_ID 
--															AND BITRM_BIT_LOCATION = @PA_EXCSM_ID   




															/* insert into batch table*/              

--																IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@l_TRX_TAB)  
--																	BEGIN  
--
--																		INSERT INTO BATCHNO_CDSL_MSTR                                       
--																		(    
--																			BATCHC_DPM_ID,  
--																			BATCHC_NO,  
--																			BATCHC_RECORDS ,  
--																			BATCHC_TRANS_TYPE, 
--																			BATCHC_FILEGEN_DT,          
--																			BATCHC_TYPE,  
--																			BATCHC_STATUS,  
--																			BATCHC_CREATED_BY,  
--																			BATCHC_CREATED_DT ,  
--																			BATCHC_DELETED_IND  
--																		)  
--																		VALUES  
--																		(  
--																			@L_DPM_ID,  
--																			@PA_BATCH_NO,  
--																			@L_TOT_REC,  
--																			@l_TRX_TAB,--@L_TRANS_TYPE,
--																			CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',  
--																			'T',  
--																			'P',  
--																			@PA_LOGINNAME,  
--																			GETDATE(),  
--																			1  
--																		)      
--																			END  
												END              

									END  
																										ELSE  
									BEGIN   
										SELECT  replace(convert(varchar(11),dptdc_execution_dt,103),'/','')  
												+ isnull(dpam_sba_no,'')  
												+ isnull(dptdc_counter_dp_id,'') + isnull(dptdc_counter_demat_acct_no,'')  
												+ isnull(convert(char(12),dptdc_isin),'')  
												+ convert(varchar(16),citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(dptdc_qty)),12,3,'L','0'))    
												+ case  when dptdc_internal_trastm in('BOCM','CMCM') then 'S' when dptdc_internal_trastm = 'CMBO' then 'S' else 'S' end  
												+ isnull(dptdc_cash_trf,'')  
												+ isnull(convert(varchar(10),dptdc_reason_cd),'2')  
												+ convert(char(16),'/'+dptdc_internal_ref_no)--+ convert(char(16),ltrim(rtrim(DPTDC_SLIP_NO))+'/'+dptdc_internal_ref_no)
											    + case when isnull(dptdc_settlement_no,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',dptdc_settlement_no,A.settm_type_cdsl),'')   +isnull(dptdc_settlement_no,''))  else convert(char(13),'') end 
                                                + case when isnull(DPTDC_OTHER_SETTLEMENT_NO,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',DPTDC_OTHER_SETTLEMENT_NO,B.settm_type_cdsl),'')   +isnull(DPTDC_OTHER_SETTLEMENT_NO,''))  else convert(char(13),'') end 
                                                   DETAILS--space(13) DETAILS  
												, abs(dptdc_qty) qty
											FROm   dp_trx_dtls_cdsl   
                                                   left outer join  settlement_type_mstr  A on convert(varchar,A.settm_id) = dptdc_mkt_type and dptdc_mkt_type <> ''
                                                   left outer join  settlement_type_mstr  B on convert(varchar,B.settm_id) = DPTDC_OTHER_SETTLEMENT_TYPE and DPTDC_OTHER_SETTLEMENT_TYPE <> ''
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
											--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
											order by dptdc_lst_upd_dt 


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
														+ case when isnull(dptdc_other_settlement_no,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',dptdc_other_settlement_no,A.settm_type_cdsl),'')   +isnull(dptdc_other_settlement_no,''))  else convert(char(13),'') END
														
														+ convert(char(16),ltrim(rtrim(DPTDC_SLIP_NO))+'/'+dptdc_internal_ref_no)
                                                        + case when isnull(dptdc_settlement_no,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',dptdc_other_settlement_no,B.settm_type_cdsl),'')   +isnull(dptdc_settlement_no,''))  else convert(char(13),'') END 
														+ case when isnull(convert(varchar,dptdc_reason_cd),'0')='0' then space(1)  when DPTDC_CREATED_BY = DPAM_SBA_NO and  DPTDC_OTHER_SETTLEMENT_NO <>''and   left(DPTDC_COUNTER_CMBP_ID ,2) = 'IN'  then '23'  else  isnull(convert(varchar,dptdc_reason_cd),'') end 

															+ convert(char(1),ltrim(rtrim(case when DPTDC_PAYMODE='Cheque Payment' then '1' when DPTDC_PAYMODE='Electronic Payment' then '2' when DPTDC_PAYMODE='Cash Payment' then '3' else '' end )))
	+ convert(char(35),isnull(DPTDC_BANKACNO,''))
	+ convert(char(100),isnull(DPTDC_BANKACNAME,''))
	+ convert(char(100),isnull(DPTDC_BANKBRNAME,''))
	+ convert(char(150),isnull(DPTDC_TRANSFEREENAME,''))
	+ case when convert(char(8),isnull(replace(convert(varchar(11),DPTDC_DOI,103),'/','')  ,''))='01011900' then space(8) else convert(char(8),isnull(replace(convert(varchar(11),DPTDC_DOI,103),'/','')  ,'')) end --convert(char(8),isnull(replace(convert(varchar(11),DPTDC_DOI,103),'/','')  ,''))--+ convert(char(8),isnull(replace(convert(varchar(11),DPTDC_DOI,103),'/','')  ,''))
	+ convert(char(22),isnull(DPTDC_CHQ_REFNO,''))
														DETAILS
														, abs(dptdc_qty) qty , 
														case when dpam_sba_no=dptdc_created_by then 'Y' else 'N' end TRXEFLG 
														,citrus_usr.fn_get_slip_no_export(dpam_sba_no,dptdc_slip_no) dptdc_slip_no , dptdc_created_by , case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')='' then dptdc_lst_upd_by else isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'') end dptdc_lst_upd_by , case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')<>'' then dptdc_lst_upd_by else '' end verifier
														,dptdc_id   as USN,''
											FROM   dp_trx_dtls_cdsl   
												   left outer join settlement_type_mstr A on convert(varchar,A.settm_id) = dptdc_other_settlement_type and dptdc_other_settlement_type <> ''
                                                   left outer join settlement_type_mstr B on convert(varchar,B.settm_id) = DPTDC_MKT_TYPE and DPTDC_MKT_TYPE <> ''
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
											--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
											order by dptdc_lst_upd_dt 

											SELECT @L_TOT_REC = COUNT(DPTDC_ID) FROM dp_trx_dtls_cdsl,dp_acct_mstr   
											WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
											--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
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
															--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
															AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
															AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
															AND    dptdc_internal_trastm = @l_TRX_TAB  
															AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
															AND    isnull(DPTDC_BROKERBATCH_NO,'') <> ''

															UPDATE D1 Set dptdc_batch_no=@pa_batch_no FROM dp_trx_dtls_cdsl D1 ,dp_acct_mstr D2  
															WHERE  dptdc_dpam_id = dpam_id   
															--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
															AND    isnull(dptdc_status,'P')='P'  
															AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
															AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
															AND    dptdc_internal_trastm = @l_TRX_TAB   
															AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
															AND    isnull(DPTDC_BROKERBATCH_NO,'') <> ''


															/* Update in Bitmap ref mstr*/   
--															UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
--															WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND  BITRM_CHILD_CD= @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  
--
--															/* insert into batch table*/  
--
--
--
--																IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@l_TRX_TAB)  
--																	BEGIN  
--																		INSERT INTO BATCHNO_CDSL_MSTR                                       
--																		(    
--																			BATCHC_DPM_ID,  
--																			BATCHC_NO,  
--																			BATCHC_RECORDS ,  
--																			BATCHC_TRANS_TYPE,
--																			BATCHC_FILEGEN_DT,
--																			BATCHC_TYPE,  
--																			BATCHC_STATUS,  
--																			BATCHC_CREATED_BY,  
--																			BATCHC_CREATED_DT ,  
--																			BATCHC_DELETED_IND  
--																		)  
--																		VALUES  
--																		(  
--																			@L_DPM_ID,  
--																			@PA_BATCH_NO,  
--																			@L_TOT_REC,  
--																			@L_TRANS_TYPE,
--																			CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',  
--																			'T',  
--																			'P',  
--																			@PA_LOGINNAME,  
--																			GETDATE(),  
--																			1  
--																		)      
--																																																											END    
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
													+ case when isnull(dptdc_other_settlement_no,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',dptdc_other_settlement_no,A.settm_type_cdsl),'')   +isnull(dptdc_other_settlement_no,''))  else convert(char(13),'') END
                                                    + convert(char(16),ltrim(rtrim(DPTDC_SLIP_NO))+'/'+dptdc_internal_ref_no)
                                                    + case when isnull(DPTDC_SETTLEMENT_NO,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',DPTDC_SETTLEMENT_NO,B.settm_type_cdsl),'')   +isnull(DPTDC_SETTLEMENT_NO,''))  else convert(char(13),'') END DETAILS
													, abs(dptdc_qty) qty
											FROm   dp_trx_dtls_cdsl   
												left outer join  settlement_type_mstr A on convert(varchar,A.settm_id) = dptdc_other_settlement_type and dptdc_other_settlement_type <> ''
                                                LEFT OUTER JOIN  settlement_type_mstr B on convert(varchar,B.settm_id) = DPTDC_MKT_TYPE and DPTDC_MKT_TYPE <> ''
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
											--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
											order by dptdc_lst_upd_dt 

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
										+ convert(char(5),citrus_usr.FN_FORMATSTR(CONVERT(VARCHAR(5),isnull(demrm_total_certificates,'0')),5,0,'L','0'))  --case when demrm_isin like 'INF%' then convert(char(5),citrus_usr.FN_FORMATSTR(CONVERT(VARCHAR(5),isnull(demrd_cert_no,'0')),5,0,'L','0'))   else convert(char(5),citrus_usr.FN_FORMATSTR(CONVERT(VARCHAR(5),isnull(demrm_total_certificates,'0')),5,0,'L','0')) end --
										+ convert(char(1),isnull(demrm_free_lockedin_yn,''))  
										+ convert(char(2),isnull(demrm_lockin_reason_cd,''))  
										+ convert(char(50),case when ltrim(rtrim(isnull(DEMRM_RMKS,'')))='' then space(50) else ltrim(rtrim(isnull(DEMRM_RMKS,''))) end ) 
										+ case when convert(char(8),replace(convert(varchar(11),isnull(DEMRM_LOCKIN_RELEASE_DT,space(8)),103),'/','')) = '01011900' or isnull(demrm_free_lockedin_yn,'N')='N'  then  convert(char(8),'00000000') else convert(char(8),replace(convert(varchar(11),isnull(DEMRM_LOCKIN_RELEASE_DT,space(8)),103),'/','')) end  DETAILS
										,abs(demrm_qty) qty,'','','','','','0',replace(convert(varchar(11),isnull(DEMRM_REQUEST_DT,space(8)),103),'/','') DEMRM_REQUEST_DT
										FROM demat_request_mstr  
										 left outer join dmat_dispatch on demrm_id=disp_demrm_id
										,dp_acct_mstr  --, demat_request_dtls
											WHERE demrm_dpam_id     = dpam_id   
											AND   dpam_deleted_ind  = 1  
											AND   demrm_deleted_ind = 1  
											AND    isnull(demrm_status,'P')='P'  --and demrm_id= demrd_demrm_id and demrd_deleted_ind=1
											AND    ltrim(rtrim(isnull(demrm_batch_no,''))) = ''  
											AND   demrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'       
											AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
											--AND		dpam_dpm_id   = @L_DPM_ID 
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end and isnull(demrm_typeofsec,'')='EQUITY'
                                            order by demrm_lst_upd_dt 

											SELECT @L_TOT_REC = COUNT(demrm_ID) FROM demat_request_mstr left outer join dmat_dispatch on demrm_id=disp_demrm_id ,dp_acct_mstr
                                            --,demat_request_dtls
											WHERE  isnull(demrm_status,'P')='P' and demrm_dpam_id = dpam_id --and demrm_id= demrd_demrm_id    
											--AND    dpam_dpm_id      = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
											AND    ltrim(rtrim(isnull(demrm_batch_no,''))) = ''  
											AND    demrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																		AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END


											IF @L_TOT_REC > 0  
											BEGIN   

														/* Update in Demat_request_mstr*/   
														UPDATE D1 Set demrm_batch_no=@pa_batch_no FROM demat_request_mstr D1 ,dp_acct_mstr D2  
														WHERE  demrm_dpam_id = dpam_id   
														--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
														AND    isnull(demrm_status,'P')='P'  
														AND    ltrim(rtrim(isnull(demrm_batch_no,''))) = ''  
														AND    demrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
														AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  and isnull(demrm_typeofsec,'')='EQUITY'
														/* Update in Bitmap ref mstr*/   
--														UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
--														WHERE   BITRM_PARENT_CD = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  
--
--														/* insert into batch table*/                    
--																IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@l_TRX_TAB)  
--																	BEGIN  
--																		INSERT INTO BATCHNO_CDSL_MSTR                                       
--																		(    
--																			BATCHC_DPM_ID,  
--																			BATCHC_NO,  
--																			BATCHC_RECORDS ,  
--																			BATCHC_TRANS_TYPE,
--																			BATCHC_FILEGEN_DT,           
--																			BATCHC_TYPE,  
--																			BATCHC_STATUS,  
--																			BATCHC_CREATED_BY,  
--																			BATCHC_CREATED_DT ,  
--																			BATCHC_DELETED_IND  
--																		)  
--																		VALUES  
--																		(  
--																			@L_DPM_ID,  
--																			@PA_BATCH_NO,  
--																			@L_TOT_REC,  
--																			@l_TRX_TAB,
--																			CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'  ,
--																			'T',  
--																			'P',  
--																			@PA_LOGINNAME,  
--																			GETDATE(),  
--																			1  
--																		)      
--																	END  
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
											AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END and isnull(demrm_typeofsec,'')='EQUITY'
											--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
                                            order by demrm_lst_upd_dt 
									END   


						--  
						END  





						IF @l_TRX_TAB= 'CLSR_ACCT_GEN'   
						BEGIN  
							SELECT * FROM CLOSURE_ACCT_MSTR WHERE  CLSR_DATE BETWEEN   
							CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT ,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'     
							AND CLSR_DELETED_IND=1  
						END   
    --
    END
    ELSE IF @pa_broker_yn = 'N'
    BEGIN
    --

IF @l_TRX_TAB= 'DESTAT'  
BEGIN  
--  

IF @PA_BATCH_TYPE = 'BN'  

BEGIN 
Select 
'<Tp>' + '21' + '</Tp>'
+'<Bnfcry>' + convert(varchar,isnull(dpam_sba_no,'')) + '</Bnfcry>'
+'<ISIN>' + convert(varchar,isnull(demrm_isin,''))    + '</ISIN>'
+'<QtyFlg>' + case when demrm_qty <>0 then 'P' else 'A' end + '</QtyFlg>'
+'<Qty>' + case when DEMRD_QTY <>0 then convert(varchar(16),convert(numeric(18,3),DEMRD_QTY)) else '0' end  + '</Qty>'
+'<Drf>' + convert(varchar,isnull(demrm_slip_serial_no,'')) + '</Drf>'
+'<Fol>' + convert(varchar,ltrim(rtrim(DEMRD_FOLIO_NO))) + '</Fol>'
+'<Ref>' + convert(varchar,DEMRM_id) + '</Ref>'
+'<Pg>' +  convert(varchar,isnull(demrd_cert_no,'0')) + '</Pg>' 

--+'<Dspchid>'+ convert(varchar,DEMRM_id) + '</Dspchid>'
--+'<Dspchnm>'+ convert(char(1),isnull(DEMRM_FREE_LOCKEDIN_YN,'')) + '</Dspchnm>'
--+'<Dspchdt>'+ convert(char(1),isnull(DEMRM_FREE_LOCKEDIN_YN,'')) + '</Dspchdt>'

+'<Lcksts>'+ case when convert(char(1),isnull(DEMRM_FREE_LOCKEDIN_YN,''))='Y' then 'L' else 'F' end + '</Lcksts>' 
+ case when isnull(DEMRM_FREE_LOCKEDIN_YN,'')='Y' then '<Lckcd>' + DEMRM_LOCKIN_REASON_CD + '</Lckcd>' else '' end
+ case when isnull(DEMRM_FREE_LOCKEDIN_YN,'')='Y' then '<Lckrem>' + DEMRM_RMKS + '</Lckrem>' else '' end
+ case when isnull(DEMRM_FREE_LOCKEDIN_YN,'')='Y' then '<Lckexpdt>' + replace(convert(varchar(11),DEMRM_LOCKIN_RELEASE_DT ,103),'/','') + '</Lckexpdt>' else '' end
+'<Rcvdt>' + replace(convert(varchar(11),isnull(DEMRM_REQUEST_DT,space(8)),103),'/','') + '</Rcvdt>'

DETAILS

,convert(numeric(18,3),demrm_qty) qty,'','','','','','0',replace(convert(varchar(11),isnull(DEMRM_REQUEST_DT,space(8)),103),'/','') DEMRM_REQUEST_DT

FROM demat_request_mstr  
left outer join dmat_dispatch on demrm_id=disp_demrm_id
,dp_acct_mstr  ,demat_request_dtls
WHERE demrm_dpam_id     = dpam_id   
AND   dpam_deleted_ind  = 1  and demrm_id=demrd_demrm_id and demrd_deleted_ind=1
AND   demrm_deleted_ind = 1  
AND    isnull(demrm_status,'P')='P'  
AND    ltrim(rtrim(isnull(demrm_batch_no,''))) = '' and demrm_isin like 'INF%' 
AND   demrm_request_dt BETWEEN    CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  																								  								     
AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
order by demrm_lst_upd_dt 
END


SELECT @L_TOT_REC = COUNT(demrm_id) FROM demat_request_mstr  
left outer join dmat_dispatch on demrm_id=disp_demrm_id
,dp_acct_mstr  ,demat_request_dtls
WHERE demrm_dpam_id     = dpam_id   
AND   dpam_deleted_ind  = 1  and demrm_id=demrd_demrm_id and demrd_deleted_ind=1
AND   demrm_deleted_ind = 1  
AND    isnull(demrm_status,'P')='P'  
AND    ltrim(rtrim(isnull(demrm_batch_no,''))) = '' and demrm_isin like 'INF%' 
AND   demrm_request_dt BETWEEN    CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  																								  								     
AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END


IF @L_TOT_REC > 0   
BEGIN  
/* Update in dp_trx_dtls_cdsl*/ 

--SELECT @L_TRANS_TYPE = dptdc_internal_trastm FROM dp_trx_dtls_cdsl ,dp_acct_mstr  
--WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
--AND    dpam_dpm_id   = @l_dpm_id    
--AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
--AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
--AND    dptdc_internal_trastm in ('CMBO','CMCM','BOBO','BOCM')  
--AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  


--UPDATE D1 Set dptdc_batch_no=@pa_batch_no FROM dp_trx_dtls_cdsl D1 ,dp_acct_mstr D2  
--WHERE  dptdc_dpam_id = dpam_id   
--AND    dpam_dpm_id   = @l_dpm_id    
--AND    isnull(dptdc_status,'P')='P'  
--AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
--AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
--AND    dptdc_internal_trastm in ('CMBO','CMCM','BOBO','BOCM')  
--AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END

update d set demrm_batch_no=@pa_batch_no FROM demat_request_mstr d 
left outer join dmat_dispatch on demrm_id=disp_demrm_id
,dp_acct_mstr  ,demat_request_dtls
WHERE demrm_dpam_id     = dpam_id   
AND   dpam_deleted_ind  = 1  and demrm_id=demrd_demrm_id and demrd_deleted_ind=1
AND   demrm_deleted_ind = 1  
AND    isnull(demrm_status,'P')='P'  
AND    ltrim(rtrim(isnull(demrm_batch_no,''))) = '' and demrm_isin like 'INF%' 
AND   demrm_request_dt BETWEEN    CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  																								  								     
AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END															


/* Update in Bitmap ref mstr*/   
--															UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
--															WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + 'ALL' + '_CURNO' AND  BITRM_CHILD_CD = @L_DPM_ID 
--															AND BITRM_BIT_LOCATION = @PA_EXCSM_ID   
--
--
--
--
--															/* insert into batch table*/              
--
--																IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@l_TRX_TAB)  
--																	BEGIN  
--
--																		INSERT INTO BATCHNO_CDSL_MSTR                                       
--																		(    
--																			BATCHC_DPM_ID,  
--																			BATCHC_NO,  
--																			BATCHC_RECORDS ,  
--																			BATCHC_TRANS_TYPE, 
--																			BATCHC_FILEGEN_DT,          
--																			BATCHC_TYPE,  
--																			BATCHC_STATUS,  
--																			BATCHC_CREATED_BY,  
--																			BATCHC_CREATED_DT ,  
--																			BATCHC_DELETED_IND  
--																		)  
--																		VALUES  
--																		(  
--																			@L_DPM_ID,  
--																			@PA_BATCH_NO,  
--																			@L_TOT_REC,  
--																			@l_TRX_TAB,--@L_TRANS_TYPE,
--																			CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',  
--																			'T',  
--																			'P',  
--																			@PA_LOGINNAME,  
--																			GETDATE(),  
--																			1  
--																		)      
--																			END  
END       


END -- destat

      						IF @l_TRX_TAB = 'EP'  
												BEGIN  
													--  
																--for exch filelookup  
																--settlemnt lookup + other settl_no  
														IF @PA_BATCH_TYPE = 'BN'  
														BEGIN  
														print @l_TRX_TAB
																Select convert(char(2),isnull(excm_short_name,0))  
																					+ convert(char(2),isnull(fillm_file_value,''))  
																				+ convert(char(8),isnull(convert(varchar,dptdc_cm_id),''))  
																				+ convert(char(13),isnull(case when settm_type_cdsl = 'TT' then 'W' when settm_type_cdsl = 'NR' then 'N' when settm_type_cdsl = 'NA' then 'A' else settm_type_cdsl end,0)+isnull(dptdc_other_settlement_no,''))  
																				+ convert(char(16),isnull(dpam_sba_no,''))  
																				+ convert(char(12),isnull(dptdc_isin,'') )  
																							+ convert(varchar(16),citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(dptdc_qty)),13,3,'L','0'))    
																				--+ convert(char(16),isnull(dptdc_counter_demat_acct_no,''))  
                                                                                + case when len(dptdc_counter_demat_acct_no)=16 then convert(char(16),isnull(dptdc_counter_demat_acct_no,''))  else convert(char(8),isnull(dptdc_counter_dp_id,'')) + convert(char(8),isnull(dptdc_counter_demat_acct_no,'')) end
																				+ convert(char(16),DPTDC_SLIP_NO+'/'+dptdc_internal_ref_no)  
																				+ convert(char(8),replace(convert(varchar(11),dptdc_execution_dt,103),'/',''))  DETAILS
																			, abs(dptdc_qty) qty, 'N' TRXEFLG ,citrus_usr.fn_get_slip_no_export(dpam_sba_no,dptdc_slip_no) dptdc_slip_no , dptdc_created_by , case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')='' then dptdc_lst_upd_by else isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'') end dptdc_lst_upd_by , case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')<>'' then dptdc_lst_upd_by else '' end verifier
																			,dptdc_id   as USN,''
																			
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
																		--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
																		order by dptdc_lst_upd_dt 
						
																					SELECT @L_TOT_REC = COUNT(DPTDC_ID) FROM dp_trx_dtls_cdsl ,dp_acct_mstr  
																																													WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
																					--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
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
																					--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
																					AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
																					AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																					AND    dptdc_internal_trastm = @l_TRX_TAB   
																					AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																					AND isnull(DPTDC_BROKERBATCH_NO,'') = ''
						
																					UPDATE D1 Set dptdc_batch_no=@pa_batch_no FROM dp_trx_dtls_cdsl D1 ,dp_acct_mstr D2  
																					WHERE  dptdc_dpam_id = dpam_id   
																					--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
																					AND    isnull(dptdc_status,'P')='P'  
																					AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
																					AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																					AND    dptdc_internal_trastm = @l_TRX_TAB   
																					AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																					AND isnull(DPTDC_BROKERBATCH_NO,'') = ''
						
						
																					/* Update in Bitmap ref mstr*/   
--																					UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
--																					WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  
--						
--																					/* insert into batch table*/  
--						
--						
--						
--																							IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@l_TRX_TAB)  
--																							BEGIN  
--																								INSERT INTO BATCHNO_CDSL_MSTR                                       
--																								(    
--																									BATCHC_DPM_ID,  
--																									BATCHC_NO,  
--																									BATCHC_RECORDS ,  
--																									BATCHC_TRANS_TYPE,           
--																									BATCHC_TYPE,  
--																									BATCHC_FILEGEN_DT,
--																									BATCHC_STATUS,  
--																									BATCHC_CREATED_BY,  
--																									BATCHC_CREATED_DT ,  
--																									BATCHC_DELETED_IND  
--																								)  
--																								VALUES  
--																								(  
--																									@L_DPM_ID,  
--																									@PA_BATCH_NO,  
--																									@L_TOT_REC,  
--																									@L_TRANS_TYPE,  
--																									'T', 
--																									CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00', 
--																									'P',  
--																									@PA_LOGINNAME,  
--																									GETDATE(),  
--																									1  
--																								)      
--																																																																	END  
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
																				--+ convert(char(16),isnull(dptdc_counter_demat_acct_no,''))  
                                                                                + case when len(dptdc_counter_demat_acct_no)=16 then convert(char(16),isnull(dptdc_counter_demat_acct_no,''))  else convert(char(8),isnull(dptdc_counter_dp_id,'')) + convert(char(8),isnull(dptdc_counter_demat_acct_no,'')) end
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
																		--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
                                                                        order by dptdc_lst_upd_dt 
						
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
																			, case when dpam_sba_no=dptdc_created_by then 'Y' else  'N' end  TRXEFLG --'N'
																			,citrus_usr.fn_get_slip_no_export(dpam_sba_no,dptdc_slip_no) dptdc_slip_no , dptdc_created_by , case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')='' then dptdc_lst_upd_by else isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'') end dptdc_lst_upd_by , case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')<>'' then dptdc_lst_upd_by else '' end verifier
																			,dptdc_id   as USN,''
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
														--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
														order by dptdc_lst_upd_dt 
						
						
															SELECT @L_TOT_REC = COUNT(DPTDC_ID) FROM dp_trx_dtls_cdsl ,dp_acct_mstr  
																																				WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
																																				--AND    dpam_dpm_id   = @l_dpm_id    
															AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
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
																		--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
																		AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
																		AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																		AND    dptdc_internal_trastm = @l_TRX_TAB 
																		AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  
																		AND isnull(DPTDC_BROKERBATCH_NO,'') = ''
						
																		UPDATE D1 Set dptdc_batch_no=@pa_batch_no FROM dp_trx_dtls_cdsl D1 ,dp_acct_mstr D2  
																		WHERE  dptdc_dpam_id = dpam_id   
																		--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
																		AND    isnull(dptdc_status,'P')='P'  
																		AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
																		AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																		AND    dptdc_internal_trastm = @l_TRX_TAB  
																		AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																		AND isnull(DPTDC_BROKERBATCH_NO,'') = ''
						
																					/* Update in Bitmap ref mstr*/   
--																		UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
--																		WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND  BITRM_CHILD_CD= @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  
--						
--																		/* insert into batch table*/  
--						
--						
--						
--																						IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@l_TRX_TAB)  
--																							BEGIN  
--																								INSERT INTO BATCHNO_CDSL_MSTR                                       
--																								(    
--																									BATCHC_DPM_ID,  
--																									BATCHC_NO,  
--																									BATCHC_RECORDS ,  
--																									BATCHC_TRANS_TYPE,
--																									BATCHC_FILEGEN_DT,           
--																									BATCHC_TYPE,  
--																									BATCHC_STATUS,  
--																									BATCHC_CREATED_BY,  
--																									BATCHC_CREATED_DT ,  
--																									BATCHC_DELETED_IND  
--																								)  
--																								VALUES  
--																								(  
--																									@L_DPM_ID,  
--																									@PA_BATCH_NO,  
--																									@L_TOT_REC,  
--																									@L_TRANS_TYPE,
--																									CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',  
--																									'T',  
--																									'P',  
--																									@PA_LOGINNAME,  
--																									GETDATE(),  
--																									1  
--																								)      
--																																																																	END  
						
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
																			, abs(dptdc_qty) qty, 'N' TRXEFLG ,citrus_usr.fn_get_slip_no_export(dpam_sba_no,dptdc_slip_no) dptdc_slip_no , dptdc_created_by , case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')='' then dptdc_lst_upd_by else isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'') end dptdc_lst_upd_by , case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')<>'' then dptdc_lst_upd_by else '' end verifier
																			,dptdc_id   as USN,''
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
														--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
														order by dptdc_lst_upd_dt 

						
														END   
												--  
												END  
												IF @l_TRX_TAB in ('OFFM')  
												BEGIN  
												--   
												
															-- in case of request for off market  
														IF @PA_BATCH_TYPE = 'BN'  
															BEGIN  

																	SELECT replace(convert(varchar(11),dptdc_execution_dt,103),'/','')  
																	+ isnull(dpam_sba_no,'')  
																	+ case when (dpam_sba_no=dptdc_created_by and len(dptdc_counter_demat_acct_no)=16)  then right(isnull(dptdc_counter_demat_acct_no,''),16) when (dpam_sba_no=dptdc_created_by and len(dptdc_counter_demat_acct_no)=8) then  isnull(dptdc_counter_dp_id,'') + isnull(dptdc_counter_demat_acct_no,'') when (LEN(dptdc_counter_demat_acct_no)>8 and LEN(dptdc_counter_demat_acct_no)<>'16') then ISNULL(dptdc_counter_demat_acct_no,'')+ SPACE(1) else isnull(dptdc_counter_dp_id,'') + isnull(dptdc_counter_demat_acct_no,'') end   
																	+ isnull(convert(char(12),dptdc_isin),'')  
																	+ convert(varchar(16),citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(dptdc_qty)),12,3,'L','0'))    
																	+ case  when dptdc_internal_trastm in('BOCM','CMCM') then 'S' when dptdc_internal_trastm = 'CMBO' then 'S' else 'S' end  
																	+ isnull(dptdc_cash_trf,'')  
																	--need to revert 
																	--------+ case when isnull(convert(varchar(10),dptdc_reason_cd),'2')=0 then '2' else isnull(convert(varchar(10),dptdc_reason_cd),'2')  end
																	
																	+ case when isnull(convert(varchar(10),dptdc_reason_cd),'2')=0 then SPACE(1) else isnull(convert(varchar(10),dptdc_reason_cd),'2')  end
																	+ convert(char(16),'/'+dptdc_internal_ref_no) --ltrim(rtrim(DPTDC_SLIP_NO))+
																	--+ case when isnull(dptdc_settlement_no,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',dptdc_settlement_no,A.settm_type_cdsl),'')   +isnull(dptdc_settlement_no,''))  else convert(char(13),'') end 
																	--+ case when isnull(DPTDC_OTHER_SETTLEMENT_NO,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',DPTDC_OTHER_SETTLEMENT_NO,B.settm_type_cdsl),'')   +isnull(DPTDC_OTHER_SETTLEMENT_NO,''))  else convert(char(13),'') end 
																	--onnov1116--+ case when dptdc_internal_trastm in ('CMCM') then case when isnull(DPTDC_OTHER_SETTLEMENT_NO,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',DPTDC_OTHER_SETTLEMENT_NO,B.settm_type_cdsl),'')   +isnull(DPTDC_OTHER_SETTLEMENT_NO,''))  else convert(char(13),'') end  else case when isnull(dptdc_settlement_no,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',dptdc_settlement_no,A.settm_type_cdsl),'')   +isnull(dptdc_settlement_no,''))  else convert(char(13),'') end end
																	--+ case when dptdc_internal_trastm in ('CMCM') then case when isnull(dptdc_settlement_no,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',dptdc_settlement_no,A.settm_type_cdsl),'')   +isnull(dptdc_settlement_no,''))  else convert(char(13),'') end else case when isnull(DPTDC_OTHER_SETTLEMENT_NO,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',DPTDC_OTHER_SETTLEMENT_NO,B.settm_type_cdsl),'')   +isnull(DPTDC_OTHER_SETTLEMENT_NO,''))  else convert(char(13),'') end end
																	 --onnov1116-- + case when dptdc_internal_trastm in ('CMCM') then case when isnull(dptdc_settlement_no,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',dptdc_settlement_no,A.settm_type_cdsl),'')   +isnull(dptdc_settlement_no,''))  else convert(char(13),'') end else case when dptdc_internal_trastm in ('CMBO') then CONVERT(char(13),'') else case when isnull(dptdc_settlement_no,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',dptdc_settlement_no,a.settm_type_cdsl),'')   +isnull(dptdc_settlement_no,''))   else convert(char(13),'') end end end
																	+ case when dptdc_internal_trastm in ('CMCM') then 
																	       case when isnull(DPTDC_OTHER_SETTLEMENT_NO,'') <> '' 
																	       then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',DPTDC_OTHER_SETTLEMENT_NO,B.settm_type_cdsl),'')   +isnull(DPTDC_OTHER_SETTLEMENT_NO,''))  
																	       else convert(char(13),'') end   
																	  when dptdc_internal_trastm in ('BOCM') then convert(char(13),'')   
																	        else case when (isnull(dptdc_settlement_no,'') <> '' and dpam_subcm_cd in ('122624','102624','192624') ) then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',dptdc_settlement_no,A.settm_type_cdsl),'')   +isnull(dptdc_settlement_no,'')) 
																	        else convert(char(13),'') end 
																	  end
																	--+ case when dptdc_internal_trastm in ('CMCM') then case when isnull(dptdc_settlement_no,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',dptdc_settlement_no,A.settm_type_cdsl),'')   +isnull(dptdc_settlement_no,''))  else convert(char(13),'') end else case when isnull(DPTDC_OTHER_SETTLEMENT_NO,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',DPTDC_OTHER_SETTLEMENT_NO,B.settm_type_cdsl),'')   +isnull(DPTDC_OTHER_SETTLEMENT_NO,''))  else convert(char(13),'') end end
																	+ case when dptdc_internal_trastm in ('CMCM','BOCM') 
																	       then case when isnull(dptdc_settlement_no,'') <> '' then 
																	       convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',dptdc_settlement_no,A.settm_type_cdsl),'')   +isnull(dptdc_settlement_no,''))  
																	       else convert(char(13),'') end 
																	       when (dptdc_internal_trastm in ('CMBO') and dpam_subcm_cd='122624') then convert(char(13),'') else 
																	       case when (isnull(dptdc_settlement_no,'') <> '' and dpam_subcm_cd not in ('122624','102624','192624')) then 
																	       convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',dptdc_settlement_no,a.settm_type_cdsl),'')   +isnull(dptdc_settlement_no,'')) 
																	        else convert(char(13),'') end end																	

																				+ convert(char(1),ltrim(rtrim(case when DPTDC_PAYMODE='Cheque Payment' then '1' when DPTDC_PAYMODE='Electronic Payment' then '2' when DPTDC_PAYMODE='Cash Payment' then '3' else '' end )))
																				+ convert(char(35),isnull(DPTDC_BANKACNO,''))
																				+ convert(char(100),isnull(DPTDC_BANKACNAME,''))
																				+ convert(char(100),isnull(DPTDC_BANKBRNAME,''))
																				+ convert(char(150),isnull(DPTDC_TRANSFEREENAME,''))
																				+ case when convert(char(8),isnull(replace(convert(varchar(11),DPTDC_DOI,103),'/','')  ,''))='01011900' then SPACE(8) else convert(char(8),isnull(replace(convert(varchar(11),DPTDC_DOI,103),'/','')  ,'')) end --convert(char(8),isnull(replace(convert(varchar(11),DPTDC_DOI,103),'/','')  ,''))
																				+ convert(char(22),isnull(DPTDC_CHQ_REFNO,''))

																	   DETAILS--space(13) DETAILS  
																	, abs(dptdc_qty) qty
																	, case when dpam_sba_no=dptdc_created_by then 'Y' else  'N' end TRXEFLG --'N' TRXEFLG 
																	,citrus_usr.fn_get_slip_no_export(dpam_sba_no,dptdc_slip_no) dptdc_slip_no , dptdc_created_by , case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')='' then dptdc_lst_upd_by else isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'') end dptdc_lst_upd_by , case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')<>'' then dptdc_lst_upd_by else '' end verifier
																	,dptdc_id    as USN,''
																	FROM   dp_trx_dtls_cdsl   
																		   left outer join  settlement_type_mstr  A on convert(varchar,A.settm_id) = dptdc_mkt_type and dptdc_mkt_type <> ''
																		   left outer join  settlement_type_mstr  B on convert(varchar,B.settm_id) = DPTDC_OTHER_SETTLEMENT_TYPE and DPTDC_OTHER_SETTLEMENT_TYPE <> ''
																						, dp_acct_mstr 
																	WHERE  dpam_id  = dptdc_dpam_id  
																	AND    dpam_deleted_ind  = 1  
																	AND    isnull(dptdc_status,'P')='P'  
																	AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
																	AND    dptdc_deleted_ind  = 1  
																	AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' 
																	AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																	AND    dptdc_internal_trastm in ('CMBO','CMCM','BOBO','BOCM')  
																	AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																	--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
																	order by dptdc_lst_upd_dt 

						
																	SELECT @L_TOT_REC = COUNT(DPTDC_ID) FROM dp_trx_dtls_cdsl ,dp_acct_mstr  
																	WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
																	--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
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
																					--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
																					AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
																					AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' 
																					AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																					AND    dptdc_internal_trastm in ('CMBO','CMCM','BOBO','BOCM')  
																					AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  
																					AND isnull(DPTDC_BROKERBATCH_NO,'') = ''
						
																					UPDATE D1 Set dptdc_batch_no=@pa_batch_no FROM dp_trx_dtls_cdsl D1 ,dp_acct_mstr D2  
																					WHERE  dptdc_dpam_id = dpam_id   
																					--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
																					AND    isnull(dptdc_status,'P')='P'  
																					AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
																					AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' 
																					AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																					AND    dptdc_internal_trastm in ('CMBO','CMCM','BOBO','BOCM')  
																					AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																					AND isnull(DPTDC_BROKERBATCH_NO,'') = ''
						
						
																					/* Update in Bitmap ref mstr*/   
--																					UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
--																					WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND  BITRM_CHILD_CD = @L_DPM_ID 
--																					AND BITRM_BIT_LOCATION = @PA_EXCSM_ID   
--						
--						
--						
--						
--																					/* insert into batch table*/              
--						
--																						IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@l_TRX_TAB)  
--																							BEGIN  
--						
--																								INSERT INTO BATCHNO_CDSL_MSTR                                       
--																								(    
--																									BATCHC_DPM_ID,  
--																									BATCHC_NO,  
--																									BATCHC_RECORDS ,  
--																									BATCHC_TRANS_TYPE, 
--																									BATCHC_FILEGEN_DT,          
--																									BATCHC_TYPE,  
--																									BATCHC_STATUS,  
--																									BATCHC_CREATED_BY,  
--																									BATCHC_CREATED_DT ,  
--																									BATCHC_DELETED_IND  
--																								)  
--																								VALUES  
--																								(  
--																									@L_DPM_ID,  
--																									@PA_BATCH_NO,  
--																									@L_TOT_REC,  
--																									@l_TRX_TAB,--@L_TRANS_TYPE,
--																									CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',  
--																									'T',  
--																									'P',  
--																									@PA_LOGINNAME,  
--																									GETDATE(),  
--																									1  
--																								)      
--																									END  
																		END              
						
															END  
																																ELSE  
															BEGIN   
																	SELECT replace(convert(varchar(11),dptdc_execution_dt,103),'/','')  
																	+ isnull(dpam_sba_no,'')  
																	+ isnull(dptdc_counter_dp_id,'') + isnull(dptdc_counter_demat_acct_no,'')  
																	+ isnull(convert(char(12),dptdc_isin),'')  
																	+ convert(varchar(16),citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(dptdc_qty)),12,3,'L','0'))    
																	+ case  when dptdc_internal_trastm in('BOCM','CMCM') then 'S' when dptdc_internal_trastm = 'CMBO' then 'S' else 'S' end  
																	+ isnull(dptdc_cash_trf,'')  
																	+ isnull(convert(varchar(10),dptdc_reason_cd),'2')  
																+ convert(char(16),'/'+dptdc_internal_ref_no)	--+ convert(char(16),ltrim(rtrim(DPTDC_SLIP_NO))+'/'+dptdc_internal_ref_no) 
																	+ case when isnull(dptdc_settlement_no,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',dptdc_settlement_no,A.settm_type_cdsl),'')   +isnull(dptdc_settlement_no,''))  else convert(char(13),'') end 
																	+ case when isnull(DPTDC_OTHER_SETTLEMENT_NO,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',DPTDC_OTHER_SETTLEMENT_NO,B.settm_type_cdsl),'')   +isnull(DPTDC_OTHER_SETTLEMENT_NO,''))  else convert(char(13),'') end 

																		+ convert(char(1),ltrim(rtrim(case when DPTDC_PAYMODE='Cheque Payment' then '1' when DPTDC_PAYMODE='Electronic Payment' then '2' when DPTDC_PAYMODE='Cash Payment' then '3' else '' end )))
	+ convert(char(35),isnull(DPTDC_BANKACNO,''))
	+ convert(char(100),isnull(DPTDC_BANKACNAME,''))
	+ convert(char(100),isnull(DPTDC_BANKBRNAME,''))
	+ convert(char(150),isnull(DPTDC_TRANSFEREENAME,''))
	+ case when convert(char(8),isnull(replace(convert(varchar(11),DPTDC_DOI,103),'/','')  ,''))='01011900' then '' else convert(char(8),isnull(replace(convert(varchar(11),DPTDC_DOI,103),'/','')  ,'')) end --convert(char(8),isnull(replace(convert(varchar(11),DPTDC_DOI,103),'/','')  ,''))
	+ convert(char(22),isnull(DPTDC_CHQ_REFNO,''))
																	   DETAILS--space(13) DETAILS  
																	, abs(dptdc_qty) qty, 'N' TRXEFLG ,citrus_usr.fn_get_slip_no_export(dpam_sba_no,dptdc_slip_no) dptdc_slip_no , dptdc_created_by , case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')='' then dptdc_lst_upd_by else isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'') end dptdc_lst_upd_by , case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')<>'' then dptdc_lst_upd_by else '' end verifier
																	,dptdc_id    as USN,''
																	FROM   dp_trx_dtls_cdsl   
																		   left outer join  settlement_type_mstr  A on convert(varchar,A.settm_id) = dptdc_mkt_type and dptdc_mkt_type <> ''
																		   left outer join  settlement_type_mstr  B on convert(varchar,B.settm_id) = DPTDC_OTHER_SETTLEMENT_TYPE and DPTDC_OTHER_SETTLEMENT_TYPE <> ''
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
																	--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
																	order by dptdc_lst_upd_dt 

						
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
																			+ case when isnull(dptdc_other_settlement_no,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',dptdc_other_settlement_no,A.settm_type_cdsl),'')   +isnull(dptdc_other_settlement_no,''))  else convert(char(13),'') END
																			
																			+ convert(char(16),'/'+dptdc_internal_ref_no) --ltrim(rtrim(DPTDC_SLIP_NO))+
																			+ case when isnull(dptdc_settlement_no,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',dptdc_other_settlement_no,B.settm_type_cdsl),'')   +isnull(dptdc_settlement_no,''))  else convert(char(13),'') END 
																			+ case when isnull(convert(varchar,dptdc_reason_cd),'0')='0' then space(1) when DPTDC_CREATED_BY = DPAM_SBA_NO and  DPTDC_OTHER_SETTLEMENT_NO <>''and   left(DPTDC_COUNTER_CMBP_ID ,2) = 'IN'  then '23' else  isnull(convert(varchar,dptdc_reason_cd),'') end 

																				+ convert(char(1),ltrim(rtrim(case when DPTDC_PAYMODE='Cheque Payment' then '1' when DPTDC_PAYMODE='Electronic Payment' then '2' when DPTDC_PAYMODE='Cash Payment' then '3' else '' end )))
	+ convert(char(35),isnull(DPTDC_BANKACNO,''))
	+ convert(char(100),isnull(DPTDC_BANKACNAME,''))
	+ convert(char(100),isnull(DPTDC_BANKBRNAME,''))
	+ convert(char(150),isnull(DPTDC_TRANSFEREENAME,''))
	+ case when convert(char(8),isnull(replace(convert(varchar(11),DPTDC_DOI,103),'/','')  ,''))='01011900' then space(8) else convert(char(8),isnull(replace(convert(varchar(11),DPTDC_DOI,103),'/','')  ,'')) end --convert(char(8),isnull(replace(convert(varchar(11),DPTDC_DOI,103),'/','')  ,''))
	+ convert(char(22),isnull(DPTDC_CHQ_REFNO,''))
																			DETAILS
																			, abs(dptdc_qty) qty, case when dpam_sba_no=dptdc_created_by then 'Y' else 'N' end  TRXEFLG ,
																			citrus_usr.fn_get_slip_no_export(dpam_sba_no,dptdc_slip_no) dptdc_slip_no
																			 , dptdc_created_by ,
																			  case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')=''
																			   then dptdc_lst_upd_by else isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')
																			    end dptdc_lst_upd_by , 
																			    case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')<>'' then dptdc_lst_upd_by else '' end
																			     verifier,dptdc_id   as USN,''
																		    FROM   dp_trx_dtls_cdsl   
																		    left outer join settlement_type_mstr A on convert(varchar,A.settm_id) = dptdc_other_settlement_type and dptdc_other_settlement_type <> ''
																		    left outer join settlement_type_mstr B on convert(varchar,B.settm_id) = DPTDC_MKT_TYPE and DPTDC_MKT_TYPE <> ''
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
																	--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
																	order by dptdc_lst_upd_dt 
						
																	SELECT @L_TOT_REC = COUNT(DPTDC_ID) FROM dp_trx_dtls_cdsl,dp_acct_mstr   
																	WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
																	--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
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
																					--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
																					AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
																					AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																					AND    dptdc_internal_trastm = @l_TRX_TAB  
																					AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
						               AND isnull(DPTDC_BROKERBATCH_NO,'') = ''
						
																					UPDATE D1 Set dptdc_batch_no=@pa_batch_no FROM dp_trx_dtls_cdsl D1 ,dp_acct_mstr D2  
																					WHERE  dptdc_dpam_id = dpam_id   
																					--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
																					AND    isnull(dptdc_status,'P')='P'  
																					AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
																					AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																					AND    dptdc_internal_trastm = @l_TRX_TAB   
																					AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																					AND isnull(DPTDC_BROKERBATCH_NO,'') = ''
						
						
																					/* Update in Bitmap ref mstr*/   
--																					UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
--																					WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND  BITRM_CHILD_CD= @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  
--						
--																					/* insert into batch table*/  
--						
--						
--						
--																						IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@l_TRX_TAB)  
--																							BEGIN  
--																								INSERT INTO BATCHNO_CDSL_MSTR                                       
--																								(    
--																									BATCHC_DPM_ID,  
--																									BATCHC_NO,  
--																									BATCHC_RECORDS ,  
--																									BATCHC_TRANS_TYPE,
--																									BATCHC_FILEGEN_DT,
--																									BATCHC_TYPE,  
--																									BATCHC_STATUS,  
--																									BATCHC_CREATED_BY,  
--																									BATCHC_CREATED_DT ,  
--																									BATCHC_DELETED_IND  
--																								)  
--																								VALUES  
--																								(  
--																									@L_DPM_ID,  
--																									@PA_BATCH_NO,  
--																									@L_TOT_REC,  
--																									@L_TRANS_TYPE,
--																									CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',  
--																									'T',  
--																									'P',  
--																									@PA_LOGINNAME,  
--																									GETDATE(),  
--																									1  
--																								)      
--																																																																	END    
																	END   
															END  
																																ELSE  
															BEGIN   
																	Select convert(char(8),replace(convert(varchar(11),dptdc_execution_dt,103),'/',''))  
																	+ convert(char(16),isnull(dpam_sba_no,space(8)))  
																	+ convert(char(12),isnull(dptdc_isin,''))  
																	+ convert(char(15),citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(dptdc_qty)),12,3,'L','0'))    
																	+ 'S' --CASE  WHEN isnull(citrus_usr.fn_acct_entp(dpam_id,'CMBP_ID'),'') = '' THEN 'S' ELSE 'B'END  
																	+ isnull(dptdc_cash_trf,'X')  
																	+ case when ltrim(rtrim(isnull(dptdc_counter_cmbp_id,''))) <> '' then  convert(char(8),'') else convert(char(8),isnull(dptdc_counter_demat_acct_no,'')) end 
																	+ case when convert(char(8),isnull(dptdc_counter_cmbp_id,'')) <> '' then convert(char(8),isnull(dptdc_counter_cmbp_id,'')) else  convert(char(8),isnull(dptdc_counter_dp_id,'')) end  
																	+ case when isnull(dptdc_other_settlement_no,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',dptdc_other_settlement_no,A.settm_type_cdsl),'')   +isnull(dptdc_other_settlement_no,''))  else convert(char(13),'') END
																	+ convert(char(16),ltrim(rtrim(DPTDC_SLIP_NO))+'/'+dptdc_internal_ref_no) 
																	+ case when isnull(dptdc_settlement_no,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',dptdc_other_settlement_no,B.settm_type_cdsl),'')   +isnull(dptdc_settlement_no,''))  else convert(char(13),'') END DETAILS
																	, abs(dptdc_qty) qty 
																	FROM   dp_trx_dtls_cdsl   
																	left outer join settlement_type_mstr A on convert(varchar,A.settm_id) = dptdc_other_settlement_type and dptdc_other_settlement_type <> ''
																	left outer join settlement_type_mstr B on convert(varchar,B.settm_id) = DPTDC_MKT_TYPE and DPTDC_MKT_TYPE <> ''
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
																	--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
																	order by dptdc_lst_upd_dt 
						
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
										                        + convert(char(5),citrus_usr.FN_FORMATSTR(CONVERT(VARCHAR(5),isnull(demrm_total_certificates,'0')),5,0,'L','0')) --case when demrm_isin like 'INF%' then convert(char(5),citrus_usr.FN_FORMATSTR(CONVERT(VARCHAR(5),isnull(demrd_cert_no,'0')),5,0,'L','0'))   else convert(char(5),citrus_usr.FN_FORMATSTR(CONVERT(VARCHAR(5),isnull(demrm_total_certificates,'0')),5,0,'L','0')) end --   
																+ convert(char(1),isnull(demrm_free_lockedin_yn,''))  
																+ convert(char(2),isnull(demrm_lockin_reason_cd,''))  
																+ convert(char(50),case when ltrim(rtrim(isnull(DEMRM_RMKS,'')))='' then space(50) else ltrim(rtrim(isnull(DEMRM_RMKS,''))) end ) 
																+ case when convert(char(8),replace(convert(varchar(11),isnull(DEMRM_LOCKIN_RELEASE_DT,space(8)),103),'/','')) = '01011900'  or isnull(demrm_free_lockedin_yn,'N')='N' then  convert(char(8),'00000000') else convert(char(8),replace(convert(varchar(11),isnull(DEMRM_LOCKIN_RELEASE_DT,space(8)),103),'/','')) end  DETAILS
                                                                ,abs(demrm_qty) qty,'','','','','','0',replace(convert(varchar(11),isnull(DEMRM_REQUEST_DT,space(8)),103),'/','') DEMRM_REQUEST_DT
																	FROM  demat_request_mstr  
																	left outer join dmat_dispatch on demrm_id=disp_demrm_id
																	,dp_acct_mstr  --,demat_request_dtls
																	WHERE demrm_dpam_id     = dpam_id   
																	AND   dpam_deleted_ind  = 1  
																	AND   demrm_deleted_ind = 1  
																	AND    isnull(demrm_status,'P')='P'  --and demrm_id=demrd_demrm_id and demrd_deleted_ind=1
																	AND    ltrim(rtrim(isnull(demrm_batch_no,''))) = ''
																	AND	  ISNULL(DEMRM_INTERNAL_REJ,'') = ''   
																	AND   demrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'       
																	AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END and isnull(demrm_typeofsec,'')='EQUITY'
																	--AND		dpam_dpm_id   = @L_DPM_ID
												                    AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
																	order by demrm_lst_upd_dt 
						
																	SELECT @L_TOT_REC = COUNT(demrm_ID) FROM demat_request_mstr left outer join dmat_dispatch on demrm_id=disp_demrm_id ,dp_acct_mstr
                                                                    --,demat_request_dtls  
																	WHERE  isnull(demrm_status,'P')='P' and demrm_dpam_id = dpam_id   ---and demrm_id= demrd_demrm_id    
																	--AND    dpam_dpm_id      = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
																	AND    ltrim(rtrim(isnull(demrm_batch_no,''))) = '' 
																	AND	  ISNULL(DEMRM_INTERNAL_REJ,'') = '' 
																	AND    demrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																	AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END and isnull(demrm_typeofsec,'')='EQUITY'
						
																	IF @L_TOT_REC > 0  
																	BEGIN   
						
																				/* Update in Demat_request_mstr*/   
																				UPDATE D1 Set demrm_batch_no=@pa_batch_no FROM demat_request_mstr D1 ,dp_acct_mstr D2  
																				WHERE  demrm_dpam_id = dpam_id   
																				--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
																				AND    isnull(demrm_status,'P')='P'  
																				AND    ltrim(rtrim(isnull(demrm_batch_no,''))) = ''
																				AND	  ISNULL(DEMRM_INTERNAL_REJ,'') = ''  
																				AND    demrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																				AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  and isnull(demrm_typeofsec,'')='EQUITY'
																				/* Update in Bitmap ref mstr*/   
--																				UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
--																				WHERE   BITRM_PARENT_CD = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  
--						
--																				/* insert into batch table*/                    
--																						IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@l_TRX_TAB)  
--																							BEGIN  
--																								INSERT INTO BATCHNO_CDSL_MSTR                                       
--																								(    
--																									BATCHC_DPM_ID,  
--																									BATCHC_NO,  
--																									BATCHC_RECORDS ,  
--																									BATCHC_TRANS_TYPE,
--																									BATCHC_FILEGEN_DT,           
--																									BATCHC_TYPE,  
--																									BATCHC_STATUS,  
--																									BATCHC_CREATED_BY,  
--																									BATCHC_CREATED_DT ,  
--																									BATCHC_DELETED_IND  
--																								)  
--																								VALUES  
--																								(  
--																									@L_DPM_ID,  
--																									@PA_BATCH_NO,  
--																									@L_TOT_REC,  
--																									@l_TRX_TAB,
--																									CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'  ,
--																									'T',  
--																									'P',  
--																									@PA_LOGINNAME,  
--																									GETDATE(),  
--																									1  
--																								)      
--																																																																	END  
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
																	AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END and isnull(demrm_typeofsec,'')='EQUITY'
																	--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
																	order by demrm_lst_upd_dt 
															END   
						
						
												--  
												END 

----PLEDGE

						IF @l_TRX_TAB= 'PLEDGE'  
						BEGIN  
						--  
								IF @PA_BATCH_TYPE = 'BN'  
									BEGIN  
--										Select convert(char(1),case when pldtc_trastm_cd in('CRTE','CONF') then 'P'  when pldtc_trastm_cd in('CLOS') then 'U' else '' end )--'P','U','C','A'  
--										 + convert(char(1),case when pldtc_trastm_cd = 'CRTE' and isnull(PLDTC_SUB_STATUS,'') = '' then 'S'
--															  when pldtc_trastm_cd = 'CONF' and isnull(PLDTC_SUB_STATUS,'') = '' then 'A'
--															  when pldtc_trastm_cd = 'CLOS' and isnull(PLDTC_SUB_STATUS,'') = '' then 'S'
--															  when isnull(PLDTC_SUB_STATUS,'') <> '' then isnull(PLDTC_SUB_STATUS,'') 
--															  else '' end ) --'P' THEN 'S','A','R','C','E' --   'U' THEN 'S','A','R','C','E'--'A' THEN 'S','E'--'C' THEN 'S','E'
--										 + convert(char(1),case when pldtc_trastm_cd = 'CRTE' and isnull(PLDTC_SUB_STATUS,'') = '' then isnull(PLDTC_SECURITTIES,'') else '' end)--'P''S' THEN 'F','L'   
--										 + '0000000000000000'--convert(char(16),isnull(A.DPAM_SBA_NO,'')) --'P''S''L'   
--										 + convert(char(8),case when pldtc_trastm_cd = 'CRTE' and isnull(PLDTC_SUB_STATUS,'') = '' then '00000000' else isnull(PLDTC_PSN,'') end)  --'P''S' THEN '00000000' ELSE MEND PLDTC_PSN
--										 + convert(char(16),isnull(A.DPAM_SBA_NO,''))  
--											+ convert(char(16),isnull(PLDTC_PLDG_CLIENTID,''))  
--										 + convert(char(12),isnull(PLDTC_ISIN,''))  
--										 + convert(char(16),citrus_usr.FN_FORMATSTR(abs(PLDTC_QTY),13,3,'L','0'))--'P' OR ZEROS
--									     + convert(char(15),citrus_usr.FN_FORMATSTR(abs(PLDTC_QTY),13,3,'L','0'))--'P' OR ZEROS--PLEDGE VALUE?????????
--										 + convert(char(8),case when pldtc_trastm_cd = 'CRTE' and isnull(PLDTC_SUB_STATUS,'') = '' then replace(convert(varchar(11),PLDTC_EXPIRY_DT,103),'/','') else '00000000' end) --'P''S' ELSE ZEROS 
--										 + convert(char(16),case when pldtc_trastm_cd = 'CONF'  then PLDTC_ID else '' end )  --'PLEDGEE DP INTERNAL REF NO'
--									     + convert(char(16),case when pldtc_trastm_cd = 'CRTE'  then PLDTC_ID else '' end ) --'PLEDGEE DP INTERNAL REF NO'  
--										 + convert(char(20),PLDTC_AGREEMENT_NO)  --'P''S'
--										 + convert(char(4),'0000') 
--										 + convert(char(16),citrus_usr.FN_FORMATSTR(abs(PLDTC_QTY),13,3,'L','0'))--UNPLEDGE / AUTO UNPLEDGE / CONFISCATE PART QUANTITY
--										 + convert(char(100),PLDTC_RMKS) 
--										 + CONVERT(char(16),isnull(PLDTC_SLIP_NO,'')) DETAILS
--										,citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(PLDTC_QTY)),13,3,'L','0') QTY
--										FROM  cdsl_pledge_dtls
--										,dp_acct_mstr  A
--										WHERE PLDTC_DPAM_ID = A.dpam_id   
--										AND   A.dpam_deleted_ind  = 1  
--										AND   pldtc_deleted_ind = 1  
--										AND   isnull(pldtc_status,'P')='P'  
--										AND   ltrim(rtrim(isnull(pldtc_batch_no,''))) = ''  
--										AND   pldtc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'       
--										AND   dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
--										AND		dpam_dpm_id   = @L_DPM_ID
--										order by PLDTC_UPDATED_DATE
										Select convert(char(1),case when pldtc_trastm_cd in('CRTE','CONF') then 'P'  when pldtc_trastm_cd in('CLOS') then 'U' else '' end )--'P','U','C','A'  
										 + convert(char(1),case when pldtc_trastm_cd = 'CRTE' and isnull(PLDTC_SUB_STATUS,'') = '' then 'S'
															  when pldtc_trastm_cd = 'CONF' and isnull(PLDTC_SUB_STATUS,'') = '' then 'A'
															  when pldtc_trastm_cd = 'CLOS' and isnull(PLDTC_SUB_STATUS,'') = '' then 'S'
															  when isnull(PLDTC_SUB_STATUS,'') <> '' then isnull(PLDTC_SUB_STATUS,'') 
															  else '' end ) --'P' THEN 'S','A','R','C','E' --   'U' THEN 'S','A','R','C','E'--'A' THEN 'S','E'--'C' THEN 'S','E'
										 + convert(char(1),case when pldtc_trastm_cd = 'CRTE' and isnull(PLDTC_SUB_STATUS,'') = '' then isnull(PLDTC_SECURITTIES,'') else '' end)--'P''S' THEN 'F','L'   
										 + '0000000000000000'--convert(char(16),isnull(A.DPAM_SBA_NO,'')) --'P''S''L'   
--commented as want pledge slip no in new common format -- + convert(char(8),case when pldtc_trastm_cd = 'CRTE' and isnull(PLDTC_SUB_STATUS,'') = '' then '00000000' else isnull(PLDTC_PSN,'') end)  --'P''S' THEN '00000000' ELSE MEND PLDTC_PSN
									     + convert(char(8),pldtc_slip_no)
										 + convert(char(16),isnull(A.DPAM_SBA_NO,''))  
											+ convert(char(16),isnull(PLDTC_PLDG_CLIENTID,''))  
										 + convert(char(12),isnull(PLDTC_ISIN,''))  
										 + convert(char(16),citrus_usr.FN_FORMATSTR(abs(PLDTC_QTY),13,3,'L','0'))--'P' OR ZEROS
										 --+ ltrim(rtrim(convert(char(16),abs(PLDTC_QTY))))--'P' OR ZEROS
									     --+ convert(char(15),citrus_usr.FN_FORMATSTR(abs(isnull(CLOPM_CDSL_RT,0)*PLDTC_QTY),13,3,'L','0'))--'P' OR ZEROS--PLEDGE VALUE?????????
										 + convert(char(15),citrus_usr.FN_FORMATSTR(abs(isnull(CLOPM_CDSL_RT,0)*PLDTC_QTY),13,3,'L','0'))--'P' OR ZEROS--PLEDGE VALUE?????????
										 + convert(char(8),case when pldtc_trastm_cd = 'CRTE' and isnull(PLDTC_SUB_STATUS,'') = '' then replace(convert(varchar(11),PLDTC_EXPIRY_DT,103),'/','') else '00000000' end) --'P''S' ELSE ZEROS 
										 + convert(char(16),case when ((convert(char(1),case when pldtc_trastm_cd = 'CRTE' and isnull(PLDTC_SUB_STATUS,'') = '' then 'S'
															  when pldtc_trastm_cd = 'CONF' and isnull(PLDTC_SUB_STATUS,'') = '' then 'A'
															  when pldtc_trastm_cd = 'CLOS' and isnull(PLDTC_SUB_STATUS,'') = '' then 'S'
															  when isnull(PLDTC_SUB_STATUS,'') <> '' then isnull(PLDTC_SUB_STATUS,'') 
															  else '' end )) in ('A','R') and 
															  (case when pldtc_trastm_cd in('CRTE','CONF') then 'P'  when pldtc_trastm_cd in('CLOS') then 'U' else '' end) in ('P')) 
															  then convert(varchar(16),PLDTC_ID)
															  when ((convert(char(1),case when pldtc_trastm_cd = 'CRTE' and isnull(PLDTC_SUB_STATUS,'') = '' then 'S'
															  when pldtc_trastm_cd = 'CONF' and isnull(PLDTC_SUB_STATUS,'') = '' then 'A'
															  when pldtc_trastm_cd = 'CLOS' and isnull(PLDTC_SUB_STATUS,'') = '' then 'S'
															  when isnull(PLDTC_SUB_STATUS,'') <> '' then isnull(PLDTC_SUB_STATUS,'') 
															  else '' end )) in ('S') and 
															  (case when pldtc_trastm_cd in('CRTE','CONF') then 'P'  when pldtc_trastm_cd in('CLOS') then 'U' else '' end) in ('U')) then convert(varchar(16),PLDTC_ID)
															  else '' end)  --convert(char(16),case when pldtc_trastm_cd = 'CONF'  then PLDTC_ID else '' end )  --'PLEDGEE DP INTERNAL REF NO'
									     + convert(char(16),case when pldtc_trastm_cd = 'CRTE'  then PLDTC_ID else '' end ) --'PLEDGEE DP INTERNAL REF NO'  
										 + convert(char(20),PLDTC_AGREEMENT_NO)  --'P''S'
										 + convert(char(4),'0000') 
										 + '0000000000000000'--convert(char(16),citrus_usr.FN_FORMATSTR(abs(PLDTC_QTY),13,3,'L','0'))--UNPLEDGE / AUTO UNPLEDGE / CONFISCATE PART QUANTITY
										 + convert(char(100),PLDTC_RMKS) 
										 + CONVERT(char(16),isnull(PLDTC_SLIP_NO,'')) DETAILS
										--,citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(PLDTC_QTY)),13,3,'L','0') QTY
										,ltrim(rtrim(convert(char(16),abs(PLDTC_QTY)))) QTY
,'','','','','',PLDTC_ID,replace(convert(varchar(11),isnull(PLDTC_REQUEST_DT,space(8)),103),'/','') PLDTC_REQUEST_DT
										FROM  cdsl_pledge_dtls left outer join closing_price_mstr_cdsl on  CLOPM_ISIN_CD =   PLDTC_ISIN  
                                        and    ISNULL(CLOPM_DT,'01/01/1900') = ( select top 1 CLOPM_DT from CLOSING_PRICE_MSTR_CDSL WHERE CLOPM_ISIN_CD = PLDTC_ISIN  and CLOPM_DELETED_IND = 1  order by CLOPM_DT desc)
										,dp_acct_mstr  A
										WHERE PLDTC_DPAM_ID = A.dpam_id  
										--and   CLOPM_ISIN_CD =   PLDTC_ISIN
										--and   PLDTC_REQUEST_DT = CLOPM_DT
										AND   A.dpam_deleted_ind  = 1  
										AND   pldtc_deleted_ind = 1  
										AND   isnull(pldtc_status,'P')='P'  
										AND   ltrim(rtrim(isnull(pldtc_batch_no,''))) = ''  
										AND   pldtc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'       
										AND   dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
										--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
										order by PLDTC_UPDATED_DATE										 
						
										SELECT @L_TOT_REC = COUNT(pldtc_id) FROM cdsl_pledge_dtls ,dp_acct_mstr  
										WHERE  isnull(pldtc_status,'P')='P' and PLDTC_DPAM_ID = dpam_id   
										--AND    dpam_dpm_id      = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
										AND    ltrim(rtrim(isnull(pldtc_batch_no,''))) = ''  
										AND    pldtc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
										AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END

										IF @L_TOT_REC > 0  
										BEGIN   
										/* Update in Demat_request_mstr*/   
										UPDATE D1 Set pldtc_batch_no=@pa_batch_no FROM cdsl_pledge_dtls D1 ,dp_acct_mstr D2  
										WHERE  PLDTC_DPAM_ID = dpam_id   
										--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
										AND    isnull(pldtc_status,'P')='P'  
										AND    ltrim(rtrim(isnull(pldtc_batch_no,''))) = ''  
										AND    pldtc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
										AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  

										/* Update in Bitmap ref mstr*/   
--										UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
--										WHERE   BITRM_PARENT_CD = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  
--										  
--														/* insert into batch table*/                    
--																IF NOT EXISTS(SELECT BATCHN_NO FROM BATCHNO_NSDL_MSTR   WHERE BATCHN_NO  = @PA_BATCH_NO AND BATCHN_DPM_ID = @L_DPM_ID AND BATCHN_DELETED_IND =1)  
--																	BEGIN  
--																		INSERT INTO BATCHNO_CDSL_MSTR                                       
--																		(    
--																			BATCHC_DPM_ID,  
--																			BATCHC_NO,  
--																			BATCHC_RECORDS ,  
--																			BATCHC_TRANS_TYPE,
--																			BATCHC_FILEGEN_DT,           
--																			BATCHC_TYPE,  
--																			BATCHC_STATUS,  
--																			BATCHC_CREATED_BY,  
--																			BATCHC_CREATED_DT ,  
--																			BATCHC_DELETED_IND  
--																		)  
--																		VALUES  
--																		(  
--																			@L_DPM_ID,  
--																			@PA_BATCH_NO,  
--																			@L_TOT_REC,  
--																			@PA_BATCH_TYPE,
--																			CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'  ,
--																			'T',  
--																			'P',  
--																			@PA_LOGINNAME,  
--																			GETDATE(),  
--																			1  
--																		)      
--																																																											END  
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
										 + '0000000000000000'--convert(char(16),isnull(A.DPAM_SBA_NO,'')) --'P''S''L'   
										 + convert(char(8),case when pldtc_trastm_cd = 'CRTE' and isnull(PLDTC_SUB_STATUS,'') = '' then '00000000' else isnull(PLDTC_PSN,'') end)  --'P''S' THEN '00000000' ELSE MEND PLDTC_PSN
										 + convert(char(16),isnull(A.DPAM_SBA_NO,''))  
											+ convert(char(16),isnull(PLDTC_PLDG_CLIENTID,''))  
										 + convert(char(12),isnull(PLDTC_ISIN,''))  
										 + convert(char(16),citrus_usr.FN_FORMATSTR(abs(PLDTC_QTY),13,3,'L','0'))--'P' OR ZEROS
											+ convert(char(15),citrus_usr.FN_FORMATSTR(abs(CLOPM_CDSL_RT*PLDTC_QTY),13,3,'L','0'))--'P' OR ZEROS--PLEDGE VALUE?????????
										 + convert(char(8),case when pldtc_trastm_cd = 'CRTE' and isnull(PLDTC_SUB_STATUS,'') = '' then replace(convert(varchar(11),PLDTC_EXPIRY_DT,103),'/','') else '00000000' end) --'P''S' ELSE ZEROS 
										 + convert(char(16),case when pldtc_trastm_cd = 'CONF'  then PLDTC_ID else '' end )  --'PLEDGEE DP INTERNAL REF NO'
									     + convert(char(16),case when pldtc_trastm_cd = 'CRTE'  then PLDTC_ID else '' end ) --'PLEDGEE DP INTERNAL REF NO'  
										 + convert(char(20),PLDTC_AGREEMENT_NO)  --'P''S'
										 + convert(char(4),'0000') --'UNPLEDGE / AUTO UNPLEDGE / CONFISCATE PART COUNTER' 
											+ convert(char(16),citrus_usr.FN_FORMATSTR(abs(PLDTC_QTY),13,3,'L','0'))--UNPLEDGE / AUTO UNPLEDGE / CONFISCATE PART QUANTITY
										 + convert(char(100),PLDTC_RMKS) 
										 + CONVERT(char(16),isnull(PLDTC_SLIP_NO,'')) DETAILS
										,citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(PLDTC_QTY)),13,3,'L','0') QTY
										FROM  cdsl_pledge_dtls,closing_price_mstr_cdsl
										,dp_acct_mstr  A
										WHERE PLDTC_DPAM_ID = A.dpam_id 
										and   PLDTC_ISIN = CLOPM_ISIN_CD
										and   PLDTC_REQUEST_DT = CLOPM_DT
										AND   A.dpam_deleted_ind  = 1  
										AND   pldtc_deleted_ind = 1  
										AND   isnull(pldtc_status,'P')='P'  
										AND   ltrim(rtrim(isnull(pldtc_batch_no,''))) = @PA_BATCH_NO
										AND   pldtc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'       
										AND   dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
										--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
										order by PLDTC_UPDATED_DATE
										 
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
												,abs(fre_qty) qty,'','','','','','',''
												FROM freeze_Unfreeze_dtls_cdsl D1 
											       , DP_ACCT_MSTR D2   
												WHERE D1.fre_Dpam_id = convert(varchar,D2.DPAM_ID) 
												--AND DPAM_DPM_ID = @L_DPM_ID   
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
												AND D1.fre_activation_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  																								  
												AND LTRIM(RTRIM(ISNULL(D1.FRE_BATCH_NO,'0'))) = '0' 
												AND d1.fre_trans_type='S'
												AND isnull(D1.fre_upload_status,'P')='P'
												AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
												AND D1.fre_deleted_ind = 1   
												order by fre_lst_upd_dt 
												
						
										SELECT @L_TOT_REC = COUNT(fre_id) FROM freeze_Unfreeze_dtls_cdsl ,dp_acct_mstr  
										WHERE  isnull(fre_upload_status,'P')='P' and fre_DPAM_ID = convert(varchar,dpam_id)   
										--AND    dpam_dpm_id      = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
										AND    ltrim(rtrim(isnull(fre_batch_no,'0'))) = '0'  
										AND    fre_activation_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
										AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END

										IF @L_TOT_REC > 0  
										BEGIN   
										/*Update in Demat_request_mstr*/   
										UPDATE D1 Set fre_batch_no=@pa_batch_no FROM freeze_Unfreeze_dtls_cdsl D1 ,dp_acct_mstr D2  
										WHERE  fre_DPAM_ID = convert(varchar,dpam_id)  
										--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
										AND    isnull(fre_status,'P')='P'  
										AND    ltrim(rtrim(isnull(fre_batch_no,'0'))) = '0'  
										AND    fre_activation_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
										AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  

										/* Update in Bitmap ref mstr*/   
--										UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
--										WHERE   BITRM_PARENT_CD = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  
--										  
--														/* insert into batch table*/                    
--																IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1)  
--																	BEGIN  
--																		INSERT INTO BATCHNO_CDSL_MSTR                                       
--																		(    
--																			BATCHC_DPM_ID,  
--																			BATCHC_NO,  
--																			BATCHC_RECORDS ,  
--																			BATCHC_TRANS_TYPE,
--																			BATCHC_FILEGEN_DT,           
--																			BATCHC_TYPE,  
--																			BATCHC_STATUS,  
--																			BATCHC_CREATED_BY,  
--																			BATCHC_CREATED_DT ,  
--																			BATCHC_DELETED_IND  
--																		)  
--																		VALUES  
--																		(  
--																			@L_DPM_ID,  
--																			@PA_BATCH_NO,  
--																			@L_TOT_REC,  
--																			@PA_BATCH_TYPE,
--																			CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'  ,
--																			'T',  
--																			'P',  
--																			@PA_LOGINNAME,  
--																			GETDATE(),  
--																			1  
--																		)      
--																																																											END  
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
												,abs(fre_qty) qty,'','','','','','',''
												FROM freeze_Unfreeze_dtls_cdsl D1 
											       , DP_ACCT_MSTR D2   
												WHERE D1.fre_Dpam_id = convert(varchar,D2.DPAM_ID) 
												---AND DPAM_DPM_ID = @L_DPM_ID   
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
												AND D1.fre_activation_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  																							  
												AND LTRIM(RTRIM(ISNULL(D1.FRE_BATCH_NO,'0'))) = '0' 
                                                AND d1.fre_trans_type='S'
                                                AND isnull(D1.fre_upload_status,'P')='P'
												AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
												AND D1.fre_deleted_ind = 1  order by fre_lst_upd_dt 

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
												--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
												order by d1.fre_lst_upd_dt 
						
										SELECT @L_TOT_REC = COUNT(fre_id) FROM freeze_Unfreeze_dtls_cdsl ,dp_acct_mstr  
										WHERE  isnull(fre_upload_status,'P')='P' and fre_DPAM_ID = convert(varchar,dpam_id)   
										--AND    dpam_dpm_id      = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
										AND    ltrim(rtrim(isnull(fre_batch_no,'0'))) = '0'  
										AND    fre_created_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
										AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END

										IF @L_TOT_REC > 0  
										BEGIN   
										/* Update in Demat_request_mstr*/   
										UPDATE D1 Set fre_batch_no=@pa_batch_no FROM freeze_Unfreeze_dtls_cdsl D1 ,dp_acct_mstr D2  
										WHERE  fre_DPAM_ID = convert(varchar,dpam_id)   
										--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
										AND    isnull(fre_status,'P')='P'  
										AND    ltrim(rtrim(isnull(fre_batch_no,'0'))) = '0'  
										AND    fre_created_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
										AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  

										/* Update in Bitmap ref mstr*/   
--										UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
--										WHERE   BITRM_PARENT_CD = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  
--										  
--														/* insert into batch table*/                    
--																IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1)  
--																	BEGIN  
--																		INSERT INTO BATCHNO_CDSL_MSTR                                       
--																		(    
--																			BATCHC_DPM_ID,  
--																			BATCHC_NO,  
--																			BATCHC_RECORDS ,  
--																			BATCHC_TRANS_TYPE,
--																			BATCHC_FILEGEN_DT,           
--																			BATCHC_TYPE,  
--																			BATCHC_STATUS,  
--																			BATCHC_CREATED_BY,  
--																			BATCHC_CREATED_DT ,  
--																			BATCHC_DELETED_IND  
--																		)  
--																		VALUES  
--																		(  
--																			@L_DPM_ID,  
--																			@PA_BATCH_NO,  
--																			@L_TOT_REC,  
--																			@PA_BATCH_TYPE,
--																			CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'  ,
--																			'T',  
--																			'P',  
--																			@PA_LOGINNAME,  
--																			GETDATE(),  
--																			1  
--																		)      
--																																																											END  
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
									--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
									order by d1.fre_lst_upd_dt 

									END   


						--  
						END  

--UNFRZ

 
												IF @l_TRX_TAB= 'CLSR_ACCT_GEN'   
												BEGIN  
													SELECT * FROM CLOSURE_ACCT_MSTR WHERE  CLSR_DATE BETWEEN   
													CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT ,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'     
													AND CLSR_DELETED_IND=1  
												END   
												
												
						IF @l_TRX_TAB= 'REMAT'   
						BEGIN
										IF @PA_BATCH_TYPE = 'BN'  
										BEGIN  
										
											Select '26' + 'R' 
											+ convert(char(16),isnull(dpam_sba_no,''))  
											+ convert(char(12),isnull(remrm_isin,''))  
											+ convert(char(16),isnull(remrm_slip_serial_no,''))  
											+ convert(char(16),citrus_usr.FN_FORMATSTR(convert(varchar(16),abs(remrm_qty)),13,3,'L','0'))   
											 
											+ convert(char(1),isnull(remrm_lot_type,'')) --convert(char(20),convert(varchar(20),case when isnull(disp_doc_id,0) =0 then '' else convert(varchar(20),disp_doc_id) end))  
											+ --convert(char(30),isnull(disp_name,''))
											+ --case when convert(char(8),replace(convert(varchar(11),isnull(Disp_dt,space(8)),103),'/','')) = '01011900' then  convert(char(8),'00000000') else convert(char(8),replace(convert(varchar(11),isnull(Disp_dt,space(8)),103),'/','')) end  
											+ --convert(char(5),citrus_usr.FN_FORMATSTR(CONVERT(VARCHAR(5),isnull(remrm_total_certificates,'0')),5,0,'L','0'))    
											+ case when convert(char(1),isnull(remrm_free_lockedin_yn,''))='Y' then 'L' else 'F' end  
											+ convert(char(16),isnull(remrm_lockin_reason_cd,''))
											+ convert(char(11),citrus_usr.FN_FORMATSTR(convert(varchar(11),abs(remrm_certificate_no)),8,3,'L','0'))
											+ convert(char(40),case when ltrim(rtrim(isnull(rEMRM_RMKS,'')))='' then space(40) else ltrim(rtrim(isnull(rEMRM_RMKS,''))) end ) 
											
											DETAILS
											,abs(remrm_qty) qty
											,REMRM_REPURCHASE_FLG,'','','','','0',replace(convert(varchar(11),isnull(rEMRM_REQUEST_DT,space(8)),103),'/','') rEMRM_REQUEST_DT
												FROM  remat_request_mstr  
												
												,dp_acct_mstr  
												WHERE remrm_dpam_id     = dpam_id   
												AND   dpam_deleted_ind  = 1  
												AND   remrm_deleted_ind = 1  
												AND    isnull(remrm_status,'P')='P'  
												AND    ltrim(rtrim(isnull(remrm_batch_no,''))) = ''
												AND	  ISNULL(rEMRM_INTERNAL_REJ,'') = ''   
												AND   remrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'       
												AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
												--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
												order by remrm_lst_upd_dt 

												SELECT @L_TOT_REC = COUNT(remrm_ID) FROM remat_request_mstr ,dp_acct_mstr  
												WHERE  isnull(remrm_status,'P')='P' and remrm_dpam_id = dpam_id      
												--AND    dpam_dpm_id      = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
												AND    ltrim(rtrim(isnull(remrm_batch_no,''))) = '' 
												AND	  ISNULL(rEMRM_INTERNAL_REJ,'') = '' 
												AND    remrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
												AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END

												IF @L_TOT_REC > 0  
												BEGIN   

															/* Update in Demat_request_mstr*/   
															UPDATE D1 Set remrm_batch_no=@pa_batch_no FROM remat_request_mstr D1 ,dp_acct_mstr D2  
															WHERE  remrm_dpam_id = dpam_id   
															--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
															AND    isnull(remrm_status,'P')='P'  
															AND    ltrim(rtrim(isnull(remrm_batch_no,''))) = ''
															AND	  ISNULL(rEMRM_INTERNAL_REJ,'') = ''  
															AND    remrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
															AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  
															/* Update in Bitmap ref mstr*/   
--															UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
--															WHERE   BITRM_PARENT_CD = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  
--
--															/* insert into batch table*/                    
--																	IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@l_TRX_TAB)  
--																		BEGIN  
--																			INSERT INTO BATCHNO_CDSL_MSTR                                       
--																			(    
--																				BATCHC_DPM_ID,  
--																				BATCHC_NO,  
--																				BATCHC_RECORDS ,  
--																				BATCHC_TRANS_TYPE,
--																				BATCHC_FILEGEN_DT,           
--																				BATCHC_TYPE,  
--																				BATCHC_STATUS,  
--																				BATCHC_CREATED_BY,  
--																				BATCHC_CREATED_DT ,  
--																				BATCHC_DELETED_IND  
--																			)  
--																			VALUES  
--																			(  
--																				@L_DPM_ID,  
--																				@PA_BATCH_NO,  
--																				@L_TOT_REC,  
--																				@l_TRX_TAB,
--																				CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'  ,
--																				'T',  
--																				'P',  
--																				@PA_LOGINNAME,  
--																				GETDATE(),  
--																				1  
--																			)      
--																																																												END  
												END   
						
									END  						
						END												
												 
 
    --												
												 
 
    --
    END
  --  
	Else IF @pa_broker_yn = 'A' -- for all
	begin -- for all
	
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
														--+ convert(char(16),isnull(dptdc_counter_demat_acct_no,''))  
                                                        + case when len(dptdc_counter_demat_acct_no)=16 then convert(char(16),isnull(dptdc_counter_demat_acct_no,''))  else convert(char(8),isnull(dptdc_counter_dp_id,'')) + convert(char(8),isnull(dptdc_counter_demat_acct_no,'')) end
														+ convert(char(16),DPTDC_SLIP_NO+'/'+dptdc_internal_ref_no)
														+ convert(char(8),replace(convert(varchar(11),dptdc_execution_dt,103),'/',''))  DETAILS
														, abs(dptdc_qty) qty , 'N' TRXEFLG ,citrus_usr.fn_get_slip_no_export(dpam_sba_no,dptdc_slip_no) dptdc_slip_no , dptdc_created_by , case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')='' then dptdc_lst_upd_by else isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'') end dptdc_lst_upd_by , case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')<>'' then dptdc_lst_upd_by else '' end verifier
														,dptdc_id  as USN,''
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
												--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
												order by dptdc_lst_upd_dt 

															SELECT @L_TOT_REC = COUNT(DPTDC_ID) FROM dp_trx_dtls_cdsl ,dp_acct_mstr  
																																							WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
															--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
															AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
															AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
															AND    dptdc_internal_trastm = @l_TRX_TAB  
															AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 

															IF @L_TOT_REC > 0   
															BEGIN   
																	/* Update in dp_trx_dtls_cdsl*/ 

															SELECT @L_TRANS_TYPE = dptdc_internal_trastm FROM dp_trx_dtls_cdsl ,dp_acct_mstr  
															WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
															--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
															AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
															AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
															AND    dptdc_internal_trastm = @l_TRX_TAB   
															AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
															

															UPDATE D1 Set dptdc_batch_no=@pa_batch_no FROM dp_trx_dtls_cdsl D1 ,dp_acct_mstr D2  
															WHERE  dptdc_dpam_id = dpam_id   
															--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
															AND    isnull(dptdc_status,'P')='P'  
															AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
															AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
															AND    dptdc_internal_trastm = @l_TRX_TAB   
															AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
															


															/* Update in Bitmap ref mstr*/   
--															UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
--															WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  
--
--															/* insert into batch table*/  
--
--
--
--																	IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@l_TRX_TAB)  
--																	BEGIN  
--																		INSERT INTO BATCHNO_CDSL_MSTR                                       
--																		(    
--																			BATCHC_DPM_ID,  
--																			BATCHC_NO,  
--																			BATCHC_RECORDS ,  
--																			BATCHC_TRANS_TYPE,          
--																			BATCHC_TYPE,  
--																			BATCHC_FILEGEN_DT,
--																			BATCHC_STATUS,  
--																			BATCHC_CREATED_BY,  
--																			BATCHC_CREATED_DT ,  
--																			BATCHC_DELETED_IND  
--																		)  
--																		VALUES  
--																		(  
--																			@L_DPM_ID,  
--																			@PA_BATCH_NO,  
--																			@L_TOT_REC,  
--																			@L_TRANS_TYPE,  
--																			'T',  
--																			CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',
--																			'P',  
--																			@PA_LOGINNAME,  
--																			GETDATE(),  
--																			1  
--																		)      
--																																																											END  
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
														--+ convert(char(16),isnull(dptdc_counter_demat_acct_no,''))  
                                                        + case when len(dptdc_counter_demat_acct_no)=16 then convert(char(16),isnull(dptdc_counter_demat_acct_no,''))  else convert(char(8),isnull(dptdc_counter_dp_id,'')) + convert(char(8),isnull(dptdc_counter_demat_acct_no,'')) end
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
												--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
												order by dptdc_lst_upd_dt 

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
													, case when dpam_sba_no=dptdc_created_by then 'Y' else  'N' end  TRXEFLG --'N'
													,citrus_usr.fn_get_slip_no_export(dpam_sba_no,dptdc_slip_no) dptdc_slip_no , dptdc_created_by , case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')='' then dptdc_lst_upd_by else isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'') end dptdc_lst_upd_by , case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')<>'' then dptdc_lst_upd_by else '' end verifier
													,dptdc_id    as USN,''
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
								--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
								order by dptdc_lst_upd_dt 
 


									SELECT @L_TOT_REC = COUNT(DPTDC_ID) FROM dp_trx_dtls_cdsl ,dp_acct_mstr  
																														WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
																														--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
									AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
									AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
									AND    dptdc_internal_trastm = @l_TRX_TAB    
									AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
									

									IF @L_TOT_REC > 0   
									BEGIN   
												/* Update in dp_trx_dtls_cdsl*/  

												SELECT @L_TRANS_TYPE = dptdc_internal_trastm FROM dp_trx_dtls_cdsl ,dp_acct_mstr  
												WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
												--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
												AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
												AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
												AND    dptdc_internal_trastm = @l_TRX_TAB 
												AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  
												

												UPDATE D1 Set dptdc_batch_no=@pa_batch_no FROM dp_trx_dtls_cdsl D1 ,dp_acct_mstr D2  
												WHERE  dptdc_dpam_id = dpam_id   
												--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
												AND    isnull(dptdc_status,'P')='P'  
												AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
												AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
												AND    dptdc_internal_trastm = @l_TRX_TAB  
												AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
												

															/* Update in Bitmap ref mstr*/   
--												UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
--												WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND  BITRM_CHILD_CD= @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  
--
--												/* insert into batch table*/  
--
--
--
--																IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@l_TRX_TAB)  
--																	BEGIN  
--																		INSERT INTO BATCHNO_CDSL_MSTR                                       
--																		(    
--																			BATCHC_DPM_ID,  
--																			BATCHC_NO,  
--																			BATCHC_RECORDS ,  
--																			BATCHC_TRANS_TYPE,
--																			BATCHC_FILEGEN_DT,           
--																			BATCHC_TYPE,  
--																			BATCHC_STATUS,  
--																			BATCHC_CREATED_BY,  
--																			BATCHC_CREATED_DT ,  
--																			BATCHC_DELETED_IND  
--																		)  
--																		VALUES  
--																		(  
--																			@L_DPM_ID,  
--																			@PA_BATCH_NO,  
--																			@L_TOT_REC,  
--																			@L_TRANS_TYPE,
--																			CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',  
--																			'T',  
--																			'P',  
--																			@PA_LOGINNAME,  
--																			GETDATE(),  
--																			1  
--																		)      
--																																																											END  

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
								
																										AND    isnull(dptdc_status,'P')='P'  
												AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = @PA_BATCH_NO  
								AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
								AND    dptdc_internal_trastm = @l_TRX_TAB  
								AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
								--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
								order by dptdc_lst_upd_dt 

								END   
						--  
						END  
						IF @l_TRX_TAB in ('OFFM')  
						BEGIN  
						--   
									-- in case of request for off market  
								IF @PA_BATCH_TYPE = 'BN'  
									BEGIN  
										SELECT  replace(convert(varchar(11),dptdc_execution_dt,103),'/','')  
												+ isnull(dpam_sba_no,'')  
												+ case when (dpam_sba_no=dptdc_created_by and len(dptdc_counter_demat_acct_no)=16)  then right(isnull(dptdc_counter_demat_acct_no,''),16) when (dpam_sba_no=dptdc_created_by and len(dptdc_counter_demat_acct_no)=8) then  isnull(dptdc_counter_dp_id,'') + isnull(dptdc_counter_demat_acct_no,'') when (LEN(dptdc_counter_demat_acct_no)>8 and LEN(dptdc_counter_demat_acct_no)<>'16') then ISNULL(dptdc_counter_demat_acct_no,'') + SPACE(1) else isnull(dptdc_counter_dp_id,'') + isnull(dptdc_counter_demat_acct_no,'') end   
												+ isnull(convert(char(12),dptdc_isin),'')  
												+ convert(varchar(16),citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(dptdc_qty)),12,3,'L','0'))    
												+ case  when dptdc_internal_trastm in('BOCM','CMCM') then 'S' when dptdc_internal_trastm = 'CMBO' then 'S' else 'S' end  
												+ isnull(dptdc_cash_trf,'')  
												---- need to revert for old  
												----+ case when isnull(convert(varchar(10),dptdc_reason_cd),'2')=0 then '2' else isnull(convert(varchar(10),dptdc_reason_cd),'2')  end--isnull(convert(varchar(10),dptdc_reason_cd),'2')  
												
												+ case when isnull(convert(varchar(10),dptdc_reason_cd),'2')=0 then SPACE(1) else isnull(convert(varchar(10),dptdc_reason_cd),'2')  end--isnull(convert(varchar(10),dptdc_reason_cd),'2')  
												+ convert(char(16),'/'+dptdc_internal_ref_no) -- DPTDC_SLIP_NO+
												--+ case when isnull(dptdc_settlement_no,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',dptdc_settlement_no,A.settm_type_cdsl),'')   +isnull(dptdc_settlement_no,''))  else convert(char(13),'') end 
                                                --+ case when isnull(DPTDC_OTHER_SETTLEMENT_NO,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',DPTDC_OTHER_SETTLEMENT_NO,B.settm_type_cdsl),'')   +isnull(DPTDC_OTHER_SETTLEMENT_NO,''))  else convert(char(13),'') end 
												+ case when dptdc_internal_trastm in ('CMCM') then case when isnull(DPTDC_OTHER_SETTLEMENT_NO,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',DPTDC_OTHER_SETTLEMENT_NO,B.settm_type_cdsl),'')   +isnull(DPTDC_OTHER_SETTLEMENT_NO,''))  else convert(char(13),'') end  else case when isnull(dptdc_settlement_no,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',dptdc_settlement_no,A.settm_type_cdsl),'')   +isnull(dptdc_settlement_no,''))  else convert(char(13),'') end end
                                                + case when dptdc_internal_trastm in ('CMCM') then case when isnull(dptdc_settlement_no,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',dptdc_settlement_no,A.settm_type_cdsl),'')   +isnull(dptdc_settlement_no,''))  else convert(char(13),'') end else case when isnull(DPTDC_OTHER_SETTLEMENT_NO,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',DPTDC_OTHER_SETTLEMENT_NO,B.settm_type_cdsl),'')   +isnull(DPTDC_OTHER_SETTLEMENT_NO,''))  else convert(char(13),'') end end
                                                
													+ convert(char(1),ltrim(rtrim(case when DPTDC_PAYMODE='Cheque Payment' then '1' when DPTDC_PAYMODE='Electronic Payment' then '2' when DPTDC_PAYMODE='Cash Payment' then '3' else '' end )))
	+ convert(char(35),isnull(DPTDC_BANKACNO,''))
	+ convert(char(100),isnull(DPTDC_BANKACNAME,''))
	+ convert(char(100),isnull(DPTDC_BANKBRNAME,''))
	+ convert(char(150),isnull(DPTDC_TRANSFEREENAME,''))
	+ case when convert(char(8),isnull(replace(convert(varchar(11),DPTDC_DOI,103),'/','')  ,''))='01011900' then SPACE(8) else convert(char(8),isnull(replace(convert(varchar(11),DPTDC_DOI,103),'/','')  ,'')) end --convert(char(8),isnull(replace(convert(varchar(11),DPTDC_DOI,103),'/','')  ,''))
	+ convert(char(22),isnull(DPTDC_CHQ_REFNO,''))

                                                   DETAILS--space(13) DETAILS  
												, abs(dptdc_qty) qty
												, case when dpam_sba_no=dptdc_created_by then 'Y' else  'N' end TRXEFLG  -- 'N' TRXEFLG 
												,citrus_usr.fn_get_slip_no_export(dpam_sba_no,dptdc_slip_no) dptdc_slip_no , dptdc_created_by , case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')='' then dptdc_lst_upd_by else isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'') end dptdc_lst_upd_by , case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')<>'' then dptdc_lst_upd_by else '' end verifier
												,dptdc_id   as USN,''
											FROm   dp_trx_dtls_cdsl   
                                                   left outer join  settlement_type_mstr  A on convert(varchar,A.settm_id) = dptdc_mkt_type and dptdc_mkt_type <> ''
                                                   left outer join  settlement_type_mstr  B on convert(varchar,B.settm_id) = DPTDC_OTHER_SETTLEMENT_TYPE and DPTDC_OTHER_SETTLEMENT_TYPE <> ''
																, dp_acct_mstr  
											WHERE  dpam_id  = dptdc_dpam_id  
											AND    dpam_deleted_ind  = 1  
											AND    isnull(dptdc_status,'P')='P'  
											AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
											AND    dptdc_deleted_ind  = 1  
											AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
											AND    dptdc_internal_trastm in ('CMBO','CMCM','BOBO','BOCM')  
											AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
											--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
                                            order by dptdc_lst_upd_dt 
 
											

											SELECT @L_TOT_REC = COUNT(DPTDC_ID) FROM dp_trx_dtls_cdsl ,dp_acct_mstr  
											WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
											--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
											AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
											AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
											AND    dptdc_internal_trastm in ('CMBO','CMCM','BOBO','BOCM')  
											AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  
											

											IF @L_TOT_REC > 0   
												BEGIN  
															/* Update in dp_trx_dtls_cdsl*/ 

															SELECT @L_TRANS_TYPE = dptdc_internal_trastm FROM dp_trx_dtls_cdsl ,dp_acct_mstr  
															WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
															--AND    dpam_dpm_id   = @l_dpm_id    

												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
															AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
															AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
															AND    dptdc_internal_trastm in ('CMBO','CMCM','BOBO','BOCM')  
															AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  
															

															UPDATE D1 Set dptdc_batch_no=@pa_batch_no FROM dp_trx_dtls_cdsl D1 ,dp_acct_mstr D2  
															WHERE  dptdc_dpam_id = dpam_id   
															--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
															AND    isnull(dptdc_status,'P')='P'  
															AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
															AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
															AND    dptdc_internal_trastm in ('CMBO','CMCM','BOBO','BOCM')  
															AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
															


															/* Update in Bitmap ref mstr*/   
--															UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
--															WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND  BITRM_CHILD_CD = @L_DPM_ID 
--															AND BITRM_BIT_LOCATION = @PA_EXCSM_ID   
--
--
--
--
--															/* insert into batch table*/              
--
--																IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@l_TRX_TAB)  
--																	BEGIN  
--
--																		INSERT INTO BATCHNO_CDSL_MSTR                                       
--																		(    
--																			BATCHC_DPM_ID,  
--																			BATCHC_NO,  
--																			BATCHC_RECORDS ,  
--																			BATCHC_TRANS_TYPE, 
--																			BATCHC_FILEGEN_DT,          
--																			BATCHC_TYPE,  
--																			BATCHC_STATUS,  
--																			BATCHC_CREATED_BY,  
--																			BATCHC_CREATED_DT ,  
--																			BATCHC_DELETED_IND  
--																		)  
--																		VALUES  
--																		(  
--																			@L_DPM_ID,  
--																			@PA_BATCH_NO,  
--																			@L_TOT_REC,  
--																			@l_TRX_TAB,--@L_TRANS_TYPE,
--																			CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',  
--																			'T',  
--																			'P',  
--																			@PA_LOGINNAME,  
--																			GETDATE(),  
--																			1  
--																		)      
--																			END  
												END              

									END  
																										ELSE  
									BEGIN   
										SELECT  replace(convert(varchar(11),dptdc_execution_dt,103),'/','')  
												+ isnull(dpam_sba_no,'')  
												+ isnull(dptdc_counter_dp_id,'') + isnull(dptdc_counter_demat_acct_no,'')  
												+ isnull(convert(char(12),dptdc_isin),'')  
												+ convert(varchar(16),citrus_usr.FN_FORMATSTR(convert(varchar(15),abs(dptdc_qty)),12,3,'L','0'))    
												+ case  when dptdc_internal_trastm in('BOCM','CMCM') then 'S' when dptdc_internal_trastm = 'CMBO' then 'S' else 'S' end  
												+ isnull(dptdc_cash_trf,'')  
												+ isnull(convert(varchar(10),dptdc_reason_cd),'2')  
												+ convert(char(16),'/'+dptdc_internal_ref_no)--+ convert(char(16),DPTDC_SLIP_NO+'/'+dptdc_internal_ref_no)
											    + case when isnull(dptdc_settlement_no,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',dptdc_settlement_no,A.settm_type_cdsl),'')   +isnull(dptdc_settlement_no,''))  else convert(char(13),'') end 
                                                + case when isnull(DPTDC_OTHER_SETTLEMENT_NO,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',DPTDC_OTHER_SETTLEMENT_NO,B.settm_type_cdsl),'')   +isnull(DPTDC_OTHER_SETTLEMENT_NO,''))  else convert(char(13),'') end 
                                                   DETAILS--space(13) DETAILS  
												, abs(dptdc_qty) qty
											FROm   dp_trx_dtls_cdsl   
                                                   left outer join  settlement_type_mstr  A on convert(varchar,A.settm_id) = dptdc_mkt_type and dptdc_mkt_type <> ''
                                                   left outer join  settlement_type_mstr  B on convert(varchar,B.settm_id) = DPTDC_OTHER_SETTLEMENT_TYPE and DPTDC_OTHER_SETTLEMENT_TYPE <> ''
																, dp_acct_mstr  
											WHERE  dpam_id  = dptdc_dpam_id  
											AND    dpam_deleted_ind  = 1  
											AND    dptdc_deleted_ind  = 1  
											AND    isnull(dptdc_status,'P')='P'  
											AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = @PA_BATCH_NO  
											AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
											AND    dptdc_internal_trastm in ('CMBO','CMCM','BOBO','BOCM')  
											AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
											--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
											order by dptdc_lst_upd_dt 


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
														+ case when isnull(dptdc_other_settlement_no,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',dptdc_other_settlement_no,A.settm_type_cdsl),'')   +isnull(dptdc_other_settlement_no,''))  else convert(char(13),'') END
														
														+ convert(char(16),'/'+dptdc_internal_ref_no) --DPTDC_SLIP_NO+
                                                        + case when isnull(dptdc_settlement_no,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',dptdc_other_settlement_no,B.settm_type_cdsl),'')   +isnull(dptdc_settlement_no,''))  else convert(char(13),'') END 
														+ case when isnull(convert(varchar,dptdc_reason_cd),'0')='0' then space(1) when DPTDC_CREATED_BY = DPAM_SBA_NO and  DPTDC_OTHER_SETTLEMENT_NO <>''and   left(DPTDC_COUNTER_CMBP_ID ,2) = 'IN'  then '23' else  isnull(convert(varchar,dptdc_reason_cd),'') end 

															+ convert(char(1),ltrim(rtrim(case when DPTDC_PAYMODE='Cheque Payment' then '1' when DPTDC_PAYMODE='Electronic Payment' then '2' when DPTDC_PAYMODE='Cash Payment' then '3' else '' end )))
	+ convert(char(35),isnull(DPTDC_BANKACNO,''))
	+ convert(char(100),isnull(DPTDC_BANKACNAME,''))
	+ convert(char(100),isnull(DPTDC_BANKBRNAME,''))
	+ convert(char(150),isnull(DPTDC_TRANSFEREENAME,''))
	+ case when convert(char(8),isnull(replace(convert(varchar(11),DPTDC_DOI,103),'/','')  ,''))='01011900' then space(8) else convert(char(8),isnull(replace(convert(varchar(11),DPTDC_DOI,103),'/','')  ,'')) end --convert(char(8),isnull(replace(convert(varchar(11),DPTDC_DOI,103),'/','')  ,''))
	+ convert(char(22),isnull(DPTDC_CHQ_REFNO,''))

														DETAILS
														, abs(dptdc_qty) qty, case when dpam_sba_no=dptdc_created_by then 'Y' else 'N' end TRXEFLG ,citrus_usr.fn_get_slip_no_export(dpam_sba_no,dptdc_slip_no) dptdc_slip_no , dptdc_created_by , case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')='' then dptdc_lst_upd_by else isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'') end dptdc_lst_upd_by , case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')<>'' then dptdc_lst_upd_by else '' end verifier
														,dptdc_id    as USN,''
											FROM   dp_trx_dtls_cdsl   
												   left outer join settlement_type_mstr A on convert(varchar,A.settm_id) = dptdc_other_settlement_type and dptdc_other_settlement_type <> ''
                                                   left outer join settlement_type_mstr B on convert(varchar,B.settm_id) = DPTDC_MKT_TYPE and DPTDC_MKT_TYPE <> ''
																, dp_acct_mstr  

											WHERE  dpam_id            = dptdc_dpam_id  
											AND    dpam_deleted_ind   = 1  
											AND    dptdc_deleted_ind  = 1  
											AND    isnull(dptdc_status,'P')='P'  
											AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
											AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
											AND    dptdc_internal_trastm = @l_TRX_TAB 
											AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
											--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
											order by dptdc_lst_upd_dt 

											SELECT @L_TOT_REC = COUNT(DPTDC_ID) FROM dp_trx_dtls_cdsl,dp_acct_mstr   
											WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
											--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
											AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
											AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
											AND    dptdc_internal_trastm = @l_TRX_TAB   
											AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
											
                                            
                        
											IF @L_TOT_REC > 0  
											BEGIN   

															/* Update in dp_trx_dtls_cdsl*/  

															SELECT @L_TRANS_TYPE = dptdc_internal_trastm FROM dp_trx_dtls_cdsl ,dp_acct_mstr  
															WHERE  isnull(dptdc_status,'P')='P' and dptdc_dpam_id = dpam_id   
															--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
															AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
															AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
															AND    dptdc_internal_trastm = @l_TRX_TAB  
															AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
															

															UPDATE D1 Set dptdc_batch_no=@pa_batch_no FROM dp_trx_dtls_cdsl D1 ,dp_acct_mstr D2  
															WHERE  dptdc_dpam_id = dpam_id   
															--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
															AND    isnull(dptdc_status,'P')='P'  
															AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
															AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
															AND    dptdc_internal_trastm = @l_TRX_TAB   
															AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
															


															/* Update in Bitmap ref mstr*/   
--															UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
--															WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND  BITRM_CHILD_CD= @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  
--
--															/* insert into batch table*/  
--
--
--
--																IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@l_TRX_TAB)  
--																	BEGIN  
--																		INSERT INTO BATCHNO_CDSL_MSTR                                       
--																		(    
--																			BATCHC_DPM_ID,  
--																			BATCHC_NO,  
--																			BATCHC_RECORDS ,  
--																			BATCHC_TRANS_TYPE,
--																			BATCHC_FILEGEN_DT,
--																			BATCHC_TYPE,  
--																			BATCHC_STATUS,  
--																			BATCHC_CREATED_BY,  
--																			BATCHC_CREATED_DT ,  
--																			BATCHC_DELETED_IND  
--																		)  
--																		VALUES  
--																		(  
--																			@L_DPM_ID,  
--																			@PA_BATCH_NO,  
--																			@L_TOT_REC,  
--																			@L_TRANS_TYPE,
--																			CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',  
--																			'T',  
--																			'P',  
--																			@PA_LOGINNAME,  
--																			GETDATE(),  
--																			1  
--																		)      
--																																																											END    
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
													+ case when isnull(dptdc_other_settlement_no,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',dptdc_other_settlement_no,A.settm_type_cdsl),'')   +isnull(dptdc_other_settlement_no,''))  else convert(char(13),'') END
                                                    + convert(char(16),DPTDC_SLIP_NO+'/'+dptdc_internal_ref_no)
                                                    + case when isnull(DPTDC_SETTLEMENT_NO,'') <> '' then convert(char(13),isnull(citrus_usr.[GetCDSLinterdpSettType_SP]('',DPTDC_SETTLEMENT_NO,B.settm_type_cdsl),'')   +isnull(DPTDC_SETTLEMENT_NO,''))  else convert(char(13),'') END 
													
														+ convert(char(1),ltrim(rtrim(case when DPTDC_PAYMODE='Cheque Payment' then '1' when DPTDC_PAYMODE='Electronic Payment' then '2' when DPTDC_PAYMODE='Cash Payment' then '3' else '' end )))
	+ convert(char(35),isnull(DPTDC_BANKACNO,''))
	+ convert(char(100),isnull(DPTDC_BANKACNAME,''))
	+ convert(char(100),isnull(DPTDC_BANKBRNAME,''))
	+ convert(char(150),isnull(DPTDC_TRANSFEREENAME,''))
	+ case when convert(char(8),isnull(replace(convert(varchar(11),DPTDC_DOI,103),'/','')  ,''))='01011900' then '' else convert(char(8),isnull(replace(convert(varchar(11),DPTDC_DOI,103),'/','')  ,'')) end --convert(char(8),isnull(replace(convert(varchar(11),DPTDC_DOI,103),'/','')  ,''))
	+ convert(char(22),isnull(DPTDC_CHQ_REFNO,''))

													DETAILS
													, abs(dptdc_qty) qty, 'N' TRXEFLG ,citrus_usr.fn_get_slip_no_export(dpam_sba_no,dptdc_slip_no) dptdc_slip_no , dptdc_created_by , case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')='' then dptdc_lst_upd_by else isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'') end dptdc_lst_upd_by , case when isnull(citrus_usr.Fn_Toget_Midchk(dptdc_slip_no,dptdc_id),'')<>'' then dptdc_lst_upd_by else '' end verifier
													,dptdc_id    as USN,''
											FROm   dp_trx_dtls_cdsl   
												left outer join  settlement_type_mstr A on convert(varchar,A.settm_id) = dptdc_other_settlement_type and dptdc_other_settlement_type <> ''
                                                LEFT OUTER JOIN  settlement_type_mstr B on convert(varchar,B.settm_id) = DPTDC_MKT_TYPE and DPTDC_MKT_TYPE <> ''
																, dp_acct_mstr  

											WHERE  dpam_id            = dptdc_dpam_id  
											AND    dpam_deleted_ind   = 1  
											AND    dptdc_deleted_ind  = 1  
											AND    isnull(dptdc_status,'P')='P'  
											AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = @PA_BATCH_NO  
											AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
											AND    dptdc_internal_trastm = @l_TRX_TAB 
											AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
											--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
											order by dptdc_lst_upd_dt 

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
										+ convert(char(5),citrus_usr.FN_FORMATSTR(CONVERT(VARCHAR(5),isnull(demrm_total_certificates,'0')),5,0,'L','0'))  --case when demrm_isin like 'INF%' then convert(char(5),citrus_usr.FN_FORMATSTR(CONVERT(VARCHAR(5),isnull(demrd_cert_no,'0')),5,0,'L','0'))   else convert(char(5),citrus_usr.FN_FORMATSTR(CONVERT(VARCHAR(5),isnull(demrm_total_certificates,'0')),5,0,'L','0')) end --
										+ convert(char(1),isnull(demrm_free_lockedin_yn,''))  
										+ convert(char(2),isnull(demrm_lockin_reason_cd,''))  
										+ convert(char(50),case when ltrim(rtrim(isnull(DEMRM_RMKS,'')))='' then space(50) else ltrim(rtrim(isnull(DEMRM_RMKS,''))) end ) 
										+ case when convert(char(8),replace(convert(varchar(11),isnull(DEMRM_LOCKIN_RELEASE_DT,space(8)),103),'/','')) = '01011900' or isnull(demrm_free_lockedin_yn,'N')='N'  then  convert(char(8),'00000000') else convert(char(8),replace(convert(varchar(11),isnull(DEMRM_LOCKIN_RELEASE_DT,space(8)),103),'/','')) end  DETAILS
										,abs(demrm_qty) qty,'','','','','','0',replace(convert(varchar(11),isnull(DEMRM_REQUEST_DT,space(8)),103),'/','') DEMRM_REQUEST_DT
										FROM demat_request_mstr  
										 left outer join dmat_dispatch on demrm_id=disp_demrm_id
										,dp_acct_mstr  --,demat_request_dtls
											WHERE demrm_dpam_id     = dpam_id   
											AND   dpam_deleted_ind  = 1  
											AND   demrm_deleted_ind = 1  
											AND    isnull(demrm_status,'P')='P' -- and demrd_demrm_id=demrm_id and demrd_deleted_ind=1
											AND    ltrim(rtrim(isnull(demrm_batch_no,''))) = ''  
											AND   demrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'       
											AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END and isnull(demrm_typeofsec,'')='EQUITY'
											--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
                                            order by demrm_lst_upd_dt 

											SELECT @L_TOT_REC = COUNT(demrm_ID) FROM demat_request_mstr left outer join dmat_dispatch on demrm_id=disp_demrm_id ,dp_acct_mstr
                                            --,demat_request_dtls
											WHERE  isnull(demrm_status,'P')='P' and demrm_dpam_id = dpam_id --and demrm_id= demrd_demrm_id    
											--AND    dpam_dpm_id      = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end and isnull(demrm_typeofsec,'')='EQUITY'
											AND    ltrim(rtrim(isnull(demrm_batch_no,''))) = ''  
											AND    demrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																		AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END


											IF @L_TOT_REC > 0  
											BEGIN   

														/* Update in Demat_request_mstr*/   
														UPDATE D1 Set demrm_batch_no=@pa_batch_no FROM demat_request_mstr D1 ,dp_acct_mstr D2  
														WHERE  demrm_dpam_id = dpam_id   
														--AND    dpam_dpm_id   = @l_dpm_id    
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
														AND    isnull(demrm_status,'P')='P'  
														AND    ltrim(rtrim(isnull(demrm_batch_no,''))) = ''  
														AND    demrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
														AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END   and isnull(demrm_typeofsec,'')='EQUITY'
														/* Update in Bitmap ref mstr*/   
--														UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
--														WHERE   BITRM_PARENT_CD = 'CDSL_BTCH_'  + @l_TRX_TAB + '_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  
--
--														/* insert into batch table*/                    
--																IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@l_TRX_TAB)  
--																	BEGIN  
--																		INSERT INTO BATCHNO_CDSL_MSTR                                       
--																		(    
--																			BATCHC_DPM_ID,  
--																			BATCHC_NO,  
--																			BATCHC_RECORDS ,  
--																			BATCHC_TRANS_TYPE,
--																			BATCHC_FILEGEN_DT,           
--																			BATCHC_TYPE,  
--																			BATCHC_STATUS,  
--																			BATCHC_CREATED_BY,  
--																			BATCHC_CREATED_DT ,  
--																			BATCHC_DELETED_IND  
--																		)  
--																		VALUES  
--																		(  
--																			@L_DPM_ID,  
--																			@PA_BATCH_NO,  
--																			@L_TOT_REC,  
--																			@l_TRX_TAB,
--																			CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'  ,
--																			'T',  
--																			'P',  
--																			@PA_LOGINNAME,  
--																			GETDATE(),  
--																			1  
--																		)      
--																	END  
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
											AND    dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END and isnull(demrm_typeofsec,'')='EQUITY'
											--AND		dpam_dpm_id   = @L_DPM_ID
												AND		dpam_dpm_id   = case when @L_DPM_ID='3' then dpam_dpm_id else @L_DPM_ID end
                                            order by demrm_lst_upd_dt 
									END   


						--  
						END  	
	end -- for all
  
  END  
  --  

  
  END  
    
--  
END

GO
