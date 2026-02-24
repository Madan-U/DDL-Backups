-- Object: PROCEDURE citrus_usr.pr_pms_migration
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_pms_migration](@pa_from_dt    varchar(11)    
                                 ,@pa_to_dt      varchar(11)    
                                 ,@pa_from_crn   varchar(25)    
                                 ,@pa_to_crn     varchar(25)     
                                 ,@pa_login      varchar(25)    
                                 ,@pa_error      varchar(8000) out    
                                 )    
AS    
BEGIN    
--    
  DECLARE @l_error             numeric    
        , @t_errorstr          varchar(200)       
        , @c_crn_no            numeric    
        , @c_acct_no           varchar(20)    
        , @l_e_comltd          char(1)    
        , @rowdelimiter        char(4)    
  --    
  SET @rowdelimiter = '*|~*'    
  SET NOCOUNT ON    
  --    
  DECLARE @c_client_mstr       cursor    
        , @clim_crn_no         numeric     
        , @clim_name1          varchar(64)    
        , @clim_name2          varchar(64)    
        , @clim_name3          varchar(64)    
        , @clim_short_name     varchar(25)    
        , @clim_enttm_cd       varchar(25)    
        , @clim_clicm_cd       varchar(25)     
        , @modified            char(1)    
        , @clim_created_dt     datetime
        , @clim_lst_upd_dt     datetime
        , @clim_lst_upd_by     varchar(10)    
        , @l_code              varchar(14)     
        , @l_clia_acct_no      varchar(20)    
        , @l_contt_person      varchar(100)    
        , @l_mobile            numeric(32)     
        , @l_fax1              numeric(32)    
        , @l_email             varchar(128)     
        , @l_url               varchar(128)    
        , @l_bank_branch       varchar(32)    
        , @l_pan_gir           varchar(64)    
        , @l_cntrl             numeric    
        , @l_jng_date          datetime
        , @l_mode_pay          varchar(32)    
        , @l_split_val         varchar(8000)    
        , @l_dp_id             varchar(64)    
        , @l_clnt_id           varchar(64)    
        , @l_dp_clnt_id        varchar(64)    
        , @l_rgstr_code        varchar(32)    
        , @l_tier              varchar(32)    
        , @l_rm                varchar(32)    
        , @l_aplcnt_sts        varchar(32)    
        , @l_label             varchar(32)    
        , @l_adnl_phone        varchar(32)    
        , @l_intrdcd           varchar(32)    
        , @l_adrs_flat         varchar(64)    
        , @l_adrs_strt         varchar(64)    
        , @l_adrs_area         varchar(64)    
        , @l_adrs_city         varchar(32)    
        , @l_adrs_ste          varchar(32)    
        , @l_adrs_cntry        varchar(32)    
        , @l_adrs_pin          numeric
        , @l_phne              varchar(32)    
        , @l_sourcecode        varchar(32)    
        , @l_sbdc_flag         char(1)    
        , @l_cmpltd            char(1)    
        , @l_blcklstd          char(1)    
        , @l_ex_acnt_name      varchar(30)    
        , @l_amfi_nmbr         varchar(30)    
        , @l_arnfrm_date       datetime
        , @l_arnto_date        datetime
        , @l_amfi_sts          varchar(20)    
        , @l_amfilot_no        varchar(60)    
        , @l_arnpa_date        datetime
        , @l_mapin             varchar(9)    
        , @l_short_name        varchar(50)    
   --    
   IF EXISTS(SELECT sbk_code FROM pms_mig WITH (NOLOCK))    
   BEGIN--#    
   --    
     INSERT INTO pms_mig_hst    
     (sbk_code                  
     ,sbk_name                  
     ,sbk_frst_name             
     ,sbk_mdle_name             
     ,sbk_last_name             
     ,sbk_cntct                 
     ,sbk_mble                  
     ,sbk_fax                   
     ,sbk_eml                   
     ,sbk_url                   
     ,sbk_ctgry                 
     ,sbk_brnch_name            
     ,sbk_pan                   
     ,sbk_cntrl                 
     ,sbk_mode_pay              
     ,sbk_jng_date              
     ,sbk_dp_id      
     ,sbk_clnt_id               
     ,sbk_dp_clnt_id            
     ,sbk_rgstr_code            
     ,sbk_tier                  
     ,sbk_rltnshp_mngr          
     ,sbk_aplcnt_sts            
     ,sbk_lbl                   
     ,sbk_adtnl_phne            
     ,sbk_intrdcd               
     ,sbk_adrs_area             
     ,sbk_adrs_strt             
     ,sbk_adrs_flat             
     ,sbk_adrs_city             
     ,sbk_adrs_ste              
     ,sbk_adrs_pin              
     ,sbk_adrs_cntry            
     ,sbk_phne                  
     ,sbk_sbdc_flag             
     ,sbk_sourcecode            
     ,e_cmpltd                  
     ,createdate                
     ,modifydate                
     ,edittype                  
     ,sbk_blklsted              
     ,sbk_ex_acnt_name          
     ,sbk_amfi_nmbr             
     ,sbk_arnfrm_date           
     ,sbk_arnto_date            
     ,sbk_amfi_sts              
     ,sbk_amfilot_no            
     ,sbk_arnpay_date           
     ,sbk_mapin                 
     )    
     SELECT sbk_code                  
          , sbk_name                  
          , sbk_frst_name             
          , sbk_mdle_name             
          , sbk_last_name             
          , sbk_cntct                 
          , sbk_mble                  
          , sbk_fax                   
          , sbk_eml                   
          , sbk_url                   
          , sbk_ctgry                 
          , sbk_brnch_name            
          , sbk_pan                   
          , sbk_cntrl                 
          , sbk_mode_pay              
          , sbk_jng_date              
          , sbk_dp_id                 
          , sbk_clnt_id               
          , sbk_dp_clnt_id            
          , sbk_rgstr_code            
          , sbk_tier                  
          , sbk_rltnshp_mngr          
          , sbk_aplcnt_sts            
          , sbk_lbl                   
          , sbk_adtnl_phne            
          , sbk_intrdcd               
          , sbk_adrs_area             
          , sbk_adrs_strt             
          , sbk_adrs_flat             
          , sbk_adrs_city             
          , sbk_adrs_ste              
          , sbk_adrs_pin              
          , sbk_adrs_cntry            
          , sbk_phne                  
          , sbk_sbdc_flag             
          , sbk_sourcecode            
          , '1'                  
          , createdate                
          , getdate()                
          , edittype                  
          , sbk_blklsted              
          , sbk_ex_acnt_name          
          , sbk_amfi_nmbr             
          , sbk_arnfrm_date           
          , sbk_arnto_date            
          , sbk_amfi_sts              
          , sbk_amfilot_no            
          , sbk_arnpay_date           
          , sbk_mapin                 
      FROM  pms_mig    WITH (NOLOCK)    
      WHERE e_cmpltd = '1'    
      --    
      DELETE FROM pms_mig     
      WHERE e_cmpltd  = '1'    
   --    
   END    
   --    
   CREATE TABLE #clim    
   (crn          numeric    
   ,client_code  varchar(25)    
   ,name1        varchar(50)    
   ,name2        varchar(50)    
   ,name3        varchar(50)      
   ,sname        varchar(50)    
   ,enttm_cd     varchar(25)    
   ,ctgry        varchar(25)    
   ,createddt    varchar(11)    
   ,lstupddt     varchar(11)    
   ,modified     char(1)    
   )    
   --    
   IF  isnull(@pa_from_dt,'') <> '' AND isnull(@pa_to_dt,'') <> '' AND isnull(@pa_from_crn,'') <> '' AND isnull(@pa_to_crn,'') <> ''    
   BEGIN--1    
   --    
     INSERT INTO #clim    
     (crn             
     ,client_code     
     ,name1           
     ,name2           
     ,name3           
     ,sname           
     ,enttm_cd        
     ,ctgry           
     ,createddt       
     ,lstupddt        
     ,modified        
     )    
     SELECT clia.clia_crn_no   clia_crn_no    
           ,clia.clia_acct_no  clia_acct_no    
           ,clim_name1    
           ,clim_name2    
           ,clim_name3    
           ,clim_short_name    
           ,clim_enttm_cd    
           ,clim_clicm_cd    
           ,clia_created_dt
           ,clia_lst_upd_dt
           ,CASE WHEN clia_created_dt = clia_lst_upd_dt THEN 'I' ELSE 'U' END modified    
     FROM   client_mstr          clim   WITH (NOLOCK)    
           ,client_accounts      clia   WITH (NOLOCK)     
     WHERE  clim.clim_deleted_ind     = 1    
     AND    clia.clia_deleted_ind     = 1    
     AND    clim.clim_crn_no          = clia.clia_crn_no    
     AND    clia.clia_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'     
     AND    CONVERT(VARCHAR,clia.clia_crn_no) BETWEEN convert(numeric, @pa_from_crn)  AND  convert(numeric, @pa_to_crn)    
   --      
   END--1    
   --    
   IF  isnull(@pa_from_dt,'') <> '' AND isnull(@pa_to_dt,'') <> '' AND isnull(@pa_from_crn,'') = '' AND isnull(@pa_to_crn,'') = ''    
   BEGIN--2    
   --    
     INSERT INTO #clim    
     (crn             
     ,client_code     
     ,name1           
     ,name2           
     ,name3           
     ,sname           
     ,enttm_cd        
     ,ctgry           
     ,createddt       
     ,lstupddt        
     ,modified        
     )    
     --    
     SELECT clia.clia_crn_no   clia_crn_no    
           ,clia.clia_acct_no  clia_acct_no    
           ,clim_name1    
           ,clim_name2    
           ,clim_name3    
           ,clim_short_name    
           ,clim_enttm_cd    
           ,clim_clicm_cd    
           ,clia_created_dt
           ,clia_lst_upd_dt
           ,CASE WHEN clia_created_dt = clia_lst_upd_dt THEN 'I' ELSE 'U' END modified    
     FROM   client_mstr                 clim   WITH (NOLOCK)    
           ,client_accounts             clia   WITH (NOLOCK)     
     WHERE  clim.clim_deleted_ind     = 1    
     AND    clia.clia_deleted_ind     = 1    
     AND    clim.clim_crn_no          = clia.clia_crn_no    
     AND    clia.clia_lst_upd_dt        BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'     
   --      
   END--2    
   --    
   IF  isnull(@pa_from_dt,'') = '' AND isnull(@pa_to_dt,'') = '' AND isnull(@pa_from_crn,'') <> '' AND isnull(@pa_to_crn,'') <> ''    
   BEGIN--3    
   --    
     INSERT INTO #clim    
     (crn             
     ,client_code     
     ,name1           
     ,name2           
     ,name3           
     ,sname           
     ,enttm_cd        
     ,ctgry           
     ,createddt       
     ,lstupddt        
     ,modified        
     )    
     --    
     SELECT clia.clia_crn_no   clia_crn_no    
           ,clia.clia_acct_no  clia_acct_no    
           ,clim_name1    
           ,clim_name2    
           ,clim_name3    
           ,clim_short_name    
           ,clim_enttm_cd    
           ,clim_clicm_cd    
           ,clia_created_dt
           ,clia_lst_upd_dt
           ,CASE WHEN clia_created_dt = clia_lst_upd_dt THEN 'I' ELSE 'U' END modified    
     FROM   client_mstr          clim   WITH (NOLOCK)    
           ,client_accounts      clia   WITH (NOLOCK)     
     WHERE  clim.clim_deleted_ind     = 1    
     AND    clia.clia_deleted_ind     = 1    
     AND    clim.clim_crn_no          = clia.clia_crn_no    
     AND    CONVERT(VARCHAR,clia.clia_crn_no)  BETWEEN convert(numeric, @pa_from_crn)  AND  convert(numeric, @pa_to_crn)    
   --      
   END--3    
       
   --Addresses--    
   CREATE TABLE #addr(id       numeric              
                     ,code     varchar(25)              
                     ,add1     varchar(64)              
                     ,add2     varchar(64)              
                     ,add3     varchar(64)              
                     ,city     varchar(32)              
                     ,state    varchar(32)              
                     ,country  varchar(32)              
                     ,pin      numeric
                     )              
                         
   --entity_properties--    
   CREATE table #entity_properties              
   (id      numeric                 
   ,code    varchar(25)              
   ,value   varchar(50)              
   )              
       
   --contacts--              
   CREATE TABLE #conc(id       numeric               
                     ,code     varchar(20)              
                     ,value    varchar(24)                  
                     )              
       
   --    
   INSERT INTO #entity_properties              
   (id              
   ,code              
   ,value              
   )              
   SELECT entp_ent_id              
         ,entp_entpm_cd              
         ,entp_value               
   FROM   entity_properties                    
   WHERE  entp_ent_id           IN (SELECT distinct crn FROM #clim) --= @pa_crn_no              
   AND    entp_deleted_ind      = 1              
       
   --contacts              
   INSERT INTO #conc              
   (id              
   ,code              
   ,value                
   )    
   --    
   SELECT entac.entac_ent_id              
        , entac.entac_concm_cd              
        , conc.conc_value              
   FROM   contact_channels          conc    WITH (NOLOCK)              
        , entity_adr_conc           entac   WITH (NOLOCK)               
   WHERE  entac.entac_adr_conc_id = conc.conc_id              
   AND    entac.entac_ent_id     IN (SELECT distinct crn FROM #clim)              
   AND    conc.conc_deleted_ind   = 1              
   AND    entac.entac_deleted_ind = 1         
       
   --Addresses    
   INSERT INTO #addr              
   (id              
   ,code              
   ,add1              
   ,add2              
   ,add3              
   ,city              
   ,state              
   ,country              
   ,pin              
   )              
   SELECT entac.entac_ent_id              
        , convert(varchar, entac.entac_concm_cd)                   
        , convert(varchar, adr.adr_1)              
        , convert(varchar, adr.adr_2)              
        , convert(varchar, adr.adr_3)              
        , convert(varchar, adr.adr_city)              
        , convert(varchar, adr.adr_state)              
        , convert(varchar, adr.adr_country)              
   --     , isnull(convert(numeric, adr.adr_zip), 0)  
        ,0  
   FROM   addresses                 adr     WITH (NOLOCK)              
        , entity_adr_conc           entac   WITH (NOLOCK)              
   WHERE  entac.entac_adr_conc_id = adr.adr_id              
   AND    entac.entac_ent_id     IN (SELECT DISTINCT crn FROM #clim) --= @pa_crn_no              
   AND    adr.adr_deleted_ind     = 1              
   AND    entac.entac_deleted_ind = 1      
   --  
   SET @c_client_mstr      = CURSOR FAST_FORWARD FOR     
   SELECT crn             
        , client_code     
        , name1           
        , name2           
        , name3           
        , sname           
        , enttm_cd        
        , ctgry           
        , createddt       
        , lstupddt        
        , modified        
   FROM   #clim    
   --    
   OPEN @c_client_mstr    
   --    
   FETCH NEXT FROM  @c_client_mstr     
   INTO @clim_crn_no    
      , @l_clia_acct_no     
      , @clim_name1                                                                     --sbk_name, sbk_frst_name    
      , @clim_name2                                                                     --sbk_mdle_name    
      , @clim_name3                                                                     --sbk_last_name    
      , @clim_short_name      
      , @clim_enttm_cd    
      , @clim_clicm_cd                                                                  --sbk_ctgry      
      , @clim_created_dt                                                                --createddate    
      , @clim_lst_upd_dt                                                 --modifydate    
      , @modified                                                                       --edittype    
   --       
   WHILE @@FETCH_STATUS = 0      
   BEGIN--cursor      
   --    
     SET @l_code             = CONVERT(varchar(14), @l_clia_acct_no)    
     --
     SELECT @l_contt_person  = CONVERT(VARCHAR(100), value) FROM #entity_properties WHERE code = 'CONTACT_PERSON' AND id = @clim_crn_no --sbk_cntct    
     --
     SELECT @l_mobile        = ISNULL(value,0) FROM #conc WHERE code = 'MOBILE1' AND id = @clim_crn_no                                  --sbk_mble    
     --
     SELECT @l_fax1          = ISNULL(value,0) FROM #conc WHERE code = 'FAX1' AND id = @clim_crn_no                                     --sbk_fax    
     --
     SELECT @l_email         = ISNULL(convert(varchar(128), value),'') FROM #conc WHERE code = 'EMAIL1' AND id = @clim_crn_no           --sbk_eml    
     --    
     SET @l_URL              = ''                                                                                                       --sbk_url    
     --***----    
     SET @l_bank_branch      = ISNULL(CONVERT(VARCHAR(32), citrus_usr.fn_to_get_enttm_shortname(@clim_crn_no,@l_clia_acct_no,@clim_enttm_cd)),'') -- sbk_brnch_name    
     --***----    
     SELECT @l_pan_gir       = ISNULL(CONVERT(VARCHAR(64), value),'') FROM #entity_properties WHERE code = 'PAN_GIR_NO' AND id = @clim_crn_no      --sbk_pan    
     --    
     SET @l_cntrl            = 0                                                                                                        --sbk_cntrl    
     --    
     SELECT @l_mode_pay      = CONVERT(VARCHAR(32), value) FROM #entity_properties WHERE code = 'PAY_MODE' AND id = @clim_crn_no        --sbk_pay_mode    
     --    
     SET @l_jng_date         = convert(datetime,getdate())
     --    
     SET @l_split_val        = ''    
     --    
     SET @l_split_val        = citrus_usr.fn_ucc_dp_dtls(@clim_crn_no, @l_clia_acct_no)    
     --    
     SELECT @l_dp_id         = ISNULL(CONVERT(VARCHAR(64), citrus_usr.fn_splitval(@l_split_val,1)),'')                                  --sbk_dp_id    
          , @l_clnt_id       = ISNULL(CONVERT(VARCHAR(64), citrus_usr.fn_splitval(@l_split_val,2)),'')                                                                                                       --sbk_clnt_id     
     --         
     SET @l_dp_clnt_id       = ISNULL(@l_dp_id,'')+ISNULL(@l_clnt_id,'')                                                                --sbk_dp_clnt_id       
     --    
     SET @l_rgstr_code       = ''                                                                                                       --sbk_rgstr_code     
     --    
     SET @l_tier             = ''                                                                                                       --sbk_tier    
     --     
     SET @l_rm               = ISNULL(CONVERT(VARCHAR(32), citrus_usr.fn_to_get_entm_id(@clim_crn_no ,@l_clia_acct_no ,'RM')),'')     
     --    
     SET @l_aplcnt_sts       = CONVERT(VARCHAR(32), @clim_clicm_cd)                                                                     --sbk_aplcnt_sts    
     --    
     SELECT @l_label         = CONVERT(VARCHAR(64), value) FROM #entity_properties WHERE code = 'LABEL' AND id = @clim_crn_no           --sbk_lbl    
     --  
     SELECT @l_adnl_phone    = ISNULL(CONVERT(VARCHAR, value),'') FROM #conc WHERE code = 'RES_PH1' AND id = @clim_crn_no                                  --sbk_adtnl_phne    
     --  
     SELECT @l_intrdcd       = CONVERT(VARCHAR(96), value) FROM #entity_properties WHERE code = 'INTRODUCER_ID' AND id = @clim_crn_no   --sbk_intrdcd    
     --  
     SELECT @l_adrs_flat     = CONVERT(VARCHAR(64), add1)        --sbk_adrs_flat    
          , @l_adrs_strt     = CONVERT(VARCHAR(64), add2)        --sbk_adrs_strt    
          , @l_adrs_area     = CONVERT(VARCHAR(64), add3)        --sbk_adrs_area    
          , @l_adrs_city     = CONVERT(VARCHAR(32), city)        --sbk_adrs_city    
          , @l_adrs_ste      = CONVERT(VARCHAR(32), state)       --sbk_adrs_ste    
          , @l_adrs_cntry    = CONVERT(VARCHAR(32), country)     --sbk_adrs_cntry    
          , @l_adrs_pin      = isnull(pin,0)                               --sbk_adrs_pin    
     FROM   #addr                 
     WHERE  code             = 'COR_ADR1'              
     AND    id               = @clim_crn_no         
     --
     print convert(varchar, @l_adrs_pin)  
     SELECT @l_phne          = isnull(convert(varchar(32), value),'') FROM #conc WHERE code = 'OFF_PH1' AND id = @clim_crn_no      --sbk_phne    
     --    
     SET @l_sbdc_flag        = ''                                 --sbk_sbdc_flag    
     --    
     SET @l_sourcecode       = ''                                 --sbk_sourcecode    
     --    
     SET @l_cmpltd           = '0'                                --e_cmpltd    
     --    
     SET @l_blcklstd         =  ''                                --sbk_blcklstd     
     --    
     SET @l_ex_acnt_name     = ''                                 --sbk_exacnt_name    
     --    
     SET @l_amfi_nmbr        =  ''                                --sbk_amfi_nmbr     
     --    
     SET @l_arnfrm_date      =  NULL                                --sbk_arnfrm_date    
     --                                  
     SET @l_arnto_date       =  NULL                                --sbk_arnto_date                               
     --    
     SET @l_amfi_sts         =  ''                                --sbk_amfi_sts     
     --    
     SET @l_amfilot_no       = ''                                 --sbk_amfilot_no     
     --    
     SET @l_arnpa_date       =  NULL                                --sbk_arnpa_date    
     --    
     SELECT @l_mapin         = CONVERT(VARCHAR(9), value) FROM #entity_properties WHERE code = 'MAPIN_ID' AND id = @clim_crn_no      --sbk_mapin    
     --  
     INSERT INTO PMS_MIG    
     (sbk_code             
     ,sbk_name             
     ,sbk_frst_name        
     ,sbk_mdle_name        
     ,sbk_last_name        
     ,sbk_cntct            
     ,sbk_mble             
     ,sbk_fax              
     ,sbk_eml              
     ,sbk_url              
     ,sbk_ctgry            
     ,sbk_brnch_name       
     ,sbk_pan              
     ,sbk_cntrl            
     ,sbk_mode_pay         
     ,sbk_jng_date         
     ,sbk_dp_id            
     ,sbk_clnt_id          
     ,sbk_dp_clnt_id       
     ,sbk_rgstr_code       
     ,sbk_tier             
     ,sbk_rltnshp_mngr     
     ,sbk_aplcnt_sts       
     ,sbk_lbl              
     ,sbk_adtnl_phne       
     ,sbk_intrdcd          
     ,sbk_adrs_area        
     ,sbk_adrs_strt        
     ,sbk_adrs_flat        
     ,sbk_adrs_city        
     ,sbk_adrs_ste         
     ,sbk_adrs_pin         
     ,sbk_adrs_cntry       
     ,sbk_phne             
     ,sbk_sbdc_flag        
     ,sbk_sourcecode       
     ,e_cmpltd             
     ,createdate           
     ,modifydate           
     ,edittype             
     ,sbk_blklsted         
     ,sbk_ex_acnt_name     
     ,sbk_amfi_nmbr        
     ,sbk_arnfrm_date      
     ,sbk_arnto_date       
     ,sbk_amfi_sts         
     ,sbk_amfilot_no       
     ,sbk_arnpay_date      
     ,sbk_mapin         
     )    
     VALUES    
     (@l_code     
     ,@clim_short_name    
     ,@clim_name1    
     ,@clim_name2    
     ,@clim_name3    
     ,@l_contt_person    
     ,@l_mobile     
     ,@l_fax1    
     ,@l_email    
     ,@l_URL    
     ,@clim_clicm_cd    
     ,@l_bank_branch    
     ,@l_pan_gir    
     ,@l_cntrl    
     ,@l_mode_pay    
     ,@l_jng_date    
     ,@l_dp_id    
     ,@l_clnt_id    
     ,@l_dp_clnt_id    
     ,@l_rgstr_code    
     ,@l_tier    
     ,@l_rm    
     ,@l_aplcnt_sts    
     ,@l_label    
     ,@l_adnl_phone    
     ,@l_intrdcd    
     ,@l_adrs_area    
     ,@l_adrs_strt    
     ,@l_adrs_flat    
     ,@l_adrs_city    
     ,@l_adrs_ste    
     ,@l_adrs_pin    
     ,@l_adrs_cntry   
     ,@l_phne    
     ,@l_sbdc_flag    
     ,@l_sourcecode    
     ,@l_cmpltd    
     ,@clim_created_dt
     ,@clim_lst_upd_dt
     ,@modified    
     ,@l_blcklstd    
     ,@l_ex_acnt_name    
     ,@l_amfi_nmbr    
     ,@l_arnfrm_date    
     ,@l_arnto_date    
     ,@l_amfi_sts    
     ,@l_amfilot_no    
     ,@l_arnpa_date    
     ,@l_mapin    
     )    
     --
     SET @pa_error = convert(varchar, @@rowcount)    
     --    
     SET @l_code          = NULL    
     SET @l_short_name    = NULL    
     SET @clim_name1      = NULL    
     SET @clim_name1      = NULL    
     SET @clim_name2      = NULL    
     SET @clim_name3      = NULL    
     SET @l_contt_person  = NULL    
     SET @l_mobile        = NULL    
     SET @l_fax1          = NULL    
     SET @l_email         = NULL    
     SET @l_URL           = NULL    
     SET @clim_clicm_cd   = NULL    
     SET @l_bank_branch   = NULL    
     SET @l_pan_gir       = NULL    
     SET @l_cntrl         = NULL    
     SET @l_mode_pay      = NULL    
     SET @l_jng_date      = NULL    
     SET @l_dp_id         = NULL    
     SET @l_clnt_id       = NULL    
     SET @l_dp_clnt_id    = NULL    
     SET @l_rgstr_code    = NULL    
     SET @l_tier          = NULL    
     SET @l_rm            = NULL    
     SET @l_aplcnt_sts    = NULL    
     SET @l_label         = NULL    
     SET @l_adnl_phone    = NULL    
     SET @l_intrdcd       = NULL    
     SET @l_adrs_area     = NULL    
     SET @l_adrs_strt     = NULL    
     SET @l_adrs_flat     = NULL    
     SET @l_adrs_city     = NULL    
     SET @l_adrs_ste      = NULL    
     SET @l_adrs_pin      = 0    
     SET @l_adrs_cntry    = NULL    
     SET @l_phne          = NULL    
     SET @l_sbdc_flag     = NULL    
     SET @l_sourcecode    = NULL    
     SET @l_cmpltd        = NULL    
     SET @clim_created_dt = NULL    
     SET @clim_lst_upd_dt = NULL    
     SET @modified        = NULL    
     SET @l_blcklstd      = NULL    
     SET @l_ex_acnt_name  = NULL    
     SET @l_amfi_nmbr     = NULL    
     SET @l_arnfrm_date   = NULL    
     SET @l_arnto_date    = NULL    
     SET @l_amfi_sts      = NULL    
     SET @l_amfilot_no    = NULL    
     SET @l_arnpa_date    = NULL    
     SET @l_mapin         = NULL    
     --    
     FETCH NEXT FROM  @c_client_mstr     
     INTO @clim_crn_no    
        , @l_clia_acct_no     
        , @clim_name1                                                                        
        , @clim_name2                                                                        
        , @clim_name3                                                                        
        , @clim_short_name    
        , @clim_enttm_cd    
        , @clim_clicm_cd                                                                     
        , @clim_created_dt                                                                  
        , @clim_lst_upd_dt                                                                  
        , @modified                                                                         
   --    
   END--cursor    
   --    
   CLOSE @c_client_mstr     
   DEALLOCATE @c_client_mstr    
   --    
   SELECT * FROM PMS_MIG    
--       
END

GO
