-- Object: PROCEDURE citrus_usr.bulk_upd_accp_pend_bill_start_dt
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------



CREATE      proc [citrus_usr].[bulk_upd_accp_pend_bill_start_dt]
as
begin 


-- take data from client import in #temp table.
select    ClntId   boid  into #temp 
from activedata1402 -- client provided data import in this table
 
 


drop  table Pend_data_to_import_accp_entp_dps8_pc1
select * into Pend_data_to_import_accp_entp_dps8_pc1 from dps8_pc1 where boid  in (select boid from #temp )
 



select * into #tmp_accp_value1 from ( 
SELECT DISTINCT  boid, CONVERT(VARCHAR,'35') propid, LEFT(ISNULL(LTRIM(RTRIM(BOActDt)),''),2) + '/'+ SUBSTRING(ISNULL(LTRIM(RTRIM(BOActDt)),''),3,2) + '/' + RIGHT(ISNULL(LTRIM(RTRIM(BOActDt)),''),4)  value FROM Pend_data_to_import_accp_entp_dps8_pc1  where BOActDt <> ''


) a 


SELECT BOID , PROPID , mAX(VALUE ) VALUE  INTO  #tmp_accp_value FROM #tmp_accp_value1
GROUP BY BOID , PROPID

sELECT dpam_id,dpam_sba_no  acno,'DP' accttype , (select top 1 ACCPM_PROP_CD from account_property_mstr where accpm_prop_ID = propid) code , propid, value ,'TMIG' cb,getdate() cd ,'TMIG' lb,getdate() ld ,1  delind 
into #tempprop1_old_todelete FROM (select distinct * from #tmp_accp_value ) a , dp_acct_mstr where dpam_sba_no = boid
and exists (select 1 from account_properties where dpam_id = accp_clisba_id  and accp_accpm_prop_id = propid and accp_deleted_ind = 1) 
and value =  ''

update accp set  accp_deleted_ind = 0 , accp_lst_upd_by ='BULK' , accp_lst_upd_dt = getdate() from account_properties  accp , #tempprop1_old_todelete 
where dpam_id = accp_clisba_id  and accp_accpm_prop_id = propid
and accp_value <>  value 
and value =  ''



sELECT dpam_id,dpam_sba_no  acno,'DP' accttype , (select top 1 ACCPM_PROP_CD from account_property_mstr where accpm_prop_ID = propid) code , propid, value ,'TMIG' cb,getdate() cd ,'TMIG' lb,getdate() ld ,1  delind 
into #tempprop1_old_deleted_revert FROM (select distinct * from #tmp_accp_value ) a , dp_acct_mstr where dpam_sba_no = boid
and exists (select 1 from account_properties where dpam_id = accp_clisba_id  and accp_accpm_prop_id = propid and accp_deleted_ind = 0) 
and value <> ''


update accp set accp_deleted_ind = 1 , accp_value = value, accp_lst_upd_by ='BULK' , accp_lst_upd_dt = getdate() from account_properties  accp , #tempprop1_old_deleted_revert 
where dpam_id = accp_clisba_id  and accp_accpm_prop_id = propid
and value <> ''



sELECT dpam_id,dpam_sba_no  acno,'DP' accttype , (select top 1 ACCPM_PROP_CD from account_property_mstr where accpm_prop_ID = propid) code , propid, value ,'TMIG' cb,getdate() cd ,'TMIG' lb,getdate() ld ,1  delind 
into #tempprop1_old FROM (select distinct * from #tmp_accp_value ) a , dp_acct_mstr where dpam_sba_no = boid
and exists (select 1 from account_properties where dpam_id = accp_clisba_id  and accp_accpm_prop_id = propid and accp_deleted_ind = 1) 
and value <> ''


update accp set accp_value = value, accp_lst_upd_by ='BULK' , accp_lst_upd_dt = getdate() from account_properties  accp , #tempprop1_old 
where dpam_id = accp_clisba_id  and accp_accpm_prop_id = propid
and accp_value <>  value 
and value <> ''



sELECT identity(numeric,1,1) id , dpam_id,dpam_sba_no  acno,'DP' accttype , (select top 1 ACCPM_PROP_CD from account_property_mstr where accpm_prop_ID = propid) code , propid, value ,'TMIG' cb,getdate() cd ,'TMIG' lb,getdate() ld ,1  delind 
into #tempprop1_new FROM (select distinct * from #tmp_accp_value ) a , dp_acct_mstr where dpam_sba_no = boid
and not exists (select 1 from account_properties where dpam_id = accp_clisba_id  and accp_accpm_prop_id = propid and accp_deleted_ind = 1) 
and value <> ''


declare @l_id numeric 
set @l_id  = 0 
sELECT @l_id  = MAX(accp_id) from (select accp_id from account_PROPERTIES 
union all 
select accp_id from accp_mak ) a 


insert into Account_PROPERTIES 
select @l_id + id 
,dpam_id
,acno
,accttype
,code
,propid 
,value
,cb
,cd
,lb
,ld
,delind from #tempprop1_new




drop table #temp

end

GO
