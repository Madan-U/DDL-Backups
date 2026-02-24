-- Object: VIEW citrus_usr.dp_client_master
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


--select  * from [dp_client_master] where cm_cd  ='1201090001354935'  
CREATE view [citrus_usr].[dp_client_master]  
as  
select  case when isdate(ACC_CLOSE_DT )=  1 then replace(convert(varchar(11),convert(datetime,ACC_CLOSE_DT ,103) ,103),'/','') else '' end cm_acc_closuredate  
, left(enttm_cd,2) cm_acctype  
, case when dpam_stam_Cd ='active' then '01' else stam_cd end  cm_active  
, convert (varchar (50), c_adr1) cm_add1  
, convert (varchar (30), c_adr2) cm_add2  
, convert (varchar (30),  c_adr3) cm_add3  
, banm_name cm_bankname  
, isnull(dpam_bbo_code,'') [cm_blsavingcd]  
, BOSTMNTCYCLE cm_bostatementcycle  
, case when ba ='' then br else ba end  cm_brboffcode  
, case when ba ='' then br else ba end  cm_brcode  
, dpam_sba_no  cm_cd  
, brom_desc cm_chgsscheme  
, c_adr_city cm_city  
, right(subcm_cd,4) cm_clienttype  
, c_adr_country cm_country  
,  REPLACE(CONVERT(VARCHAR(10), clim_dob, 111), '/', '')  cm_dateofbirth  
, CLIBA_AC_NO cm_divbankacno  
, DIVBANKCCY cm_divbankccy  
, banm_micr cm_divbankcode  
, case when CLIBA_AC_TYPE = 'savings' then '10' when CLIBA_AC_TYPE = 'current' then '11' else '13' end   cm_divbranchno  
, dpam_acct_no cm_dpintrefno  
, EMAIL1 cm_email  
, clim_name3 cm_lastname  
, banm_micr cm_micr  
, clim_name2 cm_middlename  
, MOBILE1 cm_mobile  
, dpam_sba_name cm_name  
, OCCUPATION cm_occupation  
, REPLACE(CONVERT(VARCHAR(10), convert(datetime,BILL_START_DT,103), 111), '/', '') cm_opendate  
, p_adr_zip cm_pin  
, case when dppd_gpabpa_flg ='B' and  exists (select 1 from dps8_pc5 where boid =dpam_sba_no and TypeOfTrans in ('','1','2','4')) then 'Y' else 'N' end  cm_poaforpayin  
, case when exists (select 1 from dps8_pc5 where boid =dpam_sba_no and TypeOfTrans in ('','1','2','4')) then  REPLACE(CONVERT(VARCHAR(10), isnull(dppd_setup,'') , 111), '/', '') else '' end cm_poaregdate  
, convert(numeric,left(subcm_cd,2)) cm_productcd  
,ltrim(rtrim(ISNULL(DPHD_SH_FNAME,''))) +' '  +ltrim(rtrim(ISNULL(DPHD_SH_MNAME,''))) +' '  +ltrim(rtrim(ISNULL(DPHD_SH_LNAME,'')))  cm_sech_name  
, c_adr_state cm_state  
, case when r_ph1 = '' then case when MOBILE1 ='' then o_ph1 else MOBILE1 end  else r_ph1 end cm_tele1  
, ltrim(rtrim(ISNULL(DPHD_TH_FNAME,'') ))+' '  +ltrim(rtrim(ISNULL(DPHD_TH_MNAME,'') ))+' '  +ltrim(rtrim(ISNULL(DPHD_TH_LNAME,'') )) cm_thih_name  
, '' cm_title  
, case when exists (select 1 from dps8_pc5 where boid =dpam_sba_no and TypeOfTrans in ('','1','2','4')) then case when isnull(dppd_master_id,'')<>'' then 'Y' else 'N' end  else 'N' end [IS POA]  
,case when exists (select 1 from dps8_pc5 where boid =dpam_sba_no and TypeOfTrans in ('','1','2','4')) then  isnull(dppd_master_id,'') else '' end  [Master POA ID]  
,   REPLACE(CONVERT(VARCHAR(10), isnull(fre_exec_date,'') , 111), '/', '')  [cm_freezedt]  
, isnull(fre_rmks,'') [cm_freezereason]  
, case when fre_status='a'then '1' else '0' end  [cm_freezeyn]  
, p_adr1 cb_add1  
, p_adr2 cb_add2  
, p_adr3 cb_add3  
, ANNUAL_INCOME cb_annualincome  
--, case when isnull(bo_adr1,'')='' then isnull(TMPBA_DP_BANK_ADD1,'') else isnull(bo_adr1,'') end  cb_bankadd1  
--, case when isnull(bo_adr2,'')='' then isnull(TMPBA_DP_BANK_ADD2,'') else isnull(bo_adr2,'') end   cb_bankadd2  
--, case when isnull(bo_adr3,'')='' then isnull(TMPBA_DP_BANK_ADD3,'') else isnull(bo_adr3,'') end  cb_bankadd3  
, isnull(TMPBA_DP_BANK_ADD1,'')   cb_bankadd1  
, isnull(TMPBA_DP_BANK_ADD2,'')   cb_bankadd2  
, isnull(TMPBA_DP_BANK_ADD3,'') cb_bankadd3  
  
