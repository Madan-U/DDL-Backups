-- Object: PROCEDURE citrus_usr.pr_get_holding_fix_byisin_arch
-- Server: 10.253.78.167 | DB: DMAT
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
      
--exec [pr_get_holding_fix] 3,'aug 02 2011','aug 02 2011','1201090000000101','1201090000000101',''    
--exec [pr_get_holding_fix_byisin_test] 3,'jun 01 2012','jun 01 2012','1201090000000101','1201090000000101','INE117A01022',''    
--1201090000025122~INE083C01022    
    
    
    
CREATE proc [citrus_usr].[pr_get_holding_fix_byisin_arch](@pa_dpm_id numeric,@pa_from_dt datetime, @pa_to_dt datetime                        
,@pa_ben_acct_no_fr varchar(16),@pa_ben_acct_no_to varchar(16),@PA_ISIN VARCHAR(50),@pa_out  varchar(8000) out)      
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


      
select distinct cdshm_dpm_id DPHMCD_DPM_ID      
,cdshm_dpam_id  DPHMCD_DPAM_ID        
,cdshm_isin  DPHMCD_ISIN    
,convert(numeric(18,5),0) DPHMCD_CURR_QTY    
,convert(numeric(18,5),0) DPHMCD_FREE_QTY    
,convert(numeric(18,5),0) DPHMCD_FREEZE_QTY    
,convert(numeric(18,5),0) DPHMCD_PLEDGE_QTY    
,convert(numeric(18,5),0) DPHMCD_DEMAT_PND_VER_QTY    
,convert(numeric(18,5),0) DPHMCD_REMAT_PND_CONF_QTY    
,convert(numeric(18,5),0) DPHMCD_DEMAT_PND_CONF_QTY    
,convert(numeric(18,5),0) DPHMCD_SAFE_KEEPING_QTY    
,convert(numeric(18,5),0) DPHMCD_LOCKIN_QTY    
,convert(numeric(18,5),0) DPHMCD_ELIMINATION_QTY    
,convert(numeric(18,5),0) DPHMCD_EARMARK_QTY    
,convert(numeric(18,5),0) DPHMCD_AVAIL_LEND_QTY    
,convert(numeric(18,5),0) DPHMCD_LEND_QTY    
,convert(numeric(18,5),0) DPHMCD_BORROW_QTY    
into #tmp_vw_holding_base_all from dmat_archival.citrus_usr.cdsl_holding_dtls      
where  CDSHM_TRAS_DT >= @l_min_trx_dt      
and CDSHM_TRAS_DT <= @pa_to_dt     
and cdshm_dpm_id = @pa_dpm_id      
and cdshm_tratm_cd in ('2246','2277','2201','3102','2270','2220','2205')    
and cdshm_isin =@pa_isin      
and cdshm_ben_acct_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to        
    
