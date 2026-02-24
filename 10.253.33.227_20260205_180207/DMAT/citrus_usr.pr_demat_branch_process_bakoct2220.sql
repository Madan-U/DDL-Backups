-- Object: PROCEDURE citrus_usr.pr_demat_branch_process_bakoct2220
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--pr_demat_branch_process '4','jan 01 2008','aug 27 2009'
--drop procedure pr_demat_branch_process
create proc [citrus_usr].[pr_demat_branch_process_bakoct2220]

(

@pa_id numeric , 
@pa_from_dt datetime, 
@pa_to_dt datetime

)
as
begin

declare @l_dpm_id  numeric

select @l_dpm_id   = dpm_id from dp_mstr where default_dp = dpm_excsm_id and dpm_excsm_id = @pa_id and dpm_deleted_ind = 1 
create table #temp_demat_process(id numeric, branch varchar(100),demrm_id numeric)

insert into #temp_demat_process
select  distinct '1',isnull(citrus_usr.[fn_find_relations_nm_by_dpamno](dpam_sba_no,'BR'),'') Branch ,demrm_id
from  demrm_mak , dp_acct_mstr  where demrm_dpam_id = dpam_id 
and   demrm_deleted_ind in (0,1)
and   dpam_dpm_id = @l_dpm_id   
and   demrm_created_dt between @pa_from_dt and @pa_to_dt
and   ltrim(rtrim(isnull(citrus_usr.[fn_find_relations_nm_by_dpamno](dpam_sba_no,'BR'),''))) <> ''
union
select  distinct '2',isnull(citrus_usr.[fn_find_relations_nm_by_dpamno](dpam_sba_no,'BR'),'') Branch ,demrm_id
from  demrm_mak , dp_acct_mstr  where demrm_dpam_id = dpam_id 
and   demrm_deleted_ind in (0)
and   dpam_dpm_id = @l_dpm_id   
and   demrm_created_dt between @pa_from_dt and @pa_to_dt
and   ltrim(rtrim(isnull(citrus_usr.[fn_find_relations_nm_by_dpamno](dpam_sba_no,'BR'),''))) <> ''
union
select  distinct '3',isnull(citrus_usr.[fn_find_relations_nm_by_dpamno](dpam_sba_no,'BR'),'') Branch ,demrm_id
from  demat_request_mstr , dp_acct_mstr  where demrm_dpam_id = dpam_id 
and   demrm_deleted_ind in (1)
and   demrm_drf_no = DEMRM_SLIP_SERIAL_NO
and   dpam_dpm_id = @l_dpm_id   
and   demrm_created_dt between @pa_from_dt and @pa_to_dt
and   not   exists(select disp_demrm_id from dmat_dispatch where demrm_id = disp_demrm_id )
and   ltrim(rtrim(isnull(citrus_usr.[fn_find_relations_nm_by_dpamno](dpam_sba_no,'BR'),''))) <> ''
union
select  distinct '4',isnull(citrus_usr.[fn_find_relations_nm_by_dpamno](dpam_sba_no,'BR'),'') Branch ,demrm_id
from  demat_request_mstr , dp_acct_mstr  , dmat_dispatch where demrm_dpam_id = dpam_id  and DEMRM_ID = DISP_DEMRM_ID 
and   demrm_deleted_ind = 1
and   dpam_dpm_id = @l_dpm_id   
and   demrm_created_dt between @pa_from_dt and @pa_to_dt
and   demrm_drf_no <> DEMRM_SLIP_SERIAL_NO
and   ltrim(rtrim(isnull(citrus_usr.[fn_find_relations_nm_by_dpamno](dpam_sba_no,'BR'),''))) <> ''

--select branch  ,  count(demrm_id) as demrm_id , 
--case when id = 1 then  'Entered'   
--when id = 2 then 'Entered But Not Authorised'   
--when id = 3 then 'Authorised But Not Dispatched'
--when id = 4 then 'Acknowledged But DRN Not Generated' end  description
--from #temp_demat_process group by id , branch


select a.branch  , sum([Entered]) [Entered] , sum([Entered But Not Authorised]) [Entered But Not Authorised]
,sum([Authorised But Not Dispatched]) [Authorised But Not Dispatched], sum([Acknowledged But DRN Not Generated]) [Acknowledged But DRN Not Generated] 
from (
select branch  ,  count(case when id = 1 then demrm_id end) as [Entered]    , 
count(case when id = 2 then demrm_id end)  as  [Entered But Not Authorised]   ,
count(case when id = 3 then demrm_id end)  as  [Authorised But Not Dispatched], 
count(case when id = 4 then demrm_id end)  as  [Acknowledged But DRN Not Generated]
from #temp_demat_process group by id , branch) a 
group by a.branch


end

GO
