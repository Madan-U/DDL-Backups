-- Object: VIEW citrus_usr.v_IPO_KYC
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


/*        
CREATED BY : SIVA KUMAR        
CREATED ON : OCT 26 2015      
*/        
--select cm_micr,cm_bankbranchno,* from Client_master with(Nolock) where cm_cd='1203320000451554'        
        
--select cb_nationality,* from Client_Backoffice with(Nolock) where cb_cmcd='1203320000451554'        
        
--select * from Beneficiary_occupation with(Nolock) where bo_code='S'        
--select * from Clientsub_master with(Nolock) where cs_code='01' AND cs_Module = 'CS11'        
--select * from dbo.Bank_master AS bm with(Nolock) where bk_micr='000SBI000'        
--select * from Bankaccount_type with(nolock) where ba_code='10'        
        
--select * from sysobjects where name like '%Bank%' and xtype='U'        
CREATE VIEW [citrus_usr].[v_IPO_KYC]        
AS        
SELECT DISTINCT         
cm.cm_cd, cm.cm_name, cm.cm_middlename, cm.cm_lastname, cm.cm_title, cm.cm_suffix, cm.cm_add1, cm.cm_add2, cm.cm_add3, cm.cm_city,        
cm.cm_state, cm.cm_country, cm.cm_pin, cm.cm_phoneindicator, cm.cm_tele1, cm.cm_phoneindicator2, cm.cm_tele2, cm.cm_tele3, cm.cm_fax,        
cm.cm_mobile, cm.cm_itcircle, cm.cm_email, cm.cm_sech_name, cm.cm_thih_name, cm.cm_dateofmaturity, cm.cm_dpintrefno,        
--CASE WHEN cm.cm_dateofbirth='00010101' THEN NULL else CONVERT(char(15),cast(cm.cm_dateofbirth AS datetime),106) END AS cm_dateofbirth ,        
CASE WHEN (cm.cm_dateofbirth='010101' OR cm.cm_dateofbirth='') THEN NULL else         
(convert(char(15), cast((substring(cm_dateofbirth, 1, 2) + '/' + substring(cm_dateofbirth, 3, 2) + '/' + substring(cm_dateofbirth, 5, 2)) as datetime),106))        
END AS cm_dateofbirth ,        
cm.cm_occupation, cm.cm_acctype, cm.cm_active, cm.cm_clienttype, cm.cm_confirmationwaived, cm.cm_securitycode, cm.cm_rbirefno,        
cm.cm_rbiappdate, cm.cm_sebiregno, cm.cm_taxdeduction, cm.cm_ccid, cm.cm_cmid, cm.cm_stockexchange, cm.cm_tradingid,        
cm.cm_bostatementcycle, cm.cm_micr, cm.cm_bankname, cm.cm_bankbranchno, cm.cm_bankactno, cm.cm_bankccy, cm.cm_divbankcode,        
cm.cm_divbranchno, cm.cm_divbankacno, cm.cm_divbankccy, cm.cm_poaid, cm.cm_poaname, cm.cm_pwd, cm.cm_opendate,        
cm.cm_acc_closuredate, cm.cm_brcode, cm.cm_brboffcode, cm.cm_groupcd, cm.cm_familycd, cm.cm_chgsscheme, cm.cm_billcycle,        
cm.cm_statements, cm.cm_billflag, cm.cm_billcode, cm.cm_collectioncode, cm.cm_allowcredit, cm.cm_upfront, cm.cm_lastbill, cm.cm_keepsettlement,        
cm.cm_fre_trx, cm.cm_fre_hold, cm.cm_fre_bill, cm.cm_blsavingcd, cm.cm_amtmntdt, cm.cm_updatebal, cm.cm_schedule, cm.cm_openingbal,        
cm.cm_freezedt, cm.mkrdt, cm.mkrid, cm.cm_freezeyn, cm.cm_freezereason, cm.cm_productcd, cm.mkrtm, cm.cm_remisser, cm.cm_poaforpayin,        
cm.cm_poaregdate, cb.cb_cmcd, cb.cb_add1, cb.cb_add2, cb.cb_add3, cb.cb_city, cb.cb_state, cb.cb_country, cb.cb_pin, cb.cb_tele1, cb.cb_tele2,        
cb.cb_tele3, cb.cb_fax, cb.cb_instrno, cb.cb_fathername, cb.cb_panno, cb.cb_usertext1, cb.cb_usertext2, cb.cb_userfield1, cb.cb_userfield2,        
cb.cb_userfield3, cb.cb_sechmiddle, cb.cb_sechlastname, cb.cb_sechtitle, cb.cb_sechsuffix, cb.cb_sechfathername, cb.cb_sechpanno,        
cb.cb_sechitcircle, cb.cb_thirdmiddle, cb.cb_thirdlastname, cb.cb_thirdtitle, cb.cb_thirdsuffix, cb.cb_thirdfathername, cb.cb_thirdpanno,        
cb.cb_thirditcircle, cb.cb_sexcode, cb.cb_annualincome, cb.cb_legalstatus, cb.cb_feetype, cb.cb_staff, cb.cb_staffcode, cb.cb_bosettlementplanflag,        
cb.cb_lifestyle, cb.cb_geographical, cb.cb_degree, cb.cb_language, cb.cb_voicemail, cb.cb_smartcardreq, cb.cb_smartcardno, cb.cb_smartcardpin,        
cb.cb_ecs, cb.cb_electronicconfirm, cb.cb_dividendcurrency, cb.cb_setupdate, cb.cb_operateaccount, cb.cb_gpaflag, cb.cb_effectivefrom,        
cb.cb_effectiveto, cb.cb_poauserfield1, cb.cb_poauserfield2, cb.cb_cacharfield, cb.cb_bankbranch, cb.cb_bankadd1, cb.cb_bankadd2, cb.cb_bankadd3,        
cb.cb_bankcity, cb.cb_bankstate, cb.cb_bankcountry, cb.cb_bankpin, cb.cb_nominee,        
CASE WHEN cb.cb_nominee_dob ='' THEN NULL else        
 ((substring(cb_nominee_dob, 1, 2) + '/' + substring(cb_nominee_dob, 3, 2) + '/' + substring(cb_nominee_dob, 5, 4))) END AS cb_nominee_dob ,        
