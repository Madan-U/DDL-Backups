-- Object: PROCEDURE citrus_usr.Pr_get_eff_frm_dt
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE procedure [citrus_usr].[Pr_get_eff_frm_dt](@pa_dpam_id numeric,@pa_date datetime,@pa_errmsg Varchar(25) output   )
as
Select @pa_errmsg= case when min(ENTR_FROM_DT) > @pa_date then 'N' else 'Y' end
from entity_relationship,
dp_acct_mstr 
where dpam_id =@pa_dpam_id
and dpam_sba_no = entr_sba
and entr_deleted_ind = 1

GO
