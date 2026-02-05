-- Object: PROCEDURE citrus_usr.pr_client_details_migrate
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--SELECT * FROM MIGRATION_DETAILS
--delete from MIGRATION_DETAILS where id in(21)
--DELETE FROM CLIENT_BROK_DETAILS
--ROLLBACK
--select * from client_brok_details order by clibd_lst_upd_dt desc

--select * from client_mstr order by clim_lst_upd_dt desc

------select * from client_brok_details where cl_code = '10110208'
----delete from migration_details where id = 474
--select * from client_details_hst WHERE SHORT_NAME LIKE '%RO'
--select * from client_details WHERE PARTY_CODE = '10310027'
--select DISTINCT * from client_brok_details     WHERE CL_CODE = '10500004'
--select * from client_brok_details_hst where cl_code like '02010007'
--PR_SELECT_MIG_TAB '','CLIENT_DETAILS','04/04/2008','07/04/2008','',''

--pr_client_details_migrate '','29/01/2009','29/01/2009',''
--select * from client_details order by cd_lst_upd_dt desc


--select * from slb_mstr
--select * from client_accounts where clia_crn_no = 128372
--select * from slb_mstr where slb_client_cd = 11300018
--INSERT INTO slb_mstr values(10548,'11300018','TANUJA SHINDE','TANUJ1234P','','BSE_TEST','HO',GETDATE(),'HO',GETDATE(),1)
--SELECT * FROM CLIENT_ACCOUNTS
--select * from exch_seg_mstr
--insert into exch_seg_mstr values(8,1,'SLBBSE','SLBS','SLBS','SLBBSE_SLBS_SLBS_1',NULL,'','HO',GETDATE(),'HO',GETDATE(),1,0)
create PROCEDURE [citrus_usr].[pr_client_details_migrate]( @pa_id         varchar(8000)
														 ,@pa_from_dt    varchar(11)
														 ,@pa_to_dt      varchar(11)
														 ,@pa_err        VARCHAR(250) OUTPUT
														)

