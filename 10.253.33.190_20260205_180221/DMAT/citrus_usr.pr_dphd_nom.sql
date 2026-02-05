-- Object: PROCEDURE citrus_usr.pr_dphd_nom
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--pr_dphd_nom 'DEC 1 2009','JAN 12 2010'
--select * from dp_holder_dtls order by 1 desc
--select * from account_properties
--select * from dp_acct_mstr
CREATE PROC [citrus_usr].[pr_dphd_nom]
(
	 @pa_from_dt    VARCHAR(11)   
    ,@pa_to_dt      VARCHAR(11) 
)
AS
BEGIN

SELECT DPAM_SBA_NAME,
	   DPHD_DPAM_SBA_NO,
	   SUBCM_DESC	SUB_CATEGORY,
	   ACCP_VALUE	ACTIVATION_DT       
FROM dp_acct_mstr			dpam,
	 dp_holder_dtls			dphd,
	 account_properties		accp,
     sub_ctgry_mstr			subcm
WHERE dpam.dpam_sba_no = dphd.dphd_dpam_sba_no
AND dpam.dpam_id = accp.accp_clisba_id
AND dpam.dpam_subcm_cd = subcm.SUBCM_CD
AND dphd.dphd_nom_fname = ''
and convert(datetime,ACCP_VALUE,103) between convert(datetime,@pa_from_dt,103) and convert(datetime,@pa_to_dt,103)
--AND dphd.dphd_lst_upd_dt BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
AND accp.accp_accpm_prop_cd ='BILL_START_DT'
AND dpam.dpam_deleted_ind = 1
AND dphd.dphd_deleted_ind = 1
AND accp.accp_deleted_ind = 1
AND subcm.subcm_deleted_ind = 1

END

GO
