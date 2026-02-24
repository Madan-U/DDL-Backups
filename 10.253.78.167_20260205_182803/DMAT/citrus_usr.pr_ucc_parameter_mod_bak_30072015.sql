-- Object: PROCEDURE citrus_usr.pr_ucc_parameter_mod_bak_30072015
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------







create PROCEDURE [citrus_usr].[pr_ucc_parameter_mod_bak_30072015](@pa_from_dt       varchar(100)      
                                ,@pa_to_dt         varchar(100)      
                                ,@pa_exch_cd       varchar(10)      
                                ,@pa_exch_seg_cd   varchar(15)      
                                ,@pa_tab           char(3)   
                                ,@pa_excsm_id	   varchar(15)  
                                ,@pa_mod_typ	   varchar(50) 
                                ,@pa_ref_cur       varchar(8000)  output      
                                )      
AS      
BEGIN      
--
  
 -- set @pa_from_dt = @pa_from_dt + +' 00:00:00.000'
 -- set @pa_to_dt   = @pa_to_dt + +' 23:59:59.999'
       
  IF @pa_exch_cd <> 'NSDL' AND @pa_exch_cd <> 'CDSL'  
  BEGIN  
  --  
    IF @pa_tab = 'N'      
    BEGIN      
    --      
      --CONVERT(VARCHAR(10), clim_crn_no)+'|*~|'+CONVERT(varchar(25), x.clia_acct_no)+'|*~|*|~*' value      
      SELECT DISTINCT CONVERT(VARCHAR(10), clim.clim_crn_no)                   clim_crn_no      
           , isnull(clim.clim_name1,'')+' '+isnull(clim.clim_name2,'')+' '+isnull(clim.clim_name3,'')           names      
           , clim.clim_short_name                                              short_name       
           --, compm.compm_mem_cd                                                compm_mem_cd      
           , Case When @pa_exch_cd='NSE' Then compm.COMPM_NSECM_MEM_CD when @pa_exch_cd='BSE' Then compm.COMPM_BSECM_MEM_CD when @pa_exch_cd='MCX' Then compm.COMPM_mcx_MEM_CD when @pa_exch_cd='NCDEX' Then compm.COMPM_ncdex_MEM_CD when  @pa_exch_cd='NMC' Then compm.COMPM_nmc_MEM_CD when @pa_exch_cd='dgcx' Then compm.COMPM_dgcx_MEM_CD  when @pa_exch_cd='mcd' Then '58300' else '' End compm_mem_cd
           , compm.compm_name1                                                 trading_mem_name
           , x.clia_acct_no                                                    party_code      
           , clicm.clicm_id                                                    clicm_id    
           , enttm.enttm_id                                                    enttm_id  
      FROM      
          (SELECT clia.clia_crn_no            clia_crn_no      
                , clia.clia_acct_no           clia_acct_no      
                , excsm.excsm_exch_cd         excsm_exch_cd      
                , excsm.excsm_seg_cd          excsm_seg_cd      
                , excsm.excsm_compm_id        compm_id      
                , ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc),0) access1      
           FROM   client_accounts             clia      WITH (NOLOCK)      
                , exch_seg_mstr               excsm     WITH (NOLOCK)      
           WHERE  excsm.excsm_exch_cd       = @pa_exch_cd      
           --AND    excsm.excsm_seg_cd        = @pa_exch_seg_cd      
           AND    clia.clia_deleted_ind     = 1      
           AND    excsm.excsm_deleted_ind   = 1      
          ) x      
          , client_mstr                       clim      WITH (NOLOCK)    
          , client_ctgry_mstr                 clicm     WITH (NOLOCK)    
          , entity_type_mstr                  enttm     WITH (NOLOCK)     
          , company_mstr                      compm     WITH (NOLOCK)      
      WHERE x.clia_crn_no                   = clim.clim_crn_no      
      AND   x.compm_id                      = compm.compm_id      
      AND   clim.clim_clicm_cd              = clicm.clicm_cd    
      AND   clim.clim_enttm_cd              = enttm.enttm_cd    
      AND   clim.clim_created_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'       
      --AND   clim.clim_lst_upd_dt            = clim.clim_created_dt    
      AND   clim.clim_deleted_ind           = 1      
      AND   x.access1                      <> 0      
    --      
    END      
    ELSE IF @pa_tab = 'M'      
    BEGIN      
    --      
      SELECT DISTINCT   CONVERT(VARCHAR(10), clim.clim_crn_no)                clim_crn_no      
           , isnull(clim.clim_name1,'')+' '+isnull(clim.clim_name2,'')+' '+isnull(clim.clim_name3,'')        names      
           , clim.clim_short_name                                           short_name       
           --, compm.compm_mem_cd                                             compm_mem_cd      
	          , Case When @pa_exch_cd='NSE' Then compm.COMPM_NSECM_MEM_CD when @pa_exch_cd='BSE' Then compm.COMPM_BSECM_MEM_CD when @pa_exch_cd='MCX' Then compm.COMPM_mcx_MEM_CD when @pa_exch_cd='NCDEX' Then compm.COMPM_ncdex_MEM_CD when  @pa_exch_cd='NMC' Then compm.COMPM_nmc_MEM_CD when @pa_exch_cd='dgcx' Then compm.COMPM_dgcx_MEM_CD when @pa_exch_cd='mcd' Then '58300' else '' End compm_mem_cd
	          , compm.compm_name1                                                 trading_mem_name
           , x.clia_acct_no                                                 party_code      
           , clicm.clicm_id                                                 clicm_id    
           , enttm.enttm_id                                                 enttm_id    
      FROM      
          (SELECT clia.clia_crn_no       clia_crn_no      
                , clia.clia_acct_no           clia_acct_no      
                , excsm.excsm_exch_cd         excsm_exch_cd      
                , excsm.excsm_seg_cd          excsm_seg_cd      
                , excsm.excsm_compm_id        compm_id      
                , ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc),0) access1      
           FROM   client_accounts             clia      WITH (NOLOCK)      
                , exch_seg_mstr               excsm     WITH (NOLOCK)      
           WHERE  excsm.excsm_exch_cd       = @pa_exch_cd      
           --AND    excsm.excsm_seg_cd        = @pa_exch_seg_cd      
           AND    clia.clia_deleted_ind     = 1      
           AND    excsm.excsm_deleted_ind   = 1       
          ) x      
          , client_mstr                       clim      WITH (NOLOCK)      
          , company_mstr                      compm     WITH (NOLOCK)     
          , client_ctgry_mstr                 clicm     WITH (NOLOCK)    
          , entity_type_mstr                  enttm     WITH (NOLOCK)      
      WHERE x.clia_crn_no                   = clim.clim_crn_no      
      AND   x.compm_id                      = compm.compm_id      
      AND   clim.clim_clicm_cd              = clicm.clicm_cd    
      AND   clim.clim_enttm_cd              = enttm.enttm_cd    
      AND   clim.clim_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'       
      --AND   clim.clim_lst_upd_dt            <> clim.clim_created_dt    
      AND   clim.clim_deleted_ind           = 1      
      AND   x.access1                      <> 0  
          
    --      
    END  
    ELSE   
    BEGIN      
    --   
      SELECT DISTINCT CONVERT(VARCHAR(10), clim.clim_crn_no)                clim_crn_no      
           , isnull(clim.clim_name1,'')+' '+isnull(clim.clim_name2,'')+' '+isnull(clim.clim_name3,'')        names      
           , clim.clim_short_name                                           short_name       
           --, compm.compm_mem_cd                                             compm_mem_cd      
	          , Case When @pa_exch_cd='NSE' Then compm.COMPM_NSECM_MEM_CD when @pa_exch_cd='BSE' Then compm.COMPM_BSECM_MEM_CD when @pa_exch_cd='MCX' Then compm.COMPM_mcx_MEM_CD when @pa_exch_cd='NCDEX' Then compm.COMPM_ncdex_MEM_CD when  @pa_exch_cd='NMC' Then compm.COMPM_nmc_MEM_CD when @pa_exch_cd='dgcx' Then compm.COMPM_dgcx_MEM_CD when @pa_exch_cd='mcd' Then '58300' else '' End compm_mem_cd
	          , compm.compm_name1                                                 trading_mem_name
           , x.clia_acct_no                                                 party_code      
           , clicm.clicm_id                                                 clicm_id    
           , enttm.enttm_id                                                 enttm_id    
           , clim.clim_created_dt    
           , clim.clim_lst_upd_dt    
      FROM      
          (SELECT clia.clia_crn_no            clia_crn_no      
                , clia.clia_acct_no           clia_acct_no      
                , excsm.excsm_exch_cd         excsm_exch_cd      
                , excsm.excsm_seg_cd          excsm_seg_cd      
                , excsm.excsm_compm_id        compm_id      
                , ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc),0) access1      
           FROM   client_accounts             clia      WITH (NOLOCK)      
                , exch_seg_mstr               excsm     WITH (NOLOCK)      
           WHERE  excsm.excsm_exch_cd       = @pa_exch_cd      
           --AND    excsm.excsm_seg_cd        = @pa_exch_seg_cd      
           AND    clia.clia_deleted_ind     = 1      
           AND    excsm.excsm_deleted_ind   = 1      
          ) x      
          , client_mstr                       clim      WITH (NOLOCK)      
          , company_mstr                      compm     WITH (NOLOCK)     
          , client_ctgry_mstr                 clicm     WITH (NOLOCK)    
          , entity_type_mstr                  enttm     WITH (NOLOCK)      
      WHERE x.clia_crn_no                   = clim.clim_crn_no      
      AND   x.compm_id                      = compm.compm_id      
      AND   clim.clim_clicm_cd              = clicm.clicm_cd    
      AND   clim.clim_enttm_cd              = enttm.enttm_cd    
      AND   clim.clim_lst_upd_dt           BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'       
      AND   clim.clim_deleted_ind           = 1      
      AND   x.access1                      <> 0      
    --      
    END      
  --  
  END  
  ELSE  
  BEGIN  
  --  
    IF @pa_tab = 'N'      
    BEGIN      
    --      
      --CONVERT(VARCHAR(10), clim_crn_no)+'|*~|'+CONVERT(varchar(25), x.clia_acct_no)+'|*~|*|~*' value      
      SELECT DISTINCT CONVERT(VARCHAR(10), clim.clim_crn_no)                   clim_crn_no      
           , isnull(clim.clim_name1,'')+' '+isnull(clim.clim_name2,'')+' '+isnull(clim.clim_name3,'')           names      
           , clim.clim_short_name                                              short_name       
           --, compm.compm_mem_cd                                                compm_mem_cd      
           --, Case When @pa_exch_cd='NSE' Then compm.COMPM_NSECM_MEM_CD when @pa_exch_cd='BSE' Then compm.COMPM_BSECM_MEM_CD when @pa_exch_cd='MCX' Then compm.COMPM_mcx_MEM_CD when @pa_exch_cd='NCDEX' Then compm.COMPM_ncdex_MEM_CD when  @pa_exch_cd='NMC' Then compm.COMPM_nmc_MEM_CD when @pa_exch_cd='dgcx' Then compm.COMPM_dgcx_MEM_CD else '' End compm_mem_cd
           , Case When @pa_exch_cd='NSDL' Then  isnull(COMPM_nsdl_dpid,'') when @pa_exch_cd='CDSL' Then  isnull(COMPM_cdsl_dpid,'') End compm_mem_cd
           , x.dpam_acct_no                                                    party_code
           , x.dpam_sba_no                                                     Sba_No
           , clicm.clicm_id                                                    clicm_id    
           , enttm.enttm_id                                                    enttm_id  
           , case when clicm.clicm_desc    
             not in ('individual','corporate','non resident indian','indian financial institute','fii','mutual fund','bank','foreign national','trust','fi fii corporates','clearing member')
             then clicm.clicm_desc  +  ' : Category not valid for DP' ELSE clicm.clicm_desc END ctgry  
      FROM      
          (SELECT dpam.dpam_crn_no            dpam_crn_no      
                , dpam.dpam_acct_no           dpam_acct_no      
                , excsm.excsm_exch_cd         excsm_exch_cd      
                , excsm.excsm_seg_cd          excsm_seg_cd      
                , excsm.excsm_compm_id        compm_id      
                , dpam.dpam_enttm_cd          dpam_enttm_cd  
                , dpam.dpam_clicm_cd          dpam_clicm_cd  
                , dpam.dpam_lst_upd_dt        dpam_lst_upd_dt
                , dpam.dpam_batch_no          dpam_batch_no 
                , dpam.dpam_sba_no            dpam_sba_no        
           FROM exch_seg_mstr               excsm     WITH (NOLOCK)      
                , dp_acct_mstr                dpam      WITH (NOLOCK)   
                  left outer join 
                  dp_holder_dtls              dphm      WITH (NOLOCK)      on dpam.dpam_id = dphm.dphd_dpam_id  
                  left outer join 
                  client_bank_accts           cliba     WITH (NOLOCK)      on dpam.dpam_id  = cliba.cliba_clisba_id  
           WHERE  excsm.excsm_seg_cd        = @pa_exch_seg_cd      
           AND    excsm.excsm_exch_cd       = @pa_exch_cd      
           AND    dpam.dpam_excsm_id        = excsm.excsm_id  
           AND    dpam.dpam_excsm_id        = excsm.excsm_id  AND DPAM_EXCSM_ID=@pa_excsm_id
           AND    dpam.dpam_deleted_ind     = 1    
           
           ) x      
          , client_mstr                       clim      WITH (NOLOCK)    
          , client_ctgry_mstr                 clicm     WITH (NOLOCK)    
          , entity_type_mstr                  enttm     WITH (NOLOCK)     
          , company_mstr                      compm     WITH (NOLOCK)      
      WHERE x.dpam_crn_no                   = clim.clim_crn_no      
      AND   x.compm_id                      = compm.compm_id      
      AND   x.dpam_clicm_cd                 = clicm.clicm_cd    
      AND   x.dpam_enttm_cd                 = enttm.enttm_cd    
      AND   CLIM.CLIM_lst_upd_dt                 BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'       
      --AND   clim.clim_lst_upd_dt            = clim.clim_created_dt    
      AND   isnull(x.dpam_batch_no,0)       = 0
      AND   clim.clim_deleted_ind           = 1    
      
       
    --      
    END      
    ELSE IF @pa_tab = 'M'      
    BEGIN      
    --    
      
      SELECT  DISTINCT  CONVERT(VARCHAR(10), clim.clim_crn_no)                   clim_crn_no      
           , isnull(clim.clim_name1,'')+' '+isnull(clim.clim_name2,'')+' '+isnull(clim.clim_name3,'')           names      
           , clim.clim_short_name short_name       
           --, compm.compm_mem_cd                                                compm_mem_cd      
