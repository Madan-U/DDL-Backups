-- Object: PROCEDURE citrus_usr.pr_inv_allocation
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------




CREATE  proc [citrus_usr].[pr_inv_allocation](@pa_action varchar(100),@pa_dpm_id numeric,@pa_from_dt datetime,@pa_to_dt datetime
,@pa_login_name varchar(100))
as
begin 

if @pa_action='INS'
begin
--drop table #finaldata
select IDENTITY(numeric,1,1) ID,monthid,year,sbano
--STATE_CODE+'/'+left(DateName( month , DateAdd( month , monthid , 0 ) - 1 ),3)+right(CONVERT(varchar,year),2)+'/DPB/' INV_NO
--right(convert(varchar(10),clic_trans_dt,103),4)+substring(convert(varchar(10),clic_trans_dt,103),4,2) inv_no
,convert(varchar,year)+case when len(convert(varchar,monthid))=1 then '0'+convert(varchar,monthid) else convert(varchar,monthid) end inv_no
,flg1,flg2 , DPAM_DPM_ID
--,'MIG',GETDATE(),'MIG',GETDATE(),1 
into #finaldata from (
select distinct month(CLIC_TRANS_DT) monthid ,YEAR(CLIC_TRANS_DT) year, dpam_sba_no sbano,'' invno,'' flg1,'' flg2
,DPAM_DPM_ID ,STATE_CODE--,CLIC_TRANS_DT
from client_charges_CDSL , dp_acct_mstr ,VW_BASELOCATION_MSTR
where dpam_id = CLIC_DPAM_ID and DPAM_SBA_NO = BOID and DPAM_DPM_ID = @pa_dpm_id 
and CLIC_TRANS_DT between  @pa_from_dt and @pa_to_dt ) a order by 3 

if not exists (select 1 from bo_bill_inv_mapping where billmonth = month(@pa_from_dt) and billyear = YEAR(@pa_from_dt)) 
begin 


insert into bo_bill_inv_mapping
select monthid,YEAR, sbano, inv_no+case when len(id)=1 then replicate(0,5) +convert(varchar,id)
when len(id)=2 then replicate(0,4) +convert(varchar,id)
when len(id)=3 then replicate(0,3) +convert(varchar,id)
when len(id)=4 then replicate(0,2) +convert(varchar,id)
when len(id)=5 then replicate(0,1) +convert(varchar,id)

else convert(varchar,id) end 
,'','','MIG',GETDATE(),'MIG',GETDATE(),1  ,dpam_dpm_id 
from #finaldata
end
end 
if @pa_action='DEL'
begin

update  bo_bill_inv_mapping  set deleted_ind = 0 where billmonth=month(@pa_from_dt) and  billyear=year(@pa_from_dt)
and billmonth=month(@pa_to_dt) and  billyear=year(@pa_to_dt)
end

if @pa_action='Select'
begin
---0104201730042017
declare @l_id varchar(30)
declare @l_strsql varchar(800), @pa_from_dtnew varchar(30),@pa_to_dtnew varchar(30)
--select @l_id=fin_id from Financial_Yr_Mstr where getdate() between FIN_START_DT and FIN_END_DT

--- by lateshw on apr 02 2018
if MONTH(@pa_from_dt)='3'
begin
select @l_id=fin_id from Financial_Yr_Mstr where --getdate() between FIN_START_DT and FIN_END_DT
month(FIN_END_DT)=month(@pa_to_dt)
and  year(FIN_END_DT)=year(@pa_to_dt)
end
else
begin
select @l_id=fin_id from Financial_Yr_Mstr where getdate() between FIN_START_DT and FIN_END_DT
end

--- by lateshw on apr 02 2018

print replace(convert(varchar(10),@pa_from_dt,103),'/','')
set @pa_from_dtnew=replace(convert(varchar(10),@pa_from_dt,103),'/','')
set @pa_to_dtnew=replace(convert(varchar(10),@pa_to_dt,103),'/','')
print @l_id
print @pa_from_dtnew
Set @l_strsql='if exists (Select * from ledger'+@l_id +' where LDG_REF_NO=' + @pa_from_dtnew+@pa_to_dtnew + ' and LDG_VOUCHER_TYPE=5 and LDG_DELETED_IND=1)'
Set @l_strsql=@l_strsql + ' begin Select ''Y'' flag end'
Set @l_strsql=@l_strsql + ' else begin Select ''N'' flag end'
print @l_strsql
exec (@l_strsql)

end


if @pa_action='Reset'
begin
---0104201730042017
if not exists(
Select billmonth from bo_bill_inv_mapping where billmonth=month(@pa_from_dt) and  billyear=year(@pa_from_dt)
and billmonth=month(@pa_to_dt) and  billyear=year(@pa_to_dt)
)
begin
Select 'N' flag
end
end

if @pa_action='Validate'
begin
---0104201730042017
if  exists(
Select billmonth from bo_bill_inv_mapping where billmonth=month(@pa_from_dt) and  billyear=year(@pa_from_dt)
and billmonth=month(@pa_to_dt) and  billyear=year(@pa_to_dt)
)
begin
Select '1' flag
end
end

end

GO
