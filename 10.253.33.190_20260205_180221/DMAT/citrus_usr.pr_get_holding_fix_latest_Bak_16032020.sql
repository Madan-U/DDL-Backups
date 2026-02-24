-- Object: PROCEDURE citrus_usr.pr_get_holding_fix_latest_Bak_16032020
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
      
--exec [pr_get_holding_fix_latest] 3,'MAR 31 2012','MAR 31 2012','0','9999999999999999',''    
--exec [pr_get_holding_fix_latest] 3,'aug 01 2012','aug 01 2012','1201090000004621','1201090000004621',''    
--1201090000025122~INE083C01022    
    ---drop  proc [citrus_usr].[pr_get_holding_fix_latest]
    

    
CREATE proc [citrus_usr].[pr_get_holding_fix_latest_Bak_16032020](@pa_dpm_id numeric,@pa_from_dt datetime, @pa_to_dt datetime                        
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
      
print @l_min_trx_dt   
print @l_base_hldg_dt 


set transaction isolation level read uncommitted  

if exists(select name from sysobjects where name ='holdingall')  
DROP TABLE holdingall  
      
select cdshm_dpm_id DPHMCD_DPM_ID      
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
into #tmp_dp_daily_hldg_cdsl_all from cdsl_holding_dtls      with (nolock)
where  CDSHM_TRAS_DT >= @l_min_trx_dt      
and CDSHM_TRAS_DT <= @pa_to_dt     
and cdshm_dpm_id = @pa_dpm_id      
and cdshm_tratm_cd in ('2246','2277','2201','3102','2270','2220','2205')    
--and cdshm_isin =@pa_isin      
and cdshm_ben_acct_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to 

select distinct * into #tmp_dp_daily_hldg_cdsl from #tmp_dp_daily_hldg_cdsl_all
    
insert into #tmp_dp_daily_hldg_cdsl     
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
from vw_holding_base_all a with (nolock) ,dp_acct_mstr  with (nolock) where dphmcd_holding_dt =@l_base_hldg_dt    
and  dphmcd_dpm_id = @pa_dpm_id    
and dpam_id = dphmcd_dpam_id     
and dpam_sba_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to         
--and dphmcd_isin =@pa_isin      
and not exists(select b.dphmcd_dpam_id,b.dphmcd_isin,b.dphmcd_dpm_id from #tmp_dp_daily_hldg_cdsl b with (nolock) where a.dphmcd_dpm_id = b.dphmcd_dpm_id    
and a.dphmcd_dpam_id = b.dphmcd_dpam_id and a.dphmcd_isin = b.dphmcd_isin)    
                      
     
    
    
--create index ix_1 on #tmp_dp_daily_hldg_cdsl(DPHMCD_DPM_ID,DPHMCD_DPAM_ID,dphmcd_isin)                    
--select * into #dematpendin from cdsl_holding_dtls     with(nolock)     
--WHERE CDSHM_TRAS_DT  >=@l_min_trx_dt and CDSHM_TRAS_DT   <= @pa_to_dt    
--and (cdshm_tratm_cd in ('2246','2277','3102')       or (cdshm_tratm_cd in ('2251') and cdshm_trans_cdas_code like '%~607~%'))
--and   cdshm_ben_acct_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to 
--and cdshm_dpm_id = @pa_dpm_id    
--

SELECT * INTO #TEMPDATA FROM (select cdshm_dpam_id  dphmcd_dpam_id,cdshm_isin dphmcd_isin 
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
from   citrus_usr.cdsl_holding_dtls        with(nolock)                     
where cdshm_tratm_cd in ('2246','2277','2201')   
--and (CITRUS_USR.FN_SPLITVAL_BY(SUBSTRING(cdshm_trans_cdas_code,CHARINDEX('D~',cdshm_trans_cdas_code),LEN(cdshm_trans_cdas_code)),2,'~') NOT IN ('33','7')) 
and   cdshm_ben_acct_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to    
--and   cdshm_isin = @pa_isin              
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
from citrus_usr.vw_holding_base_all with(nolock) ,dp_acct_mstr with(nolock)                      
where DPHMCd_HOLDING_DT =@l_base_hldg_dt    
and dphmcd_dpam_id = dpam_id   
and dphmcd_dpm_id = @pa_dpm_id   
and dpam_sba_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to    
--and dphmcd_isin = @pa_isin    
group by         dphmcd_dpam_id,dphmcd_isin ,dphmcd_dpm_id ) A 
    
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
 ,dphmcd_cntr_settm_id  
