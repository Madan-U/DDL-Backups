-- Object: PROCEDURE citrus_usr.pr_audittrail_dp
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

/*
alter table dp_Acct_mstr_hst add dpam_subcm_cd varchar(10)
alter table dp_Acct_mstr_hst add dpam_batch_no varchar(10)
alter table dp_holder_dtls_hst add  dphd_nomGAU_fname varchar(100)
select * from dp_mstr
*/
--[pr_audittrail_dp] 'NSDL','08/08/2008','08/08/2008','10000004','10000004','',4,'N',''
CREATE PROCEDURE [citrus_usr].[pr_audittrail_dp]
                            (              
                              @pa_exch        VARCHAR(10)                  
                            , @pa_from_dt     VARCHAR(11)                  
                            , @pa_to_dt       VARCHAR(11)                  
                            , @pa_from_acct   VARCHAR(16)                  
                            , @pa_to_acct     VARCHAR(16)                  
                            , @pa_tab         CHAR(3)  
                            , @PA_EXCSM_ID    NUMERIC  
                            , @pa_all_yn      char(1)
                            , @pa_ref_cur     VARCHAR(8000) OUTPUT                  
                             )                  
AS                  
/*                  
*********************************************************************************                  
 SYSTEM         : CITRUS                  
 MODULE NAME    : PR_IMPORT_DP                  
 DESCRIPTION    : THIS PROCEDURE WILL CONTAIN THE MAKER CHECKER FACILITY FOR STATUS MASTER                  
 COPYRIGHT(C)   : MARKETPLACE TECHNOLOGIES PVT LTD                  
 VERSION HISTORY: 1.0                  
 VERS.  AUTHOR            DATE          REASON                  
 -----  -------------     ------------  --------------------------------------------------                  
 2.0    TUSHAR            17-aug-2007   VERSION.                  
-----------------------------------------------------------------------------------*/                  
BEGIN                  
--                  
            
                       
                       
    DECLARE @c_cursor            cursor      
    declare @l_nom_gua_ind       varchar(3)      
           ,@l_nom_gua_name      varchar(500)      
           ,@l_mapin             varchar(10)                                                  
           , @l_sms              char(1)      
           , @l_secondmapin      varchar(10)                                                           
           , @l_secondsms        char(1)                                                                        
           , @l_thirdmapin       varchar(10)                                                                  
           , @l_thirdsms         char(1)      
           , @l_thirdemail       varchar(50)      
           , @l_fh_panflag       varchar(10)      
           , @l_rbi_appdate      datetime      
           , @l_authid           char(8)      
           , @l_counter         NUMERIC  
           , @L_DPM_ID           BIGINT  
    --            
    DECLARE @@rm_id              VARCHAR(8000)                    
          , @@cur_id             VARCHAR(8000)                    
          , @@foundat            INT                    
          , @@delimeterlength    INT                   
          , @@delimeter          CHAR(1)               
          , @c_crn_no            numeric                     
          , @c_dpam_id           numeric                                                                   
          , @c_acct_no           varchar(25)                                                                     
          , @c_sba_no            varchar(20)          
          , @l_crn_no            NUMERIC                  
          , @l_acct_no           VARCHAR(25)                    
          , @l_Value   VARCHAR(8000)                  
          , @l_client_type       VARCHAR(100)                  
          , @l_chk               NUMERIC                  
          , @l_ctgry_chk         NUMERIC                        
                                             
  IF @pa_exch = 'NSDL'                  
  BEGIN                  
  --                  
    --SET @l_chk = case @pa_type WHEN 'ALL' THEN '4' WHEN 'Non House' THEN '02' WHEN 'House' THEN '01' WHEN 'Clearing Member' THEN '03' END                  
    SET @l_chk = 4                  
    --              
    CREATE TABLE #l_values(dp_string VARCHAR(8000), sign_path varchar(8000),fhd_sign VARCHAR(500),shd_sign VARCHAR(500),thd_sign VARCHAR(500), sba_no varchar(20))                  
    --              
    CREATE TABLE #ctgry_nh1(clicm_desc varchar(50))                  
    --      
    --           
    INSERT INTO #ctgry_nh1 values('FI FII CORPORATES')                  
    --            
                
    CREATE TABLE #ctgry_nh2(clicm_desc varchar(50))                  
    --    
    CREATE table #NO_SIGN_TEMP  
    (dpam_sba_no VARCHAR(25)  
    ,NO_OF_FH VARCHAR(2)  
    ,NO_OF_SH VARCHAR(2)  
    ,NO_OF_TH VARCHAR(2))          
          
      
    --              
    INSERT INTO #ctgry_nh2 values('INDIVIDUAL')                  
      
    --              
    DECLARE @l_dp_pri_dtls table(--ln_number         numeric                 
     --ben_acct_ctgr     VARCHAR(20)                  
      entity_type_desc  VARCHAR(50)                  
    , ctgry_desc        VARCHAR(50)                  
    , ben_type          VARCHAR(20)                  
    , ben_sub_type      VARCHAR(20)                  
    , ben_short_name    VARCHAR(16)                  
    , fh_name           VARCHAR(45)                  
    , sh_name           VARCHAR(45)                  
    , th_name           VARCHAR(45)                  
    --, addr_pref_flg     CHAR(1)                  
    , PAN_NO            CHAR(10)                  
    , sh_pan            CHAR(10)                  
    , th_pan            CHAR(10)                
    , stan_instr_ind    CHAR(1)                  
    , ben_bank_acct_no  VARCHAR(30)                  
    , ben_bank_name     VARCHAR(35)                  
    , ben_rbi_ref_no    VARCHAR(50)                  
    , ben_rbi_app_dt    DATETIME                  
    , ben_sebi_reg_no   VARCHAR(24)                  
    , ben_tax_ded_sts   VARCHAR(20)                  
    , local_addr        CHAR(1)                  
    --, bank_addr         CHAR(1)                  
    , nom_gur_addr      CHAR(1)                  
    , min_nom_g_addr    CHAR(1)                  
    , for_cor_addr      CHAR(1)                  
    , no_of_fh_at       varchar(2)                  
    , no_of_sh_at       varchar(2)                
    , no_of_th_at       varchar(2)                
    --, size_of_sign      VARCHAR(5)                  
    , send_ref_no1      VARCHAR(35)                  
    , send_ref_no2      VARCHAR(35)                  
    --, micr_cd       VARCHAR(9)                  
    , bank_acct_type    VARCHAR(20)                  
    , fh_email          VARCHAR(50)                  
    , fh_map_id         VARCHAR(9)                  
    , fh_mob_no         VARCHAR(11)                  
    , fh_sms_fac        CHAR(1)                  
    , fh_poa_fac        CHAR(1)                  
    , fh_pan_flg        CHAR(1)                  
    , sh_email          VARCHAR(50)                  
    , sh_map_id         VARCHAR(9)                  
    , sh_mob_no         VARCHAR(11)                  
    , sh_sms_fac        CHAR(1)                  
    , sh_pan_flg        CHAR(1)                  
    , th_email          VARCHAR(50)                  
    , th_map_id         VARCHAR(9)                  
    , th_mob_no         VARCHAR(11)                  
    , th_sms_fac        CHAR(1)                  
    , th_pan_flg        CHAR(1)                  
    , ben_occupation    VARCHAR(20) --NUMERIC                  
    , fh_fth_hus_name   VARCHAR(45)                  
    , sh_fth_hus_name   VARCHAR(45)                  
    , th_fth_hus_name   VARCHAR(45)                  
    , nom_gur_ind       CHAR(1)                  
    , nom_gur_name      VARCHAR(45)                  
    , nom_min_ind       CHAR(1)                  
    , min_nom_gur_name  VARCHAR(45)                  
    , dob_min           DATETIME                   
    , don_min_nom       DATETIME                  
    , corr_bp_id        VARCHAR(8)                  
    , dpam_created_dt   DATETIME 
    , clim_lst_upd_by   varchar(50)                 
    , dpam_lst_upd_dt   DATETIME                  
    , dpam_sign_path    varchar(8000)                  
    , dpam_fholder_sign VARCHAR(500)                  
    , dpam_sholder_sign VARCHAR(500)                  
    , dpam_tholder_sign VARCHAR(500)   
    , clim_lst_upd_dt   DATETIME
    )                  
    --      
      
    
      
      If ltrim(rtrim(isnull(@l_thirdsms,'') ))   = ''  set @l_thirdsms = 'N'       
      --                 
