-- Object: PROCEDURE citrus_usr.pr_select_mig_tab
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--SP_who2
--select * from x_partycode_commodities order by 3 desc
--SELECT * from x_partycode order by 3 desc
--select * from client_mstr order by clim_lst_upd_dt desc
--select * from client_details order by cd_lst_upd_dt desc
--pr_select_mig_tab  '','','','client_details','03/10/2009','08/10/2009','',''
--pr_select_mig_tab  '','','','client_details_commodities','03/10/2009','08/10/2009','',''
--sp_help client_brok_details
--pr_select_mig_tab  '','client_details','29/09/2008','29/09/2008','',''
--PR_CLIENT '','CLIENT_BROK_DETAILS','01/03/2008','14/03/2008','',''
--select * from client_brok_details_HST
--select * from client_details WHERE PARTY_CODE = '11410211'
--select * from migration_details order by id desc
--delete from migration_details where id = 1311
CREATE  PROCEDURE [citrus_usr].[pr_select_mig_tab]( --@l_id      VARCHAR(25)
                                                @PA_FROMCD   VARCHAR(25)    --added by vivek on 081009
                                                ,@PA_TOCD   VARCHAR(25)      --added by vivek on 081009
                                                 ,@PA_EXCD    VARCHAR(1000)  --added by vivek on 081009
                                                ,@pa_tab     VARCHAR(100)
                                                ,@pa_from_dt VARCHAR(11)
                                                ,@pa_to_dt   VARCHAR(11)
                                                ,@pa_err     VARCHAR(250)   OUTPUT
                                                ,@pa_ref_cur VARCHAR(8000)  OUTPUT
                                                )
AS
BEGIN
--
  DECLARE @l_error  VARCHAR(250)
        , @l_id     varchar(25)
  --
set @l_id = ''
  --
  IF @pa_tab = 'AREA'
  BEGIN
  --
    exec pr_insert_hst 'area'
    EXEC pr_entm_migrate @l_id, @pa_tab, @pa_from_dt, @pa_to_dt , @l_error output
    --
    --
    IF ISNULL(@l_error,'') = ''
    BEGIN
    --
      SELECT DISTINCT ar_id          Id
            ,ISNULL(areacode,'')     Areacode
            ,ISNULL(description,'')  Description
            ,branch_code             Branch_Code
            ,''                      Dummy1
            ,''                      Dummy2
            ,ar_changed              Modified
            ,ar_lst_upd_dt           ar_lst_upd_dt
      FROM   area
      WHERE  migrate_yn = 0
      AND    ar_lst_upd_dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
      order by ar_lst_upd_dt desc
    --
    --
    END
    --
    ELSE
    BEGIN
    --
      SET @pa_err = @l_error
    --
    END
    --
  --
  END
  --
  ELSE IF @pa_tab = 'custodian'
    BEGIN
    --
      exec pr_insert_hst 'custodian'
      EXEC pr_entm_migrate @l_id, @pa_tab, @pa_from_dt, @pa_to_dt , @l_error output
      --
      --
      IF ISNULL(@l_error,'') = ''
      BEGIN
      --
        SELECT DISTINCT cd_id       ID
               ,custodiancode
               ,short_name
               ,long_name
               ,address1
               ,address2
               ,city
               ,state
               ,nation
               ,zip
               ,fax
               ,off_phone1
               ,off_phone2
               ,email
               ,cltdpno
               ,dpid
               ,sebiregno
               ,exchange
               ,segment
               ,cd_changed      Modified
               ,cd_lst_upd_dt   cd_lst_upd_dt
        FROM   custodian_mstr
        WHERE  migrate_yn = 0
        AND ISNULL(EXCHANGE,'') <> ''
        AND ISNULL(SEGMENT,'') <> ''
        AND    cd_lst_upd_dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
        order by cd_lst_upd_dt desc
      --
      END
      ELSE
      BEGIN
      --
        SET @pa_err = @l_error
      --
      END
  --
  END
  ELSE IF @pa_tab = 'sbu_master'
  BEGIN
  --
    exec pr_insert_hst 'sbu_master'
    EXEC pr_entm_migrate @l_id, @pa_tab, @pa_from_dt, @pa_to_dt , @l_error output
    --
    --
    IF ISNULL(@l_error,'') = ''
    BEGIN
    --
      SELECT DISTINCT rm_id                   Id
       ,Sbu_Code
       ,Sbu_Name
       ,Sbu_Addr1
       ,Sbu_Addr2
       ,Sbu_Addr3
       ,Sbu_City
       ,Sbu_State
       ,Sbu_Zip
       ,Sbu_Phone1
       ,Sbu_Phone2
       ,Sbu_Type
       ,Sbu_Party_Code
       ,relm_changed  Modified
       ,relm_lst_upd_dt     relm_lst_upd_dt
      FROM   relation_mgr
      WHERE  migrate_yn = 0
      AND    relm_lst_upd_dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
      order by relm_lst_upd_dt desc
    --
    END
    ELSE
    BEGIN
    --
      SET @pa_err = @l_error
    --
    END
    --
  --
  END
  ELSE IF @pa_tab = 'BRANCH'
  BEGIN                                      --
    exec pr_insert_hst 'branch'
    EXEC pr_entm_migrate @l_id, @pa_tab, @pa_from_dt, @pa_to_dt , @l_error output
    --
    --
    IF ISNULL(@l_error,'') = ''
    BEGIN
    --
      SELECT DISTINCT br_id                     Id
            ,branch_code						Branch_Code
            ,ISNULL(branch,'')					Branch
            ,ISNULL(long_name,'')				Long_Name
            ,left(ISNULL(address1,''),25)       Address1
            ,left(ISNULL(address2,''),25)       Address2
            ,left(ISNULL(city,''),20)           City
            ,left(ISNULL(state,''),15)          State
            ,ISNULL(nation,'')         Nation
            ,ISNULL(zip,'')            Zip
            ,ISNULL(phone1,'')         Phone1
            ,ISNULL(phone2,'')         Phone2
            ,ISNULL(fax,'')            Fax
            ,ISNULL(email,'')          Email
            ,0         Remote
            ,0                         Security_Net
            ,0                         Money_Net
            ,''                        Excise_Reg
            ,ISNULL(contact_person,'') Contact_Person
            ,ISNULL(prefix,'')         Prefix
            ,br_changed                Modified
            ,br_lst_upd_dt             br_lst_upd_dt
      FROM   branch
      WHERE  migrate_yn = 0
      AND    br_lst_upd_dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
      order by br_lst_upd_dt desc
    --
    END
    --
    ELSE
    BEGIN
    --
      SET @pa_err = @l_error
    --
    END
    --
  --
