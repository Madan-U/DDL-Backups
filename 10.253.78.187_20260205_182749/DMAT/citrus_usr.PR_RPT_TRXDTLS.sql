-- Object: PROCEDURE citrus_usr.PR_RPT_TRXDTLS
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------









/*  

exec PR_RPT_TRXDTLS  'CDSL','1','25/11/2008','ID' 
exec PR_RPT_TRXDTLS  'NSDL',600009,'28/05/2009','id'
exec PR_RPT_TRXDTLS  'NSDL',600009,'28/05/2009','DMAT'
exec PR_RPT_TRXDTLS  'cdsl',7002,'03/02/2010','np'

*/
  
CREATE PROCEDURE [citrus_usr].[PR_RPT_TRXDTLS]
(      
	@pa_exch varchar(100),       
	@pa_batch_no varchar(50),      
	@pa_date varchar(11),       
	@pa_trans_type varchar(100)   
)        
AS        
begin        
 if @pa_exch = 'NSDL'    
 begin        
  select distinct case when DPTD_INTERNAL_TRASTM = 'DO' then 'Delivery Out'        
  when DPTD_INTERNAL_TRASTM = 'IDO' then 'Inter Delivery Out'        
  when DPTD_INTERNAL_TRASTM = 'IDD' then 'Inter Depository'        
  else 'Account Transfer' end         
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
  , DPTD_CREATED_BY  MAKER_ID    
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
		, DEMRM_CREATED_BY  MAKER_ID       
  from demat_request_mstr    
  , dp_acct_mstr src_client , dp_mstr src_dpm ,  isin_mstr ,batchno_nsdl_mstr         
  where demrm_dpam_id = src_client.dpam_id         
  and   src_client.dpam_dpm_id      = src_dpm.dpm_id         
  and   demrm_isin                  = isin_cd        
  and   demrm_deleted_ind           = 1        
  and   src_client.dpam_deleted_ind = 1        
  and   src_dpm.dpm_deleted_ind     = 1         
  and   demrm_batch_no = BATCHN_NO        
  and   demrm_batch_no = @pa_batch_no         
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
		, REMRM_CREATED_BY  MAKER_ID     
  from remat_request_mstr    
  , dp_acct_mstr src_client , dp_mstr src_dpm ,  isin_mstr ,batchno_nsdl_mstr         
  where remrm_dpam_id = src_client.dpam_id         
  and   src_client.dpam_dpm_id      = src_dpm.dpm_id         
  and   remrm_isin                  = isin_cd        
  and   remrm_deleted_ind           = 1        
  and   src_client.dpam_deleted_ind = 1        
  and   src_dpm.dpm_deleted_ind     = 1         
  and   remrm_batch_no = BATCHN_NO        
  and   remrm_batch_no = @pa_batch_no         
  and   convert(varchar(11),remrm_request_dt,103) = convert(varchar(11),BATCHN_FILEGEN_DT,103)        
  and   convert(varchar(11),remrm_request_dt,103)  = @pa_date        
  --and   BATCHC_TRANS_TYPE  = case when DPTDC_INTERNAL_TRASTM in ('C2P','P2C','C2C','P2P') then 'OFFM' else DPTDC_INTERNAL_TRASTM end         
  and   BATCHN_TRANS_TYPE  = 'RMT'        
  and   isnull(remrm_batch_no,'') <> ''        
  and   batchN_trans_type <>'ACCOUNT REGISTRATION'   
        --ORDER BY DPTD_INTERNAL_REF_NO    


union  
  select       
  'PLEDGE'         
  , convert(varchar,PLDT_REQUEST_DT,103) request_dt, isnull( convert(varchar,PLDT_EXEC_DT,103),'') execution_dt         
        , '' series         
        ,PLDT_SLIP_NO slip_no         
        ,src_client.dpam_sba_no ACCOUNT_NO         
        , src_client.dpam_sba_name CLIENT_NAME         
  , CASE WHEN ISNULL(PLDT_PLEDGEE_DEMAT_ACCT_NO,'')='' THEN '-NA-' ELSE ISNULL(PLDT_PLEDGEE_DEMAT_ACCT_NO,'') END  COUNTER_ACCOUNT         
        , CASE WHEN ISNULL(PLDT_PLEDGEE_DEMAT_ACCT_NO,'')='' THEN '-NA-' ELSE ISNULL('','') END  ACCOUNT_NAME        
