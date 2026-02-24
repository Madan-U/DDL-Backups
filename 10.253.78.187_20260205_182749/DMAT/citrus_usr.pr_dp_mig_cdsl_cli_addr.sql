-- Object: PROCEDURE citrus_usr.pr_dp_mig_cdsl_cli_addr
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

---Exec pr_dp_mig_cdsl_cli_addr '15/01/2007','06/02/2008','','','',''             
---Select * from client_otheraddress where co_phind1='M' and len(co_tele1)<10            
---DELETE FROM client_otheraddress
--USE [CITRUS]            
CREATE PROCEDURE [citrus_usr].[pr_dp_mig_cdsl_cli_addr](@pa_from_dt    varchar(10)            
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
DECLARE @l_dpintrefno               varchar(10)            
       ,@l_cmcd                     char(16)            
       ,@l_purposecd                int            
       ,@l_name                     varchar(100)            
       ,@l_middlename               varchar(20)            
       ,@l_searchname               varchar(20)            
       ,@l_title                    varchar(10)            
       ,@l_suffix                   varchar(10)            
       ,@l_fhname                   varchar(50)            
       ,@l_add1                     varchar(30)            
       ,@l_add2                     varchar(30)            
       ,@l_add3                     varchar(30)            
       ,@l_city                     varchar(25)            
       ,@l_state                    varchar(25)            
       ,@l_country                  varchar(25)            
       ,@l_pin                      varchar(10)            
       ,@l_phind1                   char(1)            
       ,@l_tele1                    varchar(17)            
       ,@l_phind2                   char(1)            
       ,@l_tele2                    varchar(17)            
       ,@l_tele3                    varchar(100)            
       ,@l_fax                      varchar(17)            
       ,@l_panno                    varchar(25)            
       ,@l_itcircle                 varchar(15)            
       ,@l_email                    varchar(50)            
       ,@l_values                   varchar(8000)            
       ,@l_usertext1                varchar(50)            
       ,@l_usertext2                varchar(50)            
       ,@l_userfield1               int            
       ,@l_userfield2               int            
       ,@l_userfield3               int            
       ,@c_crn_no                   varchar(25)            
       ,@c_dpam_id                  varchar(25)            
       ,@c_acct_no                  varchar(25)            
       ,@c_sba_no                   varchar(25)            
       ,@l_guaadd1                  varchar(30)            
       ,@l_guaadd2                  varchar(30)            
       ,@l_guaadd3                  varchar(30)            
       ,@l_guacity                  varchar(25)            
       ,@l_guastate                 varchar(25)            
       ,@l_guacountry               varchar(25)            
       ,@l_guapin         varchar(10)            
       ,@l_guateleindicator1        char(1)            
       ,@l_guateleindicator2        char(1)            
       ,@l_guatele1                 varchar(17)            
       ,@l_guatele2               varchar(17)            
       ,@l_guatele3                 varchar(100)            
       ,@l_guafax                   varchar(17)            
       ,@l_guapanno                 varchar(25)            
       ,@l_guaitcircle              varchar(15)            
       ,@l_guaemail                 varchar(50)            
       ,@l_nom_guard_add1           varchar(30)            
       ,@l_nom_guard_add2           varchar(30)            
       ,@l_nom_guard_add3           varchar(30)            
       ,@l_nom_guard_city varchar(25)            
       ,@l_nom_guard_state          varchar(25)            
       ,@l_nom_guard_country        varchar(25)            
       ,@l_nom_guard_pin            varchar(10)            
       ,@l_nom_guard_teleindicator1 char(1)            
       ,@l_nom_guard_teleindicator2 char(1)            
       ,@l_nom_guard_tele1          varchar(17)            
       ,@l_nom_guard_tele2          varchar(17)            
       ,@l_nom_guard_tele3          varchar(100)            
       ,@l_nom_guard_fax            varchar(17)            
       ,@l_nom_guard_panno          varchar(25)            
       ,@l_nom_guard_itcircle       varchar(15)            
       ,@l_nom_guard_email          varchar(50)            
       ,@l_sh_poa_add1              varchar(30)            
       ,@l_sh_poa_add2              varchar(30)            
       ,@l_sh_poa_add3              varchar(30)            
       ,@l_sh_poa_city              varchar(25)            
       ,@l_sh_poa_state             varchar(25)            
       ,@l_sh_poa_country           varchar(25)            
       ,@l_sh_poa_pin               varchar(10)            
       ,@l_sh_poa_teleindicator1    char(1)            
       ,@l_sh_poa_teleindicator2    char(1)            
       ,@l_sh_poa_tele1             varchar(17)            
       ,@l_sh_poa_tele2             varchar(17)            
       ,@l_sh_poa_tele3             varchar(100)            
       ,@l_sh_poa_fax               varchar(17)            
       ,@l_sh_poa_panno             varchar(25)            
       ,@l_sh_poa_itcircle          varchar(15)            
       ,@l_sh_poa_email             varchar(50)            
       ,@l_sechname                 varchar(200)            
       ,@l_sechmiddle               varchar(200)            
       ,@l_sechlastname             varchar(200)            
       ,@l_thirdhname               varchar(200)            
       ,@l_thirdhmiddle             varchar(200)            
       ,@l_thirdhlastname           varchar(200)            
       ,@l_sechfname                varchar(200)            
       ,@l_gaufname                 varchar(200)            
       ,@l_gaumname                 varchar(200)            
       ,@l_gaulname                 varchar(200)            
       ,@l_nomgaufname              varchar(200)            
       ,@l_nomgaumname              varchar(200)            
       ,@l_nomgaulname              varchar(200)            
       ,@l_th_poa_add1              varchar(200)            
       ,@l_th_poa_add2              varchar(200)            
       ,@l_th_poa_add3              varchar(200)            
       ,@l_th_poa_city              varchar(200)            
       ,@l_th_poa_state             varchar(200)            
       ,@l_th_poa_country           varchar(200)            
       ,@l_th_poa_pin               varchar(10)   
       ,@l_th_poa_teleindicator1    char(1)            
       ,@l_th_poa_teleindicator2    char(1)            
       ,@l_th_poa_tele1             varchar(17)            
       ,@l_th_poa_tele2             varchar(17)            
       ,@l_th_poa_tele3             varchar(17)            
       ,@l_th_poa_fax               varchar(17)            
       ,@l_th_poa_panno             varchar(25)            
       ,@l_th_poa_itcircle          varchar(15)            
       ,@l_th_poa_email             varchar(50)            
       ,@l_lastname                 varchar(200)            
       ,@l_nri_frn_values           varchar(200)            
       ,@l_nri_ind_values    varchar(200)            
       ,@l_cli_values               varchar(200)            
       ,@l_pur_code                 int            
       ,@l_fathername               varchar(200)            
       ,@l_code                     varchar(200)            
       ,@l_modified                 char(1)            
       ,@l_nomgauftname             varchar(200)            
       ,@l_gaufthname               varchar(200)            
       ,@l_thirdfname               varchar(200)            
--            
--            
IF EXISTS(SELECT TOP 1 * FROM client_otheraddress WITH (NOLOCK) WHERE co_cmpltd = 1)            
--            
BEGIN--#            
--            
INSERT INTO client_otheraddress_hst            
( co_dpintrefno            
, co_cmcd            
, co_purposecd            
, co_name            
, co_middlename            
, co_searchname            
, co_title            
, co_suffix            
, co_fhname            
, co_add1            
, co_add2            
, co_add3            
, co_city            
, co_state            
, co_country            
, co_pin            
, co_phind1            
, co_tele1            
, co_phind2            
, co_tele2            
, co_tele3            
, co_fax            
, co_panno            
, co_itcircle            
, co_email            
, co_usertext1            
, co_usertext2            
, co_userfield1            
, co_userfield2            
, co_userfield3            
, co_cmpltd            
, co_edittype --new col            
)            
SELECT co_dpintrefno            
 , co_cmcd            
 , co_purposecd            
 , co_name            
 , co_middlename            
 , co_searchname            
 , co_title            
 , co_suffix            
 , co_fhname            
 , co_add1            
 , co_add2            
 , co_add3            
 , co_city            
 , co_state            
 , co_country            
 , co_pin            
 , co_phind1            
 , co_tele1            
 , co_phind2            
 , co_tele2            
 , co_tele3            
 , co_fax            
 , co_panno            
 , co_itcircle            
 , co_email            
 , co_usertext1            
 , co_usertext2            
 , co_userfield1            
 , co_userfield2            
 , co_userfield3            
 , 1            
 , co_edittype  --new col            
FROM     client_otheraddress            
WHERE    co_cmpltd     = 1            
--            
DELETE FROM client_otheraddress            
WHERE  co_cmpltd  = 1            
--            
END--#            
--            
--dp_holder_details            
--            
CREATE TABLE #dp_holder_dtls1            
( dphd_dpam_sba_no      varchar(20)            
,dphd_sh_fname         varchar(100)            
,dphd_sh_mname         varchar(50)            
,dphd_sh_lname         varchar(50)            
,dphd_sh_fthname       varchar(100)            
,dphd_sh_dob           datetime            
,dphd_sh_pan_no        varchar(15)            
,dphd_sh_gender        varchar(1)            
,dphd_th_fname         varchar(100)            
,dphd_th_mname         varchar(50)            
,dphd_th_lname         varchar(50)            
,dphd_th_fthname       varchar(100)            
,dphd_th_dob           datetime            
,dphd_th_pan_no        varchar(15)            
,dphd_th_gender        varchar(1)            
,dphd_poa_fname        varchar(100)            
,dphd_poa_mname varchar(50)            
,dphd_poa_lname        varchar(50)            
,dphd_poa_fthname      varchar(100)            
,dphd_poa_dob          datetime            
,dphd_poa_pan_no       varchar(15)            
,dphd_poa_gender       varchar(1)            
,dphd_nom_fname        varchar(100)            
,dphd_nom_mname        varchar(50)            
,dphd_nom_lname        varchar(50)            
,dphd_nom_fthname      varchar(100)            
,dphd_nom_dob          datetime            
,dphd_nom_pan_no       varchar(15)            
,dphd_nom_gender       varchar(1)            
,dphd_gau_fname        varchar(100)            
,dphd_gau_mname        varchar(50)            
,dphd_gau_lname        varchar(50)            
,dphd_gau_fthname      varchar(100)            
,dphd_gau_dob          datetime            
,dphd_gau_pan_no       varchar(15)            
,dphd_gau_gender       varchar(1)            
,dphd_fh_fthname       varchar(100)            
,dphd_dppd_hld         varchar(200)             --column from dp_poa_dtls            
,dphd_nomgau_fname     varchar(200)             --new column            
,dphd_nomgau_mname     varchar(200)             --new column            
,dphd_nomgau_lname     varchar(200)             --new column            
,dphd_nomgau_fthname   varchar(100)             --new column            
,dphd_nomgau_dob       datetime                 --new column            
,dphd_nomgau_pan_no    varchar(15)              --new column            
,dphd_nomgau_gender    varchar(1)               --new column            
)            
--            
IF isnull(@pa_from_dt,'') <> '' AND isnull(@pa_to_dt,'') <> '' AND isnull(@pa_from_crn,'') <> '' AND isnull(@pa_to_crn,'') <> ''            
--            
BEGIN            
--            
SET @c_cursor = CURSOR fast_forward FOR            
SELECT DISTINCT dpam.dpam_crn_no       crn_no            
    , dpam.dpam_id dpam_id            
    , dpam.dpam_acct_no              acct_no            
    , dpam.dpam_sba_no               sba_no            
FROM   exch_seg_mstr                   excsm    WITH (NOLOCK)            
   , status_mstr                     sm       WITH (NOLOCK)            
   , dp_mstr                         dpm      WITH (NOLOCK)            
   , dp_acct_mstr                    dpam     WITH (NOLOCK)            
   , product_mstr                    prom            
   , excsm_prod_mstr                 excpm            
WHERE  dpam.dpam_excsm_id           =  excsm.excsm_id            
AND    excsm.excsm_id               =  excpm.excpm_excsm_id            
AND    dpam_lst_upd_dt                 between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'            
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
AND    prom.prom_deleted_ind     =  1            
AND    excpm.excpm_deleted_ind      =  1            
--            
END            
--            
IF isnull(@pa_from_dt,'') <> '' AND isnull(@pa_to_dt,'') <> '' AND isnull(@pa_from_crn,'') = '' AND isnull(@pa_to_crn,'') = ''            
--            
BEGIN            
SET @c_cursor = CURSOR fast_forward FOR            
SELECT DISTINCT dpam.dpam_crn_no       crn_no            
     , dpam.dpam_id                    dpam_id            
     , dpam.dpam_acct_no               acct_no            
      , dpam.dpam_sba_no               sba_no            
FROM   exch_seg_mstr                   excsm    WITH (NOLOCK)            
     , status_mstr                     sm       WITH (NOLOCK)            
     , dp_mstr                         dpm      WITH (NOLOCK)            
     , dp_acct_mstr                    dpam     WITH (NOLOCK)            
     , product_mstr                    prom            
     , excsm_prod_mstr                 excpm            
WHERE  dpam.dpam_excsm_id           =  excsm.excsm_id            
AND    excsm.excsm_id               =  excpm.excpm_excsm_id            
AND    dpam_lst_upd_dt                 between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'            
--AND    dpam_crn_no   between convert(numeric, @pa_from_crn)  AND  convert(numeric, @pa_to_crn)            
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
IF isnull(@pa_from_dt,'') = '' AND isnull(@pa_to_dt,'') = '' AND isnull(@pa_from_crn,'') <> '' AND isnull(@pa_to_crn,'') <> ''            
--            
BEGIN            
SET @c_cursor = CURSOR fast_forward FOR            
SELECT DISTINCT dpam.dpam_crn_no       crn_no            
      , dpam.dpam_id                    dpam_id            
      , dpam.dpam_acct_no               acct_no            
      , dpam.dpam_sba_no                sba_no            
 FROM   exch_seg_mstr                   excsm    WITH (NOLOCK)            
      , status_mstr                     sm       WITH (NOLOCK)            
      , dp_mstr                         dpm      WITH (NOLOCK)            
      , dp_acct_mstr                    dpam     WITH (NOLOCK)            
      , product_mstr                    prom            
      , excsm_prod_mstr                 excpm            
WHERE  dpam.dpam_excsm_id           =  excsm.excsm_id            
AND    excsm.excsm_id               =  excpm.excpm_excsm_id            
--AND    dpam_lst_upd_dt                 between convert(varchar,convert(datetime, @pa_from_dt,103),106)+' 00:00:00' AND convert(varchar,convert(datetime,@pa_to_dt,103),106)+' 23:59:59'            
AND    dpam_crn_no                     between convert(numeric, @pa_from_crn)  AND  convert(numeric, @pa_to_crn)            
AND    prom.prom_cd                 =  '01'            
AND    excsm.excsm_exch_cd          =  'CDSL'            
AND    prom.prom_id                 =  excpm.excpm_prom_id            
AND    dpam.dpam_dpm_id             =  dpm.dpm_id            
AND    dpam.dpam_stam_cd            =  sm.stam_cd            
AND    dpam.dpam_deleted_ind        =  1            
AND    excsm.excsm_deleted_ind   =  1            
AND    dpm.dpm_deleted_ind          =  1            
AND    sm.stam_deleted_ind          =  1            
AND    prom.prom_deleted_ind        =  1            
AND    excpm.excpm_deleted_ind      =  1            
--            
END            
--            
OPEN @c_cursor            
FETCH NEXT FROM @c_cursor INTO @c_crn_no,@c_dpam_id,@c_acct_no , @c_sba_no            
--            
WHILE @@fetch_status = 0            
BEGIN --#cursor            
--            
DELETE FROM #dp_holder_dtls1            
--            
DELETE FROM #entity_properties            
--            
DELETE FROM #entity_property_dtls            
--            
DELETE FROM #conc            
--            
DELETE FROM #addr            
--            
INSERT INTO #dp_holder_dtls1            
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
,dphd_dppd_hld  --new column            
,dphd_nomgau_fname            
,dphd_nomgau_mname            
,dphd_nomgau_lname            
,dphd_nomgau_fthname            
,dphd_nomgau_dob            
,dphd_nomgau_pan_no            
,dphd_nomgau_gender            
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
     , dphd_gau_dob --convert(varchar(8), dphd_gau_dob, 3)            
     , dphd_gau_pan_no            
     , dphd_gau_gender            
     , dphd_fh_fthname            
     , dppd_hld          --new column            
     , dphd_nomgau_fname            
     , dphd_nomgau_mname            
     , dphd_nomgau_lname            
     , dphd_nomgau_fthname            
     , dphd_nomgau_dob            
     , dphd_nomgau_pan_no            
     , dphd_nomgau_gender            
FROM   dp_holder_dtls          WITH (NOLOCK)            
     , dp_acct_mstr            WITH (NOLOCK)            
       left outer join            
       dp_poa_dtls             WITH (NOLOCK)            
       on  dpam_id             = dppd_dpam_id            
WHERE  dphd_dpam_id            = dpam_id            
AND    dpam_id                 = @c_dpam_id          
AND    dphd_dpam_sba_no        = @c_sba_no            
AND    dphd_deleted_ind        = 1            
AND    dpam_deleted_ind        = 1            
--AND    dppd_deleted_ind        = 1            
--            
INSERT INTO #entity_properties            
(code            
,value            
)            
SELECT entp_entpm_cd            
      ,entp_value            
FROM   entity_properties            
WHERE  entp_ent_id           = @c_crn_no            
AND    entp_deleted_ind      = 1            
            
            
INSERT INTO #entity_property_dtls            
(code1            
,code2            
,value            
)            
--            
SELECT a.entp_entpm_cd            
     , b.entpd_entdm_cd            
     , b.entpd_value            
FROM   entity_properties      a  WITH (NOLOCK)            
     , entity_property_dtls   b  WITH (NOLOCK)            
WHERE  a.entp_ent_id        = @c_crn_no            
AND    a.entp_id            = b.entpd_entp_id            
AND    a.entp_deleted_ind   = 1            
AND    b.entpd_deleted_ind  = 1            
--            
--            
INSERT INTO #account_properties            
(code            
,value            
)            
SELECT accp_accpm_prop_cd            
     , accp_value            
FROM   account_properties      WITH (NOLOCK)            
WHERE  accp_clisba_id        = @c_dpam_id            
AND    accp_deleted_ind      = 1            
--            
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
WHERE  a.accp_clisba_id      = @c_dpam_id            
AND    a.accp_id     = b.accpd_accp_id            
AND    a.accp_deleted_ind    = 1            
AND    b.accpd_deleted_ind   = 1            
--            
--            
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
--            
--            
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
--FOR GUARDIAN            
SET @l_values               = ''            
--            
SELECT @l_values               = citrus_usr.fn_dp_mig_nsdl_dphd('ADDR',@c_dpam_id,'GUARD_ADR')            
--            
SELECT @l_guaadd1              = convert(varchar(30), citrus_usr.fn_splitval(@l_values,1))            
    , @l_guaadd2              = convert(varchar(30), citrus_usr.fn_splitval(@l_values,2))            
    , @l_guaadd3              = convert(varchar(30), citrus_usr.fn_splitval(@l_values,3))            
    , @l_guacity              = convert(varchar(25), citrus_usr.fn_splitval(@l_values,4))            
    , @l_guastate             = convert(varchar(25), citrus_usr.fn_splitval(@l_values,5))            
    , @l_guacountry           = convert(varchar(25), citrus_usr.fn_splitval(@l_values,6))            
    , @l_guapin               = convert(varchar(10), citrus_usr.fn_splitval(@l_values,7))            
--      
If ltrim(rtrim(isnull(@l_guaadd1,'') ))      = ''  set @l_guaadd1 = ''                  
If ltrim(rtrim(isnull(@l_guaadd2,'') ))      = ''  set @l_guaadd2 = ''            
If ltrim(rtrim(isnull(@l_guaadd3,'') ))      = ''  set @l_guaadd3 = ''            
If ltrim(rtrim(isnull(@l_guacity,'') ))      = ''  set @l_guacity = ''            
If ltrim(rtrim(isnull(@l_guastate ,'') ))    = ''  set @l_guastate  = ''            
If ltrim(rtrim(isnull(@l_guacountry,'') ))   = ''  set @l_guacountry = ''            
If ltrim(rtrim(isnull(@l_guapin,'') ))       = ''  set @l_guapin = ''            
--            
SELECT @l_guatele1             = isnull(convert(varchar(17), citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'RES_PH1')) ,'')            
SELECT @l_guateleindicator1    = case when @l_guatele1<>'' then 'R' else'M' end            
If ltrim(rtrim(isnull(@l_guatele1,'') ))   = ''  set @l_guatele1 = ''            
--            
SELECT @l_guatele1             = isnull(convert(varchar(17), citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'GUARD_RES')) ,'')            
SELECT @l_guateleindicator1    = case when @l_guatele1<>'' then 'R' else'' end            
--            
--            
SELECT @l_guatele2             = isnull(convert(varchar(17), citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'GUARD_MOB')) ,'')            
SELECT @l_guateleindicator2    = case when @l_guatele2 <> '' then 'M' else '' end            
If ltrim(rtrim(isnull(@l_guatele2,'') ))   = ''  set @l_guatele2 = ''            
--            
SELECT @l_guatele3             = isnull(convert(varchar(100), citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'GUARD_OFF')) ,'')            
If ltrim(rtrim(isnull(@l_guatele3,'') ))   = ''  set @l_guatele3 = ''            
--            
SELECT @l_guafax             = isnull(convert(varchar(17), citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'GUARD_FAX')),'')            
If ltrim(rtrim(isnull(@l_guafax,'') ))   = ''  set @l_guafax = ''            
--            
SELECT @l_guapanno             = dphd_gau_pan_no from #dp_holder_dtls1 --isnull(convert(varchar(25),value),'') FROM #account_properties WHERE code = 'GUARD_PAN_GIR_NO'            
If ltrim(rtrim(isnull(@l_guapanno,'') ))   = ''  set @l_guapanno = ''            
--            
SELECT @l_guaitcircle          = convert(varchar(25), value) FROM #account_properties WHERE code = 'GUARD_IT'            
If ltrim(rtrim(isnull(@l_guaitcircle,'') ))   = ''  set @l_guaitcircle = ''            
--            
SELECT @l_guaemail             = isnull(convert(varchar(50), value),'')            
FROM   #conc                     WITH (NOLOCK)            
WHERE  code                    = 'GUARD_MAIL'            
AND    pk                      = @c_crn_no            
--            
If ltrim(rtrim(isnull(@l_guaemail,'') ))   = ''  set @l_guaemail = ''            
--            
SET @l_usertext1           = ''            
SET @l_usertext2           = ''            
SET @l_userfield1          = 0            
SET @l_userfield2          = 0            
SET @l_userfield3          = 0            
--            
SET @l_suffix              = ''            
            
