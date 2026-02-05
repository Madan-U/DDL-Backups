-- Object: PROCEDURE citrus_usr.pr_dp_select_mstr_2
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


--pr_dp_select_mstr_2	'3','DISP_RTA_CONF','HO','3','04/11/2008','06/11/2008','','','','','','','DEMAT','',0,'','',''

--pr_dp_select_mstr_2 '3','DISP_RTA_ISIN','HO','3','','','','','','','','','DEMAT','',0,'*|~*','|*~|',''
--pr_dp_select_mstr '1|*~|4|*~|','VOUCHERPAY_SELC','','','18/10/2008','','203412','6*|~*',229,'*|~*','|*~|',''	              
--pr_dp_select_mstr_2 '','DIGITAL_SIGN','HO','NSDL','IN300175','','','','','','','','','',0,'','',''                              
--pr_dp_select_mstr_2 '','DISP_MARK_CONF','HO','IR','','','','','','','','','','',0,'','',''                    
--pr_dp_select_mstr_2 '3','DISP_RTA_SEARCH','HO','3','','','','','','','','','DEMAT','',0,'','',''  
--pr_dp_select_mstr_2 '4','PLEDGEE_SELM','','','','','','','7','','','','','1|*~|',0,'*|~*','|*~|',''                                         
--pr_dp_select_mstr_2 '','BILL_PERIOD_MISSED_ISIN','HO','','','','','','7','','','','','1*|~*',307,'*|~*','|*~|',''         
--select * from NpledgeD_mak order by 1 desc                                  
--select * from nsdl_pledge_dtls order by 1 desc                
/*ALTER TABLE REMAT_REQUEST_MSTR ADD REMRM_INTERNAL_REJ varchar (10)              
ALTER TABLE REMAT_REQUEST_MSTR ADD REMRM_COMPANY_OBJ varchar (10)              
ALTER TABLE REMAT_REQUEST_MSTR ADD REMRM_CREDIT_RECD varchar (5)*/    


                            
CREATE procedure [citrus_usr].[pr_dp_select_mstr_2]                                                
(@pa_id             VARCHAR(20)                                                  
,@pa_action         VARCHAR(100)                                                  
,@pa_login_name     VARCHAR(20)                                                  
,@pa_search_c1      VARCHAR(20)                                                  
,@pa_search_c2      VARCHAR(20)                                                  
,@pa_search_c3      VARCHAR(20)                                                  
,@pa_search_c4      VARCHAR(20)                                                  
,@pa_search_c5      VARCHAR(20)                                                  
,@pa_search_c6      VARCHAR(20)                                                  
,@pa_search_c7      VARCHAR(20)                                                  
,@pa_search_c8      VARCHAR(20)                                                  
,@pa_search_c9      VARCHAR(20)                                                  
,@pa_search_c10     VARCHAR(20)                                                  
,@pa_roles          VARCHAR(8000)                                                
,@pa_scr_id         NUMERIC                                                
,@rowdelimiter      CHAR(10)                                                  
,@coldelimiter      CHAR(4)                                                  
,@pa_ref_cur        VARCHAR(8000) OUT)                                                
as                                                
begin                                                
--                                                
                                                
declare @l_dpm_dpid varchar(25)                                                
, @l_entm_id bigint                                         
,@pa_dpname varchar(25)             
,@L_EXCSM_CD VARCHAR(10)                                    
if  isnumeric(@pa_search_c1) = 1                                                
select @l_dpm_dpid = dpm_id ,@L_EXCSM_CD = EXCSM_EXCH_CD from dp_mstr, EXCH_SEG_MSTR where EXCSM_ID = DPM_EXCSM_ID AND DEFAULT_DP = @pa_search_c1 and dpm_deleted_ind = 1                                 
SET @pa_dpname = @pa_search_c3                                              
                                                
select @l_entm_id = logn_ent_id from login_names where logn_name = @pa_login_name and logn_deleted_ind =  1                                                
                                                        
                                                
if @pa_action = 'PLEDGEE_SEL'                                                
BEGIN                                                
--                                              
  select distinct dpm_dpid    Dpid                                                
        , dpam_sba_no [Client Id]                                                
        , PLDT_SLIP_NO SlipNO        
        , convert(varchar,PLDT_REQUEST_DT,103) RequestDate        
        , PLDT_AGREEMENT_NO AgrementNO                                                
        , convert(varchar,PLDT_CLOSURE_DT,103) ClosureDate                                                
        , case when PLDT_TRASTM_CD in ('908','916') then 'P' when  PLDT_TRASTM_CD in ('909','917') then 'H' else '' end  [Instr type]                                           
        , PLDT_PLEDGEE_DEMAT_ACCT_NO [PldgeePldgor id]                                      
        , pldt_rmks Remarks                                             , convert(varchar,PLDT_EXEC_DT,103)    ExecDate                                               
        , @pa_search_c1 [exchange]                                              
        , PLDT_DTLS_ID [Dtls id]                                                
        , PLDT_PLEDGEE_DPID [PldgeePldgor DPID]                                    
        , case when PLDT_TRASTM_CD in ('908','909') then 'create'                                                 
               when  PLDT_TRASTM_CD in ('916','917') then 'cnfcreate'                                                 
               when  PLDT_TRASTM_CD in ('911') then 'close'                                 
               when  PLDT_TRASTM_CD in ('910') then 'invk'                                                
 when  PLDT_TRASTM_CD in ('918') then 'cnfclose'                                                 
               when  PLDT_TRASTM_CD in ('919') then 'cnfinvk'                                  
               when  PLDT_TRASTM_CD in ('999') then 'uniclose' else '' end   [Desc]                                        
  from nsdl_pledge_dtls                                                
  ,    dp_mstr                                                
  ,    dp_acct_mstr                                                 
  where dpam_id  =   PLDT_DPAM_ID                                                
  and   dpm_id   =  PLDT_DPM_ID                                 
        and   default_dp = @pa_search_c1                                                
        and   dpam_deleted_ind = 1                                                
  and   dpm_deleted_ind = 1                                                
  and   PLDT_deleted_ind = 1    
   and   convert(varchar,PLDT_REQUEST_DT,103) like case when @pa_search_c2 = '' then '%' else @pa_search_c2 end                                               
       -- and   convert(varchar,PLDT_REQUEST_DT,103) = @pa_search_c2                                                  
  and   dpam_sba_no like   case when @pa_search_c3 = '' then '%' else @pa_search_c3 end                                                
  and   PLDT_SLIP_NO like   case when @pa_search_c4 = '' then '%' else @pa_search_c4 end                                                 
        and   case when PLDT_TRASTM_CD in ('908','909') then 'create'                                                 
               when  PLDT_TRASTM_CD in ('916','917') then 'cnfcreate'                                                 
               when  PLDT_TRASTM_CD in ('911') then 'close'                                                
               when  PLDT_TRASTM_CD in ('910') then 'invk'                                                
               when  PLDT_TRASTM_CD in ('918') then 'cnfclose'                                     
               when  PLDT_TRASTM_CD in ('999') then 'uniclose'                                              
               when  PLDT_TRASTM_CD in ('919') then 'cnfinvk' else '' end like   case when @pa_search_c5 = '' then '%' else @pa_search_c5 end                                                   
  and  isnull(PLDT_BROKER_BATCH_NO,'') = ''  
  and   PLDT_SEQ_NO like   case when @pa_search_c7 = '' then '%' else @pa_search_c7 end                                             
                                                   
--                                                
END                                                
ELSE IF @pa_action = 'PLEDGEE_DTLS_SEL'                                                
BEGIN                                                
--                                           
                                                
  select PLDT_ISIN                                              
        ,convert(varchar,PLDT_REL_DT,103) PLDT_REL_DT                                                
        ,isnull(PLDT_REL_RSN,'') PLDT_REL_RSN                                                
        ,abs(PLDT_QTY)  PLDT_QTY                                                
       -- ,isnull(PLDT_SEQ_NO,'')  PLDT_SEQ_NO 
       ,isnull(PLDT_TRANS_NO,'')  PLDT_SEQ_NO                                                  
        ,isnull(PLDT_REJ_RSN,'') PLDT_REJ_RSN                                              
        ,PLDT_ID 
		,case when isnull(pldt_batch_no,'') = '' then PLDT_ID else ISNULL(PLDT_TRANS_NO,'') end  internalno   
  from  nsdl_pledge_dtls                                                
  where PLDT_DTLS_ID = @pa_search_c1                                                
  and   PLDT_deleted_ind = 1                             
--                                                
END                                                
ELSE IF @pa_action = 'PLEDGEE_SELM'                                                
BEGIN                                                
--                                                
  if isnull(@pa_search_c6,'') <> ''                                            
  begin                                             
    select distinct dpm_dpid    Dpid                                                
        , dpam_sba_no [Client Id]                                                
        , PLDT_SLIP_NO SlipNO                                                      
        , convert(varchar,PLDT_REQUEST_DT,103) RequestDate                                                
  , PLDT_AGREEMENT_NO AgrementNO                                                
        , convert(varchar,PLDT_CLOSURE_DT,103) ClosureDate                                                
        , case when PLDT_TRASTM_CD in ('908','916') then 'P' when  PLDT_TRASTM_CD in ('909','917') then 'H' else '' end  [Instr type]                                                
        , PLDT_PLEDGEE_DEMAT_ACCT_NO [PldgeePldgor id]                                   
       , pldt_rmks Remarks                                             
        , convert(varchar,PLDT_EXEC_DT,103)    ExecDate                                                
        , @pa_search_c1 [exchange]                                              
        , PLDT_DTLS_ID [Dtls id]                                                
        , PLDT_PLEDGEE_DPID [PldgeePldgor DPID]                                                
        , case when PLDT_TRASTM_CD in ('908','909') then 'create'                                                 
               when  PLDT_TRASTM_CD in ('916','917') then 'cnfcreate'                                                 
               when  PLDT_TRASTM_CD in ('911') then 'close'                                                
               when  PLDT_TRASTM_CD in ('910') then 'invk'                         
               when  PLDT_TRASTM_CD in ('919') then 'cnfclose'                                   
               when  PLDT_TRASTM_CD in ('999') then 'uniclose'                                                
               when  PLDT_TRASTM_CD in ('918') then 'cnfinvk'else '' end   [Desc]                                                
  from NpledgeD_mak                                                
  ,    dp_mstr                                                
  ,    dp_acct_mstr                                                 
  where dpam_id  =   PLDT_DPAM_ID                                                
  and   dpm_id   =  PLDT_DPM_ID                                       
        and   default_dp = @pa_search_c1                                                
        and   dpam_deleted_ind = 1                                                
  and   dpm_deleted_ind = 1                                                
  and   PLDT_deleted_ind in (0,4,6,-1)                                          
  and   convert(varchar,PLDT_REQUEST_DT,103) like case when @pa_search_c2 = '' then '%' else @pa_search_c2 end                                                
                                        
--        and   convert(varchar,PLDT_REQUEST_DT,103) = @pa_search_c2                                                  
  and   dpam_sba_no like   case when @pa_search_c3 = '' then '%' else @pa_search_c3 end                                                
  and   PLDT_SLIP_NO like   case when @pa_search_c4 = '' then '%' else @pa_search_c4 end                                                 
        and   case when PLDT_TRASTM_CD in ('908','909') then 'create'                                                 
               when  PLDT_TRASTM_CD in ('916','917') then 'cnfcreate'                                                 
               when  PLDT_TRASTM_CD in ('911') then 'close'                                                
               when  PLDT_TRASTM_CD in ('910') then 'invk'                                         
               when  PLDT_TRASTM_CD in ('999') then 'uniclose'                                         
               when  PLDT_TRASTM_CD in ('919') then 'cnfclose'                                                 
               when  PLDT_TRASTM_CD in ('918') then 'cnfinvk' else '' end like   case when @pa_search_c5 = '' then '%' else @pa_search_c5 end                                                   
   and  isnull(PLDT_BROKER_BATCH_NO,'') = ''                                            
   and  PLDT_DTLS_ID = @pa_search_c6 
   and   isnull(PLDT_SEQ_NO,'') like   case when @pa_search_c7 = '' then '%' else @pa_search_c7 end                                                 
                                           
                                            
                                                   
  end                                            
  else                                             
  begin                         
    select distinct dpm_dpid    Dpid                                                
        , dpam_sba_no [Client Id]                                        
        , PLDT_SLIP_NO SlipNO                                                      
        , convert(varchar,PLDT_REQUEST_DT,103) RequestDate                                                
        , PLDT_AGREEMENT_NO AgrementNO                                                
        , convert(varchar,PLDT_CLOSURE_DT,103) ClosureDate                                          , case when PLDT_TRASTM_CD in ('908','916') then 'P' when  PLDT_TRASTM_CD in ('909','917') then 'H' else '' end  [Instr type]                              
                  
        , PLDT_PLEDGEE_DEMAT_ACCT_NO [PldgeePldgor id]                                      
        , pldt_rmks Remarks                                                       
  , convert(varchar,PLDT_EXEC_DT,103)    ExecDate                                                       
        , @pa_search_c1 [exchange]                                              
        , PLDT_DTLS_ID [Dtls id]                                                
        , PLDT_PLEDGEE_DPID [PldgeePldgor DPID]                                                
        , case when PLDT_TRASTM_CD in ('908','909') then 'create'                                                 
               when  PLDT_TRASTM_CD in ('916','917') then 'cnfcreate'                                                 
  when  PLDT_TRASTM_CD in ('911') then 'close'                                                
               when  PLDT_TRASTM_CD in ('910') then 'invk'                                                
               when  PLDT_TRASTM_CD in ('919') then 'cnfclose'                                     
              when  PLDT_TRASTM_CD in ('999') then 'uniclose'                                              
               when  PLDT_TRASTM_CD in ('918') then 'cnfinvk'else '' end   [Desc]                          
  from NpledgeD_mak                                                
  ,    dp_mstr                                                
  ,    dp_acct_mstr                                                 
  where dpam_id  =   PLDT_DPAM_ID                                                
  and   dpm_id   =  PLDT_DPM_ID                         
        and   default_dp = @pa_search_c1         
        and   dpam_deleted_ind = 1                                                
  and   dpm_deleted_ind = 1                                                
  and   PLDT_deleted_ind in (0,4,6,-1)
   AND    convert(varchar,PLDT_REQUEST_DT,103)      LIKE CASE WHEN ISNULL(@pa_search_c2,'') = '' then convert(varchar,PLDT_REQUEST_DT,103) else @pa_search_c2 end                                                                 
       -- and   convert(varchar,PLDT_REQUEST_DT,103) = @pa_search_c2                                                and   dpam_sba_no like   case when @pa_search_c3 = '' then '%' else @pa_search_c3 end 
--and   PLDT_SEQ_NO like   case when @pa_search_c7 = '' then '%' else @pa_search_c7 end                                                  
  and   PLDT_SLIP_NO like   case when @pa_search_c4 = '' then '%' else @pa_search_c4 end   
 and   dpam_sba_no like   case when @pa_search_c3 = '' then '%' else @pa_search_c3 end                                                 
        and   case when PLDT_TRASTM_CD in ('908','909') then 'create'                                                 
  when  PLDT_TRASTM_CD in ('916','917') then 'cnfcreate'                                                 
               when  PLDT_TRASTM_CD in ('911') then 'close'                                                
               when  PLDT_TRASTM_CD in ('910') then 'invk'                                                
               when  PLDT_TRASTM_CD in ('919') then 'cnfclose'                   
               when  PLDT_TRASTM_CD in ('999') then 'uniclose'                                              
               when  PLDT_TRASTM_CD in ('918') then 'cnfinvk' else '' end like   case when @pa_search_c5 = '' then '%' else @pa_search_c5 end                                                   
   and  isnull(PLDT_BROKER_BATCH_NO,'') = ''                                              
  end                                          
--                                                
END                                                
ELSE IF @pa_action = 'PLEDGEE_DTLS_SELM'                                                
BEGIN                                                
--                                                
  select PLDT_ISIN                                                
        ,case when PLDT_REL_DT = '1900-01-01 00:00:00.000' then '' else convert(varchar,PLDT_REL_DT,103)end  PLDT_REL_DT                                                
        ,isnull(PLDT_REL_RSN,'') PLDT_REL_RSN                                            
        ,abs(PLDT_QTY)   PLDT_QTY                                     
        --,isnull(PLDT_SEQ_NO,'')  PLDT_SEQ_NO
        ,isnull(PLDT_TRANS_NO,'')  PLDT_SEQ_NO                                                     
        ,isnull(PLDT_REJ_RSN,'') PLDT_REJ_RSN                                              
        ,PLDT_ID         
		,case when isnull(pldt_batch_no,'') = '' then PLDT_ID else ISNULL(PLDT_TRANS_NO,'') end  internalno                                     
                                              
  from  NpledgeD_mak                                                
  where PLDT_DTLS_ID = @pa_search_c1                                             
  and   PLDT_deleted_ind  in (0,4,6,-1)                                              
--                                                
END                                   
ELSE IF @pa_action = 'PLEDGEE_SELC'                                                
BEGIN                                        
--                                                
    select distinct dpm_dpid    Dpid                                                
        , dpam_sba_no [Client Id]                                                
        , PLDT_SLIP_NO SlipNO                                                      
        , convert(varchar,PLDT_REQUEST_DT,103) RequestDate                                                
        , PLDT_AGREEMENT_NO AgrementNO                                                
        , convert(varchar,PLDT_CLOSURE_DT,103) ClosureDate                   
        , case when PLDT_TRASTM_CD in ('908','916') then 'P' when  PLDT_TRASTM_CD in ('909','917') then 'H' else '' end  [Instr type]                                                
  , PLDT_PLEDGEE_DEMAT_ACCT_NO [PldgeePldgor id]                                                           
       -- , abs(PLDT_QTY)   [Quantity]                                                  
        , pldt_rmks Remarks                                                
        , convert(varchar,PLDT_EXEC_DT,103)    ExecDate                                    
        , @pa_search_c1 [exchange]                                  
        , PLDT_DTLS_ID [Dtls_id]                                                
        , PLDT_PLEDGEE_DPID [PldgeePldgor DPID]                                         
        ,'0' PLDT_DELETED_IND                                               
        , case when PLDT_TRASTM_CD in ('908','909') then 'create'                                                 
               when  PLDT_TRASTM_CD in ('916','917') then 'cnfcreate'                                                 
        when  PLDT_TRASTM_CD in ('911') then 'close'                                                
               when  PLDT_TRASTM_CD in ('910') then 'invk'                                                
               when  PLDT_TRASTM_CD in ('918') then 'cnfclose'                                      
               when  PLDT_TRASTM_CD in ('999') then 'uniclose'                                             
               when  PLDT_TRASTM_CD in ('919') then 'cnfinvk'else '' end   [Desc]                                       
  from NpledgeD_mak                                                
  ,    dp_mstr                                                
  ,    dp_acct_mstr                                                 
  where dpam_id  =   PLDT_DPAM_ID                                                
  and   dpm_id   =  PLDT_DPM_ID                                                       
  and   dpam_deleted_ind = 1                    
  and   dpm_deleted_ind = 1                                                
  and   PLDT_deleted_ind in (0,4,6,-1)                                                 
  and   case when PLDT_TRASTM_CD in ('908','909') then 'create'                                                 
        when  PLDT_TRASTM_CD in ('916','917') then 'cnfcreate'                                                 
        when  PLDT_TRASTM_CD in ('911') then 'close'                                                
        when  PLDT_TRASTM_CD in ('910') then 'invk'                                                
        when  PLDT_TRASTM_CD in ('918') then 'cnfclose'                                                 
        when  PLDT_TRASTM_CD in ('919') then 'cnfinvk' else '' end  like   case when @pa_search_c5 = '' then '%' else @pa_search_c5 end                                                   
  and  isnull(PLDT_BROKER_BATCH_NO,'') = ''                                        
--                                                
END                  
                
IF @PA_ACTION = 'PLEDGEE_SEL_CDSL'                                                
BEGIN                                                
--                                    
  SELECT DISTINCT DPM_DPID    DPID                                                
        , DPAM_SBA_NO [CLIENT ID]                                                
        , PLDTC_SLIP_NO SLIPNO                               
        , CONVERT(VARCHAR,PLDTC_REQUEST_DT,103) REQUESTDATE                                                
        , PLDTC_AGREEMENT_NO AGREMENTNO                                                
        , CONVERT(VARCHAR,PLDTC_SETUP_DT,103) SETUPDATE                                  
        , CONVERT(VARCHAR,PLDTC_EXPIRY_DT,103) EXPIRYDATE                                  
        , PLDTC_RMKS REMARKS                                                       
  , CONVERT(VARCHAR,PLDTC_EXEC_DT,103)    EXECDATE                            
        , @PA_SEARCH_C1 [EXCHANGE]                                              
        , PLDTC_DTLS_ID [DTLS ID]                                                
        , PLDTC_PLDG_DPID [PLDGEEPLDGOR DPID]                                    
        , PLDTC_PLDG_CLIENTID [CLIENTID]                                  
        , PLDTC_PLDG_CLIENTNAME  [CLIENTNAME]                                             
        , PLDTC_TRASTM_CD  [DESC]                                   
        ,PLDTC_CLOSURE_BY                                   
        ,PLDTC_SECURITTIES                                    
        ,PLDTC_SUB_STATUS ,pldtc_id    
		,PLDTC_UCC
		,PLDTC_EXID
		,PLDTC_SEGID
		,PLDTC_CMID
		,PLDTC_EID
		,PLDTC_TMCMID 
		,PLDTC_REASON_CODE
		,PLDTC_CUSPA_FLG
,PLDTC_CUSPA_TRX_CTGRY
,PLDTC_CUSPA_EPI
,PLDTC_CUSPA_SETTLEMENTID
,PLDTC_CUSPA_CMBP_DPID
  FROM CDSL_PLEDGE_DTLS                                                
  ,    DP_MSTR                                                
  ,    DP_ACCT_MSTR                                                 
  WHERE DPAM_ID  =   PLDTC_DPAM_ID                                                
  AND   DPM_ID   =  PLDTC_DPM_ID                                                
        AND   DEFAULT_DP = @PA_SEARCH_C1                                                
        AND   DPAM_DELETED_IND = 1                                                
  AND   DPM_DELETED_IND = 1                                 
  AND   PLDTC_DELETED_IND = 1                                                
  AND   CONVERT(VARCHAR,PLDTC_REQUEST_DT,103) = @PA_SEARCH_C2                                                  
  AND   DPAM_SBA_NO LIKE   CASE WHEN @PA_SEARCH_C3 = '' THEN '%' ELSE @PA_SEARCH_C3 END                                       
  AND   PLDTC_SLIP_NO LIKE   CASE WHEN @PA_SEARCH_C4 = '' THEN '%' ELSE @PA_SEARCH_C4 END                                                 
  AND   PLDTC_TRASTM_CD LIKE   CASE WHEN @PA_SEARCH_C5 = '' THEN '%' ELSE @PA_SEARCH_C5 END                        
  AND  ISNULL(PLDTC_BROKER_BATCH_NO,'') = ''   
order by pldtc_id                                         
                                                   
--                                                
END                             
ELSE IF @PA_ACTION = 'PLEDGEE_DTLS_SEL_CDSL'                                                
BEGIN                                                
--                                                
                                                
  SELECT PLDTC_ISIN                                                
        ,ABS(PLDTC_QTY)  PLDTC_QTY                        
        ,ISNULL(PLDTC_PSN,'')  PLDTC_PSN                                                
        ,ISNULL(PLDTC_REASON,'') REASON                                              
        ,PLDTC_ID        
		,CASE WHEN isnull(PLDTC_BATCH_NO,'') = '' THEN PLDTC_ID ELSE ISNULL(PLDTC_TRANS_NO,'') END INTERNALNO 
		,ISNULL(PLDTC_VALUE , '0')      PLDTC_VALUE                              
  FROM  CDSL_PLEDGE_DTLS                                                
  WHERE PLDTC_DTLS_ID = @PA_SEARCH_C1                                                
  AND   PLDTC_DELETED_IND = 1                                              
--                                                
END                                  
ELSE IF @PA_ACTION = 'PLEDGEE_DTLS_SELM_CDSL'                                                
BEGIN                               
--                                                
  SELECT PLDTC_ISIN                                                
        ,ABS(PLDTC_QTY)  PLDTC_QTY                                                
        ,ISNULL(PLDTC_PSN,'')  PLDTC_PSN                                                
        ,ISNULL(PLDTC_REASON,'') REASON                                              
        ,PLDTC_ID            
		,CASE WHEN isnull(PLDTC_BATCH_NO,'') = '' THEN PLDTC_ID ELSE ISNULL(PLDTC_TRANS_NO,'') END INTERNALNO    
		,isnull (PLDTC_VALUE,'0' )    PLDTC_VALUE                      
  FROM  CPLEDGED_MAK                                                
  WHERE PLDTC_DTLS_ID = @PA_SEARCH_C1                                             
  AND   PLDTC_DELETED_IND  IN (0,4,6,-1)                                              