--  , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   COUNTER_DP         
--        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   dp_name 
  , CASE WHEN ISNULL(PLDT_PLEDGEE_DPID,'')='' THEN '-NA-' ELSE ISNULL(PLDT_PLEDGEE_DPID,'') END   COUNTER_DP         
  , CASE WHEN ISNULL(PLDT_PLEDGEE_DPID,'')='' THEN '-NA-' ELSE ISNULL(PLDT_PLEDGEE_DEMAT_NAME,'') END   dp_name         
        ,PLDT_ISIN , isin_name , abs(PLDT_QTY ) DPTD_QTY, isnull(PLDT_TRANS_NO,'') TRANSACTION_NO,PLDT_DTLS_ID INTERNAL_REF_NO        
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE '' END   SOURCE_SETT_TYPE         
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   SOURCE_SETT_NO         
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ''  END   TRG_SETT_TYPE        
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   TRG_SETT_NO        
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   CMBPID
		, PLDT_CREATED_BY  MAKER_ID    
  from nsdl_pledge_dtls    
  , dp_acct_mstr src_client , dp_mstr src_dpm ,  isin_mstr ,batchno_nsdl_mstr         
  where PLDT_DPAM_ID = src_client.dpam_id         
  and   src_client.dpam_dpm_id      = src_dpm.dpm_id         
  and   PLDT_ISIN                  = isin_cd        
  and   PLDT_DELETED_IND           = 1        
  and   src_client.dpam_deleted_ind = 1        
  and   src_dpm.dpm_deleted_ind     = 1         
  and   PLDT_BATCH_NO = BATCHN_NO        
  and   PLDT_BATCH_NO = @pa_batch_no         
  and   convert(varchar(11),PLDT_REQUEST_DT,103) = convert(varchar(11),BATCHN_FILEGEN_DT,103)        
  and   convert(varchar(11),PLDT_REQUEST_DT,103)  = @pa_date        
  --and   BATCHC_TRANS_TYPE  = case when DPTDC_INTERNAL_TRASTM in ('C2P','P2C','C2C','P2P') then 'OFFM' else DPTDC_INTERNAL_TRASTM end         
  --and   BATCHN_TRANS_TYPE  = 'PLDGCLSR'        
  AND BATCHN_TRANS_TYPE  = CASE WHEN PLDT_TRASTM_CD = '908' THEN 'CPLDG'
                              WHEN PLDT_TRASTM_CD = '909' THEN 'HPLDG'  
                              WHEN PLDT_TRASTM_CD = '910' THEN 'PLDGINVK'
     						  WHEN PLDT_TRASTM_CD IN ('999','911') THEN 'PLDGCLSR'
							  WHEN PLDT_TRASTM_CD = '916' THEN 'PLDGCNF'
							  WHEN PLDT_TRASTM_CD = '917' THEN 'HYPOCNF'
                              WHEN PLDT_TRASTM_CD = '919' THEN 'CLSRCNF'
							  WHEN PLDT_TRASTM_CD = '918' THEN 'INKCNF'
                          END 
  and   isnull(PLDT_BATCH_NO,'') <> ''        
  and   batchN_trans_type <>'ACCOUNT REGISTRATION'   
        ORDER BY DPTD_INTERNAL_REF_NO       
        
    end 

      
    else if @pa_exch = 'CDSL'    
   
 begin
	--declare @DEMRM_FREE_LOCKEDIN_YN char(1)
 if @pa_trans_type <>'ALL'    
 begin 
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
   , DPTDC_CREATED_BY	MAKER_ID   
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
  and   dptdc_batch_no = BATCHC_NO        
  and   dptdc_batch_no = @pa_batch_no         
  and   convert(varchar(11),dptdc_request_dt,103) = convert(varchar(11),BATCHC_FILEGEN_DT,103)        
  and   convert(varchar(11),dptdc_request_dt,103)  = @pa_date        
  --and   BATCHC_TRANS_TYPE  = case when DPTDC_INTERNAL_TRASTM in ('C2P','P2C','C2C','P2P') then 'OFFM' else DPTDC_INTERNAL_TRASTM end         
  and   BATCHC_TRANS_TYPE  = case when DPTDC_INTERNAL_TRASTM  in ('BOCM','CMCM','CMBO','BOBO') then 'OFFM' else DPTDC_INTERNAL_TRASTM end         
  and   BATCHC_TRANS_TYPE  = @pa_trans_type
  and   isnull(dptdc_batch_no,'') <> ''        
  and   batchc_trans_type <>'ACCOUNT REGISTRATION'        
  
