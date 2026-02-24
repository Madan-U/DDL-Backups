-- Object: PROCEDURE citrus_usr.viewtushar
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--viewtushar
CREATE proc [citrus_usr].[viewtushar]
as
select top 5  case when ClosDt <> '' then ClosDt else '' end cm_acc_closuredate  
, left(enttm_cd,2) cm_acctype  
, case when dpam_stam_Cd ='active' then '01' else stam_cd end  cm_active  
, isnull(ltrim(rtrim(dps8_pc1.Addr1)),'')  cm_add1  
, isnull(ltrim(rtrim(dps8_pc1.Addr2)),'')  cm_add2  
, isnull(ltrim(rtrim(dps8_pc1.Addr3)),'')  cm_add3  
, citrus_usr.fn_splitval_by(isnull(BANM_NAME,''),'1','-')  cm_bankname  
, isnull(dpam_bbo_code,'') [cm_blsavingcd]  
, '' cm_bostatementcycle  --pending 
--, ISNULL(CITRUS_USR.FN_FIND_RELATIONS(DPAM.DPAM_CRN_NO,'BA'),isnull(CITRUS_USR.FN_FIND_RELATIONS(DPAM.DPAM_CRN_NO,'BR'),''))  cm_brboffcode  
--, ISNULL(CITRUS_USR.FN_FIND_RELATIONS(DPAM.DPAM_CRN_NO,'BA'),isnull(CITRUS_USR.FN_FIND_RELATIONS(DPAM.DPAM_CRN_NO,'BR'),''))  cm_brcode  
, dpam_sba_no  cm_cd  
, brom_desc cm_chgsscheme  
,  isnull(ltrim(rtrim(dps8_pc1.City)),'') cm_city  
, right(subcm_cd,4) cm_clienttype  
, isnull(ltrim(rtrim(dps8_pc1.Country)),'') cm_country  
, isnull(dps8_pc1.DateOfBirth,'') cm_dateofbirth  
, dps8_pc1.DivBankAcctNo cm_divbankacno  
, '' cm_divbankccy   --pending
, isnull( dps8_pc1.DivBankCd,'') cm_divbankcode  
, ''  cm_divbranchno   --pending 
, dpam_acct_no cm_dpintrefno  
,  dps8_pc1.EMailId cm_email  
, case when CLIM_NAME3 ='' then clim_short_name else CLIM_NAME3  end cm_lastname  
, isnull( dps8_pc1.DivBankCd,'') cm_micr  
, clim_name2 cm_middlename  
, case when isnull(MobileNum,'') <> '' then isnull(MobileNum,'') else  case when  dps8_pc1.PriPhInd = 'M' then  dps8_pc1.PriPhNum else dps8_pc1.PriPhNum end end cm_mobile  
, dpam_sba_name cm_name  
, case when Occupation  = 'B'then 'Business' 
                        when Occupation  = 'F' then 'Farmer'                      
                        when Occupation  =  'H' then 'House Wife'                     
                        when Occupation  = 'O' then 'Others'                                                                   
                        when Occupation  = 'P' then 'Professional'                      
                        when Occupation  = 'R' then 'Retired'                      
                        when Occupation  =  'S' then 'Service'                     
                        when Occupation  =  'ST' then 'Student'  
					    when Occupation  = 'PV' then 'PRIVATE SECTOR'
						when Occupation  = 'PS' then 'PUBLIC SECTOR'
						when Occupation  = 'GS' then 'GOVERNMENT SERVICES' else '' end   cm_occupation  
