-- Object: PROCEDURE citrus_usr.PR_RPT_TRXDTLS_COMBINE
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

/*  

exec PR_RPT_TRXDTLS  'cdsl',600009,'28/05/2009','DMAT'
exec PR_RPT_TRXDTLS_COMBINE 'NSDL',0,'Entries Mode','jan 1 2007','jan 1 2009','','','','','','','','',''									

*/  
CREATE PROCEDURE [citrus_usr].[PR_RPT_TRXDTLS_COMBINE]
(      
	@pa_exch varchar(100),      
	@pa_trans_type  varchar(100),   
    @PA_STATUS VARCHAR(10),
    @PA_FROM_DT VARCHAR(11), 
    @PA_TO_DT VARCHAR(11),
    @PA_FROM_ACC_NO VARCHAR(20),
    @PA_FROM_TO_NO  VARCHAR(20),
    @PA_ISIN        VARCHAR(20),
    @PA_SLIP_NO     VARCHAR(20),
    @PA_TR_ACC_NO   VARCHAR(20),
    @PA_SETTM_NO    VARCHAR(20),
    @PA_SETTM_TYPE  VARCHAR(20),
    @PA_MAKER_ID    VARCHAR(20),
    @PA_CHECKER_ID    VARCHAR(20)
  
)        
AS        
begin  

 IF   @PA_FROM_ACC_NO = '' SET     @PA_FROM_ACC_NO = '0'
 IF   @PA_FROM_TO_NO = '' SET     @PA_FROM_TO_NO = '9999999999999999'
 IF @PA_FROM_DT = '' SET @PA_FROM_DT = 'JAN 01 1900'
IF @PA_TO_DT = '' SET @PA_TO_DT = 'JAN 01 2100'
 if @pa_exch = 'NSDL'    
 begin        
  select distinct case when DPTD_INTERNAL_TRASTM = 'DO' then 'Delivery Out'        
  when DPTD_INTERNAL_TRASTM = 'IDO' then 'Inter Delivery Out'        
  when DPTD_INTERNAL_TRASTM = 'IDD' then 'Inter Depository'        
  else 'Account Transfer' end  TRANSTYPE       
  , convert(varchar,dptd_request_dt,103) request_dt,  convert(varchar,DPTD_EXECUTION_DT,103) execution_dt         
  , '' series         
  ,DPTD_SLIP_NO slip_no         
  ,src_client.dpam_sba_no ACCOUNT_NO         
  , src_client.dpam_sba_name CLIENT_NAME         
  , CASE WHEN ISNULL(DPTD_COUNTER_DEMAT_ACCT_NO,'')='' THEN '-NA-' ELSE ISNULL(DPTD_COUNTER_DEMAT_ACCT_NO,'') END  COUNTER_ACCOUNT         
  , CASE WHEN ISNULL(DPTD_COUNTER_DEMAT_ACCT_NO,'')='' THEN '-NA-' ELSE ISNULL(dst_client.DPAM_SBA_NAME,'') END  ACCOUNT_NAME        
  , CASE WHEN ISNULL(DPTD_COUNTER_DP_ID,'')='' THEN '-NA-' ELSE ISNULL(DPTD_COUNTER_DP_ID,'') END   COUNTER_DP         
  , CASE WHEN ISNULL(DPTD_COUNTER_DP_ID,'')='' THEN '-NA-' ELSE ISNULL(dst_dpm.dpm_name,'') END   dp_name         
  ,DPTD_ISIN , isin_name , abs(DPTD_QTY ) DPTD_QTY, isnull(DPTD_TRANS_NO,'') TRANSACTION_NO,DPTD_INTERNAL_REF_NO INTERNAL_REF_NO        