union 
   
  select distinct BATCHC_TRANS_TYPE 
			,case when DEMRM_FREE_LOCKEDIN_YN='Y' THEN 'LOCK' ELSE 'FREE' END
			,convert(varchar,DEMRM_TOTAL_CERTIFICATES)
			,convert(varchar,demrm_request_dt,103) request_dt
			, isnull(convert(varchar,demrm_EXECUTION_DT,103),'') execution_dt
			,'' series       
			,DEMRM_SLIP_SERIAL_NO slip_no      
		    ,src_client.dpam_sba_no ACCOUNT_NO     
		    ,src_client.dpam_sba_name CLIENT_NAME        
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
 , DEMRM_CREATED_BY maker_id
  from demat_request_mstr    
  , dp_acct_mstr src_client , dp_mstr src_dpm ,  isin_mstr ,batchno_cdsl_mstr         
  where demrm_dpam_id = src_client.dpam_id         
  and   src_client.dpam_dpm_id      = src_dpm.dpm_id         
  and   demrm_isin                  = isin_cd        
  and   demrm_deleted_ind           = 1        
  and   src_client.dpam_deleted_ind = 1        
  and   src_dpm.dpm_deleted_ind     = 1         
  and   demrm_batch_no = BATCHC_NO        
  and   demrm_batch_no = @pa_batch_no         
  and   convert(varchar(11),demrm_request_dt,103) = convert(varchar(11),BATCHC_FILEGEN_DT,103)        
  and   convert(varchar(11),demrm_request_dt,103)  = @pa_date        
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
  , REMRM_CREATED_BY maker_id
  from remat_request_mstr    
  , dp_acct_mstr src_client , dp_mstr src_dpm ,  isin_mstr ,batchno_cdsl_mstr         
  where remrm_dpam_id = src_client.dpam_id         
  and   src_client.dpam_dpm_id      = src_dpm.dpm_id         
  and   remrm_isin                  = isin_cd        
  and   remrm_deleted_ind           = 1        
  and   src_client.dpam_deleted_ind = 1        
  and   src_dpm.dpm_deleted_ind     = 1         
  and   remrm_batch_no = BATCHC_NO        
  and   remrm_batch_no = @pa_batch_no         
  and   convert(varchar(11),remrm_request_dt,103) = convert(varchar(11),BATCHC_FILEGEN_DT,103)        
  and   convert(varchar(11),remrm_request_dt,103)  = @pa_date        
  --and   BATCHC_TRANS_TYPE  = case when DPTDC_INTERNAL_TRASTM in ('C2P','P2C','C2C','P2P') then 'OFFM' else DPTDC_INTERNAL_TRASTM end         
  and   BATCHC_TRANS_TYPE  = 'RMT'        
  and   isnull(remrm_batch_no,'') <> ''        
  and   batchc_trans_type <>'ACCOUNT REGISTRATION'   
  --ORDER BY INTERNAL_REF_NO   

union  
  select       
  distinct BATCHC_TRANS_TYPE,'' as DEMRM_FREE_LOCKEDIN_YN,'' as DEMRM_TOTAL_CERTIFICATES
  ,convert(varchar,PLDTC_REQUEST_DT,103) request_dt,      
isnull(convert(varchar,PLDTC_EXEC_DT,103),'') execution_dt,         
  '' series ,      
  PLDTC_SLIP_NO slip_no,      
  src_client.dpam_sba_no ACCOUNT_NO,      
  src_client.dpam_sba_name CLIENT_NAME        
  ,CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END  COUNTER_ACCOUNT         
        ,CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END  ACCOUNT_NAME        
  ,CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   COUNTER_DP         
        ,CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   dp_name         
, CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   CMBPID            
,PLDTC_ISIN DPTD_ISIN,      
  isin_name,               
  abs(PLDTC_QTY) DPTD_QTY,      
  isnull(PLDTC_TRANS_NO,'') TRANSACTION_NO,      
  PLDTC_DTLS_ID INTERNAL_REF_NO   
    , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE '' END   SOURCE_SETT_TYPE         
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   SOURCE_SETT_NO         
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ''  END   TRG_SETT_TYPE        
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   TRG_SETT_NO             
  , PLDTC_CREATED_BY maker_id
  from cdsl_pledge_dtls    
  , dp_acct_mstr src_client , dp_mstr src_dpm ,  isin_mstr ,batchno_cdsl_mstr         
  where PLDTC_DPAM_ID = src_client.dpam_id         
  and   src_client.dpam_dpm_id      = src_dpm.dpm_id         
  and   PLDTC_ISIN                  = isin_cd        
  and   PLDTC_DELETED_IND           = 1        
  and   src_client.dpam_deleted_ind = 1        
  and   src_dpm.dpm_deleted_ind     = 1         
  and   PLDTC_BATCH_NO = BATCHC_NO        
  and   PLDTC_BATCH_NO = @pa_batch_no         
  and   convert(varchar(11),PLDTC_REQUEST_DT,103) = convert(varchar(11),BATCHC_FILEGEN_DT,103)        
  and   convert(varchar(11),PLDTC_REQUEST_DT,103)  = @pa_date        
  --and   BATCHC_TRANS_TYPE  = case when DPTDC_INTERNAL_TRASTM in ('C2P','P2C','C2C','P2P') then 'OFFM' else DPTDC_INTERNAL_TRASTM end         
  and   BATCHC_TRANS_TYPE  = 'BN'        
  and   isnull(PLDTC_BATCH_NO,'') <> ''        
  and   batchc_trans_type <>'ACCOUNT REGISTRATION'   
  ORDER BY INTERNAL_REF_NO 
  end 
  else 
  begin 
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
   , DPTDC_CREATED_BY	MAKER_ID   
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
  and   dptdc_batch_no = BATCHC_NO        
  and   dptdc_batch_no = @pa_batch_no         
  and   convert(varchar(11),dptdc_request_dt,103) = convert(varchar(11),BATCHC_FILEGEN_DT,103)        
  and   convert(varchar(11),dptdc_request_dt,103)  = @pa_date        
  --and   BATCHC_TRANS_TYPE  = case when DPTDC_INTERNAL_TRASTM in ('C2P','P2C','C2C','P2P') then 'OFFM' else DPTDC_INTERNAL_TRASTM end         
  --and   BATCHC_TRANS_TYPE  = case when DPTDC_INTERNAL_TRASTM  in ('BOCM','CMCM','CMBO','BOBO') then 'OFFM' else DPTDC_INTERNAL_TRASTM end         
  and   BATCHC_TRANS_TYPE  = @pa_trans_type
  and   isnull(dptdc_batch_no,'') <> ''        
  and   batchc_trans_type <>'ACCOUNT REGISTRATION'        
  
union 
   
  select distinct BATCHC_TRANS_TYPE 
			,case when DEMRM_FREE_LOCKEDIN_YN='Y' THEN 'LOCK' ELSE 'FREE' END
			,convert(varchar,DEMRM_TOTAL_CERTIFICATES)
			,convert(varchar,demrm_request_dt,103) request_dt
			, isnull(convert(varchar,demrm_EXECUTION_DT,103),'') execution_dt
			,'' series       
			,DEMRM_SLIP_SERIAL_NO slip_no      
		    ,src_client.dpam_sba_no ACCOUNT_NO     
		    ,src_client.dpam_sba_name CLIENT_NAME        
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
 , DEMRM_CREATED_BY maker_id
  from demat_request_mstr    
  , dp_acct_mstr src_client , dp_mstr src_dpm ,  isin_mstr ,batchno_cdsl_mstr         
  where demrm_dpam_id = src_client.dpam_id         
  and   src_client.dpam_dpm_id      = src_dpm.dpm_id         
  and   demrm_isin                  = isin_cd        
  and   demrm_deleted_ind           = 1        
  and   src_client.dpam_deleted_ind = 1        
  and   src_dpm.dpm_deleted_ind     = 1         
  and   demrm_batch_no = BATCHC_NO        
  and   demrm_batch_no = @pa_batch_no         
  and   convert(varchar(11),demrm_request_dt,103) = convert(varchar(11),BATCHC_FILEGEN_DT,103)        
  and   convert(varchar(11),demrm_request_dt,103)  = @pa_date        
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
  , REMRM_CREATED_BY maker_id
  from remat_request_mstr    
  , dp_acct_mstr src_client , dp_mstr src_dpm ,  isin_mstr ,batchno_cdsl_mstr         
  where remrm_dpam_id = src_client.dpam_id         
  and   src_client.dpam_dpm_id      = src_dpm.dpm_id         
  and   remrm_isin                  = isin_cd        
  and   remrm_deleted_ind           = 1        
  and   src_client.dpam_deleted_ind = 1        
  and   src_dpm.dpm_deleted_ind     = 1         
  and   remrm_batch_no = BATCHC_NO        
  and   remrm_batch_no = @pa_batch_no         
  and   convert(varchar(11),remrm_request_dt,103) = convert(varchar(11),BATCHC_FILEGEN_DT,103)        
  and   convert(varchar(11),remrm_request_dt,103)  = @pa_date        
  --and   BATCHC_TRANS_TYPE  = case when DPTDC_INTERNAL_TRASTM in ('C2P','P2C','C2C','P2P') then 'OFFM' else DPTDC_INTERNAL_TRASTM end         
  and   BATCHC_TRANS_TYPE  = 'RMT'        
  and   isnull(remrm_batch_no,'') <> ''        
  and   batchc_trans_type <>'ACCOUNT REGISTRATION'   
  --ORDER BY INTERNAL_REF_NO   