, banm_branch cb_bankbranch  
, 'N' cb_bosettlementplanflag  
, p_adr_city cb_city  
, dpam_sba_no cb_cmcd  
, p_adr_country cb_country  
, EDUCATION cb_degree  
, '0' cb_dividendcurrency  
, ltrim(rtrim(DPHD_FH_FTHNAME )) cb_fathername  
, dpam_acct_no cb_formno  
, GEOGRAPHICAL cb_geographical  
, LANGUAGE cb_language  
, '' cb_lifestyle  
, NATIONALITY cb_nationality  
, ltrim(rtrim(ISNULL(DPHD_NOM_FNAME,''))) + ' ' + ltrim(rtrim(ISNULL(DPHD_NOM_MNAME,''))) + ' ' + ltrim(rtrim(ISNULL(DPHD_NOM_LNAME,''))) cb_nominee  
, CASE WHEN ISNULL(convert(varchar(11),DPHD_NOM_DOB,106),'') ='01 Jan 1900' THEN '' ELSE ISNULL(convert(varchar(11),DPHD_NOM_DOB,106),'') end  cb_nominee_dob  
, n_adr1 cb_nomineeadd1  
, n_adr2 cb_nomineeadd2  
, n_adr3 cb_nomineeadd3  
, n_adr_city cb_nomineecity  
, n_adr_country cb_nomineecountry  
, n_adr_zip cb_nomineepin  
, n_adr_state cb_nomineestate  
, PAN_GIR_NO cb_panno  
, p_adr_zip cb_pin  
, ltrim(rtrim(isnull(DPHD_SH_FTHNAME,''))) cb_sechfathername  
, ltrim(rtrim(isnull(DPHD_SH_lNAME,''))) cb_sechlastname  
, ltrim(rtrim(isnull(DPHD_SH_mNAME,''))) cb_sechmiddle  
, isnull(DPHD_SH_PAN_NO,'') cb_sechpanno  
, '' cb_sechtitle  
, '' cb_setupdate  
, isnull(clim_gender,'') cb_sexcode  
, p_adr_state cb_state  
, mobile1 cb_tele1  
, ltrim(rtrim(isnull(DPHD_tH_FTHNAME,'')))  cb_thirdfathername  
, ltrim(rtrim(isnull(DPHD_tH_lNAME,''))) cb_thirdlastname  
, ltrim(rtrim(isnull(DPHD_tH_mNAME,''))) cb_thirdmiddle  
, isnull(DPHD_TH_PAN_NO,'') cb_thirdpanno  
, '' cb_thirdtitle  
, banm_rtgs_cd cb_voicemail  ,dpam_lst_upd_dt Last_Modified_Date
FROM    DP_ACCT_MSTR DPAM with(nolock)  
LEFT OUTER JOIN freeze_unfreeze_dtls on dpam_id = fre_Dpam_id and fre_type ='d' and fre_status ='a'  
    
  LEFT OUTER JOIN  
  (select accac_clisba_id   
  , max(case when isnull(CONCM_CD,'') = 'NOMINEE_ADR1' then  isnull(adr_1,'') else '' end ) n_adr1  
  , max(case when isnull(CONCM_CD,'') = 'NOMINEE_ADR1' then  isnull(adr_2,'') else ''end ) n_adr2  
  , max(case when isnull(CONCM_CD,'') = 'NOMINEE_ADR1' then  isnull(adr_3,'') else ''end ) n_adr3  
  , max(case when isnull(CONCM_CD,'') = 'NOMINEE_ADR1' then  isnull(adr_city,'') else ''end ) n_adr_city  
  , max(case when isnull(CONCM_CD,'') = 'NOMINEE_ADR1' then  isnull(adr_state,'') else ''end )n_adr_state  
  , max(case when isnull(CONCM_CD,'') = 'NOMINEE_ADR1' then  isnull(adr_country,'') else ''end ) n_adr_country  
  , max(case when isnull(CONCM_CD,'') = 'NOMINEE_ADR1' then  isnull(adr_zip,'') else ''end ) n_adr_zip  
  , max(case when isnull(CONCM_CD,'') = 'GUARD_ADR' then  isnull(adr_1,'') else ''end ) g_adr1  
  , max(case when isnull(CONCM_CD,'') = 'GUARD_ADR' then  isnull(adr_2,'')else '' end ) g_adr2  
  , max(case when isnull(CONCM_CD,'') = 'GUARD_ADR' then  isnull(adr_3,'') else '' end ) g_adr3  
  , max(case when isnull(CONCM_CD,'') = 'GUARD_ADR' then  isnull(adr_city,'') else ''end ) g_adr_city  
  , max(case when isnull(CONCM_CD,'') = 'GUARD_ADR' then  isnull(adr_state,'') else ''end ) g_adr_state  
  , max(case when isnull(CONCM_CD,'') = 'GUARD_ADR' then  isnull(adr_country,'') else ''end ) g_adr_country  
  , max(case when isnull(CONCM_CD,'') = 'GUARD_ADR' then  isnull(adr_zip,'') else '' end ) g_adr_zip  
   from account_adr_conc  with(nolock)  
   , addresses  with(nolock)   
            , conc_code_mstr with(nolock)   
    where accac_adr_conc_id = adr_id   
   and accac_concm_id = concm_id   
   and accac_DELETED_IND = 1  
   and adr_deleted_ind = 1 group by accac_clisba_id) accountaddr on dpam_id = accountaddr.accac_clisba_id   
  left outer join   
