-- Object: PROCEDURE citrus_usr.pr_eod_trx_summary
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--pr_eod_trx_summary '3','jan 01 2009','aug 20 2009','',''  
CREATE proc [citrus_usr].[pr_eod_trx_summary](@pa_id numeric,@pa_from_dt datetime,@pa_to_dt datetime,@pa_trx_type varchar(100),@pa_out varchar(1000) out)  
as  
begin  
  
declare @l_dpm_id  numeric  
,@l_exch_cd varchar(10)  
  
select @l_exch_cd = excsm_exch_cd from exch_seg_mstr where excsm_id = @pa_id and excsm_deleted_ind = 1  
  
select @l_dpm_id = dpm_id from dp_mstr where dpm_excsm_id = default_dp and dpm_excsm_id = @pa_id and dpm_deleted_ind = 1   
--seq   
--1--Total Number of Instructions Entered:   
--2--Total Number of Instructions Deleted:   
--3--Total Number of Active Instructions :   
--4--Total Number of Instructions Authorised:   
--5--Total Number of Instructions Entered for value authorization:    
--6--Total Number of Instructions Cancelled:   
  
--select * from dp_trx_dtls_cdsl  
  
create table #t_end_data(seq numeric , tran_count numeric, tran_type  varchar(100),maker_id varchar(100),auth_id varchar(100))  
  
if @l_exch_cd ='CDSL'  
begin  
  
insert into #t_end_data  
select '1',count(*) , case when dptdc_internal_trastm='CMBO' THEN 'Cm-Bo' 
when  dptdc_internal_trastm='BOBO' then 'Delivery Off-Market Trade'
when  dptdc_internal_trastm='CMBO' then 'Cm-Bo'
when  dptdc_internal_trastm='CMCM' then 'Cm-Cm'
when  dptdc_internal_trastm='EP' then 'Early Pay-In'
when  dptdc_internal_trastm='ID' then 'Inter-Depository'
when  dptdc_internal_trastm='NP' then 'Normal Pay-In'
when  dptdc_internal_trastm='DEMAT' then 'Demat Request'
when  dptdc_internal_trastm='REMAT' then 'Remat Request'
else dptdc_internal_trastm end dptdc_internal_trastm , dptdc_created_by ,''   
from dptdc_mak where dptdc_created_dt between @pa_from_dt and @pa_to_dt  
and isnull(DPTDC_BROKERBATCH_NO,'') = ''    
group by DPTDC_INTERNAL_TRASTM , dptdc_created_by  

insert into #t_end_data  
select '1',count(*) , 'Demat Request', demrm_created_by ,''   
from demrm_mak , dp_acct_mstr where demrm_dpam_id =  dpam_id 
and demrm_created_dt between @pa_from_dt and @pa_to_dt  
and dpam_dpm_id = @l_dpm_id
group by demrm_created_by  

insert into #t_end_data  
select '1',count(*) , 'Remat Request', remrm_created_by ,''   
from remrm_mak , dp_acct_mstr where remrm_dpam_id =  dpam_id 
and remrm_created_dt between @pa_from_dt and @pa_to_dt  
and dpam_dpm_id = @l_dpm_id
group by remrm_created_by  


  
insert into #t_end_data  
select '2',count(*) , case when dptdc_internal_trastm='CMBO' THEN 'Cm-Bo' 
when  dptdc_internal_trastm='BOBO' then 'Delivery Off-Market Trade'
when  dptdc_internal_trastm='CMBO' then 'Cm-Bo'
when  dptdc_internal_trastm='CMCM' then 'Cm-Cm'
when  dptdc_internal_trastm='EP' then 'Early Pay-In'
when  dptdc_internal_trastm='ID' then 'Inter-Depository'
when  dptdc_internal_trastm='NP' then 'Normal Pay-In'
when  dptdc_internal_trastm='DEMAT' then 'Demat Request'
when  dptdc_internal_trastm='REMAT' then 'Remat Request'
else dptdc_internal_trastm end dptdc_internal_trastm, dptdc_created_by ,''   
from dptdc_mak where dptdc_created_dt between @pa_from_dt and @pa_to_dt and dptdc_deleted_ind in (4,5)  
and isnull(DPTDC_BROKERBATCH_NO,'') = ''    
group by DPTDC_INTERNAL_TRASTM , dptdc_created_by  

