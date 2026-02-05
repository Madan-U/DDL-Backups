-- Object: PROCEDURE citrus_usr.pr_reconsile_dis_rpt
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------







--select * from Dis_req_Dtls
--select * from sysobjects where name like '%req%'
--select * from slip_issue_mstr --sliim_book_name
--select * from order_slip
--select * from slip_book_mstr
--pr_reconsile_dis 1,'UPDRECO','','','','',''
CREATE proc [citrus_usr].[pr_reconsile_dis_rpt](@pa_id numeric
, @pa_action varchar(100)
, @pa_from_boid varchar(16)
, @pa_to_boid varchar(16)
--, @pa_issue_date varchar(11)
, @pa_from_dt varchar(11)
, @pa_to_dt varchar(11)
--, @pa_disbook_name varchar(100)
, @pa_slip_no varchar(100)
, @pa_remarks varchar(300)
, @pa_recostatus char(1)
, @pa_status char(1)
, @pa_out varchar(1000) out 
)
as

if @pa_from_boid  = ''
begin
set @pa_from_boid  = '0'
set @pa_to_boid  = '9999999999999999'
end 

if @pa_from_dt  = ''
begin
set @pa_from_dt  = 'jan 01 1900'
set @pa_to_dt  = 'jan 01 2090'
end 

begin


select  id ,
'25303' detail_id,
'RSHRISATI_BA - SHRI SATI INVESTMENTS' entm_name1,
'RAJENDRA RAMESHRAO NIMBALKAR' dpam_sba_name,
'1201090000457310' dpam_sba_no,
'05/02/2014 15:57:58' date_of_execution,
'SHRISATI' created_by,
'OK' remarks,
remarks status,
'103570075' req_slip_no,
'S' slip_yn,
'Y' reco_yn,
'' reco_datetime,
'' code_1200,
'' name_1200,
'' contact_no_1200_code,
'' email_1200_code
 
 from [temppr_reconsile_dis]

return
 
 
if @pa_action = 'FETCHFORRECO'
select distinct id,entm_short_name + ' - ' +  entm_name1  entm_name1,dpam_sba_name,dpam_sba_no,created_by , remarks,isnull(req_slip_no,'') req_slip_no,isnull(slip_yn,'') slip_yn,isnull(reco_yn,'') reco_yn
--, case when reco_datetime = '01/01/1900' then '' else replace(isnull(reco_datetime,''),'1/1/1900','') end reco_datetime
,case when isnull(reco_datetime,'1900-01-01 00:00:00.000') ='1900-01-01 00:00:00.000' then '' else replace(isnull(reco_datetime,''),'1900-01-01 00:00:00.000','') end  reco_datetime
--,lst_upd_dt approvedt
,convert(varchar(11),req_date ,109)  req_date
,DATEDIFF(day, lst_upd_dt, GETDATE()+ 1) Ageing
,(select distinct top 1 rol_desc 
		 from roles,entity_roles
		 where rol_id = entro_rol_id
		 and entro_deleted_ind=1
		 and entro_logn_name = created_by) Role
from Dis_req_Dtls left outer join slip_issue_mstr on SLIIM_DPAM_ACCT_NO=boid,dp_Acct_mstr , login_names , entity_mstr 
where dpam_sba_no = SLIIM_DPAM_ACCT_NO and entm_id = logn_ent_id and LOGN_NAME = created_by
--and req_slip_no between  SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_TO
and DeLETED_IND = 1
and sliim_deleted_ind = 1 
and dpam_deleted_ind =1 
--and (isnull(reco_yn,'')= 'N' or isnull(reco_yn,'')= '')
and SLIIM_DPAM_ACCT_NO between @pa_from_boid and @pa_to_boid
and req_date between @pa_from_dt and @pa_to_dt
and case when @pa_slip_no = '' then '%' else  req_slip_no end  = case when @pa_slip_no = '' then '%' else  @pa_slip_no end 
and case when @pa_status = 'A' then '' else isnull(reco_yn,'N') end = case when @pa_status = 'A' then '' when @pa_status = 'R' then 'Y' else 'N' end
and slip_yn <> 'D'
--and reco_yn = case when @pa_status = 'P' then 'N' 
--			  when @pa_status = 'R' then 'Y' 
--			  when @pa_status = 'A' then '%' end 
--and case when @pa_issue_date  = '' then 'jan 01 1900' else  sliim_dt end  =  case when @pa_issue_date  = '' then 'jan 01 1900' else  @pa_issue_date  end 
--and case when @pa_disbook_name = '' then '' else  sliim_book_name end  = case when @pa_disbook_name = '' then '' else  @pa_disbook_name end 


if @pa_action = 'UPDRECO'
update Dis_req_Dtls 
set reco_yn = @pa_recostatus,remarks =@pa_remarks , reco_datetime = case when @pa_recostatus ='Y' then getdate() else '' end --getdate() 
where id = @pa_id  
and deleted_ind = 1 
set @pa_out = 'Successfully Updated'

end

GO