, isnull(dps8_pc1.AcctCreatDt,'') cm_opendate  
, isnull(ltrim(rtrim(dps8_pc1.PinCode)),'') cm_pin  
, case when dppd_gpabpa_flg ='B' then 'Y' else 'N' end  cm_poaforpayin  
,  REPLACE(CONVERT(VARCHAR(10), isnull(dppd_setup,'') , 111), '/', '') cm_poaregdate  
, convert(numeric,left(subcm_cd,2)) cm_productcd  
,ltrim(rtrim(isnull(DPS8_PC2.Name,''))) +' '  +ltrim(rtrim(isnull(DPS8_PC2.MiddleName,''))) +' '  +ltrim(rtrim(isnull(DPS8_PC2.SearchName,'')))   cm_sech_name  
, isnull(ltrim(rtrim(dps8_pc1.State)),'') cm_state  
, dps8_pc1.PriPhNum cm_tele1  --pending 
,ltrim(rtrim(isnull(DPS8_PC3.Name,''))) +' '  +ltrim(rtrim(isnull(DPS8_PC3.MiddleName,''))) +' '  +ltrim(rtrim(isnull(DPS8_PC3.SearchName,'')))   cm_thih_name  
, '' cm_title  
, case when isnull(dppd_master_id,'')<>'' then 'Y' else 'N' end  [IS POA]  
, isnull(dppd_master_id,'') [Master POA ID]  
,   REPLACE(CONVERT(VARCHAR(10), isnull(fre_exec_date,'') , 111), '/', '')  [cm_freezedt]  
, isnull(fre_rmks,'') [cm_freezereason]  
, case when fre_status='a'then '1' else '0' end  [cm_freezeyn]  
, isnull(ltrim(rtrim(dps8_pc12.Addr1)),'') cb_add1  
, isnull(ltrim(rtrim(dps8_pc12.Addr2)),'') cb_add2  
, isnull(ltrim(rtrim(dps8_pc12.Addr3)),'') cb_add3  
, '' cb_annualincome  --pending 
, isnull(TMPBA_DP_BANK_ADD1,'')   cb_bankadd1  
, isnull(TMPBA_DP_BANK_ADD2,'')   cb_bankadd2  
, isnull(TMPBA_DP_BANK_ADD3,'') cb_bankadd3  
  
, banm_branch cb_bankbranch  
, '' cb_bosettlementplanflag  --pending
, isnull(ltrim(rtrim(dps8_pc12.City)),'') cb_city  
, dpam_sba_no cb_cmcd  
, isnull(ltrim(rtrim(dps8_pc12.Country)),'')  cb_country  
, '' cb_degree  --pending 
, '0' cb_dividendcurrency  
, ltrim(rtrim(isnull(DPS8_PC1.FthName,'')))  cb_fathername  
, dpam_acct_no cb_formno  
, '' cb_geographical  --pending
, '' cb_language   --pending 
, '' cb_lifestyle  --pending 
, '' cb_nationality  --pending 
, ltrim(rtrim(isnull(DPS8_PC6.Name,''))) +' '+ ltrim(rtrim(isnull(DPS8_PC6.MiddleName,'')))+' '+ltrim(rtrim(isnull(DPS8_PC6.SearchName ,''))) cb_nominee  
, ltrim(rtrim(isnull(DPS8_PC6.DateOfBirth,'')))  cb_nominee_dob  
, ltrim(rtrim(isnull(DPS8_PC6.Addr1,'')))  cb_nomineeadd1  
, ltrim(rtrim(isnull(DPS8_PC6.Addr2,'')))  cb_nomineeadd2  
, ltrim(rtrim(isnull(DPS8_PC6.Addr3,'')))  cb_nomineeadd3  
, ltrim(rtrim(isnull(DPS8_PC6.City,'')))  cb_nomineecity  
, ltrim(rtrim(isnull(DPS8_PC6.Country,'')))  cb_nomineecountry  
, ltrim(rtrim(isnull(DPS8_PC6.PinCode,'')))  cb_nomineepin  
, ltrim(rtrim(isnull(DPS8_PC6.State,'')))  cb_nomineestate  
, dps8_pc1.PANGIR cb_panno  
, isnull(ltrim(rtrim(dps8_pc12.PinCode)),'') cb_pin  
, ltrim(rtrim(isnull(DPS8_PC2.FthName,'')))  cb_sechfathername  
, ltrim(rtrim(isnull(DPS8_PC2.SearchName,'')))  cb_sechlastname  
, ltrim(rtrim(isnull(DPS8_PC2.MiddleName,''))) cb_sechmiddle  
, ltrim(rtrim(isnull(DPS8_PC2.PANGIR,''))) cb_sechpanno  
, '' cb_sechtitle  
, '' cb_setupdate  
, isnull(clim_gender,'') cb_sexcode  
, isnull(ltrim(rtrim(dps8_pc12.State)),'') cb_state  
, dps8_pc1.PriPhNum cb_tele1  
,  ltrim(rtrim(isnull(DPS8_PC3.FthName,'')))   cb_thirdfathername  
, ltrim(rtrim(isnull(DPS8_PC3.SearchName,'')))  cb_thirdlastname  
, ltrim(rtrim(isnull(DPS8_PC3.MiddleName,'')))  cb_thirdmiddle  
, ltrim(rtrim(isnull(DPS8_PC3.PANGIR,'')))  cb_thirdpanno  
, '' cb_thirdtitle  
, isnull( dps8_pc1.DivIFScd,'') cb_voicemail  
, dpam_lst_upd_dt Last_Modified_Date

