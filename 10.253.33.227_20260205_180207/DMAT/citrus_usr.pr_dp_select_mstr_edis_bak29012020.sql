-- Object: PROCEDURE citrus_usr.pr_dp_select_mstr_edis_bak29012020
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------














     
create PROCEDURE  [citrus_usr].[pr_dp_select_mstr_edis_bak29012020]( @pa_id  VARCHAR(800)                          
                                   ,@pa_action         VARCHAR(100)                          
                                   ,@pa_login_name     VARCHAR(20)                          
                                   ,@pa_cd             VARCHAR(25)                          
                                   ,@pa_desc           VARCHAR(250)                          
                                   ,@pa_rmks           VARCHAR(250)                          
                                   ,@pa_values         VARCHAR(8000)                         
                                   ,@pa_roles          VARCHAR(8000)                        
                                   ,@pa_scr_id         NUMERIC                        
                                   ,@rowdelimiter      CHAR(20)                          
                                   ,@coldelimiter      CHAR(20)                          
                                   ,@pa_ref_cur        VARCHAR(8000) OUT                          
                                  )                          
AS                        
/*                        
*********************************************************************************                        
 SYSTEM         : Dp                        
 MODULE NAME    : Pr_Select_Mstr                        
 DESCRIPTION    : This Procedure Will Contain The Select Queries For Master Tables                        
 COPYRIGHT(C)   : Marketplace Technologies                         
 VERSION HISTORY: 1.0                        
 VERS.  AUTHOR            DATE          REASON                        
 -----  -------------     ------------  --------------------------------------------------                        
 1.0    TUSHAR            08-OCT-2007   VERSION.                        
-----------------------------------------------------------------------------------*/                        
BEGIN                        
--  
 
--
--if @pa_action='OFFM_TRX_SELC_CDSL' 
--set @pa_id='--ALL--'

declare @l_temp_id table(id numeric)                        
  declare @l_count numeric                        
        , @l_tot_count numeric                        
        , @L_ENTTM_CD VARCHAR(25)                        
        , @l_dpm_dpid  int                        
        , @l_entm_id numeric                        
        , @l_stam_cd varchar(20)                        
        , @@fin_id   numeric             
        , @l_sql     varchar(8000)           
                 
        set @l_stam_cd ='ACTIVE'                        
                                
        declare @l_max_date datetime                        
           ,@l_rate     int                         
                                
        SET @L_ENTTM_CD = 'CLI' 
if @pa_action<>'POA_DOC_PATH_SIGN'                    
begin
  if  isnull(@pa_id,'') <> ''  and isnumeric(@pa_id) = 1                  
  begin                    
     if  len(@pa_id) < 5                    
     begin            
      select @l_dpm_dpid = dpm_id from dp_mstr where isnull(DEFAULT_DP,0) = @pa_id and dpm_deleted_ind = 1                         
     end            
  end           
  ELSE          
  BEGIN          
    IF  CITRUS_USR.FN_SPLITVAL(@PA_ID,2) <> ''          
    begin        
    select @l_dpm_dpid = dpm_id from dp_mstr where isnull(DEFAULT_DP,0) = CITRUS_USR.FN_SPLITVAL(@PA_ID,2) and dpm_deleted_ind = 1               
    end        
        
    SET @PA_ID = CITRUS_USR.FN_SPLITVAL(@PA_ID,1)          
        
  END  
end

