-- Object: FUNCTION citrus_usr.fn_merge_str
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_merge_str](@pa_tab varchar(50),@pa_id numeric,@pa_yn VARCHAR(50))        
RETURNS VARCHAR(8000)         
AS        
BEGIN        
  declare @res varchar(8000)    
      
  set @res =''    
        
  IF @pa_tab  = 'cc_mstr'      
  BEGIN      
  --      
    IF NOT EXISTS(SELECT ccm_id FROM CC_MSTR WHERE ccm_id = @pa_id AND ccm_deleted_ind = 1)        
    BEGIN      
    --      
    IF @pa_yn <>  'id'      
    BEGIN      
          select   @res = coalesce(@res + ',', '') +  EXCM_CD    
        FROM CCM_MAK,EXCH_SEG_MSTR,EXCHANGE_MSTR WHERE EXCM_CD = EXCSM_EXCH_CD         
              AND CITRUS_USR.FN_GET_ACCESS(EXCSM_DESC,@pa_id) > 0        
               AND  ccm_deleted_ind = 0      
        group by EXCM_CD    
    END    
    ELSE    
    BEGIN    
          select   @res = coalesce(@res + ',', '') +  CONVERT(VARCHAR,EXCM_ID)    
        FROM CCM_MAK,EXCH_SEG_MSTR,EXCHANGE_MSTR WHERE EXCM_CD = EXCSM_EXCH_CD         
              AND CITRUS_USR.FN_GET_ACCESS(EXCSM_DESC,@pa_id) > 0        
               AND  ccm_deleted_ind = 0      
        group by EXCM_ID    
    END    
    --      
    END      
    ELSE      
    BEGIN      
    --      
      IF @pa_yn <>  'id'      
    BEGIN     
          select   @res = coalesce(@res + ',', '') +  EXCM_CD    
        FROM CC_MSTR,EXCH_SEG_MSTR,EXCHANGE_MSTR WHERE EXCM_CD = EXCSM_EXCH_CD         
        AND CITRUS_USR.FN_GET_ACCESS(EXCSM_DESC,@pa_id) > 0        
        AND  ccm_deleted_ind = 1     
        group by EXCM_CD    
    END    
    ELSE    
    BEGIN    
          select   @res = coalesce(@res + ',', '') +  CONVERT(VARCHAR,EXCM_ID)    
        FROM CC_MSTR,EXCH_SEG_MSTR,EXCHANGE_MSTR WHERE EXCM_CD = EXCSM_EXCH_CD         
        AND CITRUS_USR.FN_GET_ACCESS(EXCSM_DESC,@pa_id) > 0        
        AND  ccm_deleted_ind = 1     
        group by EXCM_ID    
    
    END    
    
    --      
    END      
  --      
  END      
  ELSE IF @pa_tab = 'charge_subcm'    
    BEGIN    
    --    
      IF NOT EXISTS(SELECT chacm_cham_id FROM charge_ctgry_mapping WHERE chacm_cham_id = @pa_id AND chacm_deleted_ind  = 1)      
      BEGIN    
      --    
         
          select   @res = coalesce(@res + ',', '') +  CONVERT(VARCHAR,chacm_subcm_cd)  
          FROM chacm_mak where chacm_cham_id = @pa_id      
          AND    chacm_deleted_ind = 0   
          group by chacm_subcm_cd  
      
      --    
      END    
      ELSE    
      BEGIN    
      --    
    
    
       
          select   @res = coalesce(@res + ',', '') +  chacm_subcm_cd  
          FROM charge_ctgry_mapping where chacm_cham_id = @pa_id      
          AND    chacm_deleted_ind = 1   
          group by chacm_subcm_cd   
        
      --    
      END    
          
    --    
  END    
  ELSE IF @pa_tab = 'DP50'      
  BEGIN      
  --      
    IF @pa_yn <>  'id'      
    BEGIN      
        select   @res = coalesce(@res + ',', '') +  CONVERT(VARCHAR,tmpeod_boid)    
        FROM tmp_cdsl_trx_mstr WHERE ISNULL(tmpeod_dpam_id,0) = 0     
        group by tmpeod_boid    
    END    
    ELSE    
    BEGIN    
        select   @res = coalesce(@res + ',', '') +  tmpeod_isin    
        FROM tmp_cdsl_trx_mstr WHERE ISNULL(tmpeod_dpam_id,0) = 0     
        group by tmpeod_isin    
    END    
    
    
    
  --      
  END      
  ELSE IF @pa_tab = 'DP50_MUL_DT'      
   BEGIN      
   --      
       select   @res = coalesce(@res + ',', '') +  convert(varchar(11),tmpeod_busn_dt,109)    
       from tmp_cdsl_trx_mstr     
       group by convert(datetime,tmpeod_busn_dt,109)    
              order by tmpeod_busn_dt    
           
   --      
  END      
  ELSE IF @pa_tab = 'JV_ACPARTY_VOCUCHERS'      --AUTO CREDIT JV VOUCHERS
   BEGIN      
        select   @res = coalesce(@res + ',', '') +  CONVERT(VARCHAR,tmpbill_acct_no)    
        FROM tmp_billimp_mstr WHERE ISNULL(tmpbill_dpam_id,0) = 0 AND TMPBILL_CREDIT <> 0    
        group by tmpbill_acct_no    
   --      
  END     
  ELSE IF @pa_tab = 'REC_ACPARTY_VOCUCHERS'      --AUTO CREDIT JV VOUCHERS
   BEGIN      
        select   @res = coalesce(@res + ',', '') +  CONVERT(VARCHAR,TMPREC_ACCT_NO)    
        FROM TMP_RECIEPT_MSTR WHERE ISNULL(TMPREC_DPAM_ID,0) = 0 AND TMPREC_CREDIT <> 0    
        group by TMPREC_ACCT_NO    
   --      
  END  
  ELSE IF @pa_tab = 'REC_ACGLBANK_VOCUCHERS'      --AUTO CREDIT JV VOUCHERS
   BEGIN      
        select   @res = coalesce(@res + ',', '') +  CONVERT(VARCHAR,TMPREC_BANKGLCODE)    
        FROM TMP_RECIEPT_MSTR WHERE ISNULL(TMPREC_BANKGLID,0) = 0 AND TMPREC_CREDIT <> 0    
        group by TMPREC_BANKGLCODE    
   --      
  END  
  ELSE IF @pa_tab = 'CDSL_IMP_NP'      
   BEGIN      
   --      
       select   @res = coalesce(@res + ',', '') +  uses_slip_no    
       FROM     used_slip    
               ,TMP_DP_NP_DTLS_CDSL     
       where isnull(USES_SERIES_TYPE,'')+isnull(uses_slip_no,'') = TMPNP_SLIP_NO     
       and   uses_deleted_ind = 1    
    
   --      
  END      
 ELSE IF @pa_tab = 'CDSL_IMP_EP'      
  BEGIN      
  --      
      select  @res = coalesce(@res + ',', '') +  uses_slip_no    
      FROM     used_slip    
              ,TMP_DP_EP_DTLS_CDSL     
      where isnull(USES_SERIES_TYPE,'')+isnull(uses_slip_no,'') = TMPEP_SLIP_NO     
      and   uses_deleted_ind = 1    
    
  --      
  END      
  ELSE IF @pa_tab = 'CDSL_IMP_INTDP'      
  BEGIN      
  --      
      select   @res = coalesce(@res + ',', '') +  uses_slip_no    
      FROM     used_slip    
              ,tmp_dp_intdp_dtls_cdsl     
      where isnull(USES_SERIES_TYPE,'')+isnull(uses_slip_no,'') = tmpintdp_slip_no     
      and   uses_deleted_ind = 1    
          
  --      
  END      
  ELSE IF @pa_tab = 'CDSL_IMP_OFFM'      
  BEGIN      
  --      
      select   @res = coalesce(@res + ',', '') +  uses_slip_no    
      FROM     used_slip    
              ,tmp_dp_offm_dtls_cdsl     
      where isnull(USES_SERIES_TYPE,'')+isnull(uses_slip_no,'') = tmpoffm_slip_no     
      and   uses_deleted_ind = 1    
    
  --      
  END      
  ELSE IF @pa_tab = 'NSDL_CMBP'      
  BEGIN      
  --      
     select   distinct @res =  coalesce(@res + ',', '') +    convert(varchar,TMPDPTD_SLIP_NO )    
     FROM    TMP_DP_TRX_DTLS     
            ,dp_acct_mstr     
     where  dpam_sba_no = TMPDPTD_ACCT_ID    
     and    isnull(citrus_usr.fn_acct_entp(dpam_id,'CMBP_ID'),'') <> ''    
     and    not exists (select sliim_id from slip_issue_mstr 
                        where sliim_dpam_acct_no = TMPDPTD_ACCT_ID 
                        and   TMPDPTD_SLIP_NO like ltrim(rtrim(SLIIM_SERIES_TYPE)) +'%'
                        and convert(bigint,replace(TMPDPTD_SLIP_NO,ltrim(rtrim(SLIIM_SERIES_TYPE)),''))  between convert(bigint,SLIIM_SLIP_NO_FR) and  convert(bigint,SLIIM_SLIP_NO_TO))  
                        and TMPDPTD_SLIP_NO not like 'poa%' 
    
  --      
  END      
  ELSE IF @pa_tab = 'NSDL_IMP'      
   BEGIN      
   --      
       select   distinct @res = coalesce(@res + ',', '') +  uses_slip_no    
       FROM     USED_SLIP    
               ,TMP_DP_TRX_DTLS     
       where isnull(USES_SERIES_TYPE,'')+isnull(uses_slip_no,'') = TMPDPTD_SLIP_NO     
       and   uses_deleted_ind = 1    
    
   --      
  END    
  
  ELSE IF @pa_tab = 'NSDL_SLIP_LEN'      
   BEGIN      
   --      
       select   distinct @res = coalesce(@res + ',', '') +  uses_slip_no    
       FROM     USED_SLIP    
               ,TMP_DP_TRX_DTLS     
       where isnull(USES_SERIES_TYPE,'')+isnull(uses_slip_no,'') = TMPDPTD_SLIP_NO     
       and   uses_deleted_ind = 1      
   --      
  END      
  ELSE IF @pa_tab = 'CDSL_CMBP_INTDP'      
  BEGIN      
  --      
     select   distinct @res =  coalesce(@res + ',', '') +    convert(varchar,tmpintdp_acct_id )    
     FROM    tmp_dp_intdp_dtls_cdsl     
            ,dp_acct_mstr    
     where  dpam_sba_no = tmpintdp_acct_id    
     and    isnull(citrus_usr.fn_acct_entp(dpam_id,'CMBP_ID'),'') <> ''    
     and    not exists (select sliim_id from slip_issue_mstr where sliim_dpam_acct_no = tmpintdp_acct_id)    
    
  --      
  END      
    ELSE IF @pa_tab = 'CDSL_CMBP_OFFM'      
    BEGIN      
    --      
         select   distinct @res =  coalesce(@res + ',', '') +    convert(varchar,tmpoffm_acct_id )    
            FROM    tmp_dp_offm_dtls_cdsl     
                   ,dp_acct_mstr    
            where  dpam_sba_no = tmpoffm_acct_id    
            and    isnull(citrus_usr.fn_acct_entp(dpam_id,'CMBP_ID'),'') <> ''    
     and    not exists (select sliim_id from slip_issue_mstr where sliim_dpam_acct_no = tmpoffm_acct_id)    
      
    --      
    END      
     ELSE IF @pa_tab = 'CDSL_CMBP_EP'      
        BEGIN      
        --      
             select   distinct @res =  coalesce(@res + ',', '') +    convert(varchar,TMPEP_ACCT_ID )    
                FROM    TMP_DP_EP_DTLS_CDSL     
                       ,dp_acct_mstr    
                where  dpam_sba_no = TMPEP_ACCT_ID    
                and    isnull(citrus_usr.fn_acct_entp(dpam_id,'CMBP_ID'),'') <> ''    
         and    not exists (select sliim_id from slip_issue_mstr where sliim_dpam_acct_no = TMPEP_ACCT_ID)    
          
        --      
    END      
     ELSE IF @pa_tab = 'CDSL_CMBP_NP'      
        BEGIN      
        --      
             select   distinct @res =  coalesce(@res + ',', '') +    convert(varchar,TMPNP_ACCT_ID )    
                FROM    TMP_DP_NP_DTLS_CDSL     
                       ,dp_acct_mstr    
                where  dpam_sba_no = TMPNP_ACCT_ID    
                and    isnull(citrus_usr.fn_acct_entp(dpam_id,'CMBP_ID'),'') <> ''    
         and    not exists (select sliim_id from slip_issue_mstr where sliim_dpam_acct_no = TMPNP_ACCT_ID)    
          
        --      
    END      
  ELSE IF @pa_tab = 'NSDL_ACCT'      
   BEGIN     
   --      
       select   distinct @res =  coalesce(@res + ',', '') +    convert(varchar,TMPDPTD_ACCT_ID )    
       FROM    TMP_DP_TRX_DTLS     
       where   TMPDPTD_BO_ID not in (select dpam_sba_no from dp_acct_mstr  where   dpam_deleted_ind = 1)    
    
   --      
  END      
