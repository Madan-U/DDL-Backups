-- Object: PROCEDURE citrus_usr.pr_export_bo_cdsl
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create PROCEDURE [citrus_usr].[pr_export_bo_cdsl]( @pa_crn_no      VARCHAR(8000)                  
                            , @pa_exch        VARCHAR(10)                  
                            , @pa_from_dt     VARCHAR(11)                  
                            , @pa_to_dt       VARCHAR(11)                  
                            , @pa_tab         CHAR(3)                  
                            , @PA_BATCH_NO    VARCHAR(25)  
                            , @PA_EXCSM_ID    NUMERIC   
                            , @PA_LOGINNAME   VARCHAR(25)  
                            , @pa_ref_cur     VARCHAR(8000) OUTPUT                  
)                
AS
BEGIN
	DECLARE @crn TABLE (crn          numeric                  
                     ,acct_no      varchar(25)                  
                     ,clim_stam_cd varchar(25)                  
                     ,fm_dt        datetime                  
                     ,to_dt        datetime                  
                     )     
                     
                     
  DECLARE @@rm_id                VARCHAR(8000)                    
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
          , @l_Value             VARCHAR(8000)                  
          , @l_client_type       VARCHAR(100)                  
          , @l_chk               NUMERIC                  
          , @l_ctgry_chk         NUMERIC 
          
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
           
  IF @pa_exch = 'CDSL'                  
  BEGIN                  
  --
  declare @line2 table (ln_no CHAR(2)                  
                         ,crn_no                  numeric                  
                         ,acct_no                 varchar(20)                  
                         ,product_number          varchar(4) --numeric(4,0)                  
                         ,bo_name                 char(100)                  
                         ,bo_middle_name          char(20)                  
                         ,cust_search_name        char(20)                  
                         ,bo_title                char(10)                  
                         ,bo_suffix               char(10)                  
                         ,hldr_fth_hsd_nm         char(50)                  
                         ,cust_addr1              char(300)--char(30)                  
                         ,cust_addr2              char(300)--char(30)                  
                         ,cust_addr3              char(300)--char(30)                  
                         ,cust_addr_city          char(300)--char(25)                  
                         ,cust_addr_state         char(300)--char(25)                  
                         ,cust_addr_cntry         char(300)--char(25)                  
                         ,cust_addr_zip           char(10)                  
                         ,cust_ph1_ind            char(1)                  
                         ,cust_ph1                char(17)                  
                         ,cust_ph2_ind            char(1)                  
                         ,cust_ph2                char(17)                  
                         ,cust_addl_ph            char(100)                  
                         ,cust_fax                char(17)                  
                         ,hldr_pan                char(25)                  
                         ,it_crl                  char(15)                  
                         ,cust_email              char(50)                  
                         ,bo_usr_txt1             char(50)                  
                         ,bo_usr_txt2             char(50)                  
                         ,bo_user_fld3            varchar(20)                  
                         ,bo_user_fld4            char(4)                  
                         ,bo_user_fld5            varchar(20)                  
                         ,sign_bo                 varchar(8000)          
                         ,sign_fl_flag            char(1))                  
      declare @line3 table(ln_no CHAR(2)                  
                         ,crn_no                  numeric                      
                         ,acct_no                 varchar(20)                  
                         ,bo_name1                 char(100)                  
                         ,bo_mid_name1             char(20)                  
                         ,cust_search_name1        char(20)                  
                         ,bo_title1                char(10)                  
                         ,bo_suffix1               char(10)                  
                         ,hldr_fth_hsd_nm1         char(50)                  
                         ,hldr_pan1                char(25)                  
                         ,it_crl1                  char(15))                   
                                           
      declare @line4 table(ln_no CHAR(2)                  
                         ,crn_no                  numeric                  
                         ,acct_no                 varchar(20)                  
                         ,bo_name2                 char(100)                  
                         ,bo_mid_name2             char(20)                  
                         ,cust_search_name2        char(20)                  
                         ,bo_title2                char(10)                  
                         ,bo_suffix2               char(10)                  
                         ,hldr_fth_hsd_nm2         char(50)                  
                         ,hldr_pan2                char(25)                  
                         ,it_crl2                  char(15))                   
                                           
                                           
      declare @line5 table(ln_no CHAR(2)                  
                         ,crn_no                  numeric                  
                         ,acct_no                 varchar(20)                  
                         ,dt_of_maturity          varchar(20)--datetime                  
                         ,dp_int_ref_no           char(10)                    
                         ,dob                     varchar(20)--datetime                  
                         ,sex_cd                  char(1)                  
                         ,occp                    char(4)                  
                         ,life_style              char(4)                  
                         ,geographical_cd         char(4)                  
                         ,edu                     char(4)                  
                         ,ann_income_cd           varchar(20)                  
                         ,nat_cd                  char(3)                  
                         ,legal_status_cd         varchar(20)                  
                         ,bo_fee_type             varchar(20)                  
                         ,lang_cd                 varchar(20)                  
                         ,category4_cd            varchar(20)                  
                         ,bank_option5            varchar(20)                  
                         ,staff                   char(1)                  
                         ,staff_cd                char(10)                  
                         ,bo2_usr_txt1            char(50)                  
                         ,bo2_usr_txt2            char(50)                  
                         ,dummy1                  varchar(20)                  
                         ,dummy2                  varchar(20)                  
                         ,dummy3                  varchar(20)                  
                         ,secur_acc_cd            varchar(20)                  
                         ,bo_catg                 varchar(20)                  
                         ,bo_settm_plan_fg        char(1)                  
                         ,voice_mail         char(15)                   
                         ,rbi_ref_no              char(30)                  
                         ,rbi_app_dt              varchar(20)--datetime                  
                         ,sebi_reg_no             char(24)                  
                         ,benef_tax_ded_sta       varchar(20)                  
                         ,smart_crd_req           char(1)                  
                         ,smart_crd_no            char(20)                  
                         ,smart_crd_pin           varchar(20)                  
                         ,ecs                     char(1)                  
                         ,elec_confirm            char(1)                  
                         ,dividend_curr           varchar(20)                  
                         ,group_cd                char(8)                  
                         ,bo_sub_status           varchar(20)                  
                         ,clr_corp_id             varchar(20)                  
                         ,clr_member_id           char(8)                  
                         ,stoc_exch               varchar(20)                  
                         ,confir_waived           char(1)                  
                         ,trading_id              char(8)                  
                         ,bo_statm_cycle_cd       char(2)                  
                         ,benf_bank_code          char(12)                  
                         ,benf_brnch_numb         char(18)                  
                         ,benf_bank_acno          char(20)                  
                         ,benf_bank_ccy           varchar(20)                  
                         ,divnd_brnch_numb        char(12)                  
                         ,divnd_bank_code    char(12)                  
                         ,divnd_acct_numb         char(20)                  
                         ,divnd_bank_ccy          varchar(20))                  
                                           
      declare @line6 table (ln_no CHAR(2)                  
                         ,crn_no                  numeric                  
                         ,acct_no                 varchar(20)                  
                         ,poa_id                  char(16)                  
                         ,setup_date              datetime                  
                         ,poa_to_opr_ac           char(1)                  
                         ,gpa_bpa_fl              char(1)                  
                         ,eff_frm_dt              datetime                  
                         ,eff_to_dt               datetime                  
                         ,usr_fld1                varchar(20)                  
  ,usr_fld2               varchar(20)                  
                         ,ca_charfld              char(50)                  
                         ,bo_name3                char(100)                  
                         ,bo_mid_name3            char(20)                   
                         ,cust_srh_name3          char(20)                  
                         ,bo_title3               char(10)                  
                         ,bo_suffix3              char(10)                  
                         ,hldr_fth_hsb_nm3        char(50)                  
                         ,cus_addr1               char(300)--char(30)                 
                         ,cust_addr2              char(300)--char(30)                  
                         ,cust_addr3              char(300)--char(30)                  
                         ,cust_city               char(300)--char(25)                  
                         ,cust__state             char(300)--char(25)                  
                         ,cust_cntry              char(25)       
                         ,cust_zip                char(10)                  
                         ,cust_ph1_ind            char(1)                  
                         ,cust_ph1                char(17)                  
                         ,cust_ph2_ind            char(1)                  
                         ,cust_ph2                char(17)                  
                         ,cust_addl_ph            char(100)                  
                         ,cust_fax                char(17)                  
                         ,pan_no                  char(25)                  
                         ,it_crc                  char(15)                  
                         ,cust_email              char(50)                  
                         ,bo3_usr_txt1            char(50)                  
                         ,bo3_usr_txt2            char(50)                  
                         ,bo3_usr_fld3            varchar(20)                  
                         ,bo3_usr_fld4            varchar(20)                  
                         ,bo3_usr_fld5            varchar(20)                  
                         ,sign_poa                varchar(8000)                  
                         ,sign_file_fl            char (1))                                    
                        
                                           
      declare @line7 table(ln_no                   char(2)                  
                         ,crn_no                  numeric                  
                         ,acct_no                 varchar(20)                  
                         ,Purpose_code            CHAR(2)--numeric                  
                         ,bo_name                 char(100)                    
                         ,bo_middle_nm            char(100)                   
                         ,cust_search_name        char(100)                  
                         ,bo_title             char(100)                   
                         ,bo_suffix               char(100)                   
                         ,hldr_fth_hs_name        char(100)                   
                         ,cust_addr1              char(100)                  
                         ,cust_addr2              char(100)                  
                         ,cust_addr3              char(100)                  
                         ,cust_city               char(100)                  
                         ,cust_state              char(100)                  
                         ,cust_cntry              char(100)                   
                         ,cust_zip                char(100)                  
                         ,cust_ph1_id             char(100)                   
                         ,cust_ph1                char(100)                  
                         ,cust_ph2_in             char(100)                    
                         ,cust_ph2                char(100)                   
                         ,cust_addl_ph            char(100)                         
                         ,cust_fax                char(100)                   
                         ,hldr_in_tax_pan         char(100)                    
                         ,it_crl                  char(100)                   
                         ,cust_email              char(100)                  
                         ,usr_txt1                char(100)                    
                         ,usr_txt2                char(100)                   
                         ,usr_fld3                numeric                  
                         ,usr_fld4                numeric                      
                         ,usr_fld5                numeric                  
                         )                     
                        
                        
                        
                                           
              declare @line8 table(ln_no CHAR(2)                  
                         ,crn_no                  numeric 
                         ,acct_no                 varchar(20)                  
                         ,purposecode             char(2)
                         ,flag                    char(1)                  
                         ,mobile                  char(10)                  
                         ,email                   char(100)                  
                         ,remarks                 char(100)                  
                         ,push_flg                char(1)                  
                       )              
                                                    
       
      IF ISNULL(@pa_crn_no, '') <> ''                  
      BEGIN--n_n                  
      --                  
        SET @@rm_id  =  @pa_crn_no                  
        --                  
                          
        --                  
        WHILE @@rm_id <> ''                    
        BEGIN--w_id                    
        --              
          SET @@foundat = 0                    
          SET @@foundat =  PATINDEX('%*|~*%',@@rm_id)                    
          --                  
          IF @@foundat > 0                    
          BEGIN                    
          --                    
            SET @@cur_id  = SUBSTRING(@@rm_id, 0,@@foundat)                    
            SET @@rm_id   = SUBSTRING(@@rm_id, @@foundat+4,LEN(@@rm_id)- @@foundat+4)                    
          --                    
          END                    
          ELSE                    
          BEGIN                    
          --                    
            SET @@cur_id      = @@rm_id                    
            SET @@rm_id = ''                    
          --                    
          END                  
          --                  
          IF @@cur_id <> ''                  
          BEGIN                  
          --                  
            SET @l_crn_no  = CONVERT(NUMERIC, citrus_usr.fn_splitval(@@cur_id,1))                  
            SET @l_acct_no = CONVERT(VARCHAR(25), citrus_usr.fn_splitval(@@cur_id,2))                  
            --                   
            INSERT INTO @crn                   
            SELECT clim_crn_no,@l_acct_no, clim_stam_cd, clim_created_dt, clim_lst_upd_dt                  
            FROM   client_mstr WITH (NOLOCK)                  
            WHERE  clim_crn_no = CONVERT(numeric, @l_crn_no)                  
                  
          --                  
          END                  
        --                    
        END                  
      --                  
      END                  
      --                  
      IF  @pa_crn_no = ''                  
      BEGIN                  
        --                
        insert into @line2( ln_no                  
                           ,crn_no                  
                           ,acct_no                  
                           ,product_number                       
                           ,bo_name                              
                           ,bo_middle_name                       
                           ,cust_search_name                     
                           ,bo_title                             
                           ,bo_suffix                            
                           ,hldr_fth_hsd_nm                      
                           ,cust_addr1                           
                           ,cust_addr2                           
                           ,cust_addr3                           
                           ,cust_addr_city                       
                           ,cust_addr_state                      
                           ,cust_addr_cntry                      
                           ,cust_addr_zip                        
                           ,cust_ph1_ind                         
                           ,cust_ph1                             
                           ,cust_ph2_ind                         
                           ,cust_ph2                             
                           ,cust_addl_ph                         
                           ,cust_fax                             
                           ,hldr_pan                             
                           ,it_crl                               
                           ,cust_email                           
                           ,bo_usr_txt1                          
                           ,bo_usr_txt2                          
                           ,bo_user_fld3                         
                           ,bo_user_fld4                         
                           ,bo_user_fld5                   
                           ,sign_bo                                   
                           ,sign_fl_flag)                  
                           SELECT distinct '02'                  
                                , clim_crn_no                  
                                , dpam_acct_no                  
                                , citrus_usr.Fn_FormatStr(left(subcm_cd,2),4,0,'L','0')                  
                                , case when dpam_clicm_cd in ('21' , '24' , '27') then CITRUS_USR.inside_trim(LTRIM(RTRIM(DPAM_SBA_NAME)),'1')
                                  else LTRIM(RTRIM(dpam_sba_name))  end
                                , case when dpam_clicm_cd in ('21' , '24' , '27') then CITRUS_USR.inside_trim(LTRIM(RTRIM(DPAM_SBA_NAME)),'2')
                                  else '' end
                                , case when dpam_clicm_cd in ('21' , '24' , '27') then CITRUS_USR.inside_trim(LTRIM(RTRIM(DPAM_SBA_NAME)),'3')
                                  else '.' end
                                , case when CLIM_GENDER in ('M','MALE') then 'MR'  when CLIM_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end                 
                                , ''                  
                                , ISNULL(dphd_fh_fthname,'')  --father/husband name                  
                               , case when citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_COR_ADR1'),''),1) <> '' 
                                       then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_COR_ADR1'),''),1) 
                                       else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),1) end --adr1                  
                                , case when citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_COR_ADR1'),''),1) <> ''
                                       then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_COR_ADR1'),''),2)
                                       else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),2) end--adr2                  
                                , case when citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_COR_ADR1'),''),1) <> ''
                                       then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_COR_ADR1'),''),3)
                                       else  citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),3) end--adr3                  
                                , case when citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_COR_ADR1'),''),1) <> ''
                                       then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_COR_ADR1'),''),4)
                                       else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),4) end--adr_city                  
                                , case when citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_COR_ADR1'),''),1) <> ''
                                       then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_COR_ADR1'),''),5)
                                       else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),5) end--adr_state                  
                                , case when citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_COR_ADR1'),''),1) <> ''
                                       then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_COR_ADR1'),''),6)
                                       else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),6) end--adr_country                  
                                , case when citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_COR_ADR1'),''),1) <> ''
                                       then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_COR_ADR1'),''),7)
                                       else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),7) end --adr_zip                
                                , isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'Y'),'')  
                                , isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'N'),'')   --convert(varchar(17),isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH1'),''))--ph1                  
                                , isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'Y'),'')            --'0'                  
                                , isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'N'),'')  --isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH2'),'')--ph2                  
                                , isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,3,'N'),'')                 
                                , CASE WHEN isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCFAX1'),'') <> '' THEN isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCFAX1'),'') ELSE isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'FAX1'),'') END --fax                  
                                , isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'')  --pan card                  
                                , ''  
                                , CASE WHEN lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCEMAIL1'),'')) <> '' THEN lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCEMAIL1'),'')) ELSE lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'EMAIL1'),'')) END --email                  
                                , ''                  
                                , ''                  
                                , '0000'                  
                                , ''                  
                                , case when isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'') <> '' then '1' else '0' end + case when isnull(DPHD_SH_PAN_NO,'') <> '' then '1' else '0' end + case when  isnull(DPHD_TH_PAN_NO,'') <> '' then '1' else '0' end + '0'                
                                ,ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_BO',''),'')                  
                                , case when ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_BO',''),'') = '' then 'N' else 'Y'   end --signature file flag                  
                  
                           FROM   dp_acct_mstr              dpam                  
                                  left outer join      
                                  dp_holder_dtls            dphd                  on dpam.dpam_id            = dphd.dphd_dpam_id                      
                                  left outer join    
                                  client_bank_accts         cliba                on dpam.dpam_id            = cliba.cliba_clisba_id    
                                  left outer join           
                                  bank_mstr                 banm                 on  convert(int,cliba.cliba_banm_id)     = convert(int,banm.banm_id)          
                                , client_mstr               clim                  
                                , entity_type_mstr          enttm                  
                                , client_ctgry_mstr         clicm                  
                                , sub_ctgry_mstr            subcm                   
                                , exch_seg_mstr              excsm  
                           WHERE  dpam.dpam_crn_no        = clim.clim_crn_no                   
                           AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
                           AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
                           AND    dpam.dpam_deleted_ind   = 1                  
                           AND    dpam.dpam_excsm_id      = excsm_id                  
                           AND    excsm_exch_cd           = @pa_exch  
                           AND    subcm.subcm_CD          = DPAM.DPAM_SUBCM_CD  
                           AND    subcm.subcm_deleted_ind = 1                  
                           AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
                           AND    clim.clim_deleted_ind   = 1                  
                           AND    isnull(cliba.cliba_deleted_ind,1) = 1                  
                           AND    isnull(banm.banm_deleted_ind,1)   = 1                  
                           AND   CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
                  
                  
                   insert into @line3(ln_no                   
                                     ,crn_no                   
                                     ,acct_no                  
                                     ,bo_name1                                
                                     ,bo_mid_name1                            
                                     ,cust_search_name1                       
                                     ,bo_title1                               
                                     ,bo_suffix1                              
                                     ,hldr_fth_hsd_nm1                        
                                     ,hldr_pan1                               
                                     ,it_crl1)                  
                                     SELECT distinct '03'                  
                                                  , clim_crn_no                  
                                                  , dpam_acct_no                  
                                                  , isnull(dphd_sh_fname,'') 
                                                  , isnull(dphd_sh_mname,'')                  
                                                  , isnull(dphd_sh_lname,'')                  
                                                  , case when DPHD_SH_GENDER in ('M','MALE') then 'MR'  when DPHD_SH_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end                            
                                                  , ''         
                                                  , isnull(dphd_sh_fthname,'')                  
                                                  , isnull(dphd_sh_pan_no,'')                  
                                                  , ''--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CLIENT_IT',''),'')  --it circle                  
                                      FROM   dp_acct_mstr              dpam                  
                                             left outer join   
                                             dp_holder_dtls            dphd                 on dpam.dpam_id            = dphd.dphd_dpam_id                      
                                             left outer join                       
                                             client_bank_accts         cliba                on dpam.dpam_id            = cliba.cliba_clisba_id    
                                             left outer join           
                                             bank_mstr                 banm                 on  convert(int,cliba.cliba_banm_id)     = convert(int,banm.banm_id)          
                                           , client_mstr               clim                  
                                           , entity_type_mstr         enttm                  
                                           , client_ctgry_mstr         clicm                  
                                             left outer join                  
                                             sub_ctgry_mstr            subcm                   
                                             on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
                                             ,exch_seg_mstr  
                                      WHERE  dpam.dpam_crn_no        = clim.clim_crn_no                   
                                      AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
                                      AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
                                      AND    dpam.dpam_deleted_ind   = 1                  
                                      AND    dpam.dpam_excsm_id      = excsm_id                  
                                      AND    excsm_exch_cd           = @pa_exch  
                                      AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
                                      AND    clim.clim_deleted_ind   = 1                  
                                      AND    isnull(cliba.cliba_deleted_ind,1) = 1                  
                                      AND    isnull(banm.banm_deleted_ind,1)   = 1    
                                      AND    isnull(dphd.dphd_sh_fname,'') <> ''  
                                      AND    CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
                  
                  
                  
                insert into  @line4(ln_no                   
                                   ,crn_no                  
                                   ,acct_no                  
                                   ,bo_name2                  
                                   ,bo_mid_name2                  
                                   ,cust_search_name2                   
                                   ,bo_title2                           
                                   ,bo_suffix2                          
                                   ,hldr_fth_hsd_nm2                    
                                   ,hldr_pan2                           
                                   ,it_crl2)                   
                                   SELECT distinct '04'                  
                                               , clim_crn_no                  
                                               , dpam_acct_no                  
                                               , isnull(dphd_th_fname,'') 
                                               , isnull(dphd_th_mname,'')                  
                                               , isnull(dphd_th_lname,'')                  
                                               , case when DPHD_TH_GENDER in ('M','MALE') then 'MR'  when DPHD_TH_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end                                
                                               , ''                  
                                               , isnull(dphd_th_fthname,'')           
                                               , isnull(dphd_th_pan_no,'')                  
                                               , ''--  
                                    FROM   dp_acct_mstr              dpam                  
                                           left outer join   
                                           dp_holder_dtls            dphd                 on dpam.dpam_id            = dphd.dphd_dpam_id                      
                                           left outer join                       
                                           client_bank_accts         cliba                on dpam.dpam_id            = cliba.cliba_clisba_id    
                                           left outer join           
                                           bank_mstr                 banm                 on  convert(int,cliba.cliba_banm_id)     = convert(int,banm.banm_id)          
                                         , client_mstr               clim                  
                                         , entity_type_mstr          enttm                  
                                         , client_ctgry_mstr         clicm                  
                                           left outer join                  
                                           sub_ctgry_mstr            subcm                   
                                           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
                                         , exch_seg_mstr    
                                    WHERE  dpam.dpam_crn_no        = clim.clim_crn_no                   
                                    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
                                    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
                                    AND    dpam.dpam_deleted_ind   = 1            
                                    AND    dpam.dpam_excsm_id      = excsm_id                  
                                    AND    excsm_exch_cd           = @pa_exch  
                                    AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
                                    AND    clim.clim_deleted_ind   = 1                  
                                    AND    isnull(cliba.cliba_deleted_ind,1) = 1                  
                                    AND    isnull(banm.banm_deleted_ind,1)   = 1    
                                    AND    isnull(dphd.dphd_th_fname,'') <> ''  
                                    AND    CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
                  
                  
                                 
               insert into @line5( ln_no                   
                                  ,crn_no                              
                                  ,acct_no                  
                                  ,dt_of_maturity             
                                  ,dp_int_ref_no                       
                                  ,dob                                 
                                  ,sex_cd                              
                                  ,occp                                
                                  ,life_style                          
                                  ,geographical_cd                     
                                  ,edu                                 
                                  ,ann_income_cd                       
                                  ,nat_cd                              
                                  ,legal_status_cd                     
                                  ,bo_fee_type                         
                                  ,lang_cd                             
                                  ,category4_cd                        
                                  ,bank_option5                        
                                  ,staff                               
                                  ,staff_cd                            
                                  ,bo2_usr_txt1                        
                                  ,bo2_usr_txt2                        
                                  ,dummy1                              
                                  ,dummy2                              
                                  ,dummy3                              
                                  ,secur_acc_cd                        
                                  ,bo_catg                             
                                  ,bo_settm_plan_fg                    
                                  ,voice_mail                          
                                  ,rbi_ref_no                          
                                  ,rbi_app_dt                    
                                  ,sebi_reg_no                         
                                  ,benef_tax_ded_sta                   
                                  ,smart_crd_req                       
                                  ,smart_crd_no                        
                                  ,smart_crd_pin                       
                                  ,ecs                                 
                                  ,elec_confirm                        
                                  ,dividend_curr                       
                                  ,group_cd                            
                                  ,bo_sub_status                       
                                  ,clr_corp_id                         
                                  ,clr_member_id                       
                                  ,stoc_exch                           
                                  ,confir_waived                       
                                  ,trading_id                          
                                  ,bo_statm_cycle_cd                   
                                  ,benf_bank_code                      
                                  ,benf_brnch_numb                     
                                  ,benf_bank_acno                      
                                  ,benf_bank_ccy                       
                                  ,divnd_brnch_numb                    
                                  ,divnd_bank_code                     
                                  ,divnd_acct_numb                     
                                  ,divnd_bank_ccy)                  
                                  SELECT distinct '05'                  
                                       , clim_crn_no                  
                                       , dpam_acct_no                  
                                       , case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'date_of_maturity',''),'00000000')= '' then '00000000' else isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'date_of_maturity',''),'00000000') end  --dt_of_maturity                  
									                              , left(dpam_acct_no,8)--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'dp_int_ref_no',''),'')  --dp_int_ref_no                  
                                       , case when isnull(convert(varchar(11),clim.clim_dob,103),'00000000') = '01/01/1900' then '00000000' else   isnull(convert(varchar(11),clim.clim_dob,103),'00000000')  end                
                                       , isnull(clim.clim_gender,'')                  
                                       , CASE WHEN citrus_usr.fn_get_listing('occupation',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'occupation',''),'')) = '' THEN 'O' ELSE citrus_usr.fn_get_listing('occupation',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'occupation',''),'')) END --occupation          
                                       , ''  
                                       , citrus_usr.fn_get_listing('GEOGRAPHICAL',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'GEOGRAPHICAL',''),''))   --geographical_cd                  
                                       , citrus_usr.fn_get_listing('EDUCATION',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'EDUCATION',''),''))    --edu                  
                                       , citrus_usr.fn_get_listing('ANNUAL_INCOME',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'ANNUAL_INCOME',''),''))--isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,''),'')   --ann_income_cd                  
                                       , citrus_usr.fn_get_listing('NATIONALITY',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'NATIONALITY',''),''))   --nat_cd                  
                                       , CASE WHEN citrus_usr.fn_ucc_entp(clim.clim_crn_no,'legal_sta','')='' THEN '00' ELSE isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'legal_sta',''),'00') END  --legal_status_cd                  
                                       , CASE WHEN citrus_usr.fn_ucc_entp(clim.clim_crn_no,'bofeetype','')='' THEN '00' ELSE isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'bofeetype',''),'00') END    --bo_fee_type                  
                                       ,  citrus_usr.fn_get_listing('LANGUAGE',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'LANGUAGE',''),''))    --lang_cd                  
                                       , '00'--'' -- category4_cd                  
                                       , '00'--'' -- bank_option5                  
                                      , case when dpam_clicm_cd in ('21' , '24' , '27') then  left(isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'STAFF',''),''),1) else '' end              
                                       , '' -- staff_cd                  
                                       , '' -- usr_txt1                  
                                       , '' -- usr_txt2                  
                                       , '0000'--'' -- dummy1                  
                                       , '0000'--'' -- dummy2                  
                                       , '0000'--'' -- dummy3                  
                                       , '00'--'' -- secur_acc_cd                  
                                       , left(enttm_cd,2)  
                                       , case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'bosettlflg',''),'')  <>  '' then 'Y' else 'N' end --bo_settm_plan_fg                  
                                       , isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'voice_mail',''),'')  --voice_mail                               
                                       , isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'rbi_ref_no',''),'')  --rbi_ref_no                               
                                       , isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'rbi_app_dt',''),'00000000')  --rbi_app_dt                               
                                       , isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'sebi_regn_no',''),'')  --sebi_reg_no                              
                                       , citrus_usr.fn_get_listing('TAX_DEDUCTION',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'TAX_DEDUCTION',''),''))  --benef_tax_ded_sta                        
                                       , case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'SMART_CARD_REQ',''),'') <> '' then 'Y' else '' end                           
                                       , isnull(citrus_usr.fn_ucc_accpd(dpam.dpam_id,'SMART_CARD_REQ','SMART_CARD_NO',''),'')                             
                                       , isnull(citrus_usr.fn_ucc_accpd(dpam.dpam_id,'SMART_CARD_REQ','SMART_CARD_PIN',''),'0000000000')--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')  --smart_crd_pin                            
                                       , Case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ecs_flg',''),'')=1 then 'Y' when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ecs_flg',''),'')=0 then 'N' else 'N' end  --ecs                                   
                                       , Case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ecs_flg',''),'')=1 THEN '' ELSE  Case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'elec_conf',''),'')=1 then 'Y' when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ecs_flg',''),'')=0 then '' else '' end  END --elec_confirm                             
                                       , citrus_usr.fn_get_listing('dividend_currency',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'dividend_currency',''),''))  --dividend_curr                            
                                       , ''  
                                       , isnull(right(subcm.subcm_cd,2),'')                            
                                       , isnull(citrus_usr.get_ccm_id(isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')),'000000')                  
                                       , isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBP_ID',''),'')                   
                                       , case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')  = 'NSE'     then '12'             
																																									when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')  = 'BSE' then '11'
																																									when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')  = 'MCX' then '23'
																																									when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')  = 'NCDEX' then '22'
																																									when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')  = 'DSE' then '14'
																																									when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')  = 'CSE' then '13'
																																									else '00' end 

                                       , CASE WHEN isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'confirmation',''),'')='1' THEN 'Y' WHEN isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'confirmation',''),'')='0' THEN 'N'  ELSE 'N' END   --confir_waived                  
                                       ,isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'TRADINGID_NO',''),'')           
                                       , citrus_usr.fn_get_listing('bostmntcycle',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'bostmntcycle',''),''))  --bo_statm_cycle_cd                  
                                       , case when banm_micr=0 then space(12) else isnull(banm_micr,space(12)) end                   
                                       , case when cliba_ac_type='SAVINGS' THEN '10' WHEN  cliba_ac_type='CURRENT' THEN '11' WHEN cliba_ac_type='OTHERS' THEN '13' ELSE convert(char(12),cliba_ac_type) END                 --convert(char(12),banm_branch)                  
                                       , cliba_ac_no                  
                                       , citrus_usr.fn_get_listing('BANKCCY',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'BANKCCY',''),''))               
                                       , case when cliba_ac_type='SAVINGS' THEN '10' WHEN  cliba_ac_type='CURRENT' THEN '11' WHEN cliba_ac_type='OTHERS' THEN '13' ELSE convert(char(12),cliba_ac_type) END                 --convert(char(12),banm_branch)                                  
                                       , case when banm_micr=0 then space(12) else isnull(banm_micr,space(12)) end                    
                                       , cliba_ac_no                  
                                       , citrus_usr.fn_get_listing('BANKCCY',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'BANKCCY',''),''))--''                  
                                  FROM   dp_acct_mstr              dpam                  
                                         left outer join   
																																									dp_holder_dtls            dphd                 on dpam.dpam_id            = dphd.dphd_dpam_id                      
																																									left outer join                       
																																									client_bank_accts         cliba                on dpam.dpam_id            = cliba.cliba_clisba_id    
																																									left outer join           
                                         bank_mstr                 banm                 on  convert(int,cliba.cliba_banm_id)     = convert(int,banm.banm_id)          
                                       , client_mstr               clim                  
                                       , entity_type_mstr          enttm        
                                       , client_ctgry_mstr         clicm                  
                                         left outer join                  
                                         sub_ctgry_mstr            subcm                   
                                         on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
                                         ,exch_seg_mstr  
                                  WHERE  dpam.dpam_crn_no            = clim.clim_crn_no                   
                                  AND    dpam.dpam_enttm_cd          = enttm.enttm_cd                  
                                  AND    dpam.dpam_clicm_cd          = clicm.clicm_cd        
                                   AND    dpam.dpam_subcm_cd          = subcm.subcm_cd        
                                  AND    dpam.dpam_crn_no            = clim.clim_crn_no        
                                  AND    dpam.dpam_excsm_id      = excsm_id                  
                                  AND    excsm_exch_cd           = @pa_exch  
                                  --AND    cliba.cliba_clisba_id       = clisba.clisba_id                    
                                  AND    dpam.dpam_deleted_ind       = 1                  
                                  AND    isnull(dphd.dphd_deleted_ind,1)       = 1                   
                                  AND    isnull(clim.clim_deleted_ind,1)       = 1                  
                                  AND    isnull(cliba.cliba_deleted_ind,1)     = 1                  
                                  AND    isnull(banm.banm_deleted_ind,1)       = 1        
                                        
                                  AND    CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
          
          
          