END
--
  ELSE IF @pa_tab = 'BRANCHES'
  BEGIN
  --
    exec pr_insert_hst 'branches'
    EXEC pr_entm_migrate @l_id, @pa_tab, @pa_from_dt, @pa_to_dt ,@l_error output
    --
    IF ISNULL(@l_error,'') = ''
    BEGIN
    --
      SELECT DISTINCT dl_id                     Id
            ,branch_cd                 Branch_cd
            ,short_name                Short_Name
            ,ISNULL(long_name,'')      Long_Name
            ,ISNULL(address1,'')       Address1
            ,ISNULL(address2,'')       Address2
            ,ISNULL(city,'')           City
            ,ISNULL(state,'')          State
            ,ISNULL(nation,'')         Nation
            ,ISNULL(zip,'')            Zip
            ,ISNULL(phone1,'')         Phone1
            ,ISNULL(phone2,'')         Phone2
            ,ISNULL(fax,'')            Fax
            ,ISNULL(email,'')          Email
            ,0                         Remote
            ,0                         Security_Net
            ,0                         Money_Net
            ,''                        Excise_Reg
            ,ISNULL(contact_person,'') Contact_Person
            ,0                  Com_Perc
            ,ISNULL(terminal_id,'')    Terminal_Id
            ,0                         Deftrader
            ,dl_changed                Modified
            ,dl_lst_upd_dt             dl_lst_upd_dt
      FROM   branches
      WHERE  migrate_yn = 0
      AND    dl_lst_upd_dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
      order by dl_lst_upd_dt desc
    --
    END
    ELSE
    BEGIN
    --
      SET @pa_err = @l_error
    --
    END

  --
  END

  
  ELSE IF @pa_tab = 'CLIENT_DETAILS'
  BEGIN
  --
    exec pr_insert_hst 'client_details'
    exec pr_insert_hst 'client_brok_details'
    --
    --
    EXEC pr_client_details_migrate @l_id, @pa_from_dt, @pa_to_dt,@l_error output
    exec pr_rpt_clientcode @l_id ,@pa_from_dt ,@pa_to_dt ,@l_error output
    --
    --
