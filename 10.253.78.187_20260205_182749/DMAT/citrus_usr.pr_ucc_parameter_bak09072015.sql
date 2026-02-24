-- Object: PROCEDURE citrus_usr.pr_ucc_parameter_bak09072015
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create PROCEDURE [citrus_usr].[pr_ucc_parameter_bak09072015](@pa_from_dt       varchar(100)      
                                ,@pa_to_dt         varchar(100)      
                                ,@pa_exch_cd       varchar(10)      
                                ,@pa_exch_seg_cd   varchar(15)      
								,@pa_excsm_id int
                                ,@pa_tab           char(3)      
                                ,@pa_ref_cur       varchar(8000)  output      
                                )      
AS      
BEGIN      
--
  
 -- set @pa_from_dt = @pa_from_dt + +' 00:00:00.000'
 -- set @pa_to_dt   = @pa_to_dt + +' 23:59:59.999'
 declare @L_DPM_ID int,@file_type varchar(1)
select @L_DPM_ID = dpm_id from dp_mstr where default_dp=dpm_excsm_id and dpm_deleted_ind=1 and dpm_excsm_id=@pa_excsm_id  
--Select @file_type= citrus_usr.FN_SPLITVAL_BY(@pa_tab,2,'|')
--Select @pa_tab= citrus_usr.FN_SPLITVAL_BY(@pa_tab,1,'|')

IF @PA_TAB='SLIPISSUE_SELECT'
BEGIN
Select SLIIM_ID, SLIIM_DPAM_ACCT_NO,SLIIM_SLIP_NO_FR,SLIIM_SLIP_NO_TO,'ISSUANCE' TYPE,@pa_exch_seg_cd ISSUEENTITY -- *,'I' flag
	FROM  slip_issue_mstr
	where		sliim_dpm_id   = case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end
	and not exists (select 1 from sliim_batch_dtls where slibd_sliim_id = SLIIM_ID and slibd_deleted_ind = 1 )
	and sliim_dt   BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' 
	AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
	and len(SLIIM_DPAM_ACCT_NO)=16
	--union all 
	--Select *,'P' flag
	--FROM  slip_issue_mstr_poa
	--where		sliim_dpm_id   = case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end
	--and not exists (select 1 from sliim_batch_dtls where slibd_sliim_id = SLIIM_ID and slibd_deleted_ind = 1 )
	--and sliim_lst_upd_dt   BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
	--and len(SLIIM_DPAM_ACCT_NO)=16
END 
    
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
      SELECT DISTINCT CONVERT(VARCHAR(10), clim.clim_crn_no)                clim_crn_no      
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
           AND    dpam.dpam_excsm_id        = excsm.excsm_id  
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
print 'latesh'
   