into #finalholding   from (                      
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
from #TEMPDATA a      
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
,a.DPHMCD_FREE_QTY= 0--f.DPHMCD_FREE_QTY    
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
from #tmp_dp_daily_hldg_cdsl   a with (nolock), #finalholding f    with (nolock)
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

/*remat calculation */

 
select dphmcd_dpam_id,dphmcd_isin ,sum(DPHMCD_REMAT_PND_CONF_QTY) qty ,'' trans_no  
into #holdingdmtpenfing from  vw_holding_base_all with (nolock), DP_aCCT_MSTR  with (nolock)
where DPHMCD_DPAM_ID = DPAM_ID AND dphmcd_holding_dt=@l_base_hldg_dt
and dpam_sba_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to    
and dphmcd_dpm_id = @PA_DPM_ID
group by dphmcd_dpam_id,dphmcd_isin 
having sum(DPHMCD_REMAT_PND_CONF_QTY) <> 0 




select cdshm_dpam_id , cdshm_isin , sum(cdshm_qty) qty ,cdshm_trans_no into #trasdmtpenfing  from cdsl_holding_dtls with (nolock)
where CDSHM_TRATM_CD='2205'
and CDSHM_BEN_ACCT_NO between @pa_ben_acct_no_fr and @pa_ben_acct_no_to    
and CDSHM_DPM_ID = @PA_DPM_ID

And cdshm_tras_dt between @l_min_trx_dt and @PA_TO_DT
group by cdshm_dpam_id,cdshm_isin,cdshm_trans_no



select * 
into #tras 
from cdsl_holding_dtls with (nolock)
where cdshm_tratm_cd in ('2255','2277')
and CDSHM_BEN_ACCT_NO between @pa_ben_acct_no_fr and @pa_ben_acct_no_to    
and CDSHM_DPM_ID = @PA_DPM_ID

And cdshm_tras_dt between @l_min_trx_dt and @PA_TO_DT
and (CDSHM_CDAS_TRAS_TYPE in ('7','33'))




select CDSHM_TRATM_CD,cdshm_dpam_id , cdshm_isin , cdshm_trans_no,sum(case when  CDSHM_CDAS_SUB_TRAS_TYPE in( '709','703') then cdshm_qty*-1
															else cdshm_qty end ) cdshm_qty
into #trasdmtcnfrej from #tras A with (nolock) 
where cdshm_tratm_cd in ('2255','2277') and CDSHM_CDAS_SUB_TRAS_TYPE IN ('707','709','703','3304','705')
and CDSHM_BEN_ACCT_NO between @pa_ben_acct_no_fr and @pa_ben_acct_no_to    
and CDSHM_DPM_ID = @PA_DPM_ID