insert into #t_end_data  
select '2',count(*) , 'Demat Request', demrm_created_by ,''   
from demrm_mak , dp_Acct_mstr where demrm_dpam_id = dpam_id 
and demrm_created_dt between @pa_from_dt and @pa_to_dt and demrm_deleted_ind in (4,5)  
and dpam_dpm_id = @l_dpm_id
group by demrm_created_by  


insert into #t_end_data  
select '2',count(*) , 'Remat Request', remrm_created_by ,''   
from remrm_mak , dp_Acct_mstr where remrm_dpam_id = dpam_id 
and remrm_created_dt between @pa_from_dt and @pa_to_dt and remrm_deleted_ind in (4,5)  
and dpam_dpm_id = @l_dpm_id
group by remrm_created_by  

  
insert into #t_end_data  
select '3',count(*) , case when dptdc_internal_trastm='CMBO' THEN 'Cm-Bo' 
when  dptdc_internal_trastm='BOBO' then 'Delivery Off-Market Trade'
when  dptdc_internal_trastm='CMBO' then 'Cm-Bo'
when  dptdc_internal_trastm='CMCM' then 'Cm-Cm'
when  dptdc_internal_trastm='EP' then 'Early Pay-In'
when  dptdc_internal_trastm='ID' then 'Inter-Depository'
when  dptdc_internal_trastm='NP' then 'Normal Pay-In'
when  dptdc_internal_trastm='DEMAT' then 'Demat Request'
when  dptdc_internal_trastm='REMAT' then 'Remat Request'
else dptdc_internal_trastm end dptdc_internal_trastm , dptdc_created_by ,''   
from dp_trx_dtls_cdsl where dptdc_created_dt between @pa_from_dt and @pa_to_dt and dptdc_deleted_ind = 1   
and  DPTDC_TRANS_NO <> ''  
and isnull(DPTDC_BROKERBATCH_NO,'') = ''    
group by DPTDC_INTERNAL_TRASTM , dptdc_created_by  

insert into #t_end_data  
select '3',count(*) , 'Demat Request', demrm_created_by ,''   
from demat_request_mstr,dp_acct_mstr  where demrm_dpam_id = dpam_id 
and demrm_created_dt between @pa_from_dt and @pa_to_dt and demrm_deleted_ind = 1   
and  isnull(DEMRM_BATCH_NO ,'') <> ''  
and dpam_dpm_id = @l_dpm_id
group by demrm_created_by  

insert into #t_end_data  
select '3',count(*) , 'Remat Request', remrm_created_by ,''   
from remat_request_mstr,dp_acct_mstr  where remrm_dpam_id = dpam_id 
and remrm_created_dt between @pa_from_dt and @pa_to_dt and remrm_deleted_ind = 1   
and  isnull(rEMRM_BATCH_NO ,'') <> ''  
and dpam_dpm_id = @l_dpm_id
group by remrm_created_by
  
insert into #t_end_data  
select '4',count(*) , case when dptdc_internal_trastm='CMBO' THEN 'Cm-Bo' 
when  dptdc_internal_trastm='BOBO' then 'Delivery Off-Market Trade'
when  dptdc_internal_trastm='CMBO' then 'Cm-Bo'
when  dptdc_internal_trastm='CMCM' then 'Cm-Cm'
when  dptdc_internal_trastm='EP' then 'Early Pay-In'
when  dptdc_internal_trastm='ID' then 'Inter-Depository'
when  dptdc_internal_trastm='NP' then 'Normal Pay-In'
when  dptdc_internal_trastm='DEMAT' then 'Demat Request'
when  dptdc_internal_trastm='REMAT' then 'Remat Request'
else dptdc_internal_trastm end dptdc_internal_trastm, '' ,dptdc_lst_upd_by  
from dp_trx_dtls_cdsl where dptdc_created_dt between @pa_from_dt and @pa_to_dt and dptdc_deleted_ind = 1   
and isnull(DPTDC_BROKERBATCH_NO,'') = ''    
group by DPTDC_INTERNAL_TRASTM , dptdc_lst_upd_by  

