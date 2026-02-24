-- Object: VIEW citrus_usr.VW_ISIN_MASTER_1812018
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


--select * from [VW_ISIN_MASTER]
CREATE view [citrus_usr].[VW_ISIN_MASTER_1812018]
as
select convert(numeric,'0')	ISIN_CODE
,isin_Cd	ISIN
,ISIN_COMP_NAME 	COMP_NAME
,ISIN_COMP_CD	ISIN_SHORT_NAME
,convert(numeric,'0')	ISSUER_ID
,''	ISSUER_NAME
,''	ISSUER_ADD1
,''	ISSUER_ADD2
,''	ISSUER_ADD3
,''	ISSUER_CITY
,''	ISSUER_STATE
,''	ISSUER_COUNTRY
,''	ISSUER_ZIP
,''	ISSUER_PHONE1
,''	ISSUER_PHONE2
,''	ISSUER_FAX
,''	ISSUER_EMAIL
,''	ISSUER_CON_NAME
,''	CON_DESG
,isin_adr1 	CON_ADD1
,isin_adr2 	CON_ADD2
,isin_adr3 	CON_ADD3
,isin_adrcity 	CON_CITY
,isin_adrstate 	CON_STATE
,isin_adrcountry 	CON_COUNTRY
,isin_adrzip 	CON_ZIP
,isin_TELE	CON_PHONE1
,''	CON_PHONE2
,isin_FAX	CON_FAX
,isin_email	CON_EMAIL
,convert(numeric,ISIN_REG_CD 	) RTA_ID
,entm_name1	RTA_NAME
,''	RTA_S_NAME
,''	RTA_T_NAME
,''	RTA_ADD1
,''	RTA_ADD2
,''	RTA_ADD3
,''	RTA_CITY
,''	RTA_STATE
,''	RTA_COUNTRY
,''	RTA_ZIP
,''	RTA_PHONE1
,''	RTA_PHONE2
,''	RTA_FAX
,''	RTA_EMAIL
,ISIN_COMP_NAME 	ISIN_SHARE_NAME
,''	ISIN_S_NAME
,''	ISIN_L_NAME
,isin_adr1 	ISIN_ADD1
,isin_adr2 	ISIN_ADD2
,isin_adr3 	ISIN_ADD3
,isin_adrcity 	ISIN_CITY
,isin_adrstate 	ISIN_STATE
,isin_adrcountry 	ISIN_COUNTRY
,isin_adrzip  	ISIN_ZIP
,isin_TELE 	ISIN_PHONE1
,''	ISIN_PHONE2
,isin_FAX 	ISIN_FAX
,isin_email 	ISIN_EMAIL
,ISIN_SEC_TYPE 	SECU_TYPE
,ISIN_SECURITY_TYPE_DESCRIPTION 	SECU_TYPE_DESC
,convert(numeric,'0')	MKT_TYPE
,''	MKT_TYPE_DESC
,''	ISIN_STATUS
,''	ISIN_STATUS_DESC
,''	HOLD_DEMAT_FLAG
,''	HOLD_REMAT_FLAG
,convert(datetime,''	)	EXPIRY_DATE
,convert(numeric,'0')	MARKET_LOT
,convert(numeric,'0')	CFI_CODE
,convert(numeric,'0')	PAR_VAL
,convert(numeric,'0')	PAIDUP_VAL
,convert(numeric,'0')	REDEMPTION_PRICE
,convert(datetime,'')	REDEMPTION_DATE
,convert(numeric,'0')	CLOSE_PRICE
,convert(datetime,''	) CLOSE_DATE
,convert(datetime,'')	ISSUE_DATE
,''	ON_GOING_CONV
,convert(datetime,''	)	CONV_DATE
,''	DSTNCT_RANGE_EXISTS
,convert(numeric,'0')	ISIN_DEC_CODE
,''	ISIN_DEC_CODE_DESC
,convert(numeric,'0')	ISIN_SUSP
,''	ISIN_SUSP_DESC
,convert(datetime,''	) MONEY_DUE_DATE
,''	ISIN_COMPLETE
,''	REMARKS
,''	INACTIVE_FLAG
,''	INACTIVE_REMARKS
,''	NSDL_COMP_NAME
,''	NSDL_SHORT_NAME
,''	SHARE_REGIS_NAME
,convert(numeric,'0')	SEQ_NO
,''	VANISHING_FLAG
,convert(numeric,'0')	SHARE_REGIS_CODE
from ISIN_MSTR with(nolock)
left outer join entity_mstr on ENTM_SHORT_NAME ='rta_'+CONVERT(varchar,ISIN_REG_CD )
where ISNUMERIC(ISIN_REG_CD)=1
and ENTM_ENTTM_CD ='rta'

GO