SELECT @l_gaufname = dphd_gau_fname FROM #dp_holder_dtls1            
SELECT @l_gaumname = dphd_gau_mname FROM #dp_holder_dtls1            
SELECT @l_gaulname = dphd_gau_lname FROM #dp_holder_dtls1            
SELECT @l_gaufthname  = dphd_gau_fthname FROM #dp_holder_dtls1            
SELECT @l_title = case when dphd_gau_gender = 'M'then 'MR'   when dphd_gau_gender = 'F'then 'MS'  ELSE '' END FROM   #dp_holder_dtls1            
--            
--            
If ltrim(rtrim(isnull(@l_gaumname,'') ))   = ''  set @l_gaumname = ''            
If ltrim(rtrim(isnull(@l_gaulname,'') ))   = ''  set @l_gaulname = ''            
If ltrim(rtrim(isnull(@l_gaufthname,'') )) = ''  set @l_gaufthname = ''            
If ltrim(rtrim(isnull(@l_gaufname,'') ))   = ''  set @l_gaufname = ''            
--            
-- FOR CHECKING IN HISTORY TABLE FOR CLIENT_OTHERADDRESS            
IF exists(select * from client_otheraddress_hst where co_dpintrefno = @c_acct_no and co_cmpltd = 1)            
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
            
---FOR GUARDIAN RECORDS TO BE INSERTED            
--            
IF @l_gaufname <>''            
--            
if exists(select * from client_otheraddress where co_dpintrefno = @c_acct_no and co_cmpltd = 0)            
begin            
        --            