insert into #tmp_vw_holding_base_all     
select distinct dphmcd_dpm_id , dphmcd_dpam_id , dphmcd_isin     
,convert(numeric(18,5),0) DPHMCD_CURR_QTY    
,convert(numeric(18,5),0) DPHMCD_FREE_QTY    
,convert(numeric(18,5),0) DPHMCD_FREEZE_QTY    
,convert(numeric(18,5),0) DPHMCD_PLEDGE_QTY    
,convert(numeric(18,5),0) DPHMCD_DEMAT_PND_VER_QTY    
,convert(numeric(18,5),0) DPHMCD_REMAT_PND_CONF_QTY    
,convert(numeric(18,5),0) DPHMCD_DEMAT_PND_CONF_QTY    
,convert(numeric(18,5),0) DPHMCD_SAFE_KEEPING_QTY    
,convert(numeric(18,5),0) DPHMCD_LOCKIN_QTY    
,convert(numeric(18,5),0) DPHMCD_ELIMINATION_QTY    
,convert(numeric(18,5),0) DPHMCD_EARMARK_QTY    
,convert(numeric(18,5),0) DPHMCD_AVAIL_LEND_QTY    
,convert(numeric(18,5),0) DPHMCD_LEND_QTY    
,convert(numeric(18,5),0) DPHMCD_BORROW_QTY    
from vw_holding_base_all a ,dp_acct_mstr  where dphmcd_holding_dt =@l_base_hldg_dt    
and  dphmcd_dpm_id = @pa_dpm_id    
and dpam_id = dphmcd_dpam_id     
and dpam_sba_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to         
and dphmcd_isin =@pa_isin      
and not exists(select b.dphmcd_dpam_id,b.dphmcd_isin,b.dphmcd_dpm_id from #tmp_vw_holding_base_all b where a.dphmcd_dpm_id = b.dphmcd_dpm_id    
and a.dphmcd_dpam_id = b.dphmcd_dpam_id and a.dphmcd_isin = b.dphmcd_isin)    
                      
     
    
    
--create index ix_1 on #tmp_vw_holding_base_all(DPHMCD_DPM_ID,DPHMCD_DPAM_ID,dphmcd_isin)                    
--select * into #dematpendin from dmat_archival.citrus_usr.cdsl_holding_dtls     with(nolock)     
--WHERE CDSHM_TRAS_DT  >=@l_min_trx_dt and CDSHM_TRAS_DT   <= @pa_to_dt    
--and (cdshm_tratm_cd in ('2246','2277','3102')       or (cdshm_tratm_cd in ('2251') and cdshm_trans_cdas_code like '%~607~%'))
--and   cdshm_ben_acct_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to 
--and cdshm_dpm_id = @pa_dpm_id    
--


    
select dphmcd_dpm_id ,dphmcd_dpam_id , dphmcd_isin                      
,sum(DPHMCD_CURR_QTY) DPHMCD_CURR_QTY           
 ,sum(DPHMCD_FREE_QTY) DPHMCD_FREE_QTY                          
 ,sum(DPHMCD_FREEZE_QTY)   DPHMCD_FREEZE_QTY                        
 ,sum(DPHMCD_PLEDGE_QTY )   DPHMCD_PLEDGE_QTY                        
 ,sum(DPHMCD_DEMAT_PND_VER_QTY)    DPHMCD_DEMAT_PND_VER_QTY                        
 ,sum(DPHMCD_REMAT_PND_CONF_QTY)    DPHMCD_REMAT_PND_CONF_QTY                        
 ,sum(DPHMCD_DEMAT_PND_CONF_QTY)    DPHMCD_DEMAT_PND_CONF_QTY                        
 ,sum(DPHMCD_SAFE_KEEPING_QTY )   DPHMCD_SAFE_KEEPING_QTY                        
 ,sum(DPHMCD_LOCKIN_QTY )   DPHMCD_LOCKIN_QTY                        
 ,sum(DPHMCD_ELIMINATION_QTY)  DPHMCD_ELIMINATION_QTY                        
 ,sum(DPHMCD_EARMARK_QTY)    DPHMCD_EARMARK_QTY                        
 ,sum(DPHMCD_AVAIL_LEND_QTY)    DPHMCD_AVAIL_LEND_QTY                        
 ,sum(DPHMCD_LEND_QTY)   DPHMCD_LEND_QTY                        
 ,sum(DPHMCD_BORROW_QTY)   DPHMCD_BORROW_QTY                        
 ,dphmcd_holding_dt                      
 ,dphmcd_cntr_settm_id  into #finalholding   from (                      
select dphmcd_dpm_id ,dphmcd_dpam_id , dphmcd_isin                      
,DPHMCD_CURR_QTY    
 ,DPHMCD_FREE_QTY    
 ,DPHMCD_FREEZE_QTY    
 ,DPHMCD_PLEDGE_QTY     
 ,0 DPHMCD_DEMAT_PND_VER_QTY    
 ,DPHMCD_REMAT_PND_CONF_QTY    
 ,DPHMCD_DEMAT_PND_CONF_QTY    
 ,DPHMCD_SAFE_KEEPING_QTY     
 ,DPHMCD_LOCKIN_QTY     
 ,DPHMCD_ELIMINATION_QTY    
 ,DPHMCD_EARMARK_QTY    
 ,DPHMCD_AVAIL_LEND_QTY    
 ,DPHMCD_LEND_QTY    
 ,DPHMCD_BORROW_QTY    
 ,@pa_to_dt dphmcd_holding_dt                      
 ,'' dphmcd_cntr_settm_id                      