(select accp_clisba_id   
  , max(case when isnull(ACCP_ACCPM_PROP_CD,'')     = 'ECS_FLG'  then  isnull(accp_value,'') else ''end ) ECS_FLG  
  , max(case when isnull(ACCP_ACCPM_PROP_CD,'')     = 'BBO_CODE'  then  isnull(accp_value,'') else '' end ) BBO_CODE  
  , max(case when isnull(ACCP_ACCPM_PROP_CD,'')     = 'SEBI_REG_NO' then  isnull(accp_value,'') else ''end ) SEBI_REG_NO  
  , max(case when isnull(ACCP_ACCPM_PROP_CD,'')     = 'ACC_CLOSE_DT'  then  isnull(accp_value,'') else ''end ) ACC_CLOSE_DT  
  , max(case when isnull(ACCP_ACCPM_PROP_CD,'')     = 'SMS_FLAG'      then  isnull(accp_value,'') else ''end ) SMS_FLAG  
  , max(case when isnull(ACCP_ACCPM_PROP_CD,'')     = 'RBI_REF_NO'    then  isnull(accp_value,'') else ''end ) RBI_REF_NO  
   , max(case when isnull(ACCP_ACCPM_PROP_CD,'') = 'BILL_START_DT' then  isnull(accp_value,'') else ''end ) BILL_START_DT  
  , max(case when isnull(ACCP_ACCPM_PROP_CD,'') = 'BOSTMNTCYCLE' then  citrus_usr.[fn_get_listing]('BOSTMNTCYCLE',isnull(accp_value,'')) else ''end ) BOSTMNTCYCLE  
, max(case when isnull(ACCP_ACCPM_PROP_CD,'') = 'DIVBANKCCY' then  citrus_usr.[fn_get_listing]('DIVBANKCCY',isnull(accp_value,'')) else ''end ) DIVBANKCCY  
, max(case when isnull(ACCP_ACCPM_PROP_CD,'') = 'BOSETTLFLG' then  isnull(accp_value,'') else ''end ) BOSETTLFLG  
, max(case when isnull(ACCP_ACCPM_PROP_CD,'') = 'DIVIDEND_CURRENCY' then  citrus_usr.[fn_get_listing]('DIVIDEND_CURRENCY',isnull(accp_value,'')) else ''end ) DIVIDEND_CURRENCY  
  
  
    
   from account_properties with(nolock)  
   where accp_DELETED_IND = 1  
   group by accp_clisba_id) acprop on dpam_id = acprop.accp_clisba_id  
  left outer join   
        client_dp_brkg  with(nolock)   on dpam_id = clidb_dpam_id  and getdate() between clidb_eff_from_dt  