--           , Case When @pa_exch_cd='NSE' Then compm.COMPM_NSECM_MEM_CD when @pa_exch_cd='BSE' Then compm.COMPM_BSECM_MEM_CD when @pa_exch_cd='MCX' Then compm.COMPM_mcx_MEM_CD when @pa_exch_cd='NCDEX' Then compm.COMPM_ncdex_MEM_CD when  @pa_exch_cd='NMC' Then compm.COMPM_nmc_MEM_CD when @pa_exch_cd='dgcx' Then compm.COMPM_dgcx_MEM_CD else '' End compm_mem_cd
           , Case When @pa_exch_cd='NSDL' Then  isnull(COMPM_nsdl_dpid,'') when @pa_exch_cd='CDSL' Then  isnull(COMPM_cdsl_dpid,'') End compm_mem_cd
           , x.dpam_sba_no                                                    party_code--x.dpam_acct_no                                                    party_code      
           , clicm.clicm_id                                                    clicm_id    
           , enttm.enttm_id                                                    enttm_id  
           , case when clicm.clicm_desc    
             not in ('individual','corporate','non resident indian','indian financial institute','fii','mutual fund','bank','foreign national','trust','fi fii corporates','clearing member')
             then clicm.clicm_desc  +  ' : Category not valid for DP' ELSE clicm.clicm_desc END ctgry
		   , x.dpam_sba_no            Sba_no 
		   --, climmod.clic_mod_action	  modi_typ  
		   , case when upper(@pa_mod_typ) = 'ALL' then 'ALL' else @pa_mod_typ end as modi_typ
      FROM      
          (SELECT dpam.dpam_crn_no            dpam_crn_no      
                , dpam.dpam_acct_no           dpam_acct_no      
                , excsm.excsm_exch_cd         excsm_exch_cd      
                , excsm.excsm_seg_cd          excsm_seg_cd      
                , excsm.excsm_compm_id        compm_id      
                , dpam.dpam_enttm_cd          dpam_enttm_cd  
                , dpam.dpam_clicm_cd          dpam_clicm_cd  
                , dpam.dpam_lst_upd_dt        dpam_lst_upd_dt
                , dpam.dpam_batch_no          dpam_batch_no   
				, dpam.dpam_sba_no            dpam_sba_no 
           FROM exch_seg_mstr               excsm     WITH (NOLOCK)      
                , dp_acct_mstr                dpam      WITH (NOLOCK)   
                  left outer join 
                  dp_holder_dtls              dphm      WITH (NOLOCK)      on dpam.dpam_id = dphm.dphd_dpam_id  
                  left outer join 
                  client_bank_accts           cliba     WITH (NOLOCK)      on dpam.dpam_id  = cliba.cliba_clisba_id  
           WHERE  excsm.excsm_seg_cd        = @pa_exch_seg_cd      
           AND    excsm.excsm_exch_cd       = @pa_exch_cd      
           AND    dpam.dpam_excsm_id        = excsm.excsm_id  
           AND    dpam.dpam_excsm_id        = excsm.excsm_id  
           AND    dpam.dpam_deleted_ind     = 1    
           AND    dpam.DPAM_EXCSM_ID = @pa_excsm_id
          ) x      
          , client_mstr                       clim      WITH (NOLOCK)    
          , client_ctgry_mstr                 clicm     WITH (NOLOCK)    
          , entity_type_mstr                  enttm     WITH (NOLOCK)     
          , company_mstr                      compm     WITH (NOLOCK)      
          , client_list_modified  climmod     
      WHERE x.dpam_crn_no                   = clim.clim_crn_no      
      AND   x.compm_id                      = compm.compm_id      
      AND   x.dpam_clicm_cd                 = clicm.clicm_cd    
      AND   x.dpam_enttm_cd                 = enttm.enttm_cd   and clic_mod_action<>'SIGNATURE' 
      and   (x.dpam_sba_no =  clic_mod_dpam_sba_no)-- or case when clic_mod_pan_no <> '' then citrus_usr.fn_ucc_entp(clim.CLIM_CRN_NO,'pan_gir_no','') else '0' end = clic_mod_pan_no)
      --AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
     --AND convert(varchar,climmod.clic_mod_from_dt,103)  between @pa_from_dt and @pa_to_dt -- Added by pankaj on 20/09/2013               
	 --AND convert(varchar,climmod.clic_mod_to_dt,103)  between @pa_from_dt and @pa_to_dt -- Added by pankaj on 20/09/2013
	 and   (convert(datetime,convert(varchar(11),clic_mod_from_dt,109)) between convert(datetime,@pa_from_dt,103) and convert(datetime,@pa_to_dt,103))
	 AND   (convert(datetime,convert(varchar(11),clic_mod_to_dt,109)) between convert(datetime,@pa_from_dt,103) and convert(datetime,@pa_to_dt,103)               )
      and    climmod.clic_mod_deleted_ind = 1
      --AND   CLIM.CLIM_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'       
      --AND   clim.clim_lst_upd_dt            <>clim.clim_created_dt    
      AND   clim.clim_deleted_ind           = 1       
      AND   isnull(x.dpam_batch_no,0)       <> 0
	 AND  isnull(climmod.clic_mod_batch_no,0) = 0
     --and climmod.clic_mod_action = @pa_mod_typ
         and    climmod.clic_mod_action like case when upper(@pa_mod_typ) = 'ALL' then '%%' else @pa_mod_typ end
    END  
    ELSE   
    BEGIN      
    --   
    
      SELECT DISTINCT CONVERT(VARCHAR(10), clim.clim_crn_no)                   clim_crn_no      
           , isnull(clim.clim_name1,'')+' '+isnull(clim.clim_name2,'')+' '+isnull(clim.clim_name3,'')           names      
           , clim.clim_short_name                                              short_name       
           --, compm.compm_mem_cd                                                compm_mem_cd      