from (select cdshm_dpam_id  dphmcd_dpam_id,cdshm_isin dphmcd_isin 
,sum(case when cdshm_tratm_cd in ('2246','2277') then cdshm_qty else 0 end)  DPHMCD_CURR_QTY    
,sum(case when cdshm_tratm_cd in ('2246','2277') then cdshm_qty else 0 end)  DPHMCD_FREE_QTY                        
,0 DPHMCD_FREEZE_QTY                        
,0 DPHMCD_PLEDGE_QTY                        
,sum(case when cdshm_tratm_cd in ('2201') then cdshm_qty else 0 end)  DPHMCD_DEMAT_PND_VER_QTY                        
,0 DPHMCD_REMAT_PND_CONF_QTY                        
,0 DPHMCD_DEMAT_PND_CONF_QTY                        
,0 DPHMCD_SAFE_KEEPING_QTY                        
,0 DPHMCD_LOCKIN_QTY                        
,0 DPHMCD_ELIMINATION_QTY                        
,0 DPHMCD_EARMARK_QTY                        
,0 DPHMCD_AVAIL_LEND_QTY                        
,0 DPHMCD_LEND_QTY                        
,0 DPHMCD_BORROW_QTY                        
--,CDSHM_TRG_SETTM_NO  dphmcd_cntr_settm_id                  
,'' dphmcd_cntr_settm_id                  
,cdshm_dpm_id dphmcd_dpm_id , cdshm_trans_no dphmcd_trans_no                     
from   dmat_archival.citrus_usr.cdsl_holding_dtls  with(nolock)                     
where cdshm_tratm_cd in ('2246','2277','2201')   
--and (CITRUS_USR.FN_SPLITVAL_BY(SUBSTRING(cdshm_trans_cdas_code,CHARINDEX('D~',cdshm_trans_cdas_code),LEN(cdshm_trans_cdas_code)),2,'~') NOT IN ('33','7')) 
and   cdshm_ben_acct_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to    
and   cdshm_isin = @pa_isin              
and   CDSHM_TRAS_DT  >=@l_min_trx_dt      
and   CDSHM_TRAS_DT   <= @pa_to_dt 
and cdshm_dpm_id = @pa_dpm_id 
group by         cdshm_dpam_id  ,cdshm_isin  ,cdshm_dpm_id  , cdshm_trans_no     
union  all                     
select dphmcd_dpam_id ,dphmcd_isin
,sum(dphmcd_curr_qty   )             
,sum(DPHMCD_FREE_QTY   )                     
,sum(DPHMCD_FREEZE_QTY       )                 
,sum(DPHMCD_PLEDGE_QTY     )                   
,sum(DPHMCD_DEMAT_PND_VER_QTY  )                      
,sum(DPHMCD_REMAT_PND_CONF_QTY  )                      
,sum(DPHMCD_DEMAT_PND_CONF_QTY  )                      
,sum(DPHMCD_SAFE_KEEPING_QTY  )                      
,sum(DPHMCD_LOCKIN_QTY  )                      
,sum(DPHMCD_ELIMINATION_QTY  )                      
,sum(DPHMCD_EARMARK_QTY )                       
,sum(DPHMCD_AVAIL_LEND_QTY)                        
,sum(DPHMCD_LEND_QTY   )                     
,sum(DPHMCD_BORROW_QTY )                     
,'' dphmcd_cntr_settm_id  ,dphmcd_dpm_id , '' dphmcd_trans_no                     
from citrus_usr.vw_holding_base_all,dp_acct_mstr with(nolock)                      
where DPHMCd_HOLDING_DT =@l_base_hldg_dt    
and dphmcd_dpam_id = dpam_id   
and dphmcd_dpm_id = @pa_dpm_id   
and dpam_sba_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to    
and dphmcd_isin = @pa_isin    
group by         dphmcd_dpam_id,dphmcd_isin ,dphmcd_dpm_id 
    
) a      
) b      
                     