--                                                
END                                    
ELSE IF @PA_ACTION = 'PLEDGEE_SELM_CDSL'                                                
BEGIN                                                
--    
select  @PA_SEARCH_C1 = dpm_excsm_id from dp_mstr where dpm_id like (select distinct PLDTC_DPM_ID from CpledgeD_mak where PLDTC_DTLS_ID = @PA_SEARCH_C6)                                            
  IF ISNULL(@PA_SEARCH_C6,'') <> ''                       
  BEGIN                                             
    SELECT DISTINCT DPM_DPID    DPID                                                
        , DPAM_SBA_NO [CLIENT ID]                                                
        , PLDTC_SLIP_NO SLIPNO                                                      
        , CONVERT(VARCHAR,PLDTC_REQUEST_DT,103) REQUESTDATE                                                
        , PLDTC_AGREEMENT_NO AGREMENTNO                                                
        , CONVERT(VARCHAR,PLDTC_SETUP_DT,103) SETUPDATE                                  
        , CONVERT(VARCHAR,PLDTC_EXPIRY_DT,103) EXPIRYDATE      
        , PLDTC_RMKS REMARKS                                                       
		, CONVERT(VARCHAR,PLDTC_EXEC_DT,103)    EXECDATE                                               
        , @PA_SEARCH_C1 [EXCHANGE]                                              
        , PLDTC_DTLS_ID [DTLS ID]                                                
        , PLDTC_PLDG_DPID [PLDGEEPLDGOR DPID]                                    
        , PLDTC_PLDG_CLIENTID [CLIENTID]                                  
        , PLDTC_PLDG_CLIENTNAME  [CLIENTNAME]                                    
        , PLDTC_TRASTM_CD  [DESC]                                      
        ,PLDTC_CLOSURE_BY                                   
        ,PLDTC_SECURITTIES                                    
        ,PLDTC_SUB_STATUS   ,PLDTC_ID  
        --, isnull(pldtc_value,'0')       pldtc_value                           
		,PLDTC_UCC
		,PLDTC_EXID
		,PLDTC_SEGID
		,PLDTC_CMID
		,PLDTC_EID
		,PLDTC_TMCMID 
		,PLDTC_REASON_CODE
		,PLDTC_ULTIMATE_LENDER_PAN
,PLDTC_ULTIMATE_LENDER_CODE
,PLDTC_CUSPA_FLG
,PLDTC_CUSPA_TRX_CTGRY
,PLDTC_CUSPA_EPI
,PLDTC_CUSPA_SETTLEMENTID
,PLDTC_CUSPA_CMBP_DPID
  FROM CPLEDGED_MAK                                                
  ,    DP_MSTR                                                
  ,    DP_ACCT_MSTR                                                 
  WHERE DPAM_ID  =   PLDTC_DPAM_ID                                                
  AND   DPM_ID   =  PLDTC_DPM_ID                                                
        AND   DEFAULT_DP = @PA_SEARCH_C1                                                
        AND   DPAM_DELETED_IND = 1                                                
  AND   DPM_DELETED_IND = 1                                                
  AND   PLDTC_DELETED_IND IN (0,4,6,-1)                                          
  AND   CONVERT(VARCHAR,PLDTC_REQUEST_DT,103) LIKE CASE WHEN @PA_SEARCH_C2 = '' THEN '%' ELSE @PA_SEARCH_C2 END                                                
                                        
--        AND   CONVERT(VARCHAR,PLDT_REQUEST_DT,103) = @PA_SEARCH_C2                                                  
  AND   DPAM_SBA_NO LIKE   CASE WHEN @PA_SEARCH_C3 = '' THEN '%' ELSE @PA_SEARCH_C3 END                                                
  AND   PLDTC_SLIP_NO LIKE   CASE WHEN @PA_SEARCH_C4 = '' THEN '%' ELSE @PA_SEARCH_C4 END                                           
  AND   PLDTC_TRASTM_CD  LIKE   CASE WHEN @PA_SEARCH_C5 = '' THEN '%' ELSE @PA_SEARCH_C5 END                                                   
   AND  ISNULL(PLDTC_BROKER_BATCH_NO,'') = ''                                            
   AND  PLDTC_DTLS_ID = @PA_SEARCH_C6     
   order by    PLDTC_ID                    
                                            
                                                   
  END                                            
  ELSE                                             
  BEGIN                                            
    SELECT DISTINCT DPM_DPID    DPID                                                
        , DPAM_SBA_NO [CLIENT ID]                                                
        , PLDTC_SLIP_NO SLIPNO                                  
        , CONVERT(VARCHAR,PLDTC_REQUEST_DT,103) REQUESTDATE                                                
        , PLDTC_AGREEMENT_NO AGREMENTNO                                                
        , CONVERT(VARCHAR,PLDTC_SETUP_DT,103) SETUPDATE                                  
        , CONVERT(VARCHAR,PLDTC_EXPIRY_DT,103) EXPIRYDATE                                  
        , PLDTC_RMKS REMARKS                                                       
  , CONVERT(VARCHAR,PLDTC_EXEC_DT,103)    EXECDATE                                               
        , @PA_SEARCH_C1 [EXCHANGE]                                              
        , PLDTC_DTLS_ID [DTLS ID]                                                
        , PLDTC_PLDG_DPID [PLDGEEPLDGOR DPID]                                    
        , PLDTC_PLDG_CLIENTID [CLIENTID]                                  
        , PLDTC_PLDG_CLIENTNAME  [CLIENTNAME]                                             
        , PLDTC_TRASTM_CD  [DESC]                                  
         ,PLDTC_CLOSURE_BY                                   
        ,PLDTC_SECURITTIES                                   
        ,PLDTC_SUB_STATUS    ,PLDTC_ID                                       
		,PLDTC_UCC
		,PLDTC_EXID
		,PLDTC_SEGID
		,PLDTC_CMID
		,PLDTC_EID
		,PLDTC_TMCMID 
		,PLDTC_REASON_CODE
		,PLDTC_ULTIMATE_LENDER_PAN
,PLDTC_ULTIMATE_LENDER_CODE
,PLDTC_CUSPA_FLG
,PLDTC_CUSPA_TRX_CTGRY
,PLDTC_CUSPA_EPI
,PLDTC_CUSPA_SETTLEMENTID
,PLDTC_CUSPA_CMBP_DPID
  FROM CPLEDGED_MAK                                                
  ,    DP_MSTR                                                
  ,    DP_ACCT_MSTR                                   
  WHERE DPAM_ID  =   PLDTC_DPAM_ID                                                
  AND   DPM_ID   =  PLDTC_DPM_ID                                                
        AND   DEFAULT_DP = @PA_SEARCH_C1                                                
        AND   DPAM_DELETED_IND = 1                                                
  AND   DPM_DELETED_IND = 1                                                
  AND   PLDTC_DELETED_IND IN (0,4,6,-1)                                          
  AND   CONVERT(VARCHAR,PLDTC_REQUEST_DT,103) LIKE CASE WHEN @PA_SEARCH_C2 = '' THEN '%' ELSE @PA_SEARCH_C2 END                                              
                                        
--        AND   CONVERT(VARCHAR,PLDT_REQUEST_DT,103) = @PA_SEARCH_C2                                                  
  AND   DPAM_SBA_NO LIKE   CASE WHEN @PA_SEARCH_C3 = '' THEN '%' ELSE @PA_SEARCH_C3 END                                                
  AND   PLDTC_SLIP_NO LIKE   CASE WHEN @PA_SEARCH_C4 = '' THEN '%' ELSE @PA_SEARCH_C4 END                                                 
  AND   PLDTC_TRASTM_CD  LIKE   CASE WHEN @PA_SEARCH_C5 = '' THEN '%' ELSE @PA_SEARCH_C5 END                                                   
  AND  ISNULL(PLDTC_BROKER_BATCH_NO,'') = ''                                            
    order by    PLDTC_ID                                              
  END                                        
                     
--                                                
END                                     
ELSE IF @PA_ACTION = 'PLEDGEE_SELC_CDSL'                                                
BEGIN                                                
--                                                
    select     DPID                                                
        ,  [CLIENT ID]                                                
        ,  SLIPNO                                                      
        ,  REQUESTDATE                                                
        ,  AGREMENTNO                                                
        ,  SETUPDATE                  
  ,  EXPIRYDATE                                  
        ,  REMARKS                                                       
  ,     EXECDATE                                               
        ,  [EXCHANGE]                                              
        ,  [DTLS_ID]                                                
        ,  [PLDGEEPLDGOR DPID]                                    
        ,  [CLIENTID]                                  
        ,   [CLIENTNAME]                                             
        ,   [DESC]                                  
        ,PLDTC_CLOSURE_BY                                   
        ,PLDTC_SECURITTIES             
        ,max(PLDTC_DELETED_IND ) PLDTC_DELETED_IND
        ,PLDTC_SUB_STATUS  
        from 
        (
    SELECT DISTINCT DPM_DPID    DPID                                                
        , DPAM_SBA_NO [CLIENT ID]                                                
        , PLDTC_SLIP_NO SLIPNO                                                      
        , CONVERT(VARCHAR,PLDTC_REQUEST_DT,103) REQUESTDATE                                                
        , PLDTC_AGREEMENT_NO AGREMENTNO                                                
        , CONVERT(VARCHAR,PLDTC_SETUP_DT,103) SETUPDATE                  
  , CONVERT(VARCHAR,PLDTC_EXPIRY_DT,103) EXPIRYDATE                                  
        , PLDTC_RMKS REMARKS                                                       
  , CONVERT(VARCHAR,PLDTC_EXEC_DT,103)    EXECDATE                                               
        , @PA_SEARCH_C1 [EXCHANGE]                                              
        , PLDTC_DTLS_ID [DTLS_ID]                                                
        , PLDTC_PLDG_DPID [PLDGEEPLDGOR DPID]                                    
        , PLDTC_PLDG_CLIENTID [CLIENTID]                                  
        , PLDTC_PLDG_CLIENTNAME  [CLIENTNAME]                                             
        , PLDTC_TRASTM_CD  [DESC]                                  
        ,PLDTC_CLOSURE_BY                                   
        ,PLDTC_SECURITTIES             
        ,PLDTC_DELETED_IND                                 
        ,PLDTC_SUB_STATUS                                
  FROM CPLEDGED_MAK                                                
  ,    DP_MSTR                                                
  ,    DP_ACCT_MSTR                               
  WHERE DPAM_ID  =   PLDTC_DPAM_ID                                                
  AND   DPM_ID   =  PLDTC_DPM_ID                                                       
  AND   DPAM_DELETED_IND = 1                                                
  AND   DPM_DELETED_IND = 1                                                
  AND   PLDTC_DELETED_IND IN (0,4,6,-1)                                                 
  AND   PLDTC_TRASTM_CD LIKE   CASE WHEN @PA_SEARCH_C5 = '' THEN '%' ELSE @PA_SEARCH_C5 END                                                   
  AND   ISNULL(PLDTC_BROKER_BATCH_NO,'') = ''    
  AND   PLDTC_UPDATED_BY <> @pa_login_name            
  )   
  t       
  group by  DPID                                                
        ,  [CLIENT ID]                                                
        ,  SLIPNO                                                      
        ,  REQUESTDATE                                                
        ,  AGREMENTNO                                                
        ,  SETUPDATE                  
  ,  EXPIRYDATE                                  
        ,  REMARKS                                                       
  ,     EXECDATE                                               
        ,  [EXCHANGE]                                              
        ,  [DTLS_ID]                                                
        ,  [PLDGEEPLDGOR DPID]                                    
        ,  [CLIENTID]                                  
        ,   [CLIENTNAME]                                             
        ,   [DESC]                                  
        ,PLDTC_CLOSURE_BY                                   
        ,PLDTC_SECURITTIES             
        
        ,PLDTC_SUB_STATUS              
--                                                
END                 
 IF @PA_ACTION = 'DISP_REJECT'                                                                
BEGIN                                                       
--                   
  if @pa_search_c10 ='demat'              
  begin                   
  --                                             
      IF @PA_SEARCH_C2= 'ALL'                                                   
      BEGIN                                                   
			  SELECT DEMRM_ID ID,DEMRM_ISIN ISIN                                                
			 ,DEMRM_SLIP_SERIAL_NO   DRF_NO                                               
			 ,DEMRM_SLIP_SERIAL_NO        SLIP_SERIAL_NO                                            
			 ,CONVERT(VARCHAR,DEMRM_REQUEST_DT,103)   REQUEST_DT          
			 ,CONVERT(VARCHAR,DEMRM_EXECUTION_DT,103) EXECUTION_DT                                              
			 ,Convert(numeric(18,3),DEMRM_QTY)     QTY                                             
			 ,DPAM_SBA_NO                                            
			 ,DPAM_SBA_NAME                                            
			 ,ISNULL(DEMRM_TRANSACTION_NO,'') DRN_NO                                            
			 ,'' DISP_DT                                          
			 ,'' DISP_DOC_ID                                          
			 ,'' DISP_NAME                                          
			 ,'' DISP_ID 
			 ,'' disp_cons_no   
			 FROM DEMAT_REQUEST_MSTR,DP_ACCT_MSTR                                             
			 WHERE DEMRM_DPAM_ID =  DPAM_ID   
			 AND DPAM_DPM_ID = @l_dpm_dpid
			 AND NOT EXISTS (SELECT DISP_DEMRM_ID FROM  DMAT_DISPATCH WHERE DISP_DEMRM_ID = DEMRM_ID AND DISP_TO = 'C')                                           
			 AND (ISNULL(DEMRM_INTERNAL_REJ,'') <> '' OR ISNULL(DEMRM_COMPANY_OBJ,'') <>'')                                          
			 AND DEMRM_DELETED_IND = 1
			 AND DPAM_DELETED_IND = 1
            and DEMRM_SLIP_SERIAL_NO = @pa_search_c9
                                                
      END                                                
      ELSE IF @PA_SEARCH_C2= 'IR'                                                   
      BEGIN   
print @l_dpm_dpid                                              
--			SELECT DEMRM_ID ID,DEMRM_ISIN ISIN                                                
--			,DEMRM_SLIP_SERIAL_NO   DRF_NO                                               
--			,DEMRM_SLIP_SERIAL_NO        SLIP_SERIAL_NO                                            
--			,CONVERT(VARCHAR,DEMRM_REQUEST_DT,103)   REQUEST_DT          
--			,CONVERT(VARCHAR,DEMRM_EXECUTION_DT,103) EXECUTION_DT                                              
--			,Convert(numeric(18,3),DEMRM_QTY) QTY                                             
--			,DPAM_SBA_NO                                            
--			,DPAM_SBA_NAME                                            
--			,ISNULL(DEMRM_TRANSACTION_NO,'') DRN_NO                                            
--			,'' DISP_DT                                          
--			,'' DISP_DOC_ID                                          
--			,'' DISP_NAME                                          
--			,'' DISP_ID 
--			,'' disp_cons_no   
--			FROM DEMAT_REQUEST_MSTR,DP_ACCT_MSTR                                                  
--			WHERE DEMRM_DPAM_ID =  DPAM_ID
--			AND DPAM_DPM_ID = @l_dpm_dpid
--			AND ISNULL(DEMRM_INTERNAL_REJ,'') <>''                                                
--			AND NOT EXISTS (SELECT DISP_DEMRM_ID FROM  DMAT_DISPATCH WHERE DISP_DEMRM_ID = DEMRM_ID AND DISP_TO = 'C')                                           
--			AND DEMRM_DELETED_IND = 1
--			AND DPAM_DELETED_IND = 1
SELECT DEMRM_ID ID,DEMRM_ISIN ISIN                                                
			,DEMRM_SLIP_SERIAL_NO   DRF_NO                                               
			,DEMRM_SLIP_SERIAL_NO        SLIP_SERIAL_NO                                            
			,CONVERT(VARCHAR,DEMRM_REQUEST_DT,103)   REQUEST_DT          
			,CONVERT(VARCHAR,DEMRM_EXECUTION_DT,103) EXECUTION_DT                                              
			,Convert(numeric(18,3),DEMRM_QTY) QTY                                             
			,DPAM_SBA_NO                                            
			,DPAM_SBA_NAME                                            
			--,ISNULL(DEMRM_TRANSACTION_NO,'') DRN_NO                                            
			,'' DRN_NO
			,'' DISP_DT                                          
			,'' DISP_DOC_ID                                          
			,'' DISP_NAME                                          
			,'' DISP_ID 
			,'' disp_cons_no   
			FROM demrm_mak,DP_ACCT_MSTR                                                  
			WHERE DEMRM_DPAM_ID =  DPAM_ID
			AND DPAM_DPM_ID = @l_dpm_dpid
			AND ISNULL(demrm_res_desc_intobj,'') <>''                                                
			AND NOT EXISTS (SELECT DISP_DEMRM_ID FROM  DMAT_DISPATCH WHERE DISP_DEMRM_ID = DEMRM_ID AND DISP_TO = 'C')                                           
			AND DEMRM_DELETED_IND = 0
			AND DPAM_DELETED_IND = 1
			union all
			SELECT DEMRM_ID ID,DEMRM_ISIN ISIN                                                
			,DEMRM_SLIP_SERIAL_NO   DRF_NO                                               
			,DEMRM_SLIP_SERIAL_NO        SLIP_SERIAL_NO                                            
			,CONVERT(VARCHAR,DEMRM_REQUEST_DT,103)   REQUEST_DT          
			,CONVERT(VARCHAR,DEMRM_EXECUTION_DT,103) EXECUTION_DT                                              
			,Convert(numeric(18,3),DEMRM_QTY) QTY                                             
			,DPAM_SBA_NO                                            
			,DPAM_SBA_NAME                                            
			--,ISNULL(DEMRM_TRANSACTION_NO,'') DRN_NO                                            
			,'' DRN_NO
			,'' DISP_DT                                          
			,'' DISP_DOC_ID                                          
			,'' DISP_NAME                                          
			,'' DISP_ID 
			,'' disp_cons_no   
			FROM DEMAT_REQUEST_MSTR,DP_ACCT_MSTR                                                  
			WHERE DEMRM_DPAM_ID =  DPAM_ID
			AND DPAM_DPM_ID = @l_dpm_dpid
			AND ISNULL(DEMRM_INTERNAL_REJ,'') <>''                                                
			AND NOT EXISTS (SELECT DISP_DEMRM_ID FROM  DMAT_DISPATCH WHERE DISP_DEMRM_ID = DEMRM_ID AND DISP_TO = 'C')                                           
			AND DEMRM_DELETED_IND = 1 --and isnull(DEMRM_TRANSACTION_NO,'0')<>'0'
			AND DPAM_DELETED_IND = 1 and isnull(DEMRM_ERRMSG,'')<>''
      END                                               
      ELSE IF @PA_SEARCH_C2= 'CO'                                                   
      BEGIN                                                 
--			SELECT DEMRM_ID ID,DEMRM_ISIN ISIN                                                
--			,DEMRM_SLIP_SERIAL_NO   DRF_NO                                               
--			,DEMRM_SLIP_SERIAL_NO        SLIP_SERIAL_NO                                            
--			,CONVERT(VARCHAR,DEMRM_REQUEST_DT,103)   REQUEST_DT          
--			,CONVERT(VARCHAR,DEMRM_EXECUTION_DT,103) EXECUTION_DT                                              
--			,Convert(numeric(18,3),DEMRM_QTY)     QTY                                             
--			,DPAM_SBA_NO                                            
--			,DPAM_SBA_NAME                                            
--			,ISNULL(DEMRM_TRANSACTION_NO,'') DRN_NO                                            
--			,'' DISP_DT                                          
--			,'' DISP_DOC_ID                                          
--			,'' DISP_NAME                                          
--			,'' DISP_ID 
--			,'' disp_cons_no   
--			FROM DEMAT_REQUEST_MSTR,DP_ACCT_MSTR                       
--			WHERE DEMRM_DPAM_ID =  DPAM_ID  			 
--			AND DPAM_DPM_ID = @l_dpm_dpid
--			AND ISNULL(DEMRM_COMPANY_OBJ,'') <>''                                                
--			AND NOT EXISTS (SELECT DISP_DEMRM_ID FROM  DMAT_DISPATCH WHERE DISP_DEMRM_ID = DEMRM_ID AND DISP_TO = 'C')                                           
--			AND DEMRM_DELETED_IND = 1
--			AND DPAM_DELETED_IND = 1
SELECT DEMRM_ID ID,DEMRM_ISIN ISIN                                                
			,DEMRM_SLIP_SERIAL_NO   DRF_NO                                               
			,DEMRM_SLIP_SERIAL_NO        SLIP_SERIAL_NO                                            
			,CONVERT(VARCHAR,DEMRM_REQUEST_DT,103)   REQUEST_DT          
			,CONVERT(VARCHAR,DEMRM_EXECUTION_DT,103) EXECUTION_DT                                              
			,Convert(numeric(18,3),DEMRM_QTY)     QTY                                             
			,DPAM_SBA_NO                                            
			,DPAM_SBA_NAME                                            
			--,ISNULL(DEMRM_TRANSACTION_NO,'') DRN_NO 
			,ISNULL(DEMRM_TRANSACTION_NO,'') DRN_NO                                           
			,'' DISP_DT                                          
			,'' DISP_DOC_ID                                          
			,'' DISP_NAME                                          
			,'' DISP_ID 
			,'' disp_cons_no   
			FROM DEMAT_REQUEST_MSTR,DP_ACCT_MSTR                       
			WHERE DEMRM_DPAM_ID =  DPAM_ID  			 
			AND DPAM_DPM_ID = @l_dpm_dpid
			AND ISNULL(DEMRM_COMPANY_OBJ,'') <>''  
			--and demrm_slip_Serial_no =  @pa_search_c9
			and demrm_slip_Serial_no like case when @pa_search_c9 = '' then '%' else @pa_search_c9 end 
			AND NOT EXISTS (SELECT DISP_DEMRM_ID FROM  DMAT_DISPATCH WHERE DISP_DEMRM_ID = DEMRM_ID AND DISP_TO = 'C')                                           
			AND DEMRM_DELETED_IND = 1
			AND DPAM_DELETED_IND = 1
      END                                                
  --              
  end               
  else if @pa_search_c10 ='remat'              
  begin                   
  --                                             
      IF @PA_SEARCH_C2= 'ALL'                                                   
      BEGIN                                                   
				SELECT REMRM_ID ID,REMRM_ISIN        ISIN                                         
				,REMRM_SLIP_SERIAL_NO    DRF_NO                                               
				,REMRM_SLIP_SERIAL_NO       SLIP_SERIAL_NO                                          
				,CONVERT(VARCHAR,REMRM_REQUEST_DT,103)   REQUEST_DT                                              
				,CONVERT(VARCHAR,REMRM_EXECUTION_DT,103)  EXECUTION_DT                                              
				,Convert(numeric(18,3),REMRM_QTY)    QTY                                            
				,DPAM_SBA_NO                                            
				,DPAM_SBA_NAME                                            
				,ISNULL(REMRM_TRANSACTION_NO,'') DRN_NO                                            
				,''  DISP_DT                                        
				,''  DISP_DOC_ID                                         
				,''  DISP_NAME                                        
				,''  DISP_ID 
				,'' disp_cons_no     
				FROM REMAT_REQUEST_MSTR,DP_ACCT_MSTR                                               
				WHERE REMRM_DPAM_ID =  DPAM_ID 
				AND DPAM_DPM_ID = @l_dpm_dpid
				AND  NOT EXISTS (SELECT DISPR_REMRM_ID FROM  DMAT_DISPATCH_REMAT WHERE DISPR_REMRM_ID = REMRM_ID AND DISPR_TO = 'C')                                           
				AND (ISNULL(REMRM_INTERNAL_REJ,'') <> '' OR ISNULL(REMRM_COMPANY_OBJ,'') <>'')                                          
				AND REMRM_DELETED_IND = 1
				AND DPAM_DELETED_IND = 1           
                   
      END                               
      ELSE IF @PA_SEARCH_C2= 'IR'                                                   
      BEGIN                                                 
				SELECT REMRM_ID ID,REMRM_ISIN        ISIN                                         
				,REMRM_SLIP_SERIAL_NO    DRF_NO                                               
				,REMRM_SLIP_SERIAL_NO       SLIP_SERIAL_NO                                          
				,CONVERT(VARCHAR,REMRM_REQUEST_DT,103)   REQUEST_DT                                              
				,CONVERT(VARCHAR,REMRM_EXECUTION_DT,103)  EXECUTION_DT                                              
				,Convert(numeric(18,3),REMRM_QTY)    QTY                                            
				,DPAM_SBA_NO                                            
				,DPAM_SBA_NAME                                            
				,ISNULL(REMRM_TRANSACTION_NO,'') DRN_NO                                            
				,''  DISP_DT                                         
				,''   DISP_DOC_ID                                        
				,''   DISP_NAME                                        
				,''     DISP_ID 
				,'' disp_cons_no     
				FROM REMAT_REQUEST_MSTR,DP_ACCT_MSTR                                                  
				WHERE  REMRM_DPAM_ID =  DPAM_ID 
				AND DPAM_DPM_ID = @l_dpm_dpid
				AND  ISNULL(REMRM_INTERNAL_REJ,'') <>''                                                
				AND  NOT EXISTS (SELECT DISPR_REMRM_ID FROM  DMAT_DISPATCH_REMAT WHERE DISPR_REMRM_ID = REMRM_ID AND DISPR_TO = 'C')                                           
				AND REMRM_DELETED_IND = 1
				AND DPAM_DELETED_IND = 1     
      END                                               
      ELSE IF @PA_SEARCH_C2= 'CO'                                                   
      BEGIN                                                 
				SELECT REMRM_ID ID,REMRM_ISIN        ISIN                                         
				,REMRM_SLIP_SERIAL_NO    DRF_NO                                               
				,REMRM_SLIP_SERIAL_NO       SLIP_SERIAL_NO                                          
				,CONVERT(VARCHAR,REMRM_REQUEST_DT,103)   REQUEST_DT                                              
				,CONVERT(VARCHAR,REMRM_EXECUTION_DT,103)  EXECUTION_DT                                              
				,Convert(numeric(18,3),REMRM_QTY)    QTY                                            
				,DPAM_SBA_NO                                            
				,DPAM_SBA_NAME                                            
				,ISNULL(REMRM_TRANSACTION_NO,'') DRN_NO                                            
				,''     DISP_DT                                      
				,''     DISP_DOC_ID                                      
				,''    DISP_NAME                                       
				,''     DISP_ID 
				,'' disp_cons_no     
				FROM REMAT_REQUEST_MSTR,DP_ACCT_MSTR                                                   
				WHERE   REMRM_DPAM_ID =  DPAM_ID
				AND DPAM_DPM_ID = @l_dpm_dpid
				AND ISNULL(REMRM_COMPANY_OBJ,'') <>''                                                
				AND  NOT EXISTS (SELECT DISPR_REMRM_ID FROM  DMAT_DISPATCH_REMAT WHERE DISPR_REMRM_ID = REMRM_ID AND DISPR_TO = 'C')                                           
				AND REMRM_DELETED_IND = 1
				AND DPAM_DELETED_IND = 1                                 
      END                                                
  --              
  end               
                            
