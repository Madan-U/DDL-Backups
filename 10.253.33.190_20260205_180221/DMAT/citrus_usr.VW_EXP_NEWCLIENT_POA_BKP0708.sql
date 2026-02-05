-- Object: VIEW citrus_usr.VW_EXP_NEWCLIENT_POA_BKP0708
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------







CREATE view [citrus_usr].[VW_EXP_NEWCLIENT_POA_BKP0708]
as
select dpam_acct_no RECEIPT_CODE
,null BENEF_ACCNO
,SetupDate SLIP_DATE
,pc1.boid         CLIENT_CODE
,'5' PURPOSE_CODE
,[POARegNum] POA_ID
,CONVERT(DATETIME,SUBSTRING(SetupDate,1,2) + '/' + SUBSTRING(SetupDate,3,2) + '/' + SUBSTRING(SetupDate,5,4))    SETUP_DATE
,'Y' OPERATE_AC
,[GPABPAFlg]            GPA_BPA_FLAG
,CONVERT(DATETIME,SUBSTRING(EffFormDate,1,2) + '/' + SUBSTRING(EffFormDate,3,2) + '/' + SUBSTRING(EffFormDate,5,4))      FROM_DATE
,CASE WHEN [EffToDate]='' THEN '2049-01-01 00:00:00.000' ELSE [EffToDate] END       TO_DATE
,''   REMARKS
,'I'  STAGE
,'A'  STATUS
,'' TRXN_TYPE
,dpam_sba_no CDSL_CLIENT_CODE
,[DPAM_BBO_CODE] NISE_PARTY_CODE
from dp_acct_mstr , dps8_pc1 pc1
left outer join dps8_pc5 pc5 on pc1.boid = pc5.boid 
where dpam_sba_no = pc1.boid --AND SetupDate='06072015'
--and convert(datetime,left(pc1.AcctCreatDt ,2)+'/'+substring(pc1.AcctCreatDt ,3,2)+'/'+right(pc1.acctcreatdt,4),103) = convert(datetime,convert(varchar(11),getdate()-2,103),103)

GO
