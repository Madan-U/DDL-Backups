-- Object: PROCEDURE citrus_usr.pr_get_ob_arch
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


--exec pr_get_ob '3','aug 02 2011','aug 02 2011','1201090000000101','1201090000000101' ,''                 
                  
CREATE proc [citrus_usr].[pr_get_ob_arch](@pa_dpm_id numeric,@pa_from_dt datetime, @pa_to_dt datetime                  
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
select @l_min_trx_dt = min(hst_fr_dt) from archival_details 
select @l_base_hldg_dt = min(dphmcd_holding_dt) from vw_holding_base_all
end 
else 
begin 

set @l_min_trx_dt = 'aug 01 2011'
set @l_base_hldg_dt = 'jul 31 2011'


end 

      
select distinct cdshm_id,cdshm_tras_dt,cdshm_isin,cdshm_dpam_id , cdshm_trans_no  ,cdshm_trans_cdas_code        
into #tempdata_cdsl             
from dmat_archival.citrus_usr.cdsl_holding_dtls where cdshm_ben_acct_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to                
and cdshm_dpm_id =  @pa_dpm_id      and cdshm_tras_dt >='aug 01 2013'        
and cdshm_tras_dt between @pa_from_dt and @pa_to_dt              
and cdshm_tratm_cd in ('2246','2277','2201','3102','2270','2220','2205')    --'2280'   -- added on may 31 2012 2205  
--and cdshm_tratm_cd in('2246','2277','2201','2205','2220','3102','2252','2270','2280','2262','2251','3202','2202','2212')         
                  
              
               
              
create index ix_1 on #tempdata_cdsl(cdshm_tras_dt,cdshm_isin,cdshm_dpam_id)              
              
              
                  
select b.cdshm_id v_cdshm_id ,b.cdshm_tras_dt,a.CDSHM_DPM_ID v_CDSHM_DPM_ID                   
,a.CDSHM_DPAM_ID  v_CDSHM_DPAM_ID                  
,a.CDSHM_ISIN v_CDSHM_ISIN                  
,case when  sum(isnull(a.cdshm_qty,0)) + isnull(dphmcd_free_qty,0)    < 0 then 0 else       
       sum(isnull(a.cdshm_qty,0)) + isnull(dphmcd_free_qty,0)          end       
OB      -- ,b.CDSHM_TRANS_NO     v_CDSHM_TRANS_NO          
from dmat_archival.citrus_usr.cdsl_holding_dtls   a left outer join vw_holding_base_all                   
on dphmcd_dpam_id = a.cdshm_dpam_id                   
and dphmcd_dpm_id = a.cdshm_dpm_id                  
and dphmcd_isin = a.cdshm_isin                   
and dphmcd_holding_dt = @l_base_hldg_dt               
,#tempdata_cdsl b              
where a.cdshm_tratm_cd in ('2246','2277','2201','3102','2270','2220','2205')   --'2280',  added 2205     
--where a.cdshm_tratm_cd in('2246','2277','2201','2205','2220','3102','2252','2270','2280','2262','2251','3202','2202','2212')         
and a.cdshm_ben_acct_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to                  
and a.cdshm_dpm_id = @pa_dpm_id                  
and a.cdshm_tras_dt <= b.cdshm_tras_dt              
and a.cdshm_tras_dt >= @l_min_trx_dt
and case when a.cdshm_tras_dt = b.cdshm_tras_dt   then     a.cdshm_id else 0 end < case when a.cdshm_tras_dt = b.cdshm_tras_dt   then    b.cdshm_id  else 1 end         
--and case when a.cdshm_tras_dt = b.cdshm_tras_dt   then     convert(datetime, case when citrus_usr.fn_splitval_by(substring(a.cdshm_trans_cdas_code,CHARINDEX('D', a.cdshm_trans_cdas_code),len(a.cdshm_trans_cdas_code)),16,'~') <> '' then substring(citrus_usr.fn_splitval_by(substring(a.cdshm_trans_cdas_code,CHARINDEX('D', a.cdshm_trans_cdas_code),len(a.cdshm_trans_cdas_code)),16,'~'),5,4)+'-'
--+substring(citrus_usr.fn_splitval_by(substring(a.cdshm_trans_cdas_code,CHARINDEX('D', a.cdshm_trans_cdas_code),len(a.cdshm_trans_cdas_code)),16,'~'),3,2)
--+'-'+substring(citrus_usr.fn_splitval_by(substring(a.cdshm_trans_cdas_code,CHARINDEX('D', a.cdshm_trans_cdas_code),len(a.cdshm_trans_cdas_code)),16,'~'),1,2)
--+ ' ' + 
--replace(
--substring(citrus_usr.fn_splitval_by(substring(a.cdshm_trans_cdas_code,CHARINDEX('D', a.cdshm_trans_cdas_code),len(a.cdshm_trans_cdas_code)),16,'~'),9,2)
--+':'+substring(citrus_usr.fn_splitval_by(substring(a.cdshm_trans_cdas_code,CHARINDEX('D', a.cdshm_trans_cdas_code),len(a.cdshm_trans_cdas_code)),16,'~'),11,2)+':'+substring(citrus_usr.fn_splitval_by(substring(a.cdshm_trans_cdas_code,CHARINDEX('D', a.cdshm_trans_cdas_code),len(a.cdshm_trans_cdas_code)),16,'~'),13,2)
--, '00:00:00', '23:59:59')
--
--
--else substring(citrus_usr.fn_splitval_by(substring(a.cdshm_trans_cdas_code,CHARINDEX('D', a.cdshm_trans_cdas_code),len(a.cdshm_trans_cdas_code)),9,'~'),5,4)+'-'
--+substring(citrus_usr.fn_splitval_by(substring(a.cdshm_trans_cdas_code,CHARINDEX('D', a.cdshm_trans_cdas_code),len(a.cdshm_trans_cdas_code)),9,'~'),3,2)
--+'-'+substring(citrus_usr.fn_splitval_by(substring(a.cdshm_trans_cdas_code,CHARINDEX('D', a.cdshm_trans_cdas_code),len(a.cdshm_trans_cdas_code)),9,'~'),1,2)
--+ ' ' + 
--replace(
--substring(citrus_usr.fn_splitval_by(substring(a.cdshm_trans_cdas_code,CHARINDEX('D', a.cdshm_trans_cdas_code),len(a.cdshm_trans_cdas_code)),9,'~'),9,2)
--+':'+substring(citrus_usr.fn_splitval_by(substring(a.cdshm_trans_cdas_code,CHARINDEX('D', a.cdshm_trans_cdas_code),len(a.cdshm_trans_cdas_code)),9,'~'),11,2)+':'+substring(citrus_usr.fn_splitval_by(substring(a.cdshm_trans_cdas_code,CHARINDEX('D', a.cdshm_trans_cdas_code),len(a.cdshm_trans_cdas_code)),9,'~'),13,2)
--, '00:00:00', '23:59:59') end ) else 'jan 01 1900' end < case when a.cdshm_tras_dt = b.cdshm_tras_dt   then   convert(datetime, case when citrus_usr.fn_splitval_by(substring(b.cdshm_trans_cdas_code,CHARINDEX('D', b.cdshm_trans_cdas_code),len(b.cdshm_trans_cdas_code)),16,'~') <> '' then substring(citrus_usr.fn_splitval_by(substring(b.cdshm_trans_cdas_code,CHARINDEX('D', b.cdshm_trans_cdas_code),len(b.cdshm_trans_cdas_code)),16,'~'),5,4)+'-'
--+substring(citrus_usr.fn_splitval_by(substring(a.cdshm_trans_cdas_code,CHARINDEX('D', a.cdshm_trans_cdas_code),len(b.cdshm_trans_cdas_code)),16,'~'),3,2)
--+'-'+substring(citrus_usr.fn_splitval_by(substring(a.cdshm_trans_cdas_code,CHARINDEX('D', a.cdshm_trans_cdas_code),len(b.cdshm_trans_cdas_code)),16,'~'),1,2)
--+ ' ' + 
--replace(
--substring(citrus_usr.fn_splitval_by(substring(b.cdshm_trans_cdas_code,CHARINDEX('D', b.cdshm_trans_cdas_code),len(b.cdshm_trans_cdas_code)),16,'~'),9,2)
--+':'+substring(citrus_usr.fn_splitval_by(substring(b.cdshm_trans_cdas_code,CHARINDEX('D', b.cdshm_trans_cdas_code),len(b.cdshm_trans_cdas_code)),16,'~'),11,2)+':'+substring(citrus_usr.fn_splitval_by(substring(b.cdshm_trans_cdas_code,CHARINDEX('D', b.cdshm_trans_cdas_code),len(b.cdshm_trans_cdas_code)),16,'~'),13,2)
--, '00:00:00', '23:59:59')
--
--
--else substring(citrus_usr.fn_splitval_by(substring(b.cdshm_trans_cdas_code,CHARINDEX('D', b.cdshm_trans_cdas_code),len(b.cdshm_trans_cdas_code)),9,'~'),5,4)+'-'
--+substring(citrus_usr.fn_splitval_by(substring(b.cdshm_trans_cdas_code,CHARINDEX('D', b.cdshm_trans_cdas_code),len(b.cdshm_trans_cdas_code)),9,'~'),3,2)
--+'-'+substring(citrus_usr.fn_splitval_by(substring(b.cdshm_trans_cdas_code,CHARINDEX('D', b.cdshm_trans_cdas_code),len(b.cdshm_trans_cdas_code)),9,'~'),1,2)
--+ ' ' + 
--replace(
--substring(citrus_usr.fn_splitval_by(substring(a.cdshm_trans_cdas_code,CHARINDEX('D', b.cdshm_trans_cdas_code),len(b.cdshm_trans_cdas_code)),9,'~'),9,2)
--+':'+substring(citrus_usr.fn_splitval_by(substring(a.cdshm_trans_cdas_code,CHARINDEX('D', b.cdshm_trans_cdas_code),len(b.cdshm_trans_cdas_code)),9,'~'),11,2)+':'+substring(citrus_usr.fn_splitval_by(substring(b.cdshm_trans_cdas_code,CHARINDEX('D', b.cdshm_trans_cdas_code),len(b.cdshm_trans_cdas_code)),9,'~'),13,2)
--, '00:00:00', '23:59:59') end ) else 'jan 02 1900' end 
and a.cdshm_dpam_id = b.cdshm_dpam_id               
and a.cdshm_isin = b.cdshm_isin 
group by a.CDSHM_DPM_ID                   
,a.CDSHM_DPAM_ID                    
,a.CDSHM_ISIN               
,b.cdshm_tras_dt   
-- , b.CDSHM_TRANS_NO    
, isnull(dphmcd_free_qty,0)
,b.cdshm_id       
                  
                  
                  
end

GO
