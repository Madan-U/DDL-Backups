-- Object: PROCEDURE citrus_usr.pr_missing_tran
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--exec pr_missing_tran 3,'APr 01 2009','apr 30 2009',''

CREATE proc [citrus_usr].[pr_missing_tran](@pa_cd numeric,@pa_from_dt datetime, @pa_to_dt datetime,@pa_ref_cur varchar(800) output)
as
begin
declare @l_from_dt datetime
,@l_to_dt datetime

set @l_from_dt  = @pa_from_dt
set @l_to_dt    = @pa_to_dt
create table #month_date(dt datetime)

while @pa_from_dt <= @pa_to_dt
begin
insert into #month_date
select @pa_from_dt

set @pa_from_dt = dateadd(dd,1,@pa_from_dt)

end 
 
declare @l_dpm_dpid varchar(100)
select @l_dpm_dpid = dpm_dpid from dp_mstr where default_dp = dpm_excsm_id and dpm_deleted_ind = 1
and dpm_excsm_id = @pa_cd 

select dt,DATENAME(DW,dt) da , 'DPM DP57-CDSL FILE-'+@l_dpm_dpid  file_desc from #month_date where dt not in 
(select distinct cdshm_tras_dt from cdsl_holding_dtls where CDSHM_TRAS_DT between @l_from_dt and @l_to_dt)
and DATENAME(DW,dt) not in ('sunday')
 
--union 
--select dt,DATENAME(DW,dt) da , 'DPM DPC9-CDSL FILE - CDSL'  file_desc from #month_date where dt not in 
--(select distinct TASK_FILEDATE from filetask 
--where task_name like '%DPM DPC9-CDSL FILE - CDSL%' and  TASK_FILEDATE between @l_from_dt and @l_to_dt)

--select * from filetask order by 6 desc 


end

GO
