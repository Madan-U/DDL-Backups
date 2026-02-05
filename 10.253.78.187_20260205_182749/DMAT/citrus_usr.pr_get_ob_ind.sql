-- Object: PROCEDURE citrus_usr.pr_get_ob_ind
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------


--exec pr_get_ob_ind '3','may 02 2012','may 02 2012','0','9999999999999999' ,''             
              
CREATE proc [citrus_usr].[pr_get_ob_ind](@pa_dpm_id numeric,@pa_from_dt datetime, @pa_to_dt datetime              
,@pa_ben_acct_no_fr varchar(16),@pa_ben_acct_no_to varchar(16),@pa_out  varchar(8000) out)              
as              
begin        

declare @l_min_trx_dt datetime
declare @l_base_hldg_dt datetime

set @l_min_trx_dt   = ''
set @l_base_hldg_dt = ''
--vw_holding_base_all
if exists(select * from  bitmap_ref_mstr  where bitrm_parent_cd='arch' and bitrm_values ='1')
begin 
select @l_min_trx_dt = min(curr_fr_dt) from archival_details 
select @l_base_hldg_dt = max(dphmcd_holding_dt) from vw_holding_base_all
end 
else 
begin 

set @l_min_trx_dt = 'aug 01 2011'
set @l_base_hldg_dt = 'jul 31 2011'


end 
      

      
          
select distinct cdshm_id,cdshm_tras_dt,cdshm_isin,cdshm_dpam_id , cdshm_trans_no      
into #tempdata_cdsl         
from cdsl_holding_dtls where cdshm_ben_acct_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to            
and cdshm_dpm_id =  @pa_dpm_id    and cdshm_tras_dt >=@l_min_trx_dt      
and cdshm_tras_dt between @pa_from_dt and @pa_to_dt          
and not exists(select ACCOUNT from SPECIFIED_ACCOUNT_LIST where ACCOUNT = cdshm_ben_acct_no and cm_ben ='B')  
and cdshm_tratm_cd in ('2246','2277','2280','2201','3102','2270','2220')  
              
          
           
          
create index ix_1 on #tempdata_cdsl(cdshm_tras_dt,cdshm_isin,cdshm_dpam_id)          
          
          
              
select b.cdshm_tras_dt,a.CDSHM_DPM_ID v_CDSHM_DPM_ID               
,a.CDSHM_DPAM_ID  v_CDSHM_DPAM_ID              
,a.CDSHM_ISIN v_CDSHM_ISIN              
,case when  sum(isnull(a.cdshm_qty,0)) + sum(isnull(dphmcd_free_qty,0))    < 0 then 0 else   
       sum(isnull(a.cdshm_qty,0)) + sum(isnull(dphmcd_free_qty,0))          end   
OB       ,b.CDSHM_TRANS_NO     v_CDSHM_TRANS_NO      
from cdsl_holding_dtls   a left outer join dp_daily_hldg_cdsl               
on dphmcd_dpam_id = a.cdshm_dpam_id               
and dphmcd_dpm_id = a.cdshm_dpm_id              
and dphmcd_isin = a.cdshm_isin               
and dphmcd_holding_dt = @l_base_hldg_dt          
,#tempdata_cdsl b          
where a.cdshm_tratm_cd in ('2246','2277','2280','2201','3102','2270','2220')  
and a.cdshm_ben_acct_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to              
and a.cdshm_dpm_id = @pa_dpm_id           and cdshm_tras_dt >=@l_min_trx_dt          
and a.cdshm_tras_dt <= b.cdshm_tras_dt   
and not exists(select ACCOUNT from SPECIFIED_ACCOUNT_LIST where ACCOUNT = a.cdshm_ben_acct_no and cm_ben ='B')         
and case when a.cdshm_tras_dt = b.cdshm_tras_dt   then     a.cdshm_id else 0 end < case when a.cdshm_tras_dt = b.cdshm_tras_dt   then    b.cdshm_id  else 1 end     
and a.cdshm_dpam_id = b.cdshm_dpam_id           
and a.cdshm_isin = b.cdshm_isin          
group by a.CDSHM_DPM_ID               
,a.CDSHM_DPAM_ID                
,a.CDSHM_ISIN           
,b.cdshm_tras_dt    , b.CDSHM_TRANS_NO      
              
              
              
end

GO
