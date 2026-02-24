-- Object: PROCEDURE citrus_usr.pr_getdmacnfpnd_all
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--exec citrus_usr.pr_getdmacnfpnd 3,'mar 31 2012','mar 31 2012','0','9999999999999999','',''        
CREATE proc [citrus_usr].[pr_getdmacnfpnd_all](@pa_from_dt datetime, @pa_to_dt datetime                            
,@pa_ben_acct_no_fr varchar(16),@pa_ben_acct_no_to varchar(16),@pa_isin varchar(20),@pa_out varchar(100) out)    
as    
begin    
    
     
select dphmcd_dpam_id,dphmcd_isin ,sum(DPHMCD_DEMAT_PND_VER_QTY) qty ,'' trans_no      
into #holdingdmtpenfing from  dp_daily_hldg_cdsl, DP_aCCT_MSTR     
where DPHMCD_DPAM_ID = DPAM_ID AND dphmcd_holding_dt='jul 31 2011'    
and dpam_sba_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to        
--and dphmcd_dpm_id = @PA_DPM_ID    
group by dphmcd_dpam_id,dphmcd_isin     
having sum(DPHMCD_DEMAT_PND_VER_QTY) <> 0     
    
  --  
select cdshm_dpam_id , cdshm_isin , sum(cdshm_qty) qty ,cdshm_trans_no into #trasdmtpenfing  from cdsl_holding_dtls    
--select cdshm_dpam_id , cdshm_isin , sum(case when (cdshm_tratm_cd = '3108' then cdshm_qty* - 1 else cdshm_qty end )  qty ,cdshm_trans_no into #trasdmtpenfing  from cdsl_holding_dtls    
where CDSHM_TRATM_CD in ('2201')   
and CDSHM_BEN_ACCT_NO between @pa_ben_acct_no_fr and @pa_ben_acct_no_to        
--and CDSHM_DPM_ID = @PA_DPM_ID    
And cdshm_tras_dt between 'aug 01 2011' and @PA_TO_DT    
group by cdshm_dpam_id,cdshm_isin,cdshm_trans_no    
    
    
    
select CDSHM_TRATM_CD,cdshm_dpam_id , cdshm_isin , cdshm_trans_no,sum(case when  CDSHM_TRATM_CD = '3102' then cdshm_qty*-1    
               when  CDSHM_TRATM_CD = '2251' then cdshm_qty*-1 else cdshm_qty end ) cdshm_qty    
into #trasdmtcnfrej from cdsl_holding_dtls A     
where (CDSHM_TRATM_CD in ('2246','3102')    
or cdshm_tratm_cd ='2251' and CITRUS_USR.FN_SPLITVAL_BY(SUBSTRING(cdshm_trans_cdas_code,CHARINDEX('D~',cdshm_trans_cdas_code),LEN(cdshm_trans_cdas_code)),7,'~') IN ('607','609'))    
and CDSHM_BEN_ACCT_NO between @pa_ben_acct_no_fr and @pa_ben_acct_no_to        
--and CDSHM_DPM_ID = @PA_DPM_ID    
and (CITRUS_USR.FN_SPLITVAL_BY(SUBSTRING(cdshm_trans_cdas_code,CHARINDEX('D~',cdshm_trans_cdas_code),LEN(cdshm_trans_cdas_code)),2,'~') IN ('32','6'))    
and cdshm_tras_dt between 'aug 01 2011' and @PA_TO_DT    
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
    
--516841 INE115A01026    
    
--DROP TABLE #FINALDEMATHOLDI    
    
select a.*,CASE WHEN CDSHM_ISIN LIKE 'INF%' THEN '0' ELSE A.QTY-isnull(b.qty,0) END DMATPENDING     
from #finaldmatpen a left outer join #finaldmatcnfrej b    
on cdshm_dpam_id = dphmcd_dpam_id     
and cdshm_isin = dphmcd_isin     
and cdshm_trans_no = trans_no   
 
    
end

GO
