-- Object: VIEW citrus_usr.dp_client_master_multiclient_bak_07012019
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------




--select  top 1000 cm_tele1, * from [dp_client_master_1] where cm_cd  ='1201090001321086'  
--select * from dps8_pc1 where boid = '1201090001321086'
CREATE view [citrus_usr].[dp_client_master_multiclient_bak_07012019]  
as
select dpam_sba_no,dpam_crn_no,dpam_stam_cd, enttm_desc, clicm_desc,subcm_desc , stam_desc , dpam_dpm_id ,  dps8_pc1.boid , case when ClosDt <> '' then right(ClosDt,4)+substring(ClosDt,3,2)+left(ClosDt,2) else '' end cm_acc_closuredate  
, left(enttm_cd,2) cm_acctype  
, case when dpam_stam_Cd ='active' then '01' else stam_cd end  cm_active  
, isnull(ltrim(rtrim(dps8_pc1.Addr1)),'') cm_add1  
, isnull(ltrim(rtrim(dps8_pc1.Addr2)),'') cm_add2  
, isnull(ltrim(rtrim(dps8_pc1.Addr3)),'') cm_add3  
, isnull(banm_name ,'') cm_bankname  
, isnull(dpam_bbo_code,'') [cm_blsavingcd]  
, BOStatCycleCd cm_bostatementcycle  
,replace(ISNULL(CITRUS_USR.FN_FIND_RELATIONS(DPAM.DPAM_CRN_NO,'BA'),''),'_ba','') ba
,replace(ISNULL(CITRUS_USR.FN_FIND_RELATIONS(DPAM.DPAM_CRN_NO,'br'),''),'_br','') br
,replace(ISNULL(CITRUS_USR.FN_FIND_RELATIONS(DPAM.DPAM_CRN_NO,'onw'),''),'_onw','') onw
,replace(ISNULL(CITRUS_USR.FN_FIND_RELATIONS(DPAM.DPAM_CRN_NO,'rem'),''),'_rem','') rem
,replace(ISNULL(CITRUS_USR.FN_FIND_RELATIONS(DPAM.DPAM_CRN_NO,'BL'),''),'_BL','') BL
--, ISNULL(CITRUS_USR.FN_FIND_RELATIONS(DPAM.DPAM_CRN_NO,'BA'),isnull(CITRUS_USR.FN_FIND_RELATIONS(DPAM.DPAM_CRN_NO,'BR'),''))  cm_brcode  
--, replace(replace(ISNULL(CITRUS_USR.FN_FIND_RELATIONS(DPAM.DPAM_CRN_NO,'onw'),isnull(CITRUS_USR.FN_FIND_RELATIONS(DPAM.DPAM_CRN_NO,'rem'),'')),'_onw',''),'_rem','')   remonw  
, dpam_sba_no  cm_cd  
, brom_desc cm_chgsscheme  
, isnull(ltrim(rtrim(dps8_pc1.City)),'') cm_city  
, right(subcm_cd,4) cm_clienttype  
, isnull(ltrim(rtrim(dps8_pc1.Country)),'') cm_country  
, case when isnull(dps8_pc1.DateOfBirth,'') <> '' then right(dps8_pc1.DateOfBirth  ,4)+substring(dps8_pc1.DateOfBirth  ,3,2)+left(dps8_pc1.DateOfBirth  ,2) else '' end  cm_dateofbirth  
, acno cm_divbankacno  
, DivBankCurr cm_divbankccy  
, micr cm_divbankcode  
, case when actype = 'savings' then '10' when actype  = 'current' then '11' else '13' end   cm_divbranchno  
, dpam_acct_no cm_dpintrefno  
, dps8_pc1.EMailId cm_email  
, dps8_pc1.SearchName cm_lastname  
, micr cm_micr  
, dps8_pc1.MiddleName cm_middlename  
, case when isnull(MobileNum,'') <> '' then isnull(MobileNum,'') else  case when  dps8_pc1.PriPhInd = 'M' then  dps8_pc1.PriPhNum else '' end end  cm_mobile  
, dpam_sba_name cm_name  
, OCCUPATION cm_occupation  
, case when dps8_pc1.AcctCreatDt<>'' then right(dps8_pc1.AcctCreatDt,4)+substring(dps8_pc1.AcctCreatDt,3,2)+left(dps8_pc1.AcctCreatDt,2)  else '' end  cm_opendate  
, isnull(ltrim(rtrim(dps8_pc1.PinCode)),'')  cm_pin  
, case when dps8_pc5.GPABPAFlg ='B' then 'Y' else 'N' end  cm_poaforpayin  
,  right(dps8_pc5.setupdate,4)+substring(dps8_pc5.setupdate,3,2)+left(dps8_pc5.setupdate,2)  cm_poaregdate  
, convert(numeric,left(subcm_cd,2)) cm_productcd  
,ltrim(rtrim(isnull(DPS8_PC2.Name,''))) +' '  +ltrim(rtrim(isnull(DPS8_PC2.MiddleName,''))) +' '  +ltrim(rtrim(isnull(DPS8_PC2.SearchName,'')))  cm_sech_name  
, isnull(ltrim(rtrim(dps8_pc1.State)),'')  cm_state  
, case when  dps8_pc1.PriPhInd <> 'M' then  dps8_pc1.PriPhNum else '' end cm_tele1  
, ltrim(rtrim(isnull(DPS8_PC3.Name,'')))+' '  +ltrim(rtrim(isnull(DPS8_PC3.MiddleName ,'')))+' '  +ltrim(rtrim(isnull(DPS8_PC3.SearchName,''))) cm_thih_name  
, '' cm_title  
, case when isnull(masterpoaid,'')<>'' then 'Y' else 'N' end  [IS POA]  
, isnull(masterpoaid,'') [Master POA ID]  
,   REPLACE(CONVERT(VARCHAR(10), isnull(fre_exec_date,'') , 111), '/', '')  [cm_freezedt]  
, isnull(fre_rmks,'') [cm_freezereason]  
, case when fre_status='a'then '1' else '0' end  [cm_freezeyn]  
, isnull(ltrim(rtrim(dps8_pc12.Addr1)),'')  cb_add1  
, isnull(ltrim(rtrim(dps8_pc12.Addr2)),'')  cb_add2  
, isnull(ltrim(rtrim(dps8_pc12.Addr3)),'')  cb_add3  
, AnnIncomeCd cb_annualincome  