, CASE WHEN ISNULL(DPTD_MKT_TYPE,'')='' THEN '-NA-' ELSE ISNULL((SELECT SETTM_DESC FROM SETTLEMENT_TYPE_MSTR WHERE SETTM_ID =  DPTD_MKT_TYPE AND SETTM_DELETED_IND = 1),'') END   SOURCE_SETT_TYPE         
, CASE WHEN ISNULL(DPTD_SETTLEMENT_NO,'')='' THEN '-NA-' ELSE ISNULL(DPTD_SETTLEMENT_NO,'') END   SOURCE_SETT_NO         
, CASE WHEN ISNULL(DPTD_OTHER_SETTLEMENT_TYPE,'')='' THEN '-NA-' ELSE ISNULL((SELECT SETTM_DESC FROM SETTLEMENT_TYPE_MSTR WHERE SETTM_ID =  DPTD_OTHER_SETTLEMENT_TYPE AND SETTM_DELETED_IND = 1),'')  END   TRG_SETT_TYPE        
  , CASE WHEN ISNULL(DPTD_OTHER_SETTLEMENT_NO,'')='' THEN '-NA-' ELSE ISNULL(DPTD_OTHER_SETTLEMENT_NO,'') END   TRG_SETT_NO        
  , CASE WHEN ISNULL(DPTD_COUNTER_CMBP_ID,'')='' THEN '-NA-' ELSE ISNULL(DPTD_COUNTER_CMBP_ID,'') END   CMBPID        
  , CREATED_DT , CREATED_BY , LST_UPD_DT , LST_UPD_BY
  from dp_trx_dtls    left outer join dp_acct_mstr dst_client on dst_client.dpam_sba_no = DPTD_COUNTER_DEMAT_ACCT_NO         
      left outer join dp_mstr dst_dpm on dst_dpm.dpm_dpid = DPTD_COUNTER_DP_ID         
        ,dp_acct_mstr src_client , dp_mstr src_dpm ,  isin_mstr ,batchno_nsdl_mstr         
        ,(SELECT DPTD_CREATED_DT CREATED_DT, DPTD_CREATED_BY CREATED_BY,DPTD_LST_UPD_DT LST_UPD_DT, DPTD_LST_UPD_BY LST_UPD_BY FROM DPTD_MAK DPTDM WHERE DPTD_SLIP_NO  = DPTDM.DPTD_SLIP_NO AND DPTDM.DPTD_DELETED_IND =  1) A 
        where dptd_dpam_id = src_client.dpam_id         

  and   src_client.dpam_dpm_id  = src_dpm.dpm_id         
  and   dptd_isin               = isin_cd        
  AND   DPTD_STATUS LIKE '%' + @PA_STATUS
  AND   DPTD_ISIN LIKE '%' + @PA_ISIN
  AND   DPTD_MKT_TYPE LIKE '%' + @PA_SETTM_TYPE
  AND   DPTD_SETTLEMENT_NO LIKE '%' + @PA_SETTM_NO
  AND   CREATED_BY LIKE '%' + @PA_MAKER_ID
  AND   LST_UPD_BY LIKE '%' + @PA_CHECKER_ID
  AND   DPTD_COUNTER_DEMAT_ACCT_NO LIKE '%' + @PA_TR_ACC_NO
  AND   DPTD_SLIP_NO LIKE '%' + @PA_SLIP_NO
  AND   src_client.DPAM_SBA_NO BETWEEN @PA_FROM_ACC_NO AND @PA_FROM_TO_NO
  AND   DPTD_REQUEST_DT BETWEEN @PA_FROM_DT AND @PA_TO_DT
  and   dptd_deleted_ind        = 1        
  and   src_client.dpam_deleted_ind = 1        
  and   src_dpm.dpm_deleted_ind     = 1         
  and   dptd_batch_no = BATCHN_NO        

  and   convert(varchar(11),dptd_request_dt,103) = convert(varchar(11),BATCHN_FILEGEN_DT,103)        
  --and   BATCHN_TRANS_TYPE  like DPTD_INTERNAL_TRASTM + '%'        
  and   isnull(dptd_batch_no,'') <> ''        
  and   batchn_trans_type <>'ACCOUNT REGISTRATION'        

 union
  
  select       
  distinct 'DEMAT', convert(varchar,demrm_request_dt,103) request_dt,  isnull(convert(varchar,demrm_EXECUTION_DT,103),'') execution_dt         
        , '' series         
        ,DEMRM_SLIP_SERIAL_NO slip_no         
        ,src_client.dpam_sba_no ACCOUNT_NO         
        , src_client.dpam_sba_name CLIENT_NAME         
  , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END  COUNTER_ACCOUNT         
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END  ACCOUNT_NAME        
  , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   COUNTER_DP         
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   dp_name         
        ,demrm_ISIN , isin_name , abs(demrm_QTY ) DPTD_QTY, isnull(demrm_drf_no,'') TRANSACTION_NO,demrm_id INTERNAL_REF_NO        
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE '' END   SOURCE_SETT_TYPE         
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   SOURCE_SETT_NO         
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ''  END   TRG_SETT_TYPE        
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   TRG_SETT_NO        
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   CMBPID         
, CREATED_DT , CREATED_BY , LST_UPD_DT , LST_UPD_BY
  from demat_request_mstr    
  , dp_acct_mstr src_client , dp_mstr src_dpm ,  isin_mstr ,batchno_nsdl_mstr         
  ,(SELECT DEMRM_CREATED_DT CREATED_DT,DEMRM_CREATED_BY CREATED_BY,DEMRM_LST_UPD_DT LST_UPD_DT, DEMRM_LST_UPD_BY LST_UPD_BY FROM DEMRM_MAK DPTDM WHERE DEMRM_SLIP_SERIAL_NO  = DPTDM.DEMRM_SLIP_SERIAL_NO AND DPTDM.DEMRM_DELETED_IND =  1) A 
  where demrm_dpam_id = src_client.dpam_id         
  and   src_client.dpam_dpm_id      = src_dpm.dpm_id         
  and   demrm_isin                  = isin_cd 
  AND   DEMRM_STATUS LIKE '%' + @PA_STATUS
  AND   DEMRM_ISIN LIKE '%' + @PA_ISIN
  AND   CREATED_BY LIKE '%' + @PA_MAKER_ID
  AND   LST_UPD_BY LIKE '%' + @PA_CHECKER_ID
  AND   DEMRM_SLIP_SERIAL_NO LIKE '%' +@PA_SLIP_NO   
  AND   DPAM_SBA_NO BETWEEN @PA_FROM_ACC_NO AND @PA_FROM_TO_NO
  AND   DEMRM_REQUEST_DT BETWEEN @PA_FROM_DT AND @PA_TO_DT    
  and   demrm_deleted_ind           = 1        
  and   src_client.dpam_deleted_ind = 1        
  and   src_dpm.dpm_deleted_ind     = 1         
  and   demrm_batch_no = BATCHN_NO        

  --and   convert(varchar(11),demrm_request_dt,103) = convert(varchar(11),BATCHN_FILEGEN_DT,103)        
  --and   convert(varchar(11),demrm_request_dt,103)  = @pa_date        
  --and   BATCHC_TRANS_TYPE  = case when DPTDC_INTERNAL_TRASTM in ('C2P','P2C','C2C','P2P') then 'OFFM' else DPTDC_INTERNAL_TRASTM end         
  and   BATCHN_TRANS_TYPE  = 'DMT'        
  and   isnull(demrm_batch_no,'') <> ''        
  and   batchN_trans_type <>'ACCOUNT REGISTRATION'   