ELSE IF @pa_tab = 'NSDL_ISIN'      
   BEGIN     
   --      
       select   distinct @res =  coalesce(@res + ',', '') +    convert(varchar,TMPDPTD_ISIN )    
       FROM    TMP_DP_TRX_DTLS     
       where   TMPDPTD_ISIN not in (select ISIN_CD from ISIN_MSTR  where   ISIN_deleted_ind = 1 AND ISIN_BIT in (0,1) )    
    
   --      
  END      
      
  ELSE IF @pa_tab = 'CDSL_ACCT_INTDP'      
  BEGIN      
  --      
      select  distinct  @res =  coalesce(@res + ',', '') +    convert(varchar,tmpintdp_acct_id )    
      FROM    tmp_dp_intdp_dtls_cdsl     
      where   tmpintdp_BO_id not in (select dpam_sba_no from dp_acct_mstr  where   dpam_deleted_ind = 1)    
    
  --      
  END      
  ELSE IF @pa_tab = 'CDSL_ISIN_INTDP'      
  BEGIN      
  --      
      select  distinct  @res =  coalesce(@res + ',', '') +    convert(varchar,TMPINTDP_ISIN )    
      FROM    tmp_dp_intdp_dtls_cdsl     
      where   TMPINTDP_ISIN not in (select ISIN_CD from ISIN_MSTR  where   ISIN_DELETED_IND = 1 AND ISIN_BIT in (0,2))    
    
  --      
  END      
  ELSE IF @pa_tab = 'CDSL_ACCT_OFFM'      
  BEGIN      
  --      
            
      select   distinct @res =  coalesce(@res + ',', '') +   convert(varchar,tmpoffm_acct_id)     
      FROM    tmp_dp_offm_dtls_cdsl     
      where   tmpoffm_BO_id not in (select dpam_sba_no from dp_acct_mstr  where   dpam_deleted_ind = 1)    
  --      
  END      
  ELSE IF @pa_tab = 'CDSL_ISIN_OFFM'      
  BEGIN      
  --      
            
      select   distinct @res =  coalesce(@res + ',', '') +   convert(varchar,TMPOFFM_ISIN)     
      FROM    tmp_dp_offm_dtls_cdsl     
      where   TMPOFFM_ISIN not in (select ISIN_CD from ISIN_MSTR  where   ISIN_deleted_ind = 1 AND ISIN_BIT in (0,2))    
  --      
  END       
 ELSE IF @pa_tab = 'CDSL_ACCT_EP'      
  BEGIN      
  --      
             
      select  distinct  @res =  coalesce(@res + ',', '') +   convert(varchar,TMPEP_ACCT_ID )    
            FROM    TMP_DP_EP_DTLS_CDSL     
      where   TMPEP_BO_ID not in (select dpam_sba_no from dp_acct_mstr  where   dpam_deleted_ind = 1)    
    
  --      
  END      
