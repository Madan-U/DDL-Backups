-- Object: VIEW citrus_usr.aq
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE view [citrus_usr].[aq]
as
select clim.clim_Crn_no , clim.clim_short_name , clim.clim_lst_upd_dt
from client_mstr clim 
     left outer join 
     clim_hst climh on clim.clim_crn_no = climh.clim_crn_no  and climh.clim_lst_upd_dt = isnull((select max(hst.clim_lst_upd_dt) from clim_hst hst ),'')

GO