--                                                                
END                                             
ELSE IF @PA_ACTION = 'DISP_REJECT_SEARCH'                                                                
BEGIN                                                                
--                    
  IF @PA_SEARCH_C10 ='DEMAT'              
  BEGIN                                              
      IF @PA_SEARCH_C5= 'IR'                                                     
      BEGIN                                
--				SELECT DEMRM_ID ID,DEMRM_ISIN ISIN,DEMRM_SLIP_SERIAL_NO DRF_NO,DEMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO,ISNULL(DEMRM_TRANSACTION_NO,'') DRN_NO                                                
--				,CONVERT(VARCHAR,ISNULL(DEMRM_REQUEST_DT,''),103) REQUEST_DT ,DPAM_SBA_NO , DISP_ID                                          
--				,DPAM_SBA_NAME,CONVERT(VARCHAR,ISNULL(DEMRM_EXECUTION_DT,''),103) EXECUTION_DT ,Convert(numeric(18,3),DEMRM_QTY) QTY, ISNULL(DISP_TYPE,'') DISP_TYPE                                               
--				,CONVERT(VARCHAR,DISP_DT,103) DISP_DT,ISNULL(DISP_DOC_ID,'0') DISP_DOC_ID,ISNULL(DISP_NAME,'') DISP_NAME,ISNULL(DISP_CONF_RECD,'') DISP_CONF_RECD                                                 
--				,disp_cons_no      
--				FROM DMAT_DISPATCH , DEMAT_REQUEST_MSTR , DP_ACCT_MSTR  
--				WHERE DEMRM_DPAM_ID = DPAM_ID 
--				AND DPAM_DPM_ID = @l_dpm_dpid
--				AND DEMRM_ID = DISP_DEMRM_ID AND ISNULL(DISP_TO,'') = 'C'                                                
--				AND ISNULL(DEMRM_INTERNAL_REJ,'') <>''                                                
----				AND CONVERT(VARCHAR,ISNULL(DISP_DT,''),103) LIKE CASE WHEN @PA_SEARCH_C2 <> '' THEN @PA_SEARCH_C2 +'%' ELSE '%' END                                   
----				AND CASE WHEN @PA_SEARCH_C3 <> '' THEN @PA_SEARCH_C3 ELSE '' END = CASE WHEN @PA_SEARCH_C3 <> '' THEN disp_cons_no ELSE '' END              
----				AND ISNULL(DISP_NAME,'') LIKE CASE WHEN @PA_SEARCH_C4 <> '' THEN @PA_SEARCH_C4  ELSE '%' END                      
--				AND DEMRM_DELETED_IND = 1
--				AND DPAM_DELETED_IND = 1 
                                        
				SELECT DEMRM_ID ID,DEMRM_ISIN ISIN,DEMRM_SLIP_SERIAL_NO DRF_NO,DEMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO,'' DRN_NO                                                
				,CONVERT(VARCHAR,ISNULL(DEMRM_REQUEST_DT,''),103) REQUEST_DT ,DPAM_SBA_NO , DISP_ID                                          
				,DPAM_SBA_NAME,CONVERT(VARCHAR,ISNULL(DEMRM_EXECUTION_DT,''),103) EXECUTION_DT ,Convert(numeric(18,3),DEMRM_QTY) QTY, ISNULL(DISP_TYPE,'') DISP_TYPE                                               
				,CONVERT(VARCHAR,DISP_DT,103) DISP_DT,ISNULL(DISP_DOC_ID,'0') DISP_DOC_ID,ISNULL(DISP_NAME,'') DISP_NAME,ISNULL(DISP_CONF_RECD,'') DISP_CONF_RECD                                                 
				,disp_cons_no      
				FROM DMAT_DISPATCH , demrm_mak , DP_ACCT_MSTR  
				WHERE DEMRM_DPAM_ID = DPAM_ID 
				AND DPAM_DPM_ID = @l_dpm_dpid
				AND DEMRM_ID = DISP_DEMRM_ID AND ISNULL(DISP_TO,'') = 'C'                                                
				AND ISNULL(demrm_res_cd_intobj,'') <>''                                                 
--				AND CONVERT(VARCHAR,ISNULL(DISP_DT,''),103) LIKE CASE WHEN @PA_SEARCH_C2 <> '' THEN @PA_SEARCH_C2 +'%' ELSE '%' END                                   
--				AND CASE WHEN @PA_SEARCH_C3 <> '' THEN @PA_SEARCH_C3 ELSE '' END = CASE WHEN @PA_SEARCH_C3 <> '' THEN disp_cons_no ELSE '' END              
--				AND ISNULL(DISP_NAME,'') LIKE CASE WHEN @PA_SEARCH_C4 <> '' THEN @PA_SEARCH_C4  ELSE '%' END                      
			    and disp_cons_no like case when isnull(@PA_SEARCH_C3,'') <> '' then @PA_SEARCH_C3 else '%'  end
				AND DEMRM_DELETED_IND = 0
				AND DPAM_DELETED_IND = 1    
      END                      
      IF @PA_SEARCH_C5= 'CO'                                                     
      BEGIN                                                
--				SELECT DEMRM_ID ID,DEMRM_ISIN ISIN,DEMRM_SLIP_SERIAL_NO DRF_NO,DEMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO,ISNULL(DEMRM_TRANSACTION_NO,'') DRN_NO                                                
--				,CONVERT(VARCHAR,ISNULL(DEMRM_REQUEST_DT,''),103) REQUEST_DT ,DPAM_SBA_NO , DISP_ID                                          
--				,DPAM_SBA_NAME,CONVERT(VARCHAR,ISNULL(DEMRM_EXECUTION_DT,''),103) EXECUTION_DT ,Convert(numeric(18,3),DEMRM_QTY) QTY, ISNULL(DISP_TYPE,'') DISP_TYPE                                               
--				,CONVERT(VARCHAR,DISP_DT,103) DISP_DT,ISNULL(DISP_DOC_ID,'0') DISP_DOC_ID,ISNULL(DISP_NAME,'') DISP_NAME,ISNULL(DISP_CONF_RECD,'') DISP_CONF_RECD                                                 
--				,disp_cons_no         
--				FROM DMAT_DISPATCH , DEMAT_REQUEST_MSTR  , DP_ACCT_MSTR  
--				WHERE DEMRM_DPAM_ID = DPAM_ID 
--				AND DPAM_DPM_ID = @l_dpm_dpid
--				AND  DEMRM_ID = DISP_DEMRM_ID                                            
--				AND ISNULL(DEMRM_COMPANY_OBJ,'') <>''                                                
--				AND  DISP_TO ='C'                                             
--				AND CONVERT(VARCHAR,ISNULL(DISP_DT,''),103) LIKE CASE WHEN @PA_SEARCH_C2 <> '' THEN @PA_SEARCH_C2  ELSE '%' END                               
--				AND CASE WHEN @PA_SEARCH_C3 <> '' THEN @PA_SEARCH_C3 ELSE '' END = CASE WHEN @PA_SEARCH_C3 <> '' THEN disp_cons_no ELSE '' END              
--				AND ISNULL(DISP_NAME,'') LIKE CASE WHEN @PA_SEARCH_C4 <> '' THEN @PA_SEARCH_C4  ELSE '%' END                      
--				AND DEMRM_DELETED_IND = 1
--				AND DPAM_DELETED_IND = 1   
				SELECT DEMRM_ID ID,DEMRM_ISIN ISIN,DEMRM_SLIP_SERIAL_NO DRF_NO,DEMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO,demrm_transaction_no DRN_NO                                                
				,CONVERT(VARCHAR,ISNULL(DEMRM_REQUEST_DT,''),103) REQUEST_DT ,DPAM_SBA_NO , DISP_ID                                          
				,DPAM_SBA_NAME,CONVERT(VARCHAR,ISNULL(DEMRM_EXECUTION_DT,''),103) EXECUTION_DT ,Convert(numeric(18,3),DEMRM_QTY) QTY, ISNULL(DISP_TYPE,'') DISP_TYPE                                               
				,CONVERT(VARCHAR,DISP_DT,103) DISP_DT,ISNULL(DISP_DOC_ID,'0') DISP_DOC_ID,ISNULL(DISP_NAME,'') DISP_NAME,ISNULL(DISP_CONF_RECD,'') DISP_CONF_RECD                                                 
				,disp_cons_no         
				FROM DMAT_DISPATCH ,demat_request_mstr --, demrm_mak  --changed on 29 apr 2013 as per requi.
					, DP_ACCT_MSTR  
				WHERE DEMRM_DPAM_ID = DPAM_ID 
				AND DPAM_DPM_ID = @l_dpm_dpid
				AND  DEMRM_ID = DISP_DEMRM_ID                                            
				--AND ISNULL(demrm_res_cd_compobj,'') <>''                                                
				and isnull(DEMRM_COMPANY_OBJ,'') <> ''
				AND  DISP_TO ='C'                                             
				AND CONVERT(VARCHAR,ISNULL(DISP_DT,''),103) LIKE CASE WHEN @PA_SEARCH_C2 <> '' THEN @PA_SEARCH_C2  ELSE '%' END                               
				AND CASE WHEN @PA_SEARCH_C3 <> '' THEN @PA_SEARCH_C3 ELSE '' END = CASE WHEN @PA_SEARCH_C3 <> '' THEN disp_cons_no ELSE '' END              
				AND ISNULL(DISP_NAME,'') LIKE CASE WHEN @PA_SEARCH_C4 <> '' THEN @PA_SEARCH_C4  ELSE '%' END  
				and disp_cons_no like case when isnull(@PA_SEARCH_C3,'') <> '' then @PA_SEARCH_C3 else '%'  end                    
				--AND DEMRM_DELETED_IND = 0
				AND DEMRM_DELETED_IND = 1  -- changed on 29 apr 2013 as per requi.
				AND DPAM_DELETED_IND = 1                                          
      END                                                
      IF @PA_SEARCH_C5= 'ALL'                                     
      BEGIN                                                
				SELECT DEMRM_ID ID,DEMRM_ISIN ISIN,DEMRM_SLIP_SERIAL_NO DRF_NO,DEMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO,'' DRN_NO                                                
				,CONVERT(VARCHAR,ISNULL(DEMRM_REQUEST_DT,''),103) REQUEST_DT ,DPAM_SBA_NO , DISP_ID                                          
				,DPAM_SBA_NAME,CONVERT(VARCHAR,ISNULL(DEMRM_EXECUTION_DT,''),103) EXECUTION_DT ,Convert(numeric(18,3),DEMRM_QTY) QTY, ISNULL(DISP_TYPE,'') DISP_TYPE                                               
				,CONVERT(VARCHAR,DISP_DT,103) DISP_DT,ISNULL(DISP_DOC_ID,'0') DISP_DOC_ID,ISNULL(DISP_NAME,'') DISP_NAME,ISNULL(DISP_CONF_RECD,'') DISP_CONF_RECD                                                 
				,disp_cons_no     
				FROM DMAT_DISPATCH , demrm_mak  , DP_ACCT_MSTR  
				WHERE DEMRM_DPAM_ID = DPAM_ID 
				AND DPAM_DPM_ID = @l_dpm_dpid
				AND DEMRM_ID = DISP_DEMRM_ID                                          
				AND DISP_TO ='C'                                                 
				AND CONVERT(VARCHAR,DISP_DT,103) LIKE CASE WHEN @PA_SEARCH_C2 <> '' THEN @PA_SEARCH_C2  ELSE '%' END                                      
				AND CASE WHEN @PA_SEARCH_C3 <> '' THEN @PA_SEARCH_C3 ELSE '' END = CASE WHEN @PA_SEARCH_C3 <> '' THEN disp_cons_no ELSE '' END              
				AND ISNULL(DISP_NAME,'') LIKE CASE WHEN @PA_SEARCH_C4 <> '' THEN @PA_SEARCH_C4  ELSE '%' END                  
				AND DEMRM_DELETED_IND = 0
				AND DPAM_DELETED_IND = 1                                          
      END                   
  --              
  END               
  ELSE IF @PA_SEARCH_C10 ='REMAT'              
  BEGIN                                              
      IF @PA_SEARCH_C5= 'IR'  
      BEGIN                                                
				SELECT REMRM_ID ID,REMRM_ISIN ISIN,REMRM_SLIP_SERIAL_NO DRF_NO,REMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO,ISNULL(REMRM_TRANSACTION_NO,'') DRN_NO                                                
				,CONVERT(VARCHAR,ISNULL(REMRM_REQUEST_DT,''),103) REQUEST_DT ,DPAM_SBA_NO , DISPR_ID      DISP_ID                                    
				,DPAM_SBA_NAME,CONVERT(VARCHAR,ISNULL(REMRM_EXECUTION_DT,''),103) EXECUTION_DT ,Convert(numeric(18,3),REMRM_QTY) QTY, ISNULL(DISPR_TYPE,'') DISP_TYPE                                               
				,CONVERT(VARCHAR,DISPR_DT,103) DISP_DT,ISNULL(DISPR_DOC_ID,'0') DISP_DOC_ID,ISNULL(DISPR_NAME,'') DISP_NAME,ISNULL(DISPR_CONF_RECD,'') DISP_CONF_RECD                                                 
				,dispr_cons_no      
				FROM DMAT_DISPATCH_REMAT , REMAT_REQUEST_MSTR , DP_ACCT_MSTR  
				WHERE REMRM_DPAM_ID = DPAM_ID 
				AND DPAM_DPM_ID = @l_dpm_dpid
				AND REMRM_ID = DISPR_REMRM_ID                                               
				AND ISNULL(REMRM_INTERNAL_REJ,'') <>''                                                
				AND  DISPR_TO = 'C'                                              
				AND CONVERT(VARCHAR,ISNULL(DISPR_DT,''),103) LIKE CASE WHEN @PA_SEARCH_C2 <> '' THEN @PA_SEARCH_C2  ELSE '%' END                                   
				AND CASE WHEN @PA_SEARCH_C3 <> '' THEN @PA_SEARCH_C3 ELSE '' END = CASE WHEN @PA_SEARCH_C3 <> '' THEN dispr_cons_no ELSE '' END              
				AND ISNULL(DISPR_NAME,'') LIKE CASE WHEN @PA_SEARCH_C4 <> '' THEN @PA_SEARCH_C4  ELSE '%' END                      
				AND REMRM_DELETED_IND = 1
				AND DPAM_DELETED_IND = 1                                        
      END                                                
      IF @PA_SEARCH_C5= 'CO'  
      BEGIN                                                
				SELECT REMRM_ID ID,REMRM_ISIN ISIN,REMRM_SLIP_SERIAL_NO DRF_NO,REMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO,ISNULL(REMRM_TRANSACTION_NO,'') DRN_NO                                                
				,CONVERT(VARCHAR,ISNULL(REMRM_REQUEST_DT,''),103) REQUEST_DT ,DPAM_SBA_NO , DISPR_ID  DISP_ID                                        
				,DPAM_SBA_NAME,CONVERT(VARCHAR,ISNULL(REMRM_EXECUTION_DT,''),103) EXECUTION_DT ,Convert(numeric(18,3),REMRM_QTY) QTY, ISNULL(DISPR_TYPE,'') DISP_TYPE                                               
				,CONVERT(VARCHAR,DISPR_DT,103) DISP_DT,ISNULL(DISPR_DOC_ID,'0') DISP_DOC_ID,ISNULL(DISPR_NAME,'') DISP_NAME,ISNULL(DISPR_CONF_RECD,'') DISP_CONF_RECD                                                 
				,dispr_cons_no    
				FROM DMAT_DISPATCH_REMAT , REMAT_REQUEST_MSTR  , DP_ACCT_MSTR  
				WHERE REMRM_DPAM_ID = DPAM_ID 
				AND DPAM_DPM_ID = @l_dpm_dpid
				AND REMRM_ID = DISPR_REMRM_ID 
				AND ISNULL(REMRM_COMPANY_OBJ,'') <> ''                                                
				AND  DISPR_TO = 'C'                                              
				AND CONVERT(VARCHAR,ISNULL(DISPR_DT,''),103) LIKE CASE WHEN @PA_SEARCH_C2 <> '' THEN @PA_SEARCH_C2  ELSE '%' END                               
				AND CASE WHEN @PA_SEARCH_C3 <> '' THEN @PA_SEARCH_C3 ELSE '' END = CASE WHEN @PA_SEARCH_C3 <> '' THEN dispr_cons_no ELSE '' END              
				AND ISNULL(DISPR_NAME,'') LIKE CASE WHEN @PA_SEARCH_C4 <> '' THEN @PA_SEARCH_C4  ELSE '%' END                      
				AND REMRM_DELETED_IND = 1
				AND DPAM_DELETED_IND = 1                         
      END                                                
      IF @PA_SEARCH_C5= 'ALL'                                     
      BEGIN                                                
				SELECT REMRM_ID ID,REMRM_ISIN ISIN,REMRM_SLIP_SERIAL_NO DRF_NO,REMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO,ISNULL(REMRM_TRANSACTION_NO,'') DRN_NO                                                
				,CONVERT(VARCHAR,ISNULL(REMRM_REQUEST_DT,''),103) REQUEST_DT ,DPAM_SBA_NO , DISPR_ID  DISP_ID                                        
				,DPAM_SBA_NAME,CONVERT(VARCHAR,ISNULL(REMRM_EXECUTION_DT,''),103) EXECUTION_DT ,Convert(numeric(18,3),REMRM_QTY) QTY, ISNULL(DISPR_TYPE,'') DISP_TYPE                                               
				,CONVERT(VARCHAR,DISPR_DT,103) DISP_DT,ISNULL(DISPR_DOC_ID,'0') DISP_DOC_ID,ISNULL(DISPR_NAME,'') DISP_NAME,ISNULL(DISPR_CONF_RECD,'') DISP_CONF_RECD                                                 
				,dispr_cons_no     
				FROM DMAT_DISPATCH_REMAT , REMAT_REQUEST_MSTR  , DP_ACCT_MSTR  
				WHERE REMRM_DPAM_ID = DPAM_ID 
				AND DPAM_DPM_ID = @l_dpm_dpid
				AND  REMRM_ID = DISPR_REMRM_ID 
				AND  DISPR_TO = 'C'                                                    
				AND CONVERT(VARCHAR,DISPR_DT,103) LIKE CASE WHEN @PA_SEARCH_C2 <> '' THEN @PA_SEARCH_C2  ELSE '%' END                                      
				AND CASE WHEN @PA_SEARCH_C3 <> '' THEN @PA_SEARCH_C3 ELSE '' END = CASE WHEN @PA_SEARCH_C3 <> '' THEN dispr_cons_no ELSE '' END              
				AND ISNULL(DISPR_NAME,'') LIKE CASE WHEN @PA_SEARCH_C4 <> '' THEN @PA_SEARCH_C4  ELSE '%' END                  
				AND REMRM_DELETED_IND = 1
				AND DPAM_DELETED_IND = 1    
      END                   
  --              
  END              
                                             
--                                                                
END                                                  
ELSE IF @PA_ACTION = 'REJECTIONLIST'                                                                
BEGIN                                                                
--                                                       
  --SELECT * FROM [FN_GETSUBTRANSDTLS]('DEMAT_REJ_CD_NSDL')                                                   

SELECT  TRASTM_CD AS CD
,TRASTM_DESC AS DESCP 
--,  TRASTM_ID  
  FROM  TRANSACTION_TYPE_MSTR,    
        TRANSACTION_SUB_TYPE_MSTR    
  WHERE TRANTM_CODE =  'DEMAT_REJ_CD_NSDL'    
  AND TRANTM_ID   =  TRASTM_TRATM_ID 
  order by TRASTM_DESC
