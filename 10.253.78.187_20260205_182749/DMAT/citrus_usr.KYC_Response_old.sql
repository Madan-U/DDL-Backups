-- Object: VIEW citrus_usr.KYC_Response_old
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------






CREATE view [citrus_usr].[KYC_Response_old]

as

select KIT_NO,'' [COL NAME],'' [REJECTION REASON],'A' [STATUS],dpam_sba_no [CLIENT_CODE],'CDSL' ENTITY,citrus_usr.fn_ucc_accp(dpam_id,'BILL_START_DT','CDSL') [DATETIME]

from dp_acct_mstr,API_CLIENT_MASTER_SYNERGY_dp where len(DPAM_SBA_NO)=16 and DPAM_ACCT_NO<>DPAM_SBA_NO and DPAM_DELETED_IND=1

and DP_INTERNAL_REF=DPAM_ACCT_NO

GO
