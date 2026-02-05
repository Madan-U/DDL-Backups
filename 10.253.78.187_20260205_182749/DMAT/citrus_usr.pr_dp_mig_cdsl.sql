-- Object: PROCEDURE citrus_usr.pr_dp_mig_cdsl
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--pr_dp_mig_cdsl '03/02/2008','04/02/2008','','','',''                                            
--select * from client_export_cdsl                                            
--select * from client_otheraddress                              
--delete from client_checklist_cdsl                   
--select * from client_checklist_cdsl          
--pr_dp_mig_nsdl '04/02/2007','04/02/2008','','','',''                                            
--                       
--Alter table client_checklist_cdsl                    
--alter column mkrdt varchar(11)                    
                    
CREATE PROCEDURE [citrus_usr].[pr_dp_mig_cdsl](@pa_from_dt    varchar(10)                                            
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
  DECLARE @c_cursor    CURSOR                                                
  --                                            
  CREATE TABLE #entity_properties                                            
  (code         varchar(25)                                            
  ,value        varchar(50)                                            
  )                                            
                                              
  --                                            
  CREATE TABLE #entity_property_dtls                                            
  (code1        varchar(25)                                            
  ,code2        varchar(25)                                            
  ,value        varchar(50)                                            
  )                                            
                                              
  --                                            
  CREATE TABLE #account_properties                                            
  (code         varchar(25)                                            
  ,value        varchar(50)                                            
  )                                            
                                              
  --                                            
  CREATE TABLE #account_property_dtls                                            
  (code1        varchar(25)                                            
  ,code2        varchar(25)                                            
  ,value        varchar(50)                                            
  )                                            
                                              
  --                                            
  CREATE TABLE #conc                                            
  (pk           numeric                                            
  ,code         varchar(20)                                            
  ,value        varchar(24)                                                
  )                                            
                                              
  --                                            
  CREATE TABLE #addr                                            
  (pk          numeric                                            
  ,code        varchar(50)                                            
  ,add1        varchar(50)                                            
  ,add2        varchar(50)                    
  ,add3        varchar(50)                                            
  ,city        varchar(50)                                            
  ,state       varchar(50)                
  ,country     varchar(50)                                             
  ,pin         varchar(7)                      
  )                                            
  --                                            
  --IF @pa_tab = 'CE'                                
  --BEGIN--CE                                            
  --                                            
    DECLARE @l_brcode                      char(6)                                            
          , @l_instrno                       varchar(9)                    
          , @l_name                          varchar(100)                                            
          , @l_middlename                    varchar(20)                                            
          , @l_lastname                      varchar(20)                                            
          , @l_title                      varchar(10)                                            
          , @l_suffix                        varchar(10)                                            
    , @l_fathername                    varchar(50)                                            
          , @l_add1                          varchar(30)                       
          , @l_add2                          varchar(30)                                            
          , @l_add3                          varchar(30)                                            
          , @l_city                          varchar(25)                                        
          , @l_state                         varchar(25)                                            
          , @l_country                       varchar(25)                                        
          , @l_pin                           varchar(10)                                            
          , @l_phoneindicator                char(1)                                            
          , @l_tele1                         varchar(17)                                
          , @l_phoneindicator2               char(1)                                            
          , @l_tele2                         varchar(17)                                            
          , @l_tele3                         varchar(100)                                            
          , @l_fax                           varchar(17)                                            
          , @l_panno          varchar(25)                                            
          , @l_itcircle                      varchar(15)                                            
          , @l_email                         varchar(50)                                            
          , @l_usertext1              varchar(50)                                            
          , @l_usertext2                     varchar(50)                                            
          , @l_userfield1     int                                            
          , @l_userfield2                    int                                            
          , @l_userfield3                    int                                            
          , @l_sechname                      varchar(100)                                            
          , @l_sechmiddle                    varchar(20)                                            
          , @l_sechlastname                  varchar(20)                                            
          , @l_sechtitle                     varchar(10)                                            
    , @l_sechsuffix                    varchar(10)                                            
          , @l_sechfathername                varchar(50)                                            
          , @l_sechpanno                     varchar(25)                    
          , @l_sechitcircle                  varchar(15)                                            
          , @l_thirdname                     varchar(100)                                            
          , @l_thirdmiddle                   varchar(20)                                           
          , @l_thirdlastname           varchar(20)                                            
          , @l_thirdtitle                    varchar(10)                                 
          , @l_thirdsuffix                   varchar(10)                                            
          , @l_thirdfathername               varchar(50)         
 , @l_thirdpanno                    varchar(25)                                            
          , @l_thirditcircle                 varchar(15)                                            
          , @l_dateofmaturity                char(8)                                            
          , @l_dpintrefno                    varchar(10)                                            
          , @l_dateofbirth                   char(8)                
          , @l_sexcode                       char(1)                                            
          , @l_occupation                    char(4)                                            
          , @l_lifestyle                     char(4)                                
          , @l_geographical                  char(4)                                            
          , @l_degree                        char(4)                                            
          , @l_annualincome                  int                                   
          , @l_nationality                   char(3)                                            
          , @l_legalstatus                   varchar(2)                                            
          , @l_feetype                       varchar(2)                                         
          , @l_language                      varchar(2)                                            
          , @l_category                      varchar(2)                                            
          , @l_bankoption                    varchar(2)                                            
          , @l_staff                         char(1)                                            
          , @l_staffcode                     varchar(10)                                            
          , @l_securitycode                  varchar(2)                                            
          , @l_bosettlementplanflag          char(1)                                           
          , @l_voicemail                     varchar(15)                                            
          , @l_rbirefno                      varchar(30)                                            
          , @l_rbiappdate                    char(8)                                            
    , @l_sebiregno                     varchar(24)                                            
          , @l_taxdeduction                  varchar(2)                                            
          , @l_smartcardreq                  char(1)                                            
          , @l_smartcardno                   varchar(20)                                            
          , @l_smartcardpin           numeric(13)                                            
          , @l_ecs                           char(1)                                            
          , @l_electronicconfirm             char(1)                                            
          , @l_dividendcurrency              numeric(9)                                            
          , @l_groupcd                       varchar(8)                                            
          , @l_bosubstatus                   varchar(4)                                            
          , @l_ccid                          numeric(9)                  
          , @l_cmid                          varchar(8)                                            
         , @l_stockexchange                 varchar(2)                                            
          , @l_confirmation                  char(1)                                            
          , @l_tradingid                     varchar(8)                                            
          , @l_bostatementcycle              char(2)                                            
          , @l_branchno                      char(12)                                            
          , @l_bankacno  varchar(20)                                            
          , @l_bankccy                       numeric(9)                                            
          , @l_bankacttype                   char(2)                                            
          , @l_micr    varchar(12)                                            
          , @l_divbankcode                   char(12)                                            
          , @l_divbranchno                   char(12)                                            
          , @l_divbankacno                   varchar(20)               
          , @l_divbankccy                    numeric(9)                                            
          , @l_poaid     varchar(16)                                            
          , @l_poaname                       varchar(100)                                            
          , @l_poamiddlename                 varchar(20)                                            
          , @l_poalastname                   varchar(20)                                            
          , @l_poatitle                      varchar(10)                                            
          , @l_poasuffix                     varchar(10)                               
          , @l_poafathername                 varchar(50)                                            
          , @l_poaadd1                       varchar(30)                                            
          , @l_poaadd2                       varchar(30)                                            
          , @l_poaadd3                       varchar(30)                                            
          , @l_poacity        varchar(25)                                            
          , @l_poastate                      varchar(25)                                            
          , @l_poacountry                    varchar(25)                                            
          , @l_poapin                        varchar(10)                                       
          , @l_poateleindicator              char(1)                                            
          , @l_poatele1                      varchar(17)                                            
  , @l_poateleindicator2             char(1)                                            
          , @l_poatele2                      varchar(17)                      
          , @l_poatele3                      varchar(100)                                            
          , @l_poafax                        varchar(17)                                            
          , @l_poapanno                      varchar(25)                                            
          , @l_poaitcircle                   varchar(15)                                            
          , @l_poaemail                      varchar(50)                                            
          , @l_setupdate                     varchar(11)                                            
          , @l_operateaccount                char(1)                                            
          , @l_gpaflag                       char(1)                                            
          , @l_effectivefrom                 varchar(11)                                            
          , @l_effectiveto                   varchar(11)            
          , @l_cacharfield                   varchar(50)                                            
          , @l_chequecash                    char(1)                                            
          , @l_chqno                         varchar(10)                                            
          , @l_recvdate                      Varchar(11)                                            
          , @l_rupees    money                                            
          , @l_drawn                         varchar(50)                                            
          , @l_chgsscheme                    char(10)                                            
          , @l_billcycle                     char(1)                                            
  , @l_brboffcode                    char(6)                                            
          , @l_familycd                      char(3)                                            
          , @l_statements                    char(1)                                            
        , @l_billflag                      char(1)                
          , @l_allowcredit                   money                                            
          , @l_billcode                      char(16)                                            
          , @l_collectioncode                char(16)                                            
          , @l_upfront                       char(1)                                            
          , @l_keepsettlement        char(1)                                            
          , @l_fre_trx                       char(10)--tinyint                                            
          , @l_fre_hold                      char(10)                                            
          , @l_fre_bill                      tinyint--char(10)                                            
          , @l_allow                         char(1)                                            
          , @l_batchno                       int                                            
          , @l_cmcd                          varchar(16)                                            
          , @l_corresadd1                    varchar(30)                                            
          , @l_corresadd2                    varchar(30)                         
          , @l_corresadd3                    varchar(30)                                            
          , @l_correscity                    varchar(25)                                            
          , @l_corresstate                   varchar(25)                                            
        , @l_correscountry                 varchar(25)                                            
          , @l_correspin                     varchar(10)                                   
          , @l_correstele1                   varchar(17)                                            
          , @l_correstele2                   varchar(17)                                            
          , @l_correstele3                   varchar(100)                                            
          , @l_corresfax                     varchar(17)                                            
          , @l_blsavingcd                    char(20)                             
          , @l_errormsg                      varchar(120)                                            
          , @l_nominee                       varchar(100)                                            
          , @l_nomineeadd1                   varchar(30)                                            
          , @l_nomineeadd2                   varchar(30)                                            
          , @l_nomineeadd3                   varchar(30)                                    
          , @l_nomineecity                   varchar(25)                                            
          , @l_nomineestate                  varchar(25)                                     
          , @l_nomineecountry                varchar(25)                                            
          , @l_nomineepin                    varchar(10)                                            
          , @l_nominee_dob                   varchar(11)                                            
          , @l_fadd1                         varchar(30)                                            
          , @l_fadd2                     varchar(30)                    
          , @l_fadd3                         varchar(30)                                            
          , @l_fcity                         varchar(25)                                            
          , @l_fstate                        varchar(25)                                            
          , @l_fcountry                      varchar(25)                                            
          , @l_fpin                          varchar(10)                                            
        , @l_ftele                         varchar(17)                                            
          , @l_ffax                          varchar(17)                                            
          , @l_mkrdt                         char(11)                                            
          , @l_mkrid    char(8)                                            
          , @l_nominee_search                varchar(20)                                            
          , @l_authid                        char(8)                                            
          , @l_authdt                        char(8)                                            
          , @l_remark                        char(100)                                            
          , @l_inwarddt                      char(8)                                        
          , @l_authtm                        char(8)                                            
          , @l_mkrtm                         char(8)                                            
          , @l_nomineemiddlename             varchar(20)                                          
          , @l_nomineetitle                  varchar(10)                                            
          , @l_nomineesuffix                 varchar(10)                              
          , @l_nomineefathername             varchar(50)                                            
          , @l_nomineephoneindicator         char(1)                                            
          , @l_nomineetele1                  char(17)                                            
          , @l_remisser                      char(16)                                            
          , @l_poaforpayin                   char(1)                                            
          , @l_poaregdate                    char(11)                                            
          , @c_crn_no                        numeric                                  
          , @c_dpam_id                       numeric                                            
          , @c_acct_no                       varchar(25)                                            
          , @c_sba_no                        varchar(25)                                            
          , @l_values                        varchar(8000)                                            
          , @l_modified               char(1)                                             
    --                                            
    IF EXISTS(SELECT TOP 1 * FROM client_export_cdsl WITH (NOLOCK))                                            
    BEGIN--#                                            
    --                                            
      INSERT INTO client_export_cdsl_hst                                       
      (cx_dpam_id                                            
      ,cx_brcode                                                                          
      ,cx_instrno                     
      ,cx_name                                                                            
      ,cx_middlename                                                                      
      ,cx_lastname                                                                        
      ,cx_title                                                                           
      ,cx_suffix                                                                          
      ,cx_fathername                                                         
      ,cx_add1                                                                 
,cx_add2                                                                            
      ,cx_add3                                                                            
      ,cx_city                                                                            
      ,cx_state                                                                           
      ,cx_country                                                                         
      ,cx_pin                                                                      
      ,cx_phoneindicator                                                                  
      ,cx_tele1                                                                           
      ,cx_phoneindicator2                                              
      ,cx_tele2                                                                        
      ,cx_tele3                                                                           
      ,cx_fax                                                                             
      ,cx_panno                                                                           
      ,cx_itcircle                                                                        
      ,cx_email                                                                           
      ,cx_usertext1                                                                       
      ,cx_usertext2                                                                       
      ,cx_userfield1                                                             
     ,cx_userfield2                                                                      
      ,cx_userfield3                                                                
      ,cx_sechname                                                                        
      ,cx_sechmiddle                                                                      
      ,cx_sechlastname                                                                    
      ,cx_sechtitle                                                                       
      ,cx_sechsuffix                          
      ,cx_sechfathername                                                                  
      ,cx_sechpanno                                                                       
      ,cx_sechitcircle                                                                    
      ,cx_thirdname                                                                       
      ,cx_thirdmiddle                                                                     
      ,cx_thirdlastname                                                         
      ,cx_thirdtitle                                                                      
      ,cx_thirdsuffix                                                                    
      ,cx_thirdfathername                                                                 
      ,cx_thirdpanno                                                                      
      ,cx_thirditcircle                                                                   
      ,cx_dateofmaturity                                                                  
     ,cx_dpintrefno                                                                      
      ,cx_dateofbirth                                      
      ,cx_sexcode                                                                         
      ,cx_occupation                                                                      
      ,cx_lifestyle                                                                       
      ,cx_geographical                                                         
      ,cx_degree                                                                          
      ,cx_annualincome                                                                    
      ,cx_nationality                                                                     
      ,cx_legalstatus                                         
      ,cx_feetype                                                                         
      ,cx_language                                                           
      ,cx_category                                                                        
      ,cx_bankoption                                                                      
      ,cx_staff                                                                           
      ,cx_staffcode                                                                       
      ,cx_securitycode                                                    
      ,cx_bosettlementplanflag                                                            
      ,cx_voicemail                                                    
      ,cx_rbirefno                                                                        
      ,cx_rbiappdate                                                                      
      ,cx_sebiregno                                                                       
      ,cx_taxdeduction                                                                    
      ,cx_smartcardreq                                                     
      ,cx_smartcardno                                                                     
      ,cx_smartcardpin                                                                    
      ,cx_ecs                                                                             
      ,cx_electronicconfirm                                                               
      ,cx_dividendcurrency                                                                
      ,cx_groupcd                                                                         
      ,cx_bosubstatus                                                
      ,cx_ccid            
      ,cx_cmid                                                                            
      ,cx_stockexchange                                                                   
      ,cx_confirmation                                                                    
      ,cx_tradingid                                                                       
      ,cx_bostatementcycle                                                                
      ,cx_branchno                                                                        
      ,cx_bankacno                                                                        
      ,cx_bankccy                                                          
      ,cx_bankacttype                                          
      ,cx_micr                                                                            
      ,cx_divbankcode                                                                     
      ,cx_divbranchno                                                                     
   ,cx_divbankacno                                                                     
      ,cx_divbankccy                                                                      
      ,cx_poaid                                                                           
      ,cx_poaname                                                                         
      ,cx_poamiddlename                        
      ,cx_poalastname                                                                     
      ,cx_poatitle                                                                        
      ,cx_poasuffix                                                                       
      ,cx_poafathername                                                                
      ,cx_poaadd1                                                                         
      ,cx_poaadd2                                                                         
      ,cx_poaadd3                                                                         
      ,cx_poacity                                                                         
      ,cx_poastate                         
      ,cx_poacountry                                                                      
      ,cx_poapin                                                                          
      ,cx_poateleindicator                                                                
      ,cx_poatele1                                                                        
      ,cx_poateleindicator2                                                               
      ,cx_poatele2                                     
      ,cx_poatele3                                                                        
      ,cx_poafax                                                                            ,cx_poapanno                                                                        
      ,cx_poaitcircle                                                                     
      ,cx_poaemail                                                                        
      ,cx_setupdate                                                                       
      ,cx_operateaccount                                                                  
      ,cx_gpaflag                                                                         
      ,cx_effectivefrom                                                                   
      ,cx_effectiveto                           
      ,cx_cacharfield                                                                     
  ,cx_chequecash                                                                      
      ,cx_chqno                                                                           
      ,cx_recvdate                                                                      
      ,cx_rupees                                                                          
      ,cx_drawn                                                                           
      ,cx_chgsscheme                                                                      
      ,cx_billcycle                                                                       
      ,cx_brboffcode                                               
      ,cx_familycd                                                                        
      ,cx_statements                                                                      
      ,cx_billflag                                                                        
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
      ,cx_corresadd1                                                                      
      ,cx_corresadd2                                                                      
      ,cx_corresadd3                                                                      
      ,cx_correscity                                                
      ,cx_corresstate                                                                     
      ,cx_correscountry                                                                   
      ,cx_correspin                                                                       
      ,cx_correstele1                        
      ,cx_correstele2                                                                     
      ,cx_correstele3                                                                     
      ,cx_corresfax                                                                       
      ,cx_blsavingcd                                                                      
      ,cx_errormsg                                                                        
      ,cx_nominee                                                                         
      ,cx_nomineeadd1                                                            
      ,cx_nomineeadd2                                                                     
      ,cx_nomineeadd3                         
   ,cx_nomineecity                                                                     
      ,cx_nomineestate                                                             
      ,cx_nomineecountry                                                                  
      ,cx_nomineepin                                                                      
      ,cx_nominee_dob                                                                     
      ,cx_fadd1                                                                           
      ,cx_fadd2                                                                           
      ,cx_fadd3                      
      ,cx_fcity             
      ,cx_fstate                                                                          
      ,cx_fcountry                                                                        
      ,cx_fpin                                                                            
      ,cx_ftele                             
      ,cx_ffax                                                                            
      ,cx_mkrdt                                                                           
      ,cx_mkrid                                                                           
      ,cx_nominee_search                                                                  
      ,cx_authid                                                                   
      ,cx_authdt                                                                          
      ,cx_remark                                                                          
      ,cx_inwarddt                                                                        
      ,cx_authtm                                                                          
      ,cx_mkrtm                                                                           
      ,cx_nomineemiddlename                                                               
      ,cx_nomineetitle                                                                    
      ,cx_nomineesuffix                                                                   
      ,cx_nomineefathername                                                               
      ,cx_nomineephoneindicator                                                           
      ,cx_nomineetele1               ,cx_remisser                                                                        
      ,cx_poaforpayin                                                                     
      ,cx_poaregdate                                                                      
      ,cx_edittype                                                                        
      ,cx_cmpltd                                                  
      )                                            
      SELECT cx_dpam_id                                            
           , cx_brcode                                                                          
           , cx_instrno                                                                         
           , cx_name                                                                            
           , cx_middlename                                   
           , cx_lastname                       
           , cx_title                                                                           
, cx_suffix                                                                          
           , cx_fathername                                                                      
           , cx_add1                                                                            
           , cx_add2                                                                            
           , cx_add3                                                          
           , cx_city                                                                            
           , cx_state                                                                           
           , cx_country                                                             
           , cx_pin                                                                             
           , cx_phoneindicator                             
           , cx_tele1                                                                           
           , cx_phoneindicator2                                                                 
           , cx_tele2                                                                           
        , cx_tele3                                                                           
           , cx_fax                                                                             
           , cx_panno                                                                           
    , cx_itcircle                                                                        
           , cx_email                                                                           
           , cx_usertext1                                                              
           , cx_usertext2                                                                       
           , cx_userfield1                                                                      
           , cx_userfield2                                                                      
           , cx_userfield3                                                                      
           , cx_sechname                                                                        
           , cx_sechmiddle                                                                      
           , cx_sechlastname                                                                    
           , cx_sechtitle                                                            
           , cx_sechsuffix                                                                      
           , cx_sechfathername                                                       
           , cx_sechpanno                                                                       
           , cx_sechitcircle                                                                    
           , cx_thirdname                                                        
           , cx_thirdmiddle                                        
           , cx_thirdlastname                                                                   
           , cx_thirdtitle                                                                      
           , cx_thirdsuffix                                                                     
           , cx_thirdfathername                                                                 
           , cx_thirdpanno                                                                      
           , cx_thirditcircle                                                                   
           , cx_dateofmaturity                                                                  
           , cx_dpintrefno                                                                      
           , cx_dateofbirth                                                                     
           , cx_sexcode                                                     
           , cx_occupation                                                                      
           , cx_lifestyle                                                                       
, cx_geographical                                                           
           , cx_degree                                                          
           , cx_annualincome                                                                    
           , cx_nationality                                           
           , cx_legalstatus                                                                     
           , cx_feetype                                                                         
           , cx_language                                                                        
           , cx_category                 
           , cx_bankoption                                                                      
           , cx_staff                                                                           
           , cx_staffcode                                                                       
           , cx_securitycode                                                                    
           , cx_bosettlementplanflag                                                            
           , cx_voicemail                                                                       
           , cx_rbirefno                                                           
           , cx_rbiappdate                                                                      
           , cx_sebiregno                                                                       
           , cx_taxdeduction                                                                 
           , cx_smartcardreq                                                                    
           , cx_smartcardno                                                                     
           , cx_smartcardpin                                                                    
           , cx_ecs                                                                             
           , cx_electronicconfirm                                                               
           , cx_dividendcurrency                                                                
           , cx_groupcd                                                                         
           , cx_bosubstatus                                                                     
           , cx_ccid                                    
           , cx_cmid                                                                            
           , cx_stockexchange                            
           , cx_confirmation                                  
           , cx_tradingid                                                                       
    , cx_bostatementcycle                                                                
           , cx_branchno                                                                        
           , cx_bankacno                                                                        
           , cx_bankccy                                                                         
           , cx_bankacttype                                                                     
       , cx_micr                                                                            
           , cx_divbankcode                                                                     
           , cx_divbranchno                                                                     
           , cx_divbankacno                                                                     
           , cx_divbankccy                                          
           , cx_poaid                                                                           
           , cx_poaname                                                                         
      , cx_poamiddlename                                                                   
           , cx_poalastname                                                                     
           , cx_poatitle                                                                        
           , cx_poasuffix                                                                       
           , cx_poafathername                                                                   
           , cx_poaadd1                                                                   
           , cx_poaadd2                                                                         
           , cx_poaadd3                                                                         
           , cx_poacity                                                                         
           , cx_poastate                                                    
           , cx_poacountry                                                       
           , cx_poapin                                                                          
         , cx_poateleindicator                                                        
           , cx_poatele1                                                                        
           , cx_poateleindicator2                                                               
           , cx_poatele2                                                                        
           , cx_poatele3                                           
           , cx_poafax                                                                          
           , cx_poapanno                                                                        
           , cx_poaitcircle                                                                     
           , cx_poaemail                                                                        
    , cx_setupdate                                                                       
           , cx_operateaccount                                                   
           , cx_gpaflag                                                                         
     , cx_effectivefrom                                                                   
           , cx_effectiveto                                                                     
           , cx_cacharfield                                
           , cx_chequecash                                                                      
           , cx_chqno                                                                           
           , cx_recvdate                                                                        
           , cx_rupees                                                                          
           , cx_drawn                                                                           
           , cx_chgsscheme                                           
           , cx_billcycle                                                        
           , cx_brboffcode                                                                    
           , cx_familycd                                                             
           , cx_statements                                                                      
           , cx_billflag                                                                        
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
           , cx_corresadd1                         
           , cx_corresadd2                                                                      
           , cx_corresadd3                                                                      
           , cx_correscity                                                                      
           , cx_corresstate                                                                     
           , cx_correscountry                                                                   
           , cx_correspin                                                                       
           , cx_correstele1                                    
           , cx_correstele2                                                                     
           , cx_correstele3                                                                     
           , cx_corresfax                                                                       
           , cx_blsavingcd                                                                      
           , cx_errormsg                                                                        
           , cx_nominee                                                                         
           , cx_nomineeadd1                                                                     
           , cx_nomineeadd2                                                             
           , cx_nomineeadd3                                                                     
     , cx_nomineecity                                                                     
           , cx_nomineestate           
           , cx_nomineecountry                                                                  
           , cx_nomineepin                                                                      
           , cx_nominee_dob                                                         
           , cx_fadd1                                                                           
           , cx_fadd2                                                                           
  , cx_fadd3                                                                           
           , cx_fcity                                                                           
           , cx_fstate                                                                          
           , cx_fcountry                                                                        
           , cx_fpin                                                        
           , cx_ftele                                                                           
           , cx_ffax                                                                            
           , cx_mkrdt                         
           , cx_mkrid                                                              
           , cx_nominee_search                                                                  
           , cx_authid                                                                          
           , cx_authdt                                                                          
           , cx_remark                                                                          
           , cx_inwarddt                   
           , cx_authtm                                                                          
           , cx_mkrtm                                                                           
           , cx_nomineemiddlename                                                               
           , cx_nomineetitle                   
           , cx_nomineesuffix                                                                 
           , cx_nomineefathername                                                               
           , cx_nomineephoneindicator                                                           
           , cx_nomineetele1                                                                    
           , cx_remisser                                  
           , cx_poaforpayin                                                                     
           , cx_poaregdate                                                                      
           , cx_edittype                                                                        
           , 1                                                                          
     FROM    client_export_cdsl                                            
     WHERE   cx_cmpltd  = 1                                             
     --                                             
     DELETE FROM client_export_cdsl                        
     WHERE  cx_cmpltd  = 1                                            
   --                                            
   END--#                                            
                                            
    --dp_holder_details                                             
    CREATE TABLE #dp_holder_dtls                                            
    (dphd_dpam_sba_no   varchar(20)                                            
    ,dphd_sh_fname      varchar(100)                                              
    ,dphd_sh_mname      varchar(50)                                              
    ,dphd_sh_lname      varchar(50)                                              
    ,dphd_sh_fthname    varchar(100)                                              
    ,dphd_sh_dob        datetime                                             
    ,dphd_sh_pan_no     varchar(15)                                              
    ,dphd_sh_gender     varchar(1)                                              
    ,dphd_th_fname      varchar(100)                                              
    ,dphd_th_mname      varchar(50)          
    ,dphd_th_lname      varchar(50)                                              
    ,dphd_th_fthname    varchar(100)                                              
   ,dphd_th_dob        datetime                                             
    ,dphd_th_pan_no     varchar(15)                                              
    ,dphd_th_gender     varchar(1)                                              
    ,dphd_poa_fname     varchar(100)                                   
    ,dphd_poa_mname     varchar(50)                                              
    ,dphd_poa_lname     varchar(50)                       
    ,dphd_poa_fthname   varchar(100)                                   
    ,dphd_poa_dob       datetime                                             
    ,dphd_poa_pan_no    varchar(15)                                              
    ,dphd_poa_gender    varchar(1)                                              
 ,dphd_nom_fname     varchar(100)                                              
    ,dphd_nom_mname     varchar(50)                                              
    ,dphd_nom_lname     varchar(50)                                              
    ,dphd_nom_fthname   varchar(100)                                              
    ,dphd_nom_dob       datetime                                        
    ,dphd_nom_pan_no    varchar(15)                                              
    ,dphd_nom_gender    varchar(1)                                              
    ,dphd_gau_fname     varchar(100)                                              
    ,dphd_gau_mname     varchar(50)                                              
    ,dphd_gau_lname     varchar(50)                                              
    ,dphd_gau_fthname   varchar(100)                                              
    ,dphd_gau_dob       datetime      
    ,dphd_gau_pan_no    varchar(15)                                              
    ,dphd_gau_gender    varchar(1)                                              
    ,dphd_fh_fthname    varchar(100)                                              
    )                                            
    --                                            
    IF isnull(@pa_from_dt,'') <> '' AND isnull(@pa_to_dt,'') <> '' AND isnull(@pa_from_crn,'') <> '' AND isnull(@pa_to_crn,'') <> ''                                            
    BEGIN              --                                            
      SET @c_cursor = CURSOR fast_forward FOR                                             
      SELECT DISTINCT  dpam.dpam_crn_no      crn_no                         
           , dpam.dpam_id                   dpam_id                                                       
           , dpam.dpam_acct_no               acct_no                                                        
           , dpam.dpam_sba_no                sba_no                                                     
      FROM   exch_seg_mstr                   excsm    WITH (NOLOCK)                                                        
           , status_mstr                    sm       WITH (NOLOCK)                                                    
           , dp_mstr                         dpm      WITH (NOLOCK)                                                    
           , dp_acct_mstr                    dpam     WITH (NOLOCK)                                                    
           , product_mstr                    prom                                                      
           , excsm_prod_mstr                 excpm                                                  
      WHERE  dpam.dpam_excsm_id           =  excsm.excsm_id                                                  
      AND    excsm.excsm_id               =  excpm.excpm_excsm_id                                            
      AND    dpam_lst_upd_dt                 between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                              
      AND    dpam_crn_no                     between convert(numeric, @pa_from_crn)  AND  convert(numeric, @pa_to_crn)                                            
      AND    prom.prom_cd            =  '01'                                                 
      AND    excsm.excsm_exch_cd          =  'CDSL'                                         
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
, dpam.dpam_id                    dpam_id                                                       
           , dpam.dpam_acct_no               acct_no                                                        
           , dpam.dpam_sba_no                sba_no                                                     
      FROM   exch_seg_mstr                   excsm    WITH (NOLOCK)                                                        
           , status_mstr                     sm       WITH (NOLOCK)                                                    
           , dp_mstr                         dpm      WITH (NOLOCK)                                                    
           , dp_acct_mstr                    dpam     WITH (NOLOCK)                                                    
           , product_mstr                    prom                                                      
           , excsm_prod_mstr                 excpm                                                  
      WHERE  dpam.dpam_excsm_id           =  excsm.excsm_id                              AND    excsm.excsm_id               =  excpm.excpm_excsm_id                                            
      AND    dpam_lst_upd_dt                 between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                             
      --AND    dpam_crn_no                     between convert(numeric, @pa_from_crn)  AND  convert(numeric, @pa_to_crn)                                            
      AND    prom.prom_cd                 =  '01'                                                 
      AND    excsm.excsm_exch_cd          =  'CDSL'                                            
      AND    prom.prom_id                 =  excpm.excpm_prom_id                                                  
      AND    dpam.dpam_dpm_id             =  dpm.dpm_id                                                     
      AND    dpam.dpam_stam_cd            =  sm.stam_cd                                                    
      AND    dpam.dpam_deleted_ind        =  1                                                        
      AND    excsm.excsm_deleted_ind      =  1                                                    
      AND    dpm.dpm_deleted_ind          =  1                                                    
      AND    sm.stam_deleted_ind          =  1                                                    
      AND    prom.prom_deleted_ind   =  1                                   
      AND    excpm.excpm_deleted_ind      =  1                        
    --                                              
    END         
    --                                            
    IF isnull(@pa_from_dt,'') = '' AND isnull(@pa_to_dt,'') = '' AND isnull(@pa_from_crn,'') <> '' AND isnull(@pa_to_crn,'') <> ''                                            
    BEGIN                                            
    --                                            
    SET @c_cursor = CURSOR fast_forward FOR                                             
      SELECT DISTINCT  dpam.dpam_crn_no      crn_no                                            
           , dpam.dpam_id                    dpam_id                                                       
           , dpam.dpam_acct_no               acct_no                                                        
           , dpam.dpam_sba_no                sba_no                                                     
      FROM   exch_seg_mstr                   excsm    WITH (NOLOCK)                                                        
           , status_mstr                     sm       WITH (NOLOCK)                                                    
 , dp_mstr                         dpm      WITH (NOLOCK)                                                    
           , dp_acct_mstr                    dpam     WITH (NOLOCK)                                                    
           , product_mstr                 prom                                                      
           , excsm_prod_mstr        excpm                                                  
      WHERE  dpam.dpam_excsm_id           =  excsm.excsm_id                                                  
      AND    excsm.excsm_id               =  excpm.excpm_excsm_id                                            
      AND    dpam_crn_no                     between convert(numeric, @pa_from_crn)  AND  convert(numeric, @pa_to_crn)                                            
      AND    prom.prom_cd                 =  '01'                                                 
      AND    excsm.excsm_exch_cd          =  'CDSL'                                            
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
      --DELETE FROM #pk                                     
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
      ,dphd_th_mname                                               
      ,dphd_th_lname                                               
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
      )                                           
      SELECT dphd_dpam_sba_no                                               
           , dphd_sh_fname                                                  
           , dphd_sh_mname                                                  
           , dphd_sh_lname                                     
           , dphd_sh_fthname                                                
           , dphd_sh_dob                                  
           , dphd_sh_pan_no                                                 
           , dphd_sh_gender                                                 
           , dphd_th_fname                                           
           , dphd_th_mname                                                  
           , dphd_th_lname                                                  
           , dphd_th_fthname                                                
           , dphd_th_dob                                            
           , dphd_th_pan_no                          
           , dphd_th_gender                                                 
           , dppd_fname                                                 
           , dppd_mname                              
           , dppd_lname                                                 
           , dppd_fthname                                               
           , dppd_dob                                             
           , dppd_pan_no                                       
           , dppd_gender                                                
           , dphd_nom_fname                                                 
  , dphd_nom_mname                                                 
           , dphd_nom_lname                                                 
           , dphd_nom_fthname                                               
           , dphd_nom_dob                                            
           , dphd_nom_pan_no                                                
           , dphd_nom_gender                                                
           , dphd_gau_fname                                                 
           , dphd_gau_mname                                                 
           , dphd_gau_lname                                       
           , dphd_gau_fthname                                               
           , dphd_gau_dob                              
           , dphd_gau_pan_no                            
           , dphd_gau_gender             
           , dphd_fh_fthname                                                
      FROM   dp_holder_dtls       WITH (NOLOCK)                                            
           , dp_acct_mstr         WITH (NOLOCK)                                            
             left outer join                                      
             dp_poa_dtls          WITH (NOLOCK)                                            
             on  dpam_id            =   dppd_dpam_id                                        
      WHERE  dphd_dpam_id            = dpam_id                                                
      AND    dpam_id  = @c_dpam_id                                AND    dphd_dpam_sba_no        = @c_sba_no                                             
      AND    dphd_deleted_ind   = 1                                                  
      AND    dpam_deleted_ind   = 1                                            
                                            
      --entity_properties                                            
      INSERT INTO #entity_properties                                            
      (code                                            
      ,value                                            
      )                                            
      SELECT entp_entpm_cd                                            
            ,entp_value                                             
      FROM   entity_properties                                                  
      WHERE  entp_ent_id           = @c_crn_no                                            
      AND    entp_deleted_ind      = 1                                
                   
      --entity_properties_dtls                                              
      INSERT INTO #entity_property_dtls                                            
      (code1                                            
      ,code2                                            
      ,value                                            
      )                                            
      SELECT a.entp_entpm_cd                                            
           , b.entpd_entdm_cd                                            
           , b.entpd_value                                             
      FROM   entity_properties      a  WITH (NOLOCK)                                            
           , entity_property_dtls   b  WITH (NOLOCK)                         
      WHERE  a.entp_ent_id     = @c_crn_no                                            
      AND    a.entp_id            = b.entpd_entp_id                                            
      AND    a.entp_deleted_ind   = 1                                            
      AND    b.entpd_deleted_ind  = 1                                            
                                            
      --Account properties                                             
      INSERT INTO #account_properties                                            
      (code                                            
      ,value                              
      )                                            
      SELECT accp_accpm_prop_cd                                            
    , accp_value                
      FROM   account_properties      WITH (NOLOCK)                                            
      WHERE  accp_clisba_id        = @c_dpam_id                                             
      AND    accp_deleted_ind      = 1                                            
                                                  
      --Account properties details                                            
                                         
                                    
      INSERT INTO #account_property_dtls                                            
      (code1                                            
      ,code2                                            
      ,value                                            
      )                                            
   SELECT a.accp_accpm_prop_cd                                            
           , b.accpd_accdm_cd                                            
           , b.accpd_value                                             
      FROM   account_properties      a  WITH (NOLOCK)                                            
           , account_property_dtls   b  WITH (NOLOCK)                                            
      WHERE a.accp_clisba_id      = @c_dpam_id                                             
      AND    a.accp_id     = b.accpd_accp_id                                            
      AND    a.accp_deleted_ind    = 1                                            
      AND    b.accpd_deleted_ind   = 1                                             
                                                  
      --Contact Channels--                                            
      INSERT INTO #conc                                            
      (pk                                            
      ,code                                            
      ,value                    
      )                                            
      SELECT entac.entac_ent_id                                            
           , entac.entac_concm_cd                                            
           , convert(varchar(24), conc.conc_value)                                            
      FROM   contact_channels          conc    WITH (NOLOCK)                                            
       , entity_adr_conc           entac   WITH (NOLOCK)                                             
      WHERE  entac.entac_adr_conc_id = conc.conc_id                                            
      AND    entac.entac_ent_id      = @c_crn_no                                            
      AND    conc.conc_deleted_ind   = 1       
      AND    entac.entac_deleted_ind = 1                                            
                                            
      --Addresses--                                            
      INSERT INTO #addr                                            
      (pk                                            
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
           , convert(varchar(50), entac.entac_concm_cd)                                                 
           , convert(varchar(50), adr.adr_1)                                            
           , convert(varchar(50), adr.adr_2)                                            
  , convert(varchar(50), adr.adr_3)                                            
           , convert(varchar(50), adr.adr_city)                                            
           , convert(varchar(50), adr.adr_state)                                            
           , convert(varchar(50), adr.adr_country)                                            
           , convert(varchar(7), adr.adr_zip)                                            
      FROM   addresses                 adr     WITH (NOLOCK)                                            
 , entity_adr_conc           entac   WITH (NOLOCK)                                          
      WHERE  entac.entac_adr_conc_id = adr.adr_id                                            
      AND    entac.entac_ent_id      = @c_crn_no                                            
      AND    adr.adr_deleted_ind     = 1                                            
      AND    entac.entac_deleted_ind = 1                                            
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
            
      if isnull(@l_brcode,'')  = ''       
      set  @l_brcode  = '000000'      
      --                                            
      Declare @l_Inc_dob              Varchar(25)                                    
      SELECT @l_instrno             = convert(varchar(9), @c_sba_no)                                           
      SELECT @l_Inc_dob            =  convert(varchar(25), value) FROM #entity_properties WHERE code = 'INC_DOB'                                    
      --                                      
                                              
      SELECT @l_name                = convert(varchar(100), clim.clim_name1+' '+clim.clim_short_name)                                            
           , @l_middlename          = convert(varchar(20), isnull(clim.clim_name2,''))                                            
           , @l_lastname            = convert(varchar(20), isnull(clim.clim_name3,''))                                            
           , @l_remark              = convert(varchar(100), isnull(clim.clim_rmks,''))                                             
           , @l_mkrdt               = REPLACE(CONVERT(VARCHAR(11),clim.clim_created_dt,102),'.','')                               
     , @l_mkrid               = convert(char(8), clim.clim_created_by)                                            
           , @l_dateofbirth         = case when dpam.dpam_clicm_cd in ('25') then '' else Case When REPLACE(CONVERT(VARCHAR(11),clim.clim_dob,102),'.','')='19000101' then Isnull(@l_Inc_dob,'') else REPLACE(CONVERT(VARCHAR(11),clim.clim_dob,102),'.','') end end --INC_DOB   convert(varchar(8), clim.clim_dob, 3)                                            
           , @l_sexcode             = case when dpam.dpam_clicm_cd in ('21','24') then convert(char(1), clim.clim_gender) else ''  End                                             
           , @l_category            = Isnull(dpam_enttm_cd,'') -- citrus_usr.fn_get_listing('CATEGORY',clicm.clicm_desc)                                            
         , @l_bosubstatus         = Isnull(dpam_subcm_cd,'') -- citrus_usr.fn_get_listing('BOSUBSTATUS',value) FROM #entity_properties WHERE code = 'BOSUBSTATUS'                                                 
           , @l_modified            = CASE WHEN clim.clim_created_dt = clim.clim_lst_upd_dt THEN 'I' ELSE 'U' END                                                        
           , @l_staff               = case when dpam.dpam_clicm_cd in ('25') then '' else 'N' end                                 
      FROM   client_mstr              clim  WITH (NOLOCK)                                            
           , dp_acct_mstr             dpam  WITH (NOLOCK)                                            
           , client_ctgry_mstr        clicm WITH (NOLOCK)                                            
      WHERE  clim.clim_crn_no       = @c_crn_no                                            
      AND    clim.clim_crn_no       = dpam.dpam_crn_no                                            
      AND    dpam.dpam_clicm_cd     = clicm.clicm_cd                                     
      and    dpam.dpam_id           = @c_dpam_id                                    
      AND    clim.clim_deleted_ind  = 1                                            
      AND    dpam.dpam_deleted_ind  = 1                                            
                                                  
    --SELECT @l_staff                       = case when convert(char(1), isnull(value,'N'))=1 then 'Y' else convert(char(1), isnull(value,'N')) end  FROM #entity_properties  WHERE code = 'STAFF'                                            
    --if ltrim(rtrim(isnull(@l_staff,''))) = ''  set @l_staff = 'N'                                 
                                    
     --                                            
      SELECT @l_title               = convert(varchar(25), isnull(value,'')) FROM #entity_properties WHERE code = 'TITLE'                                           
      SELECT @l_suffix              = ''                                            
      --                                            
      /* change by Latesh wani -- as permanent addr should be of first holder                                            
      --SELECT @l_values              = citrus_usr.fn_dp_mig_nsdl_dphd('ADDR',@c_dpam_id,'PER_ADR1')--citrus_usr.fn_dp_mig_nsdl_dphd('ADDR',@c_dpam_id,'FH_ADDR1')                                            
      --SELECT @l_add1                = convert(varchar(30), citrus_usr.fn_splitval(@l_values,1))       
      --     , @l_add2                = convert(varchar(30), citrus_usr.fn_splitval(@l_values,2))                                            
      --     , @l_add3                = convert(varchar(30), citrus_usr.fn_splitval(@l_values,3))                                            
      --     , @l_city                = convert(varchar(25), citrus_usr.fn_splitval(@l_values,4))                                            
      --     , @l_state               = convert(varchar(25), citrus_usr.fn_splitval(@l_values,5))                                            
      --     , @l_country             = convert(varchar(25), citrus_usr.fn_splitval(@l_values,6))                                            
      --     , @l_pin                 = convert(varchar(10), citrus_usr.fn_splitval(@l_values,7))                                            
      change by Latesh wani -- as permanent addr should be of first holder */                                            
   SELECT @l_add1            = convert(varchar(36),isnull(add1,''))                                            
   , @l_add2                 = convert(varchar(36),isnull(add2,''))                                            
   , @l_add3                 = convert(varchar(36),isnull(add3,''))                                            
      , @l_city                 = convert(varchar(36),isnull(city,''))                       
   , @l_state                 = convert(varchar(36),isnull(state,''))                              
      , @l_country                 = convert(varchar(36),isnull(country,''))                                   
      , @l_pin                  = convert(varchar(7),pin)                        FROM   #addr                               
      WHERE  code                    = 'PER_ADR1'                                            
      AND    pk                      = @c_crn_no       
    --                                                 
      SELECT @l_tele1               = ISNULL(convert(varchar(17), value),'')   from #conc WITH (NOLOCK)   WHERE  code = 'RES_PH1' AND pk = @c_crn_no                                     
      If Ltrim(Rtrim(Isnull(@l_tele1,''))) =  ''  set @l_tele1=''                                    
   SELECT @l_phoneindicator      = Case when @l_tele1='' then '' when  @l_tele1='NULL' then '' else 'R' end                                             
      --                                            
                                          
      --                                                  
      SELECT @l_tele2               = ISNULL(convert(varchar(17), value),'')   from #conc WITH (NOLOCK)   WHERE  code = 'MOBILE1' AND pk = @c_crn_no                                           
      If Ltrim(Rtrim(Isnull(@l_tele2,''))) = ''  set @l_tele2 = ''                                    
                                          
      SELECT @l_phoneindicator2     = Case when @l_tele2='' then '' when  @l_tele1='NULL' then '' else 'M' end                                                      
      --                                            
                                          
      --                                            
      SELECT @l_tele3               = ISNULL(convert(varchar(100), citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'OFF_PH1')),'')                                            
      --                                            
      SELECT @l_fax                 = ISNULL(convert(varchar(17), value),'')                                            
      FROM   #conc                    WITH (NOLOCK)                                            
      WHERE  code                   = 'FAX1'                                            
      AND    pk                     = @c_crn_no                                            
   --                                
      if ltrim(rtrim(isnull(@l_fax,'')))              = ''  set @l_fax = ''                                            
      --                                            
  SELECT @l_panno               = convert(varchar(25), value) FROM #entity_properties WHERE code = 'PAN_GIR_NO'                                            
      --                                            
      SELECT @l_itcircle            = ''                                 
      --                                            
      SELECT @l_email               = convert(varchar(24), value)                                            
      FROM   #conc                     WITH (NOLOCK)                                            
      WHERE  code               = 'EMAIL1'                                            
      AND    pk                     = @c_crn_no                                            
     --                                            
      SELECT @l_usertext1           = ''                                            
      SELECT @l_usertext2           = ''                                            
      SELECT @l_userfield1          = 0                                             
      SELECT @l_userfield2          = 0                                             
      SELECT @l_userfield3          = 0                                            
      --                                            
      SELECT @l_sechname            = convert(varchar(100), isnull(dphd_sh_fname,''))                                            
           , @l_sechmiddle          = convert(varchar(20), isnull(dphd_sh_mname,''))                                            
           , @l_sechlastname        = convert(varchar(20), isnull(dphd_sh_lname,''))                                                       
           , @l_sechsuffix          = ''                                              
           , @l_sechfathername      = dphd_sh_fthname                                            
           , @l_sechpanno           = dphd_sh_pan_no                                            
           , @l_sechitcircle        = ''                
      FROM   #dp_holder_dtls                                               
      --                                            
    SELECT @l_thirdname            = convert(varchar(100), Isnull(dphd_th_fname,''))                                            
           , @l_thirdmiddle     = convert(varchar(20), Isnull(dphd_th_mname,''))                                         
           , @l_thirdlastname        = convert(varchar(20), Isnull(dphd_th_lname,''))                                            
                                               
           , @l_thirdsuffix          = ''                                              
           , @l_thirdfathername      = convert(varchar(50), Isnull(dphd_th_fthname,''))                                            
           , @l_thirdpanno           = convert(varchar(10), Isnull(dphd_th_pan_no,''))                                            
           , @l_thirditcircle        = ''                                            
      FROM   #dp_holder_dtls                                            
      --                                     
      SELECT @l_sechtitle           = convert(varchar(25), Isnull(value,'')) FROM #entity_properties WHERE code = 'TITLE_SH'                                           
      SELECT @l_thirdtitle           = convert(varchar(25), Isnull(value,'')) FROM #entity_properties WHERE code = 'TITLE_TH'                                   
                                  
      declare @l_gua_name varchar(50), @l_gua_pan varchar(50)                                    
                                          
      select @l_gua_name = dphd_gau_fname , @l_gua_pan= dphd_gau_pan_no from #dp_holder_dtls                                    
      if isnull(@l_gua_name,'') <> '' or   isnull(@l_gua_pan,'') <> ''                                    
      begin                                    
      --                                    
        SELECT @l_dateofmaturity       = REPLACE(CONVERT(VARCHAR(11),convert(datetime,VALUE,120),102),'.','')  FROM #account_properties WHERE code = 'DATE_OF_MATURITY'                                    
      --                                    
      end                                    
      else                                    
      begin                                    
      --                           
        SELECT @l_dateofmaturity       = ''                                    
      --                                    
      end                                    
                          
      --                                            
      SELECT @l_dpintrefno           = convert(varchar(9), @c_sba_no)                                            
      SELECT @l_language             = citrus_usr.fn_get_listing('LANGUAGE',value)  FROM #entity_properties  WHERE code = 'LANGUAGE'                                            
      --                                            
      SELECT @l_occupation           = citrus_usr.fn_get_listing('OCCUPATION',value)  FROM #entity_properties  WHERE code = 'OCCUPATION'                                             
      --                                            
      SELECT @l_lifestyle            = ''                                            
      --                                            
      SELECT @l_geographical         = citrus_usr.fn_get_listing('GEOGRAPHICAL',value)  FROM #entity_properties  WHERE code = 'GEOGRAPHICAL'                                            
      SELECT @l_degree               = citrus_usr.fn_get_listing('EDUCATION',value)  FROM #entity_properties  WHERE code = 'EDUCATION'                                            
      SELECT @l_annualincome         = citrus_usr.fn_get_listing('ANNUAL_INCOME',value)  FROM #entity_properties  WHERE code = 'ANNUAL_INCOME'                                            
      SELECT @l_nationality          = citrus_usr.fn_get_listing('NATIONALITY',value) FROM #entity_properties  WHERE code = 'NATIONALITY'                                            
      if ltrim(rtrim(isnull(@l_nationality,''))) = '' set @l_nationality='01'                                      
      SELECT @l_legalstatus          = '0'                                            
      SELECT @l_feetype   = '0'                                            
      -- SELECT @l_bankoption           = '0'      'Right now we are taking Saving and Current code                                      
                                                  
      SELECT @l_staffcode            = ''                                            
  SELECT @l_securitycode         = ''                                            
      SELECT @l_bosettlementplanflag = case when convert(char(1), isnull(value,'N'))=1 then 'Y' else convert(char(1), isnull(value,'N')) end  FROM #entity_properties  WHERE code = 'BOSETTLFLG'                                            
      if ltrim(rtrim(isnull(@l_bosettlementplanflag,'') ))              = ''  set @l_bosettlementplanflag = 'N'                                             
                                            
      SELECT @l_voicemail            = ''                                            
      --                                            
 SELECT @l_rbirefno             = ''                                    
      SELECT @l_rbiappdate           = ''                                            
      SELECT @l_sebiregno            = ''                                            
      SELECT @l_taxdeduction         = citrus_usr.fn_get_listing('TAX_DEDUCTION',value) FROM #entity_properties  WHERE code = 'TAX_DEDUCTION'                                            
                                                  
                                                                                  
      SELECT @l_smartcardreq         = 'N'                                   
      SELECT @l_smartcardno          = ''                                            
      SELECT @l_smartcardpin         = 0        
      SELECT @l_ecs                  = case when convert(char(1),isnull(value,'N'))=1 then 'Y' else convert(char(1),isnull(value,'N')) end  FROM #account_properties    WHERE code = 'ECS_FLG'                         
      SELECT @l_electronicconfirm    = case when convert(char(1),isnull(value,'N'))=1 then 'Y' else convert(char(1),isnull(value,'N')) end  FROM #account_properties    WHERE code = 'ELECTRONIC_CONFIRMATION'                                             
     if ltrim(rtrim(isnull(@l_electronicconfirm,'') ))              = ''  set @l_electronicconfirm = 'N'                                     
     if ltrim(rtrim(isnull(@l_ecs,'') ))                            = ''  set @l_ecs = 'N'                                            
                                             
      SELECT @l_dividendcurrency     = case when citrus_usr.fn_get_listing('DIVIDEND_CURRENCY',value)= '' then 0 else Isnull(citrus_usr.fn_get_listing('DIVIDEND_CURRENCY',value),0) end FROM #account_properties    WHERE code = 'DIVIDEND_CURRENCY'         
  
    
      
        
           
            
             
                 
                 
                     
                     
                        
                           
                           
                               
                               
                                   
                                   
      SELECT @l_groupcd              = convert(varchar(8), isnull(value,'')) FROM #entity_properties WHERE code = 'GROUP_CD'                                    
  if ltrim(rtrim(isnull(@l_groupcd,'') ))              = ''  set @l_groupcd = 'ZZZ'                                                 
                                                  
                                            
      SELECT @l_fathername           = isnull(dphd_fh_fthname,'')  FROM #dp_holder_dtls                                             
      SELECT @l_ccid                 = 0                                            
      SELECT @l_cmid                 = ''                                            
      SELECT @l_stockexchange        = '0'        
      SELECT @l_confirmation         = Case when convert(char(1),isnull(value,'N'))=1 then 'Y' Else 'N' END  FROM #account_properties WHERE code = 'CONFIRMATION'                                              
      if ltrim(rtrim(isnull(@l_confirmation,'') )) = ''  set @l_confirmation = 'N'                                             
      SELECT @l_tradingid            = ''                                            
      SELECT @l_bostatementcycle     = citrus_usr.fn_get_listing('BOSTMNTCYCLE',value) FROM #account_properties    WHERE code = 'BOSTMNTCYCLE'                                             
      --SELECT @l_branchno             = ''                                            
                                                  
      SELECT @l_bankacno = convert(varchar(20), cliba_ac_no)                                       
           , @l_micr     = Isnull(banm_micr,'')                                    
           , @l_divbankcode          = Isnull(banm_micr,'')                                    
           , @l_bankacttype          = CASE WHEN cliba_ac_type = 'SAVINGS' THEN '10' WHEN cliba_ac_type = 'CURRENT' THEN '11'  ELSE '13' END                                            
           , @l_branchno             = CASE WHEN cliba_ac_type = 'SAVINGS' THEN '10' WHEN cliba_ac_type = 'CURRENT' THEN '11'  ELSE '13' END                                            
           , @l_divbranchno          = CASE WHEN cliba_ac_type = 'SAVINGS' THEN '10' WHEN cliba_ac_type = 'CURRENT' THEN '11'  ELSE '13' END                                            
           , @l_bankoption           = CASE WHEN dpam_subcm_cd = '2104' THEN '8' WHEN dpam_subcm_cd = '2103' THEN '1' WHEN dpam_subcm_cd = '2410' THEN '3' WHEN dpam_subcm_cd = '2411' THEN '3' WHEN dpam_subcm_cd = '2512' THEN '2' ELSE '' END               
 
     
      
        
         
             
         
                
                  
                    
                      
                       
                           
                           
                              
  , @l_divbankacno          = convert(varchar(20),cliba_ac_no)                                            
      FROM   dp_acct_mstr             WITH (NOLOCK)                                            
      , client_bank_accts         WITH (NOLOCK)                                     
           , bank_mstr WITH (NOLOCK)                                             
      WHERE  dpam_crn_no             = @c_crn_no                                            
      AND    dpam_acct_no            = @c_sba_no                                            
      AND    dpam_id                 = cliba_clisba_id                                            
      AND    cliba_banm_id         = banm_id                                    
      AND    dpam_deleted_ind       = 1                                            
      AND    cliba_deleted_ind       = 1                                             
      AND    banm_deleted_ind=1                                           
                                    
      --                                            
                                                  
      SELECT @l_bankccy              = case when citrus_usr.fn_get_listing('BANKCCY',value) = '' then 0 else Isnull(citrus_usr.fn_get_listing('BANKCCY',value),0) end  FROM #account_properties WHERE code = 'BANKCCY'                                         
  
    
      --SELECT @l_micr                 = ''                                     
  --SELECT @l_divbankcode          = ''                                            
      --SELECT @l_divbranchno          = ''                                            
                                                  
      SELECT @l_divbankccy           = case when  citrus_usr.fn_get_listing('DIVBANKCCY',value) = '' then 0 else Isnull(citrus_usr.fn_get_listing('DIVBANKCCY',value),0) end FROM #account_properties WHERE code = 'DIVBANKCCY'                                
  
    
      
        
          
            
             
      SELECT @l_poaid                = ''                            
                                                  
      SELECT @l_poaname              = convert(varchar(100), Isnull(dphd_poa_fname,''))                                            
           , @l_poamiddlename        = convert(varchar(20), Isnull(dphd_poa_mname,''))                                            
           , @l_poalastname          = convert(varchar(20), Isnull(dphd_poa_lname,''))                                                       
           , @l_poasuffix            = ''                                            
  , @l_poafathername        = convert(varchar(50), Isnull(dphd_poa_fthname,''))                                            
      FROM   #dp_holder_dtls                                               
      --                                            
      SELECT @l_poatitle             = convert(varchar(25), value) FROM #entity_properties WHERE code = 'POA_TITLE'                                           
      if ltrim(rtrim(isnull(@l_poatitle,'') ))              = ''  set @l_poatitle = ''                                  
                                  
      SELECT @l_values               = ''                                            
      SELECT @l_values               = citrus_usr.fn_dp_mig_nsdl_dphd('ADDR',@c_dpam_id,'POA_ADR1')                                            
      SELECT @l_poaadd1              = convert(varchar(30), citrus_usr.fn_splitval(@l_values,1))                                            
           , @l_poaadd2              = convert(varchar(30), citrus_usr.fn_splitval(@l_values,2))                                            
           , @l_poaadd3              = convert(varchar(30), citrus_usr.fn_splitval(@l_values,3))                                            
           , @l_poacity              = convert(varchar(25), citrus_usr.fn_splitval(@l_values,4))                                            
           , @l_poastate             = convert(varchar(25), citrus_usr.fn_splitval(@l_values,5))                                            
           , @l_poacountry           = convert(varchar(25), citrus_usr.fn_splitval(@l_values,6))                                            
           , @l_poapin               = convert(varchar(10), citrus_usr.fn_splitval(@l_values,7))                                            
      --                                            
    --  if ltrim(rtrim(isnull(@l_poaadd1,'') ))              = ''  set @l_poaadd1 = ''                                  
      --                                      
      SELECT @l_poateleindicator     = ''                                            
      --                                            
      SELECT @l_poatele1             = isnull(convert(varchar(17), citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'MOBILE')) ,'')                                            
      --                                            
      SELECT @l_poateleindicator2    = ''                                            
      --                                            
      SELECT @l_poatele1             = isnull(convert(varchar(17), citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'POA_PH1')) ,'')                                            
      --                                            
      SELECT @l_poatele2             = isnull(convert(varchar(100), citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'POA_PH2')) ,'')                                            
      --                                            
      SELECT @l_poafax               = isnull(convert(varchar(17), citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'POA_FAX')),'')                                             
      --                                            
      SELECT @l_poapanno             = isnull(convert(varchar(25),value),'') FROM #account_properties WHERE code = 'POA_PAN_GIR_NO'      --                                            
      SELECT @l_poaitcircle          = ''                                            
      --                                            
      SELECT @l_poaemail             = isnull(convert(varchar(50), value),'')                                            
      FROM   #conc                     WITH (NOLOCK)                                            
      WHERE  code                    = 'POA_EMAIL1'                                            
      AND    pk                      = @c_crn_no                                            
      --                                            
      SELECT @l_setupdate            = Replace(Convert(Varchar(11),convert(datetime,value,105),102),'.','') FROM #account_properties WHERE code = 'SETUPDATE'                                            
      SELECT @l_operateaccount       = Case when convert(char(1),value)=1 then 'Y' else 'N' end  FROM #account_properties WHERE code = 'OPERATEACCOUNT'                                            
      if ltrim(rtrim(isnull(@l_operateaccount,'') ))              = ''  set @l_operateaccount = 'N'                                             
      SELECT @l_gpaflag              = convert(char(1),value) FROM #account_properties WHERE code = 'GPA_FLAG'                                            
      if ltrim(rtrim(isnull(@l_gpaflag,'') ))              = ''  set @l_gpaflag = 'B'                                             
      SELECT @l_effectivefrom        = Replace(Convert(Varchar(11),convert(datetime,value,105),102),'.','') FROM #account_properties WHERE code = 'EFFECTIVEFROM'                                            
      if ltrim(rtrim(isnull(@l_effectivefrom,'') ))              = ''  set @l_effectivefrom = ''                                      