--                               insert into @line6(ln_no                   
--                                         ,crn_no                  
--                                         ,acct_no                  
--                                         ,poa_id                                    
--                                         ,setup_date                                
--                                         ,poa_to_opr_ac                             
--                                         ,gpa_bpa_fl                                
--                                         ,eff_frm_dt                                
--                                         ,eff_to_dt                                 
--                                         ,usr_fld1                                  
--                                         ,usr_fld2                                  
--                                         ,ca_charfld                                
--                                         ,bo_name3                                
--                                         ,bo_mid_name3                               
--                                         ,cust_srh_name3                            
--                                         ,bo_title3                                 
--                                         ,bo_suffix3                                
--                                         ,hldr_fth_hsb_nm3                          
--                                         ,cus_addr1                                 
--                                         ,cust_addr2                                
--                                         ,cust_addr3                                
--                                         ,cust_city                                 
--                                         ,cust__state                               
--                                         ,cust_cntry                                
--                                         ,cust_zip                                  
--                                         ,cust_ph1_ind                              
--                                         ,cust_ph1                                  
--                                         ,cust_ph2_ind                              
--                                         ,cust_ph2                                  
--                                         ,cust_addl_ph                              
--                                         ,cust_fax                                  
--                                         ,pan_no                                    
--                                         ,it_crc                                    
--                                         ,cust_email                                
--                                         ,bo3_usr_txt1                              
--                                         ,bo3_usr_txt2                              
--                                         ,bo3_usr_fld3                                  
--                                         ,bo3_usr_fld4                              
--                                         ,bo3_usr_fld5                  
--                                         ,sign_poa                  
--                                         ,sign_file_fl)                  
--                                         SELECT distinct '06'                  
--																																																,clim_crn_no                  
--																																																,isnull(dpam.dpam_acct_no,'')                  
--																																																,CITRUS_USR.FN_FORMATSTR(dppd_poa_id,16-len(dppd_poa_id),len(dppd_poa_id),'R',' ') dppd_poa_id--isnull(dppd_poa_id,replicate(0,16)) dppd_poa_id              
--																																																,convert(char(11),dppd_setup)                  
--																																																,case when dppd_poa_type = 'FULL' then 'Y' else 'N' END                  
--																																																,dppd_gpabpa_flg  
--																																																,dppd_eff_fr_dt--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')                    
--																																																,dppd_eff_to_dt--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')                    
--																																															,'0000'--''--usr_fld1                                  
--                                               ,'0000'--''--usr_fld2                                  
--                                               ,''--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')                    
--                                               ,''--isnull(dppd.dppd_fname,'') 
--                                               ,''--isnull(dppd.dppd_mname,'')                         
--                                               ,''--convert(char(20),isnull(dppd.dppd_lname,''))     
--                                               ,''--bo_title3                                 
--                                               ,''--bo_suffix3                                
--                                               ,''--isnull(dppd.dppd_fthname,'')                              
--                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),1)--adr1                       
--                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),2)--adr1                  
--                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),3)--adr1                  
--                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),4)--adr1                  
--                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),5)--adr1                  
--                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),6)--adr1                  
--                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),7)--adr1                  
--                                               ,''--case when isnull(citrus_usr.fn_dp_import_conc(dpam.dpam_id,'POA_OFF_PH1'),'') <> '' then  'O'    ELSE ''                                                     end                
--                                               ,''--case when isnull(citrus_usr.fn_dp_import_conc(dpam.dpam_id,'POA_OFF_PH1'),'') <> '' then  isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'POA_OFF_PH1'),'')                                    end                                   
--                                               ,''--cust_ph2_ind                              
--                                               ,''  
--                                               ,''  
--                                               ,''  
--                                               ,''--dppd_pan_no  
--                                               ,''  
--                                               ,''  
--                                               ,isnull(dppd_master_id,'0')
--                                               ,''--bo3_usr_txt2                              
--                                               ,CASE WHEN dppd_hld = '1st holder' THEN  '0001'
--																																																WHEN dppd_hld = '2nd holder' THEN  '0002'
--																																																WHEN dppd_hld = '3rd holder' THEN  '0003' ELSE '0000' end                            
--                                               ,'0000'--''--bo3_usr_fld4                              
--                                               ,'0000'--''--bo3_usr_fld5                                    
--																																															,ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_POA',''),'')                  
--																																															,case when ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_POA',''),'') = '' then 'N' else 'Y'   end  --signature file flag           
--																																								FROM   dp_acct_mstr              dpam          
--																																															left outer join                  
--																																															dp_poa_dtls                   dppd                  
--																																															on dpam.dpam_id             = dppd.dppd_dpam_id                  
--																																													, client_mstr               clim                  
--																																													, entity_type_mstr          enttm                  
--																																													, client_ctgry_mstr         clicm                  
--																																															left outer join                  
--																																															sub_ctgry_mstr            subcm                   
--																																															on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
--																																															,exch_seg_mstr  
--																																								WHERE  dpam.dpam_crn_no        = clim.clim_crn_no                  
--																																								AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
--																																								AND    isnull(dpam.dpam_batch_no,0) = 0   
--																																								AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
--																																								AND    dpam.dpam_excsm_id      = excsm_id                  
--																																							AND    excsm_exch_cd           = @pa_exch  
--																																							AND    dpam.dpam_deleted_ind   = 1                  
--																																							AND    clim.clim_deleted_ind   = 1  
--																																							AND    dppd.dppd_deleted_ind   =1   
--																																							AND    isnull(dppd.dppd_fname,'')  <> ''
--																																							--AND    dppd_hld ='1St HOLDER'        
--																																							AND    getdate() between dppd_eff_fr_dt and  CASE WHEN isnull(dppd_eff_to_dt,'01/01/2100') ='01/01/1900' THEN '01/01/2100' ELSE isnull(dppd_eff_to_dt,'01/01/2100') END --isnull(dppd_eff_to_dt,'01/01/2100')           
--																																							AND    CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
--																																							AND    isnull(dppd_poa_type,'') IN ('FULL','PAYIN ONLY')         
                                         --        
                                 insert into  @line7(ln_no                                    
                                  ,crn_no                   
                                  ,acct_no                  
                                  ,Purpose_code                             
                                  ,bo_name                  
                                  ,bo_middle_nm                             
                                  ,cust_search_name                         
                                  ,bo_title                                 
                                  ,bo_suffix                                
                                  ,hldr_fth_hs_name                         
                                  ,cust_addr1                               
                                  ,cust_addr2                               
                                  ,cust_addr3                                                         
                                  ,cust_city                                
                                  ,cust_state                               
                                  ,cust_cntry                               
                                  ,cust_zip                                 
                                  ,cust_ph1_id                              
                                  ,cust_ph1                                 
                                  ,cust_ph2_in                              
                                  ,cust_ph2                                 
                                  ,cust_addl_ph                                
                                  ,cust_fax                                 
                                  ,hldr_in_tax_pan                          
                                  ,it_crl                                   
                                  ,cust_email                               
                                  ,usr_txt1                                 
                                  ,usr_txt2                                 
                                  ,usr_fld3                                 
                                  ,usr_fld4                                 
                                  ,usr_fld5                                 
                                  )                     
                                   SELECT ln_no                                    
                                  ,crn_no                   
                                  ,acct_no                  
                                  ,Purpose_code                             
                                  ,bo_name                  
                                  ,bo_middle_nm                             
                                  ,cust_search_name                         
                                  ,bo_title                                 
                                  ,bo_suffix                                
                                  ,hldr_fth_hs_name                         
                                  ,cust_addr1                               
                                  ,cust_addr2                               
                                  ,cust_addr3                                                         
                                  ,cust_city                                
                                  ,cust_state                               
                                  ,cust_cntry                               
                                  ,cust_zip                                 
                                  ,cust_ph1_id                              
                                  ,cust_ph1                                 
                                  ,cust_ph2_in                              
                                  ,cust_ph2                                 
                                  ,cust_addl_ph                                
                                  ,cust_fax                                 
                                  ,hldr_in_tax_pan                          
                                  ,it_crl                                   
                                  ,cust_email                               
                                  ,usr_txt1                                 
                                  ,usr_txt2                                 
                                  ,CASE WHEN usr_fld3=0 THEN '0000' ELSE usr_fld3 END                                 
                                  ,CASE WHEN usr_fld4=0 THEN '0000' ELSE usr_fld4 END                                  
                                  ,CASE WHEN usr_fld5=0 THEN '0000' ELSE usr_fld5 END         
                                  FROM fn_cdsl_export_line_7_extract(@pa_crn_no, @pa_from_dt, @pa_to_dt), dp_acct_mstr , EXCH_SEG_MSTR esm  
                                            WHERE dpam_acct_no = acct_no AND dpam_excsm_id =  excsm_id 
                                            AND   excsm_exch_cd = @pa_exch
                                            ORDER BY Purpose_code  DESC 
                                            
                                            
                                            