FROM    DP_ACCT_MSTR DPAM
left outer join freeze_unfreeze_dtls on fre_Dpam_id = dpam.dpam_id and fre_deleted_ind = 1
		left outer join dps8_pc1  dps8_pc1  on dps8_pc1.boid = dpam_sba_no 
left outer join
		(select a.* from bank_mstr a,(select max(banm_id) banm_id ,banm_micr,banm_rtgs_cd from BANK_MSTR where banm_deleted_ind = 1 group by  banm_micr,banm_rtgs_cd) maxbanm
where a.banm_id = maxbanm.banm_id ) banm    on   banm_micr      = DivBankCd AND banm_rtgs_cd = DivIFScd 
		
        left outer join
        bank_addresses_dtls on TMPBA_DP_BANK = banm_micr and TMPBA_DP_BR = banm_rtgs_cd
		left outer join dps8_pc2  dps8_pc2  on dps8_pc2.boid = dps8_pc1.boid 
		left outer join dps8_pc3  dps8_pc3  on dps8_pc3.boid = dps8_pc1.boid 
		left outer join (SELECT BOID,Name,MiddleName,SearchName ,FthName,Addr1,
Addr2,Addr3,City,State,Country,PinCode,PANGIR,DateOfBirth,MAX(DateOfSetup) D
FROM dps8_pc6 GROUP BY BOID,Name,MiddleName,SearchName ,FthName,Addr1,Addr2,
Addr3,City,State,Country,PinCode,PANGIR,DateOfBirth)  dps8_pc6  on dps8_pc6.boid = dps8_pc1.boid 
		left outer join (SELECT BOID,Name,MiddleName,SearchName ,FthName,Addr1,
Addr2,Addr3,City,State,Country,PinCode,PANGIR,DateOfBirth,MAX(DateOfSetup) D
FROM dps8_pc7 GROUP BY BOID,Name,MiddleName,SearchName ,FthName,Addr1,Addr2,
Addr3,City,State,Country,PinCode,PANGIR,DateOfBirth)  dps8_pc7  on dps8_pc7.boid = dps8_pc1.boid 
		left outer join dps8_pc12 dps8_pc12 on dps8_pc12.boid = dps8_pc1.boid 
		left outer join dps8_pc16 dps8_pc16 on dps8_pc16.boid = dps8_pc1.boid 
		LEFT OUTER JOIN 
        client_dp_brkg     on dpam_id = clidb_dpam_id  and getdate() between clidb_eff_from_dt and clidb_eff_to_dt
        LEFT OUTER JOIN 
      	brokerage_mstr on brom_id = clidb_brom_id  
--        LEFT OUTER JOIN 
--		DP_HOLDER_DTLS ON  DPAM_ID = DPHD_DPAM_ID AND DPHD_DELETED_IND =1
		LEFT OUTER JOIN 
		DP_POA_DTLS    ON   DPAM_ID = DPPD_DPAM_ID  AND DPPD_DELETED_IND =1
--		left outer join 
--        account_documents on accd_clisba_id = DPAM_ID and accd_deleted_ind = 1 and accd_accdocm_doc_id = 12
		,CLIENT_CTGRY_MSTR
		,ENTITY_TYPE_MSTR
		,STATUS_MSTR
		,SUB_CTGRY_MSTR 
		,CLIENT_MSTR
		--,CLIENT_BANK_ACCTS
		--,BANK_MSTR  
		--,CITRUS_USR.FN_ACCT_LIST(@@DPMID ,@PA_LOGIN_PR_ENTM_ID,@@L_CHILD_ENTM_ID) ACCOUNT 		       
		
		
	   	WHERE isNumeric(dpam.DPAM_SBA_NO)=1 
        --and right(dpam.DPAM_SBA_NO,8)  BETWEEN @PA_FROM_ACCTNO AND @PA_TO_ACCTNO
		AND   DPAM.DPAM_CLICM_CD = CLICM_CD --and dpam_sba_no ='1201090001321086'
		AND   DPAM.DPAM_ENTTM_CD = ENTTM_CD
		AND   DPAM.DPAM_STAM_CD  = STAM_CD
		AND   DPAM.DPAM_SUBCM_CD = SUBCM_CD
		--AND   CLICM_ID           = SUBCM_CLICM_ID
		AND   CLIM_CRN_NO        = DPAM.DPAM_CRN_NO

GO