SELECT @l_effectiveto          = Replace(Convert(Varchar(11),convert(datetime,value,105),102),'.','') FROM #account_properties WHERE code = 'EFFECTIVETO'                                            
      if ltrim(rtrim(isnull(@l_effectiveto,'') ))              = ''  set @l_effectiveto = ''                                      
      SELECT @l_cacharfield          = ''                                            
      SELECT @l_chequecash           = Case when value='CHEQUE' then 'Q' Else 'C' End  FROM #account_properties WHERE code = 'CHEQUECASH'                                            
      If Ltrim(Rtrim(Isnull(@l_chequecash,'')))='' Set  @l_chequecash = ''                                     
                                    
      SELECT @l_chqno                = Case when @l_chequecash='Q' then isnull(convert(varchar(10),Isnull(value,'')),'') else '' end  FROM #account_properties WHERE code = 'CHQNO'                                    
      if ltrim(rtrim(isnull(@l_chqno,''))) = '' set   @l_chqno =  ''                                    
      --                                            
      SELECT @l_recvdate             = Case when Isnull(@l_chqno,'') <> '' then replace(convert(Varchar(11),convert(datetime,value,105),102),'.','') else '' end  FROM #account_property_dtls WHERE code2 = 'CHQRCVDATE'                                      
  
    
      
      if ltrim(rtrim(isnull(@l_recvdate,'') ))              = ''  set @l_recvdate = ''                                      
      SELECT @l_rupees               = Case when Isnull(@l_chqno,'') <> '' then isnull(convert(numeric(18,4),value),'0.0000') else '0.0000' end  FROM #account_property_dtls WHERE code2 = 'CHQRCVAMT'                                                  
  if ltrim(rtrim(isnull(@l_rupees,''))) = '' set   @l_rupees =  convert(numeric(18,4),'0.0000')                                    
      SELECT @l_drawn                = Case when Isnull(@l_chqno,'')<>'' then  convert(varchar(50),Isnull(value,'')) else '' end FROM #account_property_dtls WHERE code2 = 'CHQDRAWNON'                                            
      if ltrim(rtrim(isnull(@l_drawn,''))) = '' set   @l_drawn = ''                                             
      SELECT @l_chgsscheme           = 'GENERAL'                                            
      SELECT @l_billcycle            = ''                                            
      SELECT @l_brboffcode           = '000000'                         
      SELECT @l_familycd             = 'ZZZ'                                            
      --                                            
      SELECT @l_statements  = isnull(convert(char(1),value),'') FROM #account_properties WHERE code = 'STMNTS'                                            
      if ltrim(rtrim(isnull(@l_statements,'') ))              = ''  set @l_statements = 'B'                                             
      SELECT @l_billflag             = Isnull(Substring(convert(char(1),value),1,1),'') FROM #account_properties WHERE code = 'BILLFLG'                                            
      SELECT @l_allowcredit          = '0'                                            
      SELECT @l_billcode             = ''                                            
      SELECT @l_collectioncode       = ''                                         
                                      
      SELECT @l_upfront              = Case when convert(char(1),value)=1 then 'Y' else 'N' End  FROM #account_properties WHERE code = 'UPFRONT'                                            
      if ltrim(rtrim(isnull(@l_upfront,'') ))              = ''  set @l_upfront = 'N'                                             
      SELECT @l_keepsettlement       = Case when convert(char(1),value)=1 then 'Y' else 'N' end  FROM #account_properties WHERE code = 'KEEPSETTLEMENT'                                            
      if ltrim(rtrim(isnull(@l_keepsettlement,'') ))              = ''  set @l_keepsettlement = 'N'                                             
      SELECT @l_fre_trx              = citrus_usr.fn_get_listing('TRXFREQ',value) FROM #account_properties WHERE code = 'TRXFREQ'                                            
      SELECT @l_fre_hold             = citrus_usr.fn_get_listing('HLDNGFREQ',value) FROM #account_properties WHERE code = 'HLDNGFREQ'                                            
      SELECT @l_fre_bill             = citrus_usr.fn_get_listing('BILLFREQ',value) FROM #account_properties WHERE code = 'BILLFREQ'                                                              
                                        
      SELECT @l_allow                = convert(char(1),Isnull(value,'')) FROM #account_properties WHERE code = 'ALLOW'                                            
      if ltrim(rtrim(isnull(@l_allow,'') ))              = ''  set @l_allow = 'N'                                             
      SELECT @l_batchno             = convert(int,isnull(value,0)) FROM #account_properties WHERE code = 'BATCHNO'                                            
       if ltrim(rtrim(isnull(@l_batchno,'0') ))              = '0'  set @l_batchno = 0                                       
      if exists(select * from dp_poa_dtls where dppd_dpam_id = @c_dpam_id and dppd_deleted_ind =1) set @l_poaforpayin  = 'Y'                                       
      IF isnull(@l_poaforpayin,'') =  ''  set @l_poaforpayin = 'N'                                      
      if ltrim(rtrim(isnull(@l_poaforpayin,'') ))              = ''  set @l_poaforpayin = 'N'                                             
      --                                            
      SELECT @l_cmcd                 = '' --- isnull(convert(varchar(16), @c_acct_no),'')--convert(varchar(16), clidpa_dp_id)                                            
      --, @l_poaforpayin          = 'N' --convert(char(1), clidpa_flg)                                            
      FROM   client_sub_accts                                            
     , client_dp_accts                                            
      WHERE  clisba_crn_no           = @c_crn_no                                            
      AND    clisba_acct_no          = @c_sba_no                                            
      AND    clisba_id               = clidpa_clisba_id                                            
      AND    clisba_deleted_ind      = 1                                            
      AND    clidpa_deleted_ind      = 1                                            
 --                                            
      SELECT @l_corresadd1           = convert(varchar(30), isnull(add1,''))                                            
           , @l_corresadd2           = convert(varchar(30), isnull(add2,''))                                            
           , @l_corresadd3           = convert(varchar(30), isnull(add3,''))                                            
           , @l_correscity           = convert(varchar(25), isnull(city,''))                                            
           , @l_corresstate          = convert(varchar(25), isnull(state,''))                                       
           , @l_correscountry        = convert(varchar(25), isnull(country,''))                                            
           , @l_correspin            = convert(varchar(10), isnull(pin,''))                                            
      FROM   #addr                                            
      WHERE  code                    = 'COR_ADR1'                                            
      AND    pk    = @c_crn_no                                            
      --                                            
      SELECT @l_correstele1       = isnull(convert(varchar(17), value),'')                                            
      FROM   #conc       WITH (NOLOCK)                                            
      WHERE  code                    = 'OFF_PH1'                                            
      AND    pk         = @c_crn_no                                            
      --                                            
      SELECT @l_correstele2          = isnull(convert(varchar(17), value),'')                                            
      FROM   #conc                     WITH (NOLOCK)                                            
      WHERE  code                    = 'OFF_PH2'                                            
      AND    pk                      = @c_crn_no                                            
                                                  
      SELECT @l_correstele3          = isnull(convert(varchar(100), value),'')                                            
      FROM   #conc                     WITH (NOLOCK)                                            
      WHERE  code                  = 'OFF_PH3'                                            
      AND    pk                      = @c_crn_no                                            
      --                                            
      SELECT @l_correstele3          = isnull(convert(varchar(17), value),'')                                        
      FROM   #conc                     WITH (NOLOCK)                                            
      WHERE  code                    = 'FAX1'                                            
      AND    pk                      = @c_crn_no                                       
      --                                            
      SELECT @l_blsavingcd           = ''                                            
      SELECT @l_errormsg             = ''                                            
      --                                            
                                                
      SELECT @l_nominee              = convert(varchar(100), dphd_nom_fname)                                            
          , @l_nominee_dob          = REPLACE(CONVERT(VARCHAR(11),isnull(dphd_nom_dob,''),102),'.','')                                     
           , @l_nominee_search       = convert(varchar(20), dphd_nom_lname)                                                
        , @l_nomineemiddlename    = convert(varchar(20), dphd_nom_mname)                                            
           , @l_nomineefathername    = convert(varchar(50), dphd_nom_fthname)                                       
           , @l_nomineesuffix        = ''                                            
      FROM   #dp_holder_dtls                                         
      if ltrim(rtrim(Isnull(@l_nominee_dob,''))) = '19000101'   set @l_nominee_dob = ''               
      --                                         
      SELECT @l_nomineetitle         =convert(varchar(25), value) FROM #entity_properties WHERE code = 'NOM_TITLEI'                                       
      SELECT @l_values               = ''                                            
      SELECT @l_values               = citrus_usr.fn_dp_mig_nsdl_dphd('ADDR',@c_dpam_id,'NOMINEE_ADR1 ')                                            
      SELECT @l_nomineeadd1          = convert(varchar(30), citrus_usr.fn_splitval(@l_values,1))                                            
           , @l_nomineeadd2          = convert(varchar(30), citrus_usr.fn_splitval(@l_values,2))                                            
           , @l_nomineeadd3          = convert(varchar(30), citrus_usr.fn_splitval(@l_values,3))                                            
           , @l_nomineecity          = convert(varchar(25), citrus_usr.fn_splitval(@l_values,4))                                            
  , @l_nomineestate         = convert(varchar(25), citrus_usr.fn_splitval(@l_values,5))                                            
           , @l_nomineecountry      = convert(varchar(25), citrus_usr.fn_splitval(@l_values,6))                                            
           , @l_nomineepin           = convert(varchar(10), citrus_usr.fn_splitval(@l_values,7))                                            
      --                                            
      /*SELECT @l_values               = ''                  
      SELECT @l_values               = citrus_usr.fn_dp_mig_nsdl_dphd('ADDR',@c_dpam_id,'FH_ADR1')                                            
      SELECT @l_fadd1                = convert(varchar(30), citrus_usr.fn_splitval(@l_values,1)) -- Foreign address                                            
           , @l_fadd2                = convert(varchar(30), citrus_usr.fn_splitval(@l_values,2))                                            
           , @l_fadd3                = convert(varchar(30), citrus_usr.fn_splitval(@l_values,3))                                            
           , @l_fcity                = convert(varchar(25), citrus_usr.fn_splitval(@l_values,4))                                            
           , @l_fstate               = convert(varchar(25), citrus_usr.fn_splitval(@l_values,5))                                            
   , @l_fcountry             = convert(varchar(25), citrus_usr.fn_splitval(@l_values,6))                                            
           , @l_fpin    = convert(varchar(10), citrus_usr.fn_splitval(@l_values,7))                                            
           , @l_ftele                = ''                                            
           , @l_ffax                 = ''                                            
                                            
       */                                            
      --                                            