--                                                                
END                                                            
ELSE IF @PA_ACTION = 'DISP_MARK_CONF'                                   
BEGIN                                                                
--                
  IF @PA_SEARCH_C10 ='DEMAT'                 
  BEGIN              
      IF @PA_SEARCH_C2 <> ''                 
      BEGIN                    
      --                                             
      IF @PA_SEARCH_C4= 'IR'                                                     
      BEGIN                                                
			SELECT DEMRM_ID ID,DEMRM_ISIN ISIN,DEMRM_SLIP_SERIAL_NO DRF_NO ,DEMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO                                               
			,ISNULL(CONVERT(VARCHAR,DEMRM_REQUEST_DT,103),'') REQUEST_DT ,ISNULL(DEMRM_EXECUTION_DT,'') EXECUTION_DT,Convert(numeric(18,3),DEMRM_QTY) QTY, ISNULL(DISP_TYPE,'')                                                
			,CONVERT(VARCHAR,DISP_DT,103),ISNULL(DISP_DOC_ID,'0'),ISNULL(DISP_NAME,''),ISNULL(DISP_CONF_RECD,'') DISP_CONF_RECD                                                
			FROM DMAT_DISPATCH , DEMAT_REQUEST_MSTR,DP_ACCT_MSTR  
			WHERE DEMRM_ID = DISP_DEMRM_ID 
			AND DEMRM_DPAM_ID = DPAM_ID 
			AND DPAM_DPM_ID = @l_dpm_dpid
			AND ISNULL(DISP_TO,'') = 'C'    
			AND ISNULL(DISP_CONF_RECD,'') = ''
			AND ISNULL(DEMRM_INTERNAL_REJ,'') <>''                                                
			AND DISP_DT BETWEEN CONVERT(DATETIME,@PA_SEARCH_C2+ ' 00:00:00:000',103) AND CONVERT(DATETIME,@PA_SEARCH_C3+ ' 23:59:59:999',103)                                                 
			AND DEMRM_DELETED_IND = 1
			AND DPAM_DELETED_IND = 1                 
                                        
      END                                                
      IF @PA_SEARCH_C4= 'CO'                                                     
      BEGIN                      
			SELECT DEMRM_ID ID,DEMRM_ISIN ISIN,DEMRM_SLIP_SERIAL_NO DRF_NO ,DEMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO                                               
			,ISNULL(CONVERT(VARCHAR,DEMRM_REQUEST_DT,103),'') REQUEST_DT ,ISNULL(DEMRM_EXECUTION_DT,'') EXECUTION_DT,Convert(numeric(18,3),DEMRM_QTY) QTY, ISNULL(DISP_TYPE,'')                                                
			,CONVERT(VARCHAR,DISP_DT,103),ISNULL(DISP_DOC_ID,'0'),ISNULL(DISP_NAME,''),ISNULL(DISP_CONF_RECD,'') DISP_CONF_RECD                                                
			FROM DMAT_DISPATCH , DEMAT_REQUEST_MSTR,DP_ACCT_MSTR
			WHERE DEMRM_ID = DISP_DEMRM_ID 
			AND DEMRM_DPAM_ID = DPAM_ID 
			AND DPAM_DPM_ID = @l_dpm_dpid
			AND ISNULL(DISP_TO,'') = 'C'     
			AND ISNULL(DISP_CONF_RECD,'') = ''                                           
			AND ISNULL(DEMRM_COMPANY_OBJ,'') <>''                                                
			AND DISP_DT BETWEEN CONVERT(DATETIME,@PA_SEARCH_C2+ ' 00:00:00:000',103) AND CONVERT(DATETIME,@PA_SEARCH_C3+ ' 23:59:59:999',103)                                                  
			AND DEMRM_DELETED_IND = 1
			AND DPAM_DELETED_IND = 1     
      END                                                
      IF @PA_SEARCH_C4= 'ALL'                                                     
      BEGIN                                                
			SELECT DEMRM_ID ID,DEMRM_ISIN ISIN,DEMRM_SLIP_SERIAL_NO DRF_NO ,DEMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO                                               
			,ISNULL(CONVERT(VARCHAR,DEMRM_REQUEST_DT,103),'') REQUEST_DT ,ISNULL(DEMRM_EXECUTION_DT,'') EXECUTION_DT,Convert(numeric(18,3),DEMRM_QTY) QTY, ISNULL(DISP_TYPE,'')                                                
			,CONVERT(VARCHAR,DISP_DT,103),ISNULL(DISP_DOC_ID,'0'),ISNULL(DISP_NAME,''),ISNULL(DISP_CONF_RECD,'') DISP_CONF_RECD                                           
			FROM DMAT_DISPATCH , DEMAT_REQUEST_MSTR,DP_ACCT_MSTR  
			WHERE DEMRM_ID = DISP_DEMRM_ID 
			AND DEMRM_DPAM_ID = DPAM_ID 
			AND DPAM_DPM_ID = @l_dpm_dpid
			AND ISNULL(DISP_CONF_RECD,'') = ''
			AND ISNULL(DISP_TO,'') = 'C'                                            
			AND DISP_DT BETWEEN CONVERT(DATETIME,@PA_SEARCH_C2+ ' 00:00:00:000',103) AND CONVERT(DATETIME,@PA_SEARCH_C3+ ' 23:59:59:999',103)                
			AND DEMRM_DELETED_IND = 1
			AND DPAM_DELETED_IND = 1                                               
      END                                                
      --                   
      END 
      ELSE
      BEGIN
      IF @PA_SEARCH_C4= 'IR'                                                     
      BEGIN                                                
			SELECT DEMRM_ID ID,DEMRM_ISIN ISIN,DEMRM_SLIP_SERIAL_NO DRF_NO ,DEMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO                                               
			,ISNULL(CONVERT(VARCHAR,DEMRM_REQUEST_DT,103),'') REQUEST_DT ,ISNULL(DEMRM_EXECUTION_DT,'') EXECUTION_DT,Convert(numeric(18,3),DEMRM_QTY) QTY, ISNULL(DISP_TYPE,'')                                                
			,CONVERT(VARCHAR,DISP_DT,103),ISNULL(DISP_DOC_ID,'0'),ISNULL(DISP_NAME,''),ISNULL(DISP_CONF_RECD,'') DISP_CONF_RECD                                                   
			FROM DMAT_DISPATCH , DEMAT_REQUEST_MSTR,DP_ACCT_MSTR  
			WHERE DEMRM_ID = DISP_DEMRM_ID 
			AND DEMRM_DPAM_ID = DPAM_ID 
			AND DPAM_DPM_ID = @l_dpm_dpid
			AND ISNULL(DISP_TO,'') = 'C'         
			AND ISNULL(DISP_CONF_RECD,'') = ''                                       
			AND ISNULL(DEMRM_INTERNAL_REJ,'') <>''                                                
			AND DEMRM_DELETED_IND = 1
			AND DPAM_DELETED_IND = 1                           
      END                                                
      IF @PA_SEARCH_C4= 'CO'                                                     
      BEGIN                      
			SELECT DEMRM_ID ID,DEMRM_ISIN ISIN,DEMRM_SLIP_SERIAL_NO DRF_NO ,DEMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO                                               
			,ISNULL(CONVERT(VARCHAR,DEMRM_REQUEST_DT,103),'') REQUEST_DT ,ISNULL(DEMRM_EXECUTION_DT,'') EXECUTION_DT,Convert(numeric(18,3),DEMRM_QTY) QTY, ISNULL(DISP_TYPE,'')                                                
			,CONVERT(VARCHAR,DISP_DT,103),ISNULL(DISP_DOC_ID,'0'),ISNULL(DISP_NAME,''),ISNULL(DISP_CONF_RECD,'') DISP_CONF_RECD                                             
			FROM DMAT_DISPATCH , DEMAT_REQUEST_MSTR,DP_ACCT_MSTR
			WHERE DEMRM_ID = DISP_DEMRM_ID 
			AND DEMRM_DPAM_ID = DPAM_ID 
			AND DPAM_DPM_ID = @l_dpm_dpid
			AND ISNULL(DISP_TO,'') = 'C'                                                
			AND ISNULL(DEMRM_COMPANY_OBJ,'') <>''                                                
			AND ISNULL(DISP_CONF_RECD,'') = ''                   
			AND DEMRM_DELETED_IND = 1
			AND DPAM_DELETED_IND = 1                                                  
      END                                                
      IF @PA_SEARCH_C4= 'ALL'                                                     
      BEGIN                                                
			SELECT DEMRM_ID ID,DEMRM_ISIN ISIN,DEMRM_SLIP_SERIAL_NO DRF_NO ,DEMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO                                               
			,ISNULL(CONVERT(VARCHAR,DEMRM_REQUEST_DT,103),'') REQUEST_DT ,ISNULL(DEMRM_EXECUTION_DT,'') EXECUTION_DT,Convert(numeric(18,3),DEMRM_QTY) QTY, ISNULL(DISP_TYPE,'')                                                
			,CONVERT(VARCHAR,DISP_DT,103),ISNULL(DISP_DOC_ID,'0'),ISNULL(DISP_NAME,''),ISNULL(DISP_CONF_RECD,'') DISP_CONF_RECD                                        
			FROM DMAT_DISPATCH , DEMAT_REQUEST_MSTR,DP_ACCT_MSTR  
			WHERE DEMRM_ID = DISP_DEMRM_ID 
			AND DEMRM_DPAM_ID = DPAM_ID 
			AND DPAM_DPM_ID = @l_dpm_dpid
			AND ISNULL(DISP_TO,'') = 'C'                                            
			AND ISNULL(DISP_CONF_RECD,'') = ''  
			AND DEMRM_DELETED_IND = 1
			AND DPAM_DELETED_IND = 1                              
                                             
      END     
      END                
  --              
  END               
  ELSE IF @PA_SEARCH_C10 ='REMAT'                 
  BEGIN              
      IF @PA_SEARCH_C2 <> ''                 
      BEGIN                    
      --                                             
      IF @PA_SEARCH_C4= 'IR'                                                     
      BEGIN                                                
				SELECT REMRM_ID ID,REMRM_ISIN ISIN,REMRM_SLIP_SERIAL_NO DRF_NO,REMRM_SLIP_SERIAL_NO  SLIP_SERIAL_NO                                               
				,ISNULL(CONVERT(VARCHAR,REMRM_REQUEST_DT,103),'') REQUEST_DT ,ISNULL(REMRM_EXECUTION_DT,'') EXECUTION_DT ,Convert(numeric(18,3),REMRM_QTY) QTY, ISNULL(DISPR_TYPE,'') DISP_TYPE                                   
				,CONVERT(VARCHAR,DISPR_DT,103) DISP_DT,ISNULL(DISPR_DOC_ID,'0') DISP_DOC_ID,ISNULL(DISPR_NAME,'') DISP_NAME,ISNULL(DISPR_CONF_RECD,'') DISP_CONF_RECD                     
				FROM DMAT_DISPATCH_REMAT , REMAT_REQUEST_MSTR,DP_ACCT_MSTR
				WHERE REMRM_ID = DISPR_REMRM_ID 
				AND REMRM_DPAM_ID = DPAM_ID 
				AND DPAM_DPM_ID = @l_dpm_dpid
				AND DISPR_DT BETWEEN CONVERT(DATETIME,@PA_SEARCH_C2+ ' 00:00:00:000',103) AND CONVERT(DATETIME,@PA_SEARCH_C3+ ' 23:59:59:999',103)
				AND ISNULL(DISPR_TO,'') = 'C'                                                
				AND ISNULL(REMRM_INTERNAL_REJ,'') <>''                                                
				AND ISNULL(DISPR_CONF_RECD,'') = ''                 
				AND REMRM_DELETED_IND = 1
				AND DPAM_DELETED_IND = 1                                         
      END                                                
      IF @PA_SEARCH_C4= 'CO'                                                     
      BEGIN                      
				SELECT REMRM_ID ID,REMRM_ISIN ISIN,REMRM_SLIP_SERIAL_NO DRF_NO,REMRM_SLIP_SERIAL_NO  SLIP_SERIAL_NO                                               
				,ISNULL(CONVERT(VARCHAR,REMRM_REQUEST_DT,103),'') REQUEST_DT ,ISNULL(REMRM_EXECUTION_DT,'') EXECUTION_DT ,Convert(numeric(18,3),REMRM_QTY) QTY, ISNULL(DISPR_TYPE,'') DISP_TYPE                                   
				,CONVERT(VARCHAR,DISPR_DT,103) DISP_DT,ISNULL(DISPR_DOC_ID,'0') DISP_DOC_ID,ISNULL(DISPR_NAME,'') DISP_NAME,ISNULL(DISPR_CONF_RECD,'') DISP_CONF_RECD                     
				FROM DMAT_DISPATCH_REMAT , REMAT_REQUEST_MSTR,DP_ACCT_MSTR
				WHERE REMRM_ID = DISPR_REMRM_ID 
				AND REMRM_DPAM_ID = DPAM_ID 
				AND DPAM_DPM_ID = @l_dpm_dpid
				AND DISPR_DT BETWEEN CONVERT(DATETIME,@PA_SEARCH_C2+ ' 00:00:00:000',103) AND CONVERT(DATETIME,@PA_SEARCH_C3+ ' 23:59:59:999',103)                                                  
				AND ISNULL(DISPR_TO,'') = 'C'                                                
				AND ISNULL(REMRM_COMPANY_OBJ,'') <>''                                                
				AND ISNULL(DISPR_CONF_RECD,'') = ''                   
				AND REMRM_DELETED_IND = 1
				AND DPAM_DELETED_IND = 1                                 
      END                                                
      IF @PA_SEARCH_C4= 'ALL'                                                     
      BEGIN                                                
				SELECT REMRM_ID ID,REMRM_ISIN ISIN,REMRM_SLIP_SERIAL_NO DRF_NO,REMRM_SLIP_SERIAL_NO  SLIP_SERIAL_NO                                               
				,ISNULL(CONVERT(VARCHAR,REMRM_REQUEST_DT,103),'') REQUEST_DT ,ISNULL(REMRM_EXECUTION_DT,'') EXECUTION_DT ,Convert(numeric(18,3),REMRM_QTY) QTY, ISNULL(DISPR_TYPE,'') DISP_TYPE                                   
				,CONVERT(VARCHAR,DISPR_DT,103) DISP_DT,ISNULL(DISPR_DOC_ID,'0') DISP_DOC_ID,ISNULL(DISPR_NAME,'') DISP_NAME,ISNULL(DISPR_CONF_RECD,'') DISP_CONF_RECD                     
				FROM DMAT_DISPATCH_REMAT , REMAT_REQUEST_MSTR ,DP_ACCT_MSTR 
				WHERE REMRM_ID = DISPR_REMRM_ID 
				AND REMRM_DPAM_ID = DPAM_ID 
				AND DPAM_DPM_ID = @l_dpm_dpid
				AND DISPR_DT BETWEEN CONVERT(DATETIME,@PA_SEARCH_C2+ ' 00:00:00:000',103) AND CONVERT(DATETIME,@PA_SEARCH_C3+ ' 23:59:59:999',103)                
				AND ISNULL(DISPR_TO,'') = 'C'                       
				AND ISNULL(DISPR_CONF_RECD,'') = ''        	
				AND REMRM_DELETED_IND = 1
				AND DPAM_DELETED_IND = 1                                           
     END                                                
      --                   
      END 
      ELSE
      BEGIN
      IF @PA_SEARCH_C4= 'IR'                                                     
      BEGIN                                                
				SELECT REMRM_ID ID,REMRM_ISIN ISIN,REMRM_SLIP_SERIAL_NO DRF_NO,REMRM_SLIP_SERIAL_NO  SLIP_SERIAL_NO                                               
				,ISNULL(CONVERT(VARCHAR,REMRM_REQUEST_DT,103),'') REQUEST_DT ,ISNULL(REMRM_EXECUTION_DT,'') EXECUTION_DT ,Convert(numeric(18,3),REMRM_QTY) QTY, ISNULL(DISPR_TYPE,'') DISP_TYPE                                   
				,CONVERT(VARCHAR,DISPR_DT,103) DISP_DT,ISNULL(DISPR_DOC_ID,'0') DISP_DOC_ID,ISNULL(DISPR_NAME,'') DISP_NAME,ISNULL(DISPR_CONF_RECD,'') DISP_CONF_RECD                     
				FROM DMAT_DISPATCH_REMAT , REMAT_REQUEST_MSTR,DP_ACCT_MSTR 
				WHERE REMRM_ID = DISPR_REMRM_ID 
				AND REMRM_DPAM_ID = DPAM_ID 
				AND DPAM_DPM_ID = @l_dpm_dpid
				AND ISNULL(DISPR_TO,'') = 'C'                                                
				AND ISNULL(REMRM_INTERNAL_REJ,'') <>''                                                
				AND ISNULL(DISPR_CONF_RECD,'') = ''                 
				AND REMRM_DELETED_IND = 1
				AND DPAM_DELETED_IND = 1                                           
      END                                                
      IF @PA_SEARCH_C4= 'CO'                                                     
      BEGIN                      
				SELECT REMRM_ID ID,REMRM_ISIN ISIN,REMRM_SLIP_SERIAL_NO DRF_NO,REMRM_SLIP_SERIAL_NO  SLIP_SERIAL_NO                                               
				,ISNULL(CONVERT(VARCHAR,REMRM_REQUEST_DT,103),'') REQUEST_DT ,ISNULL(REMRM_EXECUTION_DT,'') EXECUTION_DT ,Convert(numeric(18,3),REMRM_QTY) QTY, ISNULL(DISPR_TYPE,'') DISP_TYPE                                   
				,CONVERT(VARCHAR,DISPR_DT,103) DISP_DT,ISNULL(DISPR_DOC_ID,'0') DISP_DOC_ID,ISNULL(DISPR_NAME,'') DISP_NAME,ISNULL(DISPR_CONF_RECD,'') DISP_CONF_RECD                     
				FROM DMAT_DISPATCH_REMAT , REMAT_REQUEST_MSTR,DP_ACCT_MSTR   
				WHERE REMRM_ID = DISPR_REMRM_ID 
				AND REMRM_DPAM_ID = DPAM_ID 
				AND DPAM_DPM_ID = @l_dpm_dpid
				AND ISNULL(DISPR_TO,'') = 'C'                                                
				AND ISNULL(REMRM_COMPANY_OBJ,'') <>''                                                
				AND ISNULL(DISPR_CONF_RECD,'') = ''                   
				AND REMRM_DELETED_IND = 1
				AND DPAM_DELETED_IND = 1                                 
      END                                                
      IF @PA_SEARCH_C4= 'ALL'                                                     
      BEGIN                                                
				SELECT REMRM_ID ID,REMRM_ISIN ISIN,REMRM_SLIP_SERIAL_NO DRF_NO,REMRM_SLIP_SERIAL_NO  SLIP_SERIAL_NO                                               
				,ISNULL(CONVERT(VARCHAR,REMRM_REQUEST_DT,103),'') REQUEST_DT ,ISNULL(REMRM_EXECUTION_DT,'') EXECUTION_DT ,Convert(numeric(18,3),REMRM_QTY) QTY, ISNULL(DISPR_TYPE,'') DISP_TYPE                                   
				,CONVERT(VARCHAR,DISPR_DT,103) DISP_DT,ISNULL(DISPR_DOC_ID,'0') DISP_DOC_ID,ISNULL(DISPR_NAME,'') DISP_NAME,ISNULL(DISPR_CONF_RECD,'') DISP_CONF_RECD                     
				FROM DMAT_DISPATCH_REMAT , REMAT_REQUEST_MSTR,DP_ACCT_MSTR     
				WHERE REMRM_ID = DISPR_REMRM_ID 
				AND REMRM_DPAM_ID = DPAM_ID 
				AND DPAM_DPM_ID = @l_dpm_dpid
				AND ISNULL(DISPR_TO,'') = 'C'                       
				AND ISNULL(DISPR_CONF_RECD,'') = ''                             
				AND REMRM_DELETED_IND = 1
				AND DPAM_DELETED_IND = 1                                            
     END  
      END                
  --              
  END               
                
       
--                                                             
END                                                  
ELSE IF @PA_ACTION = 'DISP_MARK_CONF_SEARCH'                                                              
BEGIN                                                                
--               
  IF @PA_SEARCH_C10 = 'DEMAT'              
  BEGIN              
  --
   IF @PA_SEARCH_C2<>''
   BEGIN                                                                                               
    IF @PA_SEARCH_C4= 'IR'                                                     
    BEGIN                                                
				SELECT DEMRM_ID ID,DEMRM_ISIN ISIN,DEMRM_SLIP_SERIAL_NO DRF_NO,DEMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO                                     
				,ISNULL(CONVERT(VARCHAR,DEMRM_REQUEST_DT,103),'') REQUEST_DT ,ISNULL(DEMRM_EXECUTION_DT,'') EXECUTION_DT,Convert(numeric(18,3),DEMRM_QTY) EXECUTION_DT , ISNULL(DISP_TYPE,'')                                                
				,CONVERT(VARCHAR,DISP_DT,103),ISNULL(DISP_DOC_ID,'0'),ISNULL(DISP_NAME,''),ISNULL(DISP_CONF_RECD,'') DISP_CONF_RECD ,Convert(numeric(18,3),DEMRM_QTY) QTY                                               
				FROM DMAT_DISPATCH , DEMAT_REQUEST_MSTR,DP_ACCT_MSTR  
				WHERE DEMRM_ID = DISP_DEMRM_ID 
				AND DEMRM_DPAM_ID = DPAM_ID 
				AND DPAM_DPM_ID = @l_dpm_dpid
				AND DISP_DT =CONVERT(DATETIME,@PA_SEARCH_C2+ ' 00:00:00:000',103)                                        
				AND ISNULL(DISP_TO,'') = 'C'                                                
				AND ISNULL(DEMRM_INTERNAL_REJ,'') <>''                                                
				AND ISNULL(DISP_CONF_RECD,'') <> ''                
				AND  ISNULL(DEMRM_SLIP_SERIAL_NO,'')<>''  
				AND DEMRM_DELETED_IND = 1
				AND DPAM_DELETED_IND = 1                                       
    END                                                
   IF @PA_SEARCH_C4= 'CO'                                                     
    BEGIN                                                
				SELECT DEMRM_ID ID,DEMRM_ISIN ISIN,DEMRM_SLIP_SERIAL_NO DRF_NO,DEMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO                                     
				,ISNULL(CONVERT(VARCHAR,DEMRM_REQUEST_DT,103),'') REQUEST_DT ,ISNULL(DEMRM_EXECUTION_DT,'') EXECUTION_DT,Convert(numeric(18,3),DEMRM_QTY) EXECUTION_DT , ISNULL(DISP_TYPE,'')                                                
				,CONVERT(VARCHAR,DISP_DT,103),ISNULL(DISP_DOC_ID,'0'),ISNULL(DISP_NAME,''),ISNULL(DISP_CONF_RECD,'') DISP_CONF_RECD ,Convert(numeric(18,3),DEMRM_QTY) QTY                                                   
				FROM DMAT_DISPATCH , DEMAT_REQUEST_MSTR,DP_ACCT_MSTR  
				WHERE DEMRM_ID = DISP_DEMRM_ID 
				AND DEMRM_DPAM_ID = DPAM_ID 
				AND DPAM_DPM_ID = @l_dpm_dpid
				AND DISP_DT = CONVERT(DATETIME,@PA_SEARCH_C2+ ' 00:00:00:000',103)    
				AND ISNULL(DISP_TO,'') = 'C'                                                
				AND ISNULL(DEMRM_COMPANY_OBJ,'') <>''                                        
				AND ISNULL(DISP_CONF_RECD,'') <> ''               
				AND DEMRM_DELETED_IND = 1
				AND DPAM_DELETED_IND = 1                                      
    END                                                
    IF @PA_SEARCH_C4= 'ALL'                                                     
    BEGIN                                      
				SELECT DEMRM_ID ID,DEMRM_ISIN ISIN,DEMRM_SLIP_SERIAL_NO DRF_NO,DEMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO                                     
				,ISNULL(CONVERT(VARCHAR,DEMRM_REQUEST_DT,103),'') REQUEST_DT ,ISNULL(DEMRM_EXECUTION_DT,'') EXECUTION_DT,Convert(numeric(18,3),DEMRM_QTY) EXECUTION_DT , ISNULL(DISP_TYPE,'')                                                
				,CONVERT(VARCHAR,DISP_DT,103),ISNULL(DISP_DOC_ID,'0'),ISNULL(DISP_NAME,''),ISNULL(DISP_CONF_RECD,'') DISP_CONF_RECD  ,Convert(numeric(18,3),DEMRM_QTY) QTY                                                     
				FROM DMAT_DISPATCH , DEMAT_REQUEST_MSTR,DP_ACCT_MSTR   
				WHERE DEMRM_ID = DISP_DEMRM_ID 
				AND DEMRM_DPAM_ID = DPAM_ID 
				AND DPAM_DPM_ID = @l_dpm_dpid
				AND DISP_DT = CONVERT(DATETIME,@PA_SEARCH_C2+ ' 00:00:00:000',103)   
				AND ISNULL(DISP_TO,'') = 'C'                                                
				AND ISNULL(DISP_CONF_RECD,'')<> ''                
				AND DEMRM_DELETED_IND = 1
				AND DPAM_DELETED_IND = 1                                     
                                                    
    END
    END
    ELSE
    BEGIN
    IF @PA_SEARCH_C4= 'IR'                                                     
    BEGIN                                                
				SELECT DEMRM_ID ID,DEMRM_ISIN ISIN,DEMRM_SLIP_SERIAL_NO DRF_NO,DEMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO                                     
				,ISNULL(CONVERT(VARCHAR,DEMRM_REQUEST_DT,103),'') REQUEST_DT ,ISNULL(DEMRM_EXECUTION_DT,'') EXECUTION_DT,Convert(numeric(18,3),DEMRM_QTY) EXECUTION_DT , ISNULL(DISP_TYPE,'')                                                
				,CONVERT(VARCHAR,DISP_DT,103),ISNULL(DISP_DOC_ID,'0'),ISNULL(DISP_NAME,''),ISNULL(DISP_CONF_RECD,'') DISP_CONF_RECD ,Convert(numeric(18,3),DEMRM_QTY) QTY                                               
				FROM DMAT_DISPATCH , DEMAT_REQUEST_MSTR,DP_ACCT_MSTR   
				WHERE DEMRM_ID = DISP_DEMRM_ID 
				AND DEMRM_DPAM_ID = DPAM_ID 
				AND DPAM_DPM_ID = @l_dpm_dpid
				AND ISNULL(DISP_TO,'') = 'C'                                                
				AND ISNULL(DEMRM_INTERNAL_REJ,'') <>''                                                
				AND ISNULL(DISP_CONF_RECD,'') <> ''                
				AND DEMRM_DELETED_IND = 1
				AND DPAM_DELETED_IND = 1  
    END                                                
   IF @PA_SEARCH_C4= 'CO'                                                     
    BEGIN                                                
				SELECT DEMRM_ID ID,DEMRM_ISIN ISIN,DEMRM_SLIP_SERIAL_NO DRF_NO,DEMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO                                     
				,ISNULL(CONVERT(VARCHAR,DEMRM_REQUEST_DT,103),'') REQUEST_DT ,ISNULL(DEMRM_EXECUTION_DT,'') EXECUTION_DT,Convert(numeric(18,3),DEMRM_QTY) EXECUTION_DT , ISNULL(DISP_TYPE,'')                                                
				,CONVERT(VARCHAR,DISP_DT,103),ISNULL(DISP_DOC_ID,'0'),ISNULL(DISP_NAME,''),ISNULL(DISP_CONF_RECD,'') DISP_CONF_RECD  ,Convert(numeric(18,3),DEMRM_QTY) QTY                                                        
				FROM DMAT_DISPATCH , DEMAT_REQUEST_MSTR ,DP_ACCT_MSTR 
				WHERE DEMRM_ID = DISP_DEMRM_ID 
				AND DEMRM_DPAM_ID = DPAM_ID 
				AND DPAM_DPM_ID = @l_dpm_dpid
				AND ISNULL(DISP_TO,'') = 'C'                                                
				AND ISNULL(DEMRM_COMPANY_OBJ,'') <>''                                        
				AND ISNULL(DISP_CONF_RECD,'') <> ''               
				AND DEMRM_DELETED_IND = 1
				AND DPAM_DELETED_IND = 1                                    
    END                                                
    IF @PA_SEARCH_C4= 'ALL'                                                     
    BEGIN                                      
				SELECT DEMRM_ID ID,DEMRM_ISIN ISIN,DEMRM_SLIP_SERIAL_NO DRF_NO,DEMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO                                     
				,ISNULL(CONVERT(VARCHAR,DEMRM_REQUEST_DT,103),'') REQUEST_DT ,ISNULL(DEMRM_EXECUTION_DT,'') EXECUTION_DT,Convert(numeric(18,3),DEMRM_QTY) EXECUTION_DT , ISNULL(DISP_TYPE,'')                                                
				,CONVERT(VARCHAR,DISP_DT,103),ISNULL(DISP_DOC_ID,'0'),ISNULL(DISP_NAME,''),ISNULL(DISP_CONF_RECD,'') DISP_CONF_RECD ,Convert(numeric(18,3),DEMRM_QTY) QTY                                         
				FROM DMAT_DISPATCH , DEMAT_REQUEST_MSTR ,DP_ACCT_MSTR  
				WHERE DEMRM_ID = DISP_DEMRM_ID 
				AND DEMRM_DPAM_ID = DPAM_ID 
				AND DPAM_DPM_ID = @l_dpm_dpid
				AND ISNULL(DISP_TO,'') = 'C'                                                
				AND ISNULL(DISP_CONF_RECD,'')<> ''                
				AND DEMRM_DELETED_IND = 1
				AND DPAM_DELETED_IND = 1                                    
                                                    
    END
    END                
  --              
  END               
  ELSE IF @PA_SEARCH_C10 = 'REMAT'              
  BEGIN              
  --  
    IF @PA_SEARCH_C2 <> ''
    BEGIN                                                 
    IF @PA_SEARCH_C4= 'IR'                                   
    BEGIN                                                
				SELECT REMRM_ID ID,REMRM_ISIN ISIN,REMRM_SLIP_SERIAL_NO DRF_NO,REMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO                                                
				,ISNULL(CONVERT(VARCHAR,REMRM_REQUEST_DT,103),'') REQUEST_DT ,ISNULL(REMRM_EXECUTION_DT,'') EXECUTION_DT,Convert(numeric(18,3),REMRM_QTY) QTY, ISNULL(DISPR_TYPE,'')   DISP_TYPE                                             
				,CONVERT(VARCHAR,DISPR_DT,103) DISP_DT,ISNULL(DISPR_DOC_ID,'0') DISP_DOC_ID,ISNULL(DISPR_NAME,'') DISP_NAME,ISNULL(DISPR_CONF_RECD,'') DISP_CONF_RECD,Convert(numeric(18,3),REMRM_QTY) QTY                                                    
				FROM DMAT_DISPATCH_REMAT , REMAT_REQUEST_MSTR ,DP_ACCT_MSTR  
				WHERE REMRM_ID = DISPR_REMRM_ID 
				AND REMRM_DPAM_ID = DPAM_ID 
				AND DPAM_DPM_ID = @l_dpm_dpid
				AND DISPR_DT = CONVERT(DATETIME,@PA_SEARCH_C2+ ' 00:00:00:000',103)   
				AND ISNULL(DISPR_TO,'') = 'C'    
				AND ISNULL(REMRM_INTERNAL_REJ,'') <>''                                                
				AND ISNULL(DISPR_CONF_RECD,'') <> ''                
				AND REMRM_DELETED_IND = 1
				AND DPAM_DELETED_IND = 1 
    END                                                
    IF @PA_SEARCH_C4= 'CO'                                                     
    BEGIN                                                
				SELECT REMRM_ID ID,REMRM_ISIN ISIN,REMRM_SLIP_SERIAL_NO DRF_NO,REMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO                                                
				,ISNULL(CONVERT(VARCHAR,REMRM_REQUEST_DT,103),'') REQUEST_DT ,ISNULL(REMRM_EXECUTION_DT,'') EXECUTION_DT,Convert(numeric(18,3),REMRM_QTY) QTY, ISNULL(DISPR_TYPE,'')   DISP_TYPE                                             
				,CONVERT(VARCHAR,DISPR_DT,103) DISP_DT,ISNULL(DISPR_DOC_ID,'0') DISP_DOC_ID,ISNULL(DISPR_NAME,'') DISP_NAME,ISNULL(DISPR_CONF_RECD,'') DISP_CONF_RECD  ,Convert(numeric(18,3),REMRM_QTY) QTY                                                  
				FROM DMAT_DISPATCH_REMAT , REMAT_REQUEST_MSTR,DP_ACCT_MSTR
				WHERE REMRM_ID = DISPR_REMRM_ID 
				AND REMRM_DPAM_ID = DPAM_ID 
				AND DPAM_DPM_ID = @l_dpm_dpid
				AND DISPR_DT = CONVERT(DATETIME,@PA_SEARCH_C2+ ' 00:00:00:000',103)   
				AND ISNULL(DISPR_TO,'') = 'C'                                                
				AND ISNULL(REMRM_COMPANY_OBJ,'') <>''                                                
				AND ISNULL(DISPR_CONF_RECD,'') <> ''               
				AND REMRM_DELETED_IND = 1
				AND DPAM_DELETED_IND = 1                          
    END                                                
    IF @PA_SEARCH_C4= 'ALL'                                               
    BEGIN                                      
				SELECT REMRM_ID ID,REMRM_ISIN ISIN,REMRM_SLIP_SERIAL_NO DRF_NO,REMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO                                                
				,ISNULL(CONVERT(VARCHAR,REMRM_REQUEST_DT,103),'') REQUEST_DT ,ISNULL(REMRM_EXECUTION_DT,'') EXECUTION_DT,Convert(numeric(18,3),REMRM_QTY) QTY, ISNULL(DISPR_TYPE,'')   DISP_TYPE                                             
				,CONVERT(VARCHAR,DISPR_DT,103) DISP_DT,ISNULL(DISPR_DOC_ID,'0') DISP_DOC_ID,ISNULL(DISPR_NAME,'') DISP_NAME,ISNULL(DISPR_CONF_RECD,'') DISP_CONF_RECD  ,Convert(numeric(18,3),REMRM_QTY) QTY                                                  
				FROM DMAT_DISPATCH_REMAT , REMAT_REQUEST_MSTR ,DP_ACCT_MSTR 
				WHERE REMRM_ID = DISPR_REMRM_ID 
				AND REMRM_DPAM_ID = DPAM_ID 
				AND DPAM_DPM_ID = @l_dpm_dpid
				AND DISPR_DT = CONVERT(DATETIME,@PA_SEARCH_C2+ ' 00:00:00:000',103)    
				AND ISNULL(DISPR_TO,'') = 'C'                               
				AND ISNULL(DISPR_CONF_RECD,'')<> ''                
				AND REMRM_DELETED_IND = 1
				AND DPAM_DELETED_IND = 1                                         
                                                    
    END
    END
    ELSE
    BEGIN
     IF @PA_SEARCH_C4= 'IR'                                   
     BEGIN                                                
				SELECT REMRM_ID ID,REMRM_ISIN ISIN,REMRM_SLIP_SERIAL_NO DRF_NO,REMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO                                                
				,ISNULL(CONVERT(VARCHAR,REMRM_REQUEST_DT,103),'') REQUEST_DT ,ISNULL(REMRM_EXECUTION_DT,'') EXECUTION_DT,Convert(numeric(18,3),REMRM_QTY) QTY, ISNULL(DISPR_TYPE,'')   DISP_TYPE                                             
				,CONVERT(VARCHAR,DISPR_DT,103) DISP_DT,ISNULL(DISPR_DOC_ID,'0') DISP_DOC_ID,ISNULL(DISPR_NAME,'') DISP_NAME,ISNULL(DISPR_CONF_RECD,'') DISP_CONF_RECD ,Convert(numeric(18,3),REMRM_QTY) QTY                                                   
				FROM DMAT_DISPATCH_REMAT , REMAT_REQUEST_MSTR,DP_ACCT_MSTR   
				WHERE REMRM_ID = DISPR_REMRM_ID 
				AND REMRM_DPAM_ID = DPAM_ID 
				AND DPAM_DPM_ID = @l_dpm_dpid
				AND ISNULL(DISPR_TO,'') = 'C'    
				AND ISNULL(REMRM_INTERNAL_REJ,'') <>''                                                
				AND ISNULL(DISPR_CONF_RECD,'') <> ''                
				AND REMRM_DELETED_IND = 1
				AND DPAM_DELETED_IND = 1                                              
    END                                                
    IF @PA_SEARCH_C4= 'CO'                                                     
    BEGIN                                                
				SELECT REMRM_ID ID,REMRM_ISIN ISIN,REMRM_SLIP_SERIAL_NO DRF_NO,REMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO                                                
				,ISNULL(CONVERT(VARCHAR,REMRM_REQUEST_DT,103),'') REQUEST_DT ,ISNULL(REMRM_EXECUTION_DT,'') EXECUTION_DT,Convert(numeric(18,3),REMRM_QTY) QTY, ISNULL(DISPR_TYPE,'')   DISP_TYPE                                             
				,CONVERT(VARCHAR,DISPR_DT,103) DISP_DT,ISNULL(DISPR_DOC_ID,'0') DISP_DOC_ID,ISNULL(DISPR_NAME,'') DISP_NAME,ISNULL(DISPR_CONF_RECD,'') DISP_CONF_RECD   ,Convert(numeric(18,3),REMRM_QTY) QTY                                                 
				FROM DMAT_DISPATCH_REMAT , REMAT_REQUEST_MSTR,DP_ACCT_MSTR 
				WHERE REMRM_ID = DISPR_REMRM_ID 
				AND REMRM_DPAM_ID = DPAM_ID 
				AND DPAM_DPM_ID = @l_dpm_dpid
				AND ISNULL(DISPR_TO,'') = 'C'                                                
				AND ISNULL(REMRM_COMPANY_OBJ,'') <>''                                                
				AND ISNULL(DISPR_CONF_RECD,'') <> ''               
				AND REMRM_DELETED_IND = 1
				AND DPAM_DELETED_IND = 1                               
    END                                                
    IF @PA_SEARCH_C4= 'ALL'                                               
    BEGIN                                      
				SELECT REMRM_ID ID,REMRM_ISIN ISIN,REMRM_SLIP_SERIAL_NO DRF_NO,REMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO                                                
				,ISNULL(CONVERT(VARCHAR,REMRM_REQUEST_DT,103),'') REQUEST_DT ,ISNULL(REMRM_EXECUTION_DT,'') EXECUTION_DT,Convert(numeric(18,3),REMRM_QTY) QTY, ISNULL(DISPR_TYPE,'')   DISP_TYPE                                             
				,CONVERT(VARCHAR,DISPR_DT,103) DISP_DT,ISNULL(DISPR_DOC_ID,'0') DISP_DOC_ID,ISNULL(DISPR_NAME,'') DISP_NAME,ISNULL(DISPR_CONF_RECD,'') DISP_CONF_RECD ,Convert(numeric(18,3),REMRM_QTY) QTY                                                   
				FROM DMAT_DISPATCH_REMAT , REMAT_REQUEST_MSTR ,DP_ACCT_MSTR 
				WHERE REMRM_ID = DISPR_REMRM_ID 
				AND REMRM_DPAM_ID = DPAM_ID 
				AND DPAM_DPM_ID = @l_dpm_dpid
				AND ISNULL(DISPR_TO,'') = 'C'                                                
				AND ISNULL(DISPR_CONF_RECD,'')<> ''                
				AND REMRM_DELETED_IND = 1
				AND DPAM_DELETED_IND = 1                                         
                                                    
    END
    END                 
  --              
  END               
                                               