union  
  select       
  'REMAT'         
  , convert(varchar,remrm_request_dt,103) request_dt, isnull( convert(varchar,remrm_EXECUTION_DT,103),'') execution_dt         
        , '' series         
        ,rEMRM_SLIP_SERIAL_NO slip_no         
        ,src_client.dpam_sba_no ACCOUNT_NO         
        , src_client.dpam_sba_name CLIENT_NAME         
  , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END  COUNTER_ACCOUNT         
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END  ACCOUNT_NAME        
  , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   COUNTER_DP         
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   dp_name         
        ,remrm_ISIN , isin_name , abs(remrm_QTY ) DPTD_QTY, isnull(remrm_rrf_no,'') TRANSACTION_NO,remrm_id INTERNAL_REF_NO        
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE '' END   SOURCE_SETT_TYPE         
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   SOURCE_SETT_NO         
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ''  END   TRG_SETT_TYPE        
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   TRG_SETT_NO        
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   CMBPID    
, CREATED_DT , CREATED_BY , LST_UPD_DT , LST_UPD_BY
  from remat_request_mstr    
  , dp_acct_mstr src_client , dp_mstr src_dpm ,  isin_mstr ,batchno_nsdl_mstr         
,(SELECT REMRM_CREATED_DT CREATED_DT,REMRM_CREATED_BY CREATED_BY,REMRM_LST_UPD_DT LST_UPD_DT, REMRM_LST_UPD_BY LST_UPD_BY FROM REMRM_MAK DPTDM WHERE REMRM_SLIP_SERIAL_NO  = DPTDM.REMRM_SLIP_SERIAL_NO AND DPTDM.REMRM_DELETED_IND =  1) A 
 
  where remrm_dpam_id = src_client.dpam_id         
  and   src_client.dpam_dpm_id      = src_dpm.dpm_id         
  and   remrm_isin                  = isin_cd 
 AND   REMRM_STATUS LIKE '%' + @PA_STATUS
  AND   REMRM_ISIN LIKE '%' + @PA_ISIN
  AND   CREATED_BY LIKE '%' + @PA_MAKER_ID
  AND   LST_UPD_BY LIKE '%' + @PA_CHECKER_ID
  AND   REMRM_SLIP_SERIAL_NO LIKE '%' + @PA_SLIP_NO 
  AND   DPAM_SBA_NO BETWEEN @PA_FROM_ACC_NO AND @PA_FROM_TO_NO
  AND   REMRM_REQUEST_DT BETWEEN @PA_FROM_DT AND @PA_TO_DT               
  and   remrm_deleted_ind           = 1        
  and   src_client.dpam_deleted_ind = 1        
  and   src_dpm.dpm_deleted_ind     = 1         
  and   remrm_batch_no = BATCHN_NO        

  and   convert(varchar(11),remrm_request_dt,103) = convert(varchar(11),BATCHN_FILEGEN_DT,103)        

  --and   BATCHC_TRANS_TYPE  = case when DPTDC_INTERNAL_TRASTM in ('C2P','P2C','C2C','P2P') then 'OFFM' else DPTDC_INTERNAL_TRASTM end         
  and   BATCHN_TRANS_TYPE  = 'RMT'        
  and   isnull(remrm_batch_no,'') <> ''        
  and   batchN_trans_type <>'ACCOUNT REGISTRATION'   
        ORDER BY DPTD_INTERNAL_REF_NO         
        
    end 

      
    else if @pa_exch = 'CDSL'    
      
   

 begin
	--declare @DEMRM_FREE_LOCKEDIN_YN char(1)
     
  select distinct BATCHC_TRANS_TYPE ,'' as DEMRM_FREE_LOCKEDIN_YN