select @l_entm_id = logn_ent_id from login_names where logn_name = @pa_login_name and logn_deleted_ind =  1                           


 IF @pa_action = 'OFFM_TRX_SELM_CDSL_DTLS'                        
 BEGIN                        
  --  

  
  create table #tmpval(dptdc_slip_no varchar(20),Val numeric,isin varchar(15),qty numeric(18,3))

  insert into #tmpval
	select distinct dptdc_slip_no , (abs(dptdc_qty) * CLOPM_CDSL_RT) Val ,DPTDC_ISIN  ,(abs(dptdc_qty)) qty
	from dptdc_mak,CLOSING_LAST_CDSL
	where dptdc_deleted_ind  in (0,4,6,-1)  
	and DPTDC_ISIN = CLOPM_ISIN_CD
	and dptdc_dtls_id = @pa_id 
	  --select * from #tmpval,dptdc_mak where isin = DPTDC_ISIN and qty = DPTDC_QTY 	
	  --and dptdc_dtls_id = @pa_id
    
      
    SELECT  dptdc_isin                        
          ,abs(dptdc_qty)     dptdc_qty                        
           ,dptdc_id         
 ,CASE WHEN ISNULL(DPTDC_TRANS_NO,'')='' THEN DPTDC_INTERNAL_REF_NO ELSE ISNULL(DPTDC_TRANS_NO,'') END + '/'+ isnull((select distinct convert(varchar,val)  from #tmpval where isin = DPTDC_ISIN and abs(qty) = abs(DPTDC_QTY)),'')   DPTDC_TRANS_NO             
--,CASE WHEN DPTDC_DELETED_IND IN (0,6,-1)  THEN 'MAKER ENTERED'        
--  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') <> ''  THEN 'BATCH UPLOADED'         
--  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'BATCH GENERATED'        
--  WHEN DPTDC_DELETED_IND = 1 AND ISNULL(DPTDC_BATCH_NO,'') = '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'CHECKER APPROVED' END  STATUS                       
    , CASE WHEN DPTDC_DELETED_IND IN (0,6,-1) AND DPTDC_CREATED_BY = DPTDC_LST_UPD_BY  THEN 'MAKER ENTERED' 
  WHEN DPTDC_DELETED_IND = 0  AND DPTDC_CREATED_BY <> DPTDC_LST_UPD_BY AND ISNULL(dptdc_res_cd,'')  = '' THEN '1ST CHECKER DONE' 
  WHEN DPTDC_DELETED_IND  = 0 AND ISNULL(dptdc_res_cd,'')  <> '' THEN 'REJECTED'          
  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') <> ''  THEN 'BATCH UPLOADED'         
  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'BATCH GENERATED'        
  WHEN DPTDC_DELETED_IND = 1 AND ISNULL(DPTDC_BATCH_NO,'') = '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'CHECKER DONE' END  STATUS        

    FROM dptdc_mak                   dptdc        with(nolock)                 
    WHERE   dptdc_dtls_id              = @pa_id                        
    AND     dptdc_deleted_ind          in (0,4,6,-1)                        
    AND     dptdc_internal_trastm       = @pa_cd                          
    and    isnull(dptdc_brokerbatch_no,'') = ''    
    order by DPTDC_INTERNAL_REF_NO
    
	drop table #tmpval                       
  --                        
  END   
ELSE IF @pa_action = 'OFFM_TRX_SEL_CDSL_DTLS'                        
  BEGIN                        
  --   
  
  create table #tmpval3(dptdc_slip_no varchar(20),Val numeric,isin varchar(15),qty numeric)

  insert into #tmpval3
	select distinct dptdc_slip_no , (abs(dptdc_qty) * CLOPM_CDSL_RT) Val ,DPTDC_ISIN ,ABS(dptdc_qty) qty 
	from dptdc_mak,CLOSING_LAST_CDSL
	where dptdc_deleted_ind  = 1
	and DPTDC_ISIN = CLOPM_ISIN_CD
	and dptdc_dtls_id = @pa_id   


                     
   SELECT  dptdc_isin                        
     ,abs(dptdc_qty)     dptdc_qty                        
     ,dptdc_id         
    -- ,ISNULL(DPTDC_TRANS_NO,'')  DPTDC_TRANS_NO        
 ,CASE WHEN ISNULL(DPTDC_TRANS_NO,'')='' THEN DPTDC_INTERNAL_REF_NO ELSE ISNULL(DPTDC_TRANS_NO,'') END + '/'+ isnull((select distinct convert(varchar,val)  from #tmpval3 where isin = DPTDC_ISIN and abs(qty) = abs(DPTDC_QTY)),'') DPTDC_TRANS_NO            
, CASE WHEN DPTDC_DELETED_IND IN (0,6,-1) AND DPTDC_CREATED_BY = DPTDC_LST_UPD_BY  THEN 'MAKER ENTERED' 
  WHEN DPTDC_DELETED_IND = 0  AND DPTDC_CREATED_BY <> DPTDC_LST_UPD_BY AND ISNULL(dptdc_res_cd,'')  = '' THEN '1ST CHECKER DONE'      --do not change  
  WHEN DPTDC_DELETED_IND  = 0 AND ISNULL(dptdc_res_cd,'')  <> '' THEN 'REJECTED'
  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') <> ''  THEN 'BATCH UPLOADED'         
  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'BATCH GENERATED'        
  WHEN DPTDC_DELETED_IND = 1 AND ISNULL(DPTDC_BATCH_NO,'') = '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'CHECKER DONE' END  STATUS        --do not change
                         
             
  --  FROM    dp_trx_dtls_cdsl            dptd                         
    FROM    dptdc_mak                    dptd                         
    WHERE   dptdc_dtls_id              = @pa_id                        
    AND     dptdc_deleted_ind          = 1                         
    AND    dptdc_internal_trastm       = @pa_cd                          
    and    isnull(dptdc_brokerbatch_no,'') = '' 
	
	drop table #tmpval3
	            
  END  
ELSE IF @pa_action = 'OFFM_TRX_SELM_CDSL'                        
  BEGIN                        
  --                        
    IF @pa_values = ''                        
    BEGIN                        
    --             
           PRINT @l_dpm_dpid      
PRINT @l_entm_id      
      SELECT distinct  @l_dpm_dpid                                DPID                         
            ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
      ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
            ,dptdc_slip_no                                     SLIPNO                         
            ,CASE WHEN dptdc_settlement_no = '' then settm2.settm_desc else settm1.settm_desc end SETTLEMENT_TYPE                        
              ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                       
            ,dpam_sba_no                                      ACCOUNTNO                        
            ,dptdc_counter_dp_id                               TARGERDPID                         
            ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
            ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
            ,DPTDC_CM_ID      CMID         
            ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
            ,@pa_id                  DEPOSITORY                        
            ,dptdc_excm_id                                     EXCHANGEID                        
            ,dptdc_dtls_id                                     DTLSID                        
            ,dptdc_internal_trastm                          
            ,isnull(dptdc_rmks,'') + isnull(DPTDC_RES_desc,'')  dptdc_rmks                         
            ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD                        
           ,case when dptdc_settlement_no = '' then '' else isnull(dptdc_other_settlement_no,'') end       OTHERSETTLEMENTNO             
            ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE         
             ,(Select DPM_NAME from dp_mstr where DPM_DPID = dptdc_counter_dp_id)[TARGERDPNAME]         
      ,dptdc_created_by Makerid          
, case when  DPTDC_MKT_TYPE = '' then DPTDC_OTHER_SETTLEMENT_TYPE  else DPTDC_MKT_TYPE end DPTDC_MKT_TYPE         
,case when  DPTDC_MKT_TYPE = '' then DPTDC_MKT_TYPE else DPTDC_OTHER_SETTLEMENT_TYPE end  Targetsettype         --   ,dptdc_created_by Makerid                         
--,'' dptdc_ID      
,isnull(dptdc_line_no,0)        dptdc_line_no 
,isnull(DPTDC_PAYMODE,'') DPTDC_PAYMODE
,isnull(DPTDC_BANKACNO,'') DPTDC_BANKACNO
,isnull(DPTDC_BANKACNAME,'') DPTDC_BANKACNAME
,isnull(DPTDC_BANKBRNAME,'') DPTDC_BANKBRNAME
,isnull(DPTDC_TRANSFEREENAME,'') DPTDC_TRANSFEREENAME
,isnull(DPTDC_DOI,'') DPTDC_DOI
,isnull(DPTDC_CHQ_REFNO,'') DPTDC_CHQ_REFNO
      FROM   citrus_usr.fn_acct_list_disdrf(@l_dpm_dpid,@l_entm_id,0) dpam    
            --,dp_mstr                      dpm                         
            --,dp_acct_mstr                 dpam                          
            --,exch_seg_mstr       excsm                        
            --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,dptdc_mak                    dptdc                        with(nolock)                      
             left outer join                          
            settlement_type_mstr          settm1                          with(nolock)                     
           on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )            
           left outer join                          
           settlement_type_mstr          settm2                          with(nolock)                     
            on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)            
      WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      --AND    excsm.excsm_id            = @pa_id                        
      AND     convert(varchar,dptdc.dptdc_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_cd end                        
      --AND     convert(varchar,dptdc.dptdc_request_dt,103) between CASE WHEN ISNULL(@pa_cd,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_cd end  and  CASE WHEN ISNULL(@coldelimiter,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @coldelimiter end                       
      AND    dptdc.dptdc_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
      AND    dpam.dpam_sba_no            LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
      AND    dptdc_deleted_ind           in (0,4,6,-1)                        
      AND    dptdc_internal_trastm       in ('BOBO','BOCM','CMBO','CMCM','ID')                               
      AND    dptdc_internal_trastm     =  @rowdelimiter     
      and    isnull(dptdc_brokerbatch_no,'') = '' 
--order by dptdc_dtls_id         
    --                        
    END                        
    ELSE                        
    BEGIN                        
    --              
         
      SELECT distinct  @l_dpm_dpid                                DPID                         
            ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
            ,dptdc_slip_no                                     SLIPNO                         
            ,CASE WHEN dptdc_settlement_no = '' then settm2.settm_desc else settm1.settm_desc end SETTLEMENT_TYPE                        
              ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                    
            ,dpam_sba_no                                      ACCOUNTNO                        
            ,dptdc_counter_dp_id                               TARGERDPID                         
            ,dptdc_counter_cmbp_id                         TARGERCMBPID                        
            ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
            ,DPTDC_CM_ID                                       CMID                         
            ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
            ,@pa_id                                         DEPOSITORY                        
            ,dptdc_excm_id                                     EXCHANGEID                        
            ,dptdc_dtls_id                                     DTLSID                        
            ,dptdc_internal_trastm                         
            ,isnull(dptdc_rmks,'') + isnull(DPTDC_RES_desc,'')  dptdc_rmks                          
            ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD            
            ,case when dptdc_settlement_no = '' then '' else isnull(dptdc_other_settlement_no,'') end      OTHERSETTLEMENTNO             
            ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE         
            , (Select DPM_NAME from dp_mstr where DPM_DPID = dptdc_counter_dp_id)[TARGERDPNAME]             
,dptdc_created_by Makerid          
          
,case when  DPTDC_MKT_TYPE = '' then DPTDC_OTHER_SETTLEMENT_TYPE  else DPTDC_MKT_TYPE end  DPTDC_MKT_TYPE       
--,'' dptdc_ID        
,case when  DPTDC_MKT_TYPE = '' then DPTDC_MKT_TYPE else DPTDC_OTHER_SETTLEMENT_TYPE end   Targetsettype    
,isnull(dptdc_line_no,0)        dptdc_line_no 
,isnull(DPTDC_PAYMODE,'') DPTDC_PAYMODE
,isnull(DPTDC_BANKACNO,'') DPTDC_BANKACNO
,isnull(DPTDC_BANKACNAME,'') DPTDC_BANKACNAME
,isnull(DPTDC_BANKBRNAME,'') DPTDC_BANKBRNAME
,isnull(DPTDC_TRANSFEREENAME,'') DPTDC_TRANSFEREENAME
,isnull(DPTDC_DOI,'') DPTDC_DOI
,isnull(DPTDC_CHQ_REFNO,'') DPTDC_CHQ_REFNO
FROM   citrus_usr.fn_acct_list_disdrf(@l_dpm_dpid,@l_entm_id,0) dpam    
            --,dp_mstr  dpm                         
            --,dp_acct_mstr                 dpam                          
            --,exch_seg_mstr                excsm                        
            --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                         
            ,dptdc_mak                    dptdc     with(nolock)                                         
             left outer join                          
             settlement_type_mstr          settm1              with(nolock)                                 
   on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )                 
             left outer join                          
             settlement_type_mstr          settm2      with(nolock)                                         
              on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)            
      WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      AND    dptdc_dtls_id   = @pa_values                       
      --AND    excsm_list.excsm_id      = excsm.excsm_id                  
      AND    dptdc_deleted_ind         in (0,4,6,-1)                        
      AND    dptdc_internal_trastm            in ('BOBO','BOCM','CMBO','CMCM','ID')                        
      AND    dptdc_internal_trastm            = @rowdelimiter      
      and    isnull(dptdc_brokerbatch_no,'') = ''   
--order by dptdc_dtls_id                    
    --                        
    END                        
  --                        
  END 
ELSE IF @pa_action = 'OFFM_TRX_SELM_CDSL_CHECKER'                        
  BEGIN                        
  --                        
    IF @pa_values = ''                        
    BEGIN                        
    --             
           PRINT @l_dpm_dpid      
PRINT @l_entm_id   
   
      SELECT distinct  @l_dpm_dpid                                DPID                         
            ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
      ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
            ,dptdc_slip_no                                     SLIPNO                         
            ,CASE WHEN isnull(dptdc_settlement_no,'') = '' then isnull(settm2.settm_desc,'') 
            else isnull(settm1.settm_desc,'') end SETTLEMENT_TYPE                        
              ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                       
            ,dpam_sba_no                                      ACCOUNTNO                        
            ,dptdc_counter_dp_id                               TARGERDPID                         
            ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
            ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
            ,DPTDC_CM_ID      CMID         
            ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
            ,@pa_id                  DEPOSITORY                        
            ,dptdc_excm_id                                     EXCHANGEID                        
            ,dptdc_dtls_id                                     DTLSID                        
            ,dptdc_internal_trastm                          
            ,isnull(dptdc_rmks,'') + isnull(DPTDC_RES_desc,'')  dptdc_rmks                         
            ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD                        
           ,case when dptdc_settlement_no = '' then '' else isnull(dptdc_other_settlement_no,'') end       OTHERSETTLEMENTNO             
            ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE         
             ,(Select DPM_NAME from dp_mstr where DPM_DPID = dptdc_counter_dp_id)[TARGERDPNAME]         
      ,dptdc_created_by Makerid          
, case when  DPTDC_MKT_TYPE = '' then DPTDC_OTHER_SETTLEMENT_TYPE  else DPTDC_MKT_TYPE end DPTDC_MKT_TYPE         
--,case when  DPTDC_MKT_TYPE = '' then DPTDC_MKT_TYPE else DPTDC_OTHER_SETTLEMENT_TYPE end           --   ,dptdc_created_by Makerid                         
,case when  DPTDC_MKT_TYPE = '' then DPTDC_OTHER_SETTLEMENT_TYPE  else DPTDC_MKT_TYPE end  as Targetsettype 
--,'' dptdc_ID      
,isnull(dptdc_line_no,0)        dptdc_line_no 
,isnull(DPTDC_PAYMODE,'') DPTDC_PAYMODE
,isnull(DPTDC_BANKACNO,'') DPTDC_BANKACNO
,isnull(DPTDC_BANKACNAME,'') DPTDC_BANKACNAME
,isnull(DPTDC_BANKBRNAME,'') DPTDC_BANKBRNAME
,isnull(DPTDC_TRANSFEREENAME,'') DPTDC_TRANSFEREENAME
,isnull(DPTDC_DOI,'') DPTDC_DOI
,isnull(DPTDC_CHQ_REFNO,'') DPTDC_CHQ_REFNO
      FROM   dp_acct_mstr dpam                    with(nolock)                          
            --,dp_mstr                      dpm                         
            --,dp_acct_mstr                 dpam                          
            --,exch_seg_mstr       excsm                        
            --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,dptdc_mak                    dptdc                         with(nolock)                     
             left outer join                          
            settlement_type_mstr          settm1                         with(nolock)                      
           on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )            
           left outer join                          
           settlement_type_mstr          settm2                       with(nolock)                        
            on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)            
      WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      --AND    excsm.excsm_id            = @pa_id                        
      AND     convert(varchar,dptdc.dptdc_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_cd end                        
      --AND     convert(varchar,dptdc.dptdc_request_dt,103) between CASE WHEN ISNULL(@pa_cd,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_cd end  and  CASE WHEN ISNULL(@coldelimiter,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @coldelimiter end                       
      AND    dptdc.dptdc_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
      AND    dpam.dpam_sba_no            LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
      AND    dptdc_deleted_ind           in (0,4,6,-1)                        
      AND    dptdc_internal_trastm       in ('BOBO','BOCM','CMBO','CMCM','ID')                               
      AND    dptdc_internal_trastm     =  @rowdelimiter     
      and    isnull(dptdc_brokerbatch_no,'') = '' 
--order by dptdc_dtls_id         
    --                        
    END                        
    ELSE                        
    BEGIN                        
    --              
print @l_dpm_dpid 
print 'second'         
      SELECT distinct  @l_dpm_dpid                                DPID                         
            ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
            ,dptdc_slip_no                                     SLIPNO                         
            ,CASE WHEN dptdc_settlement_no = '' then isnull(settm2.settm_desc,'') else isnull(settm1.settm_desc,'') end SETTLEMENT_TYPE                        
              ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                    
            ,dpam_sba_no                                      ACCOUNTNO                        
            ,dptdc_counter_dp_id                               TARGERDPID                         
            ,dptdc_counter_cmbp_id                         TARGERCMBPID                        
            ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
            ,DPTDC_CM_ID                                       CMID                         
            ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
            ,@pa_id                                         DEPOSITORY                        
            ,dptdc_excm_id                                     EXCHANGEID                        
            ,dptdc_dtls_id                                     DTLSID                        
            ,dptdc_internal_trastm                         
            ,isnull(dptdc_rmks,'') + isnull(DPTDC_RES_desc,'')  dptdc_rmks                          
            ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD            
            ,case when dptdc_settlement_no = '' then '' else isnull(dptdc_other_settlement_no,'') end      OTHERSETTLEMENTNO             
            ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE         
            , (Select DPM_NAME from dp_mstr where DPM_DPID = dptdc_counter_dp_id)[TARGERDPNAME]             
,dptdc_created_by Makerid          
          
,case when  DPTDC_MKT_TYPE = '' then DPTDC_OTHER_SETTLEMENT_TYPE  else DPTDC_MKT_TYPE end  DPTDC_MKT_TYPE       
--,'' dptdc_ID        
--,case when  DPTDC_MKT_TYPE = '' then DPTDC_MKT_TYPE else DPTDC_OTHER_SETTLEMENT_TYPE end       
,case when  DPTDC_MKT_TYPE = '' then DPTDC_OTHER_SETTLEMENT_TYPE  else DPTDC_MKT_TYPE end  as Targetsettype 
,isnull(dptdc_line_no,0)        dptdc_line_no 
,isnull(DPTDC_PAYMODE,'') DPTDC_PAYMODE
,isnull(DPTDC_BANKACNO,'') DPTDC_BANKACNO
,isnull(DPTDC_BANKACNAME,'') DPTDC_BANKACNAME
,isnull(DPTDC_BANKBRNAME,'') DPTDC_BANKBRNAME
,isnull(DPTDC_TRANSFEREENAME,'') DPTDC_TRANSFEREENAME
,isnull(DPTDC_DOI,'') DPTDC_DOI
,isnull(DPTDC_CHQ_REFNO,'') DPTDC_CHQ_REFNO
FROM   dp_acct_mstr  dpam           with(nolock)                                   
            --,dp_mstr  dpm                         
            --,dp_acct_mstr                 dpam                          
            --,exch_seg_mstr                excsm                        
            --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,dptdc_mak                    dptdc    with(nolock)                                          
             left outer join                          
             settlement_type_mstr          settm1     with(nolock)                                          
   on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )                 
             left outer join                          
             settlement_type_mstr          settm2     with(nolock)                                          
              on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)            
      WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      AND    dptdc_dtls_id   = @pa_values                       
      --AND    excsm_list.excsm_id      = excsm.excsm_id                  
      AND    dptdc_deleted_ind         in (0,4,6,-1)                        
      AND    dptdc_internal_trastm            in ('BOBO','BOCM','CMBO','CMCM','ID')                        
      AND    dptdc_internal_trastm            =@rowdelimiter -- case when len(dptdc_created_by)='16' and @rowdelimiter='ID' then 'BOCM' else  @rowdelimiter end     
      and    isnull(dptdc_brokerbatch_no,'') = ''   
--order by dptdc_dtls_id                    
    --                        
    END                        
  --                        
  END  
ELSE IF @pa_action = 'OFFM_TRX_SEL_CDSL'                        
  BEGIN                        
  --                        
    SELECT distinct  @l_dpm_dpid                                DPID                         
          ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
          ,dptdc_slip_no            SLIPNO                         
          ,CASE WHEN dptdc_settlement_no = '' then settm2.settm_desc else settm1.settm_desc end SETTLEMENT_TYPE                        
              ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
          ,dpam_sba_no                                      ACCOUNTNO                        
          ,dptdc_counter_dp_id                               TARGERDPID                         
          ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
          ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
          ,DPTDC_CM_ID                     CMID                         
          ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
          ,@pa_id                                         DEPOSITORY                        
          ,dptdc_excm_id                                     EXCHANGEID                        
          ,dptdc_dtls_id                                     DTLSID                        
          ,dptdc_internal_trastm                           
          ,dptdc_rmks                        
          ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD           
          ,case when dptdc_settlement_no = '' then '' else isnull(dptdc_other_settlement_no,'') end       OTHERSETTLEMENTNO           
          ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE          
          ,(Select DPM_NAME from dp_mstr where DPM_DPID = dptdc_counter_dp_id)[TARGERDPNAME]         
,dptdc_created_by Makerid          
,DPTDC_MKT_TYPE         
-- ,case when  DPTDC_MKT_TYPE = '' then DPTDC_MKT_TYPE else DPTDC_OTHER_SETTLEMENT_TYPE end  as Targetsettype             --   ,dptdc_created_by Makerid                         
 ,case when  DPTDC_MKT_TYPE = '' then DPTDC_OTHER_SETTLEMENT_TYPE  else DPTDC_MKT_TYPE end  as Targetsettype             --   ,dptdc_created_by Makerid                         
--,dptdc_id       
,isnull(dptdc_line_no,0)        dptdc_line_no 
,isnull(DPTDC_PAYMODE,'') DPTDC_PAYMODE
,isnull(DPTDC_BANKACNO,'') DPTDC_BANKACNO
,isnull(DPTDC_BANKACNAME,'') DPTDC_BANKACNAME
,isnull(DPTDC_BANKBRNAME,'') DPTDC_BANKBRNAME
,isnull(DPTDC_TRANSFEREENAME,'') DPTDC_TRANSFEREENAME
,isnull(DPTDC_DOI,'') DPTDC_DOI
,isnull(DPTDC_CHQ_REFNO,'') DPTDC_CHQ_REFNO
    FROM   citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam     
          --,dp_mstr                      dpm                         
          --,dp_acct_mstr                 dpam                          
          --,exch_seg_mstr                excsm                        
          --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,dp_trx_dtls_cdsl             dptdc      with(nolock)                                         
  left outer join                          
           settlement_type_mstr          settm1      with(nolock)                                          
                                
           on (convert(varchar,settm1.settm_id          )  = dptdc.dptdc_mkt_type     )                    
           left outer join                          
           settlement_type_mstr          settm2     with(nolock)                                           
           on (convert(varchar,settm2.settm_id            ) = dptdc.dptdc_other_settlement_type)             
    WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id                        
    --AND    dpm_excsm_id              = excsm.excsm_id                        
    --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
    --AND    excsm.excsm_id            = @pa_id                        
    --AND    excsm_list.excsm_id      = excsm.excsm_id           
    AND    dptdc_deleted_ind         = 1                        
    AND    convert(varchar,dptdc.dptdc_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then convert(varchar,dptdc.dptdc_request_dt,103) else @pa_cd end                        
--AND     convert(varchar,dptdc.dptdc_request_dt,103) between CASE WHEN ISNULL(@pa_cd,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_cd end  and  CASE WHEN ISNULL(@coldelimiter,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @coldelimiter end                       
    AND    dptdc.dptdc_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
    AND    dpam.dpam_sba_no           LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
    AND    dptdc_deleted_ind         = 1                        
    AND    dptdc_internal_trastm            in ('BOBO','BOCM','CMBO','CMCM','ID')                                 
    AND    dptdc_internal_trastm            = @rowdelimiter      
    and    isnull(dptdc_brokerbatch_no,'') = ''
end  
ELSE IF @pa_action = 'INTERDP_TRX_SEL_CDSL'                        
    BEGIN                        
    --                        
     SELECT distinct  @l_dpm_dpid   DPID                         
     ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
     ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
     ,dptdc_slip_no                                     SLIPNO                         
     ,CASE WHEN dptdc_settlement_no = '' then settm2.settm_desc else settm1.settm_desc end SETTLEMENT_TYPE                        
     ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                       
     ,dpam_sba_no                                      ACCOUNTNO                        
     ,dptdc_counter_dp_id                    TARGERDPID                         
     ,dptdc_counter_cmbp_id                             TARGERCMBPID               
     ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
     ,DPTDC_CM_ID                                       CMID             
     ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                         
     ,@pa_id                                         DEPOSITORY                        
     ,dptdc_excm_id                                     EXCHANGEID                        
     ,dptdc_dtls_id                                     DTLSID                        
     ,dptdc_internal_trastm                           
     ,dptdc_rmks                        
     ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD                 
     ,case when dptdc_settlement_no = '' then '' else isnull(dptdc_other_settlement_no,'') end       OTHERSETTLEMENTNO             
     ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE         
      ,(Select DPM_NAME from dp_mstr where DPM_DPID = dptdc_counter_dp_id)[TARGERDPNAME]         
  ,dptdc_created_by Makerid          
,DPTDC_MKT_TYPE         
, case when  DPTDC_MKT_TYPE = '' then DPTDC_MKT_TYPE else DPTDC_OTHER_SETTLEMENT_TYPE end                         
--,dptdc_id       
,isnull(dptdc_line_no,0)        dptdc_line_no 

,isnull(DPTDC_PAYMODE,'') DPTDC_PAYMODE
,isnull(DPTDC_BANKACNO,'') DPTDC_BANKACNO
,isnull(DPTDC_BANKACNAME,'') DPTDC_BANKACNAME
,isnull(DPTDC_BANKBRNAME,'') DPTDC_BANKBRNAME
,isnull(DPTDC_TRANSFEREENAME,'') DPTDC_TRANSFEREENAME
,isnull(DPTDC_DOI,'') DPTDC_DOI
,isnull(DPTDC_CHQ_REFNO,'') DPTDC_CHQ_REFNO
    FROM   citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam       
          --,dp_mstr                      dpm                         
          --,dp_acct_mstr                 dpam                          
          --,exch_seg_mstr          excsm                        
          --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,dp_trx_dtls_cdsl             dptdc  with(nolock)                                             
           left outer join                          
           settlement_type_mstr          settm1     with(nolock)                                          
           on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )                    
           left outer join                          
           settlement_type_mstr          settm2      with(nolock)                                         
           on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)              
    WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id                        
    --AND    dpm_excsm_id          = excsm.excsm_id                        
    --AND    dpam.dpam_dpm_id        = dpm.dpm_id                        
    --AND    excsm.excsm_id          = @pa_id                        
    --AND    excsm_list.excsm_id     = excsm.excsm_id                        
    AND    dptdc_deleted_ind         = 1                        
    AND     convert(varchar,dptdc.dptdc_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_cd end                        
    --AND     convert(varchar,dptdc.dptdc_request_dt,103) between CASE WHEN ISNULL(@pa_cd,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_cd end  and  CASE WHEN ISNULL(@coldelimiter,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @coldelimiter end                       
    AND    dptdc.dptdc_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
    AND    dpam.dpam_sba_no            LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
    AND    dptdc_deleted_ind         = 1                        
    AND    dptdc_internal_trastm    in ('ID')        
    AND    dptdc_internal_trastm            = @rowdelimiter                         
    and    isnull(dptdc_brokerbatch_no,'') = ''                        
    --                        
    END                        
    ELSE IF @pa_action = 'INTERDP_TRX_SELC_CDSL'                        
    BEGIN                        
    --                        
      SELECT distinct  @l_dpm_dpid                                DPID                         
            ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
            ,dptdc_slip_no                                     SLIPNO                         
            ,settm1.settm_desc                                  SETTLEMENT_TYPE                        
            ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
            ,dpam_sba_no                ACCOUNTNO                        
            ,''  TARGERDPID --dptdc_counter_dp_id                                                        
            ,'' TARGERCMBPID --dptdc_counter_cmbp_id                                            
            ,'' TARGERACCOUNTNO --dptdc_counter_demat_acct_no                                               
            ,DPTDC_CM_ID                                       CMID                         
            ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
            ,@pa_id                                         DEPOSITORY                        
            ,dptdc_excm_id                                     EXCHANGEID                        
            ,dptdc_dtls_id           DTLSID                        
            ,dptdc_internal_trastm                             INTERNAL_CD                         
            ,dptdc_deleted_ind                                 DELETED_IND                        
           -- ,abs(dptdc_qty)                                    dptdc_qty                        
            --,dptdc_isin                        
            ,chk = isnull((select case when count(*) >= 1 then 'YES' else 'NO' end from dptdc_mak dptdm where dptdm.dptdc_slip_no = dptdc.dptdc_slip_no  and  dptdm.DPTDc_TRASTM_CD = dptdc.DPTDc_TRASTM_CD and dptdm.DPTDc_EXECUTION_DT =                    
  
   
             dptdc.DPTDc_EXECUTION_DT and (dptdc_deleted_ind = -1 or isnull(ltrim(rtrim(dptdc_mid_chk)),'') <> '' ) ),'NO')                        
            ,isnull(dptdc_other_settlement_no,'')       OTHERSETTLEMENTNO             
            ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE           
          ,highval = ((select top 1 CLOPM_CDSL_RT from closing_last_cdsl,dptdc_mak where  CLOPM_ISIN_CD = dptdc_isin and DPTDC_SLIP_NO = @pa_rmks) * abs(dptdc_qty))         
      ,isnull(dptdc_line_no,0)        dptdc_line_no 
      FROM   citrus_usr.fn_acct_list_disdrf(@l_dpm_dpid,@l_entm_id,0) dpam  
            --,dp_mstr                      dpm                         
            --,dp_acct_mstr                 dpam                          
            --,exch_seg_mstr                excsm                        
            --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,dptdc_mak                    dptdc      with(nolock)                                        
             left outer join                          
             settlement_type_mstr          settm1   with(nolock)                                            
             on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )                   
             left outer join                          
             settlement_type_mstr          settm2 with(nolock)                                              
             on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)              
      WHERE  dpam.dpam_id                  = dptdc.dptdc_dpam_id                        
      --AND    dpm_excsm_id                  = excsm.excsm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id              = dpm.dpm_id                        
      AND    dptdc.dptdc_lst_upd_by        <> @pa_login_name                        
      --AND    dpm_excsm_id                  = convert(int,@pa_cd)                        
      AND    dptdc_deleted_ind             in (0,4,6,-1)                        
      AND    dptdc_internal_trastm         in ('ID')        
      and    isnull(dptdc_res_desc,'')        = ''
      AND    dptdc_internal_trastm            = @rowdelimiter                               
      and    isnull(dptdc_brokerbatch_no,'') = ''      and isnull(dptdc_res_cd,'') like case when @pa_desc = '' then '%' else @pa_desc end                    
    --                        
    END                        
    ELSE IF @pa_action = 'INTERDP_TRX_SELM_CDSL'                        
    BEGIN                        
    --                        
      IF @pa_values = ''                        
      BEGIN                        
      --                     
select  @pa_cd = citrus_usr.fn_splitval(@pa_cd,1)

        SELECT distinct  @l_dpm_dpid                                DPID                         
              ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
              ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
              ,dptdc_slip_no                                     SLIPNO                         
              ,CASE WHEN dptdc_settlement_no = '' then settm2.settm_desc else settm1.settm_desc end SETTLEMENT_TYPE                        
              ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
              ,dpam_sba_no        ACCOUNTNO                        
              ,dptdc_counter_dp_id                               TARGERDPID                         
              ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
              ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
              ,DPTDC_CM_ID                                       CMID                         
              ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
              ,@pa_id                                          DEPOSITORY                        
              ,dptdc_excm_id                                     EXCHANGEID                                    ,dptdc_dtls_id                                     DTLSID                        
              ,dptdc_internal_trastm                          
              ,isnull(dptdc_rmks,'') + isnull(DPTDC_RES_desc,'')  dptdc_rmks                      
                                     
              ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD                        
              ,case when dptdc_settlement_no = '' then '' else isnull(dptdc_other_settlement_no,'') end      OTHERSETTLEMENTNO             
              ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE         
             ,(Select DPM_NAME from dp_mstr where DPM_DPID = dptdc_counter_dp_id)[TARGERDPNAME]        
			,dptdc_created_by Makerid          
			,DPTDC_MKT_TYPE         
			--,dptdc_ID               
			 ,case when  DPTDC_MKT_TYPE = '' then DPTDC_MKT_TYPE else DPTDC_OTHER_SETTLEMENT_TYPE end    
			 ,isnull(dptdc_line_no,0)        dptdc_line_no      
			 ,isnull(DPTDC_PAYMODE,'') DPTDC_PAYMODE
,isnull(DPTDC_BANKACNO,'') DPTDC_BANKACNO
,isnull(DPTDC_BANKACNAME,'') DPTDC_BANKACNAME
,isnull(DPTDC_BANKBRNAME,'') DPTDC_BANKBRNAME
,isnull(DPTDC_TRANSFEREENAME,'') DPTDC_TRANSFEREENAME
,isnull(DPTDC_DOI,'') DPTDC_DOI
,isnull(DPTDC_CHQ_REFNO,'') DPTDC_CHQ_REFNO
FROM   citrus_usr.fn_acct_list_disdrf(@l_dpm_dpid,@l_entm_id,0) dpam  
              --,dp_mstr                      dpm                        
              --,dp_acct_mstr                 dpam                          
              --,exch_seg_mstr                excsm                        
              --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
              ,dptdc_mak                    dptdc     with(nolock)                                         
               left outer join                          
                settlement_type_mstr          settm1    with(nolock)                                                     on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )             
               left outer join                          
               settlement_type_mstr          settm2       with(nolock)                                        
               on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)            
            
        WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id                        
        --AND    dpm_excsm_id              = excsm.excsm_id                        
        --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
        --AND    excsm_list.excsm_id      = excsm.excsm_id                        
        --AND    excsm.excsm_id            = @pa_id                        
        AND     convert(varchar,dptdc.dptdc_request_dt,103) LIKE CASE WHEN ISNULL(@pa_cd,'') = '%' then  convert(varchar,dptdc.dptdc_request_dt,103) else case when @pa_cd = '' then '%' else @pa_cd end end              
      --AND     convert(varchar,dptdc.dptdc_request_dt,103) between CASE WHEN ISNULL(@pa_cd,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_cd end  and  CASE WHEN ISNULL(@coldelimiter,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @coldelimiter end                       
        AND    dptdc.dptdc_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
        AND    dpam.dpam_sba_no           LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
        AND    dptdc_deleted_ind         in (0,4,6,-1)                        
        AND    dptdc_internal_trastm            in ('ID')       
        AND    dptdc_internal_trastm            = @rowdelimiter                              
        and    isnull(dptdc_brokerbatch_no,'') = ''    
		--order by dptdc_dtls_id                      
      --                        
      END                        
      ELSE                        
      BEGIN                        
      --                        
select  @pa_cd = citrus_usr.fn_splitval(@pa_cd,1)

        SELECT distinct  @l_dpm_dpid                                DPID                         
              ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
              ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
              ,dptdc_slip_no                 SLIPNO                         
              ,CASE WHEN dptdc_settlement_no = '' then settm2.settm_desc else settm1.settm_desc end SETTLEMENT_TYPE                        
            ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
              ,dpam_sba_no                                      ACCOUNTNO                        
              ,dptdc_counter_dp_id                               TARGERDPID                         
              ,dptdc_counter_cmbp_id               TARGERCMBPID                        
              ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                    ,DPTDC_CM_ID                                       CMID                         
              ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
              ,@pa_id                                         DEPOSITORY                        
              ,dptdc_excm_id                                     EXCHANGEID                        
              ,dptdc_dtls_id                                     DTLSID                        
              ,dptdc_internal_trastm                         
              ,isnull(dptdc_rmks,'') + isnull(DPTDC_RES_desc,'')  dptdc_rmks                       
--              ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD          
--              ,isnull(dptdc_other_settlement_no,'')       OTHERSETTLEMENTNO             
--              ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE                
                ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD                        
               ,case when dptdc_settlement_no = '' then '' else isnull(dptdc_other_settlement_no,'') end        OTHERSETTLEMENTNO             
               ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE         
               ,(Select DPM_NAME from dp_mstr where DPM_DPID = dptdc_counter_dp_id)[TARGERDPNAME]          
,dptdc_created_by Makerid          
,DPTDC_MKT_TYPE         
--,dptdc_ID      
 ,case when  DPTDC_MKT_TYPE = '' then DPTDC_MKT_TYPE else DPTDC_OTHER_SETTLEMENT_TYPE end 
 ,isnull(dptdc_line_no,0)        dptdc_line_no    
 ,isnull(DPTDC_PAYMODE,'') DPTDC_PAYMODE
,isnull(DPTDC_BANKACNO,'') DPTDC_BANKACNO
,isnull(DPTDC_BANKACNAME,'') DPTDC_BANKACNAME
,isnull(DPTDC_BANKBRNAME,'') DPTDC_BANKBRNAME
,isnull(DPTDC_TRANSFEREENAME,'') DPTDC_TRANSFEREENAME
,isnull(DPTDC_DOI,'') DPTDC_DOI
,isnull(DPTDC_CHQ_REFNO,'') DPTDC_CHQ_REFNO     
FROM   citrus_usr.fn_acct_list_disdrf(@l_dpm_dpid,@l_entm_id,0) dpam     
              --,dp_mstr                      dpm                         
              --,dp_acct_mstr                 dpam                          
              --,exch_seg_mstr                excsm                        
              --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
              ,dptdc_mak                    dptdc     with(nolock)                                         
               left outer join                          
              settlement_type_mstr          settm1   with(nolock)                                            
              on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )                     
               left outer join                          
               settlement_type_mstr          settm2    with(nolock)                                           
                on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)             
            
        WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id                        
        --AND    dpm_excsm_id            = excsm.excsm_id                        
        --AND    dpam.dpam_dpm_id        = dpm.dpm_id                        
        AND    dptdc_dtls_id             = @pa_values                        
        --AND    excsm_list.excsm_id     = excsm.excsm_id                        
        AND    dptdc_deleted_ind         in (0,4,6,-1)                        
        AND    dptdc_internal_trastm            in ('ID')       
        AND    dptdc_internal_trastm            = @rowdelimiter                       
        and    isnull(dptdc_brokerbatch_no,'') = ''     
		order by dptdc_dtls_id                     
      --                        
      END                        
    --                        
    END 
 ELSE IF @pa_action = 'INTERDP_TRX_SELM_CDSL_CHECKER'                        
    BEGIN                        
    --                        
      IF @pa_values = ''                        
      BEGIN                        
      --                     
select  @pa_cd = citrus_usr.fn_splitval(@pa_cd,1)

        SELECT distinct  @l_dpm_dpid                                DPID                         
              ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
              ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
              ,dptdc_slip_no                                     SLIPNO                         
              ,CASE WHEN dptdc_settlement_no = '' then settm2.settm_desc else settm1.settm_desc end SETTLEMENT_TYPE                        
              ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
              ,dpam_sba_no        ACCOUNTNO                        
              ,dptdc_counter_dp_id                               TARGERDPID                         
              ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
              ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
              ,DPTDC_CM_ID                                       CMID                         
              ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
              ,@pa_id                                          DEPOSITORY                        
              ,dptdc_excm_id                                     EXCHANGEID                                    ,dptdc_dtls_id                                     DTLSID                        
              ,dptdc_internal_trastm                          
              ,isnull(dptdc_rmks,'') + isnull(DPTDC_RES_desc,'')  dptdc_rmks                      
                                     
              ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD                        
              ,case when dptdc_settlement_no = '' then '' else isnull(dptdc_other_settlement_no,'') end      OTHERSETTLEMENTNO             
              ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE         
             ,(Select DPM_NAME from dp_mstr where DPM_DPID = dptdc_counter_dp_id)[TARGERDPNAME]        
			,dptdc_created_by Makerid          
			,DPTDC_MKT_TYPE         
			--,dptdc_ID               
			 ,case when  DPTDC_MKT_TYPE = '' then DPTDC_MKT_TYPE else DPTDC_OTHER_SETTLEMENT_TYPE end        
--,case when  DPTDC_MKT_TYPE = '' then DPTDC_OTHER_SETTLEMENT_TYPE  else DPTDC_MKT_TYPE end  as Targetsettype 
,isnull(dptdc_line_no,0)        dptdc_line_no 
,isnull(DPTDC_PAYMODE,'') DPTDC_PAYMODE
,isnull(DPTDC_BANKACNO,'') DPTDC_BANKACNO
,isnull(DPTDC_BANKACNAME,'') DPTDC_BANKACNAME
,isnull(DPTDC_BANKBRNAME,'') DPTDC_BANKBRNAME
,isnull(DPTDC_TRANSFEREENAME,'') DPTDC_TRANSFEREENAME
,isnull(DPTDC_DOI,'') DPTDC_DOI
,isnull(DPTDC_CHQ_REFNO,'') DPTDC_CHQ_REFNO
 FROM  dp_acct_mstr dpam                         with(nolock)                     
              --,dp_mstr                      dpm                        
              --,dp_acct_mstr                 dpam                          
              --,exch_seg_mstr                excsm                        
              --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
              ,dptdc_mak                    dptdc    with(nolock)                                          
               left outer join                          
                settlement_type_mstr          settm1  with(nolock)                                                       on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )             
               left outer join                          
               settlement_type_mstr          settm2    with(nolock)                                           
               on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)            
            
        WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id                        
        --AND    dpm_excsm_id              = excsm.excsm_id                        
        --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
        --AND    excsm_list.excsm_id      = excsm.excsm_id                        
        --AND    excsm.excsm_id            = @pa_id                        
        AND     convert(varchar,dptdc.dptdc_request_dt,103) LIKE CASE WHEN ISNULL(@pa_cd,'') = '%' then  convert(varchar,dptdc.dptdc_request_dt,103) else case when @pa_cd = '' then '%' else @pa_cd end end              
      --AND     convert(varchar,dptdc.dptdc_request_dt,103) between CASE WHEN ISNULL(@pa_cd,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_cd end  and  CASE WHEN ISNULL(@coldelimiter,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @coldelimiter end                       
        AND    dptdc.dptdc_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
        AND    dpam.dpam_sba_no           LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
        AND    dptdc_deleted_ind         in (0,4,6,-1)                        
        AND    dptdc_internal_trastm            in ('ID')       
        AND    dptdc_internal_trastm            = @rowdelimiter                              
        and    isnull(dptdc_brokerbatch_no,'') = ''    
		--order by dptdc_dtls_id                      
      --                        
      END                        
      ELSE                        
      BEGIN                        
      --                        
select  @pa_cd = citrus_usr.fn_splitval(@pa_cd,1)

        SELECT distinct  @l_dpm_dpid                                DPID                         
              ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
              ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
              ,dptdc_slip_no                 SLIPNO                         
              ,CASE WHEN dptdc_settlement_no = '' then settm2.settm_desc else settm1.settm_desc end SETTLEMENT_TYPE                        
            ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
              ,dpam_sba_no                                      ACCOUNTNO                        
              ,dptdc_counter_dp_id                               TARGERDPID                         
              ,dptdc_counter_cmbp_id               TARGERCMBPID                        
              ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                    ,DPTDC_CM_ID                                       CMID                         
              ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
              ,@pa_id                                         DEPOSITORY                        
              ,dptdc_excm_id                                     EXCHANGEID                        
              ,dptdc_dtls_id                                     DTLSID                        
              ,dptdc_internal_trastm                         
              ,isnull(dptdc_rmks,'') + isnull(DPTDC_RES_desc,'')  dptdc_rmks                       
--              ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD          
--              ,isnull(dptdc_other_settlement_no,'')       OTHERSETTLEMENTNO             
--              ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE                
                ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD                        
               ,case when dptdc_settlement_no = '' then '' else isnull(dptdc_other_settlement_no,'') end        OTHERSETTLEMENTNO             
               ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE         
               ,(Select DPM_NAME from dp_mstr where DPM_DPID = dptdc_counter_dp_id)[TARGERDPNAME]          
,dptdc_created_by Makerid          
,DPTDC_MKT_TYPE         
--,dptdc_ID      
 ,case when  DPTDC_MKT_TYPE = '' then DPTDC_MKT_TYPE else DPTDC_OTHER_SETTLEMENT_TYPE end         
--,case when  DPTDC_MKT_TYPE = '' then DPTDC_OTHER_SETTLEMENT_TYPE  else DPTDC_MKT_TYPE end  as Targetsettype 
,isnull(dptdc_line_no,0)        dptdc_line_no 

,isnull(DPTDC_PAYMODE,'') DPTDC_PAYMODE
,isnull(DPTDC_BANKACNO,'') DPTDC_BANKACNO
,isnull(DPTDC_BANKACNAME,'') DPTDC_BANKACNAME
,isnull(DPTDC_BANKBRNAME,'') DPTDC_BANKBRNAME
,isnull(DPTDC_TRANSFEREENAME,'') DPTDC_TRANSFEREENAME
,isnull(DPTDC_DOI,'') DPTDC_DOI
,isnull(DPTDC_CHQ_REFNO,'') DPTDC_CHQ_REFNO
FROM   dp_acct_mstr  dpam                         with(nolock)                     
              --,dp_mstr                      dpm                         
              --,dp_acct_mstr                 dpam                          
              --,exch_seg_mstr                excsm                        
              --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
              ,dptdc_mak                    dptdc    with(nolock)                                          
               left outer join                          
              settlement_type_mstr          settm1    with(nolock)                                           
              on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )                     
               left outer join                          
               settlement_type_mstr          settm2      with(nolock)                                         
                on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)             
            
        WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id                        
        --AND    dpm_excsm_id            = excsm.excsm_id                        
        --AND    dpam.dpam_dpm_id        = dpm.dpm_id                        
        AND    dptdc_dtls_id             = @pa_values                        
        --AND    excsm_list.excsm_id     = excsm.excsm_id                        
        AND    dptdc_deleted_ind         in (0,4,6,-1)                        
        AND    dptdc_internal_trastm            in ('ID')       
        AND    dptdc_internal_trastm            = @rowdelimiter                       
        and    isnull(dptdc_brokerbatch_no,'') = ''     
		order by dptdc_dtls_id                     
      --                        
      END                        
    --                        
    END         
    ELSE IF @pa_action = 'INTERDP_TRX_SEL_CDSL_DTLS'                        
   BEGIN                        
    --      
	 create table #tmpval4(dptdc_slip_no varchar(20),Val numeric,isin varchar(15),qty numeric)

  insert into #tmpval4
	select distinct dptdc_slip_no , (abs(dptdc_qty) * CLOPM_CDSL_RT) Val ,DPTDC_ISIN, abs(dptdc_qty) qty
	from dptdc_mak,CLOSING_LAST_CDSL
	where dptdc_deleted_ind  =1
	and DPTDC_ISIN = CLOPM_ISIN_CD
	and dptdc_dtls_id = @pa_id   

	                
      SELECT  dptdc_isin                        
       ,abs(dptdc_qty)     dptdc_qty                        
       ,dptdc_id         
       --,ISNULL(DPTDC_TRANS_NO,'')  DPTDC_TRANS_NO           
 ,CASE WHEN ISNULL(DPTDC_TRANS_NO,'')='' THEN DPTDC_INTERNAL_REF_NO ELSE ISNULL(DPTDC_TRANS_NO,'') END + '/'+ isnull((select distinct convert(varchar,val)  from #tmpval4 where isin = DPTDC_ISIN and  abs(qty) = abs(DPTDC_QTY)),'')    DPTDC_TRANS_NO            
--,CASE WHEN DPTDC_DELETED_IND IN (0,6,-1)  THEN 'MAKER ENTERED'        
--  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') <> ''  THEN 'BATCH UPLOADED'         
--  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'BATCH GENERATED'        
--  WHEN DPTDC_DELETED_IND = 1 AND ISNULL(DPTDC_BATCH_NO,'') = '' 
--AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'CHECKER APPROVED' END  STATUS      
, CASE WHEN DPTDC_DELETED_IND IN (0,6,-1) AND DPTDC_CREATED_BY = DPTDC_LST_UPD_BY  THEN 'MAKER ENTERED' 
  WHEN DPTDC_DELETED_IND = 0  AND DPTDC_CREATED_BY <> DPTDC_LST_UPD_BY AND ISNULL(dptdc_res_cd,'')  = '' THEN '1ST CHECKER DONE'  
  WHEN DPTDC_DELETED_IND  = 0 AND ISNULL(dptdc_res_cd,'')  <> '' THEN 'REJECTED'          
  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') <> ''  THEN 'BATCH UPLOADED'         
  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'BATCH GENERATED'        
  WHEN DPTDC_DELETED_IND = 1 AND ISNULL(DPTDC_BATCH_NO,'') = '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'CHECKER DONE' END  STATUS        
 
                   
      --FROM    dp_trx_dtls_cdsl            dptd                         
	 FROM    dptdc_mak            dptd         with(nolock)                                     
      WHERE   dptdc_dtls_id              = @pa_id                        
      AND     dptdc_deleted_ind          = 1                         
      AND    dptdc_internal_trastm       = @pa_cd                          
      and    isnull(dptdc_brokerbatch_no,'') = ''    order by dptdc_id   
	       
     drop table #tmpval4       
           
      --                        
      END                       
    ELSE IF @pa_action = 'INTERDP_TRX_SELM_CDSL_DTLS'                        
    BEGIN                        
    --                        
    create table #tmpval1(dptdc_slip_no varchar(20),Val numeric,isin varchar(15),qty numeric)

    insert into #tmpval1
	select distinct dptdc_slip_no , (abs(dptdc_qty) * CLOPM_CDSL_RT) Val ,DPTDC_ISIN , ABS(dptdc_qty) qty 
	from dptdc_mak,CLOSING_LAST_CDSL
	where dptdc_deleted_ind  in (0,4,6,-1)  
	and DPTDC_ISIN = CLOPM_ISIN_CD
	and dptdc_dtls_id = @pa_id   
                
      SELECT  dptdc_isin                        
             ,abs(dptdc_qty)     dptdc_qty                        
             ,dptdc_id          
            --,ISNULL(DPTDC_TRANS_NO,'')  DPTDC_TRANS_NO           
 ,CASE WHEN ISNULL(DPTDC_TRANS_NO,'')='' THEN DPTDC_INTERNAL_REF_NO ELSE ISNULL(DPTDC_TRANS_NO,'') END + '/'+ isnull((select distinct convert(varchar,val)  from #tmpval1 where isin = DPTDC_ISIN and  abs(qty) = abs(DPTDC_QTY)),'')   DPTDC_TRANS_NO            
--,CASE WHEN DPTDC_DELETED_IND IN (0,6,-1)  THEN 'MAKER ENTERED'        
--  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') <> ''  THEN 'BATCH UPLOADED'         
--  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'BATCH GENERATED'        
--  WHEN DPTDC_DELETED_IND = 1 AND ISNULL(DPTDC_BATCH_NO,'') = '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'CHECKER APPROVED' END  STATUS        
    , CASE WHEN DPTDC_DELETED_IND IN (0,6,-1) AND DPTDC_CREATED_BY = DPTDC_LST_UPD_BY  THEN 'MAKER ENTERED' 
  WHEN DPTDC_DELETED_IND = 0  AND DPTDC_CREATED_BY <> DPTDC_LST_UPD_BY AND ISNULL(dptdc_res_cd,'')  = '' THEN '1ST CHECKER DONE'    
  WHEN DPTDC_DELETED_IND  = 0 AND ISNULL(dptdc_res_cd,'')  <> '' THEN 'REJECTED'       
  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') <> ''  THEN 'BATCH UPLOADED'         
  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'BATCH GENERATED'        
  WHEN DPTDC_DELETED_IND = 1 AND ISNULL(DPTDC_BATCH_NO,'') = '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'CHECKER DONE' END  STATUS        
                     
              
      FROM    dptdc_mak                 dptdc          with(nolock)                                    
      WHERE   dptdc_dtls_id              = @pa_id                        
      AND     dptdc_deleted_ind          in (0,4,6,-1)                        
      AND     dptdc_internal_trastm       = @pa_cd                          
      and    isnull(dptdc_brokerbatch_no,'') = ''   order by dptdc_id     
    --     
	drop table #tmpval1      
    --                        
      END                        
  ELSE IF @pa_action = 'ONM_TRX_SEL_CDSL'                     
  BEGIN                        
  --                        
    SELECT distinct  @l_dpm_dpid                                DPID                         
          ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
          ,dptdc_slip_no       SLIPNO                         
          ,settm.settm_desc                                  SETTLEMENT_TYPE                        
          ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
          ,dpam_sba_no                                      ACCOUNTNO                        
          ,dptdc_counter_dp_id                               TARGERDPID                         
          ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
          ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
          ,DPTDC_CM_ID                                       CMID                         
          ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
          ,@pa_id                                          DEPOSITORY                        
          ,dptdc_excm_id                              EXCHANGEID                        
          ,dptdc_dtls_id                                     DTLSID                        
          ,dptdc_internal_trastm                         
          ,dptdc_rmks                        
          ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD         
             ,''      OTHERSETTLEMENTNO           
           ,''          OTHERSETTLEMENTTYPE               
          ,(Select DPM_NAME from dp_mstr where DPM_DPID = dptdc_counter_dp_id)[TARGERDPNAME]        
  -- ,dptdc_id     
  
,case when DPTDC_MKT_TYPE='' then DPTDC_OTHER_SETTLEMENT_TYPE else DPTDC_MKT_TYPE end as DPTDC_MKT_TYPE                        
    FROM   citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam   
          --,dp_mstr                      dpm                         
          --,dp_acct_mstr                 dpam                          
          --,exch_seg_mstr                excsm                        
          --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,dp_trx_dtls_cdsl             dptdc           with(nolock)                                   
           left outer join                          
        settlement_type_mstr          settm         with(nolock)                                      
           on (settm.settm_id            = case when dptdc.dptdc_mkt_type = ''  then  0  else dptdc.dptdc_mkt_type end or settm.settm_id = case when dptdc.dptdc_other_settlement_type = '' then 0 else dptdc.dptdc_other_settlement_type end)                





                   
    WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id                        
    --AND    dpm_excsm_id ONM_TRX_SELM_CDSL            = excsm.excsm_id                        
    --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
    --AND    excsm_list.excsm_id      = excsm.excsm_id                        
    --AND    excsm.excsm_id            = @pa_id                        
    AND    dptdc_deleted_ind         = 1                        
    AND     convert(varchar,dptdc.dptdc_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_cd end                        
    --AND     convert(varchar,dptdc.dptdc_request_dt,103) between CASE WHEN ISNULL(@pa_cd,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_cd end  and  CASE WHEN ISNULL(@coldelimiter,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @coldelimiter end                       
    AND    dptdc.dptdc_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
    AND    dpam.dpam_sba_no           LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
    AND    dptdc_deleted_ind = 1                        
    AND    dptdc_internal_trastm            in ('EP','NP')                          
    AND    dptdc_internal_trastm            = @rowdelimiter      
    and    isnull(dptdc_brokerbatch_no,'') = ''                        
                             --                        
  END                         
  ELSE IF @pa_action = 'ONM_TRX_SELC_CDSL'                        
  BEGIN                        
  --                        
    SELECT distinct  @l_dpm_dpid                                DPID                         
          ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
          ,dptdc_slip_no                                     SLIPNO                         
          ,settm.settm_desc                                  SETTLEMENT_TYPE                        
          ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
          ,dpam_sba_no                                      ACCOUNTNO                        
          ,dptdc_counter_dp_id                               TARGERDPID                         
          ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
          ,dptdc_counter_demat_acct_no               TARGERACCOUNTNO                        
          ,DPTDC_CM_ID                                       CMID                         
          ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
          ,@pa_id                                        DEPOSITORY                        
          ,dptdc_excm_id                                     EXCHANGEID                        
          ,dptdc_dtls_id                                     DTLSID                      
          ,dptdc_deleted_ind                                    
          --,abs(dptdc_qty)                                   dptdc_qty                        
          --,dptdc_isin                        
          ,chk = isnull((select case when count(*) >= 1 then 'YES' else 'NO' end from dptdc_mak dptdm where dptdm.dptdc_slip_no = dptdc.dptdc_slip_no  and  dptdm.DPTDc_TRASTM_CD = dptdc.DPTDc_TRASTM_CD and dptdm.DPTDc_EXECUTION_DT =                       
           dptdc.DPTDc_EXECUTION_DT and (dptdc_deleted_ind = -1 or isnull(ltrim(rtrim(dptdc_mid_chk)),'') <> '' ) ),'NO')                        
  ,highval = ((select top 1 CLOPM_CDSL_RT from closing_last_cdsl,dptdc_mak where  CLOPM_ISIN_CD = dptdc_isin and DPTDC_SLIP_NO = @pa_rmks) * abs(dptdc_qty))         
      
    FROM   citrus_usr.fn_acct_list_disdrf(@l_dpm_dpid,@l_entm_id,0) dpam      
          --,dp_mstr                      dpm                         
          --,dp_acct_mstr                 dpam                          
          --,exch_seg_mstr                excsm                        
          --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,dptdc_mak                    dptdc            with(nolock)                                  
left outer join                          
           settlement_type_mstr          settm       with(nolock)                                        
           on (settm.settm_id            = case when dptdc.dptdc_mkt_type = ''  then  0  else dptdc.dptdc_mkt_type end or settm.settm_id = case when dptdc.dptdc_other_settlement_type = '' then 0 else dptdc.dptdc_other_settlement_type end)                 
  
    
      
      
       
    WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id                        
    --AND    dpm_excsm_id              = excsm.excsm_id                        
    --AND    excsm_list.excsm_id      = excsm.excsm_id                        
    --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
    AND    dptdc_deleted_ind         in (0,4,6,-1)                        
    AND    dptdc_internal_trastm            in ('EP','NP')                          
    AND    dptdc_internal_trastm            = @rowdelimiter      
    and    isnull(dptdc_brokerbatch_no,'') = ''    and isnull(dptdc_res_cd,'') like case when @pa_desc = '' then '%' else @pa_desc end                      
  --                        
  END                        
  ELSE IF @pa_action = 'ONM_TRX_SELM_CDSL'                        
 BEGIN                        
  --                        
    IF @pa_values = ''                        
    BEGIN                        
    --                        
      SELECT distinct  @l_dpm_dpid                                DPID                         
            ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
            ,dptdc_slip_no                                     SLIPNO                         
            ,settm.settm_desc                                  SETTLEMENT_TYPE                        
            ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
            ,dpam_sba_no                                      ACCOUNTNO                        
            ,dptdc_counter_dp_id                               TARGERDPID                         
            ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
            ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
            ,DPTDC_CM_ID                                       CMID                         
            ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
            ,@pa_id                                          DEPOSITORY                        
            ,dptdc_excm_id                                     EXCHANGEID                        
            ,dptdc_dtls_id                                     DTLSID                        
            ,dptdc_internal_trastm        
            ,isnull(dptdc_rmks,'') + isnull(DPTDC_RES_desc,'')  dptdc_rmks                          
            ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD                         
            ,''      OTHERSETTLEMENTNO           
           ,''          OTHERSETTLEMENTTYPE                                     
            ,[TARGERDPNAME] = (Select DPM_NAME from dp_mstr where DPM_DPID = dptdc_counter_dp_id)                                        ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD                        
,dptdc_created_by Makerid        
--,dptdc_ID 
,case when  isnull(DPTDC_MKT_TYPE,'') = '' then DPTDC_OTHER_SETTLEMENT_TYPE  else DPTDC_MKT_TYPE end DPTDC_MKT_TYPE          
      FROM   citrus_usr.fn_acct_list_disdrf(@l_dpm_dpid,@l_entm_id,0) dpam 
            --,dp_mstr                      dpm                         
            --,dp_acct_mstr                 dpam                          
            --,exch_seg_mstr                excsm                        
  --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,dptdc_mak                    dptdc              with(nolock)                                
             left outer join                          
             settlement_type_mstr          settm          with(nolock)                                     
             on (settm.settm_id            = case when dptdc.dptdc_mkt_type = ''  then  0  else dptdc.dptdc_mkt_type end or settm.settm_id = case when dptdc.dptdc_other_settlement_type = '' then 0 else dptdc.dptdc_other_settlement_type end)               
  
    
      
      
       
          
      WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
  --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      --AND    excsm.excsm_id            = @pa_id                        
      AND     convert(varchar,dptdc.dptdc_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_cd end                        
      --AND     convert(varchar,dptdc.dptdc_request_dt,103) between CASE WHEN ISNULL(@pa_cd,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_cd end  and  CASE WHEN ISNULL(@coldelimiter,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @coldelimiter end                       
      AND    dptdc.dptdc_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
      AND    dpam.dpam_sba_no           LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
      AND    dptdc_deleted_ind        in (0,4,6,-1)                        
      AND    dptdc_internal_trastm            in ('EP','NP')       
      AND   dptdc_internal_trastm            = @rowdelimiter                         
      and isnull(dptdc_brokerbatch_no,'') = ''     
  --order by dptdc_dtls_id                   
    --                        
    END                        
    ELSE                        
    BEGIN                        
    --                        
      SELECT distinct  @l_dpm_dpid                                DPID                         
            ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
            ,dptdc_slip_no                                     SLIPNO                         
            ,settm.settm_desc                                  SETTLEMENT_TYPE                        
            ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
            ,dpam_sba_no          ACCOUNTNO                        
            ,dptdc_counter_dp_id                               TARGERDPID             
            ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
            ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
            ,DPTDC_CM_ID                                       CMID                         
            ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
            ,@pa_id                                          DEPOSITORY                        
            ,dptdc_excm_id                                     EXCHANGEID                        
            ,dptdc_dtls_id                                     DTLSID                        
            ,dptdc_internal_trastm                         
            ,isnull(dptdc_rmks,'') + isnull(DPTDC_RES_desc,'')  dptdc_rmks                         
            ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD        
              ,''      OTHERSETTLEMENTNO           
           ,''          OTHERSETTLEMENTTYPE                                     
            ,[TARGERDPNAME] = (Select DPM_NAME from dp_mstr where DPM_DPID = dptdc_counter_dp_id)                            
,dptdc_created_by Makerid        
--,dptdc_ID    
,case when  isnull(DPTDC_MKT_TYPE,'') = '' then DPTDC_OTHER_SETTLEMENT_TYPE  else DPTDC_MKT_TYPE end DPTDC_MKT_TYPE        
      FROM   citrus_usr.fn_acct_list_disdrf(@l_dpm_dpid,@l_entm_id,0) dpam     
            --,dp_mstr                      dpm                         
            --,dp_acct_mstr                 dpam                          
            --,exch_seg_mstr                excsm                        
            --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,dptdc_mak                    dptdc        with(nolock)                                      
             left outer join                          
             settlement_type_mstr          settm       with(nolock)                                        
             on (settm.settm_id       = case when dptdc.dptdc_mkt_type = ''  then  0  else dptdc.dptdc_mkt_type end or settm.settm_id = case when dptdc.dptdc_other_settlement_type = '' then 0 else dptdc.dptdc_other_settlement_type end)                   
   
   
     
      
      
      WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      AND    dptdc_dtls_id             = @pa_values                        
      AND   dptdc_deleted_ind           in (0,4,6,-1)                        
      AND    dptdc_internal_trastm        in ('EP','NP')         
      AND    dptdc_internal_trastm            = @rowdelimiter                      
      and    isnull(dptdc_brokerbatch_no,'') = ''                        
	--order by dptdc_dtls_id  
    --                        
    END                   
  --                        
  END          
                    
ELSE IF @pa_action = 'ONM_TRX_SELM_CDSL_CHECKER'                        
 BEGIN                        
  --                        
    IF @pa_values = ''                        
    BEGIN                        
    --                        
      SELECT distinct  @l_dpm_dpid                                DPID                         
            ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
            ,dptdc_slip_no                                     SLIPNO                         
            ,settm.settm_desc                                  SETTLEMENT_TYPE                        
            ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
            ,dpam_sba_no                                      ACCOUNTNO                        
            ,dptdc_counter_dp_id                               TARGERDPID                         
            ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
            ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
            ,DPTDC_CM_ID                                       CMID                         
            ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
            ,@pa_id                                          DEPOSITORY                        
            ,dptdc_excm_id                                     EXCHANGEID                        
            ,dptdc_dtls_id                                     DTLSID                        
            ,dptdc_internal_trastm        
            ,isnull(dptdc_rmks,'') + isnull(DPTDC_RES_desc,'')  dptdc_rmks                          
            ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD                         
            ,''      OTHERSETTLEMENTNO           
           ,''          OTHERSETTLEMENTTYPE                                     
            ,[TARGERDPNAME] = (Select DPM_NAME from dp_mstr where DPM_DPID = dptdc_counter_dp_id)                                        ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD                        
,dptdc_created_by Makerid        
--,dptdc_ID 
,DPTDC_MKT_TYPE     
      FROM   dp_acct_mstr dpam                     with(nolock)                         
            --,dp_mstr                      dpm                         
            --,dp_acct_mstr                 dpam                          
            --,exch_seg_mstr                excsm                        
  --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,dptdc_mak                    dptdc         with(nolock)                                     
             left outer join                          
             settlement_type_mstr          settm        with(nolock)                                       
             on (settm.settm_id            = case when dptdc.dptdc_mkt_type = ''  then  0  else dptdc.dptdc_mkt_type end or settm.settm_id = case when dptdc.dptdc_other_settlement_type = '' then 0 else dptdc.dptdc_other_settlement_type end)               
  
    
      
      
       
          
      WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
  --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      --AND    excsm.excsm_id            = @pa_id                        
      AND     convert(varchar,dptdc.dptdc_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_cd end                        
      --AND     convert(varchar,dptdc.dptdc_request_dt,103) between CASE WHEN ISNULL(@pa_cd,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_cd end  and  CASE WHEN ISNULL(@coldelimiter,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @coldelimiter end                       
      AND    dptdc.dptdc_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
      AND    dpam.dpam_sba_no           LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
      AND    dptdc_deleted_ind        in (0,4,6,-1)                        
      AND    dptdc_internal_trastm            in ('EP','NP')       
      AND   dptdc_internal_trastm            = @rowdelimiter                         
      and isnull(dptdc_brokerbatch_no,'') = ''     
  --order by dptdc_dtls_id                   
    --                        
    END                        
    ELSE                        
    BEGIN                        
    --                        
      SELECT distinct  @l_dpm_dpid                                DPID                         
            ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
            ,dptdc_slip_no                                     SLIPNO                         
            ,settm.settm_desc                                  SETTLEMENT_TYPE                        
            ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
            ,dpam_sba_no          ACCOUNTNO                        
            ,dptdc_counter_dp_id                               TARGERDPID             
            ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
            ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
            ,DPTDC_CM_ID                                       CMID                         
            ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
            ,@pa_id                                          DEPOSITORY                        
            ,dptdc_excm_id                                     EXCHANGEID                        
            ,dptdc_dtls_id                                     DTLSID                        
            ,dptdc_internal_trastm                         
            ,isnull(dptdc_rmks,'') + isnull(DPTDC_RES_desc,'')  dptdc_rmks                         
            ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD        
              ,''      OTHERSETTLEMENTNO           
           ,''          OTHERSETTLEMENTTYPE                                     
            ,[TARGERDPNAME] = (Select DPM_NAME from dp_mstr where DPM_DPID = dptdc_counter_dp_id)                            
,dptdc_created_by Makerid        
--,dptdc_ID    
,DPTDC_MKT_TYPE     
      FROM   dp_Acct_mstr dpam                     with(nolock)                         
            --,dp_mstr                      dpm                         
            --,dp_acct_mstr                 dpam                          
            --,exch_seg_mstr                excsm                        
            --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,dptdc_mak                    dptdc       with(nolock)                                       
             left outer join                          
             settlement_type_mstr          settm     with(nolock)                                          
             on (settm.settm_id       = case when dptdc.dptdc_mkt_type = ''  then  0  else dptdc.dptdc_mkt_type end or settm.settm_id = case when dptdc.dptdc_other_settlement_type = '' then 0 else dptdc.dptdc_other_settlement_type end)                   
   
   
     
      
      
      WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      AND    dptdc_dtls_id             = @pa_values                        
      AND   dptdc_deleted_ind           in (0,4,6,-1)                        
      AND    dptdc_internal_trastm        in ('EP','NP')         
      AND    dptdc_internal_trastm            = @rowdelimiter                      
      and    isnull(dptdc_brokerbatch_no,'') = ''                        
	--order by dptdc_dtls_id  
    --                        
    END                   
  --                        
  END           
  ELSE IF @pa_action = 'ONM_TRX_SEL_CDSL_DTLS'                        
   BEGIN            --                        
     create table #tmpval5(dptdc_slip_no varchar(20),Val numeric,isin varchar(15),qty numeric)

  insert into #tmpval5
	select distinct dptdc_slip_no , (abs(dptdc_qty) * CLOPM_CDSL_RT) Val ,DPTDC_ISIN,abs(dptdc_qty) qty
	from dptdc_mak,CLOSING_LAST_CDSL
	where dptdc_deleted_ind =1 
	and DPTDC_ISIN = CLOPM_ISIN_CD
	and dptdc_dtls_id = @pa_id   

                      
     SELECT  dptdc_isin                        
           ,abs(dptdc_qty)      dptdc_qty             
           ,dptdc_id         
        --   ,ISNULL(DPTDC_TRANS_NO,'')  DPTDC_TRANS_NO            
 ,CASE WHEN ISNULL(DPTDC_TRANS_NO,'')='' THEN DPTDC_INTERNAL_REF_NO ELSE ISNULL(DPTDC_TRANS_NO,'') END + '/'+ isnull((select distinct convert(varchar,val)  from #tmpval5 where isin = DPTDC_ISIN and  abs(qty) = abs(DPTDC_QTY)),'') DPTDC_TRANS_NO            
--,CASE WHEN DPTDC_DELETED_IND IN (0,6,-1)  THEN 'MAKER ENTERED'        
--  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') <> ''  THEN 'BATCH UPLOADED'         
--  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'BATCH GENERATED'        
--  WHEN DPTDC_DELETED_IND = 1 AND ISNULL(DPTDC_BATCH_NO,'') = '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'CHECKER APPROVED' END  STATUS        
, CASE WHEN DPTDC_DELETED_IND IN (0,6,-1) AND DPTDC_CREATED_BY = DPTDC_LST_UPD_BY  THEN 'MAKER ENTERED' 
  WHEN DPTDC_DELETED_IND = 0  AND DPTDC_CREATED_BY <> DPTDC_LST_UPD_BY AND ISNULL(dptdc_res_cd,'')  = '' THEN '1ST CHECKER DONE' 
  WHEN DPTDC_DELETED_IND  = 0 AND ISNULL(dptdc_res_cd,'')  <> '' THEN 'REJECTED'           
  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') <> ''  THEN 'BATCH UPLOADED'         
  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'BATCH GENERATED'        
  WHEN DPTDC_DELETED_IND = 1 AND ISNULL(DPTDC_BATCH_NO,'') = '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'CHECKER DONE' END  STATUS        

               
    --FROM    dp_trx_dtls_cdsl                    dptdc                        
    from dptdc_mak			dptdc with(nolock)                     
    WHERE   dptdc_dtls_id              = @pa_id                        
    AND     dptdc_deleted_ind          = 1                        
    AND     dptdc_internal_trastm       = @pa_cd                          
    and    isnull(dptdc_brokerbatch_no,'') = ''        
    order by dptdc_id    
	
	drop table #tmpval5                       
    --                        
  END                        
  ELSE IF @pa_action = 'ONM_TRX_SELM_CDSL_DTLS'                        
   BEGIN                        
  --                        
    create table #tmpval2(dptdc_slip_no varchar(20),Val numeric,isin varchar(15),qty numeric)

  insert into #tmpval2
	select distinct dptdc_slip_no , (abs(dptdc_qty) * CLOPM_CDSL_RT) Val ,DPTDC_ISIN ,abs(DPTDC_QTY) qty
	from dptdc_mak,CLOSING_LAST_CDSL
	where dptdc_deleted_ind  in (0,4,6,-1)  
	and DPTDC_ISIN = CLOPM_ISIN_CD
	and dptdc_dtls_id = @pa_id   
	
                       
   SELECT  dptdc_isin                        
           ,abs(dptdc_qty)               dptdc_qty                        
           ,dptdc_id          
         --  ,ISNULL(DPTDC_TRANS_NO,'')  DPTDC_TRANS_NO            
 ,CASE WHEN ISNULL(DPTDC_TRANS_NO,'')='' THEN DPTDC_INTERNAL_REF_NO ELSE ISNULL(DPTDC_TRANS_NO,'') END + '/'+ isnull((select distinct convert(varchar,val)  from #tmpval2 where isin = DPTDC_ISIN and  abs(qty) = abs(DPTDC_QTY)),'')  DPTDC_TRANS_NO            
--,CASE WHEN DPTDC_DELETED_IND IN (0,6,-1)  THEN 'MAKER ENTERED'        
--  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') <> ''  THEN 'BATCH UPLOADED'         
--  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'BATCH GENERATED'        
--  WHEN DPTDC_DELETED_IND = 1 AND ISNULL(DPTDC_BATCH_NO,'') = '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'CHECKER APPROVED' END  STATUS        
   , CASE WHEN DPTDC_DELETED_IND IN (0,6,-1) AND DPTDC_CREATED_BY = DPTDC_LST_UPD_BY  THEN 'MAKER ENTERED' 
  WHEN DPTDC_DELETED_IND = 0  AND DPTDC_CREATED_BY <> DPTDC_LST_UPD_BY AND ISNULL(dptdc_res_cd,'')  = '' THEN '1ST CHECKER DONE'   
  WHEN DPTDC_DELETED_IND  = 0 AND ISNULL(dptdc_res_cd,'')  <> '' THEN 'REJECTED'        
  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') <> ''  THEN 'BATCH UPLOADED'         
  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'BATCH GENERATED'        
  WHEN DPTDC_DELETED_IND = 1 AND ISNULL(DPTDC_BATCH_NO,'') = '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'CHECKER DONE' END  STATUS        
                      
                     
    FROM    dptdc_mak                    dptdc with(nolock)                        
    WHERE   dptdc_dtls_id              = @pa_id                        
    AND     dptdc_deleted_ind            IN (0,4,6,-1)                        
    AND     dptdc_internal_trastm    = @pa_cd                          
    and    isnull(dptdc_brokerbatch_no,'') = ''           
    order by dptdc_id 
		
drop table #tmpval2                    
  --                        
  END                        
        
ELSE IF @pa_action = 'OFFM_TRX_SELC_CDSL'                        
  BEGIN                        
  --                       
IF LTRIM(RTRIM(@ColDelimiter))='S'
BEGIN

if (@pa_cd='--ALL--')
BEGIN 

SELECT 
distinct DPID                         
          ,REQUESTDATE                         
          ,EXECUTIONDATE                        
          ,SLIPNO                         
          ,SETTLEMENT_TYPE                        
          , SETTLEMENTNO                        
          ,ACCOUNTNO                        
          ,TARGERDPID                         
          ,TARGERCMBPID                        
          ,TARGERACCOUNTNO                        
          ,CMID                         
          ,CASH                                            
          ,DEPOSITORY                        
          ,EXCHANGEID                    
          ,DTLSID                        
          ,INTERNAL_CD                         
          ,DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk  
          --,dptdc_isin                        
          ,    OTHERSETTLEMENTNO          
          ,OTHERSETTLEMENTTYPE         
          ,Makerid              
          ,sum(highval) highval ,ClientOutstanding,dptdc_dtls_id
from

(
    SELECT distinct  
          --@l_dpm_dpid                                DPID                         
          dpm_dpid                                DPID                         
          ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
          ,dptdc_slip_no                                     SLIPNO                         
          ,settm1.settm_desc                                  SETTLEMENT_TYPE                        
          ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
          ,dpam_sba_no                                      ACCOUNTNO                        
          ,dptdc_counter_dp_id                               TARGERDPID                         
          ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
          ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
          ,DPTDC_CM_ID                                       CMID                         
          ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
          ,DPM_EXCSM_ID  DEPOSITORY -- @pa_id                                         DEPOSITORY                        
          ,dptdc_excm_id                                   EXCHANGEID                    
          ,dptdc_dtls_id                                     DTLSID                        
          ,dptdc_internal_trastm                             INTERNAL_CD                         
          ,'0'                                 DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk = isnull((select case when count(*) >= 1 then 'YES' else 'NO' end from dptdc_mak dptdm where dptdm.dptdc_slip_no = dptdc.dptdc_slip_no  and  dptdm.DPTDc_TRASTM_CD = dptdc.DPTDc_TRASTM_CD and dptdm.DPTDc_EXECUTION_DT =                      
 
           dptdc.DPTDc_EXECUTION_DT and (dptdc_deleted_ind = -1 or isnull(ltrim(rtrim(dptdc_mid_chk)),'') <> '' ) ),'NO')                        
          --,dptdc_isin                        
          ,case when dptdc_settlement_no = '' then '' else isnull(dptdc_other_settlement_no,'') end     OTHERSETTLEMENTNO          
          ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE         
          --,dptdc_created_by Makerid              
          ,dptdc_created_by  + ' ( ' + 
          LTRIM(RTRIM((SELECT TOP 1 REPLACE(ENTM_SHORT_NAME  ,'_' + ENTM_ENTTM_CD ,'') + '-' + ENTM_NAME1 FROM LOGIN_NAMES , ENTITY_MSTR 
			WHERE ENTM_ID = LOGN_ENT_ID  AND LOGN_DELETED_IND = 1 
			AND ENTM_DELETED_IND =1  AND LOGN_NAME = dptdc_created_by)))
 + ' )' as  Makerid
          ,highval = convert(numeric,((select top 1 CLOPM_CDSL_RT from closing_last_cdsl where  CLOPM_ISIN_CD = dptdc_isin and DPTDC_SLIP_NO like case when @pa_rmks = '' then '%' else @pa_rmks end) * abs(dptdc_qty)))         
,ClientOutstanding=citrus_usr.Toget_OutsBal(dpam_sba_no),dptdc_dtls_id
    FROM   --citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
          dp_mstr                      dpm   with(nolock)                                            
          ,dp_acct_mstr                 dpam      with(nolock)                                         
          ,exch_seg_mstr                excsm     with(nolock)                                        
          , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list     
          ,dptdc_mak                    dptdc   with(nolock)                            
           LEFT OUTER JOIN                          
           settlement_type_mstr          settm1                         with(nolock)                      
           on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )                    
           left outer join                          
           settlement_type_mstr          settm2   with(nolock)                                            
           on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)                            
    WHERE  dpam.dpam_id                  = dptdc.dptdc_dpam_id                        
    AND    dpm_excsm_id                  = excsm.excsm_id                      
	AND    excsm_list.excsm_id      = excsm.excsm_id                        
    AND    dpam.dpam_dpm_id              = dpm.dpm_id                        
    --AND    dptdc.dptdc_lst_upd_by        <> @pa_login_name 
    AND    case when dptdc.dptdc_mid_chk <> '' then dptdc.dptdc_mid_chk else dptdc.DPTDC_LST_UPD_BY end  <> @pa_login_name                
    and    DPTDC_CREATED_BY <> @pa_login_name                
	AND    case when dptdc.DPTDC_LST_UPD_BY <> '' then dptdc.DPTDC_LST_UPD_BY  end  <> @pa_login_name   
	
    --AND    dpm_excsm_id                  = convert(int,@pa_cd)                        
    AND    dptdc_deleted_ind             in (0,4,6,-1)                        
    AND    dptdc_internal_trastm         in ('BOBO','BOCM','CMBO','CMCM','ID','EP','NP')                
    --AND    dptdc_internal_trastm            = @rowdelimiter      
    and    dptdc_slip_no like case when @pa_rmks = '' then '%' else @pa_rmks end         
    and    DPTDC_CREATED_BY like case when @pa_desc = '' then '%'  else @pa_desc end        
    and   convert(varchar,DPTDC_REQUEST_DT,103)  = case when @pa_values = '' then convert(varchar,DPTDC_REQUEST_DT,103) else @pa_values end          
  --AND convert(datetime,convert(varchar(11),dptdc_execution_dt,109))    like case when @pa_values = '' then '%'  else @pa_values end                           
    and    isnull(dptdc_brokerbatch_no,'') = '' --  and isnull(dptdc_res_cd,'') like case when @pa_desc = '' then '%' else @pa_desc end                         
    and    dptdc_internal_trastm LIKE (case when LTRIM(RTRIM(@RowDelimiter)) = '' then '%' else LTRIM(RTRIM(@RowDelimiter)) end)         
    AND DPTDC_SLIP_NO  IN (SELECT SLIP_NO FROM MAKER_SCANCOPY where deleted_ind <> 9)
    and    isnull(dptdc_res_desc,'')        = ''
	and  citrus_usr.fn_chk_app_level_cdsl (0,DPTDC_DTLS_ID,@pa_login_name,DPTDC_REQUEST_DT) = 'Y'

) t

group by DPID                       
          ,REQUESTDATE                         
          ,EXECUTIONDATE                        
          ,SLIPNO                         
          ,SETTLEMENT_TYPE                        
          , SETTLEMENTNO                        
          ,ACCOUNTNO                        
          ,TARGERDPID                         
          ,TARGERCMBPID                        
          ,TARGERACCOUNTNO                        
          ,CMID                         
          ,CASH                                            
          ,DEPOSITORY                        
          ,EXCHANGEID                    
          ,DTLSID                        
          ,INTERNAL_CD                         
          ,DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk  
          --,dptdc_isin                        
          ,    OTHERSETTLEMENTNO          
          ,OTHERSETTLEMENTTYPE         
          ,Makerid   ,ClientOutstanding,dptdc_dtls_id
          order by dptdc_dtls_id


END
ELSE --- AS IT IS FOR ELSE ALL
BEGIN 
print 'll'
SELECT 
distinct DPID                         
          ,REQUESTDATE                         
          ,EXECUTIONDATE                        
          ,SLIPNO                         
          ,SETTLEMENT_TYPE                        
          , SETTLEMENTNO                        
          ,ACCOUNTNO                        
          ,TARGERDPID                         
          ,TARGERCMBPID                        
          ,TARGERACCOUNTNO                        
          ,CMID                         
          ,CASH                                            
          ,DEPOSITORY                        
          ,EXCHANGEID                    
          ,DTLSID                        
          ,INTERNAL_CD                         
          ,DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk  
          --,dptdc_isin                        
          ,    OTHERSETTLEMENTNO          
          ,OTHERSETTLEMENTTYPE         
          ,Makerid              
          ,sum(highval) highval ,ClientOutstanding,dptdc_dtls_id
from

(
    SELECT distinct  @l_dpm_dpid                                DPID                         
          ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
          ,dptdc_slip_no                                     SLIPNO                         
          ,isnull(settm1.settm_desc,settm2.settm_desc)       SETTLEMENT_TYPE                        
          ,case when isnull(dptdc_settlement_no,'') = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
          ,dpam_sba_no                                      ACCOUNTNO                        
          ,dptdc_counter_dp_id                               TARGERDPID                         
          ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
          ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
          ,DPTDC_CM_ID                                       CMID                         
          ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
          ,@pa_id                                         DEPOSITORY                        
          ,dptdc_excm_id                                   EXCHANGEID                    
          ,dptdc_dtls_id                                     DTLSID                        
          ,dptdc_internal_trastm                             INTERNAL_CD                         
          ,'0'                                 DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk = isnull((select case when count(*) >= 1 then 'YES' else 'NO' end from dptdc_mak dptdm where dptdm.dptdc_slip_no = dptdc.dptdc_slip_no  and  dptdm.DPTDc_TRASTM_CD = dptdc.DPTDc_TRASTM_CD and dptdm.DPTDc_EXECUTION_DT =                      
 
           dptdc.DPTDc_EXECUTION_DT and (dptdc_deleted_ind = -1 or isnull(ltrim(rtrim(dptdc_mid_chk)),'') <> '' ) ),'NO')                        
          --,dptdc_isin                        
          ,case when dptdc_settlement_no = '' then '' else isnull(dptdc_other_settlement_no,'') end     OTHERSETTLEMENTNO          
          ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE         
          --,dptdc_created_by Makerid              
          ,dptdc_created_by  + ' ( ' + 
          LTRIM(RTRIM((SELECT TOP 1 REPLACE(ENTM_SHORT_NAME  ,'_' + ENTM_ENTTM_CD ,'') + '-' + ENTM_NAME1 FROM LOGIN_NAMES , ENTITY_MSTR 
			WHERE ENTM_ID = LOGN_ENT_ID  AND LOGN_DELETED_IND = 1 
			AND ENTM_DELETED_IND =1  AND LOGN_NAME = dptdc_created_by))) + ' )' as  Makerid
          ,highval = convert(numeric,((select top 1 CLOPM_CDSL_RT from closing_last_cdsl where  CLOPM_ISIN_CD = dptdc_isin and DPTDC_SLIP_NO like case when @pa_rmks = '' then '%' else @pa_rmks end) * abs(dptdc_qty)))
,ClientOutstanding=citrus_usr.Toget_OutsBal(dpam_sba_no),dptdc_dtls_id
    FROM  -- citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
          dp_mstr                      dpm   with(nolock)                                           
          ,dp_acct_mstr                 dpam   with(nolock)                                            
          ,exch_seg_mstr                excsm   with(nolock)                                          
          , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list    
          ,dptdc_mak                    dptdc     with(nolock)                          
           LEFT OUTER JOIN                          
           settlement_type_mstr          settm1    with(nolock)                                           
           on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )                    
           left outer join                          
           settlement_type_mstr          settm2     with(nolock)                                          
           on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)                            
    WHERE  dpam.dpam_id                  = dptdc.dptdc_dpam_id                        
    AND    dpm_excsm_id                  = excsm.excsm_id                      AND    excsm_list.excsm_id      = excsm.excsm_id                        
    AND    dpam.dpam_dpm_id              = dpm.dpm_id                        
    AND    dptdc.dptdc_lst_upd_by        <> @pa_login_name 
    AND    case when dptdc.dptdc_mid_chk <> '' then dptdc.dptdc_mid_chk else dptdc.DPTDC_LST_UPD_BY end  <> @pa_login_name                
    and    DPTDC_CREATED_BY <> @pa_login_name    
	AND    case when dptdc.DPTDC_LST_UPD_BY <> '' then dptdc.DPTDC_LST_UPD_BY  end  <> @pa_login_name                            
    --AND    dpm_excsm_id                  = convert(int,@pa_cd)                        
    AND    dptdc_deleted_ind             in (0,4,6,-1)                        
    AND    dptdc_internal_trastm         in ('BOBO','BOCM','CMBO','CMCM','ID','EP','NP')                
    --AND    dptdc_internal_trastm            = @rowdelimiter      
    and    dptdc_slip_no like case when @pa_rmks = '' then '%' else @pa_rmks end         
	and    DPTDC_CREATED_BY like case when @pa_desc = '' then '%'  else @pa_desc end        
    and   convert(varchar,DPTDC_REQUEST_DT,103)  = case when @pa_values = '' then convert(varchar,DPTDC_REQUEST_DT,103) else @pa_values end          
  --AND convert(datetime,convert(varchar(11),dptdc_execution_dt,109))    like case when @pa_values = '' then '%'  else @pa_values end                           
    and    isnull(dptdc_brokerbatch_no,'') = '' --  and isnull(dptdc_res_cd,'') like case when @pa_desc = '' then '%' else @pa_desc end                         
    and    dptdc_internal_trastm LIKE (case when LTRIM(RTRIM(@RowDelimiter)) = '' then '%' else LTRIM(RTRIM(@RowDelimiter)) end)         
    AND DPTDC_SLIP_NO  IN (SELECT SLIP_NO FROM MAKER_SCANCOPY where deleted_ind <> 9)
	and    isnull(dptdc_res_desc,'')        = ''
	and  citrus_usr.fn_chk_app_level_cdsl (0,DPTDC_DTLS_ID,@pa_login_name,DPTDC_REQUEST_DT) = 'Y'

) t

group by DPID                       
          ,REQUESTDATE                         
          ,EXECUTIONDATE                        
          ,SLIPNO                         
          ,SETTLEMENT_TYPE                        
          , SETTLEMENTNO                        
          ,ACCOUNTNO                        
          ,TARGERDPID                         
          ,TARGERCMBPID                        
          ,TARGERACCOUNTNO                        
          ,CMID                         
          ,CASH                                            
          ,DEPOSITORY                        
          ,EXCHANGEID                    
          ,DTLSID                        
          ,INTERNAL_CD                         
          ,DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk  
          --,dptdc_isin                        
          ,    OTHERSETTLEMENTNO          
          ,OTHERSETTLEMENTTYPE         
          ,Makerid   ,ClientOutstanding,dptdc_dtls_id
order by dptdc_dtls_id 

END -- ALL

END 

ELSE if LTRIM(RTRIM(@ColDelimiter))='WS'
BEGIN -- WITH OUT SCAN

if (@pa_cd='--ALL--')
BEGIN 

SELECT 
distinct DPID                         
          ,REQUESTDATE                         
          ,EXECUTIONDATE                        
          ,SLIPNO                         
          ,SETTLEMENT_TYPE                        
          , SETTLEMENTNO                        
          ,ACCOUNTNO                        
          ,TARGERDPID                         
          ,TARGERCMBPID                        
          ,TARGERACCOUNTNO                        
          ,CMID                         
          ,CASH                                            
          ,DEPOSITORY                        
          ,EXCHANGEID                    
          ,DTLSID                        
          ,INTERNAL_CD                         
          ,DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk  
          --,dptdc_isin                        
          ,    OTHERSETTLEMENTNO          
          ,OTHERSETTLEMENTTYPE         
          ,Makerid              
          ,sum(highval) highval ,ClientOutstanding,dptdc_dtls_id
from

(

 SELECT distinct  
--@l_dpm_dpid                                DPID                         
dpm_dpid DPID                         
          ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
          ,dptdc_slip_no                                     SLIPNO                         
          ,settm1.settm_desc                                  SETTLEMENT_TYPE                        
          ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
          ,dpam_sba_no                                      ACCOUNTNO                        
          ,dptdc_counter_dp_id                               TARGERDPID                         
          ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
          ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
          ,DPTDC_CM_ID                                       CMID                         
          ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
          ,DPM_EXCSM_ID DEPOSITORY --@pa_id                                         DEPOSITORY                        
          ,dptdc_excm_id                                   EXCHANGEID                    
          ,dptdc_dtls_id                                     DTLSID                        
          ,dptdc_internal_trastm                             INTERNAL_CD                         
          ,'0'                                 DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk = isnull((select case when count(*) >= 1 then 'YES' else 'NO' end from dptdc_mak dptdm where dptdm.dptdc_slip_no = dptdc.dptdc_slip_no  and  dptdm.DPTDc_TRASTM_CD = dptdc.DPTDc_TRASTM_CD and dptdm.DPTDc_EXECUTION_DT =                      
 
           dptdc.DPTDc_EXECUTION_DT and (dptdc_deleted_ind = -1 or isnull(ltrim(rtrim(dptdc_mid_chk)),'') <> '' ) ),'NO')                        
          --,dptdc_isin                        
          ,case when dptdc_settlement_no = '' then '' else isnull(dptdc_other_settlement_no,'') end     OTHERSETTLEMENTNO          
          ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE         
          --,dptdc_created_by Makerid              
          ,dptdc_created_by  + ' ( ' + 
          LTRIM(RTRIM((SELECT TOP 1 REPLACE(ENTM_SHORT_NAME  ,'_' + ENTM_ENTTM_CD ,'') + '-' + ENTM_NAME1 FROM LOGIN_NAMES , ENTITY_MSTR 
			WHERE ENTM_ID = LOGN_ENT_ID  AND LOGN_DELETED_IND = 1 
			AND ENTM_DELETED_IND =1  AND LOGN_NAME = dptdc_created_by))) + ' )' as  Makerid
          ,highval = convert(numeric,((select top 1 CLOPM_CDSL_RT from closing_last_cdsl where  CLOPM_ISIN_CD = dptdc_isin and DPTDC_SLIP_NO like case when @pa_rmks = '' then '%' else @pa_rmks end) * abs(dptdc_qty)))         
,ClientOutstanding=citrus_usr.Toget_OutsBal(dpam_sba_no),dptdc_dtls_id

    FROM   --citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
          dp_mstr                      dpm           with(nolock)                                   
          ,dp_acct_mstr                 dpam        with(nolock)                                      
          ,exch_seg_mstr                excsm        with(nolock)                                     
          , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list  
          ,dptdc_mak                    dptdc     with(nolock)                          
           LEFT OUTER JOIN                          
           settlement_type_mstr          settm1     with(nolock)                                          
           on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )                    
           left outer join                          
           settlement_type_mstr          settm2    with(nolock)                                           
           on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)                            
    WHERE  dpam.dpam_id                  = dptdc.dptdc_dpam_id                        
    AND    dpm_excsm_id                  = excsm.excsm_id                      AND    excsm_list.excsm_id      = excsm.excsm_id                        
    AND    dpam.dpam_dpm_id              = dpm.dpm_id                        
   -- AND    dptdc.dptdc_lst_upd_by        <> @pa_login_name    
    AND    case when dptdc.dptdc_mid_chk <> '' then dptdc.dptdc_mid_chk else dptdc.DPTDC_LST_UPD_BY end  <> @pa_login_name   
     and    DPTDC_CREATED_BY <> @pa_login_name                 
	AND    case when dptdc.DPTDC_LST_UPD_BY <> '' then dptdc.DPTDC_LST_UPD_BY  end  <> @pa_login_name                         
    --AND    dpm_excsm_id                  = convert(int,@pa_cd)                        
    AND    dptdc_deleted_ind             in (0,4,6,-1)                        
    AND    dptdc_internal_trastm         in ('BOBO','BOCM','CMBO','CMCM','ID','EP','NP')                
    --AND    dptdc_internal_trastm            = @rowdelimiter      
    and    dptdc_slip_no like case when @pa_rmks = '' then '%' else @pa_rmks end         
 and    DPTDC_CREATED_BY like case when @pa_desc = '' then '%'  else @pa_desc end        
    and   convert(varchar,DPTDC_REQUEST_DT,103)  = case when @pa_values = '' then convert(varchar,DPTDC_REQUEST_DT,103) else @pa_values end          
  --AND convert(datetime,convert(varchar(11),dptdc_execution_dt,109))    like case when @pa_values = '' then '%'  else @pa_values end                           
    and    isnull(dptdc_brokerbatch_no,'') = ''   --and isnull(dptdc_res_cd,'') like case when @pa_desc = '' then '%' else @pa_desc end                         
    and    dptdc_internal_trastm LIKE (case when LTRIM(RTRIM(@RowDelimiter)) = '' then '%' else LTRIM(RTRIM(@RowDelimiter)) end)         
    AND DPTDC_SLIP_NO NOT IN (SELECT SLIP_NO FROM MAKER_SCANCOPY where deleted_ind <> 9)
and    isnull(dptdc_res_desc,'')        = ''
and  citrus_usr.fn_chk_app_level_cdsl (0,DPTDC_DTLS_ID,@pa_login_name,DPTDC_REQUEST_DT) = 'Y'
) t
group by DPID                         
          ,REQUESTDATE                         
          ,EXECUTIONDATE                        
          ,SLIPNO                         
          ,SETTLEMENT_TYPE                        
          , SETTLEMENTNO                        
          ,ACCOUNTNO                        
          ,TARGERDPID                         
          ,TARGERCMBPID                        
          ,TARGERACCOUNTNO                        
          ,CMID                         
          ,CASH                                            
          ,DEPOSITORY                        
          ,EXCHANGEID                    
          ,DTLSID                        
          ,INTERNAL_CD                         
          ,DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk  
          --,dptdc_isin                        
          ,    OTHERSETTLEMENTNO          
          ,OTHERSETTLEMENTTYPE         
          ,Makerid  ,ClientOutstanding ,dptdc_dtls_id
          order by dptdc_dtls_id

end 

ELSE -- AS IT IS FOR ALL
BEGIN 
print 'pppp'
SELECT 
distinct DPID                         
          ,REQUESTDATE                         
          ,EXECUTIONDATE                        
          ,SLIPNO                         
          ,SETTLEMENT_TYPE                        
          , SETTLEMENTNO                        
          ,ACCOUNTNO                        
          ,TARGERDPID                         
          ,TARGERCMBPID                        
          ,TARGERACCOUNTNO                        
          ,CMID                         
          ,CASH                                            
          ,DEPOSITORY                        
          ,EXCHANGEID                    
          ,DTLSID                        
          ,INTERNAL_CD                         
          ,DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk  
          --,dptdc_isin                        
          ,    OTHERSETTLEMENTNO          
          ,OTHERSETTLEMENTTYPE         
          ,Makerid              
          ,sum(highval) highval ,ClientOutstanding,dptdc_dtls_id
from

(

 SELECT distinct  @l_dpm_dpid                                DPID                         
          ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
          ,dptdc_slip_no                                     SLIPNO                         
          ,isnull(settm1.settm_desc,settm2.settm_desc)                                 SETTLEMENT_TYPE                        
          ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
          ,dpam_sba_no                                      ACCOUNTNO                        
          ,dptdc_counter_dp_id                               TARGERDPID                         
          ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
          ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
          ,DPTDC_CM_ID                                       CMID                         
          ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
          ,@pa_id                                         DEPOSITORY                        
          ,dptdc_excm_id                                   EXCHANGEID                    
          ,dptdc_dtls_id                                     DTLSID                        
          ,dptdc_internal_trastm                             INTERNAL_CD                         
          ,'0'                                 DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk = isnull((select case when count(*) >= 1 then 'YES' else 'NO' end from dptdc_mak dptdm where dptdm.dptdc_slip_no = dptdc.dptdc_slip_no  and  dptdm.DPTDc_TRASTM_CD = dptdc.DPTDc_TRASTM_CD and dptdm.DPTDc_EXECUTION_DT =                      
 
           dptdc.DPTDc_EXECUTION_DT and (dptdc_deleted_ind = -1 or isnull(ltrim(rtrim(dptdc_mid_chk)),'') <> '' ) ),'NO')                        
          --,dptdc_isin                        
          ,case when dptdc_settlement_no = '' then '' else isnull(dptdc_other_settlement_no,'') end     OTHERSETTLEMENTNO          
          ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE         
          --,dptdc_created_by Makerid              
          ,dptdc_created_by  + ' ( ' + 
          LTRIM(RTRIM((SELECT TOP 1 REPLACE(ENTM_SHORT_NAME  ,'_' + ENTM_ENTTM_CD ,'') + '-' + ENTM_NAME1 FROM LOGIN_NAMES , ENTITY_MSTR 
			WHERE ENTM_ID = LOGN_ENT_ID  AND LOGN_DELETED_IND = 1 
			AND ENTM_DELETED_IND =1  AND LOGN_NAME = dptdc_created_by))) + ' )' as  Makerid
          ,highval = convert(numeric,((select top 1 CLOPM_CDSL_RT from closing_last_cdsl where  CLOPM_ISIN_CD = dptdc_isin and DPTDC_SLIP_NO like case when @pa_rmks = '' then '%' else @pa_rmks end) * abs(dptdc_qty)))         
,ClientOutstanding=citrus_usr.Toget_OutsBal(dpam_sba_no),dptdc_dtls_id
    FROM  -- citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
          dp_mstr                      dpm            with(nolock)                                  
          ,dp_acct_mstr                 dpam         with(nolock)                                      
          ,exch_seg_mstr                excsm        with(nolock)                                     
          , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list    
          ,dptdc_mak                    dptdc          with(nolock)                     
           LEFT OUTER JOIN                          
           settlement_type_mstr          settm1          with(nolock)                                     
           on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )                    
           left outer join                          
           settlement_type_mstr          settm2        with(nolock)                                       
           on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)                            
    WHERE  dpam.dpam_id                  = dptdc.dptdc_dpam_id                        
    AND    dpm_excsm_id                  = excsm.excsm_id                      AND    excsm_list.excsm_id      = excsm.excsm_id                        
    AND    dpam.dpam_dpm_id              = dpm.dpm_id                        
    AND    dptdc.dptdc_lst_upd_by        <> @pa_login_name  
    AND    case when dptdc.dptdc_mid_chk <> '' then dptdc.dptdc_mid_chk else dptdc.DPTDC_LST_UPD_BY end  <> @pa_login_name 
     and    DPTDC_CREATED_BY <> @pa_login_name                   
	AND    case when dptdc.DPTDC_LST_UPD_BY <> '' then dptdc.DPTDC_LST_UPD_BY  end  <> @pa_login_name                           
    --AND    dpm_excsm_id                  = convert(int,@pa_cd)                        
    AND    dptdc_deleted_ind             in (0,4,6,-1)                        
    AND    dptdc_internal_trastm         in ('BOBO','BOCM','CMBO','CMCM','ID','EP','NP')                
    --AND    dptdc_internal_trastm            = @rowdelimiter      
    and    dptdc_slip_no like case when @pa_rmks = '' then '%' else @pa_rmks end         
 and    DPTDC_CREATED_BY like case when @pa_desc = '' then '%'  else @pa_desc end        
    and   convert(varchar,DPTDC_REQUEST_DT,103)  = case when @pa_values = '' then convert(varchar,DPTDC_REQUEST_DT,103) else @pa_values end          
  --AND convert(datetime,convert(varchar(11),dptdc_execution_dt,109))    like case when @pa_values = '' then '%'  else @pa_values end                           
    and    isnull(dptdc_brokerbatch_no,'') = ''   --and isnull(dptdc_res_cd,'') like case when @pa_desc = '' then '%' else @pa_desc end                         
    and    dptdc_internal_trastm LIKE (case when LTRIM(RTRIM(@RowDelimiter)) = '' then '%' else LTRIM(RTRIM(@RowDelimiter)) end)         
    AND DPTDC_SLIP_NO NOT IN (SELECT SLIP_NO FROM MAKER_SCANCOPY where deleted_ind <> 9)
and    isnull(dptdc_res_desc,'')        = ''
and  citrus_usr.fn_chk_app_level_cdsl (0,DPTDC_DTLS_ID,@pa_login_name,DPTDC_REQUEST_DT) = 'Y'
) t
group by DPID                         
          ,REQUESTDATE                         
          ,EXECUTIONDATE                        
          ,SLIPNO                         
          ,SETTLEMENT_TYPE                        
          , SETTLEMENTNO                        
          ,ACCOUNTNO                        
          ,TARGERDPID                         
          ,TARGERCMBPID                        
          ,TARGERACCOUNTNO                        
          ,CMID                         
          ,CASH                                            
          ,DEPOSITORY                        
          ,EXCHANGEID                    
          ,DTLSID                        
          ,INTERNAL_CD                         
          ,DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk  
          --,dptdc_isin                        
          ,    OTHERSETTLEMENTNO          
          ,OTHERSETTLEMENTTYPE         
          ,Makerid   ,ClientOutstanding,dptdc_dtls_id
          order by dptdc_dtls_id

END -- ALL
END
ELSE 
BEGIN 

-- new condition for 'ALL'  
if (@pa_cd='--ALL--')
BEGIN 

PRINT '2434343'
print @l_dpm_dpid
SELECT 
distinct DPID                         
          ,REQUESTDATE                         
          ,EXECUTIONDATE                        
          ,SLIPNO                         
          ,SETTLEMENT_TYPE                        
          , SETTLEMENTNO                        
          ,ACCOUNTNO                        
          ,TARGERDPID                         
          ,TARGERCMBPID                        
          ,TARGERACCOUNTNO                        
          ,CMID                         
          ,CASH                                            
          ,DEPOSITORY                        
          ,EXCHANGEID                    
          ,DTLSID                        
          ,INTERNAL_CD                         
          ,DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk  
          --,dptdc_isin                        
          ,    OTHERSETTLEMENTNO          
          ,OTHERSETTLEMENTTYPE         
          ,Makerid              
          ,sum(isnull(highval,0)) highval 
,slip_no,ClientOutstanding ,ref_no  --, t.created_dt
from

(
 SELECT distinct  
          --@l_dpm_dpid                                DPID                         
          dpm_dpid                                DPID                         
          ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
          ,dptdc_slip_no                                     SLIPNO                         
          ,isnull(settm1.settm_desc,settm2.settm_desc)                               SETTLEMENT_TYPE                        
          ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
          ,dpam_sba_no                                      ACCOUNTNO                        
          ,dptdc_counter_dp_id                               TARGERDPID                         
          ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
          ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
          ,DPTDC_CM_ID                                       CMID                         
          ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
          ,DPM_EXCSM_ID                                         DEPOSITORY --@pa_id                                         DEPOSITORY                        
          ,dptdc_excm_id                                   EXCHANGEID                    
          ,dptdc_dtls_id                                     DTLSID                        
          ,dptdc_internal_trastm                             INTERNAL_CD                         
          ,'0'                                 DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk = isnull((select case when count(*) >= 1 then 'YES' else 'NO' end from dptdc_mak dptdm where dptdm.dptdc_slip_no = dptdc.dptdc_slip_no  and  dptdm.DPTDc_TRASTM_CD = dptdc.DPTDc_TRASTM_CD and dptdm.DPTDc_EXECUTION_DT =                      
 
           dptdc.DPTDc_EXECUTION_DT and (dptdc_deleted_ind = -1 or isnull(ltrim(rtrim(dptdc_mid_chk)),'') <> '' ) ),'NO')                        
          --,dptdc_isin                        
          ,case when dptdc_settlement_no = '' then '' else isnull(dptdc_other_settlement_no,'') end     OTHERSETTLEMENTNO          
          ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE         
          --,dptdc_created_by Makerid              
           ,dptdc_created_by  + ' ( ' + 
          LTRIM(RTRIM((SELECT TOP 1 REPLACE(ENTM_SHORT_NAME  ,'_' + ENTM_ENTTM_CD ,'') + '-' + ENTM_NAME1 FROM LOGIN_NAMES , ENTITY_MSTR 
			WHERE ENTM_ID = LOGN_ENT_ID  AND LOGN_DELETED_IND = 1 
			AND ENTM_DELETED_IND =1  AND LOGN_NAME = dptdc_created_by))) + ' )' as  Makerid
          ,highval = convert(numeric,((select top 1 CLOPM_CDSL_RT from closing_last_cdsl where  CLOPM_ISIN_CD = dptdc_isin and DPTDC_SLIP_NO like case when @pa_rmks = '' then '%' else @pa_rmks end) * abs(dptdc_qty)))
		,isnull(slip_no,'')   slip_no
		,ClientOutstanding=citrus_usr.Toget_OutsBal(dpam_sba_no),isnull(ref_no,'999999999') ref_no
--,created_dt
    FROM   --citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
          dp_mstr                      dpm   with(nolock)                                           
          ,dp_acct_mstr                 dpam   with(nolock)                                            
          ,exch_seg_mstr                excsm   with(nolock)                                          
          , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list 
          ,dptdc_mak                    dptdc   with(nolock)                            
left outer join maker_scancopy on slip_no = DPTDC_SLIP_NO and deleted_ind =1
           LEFT OUTER JOIN                          
           settlement_type_mstr          settm1   with(nolock)                                            
           on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )                    
           left outer join                          
           settlement_type_mstr          settm2 with(nolock)                                              
           on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)                            
    WHERE  dpam.dpam_id                  = dptdc.dptdc_dpam_id                        
    AND    dpm_excsm_id                  = excsm.excsm_id                      AND    excsm_list.excsm_id      = excsm.excsm_id                        
    AND    dpam.dpam_dpm_id              = dpm.dpm_id                        
    --AND    dptdc.dptdc_lst_upd_by        <> @pa_login_name    
    AND    case when dptdc.dptdc_mid_chk <> '' then dptdc.dptdc_mid_chk else dptdc.DPTDC_LST_UPD_BY end  <> @pa_login_name                
    and    DPTDC_CREATED_BY <> @pa_login_name    
	AND    case when dptdc.DPTDC_LST_UPD_BY <> '' then dptdc.DPTDC_LST_UPD_BY  end  <> @pa_login_name     	                   
    --AND    dpm_excsm_id                  = convert(int,@pa_cd)                        
    AND    dptdc_deleted_ind             in (0,4,6,-1)                        
    AND    dptdc_internal_trastm         in ('BOBO','BOCM','CMBO','CMCM','ID','EP','NP')                
    --AND    dptdc_internal_trastm            = @rowdelimiter      
    and    dptdc_slip_no like case when @pa_rmks = '' then '%' else @pa_rmks end         
    and    DPTDC_CREATED_BY like case when @pa_desc = '' then '%'  else @pa_desc end  
    and    dptdc_internal_trastm LIKE (case when LTRIM(RTRIM(@RowDelimiter)) = '' then '%' else LTRIM(RTRIM(@RowDelimiter)) end)               
    and   convert(varchar,DPTDC_REQUEST_DT,103)  = case when @pa_values = '' then convert(varchar,DPTDC_REQUEST_DT,103) else @pa_values end          
  --AND convert(datetime,convert(varchar(11),dptdc_execution_dt,109))    like case when @pa_values = '' then '%'  else @pa_values end                           
    and    isnull(dptdc_brokerbatch_no,'') = ''    and isnull(dptdc_res_cd,'') ='' 

--and  citrus_usr.fn_chk_app_level_cdsl (0,DPTDC_DTLS_ID,@pa_login_name,DPTDC_REQUEST_DT) = 'Y'                      
and (case when exists(select dptdc_created_by from dptdc_mak inn where inn.dptdc_dtls_id = dptdc.dptdc_dtls_id
and inn.dptdc_deleted_ind in(0,-1) and isnull(inn.dptdc_mid_chk,'') = '' and isnull(inn.dptdc_res_cd,'')='')           
and exists(select logn_name from login_names where logn_name = @pa_login_name and isnull(logn_level,'') = 1)  
then 'Y'
when exists(select dptdc_created_by from dptdc_mak inn where inn.dptdc_dtls_id = dptdc.dptdc_dtls_id       
and inn.dptdc_deleted_ind = 0 and isnull(inn.dptdc_mid_chk,'') <> '' and isnull(inn.dptdc_res_cd,'')='' )           
and exists(select logn_name from login_names where logn_name = @pa_login_name and isnull(logn_level,'') = 2)    
then 'Y' else 'N' end ) ='Y'
) t
group by DPID                         
          ,REQUESTDATE                         
          ,EXECUTIONDATE                        
          ,SLIPNO                         
          ,SETTLEMENT_TYPE                        
          , SETTLEMENTNO                        
          ,ACCOUNTNO                        
          ,TARGERDPID                         
          ,TARGERCMBPID                        
          ,TARGERACCOUNTNO                        
          ,CMID                         
          ,CASH                                            
          ,DEPOSITORY                        
          ,EXCHANGEID                    
          ,DTLSID                        
          ,INTERNAL_CD                         
          ,DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk  
          --,dptdc_isin                        
          ,    OTHERSETTLEMENTNO          
          ,OTHERSETTLEMENTTYPE         
          ,Makerid ,slip_no  ,ClientOutstanding,ref_no --, t.created_dt
order by ref_no --t.created_dt,
--slip_no desc


END
ELSE 
BEGIN -- AS IT IS 
print 'latesh'
SELECT 
distinct DPID                         
          ,REQUESTDATE                         
          ,EXECUTIONDATE                        
          ,SLIPNO                         
          ,SETTLEMENT_TYPE                        
          , SETTLEMENTNO                        
          ,ACCOUNTNO                        
          ,TARGERDPID                         
          ,TARGERCMBPID                        
          ,TARGERACCOUNTNO                        
          ,CMID                         
          ,CASH                                            
          ,DEPOSITORY                        
          ,EXCHANGEID                    
          ,DTLSID                        
          ,INTERNAL_CD                         
          ,DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk  
          --,dptdc_isin                        
          ,    OTHERSETTLEMENTNO          
          ,OTHERSETTLEMENTTYPE         
          ,Makerid              
          ,sum(isnull(highval,0)) highval 
,slip_no,ClientOutstanding,ref_no
from

(
 SELECT distinct  dpm_dpid                                DPID                         
          ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
          ,dptdc_slip_no                                     SLIPNO                         
          ,isnull(settm1.settm_desc,settm2.settm_desc)                                 SETTLEMENT_TYPE                        
          ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
          ,dpam_sba_no                                      ACCOUNTNO                        
          ,dptdc_counter_dp_id                               TARGERDPID                         
          ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
          ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
          ,DPTDC_CM_ID                                       CMID                         
          ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
          ,@pa_id                                         DEPOSITORY                        
          ,dptdc_excm_id                                   EXCHANGEID                    
          ,dptdc_dtls_id                                     DTLSID                        
          ,dptdc_internal_trastm                             INTERNAL_CD                         
          ,'0'                                 DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk = isnull((select case when count(*) >= 1 then 'YES' else 'NO' end from dptdc_mak dptdm where dptdm.dptdc_slip_no = dptdc.dptdc_slip_no  and  dptdm.DPTDc_TRASTM_CD = dptdc.DPTDc_TRASTM_CD and dptdm.DPTDc_EXECUTION_DT =                      
 
           dptdc.DPTDc_EXECUTION_DT and (dptdc_deleted_ind = -1 or isnull(ltrim(rtrim(dptdc_mid_chk)),'') <> '' ) ),'NO')                        
          --,dptdc_isin                        
          ,case when dptdc_settlement_no = '' then '' else isnull(dptdc_other_settlement_no,'') end     OTHERSETTLEMENTNO          
          ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE         
          --,dptdc_created_by Makerid              
          ,dptdc_created_by  + ' ( ' + 
          LTRIM(RTRIM((SELECT TOP 1 REPLACE(ENTM_SHORT_NAME  ,'_' + ENTM_ENTTM_CD ,'') + '-' + ENTM_NAME1 FROM LOGIN_NAMES , ENTITY_MSTR 
			WHERE ENTM_ID = LOGN_ENT_ID  AND LOGN_DELETED_IND = 1 
			AND ENTM_DELETED_IND =1  AND LOGN_NAME = dptdc_created_by))) + ' )' as  Makerid
          ,highval = convert(numeric,((select top 1 CLOPM_CDSL_RT from closing_last_cdsl where  CLOPM_ISIN_CD = dptdc_isin and DPTDC_SLIP_NO like case when @pa_rmks = '' then '%' else @pa_rmks end) * abs(dptdc_qty)))         
		,isnull(slip_no,'')   slip_no
		,ClientOutstanding=citrus_usr.Toget_OutsBal(dpam_sba_no),isnull(ref_no,'999999999') ref_no
    FROM  -- citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
          dp_mstr                      dpm   with(nolock)                                           
          ,dp_acct_mstr                 dpam      with(nolock)                                         
          ,exch_seg_mstr                excsm     with(nolock)                                        
          , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list  
          ,dptdc_mak                    dptdc       with(nolock)                        
left outer join maker_scancopy on slip_no = DPTDC_SLIP_NO  and deleted_ind =1
           LEFT OUTER JOIN                          
           settlement_type_mstr          settm1    with(nolock)                                           
           on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )                    
           left outer join                          
           settlement_type_mstr          settm2     with(nolock)                                          
           on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)                            
    WHERE  dpam.dpam_id                  = dptdc.dptdc_dpam_id    AND DPAM.dpam_sba_no=dptdc.dptdc_created_by  and dptdc.DPTDC_SLIP_NO like 'e%'                
    AND    dpm_excsm_id                  = excsm.excsm_id                     
AND    excsm_list.excsm_id      = excsm.excsm_id                        
    AND    dpam.dpam_dpm_id              = dpm.dpm_id                        
    AND    dptdc.dptdc_lst_upd_by        <> @pa_login_name    
    AND    case when dptdc.dptdc_mid_chk <> '' then dptdc.dptdc_mid_chk else dptdc.DPTDC_LST_UPD_BY end  <> @pa_login_name     
    and    DPTDC_CREATED_BY <> @pa_login_name               
	AND    case when dptdc.DPTDC_LST_UPD_BY <> '' then dptdc.DPTDC_LST_UPD_BY  end  <> @pa_login_name                         
    --AND    dpm_excsm_id                  = convert(int,@pa_cd)                        
    AND    dptdc_deleted_ind             in (0,4,6,-1)                        
    AND    dptdc_internal_trastm         in ('BOBO','BOCM','CMBO','CMCM','ID','EP','NP')                
    --AND    dptdc_internal_trastm            = @rowdelimiter      
    --and    dptdc_slip_no like case when @pa_rmks = '' then '%' else @pa_rmks end         
    and    DPTDC_CREATED_BY like case when @pa_desc = '' then '%'  else @pa_desc end  
    and    dptdc_internal_trastm LIKE (case when LTRIM(RTRIM(@RowDelimiter)) = '' then '%' else LTRIM(RTRIM(@RowDelimiter)) end)               
    and   convert(varchar,DPTDC_REQUEST_DT,103)  = case when @pa_values = '' then convert(varchar,DPTDC_REQUEST_DT,103) else @pa_values end          
  --AND convert(datetime,convert(varchar(11),dptdc_execution_dt,109))    like case when @pa_values = '' then '%'  else @pa_values end                           
    and    isnull(dptdc_brokerbatch_no,'') = ''   and isnull(dptdc_res_cd,'') =''   
--and  citrus_usr.fn_chk_app_level_cdsl (0,DPTDC_DTLS_ID,@pa_login_name,DPTDC_REQUEST_DT) = 'Y'                     
and (case when exists(select dptdc_created_by from dptdc_mak inn where inn.dptdc_dtls_id = dptdc.dptdc_dtls_id
and inn.dptdc_deleted_ind in(0,-1) and isnull(inn.dptdc_mid_chk,'') = '' and isnull(inn.dptdc_res_cd,'')='')           
and exists(select logn_name from login_names where logn_name = @pa_login_name and isnull(logn_level,'') = 1)  
then 'Y'
when exists(select dptdc_created_by from dptdc_mak inn where inn.dptdc_dtls_id = dptdc.dptdc_dtls_id       
and inn.dptdc_deleted_ind = 0 and isnull(inn.dptdc_mid_chk,'') <> '' and isnull(inn.dptdc_res_cd,'')='' )           
and exists(select logn_name from login_names where logn_name = @pa_login_name and isnull(logn_level,'') = 2)    
then 'Y' else 'N' end ) ='Y'
) t
group by DPID                         
          ,REQUESTDATE                         
          ,EXECUTIONDATE                        
          ,SLIPNO                         
          ,SETTLEMENT_TYPE                        
          , SETTLEMENTNO                        
          ,ACCOUNTNO                        
          ,TARGERDPID                         
          ,TARGERCMBPID                        
          ,TARGERACCOUNTNO                        
          ,CMID                         
          ,CASH                                            
          ,DEPOSITORY                        
          ,EXCHANGEID                    
          ,DTLSID                        
          ,INTERNAL_CD                         
          ,DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk  
          --,dptdc_isin                        
          ,    OTHERSETTLEMENTNO          
          ,OTHERSETTLEMENTTYPE         
          ,Makerid ,slip_no  ,ClientOutstanding,ref_no
order by ref_no --slip_no desc

END -- ALL

END

  --                        
  END 

end

GO