--                                    
END                                                
ELSE IF @PA_ACTION = 'DISP_RTA_NEW'                                                              
BEGIN                                                                
--                                                    
   IF @PA_SEARCH_C10 ='DEMAT'              
   BEGIN               
   --              
/*                                              
     SELECT DEMRM_ID ID ,DEMRM_ISIN ISIN ,ISIN_NAME                                                
    ,DEMRM_SLIP_SERIAL_NO   DRF_NO                                         
    ,DEMRM_SLIP_SERIAL_NO      SLIP_SERIAL_NO                                          
    ,CONVERT(VARCHAR,DEMRM_REQUEST_DT,103)   REQUEST_DT                                              
    ,CONVERT(VARCHAR,DEMRM_EXECUTION_DT,103)  EXECUTION_DT                                              
    ,Convert(numeric(18,3),DEMRM_QTY)    QTY                                             
    ,DPAM_SBA_NO                                            
    ,DPAM_SBA_NAME                                            
    ,ISNULL(DEMRM_TRANSACTION_NO,'') DRN_NO                                          
    ,'' AS DISP_ID                                         
    ,'' DISP_DT                                          
    ,'' DISP_DOC_ID                                       
    ,'' DISP_NAME                            
    ,ENTM_NAME1 RTA_NAME            
    ,ISIN_REG_CD RTA_CD                             
    FROM DEMAT_REQUEST_MSTR LEFT OUTER JOIN DP_ACCT_MSTR ON DEMRM_DPAM_ID =  DPAM_ID , ISIN_MSTR  , ENTITY_MSTR                                           
    WHERE DEMRM_ID NOT IN (SELECT DISP_DEMRM_ID FROM  DMAT_DISPATCH WHERE DISP_TO = 'R')              
    AND ISIN_CD = DEMRM_ISIN                 
    AND ISIN_REG_CD = case when @L_EXCSM_CD = 'nsdl' then ltrim(rtrim(entm_short_name))  else  replace(ltrim(rtrim(entm_short_name)),'RTA_','') end            
    and entm_enttm_cd = case when  @L_EXCSM_CD = 'nsdl' then 'SR' else 'RTA' end             
    AND CASE WHEN @PA_SEARCH_C9 <> '' THEN @PA_SEARCH_C9 ELSE '' END = CASE WHEN @PA_SEARCH_C9 <> '' THEN ISIN_CD ELSE '' END              
    AND  ISNULL(DEMRM_TRANSACTION_NO,'')<>''   

*/
--print 'pankaj'
--print @l_dpm_dpid
--print @L_EXCSM_CD
--print @PA_SEARCH_C9
						SELECT DEMRM_ID ID ,DEMRM_ISIN ISIN ,ISIN_NAME                                                
						,DEMRM_SLIP_SERIAL_NO   DRF_NO                                         
						,DEMRM_SLIP_SERIAL_NO      SLIP_SERIAL_NO                                          
						,CONVERT(VARCHAR,DEMRM_REQUEST_DT,103)   REQUEST_DT                                              
						,CONVERT(VARCHAR,DEMRM_EXECUTION_DT,103)  EXECUTION_DT                                              
						,Convert(numeric(18,3),DEMRM_QTY)    QTY                                             
						,DPAM_SBA_NO                                            
						,DPAM_SBA_NAME                                            
						,ISNULL(DEMRM_TRANSACTION_NO,'') DRN_NO                                          
						,'' AS DISP_ID                                         
						,'' DISP_DT                                          
						,'' DISP_DOC_ID                                       
						,'' DISP_NAME                            
						,ENTM_NAME1 RTA_NAME            
						,ISIN_REG_CD RTA_CD  
						,isin_adr1 + ',' + isin_adr2 + ',' + isin_adr3 + ',' + isin_adrcity + ',' + isin_adrstate + ',' + 
						isin_adrcountry + ',' + isin_adrzip RTA_ADDRESS						                                                                                  
						FROM DEMAT_REQUEST_MSTR,DP_ACCT_MSTR , ISIN_MSTR  , ENTITY_MSTR                                           
						WHERE DEMRM_DPAM_ID =  DPAM_ID 
						AND NOT EXISTS (SELECT DISP_DEMRM_ID FROM  DMAT_DISPATCH WHERE DEMRM_ID = DISP_DEMRM_ID AND DISP_TO = 'R')              
						AND DEMRM_CREDIT_RECD <> 'Y'
						AND (ISNULL(LTRIM(RTRIM(DEMRM_INTERNAL_REJ)),'') = '' or isnull(DEMRM_STATUS,'') = 'S')
						AND ISNULL(LTRIM(RTRIM(DEMRM_COMPANY_OBJ)),'') = ''
						AND  ISNULL(DEMRM_TRANSACTION_NO,'')<>'' 
						AND ISIN_CD = DEMRM_ISIN                 
						AND ISIN_REG_CD = case when @L_EXCSM_CD = 'nsdl' then ltrim(rtrim(entm_short_name))  else  replace(ltrim(rtrim(entm_short_name)),'RTA_','') end            
						and entm_enttm_cd = case when  @L_EXCSM_CD = 'nsdl' then 'SR' else 'RTA' end    
						AND CASE WHEN @PA_SEARCH_C9 <> '' THEN @PA_SEARCH_C9 ELSE '' END = CASE WHEN @PA_SEARCH_C9 <> '' THEN ISIN_CD ELSE '' END               
						and DEMRM_LST_UPD_DT between case when isnull(@pa_search_c2,'')='' then DEMRM_LST_UPD_DT else @pa_search_c2 end and case when isnull(@pa_search_c3,'')= '' then DEMRM_LST_UPD_DT else @pa_search_c3 end  + ' 23:59:59'
						AND DPAM_DPM_ID = @l_dpm_dpid
						AND DPAM_DELETED_IND = 1
						AND DEMRM_DELETED_IND = 1
						AND ENTM_DELETED_IND = 1 order by DEMRM_ISIN
                    
  --              
  END                           
  ELSE IF @PA_SEARCH_C10 ='REMAT'              
  BEGIN               
  --   
/*                                           
    SELECT REMRM_ID ID ,REMRM_ISIN ISIN,ISIN_NAME                                             
   ,REMRM_SLIP_SERIAL_NO   DRF_NO                                             
   ,REMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO                                                 
   ,CONVERT(VARCHAR,REMRM_REQUEST_DT,103)   REQUEST_DT                                              
   ,CONVERT(VARCHAR,REMRM_EXECUTION_DT,103)  EXECUTION_DT                                              
   ,Convert(numeric(18,3),REMRM_QTY)   QTY                                             
   ,DPAM_SBA_NO                    
   ,DPAM_SBA_NAME                                            
   ,ISNULL(REMRM_TRANSACTION_NO,'') DRN_NO                                          
   ,'' AS DISP_ID                                         
   ,'' DISP_DT                                          
   ,'' DISP_DOC_ID                                       
   ,'' DISP_NAME              
   ,ENTM_NAME1 RTA_NAME            
    ,ISIN_REG_CD RTA_CD                                                 
   FROM REMAT_REQUEST_MSTR LEFT OUTER JOIN DP_ACCT_MSTR ON REMRM_DPAM_ID =  DPAM_ID , ISIN_MSTR   , ENTITY_MSTR                                          
   WHERE REMRM_ID NOT IN (SELECT DISPR_REMRM_ID FROM  DMAT_DISPATCH_REMAT WHERE DISPR_TO = 'R')              
   AND ISIN_CD = REMRM_ISIN               
 AND ISIN_REG_CD = case when @L_EXCSM_CD = 'nsdl' then ltrim(rtrim(entm_short_name))  else  replace(ltrim(rtrim(entm_short_name)),'RTA_','') end            
    and entm_enttm_cd = case when  @L_EXCSM_CD = 'nsdl' then 'SR' else 'RTA' end               
   AND CASE WHEN @PA_SEARCH_C9 <> '' THEN @PA_SEARCH_C9 ELSE '' END = CASE WHEN @PA_SEARCH_C9 <> '' THEN ISIN_CD ELSE '' END              
    AND  ISNULL(REMRM_TRANSACTION_NO,'')<>''       
*/
				SELECT REMRM_ID ID ,REMRM_ISIN ISIN,ISIN_NAME                                             
				,REMRM_SLIP_SERIAL_NO   DRF_NO                                             
				,REMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO                                                 
				,CONVERT(VARCHAR,REMRM_REQUEST_DT,103)   REQUEST_DT                                              
				,CONVERT(VARCHAR,REMRM_EXECUTION_DT,103)  EXECUTION_DT                                              
				,Convert(numeric(18,3),REMRM_QTY)   QTY                                             
				,DPAM_SBA_NO                    
				,DPAM_SBA_NAME                                            
				,ISNULL(REMRM_TRANSACTION_NO,'') DRN_NO                                          
				,'' AS DISP_ID                                         
				,'' DISP_DT                                          
				,'' DISP_DOC_ID                                       
				,'' DISP_NAME              
				,ENTM_NAME1 RTA_NAME            
				,ISIN_REG_CD RTA_CD                                                                  
				FROM REMAT_REQUEST_MSTR ,DP_ACCT_MSTR, ISIN_MSTR  , ENTITY_MSTR                                           
				WHERE  REMRM_DPAM_ID =  DPAM_ID 
				AND NOT EXISTS (SELECT DISPR_REMRM_ID FROM  DMAT_DISPATCH_REMAT WHERE DISPR_REMRM_ID = REMRM_ID  AND DISPR_TO = 'R')              
				AND REMRM_CREDIT_RECD <> 'Y'             
				AND ISNULL(LTRIM(RTRIM(REMRM_INTERNAL_REJ)),'') = '' AND ISNULL(LTRIM(RTRIM(REMRM_COMPANY_OBJ)),'') = ''
				AND  ISNULL(REMRM_TRANSACTION_NO,'')<>'' 
				AND ISIN_CD = REMRM_ISIN                 
				AND ISIN_REG_CD = case when @L_EXCSM_CD = 'nsdl' then ltrim(rtrim(entm_short_name))  else  replace(ltrim(rtrim(entm_short_name)),'RTA_','') end            
				AND entm_enttm_cd = case when  @L_EXCSM_CD = 'nsdl' then 'SR' else 'RTA' end             
				AND CASE WHEN @PA_SEARCH_C9 <> '' THEN @PA_SEARCH_C9 ELSE '' END = CASE WHEN @PA_SEARCH_C9 <> '' THEN ISIN_CD ELSE '' END              
				AND DPAM_DPM_ID = @l_dpm_dpid
				AND DPAM_DELETED_IND = 1
				AND REMRM_DELETED_IND = 1
				AND ENTM_DELETED_IND = 1                
 --              
 END                                     
                                                     
--             
END                                            
ELSE IF @PA_ACTION = 'DISP_RTA_FOLLOW'                                                              
BEGIN                                                                
--         
select @l_dpm_dpid = dpm_id ,@L_EXCSM_CD = EXCSM_EXCH_CD from dp_mstr, EXCH_SEG_MSTR where EXCSM_ID = DPM_EXCSM_ID AND DEFAULT_DP = @pa_id and dpm_deleted_ind = 1                                 
                                           
   IF @PA_SEARCH_C10 ='DEMAT'              
   BEGIN               
   -- 
/*                                            
    SELECT DEMRM_ID ID ,DEMRM_ISIN ISIN ,ISIN_NAME                                                
    ,DEMRM_SLIP_SERIAL_NO   DRF_NO                                         
    ,DEMRM_SLIP_SERIAL_NO      SLIP_SERIAL_NO                                          
    ,CONVERT(VARCHAR,DEMRM_REQUEST_DT,103)   REQUEST_DT                                              
    ,CONVERT(VARCHAR,DEMRM_EXECUTION_DT,103)  EXECUTION_DT                                              
    ,Convert(numeric(18,3),DEMRM_QTY)    QTY                                             
    ,DPAM_SBA_NO                                            
    ,DPAM_SBA_NAME                                            
    ,ISNULL(DEMRM_TRANSACTION_NO,'') DRN_NO                                          
    ,'' AS DISP_ID                                         
    ,'' DISP_DT                                          
    ,'' DISP_DOC_ID                                       
    ,'' DISP_NAME                            
    ,ENTM_NAME1 RTA_NAME            
    ,ISIN_REG_CD RTA_CD                                                     
    FROM DEMAT_REQUEST_MSTR LEFT OUTER JOIN DP_ACCT_MSTR ON DEMRM_DPAM_ID =  DPAM_ID , ISIN_MSTR    , ENTITY_MSTR                           
    ,DMAT_DISPATCH                                          
   WHERE DEMRM_ID = DISP_DEMRM_ID                                           
   AND  DISP_TO = 'R'                       
   AND ISIN_CD = DEMRM_ISIN                                          
   AND  ISNULL(DEMRM_CREDIT_RECD,'') = 'N'                                           
   AND DATEDIFF(DD,DISP_DT,GETDATE()) >=@PA_SEARCH_C2               
 AND ISIN_REG_CD = case when @L_EXCSM_CD = 'nsdl' then ltrim(rtrim(entm_short_name))  else  replace(ltrim(rtrim(entm_short_name)),'RTA_','') end            
    and entm_enttm_cd = case when  @L_EXCSM_CD = 'nsdl' then 'SR' else 'RTA' end             
   AND CASE WHEN @PA_SEARCH_C9 <> '' THEN @PA_SEARCH_C9 ELSE '' END = CASE WHEN @PA_SEARCH_C9 <> '' THEN ISIN_CD ELSE '' END              
    AND  ISNULL(DEMRM_TRANSACTION_NO,'')<>''     
*/
					SELECT DEMRM_ID ID ,DEMRM_ISIN ISIN ,ISIN_NAME                                                
					,DEMRM_SLIP_SERIAL_NO   DRF_NO                                         
					,DEMRM_SLIP_SERIAL_NO   SLIP_SERIAL_NO                                          
					,CONVERT(VARCHAR,DEMRM_REQUEST_DT,103)   REQUEST_DT                                              
					,CONVERT(VARCHAR,DEMRM_EXECUTION_DT,103)  EXECUTION_DT                                              
					,Convert(numeric(18,3),DEMRM_QTY)    QTY                                             
					,DPAM_SBA_NO                                            
					,DPAM_SBA_NAME  					                                      
					,ISNULL(DEMRM_TRANSACTION_NO,'') DRN_NO                                          
					,DISP_ID                                         
--					,'' DISP_DT                                          
--					,'' DISP_DOC_ID                                       
--					,'' DISP_NAME 
					, DISP_DT                                          
					, DISP_DOC_ID                                       
					, DISP_NAME                                   
					,ENTM_NAME1 RTA_NAME            
					,ISIN_REG_CD RTA_CD   
					,isin_adr1 + ',' + isin_adr2 + ',' + isin_adr3 + ',' + isin_adrcity + ',' + isin_adrstate + ',' + 
					isin_adrcountry + ',' + isin_adrzip RTA_ADDRESS						                                                                                            
					FROM DEMAT_REQUEST_MSTR LEFT OUTER JOIN DMAT_DISPATCH ON DEMRM_ID = DISP_DEMRM_ID AND DISP_TO = 'R'  AND DISP_TYPE = 'N'  and isnull(DISP_CONF_RECD,'') <>'D'
					,DP_ACCT_MSTR , ISIN_MSTR  , ENTITY_MSTR                                           
					WHERE DEMRM_DPAM_ID =  DPAM_ID 
					AND DEMRM_CREDIT_RECD <> 'Y'
					AND ISNULL(LTRIM(RTRIM(DEMRM_INTERNAL_REJ)),'') = '' AND ISNULL(LTRIM(RTRIM(DEMRM_COMPANY_OBJ)),'') = ''
					AND  ISNULL(DEMRM_TRANSACTION_NO,'')<>'' 
					AND DISP_DEMRM_ID IS NOT NULL
					AND ISIN_CD = DEMRM_ISIN                 
					AND DISP_RTA_CD = case when @L_EXCSM_CD = 'nsdl' then ltrim(rtrim(entm_short_name))  else  replace(ltrim(rtrim(entm_short_name)),'RTA_','') end            
					and entm_enttm_cd = case when  @L_EXCSM_CD = 'nsdl' then 'SR' else 'RTA' end     
					AND CASE WHEN @PA_SEARCH_C9 <> '' THEN @PA_SEARCH_C9 ELSE '' END = CASE WHEN @PA_SEARCH_C9 <> '' THEN ISIN_CD ELSE '' END              
					AND DEMRM_LST_UPD_DT between @pa_search_c2 and @pa_search_c3 + ' 23:59:59'
					AND DPAM_DPM_ID = @l_dpm_dpid
					AND DPAM_DELETED_IND = 1
					AND DEMRM_DELETED_IND = 1
					AND ENTM_DELETED_IND = 1
                  
 --              
 END              
 ELSE IF @PA_SEARCH_C10 ='REMAT'              
 BEGIN               
 --          
