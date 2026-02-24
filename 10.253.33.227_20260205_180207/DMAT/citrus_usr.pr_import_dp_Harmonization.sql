-- Object: PROCEDURE citrus_usr.pr_import_dp_Harmonization
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------








--pr_import_dp '','CDSL','02/02/2007','13/02/2008','ALL',''                     
--begin tran 
--rollback
--commit 
--[pr_import_dp] '','NSDL','21/12/2009','21/12/2009','N','76',3,'HO',''   
CREATE  PROCeDURE [citrus_usr].[pr_import_dp_Harmonization]( @pa_crn_no      VARCHAR(8000)                  
                            , @pa_exch        VARCHAR(10)                  
                            , @pa_from_dt     VARCHAR(50)                  
                            , @pa_to_dt       VARCHAR(50)                  
                            , @pa_tab         CHAR(3)                  
                            , @PA_BATCH_NO    VARCHAR(25)  
                            , @PA_EXCSM_ID     NUMERIC   
                            , @PA_LOGINNAME    VARCHAR(25)  
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


-- set @pa_from_dt = @pa_from_dt + +' 00:00:00.000'
--  set @pa_to_dt   = @pa_to_dt + +' 23:59:59.999'
            
  DECLARE @crn TABLE (crn          numeric                  
                     ,acct_no      varchar(25)                  
                     ,clim_stam_cd varchar(25)                  
                     ,fm_dt        datetime                  
                     ,to_dt        datetime                  
                     )            
                       
                       
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
          , @l_Value             VARCHAR(8000)                  
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
    DECLARE @l_dp_pri_dtls table(ln_number         numeric                 
    , ben_acct_ctgr     VARCHAR(20)                  
    , entity_type_desc  VARCHAR(50)                  
    , ctgry_desc        VARCHAR(50)                  
    , ben_type          VARCHAR(20)                  
    , ben_sub_type      VARCHAR(20)                  
    , ben_short_name    VARCHAR(16)                  
    , fh_name           VARCHAR(45)                  
    , sh_name           VARCHAR(45)                  
    , th_name           VARCHAR(45)                  
    , addr_pref_flg     CHAR(1)                  
    , fh_pan            CHAR(10)                  
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
    , bank_addr         CHAR(1)                  
    , nom_gur_addr      CHAR(1)                  
    , min_nom_g_addr    CHAR(1)                  
    , for_cor_addr      CHAR(1)                  
    , no_of_fh_at       varchar(2)                  
    , no_of_sh_at       varchar(2)                
    , no_of_th_at       varchar(2)                
    , size_of_sign      VARCHAR(5)                  
    , send_ref_no1      VARCHAR(35)                  
    , send_ref_no2      VARCHAR(35)                  
    , micr_cd       VARCHAR(9)                  
    , bank_acct_type    VARCHAR(20)                  
    , fh_email          VARCHAR(50)                  
    , fh_map_id         VARCHAR(9)                  
    , fh_mob_no         VARCHAR(12)                  
    , fh_sms_fac        CHAR(1)                  
    , fh_poa_fac        CHAR(1)                  
    , fh_pan_flg        CHAR(1)                  
    , sh_email          VARCHAR(50)                  
    , sh_map_id         VARCHAR(9)                  
    , sh_mob_no         VARCHAR(12)                  
    , sh_sms_fac        CHAR(1)                  
    , sh_pan_flg        CHAR(1)                  
    , th_email          VARCHAR(50)                  
    , th_map_id         VARCHAR(9)                  
    , th_mob_no         VARCHAR(12)                  
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
    , dpam_lst_upd_dt   DATETIME                  
    , dpam_sign_path    varchar(8000)                  
    , dpam_fholder_sign VARCHAR(500)                  
    , dpam_sholder_sign VARCHAR(500)                  
    , dpam_tholder_sign VARCHAR(500)                  
    
    )                  
    --      
      
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
        --                  
        END                  
      --                    
      END                  
      --      
    
      --      
      --      
      If ltrim(rtrim(isnull(@l_thirdsms,'') ))   = ''  set @l_thirdsms = 'N'       
      --      
      --      
        INSERT INTO #NO_SIGN_TEMP(dpam_sba_no,NO_OF_FH,NO_OF_SH,NO_OF_TH)          
        SELECT dpam_sba_no,  CONVERT(VARCHAR,SUM(CASE WHEN DPPD_HLD = '1ST HOLDER' THEN TMP.CNT ELSE 0 END)) HLD1,  
        CONVERT(VARCHAR,SUM(CASE WHEN DPPD_HLD = '2ND HOLDER' THEN TMP.CNT ELSE 0 END)) AS HLD2,  
        CONVERT(VARCHAR,SUM(CASE WHEN DPPD_HLD = '3RD HOLDER' THEN TMP.CNT ELSE 0 END)) AS HLD3  
        FROM  
        (  
        SELECT dpam_sba_no  
              ,DPPD_HLD  
              ,COUNT(DPPD_HLD) CNT   
        FROM DP_POA_DTLS   
        ,    DP_ACCT_MSTR   
        WHERE DPAM_ID = DPPD_DPAM_ID   
        AND   DPAM_DELETED_IND =1   
        AND   DPPD_DELETED_IND =1   
        AND  DPPD_LST_UPD_DT  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
       
        GROUP BY dpam_sba_no,DPPD_HLD  
        ) TMP  
        GROUP BY dpam_sba_no  
        


        INSERT INTO @l_dp_pri_dtls  
        (ln_number                  
        , ben_acct_ctgr                  
        , entity_type_desc                  
        , ctgry_desc                  
        , ben_type                            
        , ben_sub_type                        
        , ben_short_name                      
        , fh_name                             
        , sh_name                             
        , th_name                             
        , addr_pref_flg                       
        , fh_pan                              
        , sh_pan                              
        , th_pan             
        , stan_instr_ind                      
        , ben_bank_acct_no                    
        , ben_bank_name                       
        , ben_rbi_ref_no                      
        , ben_rbi_app_dt                      
        , ben_sebi_reg_no                     
        , ben_tax_ded_sts                     
        , local_addr                          
        , bank_addr                           
        , nom_gur_addr                        
        , min_nom_g_addr             
        , for_cor_addr                        
        , no_of_fh_at                         
        , no_of_sh_at                         
        , no_of_th_at                         
        , size_of_sign                        
        , send_ref_no1                        
        , send_ref_no2                        
        , micr_cd                             
        , bank_acct_type                      
        , fh_email                            
        , fh_map_id                           
        , fh_mob_no                           
        , fh_sms_fac                          
        , fh_poa_fac                          
        , fh_pan_flg                          
        , sh_email                            
        , sh_map_id                           
        , sh_mob_no                           
        , sh_sms_fac                          
        , sh_pan_flg                          
        , th_email                            
        , th_map_id                           
        , th_mob_no                           
        , th_sms_fac                          
        , th_pan_flg                          
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
        , dpam_lst_upd_dt                  
        , dpam_sign_path                  
        , dpam_fholder_sign                   
        , dpam_sholder_sign                   
        , dpam_tholder_sign                   
        
        )     
          
        SELECT 0                  
             , convert(varchar(20),enttm_cd)                                                                                                                        --beneficiary account category '02'                  
             , convert(varchar(50),enttm.enttm_desc)                  
             , convert(varchar(50),clicm.clicm_desc)                  
             , convert(varchar(20),isnull(left(subcm.subcm_cd,2),'00')) --beneficiary  type          
             , convert(varchar(20),isnull(right(subcm.subcm_cd,2),'00'))                                                                             --beneficiary sub type                                                              
             , convert(char(16),clim_short_name)--convert(char(16),LTRIM(RTRIM(dpam_sba_name)))                                                                                      --beneficiary short name                                                          
             , convert(char(45),ltrim(rtrim(isnull(CLIM_NAME1,''))) + ' ' + ltrim(rtrim(isnull(CLIM_NAME2,''))) + ' ' + ltrim(rtrim(isnull(CLIM_NAME3,'')))) --isnull(convert(char(45),clim.clim_name1+' ' + ISNULL(clim.clim_name2,'') + ' ' +  ISNULL(clim.clim_name3,'')),'')           --beneficiary first holder name                  
             , isnull(convert(char(45),dphd.dphd_sh_fname + ' ' + ISNULL(dphd.dphd_sh_mname,'') + ' ' + ISNULL(dphd.dphd_sh_lname,'')),'') --beneficiary second holder name                   
             , isnull(convert(char(45),dphd.dphd_th_fname + ' ' + ISNULL(dphd.dphd_th_mname,'') + ' ' + ISNULL(dphd.dphd_th_lname,'')),'') --beneficiary third holder name                  
             , case when convert(char(1),ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ADR_PREF_FLG',''),'')) = '1' then 'Y' else 'N' end    --convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                                  --address preference flag                   
             , convert(char(10),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),''))                                       --First holder pan                  
             , convert(char(10),ISNULL(dphd.dphd_sh_pan_no,''))                                                                            --second holder pan                  
             , convert(char(10),ISNULL(dphd.dphd_th_pan_no,''))                                                                            --third holder pan                  
             , 'Y' --case when convert(char(1),ISNULL(citrus_usr.fn_ucc_accp(clim.clim_crn_no,'STAN_INS_IND',''),'')) in ('','0') then 'N' else 'Y'  end                                                --standing instruction indicator                  
             , convert(char(30),ISNULL(cliba.cliba_ac_no,''))                                                                              --bank account no                   
             , convert(char(35),ISNULL(banm.banm_name ,''))                                                                                --bank name                   
             , convert(char(50),ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'RBI_REF_NO',''),''))   --benrficiary rbi reference no --50                  
             , REPLACE(CONVERT(VARCHAR(11),CONVERT(DATETIME,ISNULL(ISNULL(citrus_usr.fn_ucc_accpd(dpam.dpam_id,'RBI_REF_NO','RBI_APP_DT',''),''),''),103),102),'.','')                                           --benrficiary rbi approval date --8                  
			        
             , convert(char(24),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'SEBI_REGN_NO',''),''))                                                 --beneficiary sebi registration no --24                  
             , citrus_usr.fn_get_listing('TAX_DEDUCTION',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'TAX_DEDUCTION',''),''))  --benef_tax_ded_sta                                                                      --tax deduction status --20             
     
             , 'Y'                                                                                                      --local addr???                  
             , case when ISNULL(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),'') <> '' OR ISNULL(citrus_usr.fn_addr_value(banm_id,'PER_ADR1'),'') <> ''  then 'Y'   else 'N' end                                                                                                                      --bank addr???                    
             , case when (citrus_usr.[fn_acct_addr_value](dpam_id,'NOMINEE_ADR1') <> '' or citrus_usr.[fn_acct_addr_value](dpam_id,'GUARD_ADR') <> '' ) then  'Y' else  'N' end                                         --minor nominee addr???                     
             , case when citrus_usr.[fn_acct_addr_value](dpam_id,'NOM_GUARDIAN_ADDR') <> '' then 'Y' else 'N' end
            ,  CASE WHEN  convert(char(1),ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ADR_PREF_FLG',''),'')) <> '1' THEN 'Y'  
                     ELSE 'N' END  
             , RIGHT('00'+ ISNULL(LTRIM(RTRIM(NO_OF_FH)),'00'),2)
             , RIGHT('00'+ ISNULL(LTRIM(RTRIM(NO_OF_SH)),'00'),2)
                                                                                                          --no of second holder authorized signatories                  
             , RIGHT('00'+ ISNULL(LTRIM(RTRIM(NO_OF_TH)),'00'),2)
             , '#SIG#'                                 --size of signature --size in bytes                  
             , convert(char(35),DPAM.dpam_sba_no)                                                                                                        --sender ref no 1                  
             , convert(char(35),'')                                                                                                        --sender ref no 2                  
             , case when isnull(convert(vARCHAR(30),BANM_MICR),'') = '0' then case when ISNULL(citrus_usr.fn_ACCT_entp(dpam_id,'BENMICR'),'') <> '' then convert(char(9),ISNULL(citrus_usr.fn_ACCT_entp(dpam_id,'BENMICR'),'')) else convert(char(9),'') end  else convert(char(9),isnull(convert(vARCHAR(30),BANM_MICR),'')) end
             , CASE WHEN convert(char(20),cliba_ac_type) IN( 'SAVINGS', 'SAVING')  THEN '10' WHEN convert(char(20),cliba_ac_type) IN('CURRENT') THEN '11' WHEN convert(char(20),cliba_ac_type) IN( 'OTHERS') THEN  '13' else '00' END   --'11'                                                                                          --bank acct type                  
             , CASE WHEN lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCEMAIL1'),'')) <> '' THEN lower(convert(char(50),isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCEMAIL1'),''))) ELSE lower(convert(char(50),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'EMAIL1'),'')))  end                                                --email id for first holder            
             , convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'MAPIN_ID',''),''))                                  --map in id of first holder   --9                  
             , CASE WHEN isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCMOBILE1'),'') <> '' then convert(char(12),isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCMOBILE1'),'')) ELSE convert(char(12),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'MOBILE1'),''))            end                                       --mobile no of first holder  --12                  
             , case when subcm_cd in ('022545') then 'N'
				  when subcm_cd in ('392144') then 'N'
				  when subcm_cd in ('413046') then 'N'
			      WHEN ((convert(char(11),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'MOBILE1'),'')) <> '' OR isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCMOBILE1'),'') <> '' ) AND  convert(char(1),ISNULL(citrus_usr.fn_ACCT_entp(DPAM_ID,'SMS_FLAG'),''))= 1 )   THEN 'Y' 
                  WHEN ((convert(char(11),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'MOBILE1'),'')) <> '' OR isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCMOBILE1'),'') <> '' ) AND  convert(char(1),ISNULL(citrus_usr.fn_ACCT_entp(DPAM_ID,'SMS_FLAG'),''))= '')  THEN 'N' ELSE ' ' END 
             , CASE WHEN  isnull(DPPD_FNAME,'') <> '' THEN 'Y' ELSE 'N' end                                                    --poa facility                  
             , CASE WHEN convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),''))  <> '' THEN 'Y' ELSE 'N' END                                                --pan flag for first holder                  
             , lower(convert(char(50),isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'SH_EMAIL1'),'')))                                              --email id for second holder                  
             , ''--convert(char(9),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                                  --map in id of second holder   --9                  
             , convert(CHAR(12),isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'SH_MOBILE'),''))                                             --mobile no of second holder  --12                  
             ,  case when subcm_cd in ('022545') then 'N'
				  when subcm_cd in ('392144') then 'N'
				  when subcm_cd in ('413046') then 'N'
               WHEN (convert(char(11),isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'SH_MOBILE'),'')) <> '' AND  convert(char(1),ISNULL(citrus_usr.fn_ACCT_entp(DPAM_ID,'SH_SMS_FLG'),''))= 1 )   THEN 'Y' 
               WHEN (convert(char(11),isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'SH_MOBILE'),'')) <> '' AND  convert(char(1),ISNULL(citrus_usr.fn_ACCT_entp(DPAM_ID,'SH_SMS_FLG'),''))= '')  THEN 'N' ELSE ' ' END 
                                                                                                                 --sms facility for sh                  
             , CASE WHEN ISNULL(dphd_sh_pan_no,'') = '' THEN '' ELSE 'Y' END  --convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_',''),''))                                                  --pan flag for second holder                 
 
             , lower(convert(char(50),isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'TH_EMAIL1'),'')))                                            --email id for third holder                  
             , ''--convert(char(9),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                                  --map in id of third holder   --9                  
             ,  convert(CHAR(12),isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'TH_MOBILE'),''))                                                --mobile no of third holder  --12                  
             ,  case when subcm_cd in ('022545') then 'N'
				  when subcm_cd in ('392144') then 'N'
				  when subcm_cd in ('413046') then 'N' 
               WHEN (convert(char(11),isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'TH_MOBILE'),'')) <> '' AND  convert(char(1),ISNULL(citrus_usr.fn_ACCT_entp(DPAM_ID,'TH_SMS_FLG'),''))= 1 )   THEN 'Y' 
               WHEN (convert(char(11),isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'TH_MOBILE'),'')) <> '' AND  convert(char(1),ISNULL(citrus_usr.fn_ACCT_entp(DPAM_ID,'TH_SMS_FLG'),''))= '')  THEN 'N' ELSE ' ' END 
                                                                                        --sms facility for th                  
             , CASE WHEN ISNULL(dphd_th_pan_no,'') = '' THEN '' ELSE 'Y' END  --convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))   --pan flag for third holder                  
             , citrus_usr.fn_get_listing_NSDL('occupation',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'occupation',''),''))  --1--convert(NUMERIC,ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                               --benifi  occupation                  
             , convert(char(45),ISNULL(dphd.dphd_Fh_fthname,''))                                         --benifi father/husband name                  
             , convert(char(45),ISNULL(dphd.dphd_sh_fthname,''))                                                                           --sh father/husband name                  
             , convert(char(45),ISNULL(dphd.dphd_th_fthname,''))                                                                           --th father/husband name                  
             , case when dphd_nom_fname <> '' then 'N' when dphd_gau_fname <> '' then 'G' else ' ' end  --convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                                 --nom-gur indicator       
   
             , case when isnull(dphd_nom_fname,'') <> '' then isnull(dphd_nom_fname,'')+' '+isnull(dphd_nom_mname,'')+' '+isnull(dphd_nom_lname,'')  when isnull(dphd_gau_fname,'') <> '' then isnull(dphd_gau_fname,'')+ ' '+isnull(dphd_gau_mname,'')+' '+ isnull(dphd_gau_lname,'') else '' end    
             , CASE WHEN (dphd_nom_fname <> '' AND DATEDIFF(YEAR, CONVERT(DATETIME,DPHD_NOM_DOB,103), CONVERT(DATETIME,GETDATE(),103)) < 18 )   THEN 'Y' ELSE ' ' END                                               --nom-min indicator                  
             , convert(char(45),ISNULL(dphd_nomGAU_fname,'') + ' ' + ISNULL(dphd_nomGAU_mname,'') + ' ' + ISNULL(dphd_nomGAU_lname,'') ) --min nom gurdian name                  
             --, CASE when dphd_gau_fname <> '' then   convert(datetime, dphd_nom_dob,103) END            
			          , CASE when dphd_gau_fname <> '' then   convert(datetime, clim_dob,103) else '00000000' END            
             , CASE WHEN (dphd_nom_fname <> '' AND DATEDIFF(YEAR, CONVERT(DATETIME,DPHD_NOM_DOB,103), CONVERT(DATETIME,GETDATE(),103)) < 18 ) THEN CONVERT(DATETIME,dphd_nom_dob) else '00000000' end  
             , convert(char(8),ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBP_ID',''),''))                                                  --corresponding bp id                  
             , dpam.dpam_created_dt                   
             , dpam.dpam_lst_upd_dt                  
             , ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_BO','NSDL'),'')                                                                    
             , case when clim.clim_name1 <> '' then '11'+ convert(varchar(135),clim.clim_name1+' ' + ISNULL(clim.clim_name2,'') + ' ' +  ISNULL(clim.clim_name3,''))  end                  
             , case when dphd.dphd_sh_fname <> '' then '12'+convert(char(135),dphd.dphd_sh_fname + ' ' + ISNULL(dphd.dphd_sh_mname,'') + ' ' + ISNULL(dphd.dphd_sh_lname,'')) end                  
             , case when dphd.dphd_th_fname <> '' then '13'+convert(char(45),dphd.dphd_th_fname + ' ' + ISNULL(dphd.dphd_th_mname,'') + ' ' + ISNULL(dphd.dphd_th_lname,'')) end                  
    
        FROM   dp_acct_mstr              dpam      
               left outer  join  
               dp_holder_dtls            dphd                  on dpam.dpam_id            = dphd.dphd_dpam_id             
               LEFT OUTER JOIN  
               #NO_SIGN_TEMP             HLDSG                 ON HLDSG.dpam_sba_no      = DPAM.dpam_sba_no     
               left outer join  
               dp_poa_dtls               dppd                  ON dpam.dpam_id = dppd.dppd_dpam_id      AND    (isnull(DPPD_POA_TYPE,'FULL') =   'FULL' OR isnull(DPPD_POA_TYPE,'PAYIN ONLY') = 'PAYIN ONLY')                   
               left outer join  
               client_bank_accts         cliba                 on dpam.dpam_id            = cliba.cliba_clisba_id   
               left outer join  
               bank_mstr                 banm                  on cliba.cliba_banm_id     = banm.banm_id     
           ,   @crn                      crn                  
           ,   client_mstr               clim                   
           ,   entity_type_mstr          enttm                  
           ,   client_ctgry_mstr         clicm    
               left outer join   
               sub_ctgry_mstr   subcm   
               on clicm.clicm_id  = subcm.subcm_clicm_id    
               AND    subcm.subcm_deleted_ind = 1                  
        WHERE  crn.crn                 = clim.clim_crn_no 
        and    crn.acct_no =            dpam.dpam_acct_no      
        AND    dpam.dpam_crn_no        = clim.clim_crn_no           
        AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
        AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
        AND    dpam.dpam_subcm_cd      = subcm.subcm_cd         
        AND    clim_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
        AND    isnull(banm.banm_deleted_ind,1)   = 1                  
        AND    isnull(cliba.cliba_deleted_ind,1) = 1                  
        AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
        AND    dpam.dpam_deleted_ind   = 1                  
        AND    clim.clim_deleted_ind   = 1             
        AND    cliba.cliba_flg & power(2,1-1) > 0               
        AND    enttm.enttm_cd in ('01','02','03')  
        AND    isnull(dpam.dpam_batch_no,0) = 0     
        and  NOT EXISTS (select nsdl_ACCT_ID FROM nsdl_dpm_response where nsdl_ACCT_ID = DPAM.dpam_sba_no)  
        
           
           
        update dpam set dpam_batch_no =  @PA_BATCH_NO from @l_dp_pri_dtls, dp_acct_mstr dpam where dpam_sba_no =  send_ref_no1   
        
        select @l_counter = COUNT(send_ref_no1) from @l_dp_pri_dtls    
          
        SELECT @L_DPM_ID = DPM_ID FROM DP_MSTR WHERE DEFAULT_DP = @PA_EXCSM_ID AND DPM_DELETED_IND = 1   
          
          
        IF NOT EXISTS(SELECT BATCHN_NO FROM BATCHNO_NSDL_MSTR   WHERE BATCHN_NO  = @PA_BATCH_NO AND BATCHN_DPM_ID = @L_DPM_ID AND BATCHN_DELETED_IND =1 AND BATCHN_TYPE='C')  
        BEGIN  
        --  
              
          INSERT INTO BATCHNO_NSDL_MSTR                                       
          (    
           BATCHN_DPM_ID,  
           BATCHN_NO,  
           BATCHN_RECORDS ,           
           BATCHN_TRANS_TYPE,
		   BATCHN_FILEGEN_DT,     
           BATCHN_TYPE,  
           BATCHN_STATUS,  
           BATCHN_CREATED_BY,  
           BATCHN_CREATED_DT , 
           BATCHN_LST_UPD_BY,  
           BATCHN_LST_UPD_DT ,  
           BATCHN_DELETED_IND  
          )  
          VALUES  
          (  
           @L_DPM_ID,  
           @PA_BATCH_NO,  
           @l_counter,  
           'ACCOUNT REGISTRATION',  
			CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00',
           'C',  
           'P',  
           @PA_LOGINNAME,  
           GETDATE(), 
           @PA_LOGINNAME,  
           GETDATE(),  
           1  
           )  
  
  
  
          UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
          WHERE BITRM_PARENT_CD ='NSDL_BTCH_CLT_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID and BITRM_BIT_LOCATION = @PA_EXCSM_ID  
                 
        --  
        END  
                             
                             
                             
                             
                          
                  
      END                  
      ELSE                  
      BEGIN       
      --      
     
      
      If ltrim(rtrim(isnull(@l_thirdsms,'') ))   = ''  set @l_thirdsms = 'N'       
      --                 
--vishal  


 

           

       INSERT INTO @l_dp_pri_dtls(ln_number                  
        , ben_acct_ctgr                  
        , entity_type_desc                  
        , ctgry_desc                  
        , ben_type                            
        , ben_sub_type                        
        , ben_short_name                      
        , fh_name                             
        , sh_name                             
        , th_name                             
        , addr_pref_flg                       
        , fh_pan                              
        , sh_pan                              
        , th_pan                              
        , stan_instr_ind                      
        , ben_bank_acct_no                    
        , ben_bank_name                       
        , ben_rbi_ref_no                      
        , ben_rbi_app_dt                      
        , ben_sebi_reg_no                     
        , ben_tax_ded_sts                     
        , local_addr                          
        , bank_addr                           
        , nom_gur_addr                        
        , min_nom_g_addr                      
        , for_cor_addr                        
        , no_of_fh_at                         
        , no_of_sh_at                         
        , no_of_th_at                         
        , size_of_sign                        
        , send_ref_no1                        
        , send_ref_no2                        
        , micr_cd                             
        , bank_acct_type                      
        , fh_email                
        , fh_map_id                           
        , fh_mob_no                           
        , fh_sms_fac                          
        , fh_poa_fac                          
        , fh_pan_flg                          
        , sh_email                            
        , sh_map_id                           
        , sh_mob_no                           
        , sh_sms_fac                          
        , sh_pan_flg                          
        , th_email                            
        , th_map_id                           
        , th_mob_no                           
        , th_sms_fac                          
        , th_pan_flg                          
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
        , dpam_lst_upd_dt                  
        , dpam_sign_path                  
        , dpam_fholder_sign                   
        , dpam_sholder_sign                   
        , dpam_tholder_sign
                               
        )                 
  
        SELECT 0                  
             , convert(varchar(20),enttm_cd)                                                                                                                        --beneficiary account category '02'                  
             , convert(varchar(50),enttm.enttm_desc)                  
             , convert(varchar(50),clicm.clicm_desc)                  
             , convert(varchar(20),isnull(left(subcm.subcm_cd,2),'00')) --beneficiary  type          
             , convert(varchar(20),isnull(right(subcm.subcm_cd,2),'00'))                                                                             --beneficiary sub type                                                              
             , convert(char(16),clim_short_name)--convert(char(16),LTRIM(RTRIM(dpam_sba_name)))                                                                                      --beneficiary short name                                                          
             , convert(char(45),ltrim(rtrim(isnull(CLIM_NAME1,''))) + ' ' + ltrim(rtrim(isnull(CLIM_NAME2,''))) + ' ' + ltrim(rtrim(isnull(CLIM_NAME3,'')))) --isnull(convert(char(45),clim.clim_name1+' ' + ISNULL(clim.clim_name2,'') + ' ' +  ISNULL(clim.clim_name3,'')),'')           --beneficiary first holder name                  
             , isnull(convert(char(45),dphd.dphd_sh_fname + ' ' + ISNULL(dphd.dphd_sh_mname,'') + ' ' + ISNULL(dphd.dphd_sh_lname,'')),'') --beneficiary second holder name                   
             , isnull(convert(char(45),dphd.dphd_th_fname + ' ' + ISNULL(dphd.dphd_th_mname,'') + ' ' + ISNULL(dphd.dphd_th_lname,'')),'') --beneficiary third holder name                  
             , case when convert(char(1),ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ADR_PREF_FLG',''),'')) = '1' then 'Y' else 'N' end   --convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                                  --address preference flag                   
             , convert(char(10),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),''))                                       --First holder pan                  
             , convert(char(10),ISNULL(dphd.dphd_sh_pan_no,''))                                                                            --second holder pan                  
             , convert(char(10),ISNULL(dphd.dphd_th_pan_no,''))                                                                            --third holder pan                  
             , 'Y'--case when convert(char(1),ISNULL(citrus_usr.fn_ucc_accp(clim.clim_crn_no,'STAN_INS_IND',''),'')) in ('','0') then 'N' else 'Y'  end                                                --standing instruction indicator                  
             , convert(char(30),ISNULL(cliba.cliba_ac_no,''))                                                                              --bank account no                   
             , convert(char(35),ISNULL(banm.banm_name ,''))                                                                                --bank name                   
             , convert(char(50),ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'RBI_REF_NO',''),''))  --benrficiary rbi reference no --50                  
             , REPLACE(CONVERT(VARCHAR(11),CONVERT(DATETIME,ISNULL(ISNULL(citrus_usr.fn_ucc_accpd(dpam.dpam_id,'RBI_REF_NO','RBI_APP_DT',''),''),''),103),102),'.','')                                              --benrficiary rbi approval date --8                  
             , convert(char(24),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'SEBI_REGN_NO',''),''))                                               --beneficiary sebi registration no --24                  
             , citrus_usr.fn_get_listing('TAX_DEDUCTION',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'TAX_DEDUCTION',''),''))  --benef_tax_ded_sta                                                                      --tax deduction status --20             
     
             , 'Y'                                                                                                      --local addr???                  
             , case when ISNULL(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),'') <> '' OR ISNULL(citrus_usr.fn_addr_value(banm_id,'PER_ADR1'),'') <> ''  then 'Y'   else 'N' end                                                                                                                                       --bank addr???                    
             , case when (citrus_usr.[fn_acct_addr_value](dpam_id,'NOMINEE_ADR1') <> '' or citrus_usr.[fn_acct_addr_value](dpam_id,'GUARD_ADR') <> '' )  then 'Y' else 'N' end                                         --minor nominee addr???                     
             , case when citrus_usr.[fn_acct_addr_value](dpam_id,'NOM_GUARDIAN_ADDR') <> '' then 'Y' else 'N' end
           ,  CASE WHEN  convert(char(1),ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ADR_PREF_FLG',''),'')) <> '1' THEN 'Y'  
                     ELSE 'N' END  
             , RIGHT('00'+ ISNULL(LTRIM(RTRIM(NO_OF_FH)),'00'),2)
             , RIGHT('00'+ ISNULL(LTRIM(RTRIM(NO_OF_SH)),'00'),2)
                                                                                                          --no of second holder authorized signatories                  
             , RIGHT('00'+ ISNULL(LTRIM(RTRIM(NO_OF_TH)),'00'),2)
             , '#SIG#'                                                                                                                           --size of signature --size in bytes                  
             , convert(char(35),DPAM.dpam_sba_no)                                                                                                        --sender ref no 1                  
             , convert(char(35),'')                                                                                                        --sender ref no 2                  
             , case when isnull(convert(vARCHAR(30),BANM_MICR),'') = '0' then case when ISNULL(citrus_usr.fn_ACCT_entp(dpam_id,'BENMICR'),'') <> '' then convert(char(9),ISNULL(citrus_usr.fn_ACCT_entp(dpam_id,'BENMICR'),'')) else convert(char(9),'') end  else convert(char(9),isnull(convert(vARCHAR(30),BANM_MICR),'')) end
             , CASE WHEN convert(char(20),cliba_ac_type) IN( 'SAVINGS', 'SAVING')  THEN '10' WHEN convert(char(20),cliba_ac_type) IN('CURRENT') THEN  '11' WHEN convert(char(20),cliba_ac_type) IN( 'OTHERS') THEN  '13' else '13' END   --'11'                                                                                          --bank acct type                  
             , CASE WHEN lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCEMAIL1'),'')) <> '' THEN lower(convert(char(50),isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCEMAIL1'),''))) ELSE lower(convert(char(50),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'EMAIL1'),'')))  end                                                --email id for first holder                                                           --email id for first holder            
             , convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'MAPIN_ID',''),''))                                  --map in id of first holder   --9                  
             , CASE WHEN isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCMOBILE1'),'') <> '' then convert(char(12),isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCMOBILE1'),'')) ELSE convert(char(12),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'MOBILE1'),''))            end                                       --mobile no of first holder  --12                  
			 ,  case when subcm_cd in ('022545') then 'N'
				  when subcm_cd in ('392144') then 'N'
				  when subcm_cd in ('413046') then 'N' 
			   WHEN ((convert(char(12),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'MOBILE1'),'')) <> '' OR isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCMOBILE1'),'') <> '' ) AND  convert(char(1),ISNULL(citrus_usr.fn_ACCT_entp(DPAM_ID,'SMS_FLAG'),''))= 1 )   THEN 'Y' 
               WHEN ((convert(char(12),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'MOBILE1'),'')) <> '' OR isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCMOBILE1'),'') <> '' ) AND  convert(char(1),ISNULL(citrus_usr.fn_ACCT_entp(DPAM_ID,'SMS_FLAG'),''))= '')  THEN 'N' ELSE ' ' END 
             , CASE WHEN  isnull(DPPD_FNAME,'') <> '' THEN 'Y' ELSE 'N' end                                                      --poa facility                  
             , CASE WHEN convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),''))  <> '' THEN 'Y' ELSE 'N' END                                                --pan flag for first holder                  
             , lower(convert(char(50),isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'SH_EMAIL1'),'')))                                                       --email id for second holder                  
             , ''--convert(char(9),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                                  --map in id of second holder   --9                  
             , convert(CHAR(12),isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'SH_MOBILE'),''))                                             --mobile no of second holder  --12                  
             , case when subcm_cd in ('022545') then 'N'
				  when subcm_cd in ('392144') then 'N'
				  when subcm_cd in ('413046') then 'N' 
                  WHEN (convert(char(11),isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'SH_MOBILE'),'')) <> '' AND  convert(char(1),ISNULL(citrus_usr.fn_ACCT_entp(DPAM_ID,'SH_SMS_FLG'),''))= 1 )   THEN 'Y' 
                 WHEN (convert(char(11),isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'SH_MOBILE'),'')) <> '' AND  convert(char(1),ISNULL(citrus_usr.fn_ACCT_entp(DPAM_ID,'SH_SMS_FLG'),''))= '')  THEN 'N' ELSE ' ' END 
                                                                                                                 --sms facility for sh                  
             , CASE WHEN ISNULL(dphd_sh_pan_no,'') = '' THEN '' ELSE 'Y' END  --convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_',''),''))                                                  --pan flag for second holder                 
 
             , lower(convert(char(50),isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'TH_EMAIL1'),'')))                                                       --email id for third holder                  
             , ''--convert(char(9),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                                  --map in id of third holder   --9                  
              ,  convert(CHAR(12),isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'TH_MOBILE'),''))                                                --mobile no of third holder  --12                  
             ,  case when subcm_cd in ('022545') then 'N'
				  when subcm_cd in ('392144') then 'N'
				  when subcm_cd in ('413046') then 'N' 
               WHEN (convert(char(11),isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'TH_MOBILE'),'')) <> '' AND  convert(char(1),ISNULL(citrus_usr.fn_ACCT_entp(DPAM_ID,'TH_SMS_FLG'),''))= 1 )   THEN 'Y' 
               WHEN (convert(char(11),isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'TH_MOBILE'),'')) <> '' AND  convert(char(1),ISNULL(citrus_usr.fn_ACCT_entp(DPAM_ID,'TH_SMS_FLG'),''))= '')  THEN 'N' ELSE ' ' END 
                                                                      --sms facility for th                  
             , CASE WHEN ISNULL(dphd_th_pan_no,'') = '' THEN '' ELSE 'Y' END  --convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))   --pan flag for third holder                  
             , citrus_usr.fn_get_listing_NSDL('occupation',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'occupation',''),''))  --1--convert(NUMERIC,ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                               --benifi  BEN_OCCUPATION                  
             , convert(char(45),ISNULL(dphd.dphd_Fh_fthname,''))                                         --benifi father/husband name                  
             , convert(char(45),ISNULL(dphd.dphd_sh_fthname,''))                                                                           --sh father/husband name                  
             , convert(char(45),ISNULL(dphd.dphd_th_fthname,''))                                                                           --th father/husband name                  
             , case when isnull(dphd_nom_fname,'') <> '' then 'N' when isnull(dphd_gau_fname,'') <> '' then 'G' else ' ' end  --convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),''))                                                 --nom-gur indicator          
             , case when isnull(dphd_nom_fname,'') <> '' then isnull(dphd_nom_fname,'')+' '+isnull(dphd_nom_mname,'')+' '+isnull(dphd_nom_lname,'')  when isnull(dphd_gau_fname,'') <> '' then isnull(dphd_gau_fname,'')+ ' '+isnull(dphd_gau_mname,'')+' '+ isnull(dphd_gau_lname,'') else '' end    
             , CASE WHEN (isnull(dphd_nom_fname,'') <> '' AND DATEDIFF(YEAR, CONVERT(DATETIME,DPHD_NOM_DOB,103), CONVERT(DATETIME,GETDATE(),103)) < 18 )   THEN 'Y' ELSE ' ' END                                               --nom-min indicator             
     
             , convert(char(45),ISNULL(dphd_nomGAU_fname,'') + ' ' + ISNULL(dphd_nomGAU_mname,'') + ' ' + ISNULL(dphd_nomGAU_lname,'') ) --min nom gurdian name                             
             --, CASE when isnull(dphd_gau_fname,'') <> '' then   convert(datetime, dphd_nom_dob,103) END            
			          , CASE when isnull(dphd_gau_fname,'') <> '' then   convert(datetime, clim_dob,103) else '00000000' END 
             , CASE WHEN (isnull(dphd_nom_fname,'') <> '' AND DATEDIFF(YEAR, CONVERT(DATETIME,DPHD_NOM_DOB,103), CONVERT(DATETIME,GETDATE(),103)) < 18 ) THEN CONVERT(DATETIME,dphd_nomgau_fname) else '00000000' end  
             , convert(char(8),ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBP_ID',''),''))                                                  --corresponding bp id                  
             , dpam.dpam_created_dt                   
             , dpam.dpam_lst_upd_dt                  
             , ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_BO','NSDL'),'')                                                                    
             , case when clim.clim_name1 <> '' then '11'+ convert(varchar(135),clim.clim_name1+' ' + ISNULL(clim.clim_name2,'') + ' ' +  ISNULL(clim.clim_name3,''))  end                  
             , case when isnull(dphd.dphd_sh_fname,'') <> '' then '12'+convert(char(135),isnull(dphd.dphd_sh_fname,'') + ' ' + ISNULL(dphd.dphd_sh_mname,'') + ' ' + ISNULL(dphd.dphd_sh_lname,'')) else convert(char(135),' ')end                  
             , case when isnull(dphd.dphd_th_fname,'') <> '' then '13'+convert(char(45),isnull(dphd.dphd_th_fname,'') + ' ' + ISNULL(dphd.dphd_th_mname,'') + ' ' + ISNULL(dphd.dphd_th_lname,'')) else convert(char(135),' ') end                  
             
        FROM   dp_acct_mstr              dpam      
               left outer  join  
               dp_holder_dtls            dphd                  on dpam.dpam_id            = dphd.dphd_dpam_id             
               LEFT OUTER JOIN  
               #NO_SIGN_TEMP             HLDSG                 ON HLDSG.dpam_sba_no      = DPAM.dpam_sba_no         
               left outer join  
               dp_poa_dtls               dppd                  ON dpam.dpam_id = dppd.dppd_dpam_id      AND    (isnull(DPPD_POA_TYPE,'FULL') =   'FULL' OR isnull(DPPD_POA_TYPE,'PAYIN ONLY') = 'PAYIN ONLY')                   
               left outer join  
               client_bank_accts         cliba                 on dpam.dpam_id            = cliba.cliba_clisba_id   
               left outer join  
               bank_mstr                 banm                  on cliba.cliba_banm_id     = banm.banm_id     
           ,   client_mstr               clim                   
           ,   entity_type_mstr          enttm                  
           ,   client_ctgry_mstr         clicm    
               left outer join   
               sub_ctgry_mstr   subcm   
               on clicm.clicm_id  = subcm.subcm_clicm_id    
               AND    subcm.subcm_deleted_ind = 1              
        WHERE  dpam.dpam_crn_no        = clim.clim_crn_no                   
        AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
        AND    dpam.dpam_clicm_cd      = clicm.clicm_cd  
        AND    dpam.dpam_subcm_cd      = subcm.subcm_cd                         
        AND    isnull(dpam.dpam_batch_no,0) = 0   
        AND    clim_lst_upd_dt        BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
        AND    dpam.dpam_deleted_ind   = 1                  
        AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
        AND    isnull(clim.clim_deleted_ind,1)   = 1                  
        AND    isnull(cliba.cliba_deleted_ind,1) = 1    
        AND    isnull(banm.banm_deleted_ind,1)   = 1                  
        AND    enttm.enttm_cd in ('01','02','03')                  
        and  NOT EXISTS (select nsdl_ACCT_ID FROM nsdl_dpm_response where nsdl_ACCT_ID = dpam.dpam_sba_no)  
           
        update dpam set dpam_batch_no =  @PA_BATCH_NO from @l_dp_pri_dtls, dp_acct_mstr dpam where dpam_sba_no =  send_ref_no1  
          
        select @l_counter = COUNT(send_ref_no1) from @l_dp_pri_dtls    
  
        SELECT @L_DPM_ID = DPM_ID FROM DP_MSTR WHERE DEFAULT_DP = @PA_EXCSM_ID AND DPM_DELETED_IND = 1   
  
  
        IF NOT EXISTS(SELECT BATCHN_NO FROM BATCHNO_NSDL_MSTR   WHERE BATCHN_NO  = @PA_BATCH_NO AND BATCHN_DPM_ID = @L_DPM_ID AND BATCHN_DELETED_IND =1 AND BATCHN_TYPE='C')  
        BEGIN  
        --  
  
          INSERT INTO BATCHNO_NSDL_MSTR                                       
          (    
           BATCHN_DPM_ID,  
           BATCHN_NO,  
           BATCHN_RECORDS ,           
           BATCHN_TRANS_TYPE,   
           BATCHN_FILEGEN_DT,   
           BATCHN_TYPE,  
           BATCHN_STATUS,  
           BATCHN_CREATED_BY,  
           BATCHN_CREATED_DT ,   BATCHN_LST_UPD_BY,  
           BATCHN_LST_UPD_DT ,  
           BATCHN_DELETED_IND  
          )  
          VALUES  
          (  
           @L_DPM_ID,  
           @PA_BATCH_NO,  
           @l_counter,  
           'ACCOUNT REGISTRATION',  
           CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00',   
           'C',  
           'P',  
           @PA_LOGINNAME,  
           GETDATE(),    @PA_LOGINNAME,  
           GETDATE(),  
           1  
           )  
  
  
  
          UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
          WHERE BITRM_PARENT_CD ='NSDL_BTCH_CLT_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID and BITRM_BIT_LOCATION = @PA_EXCSM_ID  
  
        --  
        END  
      --                  
      END      
                                                                  
      IF @l_chk = 1 or @l_chk = 4                     
      BEGIN                  
      --                  
        IF @PA_TAB = 'N'                    
        BEGIN                  
        --                  
          INSERT INTO #l_values(dp_string,sign_path,fhd_sign,shd_sign,thd_sign,sba_no)                  
          SELECT --'02'                  
              --- + '0000000'                  
              -- + 'A'                                                                            
                 convert(char(2),ben_acct_ctgr)                                                 
               + convert(char(2),ben_type)                                             
               + convert(char(2),ben_sub_type)                                         
               + convert(char(16),ben_short_name)                                      
               + CONVERT(CHAR(2),BEN_OCCUPATION)
               + convert(char(45),fh_name)                             
               + SPACE(90)
               + CONVERT(CHAR(45),fh_fth_hus_name)                                       
               + convert(char(45),sh_name)
			   + SPACE(90)                   
               + convert(char(45),sh_fth_hus_name) --SPACE(135) 
               + convert(char(45),th_name)                   
               + SPACE(90)                                  
               + convert(char(45),th_fth_hus_name)
               + SPACE(8)              
               + convert(char(1),addr_pref_flg)                   
               + convert(char(10),fh_pan)                     
               + SPACE(20)                                    
               + convert(char(10),sh_pan)                     
               + SPACE(20)                                    
               + convert(char(10),th_pan)                    
               + SPACE(20)
               + CONVERT(CHAR(1), ISNULL(nom_gur_ind,''))                         
               + CONVERT(CHAR(45), ISNULL(nom_gur_name,''))                      
			   + CONVERT(CHAR(1), ISNULL(nom_min_ind,'')) 
			   + CONVERT(CHAR(45), ISNULL(min_nom_gur_name,''))
			   + CONVERT(CHAR(8), ISNULL(CONVERT(CHAR(8),dob_min,112),''))
			   + CONVERT(CHAR(8), ISNULL(CONVERT(CHAR(8),don_min_nom,112),''))
               + convert(char(1),stan_instr_ind)                
               + convert(char(30),ben_bank_acct_no)                  
               + convert(char(35),ben_bank_name)                     
               + SPACE(100)                                          
               + convert(char(50),ben_rbi_ref_no)                    
               + case when convert(char(8),replace(convert(varchar,ben_rbi_app_dt,102),'.',''))  = '19000101' then '' else convert(char(8),replace(convert(varchar,ben_rbi_app_dt,102),'.',''))    end                                    
               + convert(char(24),ben_sebi_reg_no)                   
               + convert(char(20),ben_tax_ded_sts)                   
               + local_addr                                          
               + bank_addr                                           
               + nom_gur_addr                                        
               + min_nom_g_addr                                      
               + convert(char(1),for_cor_addr)                       
			           	+ convert(char(2),no_of_fh_at)                      
               + convert(char(2),no_of_sh_at)                      
               + convert(char(2),no_of_th_at)                      
               + convert(char(5),size_of_sign)                     
               + convert(char(35),send_ref_no1)                    
               + convert(char(35),send_ref_no2)                    
               + convert(char(9),isnull(micr_cd,''))                          
               + convert(char(2),isnull(bank_acct_type,''))                   
               + SPACE(20)                                         
               + convert(char(50),fh_email)                        
               + convert(char(9),fh_map_id )                       
               + convert(char(12),fh_mob_no)                       
               + convert(char(1),fh_sms_fac)                       
               + convert(char(1),fh_poa_fac)                       
               + convert(char(1),fh_pan_flg)                       
               + case when convert(char(2),ben_type) + convert(char(2),ben_sub_type)  not in ('0402','0401','0101','0703','0702','0701','0700','0405','0404','0105') then ' ' else case when nom_gur_ind in ('N','G')  then 'N' else 'Y' end end  
               + SPACE(13)                                         
               + convert(char(50),sh_email)                        
               + convert(char(9),sh_map_id)                        
               + convert(char(12),sh_mob_no)                       
               + convert(char(1),sh_sms_fac)                       
               + SPACE(1)                                          
               + convert(char(1),sh_pan_flg)                       
               + SPACE(14)                                         
               + convert(char(50),th_email)              
               + convert(char(9),th_map_id)                       
               + convert(char(12),th_mob_no)                      
               + convert(char(1),th_sms_fac)                      
               + SPACE(1)                                         
               + convert(char(1),th_pan_flg)                      
               + SPACE(14)                   
               , dpam_sign_path                  
               , dpam_fholder_sign                   
               , dpam_sholder_sign                   
               , dpam_tholder_sign     
               ,  send_ref_no1            
          FROM  @l_dp_pri_dtls                  
          WHERE ben_acct_ctgr      = '02'  
                         
          --and   dpam_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
        --                  
        END                  
        ELSE IF @PA_TAB = 'M'                   
		BEGIN                  
        --                  
          INSERT INTO #l_values(dp_string,sign_path,fhd_sign,shd_sign,thd_sign,sba_no)                  
          SELECT --'02'                  
              --- + '0000000'                  
              -- + 'A'                                                                            
                 convert(char(2),ben_acct_ctgr)                                                 
               + convert(char(2),ben_type)                                             
              + convert(char(2),ben_sub_type)                                         
               + convert(char(16),ben_short_name)                                      
               + CONVERT(CHAR(2),BEN_OCCUPATION)
               + convert(char(45),fh_name)                             
               + SPACE(90)
               + CONVERT(CHAR(45),fh_fth_hus_name)
               + convert(char(45),sh_name)                   
			   + SPACE(90)                   
               + convert(char(45),sh_fth_hus_name) --SPACE(135)      
               + convert(char(45),th_name)                   
                + SPACE(90)                                  
               + convert(char(45),th_fth_hus_name)
               + SPACE(8)    
               + convert(char(1),addr_pref_flg)                   
               + convert(char(10),fh_pan)                     
               + SPACE(20)                                    
               + convert(char(10),sh_pan)                     
               + SPACE(20)                                    
               + convert(char(10),th_pan)                    
               + SPACE(20)
               + CONVERT(CHAR(1), ISNULL(nom_gur_ind,''))                         
               + CONVERT(CHAR(45), ISNULL(nom_gur_name,''))                      
				+ CONVERT(CHAR(1), ISNULL(nom_min_ind,'')) 
				+ CONVERT(CHAR(45), ISNULL(min_nom_gur_name,''))
				+ CONVERT(CHAR(8), ISNULL(CONVERT(CHAR(8),dob_min,112),''))
				+ CONVERT(CHAR(8), ISNULL(CONVERT(CHAR(8),don_min_nom,112),''))
               + convert(char(1),stan_instr_ind)                
               + convert(char(30),ben_bank_acct_no)                  
               + convert(char(35),ben_bank_name)                     
               + SPACE(100)                                          
               + convert(char(50),ben_rbi_ref_no)                    
           + case when convert(char(8),replace(convert(varchar,ben_rbi_app_dt,102),'.',''))  = '19000101' then '' else convert(char(8),replace(convert(varchar,ben_rbi_app_dt,102),'.',''))    end                                    
               + convert(char(24),ben_sebi_reg_no)                   
               + convert(char(20),ben_tax_ded_sts)                   
               + local_addr                                          
               + bank_addr                                           
               + nom_gur_addr                                        
               + min_nom_g_addr                                      
               + convert(char(1),for_cor_addr)                       
          + convert(char(2),no_of_fh_at)                      
               + convert(char(2),no_of_sh_at)                      
               + convert(char(2),no_of_th_at)                      
               + convert(char(5),size_of_sign)                     
               + convert(char(35),send_ref_no1)                    
               + convert(char(35),send_ref_no2)                    
               + convert(char(9),isnull(micr_cd,''))                          
               + convert(char(2),isnull(bank_acct_type,''))                   
               + SPACE(20)                                         
               + convert(char(50),fh_email)                        
               + convert(char(9),fh_map_id )                       
               + convert(char(12),fh_mob_no)                       
               + convert(char(1),fh_sms_fac)                       
               + convert(char(1),fh_poa_fac)                       
               + convert(char(1),fh_pan_flg)                       
               + case when convert(char(2),ben_type) + convert(char(2),ben_sub_type)  not in ('0402','0401','0101','0703','0702','0701','0700','0405','0404','0105') then ' ' else case when nom_gur_ind in ('N','G')  then 'N' else 'Y' end end  
               + SPACE(13)                                                 
               + convert(char(50),sh_email)                        
               + convert(char(9),sh_map_id)                        
               + convert(char(12),sh_mob_no)                       
               + convert(char(1),sh_sms_fac)                       
               + SPACE(1)                                          
               + convert(char(1),sh_pan_flg)                       
               + SPACE(14)                                         
               + convert(char(50),th_email)              
               + convert(char(9),th_map_id)                       
               + convert(char(12),th_mob_no)                      
               + convert(char(1),th_sms_fac)                      
               + SPACE(1)                                         
               + convert(char(1),th_pan_flg)                      
               + SPACE(14)                   
               , dpam_sign_path                  
               , dpam_fholder_sign                   
               , dpam_sholder_sign                   
               , dpam_tholder_sign 
               ,send_ref_no1                 
          FROM  @l_dp_pri_dtls                  
          WHERE ben_acct_ctgr      = '02'                  
          --AND   dpam_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
                            
        --                  
        END                  
        ELSE                  
        BEGIN                  
        --                  
          INSERT INTO #l_values(dp_string,sign_path,fhd_sign,shd_sign,thd_sign,sba_no)                  
          SELECT --'02'                  
              --- + '0000000'                  
              -- + 'A'                                                                            
                 convert(char(2),ben_acct_ctgr)                                                 
               + convert(char(2),ben_type)                                             
               + convert(char(2),ben_sub_type)                                         
               + convert(char(16),ben_short_name)                                      
               + CONVERT(CHAR(2),BEN_OCCUPATION)
               + convert(char(45),fh_name)                             
               + SPACE(90)
               + CONVERT(CHAR(45),fh_fth_hus_name)                                     
               + convert(char(45),sh_name)                   
			   + SPACE(90)                   
               + convert(char(45),sh_fth_hus_name) --SPACE(135)                     
               + convert(char(45),th_name)                   
                + SPACE(90)                                  
               + convert(char(45),th_fth_hus_name)
               + SPACE(8)                
               + convert(char(1),addr_pref_flg)                   
               + convert(char(10),fh_pan)                     
               + SPACE(20)                                    
               + convert(char(10),sh_pan)                     
               + SPACE(20)                                    
               + convert(char(10),th_pan)                    
               + SPACE(20)
               + CONVERT(CHAR(1), ISNULL(nom_gur_ind,''))                         
               + CONVERT(CHAR(45), ISNULL(nom_gur_name,''))                      
				+ CONVERT(CHAR(1), ISNULL(nom_min_ind,'')) 
				+ CONVERT(CHAR(45), ISNULL(min_nom_gur_name,''))
				+ CONVERT(CHAR(8), ISNULL(CONVERT(CHAR(8),dob_min,112),''))
				+ CONVERT(CHAR(8), ISNULL(CONVERT(CHAR(8),don_min_nom,112),''))
               + convert(char(1),stan_instr_ind)                
               + convert(char(30),ben_bank_acct_no)                  
               + convert(char(35),ben_bank_name)                     
               + SPACE(100)                                          
               + convert(char(50),ben_rbi_ref_no)                    
           + case when convert(char(8),replace(convert(varchar,ben_rbi_app_dt,102),'.',''))  = '19000101' then '' else convert(char(8),replace(convert(varchar,ben_rbi_app_dt,102),'.',''))    end                                    
               + convert(char(24),ben_sebi_reg_no)                   
               + convert(char(20),ben_tax_ded_sts)                   
               + local_addr                                          
               + bank_addr                                           
               + nom_gur_addr                                        
               + min_nom_g_addr                                      
               + convert(char(1),for_cor_addr)                       
          + convert(char(2),no_of_fh_at)                      
               + convert(char(2),no_of_sh_at)                      
               + convert(char(2),no_of_th_at)                      
               + convert(char(5),size_of_sign)                     
               + convert(char(35),send_ref_no1)                    
               + convert(char(35),send_ref_no2)                    
               + convert(char(9),isnull(micr_cd,''))                          
               + convert(char(2),isnull(bank_acct_type,''))                   
               + SPACE(20)                                         
               + convert(char(50),fh_email)                        
               + convert(char(9),fh_map_id )                       
               + convert(char(12),fh_mob_no)                       
               + convert(char(1),fh_sms_fac)                       
               + convert(char(1),fh_poa_fac)                       
               + convert(char(1),fh_pan_flg)                       
               + case when convert(char(2),ben_type) + convert(char(2),ben_sub_type)  not in ('0402','0401','0101','0703','0702','0701','0700','0405','0404','0105') then ' ' else case when nom_gur_ind in ('N','G')  then 'N' else 'Y' end end  
               + SPACE(13)                                                  
               + convert(char(50),sh_email)                        
               + convert(char(9),sh_map_id)                        
               + convert(char(12),sh_mob_no)                       
               + convert(char(1),sh_sms_fac)                       
               + SPACE(1)                                          
               + convert(char(1),sh_pan_flg)                       
               + SPACE(14)                                         
               + convert(char(50),th_email)              
               + convert(char(9),th_map_id)                       
               + convert(char(12),th_mob_no)                      
               + convert(char(1),th_sms_fac)                      
               + SPACE(1)                                         
               + convert(char(1),th_pan_flg)                      
               + SPACE(14)                   
               , dpam_sign_path                  
               , dpam_fholder_sign                   
               , dpam_sholder_sign                   
               , dpam_tholder_sign  
               ,send_ref_no1  
          FROM  @l_dp_pri_dtls                  
          WHERE ben_acct_ctgr      = '02'                  
          --AND   dpam_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
                  
                            
        --                  
        END                  
      --                  
      END                  
 IF @l_chk = 2 or @l_chk = 4                     
      BEGIN                  
      --                  
        IF @PA_TAB = 'N'                    
        BEGIN                  
        --                  
          INSERT INTO #l_values(dp_string,sign_path,fhd_sign,shd_sign,thd_sign,sba_no)                  
          SELECT --'02'                  
              --- + '0000000'                  
              -- + 'A'                                                                            
                convert(char(2),ben_acct_ctgr)                                                 
               + convert(char(2),ben_type)                                             
               + convert(char(2),ben_sub_type)                                         
               + convert(char(16),ben_short_name)                                      
               + CONVERT(CHAR(2),BEN_OCCUPATION)
               + SPACE(180)                                                              
               + convert(char(45),sh_name)                   
			   + SPACE(90)                   
               + convert(char(45),sh_fth_hus_name) --SPACE(135)                                  
               + convert(char(45),th_name) 
               + SPACE(90)                                  
               + convert(char(45),th_fth_hus_name)
               + SPACE(8)                                  
               + convert(char(1),addr_pref_flg)                   
               + convert(char(10),fh_pan)              
               + SPACE(20)                                    
               + convert(char(10),sh_pan)                     
               + SPACE(20)                                    
               + convert(char(10),th_pan)                    
               + SPACE(128)                                  
               + convert(char(1),stan_instr_ind)                  
               + convert(char(30),ben_bank_acct_no)                  
               + convert(char(35),ben_bank_name)                     
               + SPACE(100)                                
               + convert(char(50),ben_rbi_ref_no)                    
               + case when convert(char(8),replace(convert(varchar,ben_rbi_app_dt,102),'.',''))  = '19000101' then '' else convert(char(8),replace(convert(varchar,ben_rbi_app_dt,102),'.',''))    end                                    
               + convert(char(24),ben_sebi_reg_no)                   
               + convert(char(20),ben_tax_ded_sts)                   
               + local_addr                                          
               + bank_addr                                           
               + nom_gur_addr                                        
               + min_nom_g_addr                                      
               + convert(char(1),for_cor_addr)                       
               + convert(char(2),no_of_fh_at)                      
               + convert(char(2),no_of_sh_at)                      
               + convert(char(2),no_of_th_at)                      
               + convert(char(5),size_of_sign)                     
               + convert(char(35),send_ref_no1)                    
               + convert(char(35),send_ref_no2)                    
               + convert(char(9),isnull(micr_cd,''))                          
               + convert(char(2),isnull(bank_acct_type,''))                   
               + SPACE(20)                                         
               + convert(char(50),fh_email)                        
               + convert(char(9),fh_map_id )                       
               + convert(char(12),fh_mob_no)                       
               + convert(char(1),fh_sms_fac)                       
               + convert(char(1),fh_poa_fac)                       
               + convert(char(1),fh_pan_flg)                       
               + SPACE(14)                                         
               + convert(char(50),sh_email)                        
               + convert(char(9),sh_map_id)                        
               + convert(char(12),sh_mob_no)                       
               + convert(char(1),sh_sms_fac)                       
               + SPACE(1)                                          
               + convert(char(1),sh_pan_flg)                       
               + SPACE(14)                                         
               + convert(char(50),th_email)                        
               + convert(char(9),th_map_id)                       
               + convert(char(12),th_mob_no)                      
               + convert(char(1),th_sms_fac)                      
               + SPACE(1)                                         
               + convert(char(1),th_pan_flg)                      
               + SPACE(14)                        
               , dpam_sign_path                  
               , dpam_fholder_sign                   
               , dpam_sholder_sign                   
               , dpam_tholder_sign   
               ,send_ref_no1                
          FROM  @l_dp_pri_dtls                  
          WHERE ben_acct_ctgr      = '01'                  
          --AND   dpam_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
        --                  
        END                  
        ELSE IF @PA_TAB = 'M'                   
        BEGIN                  
        --                  
          INSERT INTO #l_values(dp_string,sign_path,fhd_sign,shd_sign,thd_sign,sba_no)                  
          SELECT --'02'                  
              --- + '0000000'                  
              -- + 'A'                                                                            
                convert(char(2),ben_acct_ctgr)                                                 
               + convert(char(2),ben_type)                                             
               + convert(char(2),ben_sub_type)                                         
               + convert(char(16),ben_short_name)                                      
               + CONVERT(CHAR(2),BEN_OCCUPATION)
               + SPACE(180)                                                              
               + convert(char(45),sh_name)                   
			   + SPACE(90)                   
               + convert(char(45),sh_fth_hus_name) --SPACE(135) 
               + convert(char(45),th_name)                   
                 + SPACE(90)                                  
               + convert(char(45),th_fth_hus_name)
               + SPACE(8)                                
               + convert(char(1),addr_pref_flg)                   
               + convert(char(10),fh_pan)              
               + SPACE(20)                                    
               + convert(char(10),sh_pan)                     
               + SPACE(20)                                    
               + convert(char(10),th_pan)                    
               + SPACE(128)                                  
               + convert(char(1),stan_instr_ind)                  
               + convert(char(30),ben_bank_acct_no)                  
               + convert(char(35),ben_bank_name)                     
               + SPACE(100)                                
               + convert(char(50),ben_rbi_ref_no)                    
               + case when convert(char(8),replace(convert(varchar,ben_rbi_app_dt,102),'.',''))  = '19000101' then '' else convert(char(8),replace(convert(varchar,ben_rbi_app_dt,102),'.',''))    end                                    
               + convert(char(24),ben_sebi_reg_no)                   
               + convert(char(20),ben_tax_ded_sts)                   
               + local_addr                                          
               + bank_addr                                           
               + nom_gur_addr                                        
               + min_nom_g_addr                                      
               + convert(char(1),for_cor_addr)                       
               + convert(char(2),no_of_fh_at)                      
               + convert(char(2),no_of_sh_at)                      
               + convert(char(2),no_of_th_at)                      
               + convert(char(5),size_of_sign)                     
               + convert(char(35),send_ref_no1)                    
               + convert(char(35),send_ref_no2)                    
               + convert(char(9),isnull(micr_cd,''))                          
               + convert(char(2),isnull(bank_acct_type,''))                   
               + SPACE(20)                                         
               + convert(char(50),fh_email)                        
               + convert(char(9),fh_map_id )                       
               + convert(char(12),fh_mob_no)                       
               + convert(char(1),fh_sms_fac)                       
               + convert(char(1),fh_poa_fac)                       
               + convert(char(1),fh_pan_flg)                       
               + SPACE(14)                                         
               + convert(char(50),sh_email)                        
               + convert(char(9),sh_map_id)                        
               + convert(char(12),sh_mob_no)                       
               + convert(char(1),sh_sms_fac)                       
               + SPACE(1)                                          
               + convert(char(1),sh_pan_flg)                       
               + SPACE(14)                                         
               + convert(char(50),th_email)                        
               + convert(char(9),th_map_id)                       
               + convert(char(12),th_mob_no)                      
               + convert(char(1),th_sms_fac)                      
               + SPACE(1)                                         
			   + convert(char(1),th_pan_flg)                      
               + SPACE(14)                        
               , dpam_sign_path                  
               , dpam_fholder_sign                   
               , dpam_sholder_sign                   
               , dpam_tholder_sign   
			   ,send_ref_no1                 
          FROM  @l_dp_pri_dtls                  
          WHERE ben_acct_ctgr      = '01'                  
          --and   dpam_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
        --                  
        END                  
        ELSE                  
        BEGIN                  
        --                  
          INSERT INTO #l_values(dp_string,sign_path,fhd_sign,shd_sign,thd_sign,sba_no)                  
		  SELECT --'02'                  
              --- + '0000000'                  
              -- + 'A'                                                                            
                convert(char(2),ben_acct_ctgr)                                                 
               + convert(char(2),ben_type)                                             
               + convert(char(2),ben_sub_type)                                         
               + convert(char(16),ben_short_name)
               + CONVERT(CHAR(2),BEN_OCCUPATION)
               + SPACE(180)                                                              
               + convert(char(45),sh_name)                   
			   + SPACE(90)                   
               + convert(char(45),sh_fth_hus_name) --SPACE(135)                                  
               + convert(char(45),th_name)                   
                 + SPACE(90)                                  
               + convert(char(45),th_fth_hus_name)
               + SPACE(8)                                  
               + convert(char(1),addr_pref_flg)                   
               + convert(char(10),fh_pan)              
               + SPACE(20)                                    
               + convert(char(10),sh_pan)                     
               + SPACE(20)                                    
               + convert(char(10),th_pan)                    
               + SPACE(128)                                  
               + convert(char(1),stan_instr_ind)                  
               + convert(char(30),ben_bank_acct_no)                  
               + convert(char(35),ben_bank_name)                     
               + SPACE(100)                                
               + convert(char(50),ben_rbi_ref_no)                    
               + case when convert(char(8),replace(convert(varchar,ben_rbi_app_dt,102),'.',''))  = '19000101' then '' else convert(char(8),replace(convert(varchar,ben_rbi_app_dt,102),'.',''))    end                                    
               + convert(char(24),ben_sebi_reg_no)                   
               + convert(char(20),ben_tax_ded_sts)                   
               + local_addr                                          
               + bank_addr                                           
               + nom_gur_addr                                        
               + min_nom_g_addr                                      
               + convert(char(1),for_cor_addr)                       
               + convert(char(2),no_of_fh_at)                      
               + convert(char(2),no_of_sh_at)                      
               + convert(char(2),no_of_th_at)                      
               + convert(char(5),size_of_sign)                     
               + convert(char(35),send_ref_no1)                    
               + convert(char(35),send_ref_no2)                    
               + convert(char(9),isnull(micr_cd,''))                          
               + convert(char(2),isnull(bank_acct_type,''))                   
               + SPACE(20)                                         
               + convert(char(50),fh_email)                        
               + convert(char(9),fh_map_id )                       
               + convert(char(12),fh_mob_no)                       
               + convert(char(1),fh_sms_fac)                       
               + convert(char(1),fh_poa_fac)                       
               + convert(char(1),fh_pan_flg)                       
               + SPACE(14)                                         
               + convert(char(50),sh_email)                        
               + convert(char(9),sh_map_id)                        
               + convert(char(12),sh_mob_no)                       
               + convert(char(1),sh_sms_fac)                       
               + SPACE(1)                                          
               + convert(char(1),sh_pan_flg)                       
               + SPACE(14)                                         
               + convert(char(50),th_email)                        
               + convert(char(9),th_map_id)                       
               + convert(char(12),th_mob_no)                      
               + convert(char(1),th_sms_fac)                      
               + SPACE(1)                                         
			   + convert(char(1),th_pan_flg)                      
               + SPACE(14)                        
               , dpam_sign_path                  
               , dpam_fholder_sign                   
               , dpam_sholder_sign                   
               , dpam_tholder_sign   
              , send_ref_no1               
          FROM  @l_dp_pri_dtls                  
          WHERE ben_acct_ctgr      = '01'                  
          --and   dpam_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
        --                  
          
        END               
      --                  
      END                  
      IF @l_chk = 3 or @l_chk = 4                     
      BEGIN                  
      --                  
        IF @PA_TAB = 'N'                    
        BEGIN                  
        --                  
          INSERT INTO #l_values(dp_string,sign_path,fhd_sign,shd_sign,thd_sign,sba_no)                  
          SELECT --'02'                  
              --- + '0000000'                  
              -- + 'A'                                                                            
                convert(char(2),ben_acct_ctgr)                                                 
               + convert(char(2),ben_type)                                             
               + convert(char(2),ben_sub_type)                                         
               + convert(char(16),ben_short_name)                                     
               + CONVERT(CHAR(2),BEN_OCCUPATION)
               + SPACE(540)                                                              
               + convert(char(8),corr_bp_id)                             
               + SPACE(1)                                            
               + convert(char(10),fh_pan)                     
               + SPACE(188)                                    
               + convert(char(1),stan_instr_ind)                  
               + convert(char(30),ben_bank_acct_no)                  
               + convert(char(35),ben_bank_name)                     
               + SPACE(202)                                          
               + local_addr                                          
               + bank_addr                                           
               + nom_gur_addr                                        
               + min_nom_g_addr                                      
               + convert(char(1),for_cor_addr)                       
               + convert(char(2),no_of_fh_at)                      
    + convert(char(2),no_of_sh_at)                      
               + convert(char(2),no_of_th_at)                      
               + convert(char(5),size_of_sign)                     
     + convert(char(35),send_ref_no1)                    
               + convert(char(35),send_ref_no2)                    
               + convert(char(9),isnull(micr_cd,''))                          
               + convert(char(2),isnull(bank_acct_type,''))                   
               + SPACE(284)                   
               , dpam_sign_path                  
               , dpam_fholder_sign                   
               , dpam_sholder_sign                   
               , dpam_tholder_sign  
,send_ref_no1                 
          FROM  @l_dp_pri_dtls                  
          WHERE ben_acct_ctgr      = '03'                  
          --and   dpam_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
        --                  
        END                  
        ELSE IF @PA_TAB = 'M'                   
        BEGIN                  
        --                  
          INSERT INTO #l_values(dp_string,sign_path,fhd_sign,shd_sign,thd_sign,sba_no)                  
          SELECT --'02'                  
              --- + '0000000'                  
              -- + 'A'                                                                            
                convert(char(2),ben_acct_ctgr)                                                 
               + convert(char(2),ben_type)                                             
               + convert(char(2),ben_sub_type)                                         
               + convert(char(16),ben_short_name)                                      
               + CONVERT(CHAR(2),BEN_OCCUPATION)
               + SPACE(540)                                                              
               + convert(char(8),corr_bp_id)                             
               + SPACE(1)                                            
               + convert(char(10),fh_pan)                     
               + SPACE(188)                                    
               + convert(char(1),stan_instr_ind)                  
               + convert(char(30),ben_bank_acct_no)                  
               + convert(char(35),ben_bank_name)                     
               + SPACE(202)                                          
               + local_addr                                          
               + bank_addr                                           
               + nom_gur_addr                                        
               + min_nom_g_addr                                      
               + convert(char(1),for_cor_addr)                       
               + convert(char(2),no_of_fh_at)                      
    + convert(char(2),no_of_sh_at)                      
               + convert(char(2),no_of_th_at)                      
               + convert(char(5),size_of_sign)                     
     + convert(char(35),send_ref_no1)                    
               + convert(char(35),send_ref_no2)                    
               + convert(char(9),isnull(micr_cd,''))                          
               + convert(char(2),isnull(bank_acct_type,''))                   
               + SPACE(284)                   
               , dpam_sign_path                  
               , dpam_fholder_sign                   
               , dpam_sholder_sign                   
               , dpam_tholder_sign 
,send_ref_no1                 
          FROM  @l_dp_pri_dtls                  
          WHERE ben_acct_ctgr      = '03'                  
          --AND   dpam_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                          
        --                  
        END                  
        ELSE                  
        BEGIN                  
        --                  
          INSERT INTO #l_values(dp_string,sign_path,fhd_sign,shd_sign,thd_sign,sba_no)                  
          SELECT --'02'                  
              --- + '0000000'                  
              -- + 'A'                                                                            
                convert(char(2),ben_acct_ctgr)                                                 
               + convert(char(2),ben_type)                                             
               + convert(char(2),ben_sub_type)                                         
               + convert(char(16),ben_short_name)                                      
               + CONVERT(CHAR(2),BEN_OCCUPATION)           
               + SPACE(540)                                                              
               + convert(char(8),corr_bp_id)                             
               + SPACE(1)                                            
               + convert(char(10),fh_pan)                     
               + SPACE(188)                                    
               + convert(char(1),stan_instr_ind)                  
               + convert(char(30),ben_bank_acct_no)                  
               + convert(char(35),ben_bank_name)                     
               + SPACE(202)                                          
               + local_addr                                          
               + bank_addr                                           
               + nom_gur_addr                                        
               + min_nom_g_addr                                      
               + convert(char(1),for_cor_addr)                       
               + convert(char(2),no_of_fh_at)                      
    + convert(char(2),no_of_sh_at)                      
               + convert(char(2),no_of_th_at)                      
               + convert(char(5),size_of_sign)                     
     + convert(char(35),send_ref_no1)                    
               + convert(char(35),send_ref_no2)                    
               + convert(char(9),isnull(micr_cd,''))                          
               + convert(char(2),isnull(bank_acct_type,''))                   
               + SPACE(284)                   
               , dpam_sign_path                  
               , dpam_fholder_sign                   
               , dpam_sholder_sign                   
               , dpam_tholder_sign       
,send_ref_no1            
          FROM  @l_dp_pri_dtls                  
          WHERE ben_acct_ctgr      = '03'                  
          --AND   dpam_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
        --                  
        END                  
      --                  
      END                                                                 
     
      --********************NON-HOUSE --> fI, fII, body corporate, mutual fund , trust and bank ************--                  
                    
      --           
      SELECT DISTINCT dp_string,sign_path docpath,fhd_sign,shd_sign,thd_sign,sba_no from  #l_values  order by sba_no                
      --      
         --                  
    END                  
    ELSE IF @pa_exch = 'CDSL'                  
    BEGIN                  
    -- 
      SELECT @L_DPM_ID = DPM_ID FROM DP_MSTR WHERE DEFAULT_DP = @PA_EXCSM_ID AND DPM_DELETED_IND = 1                 
      PRINT @pa_from_dt
      PRINT @pa_to_dt
      
     exec [citrus_usr].[pr_auto_nrn_poaid] @pa_crn_no      
                            , @pa_exch                        
                            , @pa_from_dt     
                            , @pa_to_dt       
                            , @pa_tab         
                            , @PA_BATCH_NO    
                            , @PA_EXCSM_ID    
                            , @PA_LOGINNAME   
                            , @pa_ref_cur     
                             
      declare @line2 table (ln_no CHAR(2)                  
                         ,crn_no                  numeric                  
                         ,acct_no                 varchar(20)  
                         ,dpam_id				  numeric              
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
                         ,hldr_pan                char(10) 
						 , HLDR_UID               CHAR(16) -- 12
                         ,it_crl                  char(15)                  
                         ,cust_email              char(100)--50 Sep1818                  
                         ,bo_usr_txt1             char(50)                  
                         ,bo_usr_txt2             char(50)                  
                         ,bo_user_fld3            varchar(20)                  
                         ,bo_user_fld4            char(4)                  
                         ,bo_user_fld5            varchar(20)                  
                         ,sign_bo                 varchar(8000)          
                         ,sign_fl_flag            char(1)
                         ,Borequestdt varchar(14)
						 --Sep1818
						 ,cust_adr_cntry_cd  char(2)
						 ,cust_state_code varchar(6)
						 ,city_seq_no char(2)
						 ,Smart char(1)
						 ,Pri_mob_ISD varchar(6)
						 ,Sec_mobile varchar(17)
						 ,Sec_mob_ISD varchar(6)
						 --Sep1818
						 --Jul282021
						 ,pan_vf char(1)
						 ,Bo_Acop_src char(1)						 
						 ,pan_vf2 char(1)
						 ,pan_vf3 char(1)
						 --Jul282021

						 						/*cir May 26 2025*/
						,DtBsdaOptOut datetime
						,Rbsdam varchar(100)
						,DtIntdem datetime
						,DrvLiccd varchar(40)
						,PassOCI varchar(40)
						,Fnoms char(3)
						/*cir May 26 2025*/
						 
                         )                  
      declare @line3 table(ln_no CHAR(2)                  
                         ,crn_no                  numeric                      
                         ,acct_no                 varchar(20)                  
                         ,bo_name1                 char(100)                  
                         ,bo_mid_name1             char(20)                  
                         ,cust_search_name1        char(20)                  
                         ,bo_title1                char(10)                  
                         ,bo_suffix1               char(10)                  
                         ,hldr_fth_hsd_nm1         char(50)                  
                         ,hldr_pan1                char(10) 
						 , HLDR_UID1               CHAR(16) -- 15                 
                         ,it_crl1                  char(15)
                         ,sh_mob char(17)-- 10
,sh_email char(100)--50
,sh_mob_phone_isd varchar(6)
                         )                   
                                           
      declare @line4 table(ln_no CHAR(2)                  
                         ,crn_no                  numeric                  
                         ,acct_no                 varchar(20)                  
                         ,bo_name2                 char(100)                  
                         ,bo_mid_name2             char(20)                  
                         ,cust_search_name2        char(20)                  
                         ,bo_title2                char(10)                  
                         ,bo_suffix2               char(10)                  
                         ,hldr_fth_hsd_nm2         char(50)                  
                         ,hldr_pan2                char(10) 
						  , HLDR_UID2               CHAR(16) -- 15                 
                         ,it_crl2                  char(15)
                         ,th_mob char(17)--10
,th_email char(100)--50
,th_mob_phone_isd varchar(6)
                         )                   
                                           
                                           
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
			 --changed by tushar  on jan 09 2015
                         ,bo2_usr_txt1            char(40) 
			  ,EMAIL_STATEMENT_FLAG            char(1)                  
                         ,CAS_MODE char(2)                  
                         ,MENTAL_DISABILITY char(1)                  
                         ,Filler1            char(1)                  
                         --changed by tushar  on jan 09 2015
                         ,RGESS_FLAG char(1)
						 ,ANNUAL_REPORT char(1)
						 ,PLEDGE_STANDING char(1)
						 ,EMAIL_RTA char(1)
						 ,BSDA_FLAG CHAR(1)                                    
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
                         ,divnd_bank_code         char(12)                  
                         ,divnd_acct_numb         char(20)                  
                         ,divnd_bank_ccy          varchar(20)
                         ,Bonafide_flg char(1)
                         )                  
                                           
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
                         ,Purpose_code            CHAR(3)--numeric                  
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
                         ,cust_addl_ph            char(92)  
                         ,cust_dob char(8)  
                                              
 ,cust_fax                char(100)                   
                         ,hldr_in_tax_pan         char(100)                    
                         ,it_crl                  char(100)                   
                         ,cust_email              char(100)                  
                         ,usr_txt1                char(100)                    
                         ,usr_txt2                char(100)                   
                         ,usr_fld3                numeric                  
                         ,usr_fld4                numeric                      
                      ,usr_fld5                numeric            
					  ,nom_serial_no varchar(10)