and isnull(clidb_eff_to_dt,'jan 01 2100')  
        LEFT OUTER JOIN   
       brokerage_mstr  with(nolock) on brom_id = clidb_brom_id    
        LEFT OUTER JOIN   
  DP_HOLDER_DTLS with(nolock) ON  DPAM_ID = DPHD_DPAM_ID AND DPHD_DELETED_IND =1  
  
  LEFT OUTER JOIN   
  DP_POA_DTLS    with(nolock) ON   DPAM_ID = DPPD_DPAM_ID  AND DPPD_DELETED_IND =1 and DPPD_HLD ='1st holder'   
  and substring(dpam_sba_no,4,5)=substring(dppd_master_id,4,5)   
  and getdate() between dppd_eff_fr_dt and case when dppd_eff_TO_dt = '1900-01-01 00:00:00.000' then 'jan 01 2100' else  isnull(dppd_eff_TO_dt,'jan 01 2100') end   
  left outer join  
  CLIENT_BANK_ACCTS with(nolock) on DPAM_ID = CLIBA_CLISBA_ID and CLIBA_DELETED_IND = 1  
  left outer join  
  BANK_MSTR    with(nolock) on   CLIBA_BANM_ID      = BANM_ID and  BANM_DELETED_IND = 1  
left outer join   
(select entac_ent_id   
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'OFF_ADR1' then  isnull(adr_1,'') else '' end ) bo_adr1  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'OFF_ADR1' then  isnull(adr_2,'') else ''end ) bo_adr2  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'OFF_ADR1' then  isnull(adr_3,'') else ''end ) bo_adr3  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'OFF_ADR1' then  isnull(adr_city,'') else ''end ) bo_adr_city  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'OFF_ADR1' then  isnull(adr_state,'') else ''end )bo_adr_state  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'OFF_ADR1' then  isnull(adr_country,'') else ''end ) bo_adr_country  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'OFF_ADR1' then  isnull(adr_zip,'') else ''end ) bo_adr_zip  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'COR_ADR1' then  isnull(adr_1,'') else ''end ) bc_adr1  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'COR_ADR1' then  isnull(adr_2,'')else '' end ) bc_adr2  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'COR_ADR1' then  isnull(adr_3,'') else '' end ) bc_adr3  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'COR_ADR1' then  isnull(adr_city,'') else ''end ) bc_adr_city  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'COR_ADR1' then  isnull(adr_state,'') else ''end ) bc_adr_state  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'COR_ADR1' then  isnull(adr_country,'') else ''end ) bc_adr_country  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'COR_ADR1' then  isnull(adr_zip,'') else '' end ) bc_adr_zip  
   from entity_adr_conc  with(nolock)   
   , addresses with(nolock)  
    where entac_adr_conc_id = adr_id   
   and ENTAC_DELETED_IND = 1  
   and adr_deleted_ind = 1 group by entac_ent_id) bankaddr on banm_id = bankaddr.entac_ent_id   
