-- Object: PROCEDURE citrus_usr.pr_getrmtcnfpnd
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--exec citrus_usr.pr_getrmtcnfpnd 3,'mar 31 2012','mar 31 2012','0','9999999999999999','',''    
CREATE proc [citrus_usr].[pr_getrmtcnfpnd](@pa_dpm_id numeric,@pa_from_dt datetime, @pa_to_dt datetime                        
,@pa_ben_acct_no_fr varchar(16),@pa_ben_acct_no_to varchar(16),@pa_isin varchar(20),@pa_out varchar(100) out)
as
begin

 
select dphmcd_dpam_id,dphmcd_isin ,sum(DPHMCD_REMAT_PND_CONF_QTY) qty ,'' trans_no  
into #holdingdmtpenfing from  dp_daily_hldg_cdsl, DP_aCCT_MSTR 
where DPHMCD_DPAM_ID = DPAM_ID AND dphmcd_holding_dt='jul 31 2011'
and dpam_sba_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to    
and dphmcd_dpm_id = @PA_DPM_ID
AND DPHMCD_ISIN LIKE '%' + @pa_isin 
group by dphmcd_dpam_id,dphmcd_isin 
having sum(DPHMCD_REMAT_PND_CONF_QTY) <> 0 




select cdshm_dpam_id , cdshm_isin , sum(cdshm_qty) qty ,cdshm_trans_no into #trasdmtpenfing  from cdsl_holding_dtls
where CDSHM_TRATM_CD='2205'
and CDSHM_BEN_ACCT_NO between @pa_ben_acct_no_fr and @pa_ben_acct_no_to    
and CDSHM_DPM_ID = @PA_DPM_ID
AND CDSHM_ISIN LIKE '%' + @pa_isin 
And cdshm_tras_dt between 'aug 01 2011' and @PA_TO_DT
group by cdshm_dpam_id,cdshm_isin,cdshm_trans_no



select * 
into #tras 
from cdsl_holding_dtls
where cdshm_tratm_cd in ('2255','2277')
and CDSHM_BEN_ACCT_NO between @pa_ben_acct_no_fr and @pa_ben_acct_no_to    
and CDSHM_DPM_ID = @PA_DPM_ID
AND CDSHM_ISIN LIKE '%' + @pa_isin 
And cdshm_tras_dt between 'aug 01 2011' and @PA_TO_DT
and (CDSHM_CDAS_TRAS_TYPE in ('7','33'))




select CDSHM_TRATM_CD,cdshm_dpam_id , cdshm_isin , cdshm_trans_no,sum(case when  CDSHM_CDAS_SUB_TRAS_TYPE in( '709','703') then cdshm_qty*-1
															else cdshm_qty end ) cdshm_qty
into #trasdmtcnfrej from #tras A 
where cdshm_tratm_cd in ('2255','2277') and CDSHM_CDAS_SUB_TRAS_TYPE IN ('707','709','703','3304','705')
and CDSHM_BEN_ACCT_NO between @pa_ben_acct_no_fr and @pa_ben_acct_no_to    
and CDSHM_DPM_ID = @PA_DPM_ID
AND CDSHM_ISIN LIKE '%' + @pa_isin 
and (CDSHM_CDAS_TRAS_TYPE IN ('33','7'))
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


select a.*,A.QTY-abs(isnull(b.qty,0)) RMATPENDING 
from #finaldmatpen a left outer join #finaldmatcnfrej b
on cdshm_dpam_id = dphmcd_dpam_id 
and cdshm_isin = dphmcd_isin 
and cdshm_trans_no = trans_no


DROP TABLE #holdingdmtpenfing 
DROP TABLE #trasdmtpenfing  
DROP TABLE #tras 
DROP TABLE #trasdmtcnfrej 
DROP TABLE #finaldmatcnfrej 



end

GO