and (CDSHM_CDAS_TRAS_TYPE IN ('33','7'))
and cdshm_tras_dt between @l_min_trx_dt and @PA_TO_DT
and (cdshm_trans_no in (select distinct cdshm_trans_no from #trasdmtpenfing B )
OR EXISTS(SELECT DPHMCD_DPAM_ID,DPHMCD_ISIN FROM #holdingdmtpenfing WHERE DPHMCD_DPAM_ID = CDSHM_DPAM_ID 
AND DPHMCD_ISIN = CDSHM_ISIN ))
group by cdshm_dpam_id,cdshm_isin,cdshm_trans_no, cdshm_tratm_cd





update tras set cdshm_trans_no =''
from #trasdmtpenfing tras
where exists(select dphmcd_dpam_id , dphmcd_isin from #holdingdmtpenfing where dphmcd_dpam_id = cdshm_dpam_id and dphmcd_isin = cdshm_isin )


update trascnfrej set cdshm_trans_no =''
from #trasdmtcnfrej trascnfrej
where exists(select dphmcd_dpam_id , dphmcd_isin from #holdingdmtpenfing where dphmcd_dpam_id = cdshm_dpam_id and dphmcd_isin = cdshm_isin )


delete a from #trasdmtcnfrej a
where CDSHM_TRATM_CD ='2255'
and exists(select * from #trasdmtcnfrej b where a.cdshm_dpam_id = b.cdshm_dpam_id 
and a.cdshm_isin = b.cdshm_isin
and a.cdshm_trans_no = b.cdshm_trans_no
and b.CDSHM_TRATM_CD = '2277')

 

select dphmcd_dpam_id,dphmcd_isin,trans_no,sum(qty) qty into #finaldmatpen from (
select dphmcd_dpam_id,dphmcd_isin,qty,trans_no from #holdingdmtpenfing
union ALL
select cdshm_dpam_id , cdshm_isin,qty,cdshm_trans_no from #trasdmtpenfing) a 
group by dphmcd_dpam_id,dphmcd_isin,trans_no

select cdshm_dpam_id , cdshm_isin , cdshm_trans_no ,sum(cdshm_qty) qty 
into #finaldmatcnfrej from #trasdmtcnfrej 
group by cdshm_dpam_id , cdshm_isin , cdshm_trans_no

--SELECT * FROM #finaldmatpen WHERE DPHMCD_ISIN  = 'INE680B01019' AND DPHMCD_DPAM_ID=549859
--SELECT * FROM #finaldmatcnfrej WHERE CDSHM_DPAM_ID = 549859 AND CDSHM_ISIN ='INE680B01019'

--516841	INE115A01026

--DROP TABLE #FINALDEMATHOLDI

insert into #FINALREMTHOLDI
select a.*,A.QTY-abs(isnull(b.qty,0)) RMATPENDING 
 from #finaldmatpen a left outer join #finaldmatcnfrej b
on cdshm_dpam_id = dphmcd_dpam_id 
and cdshm_isin = dphmcd_isin 
and cdshm_trans_no = trans_no

--insert into #FINALREMTHOLDI
--exec citrus_usr.pr_getrmtcnfpnd @pa_dpm_id ,@pa_from_dt , @pa_to_dt,@pa_ben_acct_no_fr ,@pa_ben_acct_no_to ,'' ,''



DROP TABLE #holdingdmtpenfing 
DROP TABLE #trasdmtpenfing  
DROP TABLE #tras 
DROP TABLE #trasdmtcnfrej 
DROP TABLE #finaldmatcnfrej 





--SELECT * FROM #tmp_dp_daily_hldg_cdsl

update a      
set a.DPHMCD_REMAT_PND_CONF_QTY  = case when A.DPHMCD_CURR_QTY <> 0  then RMATPENDING else 0 end   
--, a.DPHMCD_FREE_QTY  = a.DPHMCD_FREE_QTY - case when A.DPHMCD_CURR_QTY = a.DPHMCD_FREE_QTY and a.DPHMCD_FREE_QTY >= RMATPENDING  then RMATPENDING else 0 end   
from #tmp_dp_daily_hldg_cdsl   a , #FINALREMTHOLDI f    
where a.dphmcd_dpam_id= f.dphmcd_dpam_id     
and a.dphmcd_isin = f.dphmcd_isin 
and RMATPENDING <> 0 

--SELECT * FROM #tmp_dp_daily_hldg_cdsl

/*remat calculation */

 /*demat calculation */

create table #FINALDEMATHOLDI
(DPHMCD_DPAM_ID numeric,DPHMCD_ISIN varchar(50),trans_no VARCHAR(100),qty numeric(18,5),DMATPENDING numeric(18,5))


select dphmcd_dpam_id,dphmcd_isin ,sum(DPHMCD_DEMAT_PND_VER_QTY) qty ,'' trans_no  
into #holdingdmtpenfing1 from  vw_holding_base_all with (nolock) , DP_aCCT_MSTR with (nolock)
where DPHMCD_DPAM_ID = DPAM_ID AND dphmcd_holding_dt=@l_base_hldg_dt
and dpam_sba_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to    
and dphmcd_dpm_id = @PA_DPM_ID

group by dphmcd_dpam_id,dphmcd_isin 
having sum(DPHMCD_DEMAT_PND_VER_QTY) <> 0 
PRINT CONVERT(VARCHAR(26), GETDATE(), 109)

select cdshm_dpam_id , cdshm_isin , sum(cdshm_qty  ) qty ,cdshm_trans_no into #trasdmtpenfing1  from cdsl_holding_dtls with (nolock)
where CDSHM_TRATM_CD in ('2201')
and CDSHM_BEN_ACCT_NO between @pa_ben_acct_no_fr and @pa_ben_acct_no_to    
and CDSHM_DPM_ID = @PA_DPM_ID

And cdshm_tras_dt between @l_min_trx_dt and @PA_TO_DT
group by cdshm_dpam_id,cdshm_isin,cdshm_trans_no
PRINT CONVERT(VARCHAR(26), GETDATE(), 109)


select * 
into #tras1 
from cdsl_holding_dtls with (nolock)
WHERE (CDSHM_TRATM_CD in ('2246','3102')
or cdshm_tratm_cd ='2251' and  CDSHM_CDAS_SUB_TRAS_TYPE IN ('607','609'))
and CDSHM_BEN_ACCT_NO between @pa_ben_acct_no_fr and @pa_ben_acct_no_to    
and CDSHM_DPM_ID = @PA_DPM_ID

and (CDSHM_CDAS_TRAS_TYPE IN ('32','6'))
and cdshm_tras_dt between @l_min_trx_dt and @PA_TO_DT
and (cdshm_trans_no in (select distinct cdshm_trans_no from #trasdmtpenfing1 B )
	OR EXISTS(SELECT DPHMCD_DPAM_ID,DPHMCD_ISIN FROM #holdingdmtpenfing1 WHERE DPHMCD_DPAM_ID = CDSHM_DPAM_ID 
AND DPHMCD_ISIN = CDSHM_ISIN ))

PRINT CONVERT(VARCHAR(26), GETDATE(), 109)




select CDSHM_TRATM_CD,cdshm_dpam_id , cdshm_isin , cdshm_trans_no,sum(case when  CDSHM_TRATM_CD = '3102' then cdshm_qty*-1
															when  CDSHM_TRATM_CD = '2251' then cdshm_qty*-1 else cdshm_qty end ) cdshm_qty
into #trasdmtcnfrej1 from #tras1 A 
group by cdshm_dpam_id,cdshm_isin,cdshm_trans_no, cdshm_tratm_cd
PRINT CONVERT(VARCHAR(26), GETDATE(), 109)

update tras1 set cdshm_trans_no =''
from #trasdmtpenfing1 tras1
where exists(select dphmcd_dpam_id , dphmcd_isin from #holdingdmtpenfing1 where dphmcd_dpam_id = cdshm_dpam_id and dphmcd_isin = cdshm_isin )
PRINT CONVERT(VARCHAR(26), GETDATE(), 109)

update trascnfrej1 set cdshm_trans_no =''
from #trasdmtcnfrej1 trascnfrej1
where exists(select dphmcd_dpam_id , dphmcd_isin from #holdingdmtpenfing1 where dphmcd_dpam_id = cdshm_dpam_id and dphmcd_isin = cdshm_isin )
PRINT CONVERT(VARCHAR(26), GETDATE(), 109)

select dphmcd_dpam_id,dphmcd_isin,trans_no,sum(qty) qty into #finaldmatpen1 from (
select dphmcd_dpam_id,dphmcd_isin,qty,trans_no from #holdingdmtpenfing1
union ALL
select cdshm_dpam_id , cdshm_isin,qty,cdshm_trans_no from #trasdmtpenfing1) a 
group by dphmcd_dpam_id,dphmcd_isin,trans_no
PRINT CONVERT(VARCHAR(26), GETDATE(), 109)

select cdshm_dpam_id , cdshm_isin , cdshm_trans_no ,sum(cdshm_qty) qty 
into #finaldmatcnfrej1 from #trasdmtcnfrej1 
group by cdshm_dpam_id , cdshm_isin , cdshm_trans_no
PRINT CONVERT(VARCHAR(26), GETDATE(), 109)
--SELECT * FROM #finaldmatpen WHERE DPHMCD_ISIN  = 'INE680B01019' AND DPHMCD_DPAM_ID=549859
--SELECT * FROM #finaldmatcnfrej WHERE CDSHM_DPAM_ID = 549859 AND CDSHM_ISIN ='INE680B01019'

--516841	INE115A01026

--DROP TABLE #FINALDEMATHOLDI
insert into #FINALDEMATHOLDI
select a.*,CASE WHEN CDSHM_ISIN LIKE 'INF%' THEN '0' ELSE A.QTY-isnull(b.qty,0) END DMATPENDING 
from #finaldmatpen1 a left outer join #finaldmatcnfrej1 b
on cdshm_dpam_id = dphmcd_dpam_id 
and cdshm_isin = dphmcd_isin 
and cdshm_trans_no = trans_no
PRINT CONVERT(VARCHAR(26), GETDATE(), 109)


DROP TABLE #holdingdmtpenfing1 
DROP TABLE #trasdmtpenfing1 
DROP TABLE #tras1 
DROP TABLE #trasdmtcnfrej1 
DROP TABLE #finaldmatcnfrej1 
--insert into #FINALDEMATHOLDI
--exec citrus_usr.pr_getdmacnfpnd @pa_dpm_id ,@pa_from_dt , @pa_to_dt,@pa_ben_acct_no_fr ,@pa_ben_acct_no_to ,'' ,''


SELECT DPHMCD_DPAM_ID , DPHMCD_ISIN , SUM(DMATPENDING) pVERQTY INTO  #pVERQTY
FROM #FINALDEMATHOLDI 
WHERE NOT EXISTS(SELECT 1 FROM CDSL_HOLDING_DTLS with (nolock) WHERE CDSHM_DPAM_ID = DPHMCD_DPAM_ID AND DPHMCD_ISIN = CDSHM_ISIN 
AND CDSHM_TRAS_DT < =@PA_TO_DT AND CDSHM_TRATM_cD = '2202' AND CDSHM_TRANS_NO = TRANS_NO)
AND DMATPENDING <> 0
GROUP BY  DPHMCD_DPAM_ID , DPHMCD_ISIN
HAVING SUM(DMATPENDING) <> 0

update a      
set a.DPHMCD_DEMAT_PND_VER_QTY  = pVERQTY   
from #tmp_dp_daily_hldg_cdsl   a , #pVERQTY f    
where a.dphmcd_dpam_id= f.dphmcd_dpam_id     
and a.dphmcd_isin = f.dphmcd_isin 



SELECT DPHMCD_DPAM_ID , DPHMCD_ISIN , SUM(DMATPENDING) pCONVERQTY INTO  #pCONVERQTY
FROM #FINALDEMATHOLDI 
WHERE EXISTS(SELECT 1 FROM CDSL_HOLDING_DTLS with (nolock) WHERE CDSHM_DPAM_ID = DPHMCD_DPAM_ID AND DPHMCD_ISIN = CDSHM_ISIN 
AND CDSHM_TRAS_DT < =@PA_TO_DT AND CDSHM_TRATM_cD = '2202' AND CDSHM_TRANS_NO = TRANS_NO)
AND DMATPENDING <> 0
GROUP BY  DPHMCD_DPAM_ID , DPHMCD_ISIN
HAVING SUM(DMATPENDING) <> 0

--update a      
--set a.DPHMCD_DEMAT_PND_CONF_QTY  = pCONVERQTY   
--from #tmp_dp_daily_hldg_cdsl   a , #pCONVERQTY f    
--where a.dphmcd_dpam_id= f.dphmcd_dpam_id     
--and a.dphmcd_isin = f.dphmcd_isin 
/*tushar dmeat peding confirmation qty*/



 /*demat calculation */


/*PLEDGE QTY*/


 --593918	INE749A01030
select dphmcd_dpam_id,dphmcd_isin ,sum(DPHMCD_PLEDGE_QTY) QTY 
into #holdingdmtpenfing2 from  vw_holding_base_all with (nolock), DP_aCCT_MSTR with (nolock)
where DPHMCD_DPAM_ID = DPAM_ID AND dphmcd_holding_dt=@l_base_hldg_dt
group by dphmcd_dpam_id,dphmcd_isin 
having sum(DPHMCD_PLEDGE_QTY) <> 0 
PRINT CONVERT(VARCHAR(26), GETDATE(), 109)



select cdshm_dpam_id  ,cdshm_isin 
,case when cdshm_tratm_cd in ('2230','2246') and cdshm_tratm_type_desc = 'PLEDGE' then cdshm_qty 
when cdshm_tratm_cd in ('2280') and cdshm_tratm_type_desc in ('UNPLEDGE','CONFISCATE','AUTO PLEDGE','PLEDGE') then cdshm_qty else 0 end QTY                    
                  
INTO #TEMPDATA2 from   cdsl_holding_dtls                     with (nolock)
where cdshm_tratm_cd in ('2246','2277','2201','2230','5101','2280')   
and cdshm_tras_dt between @l_min_trx_dt and @PA_TO_DT
and cdshm_ben_acct_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to 

and cdshm_tratm_type_desc in ('UNPLEDGE','CONFISCATE','AUTO PLEDGE','PLEDGE')

select cdshm_dpam_id , cdshm_isin , sum(QTY) qty into #trasdmtpenfing2  from #TEMPDATA2
group by cdshm_dpam_id,cdshm_isin

PRINT CONVERT(VARCHAR(26), GETDATE(), 109)


select dphmcd_dpam_id,dphmcd_isin,sum(qty) qty into #finaldmatpen2 from (
select dphmcd_dpam_id,dphmcd_isin,qty from #holdingdmtpenfing2
union ALL
select cdshm_dpam_id , cdshm_isin,qty from #trasdmtpenfing2) a 
group by dphmcd_dpam_id,dphmcd_isin
PRINT CONVERT(VARCHAR(26), GETDATE(), 109)





update a      
set a.DPHMCD_PLEDGE_QTY  = case when QTY >= 0 then QTY       else 0 end   
from #tmp_dp_daily_hldg_cdsl   a , #finaldmatpen2 f    
where a.dphmcd_dpam_id= f.dphmcd_dpam_id     
and a.dphmcd_isin = f.dphmcd_isin 


DROP TABLE #holdingdmtpenfing2 
DROP TABLE #trasdmtpenfing2 
DROP TABLE #finaldmatpen2 
DROP TABLE #TEMPDATA2




/*PLEDGE QTY*/

--update a set DPHMCD_LOCKIN_QTY  = DPHMCD_LOCKIN_QTY - isnull(DPHMCD_REMAT_PND_CONF_QTY ,0)
--from   #tmp_dp_daily_hldg_cdsl   a
--where DPHMCD_LOCKIN_QTY <> 0 
--and   DPHMCD_REMAT_PND_CONF_QTY <> 0 
--


SELECT CDSHM_DPAM_ID , CDSHM_ISIN , SUM(CDSHM_QTY) QTY into #locindata_cr FROM CDSL_HOLDING_DTLS with (nolock) WHERE 
CDSHM_TRATM_cD IN ('2212','2211') --,'2211'
and CDSHM_TRAS_DT between  @l_min_trx_dt and @pa_to_dt
and cdshm_ben_acct_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to 

--AND CDSHM_CDAS_TRAS_TYPE IN ('12','20','21','22','23','14') --'12' -- 20 added by tushar on jul 16 2012
AND CDSHM_CDAS_TRAS_TYPE IN ('12','20','21','22','23','14'
,'18','8','9','14','29','32','326','6','3','2') --'12' -- 20 added by tushar on jul 16 2012

GROUP BY CDSHM_DPAM_ID ,  CDSHM_ISIN 

update a set DPHMCD_LOCKIN_QTY = DPHMCD_LOCKIN_QTY + qty from #locindata_cr , #tmp_dp_daily_hldg_cdsl  a
where dphmcd_dpam_id = cdshm_dpam_id 
and dphmcd_isin = cdshm_isin 

--SELECT CDSHM_DPAM_ID , CDSHM_ISIN , SUM(CDSHM_QTY) QTY into #locindata_dr FROM CDSL_HOLDING_DTLS 
--WHERE CDSHM_TRATM_cD =case when CDSHM_CDAS_TRAS_TYPE IN ('21','22','23') then '2262' else '2277' end 
--and CDSHM_TRAS_DT between  @l_min_trx_dt and @pa_to_dt
--AND CDSHM_CDAS_TRAS_TYPE IN ('21','22','23','7')
--GROUP BY CDSHM_DPAM_ID ,  CDSHM_ISIN 

  
SELECT CDSHM_DPAM_ID , CDSHM_ISIN , SUM(CDSHM_QTY) QTY into #locindata_dr FROM CDSL_HOLDING_DTLS with (nolock)
WHERE CDSHM_TRATM_cD  in ( '2262','2261') --=case when CDSHM_CDAS_TRAS_TYPE IN ('21','22','23') then '2262' else '2277' end --2261 added by tushar on jun 03 2014
and CDSHM_TRAS_DT between  @l_min_trx_dt and @pa_to_dt
and cdshm_ben_acct_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to 

--AND CDSHM_CDAS_TRAS_TYPE IN ('21','22','23','12')--12 added by tushar on jun 03 2014
AND CDSHM_CDAS_TRAS_TYPE IN ('12','20','21','22','23','14'
,'18','8','9','14','29','32','326','6','3','2') --'12' -- 20 added by tushar on jul 16 2012

GROUP BY CDSHM_DPAM_ID ,  CDSHM_ISIN 


update a set DPHMCD_LOCKIN_QTY = DPHMCD_LOCKIN_QTY + qty from #locindata_dr , #tmp_dp_daily_hldg_cdsl  a
where dphmcd_dpam_id = cdshm_dpam_id 
and dphmcd_isin = cdshm_isin 
and  DPHMCD_LOCKIN_QTY <> 0 


/*sAFE KEEPING */
SELECT CDSHM_DPAM_ID , CDSHM_ISIN , SUM(CDSHM_QTY*-1) QTY into #safedata_dr FROM CDSL_HOLDING_DTLS with (nolock)
WHERE CDSHM_TRATM_cD  in ( '3250') --=case when CDSHM_CDAS_TRAS_TYPE IN ('21','22','23') then '2262' else '2277' end --2261 added by tushar on jun 03 2014
and CDSHM_TRAS_DT between  @l_min_trx_dt and @pa_to_dt
and cdshm_ben_acct_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to 

--AND CDSHM_CDAS_TRAS_TYPE IN ('21','22','23','12')--12 added by tushar on jun 03 2014
GROUP BY CDSHM_DPAM_ID ,  CDSHM_ISIN 



update a set DPHMCD_SAFE_KEEPING_QTY = DPHMCD_SAFE_KEEPING_QTY + QTY 
from #safedata_dr  
, #tmp_dp_daily_hldg_cdsl  a
where dphmcd_dpam_id = cdshm_dpam_id 
and dphmcd_isin = cdshm_isin 



update a set DPHMCD_SAFE_KEEPING_QTY = DPHMCD_SAFE_KEEPING_QTY + qty 
from 
(select cdshm_dpam_id  , cdshm_isin  , sum(qty) qty from 
(select * from #locindata_dr 
union all 
select * from #locindata_Cr ) a group by cdshm_dpam_id  , cdshm_isin ) lockin 
, #tmp_dp_daily_hldg_cdsl  a
where dphmcd_dpam_id = cdshm_dpam_id 
and dphmcd_isin = cdshm_isin 
and  DPHMCD_LOCKIN_QTY = 0 
and DPHMCD_SAFE_KEEPING_QTY <> 0
and DPHMCD_SAFE_KEEPING_QTY + qty   >= 0 
/*sAFE KEEPING */ 

--lockin remat

SELECT CDSHM_DPAM_ID , CDSHM_ISIN , SUM(CDSHM_QTY) QTY into #locindata_dr_remat FROM CDSL_HOLDING_DTLS with (nolock)
WHERE CDSHM_TRATM_cD  = '2262' --=case when CDSHM_CDAS_TRAS_TYPE IN ('21','22','23') then '2262' else '2277' end 
and CDSHM_TRAS_DT between  @l_min_trx_dt and @pa_to_dt
and cdshm_ben_acct_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to 

AND CDSHM_CDAS_TRAS_TYPE = '7'
and CDSHM_CDAS_SUB_TRAS_TYPE = '707'
GROUP BY CDSHM_DPAM_ID ,  CDSHM_ISIN 

update a set DPHMCD_LOCKIN_QTY = DPHMCD_LOCKIN_QTY + qty from #locindata_dr_remat , #tmp_dp_daily_hldg_cdsl  a
where dphmcd_dpam_id = cdshm_dpam_id 
and dphmcd_isin = cdshm_isin 
and  DPHMCD_LOCKIN_QTY <> 0 


--lockin remat

--lockin remat cr

SELECT CDSHM_DPAM_ID , CDSHM_ISIN , SUM(CDSHM_QTY) QTY into #locindata_dr_remat_cr FROM CDSL_HOLDING_DTLS with (nolock)
WHERE CDSHM_TRATM_cD  = '2262' --=case when CDSHM_CDAS_TRAS_TYPE IN ('21','22','23') then '2262' else '2277' end 
and CDSHM_TRAS_DT between  @l_min_trx_dt and @pa_to_dt
and cdshm_ben_acct_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to 

AND CDSHM_CDAS_TRAS_TYPE = '33'
and CDSHM_CDAS_SUB_TRAS_TYPE = '3304'
GROUP BY CDSHM_DPAM_ID ,  CDSHM_ISIN 

update a set DPHMCD_LOCKIN_QTY = DPHMCD_LOCKIN_QTY + qty from #locindata_dr_remat_cr , #tmp_dp_daily_hldg_cdsl  a
where dphmcd_dpam_id = cdshm_dpam_id 
and dphmcd_isin = cdshm_isin 
and  DPHMCD_LOCKIN_QTY <> 0  and DPHMCD_CURR_QTY=0
and DPHMCD_FREE_QTY=0


--lockin remat cr

--avail lending

SELECT CDSHM_DPAM_ID , CDSHM_ISIN , SUM(CDSHM_QTY) QTY into #availlenddata FROM CDSL_HOLDING_DTLS with (nolock)
WHERE CDSHM_TRATM_cD  = '2270' 
and CDSHM_TRAS_DT between  @l_min_trx_dt and @pa_to_dt
and cdshm_ben_acct_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to 

AND CDSHM_CDAS_TRAS_TYPE = '8'
and CDSHM_CDAS_SUB_TRAS_TYPE = '816' 
GROUP BY CDSHM_DPAM_ID ,  CDSHM_ISIN

update a set DPHMCD_AVAIL_LEND_QTY = DPHMCD_AVAIL_LEND_QTY - qty from #availlenddata , #tmp_dp_daily_hldg_cdsl  a
where dphmcd_dpam_id = cdshm_dpam_id 
and dphmcd_isin = cdshm_isin 
and  DPHMCD_AVAIL_LEND_QTY <> 0 and DPHMCD_CURR_QTY=0
and DPHMCD_FREE_QTY=0

--avail lending
    
--update a set DPHMCD_FREE_QTY  = dphmcd_curr_qty - isnull(DPHMCD_REMAT_PND_CONF_QTY ,0) - isnull(DPHMCD_LOCKIN_QTY ,0)
--from   #tmp_dp_daily_hldg_cdsl   a
--where dphmcd_curr_qty <>0 

update a set DPHMCD_FREE_QTY  = dphmcd_curr_qty 
- isnull(DPHMCD_REMAT_PND_CONF_QTY ,0) 
- isnull(DPHMCD_LOCKIN_QTY ,0) - ISNULL(DPHMCD_PLEDGE_QTY,'0')
 - ISNULL(DPHMCD_avail_lend_qty,'0') -ISNULL(DPHMCD_SAFE_KEEPING_QTY,'0') -ISNULL(DPHMCD_LEND_QTY,'0') - 
--ISNULL(DPHMCD_BORROW_QTY,'0') - 
ISNULL(DPHMCD_EARMARK_QTY,'0')    
from   #tmp_dp_daily_hldg_cdsl   a    
where dphmcd_curr_qty <> 0   




update a set DPHMCD_FREE_QTY  = dphmcd_curr_qty 
from   #tmp_dp_daily_hldg_cdsl   a    
where dphmcd_curr_qty <>0     
and DPHMCD_FREEZE_QTY=0
and DPHMCD_PLEDGE_QTY=0
and DPHMCD_DEMAT_PND_VER_QTY=0
and DPHMCD_REMAT_PND_CONF_QTY=0
and DPHMCD_DEMAT_PND_CONF_QTY=0
and DPHMCD_SAFE_KEEPING_QTY=0
and DPHMCD_LOCKIN_QTY=0
and DPHMCD_ELIMINATION_QTY=0
and DPHMCD_EARMARK_QTY=0
and DPHMCD_AVAIL_LEND_QTY=0
and DPHMCD_LEND_QTY=0
and DPHMCD_BORROW_QTY=0

    
update a set DPHMCD_FREE_QTY  = 0   
from   #tmp_dp_daily_hldg_cdsl   a    
where DPHMCD_FREE_QTY < 0 

/**/   
    
--return



select *,@pa_to_dt dphmcd_holding_dt 
into #holdingall 
from #tmp_dp_daily_hldg_cdsl     
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

select * from #holdingall

drop table #holdingall 
drop table #tmp_dp_daily_hldg_cdsl


      
end

GO
