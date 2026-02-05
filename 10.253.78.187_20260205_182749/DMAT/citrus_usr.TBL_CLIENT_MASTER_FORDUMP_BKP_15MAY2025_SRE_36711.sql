-- Object: VIEW citrus_usr.TBL_CLIENT_MASTER_FORDUMP_BKP_15MAY2025_SRE_36711
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------










--isdate(RIGHT(pc6.DateOfBirth,4)  +'-'+ substring(pc6.DateOfBirth,3,2)+'-'+left(pc6.DateOfBirth ,2))=0
--select  * from [TBL_CLIENT_MASTER_FORDUMP]
CREATE  view [citrus_usr].[TBL_CLIENT_MASTER_FORDUMP_BKP_15MAY2025_SRE_36711]  
as  
select distinct  '' ACCOUNT_TYPE  
,convert(varchar(40),enttm_desc) CATEGORY  
,convert(varchar(2),Occupation ) OCCUPATION  
,convert(varchar(40),STAM_DESC)  STATUS  
,convert(varchar(40),SUBCM_DESC)  SUB_TYPE  
,convert(varchar(10),DPAM_ACCT_NO )  DP_INT_REFNO  
,POA_ID = convert(varchar(16),(SELECT TOP 1 POARegNum FROM POA_REG WHERE  BOId = dpam.DPAM_SBA_NO ) )   ---convert(varchar(16),POARegNum ) POA_ID  
,POA_NAME = isnull((SELECT  TOP 1 poam_name1 FROM POA_REG WHERE  BOId = dpam.DPAM_SBA_NO ),'')   -- poam_name1  POA_NAME  
,convert(datetime,case when pc1.ClosAppDt   = '' then '' else left(pc1.ClosAppDt  ,2)+'/'+substring(pc1.ClosAppDt  ,3,2)+'/'+RIGHT(pc1.ClosAppDt  ,4) end , 103 )    CLOSURE_DATE  
,convert(varchar(20),pc1.Suffix ) TITLE  
,convert(varchar(100),ltrim(rtrim(pc1.Name)) +' '+ltrim(rtrim(isnull(pc1.MiddleName,'')))+' '+ltrim(rtrim(isnull(pc1.SearchName ,''))))  FIRST_HOLD_NAME  
,convert(varchar(50),pc1.Title  ) SALUTATION  
,convert(varchar(75),ltrim(rtrim(pc1.Name)) +' '+ltrim(rtrim(isnull(pc1.MiddleName,'')))+' '+ltrim(rtrim(isnull(pc1.SearchName ,'')))) CONTACT_PERSON  
,convert(varchar(30),pc1.Addr1 ) FIRST_HOLD_ADD1  
,convert(varchar(30),pc1.Addr2  ) FIRST_HOLD_ADD2  
,convert(varchar(30),pc1.Addr3  ) FIRST_HOLD_ADD3  
,convert(varchar(10),pc1.PinCode  ) FIRST_HOLD_PIN  
,convert(varchar(25),pc1.Country  ) FIRST_HOLD_CNTRY  
,convert(varchar(25),pc1.State  ) FIRST_HOLD_STATE  
,convert(varchar(17),pc1.PriPhNum  ) FIRST_HOLD_PHONE  
,convert(varchar(17),pc1.Fax  ) FIRST_HOLD_FAX  
,convert(varchar(50),Isnull(pc1.pri_email,pc1.EMailId)) EMAIL_ADD  
,convert(varchar(30),pc12.Addr1 ) FOREIGN_ADDR1  
,convert(varchar(30),pc12.Addr2 ) FOREIGN_ADDR2  
,convert(varchar(30),pc12.Addr3 ) FOREIGN_ADDR3  
,convert(varchar(25),pc12.City  ) FOREIGN_CITY  
,convert(varchar(25),pc12.State  ) FOREIGN_STATE  
,convert(varchar(25),pc12.Country ) FOREIGN_CNTRY  
,convert(varchar(10),pc12.PinCode  ) FOREIGN_ZIP  
,convert(varchar(17),pc12.PriPhNum  ) FOREIGN_PHONE  
,convert(varchar(17),pc12.Fax   ) FOREIGN_FAX  
,convert(varchar(100),ltrim(rtrim(pc2.Name)) +' '+ltrim(rtrim(isnull(pc2.MiddleName,'')))+' '+ltrim(rtrim(isnull(pc2.SearchName ,''))) )  SECOND_HOLD_NAME  
,convert(varchar(100),ltrim(rtrim(pc3.Name)) +' '+ltrim(rtrim(isnull(pc3.MiddleName,'')))+' '+ltrim(rtrim(isnull(pc3.SearchName ,''))))   THIRD_HOLD_NAME  
,convert(varchar(25),pc1.PANGIR  ) ITPAN  
,convert(varchar(40),pc1.BenTaxDedStat) TAX_DEDUCT  
,convert(varchar(12),pc1.DivBankCd) BANK_MICR  
,convert(varchar(12),pc1.DivBankCd ) MICR_CODE  
,convert(varchar(20),pc1.DivBankAcctNo ) BANK_ACCNO  
,convert(varchar(100),citrus_usr.fn_get_bank_name(DivBankCd,DivIFScd))  BANK_NAME  
,bankaddr.TMPBA_DP_BANK_ADD1   BANK_ADD1  
,bankaddr.TMPBA_DP_BANK_ADD2  BANK_ADD2  
,bankaddr.TMPBA_DP_BANK_ADD3  BANK_ADD3  
--,bankaddr.TMPBA_DP_BANK_CITY  BANK_ADD4  
,''  BANK_ADD4  
,bankaddr.TMPBA_DP_BANK_STATE   BANK_STATE  
,bankaddr.TMPBA_DP_BANK_CNTRY   BANK_CNTRY  
,convert(varchar(10),bankaddr.TMPBA_DP_BANK_ZIP)   BANK_ZIP  
,convert(varchar(24),pc1.SEBIRegNum  ) SEBI_REG_NO  
,convert(varchar(30),pc1.RBIRefNum  ) RBI_REFNO  
,convert(datetime,case when pc1.RBIAppDt   = '' then '' else left(pc1.RBIAppDt  ,2)+'/'+substring(pc1.RBIAppDt  ,3,2)+'/'+RIGHT(pc1.RBIAppDt  ,4) end ,103)  RBI_APP_DT  
,convert(varchar(100),ltrim(rtrim(pc6.Name)) +' '+ltrim(rtrim(isnull(pc6.MiddleName,'')))+' '+ltrim(rtrim(isnull(pc6.SearchName ,''))) )    NOMI_GUARD_NAME  
,convert(varchar(90),pc6.Addr1+''+ ltrim(rtrim(isnull(pc6.Addr2,'')))+''+ltrim(rtrim(isnull(pc6.Addr3,''))) ) NOMI_GUARD_ADD1  
,convert(varchar(85),ltrim(rtrim(isnull(pc6.City,'')))+' '+ltrim(rtrim(isnull(pc6.state,'')))+' '+ltrim(rtrim(isnull(pc6.Country,'')))+' '+ltrim(rtrim(isnull(pc6.pincode,'')))  ) NOMI_GUARD_ADD2  
,convert(datetime,case when pc6.DateOfBirth  = '' then '' else left(pc6.DateOfBirth ,2)+'/'+substring(pc6.DateOfBirth,3,2)+'/'+RIGHT(pc6.DateOfBirth,4) end,103 ) MINOR_BIRTH_DATE  
--,convert(datetime,'',103 ) MINOR_BIRTH_DATE  
,'' CM_ID  
,convert(numeric,'0') CH_ID  
,'' TRADING_ID  
,convert(varchar(8),pc1.GroupCd  ) GROUP_ID  
,convert(numeric,'0') EXCHANGE_ID  
,convert(varchar(4),pc1.ProdCode)  PROD_NO  
,case when pc1.BOAcctStatus='1' then 'Y' else 'N' end  ACTIVE_STATUS  
,'' CHANGE_REASON  
,convert(varchar(6),br.ENTM_NAME1)   BRANCH_CODE   
,convert(varchar(10),sb.ENTM_NAME1 )  GROUP_CODE  
,convert(numeric,'0') FAMILY_CODE   
,convert(varchar(21),brom_desc) TEMPLATE_CODE -- pending   
,convert(varchar(10),dpam_bbo_code)  NISE_PARTY_CODE  
,'' MAILING_FLAG  
,'' DISPATCH_MODE  
,'' BILLING_FREQ  
,convert(datetime,'' ,103) PRINT_DATE  
,convert(numeric,'0') LETTER_NO  
,'' FILE_REF_NO  
--,convert(datetime,left(pc1.BOActDt ,2)+'/'+substring(pc1.BOActDt,3,2)+'/'+RIGHT(pc1.BOActDt,4),103) ACTIVE_DATE  
--,convert(datetime,case when pc1.BOActDt   = '' then '01/01/1900' else left(pc1.BOActDt ,2)+'/'+substring(pc1.BOActDt ,3,2)+'/'+RIGHT(pc1.BOActDt ,4) end ) ACTIVE_DATE  
,convert(datetime,case when pc1.BOActDt   = '' then '1900-01-01' ELSE   
  REPLACE(CONVERT(VARCHAR(19),right (pc1.BOActDt ,4 )+'-'+substring (pc1.BOActDt ,3,2)+'-'+left (pc1.BOActDt ,2 ) ),'--','') END) ACTIVE_DATE  