--                                             INSERT INTO  @line8 (ln_no               
--																																													,crn_no            
--																																													,acct_no                    
--																																													,purposecode           
--																																													,flag                   
--																																													,mobile                      
--																																													,email                  
--																																													,remarks                  
--																																													,push_flg                      
--																																											)    
--																																							    SELECT distinct '08'                  
--																																											,clim_crn_no                  
--																																											,dpam_acct_no                  
--																																											,'16' --''--Purpose_code                             
--																																											,'S'
--																																											,CASE WHEN CITRUS_USR.fn_acct_conc_value(DPAM_ID,'MOBILE1')<> '' THEN CITRUS_USR.fn_acct_conc_value(DPAM_ID,'MOBILE1')
--																																																	ELSE CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'MOBILE1') END
--																																											,CASE WHEN CITRUS_USR.fn_acct_conc_value(DPAM_ID,'EMAIL1')<> '' THEN CITRUS_USR.fn_acct_conc_value(DPAM_ID,'EMAIL1')
--																																																	ELSE CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'EMAIL1') END 
--																																											,''
--																																											,'P'
--																																	           FROM   dp_acct_mstr              dpam ,client_mstr  ,EXCH_SEG_MSTR esm    ,account_properties accp           
--																																												WHERE clim_crn_no = dpam_crn_no 
--																																												AND   dpam_excsm_id = excsm_id 
--																																												AND   accp_clisba_id = dpam_id
--																																												AND    accp.accp_accpm_prop_cd = 'SMS_FLAG'
--																																												AND    accp.accp_value = '1' 
--																																												AND   excsm_exch_cd = @pa_exch
--																																												--AND   (CITRUS_USR.fn_acct_conc_value(DPAM_ID,'MOBILE1')<>'' OR CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'MOBILE1')<>'')
--																																												AND    CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
--               
      --                  
      END                  
      ELSE IF @pa_crn_no <> ''                  
      BEGIN                  
      --                  
        insert into @line2( ln_no                  
                           ,crn_no                  
                           ,acct_no                  
                           ,product_number                       
                           ,bo_name                              
                           ,bo_middle_name                       
                           ,cust_search_name                     
                           ,bo_title                             
                           ,bo_suffix                            
                           ,hldr_fth_hsd_nm                      
                           ,cust_addr1                           
                           ,cust_addr2                           
                           ,cust_addr3                           
                           ,cust_addr_city                       
                           ,cust_addr_state                      
                           ,cust_addr_cntry                      
                           ,cust_addr_zip                      
                           ,cust_ph1_ind                         
                           ,cust_ph1                             
                           ,cust_ph2_ind                         
                           ,cust_ph2                             
                           ,cust_addl_ph                         
                           ,cust_fax                             
                           ,hldr_pan                
                           ,it_crl                               
                           ,cust_email                           
                            ,bo_usr_txt1                          
                           ,bo_usr_txt2                          
                           ,bo_user_fld3                         
                           ,bo_user_fld4                 
                           ,bo_user_fld5                  
                           ,sign_bo                  
                           ,sign_fl_flag)                  
                           SELECT distinct '02'                  
                                , clim_crn_no                  
                                , dpam_acct_no                  
                                , citrus_usr.Fn_FormatStr(left(subcm_cd,2),4,0,'L','0')                  
                                , case when dpam_clicm_cd in ('21' , '24' , '27') then CITRUS_USR.inside_trim(LTRIM(RTRIM(DPAM_SBA_NAME)),'1') 
                                  else LTRIM(RTRIM(dpam_sba_name))  end
                                , case when dpam_clicm_cd in ('21' , '24' , '27') then CITRUS_USR.inside_trim(LTRIM(RTRIM(DPAM_SBA_NAME)),'2')
                                  else '' end
                                , case when dpam_clicm_cd in ('21' , '24' , '27') then CITRUS_USR.inside_trim(LTRIM(RTRIM(DPAM_SBA_NAME)),'3')
                                  else '.' end          
                                , case when CLIM_GENDER in ('M','MALE') then 'MR'  when CLIM_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end              
                                , ''                  
                                , ISNULL(dphd_fh_fthname,'')  --father/husband name                  
                                , case when citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_COR_ADR1'),''),1) <> '' 
                                       then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_COR_ADR1'),''),1) 
                                       else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),1) end --adr1                  
                                , case when citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_COR_ADR1'),''),1) <> ''
                                       then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_COR_ADR1'),''),2)
                                       else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),2) end--adr2                  
                                , case when citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_COR_ADR1'),''),1) <> ''
                                       then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_COR_ADR1'),''),3)
                                       else  citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),3) end--adr3                  
                                , case when citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_COR_ADR1'),''),1) <> ''
                                       then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_COR_ADR1'),''),4)
                                       else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),4) end--adr_city                  
                                , case when citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_COR_ADR1'),''),1) <> ''
                                       then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_COR_ADR1'),''),5)
                                       else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),5) end--adr_state                  
                                , case when citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_COR_ADR1'),''),1) <> ''
                                       then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_COR_ADR1'),''),6)
                                       else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),6) end--adr_country                  
                                , case when citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_COR_ADR1'),''),1) <> ''
                                       then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_COR_ADR1'),''),7)
                                       else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),7) end --adr_zip                   
                                , isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'Y'),'')  
                                , isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'N'),'')   --convert(varchar(17),isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH1'),''))--ph1                  
                                , isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'Y'),'')            --'0'                  
                                , isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'N'),'')  --isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH2'),'')--ph2                  
                                , isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,3,'N'),'')                    
                                , CASE WHEN isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCFAX1'),'') <> '' THEN isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCFAX1'),'') ELSE isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'FAX1'),'') END --fax                               
                                , isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'')  --pan card                  
                                , ''  
                                , CASE WHEN lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCEMAIL1'),'')) <> '' THEN lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCEMAIL1'),'')) ELSE lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'EMAIL1'),'')) END --email                          
                                , ''                  
                                , ''                  
                                , '0000'                  
                                , ''                  
                                , case when isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'') <> '' then '1' else '0' end + case when isnull(DPHD_SH_PAN_NO,'') <> '' then '1' else '0' end + case when  isnull(DPHD_TH_PAN_NO,'') <> '' then '1' else '0' end + '0'                
                                ,ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_BO',''),'')                  
                                , case when ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_BO',''),'') = '' then 'N' else 'Y'   end --signature file flag                  
                  
                          FROM   dp_acct_mstr              dpam                  
                                 left outer join      
                                 dp_holder_dtls            dphd                  on dpam.dpam_id            = dphd.dphd_dpam_id                      
                                 left outer join    
                                 client_bank_accts         cliba                on dpam.dpam_id            = cliba.cliba_clisba_id    
                                 left outer join           
                                 bank_mstr                 banm                 on  convert(int,cliba.cliba_banm_id)     = convert(int,banm.banm_id)          
                               , client_mstr               clim                  
                               , @crn                      crn  
                               , entity_type_mstr          enttm                  
                               , client_ctgry_mstr         clicm                  
                               , sub_ctgry_mstr            subcm                   
                               , exch_seg_mstr      
                           WHERE  dpam.dpam_crn_no        = clim.clim_crn_no                  
                           AND    crn.crn                 = clim.clim_crn_no                  
                           AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
                           AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
                           AND    subcm.subcm_CD          = DPAM.DPAM_SUBCM_CD    
                           AND    subcm.subcm_deleted_ind = 1                  
                           AND    dpam.dpam_deleted_ind   = 1                  
                           AND    dpam.dpam_excsm_id      = excsm_id                  
                           AND    excsm_exch_cd           = @pa_exch  
                           AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
                           AND    clim.clim_deleted_ind   = 1                  
                           AND    isnull(cliba.cliba_deleted_ind,1) = 1                  
                           AND    banm.banm_deleted_ind   = 1                  
                           AND    CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
                          
                          
                           insert into @line3(ln_no                   
                                             ,crn_no                   
                                             ,acct_no                  
                                             ,bo_name1                                
                                             ,bo_mid_name1                            
                                             ,cust_search_name1                       
                                             ,bo_title1                               
                                             ,bo_suffix1                              
                                             ,hldr_fth_hsd_nm1                        
                                             ,hldr_pan1                               
                                             ,it_crl1)                  
                                             SELECT distinct '03'                  
                                                  , clim_crn_no                  
                                                  , dpam_acct_no                  
                                                  , isnull(dphd_sh_fname,'') 
                                                  , isnull(dphd_sh_mname,'')                  
                                                  , isnull(dphd_sh_lname,'')                  
                                                  , case when DPHD_SH_GENDER in ('M','MALE') then 'MR'  when DPHD_SH_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end                                          
                                                  , ''         
                                                  , isnull(dphd_sh_fthname,'')                  
                                                  , isnull(dphd_sh_pan_no,'')                  
                                                  , ''--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CLIENT_IT',''),'')  --it circle                  
                                              FROM   dp_acct_mstr              dpam                  
                                                     left outer join   
                                                     dp_holder_dtls            dphd                 on dpam.dpam_id            = dphd.dphd_dpam_id                      
                                                     left outer join                       
                                                     client_bank_accts         cliba                on dpam.dpam_id            = cliba.cliba_clisba_id    
                                                     left outer join           
                                                     bank_mstr                 banm                 on  convert(int,cliba.cliba_banm_id)     = convert(int,banm.banm_id)          
                                                   , client_mstr               clim                  
                                                   , @crn                       crn  
                                                   , entity_type_mstr         enttm                  
                                                   , client_ctgry_mstr         clicm                  
                                                     left outer join                  
                                                     sub_ctgry_mstr            subcm                   
                                                     on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
                                                     ,exch_seg_mstr  
                                              WHERE  dpam.dpam_crn_no        = clim.clim_crn_no                  
                                              AND    crn.crn                 = clim.clim_crn_no                  
                                              AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
                                              AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                
                                              AND    dpam.dpam_excsm_id      = excsm_id                  
                                              AND    excsm_exch_cd           = @pa_exch  
                                              AND    dpam.dpam_deleted_ind   = 1                  
                                              AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
                                              AND    clim.clim_deleted_ind   = 1                  
                                              AND    isnull(cliba.cliba_deleted_ind,1) = 1                  
                                              AND    isnull(banm.banm_deleted_ind,1)   = 1 
                                              AND    isnull(dphd.dphd_sh_fname,'') <> ''                   
                                              AND    CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
     
                          
                          
                        insert into  @line4(ln_no                   
                                           ,crn_no                  
                                           ,acct_no                  
                                           ,bo_name2                  
                                           ,bo_mid_name2                  
                                           ,cust_search_name2                   
                                           ,bo_title2                           
                                           ,bo_suffix2                          
                                           ,hldr_fth_hsd_nm2                    
                                           ,hldr_pan2                           
                                           ,it_crl2)                   
                                           SELECT distinct '04'                  
                                           , clim_crn_no                  
                                           , dpam_acct_no                  
                                           , isnull(dphd_th_fname,'') 
                                           , isnull(dphd_th_mname,'')                  
                                           , isnull(dphd_th_lname,'')                  
                                           , case when DPHD_TH_GENDER in ('M','MALE') then 'MR'  when DPHD_TH_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end                                            
                                           , ''                  
                                           , isnull(dphd_th_fthname,'')           
                                           , isnull(dphd_th_pan_no,'')                  
                                               , ''--  
                                            FROM   dp_acct_mstr              dpam                  
                                                   left outer join   
                                                   dp_holder_dtls            dphd                 on dpam.dpam_id            = dphd.dphd_dpam_id                      
                                                   left outer join                       
                                                   client_bank_accts         cliba                on dpam.dpam_id            = cliba.cliba_clisba_id    
                                                   left outer join           
                                                   bank_mstr                 banm                 on  cliba.cliba_banm_id     = banm.banm_id          
                                                 , client_mstr               clim                  
                                                 ,@crn                       crn  
                                                 , entity_type_mstr          enttm                  
                                                 , client_ctgry_mstr         clicm                  
                                                   left outer join                  
                                                   sub_ctgry_mstr            subcm                   
                                                   on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
                                                   ,exch_seg_mstr  
                                            WHERE  dpam.dpam_crn_no        = clim.clim_crn_no                  
                                            AND    crn.crn                 = clim.clim_crn_no                
                                            AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
                                            AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
                                            AND    dpam.dpam_excsm_id      = excsm_id                  
                                            AND    excsm_exch_cd           = @pa_exch  
                                            AND    dpam.dpam_deleted_ind   = 1                  
                                            AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
                                            AND    clim.clim_deleted_ind   = 1                  
                                            AND    isnull(cliba.cliba_deleted_ind,1) = 1                  
                                            AND    isnull(banm.banm_deleted_ind,1)   = 1   
                                            AND    isnull(dphd.dphd_Th_fname,'') <> ''                     
                                            AND    CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
                          
                          
                          
                       insert into @line5( ln_no                   
                                          ,crn_no                              
                                          ,acct_no                  
                                          ,dt_of_maturity                      
                                          ,dp_int_ref_no                       
                                          ,dob                                 
                                          ,sex_cd                              
                                          ,occp                                
                                          ,life_style                          
                                          ,geographical_cd                     
                                          ,edu                                 
                                          ,ann_income_cd                       
                                          ,nat_cd             
                                          ,legal_status_cd                     
                                          ,bo_fee_type                         
                                          ,lang_cd                             
                                          ,category4_cd                        
                                          ,bank_option5                        
                                          ,staff                               
                                          ,staff_cd                            
                                          ,bo2_usr_txt1                        
                                          ,bo2_usr_txt2                        
                                          ,dummy1                              
                                          ,dummy2                              
                                          ,dummy3                              
                                          ,secur_acc_cd                        
                                          ,bo_catg                             
                                          ,bo_settm_plan_fg                    
                                          ,voice_mail                          
                                          ,rbi_ref_no                          
                                          ,rbi_app_dt                          
                                          ,sebi_reg_no                         
                                          ,benef_tax_ded_sta                   
                                          ,smart_crd_req                       
                                          ,smart_crd_no                
                                          ,smart_crd_pin                       
                                          ,ecs                                 
                                          ,elec_confirm                                                                
                                          ,dividend_curr                       
                            ,group_cd                            
                                          ,bo_sub_status                       
                                          ,clr_corp_id                         
                                          ,clr_member_id                       
                                          ,stoc_exch                           
                                          ,confir_waived                       
                                          ,trading_id                          
                                          ,bo_statm_cycle_cd                   
                                          ,benf_bank_code                      
                                          ,benf_brnch_numb                     
                                          ,benf_bank_acno                      
                                          ,benf_bank_ccy                       
                                          ,divnd_brnch_numb                    
                                          ,divnd_bank_code                     
                                          ,divnd_acct_numb                     
                                          ,divnd_bank_ccy)                  
									   SELECT distinct '05'                  
                                       , clim_crn_no                  
                                       , dpam_acct_no                  
                                       , case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'date_of_maturity',''),'00000000')= '' then '00000000' else isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'date_of_maturity',''),'00000000') end  --dt_of_maturity                  
									   , left(dpam_acct_no,8)--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'dp_int_ref_no',''),'')  --dp_int_ref_no                  
                                       , case when isnull(convert(varchar(11),clim.clim_dob,103),'00000000') = '01/01/1900' then '00000000' else   isnull(convert(varchar(11),clim.clim_dob,103),'00000000')  end                
                                       , isnull(clim.clim_gender,'')                  
                                       , CASE WHEN citrus_usr.fn_get_listing('occupation',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'occupation',''),'')) = '' THEN 'O' ELSE citrus_usr.fn_get_listing('occupation',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'occupation',''),'')) END
                                       , ''  
                                       , citrus_usr.fn_get_listing('GEOGRAPHICAL',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'GEOGRAPHICAL',''),''))   --geographical_cd                  
                                       , citrus_usr.fn_get_listing('EDUCATION',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'EDUCATION',''),''))    --edu                  
                                       , citrus_usr.fn_get_listing('ANNUAL_INCOME',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'ANNUAL_INCOME',''),''))--isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,''),'')   --ann_income_cd                  
                                       , citrus_usr.fn_get_listing('NATIONALITY',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'NATIONALITY',''),''))   --nat_cd                  
                                       , CASE WHEN citrus_usr.fn_ucc_entp(clim.clim_crn_no,'legal_sta','')='' THEN '00' ELSE isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'legal_sta',''),'00') END  --legal_status_cd                  
                                       , CASE WHEN citrus_usr.fn_ucc_entp(clim.clim_crn_no,'bofeetype','')='' THEN '00' ELSE isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'bofeetype',''),'00') END    --bo_fee_type                  
                                       ,  citrus_usr.fn_get_listing('LANGUAGE',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'LANGUAGE',''),''))    --lang_cd                  
                                       , '00'--'' -- category4_cd                  
                                       , '00'--'' -- bank_option5                  
                                       , case when dpam_clicm_cd in ('21' , '24' , '27') then  left(isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'STAFF',''),''),1) else '' end              
                                       , '' -- staff_cd                  
                                       , '' -- usr_txt1                  
                                       , '' -- usr_txt2                  
                                       , '0000'--'' -- dummy1                  
                                       , '0000'--'' -- dummy2                  
                                       , '0000'--'' -- dummy3                  
                                       , '00'--'' -- secur_acc_cd                  
                                       , left(enttm_cd,2)  
                                       , case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'bosettlflg',''),'')  <>  '' then 'Y' else 'N' end --bo_settm_plan_fg                  
                                       , isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'voice_mail',''),'')  --voice_mail                               
                                       , isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'rbi_ref_no',''),'')  --rbi_ref_no                               
                                       , isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'rbi_app_dt',''),'00000000')  --rbi_app_dt                               
                                       , isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'sebi_regn_no',''),'')  --sebi_reg_no                              
                                       , citrus_usr.fn_get_listing('TAX_DEDUCTION',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'TAX_DEDUCTION',''),''))  --benef_tax_ded_sta                        
                                       , case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'SMART_CARD_REQ',''),'') <> '' then 'Y' else '' end                           
                                       , isnull(citrus_usr.fn_ucc_accpd(dpam.dpam_id,'SMART_CARD_REQ','SMART_CARD_NO',''),'')                             
                                       , isnull(citrus_usr.fn_ucc_accpd(dpam.dpam_id,'SMART_CARD_REQ','SMART_CARD_PIN',''),'0000000000')---isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')  --smart_crd_pin                            
                                       , Case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ecs_flg',''),'')=1 then 'Y' when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ecs_flg',''),'')=0 then 'N' else 'N' end  --ecs                                   
                                       , Case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ecs_flg',''),'')=1 THEN '' ELSE  Case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'elec_conf',''),'')=1 then 'Y' when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ecs_flg',''),'')=0 then '' else '' end  END --elec_confirm                             
                                       , citrus_usr.fn_get_listing('dividend_currency',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'dividend_currency',''),''))  --dividend_curr                            
                                       , ''  
                                       , isnull(right(subcm.subcm_cd,2),'')                            
                                       , isnull(citrus_usr.get_ccm_id(isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')),'000000')                
                                       , isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBP_ID',''),'')                   
                                        , case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')  = 'NSE'     then '12'             
											when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')  = 'BSE' then '11'
											when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')  = 'MCX' then '23'
											when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')  = 'NCDEX' then '22'
											when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')  = 'DSE' then '14'
											when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')  = 'CSE' then '13'
											else '00' end          
                                       , CASE WHEN isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'confirmation',''),'')='1' THEN 'Y' WHEN isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'confirmation',''),'')='0' THEN 'N'  ELSE 'N' END   --confir_waived                  
                                       , '' --trading id                  
                                       , citrus_usr.fn_get_listing('bostmntcycle',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'bostmntcycle',''),''))  --bo_statm_cycle_cd                  
                                       , case when banm_micr=0 then space(12) else isnull(banm_micr,space(12)) end                  
                                       , case when cliba_ac_type='SAVINGS' THEN '10' WHEN  cliba_ac_type='CURRENT' THEN '11' WHEN cliba_ac_type='OTHERS' THEN '13' ELSE convert(char(12),cliba_ac_type) END                 --convert(char(12),banm_branch)                  
                                       , cliba_ac_no                  
                                       , citrus_usr.fn_get_listing('BANKCCY',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'BANKCCY',''),''))               
                                       , case when cliba_ac_type='SAVINGS' THEN '10' WHEN  cliba_ac_type='CURRENT' THEN '11' WHEN cliba_ac_type='OTHERS' THEN '13' ELSE convert(char(12),cliba_ac_type) END                 --convert(char(12),banm_branch)                                  
                                       , case when banm_micr=0 then space(12) else isnull(banm_micr,space(12)) end                   
                                       , cliba_ac_no                  
                                       , citrus_usr.fn_get_listing('BANKCCY',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'BANKCCY',''),''))--''                                 
                                          FROM   dp_acct_mstr              dpam                  
                                                 left outer join   
                                                 dp_holder_dtls            dphd                 on dpam.dpam_id            = dphd.dphd_dpam_id                      
                                                 left outer join                       
                                                 client_bank_accts         cliba                on dpam.dpam_id            = cliba.cliba_clisba_id    
                                                 left outer join           
                                                bank_mstr                 banm                 on  convert(int,cliba.cliba_banm_id)     = convert(int,banm.banm_id)          
                                               , client_mstr               clim                  
                                               ,@crn                       crn  
                                               , entity_type_mstr          enttm        
                                               , client_ctgry_mstr         clicm                  
                                                 left outer join                  
                                                 sub_ctgry_mstr            subcm                   
                                                  on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
                                                  ,exch_seg_mstr  
                                          WHERE  dpam.dpam_crn_no        = clim.clim_crn_no                  
                                          AND    crn.crn                  = clim.clim_crn_no                  
                                          --AND    cliba.cliba_clisba_id   = clisba.clisba_id                  
                                          AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
                                          AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
                                          AND    dpam.dpam_subcm_cd      = subcm.subcm_cd                  
                                          AND    dpam.dpam_excsm_id      = excsm_id                  
                                          AND    excsm_exch_cd           = @pa_exch  
                                          AND    dpam.dpam_deleted_ind   = 1                  
                                          AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
                                          AND    clim.clim_deleted_ind   = 1                  
                                          AND    isnull(cliba.cliba_deleted_ind,1) = 1                  
                                          AND    isnull(banm.banm_deleted_ind,1)   = 1        
                                          AND    CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
                          
                          