,rel_withbo    varchar(10)
,sharepercent varchar(10)
,res_sec_flag char(1)      
  
,ln7_cust_adr_cntry_cd char(2)
,ln7_cust_adr_state_cd varchar(6)
,ln7_city_seq_no char(2)
,ln7_Pri_mob_ISD varchar(6)

                         )                     
                        
                        
              declare @line8 table(ln_no CHAR(2)                  
                         ,crn_no                  numeric 
                         ,acct_no                 varchar(20)                  
                         ,purposecode             char(2)
                         ,flag                    char(1)                  
                         ,mobile                  char(11)                  
                         ,email                   char(100)                  
                         ,remarks                 char(100)                  
                         ,push_flg                char(1)                  
                       )    
					   

					   DECLARE  @line9 TABLE (ln_no    CHAR(2)          
														,crn_no NUMERIC            
														,acct_no      varchar(20)                 
														,purposecode  varchar(20)           
														
														,PSRN_PMSMANAGER varchar(200) 
														,PMS_MOBILENO_ISDCD varchar(200)  
														,PMS_MOBILE_NUMBER varchar(200) 
														,PMS_MIDDLE_NAME varchar(200)
														,PMS_LAST_NAME varchar(200) 
														,PMS_BO_NAME  varchar(200) )
                                      
                                                    
       
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
          print 'slip'            
            SET @l_crn_no  = CONVERT(NUMERIC, citrus_usr.fn_splitval(@@cur_id,1))                  
            SET @l_acct_no = CONVERT(VARCHAR(25), citrus_usr.fn_splitval(@@cur_id,2))                  
            --                   
            INSERT INTO @crn                   
            SELECT clim_crn_no,@l_acct_no, clim_stam_cd, clim_created_dt, clim_lst_upd_dt                  
            FROM   client_mstr WITH (NOLOCK)                  
            WHERE  clim_crn_no = CONVERT(numeric, @l_crn_no)                  
               print 'slip1'      
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
        print 'crnnobaln'         
        insert into @line2( ln_no                  
                           ,crn_no                  
                           ,acct_no                  
                           ,dpam_id
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
						   , HLDR_UID                          
                           ,it_crl                               
                           ,cust_email                           
                           ,bo_usr_txt1                          
                           ,bo_usr_txt2                          
                           ,bo_user_fld3                         
                           ,bo_user_fld4                         
                           ,bo_user_fld5                   
                           ,sign_bo                                   
                           ,sign_fl_flag
                           ,Borequestdt
						   
						    ,cust_adr_cntry_cd  
							,cust_state_code 
							,city_seq_no 
							,Smart 
							,Pri_mob_ISD 
							,Sec_mobile 
							,Sec_mob_ISD 
							,pan_vf
							,Bo_Acop_src
							,pan_vf2
							,pan_vf3

														,DtBsdaOptOut
							,Rbsdam 
							,DtIntdem 
							,DrvLiccd 
							,PassOCI 
							,Fnoms 
						   )                  
                           SELECT distinct '02'                  
                                , clim_crn_no                  
                                , dpam_acct_no   
                                ,dpam_id               
                                --, citrus_usr.Fn_FormatStr(left(subcm_cd,2),4,0,'L','0')                  
                                ,case when subcm_cd in ('022545') then citrus_usr.Fn_FormatStr(left('40',2),4,0,'L','0')    
									  when subcm_cd in ('392144') then citrus_usr.Fn_FormatStr(left('39',2),4,0,'L','0') 
									  when subcm_cd in ('413046') then citrus_usr.Fn_FormatStr(left('41',2),4,0,'L','0') else citrus_usr.Fn_FormatStr(left(subcm_cd,2),4,0,'L','0')    end
                                , case when dpam_clicm_cd in ('21' , '24' , '27') then  isnull(CLIM_NAME1,'')--CITRUS_USR.inside_trim(LTRIM(RTRIM(DPAM_SBA_NAME)),'1')
                                  else ltrim(rtrim(isnull(CLIM_NAME1,''))) + ' ' + ltrim(rtrim(isnull(CLIM_NAME2,''))) + ' ' + ltrim(rtrim(isnull(CLIM_NAME3,'')))  end
                                , case when dpam_clicm_cd in ('21' , '24' , '27') then isnull(CLIM_NAME2,'')-- CITRUS_USR.inside_trim(LTRIM(RTRIM(DPAM_SBA_NAME)),'2')
                                  else '' end
                                , case when dpam_clicm_cd in ('21' , '24' , '27') then case when isnull(CLIM_NAME3,'')='' then '.' else isnull(CLIM_NAME3,'') end--CITRUS_USR.inside_trim(LTRIM(RTRIM(DPAM_SBA_NAME)),'3')
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
                                --, isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'Y'),'')  
                                --, isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'N'),'')   --convert(varchar(17),isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH1'),''))--ph1                  
                                ,case when isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'Y'),'') <> '' then isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'Y'),'')  else isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,3,'Y'),'')  end
                                , case when isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'N'),'') <> '' then isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'N'),'') else isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,3,'N'),'') end  
                                , isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'Y'),'')            --'0'                  
                                , isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'N'),'')  --isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH2'),'')--ph2                  
                                , isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,3,'N'),'')                 
                                , CASE WHEN isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCFAX1'),'') <> '' THEN isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCFAX1'),'') ELSE isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'FAX1'),'') END --fax                  
                                , isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'')  --pan card                  
                                , isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ADHAARFLAG',''),'')  
								,''
                                , CASE WHEN lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCEMAIL1'),'')) <> '' THEN lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCEMAIL1'),'')) ELSE lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'EMAIL1'),'')) END --email                  
                                , ''                  
                                , ''                  
                                , '0000'                  
                                , ''                  
                                --, case when isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'') <> '' then '1' else '0' end + case when isnull(DPHD_SH_PAN_NO,'') <> '' then '1' else '0' end + case when  isnull(DPHD_TH_PAN_NO,'') <> '' then '1' else '0' end + '0'                
                                --add for fiest holder adhar flag -- 
                                , case when isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'') <> '' then '1' else '0' 
									end + case when isnull(DPHD_SH_PAN_NO,'') <> '' then '1' else '0' end 
									+ case when  isnull(DPHD_TH_PAN_NO,'') <> '' then '1' else '0' END 
									+ CASE when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ADHAARFLAG',''),'') <> '' then '2' else '0' end 
				--add for fiest holder adhar flag -- 
                                ,ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_BO',''),'')                  
                                , case when ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_BO',''),'') = '' then 'N' else 'Y'   end --signature file flag                  
								,REPLACE(CONVERT(VARCHAR(10), DPAM_CREATED_DT, 103), '/', '')+LEFT(REPLACE(CONVERT(VARCHAR(12), DPAM_CREATED_DT, 114),':','') ,6) 
								