/*                
      SELECT REMRM_ID ID ,REMRM_ISIN ISIN,ISIN_NAME                                             
   ,REMRM_SLIP_SERIAL_NO   DRF_NO                                             
   ,REMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO                                                 
   ,CONVERT(VARCHAR,REMRM_REQUEST_DT,103)   REQUEST_DT                                              
   ,CONVERT(VARCHAR,REMRM_EXECUTION_DT,103)  EXECUTION_DT                                              
   ,Convert(numeric(18,3),REMRM_QTY)   QTY                                             
   ,DPAM_SBA_NO                    
   ,DPAM_SBA_NAME                                            
   ,ISNULL(REMRM_TRANSACTION_NO,'') DRN_NO                                          
   ,'' AS DISP_ID                                         
   ,'' DISP_DT                                          
   ,'' DISP_DOC_ID                                       
   ,'' DISP_NAME              
   ,ENTM_NAME1 RTA_NAME            
    ,ISIN_REG_CD RTA_CD                                                
    FROM REMAT_REQUEST_MSTR LEFT OUTER JOIN DP_ACCT_MSTR ON REMRM_DPAM_ID =  DPAM_ID , ISIN_MSTR     , ENTITY_MSTR                          
    ,DMAT_DISPATCH_REMAT                                          
   WHERE REMRM_ID = DISPR_REMRM_ID                                           
   AND  DISPR_TO = 'R'                       
   AND ISIN_CD = REMRM_ISIN                                          
   AND  ISNULL(REMRM_CREDIT_RECD,'') = 'N'                                           
   AND DATEDIFF(DD,DISPR_DT,GETDATE()) >=@PA_SEARCH_C2               
 AND ISIN_REG_CD = case when @L_EXCSM_CD = 'nsdl' then ltrim(rtrim(entm_short_name))  else  replace(ltrim(rtrim(entm_short_name)),'RTA_','') end            
    and entm_enttm_cd = case when  @L_EXCSM_CD = 'nsdl' then 'SR' else 'RTA' end             
   AND CASE WHEN @PA_SEARCH_C9 <> '' THEN @PA_SEARCH_C9 ELSE '' END = CASE WHEN @PA_SEARCH_C9 <> '' THEN ISIN_CD ELSE '' END              
    AND  ISNULL(REMRM_TRANSACTION_NO,'')<>''   

*/
					SELECT REMRM_ID ID ,REMRM_ISIN ISIN,ISIN_NAME                                             
					,REMRM_SLIP_SERIAL_NO   DRF_NO                                             
					,REMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO                                                 
					,CONVERT(VARCHAR,REMRM_REQUEST_DT,103)   REQUEST_DT                                              
					,CONVERT(VARCHAR,REMRM_EXECUTION_DT,103)  EXECUTION_DT                                              
					,Convert(numeric(18,3),REMRM_QTY)   QTY                                             
					,DPAM_SBA_NO                    
					,DPAM_SBA_NAME 
					                                       
					,ISNULL(REMRM_TRANSACTION_NO,'') DRN_NO                                          
					,'' AS DISP_ID                                         
					,'' DISP_DT                                          
					,'' DISP_DOC_ID                                       
					,'' DISP_NAME 
					              
					,ENTM_NAME1 RTA_NAME            
					,ISIN_REG_CD RTA_CD                                                                   
					FROM REMAT_REQUEST_MSTR LEFT OUTER JOIN DMAT_DISPATCH_REMAT ON REMRM_ID = DISPR_REMRM_ID AND DISPR_TO = 'R'  AND DISPR_TYPE = 'N'  
					,DP_ACCT_MSTR, ISIN_MSTR  , ENTITY_MSTR                                           
					WHERE  REMRM_DPAM_ID =  DPAM_ID 
					AND ISIN_CD = REMRM_ISIN    
					AND REMRM_CREDIT_RECD <> 'Y'             
					AND ISNULL(LTRIM(RTRIM(REMRM_INTERNAL_REJ)),'') = '' AND ISNULL(LTRIM(RTRIM(REMRM_COMPANY_OBJ)),'') = ''
					AND  ISNULL(REMRM_TRANSACTION_NO,'')<>'' 
					AND DISPR_REMRM_ID IS NOT NULL
					AND DISPR_RTA_CD = case when @L_EXCSM_CD = 'nsdl' then ltrim(rtrim(entm_short_name))  else  replace(ltrim(rtrim(entm_short_name)),'RTA_','') end            
					AND entm_enttm_cd = case when  @L_EXCSM_CD = 'nsdl' then 'SR' else 'RTA' end             
					AND CASE WHEN @PA_SEARCH_C9 <> '' THEN @PA_SEARCH_C9 ELSE '' END = CASE WHEN @PA_SEARCH_C9 <> '' THEN ISIN_CD ELSE '' END              
					AND DPAM_DPM_ID = @l_dpm_dpid
					AND DPAM_DELETED_IND = 1
					AND REMRM_DELETED_IND = 1
					AND ENTM_DELETED_IND = 1
                    
 --              
 END              
                                    
--                                                    
END                                           
ELSE IF @PA_ACTION = 'DISP_RTA_SEARCH'                                                              
BEGIN                                                                
--      
select @l_dpm_dpid = dpm_id ,@L_EXCSM_CD = EXCSM_EXCH_CD from dp_mstr, EXCH_SEG_MSTR where EXCSM_ID = DPM_EXCSM_ID AND DEFAULT_DP = @pa_id and dpm_deleted_ind = 1                                 
             
  IF @PA_SEARCH_C10 ='DEMAT'              
  BEGIN                    
  --              
    IF @PA_SEARCH_C2 <> ''                 
    BEGIN                    
    --  
    SELECT DEMRM_ID ID ,DEMRM_ISIN ISIN ,DEMRM_SLIP_SERIAL_NO DRF_NO,DEMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO,ISNULL(DEMRM_TRANSACTION_NO,'') DRN_NO                                             
    ,CONVERT(VARCHAR,ISNULL(DEMRM_REQUEST_DT,''),103) REQUEST_DT ,DPAM_SBA_NO , DISP_ID                                          
    ,DPAM_SBA_NAME,CONVERT(VARCHAR,ISNULL(DEMRM_EXECUTION_DT,''),103) EXECUTION_DT ,Convert(numeric(18,3),DEMRM_QTY) QTY                                              
    ,CONVERT(VARCHAR,DISP_DT,103) DISP_DT,ISNULL(DISP_DOC_ID,'0') DISP_DOC_ID,ISNULL(DISP_NAME,'') DISP_NAME,ISNULL(DISP_CONF_RECD,'') DISP_CONF_RECD                          
    ,ENTM_NAME1 RTA_NAME            
    ,disp_rta_cd RTA_CD        
    ,disp_cons_no CONS_NO ,DISP_TYPE = CASE WHEN DISP_TYPE = 'F' THEN 'FOLLOW UP' ELSE 'NEW' END  ,ISIN_NAME        
	,isin_adr1 + ',' + isin_adr2 + ',' + isin_adr3 + ',' + isin_adrcity + ',' + isin_adrstate + ',' + 
	isin_adrcountry + ',' + isin_adrzip RTA_ADDRESS						                                                                                            
     FROM DMAT_DISPATCH , DEMAT_REQUEST_MSTR , DP_ACCT_MSTR,entity_mstr ,isin_mstr  
	 WHERE DEMRM_DPAM_ID = DPAM_ID 
     and DEMRM_ISIN = ISIN_CD
	 AND DEMRM_ID = DISP_DEMRM_ID  
	 --AND DPAM_DPM_ID = @l_dpm_dpid                                           
     AND  DISP_TO = 'R'    
	-- and isnull(DISP_CONF_RECD,'') <> ''      
     AND disp_rta_cd = case when @L_EXCSM_CD = 'nsdl' then ltrim(rtrim(entm_short_name))  else  replace(ltrim(rtrim(entm_short_name)),'RTA_','') end            
     AND entm_enttm_cd = case when  @L_EXCSM_CD = 'nsdl' then 'SR' else 'RTA' end                                                                     
     AND DISP_DT = CONVERT(DATETIME,@PA_SEARCH_C2+ ' 00:00:00:000',103) 
     AND CASE WHEN @PA_SEARCH_C3 <> '' THEN @PA_SEARCH_C3 ELSE '' END = CASE WHEN @PA_SEARCH_C3 <> '' THEN disp_cons_no ELSE '' END              
     and isin_cd like case when @PA_SEARCH_C6 <> '' then @PA_SEARCH_C6 else '%' end
     AND  ISNULL(DEMRM_TRANSACTION_NO,'')<>'' 
	 and dpam_deleted_ind =1
	 and demrm_deleted_ind = 1
	 and entm_deleted_ind =1                                
     --                
     END                
     ELSE                
     BEGIN                
     --                
     SELECT DEMRM_ID ID ,DEMRM_ISIN ISIN ,DEMRM_SLIP_SERIAL_NO DRF_NO,DEMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO,ISNULL(DEMRM_TRANSACTION_NO,'') DRN_NO                                              
    ,CONVERT(VARCHAR,ISNULL(DEMRM_REQUEST_DT,''),103) REQUEST_DT ,DPAM_SBA_NO , DISP_ID                                          
    ,DPAM_SBA_NAME,CONVERT(VARCHAR,ISNULL(DEMRM_EXECUTION_DT,''),103) EXECUTION_DT ,Convert(numeric(18,3),DEMRM_QTY) QTY                                              
    ,CONVERT(VARCHAR,DISP_DT,103) DISP_DT,ISNULL(DISP_DOC_ID,'0') DISP_DOC_ID,ISNULL(DISP_NAME,'') DISP_NAME,ISNULL(DISP_CONF_RECD,'') DISP_CONF_RECD                          
    ,ENTM_NAME1 RTA_NAME            
    ,disp_rta_cd RTA_CD        
    ,disp_cons_no CONS_NO,DISP_TYPE = CASE WHEN DISP_TYPE = 'F' THEN 'FOLLOW UP' ELSE 'NEW' END  ,ISIN_NAME                
    ,isin_adr1 + ',' + isin_adr2 + ',' + isin_adr3 + ',' + isin_adrcity + ',' + isin_adrstate + ',' + 
     isin_adrcountry + ',' + isin_adrzip RTA_ADDRESS						                                                                                            
     FROM DMAT_DISPATCH , DEMAT_REQUEST_MSTR , DP_ACCT_MSTR , ENTITY_MSTR,isin_mstr  
	 WHERE DEMRM_DPAM_ID = DPAM_ID 
     and DEMRM_ISIN = ISIN_CD
	 AND DEMRM_ID = DISP_DEMRM_ID                                             
	 --AND DPAM_DPM_ID = @l_dpm_dpid     
     AND  DISP_TO = 'R'            
	-- and isnull(DISP_CONF_RECD,'') <> ''              
     AND disp_rta_cd = case when @L_EXCSM_CD = 'nsdl' then ltrim(rtrim(entm_short_name))  else  replace(ltrim(rtrim(entm_short_name)),'RTA_','') end            
     AND entm_enttm_cd = case when  @L_EXCSM_CD = 'nsdl' then 'SR' else 'RTA' end                                             
     AND CASE WHEN @PA_SEARCH_C3 <> '' THEN @PA_SEARCH_C3 ELSE '' END = CASE WHEN @PA_SEARCH_C3 <> '' THEN disp_cons_no ELSE '' END                
     and isin_cd like case when @PA_SEARCH_C6 <> '' then @PA_SEARCH_C6 else '%' end
     AND  ISNULL(DEMRM_TRANSACTION_NO,'')<>''   
	 and dpam_deleted_ind =1
	 and demrm_deleted_ind = 1
	 and entm_deleted_ind =1                    
     --                
     END                  
  --              
  END                 
  ELSE IF @PA_SEARCH_C10 ='REMAT'              
  BEGIN                    
  --              
    IF @PA_SEARCH_C2 <> ''                 
    BEGIN                    
    --                                    
    SELECT REMRM_ID ID ,REMRM_ISIN ISIN ,REMRM_SLIP_SERIAL_NO DRF_NO ,REMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO,ISNULL(REMRM_TRANSACTION_NO,'') DRN_NO                                                                                   
    ,CONVERT(VARCHAR,ISNULL(REMRM_REQUEST_DT,''),103) REQUEST_DT ,DPAM_SBA_NO , DISPR_ID   DISP_ID                                       
    ,DPAM_SBA_NAME,CONVERT(VARCHAR,ISNULL(REMRM_EXECUTION_DT,''),103) EXECUTION_DT ,Convert(numeric(18,3),REMRM_QTY) QTY                                             
    ,CONVERT(VARCHAR,DISPR_DT,103) DISP_DT,ISNULL(DISPR_DOC_ID,'0') DISP_DOC_ID,ISNULL(DISPR_NAME,'') DISP_NAME,ISNULL(DISPR_CONF_RECD,'') DISP_CONF_RECD                                                 
    ,ENTM_NAME1 RTA_NAME            
    ,dispR_rta_cd RTA_CD          
    ,dispr_cons_no  CONS_NO,DISP_TYPE = CASE WHEN DISPR_TYPE = 'F' THEN 'FOLLOW UP' ELSE 'NEW' END   ,ISIN_NAME               
     FROM DMAT_DISPATCH_REMAT , REMAT_REQUEST_MSTR , DP_ACCT_MSTR, ENTITY_MSTR,isin_mstr
	 WHERE REMRM_DPAM_ID = DPAM_ID 
	 and REMRM_ISIN = ISIN_CD
	 --AND DPAM_DPM_ID = @l_dpm_dpid     
	 AND REMRM_ID = DISPR_REMRM_ID                                             
     AND  DISPR_TO = 'R'           
     AND dispR_rta_cd = case when @L_EXCSM_CD = 'nsdl' then ltrim(rtrim(entm_short_name))  else  replace(ltrim(rtrim(entm_short_name)),'RTA_','') end            
     AND entm_enttm_cd = case when  @L_EXCSM_CD = 'nsdl' then 'SR' else 'RTA' end                                           
	 AND DISPR_DT = CONVERT(DATETIME,@PA_SEARCH_C2+ ' 00:00:00:000',103) 
     AND ISNULL(DISPR_CONF_RECD,'') <> '' 
     AND CASE WHEN @PA_SEARCH_C3 <> '' THEN @PA_SEARCH_C3 ELSE '' END = CASE WHEN @PA_SEARCH_C3 <> '' THEN dispr_cons_no ELSE '' END         
     AND  ISNULL(REMRM_TRANSACTION_NO,'')<>''     
	 and dpam_deleted_ind =1
	 and Remrm_deleted_ind = 1
	 and entm_deleted_ind =1                        
     --                
     END                
     ELSE                
     BEGIN                
     --                
     SELECT REMRM_ID ID ,REMRM_ISIN ISIN ,REMRM_SLIP_SERIAL_NO DRF_NO ,REMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO,ISNULL(REMRM_TRANSACTION_NO,'') DRN_NO                                                                                  
    ,CONVERT(VARCHAR,ISNULL(REMRM_REQUEST_DT,''),103) REQUEST_DT ,DPAM_SBA_NO , DISPR_ID DISP_ID                                         
    ,DPAM_SBA_NAME,CONVERT(VARCHAR,ISNULL(REMRM_EXECUTION_DT,''),103) EXECUTION_DT ,Convert(numeric(18,3),REMRM_QTY) QTY                                          
    ,CONVERT(VARCHAR,DISPR_DT,103) DISP_DT,ISNULL(DISPR_DOC_ID,'0') DISP_DOC_ID,ISNULL(DISPR_NAME,'') DISP_NAME,ISNULL(DISPR_CONF_RECD,'') DISP_CONF_RECD                                                 
    ,ENTM_NAME1 RTA_NAME            
    ,dispR_rta_cd RTA_CD          
    ,dispr_cons_no  CONS_NO,DISP_TYPE = CASE WHEN DISPR_TYPE = 'F' THEN 'FOLLOW UP' ELSE 'NEW' END  ,ISIN_NAME            
     FROM DMAT_DISPATCH_REMAT , REMAT_REQUEST_MSTR , DP_ACCT_MSTR, ENTITY_MSTR,isin_mstr
	 WHERE REMRM_DPAM_ID = DPAM_ID 
	 and rEMRM_ISIN = ISIN_CD
	 --AND DPAM_DPM_ID = @l_dpm_dpid  
	 AND REMRM_ID = DISPR_REMRM_ID                                             
     AND DISPR_TO = 'R'            
     AND dispR_rta_cd = case when @L_EXCSM_CD = 'nsdl' then ltrim(rtrim(entm_short_name))  else  replace(ltrim(rtrim(entm_short_name)),'RTA_','') end            
     AND entm_enttm_cd = case when  @L_EXCSM_CD = 'nsdl' then 'SR' else 'RTA' end                                             
     AND ISNULL(DISPR_CONF_RECD,'') <> ''  
     AND CASE WHEN @PA_SEARCH_C3 <> '' THEN @PA_SEARCH_C3 ELSE '' END = CASE WHEN @PA_SEARCH_C3 <> '' THEN dispr_cons_no ELSE '' END              
     AND ISNULL(REMRM_TRANSACTION_NO,'')<>''  
	 and dpam_deleted_ind =1
	 and Remrm_deleted_ind = 1
	 and entm_deleted_ind =1                       
     --                
     END                  
  --              
  END                                    
END                         
                    
ELSE IF @PA_ACTION = 'DISP_RTA_CONF'                                                              
 BEGIN                                                
 --               
   IF @PA_SEARCH_C10 = 'DEMAT'                      
   BEGIN              
     IF @PA_SEARCH_C2 <> ''                 
     BEGIN                    
     --                                      
		  SELECT DEMRM_ID ID ,DEMRM_ISIN ISIN ,DEMRM_SLIP_SERIAL_NO DRF_NO ,DEMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO ,ISNULL(DEMRM_TRANSACTION_NO,'') DRN_NO                   
		 ,CONVERT(VARCHAR,ISNULL(DEMRM_REQUEST_DT,''),103) REQUEST_DT ,CONVERT(VARCHAR,ISNULL(DEMRM_EXECUTION_DT,''),103) EXECUTION_DT ,Convert(numeric(18,3),DEMRM_QTY) QTY                                               
		 ,CONVERT(VARCHAR,DISP_DT,103) DISP_DT,ISNULL(DISP_DOC_ID,'0') DISP_DOC_ID,ISNULL(DISP_NAME,'') DISP_NAME,ISNULL(DISP_CONF_RECD,'') DISP_CONF_RECD                                                 
		 ,disp_cons_no CONS_NO,disp_type = case when DISP_TYPE = 'F' then 'FOLLOW UP' else 'NEW' END
		  FROM DMAT_DISPATCH , DEMAT_REQUEST_MSTR,DP_ACCT_MSTR  
		  WHERE DEMRM_ID = DISP_DEMRM_ID                                             
		  AND   DEMRM_DPAM_ID = DPAM_ID
		  AND   DPAM_DPM_ID = @l_dpm_dpid
		  AND  DISP_TO = 'R'                                               
		  AND DISP_DT   BETWEEN CONVERT(DATETIME,@PA_SEARCH_C2,103) AND  CONVERT(DATETIME,@PA_SEARCH_C3,103)                                    
		  AND ISNULL(DISP_CONF_RECD,'') = ''                
		  AND ISNULL(DEMRM_TRANSACTION_NO,'')<>''   
		  AND DEMRM_DELETED_IND =1
		  AND DPAM_DELETED_IND = 1   
     --                
     END                
     ELSE                
     BEGIN                
     --                
			SELECT DEMRM_ID ID ,DEMRM_ISIN ISIN ,DEMRM_SLIP_SERIAL_NO DRF_NO ,DEMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO ,ISNULL(DEMRM_TRANSACTION_NO,'') DRN_NO                   
			,CONVERT(VARCHAR,ISNULL(DEMRM_REQUEST_DT,''),103) REQUEST_DT ,CONVERT(VARCHAR,ISNULL(DEMRM_EXECUTION_DT,''),103) EXECUTION_DT ,Convert(numeric(18,3),DEMRM_QTY) QTY                                           
			,CONVERT(VARCHAR,DISP_DT,103) DISP_DT,ISNULL(DISP_DOC_ID,'0') DISP_DOC_ID,ISNULL(DISP_NAME,'') DISP_NAME,ISNULL(DISP_CONF_RECD,'') DISP_CONF_RECD                                                 
			,disp_cons_no CONS_NO,disp_type = case when DISP_TYPE = 'F' then 'FOLLOW UP' else 'NEW' END
			FROM DMAT_DISPATCH , DEMAT_REQUEST_MSTR,DP_ACCT_MSTR    
			WHERE DEMRM_ID = DISP_DEMRM_ID            
 		    AND  DEMRM_DPAM_ID = DPAM_ID
		    AND  DPAM_DPM_ID = @l_dpm_dpid                                 
			AND  DISP_TO = 'R'                                               
			AND ISNULL(DISP_CONF_RECD,'') = ''                
			AND ISNULL(DEMRM_TRANSACTION_NO,'') <> ''   
			AND DEMRM_DELETED_IND = 1
			AND DPAM_DELETED_IND = 1                        
     --                
     END                    
  --              
  END                
  ELSE IF @PA_SEARCH_C10 = 'REMAT'                      
  BEGIN              
   IF @PA_SEARCH_C2 <> ''                 
   BEGIN                    
   --                                      
				SELECT REMRM_ID ID,REMRM_ISIN ISIN,REMRM_SLIP_SERIAL_NO DRF_NO,REMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO ,ISNULL(REMRM_TRANSACTION_NO,'') DRN_NO                                               
				,CONVERT(VARCHAR,ISNULL(REMRM_REQUEST_DT,''),103) REQUEST_DT ,CONVERT(VARCHAR,ISNULL(REMRM_EXECUTION_DT,''),103) EXECUTION_DT ,Convert(numeric(18,3),REMRM_QTY) QTY                                           
				,CONVERT(VARCHAR,DISPR_DT,103) DISP_DT,ISNULL(DISPR_DOC_ID,'0') DISP_DOC_ID,ISNULL(DISPR_NAME,'') DISP_NAME,ISNULL(DISPR_CONF_RECD,'') DISP_CONF_RECD                                                 
				,dispr_cons_no CONS_NO,disp_type = case when DISPR_TYPE = 'F' then 'FOLLOW UP' else 'NEW' END
				FROM DMAT_DISPATCH_REMAT , REMAT_REQUEST_MSTR ,DP_ACCT_MSTR    
				WHERE REMRM_ID = DISPR_REMRM_ID            
				AND   REMRM_DPAM_ID = DPAM_ID
				AND   DPAM_DPM_ID = @l_dpm_dpid                                 
				AND  DISPR_TO = 'R'                                               
				AND DISPR_DT   BETWEEN CONVERT(DATETIME,@PA_SEARCH_C2,103) AND  CONVERT(DATETIME,@PA_SEARCH_C3,103)                            
				AND ISNULL(DISPR_CONF_RECD,'') = ''                
				AND  ISNULL(REMRM_TRANSACTION_NO,'')<>''   
				AND REMRM_DELETED_IND =1
				AND DPAM_DELETED_IND = 1                        
   --                
   END                
   ELSE                
   BEGIN                
   --                
				SELECT REMRM_ID ID,REMRM_ISIN ISIN,REMRM_SLIP_SERIAL_NO DRF_NO,REMRM_SLIP_SERIAL_NO SLIP_SERIAL_NO ,ISNULL(REMRM_TRANSACTION_NO,'') DRN_NO                                               
				,CONVERT(VARCHAR,ISNULL(REMRM_REQUEST_DT,''),103) REQUEST_DT ,CONVERT(VARCHAR,ISNULL(REMRM_EXECUTION_DT,''),103) EXECUTION_DT ,Convert(numeric(18,3),REMRM_QTY) QTY                                      
				,CONVERT(VARCHAR,DISPR_DT,103) DISP_DT,ISNULL(DISPR_DOC_ID,'0') DISP_DOC_ID,ISNULL(DISPR_NAME,'') DISP_NAME,ISNULL(DISPR_CONF_RECD,'') DISP_CONF_RECD                                                 
				,dispr_cons_no CONS_NO,disp_type = case when DISPR_TYPE = 'F' then 'FOLLOW UP' else 'NEW' END
				FROM DMAT_DISPATCH_DEMAT,REMAT_REQUEST_MSTR,DP_ACCT_MSTR  
				WHERE REMRM_ID = DISPR_REMRM_ID        
				AND   REMRM_DPAM_ID = DPAM_ID
				AND   DPAM_DPM_ID = @l_dpm_dpid                                 
				AND   DISPR_TO = 'R'        
				AND   REMRM_DPAM_ID = DPAM_ID
				AND   DPAM_DPM_ID = @l_dpm_dpid                                           
				AND ISNULL(DISPR_CONF_RECD,'') = ''                
				AND  ISNULL(REMRM_TRANSACTION_NO,'')<>''                       
				AND REMRM_DELETED_IND =1
				AND DPAM_DELETED_IND = 1 
   --                
   END                    
  --              
  END                                   
