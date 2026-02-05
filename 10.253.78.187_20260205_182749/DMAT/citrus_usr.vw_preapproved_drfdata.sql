-- Object: VIEW citrus_usr.vw_preapproved_drfdata
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE view [citrus_usr].[vw_preapproved_drfdata]
as

select req_slip_no [drf no],
case when deleted_ind = 1 then 'Approved'
	 when deleted_ind = 0 then 'UnApproved'
	 when deleted_ind = 3 then 'Rejected' else '' end [status]
from dis_req_dtls_mak
where slip_yn = 'D'
and isnull(req_slip_no,'') <> ''
--order by req_slip_no

GO