--           , Case When @pa_exch_cd='NSE' Then compm.COMPM_NSECM_MEM_CD when @pa_exch_cd='BSE' Then compm.COMPM_BSECM_MEM_CD when @pa_exch_cd='MCX' Then compm.COMPM_mcx_MEM_CD when @pa_exch_cd='NCDEX' Then compm.COMPM_ncdex_MEM_CD when  @pa_exch_cd='NMC' Then compm.COMPM_nmc_MEM_CD when @pa_exch_cd='dgcx' Then compm.COMPM_dgcx_MEM_CD else '' End compm_mem_cd
           , Case When @pa_exch_cd='NSDL' Then  isnull(COMPM_nsdl_dpid,'') when @pa_exch_cd='CDSL' Then  isnull(COMPM_cdsl_dpid,'') End compm_mem_cd
           , x.dpam_acct_no                                                    party_code      
           , clicm.clicm_id                                                    clicm_id    
           , enttm.enttm_id                                                    enttm_id  
           , case when clicm.clicm_desc    
             not in ('individual','corporate','non resident indian','indian financial institute','fii','mutual fund','bank','foreign national','trust','fi fii corporates','clearing member')
             then clicm.clicm_desc  +  ' : Category not valid for DP' ELSE clicm.clicm_desc END ctgry  
			, x.dpam_sba_no            Sba_no   
			--, climmod.clic_mod_action	  modi_typ
			, case when upper(@pa_mod_typ) = 'ALL' then 'ALL' else @pa_mod_typ end as modi_typ
      FROM      
          (SELECT dpam.dpam_crn_no            dpam_crn_no      
                , dpam.dpam_acct_no           dpam_acct_no      
                , excsm.excsm_exch_cd         excsm_exch_cd      
                , excsm.excsm_seg_cd          excsm_seg_cd      
                , excsm.excsm_compm_id        compm_id      
                , dpam.dpam_enttm_cd          dpam_enttm_cd  
                , dpam.dpam_clicm_cd          dpam_clicm_cd  
                , dpam.dpam_lst_upd_dt        dpam_lst_upd_dt
				, dpam.dpam_sba_no            dpam_sba_no 
           FROM exch_seg_mstr               excsm     WITH (NOLOCK)      
                , dp_acct_mstr                dpam      WITH (NOLOCK)   
                  left outer join 
                  dp_holder_dtls              dphm      WITH (NOLOCK)      on dpam.dpam_id = dphm.dphd_dpam_id  
                  left outer join 
                  client_bank_accts           cliba     WITH (NOLOCK)      on dpam.dpam_id  = cliba.cliba_clisba_id  
           WHERE  excsm.excsm_seg_cd        = @pa_exch_seg_cd      
           AND    excsm.excsm_exch_cd       = @pa_exch_cd      
           AND    dpam.dpam_excsm_id        = excsm.excsm_id  
           AND    dpam.dpam_excsm_id        = excsm.excsm_id  
           AND    dpam.dpam_deleted_ind     = 1   
		   AND    dpam.DPAM_EXCSM_ID = @pa_excsm_id
         
          ) x      
          , client_mstr                       clim      WITH (NOLOCK)    
          , client_ctgry_mstr                 clicm     WITH (NOLOCK)    
          , entity_type_mstr                  enttm     WITH (NOLOCK)     
          , company_mstr                      compm     WITH (NOLOCK) 
          ,client_list_modified  climmod     
      WHERE x.dpam_crn_no                   = clim.clim_crn_no      
      AND   x.compm_id                      = compm.compm_id      
      AND   x.dpam_clicm_cd                 = clicm.clicm_cd    
      AND   x.dpam_enttm_cd                 = enttm.enttm_cd and clic_mod_action='SIGNATURE'
      and   (x.dpam_sba_no =  clic_mod_dpam_sba_no 
      --or citrus_usr.fn_ucc_entp(clim.CLIM_CRN_NO,'pan_gir_no','') = clic_mod_pan_no
      )
      AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
      and    climmod.clic_mod_deleted_ind = 1
      --AND   CLIM.CLIM_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'       
      AND   clim.clim_deleted_ind           = 1  
      and isnull(climmod.clic_mod_batch_no,'0')='0'
      --and climmod.clic_mod_action = @pa_mod_typ
      and    climmod.clic_mod_action like case when upper(@pa_mod_typ) = 'ALL' then '%%' else @pa_mod_typ end
    --      
    END   
  --  
  END  
--      
END

GO
