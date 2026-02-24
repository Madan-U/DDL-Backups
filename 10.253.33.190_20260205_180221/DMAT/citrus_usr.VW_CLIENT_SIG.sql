-- Object: VIEW citrus_usr.VW_CLIENT_SIG
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------





CREATE VIEW [citrus_usr].[VW_CLIENT_SIG]
as
SELECT DPAM_SBA_NAME NAME , DPAM_SBA_NO BOID ,ACCD_BINARY_IMAGE BINARYSIG ,isnull(dpam_bbo_code,'') PARTY_CODE 
,isnull(entp_value,'') PANNO,
DPHD_SH_FNAME
,DPHD_SH_MNAME
,DPHD_SH_LNAME
,DPHD_SH_FTHNAME
,case when DPHD_SH_DOB='1900-01-01 00:00:00.000' then '' else DPHD_SH_DOB end DPHD_SH_DOB
,DPHD_SH_PAN_NO
,DPHD_SH_GENDER
,DPHD_TH_FNAME
,DPHD_TH_MNAME
,DPHD_TH_LNAME
,DPHD_TH_FTHNAME
,case when DPHD_TH_DOB='1900-01-01 00:00:00.000' then '' else DPHD_TH_DOB end DPHD_TH_DOB
,DPHD_TH_PAN_NO
,DPHD_TH_GENDER
,dpam_stam_cd
,BROM_DESC scheme 
FROM DP_ACCT_MSTR left outer join client_dp_brkg on clidb_dpam_id = dpam_id and clidb_deleted_ind = 1
left outer join brokerage_mstr on clidb_brom_id = brom_id and brom_deleted_ind = 1
 left outer join ACCOUNT_PROPERTIES
on ACCP_CLISBA_ID=DPAM_ID AND ACCP_DELETED_IND=1 AND ACCP_ACCPM_PROP_CD='BBO_CODE'
, ACCOUNT_DOCUMENTS ,DP_HOLDER_DTLS,ENTITY_PROPERTIES
WHERE DPAM_ID=ACCD_CLISBA_ID AND DPAM_DELETED_IND=1 AND DPHD_DPAM_ID=DPAM_ID AND DPHD_DELETED_IND=1
AND ACCD_DELETED_IND=1 AND ACCD_ACCDOCM_DOC_ID=12
AND DPAM_CRN_NO=ENTP_ENT_ID AND ENTP_DELETED_IND=1  and ENTP_ENTPM_CD='PAN_GIR_NO'
and GETDATE() between ISNULL(clidb_eff_from_dt,'jan 01 1900') and  ISNULL(clidb_eff_to_dt,'dec 31 2100')

GO
