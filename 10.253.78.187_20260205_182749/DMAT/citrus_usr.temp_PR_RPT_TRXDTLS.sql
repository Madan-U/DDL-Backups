-- Object: PROCEDURE citrus_usr.temp_PR_RPT_TRXDTLS
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[temp_PR_RPT_TRXDTLS](  
@pa_exch varchar(100),   
@pa_batch_no varchar(50),  
@pa_date varchar(11),   
@pa_trans_type varchar(100)  
)    
AS    
begin    
    
 if @pa_exch = 'NSDL'    
 begin    


select  
  distinct case when DPTD_INTERNAL_TRASTM = 'DO' then 'Delivery Out'    
  when DPTD_INTERNAL_TRASTM = 'IDO' then 'Inter Delivery Out'    
  when DPTD_INTERNAL_TRASTM = 'IDD' then 'Inter Depository'    
  else 'Account Transfer' end     
  , convert(varchar,dptd_request_dt,103) request_dt,  convert(varchar,DPTD_EXECUTION_DT,103) execution_dt     
        ,'' series     
        ,DPTD_SLIP_NO slip_no     
        ,src_client.dpam_sba_no ACCOUNT_NO     
        ,src_client.dpam_sba_name CLIENT_NAME 		
		, CASE WHEN ISNULL(DPTD_COUNTER_DEMAT_ACCT_NO,'')='' THEN '-NA-' ELSE ISNULL(DPTD_COUNTER_DEMAT_ACCT_NO,'') END  COUNTER_ACCOUNT     
        , CASE WHEN ISNULL(DPTD_COUNTER_DEMAT_ACCT_NO,'')='' THEN '-NA-' ELSE ISNULL(dst_client.DPAM_SBA_NAME,'') END  ACCOUNT_NAME    
		, CASE WHEN ISNULL(DPTD_COUNTER_DP_ID,'')='' THEN '-NA-' ELSE ISNULL(DPTD_COUNTER_DP_ID,'') END   COUNTER_DP     
        , CASE WHEN ISNULL(DPTD_COUNTER_DP_ID,'')='' THEN '-NA-' ELSE ISNULL(dst_dpm.dpm_name,'') END   dp_name     
        ,DPTD_ISIN
		,isin_name 
		,abs(DPTD_QTY ) DPTD_QTY
		,isnull(DPTD_TRANS_NO,'') TRANSACTION_NO,
		DPTD_INTERNAL_REF_NO INTERNAL_REF_NO    
        ,CASE WHEN ISNULL(DPTD_MKT_TYPE,'')='' THEN '-NA-' ELSE ISNULL((SELECT SETTM_DESC FROM SETTLEMENT_TYPE_MSTR WHERE SETTM_ID =  DPTD_MKT_TYPE AND SETTM_DELETED_IND = 1),'') END   SOURCE_SETT_TYPE     
        ,CASE WHEN ISNULL(DPTD_SETTLEMENT_NO,'')='' THEN '-NA-' ELSE ISNULL(DPTD_SETTLEMENT_NO,'') END   SOURCE_SETT_NO     
        ,CASE WHEN ISNULL(DPTD_OTHER_SETTLEMENT_TYPE,'')='' THEN '-NA-' ELSE ISNULL((SELECT SETTM_DESC FROM SETTLEMENT_TYPE_MSTR WHERE SETTM_ID =  DPTD_OTHER_SETTLEMENT_TYPE AND SETTM_DELETED_IND = 1),'')  END   TRG_SETT_TYPE    
        ,CASE WHEN ISNULL(DPTD_OTHER_SETTLEMENT_NO,'')='' THEN '-NA-' ELSE ISNULL(DPTD_OTHER_SETTLEMENT_NO,'') END   TRG_SETT_NO    
        ,CASE WHEN ISNULL(DPTD_COUNTER_CMBP_ID,'')='' THEN '-NA-' ELSE ISNULL(DPTD_COUNTER_CMBP_ID,'') END   CMBPID    
    

		from dp_trx_dtls   left outer join dp_acct_mstr dst_client on dst_client.dpam_sba_no = DPTD_COUNTER_DEMAT_ACCT_NO     
          left outer join dp_mstr dst_dpm on dst_dpm.dpm_dpid = DPTD_COUNTER_DP_ID     
        ,dp_acct_mstr src_client , dp_mstr src_dpm ,  isin_mstr ,batchno_nsdl_mstr     
        where dptd_dpam_id = src_client.dpam_id     
  and   src_client.dpam_dpm_id  = src_dpm.dpm_id     
  and   dptd_isin               = isin_cd    
  and   dptd_deleted_ind        = 1    
  and   src_client.dpam_deleted_ind = 1    
  and   src_dpm.dpm_deleted_ind     = 1     
  and   dptd_batch_no = BATCHN_NO    
  and   dptd_batch_no = @pa_batch_no     
  and   convert(varchar(11),dptd_request_dt,103) = convert(varchar(11),BATCHN_FILEGEN_DT,103)    
  and   convert(varchar(11),dptd_request_dt,103)  = @pa_date    
  --and   BATCHN_TRANS_TYPE  like DPTD_INTERNAL_TRASTM + '%'    
  and   isnull(dptd_batch_no,'') <> ''    
  and   batchn_trans_type <>'ACCOUNT REGISTRATION'    
        ORDER BY DPTD_INTERNAL_REF_NO     
    
    end     
  
    else if @pa_exch = 'CDSL'    
  
    begin   
   
 select  

 
  distinct BATCHC_TRANS_TYPE    
  ,convert(varchar,dptdc_request_dt,103) request_dt,  
  convert(varchar,DPTDc_EXECUTION_DT,103) execution_dt,  
  '' series ,  
  DPTDc_SLIP_NO slip_no,  
  src_client.dpam_sba_no ACCOUNT_NO,  
  src_client.dpam_sba_name CLIENT_NAME    
  ,CASE WHEN ISNULL(DPTDc_COUNTER_DEMAT_ACCT_NO,'')='' THEN '-NA-' ELSE ISNULL(DPTDc_COUNTER_DEMAT_ACCT_NO,'') END  COUNTER_ACCOUNT     
  ,CASE WHEN ISNULL(DPTDc_COUNTER_DEMAT_ACCT_NO,'')='' THEN '-NA-' ELSE ISNULL(dst_client.DPAM_SBA_NAME,'') END  ACCOUNT_NAME    
  ,CASE WHEN ISNULL(DPTDc_COUNTER_DP_ID,'')='' THEN '-NA-' ELSE ISNULL(DPTDc_COUNTER_DP_ID,'') END   COUNTER_DP     
  ,CASE WHEN ISNULL(DPTDc_COUNTER_DP_ID,'')='' THEN '-NA-' ELSE ISNULL(dst_dpm.dpm_name,'') END   dp_name     
  ,CASE WHEN ISNULL(DPTDc_COUNTER_CMBP_ID,'')='' THEN '-NA-' ELSE ISNULL(DPTDc_COUNTER_CMBP_ID,'') END   CMBPID    
  ,DPTDc_ISIN DPTD_ISIN,  
  isin_name,  
  abs(DPTDc_QTY) DPTD_QTY,  
  isnull(DPTDc_TRANS_NO,'') TRANSACTION_NO,  
  DPTDC_INTERNAL_REF_NO INTERNAL_REF_NO    

  from   

  dp_trx_dtls_cdsl   left outer join dp_acct_mstr dst_client on dst_client.dpam_sba_no = DPTDc_COUNTER_DEMAT_ACCT_NO     
          left outer join dp_mstr dst_dpm on dst_dpm.dpm_dpid = DPTDc_COUNTER_DP_ID     
       , dp_acct_mstr src_client , dp_mstr src_dpm ,  isin_mstr ,batchno_cdsl_mstr     
             
  where dptdc_dpam_id = src_client.dpam_id     
  and   src_client.dpam_dpm_id      = src_dpm.dpm_id     
  and   dptdc_isin                  = isin_cd    
  and   dptdc_deleted_ind           = 1    
  and   src_client.dpam_deleted_ind = 1    
  and   src_dpm.dpm_deleted_ind     = 1     
  and   dst_dpm.dpm_deleted_ind     = 1    
  and   dptdc_batch_no = BATCHC_NO    
  and   dptdc_batch_no = @pa_batch_no     
  and   convert(varchar(11),dptdc_request_dt,103) = convert(varchar(11),BATCHC_FILEGEN_DT,103)    
  and   convert(varchar(11),dptdc_request_dt,103)  = @pa_date    
  --and   BATCHC_TRANS_TYPE  = case when DPTDC_INTERNAL_TRASTM in ('C2P','P2C','C2C','P2P') then 'OFFM' else DPTDC_INTERNAL_TRASTM end     
        and   BATCHC_TRANS_TYPE  = case when DPTDC_INTERNAL_TRASTM  in ('BOCM','CMCM','CMBO','BOBO') then 'OFFM' else DPTDC_INTERNAL_TRASTM end     
  and   isnull(dptdc_batch_no,'') <> ''    
  and   batchc_trans_type <>'ACCOUNT REGISTRATION'    
    end     
    
end

GO