AS
BEGIN
--
  DECLARE @c_client_mstr           CURSOR
  --
  DECLARE @clim_crn_no             NUMERIC
        , @clim_name1              VARCHAR(100)
        , @clim_short_name         VARCHAR(25)
        , @clim_enttm_cd           VARCHAR(25)
        , @clim_clicm_cd           VARCHAR(25)
        , @clim_gender             VARCHAR(15)
        , @clim_dob                DATETIME
        , @clim_sbum_id            NUMERIC
        , @clim_created_dt         DATETIME
        , @clim_lst_upd_dt         DATETIME
        , @clim_lst_upd_by         VARCHAR(10)
        , @cliba_ac_type           VARCHAR(15)
        , @cliba_ac_no             VARCHAR(20)
        , @banm_name               VARCHAR(50)
        , @banm_branch             VARCHAR(20)
        , @banm_micr               VARCHAR(10)
        , @banm_payloc_cd          varchar(20)
        , @clim_stam_cd            varchar(20)
        , @modified                CHAR(2)
        , @l_cor_adr_value         VARCHAR(5000)
        , @l_c_adr_1               VARCHAR(250)
        , @l_c_adr_2               VARCHAR(250)
        , @l_c_adr_3               VARCHAR(250)
        , @l_c_adr_city            VARCHAR(50)
        , @l_c_adr_state           VARCHAR(50)
        , @l_c_adr_country         VARCHAR(50)
        , @l_c_adr_zip             VARCHAR(20)
        , @l_per_adr_value         VARCHAR(5000)
        , @l_p_adr_1               VARCHAR(250)
        , @l_p_adr_2               VARCHAR(250)
        , @l_p_adr_3               VARCHAR(250)
        , @l_p_adr_city            VARCHAR(50)
        , @l_p_adr_state           VARCHAR(50)
        , @l_p_adr_country         VARCHAR(50)
        , @l_p_adr_zip             VARCHAR(20)
        , @l_res_ph1               VARCHAR(40)
        , @l_res_ph2               VARCHAR(40)
        , @l_off_ph1               VARCHAR(40)
        , @l_off_ph2               VARCHAR(40)
        , @l_mob1                  VARCHAR(40)
        , @l_fax1                  VARCHAR(40)
        , @l_email1                VARCHAR(230)
        , @l_email2                VARCHAR(230)
        , @l_pan_gir_no            VARCHAR(25)
        , @l_ward_no               VARCHAR(25)
        , @l_sebi_regn_no          VARCHAR(25)
        , @l_approver              VARCHAR(25)
        , @l_interactmode          VARCHAR(25)
        , @l_passport_no           VARCHAR(25)
        , @l_passport_issued_at    VARCHAR(50)
        , @l_passport_issued_on    VARCHAR(25)
        , @l_passport_expires_on   VARCHAR(25)
        , @l_licence_no            VARCHAR(25)
        , @l_licence_issued_at     VARCHAR(50)
        , @l_licence_issued_on     VARCHAR(25)
        , @l_licence_expires_on    VARCHAR(25)
        , @l_rat_card_no           VARCHAR(25)
        , @l_rat_card_issued_at    VARCHAR(50)
        , @l_rat_card_issued_on    VARCHAR(25)
        , @l_votersid_no           VARCHAR(25)
        , @l_votersid_issued_at    VARCHAR(50)
        , @l_votersid_issued_on    VARCHAR(25)
        , @l_it_return_yr          VARCHAR(10)
        , @l_it_return_filed_on    VARCHAR(25)
        , @l_regr_no               VARCHAR(25)
        , @l_regr_at               VARCHAR(50)
        , @l_regr_on               VARCHAR(25)
        , @l_regr_authority        VARCHAR(25)
        , @l_client_agrement_on    VARCHAR(25)
        , @l_introducer_id         VARCHAR(25)
        , @l_introducer            VARCHAR(50)
        , @l_introducer_relation   VARCHAR(50)
        , @l_mapin_id              VARCHAR(25)
        , @l_drector_name          VARCHAR(50)
        , @l_paylocation           VARCHAR(50)
        , @l_party_code            VARCHAR(50)
        , @l_profile_id            VARCHAR(20)
        , @l_chk_flag              SMALLINT
        , @l_rl_cd                 varchar(50)
        , @t_errorstr              VARCHAR(250)
        , @l_error                 NUMERIC
        , @ucc_no                  VARCHAR(10)
        , @l_pan_name              VARCHAR(230)
        , @l_dealing_with_other_tm VARCHAR(50)
        , @l_ucc_code              VARCHAR(12)
        , @l_fm_code               VARCHAR(16)
        , @l_family                VARCHAR(10)
        , @l_sub_broker            VARCHAR(10)
        , @l_trader                VARCHAR(20)
        , @l_region                VARCHAR(50)
        , @l_area                  VARCHAR(10)
        , @l_branch_cd             VARCHAR(10)
        , @l_sbum                  VARCHAR(50)
        , @l_group                 VARCHAR(50)
        , @Depository1             VARCHAR(7)
        , @DpId1                   VARCHAR(16)
        , @CltDpId1                VARCHAR(16)
        , @Poa1                    VARCHAR(1)
        , @l_participant_cd_nse    VARCHAR(15)
        , @l_custodian_cd_nse      VARCHAR(50)
        , @l_stp_provider_nse      VARCHAR(5)
        , @l_stp_style_nse         INT
        , @l_cont_gen_cd_nse       CHAR(1)
        , @l_roundin_method_nse    VARCHAR(10)
        , @l_rnd_to_digit_nse      INT
        , @l_participant_cd_bse    VARCHAR(15)
        , @l_custodian_cd_bse      VARCHAR(50)
        , @l_stp_provider_bse      VARCHAR(5)
        , @l_stp_style_bse         INT
        , @l_cont_gen_cd_bse       CHAR(1)
        , @l_roundin_method_bse    VARCHAR(10)
        , @l_rnd_to_digit_bse      INT
        , @l_custodian_code_BSE    VARCHAR(25)
        , @l_custodian_code_NSE    VARCHAR(25)
        , @l_paymentmode           CHAR(1)
        , @l_b3bpayment            CHAR(1)
        , @l_branch_name           VARCHAR(50)
        , @l_excsm_cd              VARCHAR(20)
        , @l_seg_cd                VARCHAR(10)
        , @l_bankname              VARCHAR(50)
        , @l_branch                varchar(20)
        , @l_crn                   varchar(20)
        , @l_bankname1             VARCHAR(50)
        --
        , @l_hdfc_nse_fno          varchar(30)
        , @l_hdfc_nse_cash         varchar(30)
        , @l_hdfc_bse_cash         varchar(30)
        , @l_citi_bse_cash         varchar(30)
        , @l_citi_nse_cash         varchar(30)
        , @l_participant_cd_bsefo  varchar(25)
        , @l_participant_cd_nsefo  varchar(25)
        , @l_Inc_dob               Varchar(25)
        , @l_email3                varchar(100)
        , @l_email4                varchar(100)
        , @l_email                 varchar(100)
        --
        --
        , @l_inactive_from         datetime
        --
        --
        , @l_participant_cd_slbnse    VARCHAR(15)
        , @l_participant_cd_slbbse    VARCHAR(15)
        , @l_participant_cd_nsx       VARCHAR(15)
        , @l_participant_cd_mcd       VARCHAR(15)
        --
        --
  --
  CREATE TABLE #entity_properties
  (code         varchar(25)
  ,value        varchar(50)
  )
  --
  --
  CREATE TABLE #entity_property_dtls
  (code1        varchar(25)
  ,code2        varchar(25)
  ,value        varchar(250)
  )
  --
  --
  SELECT @l_Inc_dob      =  convert(varchar(25), value) FROM #entity_properties WHERE code = 'INC_DOB'

  declare @last_mig_dateime datetime
  select TOP 1 @last_mig_dateime  = mig_datetime from migration_details where tab = 'CLIENT_DETAILS' order by id desc
  insert into migration_details values('CLIENT_DETAILS',getdate())
  --
  SET @c_client_mstr  = CURSOR FAST_FORWARD FOR
  /*SELECT clim_crn_no
        ,convert(varchar(100),clim_name1 + ' ' + isnull(clim_name2,'') + ' ' + isnull(clim_name3,''))
        ,case when patindex('%[_]%',clim_short_name) <> 0 then substring(clim_short_name,1,charindex('_',clim_short_name)-1) else clim_short_name end   --clim_short_name
        ,clim_enttm_cd
        ,clim_clicm_cd
        ,clim_gender
        ,convert(datetime,clim.clim_dob,103)   --case when clicm.clicm_id in ('2','3','12','15') then CONVERT(VARCHAR(11),clim.clim_dob,102) when clicm.clicm_id in ('4','5','6','7','8','9','10','11','13','14','0') then CONVERT(VARCHAR(11),@l_Inc_dob,102) end   --else Case When REPLACE(CONVERT(VARCHAR(11),clim.clim_dob,102),'.','')='19000101' then Isnull(@l_Inc_dob,'') else REPLACE(CONVERT(VARCHAR(11),clim.clim_dob,102),'.','') end end    --clim_dob
        ,clim_sbum_id
        ,clim_stam_cd
        ,banm_micr
        ,cliba_ac_type
        ,cliba_ac_no
        ,banm_name
        ,banm_branch
        ,banm_payloc_cd
        ,clim_created_dt
        ,clim_lst_upd_dt
        ,clim_lst_upd_by
        ,case when clim_created_dt =clim_lst_upd_dt then 'N' else 'M' end modified
        ,clia_acct_no
        ,excsm_exch_cd
        ,dpm_dpid
        ,clidpa_dp_id
        ,case when CLIDPA_FLG & power(2,1-1) = 1 then 1 else 0 end
  FROM   client_mstr     clim
        ,client_accounts clia
        ,client_sub_accts clisba
         left outer join
         client_dp_accts  clidpa on clidpa_clisba_id = clisba_id   AND    CLIDPA_FLG & power(2,2-1) > 0
         left outer join
         dp_mstr dpm on dpm.dpm_id = clidpa_dpm_id
         left outer join
         exch_seg_mstr  excsm on dpm_excsm_id = excsm_id
         left outer join
         client_bank_accts cliba  on cliba.cliba_clisba_id      = clisba.clisba_id
        left outer join
        bank_mstr banm on banm_id     = cliba.cliba_banm_id  AND    CLIBA_FLG & power(2,1-1) > 0
        ,client_ctgry_mstr   clicm  --
  WHERE  clim.clim_deleted_ind  = 1
  AND    clia.clia_deleted_ind  = 1
  AND   isnull( cliba.cliba_deleted_ind,1) = 1
  and    clicm.clicm_deleted_ind = 1    --
  AND    clia.clia_crn_no   = clim.clim_crn_no
  AND    clia.clia_acct_no = clisba_acct_no
  and    clim.clim_clicm_cd  = clicm.clicm_cd   --
  AND    clim.clim_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
  AND    convert(VARCHAR,clim.clim_crn_no)  LIKE CASE WHEN LTRIM(RTRIM(@PA_ID))   = '' THEN '%' ELSE @PA_ID END
  AND    ISNULL(CLIM.CLIM_CLICM_CD,'') <> ''
  AND    ISNULL(CLIM.CLIM_ENTTM_CD,'') <> ''
  --AND    CLIBA_FLG & power(2,1-1) > 0*/
  SELECT distinct clim_crn_no
        ,convert(varchar(100),clim_name1 + ' ' + isnull(clim_name2,'') + ' ' + isnull(clim_name3,''))
        ,case when patindex('%[_]%',clim_short_name) <> 0 then substring(clim_short_name,1,charindex('_',clim_short_name)-1) else clim_short_name end   --clim_short_name
        ,clim_enttm_cd
        ,clim_clicm_cd
        ,clim_gender
        ,convert(datetime,clim.clim_dob,103)   --case when clicm.clicm_id in ('2','3','12','15') then CONVERT(VARCHAR(11),clim.clim_dob,102) when clicm.clicm_id in ('4','5','6','7','8','9','10','11','13','14','0') then CONVERT(VARCHAR(11),@l_Inc_dob,102) end   --else Case When REPLACE(CONVERT(VARCHAR(11),clim.clim_dob,102),'.','')='19000101' then Isnull(@l_Inc_dob,'') else REPLACE(CONVERT(VARCHAR(11),clim.clim_dob,102),'.','') end end    --clim_dob
        ,clim_sbum_id
        ,clim_stam_cd
        ,banm_micr
        ,cliba_ac_type
        ,cliba_ac_no
        ,banm_name
        ,banm_branch
        ,banm_payloc_cd
        ,clim_created_dt
        ,clim_lst_upd_dt
        ,clim_lst_upd_by
        ,case when clim_created_dt =clim_lst_upd_dt then 'N' else 'M' end modified
        ,clia_acct_no
        ,CASE WHEN left(dpm_dpid,2) = 'IN' THEN 'NSDL' ELSE 'CDSL' end --excsmm.excsm_exch_cd
        ,dpm_dpid
        ,clidpa_dp_id
        ,case when CLIDPA_FLG & power(2,1-1) = 1 then 1 else 0 end
  FROM   client_mstr     clim
        ,client_accounts clia
        ,client_sub_accts clisba
         left outer join
         client_dp_accts  clidpa on clidpa_clisba_id = clisba_id   AND    CLIDPA_FLG & power(2,2-1) > 0
         left outer join
         dp_mstr dpm on dpm.dpm_id = clidpa_dpm_id
         left outer join
         exch_seg_mstr  excsm on dpm_excsm_id = excsm_id
         left outer join
         client_bank_accts cliba  on cliba.cliba_clisba_id      = clisba.clisba_id   AND    CLIBA_FLG & power(2,1-1) > 0

        ,bank_mstr banm
        ,client_ctgry_mstr   clicm
        ,excsm_prod_mstr     excpm
        ,exch_seg_mstr       excsmm
  WHERE  clim.clim_deleted_ind  = 1
  AND    clia.clia_deleted_ind  = 1
  AND    isnull( cliba.cliba_deleted_ind,1) = 1
  and    clicm.clicm_deleted_ind = 1    --
  AND    clia.clia_crn_no   = clim.clim_crn_no
  AND    clia.clia_acct_no = clisba_acct_no
  and    clim.clim_clicm_cd  = clicm.clicm_cd   --
  and    banm.banm_id     = cliba.cliba_banm_id
  AND    clim.clim_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
  AND    convert(VARCHAR,clim.clim_crn_no)  LIKE CASE WHEN LTRIM(RTRIM(@PA_ID))   = '' THEN '%' ELSE @PA_ID END
  AND    ISNULL(CLIM.CLIM_CLICM_CD,'') <> ''
  AND    ISNULL(CLIM.CLIM_ENTTM_CD,'') <> ''
  and    clim.clim_lst_upd_dt >= @last_mig_dateime
  and    clisba.clisba_excpm_id   = excpm.excpm_id
		and    excpm.excpm_excsm_id     = excsmm.excsm_id
		and    excsmm.EXCSM_EXCH_CD     in ('bse','nse','slbnse','slbbse','nsx','mcd')
  and    excsmm.excsm_seg_cd      in ('cash','slbs','futures','derivatives')
  --AND    CLIBA_FLG & power(2,1-1) > 0



  /*UNION

  SELECT clim_crn_no
        ,convert(varchar(100),clim_name1 + ' ' + isnull(clim_name2,'') + ' ' + isnull(clim_name3,''))
        ,clim_short_name
        ,clim_enttm_cd
        ,clim_clicm_cd
        ,clim_gender
        ,clim_dob
        ,clim_sbum_id
        ,clim_stam_cd
        ,banm_micr
        ,cliba_ac_type
        ,cliba_ac_no
        ,banm_name
        ,banm_branch
        ,banm_payloc_cd
        ,clim_created_dt
        ,clim_lst_upd_dt
        ,clim_lst_upd_by
        --,case when clim_created_dt =clim_lst_upd_dt then 'N' else 'M' end modified
        ,case when clim_created_dt =clim_lst_upd_dt then 'N' else 'M' end modified
        ,clisba_no
        ,excsm_exch_cd
        ,dpm_dpid
        ,clidpa_dp_id
        ,case when clidpa_flg & 2 = 2 then 1 else 0 end
  FROM   client_mstr     clim
        ,client_accounts clia
        ,client_sub_accts clisba
         left outer join
         client_dp_accts  clidpa on clidpa_clisba_id = clisba_id
         left outer join
         dp_mstr dpm on dpm.dpm_id = clidpa_dpm_id
         left outer join
         exch_seg_mstr  excsm on dpm_excsm_id = excsm_id
        ,client_bank_accts cliba
        ,bank_mstr         banm
  WHERE  clim.clim_deleted_ind     = 1
  AND    clia.clia_deleted_ind     = 1
  AND    clisba.clisba_deleted_ind = 1
  AND    cliba.cliba_clisba_id     = clisba.clisba_id
  AND    clia.clia_crn_no      = clim.clim_crn_no
  AND    banm_id                = cliba.cliba_banm_id
  AND    clim.clim_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
  AND    convert(VARCHAR,clim.clim_crn_no)  LIKE CASE WHEN LTRIM(RTRIM(@PA_ID))   = '' THEN '%' ELSE @PA_ID END
  AND    ISNULL(CLIM.CLIM_CLICM_CD,'') <> ''
  AND    ISNULL(CLIM.CLIM_ENTTM_CD,'') <> ''
  AND    clia.clia_acct_no = clisba_acct_no
  AND    CLIBA_FLG & power(2,1-1) = 1
  AND    CLIDPA_FLG & power(2,2-1) = 2      */
  --
  OPEN @c_client_mstr
  --
  FETCH NEXT FROM  @c_client_mstr
  INTO @clim_crn_no
     , @clim_name1
     , @clim_short_name
     , @clim_enttm_cd
     , @clim_clicm_cd
     , @clim_gender
     , @clim_dob
     , @clim_sbum_id
     , @clim_stam_cd
     , @banm_micr
     , @cliba_ac_type
     , @cliba_ac_no
     , @banm_name
     , @banm_branch
     , @banm_payloc_cd
     , @clim_created_dt
     , @clim_lst_upd_dt
     , @clim_lst_upd_by
     , @modified
     , @ucc_no
     , @Depository1
     , @DpId1
     , @CltDpId1
     , @Poa1

  WHILE @@FETCH_STATUS = 0
  BEGIN
   --
   --Hash table created For group and sbu columns in client_details table by vivek/jitesh on 26/feb/2008
   --
   print 'loop'
   DELETE FROM #entity_properties
   --
   DELETE FROM #entity_property_dtls
   --
   --
   INSERT INTO #entity_properties
   (code
   ,value
   )
   SELECT entp_entpm_cd
         ,entp_value
   FROM   entity_properties
   WHERE  entp_ent_id           = @clim_crn_no
   AND    entp_deleted_ind      = 1
   --
   --
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
   WHERE  a.entp_ent_id     = @clim_crn_no
   AND    a.entp_id            = b.entpd_entp_id
   AND    a.entp_deleted_ind   = 1
   AND    b.entpd_deleted_ind  = 1
   --
   --
    IF EXISTS(select * from client_details_hst where party_code = @ucc_no   and migrate_yn in (1,3)) --and status_flag = 'ACTIVE')
    begin
    --
      set @modified = 'M'
    --
    end
    else
    begin
    --
      set @modified = 'N'
    --
    end
    --
    SELECT @l_party_code     =  clia_acct_no FROM client_accounts WHERE clia_crn_no = @clim_crn_no AND clia_deleted_ind = 1
    --
    SELECT @l_cor_adr_value  =  citrus_usr.fn_addr_value(@clim_crn_no,'COR_ADR1')
    --
    SELECT @l_c_adr_1        = convert(varchar(40),citrus_usr.fn_splitval(@l_cor_adr_value,1))
          ,@l_c_adr_2        = convert(varchar(40),citrus_usr.fn_splitval(@l_cor_adr_value,2))
          ,@l_c_adr_3        = convert(varchar(40),citrus_usr.fn_splitval(@l_cor_adr_value,3))
          ,@l_c_adr_city     = convert(varchar(40),citrus_usr.fn_splitval(@l_cor_adr_value,4))
          ,@l_c_adr_state    = case when (@l_c_adr_city <>  '' and convert(varchar(50),citrus_usr.fn_splitval(@l_cor_adr_value,5))='') then 'OTHERS' else convert(varchar(50),citrus_usr.fn_splitval(@l_cor_adr_value,5))   end
          ,@l_c_adr_country  = citrus_usr.fn_splitval(@l_cor_adr_value,6)
          ,@l_c_adr_zip      = citrus_usr.fn_splitval(@l_cor_adr_value,7)
	--
	--
    SELECT @l_per_adr_value =  citrus_usr.fn_addr_value(@clim_crn_no,'PER_ADR1')
	--
    SELECT @l_p_adr_1        = convert(varchar(40),citrus_usr.fn_splitval(@l_per_adr_value,1))
          ,@l_p_adr_2        = convert(varchar(40),citrus_usr.fn_splitval(@l_per_adr_value,2))
          ,@l_p_adr_3        = convert(varchar(40),citrus_usr.fn_splitval(@l_per_adr_value,3))
          ,@l_p_adr_city     = convert(varchar(40),citrus_usr.fn_splitval(@l_per_adr_value,4))
          ,@l_p_adr_state    = case when (@l_p_adr_city <> '' and convert(varchar(50),citrus_usr.fn_splitval(@l_per_adr_value,5)) = '' ) then 'OTHERS' else convert(varchar(50),citrus_usr.fn_splitval(@l_per_adr_value,5))   end
          ,@l_p_adr_country  = citrus_usr.fn_splitval(@l_per_adr_value,6)
          ,@l_p_adr_zip      = citrus_usr.fn_splitval(@l_per_adr_value,7)
	--
    SELECT @l_res_ph1        = citrus_usr.fn_conc_value(@clim_crn_no,'RES_PH1')
    SELECT @l_res_ph2        = citrus_usr.fn_conc_value(@clim_crn_no,'RES_PH2')
    SELECT @l_off_ph1        = citrus_usr.fn_conc_value(@clim_crn_no,'OFF_PH1')
    SELECT @l_off_ph2        = citrus_usr.fn_conc_value(@clim_crn_no,'OFF_PH2')
    SELECT @l_mob1           = citrus_usr.fn_conc_value(@clim_crn_no,'MOBILE1')
    SELECT @l_fax1           = citrus_usr.fn_conc_value(@clim_crn_no,'FAX1')
    --
    --
    --
   --changed on 28082008 at belapur office
			    --SELECT @l_email1         = citrus_usr.fn_conc_value(@clim_crn_no,'EMAIL1')
			    SELECT @l_email1         = citrus_usr.fn_conc_value_mail(@clim_crn_no,'EMAIL1')
			    --
			    --SELECT @l_email2         = isnull(citrus_usr.fn_conc_value(@clim_crn_no,'EMAIL2'),'')
			    SELECT @l_email2         = isnull(citrus_usr.fn_conc_value_mail(@clim_crn_no,'EMAIL2'),'')
			    --
			    --SELECT @l_email3         = isnull(citrus_usr.fn_conc_value(@clim_crn_no,'EMAIL3'),'')
			    SELECT @l_email3         = isnull(citrus_usr.fn_conc_value_mail(@clim_crn_no,'EMAIL3'),'')
			    --
			   --SELECT @l_email4         = isnull(citrus_usr.fn_conc_value(@clim_crn_no,'EMAIL4'),'')
    SELECT @l_email4         = isnull(citrus_usr.fn_conc_value_mail(@clim_crn_no,'EMAIL4'),'')
    --
    --
    /*IF ISNULL(@l_email1,'')  = ''
    begin
    --
    SELECT @l_email1     = REPLACE(citrus_usr.fn_conc_value(@clim_crn_no,'EMAIL2'),',','')
    --
    end*/
    --
    if (@l_email1) <> '' and len(@l_email1 ) <= 100
     begin
      set @l_email = @l_email1
      --
    end
    --
    if (@l_email1) <> '' and (@l_email2)<> ''  and len(@l_email1 + ';' + @l_email2) <= 100
    begin
      set @l_email = @l_email1 + ';' + @l_email2
      --
    end
    --
    if (@l_email1) <> '' and (@l_email2)<> '' and (@l_email3)<> '' and len(@l_email1 + ';' + @l_email2  + ';' + @l_email3) <= 100
    begin
      set @l_email = @l_email1 + ';' + @l_email2  + ';' + @l_email3
      --
    end
    --
    if (@l_email1) <> '' and (@l_email2)<> '' and (@l_email3)<> '' and (@l_email4)<> ''  and len(@l_email1 + ';' + @l_email2  + ';' + @l_email3 + ';' + @l_email4) <= 100
    begin
      set @l_email = @l_email1 + ';' + @l_email2  + ';' + @l_email3 + ';' + @l_email4
      --
    end
    --
    --

    --
    SELECT @l_pan_gir_no     = citrus_usr.fn_ucc_entp(@clim_crn_no,'PAN_GIR_NO','')
    SELECT @l_ward_no        = citrus_usr.fn_ucc_entpd(@clim_crn_no,'PAN_GIR_NO','WARD_NO','')
    SELECT @l_pan_name       = citrus_usr.fn_ucc_entpd(@clim_crn_no,'PAN_GIR_NO','PAN_NAME','')

    SELECT @l_sebi_regn_no   = citrus_usr.fn_ucc_entp(@clim_crn_no,'SEBI_REGN_NO','')

    SELECT @l_approver    = citrus_usr.fn_ucc_entp(@clim_crn_no,'APPROVER','')

    SELECT @l_interactmode          = citrus_usr.fn_ucc_entp(@clim_crn_no,'INTERACTMODE','')

    SELECT @l_passport_no           = citrus_usr.fn_ucc_entp(@clim_crn_no,'PASSPORT_NO','')
    SELECT @l_passport_issued_at    = citrus_usr.fn_ucc_entpd(@clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_AT','')
    SELECT @l_passport_issued_on    = citrus_usr.fn_ucc_entpd(@clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON','')
    SELECT @l_passport_expires_on   = citrus_usr.fn_ucc_entpd(@clim_crn_no,'PASSPORT_NO','PASSPORT_EXPIRES_ON','')

    SELECT @l_licence_no            = citrus_usr.fn_ucc_entp(@clim_crn_no,'LICENCE_NO','')
    SELECT @l_licence_issued_at     = citrus_usr.fn_ucc_entpd(@clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_AT','')
    SELECT @l_licence_issued_on     = citrus_usr.fn_ucc_entpd(@clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_ON','')
    SELECT @l_licence_expires_on    = citrus_usr.fn_ucc_entpd(@clim_crn_no,'LICENCE_NO','LICENCE_EXPIRES_ON','')

    SELECT @l_rat_card_no           = citrus_usr.fn_ucc_entp(@clim_crn_no,'RAT_CARD_NO','')
    SELECT @l_rat_card_issued_at    = citrus_usr.fn_ucc_entpd(@clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_AT','')
    SELECT @l_rat_card_issued_on    = citrus_usr.fn_ucc_entpd(@clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_ON','')

    SELECT @l_votersid_no           = citrus_usr.fn_ucc_entp(@clim_crn_no,'VOTERSID_NO','')
    SELECT @l_votersid_issued_at    = citrus_usr.fn_ucc_entpd(@clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_AT','')
    SELECT @l_votersid_issued_on    = citrus_usr.fn_ucc_entpd(@clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_ON','')

    SELECT @l_it_return_yr          = citrus_usr.fn_ucc_entp(@clim_crn_no,'IT_RETURN_YR','')
    SELECT @l_it_return_filed_on    = citrus_usr.fn_ucc_entpd(@clim_crn_no,'IT_RETURN_YR','IT_RETURN_FILED_ON','')

    SELECT @l_regr_no               = citrus_usr.fn_ucc_entp(@clim_crn_no,'REGR_NO','')
    SELECT @l_regr_at    = citrus_usr.fn_ucc_entpd(@clim_crn_no,'REGR_NO','REGR_AT','')
    SELECT @l_regr_on               = citrus_usr.fn_ucc_entpd(@clim_crn_no,'VOTERSID_NO','REGR_ON','')
    SELECT @l_regr_authority        = citrus_usr.fn_ucc_entpd(@clim_crn_no,'VOTERSID_NO','REGR_AUTHORITY','')

    SELECT @l_client_agrement_on    = citrus_usr.fn_ucc_entp(@clim_crn_no,'CLIENT_AGREMENT_ON','')

    SELECT @l_introducer_id         = citrus_usr.fn_ucc_entp(@clim_crn_no,'INTRODUCER_ID','')
    SELECT @l_introducer            = citrus_usr.fn_ucc_entpd(@clim_crn_no,'INTRODUCER_ID','INTRODUCER','')
    SELECT @l_introducer_relation   = citrus_usr.fn_ucc_entpd(@clim_crn_no,'INTRODUCER_ID','INTRODUCER_RELATION','')

    SELECT @l_mapin_id              = citrus_usr.fn_ucc_entp(@clim_crn_no,'MAPIN_ID','')

    SELECT @l_drector_name          = citrus_usr.fn_ucc_entp(@clim_crn_no,'DRECTOR_NAME','')

    SELECT @l_paylocation           = citrus_usr.fn_ucc_entp(@clim_crn_no,'PAYLOCATION','')

    SELECT @l_chk_flag              = 0--citrus_usr.fn_ucc_entp(@clim_crn_no,'CHK_FLAG','')
    --********************************************--
    SELECT @l_dealing_with_other_tm = citrus_usr.fn_ucc_entp(@clim_crn_no,'DEALING_WITH_OTHER_TM','') --add new property

    SELECT @l_ucc_code              = citrus_usr.fn_ucc_entp(@clim_crn_no,'UCC_CODE','') --add new property

    SELECT @l_fm_code               = citrus_usr.fn_ucc_entp(@clim_crn_no,'FM_CODE','')  --add new property

    SELECT @l_family                = case when isnull(citrus_usr.fn_find_relations_nm(@clim_crn_no,'FAMILY'),'')  = '' then @l_party_code      end --add enttm_short_name for "family"
    --
    SELECT @l_sub_broker  = citrus_usr.fn_find_relations(@clim_crn_no,'SBFR')  --add enttm_short_name for "subbrokers"
    -- select @l_sub_broker  = substring(citrus_usr.fn_find_relations(@clim_crn_no,'SBFR'),1,len(citrus_usr.fn_find_relations(@clim_crn_no,'SBFR'))-len('SBFR')-1)
    --
    --
    SELECT @l_trader             = citrus_usr.fn_find_relations(@clim_crn_no,'RM_BR')  --add enttm_short_name for "trader"
    --select @l_trader  = left(substring(citrus_usr.fn_find_relations(@clim_crn_no,'RM_BR'),1,len(citrus_usr.fn_find_relations(@clim_crn_no,'RM_BR'))-len('RM_BR')-1),20)
    --
    --SELECT @l_region                = citrus_usr.fn_find_relations(@clim_crn_no,'RE')  --add enttm_short_name for "region"
    -- select @l_region  = substring(citrus_usr.fn_find_relations(@clim_crn_no,'RE'),1,len(citrus_usr.fn_find_relations(@clim_crn_no,'RE'))-len('RE')-1)
    SELECT @l_region  = citrus_usr.fn_find_relations(@clim_crn_no,'RE')

    SELECT @l_area                  = citrus_usr.fn_find_relations(@clim_crn_no,'AR')  --add enttm_short_name for "area"
    -- select @l_area  = substring(citrus_usr.fn_find_relations(@clim_crn_no,'AR'),1,len(citrus_usr.fn_find_relations(@clim_crn_no,'AR'))-len('AR')-1)

    SELECT @l_branch_cd             = citrus_usr.fn_find_relations(@clim_crn_no,'BR')  --add enttm_short_name for "branch"
    --select @l_branch_cd  = substring(citrus_usr.fn_find_relations(@clim_crn_no,'BR'),1,len(citrus_usr.fn_find_relations(@clim_crn_no,'BR'))-len('BR')-1)
    --
    SELECT @l_rl_cd             = citrus_usr.fn_find_relations(@clim_crn_no,'INT')  --add enttm_short_name for "branch"
    --select @l_rl_cd  = substring(citrus_usr.fn_find_relations(@clim_crn_no,'INT'),1,len(citrus_usr.fn_find_relations(@clim_crn_no,'INT'))-len('INT')-1)
                   --  print @l_rl_cd
    --print @clim_crn_no
    --print    citrus_usr.fn_find_relations_nm(@clim_crn_no,'RM')
    --********************************************--

    SET @l_profile_id = null
    --
    --SELECT @l_sbum        = citrus_usr.fn_get_listing('TRADINGTYPE',value)  FROM #entity_properties WHERE code = 'TRADINGTYPE'
    SELECT @l_sbum              = citrus_usr.fn_ucc_entp(@clim_crn_no,'TRADINGTYPE','')
    --
    if ltrim(rtrim(isnull(@l_sbum ,'')))     = ''  set @l_sbum = ''
    --
    --SELECT @l_group        = citrus_usr.fn_get_listing('GROUP',value)  FROM #entity_properties WHERE code = 'GROUP'
    --
    If exists(select value FROM #entity_properties WHERE code = 'GROUP'  )
    --
    begin
    --
     SELECT @l_group        = citrus_usr.fn_get_listing('GROUP',value)  FROM #entity_properties WHERE code = 'GROUP'
     --
     End
     --
     Else
     --
     Begin
     --
     SET @l_group        = ''
     --
     end
     --
    if ltrim(rtrim(isnull(@l_group ,'')))     = ''  set @l_group = ''
    --
    /*SELECT top 1 @l_profile_id   = isnull(clib_brom_id,'')
    FROM   client_brokerage        clib
          ,client_sub_accts        clisba
    WHERE  clisba.clisba_id      = clib.clib_clisba_id
    AND    clisba.clisba_acct_no = @l_party_code
    AND    clisba.clisba_crn_no  = @clim_crn_no      */
    --
    IF EXISTS(SELECT party_code,short_name FROM client_details WHERE migrate_yn =0 and party_code = @ucc_no) --AND status_flag = 'ACTIVE')
    BEGIN
    --
      delete FROM client_details WHERE migrate_yn = 0 and party_code = @ucc_no --and status_flag = 'ACTIVE'
      --
      print 'insert'
      INSERT INTO client_details(client_id
                                ,branch_cd
                                ,party_code

                                ,sub_broker
                                ,trader
                                ,long_name
                                ,short_name
                                ,l_address1
                                ,l_city
                                ,l_address2
                                ,l_state
                                ,l_address3
                                ,l_nation
                                ,l_zip
                                ,pan_gir_no
                                ,ward_no
                                ,sebi_regn_no
                                ,res_phone1
                                ,res_phone2
                                ,off_phone1
                                ,off_phone2
                                ,mobile_pager
                                ,fax
                                ,email
                                ,cl_type
                                ,cl_status
                                ,family
                                ,region
                                ,area
                                ,p_address1
                                ,p_city
                                ,p_address2
                                ,p_state
                                ,p_address3
                                ,p_nation
                                ,p_zip
                                ,addemailid
                                ,sex
                                ,dob
                                ,approver
                                ,interactmode
                                ,passport_no
                                ,passport_issued_at
                                ,passport_issued_on
                                ,passport_expires_on
                                ,licence_no
                                ,licence_issued_at
                                ,licence_issued_on
                                ,licence_expires_on
                                ,rat_card_no
                                ,rat_card_issued_at
                                ,rat_card_issued_on
                                ,votersid_no
                                ,votersid_issued_at
                                ,votersid_issued_on
                                ,it_return_yr
                                ,it_return_filed_on
                                ,regr_no
                                ,regr_at
                                ,regr_on
                                ,regr_authority
                                ,client_agreement_on
                                ,dealing_with_other_tm
                                ,other_ac_no
                                ,introducer_id
                                ,introducer
                                ,introducer_relation
                                ,chk_kyc_form
                                ,chk_corporate_deed
                                ,chk_bank_certificate
                                ,chk_annual_report
                                ,chk_networth_cert
                                ,chk_corp_dtls_recd
                                ,sbu
                                ,modifidedby
                                ,modifiedon
                                ,mapin_id
                                ,ucc_code
                                ,fm_code
                                ,micr_no

                                ,director_name
                                ,paylocation
                                ,cd_created_dt
                                ,cd_lst_upd_dt
                                ,cd_changed
                                ,migrate_yn
                           
                                )
                          VALUES(@clim_crn_no
                                ,left(ltrim(rtrim(@l_branch_cd )),10)
                                ,left(ltrim(rtrim(@l_party_code)),10) --@ucc_no         --party code
                             
                                ,left(ltrim(rtrim(@l_sub_broker)),10)
                                ,left(ltrim(rtrim(@l_trader )),20)
                                ,left(ltrim(rtrim(@clim_name1  )),100)
                                ,left(ltrim(rtrim(@clim_short_name )),100)
                                ,left(ltrim(rtrim(@l_c_adr_1 )),60)
                                ,left(ltrim(rtrim(@l_c_adr_city )),40)
                                ,left(ltrim(rtrim(@l_c_adr_2  )),60)
                                ,left(ltrim(rtrim(@l_c_adr_state)),50)
                                ,left(ltrim(rtrim(@l_c_adr_3 )),60)
                                ,left(ltrim(rtrim(@l_c_adr_country)),15)
                                ,left(ltrim(rtrim(@l_c_adr_zip )),25)
                                ,left(ltrim(rtrim(@l_pan_gir_no)),50)
                                ,left(ltrim(rtrim(@l_ward_no )),50)
                                ,left(ltrim(rtrim(@l_sebi_regn_no)),25)
                                ,left(ltrim(rtrim(@l_res_ph1 )),40)
                                ,left(ltrim(rtrim(@l_res_ph2 )),40)
                                ,left(ltrim(rtrim(@l_off_ph1 )),40)
                                ,left(ltrim(rtrim(@l_off_ph2)),40)
                                ,left(ltrim(rtrim(@l_mob1)),40)
                                ,left(ltrim(rtrim(@l_fax1 )),40)
                                ,left(ltrim(rtrim(@l_email )),230)
                                ,left(ltrim(rtrim(CONVERT(CHAR(3), @clim_enttm_cd) )),10)
                                ,left(ltrim(rtrim(CONVERT(CHAR(3), @clim_clicm_cd) )),10)
                                ,left(ltrim(rtrim(@l_family )),10)
                                ,left(ltrim(rtrim(@l_region )),50)
                                ,left(ltrim(rtrim(@l_area )),10)
                                ,left(ltrim(rtrim(@l_p_adr_1 )),60)
                                ,left(ltrim(rtrim(@l_p_adr_city)),20)
                                ,left(ltrim(rtrim(@l_p_adr_2)),60)
                                ,left(ltrim(rtrim(@l_p_adr_state)),50) --,(CASE WHEN @l_p_adr_state = 'INDIA' THEN '' ELSE @l_p_adr_state END)
                                ,left(ltrim(rtrim(@l_p_adr_3  )),60)
                                ,left(ltrim(rtrim(@l_p_adr_country)),15)
                                ,left(ltrim(rtrim(@l_p_adr_zip   )),10)
                                ,left(ltrim(rtrim(@l_pan_name  )),230)
                                ,left(ltrim(rtrim(@clim_gender)),8)
                                ,ltrim(rtrim(CONVERT(DATETIME,@clim_dob,104)))
                                ,left(ltrim(rtrim(@l_approver )),30)
                                ,left(ltrim(rtrim(@l_interactmode )),4)
                                ,left(ltrim(rtrim(@l_passport_no )),30)
                                ,left(ltrim(rtrim(@l_passport_issued_at )),30)
                                ,ltrim(rtrim(CONVERT(DATETIME,@l_passport_issued_on,104) ))
                                ,ltrim(rtrim(CONVERT(DATETIME,@l_passport_expires_on,104)))
                                ,left(ltrim(rtrim(@l_licence_no)),30)
                                ,left(ltrim(rtrim(@l_licence_issued_at )),30)
                                ,ltrim(rtrim(CONVERT(DATETIME,@l_licence_issued_on,104)))
                                ,ltrim(rtrim(CONVERT(DATETIME,@l_licence_expires_on,104) ))
                                ,left(ltrim(rtrim(@l_rat_card_no )),30)
                                ,left(ltrim(rtrim(@l_rat_card_issued_at)),30)
                                ,ltrim(rtrim(CONVERT(DATETIME,@l_rat_card_issued_on,104 ) ))
                                ,left(ltrim(rtrim(@l_votersid_no )),30)
                                ,left(ltrim(rtrim(@l_votersid_issued_at )),30)
                                ,ltrim(rtrim(CONVERT(DATETIME,@l_votersid_issued_on,104)))
                                ,left(ltrim(rtrim(@l_it_return_yr)),30)
                                ,ltrim(rtrim(CONVERT(DATETIME,@l_it_return_filed_on,104) ))
                                ,left(ltrim(rtrim(@l_regr_no)),50)
                                ,left(ltrim(rtrim(@l_regr_at)),50)
                                ,ltrim(rtrim(CONVERT(DATETIME,@l_regr_on,104 )))
                                ,left(ltrim(rtrim(@l_regr_authority)),50)
                                ,ltrim(rtrim(CONVERT(DATETIME,@l_client_agrement_on,104)))
                                ,left(ltrim(rtrim(@l_dealing_with_other_tm)),50)
                                ,0        --other account no
                                ,left(ltrim(rtrim(@l_introducer_id)),50)
                                ,left(ltrim(rtrim(@l_introducer )),50)
                                ,left(ltrim(rtrim(@l_introducer_relation )),50)
                                ,ltrim(rtrim(citrus_usr.getbit(convert(integer,@l_chk_flag),5)    ))     --chk_flg  bit-logic
                                ,ltrim(rtrim(citrus_usr.getbit(convert(integer,@l_chk_flag),4)    ))
                                ,ltrim(rtrim(citrus_usr.getbit(convert(integer,@l_chk_flag),3)    ))
                                ,ltrim(rtrim(citrus_usr.getbit(convert(integer,@l_chk_flag),2)   ))
                                ,ltrim(rtrim(citrus_usr.getbit(convert(integer,@l_chk_flag),1)  ))
                                ,ltrim(rtrim(citrus_usr.getbit(convert(integer,@l_chk_flag),0) ))
                                ,left(ltrim(rtrim(@l_sbum )),25)  --@clim_sbum_id
                                ,left(ltrim(rtrim(@clim_lst_upd_by )),25)
                                ,ltrim(rtrim(@clim_lst_upd_dt))
                                ,left(ltrim(rtrim(@l_mapin_id )),12)
                                ,left(ltrim(rtrim(@l_ucc_code )),12)
                                ,left(ltrim(rtrim(@l_fm_code )),16)
                                ,left(ltrim(rtrim(@banm_micr )),10) --micr no
                       
                             
                                ,left(ltrim(rtrim(@l_drector_name )),100)
                                ,left(ltrim(rtrim(@l_paylocation )),20)	 --@banm_payloc_cd  changed on 11/amar/2008
                                ,ltrim(rtrim(@clim_created_dt  ))
                                ,ltrim(rtrim(@clim_lst_upd_dt ))
                                ,ltrim(rtrim(@modified ))
                                ,0
                           
                                )
  --
  SET @l_branch_cd  = ''
  SET @l_sub_broker = ''
  SET @l_trader = ''
  SET @l_c_adr_1 = ''
  SET @l_c_adr_city = ''
  SET @l_c_adr_2 = ''
  SET @l_c_adr_state = ''
  SET @l_c_adr_3 = ''
  SET @l_c_adr_country  = ''
  SET @l_c_adr_zip = ''
  SET @l_pan_gir_no = ''
  SET @l_ward_no = ''
  SET @l_sebi_regn_no = ''
  SET @l_res_ph1 = ''
  SET @l_res_ph2 = ''
  SET @l_off_ph1 = ''
  SET @l_off_ph2 = ''
  SET @l_mob1 = ''
  SET @l_fax1 = ''
  SET @l_email = ''
  SET @l_family   = ''
  SET @l_region  = ''
  SET @l_area  = ''
  SET @l_p_adr_1 = ''
  SET @l_p_adr_city = ''
  SET @l_p_adr_2 = ''
  SET @l_p_adr_state = ''
  SET @l_p_adr_3 = ''
  SET @l_p_adr_country  = ''
  SET @l_p_adr_zip = ''
  SET @l_pan_name  = ''
  SET @l_approver = ''
  SET @l_interactmode = ''
  SET @l_passport_no  = ''
  SET @l_passport_issued_at = ''
  SET @l_licence_no = ''
  SET @l_licence_issued_at = ''
  SET @l_rat_card_no = ''
  SET @l_rat_card_issued_at = ''
  SET @l_votersid_no = ''
  SET @l_votersid_issued_at = ''
  SET @l_it_return_yr = ''
  SET @l_regr_no = ''
  SET @l_regr_at = ''
  SET @l_regr_authority = ''
  SET @l_dealing_with_other_tm = ''
  SET @l_introducer_id  = ''
  SET @l_introducer = ''
  SET @l_introducer_relation = ''
  SET @l_sbum = ''
  SET @l_mapin_id = ''
  SET @l_ucc_code  = ''
  SET @l_fm_code = ''
  SET @l_drector_name = ''
  --SET @l_party_code = ''
  SET @l_rl_cd = ''
  --SET @l_group = ''
  set @l_paylocation = ''  --changed on 11/mar/2008
         --
         SET @l_error   = @@ERROR
         --
         IF @l_error > 0
         BEGIN --#1
         --
           SET @t_errorstr = @clim_short_name +' with party code ' + @l_party_code +' could not be migrated'
           --
           BREAK
         --
         END  --#1
         ELSE
         BEGIN
         --
           SET @t_errorstr = ''
         --
         END
    --
    END
    ELSE
    BEGIN
    --
       --
    print 'insert1'
    INSERT INTO client_details(client_id
                                ,branch_cd
                                ,party_code

                                ,sub_broker
                                ,trader
                                ,long_name
                                ,short_name
                                ,l_address1
                                ,l_city
                                ,l_address2
                                ,l_state
                                ,l_address3
                                ,l_nation
                                ,l_zip
                                ,pan_gir_no
                                ,ward_no
                                ,sebi_regn_no
                                ,res_phone1
                                ,res_phone2
                                ,off_phone1
                                ,off_phone2
                                ,mobile_pager
                                ,fax
                                ,email
                                ,cl_type
                                ,cl_status
                                ,family
                                ,region
                                ,area
                                ,p_address1
                                ,p_city
                                ,p_address2
                                ,p_state
                                ,p_address3
                                ,p_nation
                                ,p_zip
                                ,addemailid
                                ,sex
                                ,dob
                                ,approver
                                ,interactmode
                                ,passport_no
                                ,passport_issued_at
                                ,passport_issued_on
                                ,passport_expires_on
                                ,licence_no
                                ,licence_issued_at
                                ,licence_issued_on
                                ,licence_expires_on
                                ,rat_card_no
                                ,rat_card_issued_at
                                ,rat_card_issued_on
                                ,votersid_no
                                ,votersid_issued_at
                                ,votersid_issued_on
                                ,it_return_yr
                                ,it_return_filed_on
                                ,regr_no
                                ,regr_at
                                ,regr_on
                                ,regr_authority
                                ,client_agreement_on
                                ,dealing_with_other_tm
                                ,other_ac_no
                                ,introducer_id
                                ,introducer
                                ,introducer_relation
                                ,chk_kyc_form
                                ,chk_corporate_deed
                                ,chk_bank_certificate
                                ,chk_annual_report
                                ,chk_networth_cert
                                ,chk_corp_dtls_recd
                                ,sbu
                                ,modifidedby
                                ,modifiedon
                                ,mapin_id
                                ,ucc_code
                                ,fm_code
                                ,micr_no
                            
                                ,director_name
                                ,paylocation
                                ,cd_created_dt
                                ,cd_lst_upd_dt
                                ,cd_changed
                                ,migrate_yn
                              
                                )
                          VALUES(@clim_crn_no
                                ,left(ltrim(rtrim(@l_branch_cd )),10)
                                ,left(ltrim(rtrim(@l_party_code)),10) --@ucc_no         --party code
                           
                                ,left(ltrim(rtrim(@l_sub_broker)),10)
                                ,left(ltrim(rtrim(@l_trader )),20)
                                ,left(ltrim(rtrim(@clim_name1  )),100)
                                ,left(ltrim(rtrim(@clim_short_name )),100)
                                ,left(ltrim(rtrim(@l_c_adr_1 )),60)
                                ,left(ltrim(rtrim(@l_c_adr_city )),40)
                                ,left(ltrim(rtrim(@l_c_adr_2  )),60)
                                ,left(ltrim(rtrim(@l_c_adr_state)),50)
                                ,left(ltrim(rtrim(@l_c_adr_3 )),60)
                                ,left(ltrim(rtrim(@l_c_adr_country)),15)
                                ,left(ltrim(rtrim(@l_c_adr_zip )),25)
                                ,left(ltrim(rtrim(@l_pan_gir_no)),50)
                                ,left(ltrim(rtrim(@l_ward_no )),50)
                                ,left(ltrim(rtrim(@l_sebi_regn_no)),25)
                                ,left(ltrim(rtrim(@l_res_ph1 )),40)
                                ,left(ltrim(rtrim(@l_res_ph2 )),40)
                                ,left(ltrim(rtrim(@l_off_ph1 )),40)
                                ,left(ltrim(rtrim(@l_off_ph2)),40)
                                ,left(ltrim(rtrim(@l_mob1)),40)
                                ,left(ltrim(rtrim(@l_fax1 )),40)
                                ,left(ltrim(rtrim(@l_email )),230)
                                ,left(ltrim(rtrim(CONVERT(CHAR(3), @clim_enttm_cd) )),10)
                                ,left(ltrim(rtrim(CONVERT(CHAR(3), @clim_clicm_cd) )),10)
                                ,left(ltrim(rtrim(@l_family )),10)
                                ,left(ltrim(rtrim(@l_region )),50)
                                ,left(ltrim(rtrim(@l_area )),10)
                                ,left(ltrim(rtrim(@l_p_adr_1 )),60)
                                ,left(ltrim(rtrim(@l_p_adr_city)),20)
                                ,left(ltrim(rtrim(@l_p_adr_2)),60)
                                ,left(ltrim(rtrim(@l_p_adr_state)),50) --,(CASE WHEN @l_p_adr_state = 'INDIA' THEN '' ELSE @l_p_adr_state END)
                                ,left(ltrim(rtrim(@l_p_adr_3  )),60)
                                ,left(ltrim(rtrim(@l_p_adr_country)),15)
                                ,left(ltrim(rtrim(@l_p_adr_zip   )),10)
                                ,left(ltrim(rtrim(@l_pan_name  )),230)
                                ,left(ltrim(rtrim(@clim_gender)),8)
                                ,ltrim(rtrim(CONVERT(DATETIME,@clim_dob,104)))
                                ,left(ltrim(rtrim(@l_approver )),30)
                                ,left(ltrim(rtrim(@l_interactmode )),4)
                                ,left(ltrim(rtrim(@l_passport_no )),30)
                                ,left(ltrim(rtrim(@l_passport_issued_at )),30)
                                ,ltrim(rtrim(CONVERT(DATETIME,@l_passport_issued_on,104) ))
                                ,ltrim(rtrim(CONVERT(DATETIME,@l_passport_expires_on,104)))
                                ,left(ltrim(rtrim(@l_licence_no)),30)
                                ,left(ltrim(rtrim(@l_licence_issued_at )),30)
                                ,ltrim(rtrim(CONVERT(DATETIME,@l_licence_issued_on,104)))
                                ,ltrim(rtrim(CONVERT(DATETIME,@l_licence_expires_on,104) ))
                                ,left(ltrim(rtrim(@l_rat_card_no )),30)
                                ,left(ltrim(rtrim(@l_rat_card_issued_at)),30)
                                ,ltrim(rtrim(CONVERT(DATETIME,@l_rat_card_issued_on,104 ) ))
                                ,left(ltrim(rtrim(@l_votersid_no )),30)
                                ,left(ltrim(rtrim(@l_votersid_issued_at )),30)
                                ,ltrim(rtrim(CONVERT(DATETIME,@l_votersid_issued_on,104)))
                                ,left(ltrim(rtrim(@l_it_return_yr)),30)
                                ,ltrim(rtrim(CONVERT(DATETIME,@l_it_return_filed_on,104) ))
                                ,left(ltrim(rtrim(@l_regr_no)),50)
                                ,left(ltrim(rtrim(@l_regr_at)),50)
                                ,ltrim(rtrim(CONVERT(DATETIME,@l_regr_on,104 )))
                                ,left(ltrim(rtrim(@l_regr_authority)),50)
                                ,ltrim(rtrim(CONVERT(DATETIME,@l_client_agrement_on,104)))
                                ,left(ltrim(rtrim(@l_dealing_with_other_tm)),50)
                                ,0        --other account no
                                ,left(ltrim(rtrim(@l_introducer_id)),50)
                                ,left(ltrim(rtrim(@l_introducer )),50)
                                ,left(ltrim(rtrim(@l_introducer_relation )),50)
                                ,ltrim(rtrim(citrus_usr.getbit(convert(integer,@l_chk_flag),5)    ))     --chk_flg  bit-logic
                                ,ltrim(rtrim(citrus_usr.getbit(convert(integer,@l_chk_flag),4)    ))
                                ,ltrim(rtrim(citrus_usr.getbit(convert(integer,@l_chk_flag),3)    ))
                                ,ltrim(rtrim(citrus_usr.getbit(convert(integer,@l_chk_flag),2)   ))
                                ,ltrim(rtrim(citrus_usr.getbit(convert(integer,@l_chk_flag),1)  ))
                                ,ltrim(rtrim(citrus_usr.getbit(convert(integer,@l_chk_flag),0) ))
                                ,left(ltrim(rtrim(@l_sbum )),25)  --@clim_sbum_id
                                ,left(ltrim(rtrim(@clim_lst_upd_by )),25)
                                ,ltrim(rtrim(@clim_lst_upd_dt))
                                ,left(ltrim(rtrim(@l_mapin_id )),12)
                                ,left(ltrim(rtrim(@l_ucc_code )),12)
                                ,left(ltrim(rtrim(@l_fm_code )),16)
                                ,left(ltrim(rtrim(@banm_micr )),10) --micr no
                             
                                ,left(ltrim(rtrim(@l_drector_name )),100)
                                ,left(ltrim(rtrim(@l_paylocation )),20)	 --@banm_payloc_cd  changed on 11/amar/2008
                                ,ltrim(rtrim(@clim_created_dt  ))
                                ,ltrim(rtrim(@clim_lst_upd_dt ))
                                ,ltrim(rtrim(@modified ))
                                ,0
                             
                                )
  --
  --
  SET @l_branch_cd  = ''
  SET @l_sub_broker = ''
  SET @l_trader = ''
  SET @l_c_adr_1 = ''
  SET @l_c_adr_city = ''
  SET @l_c_adr_2 = ''
  SET @l_c_adr_state = ''
  SET @l_c_adr_3 = ''
  SET @l_c_adr_country  = ''
  SET @l_c_adr_zip = ''
  SET @l_pan_gir_no = ''
  SET @l_ward_no = ''
  SET @l_sebi_regn_no = ''
  SET @l_res_ph1 = ''
  SET @l_res_ph2 = ''
  SET @l_off_ph1 = ''
  SET @l_off_ph2 = ''
  SET @l_mob1 = ''
  SET @l_fax1 = ''
  SET @l_email = ''
  SET @l_family   = ''
  SET @l_region  = ''
  SET @l_area  = ''
  SET @l_p_adr_1 = ''
  SET @l_p_adr_city = ''
  SET @l_p_adr_2 = ''
  SET @l_p_adr_state = ''
  SET @l_p_adr_3 = ''
  SET @l_p_adr_country  = ''
  SET @l_p_adr_zip = ''
  SET @l_pan_name  = ''
  SET @l_approver = ''
  SET @l_interactmode = ''
  SET @l_passport_no  = ''
  SET @l_passport_issued_at = ''
  SET @l_licence_no = ''
  SET @l_licence_issued_at = ''
  SET @l_rat_card_no = ''
  SET @l_rat_card_issued_at = ''
  SET @l_votersid_no = ''
  SET @l_votersid_issued_at = ''
  SET @l_it_return_yr = ''
  SET @l_regr_no = ''
  SET @l_regr_at = ''
  SET @l_regr_authority = ''
  SET @l_dealing_with_other_tm = ''
  SET @l_introducer_id  = ''
  SET @l_introducer = ''
  SET @l_introducer_relation = ''
  SET @l_sbum = ''
  SET @l_mapin_id = ''
  SET @l_ucc_code  = ''
  SET @l_fm_code = ''
  SET @l_drector_name = ''
  --SET @l_party_code = ''
  SET @l_rl_cd = ''
  --SET @l_group = ''
  set @l_paylocation = ''
--
--
         SET @l_error   = @@ERROR
         --
       IF @l_error > 0
         BEGIN --#1
         --
         SET @t_errorstr = @clim_short_name +' with party code ' + @l_party_code +' could not be migrated'

           BREAK
         --
       END  --#1
       ELSE
         BEGIN                                                             --
           SET @t_errorstr = ''
         --
         END
       --
       END
       --
       --
     --
     IF EXISTS(select * from client_brok_details_hst where cl_code = @l_party_code  and migrate_yn in (1,3))
     --
     begin
     --

       set @modified = 'M'
     --
     end
     else
     begin
     --
       set @modified = 'N'
     --
     end
       --
       --
       --
       IF @clim_enttm_cd = 'INS'
      BEGIN
   --
   --
   SELECT @l_participant_cd_nse        = citrus_usr.fn_ucc_entp(@clim_crn_no,'PRT_CD_NSE','')
   SELECT @l_participant_cd_nsefo       = citrus_usr.fn_ucc_entp(@clim_crn_no,'PRT_CD_NSEFO','')
   SELECT @l_stp_provider_nse          = citrus_usr.fn_ucc_entpd(@clim_crn_no,'STP_STYLE_NSE','STP_PVDR_NSE','')
   SELECT @l_stp_style_nse             = case when citrus_usr.fn_ucc_entp(@clim_crn_no,'STP_STYLE_NSE','') = 'detail' then 0 when citrus_usr.fn_ucc_entp(@clim_crn_no,'STP_STYLE_NSE','') = 'summary' then 1  end
   SELECT @l_cont_gen_cd_nse           = case when citrus_usr.fn_ucc_entp(@clim_crn_no,'CNR_GEN_ST_NSE','')  = 'scrip wise' then 's' when citrus_usr.fn_ucc_entp(@clim_crn_no,'CNR_GEN_ST_NSE','')  = 'order wise' then 'o' when citrus_usr.fn_ucc_entp(@clim_crn_no,'CNR_GEN_ST_NSE','')  = 'normal' then 'N' end
   SELECT @l_roundin_method_nse        = citrus_usr.fn_ucc_entpd(@clim_crn_no,'CNR_GEN_ST_NSE','RND_MTH_NSE','')
   SELECT @l_rnd_to_digit_nse          = citrus_usr.fn_ucc_entpd(@clim_crn_no,'CNR_GEN_ST_NSE','RND_DGT_NSE','')
   --SELECT @l_custodian_code_NSE        = citrus_usr.fn_ucc_entp(@clim_crn_no,'CTD_CODE_NSE','')
   --
   --
   SELECT @l_participant_cd_slbnse        = citrus_usr.fn_ucc_entp(@clim_crn_no,'PRT_CD_NSESLBS','')   --ADDED BY VIVEK ON 29012009
   --
   --
   IF (citrus_usr.fn_ucc_entp(@clim_crn_no,'CTD_CODE_NSE','')) <> ''
     --
     BEGIN
     --
     SELECT @l_custodian_code_NSE  = SUBSTRING(citrus_usr.fn_ucc_entp(@clim_crn_no,'CTD_CODE_NSE',''),1,LEN(citrus_usr.fn_ucc_entp(@clim_crn_no,'CTD_CODE_NSE',''))-4)
     --
     if @l_custodian_code_NSE = '0'
     begin
     set @l_custodian_code_NSE = ''
     end
     --
     END
   ELSE
     --
     BEGIN
     SELECT @l_custodian_code_NSE = ''
   --
   END
   --
   END -- for condition of institutional clients
   --
   --
   --
   SELECT @l_participant_cd_bse        = citrus_usr.fn_ucc_entp(@clim_crn_no,'PRT_CD_BSE','')
   SELECT @l_participant_cd_bsefo      = citrus_usr.fn_ucc_entp(@clim_crn_no,'PRT_CD_BSEFO','')
   SELECT @l_stp_provider_bse          = citrus_usr.fn_ucc_entpd(@clim_crn_no,'STP_STYLE_BSE','STP_PVDR_BSE','')
   SELECT @l_stp_style_bse             = case when citrus_usr.fn_ucc_entp(@clim_crn_no,'STP_STYLE_BSE','') = 'detail' then 0 when citrus_usr.fn_ucc_entp(@clim_crn_no,'STP_STYLE_BSE','') = 'summary' then 1  end
   SELECT @l_cont_gen_cd_bse           = case when citrus_usr.fn_ucc_entp(@clim_crn_no,'CNR_GEN_ST_BSE','')  = 'scrip wise' then 's' when citrus_usr.fn_ucc_entp(@clim_crn_no,'CNR_GEN_ST_BSE','')  = 'order wise' then 'o'  when citrus_usr.fn_ucc_entp(@clim_crn_no,'CNR_GEN_ST_BSE','')  = 'normal' then 'N' end
   SELECT @l_roundin_method_bse        = citrus_usr.fn_ucc_entpd(@clim_crn_no,'CNR_GEN_ST_BSE','RND_MTH_BSE','')
   SELECT @l_rnd_to_digit_bse          = citrus_usr.fn_ucc_entpd(@clim_crn_no,'CNR_GEN_ST_BSE','RND_DGT_BSE','')
   --SELECT @l_custodian_code_BSE            = citrus_usr.fn_ucc_entp(@clim_crn_no,'CTD_CODE_BSE','')
   --@l_participant_cd_mcd
   SELECT @l_participant_cd_slbbse     = citrus_usr.fn_ucc_entp(@clim_crn_no,'PRT_CD_BSESLBS','')   --ADDED BY VIVEK ON 29012009
   SELECT @l_participant_cd_nsx        = citrus_usr.fn_ucc_entp(@clim_crn_no,'PRT_CD_NSXCURR','')   --ADDED BY VIVEK ON 29012009
   SELECT @l_participant_cd_mcd        = citrus_usr.fn_ucc_entp(@clim_crn_no,'PRT_CD_MCDCURR','')   --ADDED BY VIVEK ON 29012009
   --
   --
   IF (citrus_usr.fn_ucc_entp(@clim_crn_no,'CTD_CODE_BSE','')) <> ''
   --
     BEGIN
     --
     SELECT @l_custodian_code_BSE  = SUBSTRING(citrus_usr.fn_ucc_entp(@clim_crn_no,'CTD_CODE_BSE',''),1,LEN(citrus_usr.fn_ucc_entp(@clim_crn_no,'CTD_CODE_BSE',''))-4)
     --
     if @l_custodian_code_BSE = '0'
     begin
     set @l_custodian_code_BSE = ''
     end
     --
     END
   ELSE
     --
     BEGIN
     SELECT @l_custodian_code_BSE = ''
   --
   END
   --
   --END -- for condition of institutional clients
   --
   --END --dont know why
   --
   --
   SELECT @l_paymentmode        = citrus_usr.fn_get_listing('PAY_MODE',value)  FROM #entity_properties WHERE code = 'PAY_MODE'
   If ltrim(rtrim(isnull(@l_paymentmode ,'')))     = ''  set @l_paymentmode = ''
   --
   SELECT @l_b3bpayment        = citrus_usr.fn_get_listing('B3B_PAYMENT',value)  FROM #entity_properties WHERE code = 'B3B_PAYMENT'
   If ltrim(rtrim(isnull(@l_b3bpayment,'')))     = ''  set @l_b3bpayment = ''
   --
   SELECT @l_branch_name     = citrus_usr.fn_find_relations(@clim_crn_no,'BR')
   --
   --
   if @clim_stam_cd = 'ACTIVE'
   BEGIN
   SELECT @l_inactive_from = ''
   if convert(datetime,@l_inactive_from) = 'Jan 1 1900 12:00AM' set @l_inactive_from = null
   END
   --
   ELSE IF @clim_stam_cd = 'CI'
   BEGIN
   SELECT @l_inactive_from  =  convert(datetime,citrus_usr.fn_ucc_entp(@clim_crn_no,'INACTIVE_FROM',''),103)        --citrus_usr.fn_ucc_entp(@clim_crn_no,'PRT_CD_BSE','')
   END
      --
      --
   /* SELECT  @l_hdfc_nse_fno =  case when entp_value = 'HDFC' AND excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd = 'FNO' then 'HDFC BK - F&O CLIENT MONIES'      end
           ,@l_hdfc_nse_cash = case when entp_value = 'HDFC' AND excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd = 'CASH' then  'HDFC BANK NSE CLIENT MONIES A/C' end
           ,@l_hdfc_bse_cash = case when entp_value = 'HDFC' AND excsm.excsm_exch_cd = 'BSE' AND excsm.excsm_seg_cd = 'CASH' then  'HDFC BANK BSE CLIENT MONIES A/C'  end
           ,@l_citi_bse_cash = case when entp_value = 'CITI' AND excsm.excsm_exch_cd = 'BSE' AND excsm.excsm_seg_cd = 'CASH' then  'CITI BANK BSE CL MONIES ACCOUNT'   end
           ,@l_citi_nse_cash = case when entp_value = 'CITI' AND excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd = 'CASH' then  'CITI BANK NSE CL MONIES ACCOUNT'    end

          ,@l_excsm_cd = excsm.excsm_exch_cd
          ,@l_seg_cd = excsm.excsm_seg_cd
          --,@l_crn = entr_crn_no
          --, entm_short_name
    FROM entity_relationship entr WITH (NOLOCK) , client_sub_accts clisba WITH (NOLOCK)
       , client_accounts clia     WITH (NOLOCK)
       , exch_seg_mstr excsm      WITH (NOLOCK)
       , company_mstr compm       WITH (NOLOCK)
       , excsm_prod_mstr excpm    WITH (NOLOCK)
       , entity_properties entpm  WITH (NOLOCK)
       , entity_mstr entm         WITH (NOLOCK)

WHERE entr.entr_crn_no = clisba.clisba_crn_no
  AND entr.entr_acct_no = clisba.clisba_acct_no
  AND entr.entr_sba = clisba.clisba_no
  AND entr.entr_excpm_id = excpm.excpm_id
  AND clisba.clisba_crn_no = clia.clia_crn_no
  AND clisba.clisba_acct_no = clia.clia_acct_no
  AND compm.compm_id = excsm.excsm_compm_id
  AND clisba.clisba_excpm_id = excpm.excpm_id
  AND excpm.excpm_excsm_id = excsm.excsm_id
  AND isnull( citrus_usr.fn_get_single_access( clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc), 0) > 0
  AND LEFT(substring(entm_short_name,1,patindex('%[_]%',entm_short_name)-1),10) = citrus_usr.fn_find_relations(entr_crn_no,'BR')
  AND entr.entr_AR = entm_id
  AND entp_entpm_cd = 'PAY_BANK'
  and entp_ent_id = entm_id
  AND entr.entr_deleted_ind = 1
  AND clisba.clisba_deleted_ind = 1
  AND clia.clia_deleted_ind = 1
  AND excsm.excsm_deleted_ind = 1
  AND compm.compm_deleted_ind = 1
  AND excpm.excpm_deleted_ind = 1
  AND clisba.clisba_crn_no = @clim_crn_no
  AND    clia_acct_no            = @l_party_code
  --
  --    */
  IF EXISTS(SELECT cl_code FROM client_brok_details WHERE cl_code =  @l_party_code and  migrate_yn =0)
  --
  BEGIN
  --
           delete FROM client_brok_details WHERE cl_code =  @l_party_code and  migrate_yn =0
             --
	         --
             INSERT INTO client_brok_details(cl_code
             ,exchange
             ,segment
             ,profile_id
             ,status_flag
             ,Participant_Code
             ,Custodian_Code
             ,STP_Provider
             ,STP_Rp_Style
             ,Inst_Contract
             ,roundin_method
             ,Round_To_Digit
             ,clibd_created_dt
             ,clibd_lst_upd_dt
             ,clibd_changed
             ,migrate_yn
             ,pay_bank_name
             ,pay_branch_name
             ,pay_payment_mode
             ,pay_b3b_payment
             ,inactive_from
             )
             --select clia.clia_acct_no  from slb_mstr slbm,client_accounts clia where slbm.slb_client_cd = clia.clia_acct_no and slbm.slb_deleted_ind = 1 AND clia.clia_crn_no = @clim_crn_no
             --select * from slb_mstr
             SELECT distinct case when convert(char(6),excsm.excsm_exch_cd) = 'SLBNSE' AND excsm.excsm_seg_cd = 'SLBS' then (select clia.clia_acct_no /*slb_unique_id*/ from slb_mstr slbm,client_accounts clia where slbm.slb_client_cd = clia.clia_acct_no and slbm.slb_deleted_ind = 1 AND clia.clia_crn_no = @clim_crn_no) when convert(char(6),excsm.excsm_exch_cd) = 'SLBBSE' AND excsm.excsm_seg_cd = 'SLBS' then (select clia.clia_acct_no /*slb_unique_id*/ from slb_mstr slbm,client_accounts clia where slbm.slb_client_cd = clia.clia_acct_no and slbm.slb_deleted_ind = 1 AND clia.clia_crn_no = @clim_crn_no) else  clia.clia_acct_no end        --clia.clia_acct_no
                  , case when excsm.excsm_exch_cd = 'NCDEX' then  'NCX' when excsm.excsm_exch_cd ='SLBNSE' then  'NSE' when excsm.excsm_exch_cd ='SLBBSE' then  'BSE' else convert(char(3),excsm.excsm_exch_cd)  end
                  , case when excsm.excsm_seg_cd  = 'COMMODITIES' then 'DERIVATIVES' ELSE excsm.excsm_seg_cd END   --case when excsm.excsm_seg_cd  = 'CASH' then 'CASH' when excsm.excsm_seg_cd  = 'SLBS' then 'SLBS' when excsm.excsm_seg_cd  = 'FUTURES' then 'FUTURES' when excsm.excsm_seg_cd  = 'COMMODITIES' then 'DERIVATIVES'  END  --ELSE 'DERIVATIVES' --excsm.excsm_seg_cd
                  , isnull(clib_brom_id,'')         profile_id
				  , isnull(case when CLISBA_ACCESS2 = '02' then 'CI' when CLISBA_ACCESS2 = '01' then 'ACTIVE' end   ,'INACTIVE') --isnull(@clim_stam_cd,'INACTIVE')
                  , case when convert(char(3),excsm.excsm_exch_cd) = 'BSE' AND excsm.excsm_seg_cd = 'CASH' then left(@l_participant_cd_bse,15)
                         when convert(char(3),excsm.excsm_exch_cd) = 'NSE' AND excsm.excsm_seg_cd = 'CASH' then left(@l_participant_cd_nse,15)
                         when convert(char(3),excsm.excsm_exch_cd) = 'BSE' AND excsm.excsm_seg_cd = 'DERIVATIVES' then left( @l_participant_cd_bsefo,15)
                         when convert(char(3),excsm.excsm_exch_cd) = 'NSE' AND excsm.excsm_seg_cd = 'DERIVATIVES' then left(@l_participant_cd_nsefo,15)
                         when convert(char(6),excsm.excsm_exch_cd) = 'SLBNSE' AND excsm.excsm_seg_cd = 'SLBS' then left(@l_participant_cd_slbnse,15)       --added by vivek on 29012009
                         when convert(char(6),excsm.excsm_exch_cd) = 'SLBBSE' AND excsm.excsm_seg_cd = 'SLBS' then left(@l_participant_cd_slbbse,15)       --added by vivek on 29012009
                         when convert(char(3),excsm.excsm_exch_cd) = 'NSX' AND excsm.excsm_seg_cd = 'FUTURES' then left(@l_participant_cd_nsx,15)       --added by vivek on 29012009
                         when convert(char(3),excsm.excsm_exch_cd) = 'MCD' AND excsm.excsm_seg_cd = 'FUTURES' then left(@l_participant_cd_mcd,15)       --added by vivek on 29012009
                         else '' end
                  , case when convert(char(3),excsm.excsm_exch_cd) = 'BSE' then     left(@l_custodian_code_BSE,50)
                         when convert(char(3),excsm.excsm_exch_cd) = 'NSE' then     left(@l_custodian_code_NSE,50)
                         when convert(char(3),excsm.excsm_exch_cd) = 'NSX' then     left(@l_custodian_code_NSE,50) --ADDED BY VIVEK ON 22102008
                         when convert(char(6),excsm.excsm_exch_cd) = 'SLBNSE' then  left(@l_custodian_code_NSE,50) --ADDED BY VIVEK ON 22102008
                         when convert(char(6),excsm.excsm_exch_cd) = 'SLBBSE' then  left(@l_custodian_code_BSE,50) --ADDED BY VIVEK ON 22102008
                         when convert(char(3),excsm.excsm_exch_cd) = 'MCD' then     left(@l_custodian_code_NSE,50) --ADDED BY VIVEK ON 22102008
                         else '' end
                  , case when convert(char(3),excsm.excsm_exch_cd) = 'BSE' then     left(@l_stp_provider_bse,5)
                         when convert(char(3),excsm.excsm_exch_cd) = 'NSE' then     left(@l_stp_provider_nse,5)
                         when convert(char(6),excsm.excsm_exch_cd) = 'SLBNSE' then  left(@l_stp_provider_nse,5) --ADDED BY VIVEK ON 22102008
                         when convert(char(6),excsm.excsm_exch_cd) = 'SLBBSE' then  left(@l_stp_provider_bse,5) --ADDED BY VIVEK ON 22102008
                         else '' end
                  , case when convert(char(3),excsm.excsm_exch_cd) = 'BSE' then @l_stp_style_bse
                         when convert(char(3),excsm.excsm_exch_cd) = 'NSE' then @l_stp_style_nse
                         when convert(char(6),excsm.excsm_exch_cd) = 'SLBBSE' then @l_stp_style_bse      --ADDED BY VIVEK ON 22102008
                         when convert(char(6),excsm.excsm_exch_cd) = 'SLBNSE' then @l_stp_style_nse      --ADDED BY VIVEK ON 22102008
                         else '' end
                  , case when convert(char(3),excsm.excsm_exch_cd) = 'BSE' then left(@l_cont_gen_cd_bse,1)
                         when convert(char(3),excsm.excsm_exch_cd) = 'NSE' then left(@l_cont_gen_cd_nse,1)
                         when convert(char(6),excsm.excsm_exch_cd) = 'SLBBSE' then left(@l_cont_gen_cd_bse,1)  --ADDED BY VIVEK ON 22102008
                         when convert(char(6),excsm.excsm_exch_cd) = 'SLBNSE' then left(@l_cont_gen_cd_nse,1)  --ADDED BY VIVEK ON 22102008
                         when convert(char(3),excsm.excsm_exch_cd) = 'NSX' then left(@l_cont_gen_cd_nse,1)     --ADDED BY VIVEK ON 29012009
                         when convert(char(3),excsm.excsm_exch_cd) = 'MCD' then left(@l_cont_gen_cd_nse,1)     --ADDED BY VIVEK ON 29012009
                         else '' end
                  , case when convert(char(3),excsm.excsm_exch_cd) = 'BSE' then left(@l_roundin_method_bse,10)
                         when convert(char(3),excsm.excsm_exch_cd) = 'NSE' then left(@l_roundin_method_nse,10)
                         when convert(char(6),excsm.excsm_exch_cd) = 'SLBBSE' then left(@l_roundin_method_bse,10)  --ADDED BY VIVEK ON 22102008
                         when convert(char(6),excsm.excsm_exch_cd) = 'SLBNSE' then left(@l_roundin_method_nse,10)  --ADDED BY VIVEK ON 22102008
                         when convert(char(3),excsm.excsm_exch_cd) = 'NSX' then left(@l_roundin_method_nse,10)     --ADDED BY VIVEK ON 29012009
                         when convert(char(3),excsm.excsm_exch_cd) = 'MCD' then left(@l_roundin_method_nse,10)     --ADDED BY VIVEK ON 29012009
                         else '' end
                  , case when convert(char(3),excsm.excsm_exch_cd) = 'BSE' then @l_rnd_to_digit_bse
                         when convert(char(3),excsm.excsm_exch_cd) = 'NSE' then @l_rnd_to_digit_nse
                         when convert(char(6),excsm.excsm_exch_cd) = 'SLBBSE' then @l_rnd_to_digit_bse    --ADDED BY VIVEK ON 22102008
                         when convert(char(6),excsm.excsm_exch_cd) = 'SLBNSE' then @l_rnd_to_digit_nse    --ADDED BY VIVEK ON 22102008
                         when convert(char(3),excsm.excsm_exch_cd) = 'NSX' then @l_rnd_to_digit_nse       --ADDED BY VIVEK ON 29012009
                         when convert(char(3),excsm.excsm_exch_cd) = 'MCD' then @l_rnd_to_digit_nse       --ADDED BY VIVEK ON 29012009
                         else '' end
                  , clim.clim_created_dt  --getdate()
                  , clim.clim_lst_upd_dt  --getdate()
                  , case when exists(select cl_code,exchange,segment from client_brok_details_hst where cl_code = clia.clia_acct_no  and exchange = excsm.excsm_exch_cd and segment = excsm.excsm_seg_cd and migrate_yn in( 1,3) and clibd_changed = 'N' ) then 'M' else 'N' end --@modified
                  , 0
                  , case when @l_group IN ('PLATINUM','PWG PLATIN') THEN   --For clients which are of platinum group --changed on 31/mar/2008
					case when excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd       = 'DERIVATIVES'  then  'HDFC BK - F&O CLIENT MONIES'			--when entp_value = 'HDFC' AND
						 when excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd       = 'CASH'         then  'HDFC BANK NSE CLIENT MONIES A/C'      --when entp_value = 'HDFC' AND
						 when excsm.excsm_exch_cd = 'BSE' AND excsm.excsm_seg_cd       = 'CASH'         then  'HDFC BANK BSE CLIENT MONIES A/C'       --when entp_value = 'HDFC' AND --For platinum clients select exchangewise
                         when excsm.excsm_exch_cd = 'BSE' AND excsm.excsm_seg_cd       = 'DERIVATIVES'  then  'HDFC BANK BSE FO CLIENT MONEY A/C'
                         WHEN  excsm.excsm_exch_cd = 'NSX'    AND excsm.excsm_seg_cd   = 'FUTURES'      then  'HDFC BANK - CLIENT MONIES A/C'
                         WHEN  excsm.excsm_exch_cd = 'SLBNSE' AND excsm.excsm_seg_cd   = 'SLBS'         then  'HDFC BANK NSE CLIENT MONIES A/C'
                         WHEN  excsm.excsm_exch_cd = 'SLBBSE' AND excsm.excsm_seg_cd   = 'SLBS'         then  'HDFC BANK BSE CLIENT MONIES A/C'
                         WHEN  excsm.excsm_exch_cd = 'MCD'    AND excsm.excsm_seg_cd   = 'FUTURES'      then  'HDFC MCX CURRENCY CLIENT MONIES A/C'
						 when excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd       = 'DERIVATIVES'  then  'AXIS BANK LTD - 219010200009904'	
						 when excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd       = 'CASH'         then  'AXIS BANK LTD - 219010200009805'     
						 when excsm.excsm_exch_cd = 'BSE' AND excsm.excsm_seg_cd       = 'CASH'         then  'AXIS BANK LTD - 219010200009928'      
                         when excsm.excsm_exch_cd = 'BSE' AND excsm.excsm_seg_cd       = 'DERIVATIVES'  then  'AXIS BANK LTD - 219010200009928'			--changed on 14 JUN 2010 BY JITESH
						 END
					ELSE
					case when entp_value = 'HDFC' AND excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd = 'DERIVATIVES'  then  'HDFC BK - F&O CLIENT MONIES'
						when entp_value = 'HDFC' AND excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd = 'CASH' then  'HDFC BANK NSE CLIENT MONIES A/C'
						when entp_value = 'HDFC' AND excsm.excsm_exch_cd = 'BSE' AND excsm.excsm_seg_cd = 'CASH' then  'HDFC BANK BSE CLIENT MONIES A/C'
						when entp_value = 'HDFC' AND excsm.excsm_exch_cd = 'BSE' AND excsm.excsm_seg_cd = 'DERIVATIVES' then  'HDFC BANK BSE FO CLIENT MONEY A/C'       --changed on 12 may 2008
						when entp_value = 'CITI' AND excsm.excsm_exch_cd = 'BSE' AND excsm.excsm_seg_cd = 'CASH' then  'CITI BANK BSE CL MONIES ACCOUNT'
						when entp_value = 'CITI' AND excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd = 'CASH' then  'CITI BANK NSE CL MONIES ACCOUNT'
						when entp_value = 'CITI' AND excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd = 'DERIVATIVES'  then  'CITI BANK F&O CL MONIES ACCOUNT'
                        when entp_value = 'HDFC' AND  excsm.excsm_exch_cd = 'NSX'    AND excsm.excsm_seg_cd   = 'FUTURES'      then  'HDFC BANK - CLIENT MONIES A/C'
                        when entp_value = 'HDFC' AND  excsm.excsm_exch_cd = 'SLBNSE' AND excsm.excsm_seg_cd   = 'SLBS'         then  'HDFC BANK NSE CLIENT MONIES A/C'
                        when entp_value = 'HDFC' AND  excsm.excsm_exch_cd = 'SLBBSE' AND excsm.excsm_seg_cd   = 'SLBS'         then  'HDFC BANK BSE CLIENT MONIES A/C'
                        when entp_value = 'HDFC' AND  excsm.excsm_exch_cd = 'MCD'    AND excsm.excsm_seg_cd   = 'FUTURES'      then  'HDFC MCX CURRENCY CLIENT MONIES A/C'
						--end  --For clients other than Platinum     -- 14/03/2008
						when entp_value = 'AXIS' AND excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd = 'DERIVATIVES'  then  'AXIS BANK LTD - 219010200009904'
						when entp_value = 'AXIS' AND excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd = 'CASH' then  'AXIS BANK LTD - 219010200009805'
						when entp_value = 'AXIS' AND excsm.excsm_exch_cd = 'BSE' AND excsm.excsm_seg_cd = 'CASH' then  'AXIS BANK LTD - 219010200009928'
						when entp_value = 'AXIS' AND excsm.excsm_exch_cd = 'BSE' AND excsm.excsm_seg_cd = 'DERIVATIVES' then  'AXIS BANK LTD - 219010200009928'       --changed on 14 JUN 2010 BY JITESH
						else
						case when  excsm.excsm_exch_cd = 'MCX'    AND excsm.excsm_seg_cd   = 'COMMODITIES'  then  'MCX CLIENT MONIES A/C'
						     WHEN  excsm.excsm_exch_cd = 'NCDEX'  AND excsm.excsm_seg_cd   = 'COMMODITIES'  then  'NCDEX CLIENT MONIES A/C'

						END
                        END
                        END
                  , left(@l_branch_name,50)
                  , left(@l_paymentmode,1)
                  , left(@l_b3bpayment,1)
                  , case when CLISBA_ACCESS2 = 2 then clisba_inactive_from else @l_inactive_from  end	--, @l_inactive_from
             FROM   client_accounts           clia   WITH (NOLOCK)
                  , exch_seg_mstr             excsm  WITH (NOLOCK)
                  , client_sub_accts          clisba WITH (NOLOCK)
                  , client_brokerage          clib   WITH (NOLOCK)
                  , excsm_prod_mstr           excpm  WITH (NOLOCK)
                  , client_mstr               clim   WITH (NOLOCK)
                  , entity_relationship       entr   WITH (NOLOCK) -- 14/03/2008
                  , company_mstr              compm  WITH (NOLOCK) --
                  , entity_properties         entp  WITH (NOLOCK) --
                  , entity_mstr               entm   WITH (NOLOCK) -- 14/03/2008

             WHERE  clia.clia_crn_no        = @clim_crn_no
             AND    clia_acct_no            = @l_party_code
             AND    excpm.excpm_excsm_id    = excsm.excsm_id
             AND    clisba.clisba_excpm_id  = excpm.excpm_id
             AND    clia.clia_crn_no        = clim_crn_no
             AND    clisba.clisba_acct_no   = clia_acct_no
             AND    clia.clia_deleted_ind   = 1
             AND    excsm.excsm_deleted_ind = 1
             AND    clisba.clisba_id        = clib.clib_clisba_id
             AND    excsm_seg_cd IN ('CASH','DERIVATIVES','FUTURES','CAPITAL' ,'SLBS')
             AND    citrus_usr.fn_get_single_access(clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc) > 0
             AND    entr.entr_crn_no        = clisba.clisba_crn_no									-- 14/03/2008
             AND    entr.entr_acct_no       = clisba.clisba_acct_no									--
             AND    entr.entr_sba           = clisba.clisba_no										--
             AND    entr.entr_excpm_id      = excpm.excpm_id										--
             AND    clisba.clisba_crn_no    = clia.clia_crn_no										--
             AND    compm.compm_id          = excsm.excsm_compm_id									--
             --AND    LEFT(substring(entm_short_name,1,patindex('%[_]%',entm_short_name)-1),10) = citrus_usr.fn_find_relations(entr_crn_no,'BR')    --
             --AND    entr.entr_AR             = entm_id												-- 14/03/2008
             AND    entp.entp_entpm_cd         =  'BROK_PAY_BANK'  --'PAY_BANK'											--
             AND    entp.entp_ent_id           = @clim_crn_no   --entm.entm_id												--
             AND    entr.entr_deleted_ind      = 1														--
             AND    clisba.clisba_deleted_ind  = 1													--
             AND    compm.compm_deleted_ind    = 1														--
             AND    excpm.excpm_deleted_ind    = 1														--
             AND    clisba.clisba_crn_no       = @clim_crn_no											-- 14/03/2008

           --select * from exch_seg_mstr
           -- union

         /*  SELECT  clia.clia_acct_no    --clisba.clisba_no
           , case when excsm.excsm_exch_cd ='NCDEX' then  'NCX' else convert(char(3),excsm.excsm_exch_cd)  end
           , case when excsm.excsm_seg_cd  = 'CASH' then 'CASH' ELSE 'DERIVATIVES' END
           , isnull(clib_brom_id,'') profile_id
           , @clim_stam_cd
           , case when convert(char(3),excsm.excsm_exch_cd) = 'BSE' then @l_participant_cd_bse
                  when convert(char(3),excsm.excsm_exch_cd) = 'NSE' then @l_participant_cd_nse
                  else '' end
           , case when convert(char(3),excsm.excsm_exch_cd)= 'BSE' then @l_custodian_code_BSE
                  when convert(char(3),excsm.excsm_exch_cd) = 'NSE' then @l_custodian_code_NSE
                  else '' end
           , case when convert(char(3),excsm.excsm_exch_cd) = 'BSE' then @l_stp_provider_bse
                  when convert(char(3),excsm.excsm_exch_cd) = 'NSE' then @l_stp_provider_nse
                  else '' end
           , case when convert(char(3),excsm.excsm_exch_cd) = 'BSE' then @l_stp_style_bse
                  when convert(char(3),excsm.excsm_exch_cd) = 'NSE' then @l_stp_style_nse
                  else '' end
           , case when convert(char(3),excsm.excsm_exch_cd) = 'BSE' then @l_cont_gen_cd_bse
                  when convert(char(3),excsm.excsm_exch_cd) = 'NSE' then @l_cont_gen_cd_nse
                  else '' end
           , case when convert(char(3),excsm.excsm_exch_cd) = 'BSE' then @l_roundin_method_bse
                  when convert(char(3),excsm.excsm_exch_cd) = 'NSE' then @l_roundin_method_nse
                  else '' end
           , case when convert(char(3),excsm.excsm_exch_cd) = 'BSE' then @l_rnd_to_digit_bse
                  when convert(char(3),excsm.excsm_exch_cd) = 'NSE' then @l_rnd_to_digit_bse
                  else '' end
           , clim.clim_created_dt  --getdate()
           , clim.clim_lst_upd_dt  --getdate()
           , @modified
           , 0
           , case when entp_value = 'HDFC' AND excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd = 'FNO' then 'HDFC BK - F&O CLIENT MONIES A/C'
                  when entp_value = 'HDFC' AND excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd = 'CASH' then  'HDFC BANK NSE CLIENT MONIES A/C'
                  when entp_value = 'HDFC' AND excsm.excsm_exch_cd = 'BSE' AND excsm.excsm_seg_cd = 'CASH' then  'HDFC BANK BSE CLIENT MONIES A/C'
                  when entp_value = 'CITI' AND excsm.excsm_exch_cd = 'BSE' AND excsm.excsm_seg_cd = 'CASH' then  'CITI BANK BSE CL MONIES A/C'
                  when entp_value = 'CITI' AND excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd = 'CASH' then  'CITI BANK NSE CL MONIES A/C'
                  when entp_value = 'CITI' AND excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd = 'FNO'  then  'CITI BK - F&O CLIENT MONIES A/C'
                  end
                        /*case when (convert(char(3),excsm.excsm_exch_cd) = 'NSE' and excsm.excsm_seg_cd  = 'FNO')  then @l_hdfc_nse_fno
                         when (convert(char(3),excsm.excsm_exch_cd) = 'NSE' and excsm.excsm_seg_cd  = 'CASH') then CASE WHEN @l_hdfc_nse_cash = '' then @l_citi_nse_cash end
                         when (convert(char(3),excsm.excsm_exch_cd) = 'BSE' and excsm.excsm_seg_cd  = 'CASH') then CASE WHEN @l_hdfc_bse_cash = '' then @l_citi_bse_cash end
                         when (convert(char(3),excsm.excsm_exch_cd) = 'NSE' and excsm.excsm_seg_cd  = 'CASH') then CASE WHEN @l_citi_nse_cash  = '' then @l_hdfc_nse_cash end
                         when (convert(char(3),excsm.excsm_exch_cd) = 'BSE' and excsm.excsm_seg_cd  = 'CASH') then CASE WHEN @l_citi_bse_cash = '' then @l_hdfc_bse_cash end  end  --@l_bankname    */
             , @l_branch_name
             , @l_paymentmode
             , @l_b3bpayment
             FROM   client_accounts           clia   WITH (NOLOCK)
                  , exch_seg_mstr             excsm  WITH (NOLOCK)
                  , client_sub_accts          clisba WITH (NOLOCK)
                  , client_brokerage          clib   WITH (NOLOCK)
                  , excsm_prod_mstr           excpm  WITH (NOLOCK)
                  , client_mstr               clim   WITH (NOLOCK)
                  , entity_relationship       entr   WITH (NOLOCK) --
                  , company_mstr              compm  WITH (NOLOCK) --
                  , entity_properties         entpm  WITH (NOLOCK) --
                  , entity_mstr               entm   WITH (NOLOCK) --
             WHERE  clia.clia_crn_no        = @clim_crn_no
             AND    clia_acct_no            = @l_party_code
             AND    excpm.excpm_excsm_id    = excsm.excsm_id
             AND    clisba.clisba_excpm_id  = excpm.excpm_id
             AND    clisba.clisba_acct_no   = clia_acct_no
             AND    clia.clia_crn_no        = clim_crn_no
             AND    clia.clia_deleted_ind   = 1
             AND    excsm.excsm_deleted_ind = 1
             AND    clisba.clisba_id      = clib.clib_clisba_id
             AND    excsm_seg_cd IN ('CASH','DERIVATIVES','FUTURES','CAPITAL')
             AND    citrus_usr.fn_get_single_access(clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc) > 0
             AND    entr.entr_crn_no        = clisba.clisba_crn_no   -- 14/03/2008
             AND    entr.entr_acct_no       = clisba.clisba_acct_no  --
             AND    entr.entr_sba           = clisba.clisba_no       --
             AND    entr.entr_excpm_id      = excpm.excpm_id         --
             AND    clisba.clisba_crn_no    = clia.clia_crn_no       --
             AND    compm.compm_id          = excsm.excsm_compm_id   -- 14/03/2008
             AND    LEFT(substring(entm_short_name,1,patindex('%[_]%',entm_short_name)-1),10) = citrus_usr.fn_find_relations(entr_crn_no,'BR')    --
             AND    entr.entr_AR            = entm_id    -- 14/03/2008
             AND    entp_entpm_cd           = 'PAY_BANK' --
             AND    entp_ent_id             = entm_id    --
             AND    entr.entr_deleted_ind   = 1          --
             AND    clisba.clisba_deleted_ind  = 1       --
             AND    compm.compm_deleted_ind = 1          --
             AND    excpm.excpm_deleted_ind = 1          --
             AND    clisba.clisba_crn_no    = @clim_crn_no   --   14/03/2008*/
             --
             SET @l_participant_cd_nse = ''
             SET @l_stp_provider_nse = ''
             SET @l_stp_style_nse = ''
             SET @l_cont_gen_cd_nse = ''
             SET @l_roundin_method_nse = ''
             SET @l_rnd_to_digit_nse = ''
             SET @l_custodian_code_NSE = ''
			          set @l_participant_cd_nsefo =''
			          set @l_participant_cd_bsefo =''
             --
             SET @l_participant_cd_bse = ''
             SET @l_stp_provider_bse = ''
             SET @l_stp_style_bse = ''
             SET @l_cont_gen_cd_bse = ''
             SET @l_roundin_method_bse = ''
             SET @l_rnd_to_digit_bse = ''
             SET @l_custodian_code_BSE = ''
             --
             SET @l_bankname = ''
             SET @l_branch_name = ''
             SET @l_paymentmode = ''
             SET @l_b3bpayment  = ''
             SET @l_excsm_cd = ''
             SET @l_seg_cd = ''
             SET @l_branch = ''
             --
             --
             --
             set @l_inactive_from = ''
             --
             set @l_participant_cd_slbnse = ''
             set @l_participant_cd_slbbse = ''
             set @l_participant_cd_nsx    = ''
             set @l_participant_cd_mcd    = ''
             --
             --
             --
             SET @l_error   = @@ERROR
             --
          IF @l_error > 0
             BEGIN --#1
             --
               SET @t_errorstr = @clim_short_name +' with party code ' + @l_party_code +' could not be migrated'

               BREAK
             --
          END  --#1
          ELSE
             BEGIN
             --
               SET @t_errorstr = ''
      --
          END
          --
   END

-- IF NOT EXISTS(SELECT cl_code FROM client_brok_details WHERE cl_code =  @l_party_code and  migrate_yn =0)
   ELSE
          BEGIN
          --
          --
             INSERT INTO client_brok_details(cl_code
             ,exchange
             ,segment
             ,profile_id
             ,status_flag
             ,Participant_Code
             ,Custodian_Code
             ,STP_Provider
             ,STP_Rp_Style
             ,Inst_Contract
             ,roundin_method
             ,Round_To_Digit
             ,clibd_created_dt
             ,clibd_lst_upd_dt
             ,clibd_changed
             ,migrate_yn
             ,pay_bank_name
             ,pay_branch_name
             ,pay_payment_mode
             ,pay_b3b_payment
             ,inactive_from
             )
            SELECT distinct case when convert(char(6),excsm.excsm_exch_cd) = 'SLBNSE' AND excsm.excsm_seg_cd = 'SLBS' then (select clia.clia_acct_no /*slb_unique_id*/ from slb_mstr slbm,client_accounts clia where slbm.slb_client_cd = clia.clia_acct_no and slbm.slb_deleted_ind = 1 AND clia.clia_crn_no = @clim_crn_no) when convert(char(6),excsm.excsm_exch_cd) = 'SLBBSE' AND excsm.excsm_seg_cd = 'SLBS' then (select clia.clia_acct_no /*slb_unique_id*/ from slb_mstr slbm,client_accounts clia where slbm.slb_client_cd = clia.clia_acct_no and slbm.slb_deleted_ind = 1 AND clia.clia_crn_no = @clim_crn_no) else  clia.clia_acct_no end        --clia.clia_acct_no
                  , case when excsm.excsm_exch_cd = 'NCDEX' then  'NCX' when excsm.excsm_exch_cd ='SLBNSE' then  'NSE' when excsm.excsm_exch_cd ='SLBBSE' then  'BSE' else convert(char(3),excsm.excsm_exch_cd)  end
                  , case when excsm.excsm_seg_cd  = 'COMMODITIES' then 'DERIVATIVES' ELSE excsm.excsm_seg_cd END   --case when excsm.excsm_seg_cd  = 'CASH' then 'CASH' when excsm.excsm_seg_cd  = 'SLBS' then 'SLBS' when excsm.excsm_seg_cd  = 'FUTURES' then 'FUTURES' when excsm.excsm_seg_cd  = 'COMMODITIES' then 'DERIVATIVES'  END  --ELSE 'DERIVATIVES' --excsm.excsm_seg_cd
                  , isnull(clib_brom_id,'')         profile_id
                  , isnull(case when CLISBA_ACCESS2 = '02' then 'CI' when CLISBA_ACCESS2 = '01' then 'ACTIVE' end   ,'INACTIVE') --isnull(@clim_stam_cd,'INACTIVE')
                  , case when convert(char(3),excsm.excsm_exch_cd) = 'BSE' AND excsm.excsm_seg_cd = 'CASH' then left(@l_participant_cd_bse,15)
                         when convert(char(3),excsm.excsm_exch_cd) = 'NSE' AND excsm.excsm_seg_cd = 'CASH' then left(@l_participant_cd_nse,15)
                         when convert(char(3),excsm.excsm_exch_cd) = 'BSE' AND excsm.excsm_seg_cd = 'DERIVATIVES' then left( @l_participant_cd_bsefo,15)
                         when convert(char(3),excsm.excsm_exch_cd) = 'NSE' AND excsm.excsm_seg_cd = 'DERIVATIVES' then left(@l_participant_cd_nsefo,15)
                         when convert(char(6),excsm.excsm_exch_cd) = 'SLBNSE' AND excsm.excsm_seg_cd = 'SLBS' then left(@l_participant_cd_slbnse,15)       --added by vivek on 29012009
                         when convert(char(6),excsm.excsm_exch_cd) = 'SLBBSE' AND excsm.excsm_seg_cd = 'SLBS' then left(@l_participant_cd_slbbse,15)       --added by vivek on 29012009
                         when convert(char(3),excsm.excsm_exch_cd) = 'NSX' AND excsm.excsm_seg_cd = 'FUTURES' then left(@l_participant_cd_nsx,15)       --added by vivek on 29012009
                         when convert(char(3),excsm.excsm_exch_cd) = 'MCD' AND excsm.excsm_seg_cd = 'FUTURES' then left(@l_participant_cd_mcd,15)       --added by vivek on 29012009
                         else '' end
                  , case when convert(char(3),excsm.excsm_exch_cd) = 'BSE' then     left(@l_custodian_code_BSE,50)
                         when convert(char(3),excsm.excsm_exch_cd) = 'NSE' then     left(@l_custodian_code_NSE,50)
                         when convert(char(3),excsm.excsm_exch_cd) = 'NSX' then     left(@l_custodian_code_NSE,50) --ADDED BY VIVEK ON 22102008
                         when convert(char(6),excsm.excsm_exch_cd) = 'SLBNSE' then  left(@l_custodian_code_NSE,50) --ADDED BY VIVEK ON 22102008
                         when convert(char(6),excsm.excsm_exch_cd) = 'SLBBSE' then  left(@l_custodian_code_BSE,50) --ADDED BY VIVEK ON 22102008
                         when convert(char(3),excsm.excsm_exch_cd) = 'MCD' then     left(@l_custodian_code_NSE,50) --ADDED BY VIVEK ON 22102008
                         else '' end
                  , case when convert(char(3),excsm.excsm_exch_cd) = 'BSE' then     left(@l_stp_provider_bse,5)
                         when convert(char(3),excsm.excsm_exch_cd) = 'NSE' then     left(@l_stp_provider_nse,5)
                         when convert(char(6),excsm.excsm_exch_cd) = 'SLBNSE' then  left(@l_stp_provider_nse,5) --ADDED BY VIVEK ON 22102008
                         when convert(char(6),excsm.excsm_exch_cd) = 'SLBBSE' then  left(@l_stp_provider_bse,5) --ADDED BY VIVEK ON 22102008
                         else '' end
                  , case when convert(char(3),excsm.excsm_exch_cd) = 'BSE' then @l_stp_style_bse
                         when convert(char(3),excsm.excsm_exch_cd) = 'NSE' then @l_stp_style_nse
                         when convert(char(6),excsm.excsm_exch_cd) = 'SLBBSE' then @l_stp_style_bse      --ADDED BY VIVEK ON 22102008
                         when convert(char(6),excsm.excsm_exch_cd) = 'SLBNSE' then @l_stp_style_nse      --ADDED BY VIVEK ON 22102008
                         else '' end
                  , case when convert(char(3),excsm.excsm_exch_cd) = 'BSE' then left(@l_cont_gen_cd_bse,1)
                         when convert(char(3),excsm.excsm_exch_cd) = 'NSE' then left(@l_cont_gen_cd_nse,1)
                         when convert(char(6),excsm.excsm_exch_cd) = 'SLBBSE' then left(@l_cont_gen_cd_bse,1)  --ADDED BY VIVEK ON 22102008
                         when convert(char(6),excsm.excsm_exch_cd) = 'SLBNSE' then left(@l_cont_gen_cd_nse,1)  --ADDED BY VIVEK ON 22102008
                         when convert(char(3),excsm.excsm_exch_cd) = 'NSX' then left(@l_cont_gen_cd_nse,1)     --ADDED BY VIVEK ON 29012009
                         when convert(char(3),excsm.excsm_exch_cd) = 'MCD' then left(@l_cont_gen_cd_nse,1)     --ADDED BY VIVEK ON 29012009
                         else '' end
                  , case when convert(char(3),excsm.excsm_exch_cd) = 'BSE' then left(@l_roundin_method_bse,10)
                         when convert(char(3),excsm.excsm_exch_cd) = 'NSE' then left(@l_roundin_method_nse,10)
                         when convert(char(6),excsm.excsm_exch_cd) = 'SLBBSE' then left(@l_roundin_method_bse,10)  --ADDED BY VIVEK ON 22102008
                         when convert(char(6),excsm.excsm_exch_cd) = 'SLBNSE' then left(@l_roundin_method_nse,10)  --ADDED BY VIVEK ON 22102008
                         when convert(char(3),excsm.excsm_exch_cd) = 'NSX' then left(@l_roundin_method_nse,10)     --ADDED BY VIVEK ON 29012009
                         when convert(char(3),excsm.excsm_exch_cd) = 'MCD' then left(@l_roundin_method_nse,10)     --ADDED BY VIVEK ON 29012009
                         else '' end
                  , case when convert(char(3),excsm.excsm_exch_cd) = 'BSE' then @l_rnd_to_digit_bse
                         when convert(char(3),excsm.excsm_exch_cd) = 'NSE' then @l_rnd_to_digit_nse
                         when convert(char(6),excsm.excsm_exch_cd) = 'SLBBSE' then @l_rnd_to_digit_bse    --ADDED BY VIVEK ON 22102008
                         when convert(char(6),excsm.excsm_exch_cd) = 'SLBNSE' then @l_rnd_to_digit_nse    --ADDED BY VIVEK ON 22102008
                         when convert(char(3),excsm.excsm_exch_cd) = 'NSX' then @l_rnd_to_digit_nse       --ADDED BY VIVEK ON 29012009
                         when convert(char(3),excsm.excsm_exch_cd) = 'MCD' then @l_rnd_to_digit_nse       --ADDED BY VIVEK ON 29012009
                         else '' end
                  , clim.clim_created_dt  --getdate()
                  , clim.clim_lst_upd_dt  --getdate()
                  , case when exists(select cl_code,exchange,segment from client_brok_details_hst where cl_code = clia.clia_acct_no  and exchange = excsm.excsm_exch_cd and segment = excsm.excsm_seg_cd and migrate_yn in( 1,3) and clibd_changed = 'N' ) then 'M' else 'N' end --@modified
                  , 0
                  , case when @l_group IN ('PLATINUM','PWG PLATIN') THEN   --For clients which are of platinum group --changed on 31/mar/2008
					case when excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd       = 'DERIVATIVES'  then  'HDFC BK - F&O CLIENT MONIES'			--when entp_value = 'HDFC' AND
						 when excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd       = 'CASH'         then  'HDFC BANK NSE CLIENT MONIES A/C'      --when entp_value = 'HDFC' AND
						 when excsm.excsm_exch_cd = 'BSE' AND excsm.excsm_seg_cd       = 'CASH'         then  'HDFC BANK BSE CLIENT MONIES A/C'       --when entp_value = 'HDFC' AND --For platinum clients select exchangewise
                         when excsm.excsm_exch_cd = 'BSE' AND excsm.excsm_seg_cd       = 'DERIVATIVES'  then  'HDFC BANK BSE FO CLIENT MONEY A/C'
                         WHEN  excsm.excsm_exch_cd = 'NSX'    AND excsm.excsm_seg_cd   = 'FUTURES'      then  'HDFC BANK - CLIENT MONIES A/C'
                         WHEN  excsm.excsm_exch_cd = 'SLBNSE' AND excsm.excsm_seg_cd   = 'SLBS'         then  'HDFC BANK NSE CLIENT MONIES A/C'
                         WHEN  excsm.excsm_exch_cd = 'SLBBSE' AND excsm.excsm_seg_cd   = 'SLBS'         then  'HDFC BANK BSE CLIENT MONIES A/C'
                         WHEN  excsm.excsm_exch_cd = 'MCD'    AND excsm.excsm_seg_cd   = 'FUTURES'      then  'HDFC MCX CURRENCY CLIENT MONIES A/C'
						 when excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd       = 'DERIVATIVES'  then  'AXIS BANK LTD - 219010200009904'		
						 when excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd       = 'CASH'         then  'AXIS BANK LTD - 219010200009805'     
						 when excsm.excsm_exch_cd = 'BSE' AND excsm.excsm_seg_cd       = 'CASH'         then  'AXIS BANK LTD - 219010200009928'      
                         when excsm.excsm_exch_cd = 'BSE' AND excsm.excsm_seg_cd       = 'DERIVATIVES'  then  'AXIS BANK LTD - 219010200009928'			--changed on 14 JUN 2010 BY JITESH
						 END
					ELSE
					case when entp_value = 'HDFC' AND excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd = 'DERIVATIVES'  then  'HDFC BK - F&O CLIENT MONIES'
						when entp_value = 'HDFC' AND excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd = 'CASH' then  'HDFC BANK NSE CLIENT MONIES A/C'
						when entp_value = 'HDFC' AND excsm.excsm_exch_cd = 'BSE' AND excsm.excsm_seg_cd = 'CASH' then  'HDFC BANK BSE CLIENT MONIES A/C'
						when entp_value = 'HDFC' AND excsm.excsm_exch_cd = 'BSE' AND excsm.excsm_seg_cd = 'DERIVATIVES' then  'HDFC BANK BSE FO CLIENT MONEY A/C'       --changed on 12 may 2008
						when entp_value = 'CITI' AND excsm.excsm_exch_cd = 'BSE' AND excsm.excsm_seg_cd = 'CASH' then  'CITI BANK BSE CL MONIES ACCOUNT'
						when entp_value = 'CITI' AND excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd = 'CASH' then  'CITI BANK NSE CL MONIES ACCOUNT'
						when entp_value = 'CITI' AND excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd = 'DERIVATIVES'  then  'CITI BANK F&O CL MONIES ACCOUNT'
                        when entp_value = 'HDFC' AND  excsm.excsm_exch_cd = 'NSX'    AND excsm.excsm_seg_cd   = 'FUTURES'      then  'HDFC BANK - CLIENT MONIES A/C'
                        when entp_value = 'HDFC' AND  excsm.excsm_exch_cd = 'SLBNSE' AND excsm.excsm_seg_cd   = 'SLBS'         then  'HDFC BANK NSE CLIENT MONIES A/C'
                        when entp_value = 'HDFC' AND  excsm.excsm_exch_cd = 'SLBBSE' AND excsm.excsm_seg_cd   = 'SLBS'         then  'HDFC BANK BSE CLIENT MONIES A/C'
                        when entp_value = 'HDFC' AND  excsm.excsm_exch_cd = 'MCD'    AND excsm.excsm_seg_cd   = 'FUTURES'      then  'HDFC MCX CURRENCY CLIENT MONIES A/C'
						--end  --For clients other than Platinum     -- 14/03/2008
						when entp_value = 'AXIS' AND excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd = 'DERIVATIVES'  then  'AXIS BANK LTD - 219010200009904'
						when entp_value = 'AXIS' AND excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd = 'CASH' then  'AXIS BANK LTD - 219010200009805'
						when entp_value = 'AXIS' AND excsm.excsm_exch_cd = 'BSE' AND excsm.excsm_seg_cd = 'CASH' then  'AXIS BANK LTD - 219010200009928'
						when entp_value = 'AXIS' AND excsm.excsm_exch_cd = 'BSE' AND excsm.excsm_seg_cd = 'DERIVATIVES' then  'AXIS BANK LTD - 219010200009928'       --changed on 14 JUN 2010 BY JITESH
						else
						case when  excsm.excsm_exch_cd = 'MCX'    AND excsm.excsm_seg_cd   = 'COMMODITIES'  then  'MCX CLIENT MONIES A/C'
						     WHEN  excsm.excsm_exch_cd = 'NCDEX'  AND excsm.excsm_seg_cd   = 'COMMODITIES'  then  'NCDEX CLIENT MONIES A/C'

						END
                        END
                        END
                  , left(@l_branch_name,50)
                  , left(@l_paymentmode,1)
                  , left(@l_b3bpayment,1)
                  , case when CLISBA_ACCESS2 = 2 then clisba_inactive_from else @l_inactive_from  end --, @l_inactive_from
             FROM   client_accounts           clia   WITH (NOLOCK)
                  , exch_seg_mstr             excsm  WITH (NOLOCK)
                  , client_sub_accts          clisba WITH (NOLOCK)
                  , client_brokerage          clib   WITH (NOLOCK)
                  , excsm_prod_mstr           excpm  WITH (NOLOCK)
                  , client_mstr               clim   WITH (NOLOCK)
                  , entity_relationship       entr   WITH (NOLOCK) -- 14/03/2008
                  , company_mstr              compm  WITH (NOLOCK) --
                  , entity_properties         entp  WITH (NOLOCK) --
                  , entity_mstr               entm   WITH (NOLOCK) -- 14/03/2008

             WHERE  clia.clia_crn_no        = @clim_crn_no
             AND    clia_acct_no            = @l_party_code
             AND    excpm.excpm_excsm_id    = excsm.excsm_id
             AND    clisba.clisba_excpm_id  = excpm.excpm_id
             AND    clia.clia_crn_no        = clim_crn_no
             AND    clisba.clisba_acct_no   = clia_acct_no
             AND    clia.clia_deleted_ind   = 1
             AND    excsm.excsm_deleted_ind = 1
             AND    clisba.clisba_id        = clib.clib_clisba_id
             AND    excsm_seg_cd IN ('CASH','DERIVATIVES','FUTURES','CAPITAL','SLBS')
             AND    citrus_usr.fn_get_single_access(clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc) > 0
             AND    entr.entr_crn_no        = clisba.clisba_crn_no									-- 14/03/2008
             AND    entr.entr_acct_no       = clisba.clisba_acct_no									--
             AND    entr.entr_sba           = clisba.clisba_no										--
             AND    entr.entr_excpm_id      = excpm.excpm_id										--
             AND    clisba.clisba_crn_no    = clia.clia_crn_no										--
             AND    compm.compm_id          = excsm.excsm_compm_id									--
            -- AND    LEFT(substring(entm_short_name,1,patindex('%[_]%',entm_short_name)-1),10) = citrus_usr.fn_find_relations(entr_crn_no,'BR')    --
             --AND    entr.entr_AR            = entm_id												-- 14/03/2008
             AND    entp.entp_entpm_cd           = 'BROK_PAY_BANK'  --'PAY_BANK'											--
             AND    entp.entp_ent_id             = @clim_crn_no   --entm.entm_id												--
             AND    entr.entr_deleted_ind   = 1														--
             AND    clisba.clisba_deleted_ind  = 1													--
             AND    compm.compm_deleted_ind = 1														--
             AND    excpm.excpm_deleted_ind = 1														--
             AND    clisba.clisba_crn_no    = @clim_crn_no											-- 14/03/2008


          /*  union

           SELECT  clia.clia_acct_no    --clisba.clisba_no
           , case when excsm.excsm_exch_cd ='NCDEX' then  'NCX' else convert(char(3),excsm.excsm_exch_cd)  end
           , case when excsm.excsm_seg_cd  = 'CASH' then 'CASH' ELSE 'DERIVATIVES' END
           , isnull(clib_brom_id,'') profile_id
           , @clim_stam_cd
           , case when convert(char(3),excsm.excsm_exch_cd) = 'BSE' then @l_participant_cd_bse
                  when convert(char(3),excsm.excsm_exch_cd) = 'NSE' then @l_participant_cd_nse
                  else '' end
           , case when convert(char(3),excsm.excsm_exch_cd)= 'BSE' then @l_custodian_code_BSE
                  when convert(char(3),excsm.excsm_exch_cd) = 'NSE' then @l_custodian_code_NSE
                  else '' end
           , case when convert(char(3),excsm.excsm_exch_cd) = 'BSE' then @l_stp_provider_bse
                  when convert(char(3),excsm.excsm_exch_cd) = 'NSE' then @l_stp_provider_nse
                  else '' end
           , case when convert(char(3),excsm.excsm_exch_cd) = 'BSE' then @l_stp_style_bse
                  when convert(char(3),excsm.excsm_exch_cd) = 'NSE' then @l_stp_style_nse
                  else '' end
           , case when convert(char(3),excsm.excsm_exch_cd) = 'BSE' then @l_cont_gen_cd_bse
                  when convert(char(3),excsm.excsm_exch_cd) = 'NSE' then @l_cont_gen_cd_nse
                  else '' end
           , case when convert(char(3),excsm.excsm_exch_cd) = 'BSE' then @l_roundin_method_bse
                  when convert(char(3),excsm.excsm_exch_cd) = 'NSE' then @l_roundin_method_nse
                  else '' end
           , case when convert(char(3),excsm.excsm_exch_cd) = 'BSE' then @l_rnd_to_digit_bse
                  when convert(char(3),excsm.excsm_exch_cd) = 'NSE' then @l_rnd_to_digit_bse
                  else '' end
           , clim.clim_created_dt  --getdate()
           , clim.clim_lst_upd_dt  --getdate()
           , @modified
           , 0
           , case when entp_value = 'HDFC' AND excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd = 'FNO' then 'HDFC BK - F&O CLIENT MONIES A/C'
                  when entp_value = 'HDFC' AND excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd = 'CASH' then  'HDFC BANK NSE CLIENT MONIES A/C'
                  when entp_value = 'HDFC' AND excsm.excsm_exch_cd = 'BSE' AND excsm.excsm_seg_cd = 'CASH' then  'HDFC BANK BSE CLIENT MONIES A/C'
                  when entp_value = 'CITI' AND excsm.excsm_exch_cd = 'BSE' AND excsm.excsm_seg_cd = 'CASH' then  'CITI BANK BSE CL MONIES A/C'
                  when entp_value = 'CITI' AND excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd = 'CASH' then  'CITI BANK NSE CL MONIES A/C'
                  when entp_value = 'CITI' AND excsm.excsm_exch_cd = 'NSE' AND excsm.excsm_seg_cd = 'FNO'  then  'CITI BK - F&O CLIENT MONIES A/C'
                  end
                        /*case when (convert(char(3),excsm.excsm_exch_cd) = 'NSE' and excsm.excsm_seg_cd  = 'FNO')  then @l_hdfc_nse_fno
                         when (convert(char(3),excsm.excsm_exch_cd) = 'NSE' and excsm.excsm_seg_cd  = 'CASH') then CASE WHEN @l_hdfc_nse_cash = '' then @l_citi_nse_cash end
                         when (convert(char(3),excsm.excsm_exch_cd) = 'BSE' and excsm.excsm_seg_cd  = 'CASH') then CASE WHEN @l_hdfc_bse_cash = '' then @l_citi_bse_cash end
                         when (convert(char(3),excsm.excsm_exch_cd) = 'NSE' and excsm.excsm_seg_cd  = 'CASH') then CASE WHEN @l_citi_nse_cash  = '' then @l_hdfc_nse_cash end
                         when (convert(char(3),excsm.excsm_exch_cd) = 'BSE' and excsm.excsm_seg_cd  = 'CASH') then CASE WHEN @l_citi_bse_cash = '' then @l_hdfc_bse_cash end  end  --@l_bankname    */
             , @l_branch_name
             , @l_paymentmode
             , @l_b3bpayment
             FROM   client_accounts           clia   WITH (NOLOCK)
                  , exch_seg_mstr             excsm  WITH (NOLOCK)
                  , client_sub_accts          clisba WITH (NOLOCK)
                  , client_brokerage          clib   WITH (NOLOCK)
                  , excsm_prod_mstr           excpm  WITH (NOLOCK)
                  , client_mstr               clim   WITH (NOLOCK)
                  , entity_relationship       entr   WITH (NOLOCK) --
                  , company_mstr              compm  WITH (NOLOCK) --
                  , entity_properties         entp  WITH (NOLOCK) --
                  , entity_mstr               entm   WITH (NOLOCK) --
             WHERE  clia.clia_crn_no        = @clim_crn_no
             AND    clia_acct_no            = @l_party_code
             AND    excpm.excpm_excsm_id    = excsm.excsm_id
             AND    clisba.clisba_excpm_id  = excpm.excpm_id
             AND    clisba.clisba_acct_no   = clia_acct_no
             AND    clia.clia_crn_no        = clim_crn_no
             AND    clia.clia_deleted_ind   = 1
             AND    excsm.excsm_deleted_ind = 1
             AND    clisba.clisba_id      = clib.clib_clisba_id
             AND    excsm_seg_cd IN ('CASH','DERIVATIVES','FUTURES','CAPITAL')
             AND    citrus_usr.fn_get_single_access(clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc) > 0
             AND    entr.entr_crn_no        = clisba.clisba_crn_no   -- 14/03/2008
             AND    entr.entr_acct_no       = clisba.clisba_acct_no  --
             AND    entr.entr_sba           = clisba.clisba_no       --
             AND    entr.entr_excpm_id      = excpm.excpm_id         --
             AND    clisba.clisba_crn_no    = clia.clia_crn_no       --
             AND    compm.compm_id          = excsm.excsm_compm_id   -- 14/03/2008
             AND    LEFT(substring(entm_short_name,1,patindex('%[_]%',entm_short_name)-1),10) = citrus_usr.fn_find_relations(entr_crn_no,'BR')    --
             AND    entr.entr_AR            = entm_id    -- 14/03/2008
             AND    entp.entp_entpm_cd           = 'BROK_PAY_BANK'  --'PAY_BANK' --
             AND    entp.entp_ent_id             = entm.entm_id    --
             AND    entr.entr_deleted_ind   = 1          --
             AND    clisba.clisba_deleted_ind  = 1       --
             AND    compm.compm_deleted_ind = 1          --
             AND    excpm.excpm_deleted_ind = 1          --
             AND    clisba.clisba_crn_no    = @clim_crn_no*/   --   14/03/2008


             SET @l_participant_cd_nse = ''
             SET @l_stp_provider_nse = ''
             SET @l_stp_style_nse = ''
             SET @l_cont_gen_cd_nse = ''
             SET @l_roundin_method_nse = ''
             SET @l_rnd_to_digit_nse = ''
             SET @l_custodian_code_NSE = ''
             --
             set @l_participant_cd_nsefo =''
			 set @l_participant_cd_bsefo =''
             --
             SET @l_participant_cd_bse = ''
             SET @l_stp_provider_bse = ''
             SET @l_stp_style_bse = ''
             SET @l_cont_gen_cd_bse = ''
             SET @l_roundin_method_bse = ''
             SET @l_rnd_to_digit_bse = ''
             SET @l_custodian_code_BSE = ''
             --
             SET @l_bankname = ''
             SET @l_branch_name = ''
             SET @l_paymentmode = ''
             SET @l_b3bpayment  = ''
             SET @l_excsm_cd = ''
             SET @l_seg_cd = ''
             SET @l_branch = ''
             --
             set @l_inactive_from = ''
             --
             set @l_participant_cd_slbnse = ''
             set @l_participant_cd_slbbse = ''
             set @l_participant_cd_nsx    = ''
             set @l_participant_cd_mcd    = ''
             --
             --
             --
             SET @l_error   = @@ERROR
             --
          IF @l_error > 0
             BEGIN --#1
             --
               SET @t_errorstr = @clim_short_name +' with party code ' + @l_party_code +' could not be migrated'

               BREAK
             --
          END  --#1
          ELSE
             BEGIN
             --
               SET @t_errorstr = ''
          --
          END
          --
   END
   --



    FETCH NEXT FROM  @c_client_mstr
    INTO @clim_crn_no
       , @clim_name1
       , @clim_short_name
       , @clim_enttm_cd
       , @clim_clicm_cd
       , @clim_gender
       , @clim_dob
       , @clim_sbum_id
       , @clim_stam_cd
       , @banm_micr
       , @cliba_ac_type
       , @cliba_ac_no
       , @banm_name
       , @banm_branch
       , @banm_payloc_cd
       , @clim_created_dt
       , @clim_lst_upd_dt
       , @clim_lst_upd_by
       , @modified
       , @ucc_no
       , @Depository1
       , @DpId1
       , @CltDpId1
       , @Poa1
  --
  END   --#cursor
  CLOSE      @c_client_mstr
  DEALLOCATE @c_client_mstr

  SET @pa_err = @t_errorstr
--
END

GO