,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('Country',citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),6 )),'')-- addr cntry code
,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('State',citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),5 )),'') -- state code
,isnull(citrus_usr.Fn_Toget_CitySeqno(citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),7) ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),4)),'' )-- city seq no
,case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'SMART_REG',''),'')  ='YES' then 'Y' else ' ' end 
,CASE WHEN lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'PRIIC'),'')) <> '' THEN  
								
convert(varchar(6),citrus_usr.FN_FORMATSTR(convert(varchar(6),lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'PRIIC'),'')) ),6,0,'L','0'))  else space(6) END
,CASE WHEN lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'secmob'),'')) <> '' THEN  lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'secmob'),'')) else space(17) END
,CASE WHEN lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'secic'),'')) <> '' THEN  
convert(varchar(6),citrus_usr.FN_FORMATSTR(convert(varchar(6),lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'secic'),'')) ),6,0,'L','0'))  else '000000' END
,citrus_usr.fn_get_PanBOBONA_Val(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'PANVC',''),''),'PANVC')
,LTRIM(RTRIM(citrus_usr.fn_get_PanBOBONA_Val(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'BOOS',''),''),'BOOS')))
,case when isnull(DPHD_SH_PAN_NO,'') <> '' then citrus_usr.fn_get_PanBOBONA_Val(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'PANVC2',''),''),'PANVC2') else '0' end
,case when isnull(DPHD_TH_PAN_NO,'') <> '' then  citrus_usr.fn_get_PanBOBONA_Val(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'PANVC3',''),''),'PANVC3') else '0' end

