-- Object: PROCEDURE citrus_usr.pr_dp_select_mstr_validclient
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE  [citrus_usr].[pr_dp_select_mstr_validclient]( @pa_id  VARCHAR(800)                          
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

     
      

--select * from temptable_1010201422
--
--return 
       
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

        
   set dateformat dmy             
                             
  IF @pa_action = 'Valid_client'                        
  BEGIN                        
  --                        
             
      if @pa_rmks = 'A'                        
      BEGIN                        
      --            
    print 'rre'
        SELECT ltrim(rtrim(isnull(C.CLIM_NAME1,'')))  + ' ' + ltrim(rtrim(isnull(C.CLIM_NAME2,''))) + ' ' +ltrim(rtrim(isnull(C.CLIM_NAME3,''))) CLIM_NAME1                        
              ,ltrim(rtrim(isnull(d.DPHD_SH_FNAME,'')))  + ' ' + ltrim(rtrim(isnull(d.DPHD_SH_mNAME,''))) + ' ' +ltrim(rtrim(isnull(d.DPHD_sH_lNAME,''))) DPHD_SH_FNAME                        
              ,ltrim(rtrim(isnull(d.DPHD_tH_FNAME,'')))  + ' ' + ltrim(rtrim(isnull(d.DPHD_tH_mNAME,''))) + ' ' +ltrim(rtrim(isnull(d.DPHD_tH_lNAME,''))) DPHD_TH_FNAME                        
              ,A.DPAM_SBA_NO                          
              ,CASE  WHEN isnull(citrus_usr.fn_acct_entp(a.dpam_id,'CMBP_ID'),'') = '' THEN 'I' ELSE 'P'END  ACCT_TYPE                           
        FROM   CLIENT_MSTR C                         
              ,(SELECT DISTINCT dpam_crn_no,dpam_id , dpam_sba_no,dpam_stam_cd                        
                FROM   entity_mstr           entm                        
                    ,entity_relationship   entr                        
                      ,exch_seg_mstr         excsm                        
                      ,excsm_prod_mstr       excpm                            
                      ,dp_acct_mstr                        
                      ,login_names                        
                WHERE (entm_id = entr_ho                                   
                       OR entm_id = entr_re                                   
                       OR entm_id = entr_ar                                  
                       OR entm_id = entr_br                                  
                       OR entm_id = entr_sb                                  
                       OR entm_id = entr_dl                                  
                       OR entm_id = entr_rm                                  
                       OR entm_id = entr_dummy1                                  
                       OR entm_id = entr_dummy2                                  
                       OR entm_id = entr_dummy3                                  
                       OR entm_id = entr_dummy4                                  
                       OR entm_id = entr_dummy5                                  
                       OR entm_id = entr_dummy6                            
                       OR entm_id = entr_dummy7                                  
                       OR entm_id = entr_dummy8                                  
                       OR entm_id = entr_dummy9                                  
                       OR entm_id = entr_dummy10)                                  
               AND entr_crn_no   = dpam_crn_no                        
                --AND entm_id = logn_enttm_id                        
                AND (logn_name = @pa_login_name or    logn_name = right(@pa_login_name,8) )                    
                AND dpam_sba_no   = @pa_cd                         
                AND entr.entr_excpm_id = excpm.excpm_id                        
  AND excpm.excpm_excsm_id = excsm.excsm_id                        
                AND excsm.excsm_exch_cd IN ('CDSL','NSDL')                        
                and dpam_dpm_id  = @l_dpm_dpid) A                          
               LEFT OUTER JOIN                         
               DP_HOLDER_DTLS D ON  A.DPAM_ID = D.DPHD_DPAM_ID     AND    isnull(d.dphd_deleted_ind,1) = 1                      
        WHERE  C.CLIM_CRN_NO = A.DPAM_CRN_NO                        
        AND    A.DPAM_SBA_NO =@pa_cd                         
        AND    c.clim_deleted_ind = 1                        
                               
        AND    a.dpam_stam_cd = @l_stam_cd                        
          
       --                        
       END                        
       ELSE IF @pa_rmks = 'I'                        
       BEGIN                        
       --                        
          select ltrim(rtrim(isnull(C.CLIM_NAME1,'')))  + ' ' + ltrim(rtrim(isnull(C.CLIM_NAME2,''))) + ' ' +ltrim(rtrim(isnull(C.CLIM_NAME3,''))) CLIM_NAME1                       
           ,ltrim(rtrim(isnull(d.DPHD_SH_FNAME,'')))  + ' ' + ltrim(rtrim(isnull(d.DPHD_SH_mNAME,''))) + ' ' +ltrim(rtrim(isnull(d.DPHD_sH_lNAME,''))) DPHD_SH_FNAME                        
              ,ltrim(rtrim(isnull(d.DPHD_tH_FNAME,'')))  + ' ' + ltrim(rtrim(isnull(d.DPHD_tH_mNAME,''))) + ' ' +ltrim(rtrim(isnull(d.DPHD_tH_lNAME,'') )) DPHD_TH_FNAME                        
                                
          ,DPAM_SBA_NO + @coldelimiter + @pa_rmks DPAM_ACCT_NO                        
    FROM   client_mstr C                        
          ,(SELECT dpam_crn_no,dpam_id , dpam_sba_no,dpam_stam_cd                        
          FROM   entity_mstr           entm                        
          ,entity_relationship   entr                        
          ,exch_seg_mstr         excsm                        
          ,excsm_prod_mstr       excpm                            
          ,dp_acct_mstr                         
          ,login_names                        
          WHERE (entm_id = entr_ho                                   
          OR entm_id = entr_re                                   
          OR entm_id = entr_ar                                  
          OR entm_id = entr_br                              
          OR entm_id = entr_sb                                  
          OR entm_id = entr_dl                         
          OR entm_id = entr_rm                                  
          OR entm_id = entr_dummy1                                  
          OR entm_id = entr_dummy2                                  
          OR entm_id = entr_dummy3                                  
          OR entm_id = entr_dummy4                                  
          OR entm_id = entr_dummy5                                  
          OR entm_id = entr_dummy6                                  
          OR entm_id = entr_dummy7                                  
          OR entm_id = entr_dummy8                                  
          OR entm_id = entr_dummy9                                  
          OR entm_id = entr_dummy10)                                  
          AND entr_crn_no   = dpam_crn_no                        
          AND entm_id = logn_ent_id                        
          AND logn_name = @pa_login_name                        
          AND dpam_sba_no   = @pa_cd                         
          AND entr.entr_excpm_id = excpm.excpm_id                        
          AND excpm.excpm_excsm_id = excsm.excsm_id                        
          AND excsm.excsm_exch_cd IN ('CDSL','NSDL')                        
          and dpam_dpm_id  = @l_dpm_dpid) dpam                        
          left outer join                                                  
          DP_HOLDER_DTLS D  on dpam.DPAM_ID = D.DPHD_DPAM_ID                        
          left outer join                           
          account_properties accp on dpam.DPAM_ID = accp.accp_clisba_id and accp.accp_accpm_prop_cd = 'CMBP_iD'                          
          WHERE C.CLIM_CRN_NO = dpam.DPAM_CRN_NO                          
          AND   dpam.DPAM_SBA_NO =@pa_cd                        
          AND   isnull(accp.accp_value,'') = ''                         
          and   dpam.dpam_stam_cd = @l_stam_cd                        
         /*SELECT details.CLIM_NAME1                        
                        ,details.DPHD_SH_FNAME                        
                        ,details.DPHD_TH_FNAME                         
                        ,details.DPAM_SBA_NO + @coldelimiter + @pa_rmks DPAM_ACCT_NO                        
         FROM   (select hd.CLIM_CRN_NO                        
                       ,ISNULL(hd.CLIM_NAME1,'')    CLIM_NAME1                        
                       ,ISNULL(hd.DPHD_SH_FNAME,'') DPHD_SH_FNAME                        
                       ,ISNULL(hd.DPHD_TH_FNAME,'') DPHD_TH_FNAME                        
                       ,ISNULL(hd.DPAM_SBA_NO,0)   DPAM_SBA_NO                         
                       ,isnull(hd.dpam_id ,0)   dpam_id                         
                       from                         
                      (SELECT CLIM_CRN_NO                        
                       ,ISNULL(CLIM_NAME1,'')    CLIM_NAME1                        
                       ,ISNULL(DPHD_SH_FNAME,'') DPHD_SH_FNAME                        
                       ,ISNULL(DPHD_TH_FNAME,'') DPHD_TH_FNAME                        
                       ,ISNULL(a.DPAM_SBA_NO,0)   DPAM_SBA_NO                         
                       ,isnull(a.dpam_id ,0)       dpam_id                         
                 FROM CLIENT_MSTR C                         
                    , DP_ACCT_MSTR A                         
                      LEFT OUTER JOIN                         
                      DP_HOLDER_DTLS D ON  A.DPAM_ID = D.DPHD_DPAM_ID                          
                    , citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                
         WHERE C.CLIM_CRN_NO = A.DPAM_CRN_NO                        
         AND   A.DPAM_SBA_NO =dpam.dpam_sba_no                        
         AND   A.DPAM_SBA_NO =@pa_cd                        
         AND   A.DPAM_EXCSM_ID=@pa_id) HD)  details                        
         left outer join                        
         account_properties accp               
         on accp.accp_clisba_id = details.dpam_id                         
         and accp.accp_accpm_prop_cd = 'CMBP_iD'                        
         where isnull(accp.accp_value,'') = ''*/                        
       --                        
       END                        
       ELSE IF @pa_rmks = 'P'                        
       BEGIN                        
       --                        
        select ltrim(rtrim(isnull(C.CLIM_NAME1,'')))  + ' ' + ltrim(rtrim(isnull(C.CLIM_NAME2,''))) + ' ' +ltrim(rtrim(isnull(C.CLIM_NAME3,''))) CLIM_NAME1                        
               ,ltrim(rtrim(isnull(d.DPHD_SH_FNAME,'')))  + ' ' + ltrim(rtrim(isnull(d.DPHD_SH_mNAME,''))) + ' ' +ltrim(rtrim(isnull(d.DPHD_sH_lNAME,''))) DPHD_SH_FNAME                        
              ,ltrim(rtrim(isnull(d.DPHD_tH_FNAME,'')))  + ' ' + ltrim(rtrim(isnull(d.DPHD_tH_mNAME,''))) + ' ' +ltrim(rtrim(isnull(d.DPHD_tH_lNAME,''))) DPHD_TH_FNAME                        
                                  
              ,DPAM_SBA_NO + @coldelimiter + @pa_rmks DPAM_ACCT_NO                        
        FROM   client_mstr C                        
              ,(SELECT dpam_crn_no,dpam_id , dpam_sba_no,dpam_stam_cd                        
                FROM   entity_mstr           entm                        
                      ,entity_relationship   entr                        
                      ,exch_seg_mstr         excsm                        
                      ,excsm_prod_mstr       excpm                            
                      ,dp_acct_mstr                         
                      ,login_names                        
                WHERE (entm_id = entr_ho                               
                       OR entm_id = entr_re                                   
                       OR entm_id = entr_ar                                  
                       OR entm_id = entr_br                                  
                       OR entm_id = entr_sb                                  
                       OR entm_id = entr_dl                                  
                       OR entm_id = entr_rm                                  
                       OR entm_id = entr_dummy1                          
                       OR entm_id = entr_dummy2                                  
                       OR entm_id = entr_dummy3                                  
                       OR entm_id = entr_dummy4                                  
                       OR entm_id = entr_dummy5                                  
                       OR entm_id = entr_dummy6                                  
                       OR entm_id = entr_dummy7             
                       OR entm_id = entr_dummy8                                  
                       OR entm_id = entr_dummy9                                  
                       OR entm_id = entr_dummy10)                                  
                AND entr_crn_no   = dpam_crn_no                        
                AND entm_id = logn_ent_id                        
                AND logn_name = @pa_login_name                        
                AND dpam_sba_no   = @pa_cd                         
                AND entr.entr_excpm_id = excpm.excpm_id                        
                AND excpm.excpm_excsm_id = excsm.excsm_id                        
                AND excsm.excsm_exch_cd IN ('CDSL','NSDL')                         
                and dpam_dpm_id  = @l_dpm_dpid) dpam                        
               left outer join                                                  
               DP_HOLDER_DTLS D  on dpam.DPAM_ID = D.DPHD_DPAM_ID                  
               ,account_properties accp                           
        WHERE C.CLIM_CRN_NO = dpam.DPAM_CRN_NO                          
        --AND   dpam.DPAM_SBA_NO           LIKE CASE WHEN LTRIM(RTRIM(@pa_cd))     = '' THEN '%' ELSE @pa_cd END                        
        AND   dpam.DPAM_SBA_NO           = @pa_cd                         
        and   dpam.DPAM_ID = accp.accp_clisba_id                         
        and   accp.accp_accpm_prop_cd = 'CMBP_iD'                        
        and   accp.accp_value            LIKE CASE WHEN LTRIM(RTRIM(@pa_desc))     = '' THEN '%' ELSE @pa_desc  END                        
        and   dpam.dpam_stam_cd       = @l_stam_cd                        
                                 
                               
        /* SELECT details.CLIM_NAME1                        
            ,details.DPHD_SH_FNAME                        
               ,details.DPHD_TH_FNAME         
                ,details.DPAM_SBA_NO + @coldelimiter + @pa_rmks DPAM_ACCT_NO                        
                                       
         FROM   (select hd.CLIM_CRN_NO                        
                       ,ISNULL(hd.CLIM_NAME1,'')    CLIM_NAME1                        
                       ,ISNULL(hd.DPHD_SH_FNAME,'') DPHD_SH_FNAME                        
                       ,ISNULL(hd.DPHD_TH_FNAME,'') DPHD_TH_FNAME                        
                       ,ISNULL(hd.DPAM_SBA_NO,0)   DPAM_SBA_NO                         
                       ,isnull(hd.dpam_id ,0)       dpam_id                         
                       from                         
                      (SELECT CLIM_CRN_NO                        
                       ,ISNULL(CLIM_NAME1,'')    CLIM_NAME1                        
                       ,ISNULL(DPHD_SH_FNAME,'') DPHD_SH_FNAME                        
                       ,ISNULL(DPHD_TH_FNAME,'') DPHD_TH_FNAME                        
                       ,ISNULL(a.DPAM_SBA_NO,0)   DPAM_SBA_NO                         
                       ,isnull(a.dpam_id ,0)       dpam_id                         
                 FROM CLIENT_MSTR C                         
                    , DP_ACCT_MSTR A                         
                      LEFT OUTER JOIN                         
                      DP_HOLDER_DTLS D ON  A.DPAM_ID = D.DPHD_DPAM_ID                          
                    , citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                          
         WHERE C.CLIM_CRN_NO = A.DPAM_CRN_NO                                 AND   A.DPAM_EXCSM_ID=@pa_id                        
         and   dpam.dpam_sba_no = a.dpam_sba_no) HD )  details                        
       ,account_properties accp                        
        WHERE accp.accp_clisba_id = details.dpam_id                         
        and accp.accp_accpm_prop_cd = 'CMBP_iD'                        
        and accp.accp_value            LIKE CASE WHEN LTRIM(RTRIM(@pa_desc))     = '' THEN '%' ELSE @pa_desc  END                        
        and details.DPAM_SBA_NO        LIKE CASE WHEN LTRIM(RTRIM(@pa_cd))     = '' THEN '%' ELSE @pa_cd END*/                        
         
                               
     --                        
     END                        
     ELSE IF @pa_desc <> ''                        
     BEGIN                        
     --                        
       SELECT details.CLIM_NAME1                        
             ,details.DPHD_SH_FNAME                        
             ,details.DPHD_TH_FNAME                        
              ,details.DPAM_SBA_NO + @coldelimiter + @pa_rmks DPAM_ACCT_NO                        
                                     
       FROM   (select hd.CLIM_CRN_NO                        
                     ,ISNULL(hd.CLIM_NAME1,'')    CLIM_NAME1                        
     ,ISNULL(hd.DPHD_SH_FNAME,'') DPHD_SH_FNAME                        
                     ,ISNULL(hd.DPHD_TH_FNAME,'') DPHD_TH_FNAME                        
                     ,ISNULL(hd.DPAM_SBA_NO,0)   DPAM_SBA_NO                         
                     ,isnull(hd.dpam_id ,0)       dpam_id                         
                     from                         
    (SELECT CLIM_CRN_NO                        
                     ,ISNULL(CLIM_NAME1,'')    CLIM_NAME1                        
                     ,ISNULL(DPHD_SH_FNAME,'') DPHD_SH_FNAME                        
                     ,ISNULL(DPHD_TH_FNAME,'') DPHD_TH_FNAME                        
                     ,ISNULL(a.DPAM_SBA_NO,0)   DPAM_SBA_NO                         
                     ,isnull(a.dpam_id ,0)       dpam_id                         
               FROM CLIENT_MSTR C                         
                  , DP_ACCT_MSTR A                         
                    LEFT OUTER JOIN                         
                    DP_HOLDER_DTLS D ON  A.DPAM_ID = D.DPHD_DPAM_ID            
                  , citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                          
       WHERE C.CLIM_CRN_NO = A.DPAM_CRN_NO                        
       AND   A.DPAM_SBA_NO =dpam.dpam_sba_no                        
       AND   A.DPAM_SBA_NO =@pa_cd                         
       AND   A.DPAM_EXCSM_ID=@pa_id) HD ) details                        
        ,account_properties accp                        
        WHERE accp_clisba_id = details.dpam_id                         
        and accp_accpm_prop_cd = 'CMBP_iD'                        
          and accp_value <> ''                        
     --                        
     END                        
                             
  --                        
  END



END

GO
