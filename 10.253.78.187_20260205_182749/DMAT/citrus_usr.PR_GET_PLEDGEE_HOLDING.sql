-- Object: PROCEDURE citrus_usr.PR_GET_PLEDGEE_HOLDING
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE PROC [citrus_usr].[PR_GET_PLEDGEE_HOLDING](@pa_dpm_id numeric,@pa_from_dt datetime, @pa_to_dt datetime                        
,@pa_ben_acct_no_fr varchar(16),@pa_ben_acct_no_to varchar(16),@pa_out  varchar(8000) out)  
AS
BEGIN 
select dphmcd_dpam_id,dphmcd_isin ,sum(DPHMCD_PLEDGE_QTY) QTY  ,'NORMAL' PLEDGETYPE,'' PLEDGEE
into #holdingdmtpenfing2 from  vw_holding_base_all with (nolock), DP_aCCT_MSTR with (nolock)
where DPHMCD_DPAM_ID = DPAM_ID AND dphmcd_holding_dt=( SELECT max(dphmcd_holding_dt) from vw_holding_base_all)
--AND DPAM_SBA_NO BETWEEN @pa_ben_acct_no_fr AND @pa_ben_acct_no_to 
group by dphmcd_dpam_id,dphmcd_isin 
having sum(DPHMCD_PLEDGE_QTY) <> 0 
PRINT CONVERT(VARCHAR(26), GETDATE(), 109)


select cdshm_dpam_id  ,cdshm_isin 
,case when cdshm_tratm_cd in ('2230','2246') and cdshm_tratm_type_desc = 'PLEDGE' then cdshm_qty 
when cdshm_tratm_cd in ('2280') and cdshm_tratm_type_desc in ('UNPLEDGE','CONFISCATE','AUTO PLEDGE','PLEDGE') then cdshm_qty else 0 end QTY                    
     ,  CASE WHEN  CDSHM_CDAS_SUB_TRAS_TYPE BETWEEN 828 AND 838 THEN 'MARGIN' ELSE  'NORMAL'  END PLEDGETYPE  
     ,           CASE WHEN  CDSHM_CDAS_SUB_TRAS_TYPE BETWEEN 828 AND 838 THEN CDSHM_COUNTER_BOID ELSE  ''  END PLEDGEE 
INTO #TEMPDATA2 from   cdsl_holding_dtls                     with (nolock)
where -- CDSHM_BEN_ACCT_NO  BETWEEN @pa_ben_acct_no_fr AND @pa_ben_acct_no_to  AND 
cdshm_tratm_cd in ('2246','2277','2201','2230','5101','2280')   
and cdshm_tras_dt between (SELECT  min(curr_fr_dt) from archival_details ) and @pa_to_dt
and cdshm_tratm_type_desc in ('UNPLEDGE','CONFISCATE','AUTO PLEDGE','PLEDGE')


select cdshm_dpam_id , cdshm_isin , sum(QTY) qty ,PLEDGETYPE , PLEDGEE into #trasdmtpenfing2  from #TEMPDATA2
group by cdshm_dpam_id,cdshm_isin,PLEDGETYPE, PLEDGEE 


select dphmcd_dpam_id,dphmcd_isin,sum(qty) qty ,PLEDGETYPE, PLEDGEE  into #finaldmatpen2 from (
select dphmcd_dpam_id,dphmcd_isin,qty,PLEDGETYPE , PLEDGEE from #holdingdmtpenfing2
union ALL
select cdshm_dpam_id , cdshm_isin,qty,PLEDGETYPE , PLEDGEE from #trasdmtpenfing2) a 
group by dphmcd_dpam_id,dphmcd_isin,PLEDGETYPE, PLEDGEE
PRINT CONVERT(VARCHAR(26), GETDATE(), 109)

--SELECT * FROM #finaldmatpen2 WHERE QTY > 0 

SELECT PLEDGEE,dphmcd_isin,sum(qty) PLEDGEE_BAL FROM #finaldmatpen2 WHERE QTY > 0 and PLEDGETYPE ='margin' GROUP BY PLEDGEE ,dphmcd_isin

DROP TABLE #holdingdmtpenfing2 
DROP TABLE #trasdmtpenfing2 
DROP TABLE #finaldmatpen2 
DROP TABLE #TEMPDATA2
/*PLEDGE NEW WITH MARGIN PLEDGE*/
/*
SELECT * FROM  #finaldmatpen2  WHERE PLEDGETYPE='NORMAL'
SELECT * FROM  #finaldmatpen2  WHERE PLEDGETYPE='MARGIN'

SELECT  DPHMCD_DPAM_ID, DPHMCD_ISIN,SUM(QTY) FROM #finaldmatpen2 WHERE QTY > 0 GROUP BY DPHMCD_DPAM_ID, DPHMCD_ISIN-- used to update in dump process

SELECT  DPHMCD_DPAM_ID, DPHMCD_ISIN,SUM(DPHMCD_PLEDGE_QTY) FROM holdingallforview  WHERE DPHMCD_PLEDGE_QTY > 0 GROUP BY DPHMCD_DPAM_ID, DPHMCD_ISIN-- current
SELECT  DPHMC_DPAM_ID, DPHMC_ISIN,SUM(DPHMC_PLEDGE_QTY) FROM DP_HLDG_MSTR_CDSL   WHERE DPHMC_PLEDGE_QTY <> 0 AND DPHMC_HOLDING_DT ='AUG 01 2020' -- dpm3 
GROUP BY DPHMC_DPAM_ID, DPHMC_ISIN



461807INE725E010241


selEct * from cdsl_holdinG_DTLS WHERE CDSHM_DPAM_ID = '461807' AND CDSHM_ISIN ='INE725E01024'
ORDER BY 1 DESC 

selEct * from cdsl_holdinG_DTLS WHERE CDSHM_TRAS_DT = '2020-08-03 00:00:00.000'
AND CDSHM_CDAS_TRAS_TYPE = 8 
*/





END

GO
