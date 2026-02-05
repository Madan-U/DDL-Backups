-- Object: VIEW citrus_usr.CLIENT_BACKOFFICE
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------



CREATE view [citrus_usr].[CLIENT_BACKOFFICE]
as
select pc1.boid	cb_cmcd
,	pc1.Addr1  cb_add1
,	pc1.Addr2  cb_add2
,	pc1.Addr3  cb_add3
,	pc1.City cb_city
,	pc1.state cb_state
,	pc1.Country cb_country
,	pc1.PinCode  cb_pin
,	pc1.PriPhNum  cb_tele1
,	pc1.AltPhNum   cb_tele2
,	'' cb_tele3
,	pc1.fax cb_fax
,	'' cb_instrno
,	pc1.FthName  cb_fathername
,	pc1.pangir cb_panno
,	'' cb_usertext1
,	'' cb_usertext2
,	0 cb_userfield1
,	0 cb_userfield2
,	0 cb_userfield3
,	pc2.MiddleName  cb_sechmiddle
,	pc2.SearchName   cb_sechlastname
,	pc2.Title  cb_sechtitle
,	pc2.Suffix    cb_sechsuffix
,	pc2.FthName  cb_sechfathername
,	pc2.PANGIR  cb_sechpanno
,	pc2.ITCircle   cb_sechitcircle
,	pc3.MiddleName   cb_thirdmiddle
,	pc3.SearchName  cb_thirdlastname
,	 pc3.Title  cb_thirdtitle
,	 pc3.Suffix  	cb_thirdsuffix
,	 pc3.FthName  	cb_thirdfathername
,	 pc3.PANGIR  	cb_thirdpanno
,	 pc3.ITCircle  	cb_thirditcircle
,	pc1.SexCd  cb_sexcode
,	cast((CASE WHEN pc1.AnnIncomeCd=''THEN 0 ELSE pc1.AnnIncomeCd END ) as numeric)  cb_annualincome
,	'' cb_legalstatus
,	'' cb_feetype
,	pc1.Staff  cb_staff
,	pc1.StaffCd  cb_staffcode
,	pc1.BOSettPlanFlg  cb_bosettlementplanflag
,	'' cb_lifestyle
,	pc1.GeogCd  cb_geographical
,	pc1.Edu  cb_degree
,	pc1.LangCd  cb_language
,	'' cb_voicemail
,	'' cb_smartcardreq
,	'' cb_smartcardno
,	0  cb_smartcardpin
,	pc1.ECS   cb_ecs
,	pc1.EletConf  cb_electronicconfirm
,	cast((CASE WHEN  pc1.DivBankCurr =''THEN 0 ELSE  pc1.DivBankCurr     END ) as numeric)   cb_dividendcurrency
,	pc5.SetupDate   cb_setupdate
,	'' cb_operateaccount
,	pc5.GPABPAFlg  cb_gpaflag
,	pc5.EffFormDate  cb_effectivefrom
,	pc5.EffToDate  cb_effectiveto
,	0 cb_poauserfield1
,	0 cb_poauserfield2
,	'' cb_cacharfield
,	'' cb_bankbranch
,	'' cb_bankadd1
,	'' cb_bankadd2
,	'' cb_bankadd3
,	'' cb_bankcity
,	'' cb_bankstate
,	'' cb_bankcountry
,   '' 	cb_bankpin
,	pc6.Name  cb_nominee
,	pc6.DateOfBirth  cb_nominee_dob
,	pc6.Addr1  cb_nomineeadd1
,	pc6.Addr2  cb_nomineeadd2
,	pc6.Addr3   cb_nomineeadd3
,	pc6.city   cb_nomineecity
,	pc6.state   cb_nomineestate
,	pc6.Country    cb_nomineecountry
,	pc6.PinCode   cb_nomineepin
,	'' cb_chequecash
,	'' cb_chqno
,	'' cb_recvdate
,	'' cb_rupees
,	'' cb_drawn
,	0 cb_batchno
,	''	cb_fadd1
,	''	cb_fadd2
,	''	cb_fadd3
,	''	cb_fcity
,	''	cb_fstate
,	''	cb_fcountry
,	''	cb_fpin
,	''	cb_ftele
,	''	cb_ffax
,	''	cb_last_billdate
,	''	cb_last_trxdate
,	''	cb_last_holddate
,	''	mkrdt
,	''	mkrid
,	''	cb_nationality
,	''	cb_poamiddle
,	''	cb_poalastname
,	''	cb_poatitle
,	''	cb_poasuffix
,	''	cb_poafather
,	''	cb_poaadd1
,	''	cb_poaadd2
,	''	cb_poaadd3
,	''	cb_poacity
,	''	cb_poastate
,	''	cb_poacountry
,	''	cb_KRAStatus1sthld
,	''	cb_poateleindicator
,	''	cb_poatele1
,	''	cb_poateleindicator2
,	''	cb_poatele2
,	''	cb_poatele3
,	''	cb_KRAStatus2ndhld
,	''	cb_KRAStatus3rdhld
,	''	cb_poaitcircle
,	''	cb_poaemail
,	''	cb_formno
,	''	cb_remarks
from dps8_pc1 pc1 left outer join dps8_pc2 pc2 on pc1.BOId = pc2.BOId 
left outer join dps8_pc3 pc3 on pc1.BOId = pc3.BOId 
left outer join dps8_pc5 pc5 on pc1.BOId = pc5.BOId 
left outer join dps8_pc6 pc6 on pc1.BOId = pc6.BOId 
where pc1.TypeOfTrans not in ('3')
and isnull(pc2.TypeOfTrans ,'')not in ('3')
and isnull(pc3.TypeOfTrans ,'') not in ('3')
and isnull(pc5.TypeOfTrans ,'') not in ('3')
and isnull(pc6.TypeOfTrans ,'') not in ('3')

GO
