-- Object: PROCEDURE citrus_usr.pr_rpt_clientmakchk
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--Select * from CLOSURE_ACCT_CDSL 
 ---4 Sep 14 2008 Sep 14 2009  
--exec pr_rpt_clientmakchk '4','Sep 13 2009','Sep 15 2009'  
--exec pr_rpt_clientmakchk '4','dec 01 2008','nov 19 2009'  
CREATE procedure [citrus_usr].[pr_rpt_clientmakchk]  
(  
@pa_excsm_id numeric,  
@pa_from_dt datetime,  
@pa_to_dt datetime  
)  
as  
begin  
  
declare @l_dpm_id numeric   
  
select @l_dpm_id = dpm_id from dp_mstr where default_dp = dpm_excsm_id and dpm_excsm_id = @pa_excsm_id and dpm_deleted_ind = 1  
  
select dpamm.dpam_acct_no [Application No], dpam.Dpam_sba_no [Client Id], dpamm.dpam_sba_name [Client Name], case when dpam.dpam_acct_no=dpam.dpam_sba_no then Stam_desc  else 'ACTIVE' END [Status], clim_created_by [Created By] , clim_lst_upd_by [Approved By]  
, convert(varchar(11),dpamm.dpam_created_dt,103) [Creation Date]  
from dp_acct_mstr_mak dpamm,dp_acct_mstr dpam,client_mstr_mak,status_mstr   
where dpamm.dpam_stam_Cd     = stam_cd  
and   dpamm.dpam_dpm_id      = @l_dpm_id  
and   dpamm.dpam_deleted_ind = 1 
and   dpamm.dpam_id=dpam.dpam_id 
and   dpamm.dpam_crn_no=clim_crn_no
and   dpam.dpam_deleted_ind=1
and   stam_deleted_ind = 1--16  
and   clim_deleted_ind = 1
 and   dpamm.dpam_lst_upd_dt BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'      
--and   dpam_lst_upd_dt  between @pa_from_dt and @pa_to_dt  
and   not exists(select fre_DPAM_ID from freeze_unfreeze_dtls where fre_level = 'A' and fre_DPAM_ID = dpamm.dpam_id )   
and   not exists(select CLSR_BO_ID from CLOSURE_ACCT_CDSL where CLSR_BO_ID = dpamm.dpam_sba_no )   
union  
select dpam_acct_no [Application No], Dpam_sba_no [Client Id], dpam_sba_name [Client Name], Stam_desc [Status] , dpam_created_by [Created By] , dpam_lst_upd_by [Approved By],   
--dpam_created_dt [Creation Date]  
 convert(varchar(11),dpam_created_dt,103) [Creation Date]  
from dp_acct_mstr dpam , status_mstr   
where dpam_stam_Cd     = stam_cd  
and   dpam_dpm_id      = @l_dpm_id  
and   dpam_deleted_ind = 1  
and   stam_deleted_ind = 1  
and   not exists(select dpam_id from dp_acct_mstr_mak dpamm where dpamm.dpam_id = dpam.dpam_id and dpamm.dpam_deleted_ind = 1 and dpam.dpam_deleted_ind = 1)  
and   dpam_lst_upd_dt BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'     
--and   dpam_lst_upd_dt  between @pa_from_dt and @pa_to_dt   
and dpam_stam_cd='ACTIVE'  
and   not exists(select fre_DPAM_ID from freeze_unfreeze_dtls where fre_level = 'A' and fre_DPAM_ID = dpam_id )   
and   not exists(select CLSR_BO_ID from CLOSURE_ACCT_CDSL where CLSR_BO_ID = dpam_sba_no )   
union  
select dpam_acct_no [Application No], Dpam_sba_no [Client Id], dpam_sba_name [Client Name], 'FREEZE' [Status] , dpam_created_by [Created By] , dpam_lst_upd_by [Approved By],   
--dpam_created_dt [Creation Date]  
 convert(varchar(11),dpam_created_dt,103) [Creation Date]  
from dp_acct_mstr dpam , status_mstr   
where dpam_stam_Cd     = stam_cd  
and   dpam_dpm_id      = @l_dpm_id  
and   dpam_deleted_ind = 1  
and   stam_deleted_ind = 1  
and   not exists(select dpam_id from dp_acct_mstr_mak dpamm where dpamm.dpam_id = dpam.dpam_id and dpamm.dpam_deleted_ind = 1 and dpam.dpam_deleted_ind = 1)  
--and   dpam_lst_upd_dt  between @pa_from_dt and @pa_to_dt   
--and   dpam_lst_upd_dt BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'     
and   exists(select fre_DPAM_ID from freeze_unfreeze_dtls where fre_level = 'A' and fre_DPAM_ID = dpam_id and fre_lst_upd_dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59')   
and   not exists(select CLSR_BO_ID from CLOSURE_ACCT_CDSL where CLSR_BO_ID = dpam_sba_no )   
union  
select dpam_acct_no [Application No], Dpam_sba_no [Client Id], dpam_sba_name [Client Name], 'CLOSED' [Status] , dpam_created_by [Created By] , dpam_lst_upd_by [Approved By],   
--dpam_created_dt [Creation Date]  
 convert(varchar(11),dpam_created_dt,103) [Creation Date]  
from dp_acct_mstr dpam , status_mstr   
where dpam_stam_Cd     = stam_cd  
and   dpam_dpm_id      = @l_dpm_id  
and   dpam_deleted_ind = 1  
and   stam_deleted_ind = 1  
and   not exists(select dpam_id from dp_acct_mstr_mak dpamm where dpamm.dpam_id = dpam.dpam_id and dpamm.dpam_deleted_ind = 1 and dpam.dpam_deleted_ind = 1)  
and   dpam_lst_upd_dt  between @pa_from_dt and @pa_to_dt   
and   not exists(select fre_DPAM_ID from freeze_unfreeze_dtls where fre_level = 'A' and fre_DPAM_ID = dpam_id )   
and   exists(select CLSR_BO_ID from CLOSURE_ACCT_CDSL where CLSR_BO_ID = dpam_sba_no)   
  
  
  
end

GO
