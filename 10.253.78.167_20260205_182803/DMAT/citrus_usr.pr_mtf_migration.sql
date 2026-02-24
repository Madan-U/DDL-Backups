-- Object: PROCEDURE citrus_usr.pr_mtf_migration
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_mtf_migration](@pa_from_dt       varchar(10)              
                                ,@pa_to_dt         varchar(10)               
                                ,@pa_from_crn      varchar(25)    
                                ,@pa_to_crn        varchar(25)              
                                ,@pa_login         varchar(25)              
                                ,@pa_error         varchar(8000) output              
                                )              
AS              
BEGIN              
--    
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED              
  --              
  SET NOCOUNT ON              
  --    
  DECLARE @l_client_code                varchar(25)    
        , @l_brok_code                  int    
        , @l_clientname                 varchar(50)    
        , @l_client_fname               varchar(50)    
        , @l_client_sname               varchar(50)    
        , @l_client_tname               varchar(50)    
        , @l_address1                   varchar(250)    
        , @l_address2                   varchar(50)    
        , @l_address3                   varchar(50)    
        , @l_city                       varchar(50)    
        , @l_state                      varchar(50)    
        , @l_pin                        varchar(8)    
        , @l_country                    varchar(50)    
        , @l_occupation_code            int    
        , @l_status_code                int    
        , @l_res_tel                    varchar(20)    
        , @l_fax                        varchar(20)    
        , @l_bank_name                  varchar(50)    
        , @l_bank_branch                varchar(50)    
        , @l_bank_ac_no                 varchar(50)    
        , @l_bank_ac_type               varchar(50)    
        , @l_nominee                    varchar(50)    
        , @l_date_of_birth              varchar(10)    
        , @l_placeofbirth               varchar(50)    
        , @l_name_of_father             varchar(50)    
        , @l_bankname                   varchar(50)    
        , @l_branch                     varchar(50)    
        , @l_accountno                  varchar(50)    
        , @l_accounttype                varchar(50)    
        , @l_pan_no                     varchar(50)    
        , @l_girno                      varchar(50)    
        , @l_ward                       varchar(50)    
        , @l_nriadd1                    varchar(255)    
        , @l_nriadd2                    varchar(50)    
        , @l_nriadd3                    varchar(50)    
        , @l_nriadd4                    varchar(50)    
        , @l_nricountry                 varchar(50)    
        , @l_ecsno                      varchar(10)    
        , @l_nomname                    varchar(50)    
        , @l_nomguardname               varchar(50)    
        , @l_nomadd1                    varchar(50)    
        , @l_nomadd2                    varchar(50)    
        , @l_nomadd3                    varchar(50)    
        , @l_nomcity                    varchar(50)    
        , @l_nompin                     varchar(10)    
        , @l_nomstate                   varchar(50)    
        , @l_nomcountry                 varchar(50)    
        , @l_contact_person             varchar(100)    
        , @l_mobile_no                  char(10)    
        , @l_backofficecode             varchar(50)    
        , @l_initial_cor                numeric    
        , @l_porttype                   char(50)    
        , @l_maintainacc                char(1)    
        , @l_commencedate               varchar(10)    
        , @l_flag                       char(1)    
        , @l_fam_code                   numeric    
        , @l_equity                     numeric    
        , @l_mf                         numeric    
        , @l_debt                       numeric    
        , @l_clntrepemail               varchar(255)    
        , @l_clntrepfax                 varchar(10)    
        , @l_clntrepmail    char(1)    
        , @l_clntrephand                char(1)    
        , @l_alrtemail                  varchar(255)    
        , @l_alrtfax                    varchar(10)    
        , @l_alrtmobile                 varchar(10)    
        , @l_ourcode                    varchar(25)    
        , @l_dataset                    varchar(20)    
        , @l_active                     char(1)    
        , @l_activedate                 varchar(10)    
        , @l_salutation                 varchar(50)    
        , @l_send_email_on_deactivation char(1)    
        , @l_send_email_on_freeze       char(1)    
        , @l_send_email_on_closure      char(1)    
        , @l_send_email_on_corpaction   char(1)    
        , @l_schemecode                 numeric    
        , @l_modelportfolio             numeric    
        , @l_rmcode                     numeric    
        , @l_feescode                   numeric    
        , @l_ctpersondecision           varchar(50)    
        , @l_ctpersondtelno             varchar(50)    
        , @l_ctpersondfaxno             varchar(50)    
        , @l_ctpersonoperation          varchar(50)    
        , @l_ctpersonotelno             varchar(50)    
        , @l_ctpersonofaxno             varchar(50)    
        , @l_ctpersonoadd1              varchar(200)    
        , @l_ctpersonoadd2              varchar(200)    
        , @l_ctpersonoadd3              varchar(200)    
        , @l_ctpersonocity              varchar(50)    
        , @l_ctpersonopin               varchar(50)    
        , @l_jointhold1                 varchar(50)    
        , @l_jointhold2                 varchar(50)    
        , @l_jointhold1btdate           varchar(50)    
        , @l_jointhold2btdate           varchar(50)    
        , @l_branchid                   varchar(50)    
        , @l_groupid                    varchar(50)    
        , @l_clientgroup                varchar(50)    
        , @l_clientlocation             varchar(50)    
        , @l_dealer                     varchar(50)    
        , @l_clientadd1                 varchar(150)    
        , @l_clientadd2                 varchar(50)    
        , @l_clientadd3                 varchar(50)    
        , @l_clientpermenantadd1        varchar(150)    
        , @l_clientpermenantadd2        varchar(50)    
        , @l_clientpermenantadd3        varchar(50)    
        , @l_clientpermenantcity        varchar(50)    
        , @l_clientpermenantpin         varchar(7)    
        , @l_email                      varchar(255)    
        , @l_defaultbankac              numeric    
        , @l_alrtemail2                 varchar(255)    
        , @l_renewedon                  varchar(10)    
        , @l_defaultmailaddress         char(1)    
        , @l_backofficecodemf           varchar(50)    
        , @l_backofficecodedebt         varchar(50)    
        , @l_backofficecodeequity       varchar(50)    
        , @l_offadd                     char(250)    
        , @l_offcountry                 char(25)    
        , @l_offpin                     char(10)    
        , @l_offcity                    char(25)    
        , @l_offstate                   char(25)    
        , @l_off_tel                    char(20)    
        , @l_offfax                     char(20)    
        , @l_offmobile                  char(15)    
        , @l_orderaccepted              char(1)    
        , @l_assetallocationcode        numeric    
        , @l_branchcode                 numeric    
        , @l_mainclientcode             numeric    
        , @l_opstockdp                  char(1)    
        , @l_clientrbicode              varchar(50)    
        , @l_grade                      char(1)    
        , @l_portfolioreview            int    
        , @l_familyhead                 tinyint    
        , @l_rcountrycode               numeric    
        , @l_ncountrycode               numeric    
        , @l_locationcode               numeric    
        , @l_internalclient             tinyint    
        , @l_mfmodelport         numeric    
        , @l_reversalentryequity        tinyint    
        , @l_importavgtrades            tinyint    
        , @l_updatedonweb               varchar(10)    
        , @l_importedfromcrm            tinyint    
        , @l_poolaccount                tinyint    
        , @l_renewperiod                numeric    
        , @l_usr_clientid               char(20)    
        , @l_categorycode               numeric    
        , @l_gpcgrmcode                 numeric    
        , @l_mapincode                  varchar(20)    
        , @l_nbfcclient                 tinyint    
        , @l_hold1                      varchar(150)    
        , @l_holder1_code               numeric    
        , @l_holder2_code               numeric    
        , @l_holder3_code               numeric    
        , @l_opendate                   varchar(10)    
        , @l_remarks                    varchar(500)    
        , @l_cacode                     numeric    
        , @l_cafax                      varchar(25)    
        , @l_catel                      varchar(25)    
        , @l_dpid                       varchar(15)    
        , @l_fathername                 varchar(50)    
        , @l_guardianname               varchar(100)    
        , @l_introducercode             numeric    
        , @l_nonrepatapprovaldate       varchar(10)    
        , @l_nonrepatapprovalno         varchar(50)    
        , @l_nrpatvaliddate             varchar(10)    
        , @l_relationship               varchar(25)    
        , @l_repatapprovaldate          varchar(10)    
        , @l_repatapprovalno            varchar(50)    
        , @l_rpatvaliddate              varchar(10)    
        , @l_tan_no                     varchar(50)    
        , @l_fundinglimit               numeric    
        , @l_statecode                  numeric    
        , @l_stateoffcode               numeric    
        , @l_prodcat                    char(10)    
        , @l_aggno                      char(20)    
        , @l_acctrendt                  varchar(10)    
        , @l_acctexpdt                  varchar(10)    
        , @l_lgracctno                  char(15)    
        , @l_recmodtmstp                varchar(10)    
        , @l_acctclsdt                  varchar(10)    
        , @l_accountfor                 char(1)    
        , @l_iaf                        tinyint    
        , @l_las                        tinyint    
        , @l_mtf                        tinyint    
        , @l_pasaccountno               varchar(50)    
        , @l_existsinpas                char(1)    
        , @l_pasclientcode              numeric    
        , @l_clientaccttype             char(1)    
        , @l_jointpan1                  varchar(50)    
        , @l_jointpan2                  varchar(50)    
        , @l_jointmapin1                varchar(50)    
        , @l_jointmapin2                varchar(50)    
        , @l_businessunitsid            char(6)    
        , @l_createdby                  varchar(50)    
        , @l_createddate                varchar(10)    
        , @l_updatedby                  varchar(50)    
        , @l_updateddate                varchar(10)    
        , @l_poolaccountcode            numeric    
        , @l_deactivatedate             varchar(10)    
        , @l_closedate                  varchar(10)    
        , @l_activatedate               varchar(10)    
        , @l_accountlimit               numeric    
        , @l_limitconservativeliberal   char(1)    
        , @l_paymode                    varchar(50)    
        , @l_pas2clientcode             numeric    
        , @l_edittype                   char(1)     
        , @c_client_mstr                cursor        
        , @l_crn_no                     numeric       
        , @l_sba_no                     varchar(25)     
        , @l_excpm_id                   numeric    
  --    
  CREATE TABLE #clim              
  (crn_no         numeric              
  ,sba_no         varchar(25)               
  ,client_code    varchar(25)              
  )              
  --              
  IF ISNULL(@pa_from_dt,'') <> '' AND ISNULL(@pa_from_dt,'') <> '' AND isnull(@pa_from_crn,'') <> ''  AND  isnull(@pa_to_crn,'') <> ''            
  BEGIN--1            
  --      
      
    INSERT INTO #clim              
    (crn_no              
    ,sba_no              
    ,client_code              
    )              
    --    
    SELECT clisba.clisba_crn_no        crn_no              
         , clisba.clisba_no clisba    
         , clia.clia_acct_no           acct_no    
    FROM   client_accounts             clia   WITH (NOLOCK)           
        ,  client_sub_accts            clisba WITH (NOLOCK)                       
    WHERE  clisba.clisba_lst_upd_dt    BETWEEN convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                
    AND    clisba.clisba_crn_no        BETWEEN convert(numeric, @pa_from_crn)  and convert(numeric, @pa_to_crn)    
    AND    clia.clia_crn_no          = clisba.clisba_crn_no              
    AND    clia.clia_deleted_ind     = 1              
    AND    clisba.clisba_deleted_ind = 1    
    ORDER BY clisba.clisba_crn_no, clisba.clisba_no     
  --            
  END--1            
  --            
  IF ISNULL(@pa_from_dt,'') = '' AND ISNULL(@pa_from_dt,'') = '' AND isnull(@pa_from_crn,'') <> ''  AND  isnull(@pa_to_crn,'') <> ''            
  BEGIN--2            
  --            
    INSERT INTO #clim              
    (crn_no              
    ,sba_no              
    ,client_code              
    )              
    --    
    SELECT clisba.clisba_crn_no        crn_no              
         , clisba.clisba_no            clisba    
         , clia.clia_acct_no           acct_no    
    FROM   client_accounts             clia    WITH (NOLOCK)                    
        ,  client_sub_accts            clisba  WITH (NOLOCK)                      
    WHERE  clisba.clisba_crn_no        BETWEEN convert(numeric, @pa_from_crn)  and convert(numeric, @pa_to_crn)    
    AND    clia.clia_crn_no          = clisba.clisba_crn_no              
    AND    clia.clia_deleted_ind     = 1              
    AND    clisba.clisba_deleted_ind = 1    
    ORDER BY clisba.clisba_crn_no, clisba.clisba_no     
  --            
  END--2            
  --    
  IF ISNULL(@pa_from_dt,'') <> '' AND ISNULL(@pa_from_dt,'') <> '' AND isnull(@pa_from_crn,'') = ''  AND  isnull(@pa_to_crn,'') = ''            
  BEGIN--3            
  --            
    INSERT INTO #clim              
    (crn_no              
    ,sba_no              
    ,client_code              
    )              
    --    
    SELECT clisba.clisba_crn_no        crn_no              
         , clisba.clisba_no            clisba    
         , clia.clia_acct_no           acct_no    
    FROM   client_accounts             clia    WITH (NOLOCK)                    
        ,  client_sub_accts            clisba  WITH (NOLOCK)                      
    WHERE  clisba.clisba_lst_upd_dt    BETWEEN convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'                
    AND    clia.clia_crn_no          = clisba.clisba_crn_no              
    AND    clia.clia_deleted_ind     = 1              
    AND    clisba.clisba_deleted_ind = 1    
    ORDER BY clisba.clisba_crn_no, clisba.clisba_no     
  --            
  END--3         
  --    
  IF ISNULL(@pa_from_dt,'') = '' AND ISNULL(@pa_from_dt,'') = '' AND isnull(@pa_from_crn,'') = ''  AND  isnull(@pa_to_crn,'') = ''            
  BEGIN--4            
  --            
    INSERT INTO #clim              
    (crn_no              
    ,sba_no              
    ,client_code              
    )              
    --    
    SELECT clisba.clisba_crn_no        crn_no              
         , clisba.clisba_no            clisba    
         , clia.clia_acct_no           acct_no    
    FROM   client_accounts             clia    WITH (NOLOCK)                     
        ,  client_sub_accts            clisba  WITH (NOLOCK)                     
    WHERE  clia.clia_crn_no          = clisba.clisba_crn_no              
    AND    clia.clia_deleted_ind     = 1              
    AND    clisba.clisba_deleted_ind = 1    
    ORDER BY clisba.clisba_crn_no, clisba.clisba_no     
  --            
  END--4         
  --entity_properties--              
  CREATE table #entity_properties              
  (id      numeric                 
  ,code    varchar(25)              
  ,value   varchar(50)              
  )              
    
  --entity_properties_dtls--                
  CREATE TABLE #entity_property_dtls              
  (id     numeric              
  ,code1  varchar(25)              
  ,code2  varchar(25)              
  ,value  varchar(50)              
  )              
    
  --contacts--              
  CREATE TABLE #conc(id       numeric               
                    ,code     varchar(25)              
                    ,value    varchar(50)                  
          )              
  --addresses--              
  CREATE TABLE #addr(id       numeric              
                    ,code     varchar(25)              
                    ,add1     varchar(36)              
                    ,add2     varchar(36)              
                    ,add3     varchar(36)              
                    ,city     varchar(36)              
                    ,state    varchar(36)              
                    ,country  varchar(36)              
                    ,pin      varchar(7)               
                    )              
    
  --*****************--              
    
  --#entity_properties              
  INSERT INTO #entity_properties              
  (id              
  ,code              
  ,value              
  )              
  SELECT entp_ent_id              
        ,entp_entpm_cd              
        ,entp_value               
  FROM   entity_properties   WITH (NOLOCK)                           
  WHERE  entp_ent_id           IN (SELECT distinct crn_no FROM #clim) --= @pa_crn_no              
  AND    entp_deleted_ind      = 1              
    
  --#entity_property_dtls              
  INSERT INTO #entity_property_dtls              
  (id              
  ,code1              
  ,code2              
  ,value              
  )              
  SELECT a.entp_ent_id              
       , a.entp_entpm_cd              
       , b.entpd_entdm_cd              
       , b.entpd_value               
  FROM   entity_properties      a  WITH (NOLOCK)              
      ,  entity_property_dtls   b  WITH (NOLOCK)              
  WHERE  a.entp_ent_id       IN (SELECT distinct crn_no FROM #clim)               
  AND    a.entp_id            = b.entpd_entp_id              
  AND    a.entp_deleted_ind   = 1              
  AND    b.entpd_deleted_ind  = 1              
    
  --contacts              
  INSERT INTO #conc              
  (id              
  ,code              
  ,value                
  )              
  SELECT entac.entac_ent_id              
       , convert(varchar(25), entac.entac_concm_cd)              
       , convert(varchar(50), conc.conc_value)              
  FROM   contact_channels          conc    WITH (NOLOCK)              
       , entity_adr_conc           entac   WITH (NOLOCK)               
  WHERE  entac.entac_adr_conc_id = conc.conc_id              
  AND    entac.entac_ent_id     IN (SELECT distinct crn_no FROM #clim)              
  AND    conc.conc_deleted_ind   = 1              
  AND    entac.entac_deleted_ind = 1              
    
  --addresses              
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
       , convert(varchar(25), entac.entac_concm_cd)                   
       , convert(varchar(36), adr.adr_1)              
       , convert(varchar(36), adr.adr_2)              
       , convert(varchar(36), adr.adr_3)              
       , convert(varchar(36), adr.adr_city)              
       , convert(varchar(36), adr.adr_state)              
       , convert(varchar(36), adr.adr_country)              
       , isnull(adr.adr_zip,0)              
  FROM   addresses                 adr     WITH (NOLOCK)              
       , entity_adr_conc           entac   WITH (NOLOCK)              
  WHERE  entac.entac_adr_conc_id = adr.adr_id              
  AND    entac.entac_ent_id     IN (SELECT DISTINCT crn_no FROM #clim) --= @pa_crn_no              
  AND    adr.adr_deleted_ind     = 1              
  AND    entac.entac_deleted_ind = 1              
  --    
      
  IF EXISTS(SELECT client_code FROM MTF_MIG WITH (NOLOCK))    
  BEGIN--#    
  --    
    INSERT INTO MTF_MIG_HST    
    (client_code                  
    , brok_code                    
    , clientname                   
    , client_fname                 
    , client_sname                 
    , client_tname                 
    , address1                     
    , address2                     
    , address3                     
    , city                         
    , state                        
    , pin                          
    , country                      
    , occupation_code              
    , status_code                  
    , res_tel                      
    , fax                          
    , bank_name                    
    , bank_branch                  
    , bank_ac_no                   
    , bank_ac_type                 
    , nominee                      
    , date_of_birth                
    , placeofbirth                 
    , name_of_father               
    , bankname                     
    , branch                       
    , accountno                    
    , accounttype                  
    , pan_no                       
    , girno                        
    , ward                         
    , nriadd1                      
    , nriadd2                      
    , nriadd3                      
    , nriadd4                      
    , nricountry                   
    , ecsno                        
    , nomname                      
    , nomguardname                 
    , nomadd1                      
    , nomadd2                      
    , nomadd3                      
    , nomcity                      
    , nompin                       
    , nomstate                     
    , nomcountry                   
    , contact_person               
    , mobile_no                    
    , backofficecode               
    , initial_cor                  
    , porttype                     
    , maintainacc                  
    , commencedate                 
    , flag                         
    , fam_code                     
    , equity                       
    , mf                           
    , debt                         
    , clntrepemail                 
    , clntrepfax                   
    , clntrepmail                  
    , clntrephand                  
    , alrtemail                    
    , alrtfax                      
    , alrtmobile                   
    , ourcode                      
    , dataset                      
    , active                       
    , activedate                   
    , salutation                   
    , send_email_on_deactivation    
    , send_email_on_freeze         
    , send_email_on_closure        
    , send_email_on_corpaction     
    , schemecode                   
    , modelportfolio               
    , rmcode                       
    , feescode                     
    , ctpersondecision             
    , ctpersondtelno               
    , ctpersondfaxno               
    , ctpersonoperation            
    , ctpersonotelno               
    , ctpersonofaxno               
    , ctpersonoadd1                
    , ctpersonoadd2                
    , ctpersonoadd3                
    , ctpersonocity                
    , ctpersonopin                 
    , jointhold1                   
    , jointhold2                   
    , jointhold1btdate             
    , jointhold2btdate             
    , branchid                     
    , groupid                      
    , clientgroup                  
    , clientlocation               
    , dealer                       
    , clientadd1                   
    , clientadd2                   
    , clientadd3                   
    , clientpermenantadd1          
    , clientpermenantadd2          
    , clientpermenantadd3          
    , clientpermenantcity          
    , clientpermenantpin           
    , email                        
    , defaultbankac                
    , alrtemail2                   
    , renewedon                    
    , defaultmailaddress           
    , backofficecodemf             
    , backofficecodedebt           
    , backofficecodeequity         
    , offadd                       
    , offcountry                   
    , offpin                       
    , offcity                      
    , offstate                     
    , off_tel                      
    , offfax                       
    , offmobile                    
    , orderaccepted                
    , assetallocationcode          
    , branchcode                   
    , mainclientcode               
    , opstockdp                    
    , clientrbicode                
    , grade                        
    , portfolioreview              
    , familyhead                   
    , rcountrycode                 
    , ncountrycode                 
    , locationcode                 
    , internalclient               
    , mfmodelport                  
    , reversalentryequity          
    , importavgtrades              
    , updatedonweb                 
    , importedfromcrm              
    , poolaccount                  
    , renewperiod                  
    , usr_clientid                 
    , categorycode                 
    , gpcgrmcode                   
    , mapincode                    
    , nbfcclient                   
    , hold1                        
    , holder1_code                 
    , holder2_code                 
    , holder3_code                 
    , opendate                     
    , remarks                      
    , cacode                       
    , cafax                        
    , catel                        
    , dpid                         
    , fathername                   
    , guardianname                 
    , introducercode               
    , nonrepatapprovaldate         
    , nonrepatapprovalno           
    , nrpatvaliddate               
    , relationship                 
    , repatapprovaldate            
    , repatapprovalno              
    , rpatvaliddate                
    , tan_no                       
    , fundinglimit                 
    , statecode                    
    , stateoffcode                 
    , prodcat                      
    , aggno                        
    , acctrendt                    
    , acctexpdt                    
    , lgracctno                    
    , recmodtmstp                  
    , acctclsdt                    
    , accountfor                   
    , iaf                          
    , las                          
    , mtf                          
    , pasaccountno                 
    , existsinpas                  
    , pasclientcode                
    , clientaccttype               
    , jointpan1                    
    , jointpan2                    
    , jointmapin1                  
    , jointmapin2                  
    , businessunitsid              
    , createdby                    
    , createddate                  
    , updatedby                    
    , updateddate    
    , poolaccountcode              
    , deactivatedate               
    , closedate                    
    , activatedate                 
    , accountlimit                 
    , limitconservativeliberal     
    , paymode                      
    , pas2clientcode               
    , comltd                       
    , edittype         
    )    
    SELECT client_code         
         , brok_code                    
         , clientname                   
         , client_fname                 
         , client_sname                 
         , client_tname                 
         , address1                     
         , address2                     
         , address3                     
         , city                         
         , state                        
         , pin                          
         , country                      
         , occupation_code              
         , status_code                  
         , res_tel                      
         , fax                          
         , bank_name                    
         , bank_branch                  
         , bank_ac_no                   
         , bank_ac_type                 
         , nominee                      
         , date_of_birth                
         , placeofbirth                 
         , name_of_father               
         , bankname                     
         , branch                       
         , accountno                    
         , accounttype                  
         , pan_no                       
         , girno                        
         , ward                         
         , nriadd1                      
         , nriadd2                      
         , nriadd3                      
         , nriadd4                      
         , nricountry                   
         , ecsno                        
         , nomname                      
         , nomguardname                 
         , nomadd1                      
         , nomadd2                      
         , nomadd3                      
         , nomcity                      
         , nompin                      
         , nomstate                     
         , nomcountry                   
         , contact_person               
         , mobile_no                    
         , backofficecode               
         , initial_cor                  
         , porttype                     
         , maintainacc                  
         , commencedate                 
         , flag                         
         , fam_code                     
         , equity                       
         , mf                           
         , debt                         
         , clntrepemail                 
         , clntrepfax                   
         , clntrepmail                  
         , clntrephand                  
         , alrtemail                    
         , alrtfax                      
         , alrtmobile                   
         , ourcode                      
         , dataset                      
         , active                       
         , activedate                   
         , salutation                   
         , send_email_on_deactivation    
         , send_email_on_freeze         
         , send_email_on_closure        
         , send_email_on_corpaction     
         , schemecode                   
         , modelportfolio               
         , rmcode                       
         , feescode                     
         , ctpersondecision             
         , ctpersondtelno               
         , ctpersondfaxno               
         , ctpersonoperation            
         , ctpersonotelno               
         , ctpersonofaxno               
         , ctpersonoadd1                
         , ctpersonoadd2                
         , ctpersonoadd3                
         , ctpersonocity                
         , ctpersonopin                 
         , jointhold1                   
         , jointhold2                   
         , jointhold1btdate             
         , jointhold2btdate             
         , branchid                     
         , groupid                      
         , clientgroup                  
         , clientlocation               
         , dealer                       
         , clientadd1                   
         , clientadd2         
         , clientadd3                   
         , clientpermenantadd1          
         , clientpermenantadd2          
         , clientpermenantadd3          
         , clientpermenantcity          
         , clientpermenantpin           
         , email                        
         , defaultbankac                
         , alrtemail2                   
         , renewedon                    
         , defaultmailaddress           
         , backofficecodemf             
         , backofficecodedebt           
         , backofficecodeequity         
         , offadd                       
         , offcountry                   
         , offpin                       
         , offcity                      
         , offstate                     
         , off_tel                      
         , offfax                       
         , offmobile                    
         , orderaccepted                
         , assetallocationcode          
         , branchcode                   
         , mainclientcode               
         , opstockdp                    
         , clientrbicode                
         , grade                        
         , portfolioreview              
         , familyhead                   
         , rcountrycode                 
         , ncountrycode                 
         , locationcode                 
         , internalclient               
         , mfmodelport                  
         , reversalentryequity          
         , importavgtrades              
         , updatedonweb                 
         , importedfromcrm              
         , poolaccount                  
         , renewperiod                  
         , usr_clientid                 
         , categorycode                 
         , gpcgrmcode                   
         , mapincode                    
         , nbfcclient                   
         , hold1                        
         , holder1_code             
         , holder2_code                 
         , holder3_code                 
         , opendate                     
         , remarks                      
         , cacode                       
         , cafax                        
         , catel                        
         , dpid                         
         , fathername                   
         , guardianname                 
         , introducercode               
         , nonrepatapprovaldate         
         , nonrepatapprovalno           
         , nrpatvaliddate               
         , relationship                 
         , repatapprovaldate            
         , repatapprovalno              
         , rpatvaliddate                
         , tan_no                       
         , fundinglimit                 
         , statecode                    
         , stateoffcode                 
         , prodcat                      
         , aggno                        
         , acctrendt                    
         , acctexpdt                    
         , lgracctno                    
         , recmodtmstp                  
         , acctclsdt                    
         , accountfor                   
         , iaf                          
         , las                          
         , mtf                          
         , pasaccountno                 
         , existsinpas                  
         , pasclientcode                
         , clientaccttype               
         , jointpan1                    
         , jointpan2                    
         , jointmapin1                  
         , jointmapin2                  
         , businessunitsid              
         , createdby                    
         , createddate                  
         , @pa_login                    
         , getdate()    
         , poolaccountcode              
         , deactivatedate               
         , closedate                    
         , activatedate                 
         , accountlimit                 
         , limitconservativeliberal     
         , paymode                      
         , pas2clientcode               
         , 1                       
         , edittype                     
    FROM   MTF_MIG    
    WHERE  comltd = 1    
    --    
    DELETE FROM MTF_MIG     
    WHERE comltd  = 1    
  --    
  END--#    
  --    
  SET @c_client_mstr  = CURSOR FAST_FORWARD FOR SELECT DISTINCT crn_no, convert(varchar, client_code) from #clim order by crn_no              
  --              
  OPEN @c_client_mstr              
  --              
  FETCH NEXT FROM @c_client_mstr INTO @l_crn_no, @l_client_code             
  --                  
  WHILE @@FETCH_STATUS = 0                
  BEGIN--cursor                    
  --    
    SELECT @l_brok_code            = sba_no from #clim where crn_no=@l_crn_no    
    SELECT @l_client_code          = 0
         , @l_clientname           = convert(varchar(150), isnull(clim_name1,'') +' '+ isnull(clim_name2,'') +' '+ isnull(clim_name3,''))               
         , @l_client_fname         = convert(varchar(50), clim_name1)               
         , @l_client_sname         = convert(varchar(50), clim_name2)              
         , @l_client_tname         = convert(varchar(50),clim_name3)              
         , @l_status_code          = 0     
         , @l_date_of_birth        = convert(varchar(10), clim_dob, 103)              
         , @l_updateddate          = convert(varchar(10),clim_lst_upd_dt,103)             
         , @l_updatedby            = convert(varchar(20),clim_lst_upd_by)              
         , @l_createddate          = convert(varchar(10),clim_created_dt,103)              
         , @l_createdby            = convert(varchar(20),clim_created_by)              
         , @l_edittype             = CASE WHEN clim.clim_created_dt = clim.clim_lst_upd_dt               
                                          THEN 'I' ELSE 'U' END                
    FROM   client_mstr               clim WITH (NOLOCK)              
         , client_accounts           clia WITH (NOLOCK)               
    WHERE  clim.clim_deleted_ind   = 1              
    AND    clia.clia_deleted_ind   = 1              
    AND    clim.clim_crn_no        = clia.clia_crn_no              
    AND    clim.clim_crn_no        = @l_crn_no              
    AND    clia.clia_acct_no       = @l_client_code        
    --    
    SELECT @l_address1             = convert(varchar(250), add1)              
         , @l_address2             = convert(varchar(50) , add2)              
         , @l_address3             = convert(varchar(50) , add3)              
         , @l_city                 = convert(varchar(50) , city)              
         , @l_state                = convert(varchar(50) , state)              
         , @l_pin                  = convert(varchar(8)  , pin)              
         , @l_country              = convert(varchar(50) , country)                
    FROM   #addr              
    WHERE  id                      = @l_crn_no        
    --    
    SELECT @l_occupation_code      = 0    
    SELECT @l_res_tel              = convert(varchar(20),value) FROM #conc WHERE code = 'RES_PH1' AND id = @l_crn_no               
    SELECT @l_fax                  = convert(varchar(20),value) FROM #conc WHERE code = 'FAX1' AND id = @l_crn_no              
    SELECT @l_bank_name            = ''              
    SELECT @l_bank_branch          = ''              
    SELECT @l_bank_ac_no           = ''              
    SELECT @l_bank_ac_type         = ''              
    SELECT @l_nominee              = convert(varchar(50), value) FROM #entity_properties WHERE code = 'NOMINEE' AND id = @l_crn_no              
    --    
    SELECT @l_placeofbirth         = ''              
    SELECT @l_name_of_father       = ''              
    SELECT @l_bankname             = ''              
    SELECT @l_branch               = ''              
    SELECT @l_accountno            = ''              
    SELECT @l_accounttype          = ''      
    --    
    SELECT @l_pan_no               = convert(varchar(50), value) FROM #entity_properties WHERE code = 'PAN_GIR_NO' AND id = @l_crn_no              
    SELECT @l_girno                = ''              
    SELECT @l_ward                 = convert(varchar(50), value) FROM #entity_properties WHERE code = 'WARD_NO' AND id = @l_crn_no              
    SELECT @l_nriadd1              = ''              
    SELECT @l_nriadd2              = ''              
    SELECT @l_nriadd3              = ''              
    SELECT @l_nriadd4              = ''              
    SELECT @l_nricountry           = ''              
    SELECT @l_ecsno                = ''              
    --    
    SELECT @l_nomname              = convert(varchar(50), value)  FROM #entity_properties    WHERE code  = 'NOMINEE' AND id = @l_crn_no              
    SELECT @l_nomguardname         = convert(varchar(50), value)  FROM #entity_property_dtls WHERE code2 = 'NOMINEE_GUAR_NAME' AND id = @l_crn_no              
    SELECT @l_nomadd1              = convert(varchar(50), value)  FROM #entity_property_dtls WHERE code2 = 'NOMINEE_ADR1' AND id = @l_crn_no              
    SELECT @l_nomadd2              = convert(varchar(50), value)  FROM #entity_property_dtls WHERE code2 = 'NOMINEE_ADR2' AND id = @l_crn_no               
    SELECT @l_nomadd3              = convert(varchar(50), value)  FROM #entity_property_dtls WHERE code2 = 'NOMINEE_ADR3' AND id = @l_crn_no              
    SELECT @l_nomcity              = convert(varchar(50), value)  FROM #entity_property_dtls WHERE code2 = 'NOMINEE_CITY' AND id = @l_crn_no              
    SELECT @l_nompin               = convert(varchar(10), value)  FROM #entity_property_dtls WHERE code2 = 'NOMINEE_ZIP'  AND id = @l_crn_no              
    SELECT @l_nomstate             = convert(varchar(50), value)  FROM #entity_property_dtls WHERE code2 = 'NOMINEE_STATE' AND id = @l_crn_no              
    SELECT @l_nomcountry           = convert(varchar(50), value)  FROM #entity_property_dtls WHERE code2 = 'NOMINEE_COUNTRY' AND id = @l_crn_no              
    --    
    SELECT @l_contact_person       = convert(varchar(100), value) FROM #entity_properties    WHERE code  = 'CONTACT_PERSON' AND id = @l_crn_no              
    SELECT @l_backofficecode       = convert(varchar(50), @l_client_code)              
    SELECT @l_mobile_no            = convert(varchar(10),value)   FROM #conc                 WHERE code = 'MOBILE1'         AND id = @l_crn_no              
    SELECT @l_initial_cor          = convert(numeric, value)      FROM #entity_properties    WHERE code = 'INITIAL_CORPUS' AND id = @l_crn_no              
    SELECT @l_porttype             = convert(char(50), value)     FROM #entity_properties    WHERE code = 'PORTFOLIO_TYPE' AND id = @l_crn_no              
    SELECT @l_maintainacc          = ''              
    SELECT @l_commencedate         = ''              
    SELECT @l_flag                 = 'C'              
    SELECT @l_fam_code             = 0    
    SELECT @l_equity               = 0              
    SELECT @l_mf                   = 0              
    SELECT @l_debt                 = 0     
    --    
    SELECT @l_clntrepemail         = convert(varchar(255),value)  FROM #conc WHERE code = 'EMAIL1' AND id = @l_crn_no              
    SELECT @l_clntrepfax           = convert(varchar(10),value)   FROM #conc WHERE code = 'FAX1'   AND id = @l_crn_no              
    SELECT @l_clntrepmail          = ''              
    SELECT @l_clntrephand          = 'N'              
    SELECT @l_alrtemail            = ''              
    SELECT @l_alrtfax              = ''              
    SELECT @l_alrtmobile           = ''              
    SELECT @l_ourcode              = ''              
    SELECT @l_dataset              = ''              
    SELECT @l_active               = 'N'              
    SELECT @l_activedate           = ''        
    --    
    SELECT @l_salutation           = convert(varchar(50), value) FROM #entity_properties  WHERE code  = 'SALUTATION' AND id = @l_crn_no              
    SELECT @l_send_email_on_deactivation = 'Y'              
    SELECT @l_send_email_on_freeze       = 'Y'              
    SELECT @l_send_email_on_closure      = 'Y'              
    SELECT @l_send_email_on_corpaction   = ''    
    SELECT @l_schemecode                 = 0              
    SELECT @l_modelportfolio             = 0              
    SELECT @l_rmcode                     = 0             
    SELECT @l_feescode                   = 0              
    --    
    SELECT @l_ctpersondecision           = convert(varchar(50), value)  FROM #entity_properties    WHERE code  = 'CTPERSONDECISION'  AND id = @l_crn_no              
    SELECT @l_ctpersondtelno             = convert(varchar(50), value)  FROM #entity_property_dtls WHERE code2 = 'CTPERSONTELNO'     AND id = @l_crn_no              
    SELECT @l_ctpersondfaxno             = convert(varchar(50), value)  FROM #entity_property_dtls WHERE code2 = 'CTPERSONFAXNO'     AND id = @l_crn_no              
    SELECT @l_ctpersonoperation          = convert(varchar(50), value)  FROM #entity_properties    WHERE code  = 'CTPERSONOPERATION' AND id = @l_crn_no              
    SELECT @l_ctpersonotelno             = convert(varchar(50), value)  FROM #entity_property_dtls WHERE code2 = 'CTPERSONTELNO'     AND id = @l_crn_no              
    SELECT @l_ctpersonofaxno             = convert(varchar(50), value)  FROM #entity_property_dtls WHERE code2 = 'CTPERSONFAXNO'     AND id = @l_crn_no              
    SELECT @l_ctpersonoadd1              = convert(varchar(200), value) FROM #entity_property_dtls WHERE code2 = 'CTPERSONADR1'      AND id = @l_crn_no              
    SELECT @l_ctpersonoadd2              = convert(varchar(200), value) FROM #entity_property_dtls WHERE code2 = 'CTPERSONADR2'      AND id = @l_crn_no              
    SELECT @l_ctpersonoadd3              = convert(varchar(200), value) FROM #entity_property_dtls WHERE code2 = 'CTPERSONADR3'      AND id = @l_crn_no              
    SELECT @l_ctpersonocity              = convert(varchar(50), value)  FROM #entity_property_dtls WHERE code2 = 'CTPERSONCITY'      AND id = @l_crn_no              
    SELECT @l_ctpersonopin               = convert(varchar(50), value)  FROM #entity_property_dtls WHERE code2 = 'CTPERSONNOZIP'     AND id = @l_crn_no              
    SELECT @l_jointhold1                 = ''    
    SELECT @l_jointhold2                 = ''    
    SELECT @l_jointhold1btdate           = ''    
    SELECT @l_jointhold2btdate           = ''    
    SELECT @l_branchid                   = ''              
    SELECT @l_groupid                    = ''      
    --    
    SELECT @l_clientgroup                = ''              
    SELECT @l_clientlocation             = ''              
    SELECT @l_dealer                     = ''              
    SELECT @l_clientadd1                 = ''              
    SELECT @l_clientadd2                 = ''              
    SELECT @l_clientadd3                 = ''              
    SELECT @l_clientpermenantadd1        = ''              
    SELECT @l_clientpermenantadd2        = ''              
    SELECT @l_clientpermenantadd3        = ''              
    SELECT @l_clientpermenantcity        = ''              
    SELECT @l_clientpermenantpin         = ''              
    SELECT @l_email                      = convert(varchar(255),value) FROM #conc WHERE code = 'EMAIL1' AND id = @l_crn_no              
    SELECT @l_defaultbankac              = 0       
    --    
    SELECT @l_alrtemail2                 = convert(varchar(255),value) FROM #conc WHERE code = 'EMAIL1' AND id = @l_crn_no              
    SELECT @l_renewedon                  = ''              
    SELECT @l_defaultmailaddress         = convert(char(1), value) FROM #entity_properties WHERE code = 'DEFAULTEMAIL' AND id = @l_crn_no              
    SELECT @l_backofficecodemf           = convert(varchar(50),@l_client_code)              
    SELECT @l_backofficecodedebt         = convert(varchar(50),@l_client_code)              
    SELECT @l_backofficecodeequity       = convert(varchar(50),@l_client_code)              
    --              
    SELECT @l_offadd                     = convert(char(250),isnull(add1,'')+' '+isnull(add2,'')+' '+isnull(add3,''))              
         , @l_offcountry                 = convert(char(25),country)              
         , @l_offpin                     = convert(char(10),pin)              
         , @l_offcity                    = convert(char(25),city)              
         , @l_offstate                   = convert(char(25),state)              
    FROM   #addr              
    WHERE  code                          = 'OFF_ADR1'              
    AND    id                            = @l_crn_no    
    --    
    SELECT @l_off_tel                    = convert(char(20),value) FROM #conc WHERE code = 'OFF_PH1' AND id = @l_crn_no              
    SELECT @l_offfax                     = convert(char(20),value) FROM #conc WHERE code = 'OFF_FAX1'    AND id = @l_crn_no              
    SELECT @l_offmobile                  = convert(char(15),value) FROM #conc WHERE code = 'OFF_MOBILE' AND id = @l_crn_no              
    SELECT @l_orderaccepted              = 'N'              
    SELECT @l_assetallocationcode        = 0              
    SELECT @l_branchcode                 = 0    
    SELECT @l_mainclientcode             = 0              
    SELECT @l_opstockdp                  = 'N'              
    SELECT @l_clientrbicode              = ''        
    SELECT @l_grade                      = ''              
    SELECT @l_portfolioreview            = 0              
    SELECT @l_familyhead                 = convert(tinyint, value) FROM #entity_properties WHERE code = 'FAMILY_HEAD' AND id = @l_crn_no              
    SELECT @l_rcountrycode               = 0    
    SELECT @l_ncountrycode               = 0    
    SELECT @l_locationcode               = 0    
    SELECT @l_internalclient             = 0              
    SELECT @l_mfmodelport                = 0              
    SELECT @l_reversalentryequity        = 0              
    SELECT @l_importavgtrades            = 0              
    SELECT @l_updatedonweb               = ''              
    SELECT @l_importedfromcrm            = 0              
    SELECT @l_poolaccount                = 0              
    SELECT @l_renewperiod                = 0              
    SELECT @l_usr_clientid               = ''              
    SELECT @l_categorycode               = 1              
    SELECT @l_gpcgrmcode                 = 0     
    SELECT @l_mapincode                  = convert(varchar(20), value) FROM #entity_properties WHERE code = 'MAPIN_ID' AND id = @l_crn_no              
    SELECT @l_nbfcclient                 = 1    
    SELECT @l_hold1                      = ''    
    SELECT @l_holder1_code               = 0    
    SELECT @l_holder2_code               = 0    
    SELECT @l_holder3_code               = 0    
    SELECT @l_opendate                   = ''    
    SELECT @l_remarks                    = ''    
    SELECT @l_cacode                     = 0    
    SELECT @l_cafax                      = ''    
    SELECT @l_catel                      = ''    
    SELECT @l_dpid                       = convert(varchar(15), value) FROM #entity_properties WHERE code = 'FATHERNAME' AND id = @l_crn_no              
    SELECT @l_fathername                 = convert(varchar(50), value) FROM #entity_properties WHERE code = 'GUARDIANNAME' AND id = @l_crn_no              
    SELECT @l_guardianname               = ''    
    SELECT @l_introducercode             = 0    
    SELECT @l_nonrepatapprovaldate       = ''    
    SELECT @l_nonrepatapprovalno         = ''    
    SELECT @l_nrpatvaliddate             = ''    
    SELECT @l_relationship               = ''    
    SELECT @l_repatapprovaldate          = ''    
    SELECT @l_repatapprovalno            = ''    
    SELECT @l_rpatvaliddate              = ''    
    SELECT @l_tan_no                     = ''    
    SELECT @l_fundinglimit               = 0    
    SELECT @l_statecode                  = 0    
 SELECT @l_stateoffcode               = 0    
    SELECT @l_prodcat                    = ''    
    SELECT @l_aggno                      = ''    
    SELECT @l_acctrendt                  = ''    
    SELECT @l_acctexpdt                  = ''    
    SELECT @l_lgracctno                  = ''    
    SELECT @l_recmodtmstp                = ''    
    SELECT @l_acctclsdt                  = ''    
    SELECT @l_accountfor                 = ''    
    SELECT @l_iaf                        = 0    
    SELECT @l_las                        = 0    
    SELECT @l_mtf                        = 0    
    SELECT @l_pasaccountno               = ''    
    SELECT @l_existsinpas                = ''    
    SELECT @l_pasclientcode              = 0    
    SELECT @l_clientaccttype             = ''    
    SELECT @l_jointpan1                  = ''    
    SELECT @l_jointpan2                  = ''    
    SELECT @l_jointmapin1                = ''    
    SELECT @l_jointmapin2                = ''    
    SELECT @l_businessunitsid            = ''    
    SELECT @l_poolaccountcode            = 0    
    SELECT @l_deactivatedate             = ''    
    SELECT @l_closedate                  = ''    
    SELECT @l_activatedate               = ''    
    SELECT @l_accountlimit               = 0    
    SELECT @l_limitconservativeliberal   = ''    
    SELECT @l_paymode                    = convert(varchar(50), value) FROM #entity_properties WHERE code = 'PAY_MODE' AND id = @l_crn_no              
    SELECT @l_pas2clientcode             = 0    
    --    
    INSERT INTO MTF_MIG VALUES    
    (@l_client_code                    
    ,@l_brok_code                      
    ,@l_clientname                     
    ,@l_client_fname                   
    ,@l_client_sname                   
    ,@l_client_tname                   
    ,@l_address1                       
    ,@l_address2                       
    ,@l_address3                       
    ,@l_city                           
    ,@l_state                          
    ,@l_pin                            
    ,@l_country                        
    ,@l_occupation_code                
    ,@l_status_code                    
    ,@l_res_tel                        
    ,@l_fax                            
    ,@l_bank_name                      
    ,@l_bank_branch                    
    ,@l_bank_ac_no                     
    ,@l_bank_ac_type                   
    ,@l_nominee                        
    ,@l_date_of_birth                  
    ,@l_placeofbirth                   
    ,@l_name_of_father                 
    ,@l_bankname                       
    ,@l_branch                         
    ,@l_accountno                      
    ,@l_accounttype                    
    ,@l_pan_no                         
    ,@l_girno                          
    ,@l_ward                           
    ,@l_nriadd1                        
    ,@l_nriadd2                        
    ,@l_nriadd3                        
    ,@l_nriadd4                        
    ,@l_nricountry                     
    ,@l_ecsno                          
    ,@l_nomname                        
    ,@l_nomguardname                   
    ,@l_nomadd1                        
    ,@l_nomadd2                        
    ,@l_nomadd3                        
    ,@l_nomcity                        
    ,@l_nompin                         
    ,@l_nomstate                       
    ,@l_nomcountry                     
    ,@l_contact_person                 
    ,@l_mobile_no                      
    ,@l_backofficecode                 
    ,@l_initial_cor                    
    ,@l_porttype                       
    ,@l_maintainacc                    
    ,@l_commencedate                   
    ,@l_flag                           
    ,@l_fam_code                       
    ,@l_equity                         
    ,@l_mf                             
    ,@l_debt                           
    ,@l_clntrepemail                   
    ,@l_clntrepfax                     
    ,@l_clntrepmail                    
    ,@l_clntrephand              
    ,@l_alrtemail                      
    ,@l_alrtfax                        
    ,@l_alrtmobile                     
    ,@l_ourcode                        
    ,@l_dataset                        
    ,@l_active                         
    ,@l_activedate                     
    ,@l_salutation                     
    ,@l_send_email_on_deactivation     
    ,@l_send_email_on_freeze           
    ,@l_send_email_on_closure          
    ,@l_send_email_on_corpaction       
    ,@l_schemecode                     
    ,@l_modelportfolio                 
    ,@l_rmcode                         
    ,@l_feescode                       
    ,@l_ctpersondecision               
    ,@l_ctpersondtelno                 
    ,@l_ctpersondfaxno                 
    ,@l_ctpersonoperation              
    ,@l_ctpersonotelno                 
    ,@l_ctpersonofaxno                 
    ,@l_ctpersonoadd1                  
    ,@l_ctpersonoadd2                  
    ,@l_ctpersonoadd3                  
    ,@l_ctpersonocity                  
    ,@l_ctpersonopin                   
    ,@l_jointhold1                     
    ,@l_jointhold2                     
    ,@l_jointhold1btdate               
    ,@l_jointhold2btdate               
    ,@l_branchid                       
    ,@l_groupid                        
    ,@l_clientgroup                    
    ,@l_clientlocation                 
    ,@l_dealer                         
    ,@l_clientadd1                     
    ,@l_clientadd2                     
    ,@l_clientadd3                     
    ,@l_clientpermenantadd1            
    ,@l_clientpermenantadd2            
    ,@l_clientpermenantadd3            
    ,@l_clientpermenantcity            
    ,@l_clientpermenantpin             
    ,@l_email                          
    ,@l_defaultbankac                  
    ,@l_alrtemail2                     
    ,@l_renewedon                      
    ,@l_defaultmailaddress             
    ,@l_backofficecodemf               
    ,@l_backofficecodedebt             
    ,@l_backofficecodeequity           
    ,@l_offadd                         
    ,@l_offcountry                     
    ,@l_offpin                         
    ,@l_offcity                        
    ,@l_offstate                       
    ,@l_off_tel                        
    ,@l_offfax                         
    ,@l_offmobile                      
    ,@l_orderaccepted                  
    ,@l_assetallocationcode            
    ,@l_branchcode                     
    ,@l_mainclientcode                 
    ,@l_opstockdp                      
    ,@l_clientrbicode                  
    ,@l_grade                          
    ,@l_portfolioreview                
    ,@l_familyhead                     
    ,@l_rcountrycode                   
    ,@l_ncountrycode                   
    ,@l_locationcode                   
    ,@l_internalclient                 
    ,@l_mfmodelport                    
    ,@l_reversalentryequity            
    ,@l_importavgtrades                
    ,@l_updatedonweb                   
    ,@l_importedfromcrm                
    ,@l_poolaccount                    
    ,@l_renewperiod                    
    ,@l_usr_clientid                   
    ,@l_categorycode                   
    ,@l_gpcgrmcode                     
    ,@l_mapincode                      
    ,@l_nbfcclient                     
    ,@l_hold1                          
    ,@l_holder1_code                   
    ,@l_holder2_code                   
    ,@l_holder3_code                   
    ,@l_opendate                       
    ,@l_remarks                        
    ,@l_cacode                         
    ,@l_cafax                          
    ,@l_catel                          
    ,@l_dpid                           
    ,@l_fathername                     
    ,@l_guardianname                   
    ,@l_introducercode                 
    ,@l_nonrepatapprovaldate           
    ,@l_nonrepatapprovalno             
    ,@l_nrpatvaliddate                 
    ,@l_relationship                   
    ,@l_repatapprovaldate              
    ,@l_repatapprovalno                
    ,@l_rpatvaliddate                  
    ,@l_tan_no                         
    ,@l_fundinglimit                   
    ,@l_statecode                      
    ,@l_stateoffcode                   
    ,@l_prodcat                        
    ,@l_aggno                          
    ,@l_acctrendt                      
    ,@l_acctexpdt                      
    ,@l_lgracctno                      
    ,@l_recmodtmstp                    
    ,@l_acctclsdt                      
    ,@l_accountfor                     
    ,@l_iaf                            
    ,@l_las                            
    ,@l_mtf                            
    ,@l_pasaccountno                   
    ,@l_existsinpas                    
    ,@l_pasclientcode                  
    ,@l_clientaccttype                 
    ,@l_jointpan1                      
    ,@l_jointpan2                      
    ,@l_jointmapin1                    
    ,@l_jointmapin2                    
    ,@l_businessunitsid                
    ,@l_createdby                      
    ,@l_createddate                    
    ,@l_updatedby                      
    ,@l_updateddate                    
    ,@l_poolaccountcode                
    ,@l_deactivatedate                 
    ,@l_closedate                      
    ,@l_activatedate                   
    ,@l_accountlimit                   
    ,@l_limitconservativeliberal       
    ,@l_paymode                        
    ,@l_pas2clientcode     
    ,0    
    ,@l_edittype                       
    )    
    --  
    SET @pa_error = convert(varchar, @@rowcount)    
    --  
    FETCH NEXT FROM @c_client_mstr INTO @l_crn_no, @l_client_code              
  --              
  END  --cursor                    
  --    
  --SET @pa_error = convert(varchar, @@rowcount)  
  --SET @pa_error = '1'  
  --  
  CLOSE @c_client_mstr               
  DEALLOCATE @c_client_mstr       
  --              
  SELECT * FROM MTF_MIG     
--    
END

GO