,case when right(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'DtBsdaOptOut',''),''),4) + substring(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'DtBsdaOptOut',''),''),4,2) + SUBSTRING(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'DtBsdaOptOut',''),''),1,2)='19000101' then '' else  right(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'DtBsdaOptOut',''),''),4) + substring(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'DtBsdaOptOut',''),''),4,2) + SUBSTRING(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'DtBsdaOptOut',''),''),1,2) end   --ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'DtBsdaOptOut',''),'')
,ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'Rbsdam',''),'')
,case when right(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'DtIntdem',''),''),4) + substring(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'DtIntdem',''),''),4,2) + SUBSTRING(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'DtIntdem',''),''),1,2) ='19000101' then '' else  right(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'DtIntdem',''),''),4) + substring(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'DtIntdem',''),''),4,2) + SUBSTRING(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'DtIntdem',''),''),1,2) end
,ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'DrvLiccd',''),'')
,ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'PassOCI',''),'')
,ISNULL((select top 1 isnull(NOM_TRXPRINTFLAG,'') from nominee_multi a where a.Nom_dpam_id = dpam.dpam_id) ,'')

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
                           AND    isnull(dpam.dpam_batch_no,0) = 0   
                           AND    excsm_exch_cd           = @pa_exch  
                           AND    subcm.subcm_CD          = DPAM.DPAM_SUBCM_CD  
                           AND    subcm.subcm_deleted_ind = 1                  
                           AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
                           AND    clim.clim_deleted_ind   = 1                  
                           AND    isnull(cliba.cliba_deleted_ind,1) = 1                  
                           AND    isnull(banm.banm_deleted_ind,1)   = 1  
                           and    DPAM_DPM_ID = @L_DPM_ID                
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
									 , HLDR_UID1                                            
                                     ,it_crl1
                                     ,sh_mob
,sh_email
,sh_mob_phone_isd

                                     )                  
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
                                                  , isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ADHAARSECHLDR',''),'') 
												  ,'' 
												  ,isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'SH_MOB'),'')
,lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'SH_EMAIL1'),''))
,case when isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'secmic'),'')<>'' then convert(varchar(6),citrus_usr.FN_FORMATSTR(convert(varchar(6),lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'secmic'),'')) ),6,0,'L','0')) else '000000' end --isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'secmic'),'')
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
                                      AND    isnull(dpam.dpam_batch_no,0) = 0   
                                      AND    dpam.dpam_excsm_id      = excsm_id                  
                                      AND    excsm_exch_cd           = @pa_exch  
                                      AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
                                      AND    clim.clim_deleted_ind   = 1                  
                                      AND    isnull(cliba.cliba_deleted_ind,1) = 1                  
                                      AND    isnull(banm.banm_deleted_ind,1)   = 1    
                                      AND    isnull(dphd.dphd_sh_fname,'') <> '' 
                                       and    DPAM_DPM_ID = @L_DPM_ID      
                                      AND    CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
                  
                  
                 print '111' 
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
								   ,HLDR_UID2                         
                                   ,it_crl2
                                   ,th_mob
,th_email
,th_mob_phone_isd
                                   )                   
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
                                              , isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ADHAARTHRDHLDR',''),'')
											  ,''  
											   ,isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'th_mob'),'')
,lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'TH_EMAIL1'),''))
,case when isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'THMIC'),'')<>'' then convert(varchar(6),citrus_usr.FN_FORMATSTR(convert(varchar(6),lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'THMIC'),'')) ),6,0,'L','0'))  else '000000' end--isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'THMIC'),'')
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
                                    AND    isnull(dpam.dpam_batch_no,0) = 0   
                                    AND    dpam.dpam_deleted_ind   = 1            
                                    AND    dpam.dpam_excsm_id      = excsm_id                  
                                    AND    excsm_exch_cd           = @pa_exch  
                                    AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
                                    AND    clim.clim_deleted_ind   = 1                  
                                    AND    isnull(cliba.cliba_deleted_ind,1) = 1                  
                                    AND    isnull(banm.banm_deleted_ind,1)   = 1    
                                    AND    isnull(dphd.dphd_th_fname,'') <> '' 
                                     and    DPAM_DPM_ID = @L_DPM_ID      
                                    AND    CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
                  
                   print '111111111' 
                                 
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
			--changed by tushar on jan 09 2015
           			  ,EMAIL_STATEMENT_FLAG            
				  ,CAS_MODE   
				  ,MENTAL_DISABILITY                          
				  ,Filler1            
                                --changed by tushar on jan 09 2015
						 ,RGESS_FLAG 
						 ,ANNUAL_REPORT 
						 ,PLEDGE_STANDING
						 ,EMAIL_RTA 
						 ,BSDA_FLAG                                                      
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
                                  ,divnd_bank_ccy
                                  ,Bonafide_flg
                                  )                  
                                  SELECT distinct '05'                  
                                       , clim_crn_no                  
                                       , dpam_acct_no                  
                                       , case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'date_of_maturity',''),'00000000')= '' then '00000000' else isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'date_of_maturity',''),'00000000') end  --dt_of_maturity                  
									                              , left(dpam_acct_no,10)--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'dp_int_ref_no',''),'')  --dp_int_ref_no                  
                                       , case when dpam_subcm_cd in ('2156','2155','2150','082104','022512','022552','102624','122624','192624','022545','512624','022567','0225105','0225104') then case when isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',''),'') = '' then '00000000' else isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',''),'00000000') end  else case when isnull(convert(varchar(11),clim.clim_dob,103),'00000000') = '01/01/1900' then '00000000' else   isnull(convert(varchar(11),clim.clim_dob,103),'00000000')  end                end
                                       , isnull(clim.clim_gender,'')                  
                                       , CASE WHEN citrus_usr.fn_get_listing('occupation',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'occupation',''),'')) = '' THEN 'O' ELSE citrus_usr.fn_get_listing('occupation',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'occupation',''),'')) END --occupation          
                                       , ''  
                                       , citrus_usr.fn_get_listing('GEOGRAPHICAL',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'GEOGRAPHICAL',''),''))   --geographical_cd                  
                                       , citrus_usr.fn_get_listing('EDUCATION',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'EDUCATION',''),''))    --edu                  
                                       , ltrim(rtrim(case when dpam_subcm_cd in ('2156','2155','2150','022512','022552','102624','122624','192624','022545','512624','022567','0225105','0225104') then citrus_usr.fn_get_PanBOBONA_Val(isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'ANNUAL_INCOMENI',''),''),'ANNUAL_INCOMENI') else citrus_usr.fn_get_PanBOBONA_Val(isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'ANNUAL_INCOME',''),''),'ANNUAL_INCOME') end ))--isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,''),'')   --ann_income_cd                  --,'082104'
                                       , citrus_usr.fn_get_listing('NATIONALITY',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'NATIONALITY',''),''))   --nat_cd                  
                                       , CASE WHEN citrus_usr.fn_ucc_entp(clim.clim_crn_no,'legal_sta','')='' THEN '00' ELSE isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'legal_sta',''),'00') END  --legal_status_cd                  
                                       , CASE WHEN citrus_usr.fn_ucc_entp(clim.clim_crn_no,'bofeetype','')='' THEN '00' ELSE isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'bofeetype',''),'00') END    --bo_fee_type                  
                                       ,  citrus_usr.fn_get_listing('LANGUAGE',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'LANGUAGE',''),''))    --lang_cd                  
                                       , '00'--'' -- category4_cd                  
                                       , '00'--'' -- bank_option5                  
                                       , case when dpam_clicm_cd in ('21' , '24' , '27') then  left(isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'STAFF',''),''),1) else '' end              
                                       , '' -- staff_cd                  
                                       , '' -- usr_txt1     
			  --changed by tushar on jan 09 2015
                                        ,case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'Email_st_flag',''),'')  NOT IN ( 'NO','') then 'Y' else 'N' end   --EMAIL_STATEMENT_FLAG            
                                        ,case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'cas_flag',''),'')  =  'CAS NOT REQUIRED' OR  isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'Email_st_flag',''),'')='YES' then 'NO' else 'PH' end   --cas_flag
										,case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'mental_flag',''),'')  NOT IN ( 'NO','') then 'Y' when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'mental_flag',''),'')  IN ( 'NO') then 'N' else '' end  --CAS_MODE   
										,''            
                                         --changed by tushar on jan 09 2015
 , case when isnull(citrus_usr.fn_ucc_accp(dpam_id,'RGESS_FLAG',''),'00')  = 'YES'     then 'Y' else 'N' end
									   --, ''
									   --, ''
									   --,''
									   , case when isnull(citrus_usr.fn_ucc_accp(dpam_id,'ANNUAL_REPORT',''),'00')  = 'ELECTRONIC'     then '2'
										   when isnull(citrus_usr.fn_ucc_accp(dpam_id,'ANNUAL_REPORT',''),'00')  = 'PHYSICAL'     then '1'
										   when isnull(citrus_usr.fn_ucc_accp(dpam_id,'ANNUAL_REPORT',''),'00')  = 'BOTH'     then '3' else ''  end
									   ,case when isnull(citrus_usr.fn_ucc_accp(dpam_id,'PLEDGE_STANDING',''),'00')  = 'YES'     then 'Y' 
											when isnull(citrus_usr.fn_ucc_accp(dpam_id,'PLEDGE_STANDING',''),'00')  = 'NO'     then 'N'else 'N' end
										,case when isnull(citrus_usr.fn_ucc_accp(dpam_id,'RTA_EMAIL',''),'00')  = 'YES'     then 'Y' 
											when isnull(citrus_usr.fn_ucc_accp(dpam_id,'RTA_EMAIL',''),'00')  = 'NO'     then 'N'else 'N' end
									   , case when citrus_usr.fn_acct_entp(dpam_id , 'BSDA') = '1' then 'Y' else '' end                                                     
                                       , '' -- usr_txt2                  
                                     , case when isnull(citrus_usr.fn_ucc_accp(dpam_id,'MOO',''),'0000')  = 'Sole Holder'     then '0000' 
									   when isnull(citrus_usr.fn_ucc_accp(dpam_id,'MOO',''),'0000')  = 'Jointly'     then '0001' 
									   when isnull(citrus_usr.fn_ucc_accp(dpam_id,'MOO',''),'0000')  = 'Anyone or Survivor'     then '0002' else '0000' end -- dummy1                   
                                       , case when isnull(citrus_usr.fn_ucc_accp(dpam_id,'CP',''),'0000')  = 'FIRST HOLDER'     then '0001' 
									   when isnull(citrus_usr.fn_ucc_accp(dpam_id,'CP',''),'0000')  = 'ALL HOLDERS'     then '0002' 
									   else '0001' end -- dummy2              
                                       , '0000'--'' -- dummy3                  
                                       , '00'--'' -- secur_acc_cd                  
                                       , left(enttm_cd,2)  
                                       , case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'bosettlflg',''),'')  <>  '' then 'Y' else 'N' end --bo_settm_plan_fg                  
                                       --, isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'voice_mail',''),'')  --voice_mail                               
										, case when banm_rtgs_cd in ('0','000000000')  then space(15) 
                                              when  banm_rtgs_cd not in ('0','000000000')   then convert(char(15),banm_rtgs_cd)
                                              else space(15) end voice_mail   
                                       , CASE WHEN isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'rbi_ref_no',''),'') = '' THEN isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'rbi_ref_no',''),'') ELSE isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'rbi_ref_no',''),'') END  --rbi_ref_no                               
                                       , CASE WHEN isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'rbi_ref_no',''),'') = '' THEN isnull(citrus_usr.fn_ucc_accpD(dpam.dpam_id,'rbi_ref_no','rbi_app_dt',''),'00000000') ELSE  isnull(citrus_usr.fn_ucc_entpD(clim.clim_crn_no,'rbi_ref_no','rbi_app_dt',''),'00000000') END  --rbi_app_dt                               
                                      -- , isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'sebi_regn_no',''),'')  --sebi_reg_no  
                                        , isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'sebi_reg_no',''),'')  --sebi_reg_no                                                          
                                      -- , citrus_usr.fn_get_listing('TAX_DEDUCTION',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'TAX_DEDUCTION',''),''))  --benef_tax_ded_sta  
                                       , case when ISNULL(citrus_usr.fn_get_listing('TAX_DEDUCTION',isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'TAX_DEDUCTION',''),'')),'')='' then '00' else citrus_usr.fn_get_listing('TAX_DEDUCTION',isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'TAX_DEDUCTION',''),'')) end  --benef_tax_ded_sta                                              
                                       , case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'SMART_CARD_REQ',''),'') <> '' then 'Y' else '' end                           
                                       , isnull(citrus_usr.fn_ucc_accpd(dpam.dpam_id,'SMART_CARD_REQ','SMART_CARD_NO',''),'')                             
                                       , isnull(citrus_usr.fn_ucc_accpd(dpam.dpam_id,'SMART_CARD_REQ','SMART_CARD_PIN',''),'0000000000')--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')  --smart_crd_pin                            
                                       , Case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ecs_flg',''),'')=1 then 'Y' when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ecs_flg',''),'')=0 then 'N' else 'N' end  --ecs                                   
                                       , Case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ecs_flg',''),'')=1 THEN '' ELSE  Case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'elec_conf',''),'')=1 then 'Y' when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ecs_flg',''),'')=0 then '' else '' end  END --elec_confirm                             
                                       , citrus_usr.fn_get_listing('dividend_currency',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'dividend_currency',''),''))  --dividend_curr                            
                                       , ''  
             --                          , case when dpam_subcm_cd in ('022545') then '40' 
											  --when dpam_subcm_cd in ('392144') then '39' 
											  --when dpam_subcm_cd in ('413046') then '41' else isnull(right(subcm.subcm_cd,2),'') end   
									   --,isnull(right(subcm.subcm_cd,2),'')	                           
                                       --, case when subcm.subcm_cd <> '292624'  then isnull(citrus_usr.get_ccm_id(isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')),'000000') else '000019' end                  
                                       , citrus_usr.FN_FORMATSTR(convert(varchar(4),right(subcm_cd,2)),4,0,'L','0') --isnull(right(subcm.subcm_cd,2),'')                            
                                       , case when subcm.subcm_cd <> '292624'  then isnull(citrus_usr.get_ccm_id(isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')),'0000') else '0019' end                 
                                       
                                       , isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBP_ID',''),'')                   
                                       , case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')  = 'NSE'     then '12'             
											when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')  = 'BSE' then '11'
											when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')  = 'MCX' then '23'
											when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')  = 'NCDEX' then '22'
											when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')  = 'DSE' then '14'
											when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')  = 'CSE' then '13'
											when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')  = 'BSE\CISA' then '20'
											when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')  = 'MCX-SX' then '29'
											else '00' end 

                                       , 'Y'--CASE WHEN isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'confirmation',''),'')='1' THEN 'Y' WHEN isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'confirmation',''),'')='0' THEN 'N'  ELSE 'N' END   --confir_waived                  
                                       ,isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'TRADINGID_NO',''),'')           
                                       , citrus_usr.fn_get_listing('bostmntcycle',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'bostmntcycle',''),''))  --bo_statm_cycle_cd                  
                                       , case when banm_micr in ('0','000000000')  then space(12) 
                                              --when  banm_micr not in ('0','000000000')   then isnull(banm_micr,space(12)) 
											  when  banm_micr not in ('0','000000000')   then space(12) 
                                              else space(12) end                   
                                       , ''--case when cliba_ac_type='SAVINGS' THEN '10' WHEN  cliba_ac_type='CURRENT' THEN '11' WHEN cliba_ac_type='OTHERS' THEN '13' ELSE '13' END                 --convert(char(12),banm_branch)                  
                                       , ''--isnull(cliba_ac_no ,'')                 
                                       , '000000'--citrus_usr.fn_get_listing('BANKCCY',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'BANKCCY',''),''))               
                                       , case when cliba_ac_type='SAVINGS' THEN '10' WHEN  cliba_ac_type='CURRENT' THEN '11' WHEN cliba_ac_type='OTHERS' THEN '13' WHEN cliba_ac_type='CASHCREDIT' THEN '13' ELSE '' END --''--case when cliba_ac_type='SAVINGS' THEN '10' WHEN  cliba_ac_type='CURRENT' THEN '11' WHEN cliba_ac_type='OTHERS' THEN '13' ELSE '13' END                 --convert(char(12),banm_branch)                                  
                                       , case when banm_micr in ('0','000000000')  then space(12) 
                                              when  banm_micr not in ('0','000000000')   then banm_micr 
                                              else space(12) end                                  
                                       , isnull(cliba_ac_no ,'') --''--isnull(cliba_ac_no ,'')                 
                                       , citrus_usr.fn_get_listing('BANKCCY',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'BANKCCY',''),''))--''--'000000'--citrus_usr.fn_get_listing('BANKCCY',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'BANKCCY',''),''))--''                  
                                       , ltrim(rtrim(citrus_usr.fn_get_PanBOBONA_Val(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'BONAFIDE',''),''),'BONAFIDE')))
                                  FROM   dp_acct_mstr              dpam                  
                                         left outer join   
										   dp_holder_dtls            dphd                 on dpam.dpam_id            = dphd.dphd_dpam_id                      
										   left outer join                       
										   client_bank_accts         cliba                on dpam.dpam_id            = cliba.cliba_clisba_id    AND    isnull(cliba.cliba_deleted_ind,1)     = 1  AND isnull(cliba_flg,'0') IN ('1','3')                 
										   left outer join           
                                           bank_mstr                 banm                 on  convert(int,cliba.cliba_banm_id)     = convert(int,banm.banm_id)  AND    isnull(banm.banm_deleted_ind,1)       = 1         
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
                                  AND    isnull(dpam.dpam_batch_no,0) = 0   
                                  AND    dpam.dpam_crn_no            = clim.clim_crn_no        
                                  AND    dpam.dpam_excsm_id      = excsm_id                  
                                  AND    excsm_exch_cd           = @pa_exch  
                                  --AND    cliba.cliba_clisba_id       = clisba.clisba_id                    
                                  AND    dpam.dpam_deleted_ind       = 1                  
                                  AND    isnull(dphd.dphd_deleted_ind,1)       = 1                   
                                  AND    isnull(clim.clim_deleted_ind,1)       = 1  
                                   and    DPAM_DPM_ID = @L_DPM_ID                     
                                  AND    CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
          
          PRINT 'YOGESH'
          
                               insert into @line6(ln_no                   
                                         ,crn_no                  
                                         ,acct_no                  
                                         ,poa_id                                    
                                         ,setup_date                                
                                         ,poa_to_opr_ac                             
                                         ,gpa_bpa_fl                                
                                         ,eff_frm_dt                                
                                         ,eff_to_dt                                 
                                         ,usr_fld1                                  
                                         ,usr_fld2                                  
                                         ,ca_charfld                                
                                         ,bo_name3                                
                                         ,bo_mid_name3                               
                                         ,cust_srh_name3                            
                                         ,bo_title3                                 
                                         ,bo_suffix3                                
                                         ,hldr_fth_hsb_nm3                          
                                         ,cus_addr1                                 
                                         ,cust_addr2                                
                                         ,cust_addr3                                
                                         ,cust_city                                 
                                         ,cust__state                               
                                         ,cust_cntry                                
                                         ,cust_zip                                  
                                         ,cust_ph1_ind                              
                                         ,cust_ph1                                  
                                         ,cust_ph2_ind                              
                                         ,cust_ph2                                  
                                         ,cust_addl_ph                              
                                         ,cust_fax                                  
                                         ,pan_no                                    
                                         ,it_crc                                    
                                         ,cust_email                                
                                         ,bo3_usr_txt1                              
                                         ,bo3_usr_txt2                              
                                         ,bo3_usr_fld3                                  
                                         ,bo3_usr_fld4                              
                                         ,bo3_usr_fld5                  
                                         ,sign_poa                  
                                         ,sign_file_fl)                  
                                        SELECT distinct '06'                  
											,clim_crn_no                  
											,isnull(dpam.dpam_acct_no,'')                  
											--,CITRUS_USR.FN_FORMATSTR(dppd_poa_id,16-len(dppd_poa_id),len(dppd_poa_id),'R',' ') dppd_poa_id--isnull(dppd_poa_id,replicate(0,16)) dppd_poa_id              
											,convert(char(16),dppd_poa_id) dppd_poa_id              
											,convert(char(11),getdate())                  
											,case when dppd_poa_type = 'FULL' then 'Y' else 'N' END                  
											,dppd_gpabpa_flg  
											,convert(char(11),getdate())
											--,dppd_eff_fr_dt--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')                    
											,dppd_eff_to_dt--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')                    
											,'0000'--''--usr_fld1                                  
                                               ,'0000'--'0000'--''--usr_fld2                                  
                                               ,case when dppd_gpabpa_flg = 'B' then dppd_poa_type else '' end --''--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')                    
                                               ,''--isnull(dppd.dppd_fname,'') 
                                               ,''--isnull(dppd.dppd_mname,'')                         
                                               ,''--convert(char(20),isnull(dppd.dppd_lname,''))     
                                               ,''--bo_title3                                 
                                               ,''--bo_suffix3                                
                                               ,''--isnull(dppd.dppd_fthname,'')                              
                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),1)--adr1                       
                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),2)--adr1                  
                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),3)--adr1                  
                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),4)--adr1                  
                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),5)--adr1                  
                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),6)--adr1                  
                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),7)--adr1                  
                                               ,''--case when isnull(citrus_usr.fn_dp_import_conc(dpam.dpam_id,'POA_OFF_PH1'),'') <> '' then  'O'    ELSE ''                                                     end                
                                               ,''--case when isnull(citrus_usr.fn_dp_import_conc(dpam.dpam_id,'POA_OFF_PH1'),'') <> '' then  isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'POA_OFF_PH1'),'')                                    end                                   
                                               ,''--cust_ph2_ind                              
                                               ,''  
                                               ,''  
                                               ,''  
                                               ,''--dppd_pan_no  
                                               ,''  
                                               ,''  
                                               ,isnull(dppd_master_id,'0')
                                               ,''--bo3_usr_txt2                              
                                               ,CASE WHEN dppd_hld = '1st holder' THEN  '0001'
																																																WHEN dppd_hld = '2nd holder' THEN  '0002'
																																																WHEN dppd_hld = '3rd holder' THEN  '0003' ELSE '0000' end                            
                                               ,'0000'--''--bo3_usr_fld4                              
                                               ,'0000'--''--bo3_usr_fld5                         
																	,ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_POA',''),'')                  
																	,case when ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_POA',''),'') = '' then 'N' else 'Y'   end  --signature file flag           
												FROM   dp_acct_mstr              dpam          
																			left outer join                  
																			dp_poa_dtls                   dppd                  
																			on dpam.dpam_id             = dppd.dppd_dpam_id                  
																	, client_mstr               clim                  
																	, entity_type_mstr          enttm                  
																	, client_ctgry_mstr         clicm                  
																			left outer join                  
																			sub_ctgry_mstr            subcm                   
																			on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
																			,exch_seg_mstr  
												WHERE  dpam.dpam_crn_no        = clim.clim_crn_no                  
												AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
												AND    isnull(dpam.dpam_batch_no,0) = 0   
												AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
												AND    dpam.dpam_excsm_id      = excsm_id                  
																												AND    excsm_exch_cd           = @pa_exch  
																																									AND    dpam.dpam_deleted_ind   = 1                  
																																									AND    clim.clim_deleted_ind   = 1  
																																									AND    dppd.dppd_deleted_ind   =1   
																																									AND    isnull(dppd.dppd_fname,'')  <> ''
																																									 and    DPAM_DPM_ID = @L_DPM_ID     
																																									AND    getdate() between dppd_eff_fr_dt and  CASE WHEN isnull(dppd_eff_to_dt,'01/01/2100') ='01/01/1900' THEN '01/01/2100' ELSE isnull(dppd_eff_to_dt,'01/01/2100') END --isnull(dppd_eff_to_dt,'01/01/2100')           
																																									AND    CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
																																									AND    isnull(dppd_poa_type,'') IN ('FULL','PAYIN ONLY')         
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
                                  ,cust_dob                               
                                  ,cust_fax                                 
                                  ,hldr_in_tax_pan                          
                                  ,it_crl                                   
                                  ,cust_email                               
                                  ,usr_txt1                                 
                                  ,usr_txt2                                 
                                  ,usr_fld3                                 
                                  ,usr_fld4                                 
                                  ,usr_fld5   
								  ,nom_serial_no
									,rel_withbo
									,sharepercent
									,res_sec_flag    

									,ln7_cust_adr_cntry_cd 
									,ln7_cust_adr_state_cd 
									,ln7_city_seq_no 
									,ln7_Pri_mob_ISD 
                          
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
                                  ,replace(convert(varchar(11),cust_dob,103),'/','')
                                  ,cust_fax                                 
                                  ,hldr_in_tax_pan                          
                                  ,it_crl                                   
                                  ,cust_email                               
                                  ,usr_txt1                                 
                                  ,usr_txt2                                 
                                  ,CASE WHEN usr_fld3=0 THEN '0000' ELSE usr_fld3 END                                 
                                  ,CASE WHEN usr_fld4=0 THEN '0000' ELSE usr_fld4 END                                  
                                  ,CASE WHEN usr_fld5=0 THEN '0000' ELSE usr_fld5 END  
								  ,nom_serial_no
								  ,rel_withbo
								  ,sharepercent
								  ,res_sec_flag    ,ln7_cust_adr_cntry_cd,ln7_cust_adr_state_cd,ln7_city_seq_no,ln7_Pri_mob_ISD   
                                  FROM fn_cdsl_export_line_7_extract(@pa_crn_no, @pa_from_dt, @pa_to_dt), dp_acct_mstr , EXCH_SEG_MSTR esm  
                                            WHERE dpam_acct_no = acct_no AND dpam_excsm_id =  excsm_id 
                                            AND   excsm_exch_cd = @pa_exch
                                            ORDER BY Purpose_code  DESC 
                                            
                                            
                                               INSERT INTO  @line8 (ln_no               
														,crn_no            
														,acct_no                    
														,purposecode           
														,flag                   
														,mobile                      
														,email                  
														,remarks                  
														,push_flg                      
												)    
											SELECT distinct '08'                  
											,clim_crn_no                  
											,dpam_sba_no                  
											,'16' --''--Purpose_code                             
											,'S'
											,isnull(CASE WHEN CITRUS_USR.fn_acct_conc_value(DPAM_ID,'MOBSMS')<> '' THEN CITRUS_USR.fn_acct_conc_value(DPAM_ID,'MOBSMS')
											ELSE CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'MOBSMS') END,'')
											,isnull(CASE WHEN CITRUS_USR.fn_acct_conc_value(DPAM_ID,'SMSEMAIL')<> '' THEN lower(CITRUS_USR.fn_acct_conc_value(DPAM_ID,'SMSEMAIL'))
											ELSE lower(CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'EMAIL1')) END ,'')
											,''
											,'P'
											FROM   dp_acct_mstr              dpam 
											,client_mstr  ,EXCH_SEG_MSTR esm    
											,account_properties accp           
											WHERE clim_crn_no = dpam_crn_no 
											AND   dpam_excsm_id = excsm_id 
											AND   accp_clisba_id = dpam_id
											AND    accp.accp_accpm_prop_cd = 'SMS_FLAG'
											AND    isnull(dpam.dpam_batch_no,0) = 0
											AND    accp.accp_value = '1'-- and 1 = 0
											AND   excsm_exch_cd = @pa_exch
											 and    DPAM_DPM_ID = @L_DPM_ID     
											--AND   (CITRUS_USR.fn_acct_conc_value(DPAM_ID,'MOBILE1')<>'' OR CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'MOBILE1')<>'')
											AND    CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
											

											    INSERT INTO  @line9 (ln_no               
														,crn_no            
														,acct_no                    
														,purposecode           
														
														,PSRN_PMSMANAGER
														,PMS_MOBILENO_ISDCD
														,PMS_MOBILE_NUMBER
														,PMS_MIDDLE_NAME
														,PMS_LAST_NAME
														,PMS_BO_NAME                   
												)    
											SELECT distinct '00'                  
											,clim_crn_no                  
											,dpam_sba_no                  
											,'00' --''--Purpose_code                             
											,citrus_usr.FN_UCC_ACCP(DPAM_ID, 'PSRN_PMSMANAGER','')