/*                              
     Date jan 28 08 , as per discussion with  reaymin if fadd is exist in other addr tbl, than no need to display here                              
     SELECT @l_fadd1                  = convert(varchar(36),Isnull(add1,''))                                            
       , @l_fadd2                 = convert(varchar(36),Isnull(add2,''))                                            
        , @l_fadd3                 = convert(varchar(36),Isnull(add3,''))                                            
        , @l_fcity                 = convert(varchar(36),Isnull(city,''))                                            
        , @l_fstate                = convert(varchar(36),Isnull(state,''))                                            
        , @l_fcountry              = convert(varchar(36),Isnull(country,''))                                            
        , @l_fpin                  = convert(varchar(7),Isnull(pin,''))                                            
           , @l_ftele                 = ''                   
           , @l_ffax                  = ''                                
     FROM   #addr                                            
     WHERE  code                = 'FH_ADR1'                                            
     AND    pk                      = @c_crn_no                                                
                              
 */                                       
      --                                            
                                          
      SELECT @l_authid               = isnull(convert(char(8), value),'') FROM #account_properties WHERE code = 'AUTHID'                                            
      SELECT @l_authdt               = isnull(convert(char(8), value, 3),'') FROM #account_properties WHERE code = 'AUTHDT'                                            
      SELECT @l_remark               = ''                                            
      SELECT @l_inwarddt             = ''                                            
      SELECT @l_authtm               = convert(char(8),value) FROM #account_property_dtls WHERE code1 = 'AUTHTIME'                                            
      if ltrim(rtrim(isnull(@l_authtm,'') ))  = ''  set @l_authtm = '00:00:00'                                            
      SELECT @l_mkrtm                =  convert(varchar,getdate(),108)                                            
      SELECT @l_remisser  = 'ZZZ'                                            
      SELECT @l_nomineephoneindicator= ''                  
      SELECT @l_nomineetele1         = convert(char(17), citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'NOMINEE_PH1'))                                            
      if ltrim(rtrim(isnull(@l_nomineetele1,'') ))              = ''  set @l_nomineetele1 = ''                                            
      SELECT @l_poaregdate           = case when @l_poaforpayin = 'Y' then replace(convert(char(11), convert(datetime,getdate(),105),102),'.','') else '' end                                            
      if ltrim(rtrim(isnull(@l_poaregdate,'') ))              = ''  set @l_poaregdate = ''                                            
      --                                            
      IF exists(select * from client_export_cdsl_hst where cx_dpam_id = @c_dpam_id and cx_cmpltd = 1)                                            
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
                 
      if exists(select * from client_export_cdsl where cx_dpam_id =@c_dpam_id and cx_cmpltd = 0)                                           
      begin                                            
      --                                             
        delete from client_export_cdsl where cx_dpam_id =@c_dpam_id and cx_cmpltd = 0                                            
                                                  
        INSERT INTO client_export_cdsl VALUES                                            
        (@l_brcode                                                             
        ,@l_instrno                                                                 
        ,@l_name                                                                    
        ,@l_middlename                                                              
        ,@l_lastname                                                     
        ,@l_title                                                                   
        ,@l_suffix                                                                  
        ,@l_fathername                                        
        ,@l_add1                                                                    
        ,@l_add2                                                             
        ,@l_add3                                                                    
        ,@l_city                                                                    
      ,@l_state                                                                   
        ,@l_country                                                                 
        ,@l_pin                                         
        ,@l_phoneindicator                                                          
        ,@l_tele1                                                                   
        ,@l_phoneindicator2                                                         
        ,@l_tele2                                                                   
        ,@l_tele3                                                                   
        ,@l_fax                                                 
        ,@l_panno                                                                   
        ,@l_itcircle                                                                
        ,@l_email                                                                   
        ,@l_usertext1                 
        ,@l_usertext2                                                               
        ,@l_userfield1                                                              
        ,@l_userfield2                                                          
        ,@l_userfield3                                                              
        ,@l_sechname                                              
        ,@l_sechmiddle                                                              
        ,@l_sechlastname                                                            
        ,@l_sechtitle                                   
        ,@l_sechsuffix                                                              
        ,@l_sechfathername                                                          
        ,@l_sechpanno                                                               
        ,@l_sechitcircle                                                            
        ,@l_thirdname                                           
        ,@l_thirdmiddle                                                             
        ,@l_thirdlastname                                                           
        ,@l_thirdtitle                                                              
        ,@l_thirdsuffix                                                             
        ,@l_thirdfathername                                                         
      ,@l_thirdpanno                                                              
        ,@l_thirditcircle                                                           
        ,@l_dateofmaturity                                                          
        ,@l_dpintrefno                                                              
        ,@l_dateofbirth                                                             
        ,@l_sexcode                                                 
    ,@l_occupation                                                      
     ,@l_lifestyle                                                               
        ,@l_geographical                                                            
        ,@l_degree                                                               
        ,@l_annualincome                                                            
        ,@l_nationality                                                             
        ,@l_legalstatus                                   
        ,@l_feetype                                                                 
        ,@l_language                                                                
        ,@l_category                                 
        ,@l_bankoption                                                              
        ,@l_staff                                                                   
        ,@l_staffcode                                                               
        ,@l_securitycode                                                            
        ,@l_bosettlementplanflag                                                    
        ,@l_voicemail                                                               
        ,@l_rbirefno                                                    
        ,@l_rbiappdate                                                              
,@l_sebiregno                                                               
        ,@l_taxdeduction                                                            
        ,@l_smartcardreq                                                            
        ,@l_smartcardno                                                             
        ,@l_smartcardpin                                                            
        ,@l_ecs                                                                     
        ,@l_electronicconfirm                                            
        ,@l_dividendcurrency                       
        ,@l_groupcd                                                                 
        ,@l_bosubstatus                                                             
        ,@l_ccid                                                        
        ,@l_cmid                                                                    
        ,@l_stockexchange                                                           
        ,@l_confirmation                       
        ,@l_tradingid                                                               
       ,@l_bostatementcycle                                                        
        ,@l_branchno                                                                
        ,@l_bankacno                                                                
        ,@l_bankccy                                                                 
        ,@l_bankacttype                                                             
        ,@l_micr                                                                    
        ,@l_divbankcode                                                    
        ,@l_divbranchno                 
        ,@l_divbankacno                                                             
        ,@l_divbankccy                                                              
        ,@l_poaid                                                                   
        ,@l_poaname                                                                 
        ,@l_poamiddlename                                                           
        ,@l_poalastname                                                 
        ,@l_poatitle                                                                
        ,@l_poasuffix                                                               
        ,@l_poafathername                                                           
        ,@l_poaadd1                                                                 
        ,@l_poaadd2                                                                 
        ,@l_poaadd3                                                                 
        ,@l_poacity                                                                 
        ,@l_poastate                                                                
        ,@l_poacountry                                                              
        ,@l_poapin                                  
        ,@l_poateleindicator                                                        
        ,@l_poatele1                                                                
        ,@l_poateleindicator2                                                       
        ,@l_poatele2                                     
        ,isnull(@l_poatele3                    ,'')                                            
        ,@l_poafax                                                                  
        ,isnull(@l_poapanno                   ,'')                                             
        ,@l_poaitcircle                                                             
        ,isnull(@l_poaemail                   ,'')                                             
        ,@l_setupdate                                                               
        ,@l_operateaccount                                                          
        ,@l_gpaflag                                                                 
        ,@l_effectivefrom                                                           
        ,@l_effectiveto                                                             
        ,@l_cacharfield                             
        ,@l_chequecash                                                              
        ,@l_chqno                                                                   
        ,@l_recvdate                                                                
        ,@l_rupees                                                  
        ,@l_drawn                                                          
        ,@l_chgsscheme                                                              
        ,@l_billcycle                                                               
        ,@l_brboffcode                                        
        ,@l_familycd                                                                
        ,@l_statements                                                              
      ,@l_billflag                                                                
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
        ,@l_corresadd1                                                              
        ,@l_corresadd2                                                              
        ,@l_corresadd3                                   
        ,@l_correscity                                                              
    ,@l_corresstate                                                             
        ,@l_correscountry                                                           
        ,@l_correspin                                                               
        ,@l_correstele1                                                             
        ,@l_correstele2                                                             
        ,@l_correstele3                                                             
        ,@l_corresfax                                       
        ,@l_blsavingcd                                                              
        ,@l_errormsg                                                                
        ,@l_nominee                                                                 
        ,@l_nomineeadd1                                                             
        ,@l_nomineeadd2                                                             
        ,@l_nomineeadd3           
        ,@l_nomineecity                             
        ,@l_nomineestate                                                            
        ,@l_nomineecountry                                                          
        ,@l_nomineepin                                                              
  ,@l_nominee_dob                                                             
        ,@l_fadd1                                                                   
        ,@l_fadd2                                                                   
        ,@l_fadd3                                                                   
        ,@l_fcity                                                                   
        ,@l_fstate                                   
        ,@l_fcountry                                                                
        ,@l_fpin                                                   
        ,@l_ftele                                                                   
        ,@l_ffax                                                                    
        ,@l_mkrdt                                                                   
        ,@l_mkrid              
        ,@l_nominee_search                                                          
        ,@l_authid                                                                  
        ,@l_authdt                                                                  
        ,@l_remark                                                                  
        ,@l_inwarddt                                                                
        ,@l_authtm                                                                  
        ,@l_mkrtm                                                                   
        ,@l_nomineemiddlename                                                       
        ,@l_nomineetitle                           
        ,@l_nomineesuffix                                                           
        ,@l_nomineefathername                                                       
        ,@l_nomineephoneindicator          
        ,@l_nomineetele1                                                            
        ,@l_remisser                                                                
        ,@l_poaforpayin                                                             
        ,@l_poaregdate                                            
        ,@l_modified                                            
        ,0                                            
        ,@c_dpam_id                                            
        )                                            
        --                                            
        SET @l_brcode   = ''                                                                 
        SET @l_instrno   = ''                                                                
        SET @l_name       = ''                                                    
        SET @l_middlename  = ''                                                              
        SET @l_lastname     = ''                                          
        SET @l_title   = ''                                                            
        SET @l_suffix   = ''                                                           
        SET @l_fathername      = ''                                                      
        SET @l_add1  = ''                                                            
        SET @l_add2   = ''                                                                   
        SET @l_add3    = ''                                                                  
        SET @l_city    = ''                                                                
        SET @l_state   = ''                                                                  
        SET @l_country  = ''                                                           
        SET @l_pin       = ''                                                                
        SET @l_phoneindicator  = ''                                                          
        SET @l_tele1  = ''                                                                   
        SET @l_phoneindicator2  = ''                                                         
     SET @l_tele2    = ''                                                           
        SET @l_tele3   = ''                                                   
        SET @l_fax     = ''                                                            
        SET @l_panno   = ''                                                            
        SET @l_itcircle      = ''                                                            
        SET @l_email   = ''                                                            
        SET @l_usertext1     = ''                                                            
        SET @l_usertext2     = ''                                                            
        SET @l_userfield1    = ''                                                            
        SET @l_userfield2    = ''                               
        SET @l_userfield3    = ''                                                            
        SET @l_sechname      = ''                                                            
        SET @l_sechmiddle    = ''                                                            
        SET @l_sechlastname  = ''                                   
        SET @l_sechtitle     = ''                                                            
        SET @l_sechsuffix    = ''                                                            
        SET @l_sechfathername   = ''                                                         
        SET @l_sechpanno  = ''                                                         
        SET @l_sechitcircle    = ''                                                 
        SET @l_thirdname       = ''                                                          
        SET @l_thirdmiddle     = ''                                                          
        SET @l_thirdlastname   = ''                                                          
 SET @l_thirdtitle      = ''                                                          
        SET @l_thirdsuffix     = ''                                                         
        SET @l_thirdfathername   = ''                                                        
        SET @l_thirdpanno  = ''                                                        
        SET @l_thirditcircle     = ''                                                        
        SET @l_dateofmaturity   = ''                                                         
        SET @l_dpintrefno      = ''                                                          
        SET @l_dateofbirth     = ''                                                          
        SET @l_sexcode   = ''                                                          
        SET @l_occupation     = ''                                                           
        SET @l_lifestyle      = ''                                                           
        SET @l_geographical = ''                                                           
        SET @l_degree    = ''                                              
        SET @l_annualincome     = null                                                         
        SET @l_nationality  = ''                                                          
        SET @l_legalstatus       = ''                                                        
        SET @l_feetype    = ''                                                       
        SET @l_language  = ''                                                          
        SET @l_category  = ''                                    
        SET @l_bankoption     = ''                                                           
        SET @l_staff   = ''                                                            
        SET @l_staffcode = ''                                                           
        SET @l_securitycode    = ''                                                          
        SET @l_bosettlementplanflag   = ''                                                   
        SET @l_voicemail    = ''                                                             
        SET @l_rbirefno      = ''                                                            
        SET @l_rbiappdate   = ''                                                             
        SET @l_sebiregno    = ''                                                             
        SET @l_taxdeduction   = ''                                                           
        SET @l_smartcardreq   = ''                                                       
        SET @l_smartcardno    = ''                                                           
        SET @l_smartcardpin   = null                                             
        SET @l_ecs   = ''                                                            
        SET @l_electronicconfirm   = ''                                                      
        SET @l_dividendcurrency    = null                                                      
        SET @l_groupcd       = ''                                                        
        SET @l_bosubstatus    = ''                                                           
        SET @l_ccid   = null                                                             
        SET @l_cmid  = ''                                                              
        SET @l_stockexchange   = ''                                                          
        SET @l_confirmation   = ''                                                          
        SET @l_tradingid     = ''                                                            
        SET @l_bostatementcycle   = ''                                                       
        SET @l_branchno       = ''                                                           
        SET @l_bankacno       = ''                                                           
        SET @l_bankccy       = null                                                            
        SET @l_bankacttype   = ''                                                            
        SET @l_micr   = ''                                                             
        SET @l_divbankcode  = ''                            
        SET @l_divbranchno   = ''                                
        SET @l_divbankacno   = ''                                             
        SET @l_divbankccy    = null                                                            
        SET @l_poaid   = ''                                                            
        SET @l_poaname       = ''                                                            
        SET @l_poamiddlename   = ''                                                          
        SET @l_poalastname    = ''                                                           
        SET @l_poatitle       = ''                                                           
        SET @l_poasuffix      = ''                                                           
        SET @l_poafathername   = ''                                                          
        SET @l_poaadd1   = ''                                                          
        SET @l_poaadd2   = ''                                                 
        SET @l_poaadd3   = ''                                                          
        SET @l_poacity   = ''                                                 
        SET @l_poastate  = ''                                                          
        SET @l_poacountry      = ''                                                          
        SET @l_poapin     = ''                                                         
        SET @l_poateleindicator   = ''                                                       
        SET @l_poatele1      = ''                                                      
        SET @l_poateleindicator2   = ''                                                      
        SET @l_poatele2      = ''                                                  SET @l_poatele3   = ''                                                         
        SET @l_poafax      = ''                                                        
        SET @l_poapanno    = ''                                                        
        SET @l_poaitcircle       = ''                                                        
        SET @l_poaemail    = ''                                                        
        SET @l_setupdate   = ''                                                        
        SET @l_operateaccount    = ''                                                        
        SET @l_gpaflag     = ''                                  
        SET @l_effectivefrom     = ''                                                        
        SET @l_effectiveto       = ''                    
        SET @l_cacharfield       = ''                                                        
        SET @l_chequecash  = ''                                                        
        SET @l_chqno       = ''                                                        
        SET @l_recvdate    = ''                                                        
        SET @l_rupees      = null                                                        
       SET @l_drawn       = ''                            SET @l_chgsscheme  = ''                                                        
        SET @l_billcycle   = ''                                                        
        SET @l_brboffcode  = ''                                                        
        SET @l_familycd    = ''                                                        
        SET @l_statements   = ''                                   
        SET @l_billflag     = ''                                                       
        SET @l_allowcredit  = 0                                                       
        SET @l_billcode     = ''                                                       
        SET @l_collectioncode      = ''                                                      
        SET @l_upfront       = ''                                                      
        SET @l_keepsettlement     = ''                                                    
        SET @l_fre_trx      = null                                                       
        SET @l_fre_hold     = null                                          
        SET @l_fre_bill     = null                                                       
        SET @l_allow        = ''                                                       
        SET @l_batchno      = null                                                       
        SET @l_cmcd         = ''                                                       
        SET @l_corresadd1   = ''                                                       
        SET @l_corresadd2   = ''                                                       
 SET @l_corresadd3   = ''                                                       
        SET @l_correscity    = ''                                                      
        SET @l_corresstate    = ''                                                         
        SET @l_correscountry   = ''                                                          
        SET @l_correspin       = ''                                                          
        SET @l_correstele1     = ''                                                
        SET @l_correstele2     = ''                                                          
        SET @l_correstele3     = ''                                                          
        SET @l_corresfax       = ''                                                          
        SET @l_blsavingcd      = ''                                 
       SET @l_errormsg   = ''                                                         
        SET @l_nominee  = ''                                                          
        SET @l_nomineeadd1      = ''                                                         
        SET @l_nomineeadd2       = ''                                                       
        SET @l_nomineeadd3       = ''                                                        
        SET @l_nomineecity      = ''                                                         
        SET @l_nomineestate     = ''                                                         
        SET @l_nomineecountry   = ''                                                         
        SET @l_nomineepin       = ''         
        SET @l_nominee_dob      = ''                                       SET @l_fadd1      = ''                                                         
        SET @l_fadd2      = ''                                                         
        SET @l_fadd3      = ''                                                         
        SET @l_fcity      = ''                                                             
        SET @l_fstate     = ''                                                         
        SET @l_fcountry   = ''                                                         
   SET @l_fpin       = ''                                                         
        SET @l_ftele      = ''                                                         
 SET @l_ffax       = ''                                                         
        SET @l_mkrdt      = ''                                                         
        SET @l_mkrid      = ''                                                         
        SET @l_nominee_search   = ''                                                         
        SET @l_authid     = ''                                                         
        SET @l_authdt    = ''                                                          
        SET @l_remark   = ''                                                 
        SET @l_inwarddt          = ''                                             
        SET @l_authtm            = ''                                                  
        SET @l_mkrtm            = ''                                                   
        SET @l_nomineemiddlename       = ''                                                  
        SET @l_nomineetitle     = ''                                                   
        SET @l_nomineesuffix    = ''                                                   
        SET @l_nomineefathername      = ''                                                   
        SET @l_nomineephoneindicator   = ''                                                   
        SET @l_nomineetele1      = ''                                                        
        SET @l_remisser   = ''                                                         
        SET @l_poaforpayin      = ''                                                         
        SET @l_poaregdate       = ''                                            
        --                                                
    --                                            
    END                                            
    ELSE                                            
    BEGIN                     
    --                                            
     INSERT INTO client_export_cdsl VALUES                                            
        (@l_brcode                                                                  
        ,@l_instrno                                                                 
        ,@l_name                                                                    
        ,@l_middlename                                                              
        ,@l_lastname                                                        
        ,@l_title                                                     
        ,@l_suffix                                                                  
       ,@l_fathername                                                              
        ,@l_add1                                                                    
        ,@l_add2                                                               
        ,@l_add3                                                                    
        ,@l_city                                                                    
        ,@l_state                                                                   
        ,@l_country                                                                 
        ,@l_pin                                         
        ,@l_phoneindicator                                                          
        ,@l_tele1                                                                   
        ,@l_phoneindicator2                                                         
        ,@l_tele2                                                                   
        ,@l_tele3                                                                   
 ,@l_fax                                                                     
        ,@l_panno                                                     
        ,@l_itcircle                                                                
        ,@l_email                                                                   
        ,@l_usertext1                                                               
        ,@l_usertext2                                                               
        ,@l_userfield1                                                              
        ,@l_userfield2                                                              
,@l_userfield3                                                              
        ,@l_sechname                                                                
        ,@l_sechmiddle                                                              
        ,@l_sechlastname                                                            
        ,@l_sechtitle                                                               
        ,@l_sechsuffix                                                              
        ,@l_sechfathername                                                          
        ,@l_sechpanno                                                               
     ,@l_sechitcircle                                      
        ,@l_thirdname                                                               
        ,@l_thirdmiddle                                                             
        ,@l_thirdlastname                                                           
        ,@l_thirdtitle                                                              
        ,@l_thirdsuffix                                                             
        ,@l_thirdfathername                                            
       ,@l_thirdpanno                                                              
        ,@l_thirditcircle                                                           
        ,@l_dateofmaturity                                                          
        ,@l_dpintrefno                                                              
        ,@l_dateofbirth                                                
        ,@l_sexcode                                                                 
        ,@l_occupation                                                      
        ,@l_lifestyle                                                               
        ,@l_geographical                                                            
        ,@l_degree                                                                  
        ,@l_annualincome                                                            
        ,@l_nationality                                                             
        ,@l_legalstatus                                                          
        ,@l_feetype                                                                 
        ,@l_language                                                                
        ,@l_category                                                             
        ,@l_bankoption                                                              
        ,@l_staff                                                                   
        ,@l_staffcode                                                               
        ,@l_securitycode                                                            
        ,@l_bosettlementplanflag                                            ,@l_voicemail                                                               
        ,@l_rbirefno                                                                
        ,@l_rbiappdate                                                              
        ,@l_sebiregno                                                               
        ,@l_taxdeduction                                                            
        ,@l_smartcardreq                                                            
        ,@l_smartcardno                   
        ,@l_smartcardpin                                                            
        ,@l_ecs                                                                     
        ,@l_electronicconfirm                                                       
        ,@l_dividendcurrency                                                        
        ,@l_groupcd                                                                 
        ,@l_bosubstatus                    
        ,@l_ccid                                                                    
        ,@l_cmid                                                                    
        ,@l_stockexchange                                                           
        ,@l_confirmation                                                            
        ,@l_tradingid                                                               
        ,@l_bostatementcycle                                                        
        ,@l_branchno                            
        ,@l_bankacno                                                                
        ,@l_bankccy                                                                 
        ,@l_bankacttype                                                             
        ,@l_micr                                                       
        ,@l_divbankcode                                                             
        ,@l_divbranchno                                                             
 ,@l_divbankacno                                           
        ,@l_divbankccy                                    
        ,@l_poaid                                                                   
        ,@l_poaname                                                                 
        ,@l_poamiddlename                                                           
        ,@l_poalastname                                                             
        ,@l_poatitle                           
        ,@l_poasuffix                                                               
        ,@l_poafathername                                                           
        ,@l_poaadd1                                                 
        ,@l_poaadd2                                     
        ,@l_poaadd3                                                                 
        ,@l_poacity        
        ,@l_poastate                                                                
        ,@l_poacountry                                                              
        ,@l_poapin                                                                  
        ,@l_poateleindicator                                                        
        ,@l_poatele1                                                            
        ,@l_poateleindicator2                                                       
        ,@l_poatele2                                                                
        ,isnull(@l_poatele3                   ,'')                                             
        ,@l_poafax                                                               
        ,isnull(@l_poapanno                    ,'')                                            
        ,@l_poaitcircle                                               
        ,isnull(@l_poaemail                    ,'')                     
        ,@l_setupdate                                                               
        ,@l_operateaccount                                                          
        ,@l_gpaflag                                                                 
        ,@l_effectivefrom                                                           
        ,@l_effectiveto                                                             
        ,@l_cacharfield                                                         
        ,@l_chequecash                                                              
        ,@l_chqno                                                                   
        ,@l_recvdate                                                                
        ,@l_rupees                                                                  
        ,@l_drawn                                                                   
        ,@l_chgsscheme                                                              
        ,@l_billcycle                                                               
        ,@l_brboffcode                                                              
        ,@l_familycd                                                 
        ,@l_statements                                                              
        ,@l_billflag                                                                
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
        ,@l_corresadd1                                                              
        ,@l_corresadd2                                                              
        ,@l_corresadd3                                                
        ,@l_correscity                                                              
        ,@l_corresstate                                                             
        ,@l_correscountry                                                           
        ,@l_correspin                                                               
        ,@l_correstele1                                                             
        ,@l_correstele2                                                             
        ,@l_correstele3                                                             
        ,@l_corresfax                                                    
        ,@l_blsavingcd                                                              
        ,@l_errormsg                                                                
        ,@l_nominee                                                                 
        ,@l_nomineeadd1                                     
        ,@l_nomineeadd2                                                             
        ,@l_nomineeadd3                                                             
        ,@l_nomineecity                                                             
        ,@l_nomineestate                                                            
        ,@l_nomineecountry                                                          
        ,@l_nomineepin                                                      
        ,@l_nominee_dob                                                             
        ,@l_fadd1                                                                   
        ,@l_fadd2                                                                   
        ,@l_fadd3                                                                   
        ,@l_fcity                                                                   
        ,@l_fstate                                                                  
        ,@l_fcountry                                                                
        ,@l_fpin                                                                    
        ,@l_ftele                                                                   
        ,@l_ffax                                        
        ,@l_mkrdt                                       
        ,@l_mkrid                                                                   
        ,@l_nominee_search                                       
        ,@l_authid                                                                  
        ,@l_authdt                              
        ,@l_remark                                       
        ,@l_inwarddt                                                                
        ,@l_authtm                                                                  
        ,@l_mkrtm                           
   ,@l_nomineemiddlename                                
        ,@l_nomineetitle                                                            
        ,@l_nomineesuffix                                                           
        ,@l_nomineefathername                                                       
        ,@l_nomineephoneindicator                                                   
        ,@l_nomineetele1                                                            
        ,@l_remisser                                           
        ,@l_poaforpayin                                                             
        ,@l_poaregdate                                            
        ,@l_modified                                            
        ,0                                  
        ,@c_dpam_id                                            
        )                                            
        --                                            
        SET @l_brcode   = ''                                                                 
        SET @l_instrno   = ''                                                  
        SET @l_name       = ''                                                     
        SET @l_middlename  = ''                                                              
        SET @l_lastname     = ''                                                             
        SET @l_title   = ''                 
        SET @l_suffix   = ''                                                           
        SET @l_fathername      = ''                                                          
        SET @l_add1  = ''                                                 
        SET @l_add2   = ''                                                                   
        SET @l_add3    = ''                                                                  
        SET @l_city    = ''                                                                
        SET @l_state   = ''                                                                  
        SET @l_country  = ''                      
        SET @l_pin       = ''                                                                
        SET @l_phoneindicator  = ''                                                          
        SET @l_tele1  = ''                                                                   
        SET @l_phoneindicator2  = ''                                                         
        SET @l_tele2    = ''                                                         
        SET @l_tele3   = ''                                                            
        SET @l_fax     = ''                                                            
        SET @l_panno   = ''                                                            
        SET @l_itcircle      = ''                                                            
        SET @l_email   = ''                                                            
        SET @l_usertext1     = ''                                                            
        SET @l_usertext2     = ''                                                            
        SET @l_userfield1    = ''                                                            
        SET @l_userfield2    = ''                                                            
        SET @l_userfield3    = ''                                                            
        SET @l_sechname      = ''                                                            
        SET @l_sechmiddle    = ''                                                            
        SET @l_sechlastname  = ''                                                            
        SET @l_sechtitle     = ''                                                            
        SET @l_sechsuffix    = ''                                                            
        SET @l_sechfathername   = ''                                                         
        SET @l_sechpanno  = ''                                                         
        SET @l_sechitcircle    = ''                                                          
        SET @l_thirdname       = ''                                                          
        SET @l_thirdmiddle     = ''                                                          
        SET @l_thirdlastname   = ''                                                          
        SET @l_thirdtitle      = ''                                                          
        SET @l_thirdsuffix     = ''                                                          
        SET @l_thirdfathername   = ''                                                        
        SET @l_thirdpanno  = ''                                                        
        SET @l_thirditcircle     = ''                                         
        SET @l_dateofmaturity   = ''                                             
        SET @l_dpintrefno      = ''                                                          
        SET @l_dateofbirth     = ''                                                          
        SET @l_sexcode   = ''                              
        SET @l_occupation     = ''                                                           
        SET @l_lifestyle      = ''                                                           
        SET @l_geographical  = ''                                    
        SET @l_degree    = ''                                                          
        SET @l_annualincome     = null                                                         
        SET @l_nationality  = ''                      
        SET @l_legalstatus       = ''                                                        
        SET @l_feetype    = ''                                             
        SET @l_language  = ''                                                          
        SET @l_category  = ''                                                        
        SET @l_bankoption     = ''      
        SET @l_staff   = ''                                                            
        SET @l_staffcode      = ''                                                           
        SET @l_securitycode    = ''                                                          
        SET @l_bosettlementplanflag   = ''                                                   
        SET @l_voicemail    = ''                                                             
        SET @l_rbirefno      = ''                                                       
        SET @l_rbiappdate   = ''                                                             
        SET @l_sebiregno    = ''                                                             
        SET @l_taxdeduction   = ''                                                           
        SET @l_smartcardreq   = ''                                                           
        SET @l_smartcardno    = ''                                                           
        SET @l_smartcardpin   = null                                                           
        SET @l_ecs   = ''                                                             
        SET @l_electronicconfirm   = ''                                                      
        SET @l_dividendcurrency    = null                                                      
        SET @l_groupcd       = ''                                                            
        SET @l_bosubstatus    = ''                                                           
        SET @l_ccid   = null                                                             
        SET @l_cmid  = ''                                                              
        SET @l_stockexchange   = ''                                                          
        SET @l_confirmation    = ''                                                          
        SET @l_tradingid     = ''                                                            
        SET @l_bostatementcycle   = ''                                                       
        SET @l_branchno       = ''                                                           
        SET @l_bankacno       = ''                                                           
        SET @l_bankccy       = null                                                            
        SET @l_bankacttype   = ''                                                            
        SET @l_micr   = ''                                                             
        SET @l_divbankcode  = ''                                                             
        SET @l_divbranchno   = ''                                                            
        SET @l_divbankacno   = ''                                                            
        SET @l_divbankccy    = null                                                            
        SET @l_poaid   = ''                                                            
        SET @l_poaname       = ''                                                            
        SET @l_poamiddlename   = ''                                                          
        SET @l_poalastname    = ''                                                           
        SET @l_poatitle       = ''                                                           
        SET @l_poasuffix      = ''                                                           
        SET @l_poafathername   = ''                              
        SET @l_poaadd1   = ''                   
        SET @l_poaadd2   = ''                                                          
        SET @l_poaadd3   = ''                                      
    SET @l_poacity   = ''                                                
        SET @l_poastate  = ''                                                          
   SET @l_poacountry      = ''                                         
        SET @l_poapin     = ''                                               
        SET @l_poateleindicator   = ''                                                       
        SET @l_poatele1      = ''                                                      
        SET @l_poateleindicator2   = ''                                                      
        SET @l_poatele2      = ''                                                      
        SET @l_poatele3   = ''                                                         
        SET @l_poafax      = ''                                                        
        SET @l_poapanno    = ''                                                        
        SET @l_poaitcircle       = ''                                                        
        SET @l_poaemail    = ''                                                        
        SET @l_setupdate   = ''                                                        
        SET @l_operateaccount    = ''                                                        
        SET @l_gpaflag     = ''                                                        
        SET @l_effectivefrom     = ''                                                        
        SET @l_effectiveto       = ''                                                        
      SET @l_cacharfield       = ''                                                        
        SET @l_chequecash  = ''                                                        
        SET @l_chqno       = ''                                                        
        SET @l_recvdate    = ''                                                        
        SET @l_rupees      = null                                                        
        SET @l_drawn       = ''                                                        
        SET @l_chgsscheme  = ''                                                        
        SET @l_billcycle   = ''                                                        
     SET @l_brboffcode  = ''                                                        
        SET @l_familycd    = ''                                                        
        SET @l_statements   = ''                                                       
        SET @l_billflag     = ''                                                       
        SET @l_allowcredit  = 0                                                       
        SET @l_billcode     = ''                                                       
        SET @l_collectioncode      = ''                                                      
        SET @l_upfront       = ''                                                      
        SET @l_keepsettlement     = ''                                                       
        SET @l_fre_trx      = null                                                       
        SET @l_fre_hold     = null                                                       
        SET @l_fre_bill     = null                                                       
        SET @l_allow        = ''                                                       
        SET @l_batchno      = null                                                       
        SET @l_cmcd         = ''                                                       
        SET @l_corresadd1   = ''                                                       
   SET @l_corresadd2   = ''                                                       
        SET @l_corresadd3   = ''                                                       
        SET @l_correscity    = ''                                                      
        SET @l_corresstate      = ''                                                         
        SET @l_correscountry   = ''                                                          
        SET @l_correspin       = ''                                                          
        SET @l_correstele1     = ''                                                          
        SET @l_correstele2     = ''                                                          
        SET @l_correstele3     = ''                        
        SET @l_corresfax       = ''                                         
        SET @l_blsavingcd      = ''           
        SET @l_errormsg   = ''                                                         
        SET @l_nominee   = ''                                                          
        SET @l_nomineeadd1      = ''                                                         
        SET @l_nomineeadd2       = ''                                                       
        SET @l_nomineeadd3       = ''                                                        
        SET @l_nomineecity      = ''                                                         
        SET @l_nomineestate     = ''                                                         
        SET @l_nomineecountry   = ''                                                         
        SET @l_nomineepin       = ''                                                         
        SET @l_nominee_dob      = ''                                                         
        SET @l_fadd1      = ''                                                         
        SET @l_fadd2      = ''                                               
        SET @l_fadd3      = ''                                                         
        SET @l_fcity      = ''                                                             
        SET @l_fstate     = ''                                                         
        SET @l_fcountry   = ''                                                       
        SET @l_fpin       = ''                                                         
        SET @l_ftele      = ''                                                         
        SET @l_ffax       = ''                                                         
        SET @l_mkrdt      = ''                                                  
        SET @l_mkrid      = ''                                                         
        SET @l_nominee_search   = ''                                                         
        SET @l_authid     = ''                                                         
        SET @l_authdt    = ''                                                          
        SET @l_remark             = ''                                                 
        SET @l_inwarddt          = ''                                                  
        SET @l_authtm            = ''                            SET @l_mkrtm            = ''                                                   
        SET @l_nomineemiddlename       = ''                                                  
        SET @l_nomineetitle     = ''                                                   
        SET @l_nomineesuffix    = ''                                                   
        SET @l_nomineefathername      = ''                                                   
        SET @l_nomineephoneindicator   = ''                                                   
        SET @l_nomineetele1      = ''                                                        
        SET @l_remisser   = ''                                                         
        SET @l_poaforpayin      = ''                                                         
        SET @l_poaregdate       = ''                                            
    --                                            
    END                                            
      FETCH NEXT FROM @c_cursor INTO @c_crn_no, @c_dpam_id, @c_acct_no, @c_sba_no                                            
    --                                            
    END  --#cursor                                            
    --                                            
    CLOSE @c_cursor                                            
    DEALLOCATE @c_cursor                                            
  --                                               
  --END--CE                                            
  --                          
  --client_checkList--                                            
  --IF @pa_tab = 'CCL'                                   
  --BEGIN                                            
  --                                            
  IF EXISTS(SELECT top 1 * FROM client_checklist_cdsl WITH (NOLOCK))                                            
    BEGIN--#                      
    --                                         
      INSERT INTO client_checklist_cdsl_hst                                 
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
      FROM   client_checklist_cdsl                                            
      WHERE  cmpltd = 1                                            
      --                                            
      DELETE FROM client_checklist_cdsl                                             
      WHERE  cmpltd  = 1                                            
    --                                            
    END--#                                            
    --                       
    IF isnull(@pa_from_dt,'') <> '' AND  isnull(@pa_to_dt,'') <> '' AND isnull(@pa_from_crn,'') <> '' AND isnull(@pa_to_crn,'') <> ''                                            
    BEGIN                                            
    --                               
      --For Account level property                        
      --                        
      if exists(select * from client_checklist_cdsl where cmpltd = 0)                                            
      begin                                            
      --                                             
       delete from client_checklist_cdsl where cmpltd = 0                                            
      --                              
      INSERT INTO client_checklist_cdsl                                            
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
           , CASE when accdocm.accdocm_cd = 'BANK_IDN' then 'A05'                        
                  when accdocm.accdocm_cd = 'BANK_ADD' then 'B05'                             
                  when accdocm.accdocm_cd = 'PROO_ADD' then 'B06'                             
                  when accdocm.accdocm_cd = 'POAPI_OTH' then 'D05'                        
                  when accdocm.accdocm_cd = 'FAX_OTH' then 'D06'                         
                  ELSE ''                        
              END                         
           , convert(char(8), dpam_created_by)                                              
           , replace(convert(varchar(11), dpam_created_dt,111),'-','')--replace(convert(varchar, dpam_created_dt,111),'/','')                                              
           , CASE WHEN dpam.dpam_created_dt = dpam.dpam_lst_upd_dt THEN 'I' ELSE 'U' END modified                                   
           , 0                                              
      FROM   dp_acct_mstr          dpam  WITH (NOLOCK)                                              
           , exch_seg_mstr         excsm WITH (NOLOCK)                                      
           , account_documents       accd                            
           , account_document_mstr   accdocm                            
      WHERE  excsm.excsm_id       = dpam_excsm_id           
      AND    excsm.excsm_exch_cd  = 'CDSL'                                              
      AND    dpam_lst_upd_dt        between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                
      AND    convert(varchar, dpam_crn_no) between convert(varchar, @pa_from_crn)  AND  convert(varchar, @pa_to_crn)                                              
      AND    dpam_deleted_ind    = 1                                              
      AND    excsm_deleted_ind   = 1                            
      AND    accd_deleted_ind    = 1                        
      and    accdocm_deleted_ind = 1                         
      AND  accd.accd_accdocm_doc_id = accdocm.accdocm_doc_id                            
      AND  dpam.dpam_id             = accd.accd_clisba_id                            
      AND  accdocm.accdocm_cd      IN('BANK_IDN','BANK_ADD','PROO_ADD','POAPI_OTH','FAX_OTH')                        
      --              
      end              
      --              
      else            
      begin            
      INSERT INTO client_checklist_cdsl                                            
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
           , CASE when accdocm.accdocm_cd = 'BANK_IDN' then 'A05'                        
                  when accdocm.accdocm_cd = 'BANK_ADD' then 'B05'                             
                  when accdocm.accdocm_cd = 'PROO_ADD' then 'B06'                             
                  when accdocm.accdocm_cd = 'POAPI_OTH' then 'D05'                        
                  when accdocm.accdocm_cd = 'FAX_OTH' then 'D06'                         
                  ELSE ''                        
              END                         
           , convert(char(8), dpam_created_by)                                              
           , replace(convert(varchar(11), dpam_created_dt,111),'-','')--replace(convert(varchar, dpam_created_dt,111),'/','')                                              
           , CASE WHEN dpam.dpam_created_dt = dpam.dpam_lst_upd_dt THEN 'I' ELSE 'U' END modified                                              
           , 0                                              
      FROM   dp_acct_mstr          dpam  WITH (NOLOCK)                                              
           , exch_seg_mstr         excsm WITH (NOLOCK)                                              
           , account_documents       accd                            
           , account_document_mstr   accdocm                         
      WHERE  excsm.excsm_id       = dpam_excsm_id     
      AND    excsm.excsm_exch_cd  = 'CDSL'                                              
      AND    dpam_lst_upd_dt        between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                
      AND    convert(varchar, dpam_crn_no) between convert(varchar, @pa_from_crn)  AND  convert(varchar, @pa_to_crn)                                              
      AND    dpam_deleted_ind    = 1                                              
      AND    excsm_deleted_ind   = 1                            
      AND    accd_deleted_ind    = 1                        
      and    accdocm_deleted_ind = 1                         
      AND  accd.accd_accdocm_doc_id = accdocm.accdocm_doc_id                            
      AND  dpam.dpam_id             = accd.accd_clisba_id                            
      AND  accdocm.accdocm_cd      IN('BANK_IDN','BANK_ADD','PROO_ADD','POAPI_OTH','FAX_OTH')                        
      --            
 end            
      --                       
      --For Client Level Property                        
      if exists(select * from client_checklist_cdsl where cmpltd = 0)               
      begin                                            
      --                                             
        delete from client_checklist_cdsl where cmpltd = 0                                            
      --              
      INSERT INTO client_checklist_cdsl                                            
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
           , CASE when docm.docm_cd = 'PASS_IDN' then 'A02'                        
                  when docm.docm_cd = 'PAN_IDN' then 'A01'                             
                  when docm.docm_cd = 'DRIV_IDN' then 'A03'                             
                  when docm.docm_cd = 'VOTE_IDN' then 'A04'                        
                  when docm.docm_cd = 'PASS_ADD' then 'B01'                         
                  when docm.docm_cd = 'DRIV_ADD' then 'B02'                        
                  when docm.docm_cd = 'RATI_ADD' then 'B03'                        
                  when docm.docm_cd = 'VOTE_ADD' then 'B04'                        
                  when docm.docm_cd = 'MEMO_COR' then 'C03'                        
                  when docm.docm_cd = 'BOAR_COR' then 'C01'                        
                  when docm.docm_cd = 'FORM_COR' then 'C04'                        
                  when docm.docm_cd = 'BOAS_COR' then 'C02'                        
                  when docm.docm_cd = 'PHOT_OTH' then 'D01'                        
                  when docm.docm_cd = 'SIGN_OTH' then 'D02'                        
                  when docm.docm_cd = 'STAM_OTH' then 'D03'                        
                  ELSE ''                        
              END                         
           , convert(char(8), dpam_created_by)                                              
           , replace(convert(varchar(11), dpam_created_dt,111),'-','')--replace(convert(varchar, dpam_created_dt,111),'/','')                                              
           , CASE WHEN dpam.dpam_created_dt = dpam.dpam_lst_upd_dt THEN 'I' ELSE 'U' END modified                                              
           , 0                                              
      FROM   dp_acct_mstr          dpam  WITH (NOLOCK)                                   
           , exch_seg_mstr         excsm WITH (NOLOCK)                                              
           , client_documents       clid                            
           , document_mstr          docm                            
      WHERE  excsm.excsm_id       = dpam_excsm_id                                              
      AND    excsm.excsm_exch_cd  = 'CDSL'                                              
      AND    dpam_lst_upd_dt        between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                
      AND    convert(varchar, dpam_crn_no) between convert(varchar, @pa_from_crn)  AND  convert(varchar, @pa_to_crn)                                              
      AND    dpam_deleted_ind    = 1                                              
      AND    excsm_deleted_ind   = 1                            
      AND    clid_deleted_ind    = 1                        
      AND    docm_deleted_ind    = 1                           
      AND  clid.clid_docm_doc_id = docm.docm_doc_id                            
      AND  dpam.dpam_crn_no      = clid.clid_crn_no                            
      AND  docm.docm_cd      IN('PASS_IDN','PAN_IDN','DRIV_IDN','VOTE_IDN','PASS_ADD','DRIV_ADD','RATI_ADD','VOTE_ADD','MEMO_COR','BOAR_COR','FORM_COR','BOAS_COR','PHOT_OTH','SIGN_OTH','STAM_OTH')                                                          
      --  
    END              
    else            
    begin            
    INSERT INTO client_checklist_cdsl                                            
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
           , CASE when docm.docm_cd = 'PASS_IDN' then 'A02'                        
                  when docm.docm_cd = 'PAN_IDN' then 'A01'                             
                  when docm.docm_cd = 'DRIV_IDN' then 'A03'                             
                  when docm.docm_cd = 'VOTE_IDN' then 'A04'                        
                  when docm.docm_cd = 'PASS_ADD' then 'B01'                         
                  when docm.docm_cd = 'DRIV_ADD' then 'B02'                        
                  when docm.docm_cd = 'RATI_ADD' then 'B03'                        
                  when docm.docm_cd = 'VOTE_ADD' then 'B04'                        
                  when docm.docm_cd = 'MEMO_COR' then 'C03'                        
                  when docm.docm_cd = 'BOAR_COR' then 'C01'                        
                  when docm.docm_cd = 'FORM_COR' then 'C04'                        
                  when docm.docm_cd = 'BOAS_COR' then 'C02'                        
                  when docm.docm_cd = 'PHOT_OTH' then 'D01'                        
                  when docm.docm_cd = 'SIGN_OTH' then 'D02'                        
                  when docm.docm_cd = 'STAM_OTH' then 'D03'                        
                  ELSE ''                        
              END                         
           , convert(char(8), dpam_created_by)                                              
           , replace(convert(varchar(11), dpam_created_dt,111),'-','')--replace(convert(varchar, dpam_created_dt,111),'/','')                                              
           , CASE WHEN dpam.dpam_created_dt = dpam.dpam_lst_upd_dt THEN 'I' ELSE 'U' END modified                                              
           , 0                                       
      FROM   dp_acct_mstr          dpam  WITH (NOLOCK)                                              
           , exch_seg_mstr         excsm WITH (NOLOCK)                                              
           , client_documents       clid                            
           , document_mstr          docm                            
      WHERE  excsm.excsm_id       = dpam_excsm_id                                              
      AND    excsm.excsm_exch_cd  = 'CDSL'                                              
      AND    dpam_lst_upd_dt        between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                
      AND    convert(varchar, dpam_crn_no) between convert(varchar, @pa_from_crn)  AND  convert(varchar, @pa_to_crn)                                              
      AND    dpam_deleted_ind    = 1                                              
      AND    excsm_deleted_ind   = 1                            
      AND    clid_deleted_ind    = 1                        
      AND    docm_deleted_ind    = 1                           
      AND  clid.clid_docm_doc_id = docm.docm_doc_id                            
      AND  dpam.dpam_crn_no      = clid.clid_crn_no                            
      AND  docm.docm_cd      IN('PASS_IDN','PAN_IDN','DRIV_IDN','VOTE_IDN','PASS_ADD','DRIV_ADD','RATI_ADD','VOTE_ADD','MEMO_COR','BOAR_COR','FORM_COR','BOAS_COR','PHOT_OTH','SIGN_OTH','STAM_OTH')                                                           
 
      --            
      end            
      end                                                 
    --                           
    IF isnull(@pa_from_dt,'') <> '' AND  isnull(@pa_to_dt,'') <> '' AND isnull(@pa_from_crn,'') = '' AND isnull(@pa_to_crn,'') = ''                                            
    BEGIN                                            
    --                               
      --For Account level property                        
      --                        
      if exists(select * from client_checklist_cdsl where cmpltd = 0)                                            
      begin                       
      --                                             
       delete from client_checklist_cdsl where cmpltd = 0                                            
      --                              
      INSERT INTO client_checklist_cdsl                                            
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
           , CASE when accdocm.accdocm_cd = 'BANK_IDN' then 'A05'                        
                  when accdocm.accdocm_cd = 'BANK_ADD' then 'B05'                             
                  when accdocm.accdocm_cd = 'PROO_ADD' then 'B06'                             
                  when accdocm.accdocm_cd = 'POAPI_OTH' then 'D05'                        
                  when accdocm.accdocm_cd = 'FAX_OTH' then 'D06'                         
