-- Object: VIEW citrus_usr.vw_drfdata_maker
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE view [citrus_usr].[vw_drfdata_maker]
as

select demrm_slip_serial_no [drf no],
case when demrm_deleted_ind = 0 and (isnull(demrm_res_cd_intobj,'') <> '' or isnull(demrm_res_cd_compobj,'') <> '') then 'REJECTED'	 
	 when demrm_deleted_ind = 0 and (isnull(demrm_res_cd_intobj,'') = '' or isnull(demrm_res_cd_compobj,'') = '') then 'MAKER ENTERED'  
	 when demrm_deleted_ind = 1 then 'APROVED'
	 ELSE '' END AS [status]
from demrm_mak 
where demrm_deleted_ind in (0,1)

GO