--                                        
END                                       
ELSE IF @PA_ACTION = 'DIGITAL_SIGN'                                  
  BEGIN                                  
  --                
 SELECT alwd_id,alwd_sign_name,alwd_sign_email,convert(varchar,alwd_from_dt,103) alwd_from_dt,convert(varchar,alwd_to_dt,103) alwd_to_dt,alwd_deleted_ind,bitrm_values,alwd_user_name                                  
    FROM allowed_signatory,bitmap_ref_mstr                               
 WHERE BITRM_PARENT_CD = CASE WHEN @pa_search_c1 = 'CDSL' THEN 'CDSL_DIG_SIGN_REQD' WHEN @pa_search_c1 = 'NSDL' THEN 'NSDL_DIG_SIGN_REQD' end                                    
    --AND alwd_excsm_id = @pa_search_c2                              
    AND alwd_dpm_dpid = @pa_search_c2                              
  --                                  
  END                                   
  ELSE IF @PA_ACTION = 'DIGISIGN_REF_UPD'                 
  BEGIN                                  
  --                                  
     DECLARE @l_desc varchar(1000)                              
                                   
     SET @l_desc = CASE WHEN @pa_dpname = 'CDSL' THEN 'CDSL_DIG_SIGN_REQD' WHEN @pa_dpname = 'NSDL' THEN 'NSDL_DIG_SIGN_REQD' END                              
                              
     IF EXISTS(SELECT bitrm_id FROM BITMAP_REF_MSTR brm WHERE bitrm_parent_cd = @l_desc)                              
  UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,@pa_search_c2)                               
  WHERE  BITRM_PARENT_CD = CASE WHEN @pa_dpname = 'CDSL' THEN 'CDSL_DIG_SIGN_REQD' WHEN @pa_dpname = 'NSDL' THEN 'NSDL_DIG_SIGN_REQD' END                              
     ELSE INSERT INTO BITMAP_REF_MSTR SELECT max(bitrm_id)+1,@l_desc, @l_dpm_dpid, @pa_search_c1,1,'','HO',getdate(),'HO',getdate(),1 FROM bitmap_ref_mstr                              
  --                                  
  END                                              
                                                
if @pa_action = 'INWCR_SEL'          
BEGIN                            
--                            
 select @pa_search_c4 = dpm_id from dp_mstr where dpm_excsm_id = @pa_search_c2 and dpm_deleted_ind =1                        
                        
  SELECT compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd +'-'+ dpm.DPM_DPID   Depository                     
  ,convert(varchar(11),inwcr.inwcr_recvd_dt,103) ReceivedDate                                       
  ,inwcr.inwcr_frmno    FormNo                      
  ,inwcr.inwcr_name    Name                            
  ,inwcr.inwcr_charge_collected ChargeCollected                             
  ,FINA_ACC_NAME   BankName                       
,inwcr.inwcr_pay_mode  PaymentMode                       
,inwcr.inwcr_cheque_no                  
,inwcr.inwcr_clibank_accno                 
  ,inwcr.inwcr_rmks                             
  ,dpm.dpm_excsm_id                            
  ,inwcr.inwcr_id                        
 ,FINA_ACC_ID 
,FINA_ACC_TYPE ,    isnull(inwcr_clibank_name,'') inwcr_clibank_name
, convert(varchar(11),inwcr.inwcr_cheque_dt,103) inwcr_cheque_dt   ,inwcr_bank_branch       
      FROM INW_CLIENT_REG inwcr                                        
           ,  dp_mstr dpm                                         
           , company_mstr                                               
           , exch_seg_mstr excsm                                        
  , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                         
  , FIN_ACCOUNT_MSTR      bankacclist                                 
      WHERE inwcr.inwcr_dmpdpid = dpm.dpm_id                         
      AND   bankacclist.FINA_ACC_ID = INWCR.INWCR_BANK_ID                                         
      AND    dpm_excsm_id       = excsm.excsm_id                                          
      AND     excsm_compm_id     = compm_id                                        
      AND    excsm_list.excsm_id      = excsm.excsm_id                                        
      AND  dpm.dpm_deleted_ind =1                                              
      AND    inwcr.inwcr_deleted_ind =1                 
      AND    dpm.dpm_excsm_id  = @pa_search_c2                             
      AND    inwcr.inwcr_frmno LIKE CASE WHEN LTRIM(RTRIM(@pa_search_c3))     = '' THEN '%' ELSE @pa_search_c3  END                         
--                            
END                            
ELSE IF @pa_action = 'BILL_PERIOD_MISSED_ISIN'                                
BEGIN                        
IF @pa_search_c2='CDSL'                
BEGIN                
          
 
		insert into CLOSING_PRICE_MSTR_CDSL(CLOPM_DT,CLOPM_ISIN_CD,CLOPM_CDSL_RT,CLOPM_CREATED_BY
		,CLOPM_CREATED_DT,CLOPM_LST_UPD_BY,CLOPM_LST_UPD_DT,CLOPM_DELETED_IND,clopm_exch)  
		SELECT DISTINCT CDSHM_TRAS_DT DATE,CDSHM_ISIN ISIN--,ISIN_NAME=ISNULL(ISIN_NAME,''),                 
		,Last_Closing_Rate=                
		isnull((                
		SELECT top 1 clopm_cdsl_rt  FROM CLOSING_PRICE_MSTR_CDSL with (nolock ) WHERE                 
		CLOPM_DT < @pa_search_c3 and CDSHM_ISIN = CLOPM_ISIN_CD and CLOPM_CDSL_RT <>0 order by CLOPM_DT desc                
		),0)                 
		,'MIG',getdate(),'mig',getdate(),1,'BSE'
		FROM CDSL_HOLDING_DTLS with (nolock )  LEFT OUTER JOIN ISIN_MSTR with (nolock )  ON CDSHM_ISIN = ISIN_CD
		WHERE  NOT EXISTS (SELECT CLOPM_ISIN_CD FROM CLOSING_PRICE_MSTR_CDSL with (nolock )  WHERE                 
		CDSHM_TRAS_DT = CLOPM_DT AND CDSHM_ISIN=CLOPM_ISIN_CD)                
		AND CDSHM_DPM_ID=@l_dpm_dpid 
		and cdshm_isin is not null 
        and month(CDSHM_TRAS_DT)= month(@pa_search_c3)             
        and year(CDSHM_TRAS_DT)= year(@pa_search_c3)  


--		WITH CTE (CLOPM_ISIN_CD
--		,CLOPM_DT, DuplicateCount)
--		AS
--		(
--		SELECT CLOPM_ISIN_CD
--		,CLOPM_DT,
--		ROW_NUMBER() OVER(PARTITION BY CLOPM_ISIN_CD
--		,CLOPM_DT ORDER BY CLOPM_ISIN_CD
--		,CLOPM_DT ) AS DuplicateCount
--		FROM closing_price_mstr_cdsl 
--		where CLOPM_DELETED_IND = 1 
--		)
--
--		delete  
--		FROM CTE
--		WHERE DuplicateCount >1


		SELECT DISTINCT '' DATE,'' ISIN,'' ISIN_NAME
		,Last_Closing_Rate=             0              
		where 1=0                
                               
                
                
END                
ELSE IF @pa_search_c2='NSDL'                
BEGIN                
		                
		SELECT DISTINCT Convert(varchar(11),NSDHM_TRANSACTION_DT,103)  DATE,NSDHM_ISIN ISIN,ISIN_NAME=ISNULL(ISIN_NAME,''),                 
		Last_Closing_Rate=                
		isnull((                
		SELECT top 1 clopm_NSDL_rt  FROM CLOSING_PRICE_MSTR_NSDL WHERE                 
		CLOPM_DT < @pa_search_c3 and NSDHM_ISIN = CLOPM_ISIN_CD order by CLOPM_DT desc                
		),0)                 
		FROM NSDL_HOLDING_DTLS LEFT OUTER JOIN ISIN_MSTR ON NSDHM_ISIN = ISIN_CD
		WHERE  NOT EXISTS (SELECT CLOPM_ISIN_CD FROM CLOSING_PRICE_MSTR_NSDL WHERE                 
		NSDHM_TRANSACTION_DT = CLOPM_DT AND NSDHM_ISIN=CLOPM_ISIN_CD)                
		AND NSDHM_DPM_ID=@l_dpm_dpid  
        and month(NSDHM_TRANSACTION_DT)= month(@pa_search_c3)             
       and year(NSDHM_TRANSACTION_DT)= year(@pa_search_c3)           
  
                
                
END                
                
--                
END                 
IF @PA_ACTION = 'FREEZECDSL_SEL' 
BEGIN
--
	select case when fre_level = 'B' then 'BO' else 'BOISIN' end	FreezeLevel
		 ,case when fre_initiated_by = 1 then 'BO' else case when fre_initiated_by = 2 then 'CDSL' else 'DP' end end	InitiatedBy
		 ,case when fre_sub_option = 1 then 'LIEN' else case when fre_sub_option = 2 then 'STATUTORY BODIES' else '' end end	SubOption
		,right(dpam_sba_no,8)		BOID
		,fre_isin			ISIN
		,case when fre_qty_type = 'P' then 'PARTIAL' else case when fre_qty_type='F' then 'FULL' else '' end end	QtyType
		,fre_qty			Qty
		,case when fre_frozen_for ='1' then 'DEBIT' else case when fre_frozen_for='2' then 'CREDIT' else 'BOTH' end end		FrozenFor
		,case when fre_activation_type = 1 then 'CURRENT' else 'FUTURE' end ActivationType
		,convert(varchar(11),fre_activation_dt,103)	 ActivationDate
		,convert(varchar(11),fre_expiry_dt,103)		 Expirydate
		,fre_reason_cd		 
		,fre_int_ref_no      
		,fre_rmks			
		,fre_id
		,int_id
	from freeze_unfreeze_dtls_cdsl	
		,DP_ACCT_MSTR
		,dp_mstr
	WHERE fre_dpam_id = dpam_id
	AND  fre_dpmid = dpm_id
	and dpm_excsm_id =@pa_id
	AND dpam_sba_no like case when @pa_search_c3 <> '' then @pa_search_c3 else '%' end
	AND fre_isin like case when @pa_search_c2 <> '' then @pa_search_c2 else '%' end
	AND fre_activation_dt between convert(datetime,@pa_search_c5,103) AND convert(datetime,@pa_search_c6,103)
	AND fre_status = 'A'
	AND fre_trans_type = 'S'
	AND fre_deleted_ind = 1 	
	AND dpam_deleted_ind = 1
	AND dpm_deleted_ind =1
--		               
END
IF @PA_ACTION = 'FREEZECDSL_SELM' 
BEGIN
--
	IF @pa_search_c4 = '' 
	BEGIN
	--
		select case when fre_level = 'B' then 'BO' else 'BOISIN' end	FreezeLevel
			 ,case when fre_initiated_by = 1 then 'BO' else case when fre_initiated_by = 2 then 'CDSL' else 'DP' end end	InitiatedBy
			 ,case when fre_sub_option = 1 then 'LIEN' else case when fre_sub_option = 2 then 'STATUTORY BODIES' else '' end end	SubOption
			,right(dpam_sba_no,8)		BOID
			,fre_isin			ISIN
			,case when fre_qty_type = 'P' then 'PARTIAL' else case when fre_qty_type='F' then 'FULL' else '' end end	QtyType
			,fre_qty			Qty
			,case when fre_frozen_for ='1' then 'DEBIT' else case when fre_frozen_for='2' then 'CREDIT' else 'BOTH' end end		FrozenFor
			,case when fre_activation_type = 1 then 'CURRENT' else 'FUTURE' end ActivationType
			,convert(varchar(11),fre_activation_dt,103)	 ActivationDate
			,convert(varchar(11),fre_expiry_dt,103)		 Expirydate
			,fre_reason_cd		 
			,fre_int_ref_no      
			,fre_rmks			
			,fre_id
			,int_id
		from freeze_unfreeze_dtls_cdsl_mak	
			,DP_ACCT_MSTR
			,dp_mstr
		WHERE fre_dpam_id = dpam_id
		AND  fre_dpmid = dpm_id
		and dpm_excsm_id =@pa_id
		AND dpam_sba_no like case when @pa_search_c3 <> '' then @pa_search_c3 else '%' end
		AND fre_isin like case when @pa_search_c2 <> '' then @pa_search_c2 else '%' end
		AND convert(varchar(11),fre_activation_dt,103) between @pa_search_c5 AND @pa_search_c6
		AND fre_status = 'A'
		AND fre_deleted_ind IN (0,4,6)
		AND dpam_deleted_ind = 1
		AND dpm_deleted_ind =1
	--
	END
	ELSE
	BEGIN
	--
		select case when fre_level = 'B' then 'BO' else 'BOISIN' end	FreezeLevel
			 ,case when fre_initiated_by = 1 then 'BO' else case when fre_initiated_by = 2 then 'CDSL' else 'DP' end end	InitiatedBy
			 ,case when fre_sub_option = 1 then 'LIEN' else case when fre_sub_option = 2 then 'STATUTORY BODIES' else '' end end	SubOption
			,right(dpam_sba_no,8)		BOID
			,fre_isin			ISIN
			,case when fre_qty_type = 'P' then 'PARTIAL' else case when fre_qty_type='F' then 'FULL' else '' end end	QtyType
			,fre_qty			Qty
			,case when fre_frozen_for ='1' then 'DEBIT' else case when fre_frozen_for='2' then 'CREDIT' else 'BOTH' end end		FrozenFor
			,case when fre_activation_type = 1 then 'CURRENT' else 'FUTURE' end ActivationType
			,convert(varchar(11),fre_activation_dt,103)	 ActivationDate
			,convert(varchar(11),fre_expiry_dt,103)		 Expirydate
			,fre_reason_cd		 
			,fre_int_ref_no      
			,fre_rmks			
			,fre_id
			,int_id
		from freeze_unfreeze_dtls_cdsl_mak	
			,DP_ACCT_MSTR
			,dp_mstr
		WHERE fre_dpam_id = dpam_id
		AND  fre_dpmid = dpm_id
		and dpm_excsm_id =@pa_id
		AND fre_deleted_ind IN (0,4,6)
		AND int_id = convert(numeric,@pa_search_c4)
		AND fre_status = 'A'
		AND dpam_deleted_ind = 1
		AND dpm_deleted_ind =1
	--
	END
--		               
END
IF @PA_ACTION = 'FREEZECDSL_SELC' 
BEGIN
--
	select case when fre_level = 'B' then 'BO' else 'BOISIN' end	FreezeLevel
		 ,case when fre_initiated_by = 1 then 'BO' else case when fre_initiated_by = 2 then 'CDSL' else 'DP' end end	InitiatedBy
		 ,case when fre_sub_option = 1 then 'LIEN' else case when fre_sub_option = 2 then 'STATUTORY BODIES' else '' end end	SubOption
		,right(dpam_sba_no,8)		BOID
		,fre_isin			ISIN
		,case when fre_qty_type = 'P' then 'PARTIAL' else case when fre_qty_type='F' then 'FULL' else '' end end	QtyType
		,fre_qty			Qty
		,case when fre_frozen_for ='1' then 'DEBIT' else case when fre_frozen_for='2' then 'CREDIT' else 'BOTH' end end		FrozenFor
		,case when fre_activation_type = 1 then 'CURRENT' else 'FUTURE' end ActivationType
		,int_id
		,fre_deleted_ind
	from freeze_unfreeze_dtls_cdsl_mak	
		,DP_ACCT_MSTR
		,dp_mstr
	WHERE fre_dpam_id = dpam_id
	AND  fre_dpmid = dpm_id
	and dpm_excsm_id =@pa_id
	AND fre_deleted_ind IN (0,4,6)
	AND fre_lst_upd_by <> @pa_login_name
	AND fre_status = 'A'
	AND dpam_deleted_ind = 1
	AND dpm_deleted_ind =1
--		               
END
IF @PA_ACTION = 'UNFREEZECDSL_SEL' 
BEGIN
--
	select case when F.fre_level = 'B' then 'BO' else 'BOISIN' end	FreezeLevel
		 ,case when F.fre_initiated_by = 1 then 'BO' else case when F.fre_initiated_by = 2 then 'CDSL' else 'DP' end end	InitiatedBy
		 ,case when F.fre_sub_option = 1 then 'LIEN' else case when F.fre_sub_option = 2 then 'STATUTORY BODIES' else '' end end	SubOption
		,right(dpam_sba_no,8)		BOID
		,F.fre_isin			ISIN
		,case when F.fre_qty_type = 'P' then 'PARTIAL' else case when F.fre_qty_type='F' then 'FULL' else '' end end	QtyType
		,F.fre_qty			Qty
		,case when F.fre_frozen_for ='1' then 'DEBIT' else case when F.fre_frozen_for='2' then 'CREDIT' else 'BOTH' end end		FrozenFor
		,case when F.fre_activation_type = 1 then 'CURRENT' else 'FUTURE' end ActivationType
		,convert(varchar(11),F.fre_activation_dt,103)	 ActivationDate
		,convert(varchar(11),F.fre_expiry_dt,103)		 Expirydate
		,F.fre_reason_cd		 
		,F.fre_int_ref_no      
		,UF.fre_rmks			
		,F.fre_id
		,UF.int_id
	from freeze_unfreeze_dtls_cdsl F,freeze_unfreeze_dtls_cdsl UF
		,DP_ACCT_MSTR
		,dp_mstr
	WHERE F.fre_id = UF.fre_id
	AND F.fre_dpam_id = dpam_id
	AND  F.fre_dpmid = dpm_id
	and dpm_excsm_id =@pa_id
	AND F.fre_status = 'I' 
	AND UF.fre_trans_type = 'U'
	AND convert(datetime,UF.fre_lst_upd_dt,103) between convert(datetime,@pa_search_c5,103) AND convert(datetime,@pa_search_c6,103) + '23:59:59'
	AND F.fre_deleted_ind = 1 	
	AND UF.fre_deleted_ind = 1 	
	AND dpam_deleted_ind = 1
	AND dpm_deleted_ind =1
--
END	
IF @PA_ACTION = 'UNFREEZECDSL_SELM' 
BEGIN
--
	IF @pa_search_c4 = '' 
	BEGIN
	--
	select case when freezemstr.fre_level = 'B' then 'BO' else 'BOISIN' end	FreezeLevel
		 ,case when freezemstr.fre_initiated_by = 1 then 'BO' else case when freezemstr.fre_initiated_by = 2 then 'CDSL' else 'DP' end end	InitiatedBy
		 ,case when freezemstr.fre_sub_option = 1 then 'LIEN' else case when freezemstr.fre_sub_option = 2 then 'STATUTORY BODIES' else '' end end	SubOption
		,right(dpam_sba_no,8)		BOID
		,freezemstr.fre_isin			ISIN
		,case when freezemstr.fre_qty_type = 'P' then 'PARTIAL' else case when freezemstr.fre_qty_type='F' then 'FULL' else '' end end	QtyType
		,freezemstr.fre_qty			Qty
		,case when freezemstr.fre_frozen_for ='1' then 'DEBIT' else case when freezemstr.fre_frozen_for='2' then 'CREDIT' else 'BOTH' end end		FrozenFor
		,case when freezemstr.fre_activation_type = 1 then 'CURRENT' else 'FUTURE' end ActivationType
		,convert(varchar(11),freezemstr.fre_activation_dt,103)	 ActivationDate
		,convert(varchar(11),freezemstr.fre_expiry_dt,103)		 Expirydate
		,freezemstr.fre_reason_cd		 
		,freezemstr.fre_int_ref_no      
		,freezemkr.fre_rmks			
		,freezemkr.fre_id
		,freezemkr.int_id
	from freeze_unfreeze_dtls_cdsl freezemstr
		,freeze_unfreeze_dtls_cdsl_mak freezemkr
		,DP_ACCT_MSTR
		,dp_mstr
	WHERE freezemstr.fre_dpam_id = dpam_id
	AND  freezemstr.fre_dpmid = dpm_id
	AND freezemstr.fre_id = freezemkr.fre_id
	AND freezemkr.fre_trans_type = 'U'
	and dpm_excsm_id =@pa_id
	AND convert(datetime,freezemkr.fre_lst_upd_dt,103) between convert(datetime,@pa_search_c5,103) and convert(datetime,@pa_search_c6,103) + '23:59:59'
	AND freezemstr.fre_deleted_ind = 1 
	AND freezemkr.fre_deleted_ind  in(0,4,6)	
	AND dpam_deleted_ind = 1
	AND dpm_deleted_ind =1
	--
	END
	ELSE
	BEGIN
	--
		select case when freezemstr.fre_level = 'B' then 'BO' else 'BOISIN' end	FreezeLevel
		 ,case when freezemstr.fre_initiated_by = 1 then 'BO' else case when freezemstr.fre_initiated_by = 2 then 'CDSL' else 'DP' end end	InitiatedBy
		 ,case when freezemstr.fre_sub_option = 1 then 'LIEN' else case when freezemstr.fre_sub_option = 2 then 'STATUTORY BODIES' else '' end end	SubOption
		,right(dpam_sba_no,8)		BOID
		,freezemstr.fre_isin			ISIN
		,case when freezemstr.fre_qty_type = 'P' then 'PARTIAL' else case when freezemstr.fre_qty_type='F' then 'FULL' else '' end end	QtyType
		,freezemstr.fre_qty			Qty
		,case when freezemstr.fre_frozen_for ='1' then 'DEBIT' else case when freezemstr.fre_frozen_for='2' then 'CREDIT' else 'BOTH' end end		FrozenFor
		,case when freezemstr.fre_activation_type = 1 then 'CURRENT' else 'FUTURE' end ActivationType
		,convert(varchar(11),freezemstr.fre_activation_dt,103)	 ActivationDate
		,convert(varchar(11),freezemstr.fre_expiry_dt,103)		 Expirydate
		,freezemstr.fre_reason_cd		 
		,freezemstr.fre_int_ref_no      
		,freezemkr.fre_rmks			
		,freezemkr.fre_id
		,freezemkr.int_id
	from freeze_unfreeze_dtls_cdsl freezemstr
		,freeze_unfreeze_dtls_cdsl_mak freezemkr
		,DP_ACCT_MSTR
		,dp_mstr
	WHERE freezemstr.fre_dpam_id = dpam_id
	AND  freezemstr.fre_dpmid = dpm_id
	AND freezemstr.fre_id = freezemkr.fre_id
	AND freezemkr.fre_trans_type = 'U'
	and dpm_excsm_id =@pa_id
	AND freezemkr.int_id  = convert(numeric,@pa_search_c4)
	AND freezemstr.fre_deleted_ind = 1 
	AND freezemkr.fre_deleted_ind  in(0,4,6)	
	AND dpam_deleted_ind = 1
	AND dpm_deleted_ind =1
	--
	END
--
END
IF @PA_ACTION = 'UNFREEZECDSL_SELC' 
BEGIN
--
	select case when freezemstr.fre_level = 'B' then 'BO' else 'BOISIN' end	FreezeLevel
		 ,case when freezemstr.fre_initiated_by = 1 then 'BO' else case when freezemstr.fre_initiated_by = 2 then 'CDSL' else 'DP' end end	InitiatedBy
		 ,case when freezemstr.fre_sub_option = 1 then 'LIEN' else case when freezemstr.fre_sub_option = 2 then 'STATUTORY BODIES' else '' end end	SubOption
		,right(dpam_sba_no,8)		BOID
		,freezemstr.fre_isin			ISIN
		,case when freezemstr.fre_qty_type = 'P' then 'PARTIAL' else case when freezemstr.fre_qty_type='F' then 'FULL' else '' end end	QtyType
		,freezemstr.fre_qty			Qty
		,case when freezemstr.fre_frozen_for ='1' then 'DEBIT' else case when freezemstr.fre_frozen_for='2' then 'CREDIT' else 'BOTH' end end		FrozenFor
		,case when freezemstr.fre_activation_type = 1 then 'CURRENT' else 'FUTURE' end ActivationType
		,freezemkr.int_id
		,freezemkr.fre_deleted_ind
	from freeze_unfreeze_dtls_cdsl freezemstr
		,freeze_unfreeze_dtls_cdsl_mak	freezemkr
		,DP_ACCT_MSTR
		,dp_mstr
	WHERE freezemstr.fre_dpam_id = dpam_id
	AND  freezemstr.fre_dpmid = dpm_id
	and freezemkr.fre_id = freezemstr.fre_id
	and dpm_excsm_id =@pa_id
	AND freezemkr.fre_deleted_ind IN (0,4,6,-1)
	AND freezemkr.fre_lst_upd_by <> @pa_login_name
	AND dpam_deleted_ind = 1
	--AND freezemstr.fre_status = 'I'
	and freezemkr.fre_trans_type = 'U'
	AND freezemstr.fre_deleted_ind = 1
	AND dpm_deleted_ind =1