--print 'abc'
    --
    IF ISNULL(@l_error,'') = ''
    BEGIN
    --
      --
      SELECT DISTINCT          --client_id
             party_code         Cl_code

            ,ISNULL(branch_cd,'')      branch_cd
            ,party_code
            ,sub_broker
            ,ISNULL(trader,'')       trader
            ,ISNULL(long_name,'')      long_name
            ,left(short_name,21)      short_name
            ,l_address1
            ,ISNULL(l_city,'')       l_city
            ,ISNULL(l_address2,'')      l_address2
            ,CASE WHEN ISNULL(l_state,'') = 'INDIA' THEN '' ELSE  ISNULL(l_state,'') END             l_state
            ,ISNULL(l_address3,'')      l_address3
            ,ISNULL(l_nation,'')      l_nation
            ,left(ISNULL(l_zip,''),10)     l_zip
            ,ISNULL(pan_gir_no,'')      pan_gir_no
            ,ISNULL(ward_no,'')       ward_no
            ,ISNULL(sebi_regn_no,'')     sebi_regn_no
            ,left(ISNULL(res_phone1,''),15)    res_phone1
            ,left(ISNULL(res_phone2,''),15)    res_phone2
            ,left(ISNULL(off_phone1,''),15)    off_phone1
            ,left(ISNULL(off_phone2,''),15)    off_phone2
            ,ISNULL(mobile_pager,'')     mobile_pager
            ,left(ISNULL(fax,''),15)     fax
            ,ISNULL(email,'')       email
            ,left(cl_type,3)       cl_type
            ,left(cl_status,3)       cl_status
            ,family
            ,left(ISNULL(region,''),20)     region
            ,ISNULL(area,'')       area
            ,ISNULL(p_address1,'')      p_address1
            ,ISNULL(p_city,'')       p_city
            ,ISNULL(p_address2,'')      p_address2
            ,ISNULL(p_state,'')       p_state
            ,ISNULL(p_address3,'')      p_address3
            ,ISNULL(p_nation,'')      p_nation
            ,ISNULL(p_zip,'')       p_zip
            ,''           p_phone

            ,ISNULL(addemailid,'')      addemailid
            ,left(ISNULL(sex,''),1)      sex
            ,ISNULL(dob,'')        dob
            ,ISNULL(approver,'')      approver
            ,ISNULL(interactmode,'')     interactmode
            ,ISNULL(passport_no,'')      passport_no
            ,ISNULL(passport_issued_at,'')    passport_issued_at
            ,ISNULL(passport_issued_on,'')    passport_issued_on
            ,ISNULL(passport_expires_on,'')    passport_expires_on
            ,ISNULL(licence_no,'')      licence_no
            ,ISNULL(licence_issued_at,'')    licence_issued_at
            ,ISNULL(licence_issued_on,'')    licence_issued_on
            ,ISNULL(licence_expires_on,'')    licence_expires_on
            ,ISNULL(rat_card_no,'')      rat_card_no
            ,ISNULL(rat_card_issued_at,'')    rat_card_issued_at
            ,ISNULL(rat_card_issued_on,'')    rat_card_issued_on
            ,ISNULL(votersid_no,'')      votersid_no
            ,ISNULL(votersid_issued_at,'')    votersid_issued_at
            ,ISNULL(votersid_issued_on,'')    votersid_issued_on
            ,ISNULL(it_return_yr,'')     it_return_yr
            ,ISNULL(it_return_filed_on,'')    it_return_filed_on
            ,ISNULL(regr_no,'')       regr_no
            ,ISNULL(regr_at,'')       regr_at
            ,ISNULL(regr_on,'')       regr_on
            ,ISNULL(regr_authority,'')     regr_authority
            ,ISNULL(client_agreement_on,'')    client_agreement_on
            ,''           sett_mode
            ,ISNULL(dealing_with_other_tm,'')   dealing_with_other_tm
            ,ISNULL(other_ac_no,'')      other_ac_no
            ,ISNULL(introducer_id,'')     introducer_id
            ,left(ISNULL(introducer,''),30)    introducer
            ,ISNULL(introducer_relation,'')    introducer_relation
            ,0           repatriat_bank
            ,''           repatriat_bank_ac_no
            ,ISNULL(chk_kyc_form,0)      chk_kyc_form
            ,ISNULL(chk_corporate_deed,0)    chk_corporate_deed
            ,ISNULL(chk_bank_certificate ,0)   chk_bank_certificate
            ,ISNULL(chk_annual_report,0)    chk_annual_report
            ,ISNULL(chk_networth_cert,0)    chk_networth_cert
            ,ISNULL(chk_corp_dtls_recd,0)    chk_corp_dtls_recd




            ,''           depository2
            ,''           dpid2
            ,''           cltdpid2
            ,''           poa2
            ,''           depository3
            ,''           dpid3
            ,''           cltdpid3
            ,''        poa3


            ,left(ISNULL(sbu,''),10)     sbu
            ,''           status
            ,0           imp_status
            ,ISNULL(modifidedby,'')      modifidedby
            ,ISNULL(modifiedon,'')      ModifidedOn
            ,0           bank_id
            ,ISNULL(mapin_id,'')      mapin_id
            ,ISNULL(ucc_code,'')      ucc_code
            ,left(ISNULL(fm_code,''),10)    FMCode
            ,ISNULL(micr_no,'')       micr_no




            ,ISNULL(director_name,'')     director_name
            ,ISNULL(paylocation,'')      paylocation
            ,cd_created_dt
            --,cd_lst_upd_dt
            ,migrate_yn
            ,cd_changed         Modified
            ,cd_lst_upd_dt        cd_lst_upd_dt
      FROM   client_details
      WHERE  migrate_yn   = 0
      AND    (cd_lst_upd_dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
             or cd_created_dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59')
      AND    ( party_code in (select party_code from client_details_hst))  --Modified Status Flag = 'Active' to 'CI' on 06-02-2010 for Testing Purpose
      and    party_code between convert(varchar,@PA_FROMCD) and convert(varchar,@PA_TOCD)
      and    party_code <> isnull(convert(varchar,@PA_EXCD),'')
      order by cd_lst_upd_dt desc
    --
    --
    --
--    if exists(
--    select dt from x_partycode where dt BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
--    )
--    --
--    begin
--    select * from x_partycode
--    where dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
--    order by dt desc
--    --
--    end
--    --
--    else
--    begin
--    select @pa_err = 'NO DATA FOUND FOR ERROR CLIENTS BETWEEN THE DATE RANGE'
--    end
    --
    --
    --
    --
    END
    ELSE
    BEGIN
    --
      SET @pa_err = @l_error
    --
    END
  --
  END
  --
  --
  
  ELSE IF @pa_tab = 'MULTIBANKID'
  BEGIN
  --
    exec pr_insert_hst 'multibankid'
    EXEC pr_cliba_migrate @l_id, @pa_from_dt, @pa_to_dt,@l_error output
    exec pr_rpt_bank_error @l_id ,@pa_from_dt ,@pa_to_dt ,@l_error output
    --
    IF ISNULL(@l_error,'') = ''
    BEGIN
    --
    --
    SELECT cltcd          CltCode
            ,Accno          Accno
            ,Acctype        Acctype
            ,Chequename     Chequename
            ,Defaultbank    Defaultbank
            ,banm_name      Bank_name
            ,banm_branch    Branch_Name
            ,cliba_changed  Modified
            ,migrate_yn     Migrate_yn
            ,cliba_lst_upd_dt     cliba_lst_upd_dt
      FROM   multibankid
      WHERE  migrate_yn   = 0
      AND    cliba_lst_upd_dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
      and    (cltcd in (select party_code from client_details_hst) or cltcd in (select party_code from client_details where migrate_yn in (1,3)))
      and    (charindex('''', banm_name) = 0)     --added by vivek on 141009
      and    (charindex('"', banm_name) = 0)      --added by vivek on 141009
      and    (charindex('''', banm_branch) = 0)   --added by vivek on 141009
      and    (charindex('"', banm_branch) = 0)    --added by vivek on 141009
      order by cliba_lst_upd_dt desc
     --
    END
    ELSE
    BEGIN
    --
      SET @pa_err = @l_error
    --
    END
  --
  END
  --
ELSE IF @pa_tab = 'MULTIBANKID_COMMODITIES'
  BEGIN
  --
    exec pr_insert_hst 'multibankid_commodities'
    EXEC pr_cliba_migrate_commodities  @l_id, @pa_from_dt, @pa_to_dt,@l_error output
    exec pr_rpt_bank_error_commodities @l_id ,@pa_from_dt ,@pa_to_dt ,@l_error output
    --
    IF ISNULL(@l_error,'') = ''
    BEGIN
    --
    --
    SELECT DISTINCT cliba_id   IDCOL
            ,cltcd          CltCode
            ,Accno          Accno
            ,Acctype        Acctype
            ,Chequename     Chequename
            ,Defaultbank    Defaultbank
            ,banm_name      Bank_name
            ,banm_branch    Branch_Name
            ,cliba_changed  Modified
            ,migrate_yn     Migrate_yn
            ,cliba_lst_upd_dt     cliba_lst_upd_dt
      FROM   multibankid_commodities
      WHERE  migrate_yn   = 0
      AND    cliba_lst_upd_dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
      and    (cltcd in (select party_code from client_details_hst_commodities) or cltcd in (select party_code from client_details_commodities where migrate_yn in (1,3)))
      and    (charindex('''', banm_name) = 0)     --added by vivek on 141009
      and    (charindex('"', banm_name) = 0)      --added by vivek on 141009
      and    (charindex('''', banm_branch) = 0)   --added by vivek on 141009
      and    (charindex('"', banm_branch) = 0)    --added by vivek on 141009
      order by cliba_lst_upd_dt desc
    --
    END
    ELSE
    BEGIN
    --
      SET @pa_err = @l_error
    --
    END
  --
  END
  ELSE IF @pa_tab = 'MULTICLTID'
  BEGIN
  --
    exec pr_insert_hst 'multicltid'
    EXEC pr_clidpa_migrate @l_id, @pa_from_dt, @pa_to_dt,@l_error output
    -- print @l_error
 IF ISNULL(@l_error,'') = ''
    BEGIN
    --
        SELECT Party_Code             Party_Code
              ,Cltdpno                Cltdpno
              ,Dpid                   Dpid
              ,ISNULL(Introducer,'')  Introducer
              ,ISNULL(Dptype,'')      Dptype
              ,isnull(poatype,'')     poatype
              ,Def                       Def
              ,clidpa_changed         Modified
              ,migrate_yn
              ,clidpa_lst_upd_dt      clidpa_lst_upd_dt
        FROM   multicltid
        WHERE  migrate_yn   = 0
        AND    clidpa_lst_upd_dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
        and    (Party_Code in (select party_code from client_details_hst) or Party_Code in (select party_code from client_details where migrate_yn in (1,3)))
        order by clidpa_lst_upd_dt desc
    --
    END
    ELSE
    BEGIN
    --
      SET @pa_err = @l_error
    --
    END
  --
  END
  --
ELSE IF @pa_tab = 'MULTICLTID_COMMODITIES'
  BEGIN
  --
    exec pr_insert_hst 'multicltid_commodities'
    EXEC pr_clidpa_migrate_commodities @l_id, @pa_from_dt, @pa_to_dt,@l_error output
    -- print @l_error
 IF ISNULL(@l_error,'') = ''
    BEGIN
    --
        SELECT DISTINCT clidpa_id     IDCOL
              ,Party_Code             Party_Code
              ,Cltdpno                Cltdpno
              ,Dpid                   Dpid
              ,ISNULL(Introducer,'')  Introducer
              ,ISNULL(Dptype,'')      Dptype
              ,isnull(poatype,'')     poatype
              ,Def                       Def
              ,clidpa_changed         Modified
              ,migrate_yn
              ,clidpa_lst_upd_dt      clidpa_lst_upd_dt
        FROM   multicltid_commodities
        WHERE  migrate_yn   = 0
        AND    clidpa_lst_upd_dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
        and    (Party_Code in (select party_code from client_details_hst_commodities) or Party_Code in (select party_code from client_details_commodities where migrate_yn in (1,3)))
        --
        order by clidpa_lst_upd_dt desc
    --
    END
    ELSE
    BEGIN
    --
      SET @pa_err = @l_error
    --
    END
  --
  END
  ELSE IF @pa_tab = 'CLIENT4'
  BEGIN
  --
    exec pr_insert_hst 'multicltid'
    EXEC pr_clidpa_migrate @l_id, @pa_from_dt, @pa_to_dt,@l_error output
    --
    IF ISNULL(@l_error,'') = ''
    BEGIN
    --
        SELECT DISTINCT Party_Code        Cl_code
              ,Party_Code        Party_Code
              ,1                 Instru
              ,Bankid            Bankid
              ,Cltdpno           Cltdpid
              ,Dptype            Depository
              ,1                 DefDp
              ,clidpa_changed    Modified
              ,multicltid.migrate_yn
              ,clidpa_lst_upd_dt    clidpa_lst_upd_dt
        FROM   multicltid
              ,bank
        WHERE  multicltid.migrate_yn     = 0
        AND    cltdpno                    = dpm_id
        AND    clidpa_lst_upd_dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
        order by clidpa_lst_upd_dt desc
    --
    END
    ELSE
    BEGIN
    --
      SET @pa_err = @l_error
    --
    END
  --
  END
  --
  --
  --
  --
  --added by vivek on 03/10/2008
		  ELSE IF @pa_tab = 'client_contact_details'
		  BEGIN
		  --
		    exec pr_insert_hst 'client_contact_details'
		    EXEC pr_client_contact_details_mig  @pa_from_dt, @pa_to_dt,@l_error output
		    --
		    IF ISNULL(@l_error,'') = ''
		    BEGIN
		    --
		        SELECT DISTINCT cl_Code     Cl_code
		              ,line_no              line_no
		              ,contact_name         contact_name
		              ,address1             address1
		              ,address2             address2
		              ,address3             address3
		              ,city                 city
		              ,state                state
		              ,nation               nation
		              ,zip                  zip
		              ,phone_no             phone_no
		              ,mobileno             mobileno
		              ,panno                panno
		              ,designation          designation
		              ,email                email
		              ,clicd_changed        Modified
		              ,migrate_yn
		              ,clicd_lst_upd_dt    clicd_lst_upd_dt
		        FROM   client_contact_details
		        WHERE  client_contact_details.migrate_yn     = 0
		        AND    clicd_lst_upd_dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
                and    cl_code between convert(varchar,@PA_FROMCD) and convert(varchar,@PA_TOCD)
                and    cl_code <> isnull(convert(varchar,@PA_EXCD),'')
                and    (cl_code in (select party_code from client_details_hst) or cl_code in (select party_code from client_details where migrate_yn in (1,3)))
                order by clicd_lst_upd_dt desc
		    --
		    END
		    ELSE
		    BEGIN
		    --
		      SET @pa_err = @l_error
		    --
		    END
		  --
  END
  --
  --added by vivek on 07052009
  --
  else if @pa_tab = 'client_contact_details_commodities'
  begin
  exec pr_insert_hst 'client_contact_details_commodities'
  EXEC pr_client_contact_details_mig_commodities  @pa_from_dt, @pa_to_dt,@l_error output
  IF ISNULL(@l_error,'') = ''
	BEGIN
    select distinct cl_code       cl_code
         , line_no                line_no
         , contact_name           contact_name
         , address1               address1
         , address2               address2
         , address3               address3
         , city                   city
         , state                  state
         , nation                 nation
         , zip                    zip
         , phone_no               phone_no
         , mobileno               mobileno
         , panno                  panno
         , designation            designation
         , email                  email
         , clicd_changed          clicd_changed
         , migrate_yn             migrate_yn
         , clicd_lst_upd_dt       clicd_lst_upd_dt
    from   client_contact_details_commodities
    where  migrate_yn           = 0
    AND    clicd_lst_upd_dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
    and    cl_code between convert(varchar,@PA_FROMCD) and convert(varchar,@PA_TOCD)
    and    cl_code <> isnull(convert(varchar,@PA_EXCD),'')
    and    (cl_code in (select party_code from client_details_hst_commodities) or cl_code in (select party_code from client_details_commodities where migrate_yn in (1,3)))
    order by clicd_lst_upd_dt desc
    --
    END
    ELSE
    BEGIN
    --
      SET @pa_err = @l_error
    --
    END
  --
  END
	--
  --
  --
  ELSE IF @pa_tab = 'ACCOUNT2'
  BEGIN--account2
  --
    IF ISNULL(@l_error,'') = ''
    BEGIN--err_null_acct
    --
      EXEC pr_mig_citrus2jm_daily @l_id, @pa_from_dt, @pa_to_dt, @pa_tab, @pa_err output
      --
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
           , e_cmpltd
           , createdate
           , modifydate
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
      FROM   ACCOUNT_PMS WITH (NOLOCK)
      WHERE  E_CMPLTD = 0
      ORDER BY sbk_code, sbk_name
    --
    END--err_null_acct
    ELSE
    BEGIN--err_acct
    --
      SET @pa_err = @l_error
    --
    END--err_acct
    --
  END--account2
  --
  ELSE IF @pa_tab = 'BANK2'
  BEGIN--bank2
  --
    IF ISNULL(@l_error,'') = ''
    BEGIN--err_null_bank
      --
      EXEC pr_mig_citrus2jm_daily @l_id, @pa_from_dt, @pa_to_dt, @pa_tab, @pa_err output
      --
      SELECT bank_infoid
           , accountno
           , bank_name
           , branch_name
           , bank_account_type
           , bank_account_no
           , createdate
           , modifydate
           , edittype
           , e_comltd
      FROM  BANK_INFO_SMS
      WHERE E_COMLTD = 0
      order by bank_infoid ,accountno
    --
    END--err_null_bank
    ELSE
    BEGIN--err_bank
    --
      SET @pa_err = @l_error
    --
    END--err_bank
    --
  END--banks
  --
  ELSE IF @pa_tab = 'DP2'
  BEGIN--DP2
  --
    IF ISNULL(@l_error,'') = ''
    BEGIN--err_null_DP
    --
      EXEC pr_mig_citrus2jm_daily @l_id, @pa_from_dt, @pa_to_dt, @pa_tab, @pa_err output
      --
      SELECT DP_INFOID
          , ACCOUNTNO
          , DP_NAME
          , DP_OPERATIONTHROUGH
          , DP_ID
          , DP_DEFAULTID
          , DP_CLIENTID
          , CREATEDDATE
          , MODIFYDATE
          , E_COMLTD
          , EDITTYPE
      FROM  DP_INFO_SMS  WITH (NOLOCK)
      WHERE E_COMLTD = 0
      ORDER BY DP_INFOID,ACCOUNTNO
    --
    END--err_null_dp
    ELSE
    BEGIN--err_dp
    --
      SET @pa_err = @l_error
    --
    END--err_dp
 --
 END--dp
--

  ELSE IF @pa_tab = 'CLIENT_MUTUAL_DETAILS'
  BEGIN
  --
    exec pr_insert_hst 'client_mutual_details'
    --exec pr_insert_hst 'client_brok_details'
    --
    --
    EXEC pr_client_mutual_details_migrate @l_id, @pa_from_dt, @pa_to_dt,@l_error output
    
    --
    --
--print 'abc'
    --
    IF ISNULL(@l_error,'') = ''
    BEGIN
    --
      --
      select CLIENT_ID
			,CLIENT_NAME
			,GENDER
			,OCCUPATION_CODE
			,TAX_STATUS
			,PAN_NO
			,KYC_FLAG
			,ADDR1
			,ADDR2
			,ADDR3
			,CITY
			,STATE
			,ZIP
			,OFFICE_PHONE
			,RES_PHONE
			,MOBILE_NO
			,EMAIL_ID
			,BANK_NAME
			,BANK_BRANCH
			,BANK_CITY
			,ACC_NO
			,PAYMODE
			,MICR_NO
			,DOB
			,GAURDIAN_NAME
			,GAURDIAN_PAN_NO
			,NOMINEE_NAME
			,NOMINEE_RELATION
			,BANK_AC_TYPE
			,STAT_COMM_MODE
			,MODIFIEDBY
			,MODIFIEDON
			,CD_CREATED_DT
			,CD_LST_UPD_DT
			,CD_CHANGED
			,MIGRATE_YN
	  FROM MFSS_CLIENT
      WHERE  MIGRATE_YN   = 0
      AND    (cd_lst_upd_dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
             or cd_created_dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59')
--      AND    ( status_flag = 'ACTIVE' or party_code in (select party_code from client_details_hst))  --Modified Status Flag = 'Active' to 'CI' on 06-02-2010 for Testing Purpose
--      and    party_code between convert(varchar,@PA_FROMCD) and convert(varchar,@PA_TOCD)
--      and    party_code <> isnull(convert(varchar,@PA_EXCD),'')
      order by cd_lst_upd_dt desc
  
    --
    END
    ELSE
    BEGIN
    --
      SET @pa_err = @l_error
    --
    END
  --
  END
  --
  --
END
--sp_helptext pr_client_details_migrate

GO