--  CASE '' as  DEMRM_FREE_LOCKEDIN_YN when ='Y' THEN 'LOCK' when='N' 'FREE'
  ,'0' as DEMRM_TOTAL_CERTIFICATES 
  ,convert(varchar,dptdc_request_dt,103) request_dt,      
  isnull(convert(varchar,DPTDc_EXECUTION_DT,103),'') execution_dt,      
  '' series ,      
  DPTDc_SLIP_NO slip_no,      
  src_client.dpam_sba_no ACCOUNT_NO,      
  src_client.dpam_sba_name CLIENT_NAME        
  ,CASE WHEN ISNULL(DPTDc_COUNTER_DEMAT_ACCT_NO,'')='' THEN '-NA-' ELSE ISNULL(DPTDc_COUNTER_DEMAT_ACCT_NO,'') END  COUNTER_ACCOUNT         
        ,CASE WHEN ISNULL(DPTDc_COUNTER_DEMAT_ACCT_NO,'')='' THEN '-NA-' ELSE ISNULL(dst_client.DPAM_SBA_NAME,'') END  ACCOUNT_NAME        
  ,CASE WHEN ISNULL(DPTDc_COUNTER_DP_ID,'')='' THEN '-NA-' ELSE ISNULL(DPTDc_COUNTER_DP_ID,'') END   COUNTER_DP         
        ,CASE WHEN ISNULL(DPTDc_COUNTER_DP_ID,'')='' THEN '-NA-' ELSE ISNULL(dst_dpm.dpm_name,'') END   dp_name         
, CASE WHEN ISNULL(DPTDC_COUNTER_CMBP_ID,'')='' THEN '-NA-' ELSE ISNULL(DPTDC_COUNTER_CMBP_ID,'') END   CMBPID            
,DPTDc_ISIN DPTD_ISIN,      
  isin_name,               
  abs(DPTDc_QTY) DPTD_QTY,      
  isnull(DPTDc_TRANS_NO,'') TRANSACTION_NO,      
  DPTDC_INTERNAL_REF_NO INTERNAL_REF_NO  