,convert(varchar(25),pc1.City  ) FIRST_HOLD_ADD4  
,convert(varchar(2),pc1.BOAcctStatus ) BENEF_STATUS  
,'' INTRO_ID  
,convert(varchar(16),dpam.dpam_sba_name)  SHORT_NAME  
,convert(varchar(16),dpam.dpam_sba_no ) CLIENT_CODE  
,'' CLIENT_CITY_CODE  
,convert(numeric,RIGHT(dpam.dpam_sba_no ,8) ) BENEF_ACCNO  
,convert(varchar(4),pc1.ConfWaived  ) PURCHASE_WAIVER  
,convert(varchar(40),clicm_desc) TYPE  
,convert(numeric,'33200') DP_ID  
,convert(varchar(11),case when pc1.DateOfBirth   = '' then '1900-01-01' ELSE   
  REPLACE(CONVERT(VARCHAR(19),right (pc1.DateOfBirth ,4 )+'-'+substring (pc1.DateOfBirth ,3,2)+'-'+left (pc1.DateOfBirth ,2 ) ),'--','') end,120) BO_DOB
--convert(varchar(11),pc1.DateOfBirth)  BO_DOB  
,convert(varchar(1),pc1.SexCd ) BO_SEX  
,convert(varchar(3),pc1.NatCd ) BO_NATIONALITY  
,convert(varchar(2),pc1.BOStatCycleCd  )NO_STMT_CODE  
,convert(numeric,'0') CLOSE_REASON  
,convert(numeric,'0') CLOSE_INITIATE  
,''  CLOSE_REQ_DATE  
,convert(varchar(11),pc1.ClosAppDt) CLOSE_APPROVAL_DATE  
,'' BO_SUSPENSION_FLAG  
,'' BO_SUSPENSION_DATE  
,convert(numeric,'0') BO_SUSPENSION_REASON  
,convert(numeric,'0') BO_SUSPENSION_INITIATE  
,convert(varchar(4),pc1.Occupation  ) PROFESSION_CODE  
,'' LIFE_STYLE_CODE  
,convert(varchar(4),pc1.GeogCd  ) GEOGRAPH_CODE  
,convert(varchar(4),pc1.Edu ) EDUCATION_CODE  
,convert(numeric,case when pc1.AnnIncomeCd  ='' then '0' else pc1.AnnIncomeCd   end ) INCOME_CODE  
,convert(varchar(1),pc1.Staff  ) STAFF_FLAG  
,convert(varchar(10),pc1.StaffCd  ) STAFF_CODE  
,convert(varchar(1),pc1.ECS ) ELECTRONIC_DIVIDEND  
,convert(varchar(1),pc1.EletConf ) ELECTRONIC_CONF  
,convert(numeric,case when pc1.DivBankCurr ='' then '0' else pc1.DivBankCurr  end   ) DIVIDEND_CURRENCY  
,convert(varchar(12),pc1.DivBankCd )  BO_BANK_CODE  
,convert(varchar(12),pc1.DivIFScd) BO_BRANCH_NO  
,convert(varchar(20),pc1.DivBankAcctNo ) DIVIDEND_ACCOUNT_NO  
,convert(numeric,case when pc1.DivBankCurr ='' then '0' else pc1.DivBankCurr  end ) BO_CURRENCY  
,convert(numeric,pc1.DivAcctType ) BANK_ACCOUNT_TYPE  
,convert(numeric,pc1.DivAcctType ) BANK_ACC_TYPE  
,convert(varchar(1),bankaddr.TMPBA_DP_BANK_ZIP)   BANK_PIN  
,convert(varchar(12),pc1.DivIFScd) DIVIDEND_BRANCH_NO  
,convert(numeric,case when pc1.DivBankCurr ='' then '0' else pc1.DivBankCurr  end ) DIVIDEND_ACC_CURRENCY  
,convert(numeric,pc1.DivAcctType) DIVIDEND_BANK_AC_TYPE  
,convert(numeric,'0') PURPOSE_ADDITIONAL_NAME  
,'' SETUP_DATE --pc5.SetupDate  SETUP_DATE  
,'' POA_START_DATE ---pc5.EffFormDate  POA_START_DATE  
,'' POA_END_DATE --- pc5.EffToDate  POA_END_DATE  
,'' POA_ENABLED  
,'' POA_TYPE  
,convert(numeric,pc1.LangCd  ) LANG_CODE  
,convert(varchar(15),pc1.PANGIR  ) ITPAN_CIRCLE  
,convert(varchar(25),pc2.PANGIR  )SECOND_HOLD_ITPAN  
,convert(varchar(25),pc3.PANGIR ) THIRD_HOLD_ITPAN  
,convert(varchar(50),pc1.FthName  ) FIRST_HOLD_FNAME  
,convert(numeric,'0') ADDITIONAL_PURPOSE_CODE  
,'' ADDITIONAL_HOLDER_NAME  
,'' ADDITIONAL_SETUP_DATE  
,'' FAX_INDEMNITY  
,(CASE WHEN ISNULL(CITRUS_USR.FN_ACCT_ENTP(DPAM_ID ,'ECN_FLAG'),'')='YES' THEN 'Y' ELSE 'N' END) EMAIL_FLAG
--,'' EMAIL_FLAG  
,convert(varchar(12),pc16.MOBILENUM  ) FIRST_HOLD_MOBILE  
,case when pc16.BOId  <> '' then 'Y' else 'N' end FIRST_SMS_FLAG  
,'' SMART_REMARKS  
,convert(varchar(25),pc1.PANGIR  ) FIRST_HOLD_PAN  
,POA_VER =(SELECT TOP 1 CASE WHEN DPPD_POA_TYPE='FULL' THEN '2' WHEN DPPD_POA_TYPE='PAYIN ONLY' THEN '1' ELSE '2' END  FROM DP_POA_DTLS WHERE DPPD_DPAM_ID=DPAM_ID AND DPPD_DELETED_IND=1)--convert(numeric,'0') POA_VER  
,'' FIRST_HOLD_UID  
,'' SECOND_HOLD_UID  
,'' THIRD_HOLD_UID  
,convert(varchar(1),pc1.AnnlRep  ) RGESS_FLAG  
,'' DIGI_ANNUAL  
,'' PSI_FLAG  
,'' RTA_FLAG  
,convert(varchar(1),pc1.Filler8  ) BSDA_FLAG  
,accp_value NEXT_AMC_DATE  
from dp_acct_mstr dpam with(nolock)  
left outer join CLIENT_DP_BRKG   with(nolock) on DPAM_ID = clidb_dpam_id and GETDATE() between clidb_eff_from_dt  and  ISNULL(clidb_eff_to_dt ,'dec 31 2100')  and clidb_deleted_ind = 1  
left outer join brokerage_mstr with(nolock) on brom_id = CLIDB_BROM_ID   
left outer join entity_relationship  with(nolock) on dpam_crn_no = entr_crn_no and DPAM_SBA_NO = entr_sba and entr_deleted_ind = 1 
and GETDATE() between ENTR_FROM_DT and  ISNULL(ENTR_TO_DT ,'dec 31 2100')   
left outer join entity_mstr sb with(nolock) on sb.entm_id = ENTR_DUMMY4  
left outer join entity_mstr br with(nolock) on br.entm_id = ENTR_BR  
left outer join ACCOUNT_PROPERTIES with(nolock) on ACCP_CLISBA_ID = DPAM_ID and ACCP_ACCPM_PROP_CD ='amc_dt' 
left outer join sub_ctgry_mstr with(nolock)  ON DPAM_subcm_CD  = SUBCM_CD    
, dps8_pc1 pc1 with(nolock)  
left outer join (select TMPBA_DP_BR,TMPBA_DP_BANK, MAX(TMPBA_DP_BANK_ADD1) TMPBA_DP_BANK_ADD1
,MAX(TMPBA_DP_BANK_ADD2) TMPBA_DP_BANK_ADD2
,MAX(TMPBA_DP_BANK_ADD3) TMPBA_DP_BANK_ADD3
,MAX(TMPBA_DP_BANK_CITY ) TMPBA_DP_BANK_CITY 
,MAX(TMPBA_DP_BANK_STATE ) TMPBA_DP_BANK_state
,MAX(TMPBA_DP_BANK_CNTRY ) TMPBA_DP_BANK_CNTRY 
,MAX(TMPBA_DP_BANK_ZIP) TMPBA_DP_BANK_ZIP
from  bank_addresses_dtls with(nolock) group by TMPBA_DP_BR,TMPBA_DP_BANK) bankaddr  on pc1.DivBankCd = bankaddr.TMPBA_DP_BANK  and pc1.DivIFScd = bankaddr.TMPBA_DP_BR  
left outer join dps8_pc2 pc2 with(nolock) on pc1.BOId = pc2.BOId  and pc2.TypeOfTrans in ('','1','2')  
left outer join dps8_pc3 pc3 with(nolock) on pc1.BOId = pc3.BOId  and pc3.TypeOfTrans in ('','1','2')  
left outer join dps8_pc4 pc4 with(nolock) on pc1.BOId = pc4.BOId  and pc4.TypeOfTrans in ('','1','2')  
--left outer join dps8_pc5 pc5 with(nolock) on pc1.BOId = pc5.BOId and pc5.TypeOfTrans in ('','1','2')  and pc5.holdernum=1
--left outer join poam  with(nolock) on poam.poam_master_id = pc5.MasterPOAId   
left outer join Nominee pc6 with(nolock) on pc1.BOId = pc6.BOId  and pc6.TypeOfTrans in ('','1','2') and case when pc6.DateOfBirth <>'' then isdate(RIGHT(pc6.DateOfBirth,4)  +'-'+ substring(pc6.DateOfBirth,3,2)+'-'+left(pc6.DateOfBirth ,2)) else '1' end =1 
left outer join dps8_pc7 pc7 with(nolock) on pc1.BOId = pc7.BOId  and pc7.TypeOfTrans in ('','1','2')  
left outer join dps8_pc8 pc8 with(nolock) on pc1.BOId = pc8.BOId  and pc8.TypeOfTrans in ('','1','2')  
left outer join dps8_pc12 pc12 with(nolock) on pc1.BOId = pc12.BOId  and pc12.TypeOfTrans in ('','1','2')  
left outer join dps8_pc16 pc16 with(nolock) on pc1.BOId = pc16.BOId  and pc16.TypeOfTrans in ('','1','2')  
left outer join dps8_pc18 pc18 with(nolock) on pc1.BOId = pc18.BOId  and pc18.TypeOfTrans in ('','1','2')  
,CLIENT_CTGRY_MSTR with(nolock)  
,ENTITY_TYPE_MSTR  with(nolock)  
,status_mstr  with(nolock)  
where dpam.DPAM_SBA_NO = pc1.BOId   
and DPAM_CLICM_CD = clicm_cd  
and DPAM_STAM_CD = stam_Cd  
and DPAM_ENTTM_CD  = enttm_Cd  
 and isnumeric(dpam_sba_no)=1   
  
  
  
 

  
  --select * FROM TBL_CLIENT_MASTER_FORDUMP_TEST WHERE CLIENT_CODE ='1203320006855798'
  --SELECT * FROM status_mstr  WHERE stam_Cd='ACTIVE'

GO
