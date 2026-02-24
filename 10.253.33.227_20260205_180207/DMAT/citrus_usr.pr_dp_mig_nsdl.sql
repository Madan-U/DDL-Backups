-- Object: PROCEDURE citrus_usr.pr_dp_mig_nsdl
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--PR_DP_MIG_NSDL '03/02/2008','04/02/2008','','','',''                                                    
--SELECT *  FROM CLIENT_EXPORT_NSDL      46746                                          
--deletE FROM CLIENT_EXPORT_NSDL                            
--SELECT * FROM client_checklist_nsdl                                    
--SELECT * FROM CLIENT_EXPORT_NSDL                                               
--Alter table client_checklist_nsdl                    
--alter column mkrdt varchar(11)                    
--SELECT * FROM client_checklist_nsdl                   
--DELETE FROM  client_checklist_nsdl                  
CREATE PROCEDURE [citrus_usr].[pr_dp_mig_nsdl](@pa_from_dt     varchar(10)                                                    
                              ,@pa_to_dt      varchar(10)                                                    
                              ,@pa_from_crn   varchar(10)                                                    
                              ,@pa_to_crn     varchar(10)                                                    
                              ,@pa_tab        varchar(5)                                                    
                              ,@pa_error      varchar(8000)                                                    
                              )                                                    
AS                                                     
BEGIN--main                                                    
--                                                    
  SET NOCOUNT ON                                                    
  --                                                    
  DECLARE @c_cursor    cursor                                                    
  --                                                    
  CREATE TABLE #entity_properties                                                    
  (code      varchar(25)                                                    
  ,value     varchar(50)                                                    
  )                                                    
                                                      
  --                                                    
  CREATE TABLE #entity_property_dtls                                                    
  (code1     varchar(25)                                                    
  ,code2     varchar(25)                                                    
  ,value     varchar(50)                                                    
  )                                                    
                                                    
  --                                                    
  CREATE TABLE #conc                                                    
  (pk        numeric                                                    
  ,code      varchar(25)                                                    
  ,value     varchar(50)                                                        
  )                                                    
  --                                                    
  CREATE TABLE #addr                                                    
  (pk        numeric                                                    
  ,code      varchar(25)                                                    
  ,add1      varchar(50)                                                    
  ,add2      varchar(50)                                                    
  ,add3      varchar(50)                                                    
  ,add4      varchar(50)                                                    
  ,pin       varchar(7)                                                    
  )                                                    
  --                                                    
  CREATE TABLE #account_properties                                                    
  (code      varchar(25)                                                    
  ,value     varchar(50)                                                    
  )                                                    
  --                                                    
  CREATE TABLE #account_property_dtls                         
  (code1     varchar(25)                                                    
  ,code2     varchar(25)                                             
  ,value     varchar(50)                                                    
  )                                          
  --                                                    
  CREATE TABLE #pk                          
  (pk        numeric)                                                    
                                                      
  --Client_Export                                                    
  --IF @pa_tab = 'CE'                                                    
  --BEGIN--CE                                      
  --                                                    
    DECLARE @l_name                                 varchar(135)                                          
          , @l_sname                                varchar(16)                 
          , @l_brcode                               char(6)                                                     
          , @l_add1                                 varchar(36)                                                    
          , @l_add2                                 varchar(36)                                          , @l_add3                                 varchar(36)                                                    
          , @l_add4   varchar(36)                                                    
          , @l_pin                                  varchar(7)                                                    
          , @l_email                                varchar(50)                                                    
          , @l_indicator                            char(1)          -- ?                                                    
          , @l_first_fh_name                        varchar(45)                                                    
          , @l_tele1                                varchar(24)                                     
          , @l_fax                                  varchar(24)                                                    
          , @l_mobile                               varchar(12)                                                    
          , @l_attorney                             char(1)          -- ?                                                    
          ---                                                    
          , @l_sech_name                            varchar(45)                                                    
          , @l_sech_fh_name                         varchar(45)                                                     
          , @l_sadd1                                varchar(36)                                                    
          , @l_sadd2                                varchar(36)                                                    
          , @l_sadd3                              varchar(36)                                                    
          , @l_sadd4                                varchar(36)                                                    
          , @l_spin          varchar(7)                                                    
          , @l_stele                                varchar(24)                                                    
          , @l_sfax                                 varchar(24)                                                    
          ---                                             
          , @l_thih_name                            varchar(45)                                                    
          , @l_thih_fh_name                         varchar(45)                                                     
          , @l_tadd1                 varchar(36)                                              
          , @l_tadd2                                varchar(36)                                                    
, @l_tadd3                                varchar(36)                                                    
          , @l_tadd4              varchar(36)                                                    
          , @l_tpin                                 varchar(7)                                                    
          , @l_ttele                 varchar(24)                                                    
          , @l_tfax                                varchar(24)                                                    
          ---                                                 
          , @l_nominee                              varchar(45)                                                    
          , @l_nominee_dob3               varchar(11)                                                    
          , @l_nomineeadd1                   varchar(36)                                                    
          , @l_nomineeadd2  varchar(36)                                                    
          , @l_nomineeadd3                          varchar(36)                                                    
          , @l_nomineeadd4              varchar(36)                                                    
          , @l_nomineepin                           varchar(7)                                                    
          , @l_nomineetele                          varchar(24)                                        
          , @l_nomineefax                           varchar(24)                                                    
          , @l_relation                             varchar(36)                                 
          , @l_nominee_dob                          varchar(11)                                                    
          ---                                                    
          , @l_occup                                char(2)                                                    
          , @l_secoccup                             char(2)                                                    
          , @l_thoccup                              char(2)                                                    
          , @l_chequecash                           char(1)                                                    
          , @l_chqno                                varchar(10)                                     
          , @l_recvdate                             datetime                                                    
          , @l_rupees                               varchar(50)                                                     
          , @l_drawn                                varchar(50)                               
          , @l_acctype                              char(2)                                                    
          , @l_active                               char(2)                                                    
          --                                                    
          , @l_minor_nominee_guardianname           varchar(45)                                                    
          , @l_minor_nominee_add1                   varchar(36)                                                    
          , @l_minor_nominee_add2                   varchar(36)                                                    
      , @l_minor_nominee_add3                   varchar(36)                                                    
          , @l_minor_nominee_add4                   varchar(36)                                                    
          , @l_minor_nominee_pin                    varchar(10)                                                    
          , @l_minor_nominee_phone                  varchar(24)                                                    
          , @l_minor_nominee_fax                    varchar(24)                                                    
          , @l_minor_nominee_guardianaddresspresent char(1)                                                    
          , @l_uploadtonsdl                         char(1)                                                    
          , @l_taxstatus                            varchar(20)                                                    
          , @l_nominee_indicator                    char(1)                                                    
          , @l_sigmode                              char(1)                                                    
          --                                                    
          , @l_upfront    char(1)                                                    
          , @l_keepsettlement                       char(1)                                                    
          , @l_fre_trx                              tinyint                                                    
          , @l_fre_hold                             tinyint                                                    
          , @l_fre_bill                             tinyint                                                    
          , @l_allow                                char                                               
          , @l_batchno                              int                                                    
          --                                                    
          , @l_fadd1                                varchar(36)                           
          , @l_fadd2                                varchar(36)                                                    
          , @l_fadd3                                varchar(36)                                                    
          , @l_fadd4                                varchar(36)                                            
          , @l_fpin                               varchar(10)                                                    
          , @l_ftele                                varchar(24)                                                    
          , @l_ffax                                 varchar(24)                                                    
          , @l_cradd1                               varchar(36)                                                    
          , @l_cradd2                               varchar(36)                                                    
          , @l_cradd3                               varchar(36)                                                    
          , @l_cradd4                               varchar(36)                                                    
          , @l_crfax                                varchar(24)                                                    
          , @l_crpin                                varchar(7)                                                    
          , @l_crtele                               varchar(24)                                                    
          , @l_introadd1          varchar(36)                                                    
          , @l_introadd2                            varchar(36)                                                    
          , @l_introadd3                            varchar(36)                                                    
          , @l_introadd4       varchar(36)                                                    
          , @l_introfax                             varchar(24)                                                    
          , @l_intropin                             varchar(7)                                                    
          , @l_introtele                            varchar(24)                                                    
          --                                  
          , @l_authid                               char(8)                
          , @l_authdt                datetime                                                    
          --                                                    
          , @l_bank_id                              numeric                                                    
          , @l_bankname   varchar(35)                                   
          , @l_bankbranch                           varchar(30)                                                    
          , @l_bankacttype                          char(2)                                                    
          , @l_bankactno        varchar(30)                                                     
          , @l_bankadd1                   varchar(36)                                                    
          , @l_bankadd2                             varchar(36)                                                    
          , @l_bankadd3          varchar(36)                                                    
          , @l_bankadd4                             varchar(36)                                                    
          , @l_bankpin                              varchar(7)                                                 
          , @l_banktele                             varchar(24)                                       
          , @l_bankfax                              varchar(24)                                                    
          , @l_micr                                 varchar(9)                                                    
          , @l_bankrbi                              varchar(50)                         
          , @l_rbi_appdate                          datetime                                         
          , @l_panno                                varchar(30)                                                    
          --                                                    
          , @l_secondmapin                          varchar(10)                                             
          , @l_secondsms                            char(1)                                                    
          , @l_thirdemail                           varchar(50)                                                    
          , @l_thirdmapin                           varchar(10)                                                    
          , @l_thirdsms                    char(1)                                                    
          , @l_minor_nominee_indicator              char(1)                                                     
          , @l_sech_panno                           varchar(30)                                                    
          , @l_thih_panno                           varchar(30)                                                    
          , @l_clienttype                           varchar(4)                                                    
          , @l_values                               varchar(8000)                                                    
          , @l_dpam_id                              numeric                                                    
          , @l_bp_id                                varchar(8)                                                    
          , @l_add_pref_flag                        char(1)                                            
          , @l_fh_panflag                           char(1)                                                    
          , @l_sh_panflag                           char(1)                                                     
          , @l_th_panflag                           char(1)                                                    
          , @l_sebireg                              varchar(24)                                                    
          , @l_mapin                                varchar(10)                                    
          , @l_sms       char(1)       
          , @l_remark                               varchar(100)                                                    
          , @l_remissier                            varchar(8)                                                    
          , @l_remissierscheme                      varchar(8)                         
          , @l_inwarddt                             datetime                                   
          , @l_mkrdt                                datetime                                                    
          , @l_mkrid                                varchar(8)                                                   
          , @l_blsavingcd                           varchar(20)              
          , @l_chgsscheme                           char(10)                                               
          , @l_billcycle                            char(1)                                                    
          , @l_brboffcode                           char(6)                                                    
          , @l_groupcd                              char(3)                                                    
          , @l_familycd                             char(3)                                                    
          , @l_introducer         varchar(30)                                                    
          , @l_statements                           char(1)                                                    
          , @l_billflag                             char(1)                                       
          , @l_instrno                              varchar(25)                                                    
          , @l_allowcredit                          money                                                    
          , @l_billcode                   char(8)                                                    
          , @l_collectioncode                       char(8)                                                    
          , @l_boff_clienttype                      char(2)                                                    
          , @l_secondemail                          varchar(50)                                                      
          , @l_cmcd                                 varchar(8)                                                    
          , @l_poaforpayin                          char(1)                                                    
          , @c_crn_no                               numeric                                                    
          , @c_dpam_id                              numeric                                                     
          , @c_acct_no                     varchar(25)                                                       
          , @c_sba_no                               varchar(20)                                                    
        , @l_modified                             char(1)                                        
          , @l_minor_nominee_guardianname1           varchar(45)                                      
          , @l_minor_nominee_address1                   varchar(36)                                                               
          , @l_minor_nominee_address2                   varchar(36)                                                    
          , @l_minor_nominee_address3                   varchar(36)                                                  
          , @l_minor_nominee_address4                   varchar(36)                                                    
          , @l_minor_nominee_pincode                    varchar(10)                                      
          , @l_minor_nominee_phone1                    varchar(24)                                                    
          , @l_minor_nominee_fax1                      varchar(24)                                                    
          , @l_minor_nominee_guardianaddresspresent1   char(1)                                            , @l_nominee_dob1                             varchar(11)                                      
          , @l_nom_gau_nm                              varchar(20)        
          , @l_nom_fnm                                 varchar(20)      
                                       
   --                                                    
   IF EXISTS(SELECT top 1 * FROM client_export_nsdl WITH (NOLOCK))                                        
   BEGIN--#                                                    
   --                                                    
     INSERT INTO client_export_nsdl_hst                                                     
     (cx_dpam_id                                                    
     ,cx_brcode                                  
     ,cx_name                                              
     ,cx_sname                                                                      
     ,cx_add1                                                                                     
     ,cx_add2                                                                                     
     ,cx_add3                                                                                     
     ,cx_add4                                                          
     ,cx_pin                                     
     ,cx_email                                                                                    
     ,cx_indicator                                                                                
     ,cx_first_fh_name                                                                            
     ,cx_tele1                                                                                    
     ,cx_fax                                                                                      
     ,cx_mobile                                                             
     ,cx_attorney                                                                                 
     ,cx_sech_name                                                                                
     ,cx_sech_fh_name                                                                             
     ,cx_sadd1                                                                                    
     ,cx_sadd2                                           
     ,cx_sadd3                                                                                    
     ,cx_sadd4                                                                             
     ,cx_spin                                                                                    
     ,cx_stele                                                                                    
     ,cx_sfax                                                                                     
     ,cx_thih_name                                                             
     ,cx_thih_fh_name                                                                             
     ,cx_tadd1                                                                                    
     ,cx_tadd2                                                           
     ,cx_tadd3                                                                                    
     ,cx_tadd4                                                                                    
     ,cx_tpin                                                                                     
     ,cx_ttele                                                                                    
     ,cx_tfax                                                                                     
     ,cx_bp_id                                                                                    
     ,cx_add_pref_flag                                                                            
     ,cx_bankname   
     ,cx_bankbranch                                                                               
     ,cx_bankadd1                                           
     ,cx_bankadd2                                                                                 
     ,cx_bankadd3                                                                                 
     ,cx_bankadd4                                                                             
     ,cx_bankpin         
     ,cx_banktele                                                                                 
     ,cx_bankfax                                                                                  
     ,cx_bankrbi                                                                                  
     ,cx_rbi_appdate                                                                 
     ,cx_bankactno                                                        
     ,cx_bankacttype                                                                              
     ,cx_micr                                                                                     
     ,cx_panno                                                                                    
     ,cx_sech_panno                                                                               
     ,cx_thih_panno                                                                               
     ,cx_sebireg                                                                                  
     ,cx_taxstatus                                       
     ,cx_nominee_indicator                                                                        
     ,cx_sigmode                                      
     ,cx_nominee                                                                                  
     ,cx_nominee_dob                                                                                                                                                                                                    
     ,cx_nomineeadd1                                                                              
     ,cx_nomineeadd2                                                                           
     ,cx_nomineeadd3                                                                              
     ,cx_nomineeadd4                                                                              
     ,cx_nomineepin                                                                               
     ,cx_nomineetele                                                                    
     ,cx_nomineefax                                                                               
     ,cx_relation                                                                           
     ,cx_clienttype                                                                               
     ,cx_occup                                                            
     ,cx_secoccup                                                                                 
     ,cx_thoccup                                                                                  
     ,cx_chequecash                                                                               
     ,cx_chqno                                                                                    
     ,cx_recvdate                                                                                 
     ,cx_rupees                                                                                   
     ,cx_drawn                                                                                    
     ,cx_acctype                                               
     ,cx_active                                                                                   
     ,cx_chgsscheme                                                                               
     ,cx_billcycle                    
     ,cx_brboffcode                    
     ,cx_groupcd                                                                                  
     ,cx_familycd                                                                                 
     ,cx_introducer                                                                               
     ,cx_statements                                                                            
     ,cx_billflag                                                                                 
     ,cx_instrno                                                                                  
 ,cx_allowcredit                                                                              
     ,cx_billcode                                                               
     ,cx_collectioncode                                                                           
     ,cx_upfront                                                                                  
     ,cx_keepsettlement                                                                           
     ,cx_fre_trx                                                                                  
     ,cx_fre_hold                                                                                 
     ,cx_fre_bill                                                                                 
     ,cx_allow                                                               
     ,cx_batchno                                                                                  
     ,cx_cmcd                                                             
     ,cx_boff_clienttype                                                                          
     ,cx_fadd1                                              
     ,cx_fadd2                                                                                    
     ,cx_fadd3                                                                                    
     ,cx_fadd4                                                                                    
     ,cx_fpin                                                                                     
     ,cx_ftele                                                                                    
     ,cx_ffax                                                                                     
     ,cx_cradd1                                                                            
,cx_cradd2                                                                         
     ,cx_cradd3                                                                                   
     ,cx_cradd4                                                                                   
     ,cx_crfax                                                        
     ,cx_crpin                                                                                    
     ,cx_crtele                                                                                   
     ,cx_introadd1                                                                                
     ,cx_introadd2                                
     ,cx_introadd3                                                                                
     ,cx_introadd4                                                                                
     ,cx_introfax                                                                                 
     ,cx_intropin                                                                               
     ,cx_introtele                                                                                
     ,cx_blsavingcd                                                                               
     ,mkrdt                                                                                       
     ,mkrid                                                         
     ,cx_authid               ,cx_authdt                                                                                   
     ,cx_remark                                                                                   
     ,cx_inwarddt                                                                                 
     ,cx_PoaForPayin                                                                              
     ,cx_remissier                                                                                
     ,cx_remissierscheme                                                              
     ,cx_mapin     
     ,cx_sms                                                                                      
     ,cx_secondemail                                                                              
     ,cx_secondmapin                                                                      
     ,cx_secondsms                                                                                
     ,cx_thirdemail                                                                               
     ,cx_thirdmapin                                                                               
,cx_thirdsms                          
     ,cx_minor_nominee_indicator                                                                  
     ,cx_minor_nominee_guardianname                                                               
     ,cx_minor_nominee_add1                                                                       
     ,cx_minor_nominee_add2                                                                       
     ,cx_minor_nominee_add3                                                                       
     ,cx_minor_nominee_add4                                                           
     ,cx_minor_nominee_pin                                                                        
     ,cx_minor_nominee_phone                                                      
     ,cx_minor_nominee_fax                                                                        
     ,cx_minor_nominee_guardianaddresspresent                                                     
     ,cx_uploadtonsdl                                                                             
  ,cx_fh_panflag                                                                               
     ,cx_sh_panflag                                                                               
     ,cx_th_panflag                                                    
     ,cx_edittype                                                    
     ,cx_e_cmpltd         )                                                    
     --                                                    
     SELECT cx_dpam_id                                                    
          , cx_brcode                                                                     
          , cx_name                                                                                 
          , cx_sname                                                                                    
          , cx_add1                                                                                     
          , cx_add2                                              
          , cx_add3                                                                                     
          , cx_add4                                                                                     
          , cx_pin                                                                        
          , cx_email                                                                                    
          , cx_indicator                                                                                
          , cx_first_fh_name                                                                            
          , cx_tele1                                                                                    
    , cx_fax                                                      
     , cx_mobile                                                                           
          , cx_attorney                                                                                 
          , cx_sech_name                                    
          , cx_sech_fh_name                                                                             
          , cx_sadd1                                                                                    
          , cx_sadd2                                                                                    
          , cx_sadd3                                                
          , cx_sadd4                                                                                    
          , cx_spin                                                                                     
          , cx_stele                                                                                    
          , cx_sfax                                     
          , cx_thih_name                                                                                
          , cx_thih_fh_name                                                            
      , cx_tadd1                    
          , cx_tadd2                                                                                    
          , cx_tadd3                                                                                    
          , cx_tadd4                                                                                    
          , cx_tpin                                                                                     
          , cx_ttele                                                                                    
          , cx_tfax                        
          , cx_bp_id                                                                           
          , cx_add_pref_flag                                                                            
          , cx_bankname                                                              
          , cx_bankbranch                                                                               
          , cx_bankadd1                                                            
          , cx_bankadd2                                                                                 
          , cx_bankadd3                                                              
          , cx_bankadd4                                                                                 
          , cx_bankpin                                                                                  
          , cx_banktele                                                                                 
          , cx_bankfax                                                 
          , cx_bankrbi                                                                 
          , cx_rbi_appdate                                                                              
          , cx_bankactno                                                                                
          , cx_bankacttype                                                                              
          , cx_micr                                                                                     
          , cx_panno                                                                                    
          , cx_sech_panno                                                                               
          , cx_thih_panno                                                                               
          , cx_sebireg                                                                                  
          , cx_taxstatus                           
          , cx_nominee_indicator                                                                        
          , cx_sigmode                                                                                 
          , cx_nominee                                                     
          , cx_nominee_dob                                                                                                                                                                                                    
          , cx_nomineeadd1                                                                              
          , cx_nomineeadd2                                                                              
          , cx_nomineeadd3                                                                              
          , cx_nomineeadd4                                                       
          , cx_nomineepin                                                                               
          , cx_nomineetele                                                                              
          , cx_nomineefax                                                                               
          , cx_relation                                                                                 
          , cx_clienttype                                                                               
          , cx_occup                                                                                    
          , cx_secoccup                                                                     
          , cx_thoccup                           
          , cx_chequecash                                                                               
          , cx_chqno                                                                                    
          , cx_recvdate                                                                                 
          , cx_rupees                                                                               
          , cx_drawn                                                                                    
          , cx_acctype                                                                                  
          , cx_active                                                                                   
          , cx_chgsscheme                                                         
          , cx_billcycle                                                                                
          , cx_brboffcode                                                                               
          , cx_groupcd                                                                                  
          , cx_familycd                                               
          , cx_introducer                                                                               
          , cx_statements                                                                               
          , cx_billflag    , cx_instrno                                                                                  
          , cx_allowcredit                                                                              
          , cx_billcode                                                                                 
          , cx_collectioncode                                                                          
          , cx_upfront                                                                                  
          , cx_keepsettlement                                                                           
          , cx_fre_trx                                                                                  
          , cx_fre_hold                                                                                 
          , cx_fre_bill                                                                                 
          , cx_allow                                                                                    
          , cx_batchno                                                                                  
          , cx_cmcd                                           
          , cx_boff_clienttype                                
          , cx_fadd1                                                                                    
          , cx_fadd2                                                                                    
          , cx_fadd3                                                                                    
          , cx_fadd4                                                                                    
          , cx_fpin                                                                                
          , cx_ftele                                     
          , cx_ffax                                                                   
          , cx_cradd1                                                                                   
          , cx_cradd2                                                                                   
          , cx_cradd3                                                                     
          , cx_cradd4                                                                                   
          , cx_crfax                                                                                    
          , cx_crpin                                                                                    
          , cx_crtele                                                 
          , cx_introadd1                                                                    , cx_introadd2                                                                                
          , cx_introadd3                                                                                
          , cx_introadd4                                                                                
          , cx_introfax                                                                         
          , cx_intropin                                                                                 
          , cx_introtele                                                                                
          , cx_blsavingcd                                                                               
          , mkrdt          
          , mkrid                                                           
          , cx_authid                                                                                   
          , cx_authdt                                                                                   
          , cx_remark                                                                                   
          , cx_inwarddt                                                      
     , cx_PoaForPayin                                                                              
          , cx_remissier                                                                            
          , cx_remissierscheme                                                                          
          , cx_mapin                                                                                    
          , cx_sms                                                                                      
          , cx_secondemail                                                                              
          , cx_secondmapin                                                                              
          , cx_secondsms                                                                                
          , cx_thirdemail                                                                               
          , cx_thirdmapin                                                                               
          , cx_thirdsms                                                                                 
          , cx_minor_nominee_indicator                                                             
          , cx_minor_nominee_guardianname                                                               
          , cx_minor_nominee_add1                                             
         , cx_minor_nominee_add2                                                                       
          , cx_minor_nominee_add3               
          , cx_minor_nominee_add4                                                                       
          , cx_minor_nominee_pin                                                                        
          , cx_minor_nominee_phone                                                                      
          , cx_minor_nominee_fax                                                                        
     , cx_minor_nominee_guardianaddresspresent                                                     
          , cx_uploadtonsdl                                                                             
          , cx_fh_panflag                                                                               
          , cx_sh_panflag                                                                               
          , cx_th_panflag                                          
          , cx_edittype                                                    
       , 1                                                    
     FROM   client_export_nsdl WITH (NOLOCK)                                                    
     WHERE  cx_e_cmpltd = 1                                                    
     --        
     DELETE FROM client_export_nsdl                                                     
     WHERE  cx_e_cmpltd  = 1                   --                                                    
   END                                                    
                                                       
   --dp_holder_details                                                     
   CREATE TABLE #dp_holder_dtls                                                    
   (dphd_dpam_sba_no                         varchar(20)                                                    
   ,dphd_sh_fname                            varchar(100)                                                      
   ,dphd_sh_mname                            varchar(50)                                                      
   ,dphd_sh_lname                            varchar(50)                                                      
   ,dphd_sh_fthname                          varchar(100)                                   
   ,dphd_sh_dob                              datetime -- varchar(11)  --                                                     
   ,dphd_sh_pan_no                           varchar(15)                                        
   ,dphd_sh_gender                           varchar(1)                                                      
   ,dphd_th_fname                            varchar(100)                                                      
   ,dphd_th_mname                            varchar(50)                                                      
   ,dphd_th_lname                            varchar(50)                                                      
   ,dphd_th_fthname                          varchar(100)                                                      
   ,dphd_th_dob                              datetime -- varchar(11)                                          
   ,dphd_th_pan_no                           varchar(15)                                                      
   ,dphd_th_gender                      varchar(1)                                                      
   ,dphd_poa_fname                           varchar(100)                                                      
   ,dphd_poa_mname                           varchar(50)                                                      
   ,dphd_poa_lname                           varchar(50)                                                      
   ,dphd_poa_fthname                         varchar(100)                                                      
   ,dphd_poa_dob                             datetime --varchar(11)                                          
   ,dphd_poa_pan_no                          varchar(15)                                                      
   ,dphd_poa_gender                          varchar(1)                                                      
   ,dphd_nom_fname                           varchar(100)                                                      
   ,dphd_nom_mname                           varchar(50)                                                      
   ,dphd_nom_lname                           varchar(50)                               
   ,dphd_nom_fthname                         varchar(100)                                                      
,dphd_nom_dob    datetime  --datetime                                                     
   ,dphd_nom_pan_no                          varchar(15)                                                      
   ,dphd_nom_gender                          varchar(1)                                                      
   ,dphd_gau_fname                        varchar(100)                                                      
   ,dphd_gau_mname                           varchar(50)                                                      
   ,dphd_gau_lname                           varchar(50)                                                      
   ,dphd_gau_fthname                         varchar(100)                                                      
   ,dphd_gau_dob                             datetime  --varchar(11)                                                    
   ,dphd_gau_pan_no                          varchar(15)                                                      
   ,dphd_gau_gender              varchar(1)                                                      
   ,dphd_fh_fthname                          varchar(100)                                      
   ,dphd_nomgau_fname                        varchar(200)             --new column                                      
   ,dphd_nomgau_mname                        varchar(200)             --new column                                      
   ,dphd_nomgau_lname                        varchar(200)             --new column                                      
   ,dphd_nomgau_fthname                      varchar(100)             --new column                                      
   ,dphd_nomgau_dob                          datetime                 --new column                                      
   ,dphd_nomgau_pan_no                       varchar(15)              --new column                                      
   ,dphd_nomgau_gender                       varchar(1)               --new column                                      
   )                                                    
   --                  
   IF isnull(@pa_from_dt,'') <> '' AND isnull(@pa_to_dt,'') <> '' AND isnull(@pa_from_crn,'') <> '' AND isnull(@pa_to_crn,'') <> ''                                                    
   BEGIN                                                    
   --                                                    
     SET @c_cursor = CURSOR fast_forward FOR                                                     
     SELECT DISTINCT  dpam.dpam_crn_no      crn_no                                                    
          --, excsm.excsm_exch_cd             excsm_exch_cd                                                                
          --, excsm.excsm_seg_cd              excsm_seg_cd                                                                
          , dpam.dpam_id                    dpam_id                                                               
          , dpam.dpam_acct_no               acct_no                                                                
          , dpam.dpam_sba_no                sba_no                                                             
          --, sm.stam_cd                      stam_cd                                                              
          --, dpm.dpm_dpid             dpid                                                  
          --, ISNULL(dpam.dpam_sba_name,'')   dpam_sba_name                                                            
     FROM   exch_seg_mstr                   excsm    WITH (NOLOCK)                                                                
          , status_mstr                     sm       WITH (NOLOCK)                                                            
          , dp_mstr                         dpm      WITH (NOLOCK)                                                            
          , dp_acct_mstr                    dpam     WITH (NOLOCK)                                                            
          , product_mstr             prom                                      
          , excsm_prod_mstr                 excpm                                                          
     WHERE  dpam.dpam_excsm_id           =  excsm.excsm_id                                                          
     AND    excsm.excsm_id               =  excpm.excpm_excsm_id                                                    
     AND    dpam_lst_upd_dt                 between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                                     
     AND    dpam_crn_no                     between convert(numeric, @pa_from_crn)  AND  convert(numeric, @pa_to_crn)                                                    
     AND    prom.prom_cd                 =  '01'                                                         
     AND    excsm.excsm_exch_cd          =  'NSDL'                                              
 AND    prom.prom_id                 =  excpm.excpm_prom_id                                                          
     AND    dpam.dpam_dpm_id             =  dpm.dpm_id                                                             
     AND    dpam.dpam_stam_cd            =  sm.stam_cd                                                            
     AND    dpam.dpam_deleted_ind        =  1                                                         
     AND    excsm.excsm_deleted_ind      =  1                                                            
     AND    dpm.dpm_deleted_ind          =  1                                                            
     AND    sm.stam_deleted_ind          =  1                                                            
     AND    prom.prom_deleted_ind        =  1                                                 
     AND    excpm.excpm_deleted_ind      =  1                                                              
   --                                                      
   END                            
   --                                    
   IF isnull(@pa_from_dt,'') <> '' AND isnull(@pa_to_dt,'') <> '' AND isnull(@pa_from_crn,'') = '' AND isnull(@pa_to_crn,'') = ''                                                    
   BEGIN                                                    
   --                                                    
     SET @c_cursor = CURSOR fast_forward FOR                                                     
     SELECT DISTINCT  dpam.dpam_crn_no      crn_no                          
          --, excsm.excsm_exch_cd             excsm_exch_cd                                                                
          --, excsm.excsm_seg_cd              excsm_seg_cd                                                                
          , dpam.dpam_id                    dpam_id                                             
          , dpam.dpam_acct_no               acct_no                                                                
          , dpam.dpam_sba_no                sba_no                                                             
          --, sm.stam_cd                      stam_cd                                                              
          --, dpm.dpm_dpid                    dpid                                                            
          --, ISNULL(dpam.dpam_sba_name,'')   dpam_sba_name                                                         
     FROM   exch_seg_mstr                   excsm    WITH (NOLOCK)                                                                
          , status_mstr                     sm       WITH (NOLOCK)                                                            
          , dp_mstr                         dpm      WITH (NOLOCK)                                                            
          , dp_acct_mstr          dpam     WITH (NOLOCK)                                                            
          , product_mstr                    prom                                                              
      , excsm_prod_mstr                 excpm                                                          
     WHERE  dpam.dpam_excsm_id           =  excsm.excsm_id                                                     
     AND    excsm.excsm_id               =  excpm.excpm_excsm_id                                                    
     AND    dpam_lst_upd_dt               between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                                     
     --AND    dpam_crn_no                     between convert(numeric, @pa_from_crn)  AND  convert(numeric, @pa_to_crn)                                                    
     AND    prom.prom_cd                 =  '01'                                                         
     AND    excsm.excsm_exch_cd          =  'NSDL'                                                    
     AND    prom.prom_id                 =  excpm.excpm_prom_id                                                   
     AND    dpam.dpam_dpm_id             =  dpm.dpm_id                                                             
     AND    dpam.dpam_stam_cd            =  sm.stam_cd                                     
     AND    dpam.dpam_deleted_ind        =  1                                                                
     AND    excsm.excsm_deleted_ind      =  1                                                            
     AND    dpm.dpm_deleted_ind          =  1                                                            
     AND    sm.stam_deleted_ind          =  1                                                            
     AND    prom.prom_deleted_ind        =  1                        
     AND    excpm.excpm_deleted_ind      =  1                                                              
   --                                                      
   END                                                    
   --                                                    
   IF isnull(@pa_from_dt,'') = '' AND isnull(@pa_to_dt,'') = '' AND isnull(@pa_from_crn,'') <> '' AND isnull(@pa_to_crn,'') <> ''                            
   BEGIN                                                    
   --                                                    
                                                            
     SET @c_cursor = CURSOR fast_forward FOR                                                   
     SELECT DISTINCT  dpam.dpam_crn_no      crn_no                                                    
          --, excsm.excsm_exch_cd             excsm_exch_cd                                                                
          --, excsm.excsm_seg_cd              excsm_seg_cd                                                                
          , dpam.dpam_id                    dpam_id                                                               
          , dpam.dpam_acct_no         acct_no                                                                
          , dpam.dpam_sba_no                sba_no                                                             
          --, sm.stam_cd                      stam_cd                                                              
          --, dpm.dpm_dpid                    dpid                                                            
          --, ISNULL(dpam.dpam_sba_name,'')   dpam_sba_name                                                            
     FROM   exch_seg_mstr                   excsm    WITH (NOLOCK)                   
          , status_mstr                     sm       WITH (NOLOCK)                                                            
          , dp_mstr                         dpm      WITH (NOLOCK)                                                            
          , dp_acct_mstr                    dpam     WITH (NOLOCK)                                                            
          , product_mstr                    prom                                                              
        , excsm_prod_mstr                 excpm                                      
