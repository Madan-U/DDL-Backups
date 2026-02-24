-- Object: VIEW citrus_usr.KYC_Response
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------




 
 CREATE view [citrus_usr].[KYC_Response]
as

select KIT_NO,'' [COL NAME],'' [REJECTION REASON],'A' [STATUS],ISNULL(dpam_sba_no,'') [CLIENT_CODE],(CASE WHEN dpam_sba_no = DPAM_ACCT_NO THEN 'MKT' ELSE 'CDSL' END) ENTITY,
--CONVERT(VARCHAR(11),citrus_usr.fn_ucc_accp(dpam_id,'BILL_START_DT','CDSL'),120) [DATETIME]
CASE WHEN dpam_sba_no = DPAM_ACCT_NO THEN CONVERT(VARCHAR(10),dpam_created_DT,126) ELSE  CONVERT(VARCHAR(10),citrus_usr.fn_ucc_accp(dpam_id,'BILL_START_DT','CDSL'),126) END [DATETIME]

from (SELECT DISTINCT KIT_NO,DP_INTERNAL_REF FROM API_CLIENT_MASTER_SYNERGY_dp WHERE DP_INTERNAL_REF<>'' )DP
LEFT OUTER JOIN 
dp_acct_mstr D
 ON len(DPAM_SBA_NO)=16 and DPAM_ACCT_NO<>DPAM_SBA_NO and DPAM_DELETED_IND=1
and DP_INTERNAL_REF=DPAM_ACCT_NO

GO