ELSE IF @pa_tab = 'CDSL_ISIN_EP'      
  BEGIN      
  --      
             
      select  distinct  @res =  coalesce(@res + ',', '') +   convert(varchar,TMPEP_ISIN )    
            FROM    TMP_DP_EP_DTLS_CDSL     
      where   TMPEP_ISIN not in (select ISIN_CD from ISIN_MSTR  where   ISIN_deleted_ind = 1 AND ISIN_BIT in (0,2))     
    
  --      
  END      
    
 ELSE IF @pa_tab = 'CDSL_ACCT_NP'      
  BEGIN      
  --      
     select  distinct  @res =  coalesce(@res + ',', '') +   convert(varchar, TMPNP_ACCT_ID )    
     FROM    TMP_DP_NP_DTLS_CDSL     
     where   TMPNP_BO_ID not in (select dpam_sba_no from dp_acct_mstr  where   dpam_deleted_ind = 1)    
  --      
  END      
 ELSE IF @pa_tab = 'CDSL_ISIN_NP'      
  BEGIN      
  --      
     select  distinct  @res =  coalesce(@res + ',', '') +   convert(varchar, TMPNP_ISIN )    
     FROM    TMP_DP_NP_DTLS_CDSL     
     where   TMPNP_ISIN not in (select ISIN_CD from ISIN_MSTR  where   ISIN_deleted_ind = 1 AND ISIN_BIT in (0,2))    
  --      
  END      
    
  ELSE IF @pa_tab = 'DPC9_MUL_DT'      
  BEGIN      
  --      
       select   @res = coalesce(@res + ',', '') +  convert(varchar(11),tmpdpc9_hldg_trx_dt,109)    
       from tmp_dpc9_cdsl_trx_hldg     
       group by convert(datetime,tmpdpc9_hldg_trx_dt,109)    
       order by tmpdpc9_hldg_trx_dt    
           
    
  --      
  END     
  ELSE IF @pa_tab = 'SOT'      
  BEGIN      
  --      
       select   @res = coalesce(@res + ',', '') +  convert(varchar(16),tmpsot_ben_acctno)    
       from tmp_sot_mstr     
       where  isnull(tmpsot_dpam_id,0) = 0     
       group by convert(varchar(16),tmpsot_ben_acctno)    
           
    
    
  --      
  END      
  ELSE IF @pa_tab = 'DPC9'      
  BEGIN      
  --      
       select   @res = coalesce(@res + ',', '') +  convert(varchar(16),tmpdpc9_boid)    
       from tmp_dpc9_cdsl_trx_mstr     
       where  isnull(tmpdpc9_dpam_id,0) = 0     
       group by convert(varchar(16),tmpdpc9_boid)    
  --      
  END   
  ELSE IF @pa_tab = 'DPC7'      
  BEGIN      
  --      
       select   @res = coalesce(@res + ',', '') +  TMPDPC7_BOID
       from tmp_dpc7_cdsl_trx_mstr     
       where  isnull(TMPDPC7_ACCT_ID,0) = 0     