, CASE WHEN ISNULL(DPTDc_MKT_TYPE,'')='' THEN '-NA-' ELSE ISNULL((SELECT SETTM_DESC FROM SETTLEMENT_TYPE_MSTR WHERE SETTM_ID =  DPTDc_MKT_TYPE AND SETTM_DELETED_IND = 1),'') END   SOURCE_SETT_TYPE         
, CASE WHEN ISNULL(DPTDc_SETTLEMENT_NO,'')='' THEN '-NA-' ELSE ISNULL(DPTDc_SETTLEMENT_NO,'') END   SOURCE_SETT_NO         
, CASE WHEN ISNULL(DPTDc_OTHER_SETTLEMENT_TYPE,'')='' THEN '-NA-' ELSE ISNULL((SELECT SETTM_DESC FROM SETTLEMENT_TYPE_MSTR WHERE SETTM_ID =  DPTDc_OTHER_SETTLEMENT_TYPE AND SETTM_DELETED_IND = 1),'')  END   TRG_SETT_TYPE        
  , CASE WHEN ISNULL(DPTDc_OTHER_SETTLEMENT_NO,'')='' THEN '-NA-' ELSE ISNULL(DPTDc_OTHER_SETTLEMENT_NO,'') END   TRG_SETT_NO        
      , CREATED_DT , CREATED_BY , LST_UPD_DT , LST_UPD_BY
  from       
  dp_trx_dtls_cdsl   left outer join dp_acct_mstr dst_client on dst_client.dpam_sba_no = DPTDc_COUNTER_DEMAT_ACCT_NO         
          left outer join dp_mstr dst_dpm on dst_dpm.dpm_dpid = DPTDc_COUNTER_DP_ID         
       , dp_acct_mstr src_client , dp_mstr src_dpm ,  isin_mstr ,batchno_cdsl_mstr         
 ,(SELECT DPTDC_CREATED_DT CREATED_DT, DPTDC_CREATED_BY CREATED_BY,DPTDC_LST_UPD_DT LST_UPD_DT, DPTDC_LST_UPD_BY LST_UPD_BY FROM DPTDC_MAK DPTDM WHERE DPTDC_SLIP_NO  = DPTDM.DPTDC_SLIP_NO AND DPTDM.DPTDC_DELETED_IND =  1) A       
  where dptdc_dpam_id = src_client.dpam_id         
  and   src_client.dpam_dpm_id      = src_dpm.dpm_id         
  and   dptdc_isin                  = isin_cd 
 AND   DPTDC_STATUS LIKE '%' + @PA_STATUS
  AND   DPTDC_ISIN LIKE '%' + @PA_ISIN
  AND   DPTDC_MKT_TYPE LIKE '%' + @PA_SETTM_TYPE
  AND   DPTDC_SETTLEMENT_NO LIKE '%' + @PA_SETTM_NO
  AND   CREATED_BY LIKE '%' + @PA_MAKER_ID
  AND   LST_UPD_BY LIKE '%' + @PA_CHECKER_ID
  AND   DPTDC_COUNTER_DEMAT_ACCT_NO LIKE '%' + @PA_TR_ACC_NO
  AND   DPTDC_SLIP_NO LIKE '%' + @PA_SLIP_NO   
  AND   src_client.DPAM_SBA_NO BETWEEN @PA_FROM_ACC_NO AND @PA_FROM_TO_NO
  AND   DPTDC_REQUEST_DT BETWEEN @PA_FROM_DT AND @PA_TO_DT        
  and   dptdc_deleted_ind           = 1        
  and   src_client.dpam_deleted_ind = 1        
  and   src_dpm.dpm_deleted_ind     = 1         
  and   dptdc_batch_no = BATCHC_NO        

  and   convert(varchar(11),dptdc_request_dt,103) = convert(varchar(11),BATCHC_FILEGEN_DT,103)        

  --and   BATCHC_TRANS_TYPE  = case when DPTDC_INTERNAL_TRASTM in ('C2P','P2C','C2C','P2P') then 'OFFM' else DPTDC_INTERNAL_TRASTM end         
  and   BATCHC_TRANS_TYPE  = case when DPTDC_INTERNAL_TRASTM  in ('BOCM','CMCM','CMBO','BOBO') then 'OFFM' else DPTDC_INTERNAL_TRASTM end         
  and   BATCHC_TRANS_TYPE  = @pa_trans_type
  and   isnull(dptdc_batch_no,'') <> ''        
  and   batchc_trans_type <>'ACCOUNT REGISTRATION'        
  