insert into #t_end_data  
select '4',count(*) , 'Demat Request', '' ,demrm_lst_upd_by  
from demat_request_mstr, dp_acct_mstr  where demrm_dpam_id = dpam_id 
and demrm_created_dt between @pa_from_dt and @pa_to_dt and demrm_deleted_ind = 1   
and dpam_dpm_id  = @l_dpm_id
group by demrm_lst_upd_by  


insert into #t_end_data  
select '4',count(*) , 'Remat Request', '' ,remrm_lst_upd_by  
from remat_request_mstr, dp_acct_mstr  where remrm_dpam_id = dpam_id 
and remrm_created_dt between @pa_from_dt and @pa_to_dt and remrm_deleted_ind = 1   
and dpam_dpm_id = @l_dpm_id
group by remrm_lst_upd_by  



  
insert into #t_end_data  
select '5',count(*) ,case when dptdc_internal_trastm='CMBO' THEN 'Cm-Bo' 
when  dptdc_internal_trastm='BOBO' then 'Delivery Off-Market Trade'
when  dptdc_internal_trastm='CMBO' then 'Cm-Bo'
when  dptdc_internal_trastm='CMCM' then 'Cm-Cm'
when  dptdc_internal_trastm='EP' then 'Early Pay-In'
when  dptdc_internal_trastm='ID' then 'Inter-Depository'
when  dptdc_internal_trastm='NP' then 'Normal Pay-In'
when  dptdc_internal_trastm='DEMAT' then 'Demat Request'
when  dptdc_internal_trastm='REMAT' then 'Remat Request'
else dptdc_internal_trastm end dptdc_internal_trastm
, dptdc_created_by ,''   
from dptdc_mak where dptdc_created_dt between @pa_from_dt and @pa_to_dt and (dptdc_deleted_ind = -1 or isnull(dptdc_mid_chk,'') <> '')  
and isnull(DPTDC_BROKERBATCH_NO,'') = ''    
group by DPTDC_INTERNAL_TRASTM , dptdc_created_by  
  
  
  
  
  
end   
  
if @l_exch_cd ='NSDL'  
begin  
  
insert into #t_end_data  
select '1',count(*) , case when dptd_internal_trastm='C2P' THEN 'Delivery Market Trade' 
when  dptd_internal_trastm='C2C' then 'Delivery Off-Market Trade'
when  dptd_internal_trastm='P2C' then 'Delivery Market Trade'
when  dptd_internal_trastm='P2P' then 'Pool to Pool'
when  dptd_internal_trastm='ATO' then 'Inter-Settlement'
when  dptd_internal_trastm='ID' then 'Inter-Depository'
when  dptd_internal_trastm='NP' then 'Normal Pay-In'
when  dptd_internal_trastm='DEMAT' then 'Demat Request'
when  dptd_internal_trastm='REMAT' then 'Remat Request'
else dptd_internal_trastm end dptd_internal_trastm , dptd_created_by ,''   
from dptd_mak where dptd_created_dt between @pa_from_dt and @pa_to_dt  
and isnull(DPTD_BROKERBATCH_NO,'') = ''    
group by DPTD_INTERNAL_TRASTM , dptd_created_by  


insert into #t_end_data  
select '1',count(*) , 'Demat Request', demrm_created_by ,''   
from demrm_mak , dp_acct_mstr where demrm_dpam_id =  dpam_id 
and demrm_created_dt between @pa_from_dt and @pa_to_dt  
and dpam_dpm_id = @l_dpm_id
group by demrm_created_by  