WHERE  dpam.dpam_excsm_id       =  excsm.excsm_id                                                          
     AND    excsm.excsm_id               =  excpm.excpm_excsm_id                            
     --AND    dpam_lst_upd_dt                 between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                                     
     AND    dpam_crn_no                     between convert(numeric, @pa_from_crn)  AND  convert(numeric, @pa_to_crn)                                                    
     AND    prom.prom_cd       =  '01'                                                         
     AND    excsm.excsm_exch_cd          =  'NSDL'                                                    
     AND    prom.prom_id                 =  excpm.excpm_prom_id                                                          
     AND    dpam.dpam_dpm_id             =  dpm.dpm_id                                       
     AND    dpam.dpam_stam_cd            =  sm.stam_cd                                                            
     AND    dpam.dpam_deleted_ind        =  1                                                                
     AND    excsm.excsm_deleted_ind      =  1                                                            
     AND    dpm.dpm_deleted_ind          =  1                                                            
     AND    sm.stam_deleted_ind          =  1                                                            
     AND    prom.prom_deleted_ind        =  1                                                        
     AND    excpm.excpm_deleted_ind      =  1                                                              
   --                                                      
   END                                                    
   --                                                   
   OPEN @c_cursor                    
   FETCH NEXT FROM @c_cursor INTO @c_crn_no, @c_dpam_id, @c_acct_no, @c_sba_no                                                    
   --                                                     
    WHILE @@fetch_status = 0             
    BEGIN --#cursor                                                   
    --                                                    
      DELETE FROM #dp_holder_dtls                                                    
      --                                                    
      DELETE FROM #entity_properties                                                    
      --                                                    
      DELETE FROM #entity_property_dtls                                                    
      --                                                    
      DELETE FROM #account_properties                                                    
      --                                                    
      DELETE FROM #pk                                                    
      --                                                    
      DELETE FROM #conc                                                    
      --                                                    
      DELETE FROM #addr                                                    
      --                                                    
      INSERT INTO #dp_holder_dtls                                                    
      (dphd_dpam_sba_no                                                    
      ,dphd_sh_fname                                  
      ,dphd_sh_mname                                                       
      ,dphd_sh_lname                                                       
      ,dphd_sh_fthname                                 
      ,dphd_sh_dob                                                         
      ,dphd_sh_pan_no                                                      
      ,dphd_sh_gender                                                      
      ,dphd_th_fname                                        
      ,dphd_th_mname                             ,dphd_th_lname                                                       
      ,dphd_th_fthname                                                     
      ,dphd_th_dob                                                         
      ,dphd_th_pan_no                                                      
      ,dphd_th_gender                                                      
      ,dphd_poa_fname                                                      
      ,dphd_poa_mname                                                      
      ,dphd_poa_lname                                                      
      ,dphd_poa_fthname                                                    
      ,dphd_poa_dob                                                        
      ,dphd_poa_pan_no                                                     
      ,dphd_poa_gender                                                     
      ,dphd_nom_fname                                                      
      ,dphd_nom_mname                   
      ,dphd_nom_lname                                                      
      ,dphd_nom_fthname                              
      ,dphd_nom_dob                                                        
      ,dphd_nom_pan_no                                                     
      ,dphd_nom_gender                                                     
      ,dphd_gau_fname                                                      
      ,dphd_gau_mname                                                      
      ,dphd_gau_lname                                                      
      ,dphd_gau_fthname                                                    
      ,dphd_gau_dob                                                        
      ,dphd_gau_pan_no                                                     
      ,dphd_gau_gender                                                     
      ,dphd_fh_fthname                                                     
      ,dphd_nomgau_fname                                      
      ,dphd_nomgau_mname                                      
      ,dphd_nomgau_lname                                      
      ,dphd_nomgau_fthname                                      
      ,dphd_nomgau_dob                                      
      ,dphd_nomgau_pan_no                                      
      ,dphd_nomgau_gender                                      
      )                                                    
      SELECT dphd_dpam_sba_no                                               
        , Isnull(dphd_sh_fname,'')     dphd_sh_fname                                                        
           , dphd_sh_mname                                                                     , dphd_sh_lname                                     
           , Isnull(dphd_sh_fthname ,'')   dphd_sh_fthname                                                    
           , dphd_sh_dob                                                            
           , Isnull(dphd_sh_pan_no,'')     dphd_sh_pan_no                                                    
           , dphd_sh_gender                                                         
           , isnull(dphd_th_fname,'')      dphd_th_fname                                                      
           , dphd_th_mname                                                      
           , dphd_th_lname                                                          
           , isnull(dphd_th_fthname,'')    dphd_th_fthname                                                    
           , dphd_th_dob                                                            
           , isnull(dphd_th_pan_no,'')     dphd_th_pan_no                                                       
           , dphd_th_gender                                    
           , dppd_fname                                                         
           , dppd_mname                                                         
           , dppd_lname                                         
           , dppd_fthname                                                       
           , dppd_dob                                                           
           , dppd_pan_no                                                        
           , dppd_gender                                                        
           , isnull(dphd_nom_fname ,'')   dphd_nom_fname                                                     
           , dphd_nom_mname                                                         
           , dphd_nom_lname                                      
           , isnull(dphd_nom_fthname,'')   dphd_nom_fthname                                                    
           , isnull(dphd_nom_dob,'')     dphd_nom_dob                                                      
           , dphd_nom_pan_no                                                        
       , dphd_nom_gender                                                        
           , dphd_gau_fname                                                         
           , dphd_gau_mname                                                         
           , dphd_gau_lname                                                   
           , isnull(dphd_gau_fthname,'')   dphd_gau_fthname                                                    
           , dphd_gau_dob --Convert(varchar(11),dphd_gau_dob,3)                                                           
           , dphd_gau_pan_no                                
           , dphd_gau_gender                                                        
           , dphd_fh_fthname                                                        
           , dphd_nomgau_fname                                      
           , dphd_nomgau_mname                                      
           , dphd_nomgau_lname                                      
           , dphd_nomgau_fthname                                      
           , dphd_nomgau_dob                                      
           , dphd_nomgau_pan_no                                      
           , dphd_nomgau_gender                                      
      FROM   dp_holder_dtls       WITH (NOLOCK)                                                    
           , dp_acct_mstr          WITH (NOLOCK)                                                        
             left outer join                                                
             dp_poa_dtls         WITH (NOLOCK)                                                        
             on  dpam_id            =   dppd_dpam_id AND    isnull(dppd_deleted_ind,1)   = 1     
      WHERE  dphd_dpam_id       = dpam_id                                                  
      AND    dpam_id            = @c_dpam_id                                                    
      AND    dphd_dpam_sba_no   = @c_sba_no                                                     
      AND    dphd_deleted_ind   = 1                                                          
      AND    dpam_deleted_ind   = 1                                              
                                               
     ---SELECT * FROM #dp_holder_dtls                                          
      --                                                    
      SELECT @l_name                 = convert(varchar(135), clim.clim_name1+' '+isnull(clim.clim_name2,'')+' '+isnull(clim.clim_name3,''))                                                    
           , @l_sname                = convert(varchar(16), clim.clim_short_name)                                                               
           , @l_clienttype           = Isnull(dpam.dpam_subcm_cd,'') --clienttype--may be a lising --convert(varchar(4), clim.clim_enttm_cd)                                                    
           , @l_acctype              = Isnull(dpam.dpam_Enttm_cd,'') --                                                   
           , @l_boff_clienttype      = Isnull(dpam.dpam_Clicm_cd,'')                                                    
           , @l_remark               = convert(varchar(100), clim.clim_rmks)                                                     
           , @l_mkrdt                = convert(datetime,clim.clim_created_dt )                                                    
           , @l_mkrid                = convert(varchar(8), clim.clim_created_by)                            
           , @l_active               = convert(varchar(2), dpam.dpam_stam_cd)                                                    
           , @l_modified             = CASE WHEN clim.clim_created_dt = clim.clim_lst_upd_dt THEN 'I' ELSE 'U' END                                                     
      FROM   client_mstr               clim WITH (NOLOCK)                                                    
           , dp_acct_mstr              dpam WITH (NOLOCK)                                                    
      WHERE  clim.clim_crn_no        = @c_crn_no                                                 
      AND    dpam_id        = @c_dpam_id                                                
      AND    clim.clim_crn_no        = dpam.dpam_crn_no                                                    
      AND    clim.clim_deleted_ind   = 1                                                    
      AND    dpam.dpam_deleted_ind   = 1                        
                                                   
                                                
                                            
                                                    
      --entity_properties                                                    
      INSERT INTO #entity_properties                                                    
      (code                                                    
      ,value                                                    
      )                                            
      SELECT convert(varchar(25), entp_entpm_cd)                                                    
           , convert(varchar(50), entp_value)                                                     
      FROM   entity_properties    WITH (NOLOCK)                                         
      WHERE  entp_ent_id        = @c_crn_no                                                    
      AND    entp_deleted_ind   = 1                                                    
                                                    
      --entity_properties_dtls                             
      INSERT INTO #entity_property_dtls                                                    
      (code1                  
      ,code2                                                    
      ,value                                                    
      )                                                    
      SELECT convert(varchar(25), a.entp_entpm_cd)                            
           , convert(varchar(25), b.entpd_entdm_cd)                                                    
           , convert(varchar(50), b.entpd_value)                                                     
      FROM   entity_properties      a  WITH (NOLOCK)                                                    
           , entity_property_dtls   b  WITH (NOLOCK)                                                    
      WHERE  a.entp_ent_id        = @c_crn_no                                                    
      AND    a.entp_id            = b.entpd_entp_id                                                    
 AND    a.entp_deleted_ind   = 1                         
      AND    b.entpd_deleted_ind  = 1                                                    
                                                    
      --Account properties                                                     
      INSERT INTO #account_properties                                                    
      (code                                                    
      ,value                                                    
      )                                                    
      SELECT convert(varchar(25), accp_accpm_prop_cd)                                                    
           , convert(varchar(50), accp_value)                                                     
      FROM   account_properties      WITH (NOLOCK)                                                    
      WHERE  accp_clisba_id        = @c_dpam_id                                                     
      AND    accp_deleted_ind    = 1                                                    
                                                    
      --Account properties details                                                    
      INSERT INTO #account_property_dtls                                                    
      (code1                                                    
      ,code2                                               
      ,value                                                    
      )                                                    
      SELECT convert(varchar(25), a.accp_accpm_prop_cd)                                                    
           , convert(varchar(25), b.accpd_accdm_cd)                                                    
           , convert(varchar(50), b.accpd_value)                                                     
      FROM   account_properties      a  WITH (NOLOCK)                                                    
           , account_property_dtls   b  WITH (NOLOCK)                                                    
    WHERE  a.accp_clisba_id      = @c_dpam_id                                                     
      AND    a.accp_id             = b.accpd_accp_id                                                    
      AND    a.accp_deleted_ind    = 1                                              
      AND    b.accpd_deleted_ind   = 1                                                    
                                                    
      --Bank                                                    
      SELECT @l_bank_id              = banm_id                                                    
           , @l_bankname             = convert(varchar(35), banm.banm_name)                                                     
           , @l_bankbranch           = convert(varchar(30), banm.banm_branch)                                        
           , @l_bankactno            = convert(varchar(30), cliba.cliba_ac_no)                                                    
           , @l_attorney             = CASE WHEN cliba.cliba_flg & 1 = 1 THEN 'Y' ELSE 'N' END                                                
           , @l_bankacttype          = CASE WHEN cliba.cliba_ac_type = 'SAVINGS' THEN '10' WHEN cliba.cliba_ac_type = 'CURRENT' THEN '11'  ELSE '13' END                                                    
           , @l_micr                 = convert(varchar(9), banm.banm_micr)                                                    
      FROM   client_bank_accts         cliba         WITH (NOLOCK)                                                    
           , bank_mstr      banm          WITH (NOLOCK)                                                    
  WHERE  banm.banm_id         = cliba.cliba_banm_id                                                    
      AND    banm.banm_deleted_ind   = 1                                                    
      AND    cliba.cliba_clisba_id   = @c_dpam_id                                                    
      AND    cliba.cliba_deleted_ind = 1                                                      
                                                    
      --crn_no and bank id                                                    
      INSERT INTO #pk VALUES (convert(numeric, @c_crn_no))                                                    
      --                                                    
      INSERT INTO #pk VALUES (@l_bank_id)                                                    
  --                                                    
      INSERT INTO #conc               
      (pk                                                    
      ,code                                                    
      ,value                                                      
      )                                                    
      SELECT entac.entac_ent_id                                                    
           , convert(varchar(25), entac.entac_concm_cd)                                                    
           , convert(varchar(50), conc.conc_value)                                                    
      FROM   contact_channels          conc    WITH (NOLOCK)                                                    
           , entity_adr_conc           entac   WITH (NOLOCK)                                                     
      WHERE  entac.entac_adr_conc_id = conc.conc_id                                                    
      AND    entac.entac_ent_id     IN (SELECT pk FROM #pk)             
      AND    conc.conc_deleted_ind   = 1                                                    
      AND    entac.entac_deleted_ind = 1                                                    
                                                    
      --Addresses                                                    
      INSERT INTO #addr                                                    
      (pk                                                    
      ,code                                                    
      ,add1                                                    
      ,add2                                                    
      ,add3                                                    
      ,add4                                                    
      ,pin                                                    
      )                                                    
      SELECT entac.entac_ent_id                 
           , convert(varchar(25), entac.entac_concm_cd)                                                         
           , convert(varchar(50),adr.adr_1)                                                    
           , convert(varchar(50),adr.adr_2)                                                    
           , convert(varchar(50),adr.adr_3)                                   
           , convert(varchar(50),isnull(adr.adr_city,'')+' '+isnull(adr.adr_state,'')+' '+isnull(adr.adr_country,''))                                   
           , convert(varchar(7),adr.adr_zip)                                                    
      FROM   addresses             adr     WITH (NOLOCK)                                                    
           , entity_adr_conc           entac   WITH (NOLOCK)                
      WHERE  entac.entac_adr_conc_id = adr.adr_id                                                    
      AND    entac.entac_ent_id      IN (SELECT pk FROM #pk)                                                    
      AND    adr.adr_deleted_ind     = 1                                                
      AND    entac.entac_deleted_ind = 1                                                    
                                                    
      --                                                    
      SELECT @l_add1                 = convert(varchar(36),Isnull(add1,''))                                                    
           , @l_add2 = convert(varchar(36),Isnull(add2,''))                                                    
           , @l_add3                = convert(varchar(36),Isnull(add3,''))                                                    
           , @l_add4                 = convert(varchar(36),Isnull(add4,''))                                                    
           , @l_pin                  = convert(varchar(7),Isnull(pin,''))                                                    
      FROM   #addr                                  
      WHERE  code                    = 'PER_ADR1'                                                    
      AND    pk                      = @c_crn_no                                                    
                                                
      --                                                    
  SELECT @l_email                = isnull(convert(varchar(24), value),'')                                                    
      FROM   #conc                                                                         
      WHERE  code                    = 'EMAIL1'                                                    
      AND    pk                      = @c_crn_no                                                    
                                                    
      --                                                    
      SELECT @l_indicator            = 'Y'                                                    
                                                    
      --                                                    
      SELECT @l_tele1      = isnull(convert(varchar(24), value),'')                                                    
      FROM   #conc                                                        
      WHERE  code                    = 'OFF_PH1'                                                    
      AND    pk                      = @c_crn_no                                                    
                 
      --                                                    
      SELECT @l_fax        = isnull(convert(varchar(24), value),'')                                                    
      FROM   #conc                                                                         
      WHERE  code                    = 'FAX1'                                                    
      AND    pk                      = @c_crn_no                                           
                                                    
      --                                             
      SELECT @l_secondemail          = isnull(convert(varchar(50), value),'')                                                    
      FROM   #conc                                                                         
      WHERE  code                    = 'SH_EMAIL1'                                                 
      AND    pk                      = @c_crn_no                                                    
      --                                                    
      SELECT @l_mobile               = isnull(convert(varchar(12), value),'')                                                    
    FROM   #conc                                               
      WHERE  code                    = 'MOBILE1'                                                     
      AND    pk                      = @c_crn_no                                                    
                                                    
      --                                                    
      --SELECT @l_attorney             = ''                                                     
                                                    
      --Second Holder--                                                    
      SELECT @l_sech_name            = Isnull(dphd_sh_fname,'')                                                    
           , @l_sech_fh_name         = Isnull(dphd_sh_fthname,'')                                                    
           , @l_sech_panno          = Isnull(dphd_sh_pan_no,'')                                                    
           , @l_values               = citrus_usr.fn_dp_mig_nsdl_dphd('ADDR',@c_dpam_id,'SH_ADR1')                                                    
           , @l_stele        = isnull(citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'SH_PH1'),'')                                                    
           , @l_sfax                 = isnull(citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'SH_FAX1'),'')                                                    
 FROM   #dp_holder_dtls                                                               
                                                          
      --                                     
      SELECT @l_sadd1                = convert(varchar(36), citrus_usr.fn_splitval(@l_values,1))                                                    
 ,@l_sadd2                = convert(varchar(36), citrus_usr.fn_splitval(@l_values,2))                                                    
            ,@l_sadd3                = convert(varchar(36), citrus_usr.fn_splitval(@l_values,3))                                                    
            ,@l_sadd4                = convert(varchar(36), citrus_usr.fn_splitval(@l_values,4)+' '+citrus_usr.fn_splitval(@l_values,5)+' '+citrus_usr.fn_splitval(@l_values,6))                                                    
            ,@l_spin                 = convert(varchar(7), citrus_usr.fn_splitval(@l_values,7))                                                      
                                                    
      --Third Holder--                                                    
      SELECT @l_values               = ''                                                    
      SELECT @l_thih_name            = Isnull(dphd_th_fname,'')                                                    
           , @l_thih_fh_name         = Isnull(dphd_th_fthname,'')                                                    
           , @l_thih_panno          = Isnull(dphd_th_pan_no,'')                                                    
           , @l_values               = citrus_usr.fn_dp_mig_nsdl_dphd('ADDR',@c_dpam_id,'TH_ADR1')              
           , @l_ttele                = isnull(citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'TH_PH1'),'')                                                    
           , @l_tfax                 = isnull(citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'TH_FAX1'),'')                                                    
      FROM   #dp_holder_dtls                             
      --                                                    
                                                    
      SELECT @l_sebireg              = ''                                                     
                                                    
      --                                                    
      --SELECT @l_values               = ''                                                    
      SELECT @l_tadd1                = convert(varchar(36), citrus_usr.fn_splitval(@l_values,1))         
           , @l_tadd2 = convert(varchar(36), citrus_usr.fn_splitval(@l_values,2))                                                    
           , @l_tadd3     = convert(varchar(36), citrus_usr.fn_splitval(@l_values,3))                                                    
           , @l_tadd4                = convert(varchar(36), citrus_usr.fn_splitval(@l_values,4)+' '+citrus_usr.fn_splitval(@l_values,5)+' '+citrus_usr.fn_splitval(@l_values,6))                                                    
           , @l_tpin                 = convert(varchar(7), citrus_usr.fn_splitval(@l_values,7))                                                      
                                                    
      --                                                    
      SELECT @l_bp_id                = ''                                                       
                                                    
   --                                                    
      SELECT @l_add_pref_flag        = 'Y'                                                    
                                                    
      --                                                    
      SELECT @l_panno                = convert(varchar(30), value) FROM #entity_properties WHERE code = 'PAN_GIR_NO'                                                    
      --                                                    
                                                    
      SELECT @l_bankadd1             = convert(varchar(36),Isnull(add1,''))                                                    
           , @l_bankadd2             = convert(varchar(36),Isnull(add2,''))                                                    
           , @l_bankadd3             = convert(varchar(36),Isnull(add3,''))                                   
           , @l_bankadd4             = convert(varchar(36),Isnull(add4,''))                                                    
           , @l_bankpin              = convert(varchar(7),Isnull(pin,''))                                                    
      FROM   #addr                                                    
      WHERE  code                    = 'PER_ADR1'                                                    
      AND    pk                      = @l_bank_id                                                    
                                                    
      --                                                    
      SELECT @l_banktele             = isnull(convert(varchar(24), value),'')                                                    
      FROM   #conc                     WITH (NOLOCK)                                                    
      WHERE  code    = 'OFF_PH1'                                 
      AND    pk = @l_bank_id                                                    
      --                                                    
      SELECT @l_bankfax              = isnull(convert(varchar(24), value),'')                                      
      FROM   #conc                     WITH (NOLOCK)                                                    