, isnull(badr1,'')   cb_bankadd1  
, isnull(badr2,'')   cb_bankadd2  
, isnull(badr3,'') cb_bankadd3  
--  
, branch cb_bankbranch  
,BOSettPlanFlg cb_bosettlementplanflag  
, isnull(ltrim(rtrim(dps8_pc12.City)),'') cb_city  
, dpam_sba_no cb_cmcd  
, isnull(ltrim(rtrim(dps8_pc12.Country)),'') cb_country  
, Edu cb_degree  
, '0' cb_dividendcurrency  
, ltrim(rtrim(isnull(DPS8_PC1.FthName,''))) cb_fathername  
, dpam_acct_no cb_formno  
, GeogCd cb_geographical  
, LangCd cb_language  
, '' cb_lifestyle  
, NatCd cb_nationality  
, ltrim(rtrim(isnull(DPS8_PC6.Name,''))) +' '+ ltrim(rtrim(isnull(DPS8_PC6.MiddleName,'')))+' '+ltrim(rtrim(isnull(DPS8_PC6.SearchName ,'')))  cb_nominee  
, ltrim(rtrim(isnull(DPS8_PC7.Name,''))) +' '+ ltrim(rtrim(isnull(DPS8_PC7.MiddleName,'')))+' '+ltrim(rtrim(isnull(DPS8_PC7.SearchName ,'')))  cb_gau 
, ltrim(rtrim(isnull(DPS8_PC8.Name,''))) +' '+ ltrim(rtrim(isnull(DPS8_PC8.MiddleName,'')))+' '+ltrim(rtrim(isnull(DPS8_PC8.SearchName ,'')))  cb_nomineeg 
,case when dps8_pc1.Filler9 in ('0','','N') then '' else 'YES' end bsda
,case when  dps8_pc1.AnnlRep in ('0','','N') then '' else 'YES' end rgess
, case when ltrim(rtrim(isnull(DPS8_PC6.DateOfBirth ,''))) <> '' then right(DPS8_PC6.DateOfBirth ,4)+substring(DPS8_PC6.DateOfBirth ,3,2)+left(DPS8_PC6.DateOfBirth ,2) end cb_nominee_dob  
, ltrim(rtrim(isnull(DPS8_PC6.Addr1,''))) cb_nomineeadd1  
, ltrim(rtrim(isnull(DPS8_PC6.Addr2,''))) cb_nomineeadd2  
, ltrim(rtrim(isnull(DPS8_PC6.Addr3,''))) cb_nomineeadd3  
, ltrim(rtrim(isnull(DPS8_PC6.City,''))) cb_nomineecity  
, ltrim(rtrim(isnull(DPS8_PC6.Country,''))) cb_nomineecountry  
, ltrim(rtrim(isnull(DPS8_PC6.PinCode,''))) cb_nomineepin  
, ltrim(rtrim(isnull(DPS8_PC6.State,''))) cb_nomineestate  
, ltrim(rtrim(isnull(DPS8_PC1.PANGIR,''))) cb_panno  
, isnull(ltrim(rtrim(dps8_pc12.PinCode)),'')  cb_pin  
, ltrim(rtrim(isnull(dps8_pc2.FthName,''))) cb_sechfathername  
, ltrim(rtrim(isnull(DPS8_PC2.name,''))) shname  
, ltrim(rtrim(isnull(DPS8_PC3.name,''))) thname  
, ltrim(rtrim(isnull(DPS8_PC2.SearchName,''))) cb_sechlastname  
, ltrim(rtrim(isnull(DPS8_PC2.MiddleName,''))) cb_sechmiddle  
, ltrim(rtrim(isnull(DPS8_PC2.PANGIR,''))) cb_sechpanno  
, '' cb_sechtitle  
, '' cb_setupdate  
, isnull(SexCd,'') cb_sexcode  
, isnull(ltrim(rtrim(dps8_pc12.State)),'') cb_state  
, ltrim(rtrim(isnull(dps8_pc1.AltPhNum,''))) cb_tele1  
, ltrim(rtrim(isnull(dps8_pc3.FthName,'')))  cb_thirdfathername  
, ltrim(rtrim(isnull(DPS8_PC3.SearchName,''))) cb_thirdlastname  
, ltrim(rtrim(isnull(DPS8_PC3.MiddleName,''))) cb_thirdmiddle  
,ltrim(rtrim(isnull(DPS8_PC3.PANGIR,'')))cb_thirdpanno  
, '' cb_thirdtitle  
, rtgs cb_voicemail  ,dpam_lst_upd_dt Last_Modified_Date
,case when dps8_pc1.PriPhInd ='R' then dps8_pc1.PriPhNum else '' end  [res ph] 
,case when dps8_pc1.PriPhInd ='M' then dps8_pc1.PriPhNum else dps8_pc1.PriPhNum end  [mobile]
,case when dps8_pc1.PriPhInd ='O' then dps8_pc1.PriPhNum else '' end  [office ph]
,left(dps8_pc1.AcctCreatDt,2) + '/' +  substring(dps8_pc1.AcctCreatDt,3,2) + '/'  + right(dps8_pc1.AcctCreatDt,4)   [activation date]
,case when ClosDt <> '' then left(dps8_pc1.ClosDt,2) +'/'+ substring(dps8_pc1.ClosDt,3,2)+'/'+right(dps8_pc1.ClosDt,4) else '' end   [Account Closure Date]
,stam_cd
,subcm_cd
,clicm_Cd
,enttm_cd
,dpam_subcm_cd,brom_id
,ECS
 ,citrus_usr.fn_acct_entp(dpam.dpam_id,'CLIENT GST') [CLIENT GST NO]