insert into #t_end_data  
select '1',count(*) , 'Remat Request', remrm_created_by ,''   
from remrm_mak , dp_acct_mstr where remrm_dpam_id =  dpam_id 
and remrm_created_dt between @pa_from_dt and @pa_to_dt  
and dpam_dpm_id = @l_dpm_id
group by remrm_created_by  

  
insert into #t_end_data  
select '2',count(*) , case when dptd_internal_trastm='C2P' THEN 'Delivery Market Trade' 
when  dptd_internal_trastm='C2C' then 'Delivery Off-Market Trade'
when  dptd_internal_trastm='P2C' then 'Delivery Market Trade'
when  dptd_internal_trastm='P2P' then 'Pool to Pool'
when  dptd_internal_trastm='ATO' then 'Inter-Settlement'
when  dptd_internal_trastm='ID' then 'Inter-Depository'
when  dptd_internal_trastm='NP' then 'Normal Pay-In'
when  dptd_internal_trastm='DEMAT' then 'Demat Request'
when  dptd_internal_trastm='REMAT' then 'Remat Request'
else dptd_internal_trastm end dptd_internal_trastm , dptd_created_by ,''   
from dptd_mak where dptd_created_dt between @pa_from_dt and @pa_to_dt and dptd_deleted_ind in (4,5)  
and isnull(DPTD_BROKERBATCH_NO,'') = ''    
group by DPTD_INTERNAL_TRASTM , dptd_created_by  
  
insert into #t_end_data  
select '2',count(*) , 'Demat Request', demrm_created_by ,''   
from demrm_mak , dp_Acct_mstr where demrm_dpam_id = dpam_id 
and demrm_created_dt between @pa_from_dt and @pa_to_dt and demrm_deleted_ind in (4,5)  
and dpam_dpm_id = @l_dpm_id
group by demrm_created_by  


insert into #t_end_data  
select '2',count(*) , 'Remat Request', remrm_created_by ,''   
from remrm_mak , dp_Acct_mstr where remrm_dpam_id = dpam_id 
and remrm_created_dt between @pa_from_dt and @pa_to_dt and remrm_deleted_ind in (4,5)  
and dpam_dpm_id = @l_dpm_id
group by remrm_created_by  



insert into #t_end_data  
select '3',count(*) , case when dptd_internal_trastm='C2P' THEN 'Delivery Market Trade' 
when  dptd_internal_trastm='C2C' then 'Delivery Off-Market Trade'
when  dptd_internal_trastm='P2C' then 'Delivery Market Trade'
when  dptd_internal_trastm='P2P' then 'Pool to Pool'
when  dptd_internal_trastm='ATO' then 'Inter-Settlement'
when  dptd_internal_trastm='ID' then 'Inter-Depository'
when  dptd_internal_trastm='NP' then 'Normal Pay-In'
when  dptd_internal_trastm='DEMAT' then 'Demat Request'
when  dptd_internal_trastm='REMAT' then 'Remat Request'
else dptd_internal_trastm end dptd_internal_trastm , dptd_created_by ,''   
from dp_trx_dtls where dptd_created_dt between @pa_from_dt and @pa_to_dt and dptd_deleted_ind = 1   
and isnull(DPTD_BROKERBATCH_NO,'') = ''    
and  DPTD_TRANS_NO <> ''  
group by DPTD_INTERNAL_TRASTM , dptd_created_by  


insert into #t_end_data  
select '3',count(*) , 'Demat Request', demrm_created_by ,''   
from demat_request_mstr,dp_acct_mstr  where demrm_dpam_id = dpam_id 
and demrm_created_dt between @pa_from_dt and @pa_to_dt and demrm_deleted_ind = 1   
and  isnull(DEMRM_BATCH_NO ,'') <> ''  
and dpam_dpm_id = @l_dpm_id
group by demrm_created_by  