delete from client_otheraddress where co_dpintrefno = @c_acct_no and co_cmpltd = 0 and co_purposecd = 7            
--            
--BEGIN            
--            
   INSERT INTO client_otheraddress -- GUARDIAN DETAILS            
   ( co_dpintrefno            
   , co_cmcd            
   , co_purposecd            
   , co_name            
   , co_middlename            
   , co_searchname            
   , co_title            
   , co_suffix            
   , co_fhname            
   , co_add1            
   , co_add2            
   , co_add3            
   , co_city            
   , co_state            
   , co_country            
   , co_pin            
   , co_phind1            
   , co_tele1            
   , co_phind2            
   , co_tele2            
   , co_tele3            
   , co_fax            
   , co_panno            
   , co_itcircle            
   , co_email            
   , co_usertext1            
   , co_usertext2            
   , co_userfield1            
   , co_userfield2            
   , co_userfield3            
   , co_cmpltd            
   , co_edittype            
   )            
   SELECT @c_acct_no            
     , '' --@c_sba_no            
     , 7            
     , @l_gaufname            
     , @l_gaumname            
     , @l_gaulname            
     , @l_title            
     , @l_suffix            
     , @l_gaufthname            
     , @l_guaadd1            
     , @l_guaadd2            
     , @l_guaadd3            
     , @l_guacity            
     , @l_guastate            
     , @l_guacountry            
     , @l_guapin            
     , @l_guateleindicator1            
     , @l_guatele1            
     , @l_guateleindicator2            
     , @l_guatele2            
     , @l_guatele3            
     , @l_guafax            
     , @l_guapanno            
     , @l_guaitcircle            
     , @l_guaemail            
     , @l_usertext1            
     , @l_usertext2            
     , @l_userfield1            
     , @l_userfield2            
     , @l_userfield3            
     , 0            
     , @l_modified            
   FROM   #dp_holder_dtls1            
   --            
   set @l_gaufname = ''            
   set @l_gaumname = ''            
   set @l_gaulname = ''            
   set @l_gaufthname = ''            
   set @l_title    =  ''            
   set @l_suffix   = ''            
   set @l_guaadd1  = ''            
   set @l_guaadd2  = ''            
   set @l_guaadd3  = ''            
   set @l_guacity  = ''            
   set @l_guastate = ''            
   set @l_guacountry = ''            
   set @l_guapin     = ''            
   set @l_guateleindicator1 = ''            
   set @l_guatele1          = ''            
   set @l_guateleindicator2 = ''            
   set @l_guatele2          = ''            
   set @l_guatele3          = ''            
   set @l_guafax            = ''            
   set @l_guapanno          = ''            
   set @l_guaitcircle       = ''            
   set @l_guaemail          = ''            
   set @l_usertext1         = ''            
   set @l_usertext2         = ''            
   set @l_userfield1        = 0            
   set @l_userfield2        = 0            
   set @l_userfield3        = 0            
   --            
   END            
   --            
   Else            
   begin            
   INSERT INTO client_otheraddress -- GUARDIAN DETAILS            
   ( co_dpintrefno            
   , co_cmcd            
   , co_purposecd            
   , co_name            
   , co_middlename            
   , co_searchname            
   , co_title            
   , co_suffix            
   , co_fhname            
   , co_add1            
   , co_add2            
   , co_add3            
   , co_city            
   , co_state            
   , co_country            
   , co_pin            
   , co_phind1            
   , co_tele1            
   , co_phind2            
   , co_tele2            
   , co_tele3     
   , co_fax            
   , co_panno            
   , co_itcircle            
   , co_email            
   , co_usertext1            
   , co_usertext2            
   , co_userfield1            
   , co_userfield2            
   , co_userfield3            
   , co_cmpltd            
   , co_edittype            
   )            
   SELECT @c_acct_no            
     , '' --@c_sba_no            
     , 7            
     , @l_gaufname            
     , @l_gaumname            
     , @l_gaulname            
     , @l_title            
     , @l_suffix            
     , @l_gaufthname            
     , @l_guaadd1            
     , @l_guaadd2            
     , @l_guaadd3            
     , @l_guacity            
     , @l_guastate            
     , @l_guacountry            
     , @l_guapin            
     , @l_guateleindicator1            
     , @l_guatele1            
     , @l_guateleindicator2            
     , @l_guatele2            
     , @l_guatele3            
     , @l_guafax            
     , @l_guapanno            
     , @l_guaitcircle            
     , @l_guaemail            
     , @l_usertext1            
     , @l_usertext2            
     , @l_userfield1            
     , @l_userfield2            
     , @l_userfield3            
     , 0            
     , @l_modified            
   FROM   #dp_holder_dtls1            
   --            
   set @l_gaufname = ''            
   set @l_gaumname = ''            
   set @l_gaulname = ''            
   set @l_gaufthname = ''            
   set @l_title    =  ''            
   set @l_suffix   = ''            
   set @l_guaadd1  = ''            
   set @l_guaadd2  = ''            
   set @l_guaadd3  = ''            
   set @l_guacity  = ''            
   set @l_guastate = ''            
   set @l_guacountry = ''            
   set @l_guapin     = ''            
   set @l_guateleindicator1 = ''            
   set @l_guatele1          = ''            
   set @l_guateleindicator2 = ''            
   set @l_guatele2          = ''            
   set @l_guatele3          = ''            
   set @l_guafax            = ''            
   set @l_guapanno          = ''            
   set @l_guaitcircle       = ''            
   set @l_guaemail          = ''            
   set @l_usertext1         = ''            
   set @l_usertext2         = ''            
   set @l_userfield1        = 0            
   set @l_userfield2        = 0            
   set @l_userfield3        = 0            
   --            
   --            
   end            
  --            
--FOR GUARDIAN RECORDS TO BE INSERTED            
--FOR NOMINEE GAURDIAN            
--For Nominees Guardian            
--            
SET @l_values               = ''            
--            
SELECT @l_values                 = citrus_usr.fn_dp_mig_nsdl_dphd('ADDR',@c_dpam_id,'NOM_GUARDIAN_ADDR')            
--            
SELECT @l_nom_guard_add1         = convert(varchar(30), citrus_usr.fn_splitval(@l_values,1))            
     , @l_nom_guard_add2         = convert(varchar(30), citrus_usr.fn_splitval(@l_values,2))            
  , @l_nom_guard_add3         = convert(varchar(30), citrus_usr.fn_splitval(@l_values,3))            
  ,  @l_nom_guard_city         = convert(varchar(25), citrus_usr.fn_splitval(@l_values,4))            
  , @l_nom_guard_state        = convert(varchar(25), citrus_usr.fn_splitval(@l_values,5))            
  , @l_nom_guard_country      = convert(varchar(25), citrus_usr.fn_splitval(@l_values,6))            
  , @l_nom_guard_pin          = convert(varchar(10), citrus_usr.fn_splitval(@l_values,7))            
--      
If ltrim(rtrim(isnull(@l_nom_guard_add1,'') ))      = ''  set @l_nom_guard_add1 = ''                  
If ltrim(rtrim(isnull(@l_nom_guard_add2,'') ))      = ''  set @l_nom_guard_add2 = ''            
If ltrim(rtrim(isnull(@l_nom_guard_add3,'') ))      = ''  set @l_nom_guard_add3 = ''            
If ltrim(rtrim(isnull(@l_nom_guard_city,'') ))      = ''  set @l_nom_guard_city = ''            
If ltrim(rtrim(isnull(@l_nom_guard_state,'') ))     = ''  set @l_nom_guard_state = ''          
If ltrim(rtrim(isnull(@l_nom_guard_country,'') ))   = ''  set @l_nom_guard_country = ''            
If ltrim(rtrim(isnull(@l_nom_guard_pin,'') ))       = ''  set @l_nom_guard_pin = ''            
--            
SELECT @l_nom_guard_tele1            = isnull(convert(varchar(17), citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'RES_PH1')) ,'')            
SELECT @l_nom_guard_teleindicator1   = case when @l_nom_guard_tele1<>'' then 'R' else'M' end            
If ltrim(rtrim(isnull(@l_nom_guard_tele1,'') ))   = ''  set @l_nom_guard_tele1 = ''            
--            
SELECT @l_nom_guard_tele1             = isnull(convert(varchar(17), citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'NOM_GUARD_RES')),'')            
SELECT @l_nom_guard_teleindicator1    = case when @l_nom_guard_tele1 <> '' then 'R' else '' end            
If ltrim(rtrim(isnull(@l_nom_guard_tele1,'') ))   = ''  set @l_nom_guard_tele1 = ''            
--            
            
--            
SELECT @l_nom_guard_tele2             = isnull(convert(varchar(17), citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'NOM_GUARD_MOB')),'')            
SELECT @l_nom_guard_teleindicator2    = case when @l_nom_guard_tele2 <> '' then 'M' else '' end            
If ltrim(rtrim(isnull(@l_nom_guard_tele2,'') ))   = ''  set @l_nom_guard_tele2 = ''            
--            
SELECT @l_nom_guard_tele3             = isnull(convert(varchar(100), citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'NOM_GUARD_OFF')),'')            
If ltrim(rtrim(isnull(@l_nom_guard_tele3,'') ))   = ''  set @l_nom_guard_tele3 = ''            
--            
SELECT @l_nom_guard_fax               = isnull(convert(varchar(17), citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'NOM_GUARD_FAX')),'')            
If ltrim(rtrim(isnull(@l_nom_guard_fax,'') ))   = ''  set @l_nom_guard_fax = ''            
--            
SELECT @l_nom_guard_panno             =  dphd_nomgau_pan_no from #dp_holder_dtls1  --isnull(convert(varchar(25),value),'') FROM #account_properties WHERE code = 'NOM_GUARD_PAN_GIR_NO'            
If ltrim(rtrim(isnull(@l_nom_guard_panno ,'') ))   = ''  set @l_nom_guard_panno  = ''            
--            
--            
SELECT @l_nom_guard_itcircle          = convert(varchar(25), value) FROM #account_properties WHERE code = 'NOM_GUARD_IT'            
If ltrim(rtrim(isnull(@l_nom_guard_itcircle ,'') ))   = ''  set @l_nom_guard_itcircle  = ''            
--            
SELECT @l_nom_guard_email             = isnull(convert(varchar(50), value),'')            
FROM   #conc                            WITH (NOLOCK)            
WHERE  code                           = 'NOM_GUARD_MAIL'            
AND    pk                             = @c_crn_no            
--            
If ltrim(rtrim(isnull(@l_nom_guard_email ,'') ))   = ''  set @l_nom_guard_email  = ''            
--            
SET @l_usertext1           = ''            
SET @l_usertext2           = ''            
SET @l_userfield1          = 0            
SET @l_userfield2          = 0            
SET @l_userfield3          = 0            
    --            
    SET @l_suffix              = ''            
    --            
    --            
    SELECT @l_nomgaufname = dphd_nomgau_fname FROM #dp_holder_dtls1            
    SELECT @l_nomgaumname = dphd_nomgau_mname FROM #dp_holder_dtls1            
    SELECT @l_nomgaulname = dphd_nomgau_lname FROM #dp_holder_dtls1            
    SELECT @l_nomgauftname = dphd_nomgau_fthname FROM #dp_holder_dtls1            
    select @l_title = case when dphd_nomgau_gender = 'M'then 'MR'   when dphd_nomgau_gender = 'F'then 'MS' ELSE '' END FROM   #dp_holder_dtls1            
    --            
    If ltrim(rtrim(isnull(@l_nomgaufname ,'') ))   = ''  set @l_nomgaufname  = ''              
    If ltrim(rtrim(isnull(@l_nomgaumname ,'') ))   = ''  set @l_nomgaumname  = ''            
    If ltrim(rtrim(isnull(@l_nomgaulname ,'') ))   = ''  set @l_nomgaulname  = ''            
    If ltrim(rtrim(isnull(@l_nomgauftname ,'') ))   = ''  set @l_nomgauftname  = ''         
    If ltrim(rtrim(isnull(@l_nom_guard_email ,'') ))   = ''  set @l_nom_guard_email  = ''            
    --            
    IF exists(select * from client_otheraddress_hst where co_dpintrefno = @c_acct_no and co_cmpltd = 1)            
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
--            
IF @l_nomgaufname <>''            
--            
if exists(select * from client_otheraddress where co_dpintrefno = @c_acct_no and co_cmpltd = 0)            
begin            
--            
delete from client_otheraddress where co_dpintrefno = @c_acct_no and co_cmpltd = 0 and co_purposecd = 8            
--BEGIN            
--            
INSERT INTO client_otheraddress            
( co_dpintrefno            
, co_cmcd            
, co_purposecd            
, co_name            
, co_middlename            
, co_searchname            
, co_title            
, co_suffix            
, co_fhname            
, co_add1            
, co_add2            
, co_add3            
, co_city            
, co_state            
, co_country            
, co_pin            
, co_phind1            
, co_tele1            
, co_phind2            
, co_tele2            
, co_tele3            
, co_fax            
, co_panno            
, co_itcircle            
, co_email            
, co_usertext1            
, co_usertext2            
, co_userfield1            
, co_userfield2            
, co_userfield3            
, co_cmpltd            
, co_edittype            
)            
SELECT @c_acct_no            
   , ''   --@c_sba_no            
   , 8    --Nominees guardian            
   , @l_nomgaufname            
   , @l_nomgaumname            
   , @l_nomgaulname            
   , @l_title            
   , @l_suffix            
   , @l_nomgauftname            
   , @l_nom_guard_add1            
   , @l_nom_guard_add2            
   , @l_nom_guard_add3            
   , @l_nom_guard_city            
   , @l_nom_guard_state            
   , @l_nom_guard_country       
   , @l_nom_guard_pin            
   , @l_nom_guard_teleindicator1            
   , @l_nom_guard_tele1            
   , @l_nom_guard_teleindicator2            
   , @l_nom_guard_tele2            
   , @l_nom_guard_tele3            
   , @l_nom_guard_fax            
   , @l_nom_guard_panno            
   , @l_nom_guard_itcircle            
   , @l_nom_guard_email            
   , @l_usertext1            
   , @l_usertext2            
   , @l_userfield1            
   , @l_userfield2            
   , @l_userfield3            
   , 0            
   , @l_modified            
