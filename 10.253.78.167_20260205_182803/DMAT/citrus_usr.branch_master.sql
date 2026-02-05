-- Object: VIEW citrus_usr.branch_master
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--SELECT * FROM branch_master
CREATE VIEW [citrus_usr].[branch_master]
AS
select REPLACE(REPLACE(entm_short_name,'_BA',''),'_BR','') bm_branchcd
,entm_name1 + ' ' + isnull(entm_name2,'') + ' ' + isnull(entm_name3,'') bm_branchname
,''  bm_contact
,case when citrus_usr.fn_addr_value(entm_id,'OFF_ADR1') <> '' then citrus_usr.fn_splitval(citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),1) else citrus_usr.fn_splitval(citrus_usr.fn_addr_value(entm_id,'COR_ADR1'),1)  end  bm_add1
,case when citrus_usr.fn_addr_value(entm_id,'OFF_ADR1') <> '' then citrus_usr.fn_splitval(citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),2) else citrus_usr.fn_splitval(citrus_usr.fn_addr_value(entm_id,'COR_ADR1'),2)  end  bm_add2
,case when citrus_usr.fn_addr_value(entm_id,'OFF_ADR1') <> '' then citrus_usr.fn_splitval(citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),3) else citrus_usr.fn_splitval(citrus_usr.fn_addr_value(entm_id,'COR_ADR1'),3)  end  bm_add3
,case when citrus_usr.fn_addr_value(entm_id,'OFF_ADR1') <> '' then citrus_usr.fn_splitval(citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),4) else citrus_usr.fn_splitval(citrus_usr.fn_addr_value(entm_id,'COR_ADR1'),4)  end  bm_city
,case when citrus_usr.fn_addr_value(entm_id,'OFF_ADR1') <> '' then citrus_usr.fn_splitval(citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),7) else citrus_usr.fn_splitval(citrus_usr.fn_addr_value(entm_id,'COR_ADR1'),7)  end  bm_pin
,ISNULL(citrus_usr.fn_conc_value(entm_id,'OFF_PH1'),'') bm_phone
,ISNULL(citrus_usr.fn_conc_value(entm_id,'FAX1'),'')  bm_fax
,ISNULL(citrus_usr.fn_conc_value(entm_id,'EMAIL1'),'') bm_email
,'' bm_allow
,'' bm_batchno
,'' bm_ip_add
,'' bm_dialup
,'' bm_server
,'' bm_database
,'' bm_dbo
,LOGN_NAME bm_user
,'' bm_pwd
,'' bm_workarea
,LOGN_CREATED_BY mkrid
,LOGN_CREATED_DT mkrdt
,'' bm_flag
,'' bm_type
,'' bm_actdt
,'' bm_deactdt
,'' bm_ContactPerDesg
,'' bm_ContactPerPaNNo
,'' bm_TrainPerName
,'' bm_TrainingDet
,'' bm_FrcName
,'' bm_FrcRegNo
,'' bm_FrcRegAuth
,'' bm_FrcDirector
,'' bm_FrcDirPan
,'' bm_ServiceOffer
,'' bm_remarks
FROM ENTITY_MSTR ,LOGIN_NAMES
WHERE ENTM_ENTTM_cD IN ('br','BA')
AND LOGN_ENT_ID = ENTM_ID

GO