ELSE ''                        
              END                         
           , convert(char(8), dpam_created_by)                                              
           , replace(convert(varchar(11), dpam_created_dt,111),'-','')--replace(convert(varchar, dpam_created_dt,111),'/','')                                              
           , CASE WHEN dpam.dpam_created_dt = dpam.dpam_lst_upd_dt THEN 'I' ELSE 'U' END modified                                              
           , 0                                              
      FROM   dp_acct_mstr          dpam  WITH (NOLOCK)                                              
           , exch_seg_mstr         excsm WITH (NOLOCK)                                              
           , account_documents       accd                            
           , account_document_mstr   accdocm                            
      WHERE  excsm.excsm_id       = dpam_excsm_id                                              
      AND    excsm.excsm_exch_cd  = 'CDSL'                                              
      AND    dpam_lst_upd_dt        between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                
      --AND    convert(varchar, dpam_crn_no) between convert(varchar, @pa_from_crn)  AND  convert(varchar, @pa_to_crn)                                              
      AND    dpam_deleted_ind    = 1                                              
      AND    excsm_deleted_ind   = 1                            
      AND    accd_deleted_ind    = 1                        
      and    accdocm_deleted_ind = 1                         
      AND  accd.accd_accdocm_doc_id = accdocm.accdocm_doc_id                            
      AND  dpam.dpam_id             = accd.accd_clisba_id                            
      AND  accdocm.accdocm_cd      IN('BANK_IDN','BANK_ADD','PROO_ADD','POAPI_OTH','FAX_OTH')                        
      --              
      end              
      --              
      else            
      begin            
      INSERT INTO client_checklist_cdsl                                            
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
           , CASE when accdocm.accdocm_cd = 'BANK_IDN' then 'A05'                        
                  when accdocm.accdocm_cd = 'BANK_ADD' then 'B05'                             
                  when accdocm.accdocm_cd = 'PROO_ADD' then 'B06'                             
                  when accdocm.accdocm_cd = 'POAPI_OTH' then 'D05'                        
                  when accdocm.accdocm_cd = 'FAX_OTH' then 'D06'                         
                  ELSE ''                        
              END                         
           , convert(char(8), dpam_created_by)                                              
           , replace(convert(varchar(11), dpam_created_dt,111),'-','')--replace(convert(varchar, dpam_created_dt,111),'/','')                                              
           , CASE WHEN dpam.dpam_created_dt = dpam.dpam_lst_upd_dt THEN 'I' ELSE 'U' END modified                                              
           , 0                                              
      FROM   dp_acct_mstr          dpam  WITH (NOLOCK)                            
           , exch_seg_mstr         excsm WITH (NOLOCK)                                              
           , account_documents       accd                            
           , account_document_mstr   accdocm                            
      WHERE  excsm.excsm_id       = dpam_excsm_id                                              
      AND    excsm.excsm_exch_cd  = 'CDSL'                                              
      AND    dpam_lst_upd_dt  between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                
      --AND    convert(varchar, dpam_crn_no) between convert(varchar, @pa_from_crn)  AND  convert(varchar, @pa_to_crn)                                              
      AND    dpam_deleted_ind    = 1                                              
      AND    excsm_deleted_ind   = 1                            
      AND    accd_deleted_ind    = 1                        
      and    accdocm_deleted_ind = 1                         
      AND  accd.accd_accdocm_doc_id = accdocm.accdocm_doc_id                            
      AND  dpam.dpam_id             = accd.accd_clisba_id                            
      AND  accdocm.accdocm_cd      IN('BANK_IDN','BANK_ADD','PROO_ADD','POAPI_OTH','FAX_OTH')                        
      --            
      end            
      --                       
      --For Client Level Property                        
      if exists(select * from client_checklist_cdsl where cmpltd = 0)               
      begin                                            
      --                                             
        delete from client_checklist_cdsl where cmpltd = 0                                            
      --              
      --Print 'Client level if'        
      INSERT INTO client_checklist_cdsl                                            
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
           , CASE when docm.docm_cd = 'PASS_IDN' then 'A02'                        
                  when docm.docm_cd = 'PAN_IDN' then 'A01'                             
                  when docm.docm_cd = 'DRIV_IDN' then 'A03'                             
                  when docm.docm_cd = 'VOTE_IDN' then 'A04'                        
                  when docm.docm_cd = 'PASS_ADD' then 'B01'                         
                  when docm.docm_cd = 'DRIV_ADD' then 'B02'                        
                  when docm.docm_cd = 'RATI_ADD' then 'B03'                        
                  when docm.docm_cd = 'VOTE_ADD' then 'B04'                        
                  when docm.docm_cd = 'MEMO_COR' then 'C03'                        
                  when docm.docm_cd = 'BOAR_COR' then 'C01'                        
                  when docm.docm_cd = 'FORM_COR' then 'C04'                        
                  when docm.docm_cd = 'BOAS_COR' then 'C02'                        
                  when docm.docm_cd = 'PHOT_OTH' then 'D01'                        
                  when docm.docm_cd = 'SIGN_OTH' then 'D02'                        
                  when docm.docm_cd = 'STAM_OTH' then 'D03'                        
                  ELSE ''                        
              END                         
           , convert(char(8), dpam_created_by)                                              
           , replace(convert(varchar(11), dpam_created_dt,111),'-','')--replace(convert(varchar, dpam_created_dt,111),'/','')                                              
           , CASE WHEN dpam.dpam_created_dt = dpam.dpam_lst_upd_dt THEN 'I' ELSE 'U' END modified                                              
           , 0                                              
      FROM   dp_acct_mstr          dpam  WITH (NOLOCK)                                              
           , exch_seg_mstr         excsm WITH (NOLOCK)                             
           , client_documents       clid                            
           , document_mstr          docm                            
      WHERE  excsm.excsm_id       = dpam_excsm_id                                              
      AND    excsm.excsm_exch_cd  = 'CDSL'                                              
      AND    dpam_lst_upd_dt        between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                
      --AND    convert(varchar, dpam_crn_no) between convert(varchar, @pa_from_crn)  AND  convert(varchar, @pa_to_crn)                                              
      AND    dpam_deleted_ind    = 1                                              
      AND    excsm_deleted_ind   = 1                            
      AND    clid_deleted_ind    = 1                        
      AND    docm_deleted_ind    = 1                           
      AND  clid.clid_docm_doc_id = docm.docm_doc_id                            
      AND  dpam.dpam_crn_no      = clid.clid_crn_no                            
      AND  docm.docm_cd      IN('PASS_IDN','PAN_IDN','DRIV_IDN','VOTE_IDN','PASS_ADD','DRIV_ADD','RATI_ADD','VOTE_ADD','MEMO_COR','BOAR_COR','FORM_COR','BOAS_COR','PHOT_OTH','SIGN_OTH','STAM_OTH')                                                          
      --
    END              
    else            
    begin        
    --Print 'Client level else'      
    INSERT INTO client_checklist_cdsl                                            
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
           , CASE when docm.docm_cd = 'PASS_IDN' then 'A02'                        
                  when docm.docm_cd = 'PAN_IDN' then 'A01'                             
                  when docm.docm_cd = 'DRIV_IDN' then 'A03'                             
                  when docm.docm_cd = 'VOTE_IDN' then 'A04'                        
                  when docm.docm_cd = 'PASS_ADD' then 'B01'                         
                  when docm.docm_cd = 'DRIV_ADD' then 'B02'                        
                  when docm.docm_cd = 'RATI_ADD' then 'B03'            
                  when docm.docm_cd = 'VOTE_ADD' then 'B04'                        
                  when docm.docm_cd = 'MEMO_COR' then 'C03'                        
                  when docm.docm_cd = 'BOAR_COR' then 'C01'                        
                  when docm.docm_cd = 'FORM_COR' then 'C04'                        
                  when docm.docm_cd = 'BOAS_COR' then 'C02'                        
                  when docm.docm_cd = 'PHOT_OTH' then 'D01'                        
                  when docm.docm_cd = 'SIGN_OTH' then 'D02'    
                  when docm.docm_cd = 'STAM_OTH' then 'D03'                        
                  ELSE ''                        
              END                         
           , convert(char(8), dpam_created_by)                                              
           , replace(convert(varchar(11), dpam_created_dt,111),'-','')--replace(convert(varchar, dpam_created_dt,111),'/','')                                              
           , CASE WHEN dpam.dpam_created_dt = dpam.dpam_lst_upd_dt THEN 'I' ELSE 'U' END modified                                              
           , 0                                              
      FROM   dp_acct_mstr          dpam  WITH (NOLOCK)     
           , exch_seg_mstr         excsm WITH (NOLOCK)                                              
           , client_documents       clid                            
           , document_mstr          docm                            
      WHERE  excsm.excsm_id       = dpam_excsm_id                                              
      AND    excsm.excsm_exch_cd  = 'CDSL'                                              
      AND    dpam_lst_upd_dt        between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                
      --AND    convert(varchar, dpam_crn_no) between convert(varchar, @pa_from_crn)  AND  convert(varchar, @pa_to_crn)                                              
      AND    dpam_deleted_ind    = 1                                              
      AND    excsm_deleted_ind   = 1                            
      AND    clid_deleted_ind    = 1                        
      AND    docm_deleted_ind    = 1                           
      AND  clid.clid_docm_doc_id = docm.docm_doc_id                            
      AND  dpam.dpam_crn_no      = clid.clid_crn_no                            
      AND  docm.docm_cd      IN('PASS_IDN','PAN_IDN','DRIV_IDN','VOTE_IDN','PASS_ADD','DRIV_ADD','RATI_ADD','VOTE_ADD','MEMO_COR','BOAR_COR','FORM_COR','BOAS_COR','PHOT_OTH','SIGN_OTH','STAM_OTH')                                                          
  
      --            
      end            
      end                                                   
    --                                            
    IF isnull(@pa_from_dt,'') = '' AND  isnull(@pa_to_dt,'') = '' AND isnull(@pa_from_crn,'') <> '' AND isnull(@pa_to_crn,'') <> ''                                            
    BEGIN                                            
    --                               
      --For Account level property                        
      --                        
      if exists(select * from client_checklist_cdsl where cmpltd = 0)                                 
      begin                                            
      --                                             
       delete from client_checklist_cdsl where cmpltd = 0                                            
      --                              
      INSERT INTO client_checklist_cdsl                                            
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
           , CASE when accdocm.accdocm_cd = 'BANK_IDN' then 'A05'                        
                  when accdocm.accdocm_cd = 'BANK_ADD' then 'B05'                          
                  when accdocm.accdocm_cd = 'PROO_ADD' then 'B06'                             
                  when accdocm.accdocm_cd = 'POAPI_OTH' then 'D05'                        
                  when accdocm.accdocm_cd = 'FAX_OTH' then 'D06'                         
                  ELSE ''                        
              END                         
           , convert(char(8), dpam_created_by)                                              
           , replace(convert(varchar(11), dpam_created_dt,111),'-','')--replace(convert(varchar, dpam_created_dt,111),'/','')                                              
           , CASE WHEN dpam.dpam_created_dt = dpam.dpam_lst_upd_dt THEN 'I' ELSE 'U' END modified                           
           , 0                                  
      FROM   dp_acct_mstr          dpam  WITH (NOLOCK)                                              
           , exch_seg_mstr         excsm WITH (NOLOCK)                                              
           , account_documents       accd                            
           , account_document_mstr   accdocm                            
      WHERE  excsm.excsm_id       = dpam_excsm_id                                              
      AND    excsm.excsm_exch_cd  = 'CDSL'                                              
      --AND    dpam_lst_upd_dt        between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                
      AND    convert(varchar, dpam_crn_no) between convert(varchar, @pa_from_crn)  AND  convert(varchar, @pa_to_crn)                                              
      AND    dpam_deleted_ind    = 1                                              
      AND    excsm_deleted_ind   = 1                            
      AND    accd_deleted_ind    = 1                        
      and    accdocm_deleted_ind = 1                         
      AND  accd.accd_accdocm_doc_id = accdocm.accdocm_doc_id                            
      AND  dpam.dpam_id             = accd.accd_clisba_id                            
      AND  accdocm.accdocm_cd      IN('BANK_IDN','BANK_ADD','PROO_ADD','POAPI_OTH','FAX_OTH')                        
      --              
      end              
      --              
      else            
      begin            
      INSERT INTO client_checklist_cdsl                                            
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
           , CASE when accdocm.accdocm_cd = 'BANK_IDN' then 'A05'                        
                  when accdocm.accdocm_cd = 'BANK_ADD' then 'B05'                             
                  when accdocm.accdocm_cd = 'PROO_ADD' then 'B06'                             
                  when accdocm.accdocm_cd = 'POAPI_OTH' then 'D05'                        
                  when accdocm.accdocm_cd = 'FAX_OTH' then 'D06'                         
                  ELSE ''                        
              END                         
           , convert(char(8), dpam_created_by)                                              
           , replace(convert(varchar(11), dpam_created_dt,111),'-','')--replace(convert(varchar, dpam_created_dt,111),'/','')                                              
