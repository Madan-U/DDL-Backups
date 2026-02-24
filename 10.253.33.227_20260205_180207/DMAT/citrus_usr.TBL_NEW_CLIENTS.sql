-- Object: VIEW citrus_usr.TBL_NEW_CLIENTS
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

create view TBL_NEW_CLIENTS
as
select pc1.boid cm_cd
,	pc1.name cm_name
,	'' cm_blsavingcd
,	pc1.DPIntRefNum cm_dpintrefno
,	pc1.AcctCreatDt cm_opendate
,	DPAM_SBA_NAME  cm_poaname
,	'' cm_poaforpayin
,	pc5.SetupDate  cm_poaregdate
from dps8_pc1 pc1 with(nolock )left outer join dps8_pc5 pc5 with(nolock ) on 
pc1.boid = pc5.boid 
left outer join dp_acct_mstr dpam with(nolock ) on 
DPAM_SBA_NO = pc5.MasterPOAId

GO