FROM   #dp_holder_dtls1            
--            
set @l_nomgaufname = ''            
set @l_nomgaumname  = ''            
set @l_nomgaulname  = ''            
set @l_nomgauftname = ''            
set @l_title    =  ''            
set @l_suffix   = ''            
set @l_nom_guard_add1 = ''            
set @l_nom_guard_add2  = ''            
set @l_nom_guard_add3  = ''            
set @l_nom_guard_city  = ''            
set @l_nom_guard_state = ''            
set @l_nom_guard_country = ''            
set @l_nom_guard_pin    = ''            
set @l_nom_guard_teleindicator1 = ''            
set @l_nom_guard_tele1         = ''            
set @l_nom_guard_teleindicator2 = ''            
set @l_nom_guard_tele2          = ''            
set @l_nom_guard_tele3          = ''            
set @l_nom_guard_fax           = ''            
set @l_nom_guard_panno          = ''            
set @l_nom_guard_itcircle       = ''            
set @l_nom_guard_email          = ''            
set @l_usertext1                = ''            
set @l_usertext2                = ''            
set @l_userfield1               = 0            
set @l_userfield2               = 0            
set @l_userfield3               = 0            
--            
END            
--            
else            
begin            
--            
INSERT INTO client_otheraddress            
( co_dpintrefno            
, co_cmcd            
, co_purposecd            
, co_name            
, co_middlename            
, co_searchname            
, co_title            
, co_suffix            
, co_fhname            
, co_add1            
, co_add2            
, co_add3            
, co_city            
, co_state            
, co_country            
, co_pin            
, co_phind1            
, co_tele1            
, co_phind2            
, co_tele2            
, co_tele3            
, co_fax            
, co_panno            
, co_itcircle            
, co_email            
, co_usertext1            
, co_usertext2            
, co_userfield1            
, co_userfield2            
, co_userfield3            
, co_cmpltd            
, co_edittype            
)            
SELECT @c_acct_no            
   , ''   --@c_sba_no            
   , 8    --Nominees guardian            
   , @l_nomgaufname            
   , @l_nomgaumname            
   , @l_nomgaulname            
   , @l_title            
   , @l_suffix            
   , @l_nomgauftname            
   , @l_nom_guard_add1            
   , @l_nom_guard_add2            
   , @l_nom_guard_add3            
   , @l_nom_guard_city            
   , @l_nom_guard_state            
   , @l_nom_guard_country            
   , @l_nom_guard_pin            
   , @l_nom_guard_teleindicator1            
   , @l_nom_guard_tele1            
   , @l_nom_guard_teleindicator2            
   , @l_nom_guard_tele2            
   , @l_nom_guard_tele3            
   , @l_nom_guard_fax            
   , @l_nom_guard_panno            
   , @l_nom_guard_itcircle            
   , @l_nom_guard_email            
   , @l_usertext1            
   , @l_usertext2            
   , @l_userfield1            
   , @l_userfield2            
  , @l_userfield3            
   , 0            
   , @l_modified            
FROM   #dp_holder_dtls1            
--            
set @l_nomgaufname = ''            
set @l_nomgaumname  = ''            
set @l_nomgaulname  = ''            
set @l_nomgauftname = ''            
set @l_title    =  ''            
set @l_suffix   = ''            
set @l_nom_guard_add1 = ''            
set @l_nom_guard_add2  = ''            
set @l_nom_guard_add3  = ''            
set @l_nom_guard_city  = ''            
set @l_nom_guard_state = ''            
set @l_nom_guard_country = ''            
set @l_nom_guard_pin    = ''            
set @l_nom_guard_teleindicator1 = ''            
set @l_nom_guard_tele1         = ''            
set @l_nom_guard_teleindicator2 = ''            
set @l_nom_guard_tele2          = ''            
set @l_nom_guard_tele3          = ''            
set @l_nom_guard_fax           = ''            
set @l_nom_guard_panno          = ''            
set @l_nom_guard_itcircle       = ''            
set @l_nom_guard_email          = ''            
set @l_usertext1                = ''            
set @l_usertext2                = ''            
set @l_userfield1               = 0            
set @l_userfield2               = 0            
set @l_userfield3               = 0            
--            
--            
end            
--FOR NOMINEE GUARDIAN            
-- FOR SECOND HOLDER POA            
SET @l_values               = ''            
--            
SELECT @l_values               = citrus_usr.fn_dp_mig_nsdl_dphd('ADDR',@c_dpam_id,'SH_POA_ADR')            
--            
SELECT @l_sh_poa_add1              = convert(varchar(30), citrus_usr.fn_splitval(@l_values,1))            
     , @l_sh_poa_add2              = convert(varchar(30), citrus_usr.fn_splitval(@l_values,2))            
     , @l_sh_poa_add3              = convert(varchar(30), citrus_usr.fn_splitval(@l_values,3))            
     , @l_sh_poa_city              = convert(varchar(25), citrus_usr.fn_splitval(@l_values,4))            
     , @l_sh_poa_state             = convert(varchar(25), citrus_usr.fn_splitval(@l_values,5))            
     , @l_sh_poa_country           = convert(varchar(25), citrus_usr.fn_splitval(@l_values,6))            
     , @l_sh_poa_pin               = convert(varchar(10), citrus_usr.fn_splitval(@l_values,7))            
--      
If ltrim(rtrim(isnull(@l_sh_poa_add1,'') ))       = ''  set @l_sh_poa_add1 = ''                  
If ltrim(rtrim(isnull(@l_sh_poa_add2,'') ))       = ''  set @l_sh_poa_add2 = ''            
If ltrim(rtrim(isnull(@l_sh_poa_add3,'') ))       = ''  set @l_sh_poa_add3 = ''            
If ltrim(rtrim(isnull(@l_sh_poa_city,'') ))       = ''  set @l_sh_poa_city = ''            
If ltrim(rtrim(isnull(@l_sh_poa_state,'') ))      = ''  set @l_nom_guard_state = ''            
If ltrim(rtrim(isnull(@l_sh_poa_country,'') ))    = ''  set @l_sh_poa_country = ''            
If ltrim(rtrim(isnull(@l_sh_poa_pin,'') ))        = ''  set @l_sh_poa_pin = ''            
--            
If ltrim(rtrim(isnull(@l_sh_poa_tele1 ,'') ))   = ''  set @l_sh_poa_tele1  = ''            
--            
SELECT @l_sh_poa_tele1            = isnull(convert(varchar(17), citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'RES_PH1')) ,'')            
SELECT @l_sh_poa_teleindicator1   = case when @l_sh_poa_tele1<>'' then 'R' else'M' end            
If ltrim(rtrim(isnull(@l_sh_poa_tele1 ,'') ))   = ''  set @l_sh_poa_tele1  = ''            
--            
SELECT @l_sh_poa_tele1             = isnull(convert(varchar(17), citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'SH_POA_RES')) ,'')            
SELECT @l_sh_poa_teleindicator1    = case when @l_sh_poa_tele1<> '' then 'R' else '' end            
If ltrim(rtrim(isnull(@l_sh_poa_tele1 ,'') ))   = ''  set @l_sh_poa_tele1  = ''            
--            
            
--            
SELECT @l_sh_poa_tele2             = isnull(convert(varchar(17), citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'SH_POA_MOB')) ,'')            
SELECT @l_sh_poa_teleindicator2    = case when @l_sh_poa_tele1 <> '' then 'M' else '' end            
If ltrim(rtrim(isnull(@l_sh_poa_tele2 ,'') ))   = ''  set @l_sh_poa_tele2  = ''            
--            
SELECT @l_sh_poa_tele3             = isnull(convert(varchar(100), citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'SH_POA_OFF')) ,'')            
If ltrim(rtrim(isnull(@l_sh_poa_tele3 ,'') ))   = ''  set @l_sh_poa_tele3  = ''            
--            
SELECT @l_sh_poa_fax               = isnull(convert(varchar(17), citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'SH_POA_FAX')),'')            
If ltrim(rtrim(isnull(@l_sh_poa_fax ,'') ))   = ''  set @l_sh_poa_fax  = ''            
--            
SELECT @l_sh_poa_panno             = dphd_sh_pan_no from #dp_holder_dtls1 --isnull(convert(varchar(25),value),'') FROM #account_properties WHERE code = 'SH_POA_PAN_GIR_NO'            
If ltrim(rtrim(isnull(@l_sh_poa_panno ,'') ))   = ''  set @l_sh_poa_panno  = ''            
--            
--            
SELECT @l_sh_poa_itcircle          = convert(varchar(25), value) FROM #account_properties WHERE code = 'SH_POA_IT'            
If ltrim(rtrim(isnull(@l_sh_poa_itcircle,'') ))   = ''  set @l_sh_poa_itcircle  = ''            
--            
SELECT @l_sh_poa_email             = isnull(convert(varchar(50), value),'')            
FROM   #conc                     WITH (NOLOCK)            
WHERE  code                    = 'SH_POA_MAIL'            
AND    pk                      = @c_crn_no            
--            
If ltrim(rtrim(isnull(@l_sh_poa_email,'') ))   = ''  set @l_sh_poa_email  = ''            
--            
SET @l_usertext1           = ''            
SET @l_usertext2           = ''            
SET @l_userfield1          = 0            
SET @l_userfield2          = 0            
SET @l_userfield3          = 0            
--            
SELECT @l_suffix              = ''            
--            
--SELECT @l_title               = citrus_usr.fn_get_listing('TITLE',value)  FROM #entity_properties  WHERE code = 'SH_POA_TITLE'            
--            
--SELECT @l_title               = convert(varchar(25), value) FROM #entity_properties WHERE code = 'TITLE'            
--            
SELECT @l_sechname            = convert(varchar(100), dphd_poa_fname)            
    , @l_sechmiddle          = convert(varchar(20), dphd_poa_mname)            
    , @l_sechlastname        = convert(varchar(20), dphd_poa_lname)            
    , @l_sechfname           = convert(varchar(20), dphd_poa_fthname)            
    , @l_title               = case when dphd_poa_gender = 'M'then 'MR'   when dphd_poa_gender = 'F'then 'MS' when dphd_poa_gender = '' then '' ELSE 'M/S' END            
FROM   #dp_holder_dtls1            
WHERE   dphd_dppd_hld         = '2ND HOLDER'            
--      
If ltrim(rtrim(isnull(@l_sechname,'') ))       = ''  set @l_sechname  = ''                  
If ltrim(rtrim(isnull(@l_sechmiddle,'') ))     = ''  set @l_sechmiddle  = ''            
If ltrim(rtrim(isnull(@l_sechlastname,'') ))   = ''  set @l_sechlastname = ''            
If ltrim(rtrim(isnull(@l_sechfname,'') ))      = ''  set @l_sechfname  = ''            
If ltrim(rtrim(isnull(@l_title,'') ))          = ''  set @l_title  = ''            
--            
IF exists(select * from client_otheraddress_hst where co_dpintrefno = @c_acct_no and co_cmpltd = 1)            
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
--            
IF @l_sechname <>''            
--            
if exists(select * from client_otheraddress where co_dpintrefno = @c_acct_no and co_cmpltd = 0)            
 begin            
 --            