group by dphmcd_dpm_id,dphmcd_holding_dt,dphmcd_dpam_id,dphmcd_isin   ,dphmcd_cntr_settm_id                      
having (sum(dphmcd_curr_qty) <> '0'                        
or sum(DPHMCD_FREE_QTY) <> '0'                        
or sum(DPHMCD_FREEZE_QTY) <> '0'                        
or sum(DPHMCD_PLEDGE_QTY ) <> '0'                        
or sum(DPHMCD_DEMAT_PND_VER_QTY)  <> '0'                        
or sum(DPHMCD_REMAT_PND_CONF_QTY)  <> '0'                        
or sum(DPHMCD_DEMAT_PND_CONF_QTY)  <> '0'                        
or sum(DPHMCD_SAFE_KEEPING_QTY ) <> '0'                        
or sum(DPHMCD_LOCKIN_QTY ) <> '0'                        
or sum(DPHMCD_ELIMINATION_QTY)  <>  '0'                        
or sum(DPHMCD_EARMARK_QTY)  <> '0'                        
or sum(DPHMCD_AVAIL_LEND_QTY)  <> '0'                        
or sum(DPHMCD_LEND_QTY)  <> '0'                        
or sum(DPHMCD_BORROW_QTY)  <> '0')       
      
    
    

    
update a      
set a.DPHMCD_CURR_QTY = f.DPHMCD_CURR_QTY    
,a.DPHMCD_FREE_QTY= f.DPHMCD_FREE_QTY    
,a.DPHMCD_FREEZE_QTY= f.DPHMCD_FREEZE_QTY    
,a.DPHMCD_PLEDGE_QTY= f.DPHMCD_PLEDGE_QTY    
,a.DPHMCD_DEMAT_PND_VER_QTY  = 0   
,a.DPHMCD_REMAT_PND_CONF_QTY= 0  
,a.DPHMCD_DEMAT_PND_CONF_QTY = 0  
,a.DPHMCD_SAFE_KEEPING_QTY= f.DPHMCD_SAFE_KEEPING_QTY    
,a.DPHMCD_LOCKIN_QTY= f.DPHMCD_LOCKIN_QTY    
,a.DPHMCD_ELIMINATION_QTY= f.DPHMCD_ELIMINATION_QTY    
,a.DPHMCD_EARMARK_QTY= f.DPHMCD_EARMARK_QTY    
,a.DPHMCD_AVAIL_LEND_QTY= f.DPHMCD_AVAIL_LEND_QTY    
,a.DPHMCD_LEND_QTY= f.DPHMCD_LEND_QTY    
,a.DPHMCD_BORROW_QTY= f.DPHMCD_BORROW_QTY    
from #tmp_vw_holding_base_all   a , #finalholding f    
where a.dphmcd_dpam_id= f.dphmcd_dpam_id     
and a.dphmcd_dpm_id = f.dphmcd_dpm_id     
and a.dphmcd_isin = f.dphmcd_isin  



/**/
--DROP TABLE #holdingdmtpenfing 
--DROP TABLE #trasdmtpenfing
--DROP TABLE #trasdmtcnfrej
--DROP TABLE #trasdmtpenfing
--DROP TABLE #finaldmatpen
--DROP TABLE #finaldmatcnfrej
--DROP TABLE #FINALDEMATHOLDI


create table #FINALREMTHOLDI
(DPHMCD_DPAM_ID numeric,DPHMCD_ISIN varchar(50),trans_no VARCHAR(100),qty numeric(18,5),RMATPENDING numeric(18,5))


insert into #FINALREMTHOLDI
exec citrus_usr.pr_getrmtcnfpnd @pa_dpm_id ,@pa_from_dt , @pa_to_dt,@pa_ben_acct_no_fr ,@pa_ben_acct_no_to ,@PA_ISIN ,''



update a      
set a.DPHMCD_REMAT_PND_CONF_QTY  = case when A.DPHMCD_CURR_QTY <> 0  then RMATPENDING else 0 end   
, a.DPHMCD_FREE_QTY  = a.DPHMCD_FREE_QTY - case when A.DPHMCD_CURR_QTY = a.DPHMCD_FREE_QTY and a.DPHMCD_FREE_QTY >= RMATPENDING  then RMATPENDING else 0 end   
from #tmp_vw_holding_base_all   a , #FINALREMTHOLDI f    
where a.dphmcd_dpam_id= f.dphmcd_dpam_id     
and a.dphmcd_isin = f.dphmcd_isin 
and RMATPENDING <> 0 