,citrus_usr.FN_UCC_ACCP(DPAM_ID, 'PMS_MOBILENO_ISDCD','')
,citrus_usr.FN_UCC_ACCP(DPAM_ID, 'PMS_MOBILE_NUMBER','')
,citrus_usr.FN_UCC_ACCP(DPAM_ID, 'PMS_MIDDLE_NAME','')
,citrus_usr.FN_UCC_ACCP(DPAM_ID, 'PMS_LAST_NAME','')
,citrus_usr.FN_UCC_ACCP(DPAM_ID, 'PMS_BO_NAME','')
											FROM   dp_acct_mstr              dpam 
											,client_mstr  ,EXCH_SEG_MSTR esm    
											--,account_properties accp           
											WHERE clim_crn_no = dpam_crn_no 
											AND   dpam_excsm_id = excsm_id 
											--AND   accp_clisba_id = dpam_id
											--AND    accp.accp_accpm_prop_cd = 'SMS_FLAG'
											AND    isnull(dpam.dpam_batch_no,0) = 0
											--AND    accp.accp_value = '1'-- and 1 = 0
											AND   excsm_exch_cd = @pa_exch
											 and    DPAM_DPM_ID = @L_DPM_ID     
											--AND   (CITRUS_USR.fn_acct_conc_value(DPAM_ID,'MOBILE1')<>'' OR CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'MOBILE1')<>'')
											AND    CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
											and citrus_usr.FN_UCC_ACCP(DPAM_ID, 'PMS_BO_NAME','') <> ''

											




                                         
									--                  
      END                  
      ELSE IF @pa_crn_no <> ''                  
      BEGIN                  
      --          
       
                       
                           
        insert into @line2( ln_no                  
                           ,crn_no                  
                           ,acct_no   
                           ,dpam_id               
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
						   , HLDR_UID                
                           ,it_crl                               
                           ,cust_email                           
        ,bo_usr_txt1                          
                           ,bo_usr_txt2                          
                           ,bo_user_fld3                         
                           ,bo_user_fld4                 
                           ,bo_user_fld5                  
                           ,sign_bo                  
                           ,sign_fl_flag,Borequestdt
						   
						   ,cust_adr_cntry_cd  
							,cust_state_code 
							,city_seq_no 
							,Smart 
							,Pri_mob_ISD 
							,Sec_mobile 
							,Sec_mob_ISD
							,pan_vf
							,Bo_Acop_src 
							,pan_vf2
							,pan_vf3

																					,DtBsdaOptOut
							,Rbsdam 
							,DtIntdem 
							,DrvLiccd 
							,PassOCI 
							,Fnoms 
						   )                  
                           SELECT distinct '02'                  
                                , clim_crn_no                  
                                , dpam_acct_no   
                                ,dpam_id               
                               -- , citrus_usr.Fn_FormatStr(left(subcm_cd,2),4,0,'L','0')                  
                               ,case when subcm_cd in ('022545') then citrus_usr.Fn_FormatStr(left('40',2),4,0,'L','0')    
									 when subcm_cd in ('392144') then citrus_usr.Fn_FormatStr(left('39',2),4,0,'L','0') 
									 when subcm_cd in ('413046') then citrus_usr.Fn_FormatStr(left('41',2),4,0,'L','0') else citrus_usr.Fn_FormatStr(left(subcm_cd,2),4,0,'L','0')    end
                                , case when dpam_clicm_cd in ('21' , '24' , '27') then isnull(CLIM_NAME1,'') --CITRUS_USR.inside_trim(LTRIM(RTRIM(DPAM_SBA_NAME)),'1')
                                  else ltrim(rtrim(isnull(CLIM_NAME1,''))) + ' ' + ltrim(rtrim(isnull(CLIM_NAME2,''))) + ' ' + ltrim(rtrim(isnull(CLIM_NAME3,''))) end
                                , case when dpam_clicm_cd in ('21' , '24' , '27') then isnull(CLIM_NAME2,'')--CITRUS_USR.inside_trim(LTRIM(RTRIM(DPAM_SBA_NAME)),'2')
                                  else '' end
                                , case when dpam_clicm_cd in ('21' , '24' , '27') then  case when isnull(CLIM_NAME3,'')='' then '.' else isnull(CLIM_NAME3,'') end--CITRUS_USR.inside_trim(LTRIM(RTRIM(DPAM_SBA_NAME)),'3')
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
                                --, isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'Y'),'')  
                                --, isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'N'),'')   --convert(varchar(17),isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH1'),''))--ph1                  
                                
                                ,case when isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'Y'),'') <> '' then isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'Y'),'')  else isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,3,'Y'),'')  end
                                , case when isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'N'),'') <> '' then isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'N'),'') else isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,3,'N'),'') end  
                                , isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'Y'),'')            --'0'                  
                                , isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'N'),'')  --isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH2'),'')--ph2                  
                                , isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,3,'N'),'')                    
                                , CASE WHEN isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCFAX1'),'') <> '' THEN isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCFAX1'),'') ELSE isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'FAX1'),'') END --fax                               
                                , isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'')  --pan card                  

                                , isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ADHAARFLAG',''),'')  
								,''
                                , CASE WHEN lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCEMAIL1'),'')) <> '' THEN lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCEMAIL1'),'')) ELSE lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'EMAIL1'),'')) END --email                          
                                , ''                  
                                , ''                  
                                , '0000'                  
                                , ''                  
                                --, case when isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'') <> '' then '1' else '0' end + case when isnull(DPHD_SH_PAN_NO,'') <> '' then '1' else '0' end + case when  isnull(DPHD_TH_PAN_NO,'') <> '' then '1' else '0' end + '0'                
                                --add for fiest holder adhar flag -- 
                                , case when isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'') <> '' then '1' else '0' 
									end + case when isnull(DPHD_SH_PAN_NO,'') <> '' then '1' else '0' end 
									+ case when  isnull(DPHD_TH_PAN_NO,'') <> '' then '1' else '0' END 
									+ CASE when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ADHAARFLAG',''),'') <> '' then '2' else '0' end 
				--add for fiest holder adhar flag -- 
                                ,ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_BO',''),'')                  
                                , case when ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_BO',''),'') = '' then 'N' else 'Y'   end --signature file flag                  
								,REPLACE(CONVERT(VARCHAR(10), DPAM_CREATED_DT, 103), '/', '')+LEFT(REPLACE(CONVERT(VARCHAR(12), DPAM_CREATED_DT, 114),':','') ,6) 


							,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('Country',citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),6 )),'')-- addr cntry code
							,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('State',citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),5 )),'') -- state code
							,isnull(citrus_usr.Fn_Toget_CitySeqno(citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),7) ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),4)),'' )-- city seq no
							,case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'SMART_REG',''),'')  ='YES' then 'Y' else ' ' end   
							,CASE WHEN lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'PRIIC'),'')) <> '' THEN  
							convert(varchar(6),citrus_usr.FN_FORMATSTR(convert(varchar(6),lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'PRIIC'),'')) ),6,0,'L','0')) else space(6) END
							,CASE WHEN lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'secmob'),'')) <> '' THEN  lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'secmob'),'')) else space(17) END
							,CASE WHEN lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'secic'),'')) <> '' THEN  
							convert(varchar(6),citrus_usr.FN_FORMATSTR(convert(varchar(6),lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'secic'),'')) ),6,0,'L','0')) else '000000' END
,citrus_usr.fn_get_PanBOBONA_Val(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'PANVC',''),''),'PANVC')
,LTRIM(RTRIM(citrus_usr.fn_get_PanBOBONA_Val(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'BOOS',''),''),'BOOS')))
,case when isnull(DPHD_SH_PAN_NO,'') <> '' then citrus_usr.fn_get_PanBOBONA_Val(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'PANVC2',''),''),'PANVC2') else '0' end
,case when isnull(DPHD_TH_PAN_NO,'') <> '' then  citrus_usr.fn_get_PanBOBONA_Val(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'PANVC3',''),''),'PANVC3') else '0' end

,case when right(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'DtBsdaOptOut',''),''),4) + substring(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'DtBsdaOptOut',''),''),4,2) + SUBSTRING(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'DtBsdaOptOut',''),''),1,2)='19000101' then '' else  right(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'DtBsdaOptOut',''),''),4) + substring(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'DtBsdaOptOut',''),''),4,2) + SUBSTRING(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'DtBsdaOptOut',''),''),1,2) end   --ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'DtBsdaOptOut',''),'')
,ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'Rbsdam',''),'')
,case when right(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'DtIntdem',''),''),4) + substring(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'DtIntdem',''),''),4,2) + SUBSTRING(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'DtIntdem',''),''),1,2) ='19000101' then '' else  right(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'DtIntdem',''),''),4) + substring(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'DtIntdem',''),''),4,2) + SUBSTRING(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'DtIntdem',''),''),1,2) end
,ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'DrvLiccd',''),'')
,ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'PassOCI',''),'')
--ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'Fnoms',''),'')
,ISNULL((select top 1 isnull(NOM_TRXPRINTFLAG,'') from nominee_multi a where a.Nom_dpam_id = dpam.dpam_id) ,'')

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
						   and    dpam.dpam_acct_no       = crn.acct_no
                           AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
                           AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
                           AND    subcm.subcm_CD          = DPAM.DPAM_SUBCM_CD    
                           AND    isnull(dpam.dpam_batch_no,0) = 0   
                           AND    subcm.subcm_deleted_ind = 1                  
                           AND    dpam.dpam_deleted_ind   = 1                  
                           AND    dpam.dpam_excsm_id      = excsm_id  
                            and    DPAM_DPM_ID = @L_DPM_ID                     
                           AND    excsm_exch_cd           = @pa_exch  
                           AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
                           AND    clim.clim_deleted_ind   = 1                  
                           AND    isnull(cliba.cliba_deleted_ind,1) = 1                  
                            AND    isnull(banm.banm_deleted_ind,1)   = 1                  
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
											 , HLDR_UID1                                           
                                             ,it_crl1
                                             
                                             ,sh_mob
,sh_email
,sh_mob_phone_isd
                                             )                  
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
						, isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ADHAARSECHLDR',''),'')  
						,''
												  ,isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'SH_MOB'),'')
,lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'SH_EMAIL1'),''))
,case when isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'secmic'),'')<>'' then convert(varchar(6),citrus_usr.FN_FORMATSTR(convert(varchar(6),lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'secmic'),'')) ),6,0,'L','0')) else '000000' end --isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'secmic'),'')
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
											  and    dpam.dpam_acct_no       = crn.acct_no                
                                              AND    isnull(dpam.dpam_batch_no,0) = 0   
                                              AND    excsm_exch_cd           = @pa_exch  
                                              AND    dpam.dpam_deleted_ind   = 1                  
                                              AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
                                              AND    clim.clim_deleted_ind   = 1  
                                               and    DPAM_DPM_ID = @L_DPM_ID                     
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
										   ,HLDR_UID2                        
                                           ,it_crl2
                                           
                                           ,th_mob
,th_email
,th_mob_phone_isd
                                           )                   
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
					   , isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ADHAARTHRDHLDR',''),'')   
					   ,''
											   ,isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'th_mob'),'')
,lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'TH_EMAIL1'),''))
,case when isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'THMIC'),'')<>'' then convert(varchar(6),citrus_usr.FN_FORMATSTR(convert(varchar(6),lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'THMIC'),'')) ),6,0,'L','0')) else '000000' end --isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'THMIC'),'')
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
                                            AND    isnull(dpam.dpam_batch_no,0) = 0   
                                            AND    dpam.dpam_excsm_id      = excsm_id                  
                                          AND    excsm_exch_cd           = @pa_exch  
											and    dpam.dpam_acct_no       = crn.acct_no
                                            AND    dpam.dpam_deleted_ind   = 1                  
                                            AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
                                            AND    clim.clim_deleted_ind   = 1                  
                                            AND    isnull(cliba.cliba_deleted_ind,1) = 1                  
                                            AND    isnull(banm.banm_deleted_ind,1)   = 1   
                                            AND    isnull(dphd.dphd_Th_fname,'') <> '' 
                                             and    DPAM_DPM_ID = @L_DPM_ID                         
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
			  --changed by tushar on jan 09 2015
                                          ,EMAIL_STATEMENT_FLAG            
					 ,CAS_MODE   
					 ,MENTAL_DISABILITY                          
					 ,Filler1            
			  --changed by tushar on jan 09 2015
					     ,RGESS_FLAG 
						 ,ANNUAL_REPORT 
						 ,PLEDGE_STANDING
						 ,EMAIL_RTA 
						 ,BSDA_FLAG                                                                
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
                                          ,divnd_bank_ccy
                                          ,Bonafide_flg
                                          )                  
									   SELECT distinct '05'                  
                                       , clim_crn_no                  
                                       , dpam_acct_no                  
                                       , case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'date_of_maturity',''),'00000000')= '' then '00000000' else isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'date_of_maturity',''),'00000000') end  --dt_of_maturity                  
									   , left(dpam_acct_no,10)--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'dp_int_ref_no',''),'')  --dp_int_ref_no                  
                                       , case when dpam_subcm_cd in ('2156','2155','2150','082104','022512','022552','102624','122624','192624','022545','512624','022567','0225105','0225104') then case when isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',''),'') = '' then '00000000' else isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',''),'00000000') end  else case when isnull(convert(varchar(11),clim.clim_dob,103),'00000000') = '01/01/1900' then '00000000' else   isnull(convert(varchar(11),clim.clim_dob,103),'00000000')  end                end
                                       , isnull(clim.clim_gender,'')                  
                                       , CASE WHEN citrus_usr.fn_get_listing('occupation',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'occupation',''),'')) = '' THEN 'O' ELSE citrus_usr.fn_get_listing('occupation',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'occupation',''),'')) END
                                       , ''  
                                       , citrus_usr.fn_get_listing('GEOGRAPHICAL',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'GEOGRAPHICAL',''),''))   --geographical_cd                  
                                       , citrus_usr.fn_get_listing('EDUCATION',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'EDUCATION',''),''))    --edu                  
                                       , ltrim(rtrim(case when dpam_subcm_cd in ('2156','2155','2150','022512','022552','102624','122624','192624','022545','512624','022567','0225105','0225104') then citrus_usr.fn_get_PanBOBONA_Val(isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'ANNUAL_INCOMENI',''),''),'ANNUAL_INCOMENI') else citrus_usr.fn_get_PanBOBONA_Val(isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'ANNUAL_INCOME',''),''),'ANNUAL_INCOME') end ))--isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,''),'')   --ann_income_cd                  --'082104',
                                       , citrus_usr.fn_get_listing('NATIONALITY',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'NATIONALITY',''),''))   --nat_cd                  
                                       , CASE WHEN citrus_usr.fn_ucc_entp(clim.clim_crn_no,'legal_sta','')='' THEN '00' ELSE isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'legal_sta',''),'00') END  --legal_status_cd                  
                                       , CASE WHEN citrus_usr.fn_ucc_entp(clim.clim_crn_no,'bofeetype','')='' THEN '00' ELSE isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'bofeetype',''),'00') END    --bo_fee_type                  
                                       ,  citrus_usr.fn_get_listing('LANGUAGE',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'LANGUAGE',''),''))    --lang_cd                  
                                       , '00'--'' -- category4_cd                  
                                       , '00'--'' -- bank_option5                  
                                       , case when dpam_clicm_cd in ('21' , '24' , '27') then  left(isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'STAFF',''),''),1) else '' end              
                                       , '' -- staff_cd                  
                                       , '' -- usr_txt1     
					--changed by tushar on jan 09 2015
                                        ,case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'Email_st_flag',''),'')  NOT IN ( 'NO','') then 'Y' else 'N' end   --EMAIL_STATEMENT_FLAG            
                                        ,case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'cas_flag',''),'')  =  'CAS NOT REQUIRED' OR  isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'Email_st_flag',''),'')='YES' then 'NO' else 'PH' end   --cas_flag
										,case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'mental_flag',''),'')  NOT IN ( 'NO','') then 'Y' when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'mental_flag',''),'')  IN ( 'NO') then 'N' else '' end  --CAS_MODE   
										,''            
                                         --changed by tushar on jan 09 2015