union 
   
  select distinct BATCHC_TRANS_TYPE ,case when DEMRM_FREE_LOCKEDIN_YN='Y' THEN 'LOCK' ELSE 'FREE' END,DEMRM_TOTAL_CERTIFICATES
  ,convert(varchar,demrm_request_dt,103) request_dt, isnull(convert(varchar,demrm_EXECUTION_DT,103),'') execution_dt,'' series ,      
  DEMRM_SLIP_SERIAL_NO slip_no,      
  src_client.dpam_sba_no ACCOUNT_NO,      
  src_client.dpam_sba_name CLIENT_NAME        
  ,CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END  COUNTER_ACCOUNT         
        ,CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END  ACCOUNT_NAME        
  ,CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   COUNTER_DP         
        ,CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   dp_name         
, CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   CMBPID            
,demrm_ISIN DPTD_ISIN,      
  isin_name,      
  abs(demrm_QTY) DPTD_QTY,      
  isnull(DEMRM_DRF_NO,'') TRANSACTION_NO,      
  demrm_id INTERNAL_REF_NO 
    , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE '' END   SOURCE_SETT_TYPE         
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   SOURCE_SETT_NO         
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ''  END   TRG_SETT_TYPE        
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   TRG_SETT_NO               
     , CREATED_DT , CREATED_BY , LST_UPD_DT , LST_UPD_BY
  from demat_request_mstr    
  , dp_acct_mstr src_client , dp_mstr src_dpm ,  isin_mstr ,batchno_cdsl_mstr         
,(SELECT DEMRM_CREATED_DT CREATED_DT,DEMRM_CREATED_BY CREATED_BY,DEMRM_LST_UPD_DT LST_UPD_DT, DEMRM_LST_UPD_BY LST_UPD_BY FROM DEMRM_MAK DPTDM WHERE DEMRM_SLIP_SERIAL_NO  = DPTDM.DEMRM_SLIP_SERIAL_NO AND DPTDM.DEMRM_DELETED_IND =  1) A 

  where demrm_dpam_id = src_client.dpam_id         
  and   src_client.dpam_dpm_id      = src_dpm.dpm_id         
  and   demrm_isin                  = isin_cd
 and   demrm_isin                  = isin_cd 
  AND   DEMRM_STATUS LIKE '%' + @PA_STATUS
  AND   DEMRM_ISIN LIKE '%' + @PA_ISIN
  AND   CREATED_BY LIKE '%' + @PA_MAKER_ID
  AND   LST_UPD_BY LIKE '%' + @PA_CHECKER_ID
  AND   DEMRM_SLIP_SERIAL_NO LIKE '%' +@PA_SLIP_NO
 AND   DPAM_SBA_NO BETWEEN @PA_FROM_ACC_NO AND @PA_FROM_TO_NO
  AND   DEMRM_REQUEST_DT BETWEEN @PA_FROM_DT AND @PA_TO_DT                  
  and   demrm_deleted_ind           = 1        
  and   src_client.dpam_deleted_ind = 1        
  and   src_dpm.dpm_deleted_ind     = 1         
  and   demrm_batch_no = BATCHC_NO        

  and   convert(varchar(11),demrm_request_dt,103) = convert(varchar(11),BATCHC_FILEGEN_DT,103)        

  --and   BATCHC_TRANS_TYPE  = case when DPTDC_INTERNAL_TRASTM in ('C2P','P2C','C2C','P2P') then 'OFFM' else DPTDC_INTERNAL_TRASTM end         
  and   BATCHC_TRANS_TYPE  = 'DMT'        
  and   isnull(demrm_batch_no,'') <> ''        
  and   batchc_trans_type <>'ACCOUNT REGISTRATION'   

union  
 
  select       
  distinct BATCHC_TRANS_TYPE,'' as DEMRM_FREE_LOCKEDIN_YN,'' as DEMRM_TOTAL_CERTIFICATES
  ,convert(varchar,remrm_request_dt,103) request_dt,      
isnull(convert(varchar,remrm_EXECUTION_DT,103),'') execution_dt,         
  '' series ,      
  rEMRM_SLIP_SERIAL_NO slip_no,      
  src_client.dpam_sba_no ACCOUNT_NO,      
  src_client.dpam_sba_name CLIENT_NAME        
  ,CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END  COUNTER_ACCOUNT         
        ,CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END  ACCOUNT_NAME        
  ,CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   COUNTER_DP         
        ,CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   dp_name         
, CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   CMBPID            
,remrm_ISIN DPTD_ISIN,      
  isin_name,               
  abs(remrm_QTY) DPTD_QTY,      
  isnull(rEMRM_rRF_NO,'') TRANSACTION_NO,      
  remrm_id INTERNAL_REF_NO   
    , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE '' END   SOURCE_SETT_TYPE         
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   SOURCE_SETT_NO         
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ''  END   TRG_SETT_TYPE        
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   TRG_SETT_NO             
     , CREATED_DT , CREATED_BY , LST_UPD_DT , LST_UPD_BY
  from remat_request_mstr    
  , dp_acct_mstr src_client , dp_mstr src_dpm ,  isin_mstr ,batchno_cdsl_mstr         
,(SELECT REMRM_CREATED_DT CREATED_DT,REMRM_CREATED_BY CREATED_BY,REMRM_LST_UPD_DT LST_UPD_DT, REMRM_LST_UPD_BY LST_UPD_BY FROM REMRM_MAK DPTDM WHERE REMRM_SLIP_SERIAL_NO  = DPTDM.REMRM_SLIP_SERIAL_NO AND DPTDM.REMRM_DELETED_IND =  1) A 

  where remrm_dpam_id = src_client.dpam_id         
  and   src_client.dpam_dpm_id      = src_dpm.dpm_id         
  and   remrm_isin                  = isin_cd 
AND   REMRM_STATUS LIKE '%' + @PA_STATUS
  AND   REMRM_ISIN LIKE '%' + @PA_ISIN
  AND   CREATED_BY LIKE '%' + @PA_MAKER_ID
  AND   LST_UPD_BY LIKE '%' + @PA_CHECKER_ID
  AND   REMRM_SLIP_SERIAL_NO LIKE '%' + @PA_SLIP_NO
 AND   DPAM_SBA_NO BETWEEN @PA_FROM_ACC_NO AND @PA_FROM_TO_NO
  AND   REMRM_REQUEST_DT BETWEEN @PA_FROM_DT AND @PA_TO_DT               
  and   remrm_deleted_ind           = 1        
  and   src_client.dpam_deleted_ind = 1        
  and   src_dpm.dpm_deleted_ind     = 1         
  and   remrm_batch_no = BATCHC_NO        

  and   convert(varchar(11),remrm_request_dt,103) = convert(varchar(11),BATCHC_FILEGEN_DT,103)        

  --and   BATCHC_TRANS_TYPE  = case when DPTDC_INTERNAL_TRASTM in ('C2P','P2C','C2C','P2P') then 'OFFM' else DPTDC_INTERNAL_TRASTM end         
  and   BATCHC_TRANS_TYPE  = 'RMT'        
  and   isnull(remrm_batch_no,'') <> ''        
  and   batchc_trans_type <>'ACCOUNT REGISTRATION'   
     
  end 

  else if @pa_exch = 'CDSL' and  @pa_trans_type = 'BROKPOATRX'
  begin
	   select distinct case when DPTDC_INTERNAL_TRASTM  in ('BOCM','CMCM','CMBO','BOBO') then 'OFFM' else DPTDC_INTERNAL_TRASTM end   ,'' as DEMRM_FREE_LOCKEDIN_YN
	  ,'0' as DEMRM_TOTAL_CERTIFICATES 
	  ,convert(varchar,dptdc_request_dt,103) request_dt,      
	  isnull(convert(varchar,DPTDc_EXECUTION_DT,103),'') execution_dt,      
	  '' series ,      
	  DPTDc_SLIP_NO slip_no,      
	  src_client.dpam_sba_no ACCOUNT_NO,      
	  src_client.dpam_sba_name CLIENT_NAME        
	  ,CASE WHEN ISNULL(DPTDc_COUNTER_DEMAT_ACCT_NO,'')='' THEN '-NA-' ELSE ISNULL(DPTDc_COUNTER_DEMAT_ACCT_NO,'') END  COUNTER_ACCOUNT         
	  ,CASE WHEN ISNULL(DPTDc_COUNTER_DEMAT_ACCT_NO,'')='' THEN '-NA-' ELSE ISNULL(dst_client.DPAM_SBA_NAME,'') END  ACCOUNT_NAME        
	  ,CASE WHEN ISNULL(DPTDc_COUNTER_DP_ID,'')='' THEN '-NA-' ELSE ISNULL(DPTDc_COUNTER_DP_ID,'') END   COUNTER_DP         
	  ,CASE WHEN ISNULL(DPTDc_COUNTER_DP_ID,'')='' THEN '-NA-' ELSE ISNULL(dst_dpm.dpm_name,'') END   dp_name         
	  ,CASE WHEN ISNULL(DPTDC_COUNTER_CMBP_ID,'')='' THEN '-NA-' ELSE ISNULL(DPTDC_COUNTER_CMBP_ID,'') END   CMBPID            
	  ,DPTDc_ISIN DPTD_ISIN,      
	  isin_name,               
	  abs(DPTDc_QTY) DPTD_QTY,      
	  isnull(DPTDc_TRANS_NO,'') TRANSACTION_NO,      
	  DPTDC_INTERNAL_REF_NO INTERNAL_REF_NO   