,case when isnull(dps8_pc16.mobilenum,'')<>'' then 'Y' else 'N' end  smsreg
 ,case when BenTaxDedStat = '0' then ''      
                        when BenTaxDedStat= '2' then 'Resident Individual'     
                        when BenTaxDedStat= '3' then 'NRI With Repatriation'     
                        when BenTaxDedStat= '4' then 'NRI Without Repatriation'     
                        when BenTaxDedStat= '5' then 'Domestic Companies'     
                        when BenTaxDedStat= '6' then 'Overseas Corporate Bodies'     
                        when BenTaxDedStat= '7' then 'Foreign Companies'     
                        when BenTaxDedStat= '8' then 'Mutual Funds'     
                        when BenTaxDedStat= '9' then 'Double Taxation Treaty'     
                        when BenTaxDedStat= '10' then 'Others' else '' end   taxded
,(select top 1 isnull(poam_name1,'')
+ isnull(poam_name2,'')
+ isnull(poam_name3,'') poaname 
 from poa_mstr where poam_master_id = isnull(masterpoaid,'')  and poam_deleted_ind = 1 ) poaname
,isnull(dps8_pc16.mobilenum,'') smsmob
, DPAM.DPAM_ACCT_NO [FORM NO]
FROM  dps8_pc1 with (nolock) left outer join 
   DP_ACCT_MSTR DPAM  with (nolock) on dps8_pc1.boid = dpam_sba_no 