delete from client_otheraddress where co_dpintrefno = @c_acct_no and co_cmpltd = 0 and co_purposecd = 13            
--            
--BEGIN            
--            
INSERT INTO client_otheraddress            
 ( co_dpintrefno            
 , co_cmcd            
 , co_purposecd            
 , co_name            
 , co_middlename            
 , co_searchname   , co_title            
 , co_suffix            
 , co_fhname            
 , co_add1            
 , co_add2            
 , co_add3            
 , co_city            
 , co_state            
 , co_country            
 , co_pin            
 , co_phind1            
 , co_tele1            
 , co_phind2            
 , co_tele2            
 , co_tele3            
 , co_fax            
 , co_panno            
 , co_itcircle            
 , co_email            
 , co_usertext1            
 , co_usertext2            
 , co_userfield1            
 , co_userfield2            
 , co_userfield3            
 , co_cmpltd            
 , co_edittype            
 )            
 SELECT @c_acct_no            
      , ''   -- @c_sba_no            
      , 13   --Second Holder Poa            
      , @l_sechname            
      , @l_sechmiddle            
      , @l_sechlastname            
      , @l_title            
      , @l_suffix            
      , @l_sechfname            
      , @l_sh_poa_add1            
      , @l_sh_poa_add2            
      , @l_sh_poa_add3            
      , @l_sh_poa_city            
      , @l_sh_poa_state            
      , @l_sh_poa_country            
      , @l_sh_poa_pin            
      , @l_sh_poa_teleindicator1            
      , @l_sh_poa_tele1            
      , @l_sh_poa_teleindicator2            
      , @l_sh_poa_tele2            
      , @l_sh_poa_tele3            
      , @l_sh_poa_fax            
      , @l_sh_poa_panno            
      , @l_sh_poa_itcircle            
      , @l_sh_poa_email            
      , @l_usertext1            
      , @l_usertext2            
      , @l_userfield1            
      , @l_userfield2            
      , @l_userfield3            
      , 0            
      , @l_modified            
     --            
     set @l_sechname = ''            
     set @l_sechmiddle = ''            
    set @l_sechlastname = ''            
     set @l_sechfname  = ''            
     set @l_title    =  ''            
     set @l_suffix   = ''            
     set @l_sh_poa_add1 = ''            
     set @l_sh_poa_add2  = ''            
     set @l_sh_poa_add3  = ''            
     set @l_sh_poa_city  = ''            
     set @l_sh_poa_state = ''            
     set @l_sh_poa_country = ''            
     set @l_sh_poa_pin    = ''            
     set @l_sh_poa_teleindicator1 = ''            
     set @l_sh_poa_tele1         = ''            
     set @l_sh_poa_teleindicator2 = ''            
     set @l_sh_poa_tele2          = ''            
     set @l_sh_poa_tele3         = ''            
     set @l_sh_poa_fax           = ''            
     set @l_sh_poa_panno         = ''            
     set @l_sh_poa_itcircle       = ''            
     set @l_sh_poa_email          = ''            
     set @l_usertext1            = ''            
     set @l_usertext2            = ''            
     set @l_userfield1           = 0            
     set @l_userfield2           = 0            
     set @l_userfield3           = 0            
     --            
     end            
     --            
     else            
     begin            
      --            
     INSERT INTO client_otheraddress            
     ( co_dpintrefno            
     , co_cmcd            
     , co_purposecd            
     , co_name            
     , co_middlename            
     , co_searchname            
     , co_title            
     , co_suffix            
     , co_fhname            
     , co_add1            
     , co_add2            
     , co_add3            
     , co_city            
     , co_state            
     , co_country            
     , co_pin            
     , co_phind1            
     , co_tele1            
     , co_phind2            
     , co_tele2            
     , co_tele3            
     , co_fax            
     , co_panno            
     , co_itcircle            
     , co_email            
     , co_usertext1            
     , co_usertext2            
     , co_userfield1            
     , co_userfield2            
     , co_userfield3            
     , co_cmpltd            
     , co_edittype            
 )            
     SELECT @c_acct_no            
          , ''   --@c_sba_no            
          , 13   --Second Holder Poa            
          , @l_sechname            
          , @l_sechmiddle            
          , @l_sechlastname            
          , @l_title            
          , @l_suffix            
          , @l_sechfname            
          , @l_sh_poa_add1            
          , @l_sh_poa_add2            
          , @l_sh_poa_add3            
          , @l_sh_poa_city            
          , @l_sh_poa_state            
          , @l_sh_poa_country            
          , @l_sh_poa_pin            
          , @l_sh_poa_teleindicator1            
          , @l_sh_poa_tele1            
          , @l_sh_poa_teleindicator2            
          , @l_sh_poa_tele2            
          , @l_sh_poa_tele3            
          , @l_sh_poa_fax            
          , @l_sh_poa_panno            
          , @l_sh_poa_itcircle            
          , @l_sh_poa_email            
          , @l_usertext1            
          , @l_usertext2            
          , @l_userfield1            
          , @l_userfield2            
          , @l_userfield3       
          , 0            
          , @l_modified            
          --            
          set @l_sechname = ''            
          set @l_sechmiddle = ''            
          set @l_sechlastname = ''            
          set @l_sechfname = ''            
          set @l_title    =  ''            
          set @l_suffix   = ''            
          set @l_sh_poa_add1 = ''            
          set @l_sh_poa_add2  = ''            
          set @l_sh_poa_add3  = ''            
          set @l_sh_poa_city  = ''            
          set @l_sh_poa_state = ''            
          set @l_sh_poa_country = ''            
          set @l_sh_poa_pin    = ''            
          set @l_sh_poa_teleindicator1 = ''            
          set @l_sh_poa_tele1         = ''            
          set @l_sh_poa_teleindicator2 = ''            
          set @l_sh_poa_tele2          = ''            
          set @l_sh_poa_tele3         = ''            
          set @l_sh_poa_fax           = ''            
          set @l_sh_poa_panno         = ''      
          set @l_sh_poa_itcircle       = ''            
          set @l_sh_poa_email          = ''            
          set @l_usertext1            = ''            
          set @l_usertext2            = ''            
          set @l_userfield1           = 0            
          set @l_userfield2           = 0            
          set @l_userfield3           = 0            
          --            
          --            
          end            
          --            
          -- FOR SECOND HOLDER POA            
            
          -- FOR THIRD HOLDER POA            
          --            
          SET @l_values        = ''            
          --            
          SELECT @l_values               = citrus_usr.fn_dp_mig_nsdl_dphd('ADDR',@c_dpam_id,'TH_POA_ADR')            
          --            
          SELECT @l_th_poa_add1               = convert(varchar(30), citrus_usr.fn_splitval(@l_values,1))            
               , @l_th_poa_add2              = convert(varchar(30), citrus_usr.fn_splitval(@l_values,2))            
               , @l_th_poa_add3              = convert(varchar(30), citrus_usr.fn_splitval(@l_values,3))            
               , @l_th_poa_city              = convert(varchar(25), citrus_usr.fn_splitval(@l_values,4))            
               , @l_th_poa_state             = convert(varchar(25), citrus_usr.fn_splitval(@l_values,5))            
               , @l_th_poa_country           = convert(varchar(25), citrus_usr.fn_splitval(@l_values,6))            
               , @l_th_poa_pin               = convert(varchar(10), citrus_usr.fn_splitval(@l_values,7))            
              --            
              --      
          If ltrim(rtrim(isnull(@l_th_poa_add1 ,'') ))      = ''  set @l_th_poa_add1  = ''                  
          If ltrim(rtrim(isnull(@l_th_poa_add2 ,'') ))      = ''  set @l_th_poa_add2  = ''            
          If ltrim(rtrim(isnull(@l_th_poa_add3,'') ))       = ''  set @l_th_poa_add3 = ''            
          If ltrim(rtrim(isnull(@l_th_poa_city ,'') ))      = ''  set @l_th_poa_city  = ''            
          If ltrim(rtrim(isnull(@l_th_poa_state,'') ))      = ''  set @l_th_poa_state = ''            
          If ltrim(rtrim(isnull(@l_th_poa_country ,'') ))   = ''  set @l_th_poa_country  = ''            
          If ltrim(rtrim(isnull(@l_th_poa_pin,'') ))        = ''  set @l_th_poa_pin = ''            
          --            
          SELECT @l_th_poa_tele1            = isnull(convert(varchar(17), citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'RES_PH1')) ,'')            
          SELECT @l_th_poa_teleindicator1   = case when @l_th_poa_tele1<>'' then 'R' else'M' end            
          If ltrim(rtrim(isnull(@l_th_poa_tele1,'') ))   = ''  set @l_th_poa_tele1  = ''            
          --            
          SELECT @l_th_poa_tele1             = isnull(convert(varchar(17), citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'TH_POA_RES')) ,'')            
          SELECT @l_th_poa_teleindicator1    = case when @l_th_poa_tele1 <> '' then 'R' else '' end            
  If ltrim(rtrim(isnull(@l_th_poa_tele1,'') ))   = ''  set @l_th_poa_tele1  = ''            
          --            
          --            
          SELECT @l_th_poa_tele2             = isnull(convert(varchar(17), citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'TH_POA_MOB')) ,'')            
          SELECT @l_th_poa_teleindicator2    = case when @l_th_poa_tele2 <> '' then 'M' else '' end            
          If ltrim(rtrim(isnull(@l_th_poa_tele2,'') ))   = ''  set @l_th_poa_tele2  = ''            
          --            
          SELECT @l_th_poa_tele3             = isnull(convert(varchar(100), citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'TH_POA_OFF')) ,'')            
          If ltrim(rtrim(isnull(@l_th_poa_tele3,'') ))   = ''  set @l_th_poa_tele3  = ''            
          --            
          SELECT @l_th_poa_fax               = isnull(convert(varchar(17), citrus_usr.fn_dp_mig_nsdl_dphd('CONC',@c_dpam_id,'TH_POA_FAX')),'')            
          If ltrim(rtrim(isnull(@l_th_poa_fax,'') ))   = ''  set @l_th_poa_fax  = ''            
          --            
          SELECT @l_th_poa_panno             = dphd_th_pan_no from #dp_holder_dtls1  ---isnull(convert(varchar(25),value),'') FROM #account_properties WHERE code = 'TH_POA_PAN_GIR_NO'            
          If ltrim(rtrim(isnull(@l_th_poa_panno,'') ))   = ''  set @l_th_poa_panno  = ''            
          --            
          --            
          SELECT @l_th_poa_itcircle         = convert(varchar(25), value) FROM #account_properties WHERE code = 'TH_POA_IT'            
          If ltrim(rtrim(isnull(@l_th_poa_itcircle,'') ))   = ''  set @l_th_poa_itcircle  = ''            
          --            
          SELECT @l_th_poa_email             = isnull(convert(varchar(50), value),'')            
          FROM   #conc                     WITH (NOLOCK)            
          WHERE  code                    = 'TH_POA_MAIL'            
          AND    pk                      = @c_crn_no            
          --            
          If ltrim(rtrim(isnull(@l_th_poa_email,'') ))   = ''  set @l_th_poa_email  = ''            
          --            
          SET @l_usertext1           = ''            
          SET @l_usertext2 = ''            
          SET @l_userfield1          = 0            
          SET @l_userfield2          = 0            
          SET @l_userfield3          = 0            
          --            
          SET @l_suffix              = ''            
          --            
          SELECT @l_thirdhname            = convert(varchar(100), dphd_poa_fname)            
               , @l_thirdhmiddle          = convert(varchar(20), dphd_poa_mname)            
               , @l_thirdhlastname        = convert(varchar(20), dphd_poa_lname)            
               , @l_thirdfname             = convert(varchar(20), dphd_poa_fthname)            
               , @l_title                 = case when dphd_poa_gender = 'M'then 'MR' when dphd_poa_gender = 'F'then 'MS' when dphd_poa_gender = '' then '' ELSE 'M/S' END            
          FROM   #dp_holder_dtls1            
          WHERE   dphd_dppd_hld         = '3RD HOLDER'            
          --      
          If ltrim(rtrim(isnull(@l_thirdhname,'') ))     = ''  set @l_thirdhname  = ''                  
          If ltrim(rtrim(isnull(@l_thirdhmiddle,'') ))     = ''  set @l_thirdhmiddle  = ''            
          If ltrim(rtrim(isnull(@l_thirdhlastname,'') ))   = ''  set @l_thirdhlastname = ''            
          If ltrim(rtrim(isnull(@l_thirdfname,'') ))       = ''  set @l_thirdfname  = ''            
          If ltrim(rtrim(isnull(@l_title,'') ))            = ''  set @l_title  = ''            
          --            
          IF exists(select * from client_otheraddress_hst where co_dpintrefno = @c_acct_no and co_cmpltd = 1)            
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
         --            
 IF @l_thirdhname  <>''            
         --            
         if exists(select * from client_otheraddress where co_dpintrefno = @c_acct_no and co_cmpltd = 0)            
         begin            
         --            
         delete from client_otheraddress where co_dpintrefno = @c_acct_no and co_cmpltd = 0 and co_purposecd = 14            
         --BEGIN            
         --            
         INSERT INTO client_otheraddress            
         ( co_dpintrefno            
         , co_cmcd            
         , co_purposecd            
         , co_name            
         , co_middlename            
         , co_searchname            
         , co_title            
         , co_suffix            
         , co_fhname            
         , co_add1            
         , co_add2            
        , co_add3            
         , co_city            
         , co_state            
         , co_country            
         , co_pin            
         , co_phind1            
         , co_tele1            
         , co_phind2            
         , co_tele2            
         , co_tele3            
         , co_fax            
         , co_panno            
         , co_itcircle            
         , co_email            
         , co_usertext1            
         , co_usertext2            
         , co_userfield1            
         , co_userfield2            
         , co_userfield3            
         , co_cmpltd            
         , co_edittype            
         )            
         SELECT @c_acct_no            
              , ''    -- @c_sba_no            
              , 14   --Third Holder Poa            
              , @l_thirdhname            
              , @l_thirdhmiddle            
              , @l_thirdhlastname            
              , @l_title            
              , @l_suffix            
              , @l_thirdfname            
              , @l_th_poa_add1            
              , @l_th_poa_add2            
              , @l_th_poa_add3            
              , @l_th_poa_city            
              , @l_th_poa_state            
              , @l_th_poa_country            
              , @l_th_poa_pin            
              , @l_th_poa_teleindicator1            
              , @l_th_poa_tele1            
              , @l_th_poa_teleindicator2            
              , @l_th_poa_tele2            
              , @l_th_poa_tele3            
              , @l_th_poa_fax            
              , @l_th_poa_panno            
              , @l_th_poa_itcircle            
              , @l_th_poa_email            
              , @l_usertext1            
              , @l_usertext2            
              , @l_userfield1            
              , @l_userfield2            
              , @l_userfield3            
              , 0            
              , @l_modified            
              --            
              set @l_thirdhname = ''           
              set @l_thirdhmiddle = ''            
              set @l_thirdhlastname = ''            
              set @l_thirdfname = ''            
              set @l_title    =  ''            
              set @l_suffix   = ''            
              set @l_th_poa_add1 = ''            
              set @l_th_poa_add2  = ''            
              set @l_th_poa_add3  = ''            
              set @l_th_poa_city  = ''            
              set @l_th_poa_state = ''            
              set @l_th_poa_country = ''            
              set @l_th_poa_pin    = ''            
              set @l_th_poa_teleindicator1 = ''            
              set @l_th_poa_tele1         = ''            
            set @l_th_poa_teleindicator2 = ''            
              set @l_th_poa_tele2          = ''            
              set @l_th_poa_tele3         = ''            
              set @l_th_poa_fax           = ''            
              set @l_th_poa_panno         = ''            
              set @l_th_poa_itcircle       = ''            
              set @l_th_poa_email          = ''            
              set @l_usertext1             = ''            
              set @l_usertext2             = ''            
              set @l_userfield1            = 0            
              set @l_userfield2            = 0            
              set @l_userfield3            = 0            
              --            
              end            
              --            
             else            
             begin            
             --            
             INSERT INTO client_otheraddress            
             ( co_dpintrefno            
             , co_cmcd            
             , co_purposecd            
             , co_name            
             , co_middlename            
             , co_searchname            
      , co_title            
             , co_suffix            
             , co_fhname            
             , co_add1            
             , co_add2            
             , co_add3            
             , co_city            
             , co_state            
             , co_country            
             , co_pin            
             , co_phind1            
             , co_tele1            
             , co_phind2            
             , co_tele2            
             , co_tele3            
             , co_fax            
             , co_panno            
             , co_itcircle            
             , co_email            
             , co_usertext1            
             , co_usertext2            
             , co_userfield1            
             , co_userfield2            
             , co_userfield3            
             , co_cmpltd            
             , co_edittype            
             )            
             SELECT @c_acct_no            
                  , ''   --@c_sba_no            
                  , 14   --Third Holder Poa            
                  , @l_thirdhname            
                  , @l_thirdhmiddle            
                  , @l_thirdhlastname            
                  , @l_title            
                  , @l_suffix            
                  , @l_thirdfname            
                  , @l_th_poa_add1            
                  , @l_th_poa_add2            
                  , @l_th_poa_add3            
                  , @l_th_poa_city            
                  , @l_th_poa_state            
                  , @l_th_poa_country            
                  , @l_th_poa_pin            
                  , @l_th_poa_teleindicator1            
                  , @l_th_poa_tele1            
                  , @l_th_poa_teleindicator2            
                  , @l_th_poa_tele2            
                  , @l_th_poa_tele3            
                  , @l_th_poa_fax            
                  , @l_th_poa_panno            
                  , @l_th_poa_itcircle            
                  , @l_th_poa_email            
                  , @l_usertext1            
                  , @l_usertext2            
                  , @l_userfield1            
                  , @l_userfield2            
                  , @l_userfield3            
                  , 0            
                  , @l_modified            
                  --            
                  set @l_thirdhname = ''            
                  set @l_thirdhmiddle = ''            
                  set @l_thirdhlastname = ''            
                  set @l_thirdfname = ''            
                  set @l_title    =  ''            
                  set @l_suffix   = ''            
                  set @l_th_poa_add1 = ''            
                  set @l_th_poa_add2  = ''            
                  set @l_th_poa_add3  = ''            
                  set @l_th_poa_city  = ''           
                  set @l_th_poa_state = ''            
                  set @l_th_poa_country = ''            
                  set @l_th_poa_pin    = ''            
                  set @l_th_poa_teleindicator1 = ''            
                  set @l_th_poa_tele1         = ''            
                  set @l_th_poa_teleindicator2 = ''            
                  set @l_th_poa_tele2          = ''            
                  set @l_th_poa_tele3        = ''            
                  set @l_th_poa_fax           = ''            
                  set @l_th_poa_panno    = ''            
                  set @l_th_poa_itcircle       = ''            
                  set @l_th_poa_email          = ''            
                  set @l_usertext1             = ''            
                  set @l_usertext2             = ''            
                  set @l_userfield1            = 0            
                  set @l_userfield2            = 0            
                  set @l_userfield3            = 0            
                  --            
                  --            
                  end            
                  -- FOR THIRD HOLDER POA            
                  -- FOR FH_ADR1            
                  IF EXISTS(SELECT code from #addr WHERE code = 'FH_ADR1')            
                  --            
                  BEGIN            
                  --            
                  SELECT @l_add1            = convert(varchar(36),add1)            
                        ,@l_add2            = convert(varchar(36),add2)            
                        ,@l_add3            = convert(varchar(36),add3)            
                        ,@l_city            = convert(varchar(36),city)            
                        ,@l_state           = convert(varchar(36),state)            
                        ,@l_country         = convert(varchar(36),country)            
                        ,@l_pin             = convert(varchar(7),pin)            
                        ,@l_code            = 'FH_ADR1'  --New code as suggested by reaymin            
                  FROM   #addr            
                  WHERE  code               = 'FH_ADR1'            
                  AND    pk                 = @c_crn_no            
                  --            
                  --      
                  If ltrim(rtrim(isnull(@l_add1,'') ))       = ''  set @l_add1 = ''                  
                  If ltrim(rtrim(isnull(@l_add2,'') ))       = ''  set @l_add2 = ''            
                  If ltrim(rtrim(isnull(@l_add3,'') ))       = ''  set @l_add3 = ''            
                  If ltrim(rtrim(isnull(@l_city,'') ))       = ''  set @l_city = ''            
                  If ltrim(rtrim(isnull(@l_state,'') ))      = ''  set @l_state = ''            
                  If ltrim(rtrim(isnull(@l_country,'') ))    = ''  set @l_country = ''            
                  If ltrim(rtrim(isnull(@l_pin,'') ))        = ''  set @l_pin = ''            
                  --            
                  SELECT @l_tele1     = ISNULL(convert(varchar(17), value),'')   from #conc WITH (NOLOCK)   WHERE  code = 'RES_PH1' AND pk = @c_crn_no            
                  SELECT @l_phind1    = case when @l_tele1 <> '' then 'R' else 'M' end            
                  If ltrim(rtrim(isnull(@l_tele1,'') ))   = ''  set @l_tele1  = ''            
                  --            
                  SELECT @l_tele1     = ISNULL(convert(varchar(17), value),'')   from #conc WITH (NOLOCK)   WHERE  code = 'NRI_FRN_RES' AND pk = @c_crn_no            
                  SELECT @l_phind1    = case when @l_tele1 <> '' then 'R' else '' end            
                  If ltrim(rtrim(isnull(@l_tele1,'') ))   = ''  set @l_tele1  = ''            
                  --            
                  --            
                  SELECT @l_tele2     = ISNULL(convert(varchar(17), value),'')   from #conc WITH (NOLOCK)   WHERE  code = 'NRI_FRN_MOB' AND pk = @c_crn_no            
                  SELECT @l_phind2    = case when @l_tele2 <> '' then 'M' else '' end            
                  If ltrim(rtrim(isnull(@l_tele2,'') ))   = ''  set @l_tele2  = ''            
                  --            
                  SELECT @l_tele3   = ISNULL(convert(varchar(17), value),'')   from #conc WITH (NOLOCK)   WHERE  code = 'NRI_FRN_OFF' AND pk = @c_crn_no            
                  If ltrim(rtrim(isnull(@l_tele3,'') ))   = ''  set @l_tele3  = ''            
                  --            
                  SELECT @l_fax                 = ISNULL(convert(varchar(17), value),'')            
                  FROM   #conc                    WITH (NOLOCK)            
                  WHERE  code                   = 'NRI_FRN_FAX'            
                  AND    pk                     = @c_crn_no            
                  --            
                  If ltrim(rtrim(isnull(@l_fax,'') ))   = ''  set @l_fax  = ''            
                  --            
              SELECT @l_panno             = isnull(convert(varchar(25),value),'') FROM #entity_properties WHERE code = 'NRI_PAN_GIR_NO'            
                  If ltrim(rtrim(isnull(@l_panno,'') ))   = ''  set @l_panno  = ''            
                  --            
                  SELECT @l_itcircle          = convert(varchar(25), value) FROM #entity_properties WHERE code = 'NRI_FRN_IT'            
                  If ltrim(rtrim(isnull(@l_itcircle,'') ))   = ''  set @l_itcircle  = ''            
                  --            
                  SELECT @l_email             = isnull(convert(varchar(50), value),'')            
                  FROM   #conc                     WITH (NOLOCK)            
                  WHERE  code                    = 'NRI_FRN_MAIL'            
                  AND    pk                      = @c_crn_no            
                  --            
                  If ltrim(rtrim(isnull(@l_email,'') ))   = ''  set @l_email  = ''            
                  --            
                  SET @l_usertext1           = ''            
                  SET @l_usertext2           = ''            
                  SET @l_userfield1          = 0            
                  SET @l_userfield2          = 0            
                  SET @l_userfield3          = 0            
                  --            
                  SELECT @l_suffix = ''            
                  SELECT @l_name                = convert(varchar(100), clim.clim_name1+' '+clim.clim_short_name)            
                       , @l_middlename          = convert(varchar(20), clim.clim_name2)            
                       , @l_lastname            = convert(varchar(20), clim.clim_name3)            
                       , @l_fathername          = convert(varchar(20), dphd.dphd_fh_fthname)            
                       , @l_title               = case when clim.clim_gender = 'M'then 'MR' when clim.clim_gender = 'F'then 'MS' ELSE '' END            
                  FROM   client_mstr              clim  WITH (NOLOCK)            
                       , dp_acct_mstr             dpam  WITH (NOLOCK)            
                       , client_ctgry_mstr        clicm WITH (NOLOCK)            
                       , dp_holder_dtls           dphd  WITH (NOLOCK)            
                  WHERE  clim.clim_crn_no       = @c_crn_no            
                  AND    clim.clim_crn_no       = dpam.dpam_crn_no            
                  AND    dpam.dpam_clicm_cd     = clicm.clicm_cd            
                  AND    dpam.dpam_id           = @c_dpam_id         
                  AND    dphd.dphd_dpam_id      = dpam.dpam_id           
                  AND    clim.clim_deleted_ind  = 1            
                  AND    dpam.dpam_deleted_ind  = 1            
                  --      
                  If ltrim(rtrim(isnull(@l_name,'') ))         = ''  set @l_name  = ''                  
                  If ltrim(rtrim(isnull(@l_middlename,'') ))   = ''  set @l_middlename  = ''            
                  If ltrim(rtrim(isnull(@l_lastname,'') ))     = ''  set @l_lastname  = ''            
                  If ltrim(rtrim(isnull(@l_fathername,'') ))   = ''  set @l_fathername  = ''            
                  If ltrim(rtrim(isnull(@l_title,'') ))        = ''  set @l_title  = ''            
                  --            
                  IF exists(select * from client_otheraddress_hst where co_dpintrefno = @c_acct_no and co_cmpltd = 1)            
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
                  --            
                  IF @l_name  <>''            
                  --          
                  If exists(select * from client_otheraddress where co_dpintrefno = @c_acct_no and co_cmpltd = 0)            
                  Begin            
                  --            
                  Delete from client_otheraddress where co_dpintrefno = @c_acct_no and co_cmpltd = 0  and co_purposecd = 10            
                  --            
            INSERT INTO client_otheraddress            
                  ( co_dpintrefno            
                  , co_cmcd            
                  , co_purposecd            
                  , co_name            
                  , co_middlename            
                  , co_searchname            
                  , co_title            
                  , co_suffix            
                  , co_fhname            
                  , co_add1            
                  , co_add2            
                  , co_add3            
                  , co_city            
                  , co_state            
                  , co_country            
                  , co_pin            
                  , co_phind1            
                  , co_tele1            
                  , co_phind2            
                  , co_tele2            
                  , co_tele3            
                  , co_fax            
                  , co_panno            
                  , co_itcircle            
                  , co_email            
                  , co_usertext1            
                  , co_usertext2            
                  , co_userfield1            
                  , co_userfield2            
                  , co_userfield3            
                  , co_cmpltd            
                  , co_edittype            
                  )            
                  SELECT            
                   @c_acct_no            
                  ,''   --@c_sba_no            
                  ,10   --10/11/12   --Nri Foreign Address,Nri Indian Address,Client Address            
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
                  ,@l_phind1            
                  ,@l_tele1            
                  ,@l_phind2            
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
                  ,0            
                  ,@l_modified            
                  --            
                  SET @l_name =''            
                  SET @l_middlename =''            
                  SET @l_lastname =''            
                  set @l_fathername = ''            
                  set @l_title    =  ''            
                  set @l_suffix   = ''            
                  set @l_add1 = ''            
                  set @l_add2  = ''            
                  set @l_add3  = ''            
                  set @l_city  = ''            
                  set @l_state = ''            
                  set @l_country = ''            
                  set @l_pin    = ''            
                  set @l_phind1 = ''            
                  set @l_tele1         = ''            
                  set @l_phind2 = ''            
  set @l_tele2      = ''            
                  set @l_tele3          = ''            
                  set @l_fax           = ''            
                  set @l_panno          = ''            
                  set @l_itcircle      = ''            
                  set @l_email          = ''            
                  set @l_usertext1   = ''            
                  set @l_usertext2    = ''            
                  set @l_userfield1  = 0            
                  set @l_userfield2  = 0            
                  set @l_userfield3  = 0            
                  --            
                  END            
                  --            
                  else            
                  begin            
                  --            
                  INSERT INTO client_otheraddress            
                  ( co_dpintrefno            
                  , co_cmcd            
                  , co_purposecd            
                  , co_name            
                  , co_middlename            
                  , co_searchname            
                  , co_title            
   , co_suffix            
                  , co_fhname            
                  , co_add1            
                  , co_add2            
                  , co_add3            
                  , co_city            
                  , co_state            
                  , co_country            
                  , co_pin            
                  , co_phind1            
                  , co_tele1            
                  , co_phind2            
                  , co_tele2            
                  , co_tele3            
                  , co_fax            
                  , co_panno            
                  , co_itcircle            
                  , co_email            
                  , co_usertext1            
                  , co_usertext2            
                  , co_userfield1            
                  , co_userfield2            
                  , co_userfield3            
                  , co_cmpltd            
                  , co_edittype            
                  )            
                  SELECT            
                  @c_acct_no            
                  , ''  --@c_sba_no            
                  ,10   --10/11/12   --Nri Foreign Address,Nri Indian Address,Client Address            
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
                  ,@l_phind1            
                  ,@l_tele1            
                  ,@l_phind2            
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
                  ,0            
                  ,@l_modified            
                  --            
                  SET @l_name =''            
                  SET @l_middlename =''            
                  SET @l_lastname =''            
                  set @l_fathername = ''            
                  set @l_title    =  ''            
                  set @l_suffix   = ''            
                  set @l_add1 = ''            
                  set @l_add2  = ''            
                  set @l_add3  = ''            
                  set @l_city  = ''            
                  set @l_state = ''            
                  set @l_country = ''            
                  set @l_pin    = ''            
                  set @l_phind1 = ''            
                  set @l_tele1         = ''            
                  set @l_phind2 = ''            
                  set @l_tele2          = ''            
                  set @l_tele3          = ''            
                  set @l_fax           = ''            
                  set @l_panno          = ''            
                  set @l_itcircle      = ''            
                  set @l_email          = ''            
                  set @l_usertext1   = ''            
                  set @l_usertext2    = ''            
                  set @l_userfield1  = 0            
                  set @l_userfield2  = 0            
                  set @l_userfield3  = 0            
                  --            
                  End            
                  --            
                  END            
                   --            
                 IF EXISTS(SELECT code from #addr WHERE code = 'NRI_ADR')            
                 BEGIN            
                 --            
     SELECT @l_add1            = convert(varchar(36),add1)            
          ,@l_add2            = convert(varchar(36),add2)            
          ,@l_add3            = convert(varchar(36),add3)            
          ,@l_city            = convert(varchar(36),city)            
          ,@l_state           = convert(varchar(36),state)            
          ,@l_country         = convert(varchar(36),country)            
          ,@l_pin             = convert(varchar(7),pin)            
          ,@l_code            = 'NRI_ADR'            
     FROM   #addr            
     WHERE  code               = 'NRI_ADR'            
     AND    pk                 = @c_crn_no            
--            
                 --      
                 If ltrim(rtrim(isnull(@l_add1,'') ))      = ''  set @l_add1 = ''                  
                 If ltrim(rtrim(isnull(@l_add2,'') ))      = ''  set @l_add2 = ''            
                 If ltrim(rtrim(isnull(@l_add3,'') ))      = ''  set @l_add3 = ''            
                 If ltrim(rtrim(isnull(@l_city,'') ))      = ''  set @l_city = ''            
         If ltrim(rtrim(isnull(@l_state,'') ))     = ''  set @l_state = ''            
                 If ltrim(rtrim(isnull(@l_country,'') ))   = ''  set @l_country = ''            
                 If ltrim(rtrim(isnull(@l_pin,'') ))        = '' set @l_pin = ''            
    --            
    SELECT @l_tele1     = ISNULL(convert(varchar(17), value),'')   from #conc WITH (NOLOCK)   WHERE  code = 'RES_PH1' AND pk = @c_crn_no            
    SELECT @l_phind1    = case when @l_tele1 <> '' then 'R' else 'M' end            
    If ltrim(rtrim(isnull(@l_tele1,'') ))   = ''  set @l_tele1  = ''            
    --            
    SELECT @l_tele1     = ISNULL(convert(varchar(17), value),'')   from #conc WITH (NOLOCK)   WHERE  code = 'NRI_IND_RES' AND pk = @c_crn_no            
    SELECT @l_phind1    = case when @l_tele1 <> '' then 'R' else '' end            
    If ltrim(rtrim(isnull(@l_tele1,'') ))   = ''  set @l_tele1  = ''            
                 --            
                 --            
    SELECT @l_tele2     = ISNULL(convert(varchar(17), value),'')   from #conc WITH (NOLOCK)   WHERE  code = 'NRI_IND_MOB' AND pk = @c_crn_no            
    SELECT @l_phind2    = case when @l_tele2<>'' then 'M' else '' end            
    If ltrim(rtrim(isnull(@l_tele2,'') ))   = ''  set @l_tele2  = ''            
                 --            
                 SELECT @l_tele3               = ISNULL(convert(varchar(17), value),'')   from #conc WITH (NOLOCK)   WHERE  code = 'NRI_IND_OFF' AND pk = @c_crn_no            
                 If ltrim(rtrim(isnull(@l_tele3,'') ))   = ''  set @l_tele3  = ''            
                 --         
                 SELECT @l_fax                 = ISNULL(convert(varchar(17), value),'')            
                 FROM   #conc                    WITH (NOLOCK)            
                 WHERE  code                   = 'NRI_IND_FAX'            
                 AND    pk  = @c_crn_no            
                 --            
                 If ltrim(rtrim(isnull(@l_fax,'') ))   = ''  set @l_fax  = ''            
                 --            
                 SELECT @l_panno             = isnull(convert(varchar(25),value),'') FROM #entity_properties WHERE code = 'NRI_PAN_GIR_NO'            
                 If ltrim(rtrim(isnull(@l_panno,'') ))   = ''  set @l_panno  = ''            
                 --            
                 SELECT @l_itcircle          = convert(varchar(25), value) FROM #entity_properties WHERE code = 'NRI_IND_IT'            
                 If ltrim(rtrim(isnull(@l_itcircle,'') ))   = ''  set @l_itcircle  = ''            
                 --            
                 SELECT @l_email             = isnull(convert(varchar(50), value),'')            
                 FROM   #conc                     WITH (NOLOCK)            
                 WHERE  code                    = 'NRI_IND_MAIL'            
                 AND    pk                      = @c_crn_no            
                 --            
                 If ltrim(rtrim(isnull(@l_email,'') ))   = ''  set @l_email  = ''            
                 --            
                 SELECT @l_usertext1           = ''            
                 SELECT @l_usertext2           = ''            
                 SELECT @l_userfield1          = 0            
                 SELECT @l_userfield2          = 0            
                 SELECT @l_userfield3          = 0            
                 --            
                 SELECT @l_suffix              = ''            
                 --            
                 --            
                 SELECT @l_name                = convert(varchar(100), clim.clim_name1+' '+clim.clim_short_name)            
                      , @l_middlename          = convert(varchar(20), clim.clim_name2)            
                      , @l_lastname            = convert(varchar(20), clim.clim_name3)            
                      , @l_fathername          = convert(varchar(20), dphd.dphd_fh_fthname)            
                      , @l_title               = case when clim.clim_gender = 'M'then 'MR' when clim.clim_gender = 'F'then 'MS' ELSE '' END            
                 FROM   client_mstr              clim  WITH (NOLOCK)            
                      , dp_acct_mstr             dpam  WITH (NOLOCK)            
                      , client_ctgry_mstr        clicm WITH (NOLOCK)            
                      , dp_holder_dtls           dphd  WITH (NOLOCK)            
                 WHERE  clim.clim_crn_no       = @c_crn_no            
                 AND    clim.clim_crn_no       = dpam.dpam_crn_no            
                 AND    dpam.dpam_clicm_cd     = clicm.clicm_cd            
                 AND    dpam.dpam_id           = @c_dpam_id            
                 AND    dphd.dphd_dpam_id      = dpam.dpam_id        
                 AND    clim.clim_deleted_ind  = 1            
                 AND    dpam.dpam_deleted_ind  = 1            
                 --      
                 If ltrim(rtrim(isnull(@l_name,'') ))   = ''  set @l_name  = ''                  
                 If ltrim(rtrim(isnull(@l_middlename,'') ))   = ''  set @l_middlename  = ''            
                 If ltrim(rtrim(isnull(@l_lastname,'') ))     = ''  set @l_lastname  = ''            
                 If ltrim(rtrim(isnull(@l_fathername,'') ))   = ''  set @l_fathername  = ''            
                 If ltrim(rtrim(isnull(@l_title,'') ))        = ''  set @l_title  = ''            
                 --            
                 -- INSERT PART            
                 IF exists(select * from client_otheraddress_hst where co_dpintrefno = @c_acct_no and co_cmpltd = 1)            
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
                 --            
                 IF @l_Name <> ''            
                 If exists(select * from client_otheraddress where co_dpintrefno = @c_acct_no and co_cmpltd = 0)            
                 Begin            
                 --            
                 Delete from client_otheraddress where co_dpintrefno = @c_acct_no and co_cmpltd = 0 and co_purposecd = 11            
                 INSERT INTO client_otheraddress            
                 ( co_dpintrefno            
                 , co_cmcd            
                 , co_purposecd            
                 , co_name            
                 , co_middlename            
                 , co_searchname            
                 , co_title            
                 , co_suffix            
                 , co_fhname            
                 , co_add1            
                 , co_add2            
                 , co_add3            
                 , co_city            
                 , co_state            
                 , co_country            
                 , co_pin            
                 , co_phind1            
                 , co_tele1            
                 , co_phind2            
                 , co_tele2            
                 , co_tele3            
                 , co_fax            
                 , co_panno            
                 , co_itcircle            
                 , co_email            
                 , co_usertext1            
                 , co_usertext2            
                 , co_userfield1            
                 , co_userfield2            
                 , co_userfield3            
                 , co_cmpltd            
                 , co_edittype            
                 )            
                 SELECT            
                  @c_acct_no            
                 ,''   --@c_sba_no            
                 ,11   --10/11/12   --Nri Foreign Address,Nri Indian Address,Client Address            
                 ,@l_name            
                 ,@l_middlename            
                 ,@l_lastname            
                 ,@l_title                       ,@l_suffix            
                 ,@l_fathername            
                 ,@l_add1            
                 ,@l_add2            
                 ,@l_add3            
                 ,@l_city            
                 ,@l_state            
                 ,@l_country            
                 ,@l_pin            
                 ,@l_phind1            
                 ,@l_tele1            
                 ,@l_phind2            
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
                 ,0            
                 ,@l_modified            
                 --            
                 SET @l_name   = ''            
                 SET @l_middlename  = ''            
                 SET @l_lastname  = ''            
                 set @l_fathername  = ''            
                 set @l_title     = ''            
                 set @l_suffix    = ''            
                 set @l_add1   = ''            
                 set @l_add2    = ''            
           set @l_add3    = ''            
                 set @l_city    = ''            
                 set @l_state   = ''            
                 set @l_country  = ''            
                 set @l_pin      = ''            
                 set @l_phind1   = ''            
                 set @l_tele1          = ''            
                 set @l_phind2   = ''            
                 set @l_tele2           = ''            
                 set @l_tele3           = ''            
                 set @l_fax            = ''            
                 set @l_panno           = ''            
                 set @l_itcircle       = ''            
                 set @l_email           = ''            
                 set @l_usertext1    = ''            
                 set @l_usertext2     = ''            
                 set @l_userfield1   = 0            
                 set @l_userfield2   = 0            
                 set @l_userfield3   = 0            
                 --            
                 END            
                 --            
                 else            
                 begin            
                 --            
                 INSERT INTO client_otheraddress            
                 ( co_dpintrefno            
            , co_cmcd            
                 , co_purposecd            
                 , co_name            
                 , co_middlename            
                 , co_searchname            
                 , co_title            
                 , co_suffix            
                 , co_fhname            
                 , co_add1            
                 , co_add2            
                 , co_add3            
                 , co_city            
                 , co_state            
                 , co_country            
                 , co_pin            
                 , co_phind1            
                 , co_tele1            
                 , co_phind2            
                 , co_tele2            
                 , co_tele3            
                 , co_fax            
                 , co_panno            
                 , co_itcircle            
                 , co_email            
                 , co_usertext1            
                 , co_usertext2            
                 , co_userfield1            
                 , co_userfield2            
                 , co_userfield3            
                 , co_cmpltd            
                 , co_edittype            
                 )            
                 SELECT            
                  @c_acct_no            
                 ,''   --@c_sba_no            
                 ,11   --10/11/12   --Nri Foreign Address,Nri Indian Address,Client Address            
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
                 ,@l_phind1            
                 ,@l_tele1            
                 ,@l_phind2            
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
                 ,0            
                 ,@l_modified            
                 --            
                 SET @l_name =''            
     SET @l_middlename =''            
                 SET @l_lastname =''            
                 set @l_fathername = ''            
                 set @l_title    =  ''            
                 set @l_suffix   = ''            
                 set @l_add1 = ''            
                 set @l_add2  = ''            
                 set @l_add3  = ''            
                 set @l_city  = ''            
                 set @l_state = ''            
                 set @l_country = ''            
                 set @l_pin    = ''            
                 set @l_phind1 = ''            
                 set @l_tele1         = ''            
                 set @l_phind2 = ''            
                 set @l_tele2          = ''            
                 set @l_tele3          = ''            
                 set @l_fax           = ''            
                 set @l_panno          = ''            
                 set @l_itcircle      = ''            
                 set @l_email          = ''            
                 set @l_usertext1   = ''            
                 set @l_usertext2    = ''            
                 set @l_userfield1  = 0            
                 set @l_userfield2  = 0            
                 set @l_userfield3  = 0            
                 --            
                 End     -- INSERT PART            
                 --            
                 END    -- FOR NRI_INDIAN            
            
                 --  For Correspondence address            
                 IF EXISTS(SELECT code from #addr WHERE code = 'COR_ADR1')            
                 --            
                 BEGIN            
     --            
                 SELECT @l_add1            = convert(varchar(36),add1)            
                       ,@l_add2            = convert(varchar(36),add2)            
                       ,@l_add3            = convert(varchar(36),add3)            
                       ,@l_city            = convert(varchar(36),city)            
                       ,@l_state           = convert(varchar(36),state)            
                       ,@l_country         = convert(varchar(36),country)            
                       ,@l_pin             = convert(varchar(7),pin)            
                       ,@l_code            = 'COR_ADR1'            
                 FROM   #addr            
                 WHERE  code               = 'COR_ADR1'            
                 AND    pk                 = @c_crn_no            
                 --      
                 If ltrim(rtrim(isnull(@l_add1,'') ))      = ''  set @l_add1  = ''                  
                 If ltrim(rtrim(isnull(@l_add2,'') ))      = ''  set @l_add2  = ''            
                 If ltrim(rtrim(isnull(@l_add3,'') ))      = ''  set @l_add3  = ''            
                 If ltrim(rtrim(isnull(@l_city,'') ))      = ''  set @l_city  = ''            
                 If ltrim(rtrim(isnull(@l_state ,'') ))    = ''  set @l_state   = ''            
                 If ltrim(rtrim(isnull(@l_country,'') ))   = ''  set @l_country  = ''            
                 If ltrim(rtrim(isnull(@l_pin,'') ))       = ''  set @l_pin  = ''            
                 --            
    SELECT @l_tele1     = ISNULL(convert(varchar(17), value),'')  from #conc WITH (NOLOCK)   WHERE  code = 'RES_PH1' AND pk = @c_crn_no                            
    If ltrim(rtrim(isnull(@l_tele1,'') ))   = ''  set @l_tele1  = ''    
    SELECT @l_phind1    = case when @l_tele1 <> '' then 'R' else '' end            
    --SELECT @l_phind1      = Case when @l_tele1='' then '' when  @l_tele1='NULL' then '' else 'R' end --vivek/jitesh on 6 feb    
                
    --            
    SELECT @l_tele2     = ISNULL(convert(varchar(17), value),'')   from #conc WITH (NOLOCK)   WHERE  code = 'MOBILE1' AND pk = @c_crn_no            
    If ltrim(rtrim(isnull(@l_tele2,'') ))   = ''  set @l_tele2  = ''         
    SELECT @l_phind2    = case when @l_tele2<>'' then 'M' else '' end                                
    -- SELECT @l_phind2     = Case when @l_tele2='' then '' when  @l_tele1='NULL' then '' else 'M' end    
        
     --            
              if  (@l_tele2<>'' and @l_tele1='')        
                Begin          
                 SET  @l_tele2  = ''        
                 SET  @l_phind2 = ''        
                 SET  @l_tele1  = ''        
                 SET  @l_phind1 = ''                         
                 SELECT @l_tele1     = ISNULL(convert(varchar(17), value),'')   from #conc WITH (NOLOCK)   WHERE  code = 'MOBILE1' AND pk = @c_crn_no            
                 SELECT @l_phind1    = case when @l_tele1 <> '' then 'M' else '' end                                
                 If ltrim(rtrim(isnull(@l_tele2,'') ))   = ''  set @l_tele2  = ''      
                 If ltrim(rtrim(isnull(@l_tele1,'') ))   = ''  set @l_tele1  = ''      
                End        
              --        
    SELECT @l_tele3               = ISNULL(convert(varchar(17), value),'')   from #conc WITH (NOLOCK)   WHERE  code = 'OFF_PH1' AND pk = @c_crn_no            
    If ltrim(rtrim(isnull(@l_tele3,'') ))   = ''  set @l_tele3  = ''            
       --            
		    SELECT @l_fax                 = ISNULL(convert(varchar(17), value),'')            
		    FROM   #conc                    WITH (NOLOCK)            
		    WHERE  code                   = 'FAX1'            
		    AND    pk                     = @c_crn_no            
                 --            
                 If ltrim(rtrim(isnull(@l_fax,'') ))   = ''  set @l_fax  = ''            
                 --            
                 SELECT @l_panno             = isnull(convert(varchar(25),value),'') FROM #entity_properties WHERE code = 'PAN_GIR_NO'            
                 If ltrim(rtrim(isnull(@l_panno,'') ))   = ''  set @l_panno  = ''            
                 --            
                 SELECT @l_itcircle          = convert(varchar(25), value) FROM #entity_properties WHERE code = 'CLIENT_IT'            
                 If ltrim(rtrim(isnull(@l_itcircle,'') ))   = ''  set @l_itcircle  = ''            
                 --            
                 SELECT @l_email             = isnull(convert(varchar(50), value),'')            
                 FROM   #conc                     WITH (NOLOCK)            
                 WHERE  code                    = 'EMAIL1'            
                 AND    pk                      = @c_crn_no            
                 --            
                 If ltrim(rtrim(isnull(@l_email,'') ))   = ''  set @l_email  = ''            
                 --            
                 SELECT @l_usertext1           = ''            
                 SELECT @l_usertext2           = ''            
                 SELECT @l_userfield1          = 0            
                 SELECT @l_userfield2          = 0            
                 SELECT @l_userfield3          = 0            
                 --            
                 SELECT @l_suffix              = ''            
                 --            
                 --            
                 SELECT @l_name                = convert(varchar(100), clim.clim_name1+' '+clim.clim_short_name)            
                      , @l_middlename          = convert(varchar(20), clim.clim_name2)            
                      , @l_lastname            = convert(varchar(20), clim.clim_name3)            
                      , @l_fathername          = convert(varchar(20), dphd.dphd_fh_fthname)            
                      , @l_title               = case when clim.clim_gender = 'M'then 'MR' when clim.clim_gender = 'F'then 'MS' ELSE '' END            
                 FROM   client_mstr              clim  WITH (NOLOCK)            
                      , dp_acct_mstr             dpam  WITH (NOLOCK)            
                      , client_ctgry_mstr        clicm WITH (NOLOCK)            
                      , dp_holder_dtls           dphd  WITH (NOLOCK)            
                 WHERE  clim.clim_crn_no       = @c_crn_no            
                 AND    clim.clim_crn_no       = dpam.dpam_crn_no            
                 AND    dpam.dpam_clicm_cd     = clicm.clicm_cd            
                 AND    dpam.dpam_id           = @c_dpam_id            
                 AND    dphd.dphd_dpam_id      = dpam.dpam_id        
                 AND    clim.clim_deleted_ind  = 1            
                 AND    dpam.dpam_deleted_ind  = 1            
                 --            
                 END            
                 --      
                 If ltrim(rtrim(isnull(@l_name,'') ))         = ''  set @l_name  = ''                  
                 If ltrim(rtrim(isnull(@l_middlename,'') ))   = ''  set @l_middlename  = ''            
                 If ltrim(rtrim(isnull(@l_lastname,'') ))     = ''  set @l_lastname  = ''            
                 If ltrim(rtrim(isnull(@l_fathername,'') ))   = ''  set @l_fathername  = ''            
                 If ltrim(rtrim(isnull(@l_title,'') ))        = ''  set @l_title  = ''       
                 --            
                 IF exists(select * from client_otheraddress_hst where co_dpintrefno = @c_acct_no and co_cmpltd = 1)            
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
                 --            
                 IF @l_name  <>''            
                 --            
                 If exists(select * from client_otheraddress where co_dpintrefno = @c_acct_no and co_cmpltd = 0)            
                 Begin            
                 --            
                 Delete from client_otheraddress where co_dpintrefno = @c_acct_no and co_cmpltd = 0 and co_purposecd = 12            
                 --            
                 INSERT INTO client_otheraddress            
                 ( co_dpintrefno            
                 , co_cmcd            
                 , co_purposecd            
                 , co_name            
                 , co_middlename            
                 , co_searchname            
                 , co_title            
            , co_suffix            
                 , co_fhname            
                 , co_add1            
                 , co_add2            
                 , co_add3            
                 , co_city            
                 , co_state            
                 , co_country            
                 , co_pin            
                 , co_phind1            
                 , co_tele1            
                 , co_phind2            
                 , co_tele2            
                 , co_tele3            
                 , co_fax            
                 , co_panno            
                 , co_itcircle            
                 , co_email            
                 , co_usertext1            
                 , co_usertext2            
                 , co_userfield1            
                 , co_userfield2            
                 , co_userfield3            
                 , co_cmpltd            
                 , co_edittype            
                 )            
                 SELECT            
                  @c_acct_no            
                 ,'' --- @c_sba_no            
                 ,12   --10/11/12   --Nri Foreign Address,Nri Indian Address,Client Address            
                 ,@l_name            
                 ,@l_middlename            
                 ,@l_lastname            
                 ,@l_title            
                 ,@l_suffix            
                 ,@l_fathername            
                 ,@l_add1            
                 ,@l_add2                             ,@l_add3            
                 ,@l_city            
                 ,@l_state            
                 ,@l_country            
                 ,@l_pin            
                 ,@l_phind1            
                 ,@l_tele1            
                 ,@l_phind2            
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
                 ,0            
                 ,@l_modified            
                 --            
                 SET @l_name =''            
                 SET @l_middlename =''            
                 SET @l_lastname =''            
                 set @l_fathername = ''            
                 set @l_title    =  ''            
                 set @l_suffix   = ''            
                 set @l_add1 = ''            
                 set @l_add2  = ''            
                 set @l_add3  = ''            
                 set @l_city  = ''            
                 set @l_state = ''            
                 set @l_country = ''            
                 set @l_pin    = ''            
                 set @l_phind1 = ''            
                 set @l_tele1         = ''            
                 set @l_phind2 = ''            
                 set @l_tele2          = ''            
                 set @l_tele3          = ''            
                 set @l_fax           = ''            
                 set @l_panno          = ''            
                 set @l_itcircle      = ''            
                 set @l_email          = ''            
                 set @l_usertext1   = ''            
                 set @l_usertext2    = ''            
                 set @l_userfield1  = 0            
                 set @l_userfield2  = 0            
                 set @l_userfield3  = 0            
                 --            
                 END            
                 --            
                 else            
                 begin            
                 --            
                 INSERT INTO client_otheraddress            
                 ( co_dpintrefno            
                 , co_cmcd            
                 , co_purposecd            
                 , co_name            
                 , co_middlename            
                 , co_searchname            
                 , co_title            
                 , co_suffix            
                 , co_fhname            
                 , co_add1            
                 , co_add2            
                 , co_add3            
                 , co_city            
                 , co_state            
                 , co_country            
                 , co_pin            
                 , co_phind1            
                 , co_tele1            
                 , co_phind2            
                 , co_tele2            
                 , co_tele3            
                 , co_fax            
                 , co_panno            
                 , co_itcircle            
                 , co_email            
                 , co_usertext1            
                 , co_usertext2            
                 , co_userfield1            
                 , co_userfield2            
                 , co_userfield3            
                 , co_cmpltd            
                 , co_edittype            
                 )            
                  SELECT            
                   @c_acct_no            
                  ,'' -- @c_sba_no            
                  ,12   --10/11/12   --Nri Foreign Address,Nri Indian Address,Client Address   
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
                  ,@l_phind1            
                  ,@l_tele1            
                  ,@l_phind2            
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
                  ,0            
                  ,@l_modified            
                  --            
                  SET @l_name =''            
                  SET @l_middlename =''            
                  SET @l_lastname =''            
                  set @l_fathername = ''            
                  set @l_title    =  ''            
set @l_suffix   = ''            
                  set @l_add1 = ''            
                  set @l_add2  = ''            
                  set @l_add3  = ''            
                  set @l_city  = ''            
                  set @l_state = ''            
                  set @l_country = ''            
                  set @l_pin    = ''            
                  set @l_phind1 = ''            
                  set @l_tele1         = ''            
                  set @l_phind2 = ''            
                  set @l_tele2          = ''            
                  set @l_tele3          = ''            
                  set @l_fax           = ''          
                  set @l_panno          = ''            
                  set @l_itcircle      = ''            
                  set @l_email          = ''            
                  set @l_usertext1   = ''            
                  set @l_usertext2    = ''            
                  set @l_userfield1  = 0            
                  set @l_userfield2  = 0            
                  set @l_userfield3  = 0            
                  End            
            
                 --            
                 --  For Correspondence address            
                 --            
                 FETCH NEXT FROM @c_cursor INTO @c_crn_no, @c_dpam_id, @c_acct_no, @c_sba_no            
                 --            
                 END  --cursor,while fetch status is not zero            
                 --            
                 CLOSE @c_cursor            
                 DEALLOCATE @c_cursor            
                  --            
END

GO