group by TMPDPC7_BOID
       --group by convert(varchar(16),TMPDPC7_BOID)    
  --      
  END      
  ELSE IF @pa_tab = 'SOH'      
  BEGIN      
  --      
       select   @res = coalesce(@res + ',', '') +  tmpsoh_benf_acct_no    
       from tmp_soh_mstr     
       where  not exists (select dpam_id from dp_Acct_mstr where dpam_sba_no = tmpsoh_benf_acct_no and dpam_deleted_ind = 1)    
       group by tmpsoh_benf_acct_no    
  --      
  END         
  ELSE IF @pa_tab = 'settm_type_cdsl'    
  BEGIN      
  --      
      if @pa_yn <> ''    
      SELECT @res=CONVERT(VARCHAR,SETTM_ID )    
      FROM SETTLEMENT_TYPE_MSTR     
      WHERE SETTM_TYPE_CDSL = @pa_yn     
          
  --      
  END     
   ELSE IF @pa_tab = 'settm_type_NSDL'    
  BEGIN      
  --      
      if @pa_yn <> ''    
      SELECT @res=CONVERT(VARCHAR,SETTM_ID )    
      FROM SETTLEMENT_TYPE_MSTR     
      WHERE SETTM_TYPE = case when @pa_yn = '16' then '05' else @pa_yn end  
      and   SETTM_EXCM_ID in (3,4)    
      and   settm_deleted_ind = 1
          
  --      
  END         
  ELSE IF @pa_tab = 'ID_DP49'    
  BEGIN      
  --      
       select   @res = coalesce(@res + ',', '') +  convert(varchar(16),tmpids_boid)    
       from tmp_id_summary     
       where  isnull(TMPIDS_DPAM_ID,0) = 0     
       group by convert(varchar(16),tmpids_boid)    
  --      
  END       
  ELSE IF @pa_tab = 'OFFSM_DP83'    
  BEGIN      
  --      
       select   @res = coalesce(@res + ',', '') +  convert(varchar(16),tmpoffx_bo_id)    
       from TMP_OFFMKT_TRXFER     
       where  isnull(TMPoffx_DPAM_ID,0) = 0     
       group by convert(varchar(16),tmpoffx_bo_id)    
  --      
  END         
  ELSE IF @pa_tab = 'DMTS_DP24'    
  BEGIN      
  --      
       select   @res = coalesce(@res + ',', '') +  convert(varchar(16),tmpds_bo_id)    
       from TMP_DMT_SUMMARY     
       where  isnull(TMPds_DPAM_ID,0) = 0     
       group by convert(varchar(16),tmpds_bo_id)    
  --      
  END           
  ELSE IF @pa_tab = 'RMTS_DP27'    
  BEGIN      
  --      
       select   @res = coalesce(@res + ',', '') +  convert(varchar(16),tmprs_bo_id)    
       from TMP_RMT_SUMMARY     
       where  isnull(TMPRS_DPAM_ID,0) = 0     
       group by convert(varchar(16),tmprs_bo_id)    
  --      
  END       
         
  RETURN (@res)      
        
--        
END

GO