, CASE WHEN dpam.dpam_created_dt = dpam.dpam_lst_upd_dt THEN 'I' ELSE 'U' END modified                                              
           , 0                                              
      FROM   dp_acct_mstr          dpam  WITH (NOLOCK)                                              
           , exch_seg_mstr         excsm WITH (NOLOCK)                                              
           , account_documents       accd                            
           , account_document_mstr   accdocm                            
      WHERE  excsm.excsm_id       = dpam_excsm_id                                              
      AND    excsm.excsm_exch_cd  = 'CDSL'                                              
      --AND    dpam_lst_upd_dt        between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                
      AND    convert(varchar, dpam_crn_no) between convert(varchar, @pa_from_crn)  AND  convert(varchar, @pa_to_crn)                                              
      AND    dpam_deleted_ind    = 1                                              
      AND    excsm_deleted_ind   = 1                            
      AND    accd_deleted_ind    = 1                        
      and    accdocm_deleted_ind = 1                         
      AND  accd.accd_accdocm_doc_id = accdocm.accdocm_doc_id                            
      AND  dpam.dpam_id             = accd.accd_clisba_id                            
      AND  accdocm.accdocm_cd      IN('BANK_IDN','BANK_ADD','PROO_ADD','POAPI_OTH','FAX_OTH')                        
      --            
      end            
      --                       
      --For Client Level Property                        
      if exists(select * from client_checklist_cdsl where cmpltd = 0)               
      begin                                            
      --                                             
        delete from client_checklist_cdsl where cmpltd = 0                                            
      --              
      INSERT INTO client_checklist_cdsl                                            
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
           , CASE when docm.docm_cd = 'PASS_IDN' then 'A02'                        
      when docm.docm_cd = 'PAN_IDN' then 'A01'                             
                  when docm.docm_cd = 'DRIV_IDN' then 'A03'                             
                  when docm.docm_cd = 'VOTE_IDN' then 'A04'                        
                  when docm.docm_cd = 'PASS_ADD' then 'B01'                         
                  when docm.docm_cd = 'DRIV_ADD' then 'B02'                        
                  when docm.docm_cd = 'RATI_ADD' then 'B03'                        
                  when docm.docm_cd = 'VOTE_ADD' then 'B04'                        
                  when docm.docm_cd = 'MEMO_COR' then 'C03'                        
                  when docm.docm_cd = 'BOAR_COR' then 'C01'                        
                  when docm.docm_cd = 'FORM_COR' then 'C04'                        
                  when docm.docm_cd = 'BOAS_COR' then 'C02'                        
                  when docm.docm_cd = 'PHOT_OTH' then 'D01'                        
                  when docm.docm_cd = 'SIGN_OTH' then 'D02'                        
                  when docm.docm_cd = 'STAM_OTH' then 'D03'                        
                  ELSE ''                        
              END                         
           , convert(char(8), dpam_created_by)                                              
           , replace(convert(varchar(11), dpam_created_dt,111),'-','')--replace(convert(varchar, dpam_created_dt,111),'/','')                                              
           , CASE WHEN dpam.dpam_created_dt = dpam.dpam_lst_upd_dt THEN 'I' ELSE 'U' END modified                                              
           , 0            
      FROM   dp_acct_mstr          dpam  WITH (NOLOCK)                                              
           , exch_seg_mstr         excsm WITH (NOLOCK)                                              
           , client_documents       clid                            
           , document_mstr          docm                            
      WHERE  excsm.excsm_id       = dpam_excsm_id                                              
      AND    excsm.excsm_exch_cd  = 'CDSL'                                              
      --AND    dpam_lst_upd_dt        between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                
      AND    convert(varchar, dpam_crn_no) between convert(varchar, @pa_from_crn)  AND  convert(varchar, @pa_to_crn)                                              
      AND    dpam_deleted_ind    = 1                                              
      AND    excsm_deleted_ind   = 1                            
  AND    clid_deleted_ind    = 1                        
      AND    docm_deleted_ind    = 1                           
      AND  clid.clid_docm_doc_id = docm.docm_doc_id                            
      AND  dpam.dpam_crn_no      = clid.clid_crn_no                            
      AND  docm.docm_cd      IN('PASS_IDN','PAN_IDN','DRIV_IDN','VOTE_IDN','PASS_ADD','DRIV_ADD','RATI_ADD','VOTE_ADD','MEMO_COR','BOAR_COR','FORM_COR','BOAS_COR','PHOT_OTH','SIGN_OTH','STAM_OTH')                                                          
  
    END              
    else            
    begin            
    INSERT INTO client_checklist_cdsl                                            
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
           , CASE when docm.docm_cd = 'PASS_IDN' then 'A02'                        
      when docm.docm_cd = 'PAN_IDN' then 'A01'                             
                  when docm.docm_cd = 'DRIV_IDN' then 'A03'                             
                  when docm.docm_cd = 'VOTE_IDN' then 'A04'                        
                  when docm.docm_cd = 'PASS_ADD' then 'B01'                         
                  when docm.docm_cd = 'DRIV_ADD' then 'B02'                        
                  when docm.docm_cd = 'RATI_ADD' then 'B03'                        
                  when docm.docm_cd = 'VOTE_ADD' then 'B04'                        
                  when docm.docm_cd = 'MEMO_COR' then 'C03'                        
                  when docm.docm_cd = 'BOAR_COR' then 'C01'                        
                  when docm.docm_cd = 'FORM_COR' then 'C04'                        
                  when docm.docm_cd = 'BOAS_COR' then 'C02'            
                  when docm.docm_cd = 'PHOT_OTH' then 'D01'                        
                  when docm.docm_cd = 'SIGN_OTH' then 'D02'                        
                  when docm.docm_cd = 'STAM_OTH' then 'D03'                        
                  ELSE ''                        
              END                         
           , convert(char(8), dpam_created_by)                                              
           , replace(convert(varchar(11), dpam_created_dt,111),'-','')--replace(convert(varchar, dpam_created_dt,111),'/','')                                              
           , CASE WHEN dpam.dpam_created_dt = dpam.dpam_lst_upd_dt THEN 'I' ELSE 'U' END modified                                              
           , 0                                              
      FROM   dp_acct_mstr          dpam  WITH (NOLOCK)                                              
           , exch_seg_mstr         excsm WITH (NOLOCK)                                              
           , client_documents       clid                            
           , document_mstr          docm                            
      WHERE  excsm.excsm_id       = dpam_excsm_id                                              
      AND    excsm.excsm_exch_cd  = 'CDSL'                                              
      --AND    dpam_lst_upd_dt        between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                
      AND    convert(varchar, dpam_crn_no) between convert(varchar, @pa_from_crn)  AND  convert(varchar, @pa_to_crn)                                              
      AND    dpam_deleted_ind    = 1                                              
      AND    excsm_deleted_ind   = 1                            
      AND    clid_deleted_ind    = 1                        
      AND    docm_deleted_ind    = 1                           
      AND  clid.clid_docm_doc_id = docm.docm_doc_id                            
      AND  dpam.dpam_crn_no      = clid.clid_crn_no                            
      AND  docm.docm_cd      IN('PASS_IDN','PAN_IDN','DRIV_IDN','VOTE_IDN','PASS_ADD','DRIV_ADD','RATI_ADD','VOTE_ADD','MEMO_COR','BOAR_COR','FORM_COR','BOAS_COR','PHOT_OTH','SIGN_OTH','STAM_OTH')                                                          
  
      --            
      end            
      end                                                  
    --                                            
  --              
  --END                                            
  --                                            
  --IF @pa_tab = 'UM'                                            
  --BEGIN--UM                                            
  --                                            
    IF EXISTS (SELECT TOP 1 * FROM user_mstr_cdsl WITH (NOLOCK))                                            
    BEGIN                                            
    --                                            
      INSERT INTO user_mstr_cdsl_hst                                             
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
       FROM  user_mstr_cdsl                                          
       WHERE um_cmpltd = 1                                            
       --                                            
       DELETE FROM user_mstr_cdsl                                            
       WHERE  um_cmpltd = 1                                            
    --                                            
    END                                            
    --                                            
    INSERT INTO user_mstr_cdsl                                             
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
    ,um_lastresetday                                               ,um_Locked                                              
    ,um_loginaccessgroup                                             
    ,um_poaforpayin                                            
    ,um_edittype                                            
    ,um_cmpltd                                            
   )                                            
   --                                            
   SELECT convert(varchar(8),logn_name)                                            
        , convert(varchar(8), logn_pswd)                                            
        , logn_enttm_id             
        , logn_short_name                                            
        , '' --???                                            
        , '' --???                                            
        , '' --???                                     
        , '' --???                               
        , '' --???                                            
        , '' --???                                            
        , '' --???                                            
        , '' --???                                            
        , '' --???                                            
        , convert(varchar(8), logn_from_dt, 3)                                            
        , convert(varchar(8), logn_to_dt, 3)                                            
        , logn_status                                            
        , logn_created_by                                            
        , convert(varchar(8), logn_created_dt, 3)                                            
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
    FROM  login_names WITH (NOLOCK)                                    
    WHERE logn_lst_upd_dt between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                             
  --                                 
  --END--UM                                            
  --                                               
  --IF @pa_tab = 'BM'                                            
  --BEGIN--BM                                            
  --                                            
    CREATE TABLE #entity_properties2                                            
    (pk        numeric                                             
    ,code      varchar(25)                                            
    ,value     varchar(50)                                            
    )                                            
    ---                                 
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
          , @l_bm_email           varchar(75)              , @l_bm_allow           char(1)                                            
          , @l_bm_batchno         numeric                                            
          , @l_bm_ip_add          varchar(15)                                            
          , @l_bm_dialup          varchar(15)                                            
          , @l_bm_server          varchar(30)                                            
          , @l_bm_database        varchar(20)                                          
          , @l_bm_dbo             varchar(15)                                            
          , @l_bm_user            varchar(15)                                            
          , @l_bm_pwd             varchar(15)                                            
          , @l_bm_workarea        varchar(150)                                            
          , @l_mkrid1             char(8)                                            
          , @l_mkrdt1             varchar(8)                                             
          , @l_bm_percentage      numeric                                            
          , @l_bm_flag            varchar(2)                                            
          , @l_bm_type            char(1)                                            
          , @c_entm_id  numeric                                            
          , @c_entm_name1         varchar(50)                                            
          , @c_entm_short_name    varchar(50)                                            
          , @c_entm_created_by    varchar(20)                                       
          , @c_entm_created_dt    varchar(8)                                            
          , @c_entm_modified      char(1)                                            
          , @c_cursor_bm          cursor                                             
    --                                            
    IF EXISTS(SELECT TOP 1 * FROM branch_mstr_cdsl WITH (NOLOCK))                                            
    BEGIN                                            
    --                                       
      INSERT INTO branch_mstr_cdsl_hst                                            
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
      ,bm_server                                                      
      ,bm_database                                                    
      ,bm_dbo                               
      ,bm_user                                    
      ,bm_pwd                                                         
      ,bm_workarea                                                    
      ,mkrid1                                                        
      ,mkrdt1                                
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
           , mkrid1                                                          
           , mkrdt1                                                          
           , bm_percentage                                                  
           , bm_flag                                           
           , bm_type                                               
        , bm_edittype                                                    
           , 1                                                      
      FROM   branch_mstr_cdsl WITH (NOLOCK)                                            
      WHERE  bm_cmpltd  = 1                                            
      --                                            
      DELETE FROM branch_mstr_cdsl                                            
      WHERE  bm_cmpltd = 1                                            
    --                                            
    END                                            
    --                                            
                                                
    CREATE TABLE #entm                                            
    (entm_id           numeric                                            
    ,entm_name1      varchar(6)                                            
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
           , convert(varchar(8),entm_created_dt,3)                                            
   , CASE WHEN entm_created_dt = entm_lst_upd_dt THEN 'I' ELSE 'U' END                                             
      FROM   entity_mstr                 WITH (NOLOCK)                                            
      WHERE  entm_enttm_cd             = 'BR'                                 
      AND    entm_lst_upd_dt              between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                                             
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
           , convert(varchar(8),entm_created_dt,3)                                            
           , CASE WHEN entm_created_dt = entm_lst_upd_dt THEN 'I' ELSE 'U' END                                            
      FROM   entity_mstr  WITH (NOLOCK)                                            
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
    AND  entp_deleted_ind       = 1                          
    --                                            
    INSERT INTO #addr                                            
    (pk                                            
    ,code                                            
    ,add1                                            
    ,add2                                            
    ,add3                                            
    ,city                                            
    ,state                                             
    ,country                                             
    ,pin                                               
    )                                            
    --                                            
    SELECT entac.entac_ent_id                                            
         , entac.entac_concm_cd                                                 
         , convert(varchar(36),adr.adr_1)                                            
         , convert(varchar(36),adr.adr_2)                                            
         , convert(varchar(36),adr.adr_3)                                            
         , convert(varchar(36),isnull(adr.adr_city,''))                                       
         , ''                                            
         , ''                                            
         , convert(varchar(6),adr.adr_zip)                                            
    FROM   addresses                 adr     WITH (NOLOCK)                                            
         , entity_adr_conc           entac   WITH (NOLOCK)                                            
    WHERE  entac.entac_adr_conc_id = adr.adr_id                                            
    AND    entac.entac_ent_id     IN (SELECT entm_id FROM #entm)                            
    AND    adr.adr_deleted_ind     = 1                                            
    AND    entac.entac_deleted_ind = 1                                            
    --                                            
    INSERT INTO #conc                                        (pk                                            
    ,code                         
    ,value                                              
    )                                            
    SELECT entac.entac_ent_id                                            
         , entac.entac_concm_cd                                            
         , convert(varchar(75), conc.conc_value)                                            
    FROM   contact_channels          conc  WITH (NOLOCK)                                            
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
           , @l_bm_city          = city                                            
           , @l_bm_pin     = pin                                            
      FROM   #addr                                            
      WHERE  pk                  = @c_entm_id                                            
      AND    code                = 'OFF_ADR1'                                            
      --                                            
      SELECT @l_bm_phone         = convert(varchar(24),value) FROM #conc WHERE code = 'PHONE1' AND pk = @c_entm_id                                            
      --                                            
      SELECT @l_bm_fax           = convert(varchar(15),value) FROM #conc WHERE code = 'FAX1' AND pk = @c_entm_id                                            
      --                                            
   SELECT @l_bm_email         = convert(varchar(75),value) FROM #conc WHERE code = 'EMAIL1' AND pk = @c_entm_id                                            
      --                                      SELECT @l_bm_allow         = ''                                            
      SELECT @l_bm_batchno       = 0                                            
      SELECT @l_bm_ip_add = ''                                            
      SELECT @l_bm_dialup        = ''                                            
      SELECT @l_bm_server        = ''                                            
      SELECT @l_bm_database      = ''                            
      SELECT @l_bm_dbo           = ''                                            
      SELECT @l_bm_user          = ''                                            
   SELECT @l_bm_pwd           = ''                                            
      SELECT @l_bm_workarea      = ''                                            
      SELECT @l_mkrid1           = convert(char(8),@c_entm_created_by)                                                 
      SELECT @l_mkrdt1           = @c_entm_created_dt                                              
      SELECT @l_bm_percentage    = 0                                            
      SELECT @l_bm_flag          = ''                                            
      SELECT @l_bm_type          = 'B'                                            
      --                                            
                                                  
                                                  
      INSERT INTO branch_mstr_cdsl VALUES                                            
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
  Exec Pr_dp_mig_cdsl_cli_addr   @pa_from_dt                                  
                                ,@pa_to_dt                                    
                                ,@pa_from_crn                                 
                                ,@pa_to_crn                                   
                                ,@pa_tab                                      
                                ,@pa_error                                    
--                                            
END

GO