left outer join freeze_unfreeze_dtls with (nolock) on fre_Dpam_id = dpam.dpam_id and fre_deleted_ind = 1  
left outer join (select isnull(citrus_usr.fn_splitval_by(isnull(BANM_NAME,''),'1','-'),'')  BANM_NAME
,isnull(banm_branch,'') branch
,TMPBA_DP_BANK_ADD1 badr1
,TMPBA_DP_BANK_ADD2 badr2
,TMPBA_DP_BANK_ADD3 badr3
,TMPBA_DP_BANK_CITY bcity
,TMPBA_DP_BANK_STATE bstate
,TMPBA_DP_BANK_CNTRY bcountry
,TMPBA_DP_BANK_ZIP bzip,dpam_sba_no sba_no,CLIBA_AC_NO acno,banm_micr micr, banm_rtgs_cd rtgs,CLIBA_AC_TYPE actype
from client_bank_accts , dp_Acct_mstr 
,bank_mstr left outer join 
 bank_addresses_dtls 
on TMPBA_DP_BANK = banm_micr 
and TMPBA_DP_BR = banm_rtgs_cd 
where cliba_clisba_id = dpam_id and cliba_banm_id = banm_id 
and cliba_deleted_ind = 1 
and dpam_deleted_ind  = 1 
and banm_deleted_ind  = 1 
) bankdetails on sba_no = dps8_pc1.boid 
--left outer join  
--  BANK_MSTR    on   banm_micr      = DivBankCd AND banm_rtgs_cd = DivIFScd and  BANM_DELETED_IND = 1  
--        left outer join  
--        bank_addresses_dtls on TMPBA_DP_BANK = banm_micr and TMPBA_DP_BR = banm_rtgs_cd  
  left outer join dps8_pc2  dps8_pc2 with (nolock)  on dps8_pc2.boid = dps8_pc1.boid   
  left outer join dps8_pc3 dps8_pc3  with (nolock)   on dps8_pc3.boid = dps8_pc1.boid   