left outer join   
bank_addresses_dtls on banm_micr = TMPBA_DP_BANK and TMPBA_DP_BR= banm_rtgs_cd  
        left outer join  
        account_documents on accd_clisba_id = DPAM_ID and accd_deleted_ind = 1 and accd_accdocm_doc_id = 12  
  ,CLIENT_CTGRY_MSTR with(nolock)  
  ,ENTITY_TYPE_MSTR with(nolock)  
  ,STATUS_MSTR with(nolock)  
  ,SUB_CTGRY_MSTR  with(nolock)  
  ,CLIENT_MSTR with(nolock)  
  left outer join   
        (select entac_ent_id   
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'PER_ADR1' then  isnull(adr_1,'') else '' end ) p_adr1  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'PER_ADR1' then  isnull(adr_2,'') else ''end ) p_adr2  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'PER_ADR1' then  isnull(adr_3,'') else ''end ) p_adr3  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'PER_ADR1' then  isnull(adr_city,'') else ''end ) p_adr_city  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'PER_ADR1' then  isnull(adr_state,'') else ''end ) p_adr_state  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'PER_ADR1' then  isnull(adr_country,'') else ''end ) p_adr_country  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'PER_ADR1' then  isnull(adr_zip,'') else ''end ) p_adr_zip  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'COR_ADR1' then  isnull(adr_1,'') else ''end ) c_adr1  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'COR_ADR1' then  isnull(adr_2,'')else '' end ) c_adr2  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'COR_ADR1' then  isnull(adr_3,'') else '' end ) c_adr3  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'COR_ADR1' then  isnull(adr_city,'') else ''end ) c_adr_city  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'COR_ADR1' then  isnull(adr_state,'') else ''end ) c_adr_state  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'COR_ADR1' then  isnull(adr_country,'') else ''end ) c_adr_country  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'COR_ADR1' then  isnull(adr_zip,'') else '' end ) c_adr_zip  
   from entity_adr_conc  with(nolock)  
   , addresses  with(nolock)  
    where entac_adr_conc_id = adr_id   
   and ENTAC_DELETED_IND = 1  
   and adr_deleted_ind = 1 group by entac_ent_id) addr on clim_crn_no = addr.entac_ent_id   
        left outer join   
  (select entac_ent_id   
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'RES_PH1' then  isnull(conc_value,'') else ''end ) r_ph1  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'OFF_PH1' then  isnull(conc_value,'') else '' end ) o_ph1  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'MOBILE1' then  isnull(conc_value,'') else ''end ) MOBILE1  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'EMAIL1' then  isnull(conc_value,'') else ''end ) EMAIL1  
  , max(case when isnull(ENTAC_CONCM_CD,'') = 'FAX1' then  isnull(conc_value,'') else ''end ) FAX1  
    
   from entity_adr_conc  with(nolock)  
   , contact_channels  with(nolock)   
    where entac_adr_conc_id = conc_id   
   and ENTAC_DELETED_IND = 1  
   and conc_deleted_ind = 1 group by entac_ent_id) conc on clim_crn_no = conc.entac_ent_id   
   left outer join   
  (select entp_ent_id   
  , max(case when isnull(ENTP_ENTPM_CD,'')     = 'NATIONALITY'   then  [citrus_usr].[fn_get_listing]('NATIONALITY',isnull(entp_value,'')) else ''end ) NATIONALITY  
  , max(case when isnull(ENTP_ENTPM_CD,'')     = 'ANNUAL_INCOME' then  [citrus_usr].[fn_get_listing]('ANNUAL_INCOME',isnull(entp_value,'')) else '' end ) ANNUAL_INCOME  
  , max(case when isnull(ENTP_ENTPM_CD,'')     = 'TAX_DEDUCTION' then  isnull(entp_value,'') else ''end ) TAX_DEDUCTION  
  , max(case when isnull(ENTP_ENTPM_CD,'')     = 'LANGUAGE'      then  [citrus_usr].[fn_get_listing]('LANGUAGE',isnull(entp_value,'')) else ''end ) LANGUAGE  
  , max(case when isnull(ENTP_ENTPM_CD,'')     = 'EDUCATION'     then  [citrus_usr].[fn_get_listing]('EDUCATION',isnull(entp_value,'')) else ''end ) EDUCATION  
  , max(case when isnull(ENTP_ENTPM_CD,'')     = 'PAN_GIR_NO'    then  isnull(entp_value,'') else ''end ) PAN_GIR_NO  
   , max(case when isnull(ENTP_ENTPM_CD,'') = 'OCCUPATION'    then  [citrus_usr].[fn_get_listing]('OCCUPATION',isnull(entp_value,'')) else ''end ) OCCUPATION  
, max(case when isnull(ENTP_ENTPM_CD,'') = 'GEOGRAPHICAL'    then  [citrus_usr].[fn_get_listing]('GEOGRAPHICAL',isnull(entp_value,'')) else ''end ) GEOGRAPHICAL  
    
   from entity_properties with(nolock)  
   where ENTP_DELETED_IND = 1  
   group by entp_ent_id) prop on clim_crn_no = prop.entp_ent_id    
