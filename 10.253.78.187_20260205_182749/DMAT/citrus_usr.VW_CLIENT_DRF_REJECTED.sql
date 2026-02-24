-- Object: VIEW citrus_usr.VW_CLIENT_DRF_REJECTED
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE VIEW [citrus_usr].[VW_CLIENT_DRF_REJECTED]  
AS  
SELECT DISTINCT RIGHT(DPAM_SBA_NO,4) DPCode,  ClientID=DPAM_SBA_NO,
'MOSL DP Demat Request No. ' + demrm_slip_serial_no + ' is being rejected, having rejected date '+ convert(varchar,convert(datetime,demrm_lst_upd_dt),104) +            
' for your DP A/C No. ****'+ right(DPAM_SBA_NO,4) + '. Kindly contact your Branch.'  as message  ,  
demrm_lst_upd_dt REJECTEDDATETIME  
FROM  
demrm_mak,DP_ACCT_MSTR WHERE Demrm_DPAM_ID=DPAM_ID  
AND DPAM_DELETED_IND=1 AND demrm_deleted_ind IN (0) AND   
ISNULL(demrm_res_desc_intobj,'')<>''  
AND ISNULL(demrm_res_cd_intobj,'')<>''

GO