insert into #t_end_data  
select '3',count(*) , 'Remat Request', remrm_created_by ,''   
from remat_request_mstr,dp_acct_mstr  where remrm_dpam_id = dpam_id 
and remrm_created_dt between @pa_from_dt and @pa_to_dt and remrm_deleted_ind = 1   
and  isnull(rEMRM_BATCH_NO ,'') <> ''  
and dpam_dpm_id = @l_dpm_id
group by remrm_created_by
  


  
insert into #t_end_data  
select '4',count(*) ,case when dptd_internal_trastm='C2P' THEN 'Delivery Market Trade' 
when  dptd_internal_trastm='C2C' then 'Delivery Off-Market Trade'
when  dptd_internal_trastm='P2C' then 'Delivery Market Trade'
when  dptd_internal_trastm='P2P' then 'Pool to Pool'
when  dptd_internal_trastm='ATO' then 'Inter-Settlement'
when  dptd_internal_trastm='ID' then 'Inter-Depository'
when  dptd_internal_trastm='NP' then 'Normal Pay-In'
when  dptd_internal_trastm='DEMAT' then 'Demat Request'
when  dptd_internal_trastm='REMAT' then 'Remat Request'
else dptd_internal_trastm end dptd_internal_trastm, '' ,dptd_lst_upd_by   
from dp_trx_dtls where dptd_created_dt between @pa_from_dt and @pa_to_dt and dptd_deleted_ind = 1   
and isnull(DPTD_BROKERBATCH_NO,'') = ''    
group by DPTD_INTERNAL_TRASTM , dptd_lst_upd_by  


insert into #t_end_data  
select '4',count(*) , 'Demat Request', '' ,demrm_lst_upd_by  
from demat_request_mstr, dp_acct_mstr  where demrm_dpam_id = dpam_id 
and demrm_created_dt between @pa_from_dt and @pa_to_dt and demrm_deleted_ind = 1   
and dpam_dpm_id = @l_dpm_id
group by demrm_lst_upd_by  


insert into #t_end_data  
select '4',count(*) , 'Remat Request', '' ,remrm_lst_upd_by  
from remat_request_mstr, dp_acct_mstr  where remrm_dpam_id = dpam_id 
and remrm_created_dt between @pa_from_dt and @pa_to_dt and remrm_deleted_ind = 1   
and dpam_dpm_id = @l_dpm_id
group by remrm_lst_upd_by  

  
insert into #t_end_data  
select '5',count(*) , case when dptd_internal_trastm='C2P' THEN 'Delivery Market Trade' 
when  dptd_internal_trastm='C2C' then 'Delivery Off-Market Trade'
when  dptd_internal_trastm='P2C' then 'Delivery Market Trade'
when  dptd_internal_trastm='P2P' then 'Pool to Pool'
when  dptd_internal_trastm='ATO' then 'Inter-Settlement'
when  dptd_internal_trastm='ID' then 'Inter-Depository'
when  dptd_internal_trastm='NP' then 'Normal Pay-In'
when  dptd_internal_trastm='DEMAT' then 'Demat Request'
when  dptd_internal_trastm='REMAT' then 'Remat Request'
else dptd_internal_trastm end dptd_internal_trastm , dptd_created_by ,''   
from dptd_mak where dptd_created_dt between @pa_from_dt and @pa_to_dt and (dptd_deleted_ind = -1 or isnull(dptd_mid_chk,'') <> '')  
and isnull(DPTD_BROKERBATCH_NO,'') = ''  
group by DPTD_INTERNAL_TRASTM , dptd_created_by  
  
  
  
  
  
end   
  
select case when seq = 1 then 'Total Number of Instructions Entered:'  
when seq = 2 then 'Total Number of Instructions Deleted:'  
when seq = 3 then 'Total Number of Active Instructions :'   
when seq = 4 then 'Total Number of Instructions Authorised:'  
when seq = 5 then 'Total Number of Instructions Entered for value authorization:' end tran_desc,  
tran_count , tran_type  , case when seq <> 4 then  maker_id else auth_id end makerauth_id   
  
from #t_end_data  
order by  seq   
  
end

GO