--                       insert into @line6(ln_no                   
--                                         ,crn_no                  
--                                         ,acct_no                  
--                                         ,poa_id                                    
--                                         ,setup_date                                
--                                         ,poa_to_opr_ac                             
--                                         ,gpa_bpa_fl                                
--                                         ,eff_frm_dt                                
--                                         ,eff_to_dt                                 
--                                         ,usr_fld1                                  
--                                         ,usr_fld2                                  
--                                         ,ca_charfld                                
--                                         ,bo_name3                                
--                                         ,bo_mid_name3                               
--                                         ,cust_srh_name3                            
--                                         ,bo_title3                                 
--                                         ,bo_suffix3                                
--                                         ,hldr_fth_hsb_nm3                          
--                                         ,cus_addr1                                 
--                                         ,cust_addr2                                
--                                         ,cust_addr3                                
--                                         ,cust_city                                 
--                                         ,cust__state                               
--                                         ,cust_cntry                                
--                                         ,cust_zip                                  
--                                         ,cust_ph1_ind                              
--                                         ,cust_ph1                                  
--                                         ,cust_ph2_ind                              
--                                         ,cust_ph2                                  
--                                         ,cust_addl_ph                              
--                                         ,cust_fax                                  
--                                         ,pan_no                                    
--                                         ,it_crc                                    
--                                         ,cust_email                                
--                                         ,bo3_usr_txt1                              
--                                         ,bo3_usr_txt2                              
--                                         ,bo3_usr_fld3                              
--                                         ,bo3_usr_fld4                              
--                                         ,bo3_usr_fld5                  
--                                         ,sign_poa                  
--                                         ,sign_file_fl)                  
--                                          SELECT distinct '06'                  
--                                               ,clim_crn_no                  
--                                               ,isnull(dpam.dpam_acct_no,'')                  
--                                               ,CITRUS_USR.FN_FORMATSTR(dppd_poa_id,16-len(dppd_poa_id),len(dppd_poa_id),'R',' ') dppd_poa_id --isnull(dppd_poa_id,replicate(0,16))  dppd_poa_id            
--                                               ,convert(char(11),dppd_setup)                  
--                                               ,case when dppd_poa_type = 'FULL' then 'Y' else 'N' END                  
--                                               ,dppd_gpabpa_flg  
--                                               ,dppd_eff_fr_dt--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')                    
--                                               ,dppd_eff_to_dt--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')                    
--                                               ,'0000'--''--usr_fld1                                  
--                                               ,'0000'--''--usr_fld2                                  
--                                               ,''--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')                    
--                                               ,''--isnull(dppd.dppd_fname,'') 
--                                               ,''--isnull(dppd.dppd_mname,'')                         
--                                               ,''--convert(char(20),isnull(dppd.dppd_lname,''))     
--                                               ,''--bo_title3                                 
--                                               ,''--bo_suffix3                                
--                                               ,''--isnull(dppd.dppd_fthname,'')                              
--                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),1)--adr1                       
--                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),2)--adr1                  
--                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),3)--adr1                  
--                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),4)--adr1                  
--                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),5)--adr1                  
--                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),6)--adr1                  
--                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),7)--adr1                  
--                                               ,''--case when isnull(citrus_usr.fn_dp_import_conc(dpam.dpam_id,'POA_OFF_PH1'),'') <> '' then  'O'    ELSE ''                                                     end                
--                                               ,''--case when isnull(citrus_usr.fn_dp_import_conc(dpam.dpam_id,'POA_OFF_PH1'),'') <> '' then  isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'POA_OFF_PH1'),'')                                    end                                   
--                                               ,''--cust_ph2_ind                              
--                                               ,''  
--                                               ,''  
--                                               ,''  
--                                               ,''--dppd_pan_no  
--                                               ,''  
--                                               ,''  
--                                               ,isnull(dppd_master_id,'0')
--                                               ,''--bo3_usr_txt2                              
--                                               ,CASE WHEN dppd_hld = '1st holder' THEN  '0001'
--																																																WHEN dppd_hld = '2nd holder' THEN  '0002'
--																																																WHEN dppd_hld = '3rd holder' THEN  '0003' ELSE '0000' end                            
--                                               ,'0000'--''--bo3_usr_fld4                              
--                                               ,'0000'--''--bo3_usr_fld5                              
--                                               ,ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_POA',''),'')                  
--                                              ,case when ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_POA',''),'') = '' then 'N' else 'Y'   end  --signature file flag           
--                                        FROM   dp_acct_mstr              dpam          
--                                               left outer join                  
--                                               dp_poa_dtls                   dppd                  
--                                               on dpam.dpam_id             = dppd.dppd_dpam_id                  
--                                             , client_mstr               clim                  
--                                             , @crn                       crn  
--                                             , entity_type_mstr          enttm                  
--                                             , client_ctgry_mstr         clicm                  
--                                               left outer join                  
--                                               sub_ctgry_mstr            subcm                   
--                                                on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
--                                                , exch_seg_mstr   
--                                         WHERE  dpam.dpam_crn_no        = clim.clim_crn_no         
--                                         AND    crn.crn                 = clim.clim_crn_no                  
--                                         AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
--                                         AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
--                                         AND    isnull(dpam.dpam_batch_no,0) = 0   
--                                         AND    dpam.dpam_excsm_id      = excsm_id                  
--                                         AND    excsm_exch_cd           = @pa_exch  
--                                         AND    dpam.dpam_deleted_ind   = 1                  
--                                         AND    clim.clim_deleted_ind   = 1     
--                                         AND    dppd.dppd_deleted_ind   =1 
--                                         AND    isnull(dppd.dppd_fname,'')  <> ''
--                                         --AND    dppd_hld ='1St HOLDER'  
--                                         AND    CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
--                                         AND    getdate() between dppd_eff_fr_dt and  CASE WHEN isnull(dppd_eff_to_dt,'01/01/2100') ='01/01/1900' THEN '01/01/2100' ELSE isnull(dppd_eff_to_dt,'01/01/2100') END --isnull(dppd_eff_to_dt,'01/01/2100')   
--                                         AND    isnull(dppd_poa_type,'') IN ('FULL','PAYIN ONLY') 
--                                         order by  dppd_eff_fr_dt   
--                          
                          
                          
                                 insert into  @line7(ln_no                                    
                                           ,crn_no                   
                                           ,acct_no                  
                                           ,Purpose_code                             
                                           ,bo_name                                  
                                           ,bo_middle_nm                             
                                           ,cust_search_name                         
                                           ,bo_title                                 
                                           ,bo_suffix                                
                                           ,hldr_fth_hs_name                         
                                           ,cust_addr1                      
                                           ,cust_addr2                               
                                           ,cust_addr3                               
                                           ,cust_city                                
                                           ,cust_state                               
                                           ,cust_cntry                               
                                           ,cust_zip                                 
                                       ,cust_ph1_id                              
                                           ,cust_ph1                                 
                                           ,cust_ph2_in                              
                                           ,cust_ph2                                 
                                           ,cust_addl_ph                                
                                           ,cust_fax                                 
                                           ,hldr_in_tax_pan                          
                                           ,it_crl                                   
                                           ,cust_email                               
                                       ,usr_txt1          
                                           ,usr_txt2                                 
                                           ,usr_fld3                                 
                                           ,usr_fld4                                 
                                           ,usr_fld5                                 
                                           )                     
                                            SELECT distinct ln_no                                    
                                            ,crn_no                   
                                            ,acct_no                  
                                            ,Purpose_code                             
                                            ,bo_name                  
                                            ,bo_middle_nm                             
                                            ,cust_search_name                         
                                            ,bo_title                                 
                                            ,bo_suffix                                
                                            ,hldr_fth_hs_name                         
                                            ,cust_addr1                               
                                            ,cust_addr2                               
                                            ,cust_addr3                                                         
                                            ,cust_city                                
                                            ,cust_state                               
                                            ,cust_cntry                               
                                            ,cust_zip                                 
                                            ,cust_ph1_id                              
                                            ,cust_ph1                                 
                                            ,cust_ph2_in                              
                                            ,cust_ph2                                 
                                            ,cust_addl_ph                                
                                            ,cust_fax                                 
                                            ,hldr_in_tax_pan                          
                                            ,it_crl                                   
                                            ,cust_email                               
                                            ,usr_txt1                                 
                                            ,usr_txt2                                 
                                            ,CASE WHEN usr_fld3=0 THEN '0000' ELSE usr_fld3 END                                 
                                            ,CASE WHEN usr_fld4=0 THEN '0000' ELSE usr_fld4 END                                  
                                            ,CASE WHEN usr_fld5=0 THEN '0000' ELSE usr_fld5 END        
                                            FROM fn_cdsl_export_line_7_extract(@pa_crn_no, @pa_from_dt, @pa_to_dt), dp_acct_mstr , EXCH_SEG_MSTR esm  
                                            WHERE dpam_acct_no = acct_no AND dpam_excsm_id =  excsm_id 
                                            AND   excsm_exch_cd = @pa_exch
                                            AND   Purpose_code = '12'
                                            ORDER BY Purpose_code  DESC
                                            
                                        
                                        
                                        
                                       