--vishal  

if @pa_all_yn = 'N'
begin
--
 
       INSERT INTO @l_dp_pri_dtls(    
         entity_type_desc                  
        , ctgry_desc                  
        --, ben_type                            
        --, ben_sub_type                        
        , ben_short_name                      
        , fh_name                             
        , sh_name                             
        , th_name                             
        --, addr_pref_flg                       
        , PAN_NO                                   
        , sh_pan                              
        , th_pan                              
        , stan_instr_ind                      
        , ben_bank_acct_no                    
        , ben_bank_name                       
        , ben_rbi_ref_no                      
        , ben_rbi_app_dt                      
        , ben_sebi_reg_no                     
        , ben_tax_ded_sts                     
        --, local_addr                          
        --, bank_addr                           
        --, nom_gur_addr                        
        --, min_nom_g_addr                      
        --, for_cor_addr                        
        , send_ref_no1                        
        , send_ref_no2                        
        --, micr_cd                             
        , bank_acct_type                      
        , fh_email                
        , fh_map_id                           
        , fh_mob_no                           
        , fh_sms_fac                          
        , fh_poa_fac                          
        --, fh_pan_flg                          
        , sh_email                            
        , sh_map_id                           
        , sh_mob_no                           
        , sh_sms_fac                          
        --, sh_pan_flg                          
        , th_email                            
        , th_map_id                           
        , th_mob_no                           
        , th_sms_fac                          
        --, th_pan_flg                          
        , ben_occupation                      
        , fh_fth_hus_name                     
        , sh_fth_hus_name                     
        , th_fth_hus_name                     
        , nom_gur_ind                         
        , nom_gur_name                        
        , nom_min_ind                         
        , min_nom_gur_name                    
        , dob_min                             
        , don_min_nom                         
        , corr_bp_id                          
        , dpam_created_dt 
        , clim_lst_upd_by                    
        , dpam_lst_upd_dt                  
        , dpam_sign_path                  
        , dpam_fholder_sign                   
        , dpam_sholder_sign                   
        , dpam_tholder_sign
        , clim_lst_upd_dt                       
        )  

        SELECT   TOP 1                                                                                                                --beneficiary account category '02'                  
              convert(varchar(50),enttm.enttm_desc)                  
             , convert(varchar(50),clicm.clicm_desc)                  
             --, convert(varchar(20),isnull(left(subcm.subcm_cd,2),'00')) --beneficiary  type          
             --, convert(varchar(20),isnull(right(subcm.subcm_cd,2),'00'))                                                                             --beneficiary sub type                                                              
             , convert(char(16),dpam_sba_name)                                                                                      --beneficiary short name                                                          
             , convert(char(45),dpam_sba_name) --isnull(convert(char(45),clim.clim_name1+' ' + ISNULL(clim.clim_name2,'') + ' ' +  ISNULL(clim.clim_name3,'')),'')           --beneficiary first holder name                  
             , isnull(convert(char(45),dphd.dphd_sh_fname + ' ' + ISNULL(dphd.dphd_sh_mname,'') + ' ' + ISNULL(dphd.dphd_sh_lname,'')),'') --beneficiary second holder name                   
             , isnull(convert(char(45),dphd.dphd_th_fname + ' ' + ISNULL(dphd.dphd_th_mname,'') + ' ' + ISNULL(dphd.dphd_th_lname,'')),'') --beneficiary third holder name                  
             --, 'Y'   --convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                                  --address preference flag                   
             , convert(char(10),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),''))                                       --First holder pan                  
             , convert(char(10),ISNULL(dphd.dphd_sh_pan_no,''))                                                                            --second holder pan                  
             , convert(char(10),ISNULL(dphd.dphd_th_pan_no,''))                                                                            --third holder pan                  
             , 'Y'--case when convert(char(1),ISNULL(citrus_usr.fn_ucc_accp(clim.clim_crn_no,'STAN_INS_IND',''),'')) in ('','0') then 'N' else 'Y'  end                                                --standing instruction indicator                  
             , convert(char(30),ISNULL(cliba.cliba_ac_no,''))                                                                              --bank account no                   
             , convert(char(35),ISNULL(banm.banm_name ,''))                                                                                --bank name                   
             , convert(char(50),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'RBI_REF_NO',''),''))   --benrficiary rbi reference no --50                  
             , convert(char(8),ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RBI_REF_NO','RBI_APP_DT',''),''))                                              --benrficiary rbi approval date --8                  
             , convert(char(24),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'SEBI_REGN_NO',''),''))                                                 --beneficiary sebi registration no --24                  
             , citrus_usr.fn_get_listing('TAX_DEDUCTION',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'TAX_DEDUCTION',''),''))  --benef_tax_ded_sta                                                                      --tax deduction status --20             
     
             --, 'Y'                                                                                                      --local addr???                  
             --, 'Y'                                                                                                                         --bank addr???                    
             --, case when (citrus_usr.[fn_acct_addr_value](dpam_id,'NOMINEE_ADR1') <> '' or citrus_usr.[fn_acct_addr_value](dpam_id,'GUARD_ADR') <> '' )  then 'Y' else 'N' end                                         --minor nominee addr???                     
             --, case when citrus_usr.[fn_acct_addr_value](dpam_id,'NOM_GUARDIAN_ADDR') <> '' then 'Y' else 'N' end
             --,  CASE WHEN citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'FH_ADR1'),''),1) <> '' THEN 'Y'   ELSE 'N' END  
             , convert(char(35),DPAM.dpam_sba_no)                                                                                                        --sender ref no 1                  
             , convert(char(35),'')                                                                                                        --sender ref no 2                  
             ---, convert(char(9),ISNULL(citrus_usr.fn_acct_entp(dpam.dpam_id,'BENMICR'),''))
             , CASE WHEN convert(char(20),cliba_ac_type) IN( 'SAVINGS', 'SAVING')  THEN '10' WHEN convert(char(20),cliba_ac_type) IN('CURRENT') THEN  '11' WHEN convert(char(20),cliba_ac_type) IN( 'OTHERS') THEN  '13' END   --'11'                                                                                          --bank acct type                  
             , convert(char(50),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'EMAIL1'),''))                                                  --email id for first holder            
             , convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'MAPIN_ID',''),''))                                  --map in id of first holder   --9                  
             , convert(char(11),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'MOBILE1'),''))                                                   --mobile no of first holder  --12                  
             , CASE WHEN (convert(char(11),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'MOBILE1'),'')) <> '' AND  convert(char(1),ISNULL(citrus_usr.fn_ACCT_entp(DPAM_ID,'SMS_FLAG'),''))= 1)   THEN 'Y' 
               WHEN (convert(char(11),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'MOBILE1'),'')) <> '' AND  convert(char(1),ISNULL(citrus_usr.fn_ACCT_entp(DPAM_ID,'SMS_FLAG'),''))= '')   THEN 'N' ELSE ' ' END 
             , convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                                  --poa facility                  
             --, CASE WHEN convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),''))  <> '' THEN 'Y' ELSE 'N' END                                                --pan flag for first holder                  
             , convert(char(50),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'SH_POA_MAIL'),''))                                                  --email id for second holder                  
             , ''--convert(char(9),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                                  --map in id of second holder   --9                  
             , convert(CHAR(12),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'SH_POA_MOB'),''))                                           --mobile no of second holder  --12                  
             , ''--convert(char(1),'')                                                                                                         --sms facility for sh                  
             --, CASE WHEN ISNULL(dphd_sh_pan_no,'') = '' THEN '' ELSE 'Y' END  --convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_',''),''))                                                  --pan flag for second holder                 
 
             , convert(char(50),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'TH_POA_MAIL'),''))                                                  --email id for third holder                  
             , ''--convert(char(9),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                                  --map in id of third holder   --9                  
             , convert(CHAR(12),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'TH_POA_MOB'),''))                                           --mobile no of third holder  --12                  
             , ''--convert(char(1),'')                                                                               --sms facility for th                  
             --, CASE WHEN ISNULL(dphd_th_pan_no,'') = '' THEN '' ELSE 'Y' END  --convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))   --pan flag for third holder                  
             , citrus_usr.fn_get_listing_NSDL('occupation',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'occupation',''),''))  --1--convert(NUMERIC,ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                               --benifi  BEN_OCCUPATION                  
             , convert(char(45),ISNULL(dphd.dphd_Fh_fthname,''))                                         --benifi father/husband name                  
             , convert(char(45),ISNULL(dphd.dphd_sh_fthname,''))                                                                           --sh father/husband name                  
             , convert(char(45),ISNULL(dphd.dphd_th_fthname,''))                                                                           --th father/husband name                  
             , case when isnull(dphd_nom_fname,'') <> '' then 'N' when isnull(dphd_gau_fname,'') <> '' then 'G' else ' ' end  --convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                                 --nom-gur indicator          
             , case when isnull(dphd_nom_fname,'') <> '' then isnull(dphd_nom_fname,'')  when isnull(dphd_gau_fname,'') <> '' then isnull(dphd_gau_fname,'') else '' end    
             , CASE WHEN (isnull(dphd_nom_fname,'') <> '' AND DATEDIFF(YEAR, CONVERT(DATETIME,DPHD_NOM_DOB,103), CONVERT(DATETIME,GETDATE(),103)) < 18 )   THEN 'Y' ELSE ' ' END                                               --nom-min indicator             
     
             , ISNULL(dphd_nomGAU_fname,'')--min nom gurdian name                  
             --, CASE when isnull(dphd_gau_fname,'') <> '' then   convert(datetime, dphd_nom_dob,103) END            
			 , CASE when isnull(dphd_gau_fname,'') <> '' then   convert(datetime, clim_dob,103) END 
             , CASE WHEN (isnull(dphd_nom_fname,'') <> '' AND DATEDIFF(YEAR, CONVERT(DATETIME,DPHD_NOM_DOB,103), CONVERT(DATETIME,GETDATE(),103)) < 18 ) THEN CONVERT(DATETIME,dphd_nomgau_fname) end  
             , convert(char(8),ISNULL(citrus_usr.fn_ucc_accp(clim.clim_crn_no,'CMBP_ID',''),''))                                                  --corresponding bp id                  
             , dpam.dpam_created_dt
             , clim.clim_lst_upd_by                      
             , dpam.dpam_lst_upd_dt                  
             , ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_BO','NSDL'),'')                                                                    
             , case when clim.clim_name1 <> '' then '11'+ convert(varchar(135),clim.clim_name1+' ' + ISNULL(clim.clim_name2,'') + ' ' +  ISNULL(clim.clim_name3,''))  end                  
             , case when isnull(dphd.dphd_sh_fname,'') <> '' then '12'+convert(char(135),isnull(dphd.dphd_sh_fname,'') + ' ' + ISNULL(dphd.dphd_sh_mname,'') + ' ' + ISNULL(dphd.dphd_sh_lname,'')) else convert(char(135),' ')end                  
             , case when isnull(dphd.dphd_th_fname,'') <> '' then '13'+convert(char(45),isnull(dphd.dphd_th_fname,'') + ' ' + ISNULL(dphd.dphd_th_mname,'') + ' ' + ISNULL(dphd.dphd_th_lname,'')) else convert(char(135),' ') end                  
             , clim_lst_upd_dt 
             
        FROM   dp_acct_mstr              dpam      
               left outer  join  
               dp_holder_dtls            dphd                  on dpam.dpam_id            = dphd.dphd_dpam_id             
               left outer join  
               client_bank_accts         cliba                 on dpam.dpam_id            = cliba.cliba_clisba_id   
               left outer join  
               bank_mstr                 banm                  on cliba.cliba_banm_id     = banm.banm_id     
           ,   client_mstr               clim                   
           ,   entity_type_mstr          enttm                  
           ,   client_ctgry_mstr         clicm    
        WHERE  clim_lst_upd_dt        BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
        AND    dpam_sba_no            BETWEEN CONVERT(VARCHAR,@pa_from_acct) AND CONVERT(VARCHAR,@pa_to_acct)
        and    dpam.dpam_crn_no        = clim.clim_crn_no                   
        AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
        AND    dpam.dpam_clicm_cd      = clicm.clicm_cd         
        AND    dpam.dpam_deleted_ind   = 1 
        AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
        AND    isnull(clim.clim_deleted_ind,1)   = 1                  
        AND    isnull(cliba.cliba_deleted_ind,1) = 1    
        AND    isnull(banm.banm_deleted_ind,1)   = 1                  
        AND    enttm.enttm_cd in ('01','02','03')                  
        

        UNION               
  
        SELECT   TOP 1                                                                                                            --beneficiary account category '02'                  
              convert(varchar(50),enttm.enttm_desc)                  
             , convert(varchar(50),clicm.clicm_desc)                  
             --, convert(varchar(20),isnull(left(subcm.subcm_cd,2),'00')) --beneficiary  type          
             --, convert(varchar(20),isnull(right(subcm.subcm_cd,2),'00'))                                                                             --beneficiary sub type                                                              
             , convert(char(16),dpam_sba_name)                                                                                      --beneficiary short name                                                          
             , convert(char(45),dpam_sba_name) --isnull(convert(char(45),clim.clim_name1+' ' + ISNULL(clim.clim_name2,'') + ' ' +  ISNULL(clim.clim_name3,'')),'')           --beneficiary first holder name                  
             , isnull(convert(char(45),dphd.dphd_sh_fname + ' ' + ISNULL(dphd.dphd_sh_mname,'') + ' ' + ISNULL(dphd.dphd_sh_lname,'')),'') --beneficiary second holder name                   
             , isnull(convert(char(45),dphd.dphd_th_fname + ' ' + ISNULL(dphd.dphd_th_mname,'') + ' ' + ISNULL(dphd.dphd_th_lname,'')),'') --beneficiary third holder name                  
             --, 'Y'   --convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                                  --address preference flag                   
             , convert(char(10),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO_HST',''),''))                                       --First holder pan                  
             , convert(char(10),ISNULL(dphd.dphd_sh_pan_no,''))                                                                            --second holder pan                  
             , convert(char(10),ISNULL(dphd.dphd_th_pan_no,''))                                                                            --third holder pan                  
             , 'Y'--case when convert(char(1),ISNULL(citrus_usr.fn_ucc_accp(clim.clim_crn_no,'STAN_INS_IND',''),'')) in ('','0') then 'N' else 'Y'  end                                                --standing instruction indicator                  
             , convert(char(30),ISNULL(cliba.cliba_ac_no,''))                                                                              --bank account no                   
             , convert(char(35),ISNULL(banm.banm_name ,''))                                                                                --bank name                   
             , convert(char(50),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'RBI_REF_NO',''),''))   --benrficiary rbi reference no --50                  
             , convert(char(8),ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RBI_REF_NO','RBI_APP_DT',''),''))                                              --benrficiary rbi approval date --8                  
             , convert(char(24),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'SEBI_REGN_NO',''),''))                                                 --beneficiary sebi registration no --24                  
             , citrus_usr.fn_get_listing('TAX_DEDUCTION',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'TAX_DEDUCTION',''),''))  --benef_tax_ded_sta                                                                      --tax deduction status --20             
     
             --, 'Y'                                                                                                      --local addr???                  
             --, 'Y'                                                                                                                         --bank addr???                    
             --, case when (citrus_usr.[fn_acct_addr_value](dpam_id,'NOMINEE_ADR1') <> '' or citrus_usr.[fn_acct_addr_value](dpam_id,'GUARD_ADR') <> '' )  then 'Y' else 'N' end                                         --minor nominee addr???                     
             --, case when citrus_usr.[fn_acct_addr_value](dpam_id,'NOM_GUARDIAN_ADDR') <> '' then 'Y' else 'N' end
             --,  CASE WHEN citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'FH_ADR1'),''),1) <> '' THEN 'Y'  ELSE 'N' END  
             , convert(char(35),DPAM.dpam_sba_no)                                                                                                        --sender ref no 1                  
             , convert(char(35),'')                                                                                                        --sender ref no 2                  
             --, convert(char(9),ISNULL(citrus_usr.fn_acct_entp(dpam.dpam_id,'BENMICR'),''))
             , CASE WHEN convert(char(20),cliba_ac_type) IN( 'SAVINGS', 'SAVING')  THEN '10' WHEN convert(char(20),cliba_ac_type) IN('CURRENT') THEN  '11' WHEN convert(char(20),cliba_ac_type) IN( 'OTHERS') THEN  '13' END   --'11'                                                                                          --bank acct type                  
             , convert(char(50),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'EMAIL1'),''))                                                  --email id for first holder            
             , convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'MAPIN_ID',''),''))                                  --map in id of first holder   --9                  
             , convert(char(11),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'MOBILE1'),''))                                                   --mobile no of first holder  --12                  
             , CASE WHEN (convert(char(11),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'MOBILE1'),'')) <> '' AND  convert(char(1),ISNULL(citrus_usr.fn_ACCT_entp(DPAM_ID,'SMS_FLAG'),''))= 1)   THEN 'Y' 
               WHEN (convert(char(11),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'MOBILE1'),'')) <> '' AND  convert(char(1),ISNULL(citrus_usr.fn_ACCT_entp(DPAM_ID,'SMS_FLAG'),''))= '')   THEN 'N' ELSE ' ' END 
             , convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                                  --poa facility                  
             --, CASE WHEN convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),''))  <> '' THEN 'Y' ELSE 'N' END                                                --pan flag for first holder                  
             , convert(char(50),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'SH_POA_MAIL'),''))                                                  --email id for second holder                  
             , ''--convert(char(9),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                                  --map in id of second holder   --9                  
             , convert(CHAR(12),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'SH_POA_MOB'),''))                                           --mobile no of second holder  --12                  
             , ''--convert(char(1),'')                                                                                                         --sms facility for sh                  
             --, CASE WHEN ISNULL(dphd_sh_pan_no,'') = '' THEN '' ELSE 'Y' END  --convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_',''),''))                                                  --pan flag for second holder                 
 
             , convert(char(50),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'TH_POA_MAIL'),''))                                                  --email id for third holder                  
             , ''--convert(char(9),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                                  --map in id of third holder   --9                  
             , convert(CHAR(12),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'TH_POA_MOB'),''))                                           --mobile no of third holder  --12                  
             , ''--convert(char(1),'')                                                                               --sms facility for th                  
             --, CASE WHEN ISNULL(dphd_th_pan_no,'') = '' THEN '' ELSE 'Y' END  --convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))   --pan flag for third holder                  
             , citrus_usr.fn_get_listing_NSDL('occupation',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'occupation_HST',''),''))  --1--convert(NUMERIC,ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                               --benifi  BEN_OCCUPATION                  
             , convert(char(45),ISNULL(dphd.dphd_Fh_fthname,''))                                         --benifi father/husband name                  
             , convert(char(45),ISNULL(dphd.dphd_sh_fthname,''))                                                                           --sh father/husband name                  
             , convert(char(45),ISNULL(dphd.dphd_th_fthname,''))                                                                           --th father/husband name                  
             , case when isnull(dphd_nom_fname,'') <> '' then 'N' when isnull(dphd_gau_fname,'') <> '' then 'G' else ' ' end  --convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                                 --nom-gur indicator          
             , case when isnull(dphd_nom_fname,'') <> '' then isnull(dphd_nom_fname,'')  when isnull(dphd_gau_fname,'') <> '' then isnull(dphd_gau_fname,'') else '' end    
             , CASE WHEN (isnull(dphd_nom_fname,'') <> '' AND DATEDIFF(YEAR, CONVERT(DATETIME,DPHD_NOM_DOB,103), CONVERT(DATETIME,GETDATE(),103)) < 18 )   THEN 'Y' ELSE ' ' END                                               --nom-min indicator             
     
             , ISNULL(dphd_nomGAU_fname,'')--min nom gurdian name                  
             --, CASE when isnull(dphd_gau_fname,'') <> '' then   convert(datetime, dphd_nom_dob,103) END            
			 , CASE when isnull(dphd_gau_fname,'') <> '' then   convert(datetime, clim_dob,103) END 
             , CASE WHEN (isnull(dphd_nom_fname,'') <> '' AND DATEDIFF(YEAR, CONVERT(DATETIME,DPHD_NOM_DOB,103), CONVERT(DATETIME,GETDATE(),103)) < 18 ) THEN CONVERT(DATETIME,dphd_nomgau_fname) end  
             , convert(char(8),ISNULL(citrus_usr.fn_ucc_accp(clim.clim_crn_no,'CMBP_ID',''),''))                                                  --corresponding bp id                  
             , dpam.dpam_created_dt 
             , clim.clim_lst_upd_by                     
             , dpam.dpam_lst_upd_dt                  
             , ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_BO','NSDL'),'')                                                                    
             , case when clim.clim_name1 <> '' then '11'+ convert(varchar(135),clim.clim_name1+' ' + ISNULL(clim.clim_name2,'') + ' ' +  ISNULL(clim.clim_name3,''))  end                  
             , case when isnull(dphd.dphd_sh_fname,'') <> '' then '12'+convert(char(135),isnull(dphd.dphd_sh_fname,'') + ' ' + ISNULL(dphd.dphd_sh_mname,'') + ' ' + ISNULL(dphd.dphd_sh_lname,'')) else convert(char(135),' ')end                  
             , case when isnull(dphd.dphd_th_fname,'') <> '' then '13'+convert(char(45),isnull(dphd.dphd_th_fname,'') + ' ' + ISNULL(dphd.dphd_th_mname,'') + ' ' + ISNULL(dphd.dphd_th_lname,'')) else convert(char(135),' ') end                  
             , clim_lst_upd_dt 
            
        FROM   dp_acct_mstr_hst              dpam      
               left outer  join  
               dp_holder_dtls_hst            dphd                  on dpam.dpam_id            = dphd.dphd_dpam_id             
               left outer join  
               cliba_hst         cliba                 on dpam.dpam_id            = cliba.cliba_clisba_id   
               left outer join  
               bank_mstr                 banm                  on cliba.cliba_banm_id     = banm.banm_id     
           ,   clim_hst               clim                   
           ,   entity_type_mstr          enttm                  
           ,   client_ctgry_mstr         clicm    
        WHERE  clim_lst_upd_dt        BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
        AND    dpam_sba_no            BETWEEN CONVERT(VARCHAR,@pa_from_acct) AND CONVERT(VARCHAR,@pa_to_acct)
        and    dpam.dpam_crn_no        = clim.clim_crn_no                   
        AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
        AND    dpam.dpam_clicm_cd      = clicm.clicm_cd         
        AND    dpam.dpam_deleted_ind   = 1      
        AND    Clim_action  ='E'
        AND    DPAM_ACTION  ='E'
        AND    CLIBA_ACTION ='E'            
        AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
        AND    isnull(clim.clim_deleted_ind,1)   = 1                  
        AND    isnull(cliba.cliba_deleted_ind,1) = 1    
        AND    isnull(banm.banm_deleted_ind,1)   = 1                  
        AND    enttm.enttm_cd in ('01','02','03')                  
        order by clim_lst_upd_dt,DPAM_LST_UPD_DT desc

--
end
else if @pa_all_yn='Y' 
begin
--
  INSERT INTO @l_dp_pri_dtls(    
         entity_type_desc                  
        , ctgry_desc                  
        --, ben_type                            
        --, ben_sub_type                        
        , ben_short_name                      
        , fh_name                             
        , sh_name                             
        , th_name                             
        --, addr_pref_flg                       
        , pan_no                              
        , sh_pan                              
        , th_pan                              
        , stan_instr_ind                      
        , ben_bank_acct_no                    
        , ben_bank_name                       
        , ben_rbi_ref_no                      
        , ben_rbi_app_dt                      
        , ben_sebi_reg_no                     
        , ben_tax_ded_sts                     
        --, local_addr                          
        --, bank_addr                           
        --, nom_gur_addr                        
        --, min_nom_g_addr                      
        --, for_cor_addr                        
        , send_ref_no1                        
        , send_ref_no2                        
        --, micr_cd                             
        , bank_acct_type                      
        , fh_email                
        , fh_map_id                           
        , fh_mob_no                           
        , fh_sms_fac                          
        , fh_poa_fac                          
        --, fh_pan_flg                          
        , sh_email                            
        , sh_map_id                           
        , sh_mob_no                           
        , sh_sms_fac                          
        --, sh_pan_flg                          
        , th_email                            
        , th_map_id                           
        , th_mob_no                           
        , th_sms_fac                          
        --, th_pan_flg                          
        , ben_occupation                      
        , fh_fth_hus_name                     
        , sh_fth_hus_name                     
        , th_fth_hus_name                     
        , nom_gur_ind                         
        , nom_gur_name                        
        , nom_min_ind                         
        , min_nom_gur_name                    
        , dob_min                             
        , don_min_nom                         
        , corr_bp_id                          
        , dpam_created_dt
        , clim_lst_upd_by                  
        , dpam_lst_upd_dt                  
        , dpam_sign_path                  
        , dpam_fholder_sign                   
        , dpam_sholder_sign                   
        , dpam_tholder_sign
        , clim_lst_upd_dt                       
        )  

        SELECT                                                                                                            --beneficiary account category '02'                  
              convert(varchar(50),enttm.enttm_desc)                  
             , convert(varchar(50),clicm.clicm_desc)                  
             --, convert(varchar(20),isnull(left(subcm.subcm_cd,2),'00')) --beneficiary  type          
             --, convert(varchar(20),isnull(right(subcm.subcm_cd,2),'00'))                                                                             --beneficiary sub type                                                              
             , convert(char(16),dpam_sba_name)                                                                                      --beneficiary short name                                                          
             , convert(char(45),dpam_sba_name) --isnull(convert(char(45),clim.clim_name1+' ' + ISNULL(clim.clim_name2,'') + ' ' +  ISNULL(clim.clim_name3,'')),'')           --beneficiary first holder name                  
             , isnull(convert(char(45),dphd.dphd_sh_fname + ' ' + ISNULL(dphd.dphd_sh_mname,'') + ' ' + ISNULL(dphd.dphd_sh_lname,'')),'') --beneficiary second holder name                   
             , isnull(convert(char(45),dphd.dphd_th_fname + ' ' + ISNULL(dphd.dphd_th_mname,'') + ' ' + ISNULL(dphd.dphd_th_lname,'')),'') --beneficiary third holder name                  
             --, 'Y'   --convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                                  --address preference flag                   
             , convert(char(10),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),''))                                       --First holder pan                  
             , convert(char(10),ISNULL(dphd.dphd_sh_pan_no,''))                                                                            --second holder pan                  
             , convert(char(10),ISNULL(dphd.dphd_th_pan_no,''))                                                                            --third holder pan                  
             , 'Y'--case when convert(char(1),ISNULL(citrus_usr.fn_ucc_accp(clim.clim_crn_no,'STAN_INS_IND',''),'')) in ('','0') then 'N' else 'Y'  end                                                --standing instruction indicator                  
             , convert(char(30),ISNULL(cliba.cliba_ac_no,''))                                                                              --bank account no                   
             , convert(char(35),ISNULL(banm.banm_name ,''))                                                                                --bank name                   
             , convert(char(50),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'RBI_REF_NO',''),''))   --benrficiary rbi reference no --50                  
             , convert(char(8),ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RBI_REF_NO','RBI_APP_DT',''),''))                                              --benrficiary rbi approval date --8                  
             , convert(char(24),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'SEBI_REGN_NO',''),''))                                                 --beneficiary sebi registration no --24                  
             , citrus_usr.fn_get_listing('TAX_DEDUCTION',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'TAX_DEDUCTION',''),''))  --benef_tax_ded_sta                                                                      --tax deduction status --20             
     
             --, 'Y'                                                                                                      --local addr???                  
             --, 'Y'                                                                                                                         --bank addr???                    
             --, case when (citrus_usr.[fn_acct_addr_value](dpam_id,'NOMINEE_ADR1') <> '' or citrus_usr.[fn_acct_addr_value](dpam_id,'GUARD_ADR') <> '' )  then 'Y' else 'N' end                                         --minor nominee addr???                     
             --, case when citrus_usr.[fn_acct_addr_value](dpam_id,'NOM_GUARDIAN_ADDR') <> '' then 'Y' else 'N' end
             --,  CASE WHEN citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'FH_ADR1'),''),1) <> '' THEN 'Y'   ELSE 'N' END  
             , convert(char(35),DPAM.dpam_sba_no)                                                                                                        --sender ref no 1                  
             , convert(char(35),'')                                                                                                        --sender ref no 2                  
             ---, convert(char(9),ISNULL(citrus_usr.fn_acct_entp(dpam.dpam_id,'BENMICR'),''))
             , CASE WHEN convert(char(20),cliba_ac_type) IN( 'SAVINGS', 'SAVING')  THEN '10' WHEN convert(char(20),cliba_ac_type) IN('CURRENT') THEN  '11' WHEN convert(char(20),cliba_ac_type) IN( 'OTHERS') THEN  '13' END   --'11'                                                                                          --bank acct type                  
             , convert(char(50),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'EMAIL1'),''))                                                  --email id for first holder            
             , convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'MAPIN_ID',''),''))                                  --map in id of first holder   --9                  
             , convert(char(11),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'MOBILE1'),''))                                                   --mobile no of first holder  --12                  
             , CASE WHEN (convert(char(11),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'MOBILE1'),'')) <> '' AND  convert(char(1),ISNULL(citrus_usr.fn_ACCT_entp(DPAM_ID,'SMS_FLAG'),''))= 1)   THEN 'Y' 
               WHEN (convert(char(11),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'MOBILE1'),'')) <> '' AND  convert(char(1),ISNULL(citrus_usr.fn_ACCT_entp(DPAM_ID,'SMS_FLAG'),''))= '')   THEN 'N' ELSE ' ' END 
             , convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                                  --poa facility                  
             --, CASE WHEN convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),''))  <> '' THEN 'Y' ELSE 'N' END                                                --pan flag for first holder                  
             , convert(char(50),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'SH_POA_MAIL'),''))                                                  --email id for second holder                  
             , ''--convert(char(9),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                                  --map in id of second holder   --9                  
             , convert(CHAR(12),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'SH_POA_MOB'),''))                                           --mobile no of second holder  --12                  
             , ''--convert(char(1),'')                                                                                                         --sms facility for sh                  
             --, CASE WHEN ISNULL(dphd_sh_pan_no,'') = '' THEN '' ELSE 'Y' END  --convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_',''),''))                                                  --pan flag for second holder                 
 
             , convert(char(50),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'TH_POA_MAIL'),''))                                                  --email id for third holder                  
             , ''--convert(char(9),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                                  --map in id of third holder   --9                  
             , convert(CHAR(12),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'TH_POA_MOB'),''))                                           --mobile no of third holder  --12                  
             , ''--convert(char(1),'')                                                                               --sms facility for th                  
             --, CASE WHEN ISNULL(dphd_th_pan_no,'') = '' THEN '' ELSE 'Y' END  --convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))   --pan flag for third holder                  
             , citrus_usr.fn_get_listing_NSDL('occupation',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'occupation',''),''))  --1--convert(NUMERIC,ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                               --benifi  BEN_OCCUPATION                  
             , convert(char(45),ISNULL(dphd.dphd_Fh_fthname,''))                                         --benifi father/husband name                  
             , convert(char(45),ISNULL(dphd.dphd_sh_fthname,''))                                                                           --sh father/husband name                  
             , convert(char(45),ISNULL(dphd.dphd_th_fthname,''))                                                                           --th father/husband name                  
             , case when isnull(dphd_nom_fname,'') <> '' then 'N' when isnull(dphd_gau_fname,'') <> '' then 'G' else ' ' end  --convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                                 --nom-gur indicator          
             , case when isnull(dphd_nom_fname,'') <> '' then isnull(dphd_nom_fname,'')  when isnull(dphd_gau_fname,'') <> '' then isnull(dphd_gau_fname,'') else '' end    
             , CASE WHEN (isnull(dphd_nom_fname,'') <> '' AND DATEDIFF(YEAR, CONVERT(DATETIME,DPHD_NOM_DOB,103), CONVERT(DATETIME,GETDATE(),103)) < 18 )   THEN 'Y' ELSE ' ' END                                               --nom-min indicator             
     
             , ISNULL(dphd_nomGAU_fname,'')--min nom gurdian name                  
             --, CASE when isnull(dphd_gau_fname,'') <> '' then   convert(datetime, dphd_nom_dob,103) END            
			 , CASE when isnull(dphd_gau_fname,'') <> '' then   convert(datetime, clim_dob,103) END 
             , CASE WHEN (isnull(dphd_nom_fname,'') <> '' AND DATEDIFF(YEAR, CONVERT(DATETIME,DPHD_NOM_DOB,103), CONVERT(DATETIME,GETDATE(),103)) < 18 ) THEN CONVERT(DATETIME,dphd_nomgau_fname) end  
             , convert(char(8),ISNULL(citrus_usr.fn_ucc_accp(clim.clim_crn_no,'CMBP_ID',''),''))                                                  --corresponding bp id                  
             , dpam.dpam_created_dt    
             , clim.clim_lst_upd_by                  
             , dpam.dpam_lst_upd_dt                  
             , ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_BO','NSDL'),'')                                                                    
             , case when clim.clim_name1 <> '' then '11'+ convert(varchar(135),clim.clim_name1+' ' + ISNULL(clim.clim_name2,'') + ' ' +  ISNULL(clim.clim_name3,''))  end                  
             , case when isnull(dphd.dphd_sh_fname,'') <> '' then '12'+convert(char(135),isnull(dphd.dphd_sh_fname,'') + ' ' + ISNULL(dphd.dphd_sh_mname,'') + ' ' + ISNULL(dphd.dphd_sh_lname,'')) else convert(char(135),' ')end                  
             , case when isnull(dphd.dphd_th_fname,'') <> '' then '13'+convert(char(45),isnull(dphd.dphd_th_fname,'') + ' ' + ISNULL(dphd.dphd_th_mname,'') + ' ' + ISNULL(dphd.dphd_th_lname,'')) else convert(char(135),' ') end                  
             , clim_lst_upd_dt 
             
        FROM   dp_acct_mstr              dpam      
               left outer  join  
               dp_holder_dtls            dphd                  on dpam.dpam_id            = dphd.dphd_dpam_id             
               left outer join  
               client_bank_accts         cliba                 on dpam.dpam_id            = cliba.cliba_clisba_id   
               left outer join  
               bank_mstr                 banm                  on cliba.cliba_banm_id     = banm.banm_id     
           ,   client_mstr               clim                   
           ,   entity_type_mstr          enttm                  
           ,   client_ctgry_mstr         clicm    
        WHERE  clim_lst_upd_dt        BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
        AND    dpam_sba_no            BETWEEN CONVERT(VARCHAR,@pa_from_acct) AND CONVERT(VARCHAR,@pa_to_acct)
        and    dpam.dpam_crn_no        = clim.clim_crn_no                   
        AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
        AND    dpam.dpam_clicm_cd      = clicm.clicm_cd         
        AND    dpam.dpam_deleted_ind   = 1 
        AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
        AND    isnull(clim.clim_deleted_ind,1)   = 1                  
        AND    isnull(cliba.cliba_deleted_ind,1) = 1    
        AND    isnull(banm.banm_deleted_ind,1)   = 1                  
        AND    enttm.enttm_cd in ('01','02','03')                  
        

        UNION               
  
        SELECT                                                                                                        --beneficiary account category '02'                  
              convert(varchar(50),enttm.enttm_desc)                  
             , convert(varchar(50),clicm.clicm_desc)                  
             --, convert(varchar(20),isnull(left(subcm.subcm_cd,2),'00')) --beneficiary  type          
             --, convert(varchar(20),isnull(right(subcm.subcm_cd,2),'00'))                                                                             --beneficiary sub type                                                              
             , convert(char(16),dpam_sba_name)                                                                                      --beneficiary short name                                                          
             , convert(char(45),dpam_sba_name) --isnull(convert(char(45),clim.clim_name1+' ' + ISNULL(clim.clim_name2,'') + ' ' +  ISNULL(clim.clim_name3,'')),'')           --beneficiary first holder name                  
             , isnull(convert(char(45),dphd.dphd_sh_fname + ' ' + ISNULL(dphd.dphd_sh_mname,'') + ' ' + ISNULL(dphd.dphd_sh_lname,'')),'') --beneficiary second holder name                   
             , isnull(convert(char(45),dphd.dphd_th_fname + ' ' + ISNULL(dphd.dphd_th_mname,'') + ' ' + ISNULL(dphd.dphd_th_lname,'')),'') --beneficiary third holder name                  
             --, 'Y'   --convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                                  --address preference flag                   
             , convert(char(10),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO_HST',''),''))                                       --First holder pan                  
             , convert(char(10),ISNULL(dphd.dphd_sh_pan_no,''))                                                                            --second holder pan                  
             , convert(char(10),ISNULL(dphd.dphd_th_pan_no,''))                                                                            --third holder pan                  
             , 'Y'--case when convert(char(1),ISNULL(citrus_usr.fn_ucc_accp(clim.clim_crn_no,'STAN_INS_IND',''),'')) in ('','0') then 'N' else 'Y'  end                                                --standing instruction indicator                  
             , convert(char(30),ISNULL(cliba.cliba_ac_no,''))                                                                              --bank account no                   
             , convert(char(35),ISNULL(banm.banm_name ,''))                                                                                --bank name                   
             , convert(char(50),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'RBI_REF_NO',''),''))   --benrficiary rbi reference no --50                  
             , convert(char(8),ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RBI_REF_NO','RBI_APP_DT',''),''))                                              --benrficiary rbi approval date --8                  
             , convert(char(24),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'SEBI_REGN_NO',''),''))                                                 --beneficiary sebi registration no --24                  
             , citrus_usr.fn_get_listing('TAX_DEDUCTION',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'TAX_DEDUCTION',''),''))  --benef_tax_ded_sta                                                                      --tax deduction status --20             
     
             --, 'Y'                                                                                                      --local addr???                  
             --, 'Y'                                                                                                                         --bank addr???                    
             --, case when (citrus_usr.[fn_acct_addr_value](dpam_id,'NOMINEE_ADR1') <> '' or citrus_usr.[fn_acct_addr_value](dpam_id,'GUARD_ADR') <> '' )  then 'Y' else 'N' end                                         --minor nominee addr???                     
             --, case when citrus_usr.[fn_acct_addr_value](dpam_id,'NOM_GUARDIAN_ADDR') <> '' then 'Y' else 'N' end
             --,  CASE WHEN citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'FH_ADR1'),''),1) <> '' THEN 'Y'  ELSE 'N' END  
             , convert(char(35),DPAM.dpam_sba_no)                                                                                                        --sender ref no 1                  
             , convert(char(35),'')                                                                                                        --sender ref no 2                  
             --, convert(char(9),ISNULL(citrus_usr.fn_acct_entp(dpam.dpam_id,'BENMICR'),''))
             , CASE WHEN convert(char(20),cliba_ac_type) IN( 'SAVINGS', 'SAVING')  THEN '10' WHEN convert(char(20),cliba_ac_type) IN('CURRENT') THEN  '11' WHEN convert(char(20),cliba_ac_type) IN( 'OTHERS') THEN  '13' END   --'11'                                                                                          --bank acct type                  
             , convert(char(50),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'EMAIL1'),''))                                                  --email id for first holder            
             , convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'MAPIN_ID',''),''))                                  --map in id of first holder   --9                  
             , convert(char(11),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'MOBILE1'),''))                                                   --mobile no of first holder  --12                  
             , CASE WHEN (convert(char(11),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'MOBILE1'),'')) <> '' AND  convert(char(1),ISNULL(citrus_usr.fn_ACCT_entp(DPAM_ID,'SMS_FLAG'),''))= 1)   THEN 'Y' 
               WHEN (convert(char(11),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'MOBILE1'),'')) <> '' AND  convert(char(1),ISNULL(citrus_usr.fn_ACCT_entp(DPAM_ID,'SMS_FLAG'),''))= '')   THEN 'N' ELSE ' ' END 
             , convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                                  --poa facility                  
             --, CASE WHEN convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),''))  <> '' THEN 'Y' ELSE 'N' END                                                --pan flag for first holder                  
             , convert(char(50),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'SH_POA_MAIL'),''))                                                  --email id for second holder                  
             , ''--convert(char(9),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                                  --map in id of second holder   --9                  
             , convert(CHAR(12),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'SH_POA_MOB'),''))                                           --mobile no of second holder  --12                  
             , ''--convert(char(1),'')                                                                                                         --sms facility for sh                  
             --, CASE WHEN ISNULL(dphd_sh_pan_no,'') = '' THEN '' ELSE 'Y' END  --convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_',''),''))                                                  --pan flag for second holder                 
 
             , convert(char(50),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'TH_POA_MAIL'),''))                                                  --email id for third holder                  
             , ''--convert(char(9),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                                  --map in id of third holder   --9                  
             , convert(CHAR(12),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'TH_POA_MOB'),''))                                           --mobile no of third holder  --12                  
             , ''--convert(char(1),'')                                                                               --sms facility for th                  
             --, CASE WHEN ISNULL(dphd_th_pan_no,'') = '' THEN '' ELSE 'Y' END  --convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))   --pan flag for third holder                  
             , citrus_usr.fn_get_listing_NSDL('occupation',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'occupation_HST',''),''))  --1--convert(NUMERIC,ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                               --benifi  BEN_OCCUPATION                  
             , convert(char(45),ISNULL(dphd.dphd_Fh_fthname,''))                                         --benifi father/husband name                  
             , convert(char(45),ISNULL(dphd.dphd_sh_fthname,''))                                                                           --sh father/husband name                  
             , convert(char(45),ISNULL(dphd.dphd_th_fthname,''))                                                                           --th father/husband name                  
             , case when isnull(dphd_nom_fname,'') <> '' then 'N' when isnull(dphd_gau_fname,'') <> '' then 'G' else ' ' end  --convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                                 --nom-gur indicator          
             , case when isnull(dphd_nom_fname,'') <> '' then isnull(dphd_nom_fname,'')  when isnull(dphd_gau_fname,'') <> '' then isnull(dphd_gau_fname,'') else '' end    
             , CASE WHEN (isnull(dphd_nom_fname,'') <> '' AND DATEDIFF(YEAR, CONVERT(DATETIME,DPHD_NOM_DOB,103), CONVERT(DATETIME,GETDATE(),103)) < 18 )   THEN 'Y' ELSE ' ' END                                               --nom-min indicator             
     
             , ISNULL(dphd_nomGAU_fname,'')--min nom gurdian name                  
             --, CASE when isnull(dphd_gau_fname,'') <> '' then   convert(datetime, dphd_nom_dob,103) END            
			 , CASE when isnull(dphd_gau_fname,'') <> '' then   convert(datetime, clim_dob,103) END 
             , CASE WHEN (isnull(dphd_nom_fname,'') <> '' AND DATEDIFF(YEAR, CONVERT(DATETIME,DPHD_NOM_DOB,103), CONVERT(DATETIME,GETDATE(),103)) < 18 ) THEN CONVERT(DATETIME,dphd_nomgau_fname) end  
             , convert(char(8),ISNULL(citrus_usr.fn_ucc_accp(clim.clim_crn_no,'CMBP_ID',''),''))                                                  --corresponding bp id                  
             , dpam.dpam_created_dt
             , clim.clim_lst_upd_by                   
             , dpam.dpam_lst_upd_dt                  
             , ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_BO','NSDL'),'')                                                                    
             , case when clim.clim_name1 <> '' then '11'+ convert(varchar(135),clim.clim_name1+' ' + ISNULL(clim.clim_name2,'') + ' ' +  ISNULL(clim.clim_name3,''))  end                  
             , case when isnull(dphd.dphd_sh_fname,'') <> '' then '12'+convert(char(135),isnull(dphd.dphd_sh_fname,'') + ' ' + ISNULL(dphd.dphd_sh_mname,'') + ' ' + ISNULL(dphd.dphd_sh_lname,'')) else convert(char(135),' ')end                  
             , case when isnull(dphd.dphd_th_fname,'') <> '' then '13'+convert(char(45),isnull(dphd.dphd_th_fname,'') + ' ' + ISNULL(dphd.dphd_th_mname,'') + ' ' + ISNULL(dphd.dphd_th_lname,'')) else convert(char(135),' ') end                  
             , clim_lst_upd_dt 
            
        FROM   dp_acct_mstr_hst              dpam      
               left outer  join  
               dp_holder_dtls_hst            dphd                  on dpam.dpam_id            = dphd.dphd_dpam_id             
               left outer join  
               cliba_hst         cliba                 on dpam.dpam_id            = cliba.cliba_clisba_id   
               left outer join  
               bank_mstr                 banm                  on cliba.cliba_banm_id     = banm.banm_id     
           ,   clim_hst               clim                   
           ,   entity_type_mstr          enttm                  
           ,   client_ctgry_mstr         clicm    
        WHERE  clim_lst_upd_dt        BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
        AND    dpam_sba_no            BETWEEN CONVERT(VARCHAR,@pa_from_acct) AND CONVERT(VARCHAR,@pa_to_acct)
        and    dpam.dpam_crn_no        = clim.clim_crn_no                   
        AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
        AND    dpam.dpam_clicm_cd      = clicm.clicm_cd         
        AND    dpam.dpam_deleted_ind   = 1      
        AND    Clim_action  ='E'
        AND    DPAM_ACTION  ='E'
        AND    CLIBA_ACTION ='E'            
        AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
        AND    isnull(clim.clim_deleted_ind,1)   = 1                  
        AND    isnull(cliba.cliba_deleted_ind,1) = 1    
        AND    isnull(banm.banm_deleted_ind,1)   = 1                  
        AND    enttm.enttm_cd in ('01','02','03')                  
        order by clim_lst_upd_dt,DPAM_LST_UPD_DT desc

end
        
    
        
      
                                                 
                    
    END                  
        select PAN_NO ,BEN_OCCUPATION OCCUPATION,CONVERT(VARCHAR(11),CLIM_LST_UPD_BY,103)CLIM_LST_UPD_BY ,CONVERT(VARCHAR(11),CLIM_LST_UPD_DT,103) CLIM_LST_UPD_DT from @l_dp_pri_dtls    
                    
--                  
END

GO