--select top 1 * from client_mstr
--      SELECT DISTINCT CONVERT(VARCHAR(10), clim.clim_crn_no)                   clim_crn_no      
--           , isnull(clim.clim_name1,'')+' '+isnull(clim.clim_name2,'')+' '+isnull(clim.clim_name3,'')           names      
--           , clim.clim_short_name short_name       
--           --, compm.compm_mem_cd                                                compm_mem_cd      
----           , Case When @pa_exch_cd='NSE' Then compm.COMPM_NSECM_MEM_CD when @pa_exch_cd='BSE' Then compm.COMPM_BSECM_MEM_CD when @pa_exch_cd='MCX' Then compm.COMPM_mcx_MEM_CD when @pa_exch_cd='NCDEX' Then compm.COMPM_ncdex_MEM_CD when  @pa_exch_cd='NMC' Then compm.COMPM_nmc_MEM_CD when @pa_exch_cd='dgcx' Then compm.COMPM_dgcx_MEM_CD else '' End compm_mem_cd
--           , Case When @pa_exch_cd='NSDL' Then  isnull(COMPM_nsdl_dpid,'') when @pa_exch_cd='CDSL' Then  isnull(COMPM_cdsl_dpid,'') End compm_mem_cd
--           , x.dpam_sba_no                                                    party_code--x.dpam_acct_no                                                    party_code      
--           , clicm.clicm_id                                                    clicm_id    
--           , enttm.enttm_id                                                    enttm_id  
--           , case when clicm.clicm_desc    
--             not in ('individual','corporate','non resident indian','indian financial institute','fii','mutual fund','bank','foreign national','trust','fi fii corporates','clearing member')
--             then clicm.clicm_desc  +  ' : Category not valid for DP' ELSE clicm.clicm_desc END ctgry
--		   , x.dpam_sba_no            Sba_no   
--      FROM      
--          (SELECT dpam.dpam_crn_no            dpam_crn_no      
--                , dpam.dpam_acct_no           dpam_acct_no      
--                , excsm.excsm_exch_cd         excsm_exch_cd      
--                , excsm.excsm_seg_cd          excsm_seg_cd      
--                , excsm.excsm_compm_id        compm_id      
--                , dpam.dpam_enttm_cd          dpam_enttm_cd  
--                , dpam.dpam_clicm_cd          dpam_clicm_cd  
--                , dpam.dpam_lst_upd_dt        dpam_lst_upd_dt
--                , dpam.dpam_batch_no          dpam_batch_no   
--				, dpam.dpam_sba_no            dpam_sba_no 
--           FROM exch_seg_mstr               excsm     WITH (NOLOCK)      
--                , dp_acct_mstr                dpam      WITH (NOLOCK)   
--                  left outer join 
--                  dp_holder_dtls              dphm      WITH (NOLOCK)      on dpam.dpam_id = dphm.dphd_dpam_id  
--                  left outer join 
--                  client_bank_accts           cliba     WITH (NOLOCK)      on dpam.dpam_id  = cliba.cliba_clisba_id  
--           WHERE  excsm.excsm_seg_cd        = @pa_exch_seg_cd      
--           AND    excsm.excsm_exch_cd       = @pa_exch_cd      
--           AND    dpam.dpam_excsm_id        = excsm.excsm_id  
--           AND    dpam.dpam_excsm_id        = excsm.excsm_id  
--           AND    dpam.dpam_deleted_ind     = 1    and dpam.dpam_excsm_id=@pa_excsm_id
--           
--          ) x      
--          , client_mstr                       clim      WITH (NOLOCK)    
--          , client_ctgry_mstr                 clicm     WITH (NOLOCK)    
--          , entity_type_mstr                  enttm     WITH (NOLOCK)     
--          , company_mstr                      compm     WITH (NOLOCK)      
--      WHERE x.dpam_crn_no                   = clim.clim_crn_no      
--      AND   x.compm_id                      = compm.compm_id      
--      AND   x.dpam_clicm_cd                 = clicm.clicm_cd    
--      AND   x.dpam_enttm_cd                 = enttm.enttm_cd    
--      AND   CLIM.CLIM_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'       
--      --AND   clim.clim_lst_upd_dt            <>clim.clim_created_dt    
--      AND   clim.clim_deleted_ind           = 1       
--      AND   isnull(x.dpam_batch_no,0)       <> 0

--print replace(@pa_to_dt,'/','')  
select distinct dpam_crn_no as clim_crn_no ,dpam_sba_name as names ,
'' as short_name,'' compm_mem_cd,'' party_code,DPAM_CLICM_CD as clicm_id,dpam_enttm_cd as enttm_id,
'' ctgry,dpam_sba_no sba_no
 from MOSL_EDP_Client_modification,dp_acct_mstr
where convert(datetime,ca_authdt,103) between 
 CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'       
and dpam_sba_no=ca_cmcd
and dpam_excsm_id=@pa_excsm_id
     
    --      
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
         
          ) x      
          , client_mstr                       clim      WITH (NOLOCK)    
          , client_ctgry_mstr                 clicm     WITH (NOLOCK)    
          , entity_type_mstr                  enttm     WITH (NOLOCK)     
          , company_mstr                      compm     WITH (NOLOCK)      
      WHERE x.dpam_crn_no                   = clim.clim_crn_no      
      AND   x.compm_id                      = compm.compm_id      
      AND   x.dpam_clicm_cd                 = clicm.clicm_cd    
      AND   x.dpam_enttm_cd                 = enttm.enttm_cd    
      AND   CLIM.CLIM_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'       
      AND   clim.clim_deleted_ind           = 1  
      
    --      
    END   
  --  
  END  
--    


  
END

GO