,  case when isnull(citrus_usr.fn_ucc_accp(dpam_id,'RGESS_FLAG',''),'00')  = 'YES'     then 'Y' else 'N' end
									   --, ''
									   --, ''
									   --, ''
									   , case when isnull(citrus_usr.fn_ucc_accp(dpam_id,'ANNUAL_REPORT',''),'00')  = 'ELECTRONIC'     then '2'
										   when isnull(citrus_usr.fn_ucc_accp(dpam_id,'ANNUAL_REPORT',''),'00')  = 'PHYSICAL'     then '1'
										   when isnull(citrus_usr.fn_ucc_accp(dpam_id,'ANNUAL_REPORT',''),'00')  = 'BOTH'     then '3' else '' end
									   ,case when isnull(citrus_usr.fn_ucc_accp(dpam_id,'PLEDGE_STANDING',''),'00')  = 'YES'     then 'Y' 
											when isnull(citrus_usr.fn_ucc_accp(dpam_id,'PLEDGE_STANDING',''),'00')  = 'NO'     then 'N'else 'N' end
										,case when isnull(citrus_usr.fn_ucc_accp(dpam_id,'RTA_EMAIL',''),'00')  = 'YES'     then 'Y' 
											when isnull(citrus_usr.fn_ucc_accp(dpam_id,'RTA_EMAIL',''),'00')  = 'NO'     then 'N'else 'N' end
									   , case when citrus_usr.fn_acct_entp(dpam_id , 'BSDA') = '1' then 'Y' else '' end                
                                                                                                           
                                       , '' -- usr_txt2                  
                                     , case when isnull(citrus_usr.fn_ucc_accp(dpam_id,'MOO',''),'0000')  = 'Sole Holder'     then '0000' 
									   when isnull(citrus_usr.fn_ucc_accp(dpam_id,'MOO',''),'0000')  = 'Jointly'     then '0001' 
									   when isnull(citrus_usr.fn_ucc_accp(dpam_id,'MOO',''),'0000')  = 'Anyone or Survivor'     then '0002' else '0000' end -- dummy1                   
                                       , case when isnull(citrus_usr.fn_ucc_accp(dpam_id,'CP',''),'0000')  = 'FIRST HOLDER'     then '0001' 
									   when isnull(citrus_usr.fn_ucc_accp(dpam_id,'CP',''),'0000')  = 'ALL HOLDERS'     then '0002' 
									   else '0001' end -- dummy2              
                                       , '0000'--'' -- dummy3                  
                                       , '00'--'' -- secur_acc_cd                  
                                       , left(enttm_cd,2)  
                                       , case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'bosettlflg',''),'')  <>  '' then 'Y' else 'N' end --bo_settm_plan_fg                  
                                       --, isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'voice_mail',''),'')  --voice_mail                               
										, case when banm_rtgs_cd in ('0','000000000')  then space(15) 
                                              when  banm_rtgs_cd not in ('0','000000000')   then convert(char(15),banm_rtgs_cd)
                                              else space(15) end voice_mail      
                                       , CASE WHEN isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'rbi_ref_no',''),'') = '' THEN isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'rbi_ref_no',''),'') ELSE isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'rbi_ref_no',''),'') END  --rbi_ref_no                               
                                       , CASE WHEN isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'rbi_ref_no',''),'') = '' THEN isnull(citrus_usr.fn_ucc_accpD(dpam.dpam_id,'rbi_ref_no','rbi_app_dt',''),'00000000') ELSE  isnull(citrus_usr.fn_ucc_entpD(clim.clim_crn_no,'rbi_ref_no','rbi_app_dt',''),'00000000') END  --rbi_app_dt                               
                                       --, isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'sebi_regn_no',''),'')  --sebi_reg_no
                                       , isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'sebi_reg_no',''),'')  --sebi_reg_no                              
                                      -- , citrus_usr.fn_get_listing('TAX_DEDUCTION',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'TAX_DEDUCTION',''),''))  --benef_tax_ded_sta  
                                        , case when ISNULL(citrus_usr.fn_get_listing('TAX_DEDUCTION',isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'TAX_DEDUCTION',''),'')),'')='' then '00' else citrus_usr.fn_get_listing('TAX_DEDUCTION',isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'TAX_DEDUCTION',''),'')) end  --benef_tax_ded_sta                                                                    
                                       , case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'SMART_CARD_REQ',''),'') <> '' then 'Y' else '' end                           
                                       , isnull(citrus_usr.fn_ucc_accpd(dpam.dpam_id,'SMART_CARD_REQ','SMART_CARD_NO',''),'')                             
                                       , isnull(citrus_usr.fn_ucc_accpd(dpam.dpam_id,'SMART_CARD_REQ','SMART_CARD_PIN',''),'0000000000')---isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')  --smart_crd_pin                            
                                       , Case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ecs_flg',''),'')=1 then 'Y' when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ecs_flg',''),'')=0 then 'N' else 'N' end  --ecs                                   
                                       , Case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ecs_flg',''),'')=1 THEN '' ELSE  Case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'elec_conf',''),'')=1 then 'Y' when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ecs_flg',''),'')=0 then '' else '' end  END --elec_confirm                             
                                       , citrus_usr.fn_get_listing('dividend_currency',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'dividend_currency',''),''))  --dividend_curr                            
                                       , ''  
                                       --, isnull(right(subcm.subcm_cd,2),'')                            
             --                           , case when dpam_subcm_cd in ('022545') then '40' 
											  --when dpam_subcm_cd in ('392144') then '39' 
											  --when dpam_subcm_cd in ('413046') then '41' else isnull(right(subcm.subcm_cd,2),'') end  
                                       --,  case when subcm.subcm_cd <> '292624'  then isnull(citrus_usr.get_ccm_id(isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')),'000000') else '000019' end---isnull(citrus_usr.get_ccm_id(isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')),'000000')                
                                       , citrus_usr.FN_FORMATSTR(convert(varchar(4),right(subcm_cd,2)),4,0,'L','0') --isnull(right(subcm.subcm_cd,2),'')                            
                                       , case when subcm.subcm_cd <> '292624'  then isnull(citrus_usr.get_ccm_id(isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')),'0000') else '0019' end                 
                                       
                                       , isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBP_ID',''),'')                   
                                        , case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')  = 'NSE'     then '12'             
											when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')  = 'BSE' then '11'
											when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')  = 'MCX' then '23'
											when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')  = 'NCDEX' then '22'
											when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')  = 'DSE' then '14'
											when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')  = 'CSE' then '13'
											when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')  = 'BSE\CISA' then '20'
											when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'CMBPEXCH',''),'00')  = 'MCX-SX' then '29'
											else '00' end          
                                       , 'Y'--CASE WHEN isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'confirmation',''),'')='1' THEN 'Y' WHEN isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'confirmation',''),'')='0' THEN 'N'  ELSE 'N' END   --confir_waived                  
                                       , isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'TRADINGID_NO',''),'')  --'' --trading id                  
                                       , citrus_usr.fn_get_listing('bostmntcycle',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'bostmntcycle',''),''))  --bo_statm_cycle_cd                  
                                        , case when banm_micr in ('0','000000000')  then space(12) 
                                              when  banm_micr not in ('0','000000000')   then space(12) 
                                              else space(12) end                     
                                       , ''--case when cliba_ac_type='SAVINGS' THEN '10' WHEN  cliba_ac_type='CURRENT' THEN '11' WHEN cliba_ac_type='OTHERS' THEN '13' ELSE '13' END                 --convert(char(12),banm_branch)                  
                                       , ''--isnull(cliba_ac_no ,'')                 
                                       , '000000'--citrus_usr.fn_get_listing('BANKCCY',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'BANKCCY',''),''))               
                                       , case when cliba_ac_type='SAVINGS' THEN '10' WHEN  cliba_ac_type='CURRENT' THEN '11' WHEN cliba_ac_type='OTHERS' THEN '13' WHEN cliba_ac_type='CASHCREDIT' THEN '13' ELSE '' END --''--case when cliba_ac_type='SAVINGS' THEN '10' WHEN  cliba_ac_type='CURRENT' THEN '11' WHEN cliba_ac_type='OTHERS' THEN '13' ELSE '13' END                 --convert(char(12),banm_branch)                                  
                                       , case when banm_micr in ('0','000000000')  then space(12) 
                                              when  banm_micr not in ('0','000000000')   then banm_micr
                                              else space(12) end                    
                                       , isnull(cliba_ac_no,'')                  
                                       , citrus_usr.fn_get_listing('BANKCCY',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'BANKCCY',''),''))--''                                 
                                       , ltrim(rtrim(citrus_usr.fn_get_PanBOBONA_Val(ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'BONAFIDE',''),''),'BONAFIDE')))
                                          FROM   dp_acct_mstr              dpam                  
                                                 left outer join   
                                                 dp_holder_dtls            dphd                 on dpam.dpam_id            = dphd.dphd_dpam_id                      
                                                 left outer join                       
                                                 client_bank_accts         cliba                on dpam.dpam_id            = cliba.cliba_clisba_id     AND isnull(cliba_flg,'0') IN ('1','3')
                                                 left outer join           
                                                bank_mstr                 banm                 on  convert(int,cliba.cliba_banm_id)     = convert(int,banm.banm_id)     AND    isnull(banm.banm_deleted_ind,1) = 1                   
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
											and    dpam.dpam_acct_no       = crn.acct_no               
                                          AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
                                          AND    dpam.dpam_subcm_cd      = subcm.subcm_cd                  
                                          AND    isnull(dpam.dpam_batch_no,0) = 0   
                                          AND    dpam.dpam_excsm_id      = excsm_id                  
                                          AND    excsm_exch_cd           = @pa_exch  
                                          AND    dpam.dpam_deleted_ind   = 1                  
                                          AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
                                          AND    clim.clim_deleted_ind   = 1                  
                                          AND    isnull(cliba.cliba_deleted_ind,1) = 1                  
                                          AND    isnull(banm.banm_deleted_ind,1)   = 1
                                           and    DPAM_DPM_ID = @L_DPM_ID             
                                          AND    CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
                          
                          
                          
                          
                       insert into @line6(ln_no                   
                                         ,crn_no                  
                                         ,acct_no                  
                                         ,poa_id                                    
                                         ,setup_date                                
                                         ,poa_to_opr_ac                             
                                         ,gpa_bpa_fl                                
                                         ,eff_frm_dt                                
                                         ,eff_to_dt                                 
                                         ,usr_fld1                                  
                                         ,usr_fld2                                  
                                         ,ca_charfld                                
                                         ,bo_name3                                
                                         ,bo_mid_name3                               
                                         ,cust_srh_name3                            
                                         ,bo_title3                                 
                                         ,bo_suffix3                                
                                         ,hldr_fth_hsb_nm3                          
                                         ,cus_addr1                                 
                                         ,cust_addr2                                
                                         ,cust_addr3                                
                                         ,cust_city                                 
                                         ,cust__state                               
                                         ,cust_cntry                                
                                         ,cust_zip                                  
                                         ,cust_ph1_ind                              
                                         ,cust_ph1                                  
                                         ,cust_ph2_ind                              
                                         ,cust_ph2                                  
                                         ,cust_addl_ph                              
                                         ,cust_fax                                  
                                         ,pan_no                                    
                                         ,it_crc                                    
                                         ,cust_email                                
                                         ,bo3_usr_txt1                              
                                         ,bo3_usr_txt2                              
                                         ,bo3_usr_fld3                              
                                         ,bo3_usr_fld4                              
                                         ,bo3_usr_fld5                  
                                         ,sign_poa                  
                                         ,sign_file_fl)                  
                                          SELECT distinct '06'                  
                                               ,clim_crn_no                  
                                               ,isnull(dpam.dpam_acct_no,'')                  
                                               --,CITRUS_USR.FN_FORMATSTR(dppd_poa_id,16-len(dppd_poa_id),len(dppd_poa_id),'R',' ') dppd_poa_id --isnull(dppd_poa_id,replicate(0,16))  dppd_poa_id            
                                               ,convert(char(16),dppd_poa_id) dppd_poa_id              
                                               --,convert(char(11),dppd_setup)                  
                                               ,convert(char(11), getdate())
                                               ,case when dppd_poa_type = 'FULL' then 'Y' else 'N' END                  
                                               ,dppd_gpabpa_flg  
                                               ,convert(char(11), getdate()) --as dppd_eff_fr_dt
                                               --,dppd_eff_fr_dt--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')                    
                                               ,dppd_eff_to_dt--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')                    
                                               ,'0000'--''--usr_fld1                                  
                                               ,'0000'--''--usr_fld2                                  
                                               ,case when dppd_gpabpa_flg = 'B' then dppd_poa_type else '' end -- ''--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')                    
                                               ,''--isnull(dppd.dppd_fname,'') 
                                               ,''--isnull(dppd.dppd_mname,'')                         
                                               ,''--convert(char(20),isnull(dppd.dppd_lname,''))     
                                               ,''--bo_title3                                 
                                               ,''--bo_suffix3                                
                                               ,''--isnull(dppd.dppd_fthname,'')                              
                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),1)--adr1                       
                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),2)--adr1                  
                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),3)--adr1                  
                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),4)--adr1                  
                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),5)--adr1                  
                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),6)--adr1                  
                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),7)--adr1                  
                                               ,''--case when isnull(citrus_usr.fn_dp_import_conc(dpam.dpam_id,'POA_OFF_PH1'),'') <> '' then  'O'    ELSE ''                                                     end                
                                               ,''--case when isnull(citrus_usr.fn_dp_import_conc(dpam.dpam_id,'POA_OFF_PH1'),'') <> '' then  isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'POA_OFF_PH1'),'')                                    end                                   
                                               ,''--cust_ph2_ind                              
                                               ,''  
                                               ,''  
                                               ,''  
                                               ,''--dppd_pan_no  
                                               ,''  
                                               ,''  
                                               ,isnull(dppd_master_id,'0')
                                               ,''--bo3_usr_txt2                              
                                               ,CASE WHEN dppd_hld = '1st holder' THEN  '0001'
																																																WHEN dppd_hld = '2nd holder' THEN  '0002'
																																																WHEN dppd_hld = '3rd holder' THEN  '0003' ELSE '0000' end                            
                                               ,'0000'--''--bo3_usr_fld4                              
                                               ,'0000'--''--bo3_usr_fld5                               
                                               ,ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_POA',''),'')                  
                                              ,case when ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_POA',''),'') = '' then 'N' else 'Y'   end  --signature file flag           
                                        FROM   dp_acct_mstr              dpam          
                                               left outer join                  
                                               dp_poa_dtls                   dppd                  
                                               on dpam.dpam_id             = dppd.dppd_dpam_id                  
                                             , client_mstr               clim                  
                                             , @crn                       crn  
                                             , entity_type_mstr          enttm                  
                                             , client_ctgry_mstr         clicm                  
                                               left outer join                  
                                               sub_ctgry_mstr            subcm                   
                                                on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
                                                , exch_seg_mstr   
                                         WHERE  dpam.dpam_crn_no        = clim.clim_crn_no         
                                         AND    crn.crn                 = clim.clim_crn_no                  
                                         AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
                                         AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
                                         AND    isnull(dpam.dpam_batch_no,0) = 0   
                                         AND    dpam.dpam_excsm_id      = excsm_id  
                						and    dpam.dpam_acct_no       = crn.acct_no 
                                         AND    excsm_exch_cd           = @pa_exch  
                                         AND    dpam.dpam_deleted_ind   = 1                  
                                         AND    clim.clim_deleted_ind   = 1     
                                         AND    dppd.dppd_deleted_ind   =1 
                                         AND    isnull(dppd.dppd_fname,'')  <> ''
                                          and    DPAM_DPM_ID = @L_DPM_ID     
                                         AND    CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
                                         AND    getdate() between dppd_eff_fr_dt and  CASE WHEN isnull(dppd_eff_to_dt,'01/01/2100') ='01/01/1900' THEN '01/01/2100' ELSE isnull(dppd_eff_to_dt,'01/01/2100') END --isnull(dppd_eff_to_dt,'01/01/2100')   
                                         AND    isnull(dppd_poa_type,'') IN ('FULL','PAYIN ONLY') 
                                         --order by  dppd_eff_fr_dt   
                          
                          
                          
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
                                           ,cust_dob                              
                                           ,cust_fax                                 
                                           ,hldr_in_tax_pan                          
                                           ,it_crl                                   
                                           ,cust_email                               
                                           ,usr_txt1          
                                           ,usr_txt2                                 
                                           ,usr_fld3                                 
                                           ,usr_fld4                                 
                                           ,usr_fld5          
										   ,nom_serial_no
								  ,rel_withbo
								  ,sharepercent
								  ,res_sec_flag      
								  
,ln7_cust_adr_cntry_cd 
,ln7_cust_adr_state_cd 
,ln7_city_seq_no 
,ln7_Pri_mob_ISD 
                  
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
                                             ,replace(convert(varchar(11),cust_dob,103),'/','')                               
                                            ,cust_fax                                 
                                            ,hldr_in_tax_pan                          
                                            ,it_crl                                   
                                            ,cust_email                               
                                            ,usr_txt1                                 
                                            ,usr_txt2                                 
                                            ,CASE WHEN usr_fld3=0 THEN '0000' ELSE usr_fld3 END                                 
                                            ,CASE WHEN usr_fld4=0 THEN '0000' ELSE usr_fld4 END                                  
                                            ,CASE WHEN usr_fld5=0 THEN '0000' ELSE usr_fld5 END    
											,nom_serial_no
								  ,rel_withbo
								  ,sharepercent
								  ,res_sec_flag    ,ln7_cust_adr_cntry_cd,ln7_cust_adr_state_cd,ln7_city_seq_no,ln7_Pri_mob_ISD --- ,'','','',''
                                            FROM fn_cdsl_export_line_7_extract(@pa_crn_no, @pa_from_dt, @pa_to_dt), dp_acct_mstr , EXCH_SEG_MSTR esm  
                                            WHERE dpam_acct_no = acct_no AND dpam_excsm_id =  excsm_id 
                                            AND   excsm_exch_cd = @pa_exch
                                            ORDER BY Purpose_code  DESC
                                           
                                           
                                            INSERT INTO  @line8 (ln_no               
														,crn_no            
																																,acct_no                    
																,purposecode           
																,flag                   
																,mobile                      
																,email                  
																,remarks                  
																,push_flg                      
														)    
										    SELECT distinct '08'                  
														,clim_crn_no                  
														,dpam_sba_no                  
														,'16' --''--Purpose_code                             
														,'S'
														,isnull(CASE WHEN CITRUS_USR.fn_acct_conc_value(DPAM_ID,'MOBSMS')<> '' THEN CITRUS_USR.fn_acct_conc_value(DPAM_ID,'MOBSMS')
																				ELSE CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'MOBSMS') END,'')
														,isnull(CASE WHEN CITRUS_USR.fn_acct_conc_value(DPAM_ID,'SMSEMAIL')<> '' THEN lower(CITRUS_USR.fn_acct_conc_value(DPAM_ID,'SMSEMAIL'))
																				ELSE lower(CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'EMAIL1')) END ,'')
														,''
														,'P'
														FROM   dp_acct_mstr              dpam ,client_mstr  ,account_properties accp,EXCH_SEG_MSTR esm      , @crn                       crn           
															WHERE clim_crn_no = dpam_crn_no 
															AND   crn.crn = clim_crn_no
															and    dpam.dpam_acct_no       = crn.acct_no 
															AND   dpam_excsm_id = excsm_id 
															AND   accp_clisba_id = dpam_id
															AND    accp.accp_accpm_prop_cd = 'SMS_FLAG'
															AND    isnull(dpam.dpam_batch_no,0) = 0
															AND    accp.accp_value = '1'-- and 1 = 0 
															AND   excsm_exch_cd = @pa_exch
															 and    DPAM_DPM_ID = @L_DPM_ID     
															--AND   (CITRUS_USR.fn_acct_conc_value(DPAM_ID,'MOBILE1')<>'' OR CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'MOBILE1')<>'')
														 AND     CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         


														     INSERT INTO  @line9 (ln_no               
														,crn_no            
														,acct_no                    
														,purposecode           
														
														,PSRN_PMSMANAGER
														,PMS_MOBILENO_ISDCD
														,PMS_MOBILE_NUMBER
														,PMS_MIDDLE_NAME
														,PMS_LAST_NAME
														,PMS_BO_NAME                   
												)    
											SELECT distinct '00'                  
											,clim_crn_no                  
											,dpam_sba_no                  
											,'00' --''--Purpose_code                             
											,citrus_usr.FN_UCC_ACCP(DPAM_ID, 'PSRN_PMSMANAGER','')
,citrus_usr.FN_UCC_ACCP(DPAM_ID, 'PMS_MOBILENO_ISDCD','')
,citrus_usr.FN_UCC_ACCP(DPAM_ID, 'PMS_MOBILE_NUMBER','')
,citrus_usr.FN_UCC_ACCP(DPAM_ID, 'PMS_MIDDLE_NAME','')
,citrus_usr.FN_UCC_ACCP(DPAM_ID, 'PMS_LAST_NAME','')
,citrus_usr.FN_UCC_ACCP(DPAM_ID, 'PMS_BO_NAME','')
											FROM   dp_acct_mstr              dpam 
											,client_mstr  ,EXCH_SEG_MSTR esm  
											 , @crn                       crn      
											--,account_properties accp           
											WHERE clim_crn_no = dpam_crn_no 
											AND   dpam_excsm_id = excsm_id 
												AND   crn.crn = clim_crn_no
															and    dpam.dpam_acct_no       = crn.acct_no 
											--AND   accp_clisba_id = dpam_id
											--AND    accp.accp_accpm_prop_cd = 'SMS_FLAG'
											AND    isnull(dpam.dpam_batch_no,0) = 0
											--AND    accp.accp_value = '1'-- and 1 = 0
											AND   excsm_exch_cd = @pa_exch
											 and    DPAM_DPM_ID = @L_DPM_ID     
											--AND   (CITRUS_USR.fn_acct_conc_value(DPAM_ID,'MOBILE1')<>'' OR CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'MOBILE1')<>'')
											AND    CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
											and citrus_usr.FN_UCC_ACCP(DPAM_ID, 'PMS_BO_NAME','') <> '' 


                                            
                                      
      --                  
      END                  
                 
		--select * from @line2
		--select * from @line3
		--select * from @line4
		--select * from @line5
		--select * from @line6
		--select * from @line7
		--select * from @line8

		

				 
 select dpam_sba_no into #tempdata from dp_acct_mstr where dpam_sba_no in (select acct_no from @line2) 
or dpam_sba_no in (select acct_no from @line3) 
or dpam_sba_no in (select acct_no from @line4) 
or dpam_sba_no in (select acct_no from @line5) 
or dpam_sba_no in (select acct_no from @line6) 
or dpam_sba_no in (select acct_no from @line7) 
or dpam_sba_no in (select acct_no from @line8) 
or dpam_sba_no in (select acct_no from @line9) 

select * ,  acct_no boidorder,'1' id  into #tmp_line2 from @line2
select * , acct_no boidorder,'2' id  , (select top 1 Borequestdt from @line2 l2 where l2.acct_no = l7.acct_no  )  Borequestdt into #tmp_line7_PADr from @line7 l7 where Purpose_code ='212'

select * ,  acct_no boidorder,'3' id   , (select top 1 Borequestdt from @line2 l2 where l2.acct_no = l3.acct_no  )  Borequestdt  into #tmp_line3 from @line3 l3
select * ,  acct_no boidorder,'4' id  , (select top 1  Borequestdt from @line2 l2 where l2.acct_no = l4.acct_no  )  Borequestdt  into #tmp_line4 from @line4 l4

select * , acct_no boidorder ,'5' id  , (select top 1  Borequestdt from @line2 l2 where l2.acct_no = l7.acct_no  )  Borequestdt  into #tmp_line7_NOM 
from @line7 l7, nominee_multi , dp_Acct_mstr  where Purpose_code ='206'
and dpam_id = Nom_dpam_id 
and '0'+nom_srno = nom_serial_no 
and acct_no = dpam_acct_no 
and nom_srno in ('1','2','3')

select * , acct_no boidorder ,'6' id  , (select top 1  Borequestdt from @line2 l2 where l2.acct_no = l7.acct_no  )  Borequestdt  into #tmp_line7_NOMgua 
from @line7 l7 ,  nominee_multi , dp_Acct_mstr where Purpose_code ='108'
and dpam_id = Nom_dpam_id 
and '0'+(nom_srno-3)= nom_serial_no 
and acct_no = dpam_acct_no 
and nom_srno in ('5','6','7')


--select * from #tmp_line7_NOM

select * ,  acct_no  boidorder ,'7' id , (select top 1  Borequestdt from @line2 l2 where l2.acct_no = l5.acct_no  )  Borequestdt   into #tmp_line5 from @line5 l5
select pc6.* ,  acct_no  boidorder, mSTRPOAFLG  ,'8' id , (select top 1  Borequestdt from @line2 l2 where l2.acct_no = pc6.acct_no  )  Borequestdt    into #tmp_line6 from @line6 pc6  , dps8_pc1   a  where boid = bo3_usr_txt1
select * ,  acct_no boidorder,'9' id , (select top 1  Borequestdt from @line2 l2 where l2.acct_no = l8.acct_no  )  Borequestdt   into #tmp_line8 from @line8 l8

select * , acct_no boidorder,'10' id  , (select top 1 Borequestdt from @line2 l2 where l2.acct_no = l7.acct_no  )  Borequestdt into #tmp_line7_AS from @line7 l7 where Purpose_code ='18'
select * ,  acct_no boidorder,'11' id  , (select top 1 Borequestdt from @line2 l2 where l2.acct_no = L9.acct_no  )  Borequestdt  into #tmp_line9 from @line9 L9

--select * from #tmp_line7_NOM

--select clic_mod_dpam_sba_no, MAX(clic_mod_created_dt) maxdt from client_list_modified where clic_mod_created_dt between @pa_from_dt and @pa_to_dt and clic_mod_batch_no is null 
--group by 

select  boidorder , DENSE_RANK () over(order by boidorder asc) orderId    into #tmp_order from (
select boidorder from #tmp_line2
union
select boidorder from #tmp_line3
union
select boidorder from #tmp_line4
union
select boidorder from #tmp_line7_PADr
union 
select boidorder  from #tmp_line5
union 
select boidorder from #tmp_line6
union 

select boidorder from #tmp_line7_NOM 
union 
select boidorder from #tmp_line7_NOM gua
union 
select boidorder from #tmp_line7_AS
UNION select boidorder FROM  #tmp_line9
) a 




--select  * from #tmp_line2
--select  * from #tmp_line5
--select * from @line7
--select * from #tmp_line7_NOMgua 

--return 

declare @l_dpmdpid varchar(100)
 
select @l_dpmdpid = dpm_dpid from dp_mstr where default_dp= dpm_excsm_id and dpm_deleted_ind =1 


select *,row_number() over (partition by orderId order by orderId, id  )  subid into #tempdata_for_sub from (

