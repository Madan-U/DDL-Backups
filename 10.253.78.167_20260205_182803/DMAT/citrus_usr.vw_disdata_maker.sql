-- Object: VIEW citrus_usr.vw_disdata_maker
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE view [citrus_usr].[vw_disdata_maker]
as

select dptdc_slip_no [dis no],
case when dptdc_deleted_ind = 0 and isnull(dptdc_res_cd,'') <> '' then 'REJECTED'
	 when dptdc_deleted_ind = -1 and isnull(dptdc_res_cd,'') = '' then 'MAKER ENTERED (INSTRUCTION WITH HIGH VALUE OR DORMANT)'
     when dptdc_deleted_ind = 0 and isnull(dptdc_res_cd,'') = '' and isnull(dptdc_mid_chk,'')='' then 'MAKER ENTERED (INSTRUCTION WITHOUT HIGH VALUE OR DORMANT)' 
	 when dptdc_deleted_ind = 0 and isnull(dptdc_res_cd,'') = '' and isnull(dptdc_mid_chk,'')<>'' then '1ST CHECKER DONE' 
	 when dptdc_deleted_ind =1 then 'APPROVED'
     ELSE '' END AS [status]
from dptdc_mak 
where dptdc_deleted_ind in (0,1,-1)

GO