--                                            INSERT INTO  @line8 (ln_no               
--																																													,crn_no            
--																																													,acct_no                    
--																																													,purposecode           
--																																													,flag                   
--																																													,mobile                      
--																																													,email                  
--																																													,remarks                  
--																																													,push_flg                      
--																																											)    
--																																							    SELECT distinct '08'                  
--																																											,clim_crn_no                  
--																																											,dpam_acct_no                  
--																																											,'16' --''--Purpose_code                             
--																																											,'S'
--																																											,CASE WHEN CITRUS_USR.fn_acct_conc_value(DPAM_ID,'MOBILE1')<> '' THEN CITRUS_USR.fn_acct_conc_value(DPAM_ID,'MOBILE1')
--																																																	ELSE CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'MOBILE1') END
--																																											,CASE WHEN CITRUS_USR.fn_acct_conc_value(DPAM_ID,'EMAIL1')<> '' THEN CITRUS_USR.fn_acct_conc_value(DPAM_ID,'EMAIL1')
--																																																	ELSE CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'EMAIL1') END 
--																																											,''
--																																											,'P'
--																																	           FROM   dp_acct_mstr              dpam ,client_mstr  ,account_properties accp,EXCH_SEG_MSTR esm      , @crn                       crn           
--																																												WHERE clim_crn_no = dpam_crn_no 
--																																												AND   crn.crn = clim_crn_no
--																																												AND   dpam_excsm_id = excsm_id 
--																																												AND   accp_clisba_id = dpam_id
--																																												AND    accp.accp_accpm_prop_cd = 'SMS_FLAG'
--																																												AND    accp.accp_value = '1' 
--																																												AND   excsm_exch_cd = @pa_exch
--																																												--AND   (CITRUS_USR.fn_acct_conc_value(DPAM_ID,'MOBILE1')<>'' OR CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'MOBILE1')<>'')
--																																											 AND     CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
--               
      --                  
      END                  
                  
       

  

											
      select distinct l2.sign_bo                  
            ,isnull(l6.sign_poa,'')  sign_poa          
            ,l2.acct_no   Bo_Id                  
            ,ISNULL(l2.ln_no,'02')     ln_no2                  
            ,ISNULL(convert(char(4),l2.product_number)                       
            +convert(char(100),l2.bo_name)                              
            +convert(char(20),l2.bo_middle_name)                      
            +convert(char(20),l2.cust_search_name)                     
            +convert(char(10),l2.bo_title)                             
            +convert(char(10),l2.bo_suffix)                            
            +convert(char(50),l2.hldr_fth_hsd_nm)                      
            +convert(char(30),l2.cust_addr1)                   
            +convert(char(30),l2.cust_addr2)                          
            +convert(char(30),l2.cust_addr3)                          
            +convert(char(25),l2.cust_addr_city)                  
            +convert(char(25),l2.cust_addr_state)                     
            +convert(char(25),l2.cust_addr_cntry)                     
            +convert(char(10),l2.cust_addr_zip)                     
            +convert(char(1),l2.cust_ph1_ind)                     
            +convert(char(17),l2.cust_ph1)                     
            +convert(char(1),l2.cust_ph2_ind)           
            +convert(char(17),l2.cust_ph2)                     
            +convert(char(100),l2.cust_addl_ph)                     
            +convert(char(17),l2.cust_fax)                     
            +convert(char(25),l2.hldr_pan)                     
            +convert(char(15),l2.it_crl)                     
            +convert(char(50),l2.cust_email)                     
            +convert(char(50),l2.bo_usr_txt1)                     
            +convert(char(50),l2.bo_usr_txt2)                  
            +convert(char(4),l2.bo_user_fld3)                     
            +convert(char(4),l2.bo_user_fld4)                     
            +convert(char(4),l2.bo_user_fld5)                  
            +convert(char(1),l2.sign_fl_flag),'') line_two_detail                  
            ,ISNULL(l3.ln_no,'03') ln_no3                  
            ,ISNULL(CONVERT(char(100),l3.bo_name1)                                
            +CONVERT(char(20),l3.bo_mid_name1)                            
            +CONVERT(char(20),l3.cust_search_name1)                       
            +CONVERT(char(10),l3.bo_title1)                   
            +CONVERT(char(10),l3.bo_suffix1)                              
            +CONVERT(char(50),l3.hldr_fth_hsd_nm1)                        
            +CONVERT(char(25),l3.hldr_pan1)                               
            +CONVERT(char(15),l3.it_crl1),'') line_three_detail                  
            ,ISNULL(l4.ln_no,'04') ln_no4                  
            ,ISNULL(CONVERT(char(100),l4.bo_name2)                  
            +CONVERT(char(20),l4.bo_mid_name2)                  
            +CONVERT(char(20),l4.cust_search_name2 )                  
            +CONVERT(char(10),l4.bo_title2         )                  
            +CONVERT(char(10),l4.bo_suffix2        )                  
            +CONVERT(char(50),l4.hldr_fth_hsd_nm2  )                  
            +CONVERT(char(25),l4.hldr_pan2         )                  
            +CONVERT(char(15),l4.it_crl2),'') line_four_detail                  
            ,ISNULL(l5.ln_no,'05') ln_no5                  
            ,ISNULL(CONVERT(char(8),replace(convert(varchar,l5.dt_of_maturity,103),'/',''))                    
            +CONVERT(char(10),l5.dp_int_ref_no   )                    
            +CONVERT(char(8),replace(convert(varchar,l5.dob,103),'/',''))                    
            +CONVERT(char(1),l5.sex_cd)                    
            +CONVERT(char(4),l5.occp)                    
            +CONVERT(char(4),l5.life_style)                    
            +CONVERT(char(4),l5.geographical_cd )                  
            +CONVERT(char(4),l5.edu)                    
            +citrus_usr.Fn_FormatStr(l5.ann_income_cd,4,0,'L','0') --CONVERT(char(4),l5.ann_income_cd)      -- PROB            
            +CONVERT(char(3),l5.nat_cd)                    
            +Isnull(CONVERT(char(2),l5.legal_status_cd),'00')                    
            +Isnull(CONVERT(char(2),l5.bo_fee_type),'00')                    
            +citrus_usr.Fn_FormatStr(l5.lang_cd,2,0,'L','0')--CONVERT(char(2),l5.lang_cd)                -- PROB
            +CONVERT(char(2),l5.category4_cd    )                    
            +CONVERT(char(2),l5.bank_option5    )                    
            +CONVERT(char(1),l5.staff           )                    
            +CONVERT(char(10),l5.staff_cd        )                    
            +CONVERT(char(50),l5.bo2_usr_txt1    )                    
            +CONVERT(char(50),l5.bo2_usr_txt2    )                    
            +CONVERT(char(4),l5.dummy1          )                  
            +CONVERT(char(4),l5.dummy2          )                  
            +CONVERT(char(4),l5.dummy3          )                    
            +CONVERT(char(2),l5.secur_acc_cd    )                    
            +CONVERT(char(2),l5.bo_catg         )                    
            +CONVERT(char(1),l5.bo_settm_plan_fg)                    
            +CONVERT(char(15),l5.voice_mail      )                    
            +CONVERT(char(30),l5.rbi_ref_no      )                    
            +CASE WHEN CONVERT(char(8),replace(convert(varchar,l5.rbi_app_dt,103),'/',''))='' THEN '00000000' ELSE CONVERT(char(8),replace(convert(varchar,l5.rbi_app_dt,103),'/','')) END                     
            +CONVERT(char(24),l5.sebi_reg_no     )                    
            +CONVERT(char(2),l5.benef_tax_ded_sta )                  
            +CONVERT(char(1),l5.smart_crd_req     )                  
            +CONVERT(char(20),l5.smart_crd_no      )                  
            +CONVERT(char(10),l5.smart_crd_pin     )                  
            +CONVERT(char(1),l5.ecs)                  
            +CONVERT(char(1),l5.elec_confirm)                  
            +CONVERT(char(6),l5.dividend_curr     )                              
            +CONVERT(char(8),l5.group_cd          )                  
            +CONVERT(char(2),l5.bo_sub_status     )                  
            +CONVERT(char(6),l5.clr_corp_id       )                  
            +CONVERT(char(8),l5.clr_member_id     )                  
            +CONVERT(char(2),l5.stoc_exch         )                  
            +CONVERT(char(8),l5.confir_waived     )                  
            +CONVERT(char(1),l5.trading_id        )                  
            +CONVERT(char(2),l5.bo_statm_cycle_cd )                  
            +CONVERT(char(12),l5.benf_bank_code    )                  
            +citrus_usr.Fn_FormatStr(LTRIM(RTRIM(l5.benf_brnch_numb)),12,0,'R','') ---CONVERT(char(12),l5.benf_brnch_numb   )                  
            +CONVERT(char(20),l5.benf_bank_acno    )                  
            +CONVERT(char(6),l5.benf_bank_ccy     )                  
            +CONVERT(char(12),l5.divnd_brnch_numb  )                  
            +CONVERT(char(12),l5.divnd_bank_code   )                  
            +CONVERT(char(20),l5.divnd_acct_numb   )                  
            +CONVERT(char(6),l5.divnd_bank_ccy ),'') line_fifth_detail                  
            ,ISNULL(l6.ln_no,'06')  ln_no6
            --, '' line_sixth_detail                 
            ,ISNULL(CONVERT(char(16),l6.poa_id)                                    
            +CONVERT(char(8),replace(convert(varchar, l6.setup_date,103),'/','') )                           
            +CONVERT(char(1),l6.poa_to_opr_ac  )                           
            +CONVERT(char(1),l6.gpa_bpa_fl     )                           
            +CONVERT(char(8),replace(convert(varchar,l6.eff_frm_dt,103),'/','')     )                           
            +CONVERT(char(8),replace(convert(varchar,l6.eff_to_dt,103),'/','')       )                           
            +CONVERT(char(4),l6.usr_fld1       )                           
            +CONVERT(char(4),l6.usr_fld2       )                           
            +CONVERT(char(50),l6.ca_charfld     )                           
            +CONVERT(char(100),l6.bo_name3       )                         
            +CONVERT(char(20),l6.bo_mid_name3   )                            
            +CONVERT(char(20),l6.cust_srh_name3 )                           
            +CONVERT(char(10),l6.bo_title3 )                                
            +CONVERT(char(10),l6.bo_suffix3)                                
            +CONVERT(char(50),l6.hldr_fth_hsb_nm3)                  
            +CONVERT(char(30),l6.cus_addr1   )                              
            +CONVERT(char(30),l6.cust_addr2  )                              
            +CONVERT(char(30),l6.cust_addr3  )                              
            +CONVERT(char(25),l6.cust_city   )                              
            +CONVERT(char(25),l6.cust__state )                              
            +CONVERT(char(25),l6.cust_cntry  )                              
            +CONVERT(char(10),l6.cust_zip    )                              
            +CONVERT(char(1),isnull(l6.cust_ph1_ind,'0'))                              
            +CONVERT(char(17),isnull(l6.cust_ph1,''))                              
            +CONVERT(char(1),l6.cust_ph2_ind)                              
            +CONVERT(char(17),l6.cust_ph2    )                              
            +CONVERT(char(100),l6.cust_addl_ph)                              
            +CONVERT(char(17),l6.cust_fax    )                              
            +CONVERT(char(25),l6.pan_no      )                              
            +CONVERT(char(15),l6.it_crc      )                              
            +CONVERT(char(50),l6.cust_email  )                        
            +CONVERT(char(50),l6.bo3_usr_txt1)                              
            +CONVERT(char(50),l6.bo3_usr_txt2)                              
            +CONVERT(char(4),l6.bo3_usr_fld3)                              
            +CONVERT(char(4),l6.bo3_usr_fld4)                              
            +CONVERT(char(4),l6.bo3_usr_fld5)                              
            +CONVERT(char(1),l6.sign_file_fl),'') line_sixth_detail                  
            ,ISNULL(l7.ln_no,'07')  ln_no7                                  
           ,ISNULL(CONVERT(char(2),l7.Purpose_code)                             
           +CONVERT(char(100),l7.bo_name         )                         
           +CONVERT(char(20),l7.bo_middle_nm    )                         
           +CONVERT(char(20),l7.cust_search_name)                         
           +CONVERT(char(10),l7.bo_title        )                         
           +CONVERT(char(10),l7.bo_suffix       )                         
            +CONVERT(char(50),l7.hldr_fth_hs_name)                         
           +CONVERT(char(30),l7.cust_addr1      )                         
           +CONVERT(char(30),l7.cust_addr2      )                         
           +CONVERT(char(30),l7.cust_addr3      )                         
           +CONVERT(char(25),l7.cust_city       )                         
           +CONVERT(char(25),l7.cust_state      )                         
           +CONVERT(char(25),l7.cust_cntry      )                         
           +CONVERT(char(10),l7.cust_zip        )                         
           +CONVERT(char(1),isnull(l7.cust_ph1_id,'')     )                       
           +CONVERT(char(17),isnull(l7.cust_ph1,'')        )                         
           +CONVERT(char(1),l7.cust_ph2_in     )                         
           +CONVERT(char(17),l7.cust_ph2        )                         
           +CONVERT(char(100),l7.cust_addl_ph    )                            
           +CONVERT(char(17),l7.cust_fax        )                         
           +CONVERT(char(25),l7.hldr_in_tax_pan )                  
           +CONVERT(char(15),l7.it_crl          )                         
           +CONVERT(char(50),l7.cust_email      )                         
           +CONVERT(char(50),l7.usr_txt1        )                         
           +CONVERT(char(50),l7.usr_txt2        )                  
           +CASE WHEN CONVERT(char(4),l7.usr_fld3) =0 THEN '0000' ELSE CONVERT(char(4),l7.usr_fld3) END                         
           +CASE WHEN CONVERT(char(4),l7.usr_fld4) =0 THEN '0000' ELSE CONVERT(char(4),l7.usr_fld4) END                         
           +CASE WHEN CONVERT(char(4),l7.usr_fld5) =0 THEN '0000' ELSE CONVERT(char(4),l7.usr_fld5) END,'') line_seventh_detail 
           ,l7.purpose_code 
           ,'08' ln_no8
           ,isnull(l8.purposecode,'')           
											+CONVERT(char(1),isnull(l8.flag,'') )                  
											+CONVERT(char(10),isnull(l8.mobile,''))                      
											+CONVERT(char(100),isnull(l8.email ,''))                 
											+CONVERT(char(100),isnull(l8.remarks,''))                  
											+CONVERT(char(1),isnull(l8.push_flg,'')  )        line_eigth_detail       
      from   @line2 l2  
             left outer join   
             @line5 l5       on                  l2.acct_no = l5.acct_no                           
             left outer join   
													@line6 l6       on                  l2.acct_no = l6.acct_no 
													left outer join   
													@line7 l7       on                  l2.acct_no = l7.acct_no  
													left outer join   
             @line8 l8       on                  l2.acct_no = l8.acct_no   
													left outer join 
             @line3 l3       on                  l2.acct_no = l3.acct_no                           
             left outer join   
             @line4 l4       on                  l2.acct_no = l4.acct_no       
             
      where  NOT EXISTS (select CDSL_ACCT_ID FROM cdsl_dpm_response where CDSL_ACCT_ID = isnull(l2.acct_no,'0'))                
      order by l2.acct_no asc, line_sixth_detail asc,l7.purpose_code desc
        
        
        
        