select  substring(@l_dpmdpid,4,5)  + ',0,,'+@pa_loginname+','+''+','+substring(a.Borequestdt,5,4)+'-'+substring(a.Borequestdt,3,2)+'-'+substring(a.Borequestdt,1,2) +','+substring(a.Borequestdt,5,4)+'-'+substring(a.Borequestdt,3,2)+'-'+substring(a.Borequestdt,1,2)+'T00:00:00'+','+CONVERT(varchar(100),ord.orderId) +','+'@@@@@'+''+','+'BOSET'+','+'' +','+case when product_number <> '' then Citrus_usr.fn_get_standard_value_harm('PrdNb',case when isnumeric(product_number)=1 then convert(varchar(100),convert(numeric,product_number) ) else '' end ) else '' end +''+','+case when bo_sub_status  <> '' then Citrus_usr.fn_get_standard_value_harm('BnfcrySubTp',case when isnumeric(bo_sub_status)=1 then convert(varchar(100),convert(numeric,bo_sub_status) ) else '' end ) else '' end+''+''+','+'FH'+','+ltrim(rtrim(isnull(bo_title,'')))+','+case when a.bo_name <> '' then ltrim(rtrim(isnull(a.bo_name,''))) else '' end +','+case when a.bo_middle_name  <> '' then ltrim(rtrim(isnull(bo_middle_name,''))) else '' end +','+case when a.cust_search_name  <> '' then ltrim(rtrim(isnull(a.cust_search_name,''))) else '' end +','+ltrim(rtrim(isnull(bo_suffix,'')))+',,'+ltrim(rtrim(isnull(hldr_fth_hsd_nm,'')))+','+case when dob <> '00000000' then convert(varchar(10),convert(datetime,dob,103),126) else '' end +''+','+Citrus_usr.fn_get_standard_value_harm('Gndr',b.sex_cd)+','+ltrim(rtrim(isnull(hldr_pan,'')))+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg',pan_vf)+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+ltrim(rtrim(isnull(hldr_UID,'')))+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty',ltrim(rtrim(smart)))+''+','+case when isnumeric(Pri_mob_ISD)=1 then Citrus_usr.fn_get_standard_value_harm('PrmryISDCd',convert(varchar(100),convert(numeric,Pri_mob_ISD))) else '' end +','+ltrim(rtrim(ISNULL(cust_ph1,'')))+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+case when isnumeric(Pri_mob_ISD)=1 then Citrus_usr.fn_get_standard_value_harm('ScndryISDCd',convert(varchar(100),convert(numeric,sec_mob_isd))) else '' end +','+ltrim(rtrim(isnull(sec_mobile,'')))+','+ltrim(rtrim(ISNULL(cust_email,'')))+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+CASE WHEN ISNUMERIC(dummy1 )= 1  THEN Citrus_usr.fn_get_standard_value_harm('MdOfOpr',isnull(CONVERT(NUMERIC,dummy1),'')) ELSE '' END +','+ltrim(rtrim(isnull(clr_member_id,'')))+','+Citrus_usr.fn_get_standard_value_harm('StgInstr',isnull(confir_waived,''))+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg',ann_income_cd )+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+','+ltrim(rtrim(isnull(CONVERT(varchar(100),voice_mail),'')))+','+ltrim(rtrim(isnull(CONVERT(varchar(100),divnd_bank_code),''))) +','+ltrim(rtrim(isnull(dividend_curr,'')))+','+ltrim(rtrim(isnull(divnd_bank_ccy,'')))+','+case when rbi_app_dt <> '00000000' then convert(varchar(10),convert(datetime,rbi_app_dt,103),126) else '' end +','+ltrim(rtrim(isnull(rbi_ref_no,'')))+','+Citrus_usr.fn_get_standard_value_harm('Mndt',isnull(ecs,''))+','+ltrim(rtrim(isnull(sebi_reg_no,'')))+','+CASE WHEN ISNUMERIC(edu)= 1 THEN Citrus_usr.fn_get_standard_value_harm('EdctnLvl',isnull(CONVERT(NUMERIC,edu),'')) ELSE '' END +''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg',isnull(ANNUAL_REPORT ,''))+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd',isnull(bo_statm_cycle_cd,''))+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf',isnull(elec_confirm,''))+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg',isnull(EMAIL_RTA,''))+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd',isnull(geographical_cd,''))+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg',isnull(stoc_exch,''))+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty',isnull(MENTAL_DISABILITY,''))+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty',ltrim(rtrim(isnull(nat_cd,''))))+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd',ltrim(rtrim(isnull(CAS_MODE ,''))))+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg',ltrim(rtrim(isnull(PLEDGE_STANDING,''))))+''+','+ltrim(rtrim(Citrus_usr.fn_get_standard_value_harm('BkAcctTp',isnull(divnd_brnch_numb,''))))+''+','+CASE WHEN ISNUMERIC(BO_CATG)= 1 THEN Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy',ltrim(rtrim(isnull(CONVERT(NUMERIC,BO_CATG),'')))) ELSE '' END +','+ltrim(rtrim(isnull(divnd_acct_numb,'')))+','+','+case when benef_tax_ded_sta <> '' then Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts',convert(numeric,ltrim(rtrim(isnull(benef_tax_ded_sta,''))))) else '' end +''+','+case when ltrim(rtrim(isnull(clr_corp_id,''))) <> '000000' then Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX') else '' end +''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg',isnull(ltrim(rtrim(bsda_flag)),''))+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn',isnull(occp,''))+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+CASE WHEN ISNUMERIC(dummy2)= 1 THEN Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo',isnull(CONVERT(NUMERIC,dummy2),'')) ELSE '' END +''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc',ltrim(rtrim(isnull(bo_acop_src,''))))+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,'+isnull(a.acct_no,'')+','+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+Case when ltrim(rtrim(isnull(cust_addr1,''))) <> '' then 'CORAD' else '' end +''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+case when isnull(cust_addr1 ,'') <> '' then ',"' else ',' end +ltrim(rtrim(isnull(cust_addr1,''))) + case when isnull(cust_addr1 ,'') <> '' then '","' else ',' end  +ltrim(rtrim(isnull(cust_addr2,'')))+case when isnull(cust_addr1 ,'') <> '' then '","' else ',' end +ltrim(rtrim(isnull(cust_addr3,'')))+ case when isnull(cust_addr1 ,'') <> '' then '",' else ',' end ++','+Citrus_usr.fn_get_standard_value_harm('Ctry',cust_addr_cntry)+','+ltrim(rtrim(isnull(cust_addr_zip ,'')))+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd',cust_addr_state  )+','+ltrim(rtrim(isnull(case when isnull(city_seq_no,'')='' then '00' else isnull(city_seq_no,'') end  ,'') ))+',,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+'#SIG#'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+ Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+''+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+''+','+case when isnull(convert(varchar(10),DtBsdaOptOut,120),'')='1900-01-01' then '' else isnull(convert(varchar(10),DtBsdaOptOut,120),'') end+','+isnull(cust_addr_state,'')+','+isnull(Rbsdam,'')+','+case when convert(varchar(10),isnull(DtIntdem,''),120)='1900-01-01' then '' else convert(varchar(10),isnull(DtIntdem,''),120) end+','+isnull(DrvLiccd,'')+','+isnull(PassOCI,'')+','+isnull(Fnoms,'')+',,,,,'   detailshr ,  ord.orderId, '1' id ,ord.boidorder
from #tmp_order ord , #tmp_line2  a left outer join #tmp_line5 b on  a.acct_no = b.acct_no 
--,  client_list_modified where  a.acct_no = clic_mod_dpam_sba_no and clic_mod_action in ('C ADDRESS','BANK')
where a.boidorder = ord.boidorder
union all
--select  substring(acct_no,4,5)  + ',0,,'+@pa_loginname+','+Citrus_usr.fn_get_standard_value_harm('CntrlSctiesDpstryPtcptRole','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('BOTxnTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrdNb','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcrySubTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Purpse','XXXXXX')+',,,,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PurpCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('Ctry','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AddModDelInd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,Z'
select  distinct substring(@l_dpmdpid,4,5)  + ',0,,'+@pa_loginname+','+''+','+substring(a.Borequestdt,5,4)+'-'+substring(a.Borequestdt,3,2)+'-'+substring(a.Borequestdt,1,2)+','+substring(a.Borequestdt,5,4)+'-'+substring(a.Borequestdt,3,2)+'-'+substring(a.Borequestdt,1,2)+'T00:00:00'+','+CONVERT(varchar(100),ord.orderId) +','+CONVERT(varchar(100),'@@@@@')+''+','+''+','+'' +','+''+''+','+''+''+','+'FH'+',,,,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+'PERAD' +''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',"'+ltrim(rtrim(isnull(cust_addr1,'')))+'","'+ltrim(rtrim(isnull(cust_addr2,'')))+'","'+ltrim(rtrim(isnull(cust_addr3,'')))+'",'++','+Citrus_usr.fn_get_standard_value_harm('Ctry',cust_cntry)+','+ltrim(rtrim(isnull(cust_zip ,'')))+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd',cust_state  )+','+ltrim(rtrim(isnull(case when isnull(ln7_city_seq_no,'')='' then '00' else isnull(ln7_city_seq_no,'') end  ,'') ))+',,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AddModDelInd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+','+','+','+','+','+','+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,', ord.orderId,'2' id ,ord.boidorder
from #tmp_order ord ,  #tmp_line7_PADr a   where  a.boidorder = ord.boidorder
union all
--select  substring(acct_no,4,5)  + ',0,,'+@pa_loginname+','+Citrus_usr.fn_get_standard_value_harm('CntrlSctiesDpstryPtcptRole','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('BOTxnTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrdNb','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcrySubTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Purpse','XXXXXX')+',,,,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PurpCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('Ctry','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AddModDelInd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,Z'
select  distinct substring(@l_dpmdpid,4,5)  + ',0,,'+@pa_loginname+','+''+','+substring(a.Borequestdt,5,4)+'-'+substring(a.Borequestdt,3,2)+'-'+substring(a.Borequestdt,1,2)+','+substring(a.Borequestdt,5,4)+'-'+substring(a.Borequestdt,3,2)+'-'+substring(a.Borequestdt,1,2)+'T00:00:00'+','+CONVERT(varchar(100),ord.orderId) +','+CONVERT(varchar(100),'@@@@@')+''+','+''+','+'' +','+''+''+','+''+''+','+'SH'+','+ltrim(rtrim(isnull(bo_title1,'')))+','+case when a.bo_name1 <> '' then ltrim(rtrim(isnull(a.bo_name1,''))) else '' end +','+case when a.bo_mid_name1  <> '' then ltrim(rtrim(isnull(bo_mid_name1,''))) else '' end +','+case when a.cust_search_name1  <> '' then ltrim(rtrim(isnull(a.cust_search_name1,''))) else '' end+','+ltrim(rtrim(isnull(bo_suffix1,'')))+',,'+ltrim(rtrim(isnull(hldr_fth_hsd_nm1,'')))+','+case when '' <> '' then convert(varchar(10),convert(datetime,'',103),126) else '' end+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+LTRIM(RTRIM(ISNULL(HLDR_PAN1,'')))+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg',aa.pan_vf2)+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+'' +''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',"'+ltrim(rtrim(isnull('','')))+'","'+ltrim(rtrim(isnull('','')))+'","'+ltrim(rtrim(isnull('','')))+'",'++','+Citrus_usr.fn_get_standard_value_harm('Ctry','')+','+ltrim(rtrim(isnull('' ,'')))+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd','')+','+ltrim(rtrim(isnull('' ,'') ))+',,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AddModDelInd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+','+','+','+','+','+','+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,', ord.orderId,'2' id ,ord.boidorder
from #tmp_order ord , #tmp_line2  aa,  #tmp_line3 a   where  a.boidorder = ord.boidorder and aa.acct_no = a.acct_no 
union all
--select  substring(acct_no,4,5)  + ',0,,'+@pa_loginname+','+Citrus_usr.fn_get_standard_value_harm('CntrlSctiesDpstryPtcptRole','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('BOTxnTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrdNb','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcrySubTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Purpse','XXXXXX')+',,,,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PurpCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('Ctry','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AddModDelInd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,Z'
select  distinct substring(@l_dpmdpid,4,5)  + ',0,,'+@pa_loginname+','+''+','+substring(a.Borequestdt,5,4)+'-'+substring(a.Borequestdt,3,2)+'-'+substring(a.Borequestdt,1,2)+','+substring(a.Borequestdt,5,4)+'-'+substring(a.Borequestdt,3,2)+'-'+substring(a.Borequestdt,1,2)+'T00:00:00'+','+CONVERT(varchar(100),ord.orderId) +','+CONVERT(varchar(100),'@@@@@')+''+','+''+','+'' +','+''+''+','+''+''+','+'TH'+','+ltrim(rtrim(isnull(bo_title2,'')))+','+case when a.bo_name2 <> '' then ltrim(rtrim(isnull(a.bo_name2,''))) else '' end +','+case when a.bo_mid_name2  <> '' then ltrim(rtrim(isnull(bo_mid_name2,''))) else '' end +','+case when a.cust_search_name2  <> '' then ltrim(rtrim(isnull(a.cust_search_name2,''))) else '' end+','+ltrim(rtrim(isnull(bo_suffix2,'')))+',,'+ltrim(rtrim(isnull(hldr_fth_hsd_nm2,'')))+','+case when '' <> '' then convert(varchar(10),convert(datetime,'',103),126) else '' end+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+LTRIM(RTRIM(ISNULL(HLDR_PAN2,'')))+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg',aa.pan_vf3)+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+'' +''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',"'+ltrim(rtrim(isnull('','')))+'","'+ltrim(rtrim(isnull('','')))+'","'+ltrim(rtrim(isnull('','')))+'",'++','+Citrus_usr.fn_get_standard_value_harm('Ctry','')+','+ltrim(rtrim(isnull('' ,'')))+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd','')+','+ltrim(rtrim(isnull('' ,'') ))+',,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AddModDelInd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+','+','+','+','+','+','+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,', ord.orderId,'2' id ,ord.boidorder
from #tmp_order ord, #tmp_line2  aa ,  #tmp_line4 a   where  a.boidorder = ord.boidorder and aa.acct_no = a.acct_no 
union all
--select  substring(acct_no,4,5)  + ',0,,'+@pa_loginname+','+Citrus_usr.fn_get_standard_value_harm('CntrlSctiesDpstryPtcptRole','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('BOTxnTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrdNb','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcrySubTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Purpse','XXXXXX')+',,,,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PurpCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('Ctry','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AddModDelInd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,Z'
select  distinct substring(@l_dpmdpid,4,5)  + ',0,,'+@pa_loginname+','+''+','+substring(a.Borequestdt,5,4)+'-'+substring(a.Borequestdt,3,2)+'-'+substring(a.Borequestdt,1,2)+','+substring(a.Borequestdt,5,4)+'-'+substring(a.Borequestdt,3,2)+'-'+substring(a.Borequestdt,1,2)+'T00:00:00'+','+CONVERT(varchar(100),ord.orderId) +','+CONVERT(varchar(100),'@@@@@')+''+','+''+','+'' +','+''+''+','+''+''+','+'NM'+',,'+ltrim(rtrim(isnull(bo_name,'')))+','+ltrim(rtrim(isnull(bo_middle_nm,'')))+','+ltrim(rtrim(isnull(cust_search_name,'')))+',,,'+ltrim(rtrim(isnull(hldr_fth_hs_name,'')))+','+case when cust_dob  ='01011900' then '' else right(cust_dob,4)+'-'+substring(cust_dob,3,2)+'-'+left(cust_dob,2)   end +','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+ltrim(rtrim(isnull(hldr_in_tax_pan,'')))+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+isnull(NOM_ISDCODE,'') +','+isnull(nom_phone1,'')++','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+isnull(nom_email,'')+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+ CASE 
        WHEN DATEDIFF(YEAR, CONVERT(DATE, STUFF(STUFF(cust_dob, 5, 0, '-'), 3, 0, '-'),103), GETDATE()) - 
             CASE WHEN FORMAT(CONVERT(DATE, STUFF(STUFF(cust_dob, 5, 0, '-'), 3, 0, '-'),103), 'MMDD') > FORMAT(GETDATE(), 'MMDD') THEN 1 ELSE 0 END < 18
        THEN 'YES' -- MINOR
        ELSE 'NO'  -- NOT MINOR
    END 
	
	+','+case when nom_serial_no <> '' then convert(varchar(10),convert(numeric,nom_serial_no)) else '' end +','+case when sharepercent <> '' then convert(varchar(10),convert(numeric(5,2),sharepercent/100)) else '' end +','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg',res_sec_flag)+''+','+case when rel_withbo <>'' then Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr',isnull(convert(numeric,rel_withbo),'')) else '' end +',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+'NOMAD' +''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',"'+ltrim(rtrim(isnull(cust_addr1,'')))+'","'+ltrim(rtrim(isnull(cust_addr2,'')))+'","'+ltrim(rtrim(isnull(cust_addr3,'')))+'",'++','+Citrus_usr.fn_get_standard_value_harm('Ctry',cust_cntry)+','+ltrim(rtrim(isnull(cust_zip ,'')))+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd',cust_state  )+','+ltrim(rtrim(isnull(case when isnull(ln7_city_seq_no,'')='' then '00' else isnull(ln7_city_seq_no,'') end  ,'') ))+',,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+''+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+','+','+','+','+isnull(NOM_DRIVINGLIC,'')+','+isnull(NOM_PASSUIC,'')+','+isnull('','')+ ','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,', ord.orderId,'2' id,ord.boidorder
from #tmp_order ord ,  #tmp_line7_NOM a   where  a.boidorder = ord.boidorder
union all
--select  substring(acct_no,4,5)  + ',0,,'+@pa_loginname+','+Citrus_usr.fn_get_standard_value_harm('CntrlSctiesDpstryPtcptRole','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('BOTxnTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrdNb','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcrySubTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Purpse','XXXXXX')+',,,,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PurpCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('Ctry','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AddModDelInd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,Z'
select  distinct substring(@l_dpmdpid,4,5)  + ',0,,'+@pa_loginname+','+''+','+substring(a.Borequestdt,5,4)+'-'+substring(a.Borequestdt,3,2)+'-'+substring(a.Borequestdt,1,2)+','+substring(a.Borequestdt,5,4)+'-'+substring(a.Borequestdt,3,2)+'-'+substring(a.Borequestdt,1,2)+'T00:00:00'+','+CONVERT(varchar(100),ord.orderId) +','+CONVERT(varchar(100),'@@@@@')+''+','+''+','+'' +','+''+''+','+''+''+','+'NMG'+',,'+ltrim(rtrim(isnull(bo_name,'')))+','+ltrim(rtrim(isnull(bo_middle_nm,'')))+','+ltrim(rtrim(isnull(cust_search_name,'')))+',,,'+ltrim(rtrim(isnull(hldr_fth_hs_name,'')))+','+case when cust_dob  ='01011900' then '' else  right(cust_dob,4)+'-'+substring(cust_dob,3,2)+'-'+left(cust_dob,2)  end +','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+ltrim(rtrim(isnull(hldr_in_tax_pan,'')))+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+isnull(NOM_ISDCODE,'') +','+isnull(nom_phone1,'')+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+isnull(nom_email,'')+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+','+case when nom_serial_no <> '' then convert(varchar(10),convert(numeric,nom_serial_no)) else '' end +','+case when sharepercent <> '' then convert(varchar(10),convert(numeric(5,2),sharepercent/100)) else '' end +','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg',res_sec_flag)+''+','+case when rel_withbo <>'' then Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr',isnull(convert(numeric,rel_withbo),'')) else '' end +',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+ case when  nom_serial_no ='01' then  'MNGAD' when  nom_serial_no ='02' then  'SMNGA' when  nom_serial_no ='03' then  'TMNGA' else '' end  +''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',"'+ltrim(rtrim(isnull(cust_addr1,'')))+'","'+ltrim(rtrim(isnull(cust_addr2,'')))+'","'+ltrim(rtrim(isnull(cust_addr3,'')))+'",'++','+Citrus_usr.fn_get_standard_value_harm('Ctry',cust_cntry)+','+ltrim(rtrim(isnull(cust_zip ,'')))+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd',cust_state  )+','+ltrim(rtrim(isnull(case when isnull(ln7_city_seq_no,'')='' then '00' else isnull(ln7_city_seq_no,'') end  ,'') ))+',,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+''+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+','+','+','+','+isnull(NOM_DRIVINGLIC,'')+','+isnull(NOM_PASSUIC,'')+','+isnull('','')++  +','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,', ord.orderId,'2' id,ord.boidorder
from #tmp_order ord ,  #tmp_line7_NOMgua a   where  a.boidorder = ord.boidorder
union all
--select  substring(acct_no,4,5)  + ',0,,'+@pa_loginname+','+Citrus_usr.fn_get_standard_value_harm('CntrlSctiesDpstryPtcptRole','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('BOTxnTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrdNb','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcrySubTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Purpse','XXXXXX')+',,,,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PurpCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('Ctry','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AddModDelInd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,Z'
select  distinct substring(@l_dpmdpid,4,5)  + ',0,,'+@pa_loginname+','+''+','+substring(a.Borequestdt,5,4)+'-'+substring(a.Borequestdt,3,2)+'-'+substring(a.Borequestdt,1,2)+','+convert(varchar(10),setup_date,126)+'T00:00:00'+','+CONVERT(varchar(100),ord.orderId) +','+CONVERT(varchar(100),'@@@@@')+''+','+''+','+'' +','+''+''+','+''+''+','+'POALB'+',,,,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+''+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',0,'+ltrim(rtrim(convert(varchar(100),poa_id)))+','+'Y'+','+''  +','+convert(varchar(10),setup_date,126)+','+convert(varchar(10),eff_frm_dt,126)+','+case when  convert(varchar(10),eff_to_dt,126) ='1900-01-01' then '' else convert(varchar(10),eff_to_dt,126) end +','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg',gpa_bpa_fl)+','+  ltrim(rtrim(isnull(bo3_usr_txt1,'')))+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd',isnull(bo3_usr_fld3,''))+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+''+''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',,,,'++','+Citrus_usr.fn_get_standard_value_harm('Ctry','')+','+ltrim(rtrim(isnull('' ,'')))+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd',''  )+','+ltrim(rtrim(isnull('' ,'') ))+',,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+''+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,0,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+','+','+','+','+','+','+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,', ord.orderId,'3' id ,ord.boidorder
from #tmp_order ord ,  #tmp_line6 a   where  a.boidorder = ord.boidorder

union all
--select  substring(acct_no,4,5)  + ',0,,'+@pa_loginname+','+Citrus_usr.fn_get_standard_value_harm('CntrlSctiesDpstryPtcptRole','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('BOTxnTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrdNb','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcrySubTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Purpse','XXXXXX')+',,,,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PurpCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('Ctry','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AddModDelInd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,Z'
select  distinct substring(@l_dpmdpid,4,5)  + ',0,,'+@pa_loginname+','+''+','+substring(a.Borequestdt,5,4)+'-'+substring(a.Borequestdt,3,2)+'-'+substring(a.Borequestdt,1,2)+','+substring(a.Borequestdt,5,4)+'-'+substring(a.Borequestdt,3,2)+'-'+substring(a.Borequestdt,1,2)+'T00:00:00'+','+CONVERT(varchar(100),ord.orderId) +','+CONVERT(varchar(100),'@@@@@')+''+','+''+','+'' +','+''+''+','+''+''+','+'AS'+','+ltrim(rtrim(isnull('','')))+','+case when a.bo_name <> '' then ltrim(rtrim(isnull(a.bo_name,''))) else '' end +','+case when ''  <> '' then ltrim(rtrim(isnull('',''))) else '' end +','+case when ''  <> '' then ltrim(rtrim(isnull('',''))) else '' end+','+ltrim(rtrim(isnull('','')))+',,'+ltrim(rtrim(isnull('','')))+','+case when '' <> '' then convert(varchar(10),convert(datetime,'',103),126) else '' end+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+LTRIM(RTRIM(ISNULL('','')))+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+'' +''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',"'+ltrim(rtrim(isnull('','')))+'","'+ltrim(rtrim(isnull('','')))+'","'+ltrim(rtrim(isnull('','')))+'",'++','+Citrus_usr.fn_get_standard_value_harm('Ctry','')+','+ltrim(rtrim(isnull('' ,'')))+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd','')+','+ltrim(rtrim(isnull('' ,'') ))+',,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AddModDelInd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+','+','+','+','+','+','+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,', ord.orderId,'2' id,ord.boidorder
from #tmp_order ord ,  #tmp_line7_AS a   where  a.boidorder = ord.boidorder


UNION ALL 
select  distinct substring(@l_dpmdpid,4,5)  + ',0,,'+@pa_loginname+','+''+','+substring(a.Borequestdt,5,4)+'-'+substring(a.Borequestdt,3,2)+'-'+substring(a.Borequestdt,1,2)+','+substring(a.Borequestdt,5,4)+'-'+substring(a.Borequestdt,3,2)+'-'+substring(a.Borequestdt,1,2)+'T00:00:00'+','+CONVERT(varchar(100),ord.orderId) +','+CONVERT(varchar(100),'@@@@@')+''+','+''+','+'' +','+''+''+','+''+''+','+'PMS'+','+ltrim(rtrim(isnull('','')))+','+case when a.PMS_BO_NAME <> '' then ltrim(rtrim(isnull(a.PMS_BO_NAME,''))) else '' end +','+case when a.PMS_MIDDLE_NAME  <> '' then ltrim(rtrim(isnull(PMS_MIDDLE_NAME,''))) else '' end +','+case when a.PMS_LAST_NAME  <> '' then ltrim(rtrim(isnull(a.PMS_LAST_NAME,''))) else '' end+','+ltrim(rtrim(isnull('','')))+',,'+ltrim(rtrim(isnull('','')))+','+case when '' <> '' then convert(varchar(10),convert(datetime,'',103),126) else '' end+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+LTRIM(RTRIM(ISNULL('','')))+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd',ISNULL(PMS_MOBILENO_ISDCD,''))+','+ISNULL(PMS_MOBILE_NUMBER,'') +','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+ISNULL(PSRN_PMSMANAGER,'') +','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+'' +''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',"'+ltrim(rtrim(isnull('','')))+'","'+ltrim(rtrim(isnull('','')))+'","'+ltrim(rtrim(isnull('','')))+'",'++','+Citrus_usr.fn_get_standard_value_harm('Ctry','')+','+ltrim(rtrim(isnull('' ,'')))+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd','')+','+ltrim(rtrim(isnull('' ,'') ))+',,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AddModDelInd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,,', ord.orderId,'2' id ,ord.boidorder
from #tmp_order ord , #tmp_line2  aa,  #tmp_line9 a   where  a.boidorder = ord.boidorder and aa.acct_no = a.acct_no 
 


) c


				  
 select detailshr,DOCPATH from  ( select 
 'CntrlSctiesDpstryPtcpt,BrnchId,BtchId,SndrId,CntrlSctiesDpstryPtcptRole,SndrDt,RcvDt,RcrdNb,RcdSRNumber,BOTxnTyp,ClntId,PrdNb,BnfcrySubTp,Purpse,Titl,FrstNm,MddlNm,LastNm,FSfx,BnfcryShrtNm,ScndHldrNmOfFthr,BirthDt,Gndr,PAN,PANVrfyFlg,PANXmptnCd,UID,AdhrAuthntcnWthUID,RsnForNonUpdtdAdhr,VID,SMSFclty,PrmryISDCd,MobNb,FmlyFlgForMobNbOf,ScndryISDCd,PhneNb,EmailAdr,FmlyFlgForEmailAdr,AltrnEmailAdr,NoNmntnFlg,MdOfOpr,ClrMmbId,StgInstr,GrssAnlIncmRg,NetWrth,NetWrthAsOnDt,LEI,LEIExp,OneTmDclrtnFlgForGSECIDT,INIFSC,MICRCd,DvddCcy,DvddBkCcy,RBIApprvdDt,RBIRefNb,Mndt,SEBIRegNb,EdctnLvl,AnlRptFlg,BnfclOwnrSttlmCyclCd,ElctrncConf,EmailRTADwnldFlg,GeoCd,Xchg,MntlDsblty,Ntlty,CASMd,AncstrlFlg,PldgStgInstrFlg,BkAcctTp,BnfcryAcctCtgy,BnfcryBkAcctNb,BnfcryBkNm,BnfcryTaxDdctnSts,ClrSysId,BSDAFlg,Ocptn,PMSClntAcctFlg,PMSSEBIRegnNb,PostvConf,FrstClntOptnToRcvElctrncStmtFlg,ComToBeSentTo,DelFlg,RsnCdDeltn,DtOfDeath,AccntOpSrc,CustdPmsEmailId,POAOrDDPITp,TradgId,SndrRefNb1,SndrRefNb2,CtdnFlg,DmtrlstnGtwy,NmneeMnrInd,SrlNbr,NmneePctgOfShr,FlgForShrPctgEqlty,RsdlSecFlg,RltshWthBnfclOwnr,NbOfPOAMppng,POAId,POAToOprtAcct,POAOrDDPIId,SetUpDt,FrDt,ToDt,GPABPAFlg,POAMstrID,PoaLnkPurpCd,Rmk,BOUCCLkFlg,CnsntInd,UnqClntId,Brkr,Sgmt,MapUMapFlg,CmAcctToMap,PurpCd,AdrPrefFlg,Adr1,Adr2,Adr3,Adr4,Ctry,PstCd,CtrySubDvsnCd,CitySeqNb,FaxNb,ITCrcl,ProofOfRes,NbOfCoprcnrs,SgntryId,SgntrSz,BnfclOwnrAcctOfPMSFlg,CrspdngBPId,ClngMbrPAN,LclAddPrsnt,BnkAddPrsnt,NmnorGrdnAddPrsnt,MnrNmnGrdnAddPrsnt,FrgnOrCorrAddPrsnt,NbOfAuthSgnt,AuthFlg,CoprcnrOrMmbr,TypMod,SubTypMod,StsChgRsnOrClsrRsnCd,NmChgRsnCd,ExecDt,AddModDelInd,AppKrta,ChgKrtaRsn,DtIntmnBO,PrfDpstryFldFrCAS,CoprcnrsId,ClsrInitBy,RmngBal,CANm,CertNbr,CertXpryDt,NbrPOASgntryReqSign,DpstryInd,AcctTyp,SrcCMBPID,TrgtDPID,TrgtClntID,SrlFlg,UPIId,SignTyp,NBOID,ClntBsdaOptOutDt,CtrySubDvsnNm,RsnBSDAMod,DtIntmnDms,Drl,Psprt,NmStmtFlg,RsnDlayClsReq,Rsvd1,Rsvd2,Rsvd3,Rsvd4' -- ChrInstUnvFlg,CtrySubDvsnNm,Rsvd3,Rsvd4 
 detailshr
 ,convert(numeric(18),0 ) orderId , convert(numeric(18),0 ) subid
 ,'' docpath
union all
select  replace(detailshr,'@@@@@',convert(varchar(100),subid) ) detailshr , orderId, subid 
, citrus_usr.fn_ucc_doc(dpam_id,'SIGN_BO','') DOCPATH
from #tempdata_for_sub ,DP_ACCT_MSTR where DPAM_ACCT_NO=boidorder
) main 
order by orderId, subid        
  
--      select distinct l2.sign_bo                  
--            ,isnull(l6.sign_poa,'')  sign_poa          
--            ,l2.acct_no   Bo_Id
--            ,dpam_id                  
--            ,ISNULL(l2.ln_no,'02')     ln_no2                  
--            ,ISNULL(convert(char(4),l2.product_number)                       
--            +convert(char(100),l2.bo_name)                              
--            +convert(char(20),l2.bo_middle_name)                      
--            +convert(char(20),l2.cust_search_name)                     
--            +convert(char(10),l2.bo_title)                             
--            +convert(char(10),l2.bo_suffix)                            
--            +convert(char(50),l2.hldr_fth_hsd_nm)                      
--            +convert(char(55),l2.cust_addr1)            --30       
--            +convert(char(55),l2.cust_addr2)            --30              
--            +convert(char(55),l2.cust_addr3)            --30  
			
--			+convert(char(2),l2.cust_adr_cntry_cd) 
--			+convert(char(10),l2.cust_addr_zip) 
--			+convert(char(6),l2.cust_state_code) 
--			+convert(char(25),l2.cust_addr_state) 
--            +convert(char(25),l2.cust_addr_city)                  
--            --+convert(char(2),l2.city_seq_no) 
--            +convert(char(2),case when isnull(l2.city_seq_no,'')='' then '00' else isnull(l2.city_seq_no,'') end )       
--			+convert(char(1),l2.Smart)       
--			+convert(char(6),l2.Pri_mob_ISD) 
--			+convert(char(17),l2.cust_ph1)    
--			+convert(char(6),case when l2.Sec_mob_ISD='' then '000000' else Sec_mob_ISD end ) 
--			+convert(char(17),l2.Sec_mobile)         
--			+convert(char(100),'') -- secondary email
--            --+convert(char(25),l2.cust_addr_cntry)    
--            --+convert(char(1),l2.cust_ph1_ind)                     
--            --+convert(char(17),l2.cust_ph1)                     
--            --+convert(char(1),l2.cust_ph2_ind)           
--            --+convert(char(17),l2.cust_ph2)                     
--            --+convert(char(100),l2.cust_addl_ph)                     
--            +convert(char(17),l2.cust_fax)                     
--            +convert(char(10),l2.hldr_pan)                     
--			+convert(char(16),l2.hldr_UID)          --- UID change-- 12           
--			+CASE WHEN l2.hldr_UID <> '' THEN '2' ELSE ' ' END -- uid verif flag
--			+convert(char(1),space(1)) -- poa flag
--			+convert(char(2),space(2))                     
--            +convert(char(15),l2.it_crl)                     
--            +convert(char(100),l2.cust_email)                     --- email 50
--            +convert(char(50),l2.bo_usr_txt1)                     
--            +convert(char(50),l2.bo_usr_txt2)                  
--            +convert(char(4),l2.bo_user_fld3)                     
--            +convert(char(4),l2.bo_user_fld4)                     
--            +CONVERT(char(1),l2.pan_vf) + CONVERT(char(1),l2.pan_vf2) + CONVERT(char(1),l2.pan_vf3) + '0' --convert(char(4),l2.bo_user_fld5)                  
--            +convert(char(1),l2.sign_fl_flag),'') 

--			+convert(char(16),space(16)) 
--			+convert(char(72),space(72)) 
--			+convert(char(1),space(1)) 
--			+convert(char(1),space(1)) 
--			+convert(char(1),l2.Bo_Acop_src)   
--			+convert(char(9),space(9)) 

--			line_two_detail                  
--            ,ISNULL(l3.ln_no,'03') ln_no3                  
--            ,ISNULL(CONVERT(char(100),l3.bo_name1)                                
--            +CONVERT(char(20),l3.bo_mid_name1)                            
--            +CONVERT(char(20),l3.cust_search_name1)                       
--            +CONVERT(char(10),l3.bo_title1)                   
--            +CONVERT(char(10),l3.bo_suffix1)                              
--            +CONVERT(char(50),l3.hldr_fth_hsd_nm1)                        
--            +CONVERT(char(10),l3.hldr_pan1)
--			--add for second holder adhar flag--
--			+CONVERT(char(16),l3.HLDR_UID1) --12
--+CASE WHEN l3.HLDR_UID1 <> '' THEN '2' ELSE ' ' END 
--+CONVERT(char(2),'')
-- --add for second holder adhar flag--
--            +CONVERT(char(15),l3.it_crl1)
--			+CONVERT(char(6),l3.sh_mob_phone_isd)
--            +CONVERT(char(17),l3.sh_mob) -- 10
--			+CONVERT(char(100),l3.sh_email),'') -- 50

--			+convert(char(16),space(16)) 
--			+convert(char(72),space(72)) 
--			+convert(char(1),space(1)) 
--			+convert(char(1),space(1)) 
--			+convert(char(10),space(10)) 

--            line_three_detail                  
--            ,ISNULL(l4.ln_no,'04') ln_no4                  
--            ,ISNULL(CONVERT(char(100),l4.bo_name2)                  
--            +CONVERT(char(20),l4.bo_mid_name2)                  
--            +CONVERT(char(20),l4.cust_search_name2 )                  
--            +CONVERT(char(10),l4.bo_title2         )                  
--            +CONVERT(char(10),l4.bo_suffix2        )                  
--            +CONVERT(char(50),l4.hldr_fth_hsd_nm2  )                  
--            +CONVERT(char(10),l4.hldr_pan2         ) 
--			--add for third holder adhar flag--
--			+CONVERT(char(16),l4.HLDR_UID2         )  -- 12
--+CASE WHEN l4.HLDR_UID2 <> '' THEN '2' ELSE ' ' END 
--+CONVERT(char(2),'')
--	    --add for second holder adhar flag--
--            +CONVERT(char(15),l4.it_crl2) 
--			+CONVERT(char(6),l4.th_mob_phone_isd) 
--            +CONVERT(char(17),l4.th_mob)
--			+CONVERT(char(100),l4.th_email),'')   -- 50

--			+convert(char(16),space(16)) 
--			+convert(char(72),space(72)) 
--			+convert(char(1),space(1)) 
--			+convert(char(1),space(1)) 
--			+convert(char(10),space(10)) 

--            line_four_detail                  
--            ,ISNULL(l5.ln_no,'05') ln_no5                  
--            ,ISNULL(CONVERT(char(8),replace(convert(varchar,l5.dt_of_maturity,103),'/',''))                    
--            +CONVERT(char(10),l5.dp_int_ref_no   )                    
--            +CONVERT(char(8),replace(convert(varchar,l5.dob,103),'/',''))                    
--            +CONVERT(char(1),l5.sex_cd)                    
--            +CONVERT(char(4),l5.occp)                    
--            +CONVERT(char(4),l5.life_style)                    
--            +CONVERT(char(4),l5.geographical_cd )                  
--            +CONVERT(char(4),l5.edu)                    
--            +citrus_usr.Fn_FormatStr(l5.ann_income_cd,4,0,'L','0') --CONVERT(char(4),l5.ann_income_cd)      -- PROB            
--            +CONVERT(char(3),l5.nat_cd)                    
--            +Isnull(CONVERT(char(2),l5.legal_status_cd),'00')                    
--            +Isnull(CONVERT(char(2),l5.bo_fee_type),'00')                    
--            +citrus_usr.Fn_FormatStr(l5.lang_cd,2,0,'L','0')--CONVERT(char(2),l5.lang_cd)                -- PROB
--            +CONVERT(char(2),l5.category4_cd    )                    
--            +CONVERT(char(2),l5.bank_option5    )                    
--            +CONVERT(char(1),l5.staff           )                    
--            +CONVERT(char(10),l5.staff_cd        )                    
--           ----- +CONVERT(char(45),l5.bo2_usr_txt1    )
--	    --changed by tushar on jan 09 2015
--            +CONVERT(char(38),l5.bo2_usr_txt1    )  -- here we need to bifurcate rgess, annual report flag , psi and email rta download , bsda flag - Dec 01 2014                  
--            +CONVERT(char(1),l5.Bonafide_flg    ) --- bonafide
--            +'N'  ---family flag 
--            +CONVERT(char(1),l5.EMAIL_STATEMENT_FLAG    )  -- here we need to bifurcate rgess, annual report flag , psi and email rta download , bsda flag - Dec 01 2014                  
--            +CONVERT(char(2),l5.CAS_MODE    )  -- here we need to bifurcate rgess, annual report flag , psi and email rta download , bsda flag - Dec 01 2014                  
--            +CONVERT(char(1),l5.MENTAL_DISABILITY    )  -- here we need to bifurcate rgess, annual report flag , psi and email rta download , bsda flag - Dec 01 2014                  
--            +CONVERT(char(1),l5.Filler1    )  -- here we need to bifurcate rgess, annual report flag , psi and email rta download , bsda flag - Dec 01 2014                  
----changed by tushar on jan 09 2015      
            
--	        +CONVERT(char(1),isnull(RGESS_FLAG,'')    )  
--            +CONVERT(char(1),ANNUAL_REPORT    )  
--            +CONVERT(char(1),PLEDGE_STANDING   )  
--            +CONVERT(char(1),EMAIL_RTA   )  
--            +CONVERT(char(1),BSDA_FLAG   )                             
--            +CONVERT(char(50),l5.bo2_usr_txt2    )                    
--            +CONVERT(char(4),l5.dummy1          )                  
--            +CONVERT(char(4),l5.dummy2          )                  
--            +CONVERT(char(4),l5.dummy3          )                    
--            +CONVERT(char(2),l5.secur_acc_cd    )                    
--            +CONVERT(char(2),l5.bo_catg         )                    
--            +CONVERT(char(1),l5.bo_settm_plan_fg)                    
--            +CONVERT(char(15),l5.voice_mail      )                    
--            +CONVERT(char(30),l5.rbi_ref_no      )                    
--            +CASE WHEN CONVERT(char(8),replace(convert(varchar,l5.rbi_app_dt,103),'/',''))='' THEN '00000000' ELSE CONVERT(char(8),replace(convert(varchar,l5.rbi_app_dt,103),'/','')) END                     
--            +CONVERT(char(24),l5.sebi_reg_no     )                    
--            +CONVERT(char(2),l5.benef_tax_ded_sta )                  
--            +CONVERT(char(1),l5.smart_crd_req     )                  
--            +CONVERT(char(20),l5.smart_crd_no      )                  
--            +CONVERT(char(10),l5.smart_crd_pin     )                  
--            +CONVERT(char(1),l5.ecs)                  
--            +CONVERT(char(1),l5.elec_confirm)                  
--            +CONVERT(char(6),l5.dividend_curr     )                              
--            +CONVERT(char(8),l5.group_cd          )                  
--            --+CONVERT(char(2),l5.bo_sub_status     )                  
--            --+CONVERT(char(6),l5.clr_corp_id       )                  
--            +CONVERT(char(4),l5.bo_sub_status     )                  
--            +CONVERT(char(4),l5.clr_corp_id       )                  
            
--            +CONVERT(char(8),l5.clr_member_id     )                  
--            +CONVERT(char(2),l5.stoc_exch         )                  
--            +CONVERT(char(1),l5.confir_waived     )     --8             
--            +CONVERT(char(8),l5.trading_id        )     --1             
--            +CONVERT(char(2),l5.bo_statm_cycle_cd )                  
--            +CONVERT(char(12),l5.benf_bank_code    )                  
--            +citrus_usr.Fn_FormatStr(LTRIM(RTRIM(l5.benf_brnch_numb)),12,0,'R','') ---CONVERT(char(12),l5.benf_brnch_numb   )                  
--            +CONVERT(char(20),l5.benf_bank_acno    )                  
--            +CONVERT(char(6),l5.benf_bank_ccy     )                  
--            +CONVERT(char(12),l5.divnd_brnch_numb  )                  
--            +CONVERT(char(12),l5.divnd_bank_code   )                  
--            +CONVERT(char(20),l5.divnd_acct_numb   )                  
--            +CONVERT(char(6),l5.divnd_bank_ccy ),'') line_fifth_detail                  
--            ,ISNULL(l6.ln_no,'06')  ln_no6
--            --, '' line_sixth_detail                 
--            ,ISNULL(CONVERT(char(16),l6.poa_id)                                    
--            +CONVERT(char(8),replace(convert(varchar, l6.setup_date,103),'/','') )                           
--            +CONVERT(char(1),l6.poa_to_opr_ac  )                           
--            +CONVERT(char(1),l6.gpa_bpa_fl     )                           
--            +CONVERT(char(8),replace(convert(varchar,l6.eff_frm_dt,103),'/','')     )                           
--            +case when CONVERT(char(8),replace(convert(varchar,l6.eff_to_dt,103),'/','')       )  = '01011900' then '00000000' else CONVERT(char(8),replace(convert(varchar,l6.eff_to_dt,103),'/','')       ) end                        
--            +CONVERT(char(4),l6.usr_fld1       )                           
--            +CONVERT(char(4),l6.usr_fld2       )                           
--            +CONVERT(char(50),l6.ca_charfld     )                           
--            +CONVERT(char(100),l6.bo_name3       )                         
--            +CONVERT(char(20),l6.bo_mid_name3   )                            
--            +CONVERT(char(20),l6.cust_srh_name3 )                           
--            +CONVERT(char(10),l6.bo_title3 )                                
--            +CONVERT(char(10),l6.bo_suffix3)                                
--            +CONVERT(char(50),l6.hldr_fth_hsb_nm3)                  
--            +CONVERT(char(30),l6.cus_addr1   )                              
--            +CONVERT(char(30),l6.cust_addr2  )                              
--            +CONVERT(char(30),l6.cust_addr3  )                              
--            +CONVERT(char(25),l6.cust_city   )                              
--            +CONVERT(char(25),l6.cust__state )                              
--            +CONVERT(char(25),l6.cust_cntry  )                              
--            +CONVERT(char(10),l6.cust_zip    )                              
--            +CONVERT(char(1),isnull(l6.cust_ph1_ind,'0'))                              
--            +CONVERT(char(17),isnull(l6.cust_ph1,''))                              
--            +CONVERT(char(1),l6.cust_ph2_ind)                              
--            +CONVERT(char(17),l6.cust_ph2    )                              
--            +CONVERT(char(100),l6.cust_addl_ph)                              
--            +CONVERT(char(17),l6.cust_fax    )                              
--            +CONVERT(char(25),l6.pan_no      )                              
--            +CONVERT(char(15),l6.it_crc      )                              
--            +CONVERT(char(50),l6.cust_email  )                        
--            +CONVERT(char(50),l6.bo3_usr_txt1)                              
--            +CONVERT(char(50),l6.bo3_usr_txt2)                              
--            +CONVERT(char(4),l6.bo3_usr_fld3)                              
--            +CONVERT(char(4),l6.bo3_usr_fld4)                              
--            +CONVERT(char(4),l6.bo3_usr_fld5)                              
--            +CONVERT(char(1),l6.sign_file_fl),'') line_sixth_detail                  
--            ,ISNULL(l7.ln_no,'07')  ln_no7                                  
--           ,CASE WHEN L7.Purpose_code='122' THEN 
--           CONVERT(char(2),right(ltrim(rtrim(l7.Purpose_code)),2))   
--           + 'A'                          
--           +CONVERT(char(2),l7.bo_name         )                         
--           +CONVERT(char(2),l7.bo_middle_nm    )                         
--           +CONVERT(char(11),l7.cust_search_name)                         
--           +CONVERT(char(2),l7.bo_title        )                         
--           +CONVERT(char(8),l7.bo_suffix      )                         
--           +CONVERT(char(8),l7.hldr_fth_hs_name)                         
--           ELSE ISNULL(CONVERT(char(2),right(ltrim(rtrim(l7.Purpose_code)),2))                             
--           +CONVERT(char(100),l7.bo_name         )                         
--           +CONVERT(char(20),l7.bo_middle_nm    )                         
--           +CONVERT(char(20),l7.cust_search_name)                         
--           +CONVERT(char(10),l7.bo_title        )                         
--           +CONVERT(char(10),l7.bo_suffix       )                         
--            +CONVERT(char(50),l7.hldr_fth_hs_name)                         
--           +CONVERT(char(55),l7.cust_addr1      )        --30                 
--           +CONVERT(char(55),l7.cust_addr2      )          --30               
--           +CONVERT(char(55),l7.cust_addr3      )             --30
		   
--		   +CONVERT(char(2),l7.ln7_cust_adr_cntry_cd      ) 
--		   +CONVERT(char(10),l7.cust_zip        )    
--		   +CONVERT(char(6),l7.ln7_cust_adr_state_cd        )   
--		   +CONVERT(char(25),l7.cust_state      )    
--           +CONVERT(char(25),l7.cust_city       )                         
--           --+CONVERT(char(2),l7.ln7_city_seq_no       )                                              
--           +CONVERT(char(2),case when isnull(l7.ln7_city_seq_no,'')='' then '00' else isnull(l7.ln7_city_seq_no,'') end        ) 
--           --+CONVERT(char(25),l7.cust_cntry      )                         
                               
--           --+CONVERT(char(1),isnull(l7.cust_ph1_id,'')     )                       
--		   +case when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) <>'212' then CONVERT(char(6),isnull(l7.ln7_Pri_mob_ISD,''))    else '' end                     
--           +case when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) <>'212' then CONVERT(char(17),isnull(l7.cust_ph1,'')        )   else '' end                      
--           --+CONVERT(char(1),l7.cust_ph2_in     )                         
--           --+CONVERT(char(17),l7.cust_ph2        )                         
--           --+CONVERT(char(92),l7.cust_addl_ph    )                            
--           +case when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) <>'212' then CONVERT(char(8),l7.cust_dob    )        else '' end                    
--           +CONVERT(char(17),l7.cust_fax        )                         
--           +case when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) <>'212' then CONVERT(char(10),l7.hldr_in_tax_pan ) ELSE '' END 
--		   +CASE when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) ='212' THEN CONVERT(char(25),l7.hldr_in_tax_pan ) ELSE '' end                  --25
--		   +case when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) <>'212' then CONVERT(char(16),space(16))     else '' end             --uid
--		   +case when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) <>'212' then CONVERT(char(1),space(1))      else '' end            --uid flag
--           +CONVERT(char(15),l7.it_crl          )                         
--           +case when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) <>'212' then CONVERT(char(100),l7.cust_email      )   else '' end                      -- 50
--           +CONVERT(char(50),l7.usr_txt1        )                         
--           +CONVERT(char(50),l7.usr_txt2        )                  
--           +CASE WHEN CONVERT(char(4),l7.usr_fld3) =0 THEN '0000' ELSE CONVERT(char(4),l7.usr_fld3) END                         
--           +CASE WHEN CONVERT(char(4),l7.usr_fld4) =0 THEN '0000' ELSE CONVERT(char(4),l7.usr_fld4) END                         
--           +CASE WHEN CONVERT(char(4),l7.usr_fld5) =0 THEN '0000' ELSE CONVERT(char(4),l7.usr_fld5) END,'') 
		   
