-- Object: PROCEDURE citrus_usr.pr_get_branch_summary
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--begin tran
--exec pr_get_branch_summary 'may 01 2013','may 31 2013'
--rollback
CREATE proc [citrus_usr].[pr_get_branch_summary](@pa_from_dt datetime,@pa_to_dt datetime)
as
begin


if not exists(select dphmcd_holding_dt from Holdingdataforaging where dphmcd_holding_dt = @pa_from_dt)
begin 

insert into Holdingdataforaging(DPHMCD_DPM_ID,DPHMCD_DPAM_ID
,DPHMCD_ISIN,DPHMCD_CURR_QTY,DPHMCD_FREE_QTY,DPHMCD_FREEZE_QTY,DPHMCD_PLEDGE_QTY
,DPHMCD_DEMAT_PND_VER_QTY,DPHMCD_REMAT_PND_CONF_QTY,DPHMCD_DEMAT_PND_CONF_QTY,DPHMCD_SAFE_KEEPING_QTY
,DPHMCD_LOCKIN_QTY,DPHMCD_ELIMINATION_QTY,DPHMCD_EARMARK_QTY,DPHMCD_AVAIL_LEND_QTY
,DPHMCD_LEND_QTY,DPHMCD_BORROW_QTY,dphmcd_holding_dt)
exec [pr_get_holding_fix_latest_branchageing] 3,@pa_from_dt,@pa_from_dt,'0','9999999999999999',''    

end 


if not exists(select dphmcd_holding_dt from Holdingdataforaging where dphmcd_holding_dt = @pa_to_dt)
begin 

insert into Holdingdataforaging(DPHMCD_DPM_ID,DPHMCD_DPAM_ID
,DPHMCD_ISIN,DPHMCD_CURR_QTY,DPHMCD_FREE_QTY,DPHMCD_FREEZE_QTY,DPHMCD_PLEDGE_QTY
,DPHMCD_DEMAT_PND_VER_QTY,DPHMCD_REMAT_PND_CONF_QTY,DPHMCD_DEMAT_PND_CONF_QTY,DPHMCD_SAFE_KEEPING_QTY
,DPHMCD_LOCKIN_QTY,DPHMCD_ELIMINATION_QTY,DPHMCD_EARMARK_QTY,DPHMCD_AVAIL_LEND_QTY
,DPHMCD_LEND_QTY,DPHMCD_BORROW_QTY,dphmcd_holding_dt)
exec [pr_get_holding_fix_latest_branchageing] 3,@pa_to_dt,@pa_to_dt,'0','9999999999999999',''   

end 
--2158473
  
--alter table Holdingdataforaging add rate  numeric(18,3)


select max(CLOPM_DT) max_CLOPM_DT,CLOPM_ISIN_CD max_CLOPM_ISIN_CD 
into #maxclosing_f  from closing_price_mstr_cdsl with (nolock) where clopm_dt < = @pa_from_dt 
and CLOPM_CDSL_RT <> 0 group by clopm_isin_cd

select max(CLOPM_DT) max_CLOPM_DT,CLOPM_ISIN_CD max_CLOPM_ISIN_CD 
into #maxclosing_l  from closing_price_mstr_cdsl with (nolock) where clopm_dt < = @pa_to_dt 
and CLOPM_CDSL_RT <> 0 group by clopm_isin_cd

create index ix_1 on #maxclosing_f(max_CLOPM_ISIN_CD,max_CLOPM_DT)
create index ix_1 on #maxclosing_l(max_CLOPM_ISIN_CD,max_CLOPM_DT)



 select clopm_isin_cd,clopm_cdsl_rt into #aa from  closing_price_mstr_cdsl with (nolock) ,#maxclosing_l
where  CLOPM_DT = max_clopm_dt
and clopm_isin_cd = max_CLOPM_ISIN_CD

create index ix_1 on #aa(clopm_isin_cd)


select * into #Holdingdataforaging  from (
select a.*,rate1 = CLOPM_CDSL_RT 
from Holdingdataforaging a with (nolock) , closing_price_mstr_cdsl with (nolock) ,#maxclosing_f
where clopm_isin_cd = dphmcd_isin 
and dphmcd_holding_dt =@pa_from_dt
and CLOPM_DT = max_clopm_dt
and clopm_isin_cd = max_CLOPM_ISIN_CD
union all 
select a.*,rate1 = CLOPM_CDSL_RT
from Holdingdataforaging a with (nolock) , #aa aa 
where aa.clopm_isin_cd = dphmcd_isin 
and dphmcd_holding_dt =@pa_to_dt
) a
 

 


select distinct convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd 
into #account_properties from account_properties  with (nolock) 
where accp_accpm_prop_cd = 'BILL_START_DT' 
and accp_value not in ('')