WHERE  code                    = 'FAX1'                                                    
      AND    pk                      = @l_bank_id                                            
      --                                                    
      /*                                               
      SELECT @l_values               = ''                                                    
      SELECT @l_values               = citrus_usr.fn_addr_value(@l_bank_id,'OFF_ADR1')                                                    
      SELECT @l_bankadd1             = convert(varchar(36), citrus_usr.fn_splitval(@l_values,1))                                                    
   , @l_bankadd2             = convert(varchar(36), citrus_usr.fn_splitval(@l_values,2))                                                    
           , @l_bankadd3             = convert(varchar(36), citrus_usr.fn_splitval(@l_values,3))                                                    
           , @l_bankadd4             = convert(varchar(36), citrus_usr.fn_splitval(@l_values,4)+'-'+citrus_usr.fn_splitval(@l_values,5)+'-'+citrus_usr.fn_splitval(@l_values,6))                                                    
           , @l_bankpin              = convert(varchar(7), citrus_usr.fn_splitval(@l_values,7))                                                      
      --                                                    
      SELECT @l_banktele             = convert(varchar(24), citrus_usr.fn_dp_mig_nsdl_conc(@l_bank_id,'OFF_PH1'))                                                    
      --                                                    
      SELECT @l_bankfax              = convert(varchar(24), citrus_usr.fn_dp_mig_nsdl_conc(@l_bank_id,'FAX1'))                                                    
      */                                                    
      --                                                      
      SELECT @l_bankrbi              = convert(varchar(8), value)   FROM #entity_properties    WHERE code = 'RBI_REF_NO'                                                    
      --                                         
      SELECT @l_rbi_appdate          = convert(datetime, value,103) FROM #entity_property_dtls WHERE code1 = 'RBI_REF_NO' and code2 = 'RBI_APP_DT'                                                    
                                                    
      --Nominee--                                                  
      SET @l_values               = ''                                                    
                                                
                                          
                                        
      SELECT @l_nominee                = case when dphd_gau_fname<>'' then Isnull(dphd_gau_fname,'') else Isnull(dphd_nom_fname,'') End                                
             ,@l_nom_gau_nm            = Isnull(dphd_gau_fname,'')                                
             ,@l_nom_fnm               = Ltrim(rtrim(Isnull(dphd_nom_fname,'')))         
