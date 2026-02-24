-- Object: PROCEDURE citrus_usr.pr_servicetax_modify
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--3--CDSL
--4--NSDL
--begin tran
--exec pr_servicetax_modify  4
--rollback

CREATE procedure [citrus_usr].[pr_servicetax_modify](@pa_excsm_id numeric)
as
begin

declare @l_str varchar(8000)

set @l_str  = 'select * into [chrage_mstr(' + convert(varchar(20),getdate(),109) + ')]  from 	charge_mstr go '
set @l_str  = @l_str+'select * into [profile_charges(' + convert(varchar(20),getdate(),109) + ')]  from 	profile_charges go '
set @l_str  = @l_str+'select * into [brokerage_mstr(' + convert(varchar(20),getdate(),109) + ')]  from 	brokerage_mstr go '
set @l_str  = @l_str+'select * into [client_dp_charges(' + convert(varchar(20),getdate(),109) + ')]  from 	client_dp_brkg go '
exec(@l_str)

declare @l_max_id numeric
declare @l_max_id1 numeric
declare @l_max_id2 numeric
if exists(select name from sysobjects where name = '#temp_data' )
begin
drop table #temp_data
drop table #temp_data2
end

select identity(bigint,1,1) id1 , CHAM_SLAB_NO CHAM_SLAB_NO_old, CHAM_SLAB_NAME= case 
when CHAM_SLAB_NAME like '%SER%TAX%' then 'SERVICE TAX'
else 'CESS' end 

,CHAM_CHARGE_TYPE
,CHAM_CHARGE_BASE
,CHAM_BILL_PERIOD
,CHAM_BILL_INTERVAL
,CHAM_CHARGE_BASEON
,CHAM_FROM_FACTOR
,CHAM_TO_FACTOR
,CHAM_VAL_PERS 
,CHAM_CHARGE_VALUE = case 
when CHAM_SLAB_NAME like '%SER%TAX%' then 10.00
else 0.30 end 
,CHAM_CHARGE_MINVAL
,CHAM_CHARGE_GRADED
,CHAM_CHARGEBITFOR
,CHAM_REMARKS
,CHAM_CREATED_BY
,CHAM_CREATED_DT
,CHAM_LST_UPD_BY
,CHAM_LST_UPD_DT
,CHAM_DELETED_IND   into #temp_data from charge_mstr where CHAM_CHARGE_TYPE = 'AMT' and cham_chargebitfor = @pa_excsm_id

select @l_max_id  = max(cham_slab_no) + 1 from charge_mstr 

insert into charge_mstr
select @l_max_id + id1  
, cham_slab_name 
, cham_charge_type 
, cham_charge_base 
, cham_bill_period
, cham_bill_interval 
, cham_charge_baseon
 , cham_from_factor 
, cham_to_factor 
, cham_val_pers 
, cham_charge_value 
, cham_charge_minval 
, cham_charge_graded 
, cham_chargebitfor
, cham_remarks  
,'MIG'
,getdate()
,'MIG'
,getdate()
,1
,@l_max_id + id1 
,1
,null,0,0
from   #temp_data 


select identity(bigint,1,1) id1 , brom_id brom_id_old ,brom_desc+' (NEW SERVICE TAX/CESS) ' brom_desc, @pa_excsm_id  excpm_id into #temp_data2 
from brokerage_mstr where brom_id in (select distinct proc_profile_id from profile_charges  where PROC_SLAB_NO in (select cham_slab_no from charge_mstr where CHAM_CHARGE_TYPE = 'AMT' and cham_chargebitfor = @pa_excsm_id))




select @l_max_id1  = max(convert(bigint,BROM_ID)) + 1 from brokerage_mstr

insert into brokerage_mstr
select  @l_max_id1 + id1 , brom_desc , excpm_id ,'MIG',getdate(),'MIG',getdate(),1 from #temp_data2 

select identity(bigint,1,1) id1 , * into #temp_data3 from (
select @l_max_id1 + a.id1 PROC_ID, @l_max_id1 + a.id1 PROC_PROFILE_ID, @l_max_id + b.id1 PROC_SLAB_NO,'MIG' PROC_CREATED_BY,ltrim(rtrim(REMARKS))+' NEW SERVICE TAX/CESS' REMARKS ,getdate() PROC_CREATED_DT,'MIG' PROC_LST_UPD_BY,getdate() PROC_LST_UPD_DT ,1 PROC_DELETED_IND from profile_charges , #temp_data2 a, #temp_data b 
where proc_profile_id = brom_id_old
and   PROC_SLAB_NO = CHAM_SLAB_NO_old
union 
select @l_max_id1 + a.id1 PROC_ID, @l_max_id1 + a.id1 PROC_PROFILE_ID, PROC_SLAB_NO PROC_SLAB_NO ,'MIG' PROC_CREATED_BY,ltrim(rtrim(REMARKS))+ ' NEW SERVICE TAX/CESS' REMARKS ,getdate() PROC_CREATED_DT,'MIG' PROC_LST_UPD_BY,getdate()  PROC_LST_UPD_DT ,1  PROC_DELETED_IND 
from profile_charges , #temp_data2 a
where proc_profile_id = brom_id_old
and   PROC_SLAB_NO not in (select CHAM_SLAB_NO_old from #temp_data)) a


select @l_max_id2 = max(proc_dtls_id) +  1 from profile_charges

insert into profile_charges(proc_dtls_id, PROC_ID,PROC_PROFILE_ID,PROC_SLAB_NO,PROC_CREATED_BY,REMARKS,PROC_CREATED_DT,PROC_LST_UPD_BY,PROC_LST_UPD_DT,PROC_DELETED_IND )
select @l_max_id2 + id1 , PROC_ID,PROC_PROFILE_ID,PROC_SLAB_NO,PROC_CREATED_BY,REMARKS,PROC_CREATED_DT,PROC_LST_UPD_BY,PROC_LST_UPD_DT,PROC_DELETED_IND  from #temp_data3


update client_dp_brkg 
set   clidb_eff_to_dt = convert(varchar(11),dateadd(dd,-1,getdate()),109)
where CLIDB_BROM_ID in(select brom_id_old from #temp_data2)
and (clidb_eff_to_dt = '2900-01-01 00:00:00.000' or clidb_eff_to_dt is null or clidb_eff_to_dt = '2900-12-31 00:00:00.000')
and clidb_deleted_ind = 1  

insert into client_dp_brkg
select clidb_dpam_id , @l_max_id1 + id1, 'MIG',getdate(),'MIG',getdate(),1, getdate(), '2900-01-01 00:00:00.000'
from client_dp_brkg ,#temp_data2 where CLIDB_BROM_ID = brom_id_old 
and  clidb_eff_to_dt = convert(varchar(11),dateadd(dd,-1,getdate()),109)
and clidb_deleted_ind = 1 


end

GO
