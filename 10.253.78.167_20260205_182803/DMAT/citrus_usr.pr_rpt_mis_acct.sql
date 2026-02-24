-- Object: PROCEDURE citrus_usr.pr_rpt_mis_acct
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--exec pr_rpt_mis_acct 'jun 01 2013','jun 30 2013'        
CREATE proc [citrus_usr].[pr_rpt_mis_acct](@pa_from_dt datetime , @pa_to_dt datetime)        
as        
begin         
select distinct convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd         
into #account_properties from account_properties       with (nolock)   
where accp_accpm_prop_cd = 'BILL_START_DT'         
and accp_value not in ('')        
        
select distinct convert(datetime,accp_value,103) accp_value_cl        
, accp_clisba_id accp_clisba_id_cl , accp_accpm_prop_cd accp_accpm_prop_cd_cl         
into #account_properties_close from account_properties  with (nolock)       
where accp_accpm_prop_cd = 'ACC_CLOSE_DT'         
and accp_value not in ('','//')         
        
create index ix_1 on #account_properties(accp_clisba_id , accp_value )        
create index ix_2 on #account_properties_close(accp_clisba_id_cl , accp_value_cl )        
        
        
        
        
        
select entr_sba , entm_short_name ,entm_name1,accp_value , isnull(accp_value_cl,'') accp_value_cl ,dpam_stam_cd ,dpam_sba_no       
into #misreport         
from dp_acct_mstr with (nolock) left outer join #account_properties_close  on accp_clisba_id_cl = dpam_id         
  
left outer join entity_relationship with (nolock) on getdate() between isnull(entr_from_dt,'jan 01 1900') and isnull(entr_to_dt,'dec 31 2100')        
and dpam_sba_no = entr_sba   
and entr_deleted_ind = 1     
 left outer join  entity_mstr  with (nolock)  on (entr_br = entm_id  or entr_sb = entm_id)        
,#account_properties         
where accp_clisba_id = dpam_id         
--   

--select isnull(entm_short_name,'1.HEADOFFICE') entm_short_name,isnull(replace(replace(entm_short_name,'_ba',''),'_br',''),'1.HEADOFFICE') [br/ba],entm_name1        ,dpam_sba_no , case when accp_value <=@pa_to_dt then 1 else 0 end [Totalacopen_Asonmonth]  
--,case when accp_value between @pa_from_dt and @pa_to_dt then 1 else 0 end  [acopen_curr_month] 
--     ,case when accp_value_cl between @pa_from_dt and @pa_to_dt then 1 else 0 end  [acclose_curr_month]        
--,case when dpam_stam_cd  ='active' and accp_value <=@pa_to_dt then 1 else 0 end  [Totalactive_lastdayofcurmonth]        
--from #misreport


---        
select isnull(entm_short_name,'1.HEADOFFICE') entm_short_name,isnull(replace(replace(entm_short_name,'_ba',''),'_br',''),'1.HEADOFFICE') [br/ba],entm_name1        
 ,sum(case when accp_value <=@pa_to_dt then 1 else 0 end ) [Totalacopen_Asonmonth]        
,sum(case when accp_value between @pa_from_dt and @pa_to_dt then 1 else 0 end ) [acopen_curr_month]        
,sum(case when accp_value_cl between @pa_from_dt and @pa_to_dt then 1 else 0 end ) [acclose_curr_month]        
,sum(case when dpam_stam_cd  ='active' and accp_value <=@pa_to_dt then 1 else 0 end ) [Totalactive_lastdayofcurmonth]        
from #misreport         
group by entm_short_name ,entm_name1        
        
        
drop table #account_properties        
drop table #account_properties_close        
drop table #misreport        
        
end

GO
