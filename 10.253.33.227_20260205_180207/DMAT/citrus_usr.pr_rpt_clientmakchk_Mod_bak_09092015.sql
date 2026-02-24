-- Object: PROCEDURE citrus_usr.pr_rpt_clientmakchk_Mod_bak_09092015
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--exec pr_rpt_clientmakchk '4','dec 01 2008','nov 19 2009'  
create  procedure [citrus_usr].[pr_rpt_clientmakchk_Mod_bak_09092015]  
(  
@pa_excsm_id numeric,  
@pa_from_dt datetime,  
@pa_to_dt datetime  
)  
as  
begin  
  
declare @l_dpm_id numeric   
  
select @l_dpm_id = dpm_id from dp_mstr where default_dp = dpm_excsm_id and dpm_excsm_id = @pa_excsm_id and dpm_deleted_ind = 1  
  
Select distinct convert(varchar(11),clic_mod_from_dt,109) ModDt,clic_mod_dpam_sba_no,citrus_usr.fn_ucc_accp(dpam_id,'BBO_CODE','') bbo_code
 ,clic_mod_action,clic_mod_created_by,clic_mod_lst_upd_by from client_list_modified,dp_acct_mstr,client_mstr 
where clic_mod_from_dt>=CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00'
and clic_mod_to_dt<=CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59' 
and clic_mod_dpam_sba_no=dpam_sba_no and dpam_crn_no=clim_crn_no
and dpam_deleted_ind=1 and clim_deleted_ind=1 and clic_mod_deleted_ind=1   
  
end

GO