, CASE WHEN ISNULL(DPTDc_MKT_TYPE,'')='' THEN '-NA-' ELSE ISNULL((SELECT SETTM_DESC FROM SETTLEMENT_TYPE_MSTR WHERE SETTM_ID =  DPTDc_MKT_TYPE AND SETTM_DELETED_IND = 1),'') END   SOURCE_SETT_TYPE         
, CASE WHEN ISNULL(DPTDc_SETTLEMENT_NO,'')='' THEN '-NA-' ELSE ISNULL(DPTDc_SETTLEMENT_NO,'') END   SOURCE_SETT_NO         
, CASE WHEN ISNULL(DPTDc_OTHER_SETTLEMENT_TYPE,'')='' THEN '-NA-' ELSE ISNULL((SELECT SETTM_DESC FROM SETTLEMENT_TYPE_MSTR WHERE SETTM_ID =  DPTDc_OTHER_SETTLEMENT_TYPE AND SETTM_DELETED_IND = 1),'')  END   TRG_SETT_TYPE        
  , CASE WHEN ISNULL(DPTDc_OTHER_SETTLEMENT_NO,'')='' THEN '-NA-' ELSE ISNULL(DPTDc_OTHER_SETTLEMENT_NO,'') END   TRG_SETT_NO        
     
	  from       
	  dp_trx_dtls_cdsl   left outer join dp_acct_mstr dst_client on dst_client.dpam_sba_no = DPTDc_COUNTER_DEMAT_ACCT_NO         
			             left outer join dp_mstr dst_dpm on dst_dpm.dpm_dpid = DPTDc_COUNTER_DP_ID         
     ,dp_acct_mstr src_client 
     ,dp_mstr src_dpm 
     ,isin_mstr 
     --,batchno_cdsl_mstr         
	  where dptdc_dpam_id               = src_client.dpam_id         
	  and   src_client.dpam_dpm_id      = src_dpm.dpm_id         
	  and   dptdc_isin                  = isin_cd        
	  and   dptdc_deleted_ind           = 1        
	  and   src_client.dpam_deleted_ind = 1        
	  and   src_dpm.dpm_deleted_ind     = 1         
	  -- and   dptdc_batch_no = BATCHC_NO        
	  --and   dptdc_batch_no = @pa_batch_no         
	  --and   convert(varchar(11),dptdc_request_dt,103) = convert(varchar(11),BATCHC_FILEGEN_DT,103)        

	  --and   BATCHC_TRANS_TYPE  = case when DPTDC_INTERNAL_TRASTM in ('C2P','P2C','C2C','P2P') then 'OFFM' else DPTDC_INTERNAL_TRASTM end         
	  ----and   BATCHC_TRANS_TYPE  = case when DPTDC_INTERNAL_TRASTM  in ('BOCM','CMCM','CMBO','BOBO') then 'OFFM' else DPTDC_INTERNAL_TRASTM end         
	  and   isnull(dptdc_batch_no,'') <> '' 
      and   isnull(DPTDC_BROKERBATCH_NO,'') <> ''
      and   not exists(select SLIIM_DPAM_ACCT_NO ,SLIIM_SLIP_NO_FR,SLIIM_SLIP_NO_TO from slip_issue_mstr 
                       where SLIIM_DPAM_ACCT_NO = src_client.dpam_sba_no 
                       and isnumeric(replace(dptdc_slip_no , isnull(SLIIM_SERIES_TYPE,''),'')) = 1   
                       and replace(dptdc_slip_no , isnull(SLIIM_SERIES_TYPE,''),'') between   SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_TO     
                       and sliim_deleted_ind = 1 
                       and src_client.dpam_deleted_ind = 1 )
                  
	  --and   batchc_trans_type <>'ACCOUNT REGISTRATION' 
  end 
         
        
end

GO
