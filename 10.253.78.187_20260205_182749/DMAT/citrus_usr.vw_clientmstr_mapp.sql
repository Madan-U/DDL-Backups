-- Object: VIEW citrus_usr.vw_clientmstr_mapp
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--select * from [vw_clientmstr_mapp] where BBO_CODE  ='h14370'
CREATE view  [citrus_usr].[vw_clientmstr_mapp]
as
(SELECT  dpam_created_dt , CLICM_DESC  [CATEGORY]
		,SUBCM_DESC  [SUBCATEGORY]
		,ENTTM_DESC  [TYPE]
		,convert(varchar(11),clim_dob,103)clim_dob
		,p_adr1 [PADDRESS1]
		,p_adr2 + ' ' + p_adr3  [PADDRESS2]
		,p_adr_city [PCITY]
		,p_adr_state [PSTATE]
		,p_adr_country  [PCOUNTRY]
		,p_adr_zip   [PPIN CODE]
		,r_ph1 [RESPHONENO]
		,c_adr1  [CADDRESS1]
		,c_adr2 + ' ' + c_adr3       [CADDRESS2]
		,c_adr_city    [CCITY]
		,c_adr_state [CSTATE]
		,c_adr_country [CCOUNTRY]
		,c_adr_zip [CPIN CODE]
		,o_ph1 [OFFPHONENO]
		,case when isnull(bc_adr1,'') <> '' then isnull(bc_adr1,'')  else isnull(bo_adr1,'')  end [BADDRESS1]
		,case when isnull(bc_adr2,'') <> '' then isnull(bc_adr2 + ' ' + bc_adr3,'')  else isnull(bo_adr2 + ' ' + bo_adr3,'')  end  [BADDRESS2]
		,case when isnull(bc_adr_city,'') <> '' then isnull(bc_adr_city,'')  else isnull(bo_adr_city,'')  end   [BCITY]
		,case when isnull(bc_adr_state,'') <> '' then isnull(bc_adr_state,'')  else isnull(bo_adr_city,'')  end  [BSTATE]
		,case when isnull(bc_adr_country,'') <> '' then isnull(bc_adr_country,'')  else isnull(bo_adr_city,'')  end  [BCOUNTRY]
		,case when isnull(bc_adr_zip,'') <> '' then isnull(bc_adr_zip,'')   else isnull(bo_adr_city,'')  end  [BPIN CODE]
		,MOBILE1 [MOBILE]
		,EMAIL1 [EMAIL]
		,FAX1 [FAX1]
		/*,ISNULL(CITRUS_USR.FN_FIND_RELATIONS(DPAM.DPAM_CRN_NO,'BA'),CITRUS_USR.FN_FIND_RELATIONS(DPAM.DPAM_CRN_NO,'BR')) BRANCH
		*/,DPAM.DPAM_SBA_NO CLIENTID
		,CLIM_SHORT_NAME SHORTNAME
		,CLIM_NAME2,CLIM_NAME3
		,CLIM_NAME1 + ' ' + isnull(CLIM_NAME2,'') + ' ' + isnull(CLIM_NAME3,'')  CLIM_NAME1
		,CLIBA_AC_NO
		,CLIBA_AC_TYPE
		,BANM_NAME
		,isnull(BANM_MICR,'') BANM_MICR
		, isnull(BANM_rtgs_cd,'') IFS_CODE
		,ISNULL(DPPD_FNAME,'') DPPD_FNAME      
		,ISNULL(DPPD_MNAME,'') DPPD_MNAME      
		,ISNULL(DPPD_LNAME,'') DPPD_LNAME      
		,CASE WHEN isnull(convert(varchar(11),DPPD_DOB,106),'') ='01 Jan 1900' THEN '' ELSE ISNULL(convert(varchar(11),DPPD_DOB,106),'') END DPPD_DOB      
		,ISNULL(DPPD_PAN_NO,'')  DPPD_PAN_NO    
		,ISNULL(DPHD_SH_FNAME,'') DPHD_SH_FNAME
		,ISNULL(DPHD_SH_MNAME,'') DPHD_SH_MNAME
		,ISNULL(DPHD_SH_LNAME,'') DPHD_SH_LNAME
		,CASE WHEN ISNULL(convert(varchar(11),DPHD_SH_DOB,106),'') ='01 Jan 1900' THEN '' ELSE ISNULL(convert(varchar(11),DPHD_SH_DOB,106),'') END DPHD_SH_DOB
		,ISNULL(DPHD_SH_PAN_NO,'')  DPHD_SH_PAN_NO
		,ISNULL(DPHD_TH_FNAME,'') DPHD_TH_FNAME
		,ISNULL(DPHD_TH_MNAME,'') DPHD_TH_MNAME
		,ISNULL(DPHD_TH_LNAME,'') DPHD_TH_LNAME
		,CASE WHEN ISNULL(convert(varchar(11),DPHD_TH_DOB,106),'') ='01 Jan 1900' THEN '' ELSE ISNULL(convert(varchar(11),DPHD_TH_DOB,106),'') END DPHD_TH_DOB
		,ISNULL(DPHD_TH_PAN_NO ,'') DPHD_TH_PAN_NO
        ,CASE WHEN ISNULL(convert(varchar(11),DPHD_NOM_DOB,106),'') ='01 Jan 1900' THEN '' ELSE ISNULL(convert(varchar(11),DPHD_NOM_DOB,106),'') END DPHD_NOM_DOB
		,ISNULL(DPHD_NOM_PAN_NO,'')  DPHD_NOM_PAN_NO
		,ISNULL(DPHD_NOM_FNAME,'') + ' ' + ISNULL(DPHD_NOM_MNAME,'') + ' ' + ISNULL(DPHD_NOM_LNAME,'') DPHD_NOM_FNAME
		,ISNULL(DPHD_NOM_MNAME,'') DPHD_NOM_MNAME
		,ISNULL(DPHD_NOM_LNAME,'') DPHD_NOM_LNAME
		,ISNULL(DPHD_FH_FTHNAME,'') DPHD_FH_FTHNAME
		,'' dobminor
		,'' poa_asign
		,n_adr1 [NADDRESS1]
		,n_adr2 + ' ' + n_adr3 NADDRESS2
		,n_adr_city [nCITY]
		,n_adr_state  [nSTATE]
		,n_adr_country [nCOUNTRY]
		,n_adr_zip [nPINCODE]
		,CASE WHEN ISNULL(convert(varchar(11),DPHD_gau_DOB,106),'') ='01 Jan 1900' THEN '' ELSE ISNULL(convert(varchar(11),DPHD_gau_DOB,106),'') END DPHD_gau_DOB
		,ISNULL(DPHD_gau_PAN_NO,'')  DPHD_gau_PAN_NO
		,ISNULL(DPHD_gau_FNAME,'') + ' ' + ISNULL(DPHD_gau_MNAME,'') + ' ' + ISNULL(DPHD_gau_LNAME,'') DPHD_gau_FNAME
		,ISNULL(DPHD_Gau_MNAME,'') DPHD_gau_MNAME
		,ISNULL(DPHD_Gau_LNAME,'') DPHD_gau_LNAME
		,g_adr1 [GADDRESS1]
		,g_adr2 + ' ' + g_adr3 GADDRESS2
		,g_adr_city [GCITY]
		,g_adr_state  [GSTATE]
		,g_adr_country [GCOUNTRY]
		,g_adr_zip [GPINCODE]
		,DPAM_ACCT_NO INREFNO
		,dpam_acct_no formno
		,ISNULL(brom_desc,'') scheme
		,isnull(accd_doc_path,'') accd_doc_path
			,ACCD_BINARY_IMAGE	
			,clidb_created_dt	
			,case when clim_gender = 'M' then 'Male' 
				  when clim_gender = 'F' then 'Female' else '' end Gender
			,isnull(banm_rtgs_cd,'') ifsc
			,NATIONALITY  
			,ANNUAL_INCOME
			,TAX_DEDUCTION
			,LANGUAGE     
			,EDUCATION    
			,PAN_GIR_NO   
			,OCCUPATION   
			,ECS_FLG		
			,BBO_CODE		
			,SEBI_REG_NO
			,ACC_CLOSE_DT
			,SMS_FLAG    
			,RBI_REF_NO  
			,BILL_START_DT
			,re,ar,br,ba,rem,onw
FROM    DP_ACCT_MSTR DPAM with(nolock)
		left outer join 
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
		, max(case when isnull(ACCP_ACCPM_PROP_CD,'')     = 'ECS_FLG'		then  isnull(accp_value,'') else ''end ) ECS_FLG
		, max(case when isnull(ACCP_ACCPM_PROP_CD,'')     = 'BBO_CODE'		then  isnull(accp_value,'') else '' end ) BBO_CODE
		, max(case when isnull(ACCP_ACCPM_PROP_CD,'')     = 'SEBI_REG_NO'	then  isnull(accp_value,'') else ''end ) SEBI_REG_NO
		, max(case when isnull(ACCP_ACCPM_PROP_CD,'')     = 'ACC_CLOSE_DT'  then  isnull(accp_value,'') else ''end ) ACC_CLOSE_DT
		, max(case when isnull(ACCP_ACCPM_PROP_CD,'')     = 'SMS_FLAG'      then  isnull(accp_value,'') else ''end ) SMS_FLAG
		, max(case when isnull(ACCP_ACCPM_PROP_CD,'')     = 'RBI_REF_NO'    then  isnull(accp_value,'') else ''end ) RBI_REF_NO
			, max(case when isnull(ACCP_ACCPM_PROP_CD,'') = 'BILL_START_DT' then  isnull(accp_value,'') else ''end ) BILL_START_DT
		
		 from account_properties with(nolock)
		 where accp_DELETED_IND = 1
		 group by accp_clisba_id) acprop on dpam_id = acprop.accp_clisba_id
		left outer join 
        client_dp_brkg  with(nolock)   on dpam_id = clidb_dpam_id  
        LEFT OUTER JOIN 
      	brokerage_mstr  with(nolock) on brom_id = clidb_brom_id  
        LEFT OUTER JOIN 
		DP_HOLDER_DTLS with(nolock) ON  DPAM_ID = DPHD_DPAM_ID AND DPHD_DELETED_IND =1
		LEFT OUTER JOIN 
		DP_POA_DTLS    with(nolock) ON   DPAM_ID = DPPD_DPAM_ID  AND DPPD_DELETED_IND =1 and getdate() between dppd_eff_fr_dt and isnull(dppd_eff_TO_dt,'jan 01 2100')
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
		, max(case when isnull(ENTP_ENTPM_CD,'')     = 'NATIONALITY'   then  isnull(entp_value,'') else ''end ) NATIONALITY
		, max(case when isnull(ENTP_ENTPM_CD,'')     = 'ANNUAL_INCOME' then  isnull(entp_value,'') else '' end ) ANNUAL_INCOME
		, max(case when isnull(ENTP_ENTPM_CD,'')     = 'TAX_DEDUCTION' then  isnull(entp_value,'') else ''end ) TAX_DEDUCTION
		, max(case when isnull(ENTP_ENTPM_CD,'')     = 'LANGUAGE'      then  isnull(entp_value,'') else ''end ) LANGUAGE
		, max(case when isnull(ENTP_ENTPM_CD,'')     = 'EDUCATION'     then  isnull(entp_value,'') else ''end ) EDUCATION
		, max(case when isnull(ENTP_ENTPM_CD,'')     = 'PAN_GIR_NO'    then  isnull(entp_value,'') else ''end ) PAN_GIR_NO
			, max(case when isnull(ENTP_ENTPM_CD,'') = 'OCCUPATION'    then  isnull(entp_value,'') else ''end ) OCCUPATION
		
		 from entity_properties with(nolock)
		 where ENTP_DELETED_IND = 1
		 group by entp_ent_id) prop on clim_crn_no = prop.entp_ent_id  
left outer join 
		
(select 
entr_crn_no, re=max(case when entm_enttm_cd = 'RE' then entm_name1 else '' end),
ar=max(case when entm_enttm_cd = 'AR' then entm_name1 else '' end),
br=max(case when entm_enttm_cd = 'br' then entm_name1 else '' end),
ba=max(case when entm_enttm_cd = 'BA' then entm_name1 else '' end),
REM=max(case when entm_enttm_cd = 'REM' then entm_name1 else '' end),
ONW=max(case when entm_enttm_cd = 'ONW' then entm_name1 else '' end)

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
group by entr_crn_no ) relations on entr_crn_no = clim_crn_no 
		WHERE DPAM.DPAM_CLICM_CD = CLICM_CD 
		AND   DPAM.DPAM_ENTTM_CD = ENTTM_CD
		AND   DPAM.DPAM_STAM_CD  = STAM_CD
		AND   DPAM.DPAM_SUBCM_CD = SUBCM_CD
		AND   CLICM_ID           = SUBCM_CLICM_ID
		AND   CLIM_CRN_NO        = DPAM.DPAM_CRN_NO 

)

GO