--		               
END             

ELSE IF @pa_action = 'MULTISLIP_TRX_SELM_CDSL'        
BEGIN        
--        
	IF @pa_search_c3 = ''        
	BEGIN        
	--        
	SELECT distinct  convert(varchar,dptdc_request_dt,103)             REQUESTDATE         
	,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE        
	,dptdc_slip_no                                     SLIPNO         
	,right(dpam_sba_no,8)                                    ACCOUNTNO        
	
	,dptdc_dtls_id                                     DTLSID        
	--,dptdc_internal_trastm        
	,dptdc_rmks        
	FROM   citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam         
	,dptdc_mak                    dptdc         
	WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id        
	AND     convert(varchar,dptdc.dptdc_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_search_c6,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_search_c6 end        
	AND    dptdc.dptdc_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_search_c4)) = '' THEN '%' ELSE @pa_search_c4 END        
	AND    dpam.dpam_sba_no           LIKE CASE WHEN LTRIM(RTRIM(@pa_search_c5)) = '' THEN '%' ELSE @pa_search_c5 END        
	AND    dptdc_deleted_ind           in (0,4,6,-1)   
	and    isnull(dptdc_brokerbatch_no,'') = ''    
	   
	--        
	END        
	ELSE        
	BEGIN        
	--        
	SELECT distinct  convert(varchar,dptdc_request_dt,103)             REQUESTDATE         
	,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE        
	,dptdc_slip_no                                     SLIPNO         
	,right(dpam_sba_no,8)                                      ACCOUNTNO        
	
	,dptdc_dtls_id                                     DTLSID        
	--,dptdc_internal_trastm        
	,dptdc_rmks        
	FROM   citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam         
	,dptdc_mak                    dptdc         
	WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id        
	AND     convert(varchar,dptdc.dptdc_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_search_c6,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_search_c6 end        
	AND    dptdc.dptdc_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_search_c4)) = '' THEN '%' ELSE @pa_search_c4 END        
	AND    dpam.dpam_sba_no           LIKE CASE WHEN LTRIM(RTRIM(@pa_search_c5)) = '' THEN '%' ELSE @pa_search_c5 END        
	AND    dptdc_deleted_ind           in (0,4,6,-1)    
	and    isnull(dptdc_brokerbatch_no,'') = ''   
	AND    dptdc_dtls_id             = @pa_search_c3      
	--        
	END        
        
  --        
  END  
  ELSE IF @pa_action = 'MULTISLIP_TRX_SELM_DTLS_CDSL'        
  BEGIN        
  --
 
  
     SELECT DISTINCT ISNULL(SETTM1.settm_id,0) settm_id ,isnull(SETTM1.settm_desc,'')                                  SETTLEMENT_TYPE        
            ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO        
            ,dptdc_counter_dp_id                               TARGERDPID         
            ,dptdc_counter_cmbp_id                             TARGERCMBPID        
            ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO        
            ,DPTDC_CM_ID                                       CMID         
            ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH  
			,case when DPTDC_CASH_TRF = 'Y' THEN 'YES' else case when DPTDC_CASH_TRF ='N' THEN 'NO' ELSE 'NA' END END CASHTYPE                         
			,case when DPTDC_REASON_CD = 1 then 'Gift' 
				 when DPTDC_REASON_CD = 2 then 'For offmkt sale/pur'
				 when DPTDC_REASON_CD = 3 then 'For onmkt sale/pur'
				 when DPTDC_REASON_CD = 4 then 'Trnsfr of a/c from dp to dp' 
				when DPTDC_REASON_CD = 5 then 'Trnsfr between 2 a/c of same hldr' else 'others' end  TRNSRECD
            ,dptdc_excm_id                                     EXCHANGEID        
            ,ISNULL(EXCM_CD,'') excm_cd
            ,dptdc_internal_trastm         
            ,dptdc_isin        
            ,convert(numeric(16,3),abs(dptdc_qty))               dptdc_qty        
            ,dptdc_id  
            ,DPTDC_REASON_CD  
            ,isnull(dptdc_other_settlement_no,'')       OTHERSETTLEMENTNO  
            ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE    
,ISNULL(SETTM2.settm_id,0) trg_settm_id  
 ,isnull((Select DPM_NAME from dp_mstr where DPM_DPID = dptdc_counter_dp_id),'')[TARGERDPNAME]               
      FROM   citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam         
             ,dptdc_mak                    dptdc         
             left outer join          
              settlement_type_mstr          settm1                  
           on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )            
           left outer join                  
           settlement_type_mstr          settm2                  
           on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)    
             LEFT OUTER JOIN
             citrus_usr.EXCHANGE_MSTR ON excm_id = dptdc_excm_id 
       WHERE dpam.dpam_id  = dptdc.dptdc_dpam_id        
       AND    dptdc_dtls_id             = @pa_search_c3      
       AND    dptdc_deleted_ind           in (0,4,6,-1)   
       and    isnull(dptdc_brokerbatch_no,'') = ''     
      
    
  --        
  END
  ELSE IF @pa_action = 'MULTISLIP_TRX_SEL_CDSL'        
  BEGIN        
  --        
	IF @pa_search_c3 = ''        
	BEGIN        
	--        
	SELECT distinct  convert(varchar,dptdc_request_dt,103)             REQUESTDATE         
	,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE        
	,dptdc_slip_no                                     SLIPNO         
	,right(dpam_sba_no,8)                                    ACCOUNTNO        
	
	,dptdc_dtls_id                                     DTLSID        
	--,dptdc_internal_trastm        
	,dptdc_rmks        
	FROM   citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam         
	,dp_trx_dtls_cdsl                    dptdc         
	WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id        
	AND     convert(varchar,dptdc.dptdc_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_search_c6,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_search_c6 end        
	AND    dptdc.dptdc_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_search_c4)) = '' THEN '%' ELSE @pa_search_c4 END        
	AND    dpam.dpam_sba_no           LIKE CASE WHEN LTRIM(RTRIM(@pa_search_c5)) = '' THEN '%' ELSE @pa_search_c5 END        
	AND    dptdc_deleted_ind           =1
	and    isnull(dptdc_brokerbatch_no,'') = ''    
	   
	--        
	END        
	ELSE        
	BEGIN        
	--        
	SELECT distinct  convert(varchar,dptdc_request_dt,103)             REQUESTDATE         
	,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE        
	,dptdc_slip_no                                     SLIPNO         
	,right(dpam_sba_no,8)                                      ACCOUNTNO        
	
	,dptdc_dtls_id                                     DTLSID        
	--,dptdc_internal_trastm        
	,dptdc_rmks        
	FROM   citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam         
	,dp_trx_dtls_cdsl                    dptdc         
	WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id        
	AND     convert(varchar,dptdc.dptdc_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_search_c6,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_search_c6 end        
	AND    dptdc.dptdc_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_search_c4)) = '' THEN '%' ELSE @pa_search_c4 END        
	AND    dpam.dpam_sba_no           LIKE CASE WHEN LTRIM(RTRIM(@pa_search_c5)) = '' THEN '%' ELSE @pa_search_c5 END        
	AND    dptdc_deleted_ind          =1 
	and    isnull(dptdc_brokerbatch_no,'') = ''  	
	AND    dptdc_dtls_id  = @pa_search_c3      
	--        
	END        
        
  --        
  END  
  ELSE IF @pa_action = 'MULTISLIP_TRX_SEL_DTLS_CDSL'        
  BEGIN        
  --
 
  
     SELECT DISTINCT ISNULL(SETTM1.settm_id,0) settm_id ,isnull(SETTM1.settm_desc,'')                                  SETTLEMENT_TYPE        
            ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO        
            ,dptdc_counter_dp_id                               TARGERDPID         
            ,dptdc_counter_cmbp_id                             TARGERCMBPID        
            ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO        
            ,DPTDC_CM_ID                                       CMID         
            ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH 
			,case when DPTDC_CASH_TRF = 'Y' THEN 'YES' else case when DPTDC_CASH_TRF ='N' THEN 'NO' ELSE 'NA' END END CASHTYPE                                                    
			,case when DPTDC_REASON_CD = 1 then 'Gift' 
				 when DPTDC_REASON_CD = 2 then 'For offmkt sale/pur'
				 when DPTDC_REASON_CD = 3 then 'For onmkt sale/pur'
				 when DPTDC_REASON_CD = 4 then 'Trnsfr of a/c from dp to dp' 
				when DPTDC_REASON_CD = 5 then 'Trnsfr between 2 a/c of same hldr' else 'others' end  TRNSRECD
            ,dptdc_excm_id                                     EXCHANGEID        
            ,ISNULL(EXCM_CD,'') excm_cd
            ,dptdc_internal_trastm         
            ,dptdc_isin        
            ,convert(numeric(16,3),abs(dptdc_qty))               dptdc_qty        
            ,dptdc_id  
            ,DPTDC_REASON_CD 
          ,isnull(dptdc_other_settlement_no,'')       OTHERSETTLEMENTNO  
          ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE  
,ISNULL(SETTM2.settm_id,0) trg_settm_id 
, isnull((Select DPM_NAME from dp_mstr where DPM_DPID = dptdc_counter_dp_id),'')[TARGERDPNAME]                     
      FROM   citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam         
             ,citrus_usr.DP_TRX_DTLS_CDSL                    dptdc         
             left outer join          
           settlement_type_mstr          settm1                  
           on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )            
           left outer join                  
           settlement_type_mstr          settm2                  
           on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)                 LEFT OUTER JOIN
             citrus_usr.EXCHANGE_MSTR ON excm_id = dptdc_excm_id 
       WHERE dpam.dpam_id  = dptdc.dptdc_dpam_id        
       AND    dptdc_dtls_id             = @pa_search_c3      
       AND    dptdc_deleted_ind           = 1  
       and    isnull(dptdc_brokerbatch_no,'') = ''     
      
    
  --        
  END   
  ELSE IF @pa_action = 'MULTISLIP_TRX_SELC_CDSL'        
  BEGIN        
  --
 
  
     SELECT distinct  convert(varchar,dptdc_request_dt,103)             REQUESTDATE         
	,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE        
	,dptdc_slip_no                                     SLIPNO         
	,right(dpam_sba_no,8)                                      ACCOUNTNO        
	,dptdc_dtls_id                                     DTLSID        
	--,dptdc_internal_trastm        
	,dptdc_rmks		REMARKS 
	, '0' dptdc_deleted_ind   
	FROM   citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam         
	,dptdc_mak                    dptdc         
	WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id        
	AND    dptdc_deleted_ind           in (0,4,6,-1)  
	and    isnull(dptdc_brokerbatch_no,'') = ''   
	aND    DPTDC_LST_UPD_BY <> @PA_LOGIN_NAME   
      
    
  --        
  END   
  
 IF @PA_ACTION = 'DISP_RTA_ISIN'                                                              
BEGIN                                                                
-- 
			IF @PA_SEARCH_C10 ='DEMAT'              
		   BEGIN               
		   -- 
					IF @PA_SEARCH_C9 ='N'              
					BEGIN  
						SELECT DISTINCT DEMRM_ISIN ISIN,ISIN_NAME                                                                  
						FROM DEMAT_REQUEST_MSTR,DP_ACCT_MSTR , ISIN_MSTR  , ENTITY_MSTR                                           
						WHERE DEMRM_DPAM_ID =  DPAM_ID 
						AND NOT EXISTS (SELECT DISP_DEMRM_ID FROM  DMAT_DISPATCH WHERE DEMRM_ID = DISP_DEMRM_ID AND DISP_TO = 'R')              
						AND DEMRM_CREDIT_RECD <> 'Y'
						AND (ISNULL(LTRIM(RTRIM(DEMRM_INTERNAL_REJ)),'') = '' or DEMRM_STATUS = 'S')
						AND ISNULL(LTRIM(RTRIM(DEMRM_COMPANY_OBJ)),'') = ''
						AND  ISNULL(DEMRM_TRANSACTION_NO,'')<>'' 
						AND ISIN_CD = DEMRM_ISIN                 
						AND ISIN_REG_CD = case when @L_EXCSM_CD = 'nsdl' then ltrim(rtrim(entm_short_name))  else  replace(ltrim(rtrim(entm_short_name)),'RTA_','') end            
						and entm_enttm_cd = case when  @L_EXCSM_CD = 'nsdl' then 'SR' else 'RTA' end     
						AND DPAM_DPM_ID = @l_dpm_dpid
						AND DPAM_DELETED_IND = 1
						AND DEMRM_DELETED_IND = 1
						AND ENTM_DELETED_IND = 1
					        
					END
					ELSE
					BEGIN
						SELECT DISTINCT DEMRM_ISIN ISIN,ISIN_NAME                                                                  
						FROM DEMAT_REQUEST_MSTR LEFT OUTER JOIN DMAT_DISPATCH ON DEMRM_ID = DISP_DEMRM_ID AND DISP_TO = 'R'  AND DISP_TYPE = 'N'  
						,DP_ACCT_MSTR , ISIN_MSTR  , ENTITY_MSTR                                           
						WHERE DEMRM_DPAM_ID =  DPAM_ID 
						AND DEMRM_CREDIT_RECD <> 'Y'
						AND ISNULL(LTRIM(RTRIM(DEMRM_INTERNAL_REJ)),'') = '' AND ISNULL(LTRIM(RTRIM(DEMRM_COMPANY_OBJ)),'') = ''
						AND  ISNULL(DEMRM_TRANSACTION_NO,'')<>'' 
						AND DISP_DEMRM_ID IS NOT NULL
						AND ISIN_CD = DEMRM_ISIN                 
						AND DISP_RTA_CD = case when @L_EXCSM_CD = 'nsdl' then ltrim(rtrim(entm_short_name))  else  replace(ltrim(rtrim(entm_short_name)),'RTA_','') end            
						and entm_enttm_cd = case when  @L_EXCSM_CD = 'nsdl' then 'SR' else 'RTA' end     
						AND DPAM_DPM_ID = @l_dpm_dpid
						AND DPAM_DELETED_IND = 1
						AND DEMRM_DELETED_IND = 1
						AND ENTM_DELETED_IND = 1

					END
		   --
		   END   
		   ELSE IF @PA_SEARCH_C10 ='REMAT'              
		   BEGIN               
		   -- 
					IF @PA_SEARCH_C9 ='N'              
					BEGIN 
							SELECT DISTINCT REMRM_ISIN ISIN,ISIN_NAME                                                                  
							FROM REMAT_REQUEST_MSTR ,DP_ACCT_MSTR, ISIN_MSTR  , ENTITY_MSTR                                           
							WHERE  REMRM_DPAM_ID =  DPAM_ID 
							AND NOT EXISTS (SELECT DISPR_REMRM_ID FROM  DMAT_DISPATCH_REMAT WHERE DISPR_REMRM_ID = REMRM_ID  AND DISPR_TO = 'R')              
							AND REMRM_CREDIT_RECD <> 'Y'             
							AND ISNULL(LTRIM(RTRIM(REMRM_INTERNAL_REJ)),'') = '' AND ISNULL(LTRIM(RTRIM(REMRM_COMPANY_OBJ)),'') = ''
							AND  ISNULL(REMRM_TRANSACTION_NO,'')<>'' 
							AND ISIN_CD = REMRM_ISIN                 
							AND ISIN_REG_CD = case when @L_EXCSM_CD = 'nsdl' then ltrim(rtrim(entm_short_name))  else  replace(ltrim(rtrim(entm_short_name)),'RTA_','') end            
							and entm_enttm_cd = case when  @L_EXCSM_CD = 'nsdl' then 'SR' else 'RTA' end             
							AND DPAM_DPM_ID = @l_dpm_dpid
							AND DPAM_DELETED_IND = 1
							AND REMRM_DELETED_IND = 1
							AND ENTM_DELETED_IND = 1
					END
					ELSE
					BEGIN
							SELECT DISTINCT REMRM_ISIN ISIN,ISIN_NAME                                                                  
							FROM REMAT_REQUEST_MSTR LEFT OUTER JOIN DMAT_DISPATCH_REMAT ON REMRM_ID = DISPR_REMRM_ID AND DISPR_TO = 'R'  AND DISPR_TYPE = 'N'  
							,DP_ACCT_MSTR, ISIN_MSTR  , ENTITY_MSTR                                           
							WHERE  REMRM_DPAM_ID =  DPAM_ID 
							AND ISIN_CD = REMRM_ISIN    
							AND REMRM_CREDIT_RECD <> 'Y'             
							AND ISNULL(LTRIM(RTRIM(REMRM_INTERNAL_REJ)),'') = '' AND ISNULL(LTRIM(RTRIM(REMRM_COMPANY_OBJ)),'') = ''
							AND  ISNULL(REMRM_TRANSACTION_NO,'')<>'' 
							AND DISPR_REMRM_ID IS NOT NULL
							AND DISPR_RTA_CD = case when @L_EXCSM_CD = 'nsdl' then ltrim(rtrim(entm_short_name))  else  replace(ltrim(rtrim(entm_short_name)),'RTA_','') end            
							and entm_enttm_cd = case when  @L_EXCSM_CD = 'nsdl' then 'SR' else 'RTA' end             
							AND DPAM_DPM_ID = @l_dpm_dpid
							AND DPAM_DELETED_IND = 1
							AND REMRM_DELETED_IND = 1
							AND ENTM_DELETED_IND = 1
					END
		   --
		   END                                                     
--
END 
ELSE IF @PA_ACTION = 'DISP_RTA_SEARCH_NEW'                                                              
BEGIN                                                                
--           
select @l_dpm_dpid = dpm_id ,@L_EXCSM_CD = EXCSM_EXCH_CD from dp_mstr, EXCH_SEG_MSTR where EXCSM_ID = DPM_EXCSM_ID AND DEFAULT_DP = @pa_id and dpm_deleted_ind = 1                                 
        
  IF @PA_SEARCH_C10 ='DEMAT'              
  BEGIN                    
  --              
    IF @PA_SEARCH_C2 <> ''                 
    BEGIN                    
    --  

    SELECT DISTINCT DEMRM_ISIN ISIN                                          
    ,CONVERT(VARCHAR,DISP_DT,103) DISP_DT
    ,disp_cons_no CONS_NO           
     FROM DMAT_DISPATCH , DEMAT_REQUEST_MSTR , DP_ACCT_MSTR, ENTITY_MSTR 
	 WHERE DEMRM_DPAM_ID = DPAM_ID 
	-- AND DPAM_DPM_ID = @l_dpm_dpid
	 AND DEMRM_ID = DISP_DEMRM_ID                                             
     AND  DISP_TO = 'R'           
	 AND  DISP_TYPE = @PA_SEARCH_C9
     AND disp_rta_cd = case when @L_EXCSM_CD = 'nsdl' then ltrim(rtrim(entm_short_name))  else  replace(ltrim(rtrim(entm_short_name)),'RTA_','') end            
     AND entm_enttm_cd = case when  @L_EXCSM_CD = 'nsdl' then 'SR' else 'RTA' end                                                                     
     AND CASE WHEN CONVERT(DATETIME,@PA_SEARCH_C2+ ' 00:00:00:000',103) <> '' THEN CONVERT(DATETIME,@PA_SEARCH_C2+ ' 00:00:00:000',103) ELSE '' END = CASE WHEN CONVERT(DATETIME,@PA_SEARCH_C2+ ' 00:00:00:000',103) <> '' THEN DISP_DT ELSE '' END                   
     AND CASE WHEN @PA_SEARCH_C3 <> '' THEN @PA_SEARCH_C3 ELSE '' END = CASE WHEN @PA_SEARCH_C3 <> '' THEN disp_cons_no ELSE '' END              
     and DEMRM_SLIP_SERIAL_NO like case when @PA_SEARCH_C4 <> '' then @PA_SEARCH_C4 else '%' end
     AND  ISNULL(DEMRM_TRANSACTION_NO,'')<>''                                 
	 AND DPAM_DELETED_IND = 1
	 AND ENTM_DELETED_IND = 1
	 AND DEMRM_DELETED_IND = 1
     --                
     END                
     ELSE                
     BEGIN                
     --           
		 SELECT DISTINCT DEMRM_ISIN ISIN                                          
		,CONVERT(VARCHAR,DISP_DT,103) DISP_DT
		,disp_cons_no CONS_NO                    
		 FROM DMAT_DISPATCH , DEMAT_REQUEST_MSTR , DP_ACCT_MSTR , ENTITY_MSTR
		 WHERE DEMRM_DPAM_ID = DPAM_ID 
		-- AND DPAM_DPM_ID = @l_dpm_dpid
		 AND DEMRM_ID = DISP_DEMRM_ID                                             
		 AND  DISP_TO = 'R'     
		 AND  DISP_TYPE = @PA_SEARCH_C9       
		 AND disp_rta_cd = case when @L_EXCSM_CD = 'nsdl' then ltrim(rtrim(entm_short_name))  else  replace(ltrim(rtrim(entm_short_name)),'RTA_','') end            
		 AND entm_enttm_cd = case when  @L_EXCSM_CD = 'nsdl' then 'SR' else 'RTA' end                                             
		 AND CASE WHEN @PA_SEARCH_C3 <> '' THEN @PA_SEARCH_C3 ELSE '' END = CASE WHEN @PA_SEARCH_C3 <> '' THEN disp_cons_no ELSE '' END                
		 AND  ISNULL(DEMRM_TRANSACTION_NO,'')<>''  
         and DEMRM_SLIP_SERIAL_NO = case when @PA_SEARCH_C4 <> '' then @PA_SEARCH_C4 else demrm_slip_serial_no end                    
		 AND DPAM_DELETED_IND = 1
		 AND ENTM_DELETED_IND = 1
		 AND DEMRM_DELETED_IND = 1
     --                
     END                  
  --              
  END                 
  ELSE IF @PA_SEARCH_C10 ='REMAT'              
  BEGIN                    
  --              
    IF @PA_SEARCH_C2 <> ''                 
    BEGIN                    
    --                                    
		 SELECT DISTINCT REMRM_ISIN ISIN                                          
		,CONVERT(VARCHAR,DISPR_DT,103) DISP_DT
		,dispR_cons_no CONS_NO            
		 FROM DMAT_DISPATCH_REMAT , REMAT_REQUEST_MSTR , DP_ACCT_MSTR, ENTITY_MSTR
		 WHERE REMRM_DPAM_ID = DPAM_ID 
		 --AND DPAM_DPM_ID = @l_dpm_dpid
		 AND REMRM_ID = DISPR_REMRM_ID                                             
		 AND  DISPR_TO = 'R'      
		 AND  DISPR_TYPE = @PA_SEARCH_C9     
		 AND dispR_rta_cd = case when @L_EXCSM_CD = 'nsdl' then ltrim(rtrim(entm_short_name))  else  replace(ltrim(rtrim(entm_short_name)),'RTA_','') end            
		 AND entm_enttm_cd = case when  @L_EXCSM_CD = 'nsdl' then 'SR' else 'RTA' end                                           
		 AND CASE WHEN @PA_SEARCH_C2 <> '' THEN @PA_SEARCH_C2 ELSE '' END = CASE WHEN @PA_SEARCH_C2 <> '' THEN DISPr_DT ELSE '' END              
		 AND CASE WHEN @PA_SEARCH_C3 <> '' THEN @PA_SEARCH_C3 ELSE '' END = CASE WHEN @PA_SEARCH_C3 <> '' THEN dispr_cons_no ELSE '' END         
		 AND  ISNULL(REMRM_TRANSACTION_NO,'')<>''       
		 AND DPAM_DELETED_IND = 1
		 AND ENTM_DELETED_IND = 1
		 AND REMRM_DELETED_IND = 1                     
     --                
     END                
     ELSE                
     BEGIN                
     --                
		SELECT DISTINCT REMRM_ISIN ISIN                                          
		,CONVERT(VARCHAR,DISPR_DT,103) DISP_DT
		,dispR_cons_no CONS_NO       
		 FROM DMAT_DISPATCH_REMAT , REMAT_REQUEST_MSTR , DP_ACCT_MSTR, ENTITY_MSTR  
		 WHERE REMRM_DPAM_ID = DPAM_ID 
		 --AND DPAM_DPM_ID = @l_dpm_dpid
		 AND REMRM_ID = DISPR_REMRM_ID                                             
		 AND  DISPR_TO = 'R' 
		 AND  DISPR_TYPE = @PA_SEARCH_C9                
		 AND dispR_rta_cd = case when @L_EXCSM_CD = 'nsdl' then ltrim(rtrim(entm_short_name))  else  replace(ltrim(rtrim(entm_short_name)),'RTA_','') end            
		 AND entm_enttm_cd = case when  @L_EXCSM_CD = 'nsdl' then 'SR' else 'RTA' end                                             
		 AND CASE WHEN @PA_SEARCH_C3 <> '' THEN @PA_SEARCH_C3 ELSE '' END = CASE WHEN @PA_SEARCH_C3 <> '' THEN dispr_cons_no ELSE '' END              
		 AND  ISNULL(REMRM_TRANSACTION_NO,'')<>''   
		 AND DPAM_DELETED_IND = 1
		 AND ENTM_DELETED_IND = 1
		 AND REMRM_DELETED_IND = 1                    
     --                
     END                  
  --              
  END                                    
END 
ELSE IF @pa_action = 'Getcmname'        
  BEGIN        
  --
 
  
     Select dpm_name from dp_mstr where dpm_dpid = @PA_id
     union
     Select ISNULL(Cm_Name1,'') from cm_mstr where CM_ID = replace(replace(@PA_id,'(',''),')','')
      
    
  --        
  END                                   
end

GO
