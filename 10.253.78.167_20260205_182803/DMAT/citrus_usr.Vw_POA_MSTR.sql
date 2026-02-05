-- Object: VIEW citrus_usr.Vw_POA_MSTR
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE view Vw_POA_MSTR
as

SELECT DISTINCT POAM_MASTER_ID DPAM_SBA_NO,'0' dpam_id,'0' dpam_dpm_id,'' dpam_stam_cd,isnull(poam_name1,'') dpam_sba_name,'0' dpam_crn_no FROM POA_MSTR WHERE POAM_DELETED_IND=1
UNION ALL
SELECT DISTINCT DPAM_SBA_NO,dpam_id,dpam_dpm_id,dpam_stam_cd,dpam_sba_name,dpam_crn_no FROM DP_ACCT_MSTR WHERE DPAM_DELETED_IND=1 AND LEFT(DPAM_SBA_NO,1)='2'
AND NOT EXISTS (SELECT DISTINCT POAM_MASTER_ID FROM POA_MSTR WHERE POAM_DELETED_IND=1 AND POAM_MASTER_ID=DPAM_SBA_NO)

GO