union  
  select       
  distinct BATCHC_TRANS_TYPE,'' as DEMRM_FREE_LOCKEDIN_YN,'' as DEMRM_TOTAL_CERTIFICATES
  ,convert(varchar,PLDTC_REQUEST_DT,103) request_dt,      
isnull(convert(varchar,PLDTC_EXEC_DT,103),'') execution_dt,         
  '' series ,      
  PLDTC_SLIP_NO slip_no,      
  src_client.dpam_sba_no ACCOUNT_NO,      
  src_client.dpam_sba_name CLIENT_NAME        
  ,CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END  COUNTER_ACCOUNT         
        ,CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END  ACCOUNT_NAME        
  ,CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   COUNTER_DP         
        ,CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   dp_name         
, CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   CMBPID            
,PLDTC_ISIN DPTD_ISIN,      
  isin_name,               
  abs(PLDTC_QTY) DPTD_QTY,      
  isnull(PLDTC_TRANS_NO,'') TRANSACTION_NO,      
  PLDTC_DTLS_ID INTERNAL_REF_NO   
    , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE '' END   SOURCE_SETT_TYPE         
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   SOURCE_SETT_NO         
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ''  END   TRG_SETT_TYPE        
        , CASE WHEN ISNULL('','')='' THEN '-NA-' ELSE ISNULL('','') END   TRG_SETT_NO             
  , PLDTC_CREATED_BY maker_id
  from cdsl_pledge_dtls    
  , dp_acct_mstr src_client , dp_mstr src_dpm ,  isin_mstr ,batchno_cdsl_mstr         
  where PLDTC_DPAM_ID = src_client.dpam_id         
  and   src_client.dpam_dpm_id      = src_dpm.dpm_id         
  and   PLDTC_ISIN                  = isin_cd        
  and   PLDTC_DELETED_IND           = 1        
  and   src_client.dpam_deleted_ind = 1        
  and   src_dpm.dpm_deleted_ind     = 1         
  and   PLDTC_BATCH_NO = BATCHC_NO        
  and   PLDTC_BATCH_NO = @pa_batch_no         
  and   convert(varchar(11),PLDTC_REQUEST_DT,103) = convert(varchar(11),BATCHC_FILEGEN_DT,103)        
  and   convert(varchar(11),PLDTC_REQUEST_DT,103)  = @pa_date        
  --and   BATCHC_TRANS_TYPE  = case when DPTDC_INTERNAL_TRASTM in ('C2P','P2C','C2C','P2P') then 'OFFM' else DPTDC_INTERNAL_TRASTM end         
  and   BATCHC_TRANS_TYPE  = 'BN'        
  and   isnull(PLDTC_BATCH_NO,'') <> ''        
  and   batchc_trans_type <>'ACCOUNT REGISTRATION'   
  ORDER BY INTERNAL_REF_NO  
      
  end 
  end  
      
   

 else  if @pa_exch = 'CDSL' and  @pa_trans_type = 'BROKPOATRX'
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
    , DPTDC_CREATED_BY	MAKER_ID
     
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
	  and   convert(varchar(11),dptdc_request_dt,103) = @pa_date        
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
