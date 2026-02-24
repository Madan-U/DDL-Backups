-- Object: PROCEDURE citrus_usr.Temp_pr_rpt_clientmakchk
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

-- exec Temp_pr_rpt_clientmakchk '4','APR 24 2008','APR 24 2009'
--CI
  
CREATE procedure [citrus_usr].[Temp_pr_rpt_clientmakchk]
(
@pa_excsm_id numeric,
@pa_from_dt datetime,
@pa_to_dt datetime
)  
as  
begin  
  
declare @l_dpm_id numeric   
  
select
@l_dpm_id = dpm_id 
from 
dp_mstr where default_dp = dpm_excsm_id and dpm_excsm_id = @pa_excsm_id and dpm_deleted_ind = 1  
  
select 
		dpam_acct_no [Application No],
		Dpam_sba_no [Client Id],
		dpam_sba_name [Client Name],
		Stam_desc [Status],
		dpam_created_by [Created By],
		dpam_lst_upd_by [Approved By],
		convert(varchar(11),dpam_created_dt,103) [Creation Date]  
from 
		dp_acct_mstr_mak , 
		status_mstr   

where 
			dpam_stam_Cd     = stam_cd  
			and   dpam_dpm_id      = @l_dpm_id  
			and   dpam_deleted_ind = 1  
			and   stam_deleted_ind = 1--16  
			and   dpam_lst_upd_dt  between @pa_from_dt and @pa_to_dt and dpam_stam_cd='CI'  

union  

select 
			dpam_acct_no [Application No],
			Dpam_sba_no [Client Id], 
			dpam_sba_name [Client Name], 
			Stam_desc [Status] , 
			dpam_created_by [Created By] , 
			dpam_lst_upd_by [Approved By],   
			--dpam_created_dt [Creation Date]  
			convert(varchar(11),dpam_created_dt,103) [Creation Date]  

from 
			dp_acct_mstr dpam , 
			status_mstr   
where 
			dpam_stam_Cd     = stam_cd  
			and   dpam_dpm_id      = @l_dpm_id  
			and   dpam_deleted_ind = 1  
			and   stam_deleted_ind = 1  
			and   not exists(select dpam_id from dp_acct_mstr_mak dpamm where dpamm.dpam_id = dpam.dpam_id and dpamm.dpam_deleted_ind = 1 and dpam.dpam_deleted_ind = 1)  
			and   dpam_lst_upd_dt  between @pa_from_dt and @pa_to_dt and dpam_stam_cd='CI'  
--select 61085+16  
  
end

GO