--           , @l_nominee_dob          = case WHEN convert(varchar(8), dphd_nom_dob, 3) = '1900-01-01' THEN '' ELSE dphd_nom_dob END                                                              
           , @l_nominee_dob          = CASE WHEN CONVERT(VARCHAR(11),CONVERT(DATETIME,dphd_nom_dob,103),103) = '01/01/1900' THEN '' ELSE REPLACE(CONVERT(VARCHAR(11),CONVERT(DATETIME,dphd_nom_dob,103),103),'/','') END                                      
  
    
     
           , @l_nominee_dob3           = Case WHEN convert(varchar(11), dphd_nom_dob, 3) = '1900-01-01' THEN '' ELSE dphd_nom_dob END                                                              
           -- , @l_nominee_dob         = REPLACE(CONVERT(VARCHAR(11),isnull(dphd_nom_dob,''),102),'.','')                                               
             , @l_values               = citrus_usr.fn_dp_mig_nsdl_dphd('ADDR',@c_dpam_id,'NOMINEE_ADR1')                                                    
           , @l_nomineetele            = isnull(citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'NOMINEE_PH1'),'')                                                    
           , @l_nomineefax             = isnull(citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'NOMINEE_FAX1'),'')                         
      FROM   #dp_holder_dtls           WITH (NOLOCK)                                                    
                                
                                              
      --                                                    
      
      SELECT @l_nomineeadd1          = convert(varchar(36), citrus_usr.fn_splitval(@l_values,1))                                                  
           , @l_nomineeadd2          = convert(varchar(36), citrus_usr.fn_splitval(@l_values,2))                                                    
           , @l_nomineeadd3          = convert(varchar(36), citrus_usr.fn_splitval(@l_values,3))                                                    
           , @l_nomineeadd4          = convert(varchar(36), citrus_usr.fn_splitval(@l_values,4)+' '+citrus_usr.fn_splitval(@l_values,5)+' '+citrus_usr.fn_splitval(@l_values,6))                                                    
           , @l_nomineepin           = convert(varchar(7), citrus_usr.fn_splitval(@l_values,7))                                                      
          
                                              
      SELECT @l_relation             = convert(varchar(36),value) FROM #account_property_dtls WHERE code2 = 'NOMINEE_RELATION'                                                     
      --                                                    
      SELECT @l_upfront              = isnull(case when value = 1 then 'Y' else 'N' end,'N') FROM #account_properties WHERE code = 'UPFRONT'                                                    
      If ltrim(rtrim(isnull(@l_upfront,'') ))             = ''  set @l_upfront = 'N'                                                     
      SELECT @l_keepsettlement       = isnull(case when value = 1 then 'Y' else 'N' end,'N') FROM #account_properties WHERE code = 'KEEPSETTLEMENT'                                                    
      If ltrim(rtrim(isnull(@l_keepsettlement,'') ))              = ''  set @l_keepsettlement = 'N'                                                     
      SELECT @l_fre_trx              = citrus_usr.fn_get_listing_nsdl('TRXFREQ',value)  FROM #account_properties WHERE code = 'TRXFREQ'                                                    
      SELECT @l_fre_hold          = citrus_usr.fn_get_listing_nsdl('HLDNGFREQ',value)  FROM #account_properties WHERE code = 'HLDNGFREQ'                   
      SELECT @l_fre_bill = citrus_usr.fn_get_listing_nsdl('BILLFREQ',value)  FROM #account_properties WHERE code = 'BILLFREQ'                                      
      SELECT @l_allow                = citrus_usr.fn_get_listing_nsdl('ALLOW',value)  FROM #account_properties WHERE code = 'ALLOW'                                                    
      SELECT @l_batchno              = value FROM #account_properties WHERE code = 'BATCHNO'                                                          
      If ltrim(rtrim(@l_batchno))              = 0  set @l_batchno = null                                                   
                                                      
      SELECT @l_first_fh_name        = isnull(dphd_fh_fthname,'') FROM #dp_holder_dtls                                                     
      --                                                          
      SELECT @l_occup               = citrus_usr.fn_get_listing_nsdl('OCCUPATION',value)      FROM #entity_properties     WHERE code = 'OCCUPATION'                                                     
      SELECT @l_secoccup             = citrus_usr.fn_get_listing_nsdl('SH_OCCUPATION',value)      FROM #account_properties    WHERE code = 'SH_OCCUPATION'                                                     
      SELECT @l_thoccup              = citrus_usr.fn_get_listing_nsdl('TH_ACCUPATION',value)      FROM #account_properties    WHERE code = 'TH_ACCUPATION'                                                     
      SELECT @l_chequecash           = citrus_usr.fn_get_listing_nsdl('CHEQUECASH',Isnull(value,''))     FROM #account_properties    WHERE code = 'CHEQUECASH'                                                     
                                                      
      if ltrim(rtrim(isnull(@l_chequecash,''))) = '' set   @l_chequecash =  ''                                                    
                                                
      SELECT @l_chqno                = convert(varchar(10),Isnull(value,''))  FROM #account_properties    WHERE code = 'CHQNO'                                         
      if ltrim(rtrim(isnull(@l_chqno,''))) = '' set   @l_chqno =  ''                  
                                                   
      SELECT @l_recvdate             = Case When @l_chequecash='Q' then convert(datetime,value,103) else '' end FROM #account_property_dtls WHERE code1 = 'CHQNO' AND code2 = 'CHQRCVDATE'                                                    
                                                      
      --SELECT @l_rupees               = convert(money,isnull(value,0.0000))        FROM #account_property_dtls WHERE code1 = 'CHQNO' AND code2 = 'CHQRCVAMT'                                                       
      SELECT @l_rupees               = Case When @l_chequecash='Q' then isnull(convert(numeric(18,4),value),'0.0000') else '0.0000' end  FROM #account_property_dtls WHERE code1 = 'CHQNO' AND code2 = 'CHQRCVAMT'                                            
  
     
     
        
          
            
              
                
      if ltrim(rtrim(isnull(@l_rupees,''))) = '' set   @l_rupees =  convert(numeric(18,4),'0.0000')                                                
                                                
      SELECT @l_drawn                = Case When @l_chequecash='Q' then convert(varchar(50),Isnull(value,'')) else '' end   FROM #account_property_dtls WHERE code1 = 'CHQNO' AND code2 = 'CHQDRAWNON'                                                    
      if ltrim(rtrim(isnull(@l_drawn,''))) = '' set   @l_drawn =  ''                                                    
                                                
      SELECT @l_active               = '06' --default                                                    
                                                    
      --Foreign  Address--                                                    
      SELECT @l_fadd1                = convert(varchar(36),Isnull(add1,''))                                                    
           , @l_fadd2                = convert(varchar(36),Isnull(add2,''))                 
           , @l_fadd3       = convert(varchar(36),Isnull(add3,''))                                               
   , @l_fadd4                = convert(varchar(36),Isnull(add4,''))                                                    
           , @l_fpin                 = convert(varchar(7),Isnull(pin,''))                                                    
      FROM   #addr                                                    
      WHERE  code       = 'FH_ADR1'                                                    
     AND    pk                 = @c_crn_no                                                    
                                                    
      --                                                    
      SELECT @l_ftele                = isnull(convert(varchar(24), value),'')                                                    
      FROM   #conc           WITH (NOLOCK)                                                    
      WHERE  code                    = 'FH_PH1'                                                    
      AND    pk                      = @c_crn_no                                                    
                                                    
      --                                                    
      SELECT @l_ffax                 = isnull(convert(varchar(24), value),'')                                                    
      FROM   #conc  WITH (NOLOCK)                                                    
      WHERE  code                    = 'FH_PH1'                                                    
      AND    pk                      = @c_crn_no                                                    
                                                    
      --                                                    
      SELECT @l_taxstatus            = ''                                                    
                                                    
      --                                                    
      --SELECT @l_nominee_indicator    = 'N'               
                                                
                                  
      --                                                    
      SELECT @l_sigmode              = 'Y'                                                    
                                   
      --First Holder Correspondance--                 
      SELECT @l_cradd1             = convert(varchar(36),isnull(add1,''))                                                    
           , @l_cradd2               = convert(varchar(36),isnull(add2,''))                                                   
           , @l_cradd3               = convert(varchar(36),isnull(add3,''))                                                    
           , @l_cradd4               = convert(varchar(36),isnull(add4,''))                                                    
           , @l_crpin                = convert(varchar(7),isnull(pin,''))                                                    
      FROM   #addr                                                    
      WHERE  code                    = 'COR_ADR1'                                                    
      AND    pk        = @c_crn_no                                                    
                                                    
      --                                                    
      SELECT @l_crtele               = convert(varchar(24), value)                                                    
      FROM   #conc                     WITH (NOLOCK)                                                    
      WHERE  code                    = 'OFF_PH3'                                                    
      AND    pk                      = @c_crn_no                                                    
                                                    
   --                                                    
      SELECT @l_crfax                = convert(varchar(24), value)                                                    
      FROM   #conc                     WITH (NOLOCK)           
      WHERE  code                    = 'FAX3'                                                    
      AND    pk                 = @c_crn_no                                                    
                                                    
      --Introducer Addresses--                                                    
      SELECT @l_introadd1            = convert(varchar(36),Isnull(add1,''))                                              
           , @l_introadd2            = convert(varchar(36),Isnull(add2,''))                                                    
           , @l_introadd3            = convert(varchar(36),Isnull(add3,''))                                                    
           , @l_introadd4            = convert(varchar(36),Isnull(add4,''))                                                    
           , @l_intropin             = convert(varchar(7),Isnull(pin,''))                                                    
      FROM   #addr                                                    
      WHERE  code      = 'INTRO_ADR1'                                                    
      AND    pk                      = @c_crn_no                                                    
                                
      --                                                    
      SELECT @l_authid               = convert(varchar(8), value)  FROM #account_properties    WHERE code = 'AUTHID'                                                    
      SELECT @l_authdt               = convert(datetime, value)  FROM #account_property_dtls WHERE code1 = 'AUTHID' AND code2 = 'AUTHDATE'                                    
      --                                                    
      SELECT @l_mapin                = convert(varchar(10), value) FROM #entity_properties     WHERE code  = 'MAPIN'                                
      SELECT @l_sms                  = CASE WHEN isnull(value,'') <> '' THEN 'Y' ELSE 'N' END  FROM #entity_properties where code  = 'SMS_FLG'                                                        
      --                                  
      SELECT @l_secondmapin          = convert(varchar(10), value) FROM #account_property_dtls WHERE code1 = 'SH_MAPIN' AND code2 = 'SH_MAPIN'                                                     
      SELECT @l_secondsms            = convert(char(1), value)     FROM #account_property_dtls WHERE code1 = 'SH_SMS_FLG' AND code2 = 'SH_SMS_FLG'                         
      If ltrim(rtrim(isnull(@l_secondsms,'') ))              = ''  set @l_secondsms = 'N'                                                    
      SELECT @l_thirdemail           = convert(varchar(50), value) FROM #account_properties    WHERE code = 'TH_EMAIL1'                                                    
      SELECT @l_thirdmapin           = convert(varchar(10), value) FROM #account_property_dtls WHERE code1 = 'TH_MAPIN' AND code2 = 'TH_MAPIN'                                                     
      SELECT @l_thirdsms             = convert(char(1), value)     FROM #account_property_dtls WHERE code1 = 'TH_SMS_FLG' AND code2 = 'TH_SMS_FLG'                                                     
      If ltrim(rtrim(isnull(@l_thirdsms,'') ))   = ''  set @l_thirdsms = 'N'                                         
                                
      --If @l_nominee=''                                         
      --Begin                                         
      --SELECT @l_minor_nominee_indicator = ''                                        
      --End                                                    
      --If  @l_nominee <> ''                                         
      --Begin                                         
      --SELECT @l_minor_nominee_indicator = isnull(convert(char(1), value),'N') FROM #account_property_dtls WHERE code1 = 'NOMINEE_IND' AND code2 = 'NOMINEE_IND'                                     
      --If ltrim(rtrim(isnull(@l_minor_nominee_indicator,'') ))              = ''  set @l_minor_nominee_indicator = 'N'              
      --End                                         
      Declare @l_Nom_dob_year varchar(20)                                
      Select @l_Nom_dob_year = dphd_nom_dob from #dp_holder_dtls with(Nolock)                                
      if @l_nom_gau_nm <> ''                                 
      Begin                                 
      Set @l_minor_nominee_indicator = ''                                      
      Set @l_minor_nominee_guardianaddresspresent=''                          
      End                                  
     if @l_nom_gau_nm = ''                                
     Begin                          
     if  @l_nominee<>''                          
     Begin               
    if (Datepart(year,Getdate())-Datepart(year,convert(varchar(11),@l_Nom_dob_year,105)))<18                                
                Begin                                 
     Set @l_minor_nominee_indicator = 'Y'                                
     Set @l_minor_nominee_guardianaddresspresent='Y'                          
                End                                       
                else                           
                Begin                                        
     Set @l_minor_nominee_indicator = 'N'                                
     Set @l_minor_nominee_guardianaddresspresent='N'                          
                End                                 
      End                          
      else                          
   Begin                           
      Set @l_minor_nominee_indicator = ''                                
      Set @l_minor_nominee_guardianaddresspresent=''                            
   End                          
      End                                
                                      
      --                                                    
      SELECT @l_introtele            = isnull(convert(varchar(24), value),'')                                                    
      FROM   #conc                     WITH (NOLOCK)                                                    
      WHERE  code              = 'INTRO_PH1'                                                    
      AND    pk        = @c_crn_no                                                    
                                                    
      --                                                    
    SELECT @l_introfax             = isnull(convert(varchar(24), value),'')                                     
      FROM   #conc                     WITH (NOLOCK)                                                    
      WHERE  code                    = 'INTRO_FAX1'                                              
      AND    pk                      = @c_crn_no                                                    
                         
      --Nominees Guardian--                                                    
      SELECT @l_values               = ''                                                    
      --                         
      SELECT @l_minor_nominee_guardianname = Isnull(convert(varchar(45), dphd_gau_fname),'')                                                  
           , @l_nominee_dob          = case WHEN convert(varchar(8), dphd_gau_dob, 3) = '1900-01-01' THEN '' ELSE dphd_gau_dob END                                                              
           , @l_values               = citrus_usr.fn_dp_mig_nsdl_dphd('ADDR',@c_dpam_id,'GAU_ADDR1')                                                                                                   
           , @l_minor_nominee_phone  = isnull(citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'GAU_PH1'),'')                                                                                                  
           , @l_minor_nominee_fax    = isnull(citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'GAU_FAX1'),'')                                                                                      
      FROM   #dp_holder_dtls           WITH (NOLOCK)                                                    
    
          
         
      SELECT @l_nominee_indicator    = case when @l_nom_fnm <> '' then 'N' when @l_minor_nominee_guardianname <> '' then 'G' else '' end                                              
          
      
      If @l_nominee_indicator = 'G'      
     Begin           
    SET @l_values                  = ''       
    SELECT @l_values               = citrus_usr.fn_dp_mig_nsdl_dphd('ADDR',@c_dpam_id,'GUARD_ADR')                                                       
    SELECT @l_nomineeadd1          = convert(varchar(36), citrus_usr.fn_splitval(@l_values,1))                                                  
      , @l_nomineeadd2          = convert(varchar(36), citrus_usr.fn_splitval(@l_values,2))                                                    
      , @l_nomineeadd3          = convert(varchar(36), citrus_usr.fn_splitval(@l_values,3))                                                    
      , @l_nomineeadd4          = convert(varchar(36), citrus_usr.fn_splitval(@l_values,4)+' '+citrus_usr.fn_splitval(@l_values,5)+' '+citrus_usr.fn_splitval(@l_values,6))                                                    
      , @l_nomineepin           = convert(varchar(7), citrus_usr.fn_splitval(@l_values,7))                                                            
   End       
       
      
      
      SELECT @l_minor_nominee_add1   = convert(varchar(36), citrus_usr.fn_splitval(@l_values,1))                                                    
      , @l_minor_nominee_add2   = convert(varchar(36), citrus_usr.fn_splitval(@l_values,2))                                                    
           , @l_minor_nominee_add3   = convert(varchar(36), citrus_usr.fn_splitval(@l_values,3))                                                    
           , @l_minor_nominee_add4   = convert(varchar(36), citrus_usr.fn_splitval(@l_values,4)+' '+citrus_usr.fn_splitval(@l_values,5)+' '+citrus_usr.fn_splitval(@l_values,6))                                                    
           , @l_minor_nominee_pin    = convert(varchar(7), citrus_usr.fn_splitval(@l_values,7))                                                      
      --                                      
      --FOR NOMINEES GUARDIAN                                      
      select @l_values = ''                                      
      select @l_minor_nominee_guardianname1 = Isnull(convert(varchar(45), dphd_nomgau_fname),'')                                                     
           , @l_nominee_dob1          = case WHEN convert(varchar(8), dphd_nomgau_dob, 3) = '1900-01-01' THEN '' ELSE dphd_nomgau_dob END                                                              
           , @l_values               = citrus_usr.fn_dp_mig_nsdl_dphd('ADDR',@c_dpam_id,'NOM_GUARDIAN_ADDR')            
                                                   
           , @l_minor_nominee_phone1   = isnull(citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'NOM_GUARD_MOB'),'')                                                    
                                                   
           , @l_minor_nominee_fax1    = isnull(citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'NOM_GUARD_FAX'),'')                                    
                                                   
      FROM   #dp_holder_dtls           WITH (NOLOCK)                                                    
      --                                      
      SELECT @l_minor_nominee_address1   = convert(varchar(36), citrus_usr.fn_splitval(@l_values,1))                            
           ,@l_minor_nominee_address2   = convert(varchar(36), citrus_usr.fn_splitval(@l_values,2))                                                    
           , @l_minor_nominee_address3   = convert(varchar(36), citrus_usr.fn_splitval(@l_values,3))                                                    
           , @l_minor_nominee_address4   = convert(varchar(36), citrus_usr.fn_splitval(@l_values,4)+' '+citrus_usr.fn_splitval(@l_values,5)+' '+citrus_usr.fn_splitval(@l_values,6))                                                    
           , @l_minor_nominee_pincode   = convert(varchar(7), citrus_usr.fn_splitval(@l_values,7))                                 
      --                                      
      SELECT @l_minor_nominee_guardianaddresspresent1 = CASE WHEN ISNULL(value,'FALSE') = 'TRUE' THEN 'Y' ELSE 'N' END  FROM #account_property_dtls WHERE code2 = 'NOMINEE_GUARDIAN_ADR_YN'                                                     
      If ltrim(rtrim(isnull(@l_minor_nominee_guardianaddresspresent1,'') ))              = ''  set @l_minor_nominee_guardianaddresspresent1 = 'N'                                                      
      --                                    
                                          
      --                                      
                                                  
      SELECT @l_uploadtonsdl         = CASE WHEN ISNULL(value,'FALSE') = 'TRUE' THEN 'Y' ELSE 'N' END  FROM #account_properties  WHERE code = 'UPLOAD_TO_NSDL'                                                    
      If ltrim(rtrim(isnull(@l_uploadtonsdl,'') ))       = ''  set @l_uploadtonsdl = 'N'                                                    
      --                                            
      SELECT @l_sh_panflag           = CASE WHEN ISNULL(dphd_sh_pan_no,'N') = '' THEN 'N' ELSE 'Y' END                                      
           , @l_th_panflag           = CASE WHEN ISNULL(dphd_th_pan_no,'N') = '' THEN 'N' ELSE 'Y' END                                                     
      FROM   #dp_holder_dtls                                                            
      --                                                    
      SELECT @l_fh_panflag           = CASE WHEN isnull(value,'N')='' THEN 'N' ELSE 'Y' END FROM #entity_properties WHERE code = 'PAN_GIR_NO'                                   
      If ltrim(rtrim(isnull(@l_fh_panflag,'') ))              = ''  set @l_fh_panflag = 'N'                                  
      If ltrim(rtrim(isnull(@l_sh_panflag,'') ))              = ''  set @l_sh_panflag = 'N'                                                    
      If ltrim(rtrim(isnull(@l_th_panflag,'') ))              = ''  set @l_th_panflag = 'N'                                                    
                                                    
      --               
      SELECT @l_inwarddt             = ''                                                    
      SELECT @l_remissier            = ''                                                    
      SELECT @l_remissierscheme      = ''                                                    
      SELECt @l_blsavingcd           = convert(varchar(20), value) FROM #entity_properties WHERE code = 'BBO_CODE'                                                    
      --                                                    
      --SELECT @l_chgsscheme           = convert(clidb_brom_id FROM client_dp_brkg WITH (NOLOCK) WHERE clidb_dpam_id = @c_dpam_id AND clidb_deleted_ind = 1                                                    
      --                                                 
      SELECT @l_chgsscheme           = ISNULL(convert(char(10), brom_desc),'GENERAL')                                                    
      FROM   client_dp_brkg            WITH (NOLOCK)                                                     
           , brokerage_mstr            WITH (NOLOCK)                                                     
      WHERE  clidb_dpam_id           = @c_dpam_id                                                     
      AND    clidb_brom_id           = brom_id                                                    
      AND    clidb_deleted_ind       = 1                                                    
      AND    brom_deleted_ind        = 1                                                       
      --                                                    
      SELECT @l_billcycle            = convert(char(1), value) FROM #entity_properties WHERE code = 'BILLC'                                                    
      SELECT @l_groupcd              = 'ZZZ'                                         
      SELECT @l_familycd             = 'ZZZ'                                                    
      SELECT @l_introducer          = isnull(convert(varchar(30),value),'') FROM #account_properties WHERE code = 'INTRODUCER'                                                    
      SELECT @l_statements           = 'B'                                                    
      SELECT @l_billflag             = Isnull(Substring(convert(char(1),value),1,1),'') FROM #account_properties WHERE code = 'BILLFLG'                                             
      SELECT @l_instrno              = convert(varchar(8), @c_sba_no) --changed_by tushar                                                     
      SELECT @l_allowcredit          = '0.0000'                                                    
      SELECT @l_billcode             = ''                                                    
      SELECT @l_collectioncode       = ''                                                    
      --SELECT @l_boff_clienttype      = '01' -- may be listing                                                     
      --                                                    
      SELECT @l_cmcd                 = '' --convert(varchar(8), @c_acct_no)                                                    
      SELECT @l_poaforpayin          = case WHEN clidpa_flg & 1 = 1 THEN 'Y' ELSE 'N' END from client_dp_accts where clidpa_clisba_id = @c_dpam_id                                                    
 --                                                 
      select distinct @l_brcode = citrus_usr.Fn_FormatStr(entp_value,6,0,'L','0')          
      FROM   entity_mstr             
            ,entity_relationship      
            ,entity_properties      
            ,entity_property_mstr       
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
      AND entr_crn_no   = @c_crn_no      
      AND entp_ent_id   = entm_id      
      AND entpm_prop_id = entp_entpm_prop_id      
      AND entpm_cd      = 'LC'            
      AND entm_enttm_cd = 'BR'                                                   
      --       
      if isnull(@l_brcode,'') = ''      
      set @l_brcode ='000000'      
       
                                               
      SELECT @l_brboffcode           = isnull(@l_brcode,'000000')    --manju told assign branch code                                                    
      --                                                    
      IF exists(select * from client_export_nsdl_hst where cx_dpam_id = @c_dpam_id and cx_e_cmpltd = 1)                                                    
      BEGIN                                                    
      --                                                    
        SET @l_modified = 'U'                                                    
      --                       
      END                                                    
      ELSE                                       
      BEGIN                                                    
      --                                                    
        SET @l_modified = 'I'                                                    
      --                                                    
      END                                                    
                                                    
if ltrim(rtrim(isnull(@l_fh_panflag,'') ))              = ''  set @l_fh_panflag = 'N'                                                     
if ltrim(rtrim(isnull(@l_sh_panflag,'') ))              = ''  set @l_sh_panflag = 'N'                        
if ltrim(rtrim(isnull(@l_th_panflag,'') ))              = ''  set @l_th_panflag = 'N'                                                     
if ltrim(rtrim(isnull(@l_uploadtonsdl,'')))            = ''  set @l_uploadtonsdl= 'N'                                                     
                                                    
                                                    
                                                    
      if exists(select * from client_export_nsdl where cx_dpam_id =@c_dpam_id and cx_e_cmpltd = 0)                                                    
      begin                                                    
      --                                                    
        delete from client_export_nsdl where cx_dpam_id =@c_dpam_id and cx_e_cmpltd = 0                                                    
                   
                                                               
                                        
    INSERT INTO client_export_nsdl VALUES                                                    
        (isnull(@l_brcode,'000000')                                                                                  
        ,@l_name                                                                                     
        ,@l_sname                                                  
        ,@l_add1                                                                                     
        ,@l_add2                                                                                     
        ,@l_add3                                                                                     
        ,@l_add4                                           
        ,@l_pin                                                                                      
        ,@l_email                                                                                    
        ,@l_indicator                                                                                
        ,@l_first_fh_name                                                                            
        ,@l_tele1                        
        ,@l_fax                                                                                      
        ,@l_mobile                                                                                   
        ,@l_attorney                                                                                 
        ,@l_sech_name                                                                                
        ,@l_sech_fh_name                         
        ,@l_sadd1                                                                          
        ,@l_sadd2                                                                                    
        ,@l_sadd3                                                                      
        ,@l_sadd4                                                                                    
        ,@l_spin                                                                                     
        ,@l_stele                                                                                    
        ,@l_sfax                                                                                     
        ,@l_thih_name                                                                                
        ,@l_thih_fh_name                                                                             
        ,@l_tadd1                                                                                    
        ,@l_tadd2                                                                                    
        ,@l_tadd3                                        
        ,@l_tadd4                                                             
        ,@l_tpin                                                                        
        ,@l_ttele                                                                                    
        ,@l_tfax                                                      
        ,@l_bp_id                                                                                      ,@l_add_pref_flag                                                                            
        ,@l_bankname                                                                                 
        ,@l_bankbranch                                                          
        ,@l_bankadd1                                                                   
        ,@l_bankadd2                                                                                 
  ,@l_bankadd3                                                                                 
        ,@l_bankadd4   
        ,@l_bankpin                                                                                  
        ,@l_banktele                                                                                 
        ,@l_bankfax                                                                              
        ,@l_bankrbi                                                  
        ,@l_rbi_appdate                                                                              
        ,@l_bankactno              
        ,@l_bankacttype                                                                              
        ,@l_micr                                                                                     
        ,@l_panno                                                                                    
        ,@l_sech_panno                                                                               
        ,@l_thih_panno                
        ,@l_sebireg                                                                                  
        ,@l_taxstatus                                                                                
        ,@l_nominee_indicator                                                                        
        ,@l_sigmode                                                                          
        ,@l_nominee                                                                                  
        ,@l_nominee_dob3                                                                                                                                                                                                 
        ,@l_nomineeadd1                                                                              
        ,@l_nomineeadd2                                                              
        ,@l_nomineeadd3                                                                              
        ,@l_nomineeadd4                                     
        ,@l_nomineepin                                            
        ,@l_nomineetele                                                 
        ,@l_nomineefax                                                                               
        ,@l_relation                                                                                 
        ,@l_clienttype                                                                               
        ,@l_occup          
        ,@l_secoccup                                                                                 
        ,@l_thoccup                                                                                  
        ,@l_chequecash                                                                               
        ,@l_chqno                                                                                 
        ,@l_recvdate                                                                                 
        ,@l_rupees                                                                                   
        ,@l_drawn                                                                                    
        ,@l_acctype                                                                                  
        ,@l_active                                                                              
        ,@l_chgsscheme                        
        ,@l_billcycle                                                                        
 ,@l_brboffcode                                                                               
        ,@l_groupcd                                                                                  
        ,@l_familycd                                                                                 
        ,@l_introducer                                     
        ,@l_statements                                                                               
        ,@l_billflag                                                                           
        ,@l_instrno                                                                                  
        ,@l_allowcredit                                                                              
        ,@l_billcode                                                                                 
        ,@l_collectioncode                                                                           
        ,@l_upfront                                                                                  
        ,@l_keepsettlement                                                                           
        ,@l_fre_trx                                  
        ,@l_fre_hold                                            
        ,@l_fre_bill                                                                                 
        ,@l_allow                                             
        ,@l_batchno                           
        ,@l_cmcd                                                                                     
        ,@l_boff_clienttype                                 
        ,@l_fadd1                                                                                    
        ,@l_fadd2                                                                                    
        ,@l_fadd3                                                                                    
        ,@l_fadd4                                                                                    
        ,@l_fpin                                                                                     
        ,@l_ftele                                                                            
        ,@l_ffax                                                                                     
        ,@l_cradd1                                                                                   
        ,@l_cradd2                                                                                   
        ,@l_cradd3                                                                                   
        ,@l_cradd4                                      ,@l_crfax                                                                                    
        ,@l_crpin                                                   
        ,@l_crtele                                                                                   
        ,@l_introadd1                                 
        ,@l_introadd2                                                                                
  ,@l_introadd3                                                                 
        ,@l_introadd4                                                                                
        ,@l_introfax                                                                                 
        ,@l_intropin                                                                                 
        ,@l_introtele                                                                                
        ,@l_blsavingcd                                                                               
        ,@l_mkrdt                                                                                       
        ,@l_mkrid                                                                                       
        ,@l_authid                                                                                   
        ,@l_authdt                                                                     
        ,@l_remark                                                                           
        ,@l_inwarddt                                   
,@l_PoaForPayin                                                                              
        ,@l_remissier                                                                                
        ,@l_remissierscheme                                                                   
        ,@l_mapin                                                                  
        ,@l_sms                                                                                      
        ,@l_secondemail                                                                              
        ,@l_secondmapin                                                                              
        ,@l_secondsms                                                    
        ,@l_thirdemail                                                                               
        ,@l_thirdmapin                                                                               
        ,@l_thirdsms                                                                                 
       ,@l_minor_nominee_indicator                                                                  
        ,@l_minor_nominee_guardianname1   --@l_minor_nominee_guardianname                   
        ,@l_minor_nominee_address1   --@l_minor_nominee_add1                                               
        ,@l_minor_nominee_address2    --@l_minor_nominee_add2                                                                       
        ,@l_minor_nominee_address3     --@l_minor_nominee_add3                                                                       
        ,@l_minor_nominee_address4      --@l_minor_nominee_add4                                                                       
        ,@l_minor_nominee_pincode       --@l_minor_nominee_pin                                                                        
        ,@l_minor_nominee_phone1        --@l_minor_nominee_phone                                                                      
        ,@l_minor_nominee_fax1          --@l_minor_nominee_fax                                                                        
        ,@l_minor_nominee_guardianaddresspresent      --@l_minor_nominee_guardianaddresspresent                                                     
        ,@l_uploadtonsdl                                                                             
       ,@l_fh_panflag   ,@l_sh_panflag                                                                               
        ,@l_th_panflag                                                    
        ,@l_modified                                                    
        ,0                                    
        ,@c_dpam_id                                                    
        )                            
        --                                                    
   SET @l_brcode  = ''                                                                                
        SET @l_name   = ''                                                                                                                
        SET @l_sname  = ''                                                                                                                
        SET @l_add1  = ''                                                                                                                 
        SET @l_add2  = ''                                                                                                                 
        SET @l_add3   = ''                                                    
        SET @l_add4   = ''                                                                                               
        SET @l_pin  = ''                                                                                                              
        SET @l_email  = ''                                   
        SET @l_indicator   = ''                                                   
        SET @l_first_fh_name   = ''                                                     
        SET @l_tele1  = ''                                                    
        SET @l_fax   = ''                                                                                           
        SET @l_mobile    = ''                                                                                                             
        SET @l_attorney   = ''                                                                                                            
        SET @l_sech_name   = ''                                                                                                           
        SET @l_sech_fh_name  = ''                                                    
        SET @l_sadd1   = ''                                                                                    
        SET @l_sadd2    = ''                                                                                   
        SET @l_sadd3    = ''                                                                                   
        SET @l_sadd4    = ''                                                                                   
        SET @l_spin    = ''                                                                                    
   SET @l_stele    = ''                                   
        SET @l_sfax    = ''                                                                
        SET @l_thih_name    = ''                                                                               
        SET @l_thih_fh_name    = ''                                                                            
  SET @l_tadd1    = ''                                                                                   
        SET @l_tadd2   = ''                                                                                    
        SET @l_tadd3   = ''                                                                                    
        SET @l_tadd4    = ''                                                                                   
        SET @l_tpin   = ''                                                                                     
        SET @l_ttele    = ''                                                                                   
        SET @l_tfax    = ''                                       
        SET @l_bp_id    = ''                                                                                   
        SET @l_add_pref_flag     = ''                                                                          
        SET @l_bankname    = ''                                                                                
        SET @l_bankbranch    = ''                     
        SET @l_bankadd1    = ''                                                                                
        SET @l_bankadd2    = ''                                                                            
        SET @l_bankadd3     = ''                                                                               
        SET @l_bankadd4   = ''                                                                                
        SET @l_bankpin    = ''                                                                                
        SET @l_banktele     = ''                                                                      
        SET @l_bankfax    = ''                                                                                 
    SET @l_bankrbi    = ''                                                                                 
        SET @l_rbi_appdate     = ''                                                                            
        SET @l_bankactno     = ''                                                                              
        SET @l_bankacttype     = ''                                                                            
    SET @l_micr     = ''                                                                                   
        SET @l_panno     = ''               
        SET @l_sech_panno     = ''                                                                             
        SET @l_thih_panno    = ''                                                                             
        SET @l_sebireg    = ''                                                      
        SET @l_taxstatus     = ''                                  
        SET @l_nominee_indicator     = ''                                                                      
        SET @l_sigmode     = ''                                                                                
        SET @l_nominee     = ''                                                                                
        SET @l_nominee_dob3    = ''                                                                                                                                                                                               
        SET @l_nomineeadd1     = ''                                                                           
        SET @l_nomineeadd2    = ''                                               
        SET @l_nomineeadd3    = ''                                                                             
        SET @l_nomineeadd4    = ''                                                                     
        SET @l_nomineepin    = ''                                                                            
        SET @l_nomineetele    = ''                  
        SET @l_nomineefax     = ''                                                
        SET @l_relation     = ''                                                                               
        SET @l_clienttype    = ''                                                                              
        SET @l_occup       = ''                                                                                
        SET @l_secoccup     = ''                                                                              
        SET @l_thoccup       = ''                                                                              
        SET @l_chequecash      = ''                                                                            
        SET @l_chqno     = ''                                                                                  
        SET @l_recvdate     = ''                                                               SET @l_rupees     = 0                                                                                
        SET @l_drawn     = ''                                                                                  
SET @l_acctype    = ''                                                                                
        SET @l_active     = ''                       
        SET @l_chgsscheme     = ''                                                                             
        SET @l_billcycle     = ''                                                                              
        SET @l_brboffcode     = ''                                                                             
        SET @l_groupcd     = ''                                                                                
        SET @l_familycd      = ''                                                                              
SET @l_introducer    = ''                                           
        SET @l_statements    = ''                                                             
        SET @l_billflag    = ''                                                                   
        SET @l_instrno    = ''                                                                                 
        SET @l_allowcredit    = 0                                                                             
        SET @l_billcode     = ''                                                                               
        SET @l_collectioncode    = ''                                         
        SET @l_upfront      = ''                                                                               
        SET @l_keepsettlement   = ''                                                                           
        SET @l_fre_trx    = ''                                                     
        SET @l_fre_hold   = ''                                                                                
        SET @l_fre_bill   = ''                                                                                 
        SET @l_allow     = ''                                     
        SET @l_batchno    = ''                                                                                 
        SET @l_cmcd    = ''                                                                                    
        SET @l_boff_clienttype    = ''                                                                        
        SET @l_fadd1    = ''                                                                                   
        SET @l_fadd2   = ''                                                                                    
        SET @l_fadd3     = ''                                                                                  
        SET @l_fadd4    = ''                                                                                   
        SET @l_fpin     = ''                                                                                   
        SET @l_ftele    = ''                                                                                   
        SET @l_ffax    = ''                                                                                    
        SET @l_cradd1    = ''                                                           
        SET @l_cradd2    = ''                                                               
        SET @l_cradd3    = ''                                                                                  
        SET @l_cradd4    = ''                                                                                  
        SET @l_crfax     = ''                                                                                  
        SET @l_crpin     = ''                                                                                  
        SET @l_crtele    = ''                                                                                  
        SET @l_introadd1    = ''                               
        SET @l_introadd2    = ''                                                                               
        SET @l_introadd3   = ''                        
        SET @l_introadd4    = ''                                                 
        SET @l_introfax   = ''                                                                                 
     SET @l_intropin   = ''                                                                                 
        SET @l_introtele    = ''                                                                         
        SET @l_blsavingcd    = ''                                                                              
        SET @l_mkrdt    = ''                                                          
        SET @l_mkrid    = ''                                                                                      
        SET @l_authid    = ''                                                                                  
        SET @l_authdt   = ''                                                                                   
        SET @l_remark    = ''                                                                                  
        SET @l_inwarddt    = ''                                                                                
 SET @l_PoaForPayin    = ''                                                                             
        SET @l_remissier   = ''                                                                                
        SET @l_remissierscheme    = ''                                                                         
  SET @l_mapin   = ''                                                          
        SET @l_sms   = ''                                                                                      
        SET @l_secondemail   = ''                                                                              
        SET @l_secondmapin   = ''                                                                              
        SET @l_secondsms   = ''                                                                                
        SET @l_thirdemail   = ''                                                                               
        SET @l_thirdmapin   = ''                                                                               
        SET @l_thirdsms   = ''                 
        SET @l_minor_nominee_indicator   = ''                                                           
        SET @l_minor_nominee_guardianname =''    
        SET @l_minor_nominee_guardianname1= ''   --@l_minor_nominee_guardianname   = ''                                                               
        SET @l_minor_nominee_address1= ''             --@l_minor_nominee_add1   = ''                                                  
        SET @l_minor_nominee_address2= ''          --@l_minor_nominee_add2   = ''       
        SET @l_minor_nominee_address3= ''          --@l_minor_nominee_add3   = ''                                                                       
        SET @l_minor_nominee_address4= ''           --@l_minor_nominee_add4  = ''                                                                      
        SET @l_minor_nominee_pincode= ''            --@l_minor_nominee_pin   = ''                                                                        
        SET @l_minor_nominee_phone1= ''             --@l_minor_nominee_phone    = ''                                      
        SET @l_minor_nominee_fax1= ''                --@l_minor_nominee_fax   = ''                                                                        
        SET @l_minor_nominee_guardianaddresspresent1= ''       --@l_minor_nominee_guardianaddresspresent    = ''                                                    
        SET @l_minor_nominee_guardianaddresspresent = ''    
        SET @l_uploadtonsdl   = ''                                                                             
        SET @l_fh_panflag     = ''                                                                             
        SET @l_sh_panflag  = ''                                  
        SET @l_th_panflag   = ''                                                    
        SET @l_nom_gau_nm = ''      
        Set @l_nom_fnm    = ''       
        SET @l_modified   = ''                                                    
      --                                                    
      END                                                    
      else                                                    
      begin                                                    
      --                                                    
        INSERT INTO client_export_nsdl VALUES                                                    
        (isnull(@l_brcode,'000000')                                                                             
        ,@l_name                                         
        ,@l_sname                                                                                    
        ,@l_add1                                                                                     
        ,@l_add2                                                                                     
        ,@l_add3                                                                                     
        ,@l_add4                                                                                    
        ,@l_pin                                                                                      
        ,@l_email                                                                                    
        ,@l_indicator                                      
        ,@l_first_fh_name                                                                            
        ,@l_tele1                                                       
        ,@l_fax                                                                                      
        ,@l_mobile                                                                                   
        ,@l_attorney                                                                                 
        ,@l_sech_name                                                                                
        ,@l_sech_fh_name                                                                             
        ,@l_sadd1                                                                                    
        ,@l_sadd2                                                                                    
        ,@l_sadd3                                                                               
        ,@l_sadd4                                                                                    
        ,@l_spin                                                                                     
        ,@l_stele                                                                      
        ,@l_sfax                                                                                     
  ,@l_thih_name                                                                                
        ,@l_thih_fh_name                                                                             
        ,@l_tadd1                                                                                    
   ,@l_tadd2                                                                                    
        ,@l_tadd3                                                                                    
        ,@l_tadd4                                                                                    
,@l_tpin                                                                                     
        ,@l_ttele                                                                                    
        ,@l_tfax                                                                                     
        ,@l_bp_id                                                                                   
        ,@l_add_pref_flag                                                                         
        ,@l_bankname                                                                          
        ,@l_bankbranch                                                                               
 ,@l_bankadd1                                                                                 
        ,@l_bankadd2                                                                                 
        ,@l_bankadd3                                                                                 
        ,@l_bankadd4                                                                                 
        ,@l_bankpin                                                                                  
        ,@l_banktele                                                                                 
,@l_bankfax                                                                                  
        ,@l_bankrbi                                                                                  
  ,@l_rbi_appdate                                                                              
   ,@l_bankactno                                                                                
        ,@l_bankacttype                                                                              
        ,@l_micr                                     
        ,@l_panno                                                                                    
        ,@l_sech_panno                                                                               
        ,@l_thih_panno                                                                               
        ,@l_sebireg                                                                                  
        ,@l_taxstatus                                                                                
        ,@l_nominee_indicator                                                                        
        ,@l_sigmode                                           
        ,@l_nominee                                                                                  
        ,@l_nominee_dob3                                                                 
        ,@l_nomineeadd1                                                                              
        ,@l_nomineeadd2                                                                              
        ,@l_nomineeadd3                                  
        ,@l_nomineeadd4                                                                     
        ,@l_nomineepin                                                                               
        ,@l_nomineetele                                                                              
        ,@l_nomineefax                                                                               
        ,@l_relation                                                                                 
        ,@l_clienttype                                                                               
        ,@l_occup                                                                   
        ,@l_secoccup                                                                                 
        ,@l_thoccup                                      
        ,@l_chequecash                                                                               
        ,@l_chqno                                                                                    
        ,@l_recvdate                                                                  
        ,@l_rupees                                                                                   
        ,@l_drawn                                                                                    
        ,@l_acctype                                                                                  
        ,@l_active                                                                                   
        ,@l_chgsscheme                                                                               
        ,@l_billcycle                                                                             
        ,@l_brboffcode                                      
        ,@l_groupcd                                                                                  
        ,@l_familycd                                                                                 
        ,@l_introducer                                                                               
        ,@l_statements                                                                               
        ,@l_billflag                                                                   
        ,@l_instrno                                                                                  
        ,@l_allowcredit                                                                              
        ,@l_billcode                                              
        ,@l_collectioncode                                                                           
        ,@l_upfront                                                                                  
       ,@l_keepsettlement                                                                   
        ,@l_fre_trx                                                                           
        ,@l_fre_hold                                                                                 
        ,@l_fre_bill                                                   
        ,@l_allow                                                                                    
        ,@l_batchno                                                                                  
        ,@l_cmcd                                                                                     
        ,@l_boff_clienttype                                                                          
        ,@l_fadd1                                                                                    
        ,@l_fadd2                                                                                    
        ,@l_fadd3                                   
      ,@l_fadd4                                                                                    
        ,@l_fpin                                                                                     
        ,@l_ftele                                                                                    
        ,@l_ffax                                                                                     
        ,@l_cradd1                                                                                   
        ,@l_cradd2                                                                 
        ,@l_cradd3                                                                                   
        ,@l_cradd4                                                                                   
        ,@l_crfax                                                            
        ,@l_crpin                                                                                    
        ,@l_crtele                                                
        ,@l_introadd1                                                                                
        ,@l_introadd2                                                                                
        ,@l_introadd3                                                                                
        ,@l_introadd4                                                                            
        ,@l_introfax                                                                                 
       ,@l_intropin                                                                                 
        ,@l_introtele                                                                                
        ,@l_blsavingcd                                                                               
        ,@l_mkrdt                                                                                       
        ,@l_mkrid                                                                        
        ,@l_authid                                                  
        ,@l_authdt                                                                                   
        ,@l_remark                                                                                   
        ,@l_inwarddt              
        ,@l_PoaForPayin                                                                              
        ,@l_remissier                                                                                
        ,@l_remissierscheme                                                                          
        ,@l_mapin                                                                                    
        ,@l_sms                                                                                      
        ,@l_secondemail                                       
        ,@l_secondmapin                 
        ,@l_secondsms                                                                                
        ,@l_thirdemail                                                                               
        ,@l_thirdmapin                                                                               
        ,@l_thirdsms                                                                           
        ,@l_minor_nominee_indicator                                                                  
        , @l_minor_nominee_guardianname1   --@l_minor_nominee_guardianname   = ''                                                               
        , @l_minor_nominee_address1             --@l_minor_nominee_add1   = ''                                              
        , @l_minor_nominee_address2          --@l_minor_nominee_add2   = ''                                                                       
        , @l_minor_nominee_address3          --@l_minor_nominee_add3   = ''                                                                       
        , @l_minor_nominee_address4           --@l_minor_nominee_add4  = ''         
        , @l_minor_nominee_pincode            --@l_minor_nominee_pin   = ''                                                                        
        , @l_minor_nominee_phone1             --@l_minor_nominee_phone    = ''                                                                    
        , @l_minor_nominee_fax1             --@l_minor_nominee_fax   = ''                                                                        
        , @l_minor_nominee_guardianaddresspresent       --@l_minor_nominee_guardianaddresspresent    = ''                                                    
        ,@l_uploadtonsdl                                                        
        ,@l_fh_panflag                                            
        ,@l_sh_panflag                                         
        ,@l_th_panflag                                                    
        ,@l_modified                                                    
        ,0                      
        ,@c_dpam_id                                                    
        )                                                    
        --                                                    
        SET @l_brcode  = ''                                                    
        SET @l_name   = ''                                                                                                                
        SET @l_sname  = ''                                                                                                                
        SET @l_add1  = ''                                                        
        SET @l_add2  = ''                  
        SET @l_add3   = ''                                                                                                                            
        SET @l_add4   = ''                                                
        SET @l_pin  = ''                                                                                                                 
        SET @l_email  = ''                                                                                                                
        SET @l_indicator   = ''                                                                                                           
        SET @l_first_fh_name   = ''                                                                                                       
        SET @l_tele1  = ''                                                                                              
        SET @l_fax   = ''                                                                                                                 
        SET @l_mobile    = ''                                                                                                             
        SET @l_attorney   = ''                                                                                                            
        SET @l_sech_name   = ''                                                                                                           
        SET @l_sech_fh_name  = ''                                                                                                         
   SET @l_sadd1   = ''                                                                                    
        SET @l_sadd2    = ''                                                
        SET @l_sadd3    = ''                                                                                   
        SET @l_sadd4    = ''                                                                                   
        SET @l_spin    = ''                                                                                    
        SET @l_stele    = ''                                                                                   
        SET @l_sfax    = ''                                                                                    
        SET @l_thih_name    = ''                                                                               
        SET @l_thih_fh_name    = ''                                                                    
        SET @l_tadd1    = ''                                                                                   
        SET @l_tadd2   = ''                                                                                    
        SET @l_tadd3   = ''                                                                                   
        SET @l_tadd4    = ''                                                                                   
        SET @l_tpin   = ''                                                                                     
        SET @l_ttele    = ''                                                                                   
        SET @l_tfax    = ''                                                                                    
        SET @l_bp_id    = ''                                  
        SET @l_add_pref_flag     = ''                                                                          
        SET @l_bankname    = ''                                                                                
        SET @l_bankbranch    = ''                                                                             
     SET @l_bankadd1    = ''                                                                                
        SET @l_bankadd2    = ''                                                                                
        SET @l_bankadd3     = ''                                                   
        SET @l_bankadd4    = ''                                                                                
        SET @l_bankpin    = ''                                                                       
        SET @l_banktele  = ''                                              
        SET @l_bankfax    = ''                                                                                 
        SET @l_bankrbi    = ''                                                                                 
        SET @l_rbi_appdate   = ''                                                                 
SET @l_bankactno     = ''                                                                           
        SET @l_bankacttype     = ''                                                                            
        SET @l_micr     = ''                                                             
        SET @l_panno     = ''                                                                                  
        SET @l_sech_panno     = ''                                                      
        SET @l_thih_panno    = ''                                       
  SET @l_sebireg    = ''                                                                                
        SET @l_taxstatus     = ''                                                                             
        SET @l_nominee_indicator     = ''                                                                      
        SET @l_sigmode     = ''                                             
        SET @l_nominee     = ''                                                                                
        SET @l_nominee_dob3    = ''                                                                                                                                                                                               
        SET @l_nomineeadd1     = ''                                                                           
        SET @l_nomineeadd2    = ''                                                                           
        SET @l_nomineeadd3    = ''                                                                             
        SET @l_nomineeadd4    = ''                                                                            
        SET @l_nomineepin    = ''                                                                            
        SET @l_nomineetele    = ''                                                                             
        SET @l_nomineefax     = ''                                                                             
        SET @l_relation     = ''                                                                               
        SET @l_clienttype    = ''                                                                              
        SET @l_occup       = ''                                                                    
        SET @l_secoccup     = ''                                                                              
        SET @l_thoccup       = ''                                                                              
        SET @l_chequecash      = ''                                  
        SET @l_chqno     = ''                                                                                  
        SET @l_recvdate     = ''                                                                      
        SET @l_rupees     = 0                                                                                
        SET @l_drawn     = ''                                                                                  
        SET @l_acctype    = ''                                                                                
        SET @l_active     = ''                                                                         
        SET @l_chgsscheme     = ''                                                                             
        SET @l_billcycle     = ''                                                                              
        SET @l_brboffcode     = ''                                                                             
      SET @l_groupcd     = ''                                                                                
        SET @l_familycd      = ''                                                                              
        SET @l_introducer    = ''                                                                              
        SET @l_statements    = ''                                                         
        SET @l_billflag    = ''                                                                               
        SET @l_instrno    = ''                                                                                 
        SET @l_allowcredit    = 0                                                                             
        SET @l_billcode     = ''                                                                               
        SET @l_collectioncode    = ''                                                                          
        SET @l_upfront      = ''                                                                               
        SET @l_keepsettlement   = ''                                                                      
        SET @l_fre_trx    = ''                                                                                
        SET @l_fre_hold   = ''                                                         
        SET @l_fre_bill   = ''                                            
        SET @l_allow     = ''                                                                                  
        SET @l_batchno    = ''                                                                                 
        SET @l_cmcd    = ''                             
        SET @l_boff_clienttype    = ''                                                                        
        SET @l_fadd1    = ''                                                                                   
        SET @l_fadd2   = ''                                                                                    
        SET @l_fadd3     = ''                                 
        SET @l_fadd4    = ''                                                                                   
        SET @l_fpin     = ''                                                                                   
        SET @l_ftele    = ''                                                                                   
        SET @l_ffax  = ''                 
SET @l_cradd1    = ''                                                                                  
        SET @l_cradd2    = ''                                                                                  
        SET @l_cradd3    = ''                                                                                  
        SET @l_cradd4    = ''                                                                                  
        SET @l_crfax     = ''                                                                                 
        SET @l_crpin     = ''                                                            
        SET @l_crtele    = ''                                                                                  
        SET @l_introadd1    = ''          
        SET @l_introadd2    = ''                                                                               
        SET @l_introadd3   = ''                                                                                
        SET @l_introadd4    = ''                                                                    
        SET @l_introfax   = ''                                                                                 
        SET @l_intropin   = ''                                                                                 
        SET @l_introtele    = ''                                                                               
        SET @l_blsavingcd    = ''                                                                              
        SET @l_mkrdt    = ''                                                                                      
        SET @l_mkrid    = ''                                                                                      
        SET @l_authid    = ''                                                                                  
        SET @l_authdt   = ''                                                                                   
        SET @l_remark    = ''                                                                                  
        SET @l_inwarddt    = ''                                                                                
        SET @l_PoaForPayin    = ''                                                                         
        SET @l_remissier   = ''                                                                                
        SET @l_remissierscheme    = ''                                                                         
        SET @l_mapin   = ''                                                                                    
        SET @l_sms   = ''                                                                                      
        SET @l_secondemail   = ''                                                                              
        SET @l_secondmapin   = ''                                                                     
        SET @l_secondsms   = ''                                                                                
        SET @l_thirdemail   = ''                                                                               
        SET @l_thirdmapin   = ''                                                                               
        SET @l_thirdsms   = ''                                                                          
        SET @l_minor_nominee_guardianname1= ''   --@l_minor_nominee_guardianname   = ''                                              
        SET @l_minor_nominee_address1= ''             --@l_minor_nominee_add1   = ''                                      
        SET @l_minor_nominee_address2= ''          --@l_minor_nominee_add2   = ''                                                                       
        SET @l_minor_nominee_address3= ''          --@l_minor_nominee_add3   = ''                                                                       
        SET @l_minor_nominee_address4= ''           --@l_minor_nominee_add4  = ''                                                                      
        SET @l_minor_nominee_pincode= ''            --@l_minor_nominee_pin   = ''                                                                        
        SET @l_minor_nominee_phone1= ''             --@l_minor_nominee_phone    = ''                                   
        SET @l_minor_nominee_fax1= ''                --@l_minor_nominee_fax   = ''                                                                        
        SET @l_minor_nominee_guardianaddresspresent1= ''       --@l_minor_nominee_guardianaddresspresent    = ''                                                    
        SET @l_uploadtonsdl   = ''                                                                             
        SET @l_fh_panflag     = ''                                    
        SET @l_sh_panflag  = ''                                                                        
        SET @l_th_panflag   = ''        
        SET @l_nom_gau_nm = ''      
        Set @l_nom_fnm    = ''                                                   
        SET @l_modified   = ''                                                    
      --                                                    
      end                                                    
      --                                                     
      FETCH NEXT FROM @c_cursor INTO @c_crn_no, @c_dpam_id, @c_acct_no, @c_sba_no                                                  
    --                                                    
    END                                  
    --                                                    
    CLOSE @c_cursor                                                    
    --                                                    
    DEALLOCATE @c_cursor                                                    
    --                                                    
    --SELECT * FROM client_export                                                    
  --                                                    
  --END--CE                                                    
                             
  --client_checkList--                                                    
  --IF @pa_tab = 'CCL'           
  --BEGIN                                                    
  --                                                    
    IF EXISTS(SELECT top 1 * FROM client_checklist_nsdl WITH (NOLOCK))                                                    
    BEGIN--#                                                    
    --                                                    
      INSERT INTO client_checklist_nsdl_hst                                                    
      (cch_dpintrefno                                             
      ,cch_cmcd                                                           
      ,cch_check                                                          
      ,mkrid                                                              
      ,mkrdt                                                    
      ,edittype                                                    
      ,cmpltd                                            
      )                                                    
      SELECT cch_dpintrefno                                                     
           , cch_cmcd                                                           
           , cch_check                                                          
           , mkrid                                                              
           , mkrdt                                                    
           , edittype                                                    
           , 1                                                    
      FROM   client_checklist_nsdl                                                    
      WHERE  cmpltd = 1                                                    
      --                                                    
      DELETE FROM client_checklist_nsdl                                                     
      WHERE  cmpltd  = 1                                                    
    --                                                    
    END--#                                                    
    --                                                    
    IF isnull(@pa_from_dt,'') <> '' AND  isnull(@pa_to_dt,'') <> '' AND isnull(@pa_from_crn,'') <> '' AND isnull(@pa_to_crn,'') <> ''                                                    
    BEGIN                                                    
    --                              
      --For account level property                              
      --                              
      if exists(select * from client_checklist_nsdl where cmpltd = 0 )                                             
      begin                                              
      --                                               
      delete from client_checklist_nsdl where cmpltd = 0                        
      --                                       
      INSERT INTO client_checklist_nsdl                                                    
      (cch_dpintrefno                                                     
      ,cch_cmcd                                                           
      ,cch_check                                                          
      ,mkrid                                                              
      ,mkrdt                                                    
      ,edittype                                                    
      ,cmpltd                            
      )                                                    
      --                                                    
     SELECT distinct convert(varchar(10), dpam_acct_no)                                          
           , ''--convert(varchar(16), dpam_sba_no)                                                    
           , CASE when accdocm.accdocm_cd = 'PHOT_IDN' then 'A07'                              
                  when accdocm.accdocm_cd = 'PHO_IDN' then 'A08'                         
                  when accdocm.accdocm_cd = 'IDEN_ADD' then 'B08'                                   
                  when accdocm.accdocm_cd = 'SELF_ADD' then 'B09'                              
                  when accdocm.accdocm_cd = 'PRIT_COR' then 'C05'                               
                  when accdocm.accdocm_cd = 'PAN_OTH' then 'D04'                              
                  when accdocm.accdocm_cd = 'LETT_OTH' then 'D05'                              
                  when accdocm.accdocm_cd = 'BIRT_OTH' then 'D06'                              
                  when accdocm.accdocm_cd = 'GENE_OTH' then 'D07'                              
                  when accdocm.accdocm_cd = 'POAPI_OTH' then 'D08'                              
                  when accdocm.accdocm_cd = 'FAX_OTH' then 'D10'                              
                  when accdocm.accdocm_cd = 'BANK_OTH' then 'D11'                              
                  when accdocm.accdocm_cd = 'IDEA_OTH' then 'D12'                              
                  when accdocm.accdocm_cd = 'SPEE_OTH' then 'D13'                              
                  when accdocm.accdocm_cd = 'AGRE_OTH' then 'D14'                              
                  when accdocm.accdocm_cd = 'POA_OTH' then 'D15'                              
                  ELSE ''                              
              END                               
           , convert(char(8), dpam_created_by)                                                    
           , replace(convert(varchar, dpam_created_dt,111),'/','')                                                    
           , CASE WHEN dpam.dpam_created_dt = dpam.dpam_lst_upd_dt THEN 'I' ELSE 'U' END modified                                                    
           , 0                                                    
      FROM   dp_acct_mstr          dpam  WITH (NOLOCK)                                                    
           , exch_seg_mstr         excsm WITH (NOLOCK)                                                    
           , account_documents       accd                                  
           , account_document_mstr   accdocm                                  
      WHERE  excsm.excsm_id       = dpam_excsm_id                                                    
      AND    excsm.excsm_exch_cd  = 'NSDL'                                                    
      AND    dpam_lst_upd_dt        between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                      
      AND    convert(varchar, dpam_crn_no) between convert(varchar, @pa_from_crn)  AND  convert(varchar, @pa_to_crn)                                                    
      AND    dpam_deleted_ind    = 1                                                    
      AND    excsm_deleted_ind   = 1                                  
      AND    accd.accd_deleted_ind    = 1                              
      and    accdocm.accdocm_deleted_ind = 1                               
      AND  accd.accd_accdocm_doc_id = accdocm.accdocm_doc_id                                  
      AND  dpam.dpam_id             = accd.accd_clisba_id                                  
      AND  accdocm.accdocm_cd      IN('PHOT_IDN','PHO_IDN','IDEN_ADD','SELF_ADD','PRIT_COR','PAN_OTH','LETT_OTH','BIRT_OTH','GENE_OTH','POAPI_OTH','BANK_OTH','IDEA_OTH','SPEE_OTH','AGRE_OTH','POA_OTH','D15','FAX_OTH')                              
      --              
      end          
      else          
      begin          
      INSERT INTO client_checklist_nsdl                                                    
      (cch_dpintrefno                                                     
      ,cch_cmcd                                                           
      ,cch_check                                                          
      ,mkrid                                                              
      ,mkrdt                                                    
      ,edittype                                               
      ,cmpltd                                                    
      )                                                    
      --                                                    
     SELECT distinct convert(varchar(10), dpam_acct_no)                                          
           , ''--convert(varchar(16), dpam_sba_no)                                                    
    , CASE when accdocm.accdocm_cd = 'PHOT_IDN' then 'A07'                              
                  when accdocm.accdocm_cd = 'PHO_IDN' then 'A08'                         
                  when accdocm.accdocm_cd = 'IDEN_ADD' then 'B08'                                   
                  when accdocm.accdocm_cd = 'SELF_ADD' then 'B09'                              
                  when accdocm.accdocm_cd = 'PRIT_COR' then 'C05'                               
                  when accdocm.accdocm_cd = 'PAN_OTH' then 'D04'                              
                  when accdocm.accdocm_cd = 'LETT_OTH' then 'D05'                              
                  when accdocm.accdocm_cd = 'BIRT_OTH' then 'D06'                              
                  when accdocm.accdocm_cd = 'GENE_OTH' then 'D07'                              
                  when accdocm.accdocm_cd = 'POAPI_OTH' then 'D08'                              
                  when accdocm.accdocm_cd = 'FAX_OTH' then 'D10'                              
                  when accdocm.accdocm_cd = 'BANK_OTH' then 'D11'                              
                  when accdocm.accdocm_cd = 'IDEA_OTH' then 'D12'                              
                  when accdocm.accdocm_cd = 'SPEE_OTH' then 'D13'                              
                  when accdocm.accdocm_cd = 'AGRE_OTH' then 'D14'                              
                  when accdocm.accdocm_cd = 'POA_OTH' then 'D15'                              
                  ELSE ''                              
              END                               
           , convert(char(8), dpam_created_by)                                                    
           , replace(convert(varchar, dpam_created_dt,111),'/','')                                                    
           , CASE WHEN dpam.dpam_created_dt = dpam.dpam_lst_upd_dt THEN 'I' ELSE 'U' END modified                                                    
           , 0                                                    
      FROM   dp_acct_mstr          dpam  WITH (NOLOCK)                      
           , exch_seg_mstr         excsm WITH (NOLOCK)                                                    
           , account_documents       accd                                  
           , account_document_mstr   accdocm                                  
      WHERE  excsm.excsm_id       = dpam_excsm_id                                                    
      AND    excsm.excsm_exch_cd  = 'NSDL'                                                    
      AND    dpam_lst_upd_dt        between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                      
      AND    convert(varchar, dpam_crn_no) between convert(varchar, @pa_from_crn)  AND  convert(varchar, @pa_to_crn)                                                    
      AND    dpam_deleted_ind    = 1                                                    
      AND    excsm_deleted_ind   = 1                                  
    AND    accd.accd_deleted_ind    = 1                              
      and    accdocm.accdocm_deleted_ind = 1                               
      AND  accd.accd_accdocm_doc_id = accdocm.accdocm_doc_id                                  
      AND  dpam.dpam_id             = accd.accd_clisba_id                                  
      AND  accdocm.accdocm_cd      IN('PHOT_IDN','PHO_IDN','IDEN_ADD','SELF_ADD','PRIT_COR','PAN_OTH','LETT_OTH','BIRT_OTH','GENE_OTH','POAPI_OTH','BANK_OTH','IDEA_OTH','SPEE_OTH','AGRE_OTH','POA_OTH','D15','FAX_OTH')                                     
  
    
      
        
             
      --          
      end          
      --          
      --For Client level property                              
      --                 
      if exists(select * from client_checklist_nsdl where cmpltd = 0 )                                             
      begin                                              
      --                                               
      delete from client_checklist_nsdl where cmpltd = 0                                              
      --                             
      INSERT INTO client_checklist_nsdl                                                    
      (cch_dpintrefno                                                     
      ,cch_cmcd                                                           
      ,cch_check                                                          
      ,mkrid                                                              
      ,mkrdt                                                    
      ,edittype                                                    
      ,cmpltd                                                    
      )                                                    
      --                                                    
      SELECT distinct convert(varchar(10), dpam_acct_no)                                          
           , ''--convert(varchar(16), dpam_sba_no)                                                    
           , CASE when docm.docm_cd = 'PASS_IDN' then 'A01'                              
                  when docm.docm_cd = 'PAN_IDN' then 'A02'                                   
                  when docm.docm_cd = 'DRIV_IDN' then 'A03'                                   
                  when docm.docm_cd = 'VOTE_IDN' then 'A04'                              
                  when docm.docm_cd = 'PASS_ADD' then 'B01'                               
                  when docm.docm_cd = 'DRIV_ADD' then 'B02'                              
                  when docm.docm_cd = 'RATI_ADD' then 'B03'                              
                  when docm.docm_cd = 'LATE_ADD' then 'B04'                              
                  when docm.docm_cd = 'LATES_ADD' then 'B05'                              
                  when docm.docm_cd = 'LEAS_ADD' then 'B06'                              
                  when docm.docm_cd = 'VOTE_ADD' then 'B07'                              
                  when docm.docm_cd = 'MEMO_COR' then 'C01'                              
                  when docm.docm_cd = 'CERT_COR' then 'C02'                              
                  when docm.docm_cd = 'BOAR_COR' then 'C03'                              
                  when docm.docm_cd = 'FORM_COR' then 'C04'                              
                  when docm.docm_cd = 'PRBS_COR' then 'C06'                              
                  when docm.docm_cd = 'PRL_COR' then 'C07'                              
                  when docm.docm_cd = 'PROC_COR' then 'C08'                              
                  when docm.docm_cd = 'RBI_COR' then 'C09'                              
                  when docm.docm_cd = 'PHOT_OTH' then 'D01'                              
                  when docm.docm_cd = 'SIGN_OTH' then 'D02'                              
                  when docm.docm_cd = 'STAM_OTH' then 'D03'                              
                  when docm.docm_cd = 'CANC_OTH' then 'D09'                              
                  ELSE ''                 
              END                               
           , convert(char(8), dpam_created_by)                                                    
           , replace(convert(varchar, dpam_created_dt,111),'/','')                                                    
           , CASE WHEN dpam.dpam_created_dt = dpam.dpam_lst_upd_dt THEN 'I' ELSE 'U' END modified                                                    
           , 0                                                    
      FROM   dp_acct_mstr          dpam  WITH (NOLOCK)                                                    
           , exch_seg_mstr         excsm WITH (NOLOCK)                                                    
           , client_documents       clid                                  
           , document_mstr          docm                                  
      WHERE  excsm.excsm_id       = dpam_excsm_id                                                    
      AND    excsm.excsm_exch_cd  = 'NSDL'                                                    
      AND    dpam_lst_upd_dt        between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                      
      AND    convert(varchar, dpam_crn_no) between convert(varchar, @pa_from_crn)  AND  convert(varchar, @pa_to_crn)                                                    
      AND    dpam_deleted_ind    = 1                                                    
      AND    excsm_deleted_ind   = 1                                  
      AND    clid_deleted_ind    = 1                              
      AND    docm_deleted_ind    = 1                                 
      AND  clid.clid_docm_doc_id = docm.docm_doc_id                                  
      AND  dpam.dpam_crn_no      = clid.clid_crn_no                                  
      AND  docm.docm_cd      IN('PASS_IDN','PAN_IDN','DRIV_IDN','VOTE_IDN','PASS_ADD','DRIV_ADD','RATI_ADD','LATE_ADD','LATES_ADD','LEAS_ADD','VOTE_ADD','MEMO_COR','CERT_COR','BOAR_COR','FORM_COR','PRBS_COR','PRL_COR','PROC_COR','RBI_COR','PHOT_OTH','SIGN_OTH','STAM_OTH','D09')                                                                  
    --                                                                
    END                
    else          
    begin          
    INSERT INTO client_checklist_nsdl                                                    
      (cch_dpintrefno                                                     
      ,cch_cmcd                                                           
      ,cch_check                                                          
      ,mkrid                                                              
      ,mkrdt                                                    
      ,edittype                                                    
      ,cmpltd                                                    
      )                                                    
      --                                                    
      SELECT distinct convert(varchar(10), dpam_acct_no)                                          
           , ''--convert(varchar(16), dpam_sba_no)                                                    
           , CASE when docm.docm_cd = 'PASS_IDN' then 'A01'                              
                  when docm.docm_cd = 'PAN_IDN' then 'A02'                                   
                  when docm.docm_cd = 'DRIV_IDN' then 'A03'                                   
                  when docm.docm_cd = 'VOTE_IDN' then 'A04'                              
                  when docm.docm_cd = 'PASS_ADD' then 'B01'                            
                  when docm.docm_cd = 'DRIV_ADD' then 'B02'                              
                  when docm.docm_cd = 'RATI_ADD' then 'B03'                     
                  when docm.docm_cd = 'LATE_ADD' then 'B04'                              
                  when docm.docm_cd = 'LATES_ADD' then 'B05'                              
                  when docm.docm_cd = 'LEAS_ADD' then 'B06'                              
                  when docm.docm_cd = 'VOTE_ADD' then 'B07'                              
                  when docm.docm_cd = 'MEMO_COR' then 'C01'                              
                  when docm.docm_cd = 'CERT_COR' then 'C02'                              
                  when docm.docm_cd = 'BOAR_COR' then 'C03'                              
                  when docm.docm_cd = 'FORM_COR' then 'C04'                              
                  when docm.docm_cd = 'PRBS_COR' then 'C06'                              
                  when docm.docm_cd = 'PRL_COR' then 'C07'                              
                  when docm.docm_cd = 'PROC_COR' then 'C08'                              
                  when docm.docm_cd = 'RBI_COR' then 'C09'                              
                  when docm.docm_cd = 'PHOT_OTH' then 'D01'                              
                  when docm.docm_cd = 'SIGN_OTH' then 'D02'                              
                  when docm.docm_cd = 'STAM_OTH' then 'D03'                              
                  when docm.docm_cd = 'CANC_OTH' then 'D09'                              
                  ELSE ''                              
              END                               
           , convert(char(8), dpam_created_by)                                                    
           , replace(convert(varchar, dpam_created_dt,111),'/','')                                                    
           , CASE WHEN dpam.dpam_created_dt = dpam.dpam_lst_upd_dt THEN 'I' ELSE 'U' END modified                                                    
           , 0                                                    
      FROM   dp_acct_mstr          dpam  WITH (NOLOCK)                                                    
           , exch_seg_mstr         excsm WITH (NOLOCK)                                                    
           , client_documents       clid                                  
           , document_mstr          docm                                  
      WHERE  excsm.excsm_id       = dpam_excsm_id                                                    
      AND    excsm.excsm_exch_cd  = 'NSDL'                                                    
      AND    dpam_lst_upd_dt        between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                      
      AND    convert(varchar, dpam_crn_no) between convert(varchar, @pa_from_crn)  AND  convert(varchar, @pa_to_crn)                                                    
      AND    dpam_deleted_ind    = 1                                                    
      AND    excsm_deleted_ind   = 1                                  
      AND    clid_deleted_ind    = 1                              
      AND    docm_deleted_ind    = 1                                 
      AND  clid.clid_docm_doc_id = docm.docm_doc_id                                  
      AND  dpam.dpam_crn_no      = clid.clid_crn_no                                  
      AND  docm.docm_cd      IN('PASS_IDN','PAN_IDN','DRIV_IDN','VOTE_IDN','PASS_ADD','DRIV_ADD','RATI_ADD','LATE_ADD','LATES_ADD','LEAS_ADD','VOTE_ADD','MEMO_COR','CERT_COR','BOAR_COR','FORM_COR','PRBS_COR','PRL_COR','PROC_COR','RBI_COR','PHOT_OTH','SIG 
  
   
       
       
N_OTH','STAM_OTH','D09')          
      --           
      end          
      end --BEGIN          
      --                                                        
    --                                                    
    IF isnull(@pa_from_dt,'') <> '' AND  isnull(@pa_to_dt,'') <> '' AND isnull(@pa_from_crn,'') = '' AND isnull(@pa_to_crn,'') = ''                                                    
    BEGIN                                                    
    --           
      --For account level property                              
      --                        
      if exists(select * from client_checklist_nsdl where cmpltd = 0 )                                   
      begin                                              
      --                                               
      delete from client_checklist_nsdl where cmpltd = 0                                              
      --                                       
      INSERT INTO client_checklist_nsdl                                                    
      (cch_dpintrefno                                                     
      ,cch_cmcd                                                           
      ,cch_check                                                          
      ,mkrid                                                              
      ,mkrdt                                                    
      ,edittype                                                    
      ,cmpltd                                                    
      )                                                    
      --                                                    
     SELECT distinct convert(varchar(10), dpam_acct_no)                                          
           , ''--convert(varchar(16), dpam_sba_no)                                                    
    ,        CASE when accdocm.accdocm_cd = 'PHOT_IDN' then 'A07'                              
                  when accdocm.accdocm_cd = 'PHO_IDN' then 'A08'                         
                  when accdocm.accdocm_cd = 'IDEN_ADD' then 'B08'                                   
                  when accdocm.accdocm_cd = 'SELF_ADD' then 'B09'                              
                  when accdocm.accdocm_cd = 'PRIT_COR' then 'C05'                               
                  when accdocm.accdocm_cd = 'PAN_OTH' then 'D04'                              
                  when accdocm.accdocm_cd = 'LETT_OTH' then 'D05'                              
                  when accdocm.accdocm_cd = 'BIRT_OTH' then 'D06'                              
                  when accdocm.accdocm_cd = 'GENE_OTH' then 'D07'                              
                  when accdocm.accdocm_cd = 'POAPI_OTH' then 'D08'                              
                  when accdocm.accdocm_cd = 'FAX_OTH' then 'D10'                              
                  when accdocm.accdocm_cd = 'BANK_OTH' then 'D11'                              
                  when accdocm.accdocm_cd = 'IDEA_OTH' then 'D12'                              
                  when accdocm.accdocm_cd = 'SPEE_OTH' then 'D13'                              
                  when accdocm.accdocm_cd = 'AGRE_OTH' then 'D14'                              
                  when accdocm.accdocm_cd = 'POA_OTH' then 'D15'                              
                  ELSE ''                              
              END                               
           , convert(char(8), dpam_created_by)                                                    
           , replace(convert(varchar, dpam_created_dt,111),'/','')                                                    
           , CASE WHEN dpam.dpam_created_dt = dpam.dpam_lst_upd_dt THEN 'I' ELSE 'U' END modified                                                    
           , 0                                                    
      FROM   dp_acct_mstr          dpam  WITH (NOLOCK)                                                    
           , exch_seg_mstr         excsm WITH (NOLOCK)                                                    
           , account_documents       accd                                  
           , account_document_mstr   accdocm                                  
      WHERE  excsm.excsm_id       = dpam_excsm_id                                                    
      AND    excsm.excsm_exch_cd  = 'NSDL'                                                    
      AND    dpam_lst_upd_dt        between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                      
      --AND    convert(varchar, dpam_crn_no) between convert(varchar, @pa_from_crn)  AND  convert(varchar, @pa_to_crn)                  
      AND    dpam_deleted_ind    = 1                                                    
      AND    excsm_deleted_ind   = 1                                  
      AND    accd.accd_deleted_ind    = 1                              
      and    accdocm.accdocm_deleted_ind = 1                               
      AND  accd.accd_accdocm_doc_id = accdocm.accdocm_doc_id                                  
      AND  dpam.dpam_id             = accd.accd_clisba_id                                  
      AND  accdocm.accdocm_cd      IN('PHOT_IDN','PHO_IDN','IDEN_ADD','SELF_ADD','PRIT_COR','PAN_OTH','LETT_OTH','BIRT_OTH','GENE_OTH','POAPI_OTH','BANK_OTH','IDEA_OTH','SPEE_OTH','AGRE_OTH','POA_OTH','D15','FAX_OTH')                              
      --                
      end          
      else          
      begin          
      INSERT INTO client_checklist_nsdl                                                    
      (cch_dpintrefno                                                     
      ,cch_cmcd                                                           
      ,cch_check                                                          
      ,mkrid                                                              
      ,mkrdt                                                    
      ,edittype                                                    
      ,cmpltd                                                    
      )                                                    
      --                                                    
      SELECT distinct convert(varchar(10), dpam_acct_no)                                          
           , ''--convert(varchar(16), dpam_sba_no)                                                    
    , CASE when accdocm.accdocm_cd = 'PHOT_IDN' then 'A07'                              
                  when accdocm.accdocm_cd = 'PHO_IDN' then 'A08'                         
                  when accdocm.accdocm_cd = 'IDEN_ADD' then 'B08'                                   
                  when accdocm.accdocm_cd = 'SELF_ADD' then 'B09'                              
                  when accdocm.accdocm_cd = 'PRIT_COR' then 'C05'                               
                  when accdocm.accdocm_cd = 'PAN_OTH' then 'D04'                              
                  when accdocm.accdocm_cd = 'LETT_OTH' then 'D05'                              
                  when accdocm.accdocm_cd = 'BIRT_OTH' then 'D06'                              
                  when accdocm.accdocm_cd = 'GENE_OTH' then 'D07'                              
                  when accdocm.accdocm_cd = 'POAPI_OTH' then 'D08'                              
                  when accdocm.accdocm_cd = 'FAX_OTH' then 'D10'                              
                  when accdocm.accdocm_cd = 'BANK_OTH' then 'D11'                              
                  when accdocm.accdocm_cd = 'IDEA_OTH' then 'D12'                              
                  when accdocm.accdocm_cd = 'SPEE_OTH' then 'D13'                              
                  when accdocm.accdocm_cd = 'AGRE_OTH' then 'D14'                              
                  when accdocm.accdocm_cd = 'POA_OTH' then 'D15'                              
                  ELSE ''                              
              END                               
           , convert(char(8), dpam_created_by)                                                    
           , replace(convert(varchar, dpam_created_dt,111),'/','')                                                    
           , CASE WHEN dpam.dpam_created_dt = dpam.dpam_lst_upd_dt THEN 'I' ELSE 'U' END modified                                                    
           , 0                                                    
      FROM   dp_acct_mstr          dpam  WITH (NOLOCK)                                                    
           , exch_seg_mstr         excsm WITH (NOLOCK)                                                    
      , account_documents       accd                                  
           , account_document_mstr   accdocm                                  
      WHERE  excsm.excsm_id       = dpam_excsm_id         
      AND    excsm.excsm_exch_cd  = 'NSDL'                                                    
      AND    dpam_lst_upd_dt        between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                      
      --AND    convert(varchar, dpam_crn_no) between convert(varchar, @pa_from_crn)  AND  convert(varchar, @pa_to_crn)                                                    
      AND    dpam_deleted_ind    = 1                                                    
      AND    excsm_deleted_ind   = 1                                  
      AND    accd.accd_deleted_ind    = 1                              
      and    accdocm.accdocm_deleted_ind = 1                               
      AND  accd.accd_accdocm_doc_id = accdocm.accdocm_doc_id                                  
      AND  dpam.dpam_id             = accd.accd_clisba_id                                  
      AND  accdocm.accdocm_cd      IN('PHOT_IDN','PHO_IDN','IDEN_ADD','SELF_ADD','PRIT_COR','PAN_OTH','LETT_OTH','BIRT_OTH','GENE_OTH','POAPI_OTH','BANK_OTH','IDEA_OTH','SPEE_OTH','AGRE_OTH','POA_OTH','D15','FAX_OTH')                                     
  
    
      
        
             
      --          
      end          
      --          
      --For Client level property                              
      --                 
      if exists(select * from client_checklist_nsdl where cmpltd = 0 )                                             
      begin                                              
      --                                               
      delete from client_checklist_nsdl where cmpltd = 0                                              
      --                             
      INSERT INTO client_checklist_nsdl                                                    
      (cch_dpintrefno                                                     
      ,cch_cmcd                                                           
      ,cch_check                                                          
      ,mkrid                                                              
      ,mkrdt                                                    
      ,edittype                                                    
      ,cmpltd                                                    
      )                                                    
      --                                                    
      SELECT distinct convert(varchar(10), dpam_acct_no)                                          
           ,''-- convert(varchar(16), dpam_sba_no)                                                    
           , CASE when docm.docm_cd = 'PASS_IDN' then 'A01'                              
                  when docm.docm_cd = 'PAN_IDN' then 'A02'                                   
                  when docm.docm_cd = 'DRIV_IDN' then 'A03'                                   
                  when docm.docm_cd = 'VOTE_IDN' then 'A04'                              
                  when docm.docm_cd = 'PASS_ADD' then 'B01'                               
                  when docm.docm_cd = 'DRIV_ADD' then 'B02'                              
                  when docm.docm_cd = 'RATI_ADD' then 'B03'                              
                  when docm.docm_cd = 'LATE_ADD' then 'B04'                              
                  when docm.docm_cd = 'LATES_ADD' then 'B05'                              
                  when docm.docm_cd = 'LEAS_ADD' then 'B06'                              
                  when docm.docm_cd = 'VOTE_ADD' then 'B07'                              
                  when docm.docm_cd = 'MEMO_COR' then 'C01'                              
                  when docm.docm_cd = 'CERT_COR' then 'C02'                              
                  when docm.docm_cd = 'BOAR_COR' then 'C03'              
                  when docm.docm_cd = 'FORM_COR' then 'C04'                              
                  when docm.docm_cd = 'PRBS_COR' then 'C06'                              
                  when docm.docm_cd = 'PRL_COR' then 'C07'                              
                  when docm.docm_cd = 'PROC_COR' then 'C08'                              
                  when docm.docm_cd = 'RBI_COR' then 'C09'                              
                  when docm.docm_cd = 'PHOT_OTH' then 'D01'                              
                  when docm.docm_cd = 'SIGN_OTH' then 'D02'                              
                  when docm.docm_cd = 'STAM_OTH' then 'D03'                              
                  when docm.docm_cd = 'CANC_OTH' then 'D09'                              
      ELSE ''                              
              END                               
           , convert(char(8), dpam_created_by)                                                    
           , replace(convert(varchar, dpam_created_dt,111),'/','')                                                    
           , CASE WHEN dpam.dpam_created_dt = dpam.dpam_lst_upd_dt THEN 'I' ELSE 'U' END modified                                                    
           , 0                                                    
      FROM   dp_acct_mstr          dpam  WITH (NOLOCK)                                                    
           , exch_seg_mstr         excsm WITH (NOLOCK)                                                    
           , client_documents       clid                                  
           , document_mstr          docm                                  
      WHERE  excsm.excsm_id       = dpam_excsm_id                                                    
      AND    excsm.excsm_exch_cd  = 'NSDL'                                                    
      AND    dpam_lst_upd_dt        between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                      
      --AND    convert(varchar, dpam_crn_no) between convert(varchar, @pa_from_crn)  AND  convert(varchar, @pa_to_crn)                                                    
      AND    dpam_deleted_ind    = 1                                                    
      AND    excsm_deleted_ind   = 1                                  
      AND    clid_deleted_ind    = 1                              
      AND    docm_deleted_ind    = 1                                 
      AND  clid.clid_docm_doc_id = docm.docm_doc_id                                  
      AND  dpam.dpam_crn_no      = clid.clid_crn_no                                  
      AND  docm.docm_cd      IN('PASS_IDN','PAN_IDN','DRIV_IDN','VOTE_IDN','PASS_ADD','DRIV_ADD','RATI_ADD','LATE_ADD','LATES_ADD','LEAS_ADD','VOTE_ADD','MEMO_COR','CERT_COR','BOAR_COR','FORM_COR','PRBS_COR','PRL_COR','PROC_COR','RBI_COR','PHOT_OTH','SIGN
_OTH','STAM_OTH','D09')                                                                  
    --                                                                
    END                
    else          
    begin          
    INSERT INTO client_checklist_nsdl                                                    
      (cch_dpintrefno                                                     
      ,cch_cmcd                                                           
      ,cch_check                                                          
      ,mkrid                                                              
      ,mkrdt                                                    
      ,edittype                                                    
      ,cmpltd                                                    
      )                                                    
      --                  
      SELECT distinct convert(varchar(10), dpam_acct_no)                                          
           , ''--convert(varchar(16), dpam_sba_no)                                   
           , CASE when docm.docm_cd = 'PASS_IDN' then 'A01'                              
                  when docm.docm_cd = 'PAN_IDN' then 'A02'                                   
                  when docm.docm_cd = 'DRIV_IDN' then 'A03'                                   
                  when docm.docm_cd = 'VOTE_IDN' then 'A04'                              
                  when docm.docm_cd = 'PASS_ADD' then 'B01'                               
                  when docm.docm_cd = 'DRIV_ADD' then 'B02'                              
                  when docm.docm_cd = 'RATI_ADD' then 'B03'                              
                  when docm.docm_cd = 'LATE_ADD' then 'B04'                              
                  when docm.docm_cd = 'LATES_ADD' then 'B05'                              
                  when docm.docm_cd = 'LEAS_ADD' then 'B06'                              
                  when docm.docm_cd = 'VOTE_ADD' then 'B07'                              
                  when docm.docm_cd = 'MEMO_COR' then 'C01'                              
                  when docm.docm_cd = 'CERT_COR' then 'C02'                              
                  when docm.docm_cd = 'BOAR_COR' then 'C03'                              
                  when docm.docm_cd = 'FORM_COR' then 'C04'                              
                  when docm.docm_cd = 'PRBS_COR' then 'C06'                              
                  when docm.docm_cd = 'PRL_COR' then 'C07'                              
                  when docm.docm_cd = 'PROC_COR' then 'C08'                              
                  when docm.docm_cd = 'RBI_COR' then 'C09'                              
                  when docm.docm_cd = 'PHOT_OTH' then 'D01'                              
                  when docm.docm_cd = 'SIGN_OTH' then 'D02'                              
                  when docm.docm_cd = 'STAM_OTH' then 'D03'                              
                  when docm.docm_cd = 'CANC_OTH' then 'D09'                              
                  ELSE ''                              
              END                               
           , convert(char(8), dpam_created_by)                                                    
           , replace(convert(varchar, dpam_created_dt,111),'/','')                                                    
           , CASE WHEN dpam.dpam_created_dt = dpam.dpam_lst_upd_dt THEN 'I' ELSE 'U' END modified                                                    
           , 0                                                    
      FROM   dp_acct_mstr          dpam  WITH (NOLOCK)                                                    
           , exch_seg_mstr         excsm WITH (NOLOCK)                                                    
           , client_documents       clid                                  
           , document_mstr          docm                                  
      WHERE  excsm.excsm_id       = dpam_excsm_id                                                    
      AND    excsm.excsm_exch_cd  = 'NSDL'                                                    
      AND    dpam_lst_upd_dt        between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                      
      --AND    convert(varchar, dpam_crn_no) between convert(varchar, @pa_from_crn)  AND  convert(varchar, @pa_to_crn)                                                    
      AND    dpam_deleted_ind    = 1                                                    
      AND    excsm_deleted_ind   = 1                                  
      AND    clid_deleted_ind    = 1                              
      AND    docm_deleted_ind    = 1                           
      AND  clid.clid_docm_doc_id = docm.docm_doc_id                                  
      AND  dpam.dpam_crn_no      = clid.clid_crn_no                                  
      AND  docm.docm_cd      IN('PASS_IDN','PAN_IDN','DRIV_IDN','VOTE_IDN','PASS_ADD','DRIV_ADD','RATI_ADD','LATE_ADD','LATES_ADD','LEAS_ADD','VOTE_ADD','MEMO_COR','CERT_COR','BOAR_COR','FORM_COR','PRBS_COR','PRL_COR','PROC_COR','RBI_COR','PHOT_OTH','SIG
N_OTH','STAM_OTH','D09')          
      --           
      end          
      end                                                         
    --                                                    
    IF isnull(@pa_from_dt,'') = '' AND  isnull(@pa_to_dt,'') = '' AND isnull(@pa_from_crn,'') <> '' AND isnull(@pa_to_crn,'') <> ''                                                    
    BEGIN                                                    
    --                              
      --For account level property                              
      --                              
      if exists(select * from client_checklist_nsdl where cmpltd = 0 )                                             
      begin                                              
      --                                               
      delete from client_checklist_nsdl where cmpltd = 0                                              
      --                                       
      INSERT INTO client_checklist_nsdl                                                    
      (cch_dpintrefno                                                     
      ,cch_cmcd                                                           
      ,cch_check                        
      ,mkrid                                                              
      ,mkrdt                                                    
      ,edittype                                                    
      ,cmpltd                                                    
      )                                                    
      --                                                    
     SELECT distinct convert(varchar(10), dpam_acct_no)                                          
           ,''-- convert(varchar(16), dpam_sba_no)                                                    
           , CASE when accdocm.accdocm_cd = 'PHOT_IDN' then 'A07'                              
                  when accdocm.accdocm_cd = 'PHO_IDN' then 'A08'                         
                  when accdocm.accdocm_cd = 'IDEN_ADD' then 'B08'                                   
                  when accdocm.accdocm_cd = 'SELF_ADD' then 'B09'                              
                  when accdocm.accdocm_cd = 'PRIT_COR' then 'C05'                               
                  when accdocm.accdocm_cd = 'PAN_OTH' then 'D04'                              
                  when accdocm.accdocm_cd = 'LETT_OTH' then 'D05'                              
                  when accdocm.accdocm_cd = 'BIRT_OTH' then 'D06'                              
                  when accdocm.accdocm_cd = 'GENE_OTH' then 'D07'                              
                  when accdocm.accdocm_cd = 'POAPI_OTH' then 'D08'                              
                  when accdocm.accdocm_cd = 'FAX_OTH' then 'D10'                              
                  when accdocm.accdocm_cd = 'BANK_OTH' then 'D11'                              
                  when accdocm.accdocm_cd = 'IDEA_OTH' then 'D12'                              
                  when accdocm.accdocm_cd = 'SPEE_OTH' then 'D13'                              
                  when accdocm.accdocm_cd = 'AGRE_OTH' then 'D14'                              
                  when accdocm.accdocm_cd = 'POA_OTH' then 'D15'                              
                  ELSE ''                              
              END                               
           , convert(char(8), dpam_created_by)                                                    
 , replace(convert(varchar, dpam_created_dt,111),'/','')                                                    
           , CASE WHEN dpam.dpam_created_dt = dpam.dpam_lst_upd_dt THEN 'I' ELSE 'U' END modified                                                    
           , 0                                                    
      FROM   dp_acct_mstr          dpam  WITH (NOLOCK)                                                    
           , exch_seg_mstr         excsm WITH (NOLOCK)                                                    
           , account_documents       accd                                  
           , account_document_mstr   accdocm                                  
      WHERE  excsm.excsm_id       = dpam_excsm_id                                                    
      AND    excsm.excsm_exch_cd  = 'NSDL'                                                    
    --AND    dpam_lst_upd_dt        between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                      
      AND    convert(varchar, dpam_crn_no) between convert(varchar, @pa_from_crn)  AND  convert(varchar, @pa_to_crn)                                                    
      AND    dpam_deleted_ind    = 1                                                    
      AND    excsm_deleted_ind   = 1                                  
      AND    accd.accd_deleted_ind    = 1                              
      and    accdocm.accdocm_deleted_ind = 1                               
      AND  accd.accd_accdocm_doc_id = accdocm.accdocm_doc_id                                  
      AND  dpam.dpam_id             = accd.accd_clisba_id                                  
      AND  accdocm.accdocm_cd      IN('PHOT_IDN','PHO_IDN','IDEN_ADD','SELF_ADD','PRIT_COR','PAN_OTH','LETT_OTH','BIRT_OTH','GENE_OTH','POAPI_OTH','BANK_OTH','IDEA_OTH','SPEE_OTH','AGRE_OTH','POA_OTH','D15','FAX_OTH')                              
      --                
      end          
  else          
      begin          
      INSERT INTO client_checklist_nsdl                                                    
      (cch_dpintrefno                                                     
      ,cch_cmcd                                                           
      ,cch_check                                                          
      ,mkrid                                                              
      ,mkrdt                                                    
      ,edittype                                                    
      ,cmpltd                                                    
      )                                                    
      --                                                    
     SELECT distinct convert(varchar(10), dpam_acct_no)                                          
           , ''--convert(varchar(16), dpam_sba_no)                                                    
           , CASE when accdocm.accdocm_cd = 'PHOT_IDN' then 'A07'                              
                  when accdocm.accdocm_cd = 'PHO_IDN' then 'A08'                         
                  when accdocm.accdocm_cd = 'IDEN_ADD' then 'B08'                                   
                  when accdocm.accdocm_cd = 'SELF_ADD' then 'B09'                              
                  when accdocm.accdocm_cd = 'PRIT_COR' then 'C05'                               
                  when accdocm.accdocm_cd = 'PAN_OTH' then 'D04'                              
                  when accdocm.accdocm_cd = 'LETT_OTH' then 'D05'                              
                  when accdocm.accdocm_cd = 'BIRT_OTH' then 'D06'                              
                  when accdocm.accdocm_cd = 'GENE_OTH' then 'D07'                              
                  when accdocm.accdocm_cd = 'POAPI_OTH' then 'D08'                              
                  when accdocm.accdocm_cd = 'FAX_OTH' then 'D10'                              
                  when accdocm.accdocm_cd = 'BANK_OTH' then 'D11'                              
                  when accdocm.accdocm_cd = 'IDEA_OTH' then 'D12'                              
                  when accdocm.accdocm_cd = 'SPEE_OTH' then 'D13'                              
                  when accdocm.accdocm_cd = 'AGRE_OTH' then 'D14'                              
                  when accdocm.accdocm_cd = 'POA_OTH' then 'D15'                              
                  ELSE ''                              
              END                               
           , convert(char(8), dpam_created_by)                                                    
           , replace(convert(varchar, dpam_created_dt,111),'/','')                                                    
           , CASE WHEN dpam.dpam_created_dt = dpam.dpam_lst_upd_dt THEN 'I' ELSE 'U' END modified                                                    
           , 0                                                    
      FROM   dp_acct_mstr          dpam  WITH (NOLOCK)                                                    
           , exch_seg_mstr         excsm WITH (NOLOCK)                                                    
           , account_documents       accd                                  
           , account_document_mstr   accdocm                                  
      WHERE  excsm.excsm_id       = dpam_excsm_id                                                    
      AND    excsm.excsm_exch_cd  = 'NSDL'                                                    
      --AND    dpam_lst_upd_dt        between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                      
      AND    convert(varchar, dpam_crn_no) between convert(varchar, @pa_from_crn)  AND  convert(varchar, @pa_to_crn)                                                    
      AND    dpam_deleted_ind    = 1                                                    
      AND    excsm_deleted_ind   = 1                                  
      AND    accd.accd_deleted_ind    = 1                              
      and    accdocm.accdocm_deleted_ind = 1                               
      AND  accd.accd_accdocm_doc_id = accdocm.accdocm_doc_id                                  
      AND  dpam.dpam_id             = accd.accd_clisba_id                          
      AND  accdocm.accdocm_cd      IN('PHOT_IDN','PHO_IDN','IDEN_ADD','SELF_ADD','PRIT_COR','PAN_OTH','LETT_OTH','BIRT_OTH','GENE_OTH','POAPI_OTH','BANK_OTH','IDEA_OTH','SPEE_OTH','AGRE_OTH','POA_OTH','D15','FAX_OTH')                                      
  
    
      
       
             
      --          
      end          
      --          
      --For Client level property                              
      --                 
      if exists(select * from client_checklist_nsdl where cmpltd = 0 )                                             
      begin                                              
      --                                               
      delete from client_checklist_nsdl where cmpltd = 0                                              
      --                             
      INSERT INTO client_checklist_nsdl                                                    
      (cch_dpintrefno                                                     
      ,cch_cmcd                                                           
      ,cch_check                                                          
      ,mkrid                                                              
      ,mkrdt                                                    
      ,edittype                                                    
      ,cmpltd                                                    
      )                                                    
      --                                                    
      SELECT distinct convert(varchar(10), dpam_acct_no)                                          
           , ''--convert(varchar(16), dpam_sba_no)                                                    
           , CASE when docm.docm_cd = 'PASS_IDN' then 'A01'                              
                  when docm.docm_cd = 'PAN_IDN' then 'A02'                                   
                  when docm.docm_cd = 'DRIV_IDN' then 'A03'                                   
                  when docm.docm_cd = 'VOTE_IDN' then 'A04'                              
                  when docm.docm_cd = 'PASS_ADD' then 'B01'                               
                  when docm.docm_cd = 'DRIV_ADD' then 'B02'                              
                  when docm.docm_cd = 'RATI_ADD' then 'B03'                              
                  when docm.docm_cd = 'LATE_ADD' then 'B04'                              
                  when docm.docm_cd = 'LATES_ADD' then 'B05'                              
                  when docm.docm_cd = 'LEAS_ADD' then 'B06'                              
                  when docm.docm_cd = 'VOTE_ADD' then 'B07'                              
                  when docm.docm_cd = 'MEMO_COR' then 'C01'                              
                  when docm.docm_cd = 'CERT_COR' then 'C02'                              
                  when docm.docm_cd = 'BOAR_COR' then 'C03'                              
                  when docm.docm_cd = 'FORM_COR' then 'C04'                              
                  when docm.docm_cd = 'PRBS_COR' then 'C06'                              
                  when docm.docm_cd = 'PRL_COR' then 'C07'                              
                  when docm.docm_cd = 'PROC_COR' then 'C08'                              
                  when docm.docm_cd = 'RBI_COR' then 'C09'                              
                  when docm.docm_cd = 'PHOT_OTH' then 'D01'                              
                  when docm.docm_cd = 'SIGN_OTH' then 'D02'                       
                  when docm.docm_cd = 'STAM_OTH' then 'D03'                              
                  when docm.docm_cd = 'CANC_OTH' then 'D09'                              
                  ELSE ''                              
              END                               
           , convert(char(8), dpam_created_by)                                                    
           , replace(convert(varchar, dpam_created_dt,111),'/','')                                                    
           , CASE WHEN dpam.dpam_created_dt = dpam.dpam_lst_upd_dt THEN 'I' ELSE 'U' END modified                                                    
           , 0                                                    
      FROM   dp_acct_mstr          dpam  WITH (NOLOCK)                                                    
           , exch_seg_mstr         excsm WITH (NOLOCK)                                                    
           , client_documents       clid                                  
           , document_mstr          docm                                  
      WHERE  excsm.excsm_id       = dpam_excsm_id                                                    
      AND    excsm.excsm_exch_cd  = 'NSDL'                                                    
      --AND    dpam_lst_upd_dt        between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                      
      AND    convert(varchar, dpam_crn_no) between convert(varchar, @pa_from_crn)  AND  convert(varchar, @pa_to_crn)                                                    
      AND    dpam_deleted_ind    = 1                                                    
      AND    excsm_deleted_ind   = 1                                  
      AND    clid_deleted_ind    = 1                              
      AND    docm_deleted_ind    = 1                                 
      AND  clid.clid_docm_doc_id = docm.docm_doc_id                                  
      AND  dpam.dpam_crn_no      = clid.clid_crn_no                                  
      AND  docm.docm_cd      IN('PASS_IDN','PAN_IDN','DRIV_IDN','VOTE_IDN','PASS_ADD','DRIV_ADD','RATI_ADD','LATE_ADD','LATES_ADD','LEAS_ADD','VOTE_ADD','MEMO_COR','CERT_COR','BOAR_COR','FORM_COR','PRBS_COR','PRL_COR','PROC_COR','RBI_COR','PHOT_OTH','SIGN
_OTH','STAM_OTH','D09')                                                                  
    --                                                                
    END                
    else          
    begin          
    INSERT INTO client_checklist_nsdl                                                    
      (cch_dpintrefno                                                     
      ,cch_cmcd                                                           
      ,cch_check                                                          
      ,mkrid                                                              
      ,mkrdt                                                    
      ,edittype                                                    
      ,cmpltd                                                    
      )                                                    
      --                                                    
      SELECT distinct convert(varchar(10), dpam_acct_no)                                          
           , ''--convert(varchar(16), dpam_sba_no)                                        
           , CASE when docm.docm_cd = 'PASS_IDN' then 'A01'                              
                  when docm.docm_cd = 'PAN_IDN' then 'A02'                                   
                  when docm.docm_cd = 'DRIV_IDN' then 'A03'                                   
                  when docm.docm_cd = 'VOTE_IDN' then 'A04'                              
                  when docm.docm_cd = 'PASS_ADD' then 'B01'                               
                  when docm.docm_cd = 'DRIV_ADD' then 'B02'                              
                  when docm.docm_cd = 'RATI_ADD' then 'B03'                              
                  when docm.docm_cd = 'LATE_ADD' then 'B04'                              
                  when docm.docm_cd = 'LATES_ADD' then 'B05'                              
                  when docm.docm_cd = 'LEAS_ADD' then 'B06'                              
                  when docm.docm_cd = 'VOTE_ADD' then 'B07'                              
                  when docm.docm_cd = 'MEMO_COR' then 'C01'                              
                  when docm.docm_cd = 'CERT_COR' then 'C02'                              
                  when docm.docm_cd = 'BOAR_COR' then 'C03'                              
                  when docm.docm_cd = 'FORM_COR' then 'C04'                              
                  when docm.docm_cd = 'PRBS_COR' then 'C06'                              
                  when docm.docm_cd = 'PRL_COR' then 'C07'                              
                  when docm.docm_cd = 'PROC_COR' then 'C08'                              
                  when docm.docm_cd = 'RBI_COR' then 'C09'                              
                  when docm.docm_cd = 'PHOT_OTH' then 'D01'               
                  when docm.docm_cd = 'SIGN_OTH' then 'D02'                              
                  when docm.docm_cd = 'STAM_OTH' then 'D03'                              
                  when docm.docm_cd = 'CANC_OTH' then 'D09'                              
                  ELSE ''                              
              END                               
           , convert(char(8), dpam_created_by)                                                    
           , replace(convert(varchar, dpam_created_dt,111),'/','')                                                    
           , CASE WHEN dpam.dpam_created_dt = dpam.dpam_lst_upd_dt THEN 'I' ELSE 'U' END modified                          
           , 0                                                    
      FROM   dp_acct_mstr          dpam  WITH (NOLOCK)                                                    
           , exch_seg_mstr         excsm WITH (NOLOCK)                                                    
           , client_documents       clid                                  
           , document_mstr          docm                                  
      WHERE  excsm.excsm_id       = dpam_excsm_id                                                    
      AND    excsm.excsm_exch_cd  = 'NSDL'                                                    
      --AND    dpam_lst_upd_dt        between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                      
      AND    convert(varchar, dpam_crn_no) between convert(varchar, @pa_from_crn)  AND  convert(varchar, @pa_to_crn)                                                    
      AND    dpam_deleted_ind    = 1                                                    
      AND    excsm_deleted_ind   = 1                                  
      AND    clid_deleted_ind    = 1                              
      AND    docm_deleted_ind    = 1                                 
      AND  clid.clid_docm_doc_id = docm.docm_doc_id                                  
      AND  dpam.dpam_crn_no      = clid.clid_crn_no                                  
      AND  docm.docm_cd      IN('PASS_IDN','PAN_IDN','DRIV_IDN','VOTE_IDN','PASS_ADD','DRIV_ADD','RATI_ADD','LATE_ADD','LATES_ADD','LEAS_ADD','VOTE_ADD','MEMO_COR','CERT_COR','BOAR_COR','FORM_COR','PRBS_COR','PRL_COR','PROC_COR','RBI_COR','PHOT_OTH','SIG
N_OTH','STAM_OTH','D09')          
      --           
      end          
      end                
    --                                                          
    --                                                    
    --SELECT * FROM #client_checklist                                                    
  --                                                      
  --END                                                    
  --                                                    
  --IF @pa_tab = 'UM'                                                    
  --BEGIN--UM                                                    
  --                                                    
    IF EXISTS (SELECT TOP 1 * FROM user_mstr_nsdl WITH (NOLOCK))                                                    
    BEGIN            
    --                                                    
      INSERT INTO user_mstr_nsdl_hst                                                     
      (um_user_id                                                          
      ,um_passwd                                                           
      ,um_group_id                                                         
      ,um_user_name                                                        
      ,um_add1                                                             
      ,um_add2                                                             
      ,um_add3                                                           
      ,um_add4                                                             
      ,um_pin                                                              
      ,um_designation                                                      
      ,um_dept                                                       
,um_lastlogin                                                      
      ,um_loginflag                                                      ,um_valid_from                                                       
      ,um_valid_to                                                         
      ,um_status                                                           
     ,mkrid                                                               
      ,mkrdt                                    
      ,um_computername                                                     
      ,um_brcode                                                           
      ,um_email                                                            
      ,um_special                                                          
      ,um_logstat                  ,um_resetpwddays                                                     
     ,um_lastresetday                                                     
      ,um_Locked                                                           
      ,um_loginaccessgroup                                                     
      ,um_poaforpayin                                                    
      ,um_edittype                                                    
    ,um_cmpltd                                                    
      )                                                    
      SELECT um_user_id                                                          
           , um_passwd                                                           
           , um_group_id                                                         
           , um_user_name                                                        
           , um_add1                                                             
           , um_add2                             
           , um_add3                                                             
           , um_add4                                                             
           , um_pin                                                              
           , um_designation                                                      
           , um_dept                                                             
           , um_lastlogin                                                        
 , um_loginflag                                             
           , um_valid_from                                                       
           , um_valid_to                                                         
           , um_status                                                           
           , mkrid                                                               
           , mkrdt                                                    
           , um_computername                                                     
           , um_brcode                                                           
           , um_email                                                            
           , um_special                                                          
           , um_logstat                                           
           , um_resetpwddays                                                     
           , um_lastresetday                                                     
          , um_Locked                                                           
           , um_loginaccessgroup                                                     
           , um_poaforpayin                                                    
           , um_edittype                                                    
           , 1                                                    
       FROM  user_mstr_nsdl                                                    
       WHERE um_cmpltd = 1                                                    
       --                                                    
       DELETE FROM user_mstr_nsdl                                                    
       WHERE  um_cmpltd = 1                                                    
    --                                                    
    END             
    --                                                    
    INSERT INTO user_mstr_nsdl                                                     
    (um_user_id                                                        
    ,um_passwd             
    ,um_group_id                                                         
    ,um_user_name                                        
    ,um_add1                                                             
    ,um_add2                                                             
    ,um_add3                                                             
    ,um_add4                                                             
    ,um_pin                                                              
    ,um_designation                                                      
    ,um_dept                                                             
    ,um_lastlogin                                                        
  ,um_loginflag                                                 
    ,um_valid_from                                                       
    ,um_valid_to                 
    ,um_status                                                           
    ,mkrid                                                               
 ,mkrdt                                                               
    ,um_computername                                                     
    ,um_brcode                                                           
    ,um_email                                                            
    ,um_special                                                          
    ,um_logstat                                                          
    ,um_resetpwddays                                                     
    ,um_lastresetday                                                     
    ,um_Locked                                                           
    ,um_loginaccessgroup                                                     
    ,um_poaforpayin                                                    
    ,um_edittype                                                    
    ,um_cmpltd                                     
   )                                                    
 --        
   SELECT convert(varchar(8),logn_name)                                             
        , convert(varchar(8), logn_pswd)                                                    
        , logn_enttm_id                                                    
        , convert(varchar(35), logn_short_name)                                                    
        , '' --???                                                    
        , '' --???                                                    
        , '' --???                                                    
        , '' --???                                                    
        , '' --???                                                    
        , '' --???                                                    
        , '' --???                                                    
        , '' --???                                                    
        , 'N' --???                                                    
        , convert(varchar(8), logn_from_dt, 3)                                                    
        , convert(varchar(8), logn_to_dt, 3)                                                 
        , logn_status                                                    
        , logn_created_by                                        
        , replace(convert(varchar, logn_created_dt,111),'/','') --convert(varchar(8), logn_created_dt,3)                                                    
        , '' --???                                                    
        , '' --???                                                    
        , logn_usr_email                                                    
        , '' --???                                                    
        , '' --???                                                    
        , logn_psw_exp_on                                                    
        , '' --???                                                    
       , logn_status                                                    
        , '' --???                                                    
        , '' --???                                                    
        , CASE WHEN logn_created_dt = logn_lst_upd_dt THEN 'I' ELSE 'U' END modified                                                    
        , 0                                                    
    FROM  login_names WITH (NOLOCK)                                               WHERE logn_lst_upd_dt between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'      
  
    
      
        
                                               
  --                                                  
  --END--UM                                                    
  --                               
  --IF @pa_tab = 'BM'                                                    
  --BEGIN--BM                             
  --                                                    
    CREATE TABLE #entity_properties2                                                    
    (pk          numeric                                                     
    ,code        varchar(25)                                                    
    ,value       varchar(50)                                                    
    )                                                    
    --                                                    
    DELETE FROM #entity_properties2                                                    
    DELETE FROM #addr                                                    
    DELETE FROM #conc                                                    
    --                                                    
    DECLARE @l_bm_branchcd        char(6)                                                    
          , @l_bm_branchname      varchar(45)                                                    
          , @l_bm_contact         varchar(45)                                                    
          , @l_bm_add1            varchar(36)                                                    
          , @l_bm_add2            varchar(36)                                              
          , @l_bm_add3            varchar(36)                                                    
          , @l_bm_city            varchar(36)                                                    
          , @l_bm_pin             char(6)                                                    
          , @l_bm_phone           varchar(24)                                                    
          , @l_bm_fax             varchar(15)                                                    
          , @l_bm_email           varchar(75)                                                    
          , @l_bm_allow           char(1)                                                    
          , @l_bm_batchno         numeric                                                    
          , @l_bm_ip_add          varchar(15)                                                    
          , @l_bm_dialup          varchar(15)                                                    
          , @l_bm_server          varchar(30)                                                    
          , @l_bm_database        varchar(20)                                                    
          , @l_bm_dbo     varchar(15)                                                    
          , @l_bm_user            varchar(15)                                                    
          , @l_bm_pwd            varchar(15)                                                 
          , @l_bm_workarea        varchar(150)                                                    
          , @l_mkrid1             char(8)                                                    
          , @l_mkrdt1             varchar(8)                                                     
          , @l_bm_percentage      numeric                                                    
          , @l_bm_flag            varchar(2)                                                    
          , @l_bm_type            char(1)                                                    
          , @c_entm_id            numeric                                                    
          , @c_entm_name1         varchar(50)                                                    
          , @c_entm_short_name    varchar(50)                                                    
          , @c_entm_created_by    varchar(20)                                                    
          , @c_entm_created_dt    varchar(8)                          
          , @c_entm_modified      char(1)                                                    
    , @c_cursor_bm          cursor                                 
    --                                           
    IF EXISTS(SELECT TOP 1 * FROM branch_mstr_nsdl WITH (NOLOCK))                                                    
    BEGIN                                       
    --                                                    
      INSERT INTO branch_mstr_nsdl                                                    
      (bm_branchcd                                                            
      ,bm_branchname                                                          
      ,bm_contact                                                             
      ,bm_add1                                                                
      ,bm_add2                                                                
      ,bm_add3                       
      ,bm_city                                                                
      ,bm_pin                                                                 
      ,bm_phone                                                               
      ,bm_fax                                                                 
      ,bm_email                                                               
      ,bm_allow                                                               
      ,bm_batchno                        
      ,bm_ip_add                                                              
      ,bm_dialup                                                              
      ,bm_server                                                                ,bm_database                                                            
      ,bm_dbo                                                                 
      ,bm_user                                                                
   ,bm_pwd                                                                 
      ,bm_workarea                                                            
      ,mkrid                                                                  
      ,mkrdt                                                                  
      ,bm_percentage                                                          
      ,bm_flag                                                                
      ,bm_type                                                      
      ,bm_edittype                                                            
      ,bm_cmpltd                                                              
  )                                                    
      --                                                    
      SELECT bm_branchcd                                                            
           , bm_branchname                                                          
           , bm_contact                                                             
           , bm_add1                            
 , bm_add2                                                                
           , bm_add3                                                                
           , bm_city                                                                
           , bm_pin                                                                 
           , bm_phone                                                               
           , bm_fax                                                                 
           , bm_email                                                               
           , bm_allow                                                               
           , bm_batchno                                                             
           , bm_ip_add                                                              
           , bm_dialup                                                   
           , bm_server                                                              
           , bm_database                                                            
           , bm_dbo                                                                 
           , bm_user                                                                
           , bm_pwd                                                                 
           , bm_workarea                                                          
           , mkrid                                                                  
           , mkrdt                               
           , bm_percentage                                                          
        , bm_flag                                                                
           , bm_type                                                       
           , bm_edittype                                                            
           , 1                                                              
      FROM   branch_mstr_nsdl WITH (NOLOCK)                                                    
      WHERE  bm_cmpltd  = 1                                                    
      --                                                    
      DELETE FROM branch_mstr_nsdl                                                    
      WHERE  bm_cmpltd = 1                                                    
    --                                           
    END                                                    
    --                                                    
    CREATE TABLE #entm                                                    
    (entm_id           numeric                                                    
    ,entm_name1        varchar(6)                                                    
    ,entm_short_name   varchar(45)                                                    
    ,entm_created_by   varchar(20)                                       
    ,entm_created_dt   varchar(8)                                                    
    ,entm_modified     char(1)                                                    
    )                                                    
    --                                                    
    IF isnull(@pa_from_dt,'') <> '' AND isnull(@pa_to_dt,'') <> ''                                    
    BEGIN                                                    
    --                                                    
      INSERT INTO #entm                                                    
      (entm_id                                                            
      ,entm_name1                                                         
      ,entm_short_name                                                    
      ,entm_created_by                                                    
      ,entm_created_dt                                                    
      ,entm_modified                                                    
      )                                                    
      --                                                    
      SELECT entm_id                                                    
           , convert(varchar(6), entm_name1)                                                    
           , convert(varchar(45), entm_short_name)                                                  
           , entm_created_by                                                    
           , replace(convert(varchar, entm_created_dt,111),'/','')--convert(varchar(8),entm_created_dt,3)                                      
           , CASE WHEN entm_created_dt = entm_lst_upd_dt THEN 'I' ELSE 'U' END                                                     
      FROM   entity_mstr                 WITH (NOLOCK)                                                    
      WHERE  entm_enttm_cd             = 'BR'                                                    
      AND    entm_lst_upd_dt            between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                                     
      AND    entm_deleted_ind          = 1                                                    
    --                                                      
    END                                                        
    --                          
    IF isnull(@pa_from_dt,'') <> '' AND isnull(@pa_to_dt,'') <> ''                                                    
    BEGIN              
    --                                                    
      INSERT INTO #entm                                                    
      (entm_id                                                            
      ,entm_name1                                                         
      ,entm_short_name                                                    
      ,entm_created_by                            
      ,entm_created_dt                  
      ,entm_modified                                                    
      )                                                    
      --                                                    
      SELECT entm_id                                                    
           , convert(varchar(6), entm_name1)                                                    
           , convert(varchar(45), entm_short_name)                                                    
           , entm_created_by                                                    
           , replace(convert(varchar, entm_created_dt,111),'/','')--convert(varchar(8),entm_created_dt,3)                                                    
           , CASE WHEN entm_created_dt = entm_lst_upd_dt THEN 'I' ELSE 'U' END                                                    
      FROM   entity_mstr    WITH (NOLOCK)                                                    
      WHERE  entm_enttm_cd    = 'BR'                                            
      AND    entm_deleted_ind = 1                                                    
--                                                      
    END                                                        
    --                                                    
    INSERT INTO #entity_properties2                                                    
    (pk                                                    
    ,code                                                    
    ,value                                                    
    )                                                    
    --                                                    
    SELECT entp_ent_id                                                    
         , convert(varchar(25), entp_entpm_cd)                                                    
         , convert(varchar(50), entp_value)                                                     
    FROM   entity_properties        WITH(NOLOCK)                                
    WHERE  entp_ent_id           IN (SELECT entm_id FROM #entm)                                                    
    AND    entp_deleted_ind       = 1                                                    
    --                                                    
    INSERT INTO #addr         
    (pk                                                    
    ,code                                                    
    ,add1                                                    
    ,add2                                                    
    ,add3                                                    
    ,add4                                    
    ,pin                                      
    )                                                    
    --                                                    
    SELECT entac.entac_ent_id                                                    
         , entac.entac_concm_cd                                                         
         , convert(varchar(36),adr.adr_1)                                                    
         , convert(varchar(36),adr.adr_2)                                                    
         , convert(varchar(36),adr.adr_3)                                                    
         , convert(varchar(36),isnull(adr.adr_city,''))                                                    
         , convert(varchar(6),adr.adr_zip)                                      
    FROM   addresses                 adr     WITH (NOLOCK)                                                    
         , entity_adr_conc           entac   WITH (NOLOCK)                                             
    WHERE  entac.entac_adr_conc_id = adr.adr_id                                                    
    AND    entac.entac_ent_id     IN (SELECT entm_id FROM #entm)                                                    
    AND    adr.adr_deleted_ind     = 1                                                    
    AND    entac.entac_deleted_ind = 1                                                    
    --                                                    
    INSERT INTO #conc                                                    
    (pk                                                    
    ,code                                                    
    ,value                                    
    )                                                    
    SELECT entac.entac_ent_id                                                    
         , entac.entac_concm_cd                                                    
         , convert(varchar(75), conc.conc_value)                                                    
    FROM   contact_channels          conc    WITH (NOLOCK)                                                   
         , entity_adr_conc           entac   WITH (NOLOCK)                                                     
    WHERE  entac.entac_adr_conc_id = conc.conc_id                                                    
    AND    entac.entac_ent_id     IN (SELECT entm_id FROM #entm)                                                    
    AND    conc.conc_deleted_ind   = 1                                                    
    AND    entac.entac_deleted_ind = 1                           
    --                                                    
    SET @c_cursor_bm = CURSOR fast_forward FOR Select entm_id, entm_name1, entm_short_name, entm_created_by, entm_created_dt, entm_modified FROM #entm                                                     
    --                             
    OPEN @c_cursor_bm                                                    
    --                                                    
    FETCH NEXT FROM @c_cursor_bm INTO @c_entm_id, @c_entm_name1, @c_entm_short_name, @c_entm_created_by, @c_entm_created_dt, @c_entm_modified                                                    
    --                                                     
    WHILE @@fetch_status = 0                                                    
    BEGIN --#cursor                                                    
    --                                                    
      SELECT @l_bm_branchcd      = @c_entm_name1                                                    
      --                   
     SELECT @l_bm_branchname    = @c_entm_short_name                                                    
      --                                                    
      SELECT @l_bm_contact       = convert(varchar(45), value) FROM #entity_properties2 WHERE code= 'CONTACT_PERSON' and pk = @c_entm_id                                   
      --                                                    
      SELECT @l_bm_add1          = add1                                                    
           , @l_bm_add2          = add2             
           , @l_bm_add3          = add3                                                    
  , @l_bm_city          = add4                                                    
           , @l_bm_pin           = pin                                                    
      FROM   #addr                                                    
      WHERE  pk                  = @c_entm_id                                                    
      AND    code                = 'OFF_ADR1'                                                    
      --                                                    
      SELECT @l_bm_phone         = convert(varchar(24),value) FROM #conc WHERE code = 'PHONE1' AND pk = @c_entm_id                                                    
      --                                                    
      SELECT @l_bm_fax           = convert(varchar(15),value) FROM #conc WHERE code = 'FAX1' AND pk = @c_entm_id                                                    
      --                                                    
      SELECT @l_bm_email         = convert(varchar(75),value) FROM #conc WHERE code = 'EMAIL1' AND pk = @c_entm_id                                                    
      --                                                    
      SELECT @l_bm_allow         = ''                                                    
      SELECT @l_bm_batchno       = 0                                                    
      SELECT @l_bm_ip_add        = ''                         
      SELECT @l_bm_dialup        = ''                                                    
      SELECT @l_bm_server        = ''                                                    
      SELECT @l_bm_database      = ''                                                    
      SELECT @l_bm_dbo           = ''                                                    
     SELECT @l_bm_user          = ''                                                    
      SELECT @l_bm_pwd           = ''                                                    
      SELECT @l_bm_workarea   = ''                                                    
      SELECT @l_mkrid1           = convert(char(8),@c_entm_created_by)                                                         
      SELECT @l_mkrdt1           = convert(datetime,@c_entm_created_dt  )                                                    
      SELECT @l_bm_percentage    = 0                                                    
      SELECT @l_bm_flag          = ''                                                    
      SELECT @l_bm_type          = ''                                                    
      --                                                    
      INSERT INTO branch_mstr_nsdl VALUES                                                    
      (@l_bm_branchcd                                                         
      ,@l_bm_branchname                                                       
      ,@l_bm_contact                                                          
      ,@l_bm_add1                                                             
      ,@l_bm_add2                                                    
      ,@l_bm_add3                                                             
      ,@l_bm_city                         
      ,@l_bm_pin                                                              
      ,@l_bm_phone      
      ,@l_bm_fax                                                              
      ,@l_bm_email                                                            
      ,@l_bm_allow                                                            
      ,@l_bm_batchno                                                          
      ,@l_bm_ip_add                                                           
      ,@l_bm_dialup                                                           
      ,@l_bm_server                                                           
      ,@l_bm_database                                                         
      ,@l_bm_dbo                                                              
      ,@l_bm_user                                                             
      ,@l_bm_pwd                    
      ,@l_bm_workarea                                                         
      ,@l_mkrid1                                                               
      ,@l_mkrdt1                                       
      ,@l_bm_percentage                                                       
      ,@l_bm_flag                                                             
      ,@l_bm_type                                                    
      ,@c_entm_modified                                                    
      ,0                                                    
      )                                                  
      --                                                    
      SET @l_bm_branchcd = ''                                                         
      SET @l_bm_branchname = ''                                                            
      SET @l_bm_contact = ''                                                               
      SET @l_bm_add1 = ''                                                                  
      SET @l_bm_add2 = ''                                                                  
      SET @l_bm_add3 = ''                                                                  
 SET @l_bm_city = ''                                            
      SET @l_bm_pin = ''                                                                   
      SET @l_bm_phone = ''                                                                 
      SET @l_bm_fax = ''                                                                   
      SET @l_bm_email = ''                                                                 
      SET @l_bm_allow = ''                                                                 
      SET @l_bm_batchno  = null                                                              
      SET @l_bm_ip_add  = ''                       
      SET @l_bm_dialup = ''                                                                
      SET @l_bm_server = ''                                                                
      SET @l_bm_database = ''                                                              
      SET @l_bm_dbo = ''                                                                   
      SET @l_bm_user = ''                                                                  
      SET @l_bm_pwd = ''                                                                   
      SET @l_bm_workarea  = ''            
      SET @l_mkrid1 = ''                                                                    
      SET @l_mkrdt1 = ''                                                                    
      SET @l_bm_percentage = null                                                            
      SET @l_bm_flag = ''                                                                  
      SET @l_bm_type  = ''                                                         
      --                                                      
      FETCH NEXT FROM @c_cursor_bm INTO @c_entm_id, @c_entm_name1, @c_entm_short_name, @c_entm_created_by, @c_entm_created_dt, @c_entm_modified           
    --                                                     
    END --#cursor                                                    
    --                                                    
    CLOSE @c_cursor_bm                                                    
    DEALLOCATE @c_cursor_bm                                                    
  --                                 
  --END--BM                                                    
--                                                    
END

GO