cb.cb_nomineeadd1, cb.cb_nomineeadd2,        
cb.cb_nomineeadd3, cb.cb_nomineecity, cb.cb_nomineestate, cb.cb_nomineecountry, cb.cb_nomineepin, cb.cb_chequecash, cb.cb_chqno,        
cb.cb_recvdate, cb.cb_rupees, cb.cb_drawn, cb.cb_batchno, cb.cb_fadd1, cb.cb_fadd2, cb.cb_fadd3, cb.cb_fcity, cb.cb_fstate, cb.cb_fcountry,        
cb.cb_fpin, cb.cb_ftele, cb.cb_ffax, cb.cb_last_billdate, cb.cb_last_trxdate, cb.cb_last_holddate, cb.mkrdt AS Expr1, cb.mkrid AS Expr2,        
cb.cb_nationality, cb.cb_poamiddle, cb.cb_poalastname, cb.cb_poatitle, cb.cb_poasuffix, cb.cb_poafather, cb.cb_poaadd1, cb.cb_poaadd2,        
cb.cb_poaadd3, cb.cb_poacity, cb.cb_poastate, cb.cb_poacountry, '' as cb_poapin , cb.cb_poateleindicator, cb.cb_poatele1, cb.cb_poateleindicator2,        
cb.cb_poatele2, cb.cb_poatele3,'' as cb_poafax,'' as cb_poapanno, cb.cb_poaitcircle, cb.cb_poaemail, cb.cb_formno, cb.cb_remarks,         
--bo.bo_code, bo.description,         
bo.code AS bo_code, bo.description,         
--csm.cs_code, csm.cs_desc, csm.cs_module,         
csm.code AS cs_code, csm.description AS CS_DESC, cs_module = '',         
bm.bk_id, bm.bk_micr, bm.bk_branch, bm.bk_name, bm.bk_add1, bm.bk_add2,        
bm.bk_add3, bm.bk_city, bm.bk_state, bm.bk_country, bm.bk_pin, bm.bk_tele1, bm.bk_tele2, bm.bk_fax, bm.bk_email, bm.bk_conname,        
bm.bk_condesg,         
--bt.ba_code, bt.ba_description        
bt.code AS ba_code, bt.description AS ba_description        
FROM SYNERGY_Client_master AS cm with(Nolock) LEFT OUTER JOIN        
 Client_Backoffice AS cb with(Nolock) ON cm.cm_cd = cb.cb_cmcd LEFT OUTER JOIN        
--dbo.Beneficiary_occupation AS bo with(Nolock) ON cm.cm_occupation = bo.bo_code LEFT OUTER JOIN        
 Type_master AS bo with(Nolock) ON cm.cm_occupation = bo.code and bo.[type] = 'OCCUPATION' LEFT OUTER JOIN        
--dbo.Clientsub_master AS csm with(Nolock) ON cb.cb_nationality = csm.cs_code        
 Type_master AS csm with(Nolock) ON cb.cb_nationality = csm.code and csm.[type] = 'NATIONALITY'        
--AND csm.cs_Module = 'CS11'        
LEFT OUTER JOIN        
--dbo.Bank_master AS bm with(Nolock) ON cm.cm_micr = bm.bk_micr LEFT OUTER JOIN        
      
 Bank_master AS bm with(Nolock) ON cm.cm_micr = bm.bk_micr and cm.cm_bankbranchno = bm.bk_branch      
LEFT OUTER JOIN        
--dbo.Bank_master AS bm with(Nolock) ON cm.cm_bankbranchno = bm.bk_branch LEFT OUTER JOIN        
      
--dbo.Bankaccount_type AS bt with(Nolock) ON cm.cm_bankbranchno = bt.ba_code        
 Type_master AS bt with(Nolock) ON cm.cm_bankbranchno = bt.code and bt.[type] = 'BANK_ACC_TYPE'

GO