left outer join   
    
(select   
entr_crn_no, re=max(case when entm_enttm_cd = 'RE' then replace(entm_short_name ,'_re','') else '' end),  
ar=max(case when entm_enttm_cd = 'AR' then replace(entm_short_name ,'_AR','')  else '' end),  
br=max(case when entm_enttm_cd = 'br' then replace(entm_short_name ,'_br','')  else '' end),  
ba=max(case when entm_enttm_cd = 'BA' then replace(entm_short_name ,'_ba','')  else '' end),  
REM=max(case when entm_enttm_cd = 'REM' then replace(entm_short_name ,'_rem','')  else '' end),  
ONW=max(case when entm_enttm_cd = 'ONW' then replace(entm_short_name ,'_onw','')  else '' end)  
  
FROM   entity_mstr  with(nolock)      
,entity_relationship    with(nolock)   
WHERE (entm_id = entr_ho       
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
AND entm_enttm_cd in ('RE','AR','BR','BA','REM','ONW')   
and getdate() between entr_from_dt and isnull(entr_to_dt,'jan 01 2100')  
group by entr_crn_no) relations on entr_crn_no = clim_crn_no   
  WHERE DPAM.DPAM_CLICM_CD = CLICM_CD   
  AND   DPAM.DPAM_ENTTM_CD = ENTTM_CD  
  AND   DPAM.DPAM_STAM_CD  = STAM_CD  
  AND   DPAM.DPAM_SUBCM_CD = SUBCM_CD  
  AND   CLICM_ID           = SUBCM_CLICM_ID  
  AND   CLIM_CRN_NO        = DPAM.DPAM_CRN_NO

GO
