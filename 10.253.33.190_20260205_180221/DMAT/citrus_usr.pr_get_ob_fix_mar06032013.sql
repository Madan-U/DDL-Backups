-- Object: PROCEDURE citrus_usr.pr_get_ob_fix_mar06032013
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--declare @p19 varchar(1)    
--set @p19=NULL    
--exec Pr_Rpt_Statement @pa_dptype='CDSL',@pa_excsmid=3,@pa_fromdate='AUG  2 2011',@pa_todate='AUG  2 2011'    
--,@pa_fromaccid='1201090000000101'    
--,@pa_toaccid='1201090000000101'    
--,@pa_bulk_printflag='N'    
--,@pa_stopbillclients_flag='N'    
--,@pa_isincd='INF732E01037'    
--,@pa_group_cd='|*~|N',@pa_transclientsonly='N    
--',@pa_Hldg_Yn='N',@pa_login_pr_entm_id='1'    
--,@pa_login_entm_cd_chain='HO|*~|',@pa_settm_type=''    
--,@pa_settm_no_fr='',@pa_settm_no_to=''    
--,@PA_WITHVALUE='N'    
--,@pa_output=@p19 output    
--select @p19    
    
--exec pr_get_ob_fix 3,'aug 02 2011','aug 02 2011','0','9999999999999999',''    
CREATE proc [citrus_usr].[pr_get_ob_fix_mar06032013](@pa_dpm_id numeric,@pa_from_dt datetime, @pa_to_dt datetime                      
,@pa_ben_acct_no_fr varchar(16),@pa_ben_acct_no_to varchar(16),@pa_out  varchar(8000) out)    
as    
begin     
    
    
select distinct cdshm_dpm_id    
, cdshm_dpam_id      
, cdshm_isin , convert(numeric(18,5),0) ob  into #tmp_cdsl_holding_dtls from cdsl_holding_dtls    
where  CDSHM_TRAS_DT >= 'aug 01 2011'    
and CDSHM_TRAS_DT between @pa_from_dt and @pa_to_dt    
and cdshm_dpm_id = @pa_dpm_id    
and cdshm_tratm_cd in ('2246','2277','2201','3102','2270','2220','2205','2262')   
-- 2262 added by tushar on  08112912 for lock in transaction 
and cdshm_ben_acct_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to      
                    
    
create index ix_1 on #tmp_cdsl_holding_dtls(cdshm_isin,cdshm_dpam_id)                  
    
    
    
update #tmp_cdsl_holding_dtls     
set ob = holdingbal    
from #tmp_cdsl_holding_dtls a    
,(select dphmcd_dpm_id , dphmcd_dpam_id , dphmcd_isin    
,sum(isnull(dphmcd_free_qty,0))+sum(isnull(DPHMCD_PLEDGE_QTY,0))++sum(isnull(DPHMCD_LOCKIN_QTY,0)) holdingbal 
--we can use curr  qty also for above case lock in qty added on 08112012 by tushar as mosl reported issue     
from dp_daily_hldg_cdsl     
where dphmcd_holding_dt = 'jul 31 2011'    
group by  dphmcd_dpm_id , dphmcd_dpam_id , dphmcd_isin) holding    
where cdshm_dpm_id = dphmcd_dpm_id     
and dphmcd_dpam_id = cdshm_dpam_id     
and cdshm_isin = dphmcd_isin     
    
    
    
update #tmp_cdsl_holding_dtls     
set ob = isnull(ob,0)+ transbal    
from #tmp_cdsl_holding_dtls a    
,(select cdshm_dpm_id    
, cdshm_dpam_id      
, cdshm_isin     
, sum(isnull(cdshm_qty,0))     transbal  
from (   select  cdshm_dpm_id,cdshm_dpam_id ,cdshm_isin ,cdshm_qty
from  cdsl_holding_dtls                        
where CDSHM_TRAS_DT < @pa_from_dt    
and cdshm_tras_dt >='aug 01 2011'    
and cdshm_tratm_cd in ('2246','2277','3102','2270','2220','2205')     
and cdshm_ben_acct_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to
union  all 
   select  cdshm_dpm_id,cdshm_dpam_id ,cdshm_isin ,cdshm_qty
from  cdsl_holding_dtls   outr                     
where CDSHM_TRAS_DT < @pa_from_dt    
and cdshm_tras_dt >='aug 01 2011'    
and cdshm_tratm_cd in ('2201')
and not exists (select  cdshm_dpm_id,cdshm_dpam_id ,cdshm_isin ,cdshm_qty
from  cdsl_holding_dtls   inn                     
where inn.cdshm_ben_acct_no = outr.cdshm_ben_acct_no 
and inn.cdshm_isin = outr.cdshm_isin 
and inn.cdshm_trans_no = outr.cdshm_trans_no 
and CDSHM_TRAS_DT < @pa_from_dt    
and cdshm_tras_dt >='aug 01 2011'    
and cdshm_tratm_cd in ('2246') )     
and cdshm_ben_acct_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to ) a      
group by  cdshm_dpm_id    
, cdshm_dpam_id      
, cdshm_isin    
) tranbal    
where a.cdshm_dpm_id = tranbal.cdshm_dpm_id    
and a.cdshm_dpam_id = tranbal.cdshm_dpam_id     
and a.cdshm_isin = tranbal.cdshm_isin     
    
select * from #tmp_cdsl_holding_dtls    
    
drop table #tmp_cdsl_holding_dtls    
    
end

GO