create table #FINALDEMATHOLDI
(DPHMCD_DPAM_ID numeric,DPHMCD_ISIN varchar(50),trans_no VARCHAR(100),qty numeric(18,5),DMATPENDING numeric(18,5))


insert into #FINALDEMATHOLDI
exec citrus_usr.pr_getdmacnfpnd @pa_dpm_id ,@pa_from_dt , @pa_to_dt,@pa_ben_acct_no_fr ,@pa_ben_acct_no_to ,@PA_ISIN ,''


SELECT DPHMCD_DPAM_ID , DPHMCD_ISIN , SUM(DMATPENDING) pVERQTY INTO  #pVERQTY
FROM #FINALDEMATHOLDI 
WHERE NOT EXISTS(SELECT 1 FROM dmat_archival.citrus_usr.cdsl_holding_dtls WHERE CDSHM_DPAM_ID = DPHMCD_DPAM_ID AND DPHMCD_ISIN = CDSHM_ISIN 
AND CDSHM_TRAS_DT < =@PA_TO_DT AND CDSHM_TRATM_cD = '2202' AND CDSHM_TRANS_NO = TRANS_NO)
AND DMATPENDING <> 0
GROUP BY  DPHMCD_DPAM_ID , DPHMCD_ISIN
HAVING SUM(DMATPENDING) <> 0

update a      
set a.DPHMCD_DEMAT_PND_VER_QTY  = pVERQTY   
from #tmp_vw_holding_base_all   a , #pVERQTY f    
where a.dphmcd_dpam_id= f.dphmcd_dpam_id     
and a.dphmcd_isin = f.dphmcd_isin 



SELECT DPHMCD_DPAM_ID , DPHMCD_ISIN , SUM(DMATPENDING) pCONVERQTY INTO  #pCONVERQTY
FROM #FINALDEMATHOLDI 
WHERE EXISTS(SELECT 1 FROM dmat_archival.citrus_usr.cdsl_holding_dtls WHERE CDSHM_DPAM_ID = DPHMCD_DPAM_ID AND DPHMCD_ISIN = CDSHM_ISIN 
AND CDSHM_TRAS_DT < =@PA_TO_DT AND CDSHM_TRATM_cD = '2202' AND CDSHM_TRANS_NO = TRANS_NO)
AND DMATPENDING <> 0
GROUP BY  DPHMCD_DPAM_ID , DPHMCD_ISIN
HAVING SUM(DMATPENDING) <> 0

update a      
set a.DPHMCD_DEMAT_PND_CONF_QTY  = pCONVERQTY   
from #tmp_vw_holding_base_all   a , #pCONVERQTY f    
where a.dphmcd_dpam_id= f.dphmcd_dpam_id     
and a.dphmcd_isin = f.dphmcd_isin 






    




/**/   
    


select *,@pa_to_dt dphmcd_holding_dt from #tmp_vw_holding_base_all     
where     
(dphmcd_curr_qty <> '0'                        
or DPHMCD_FREE_QTY <> '0'                        
or DPHMCD_FREEZE_QTY <> '0'                        
or DPHMCD_PLEDGE_QTY  <> '0'                        
or DPHMCD_DEMAT_PND_VER_QTY  <> '0'                        
or DPHMCD_REMAT_PND_CONF_QTY  <> '0'                        
or DPHMCD_DEMAT_PND_CONF_QTY  <> '0'                        
or DPHMCD_SAFE_KEEPING_QTY  <> '0'                        
or DPHMCD_LOCKIN_QTY <> '0'                        
or DPHMCD_ELIMINATION_QTY  <>  '0'                        
or DPHMCD_EARMARK_QTY  <> '0'                        
or DPHMCD_AVAIL_LEND_QTY  <> '0'                        
or DPHMCD_LEND_QTY  <> '0'                        
or DPHMCD_BORROW_QTY  <> '0') 

    
      
end

GO