select distinct convert(datetime,accp_value,103) accp_value_cl
, accp_clisba_id accp_clisba_id_cl , accp_accpm_prop_cd accp_accpm_prop_cd_cl 
into #account_properties_close from account_properties  with (nolock) 
where accp_accpm_prop_cd = 'ACC_CLOSE_DT' 
and accp_value not in ('','//') 

create index ix_1 on #account_properties(accp_clisba_id , accp_value )
create index ix_2 on #account_properties_close(accp_clisba_id_cl , accp_value_cl )


--create index ix_1 on  Holdingdataforaging (DPHMCD_DPAM_ID )
--create index ix_2 on  Holdingdataforaging (dphmcd_holding_dt)

select --cdshm_dpam_id,*
branch,brname,sum(case when isnull(dphmcd_holding_dt ,'') = @pa_from_dt then dphmcd_curr_qty*isnull(rate1,0) else 0 end ) asonfirst
,sum(case when isnull(dphmcd_holding_dt ,'')= @pa_to_dt then dphmcd_curr_qty*isnull(rate1,0) else 0 end)  asonlast
--,sum(case when accp_value <= @pa_from_dt and isnull(accp_value_cl ,'') <> '1900-01-01 00:00:00.000' and isnull(accp_value_cl ,'') < @pa_from_dt then 0 
--when accp_value <= @pa_from_dt and isnull(accp_value_cl ,'')<> '1900-01-01 00:00:00.000' and isnull(accp_value_cl ,'') > @pa_from_dt  then 1 
--			when accp_value <= @pa_from_dt and isnull(accp_value_cl ,'') = '1900-01-01 00:00:00.000' then 1 else 0 end) acopntill1
--,sum(case when accp_value <= @pa_to_dt and isnull(accp_value_cl ,'') <> '1900-01-01 00:00:00.000' and isnull(accp_value_cl ,'') < @pa_to_dt then 0 
--			when accp_value <= @pa_from_dt and isnull(accp_value_cl ,'') = '1900-01-01 00:00:00.000' then 1 else 0 end  ) acopntill15
,count(distinct case when ( isnull(accp_value_cl ,'') = '1900-01-01 00:00:00.000' or  isnull(accp_value_cl ,'') > @pa_from_dt) then  dpam_sba_no  end  ) asonfirst
,count(distinct case when ( isnull(accp_value_cl ,'') = '1900-01-01 00:00:00.000' or  isnull(accp_value_cl ,'') > @pa_to_dt) then  dpam_sba_no  end  ) asonlast
,count(distinct case when accp_value_cl <> '1900-01-01 00:00:00.000' and accp_value_cl between @pa_from_dt and @pa_to_dt then dpam_sba_no end ) closeinmonth
,count(distinct case when isnull(cdshm_dpam_id,0)<> 0 then cdshm_dpam_id end ) noofclienttrx
,sum(case when isnull(nillhldg.dpam_id,0) <> 0 then 1 else 0 end ) nilholding
from (select entm_name1 brname,dpam_id ,dpam_sba_no , replace(replace(isnull(entm_short_name,''),'_br',''),'_ba','') branch ,accp_value,accp_value_cl
 from dp_acct_mstr with (nolock)
left outer join #account_properties on accp_clisba_id=dpam_id  
left outer join #account_properties_close on accp_clisba_id_cl= dpam_id 
,entity_relationship with (nolock)
left outer join entity_mstr on  (entr_br = entm_id  or entm_id = entr_sb)
where dpam_sba_no = entr_sba 
and @pa_from_dt  between entr_from_dt and isnull(entr_to_dt,'dec 31 2100')
and dpam_deleted_ind = 1 --and replace(replace(isnull(entm_short_name,''),'_br',''),'_ba','') ='RNANGALIND'
and entr_deleted_ind = 1 
and isnull(entm_deleted_ind ,1) = 1 ) b 
left outer join #Holdingdataforaging a on b.dpam_id = a.dphmcd_dpam_id 
and dphmcd_holding_dt between @pa_from_dt and @pa_to_dt 
left outer join (select distinct cdshm_dpam_id from cdsl_holding_dtls with (nolock)
where cdshm_tras_dt between  @pa_from_dt and @pa_to_dt) cdshm
on cdshm_dpam_id = b.dpam_id 
left outer join (select distinct dpam_id  
				 from dp_acct_mstr inn 
                 where not exists(select dphmcd_dpam_id 
                 from Holdingdataforaging where inn.dpam_id = dphmcd_dpam_id and dphmcd_holding_dt=@pa_to_dt)
				 and dpam_stam_cd in ('active','02','06','6')
				 ) nillhldg
on nillhldg.dpam_id = b.dpam_id  
--where branch ='RRAVIRAJ' --and cdshm_dpam_id = 604775
group by branch,brname

truncate table #account_properties
truncate table #account_properties_close

drop table #account_properties
drop table #account_properties_close



end

GO