--                                   +replace(CASE WHEN CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) ='212' then '@@' else CONVERT(char(2),l7.nom_serial_no) end,'@@','')
--                                   +replace(CASE WHEN CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) ='212' then '@@' else CONVERT(char(2),l7.rel_withbo) end,'@@','')
--                                   +replace(CASE WHEN CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) ='212' then '@@@@@' else CONVERT(char(5),l7.sharepercent) end,'@@@@@','')
--                                   +replace(CASE WHEN CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) ='212' then '@' else CONVERT(char(1),l7.res_sec_flag) end,'@','')
--		   + space(100) END 
--		   line_seventh_detail 
--           ,l7.purpose_code 
--            ,'08' ln_no8
--   --        ,isnull(l8.purposecode,'')           
--			--+CONVERT(char(1),isnull(l8.flag,'') )                  
--			--+CONVERT(char(10),isnull(l8.mobile,''))                      
--			--+CONVERT(char(100),isnull(l8.email ,''))                 
--			--+CONVERT(char(100),isnull(l8.remarks,''))                  
--			--+CONVERT(char(1),isnull(l8.push_flg,'')  )        line_eigth_detail   
--			,'' line_eigth_detail
--			,isnull(citrus_usr.fn_ucc_accp(dpam_id,'INSTABOID',''),'')  INSTABOID    
--			,ISNULL(Borequestdt,'') Borequestdt               
--			,l7.nom_serial_no                   
--     from   @line2 l2  
--             left outer join   
--             @line5 l5       on                  l2.acct_no = l5.acct_no                           
--             left outer join   
--			@line6 l6       on                  l2.acct_no = l6.acct_no 
--			left outer join   
--			@line7 l7       on                  l2.acct_no = l7.acct_no  
--			left outer join   
--            @line8 l8       on                  l2.acct_no = l8.acct_no   and isnull(l8.mobile,'') <> ''
--			left outer join 
--             @line3 l3       on                  l2.acct_no = l3.acct_no                           
--             left outer join   
--             @line4 l4       on                  l2.acct_no = l4.acct_no       
             
--      where  NOT EXISTS (select CDSL_ACCT_ID FROM cdsl_dpm_response where CDSL_ACCT_ID = isnull(l2.acct_no,'0'))                
--      order by l2.acct_no asc, line_sixth_detail asc, l7.purpose_code desc,l7.nom_serial_no asc 
        
     update dpam set dpam_batch_no =  @PA_BATCH_NO from @line2 , dp_acct_mstr dpam where dpam_acct_no = acct_no  
        
        
     select @l_counter = COUNT(acct_no) from @line2 l2   
  
     SELECT @L_DPM_ID = DPM_ID FROM DP_MSTR WHERE DEFAULT_DP = @PA_EXCSM_ID AND DPM_DELETED_IND = 1   
  
  
     IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='C')  
     BEGIN  
     --  
      
       INSERT INTO BATCHNO_CDSL_MSTR                                       
       (    
        BATCHC_DPM_ID,  
        BATCHC_NO,  
        BATCHC_RECORDS ,           
        BATCHC_TRANS_TYPE,   
        BATCHC_FILEGEN_DT,   
        BATCHC_TYPE,  
        BATCHC_STATUS,  
        BATCHC_CREATED_BY,  
        BATCHC_CREATED_DT , BATCHC_LST_UPD_BY,  
        BATCHC_LST_UPD_DT ,  
        BATCHC_DELETED_IND  
       )  
       VALUES  
       (  
        @L_DPM_ID,  
        @PA_BATCH_NO,  
        @l_counter,  
        'ACCOUNT REGISTRATION',  
        CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' ,  
        'C',  
        'P',  
        @PA_LOGINNAME,  
        GETDATE(),   @PA_LOGINNAME,  
        GETDATE(),  
        1  
        )  
       
       
       
       UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
       WHERE BITRM_PARENT_CD ='CDSL_BTCH_CLT_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID and BITRM_BIT_LOCATION = @PA_EXCSM_ID  
         
     --  
     END  
                                         
                                     
       
--CDSL_BTCH_CLT_CURNO  
        
                        
                         
                  
                  
                             
                         
                             
    --                  
    END          
                    
--                  
END                  
                  
                  
                
              
            
          
          
        
      


























































SET ANSI_NULLS ON

GO