left outer join dps8_pc5 dps8_pc5  with (nolock)   on dps8_pc5.boid = dps8_pc1.boid and HolderNum ='1'
  left outer join (SELECT BOID,Name,MiddleName,SearchName ,FthName,Addr1,  
Addr2,Addr3,City,State,Country,PinCode,PANGIR,DateOfBirth,MAX(DateOfSetup) D  
FROM dps8_pc6 with (nolock)  GROUP BY BOID,Name,MiddleName,SearchName ,FthName,Addr1,Addr2,  
Addr3,City,State,Country,PinCode,PANGIR,DateOfBirth)  dps8_pc6  on dps8_pc6.boid = dps8_pc1.boid   
  left outer join (SELECT BOID,Name,MiddleName,SearchName ,FthName,Addr1,  
Addr2,Addr3,City,State,Country,PinCode,PANGIR,DateOfBirth,MAX(DateOfSetup) D  
FROM dps8_pc7 with (nolock)  GROUP BY BOID,Name,MiddleName,SearchName ,FthName,Addr1,Addr2,  
Addr3,City,State,Country,PinCode,PANGIR,DateOfBirth)  dps8_pc7  on dps8_pc7.boid = dps8_pc1.boid   
left outer join (SELECT BOID,Name,MiddleName,SearchName ,FthName,Addr1,  
Addr2,Addr3,City,State,Country,PinCode,PANGIR,DateOfBirth,MAX(DateOfSetup) D  
FROM dps8_pc8 with (nolock)  GROUP BY BOID,Name,MiddleName,SearchName ,FthName,Addr1,Addr2,  
Addr3,City,State,Country,PinCode,PANGIR,DateOfBirth)  dps8_pc8  on dps8_pc8.boid = dps8_pc1.boid   
  left outer join dps8_pc12  dps8_pc12 with (nolock)  on dps8_pc12.boid = dps8_pc1.boid   
  left outer join dps8_pc16 dps8_pc16  with (nolock)  on dps8_pc16.boid = dps8_pc1.boid   
  LEFT OUTER JOIN   
        client_dp_brkg  with (nolock)    on dpam_id = clidb_dpam_id  and getdate() between clidb_eff_from_dt and clidb_eff_to_dt  
        LEFT OUTER JOIN   
       brokerage_mstr with (nolock)  on brom_id = clidb_brom_id    
--        LEFT OUTER JOIN   
--  DP_HOLDER_DTLS ON  DPAM_ID = DPHD_DPAM_ID AND DPHD_DELETED_IND =1  
--  LEFT OUTER JOIN   
--  DP_POA_DTLS  with (nolock)   ON   DPAM_ID = DPPD_DPAM_ID  AND DPPD_DELETED_IND =1  
--  left outer join   
--        account_documents on accd_clisba_id = DPAM_ID and accd_deleted_ind = 1 and accd_accdocm_doc_id = 12  
  ,CLIENT_CTGRY_MSTR   with (nolock) 
  ,ENTITY_TYPE_MSTR   with (nolock) 
  ,STATUS_MSTR   with (nolock) 
  ,SUB_CTGRY_MSTR    with (nolock) 
  --,CLIENT_MSTR   with (nolock) 
  --,CLIENT_BANK_ACCTS  
  --,BANK_MSTR    
  --,CITRUS_USR.FN_ACCT_LIST(@@DPMID ,@PA_LOGIN_PR_ENTM_ID,@@L_CHILD_ENTM_ID) ACCOUNT            
    
    
     WHERE   isNumeric(dpam.DPAM_SBA_NO)=1   
    --   and dpam.DPAM_SBA_NO = '1201090000004621'
  AND   DPAM.DPAM_CLICM_CD = CLICM_CD   
  AND   DPAM.DPAM_ENTTM_CD = ENTTM_CD  
  AND   DPAM.DPAM_STAM_CD  = STAM_CD  
  AND   DPAM.DPAM_SUBCM_CD = SUBCM_CD  
  AND   CLICM_ID           = SUBCM_CLICM_ID  
 -- AND   CLIM_CRN_NO        = DPAM.DPAM_CRN_NO

GO