--     select @l_counter = COUNT(acct_no) from @line2 l2   
--  
--     SELECT @L_DPM_ID = DPM_ID FROM DP_MSTR WHERE DEFAULT_DP = @PA_EXCSM_ID AND DPM_DELETED_IND = 1   
--  
--  
--     IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='C')  
--     BEGIN  
--     --  
--      
--       INSERT INTO BATCHNO_CDSL_MSTR                                       
--       (    
--        BATCHC_DPM_ID,  
--        BATCHC_NO,  
--        BATCHC_RECORDS ,           
--        BATCHC_TRANS_TYPE,   
--        BATCHC_FILEGEN_DT,   
--        BATCHC_TYPE,  
--        BATCHC_STATUS,  
--        BATCHC_CREATED_BY,  
--        BATCHC_CREATED_DT ,  
--        BATCHC_DELETED_IND  
--       )  
--       VALUES  
--       (  
--        @L_DPM_ID,  
--        @PA_BATCH_NO,  
--        @l_counter,  
--        'ACCOUNT REGISTRATION',  
--        CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' ,  
--        'C',  
--        'P',  
--        @PA_LOGINNAME,  
--        GETDATE(),  
--        1  
--        )  
--       
--       
--       
--       UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
--       WHERE BITRM_PARENT_CD ='CDSL_BTCH_CLT_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID and BITRM_BIT_LOCATION = @PA_EXCSM_ID  
--         
--     --  
--     END  
  --
  END
  
           
          
END

GO
