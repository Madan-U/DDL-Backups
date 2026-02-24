-- Object: PROCEDURE citrus_usr.PR_SEBI_DATA
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--CREATE TABLE TEMPDATA_DATE (YEAR NUMERIC,MONTH NUMERIC, QTR NUMERIC)

----MAKE A INSERT SCRIPT OF ABOVE TABLE 



--CREATE TABLE fINALDATAFOR_qTR_sEBI(YEAR NUMERIC,MONTH NUMERIC, QTR NUMERIC, DPID VARCHAR(16), NAME VARCHAR(1000)

--,AMCCHARGE NUMERIC(18,3),NOOFACCT NUMERIC,TRXCHARGE NUMERIC(18,3),NOOFTRX NUMERIC, OTHERS VARCHAR(1000))



CREATE PROC [citrus_usr].[PR_SEBI_DATA]

AS

BEGIN 

TRUNCATE TABLE fINALDATAFOR_qTR_sEBI





INSERT INTO fINALDATAFOR_qTR_sEBI 



SELECT A.*,DPM_DPID,DPM_NAME , 0,0,0,0,0 FROM DP_MSTR , TEMPDATA_DATE A 

WHERE default_dp = DPM_EXCSM_ID 





select year(CLIC_TRANS_DT )  [year]

, MONTH(CLIC_TRANS_DT )   [month] ,dpam_dpm_id clic_dpm_id

, count(ISNULL(clic_dpam_id,0)) NOOFACCOUNT

, sum(ISNULL(clic_charge_amt,0)*-1)   AMCAMOUNT

INTO #AMCDATA from tempdata_monthly   with (NoLock) , dp_Acct_mstr   with (NoLock)
where clic_dpam_id = dpam_id 
--where exists(select 1 from charge_mstr where cham_slab_name = clic_charge_name 

--and cham_slab_name not like '%admin%' and CHAM_CHARGE_TYPE in ('F','O','AMCPRO'))

group by dpam_dpm_id,year(CLIC_TRANS_DT ) ,MONTH(CLIC_TRANS_DT ) 





UPDATE A SET AMCCHARGE = AMCAMOUNT

--,NOOFACCT =NOOFACCOUNT  

FROM fINALDATAFOR_qTR_sEBI A , #AMCDATA AMC, DP_MSTR WHERE   clic_dpm_id = DPM_ID AND DPM_DPID = DPID 

AND AMC.[year] = A.YEAR 

AND AMC.MONTH = A.MONTH


--select dpam_dpm_id , dpam_id,accp_value,isnull(accp_value_cl,'dec 31 2100') closedate into #tempdataclose
--from dp_Acct_mstr , #account_properties accopen 
--left outer join #account_properties_close on accp_clisba_id = accp_clisba_id_cl
--WHERE  dpam_id = accp_clisba_id 


select dpam_dpm_id , dpam_id ,convert(datetime,case when boactdt<> '' then substring(boactdt , 5,8) +'-'
+substring(boactdt , 3,2)+'-'+substring(boactdt , 1,2)   else  '1900-01-01' end) boactdt
,convert(datetime,case when ClosAppDt<> '' then substring(ClosAppDt , 5,8) +'-'
+substring(ClosAppDt , 3,2)+'-'+substring(ClosAppDt , 1,2)   else  '2100-01-01' end)  closedate  into #tempdataclose
from dps8_pc1 ,dp_Acct_mstr where boid = dpam_sba_no 
--and ClosAppDt<> ''



select DPID , month,year,(select count(dpam_id)  from #tempdataclose,dp_mstr where dpm_id = dpam_dpm_id and 
closedate > [dbo].[udf_GetLastDayOfMonth](convert(datetime,'01/'+convert(varchar,month)+'/'+ convert(varchar,year),103))
and boactdt < [dbo].[udf_GetLastDayOfMonth](convert(datetime,'01/'+convert(varchar,month)+'/'+ convert(varchar,year),103))
and dpm_dpid = DPID
) activeacct into #tempactive
from fINALDATAFOR_qTR_sEBI


UPDATE A SET NOOFACCT =activeacct  
FROM fINALDATAFOR_qTR_sEBI A , #tempactive act where 
 act.[year] = A.YEAR 
AND act.MONTH = A.MONTH and a.DPID= act.DPID


--UPDATE A SET AMCCHARGE = AMCAMOUNT

--,NOOFACCT =NOOFACCOUNT  

--FROM fINALDATAFOR_qTR_sEBI A  with (NoLock) , #AMCDATA AMC, DP_MSTR  with (NoLock) 
--WHERE   clic_dpm_id = DPM_ID AND DPM_DPID = DPID 

--AND AMC.[year] = A.YEAR 

--AND AMC.MONTH = A.MONTH



SELECT CDSHM_TRAS_DT,CDSHM_ISIN,  ABS(CDSHM_QTY) CDSHM_QTY, CDSHM_DPAM_ID , CDSHM_DPM_ID ,CDSHM_CHARGE
,(select top 1 CLOPM_CDSL_RT   td_rate  
 from closing_price_mstr_cdsl with (NoLock) where CLOPM_ISIN_CD = CDSHM_ISIN AND clopm_dt <= CDSHM_TRAS_DT 
 order by clopm_dt desc) RATE
INTO #TEMPTRX from cdsl_holding_dtls   with (NoLock) where CDSHM_CDAS_TRAS_TYPE in (1,2,3,4,5)
AND CDSHM_CHARGE <> 0
and CDSHM_TRATM_CD ='2277' 



insert into #TEMPTRX
SELECT CDSHM_TRAS_DT,CDSHM_ISIN,  ABS(CDSHM_QTY) CDSHM_QTY, CDSHM_DPAM_ID , CDSHM_DPM_ID ,CDSHM_CHARGE
,(select top 1 CLOPM_CDSL_RT   td_rate  
 from closing_price_mstr_cdsl with (NoLock) where CLOPM_ISIN_CD = CDSHM_ISIN AND clopm_dt <= CDSHM_TRAS_DT order by clopm_dt desc) RATE
 from Dmat_Archival.citrus_usr.cdsl_holding_dtls  with (NoLock) where CDSHM_CDAS_TRAS_TYPE in (1,2,3,4,5)
AND CDSHM_CHARGE <> 0
and CDSHM_TRATM_CD ='2277' 
--and CDSHM_TRAS_DT between 'dec 01 2017' and 'dec 31 2017'


select  year(CDSHM_TRAS_DT ) [year]

,  MONTH(CDSHM_TRAS_DT ) [MONTH]  ,CDSHM_DPM_ID

, count(1)  NOOFTRX

, sum(cdshm_charge*-1) CHARGEAMT , SUM(CDSHM_QTY*RATE) VALUATION INTO #TRX from #TEMPTRX 
group by CDSHM_DPM_ID, YEAR(CDSHM_TRAS_DT ) , MONTH(CDSHM_TRAS_DT ) 





UPDATE A SET TRXCHARGE = TRX.CHARGEAMT

,NOOFTRX = TRX.NOOFTRX, OTHERS  =  CONVERT(NUMERIC(18,2),VALUATION)

FROM fINALDATAFOR_qTR_sEBI A  with (NoLock) , #TRX TRX, DP_MSTR  with (NoLock) WHERE   CDSHM_DPM_ID = DPM_ID AND DPM_DPID = DPID 

AND TRX.[year] = A.YEAR 

AND TRX.MONTH = A.MONTH





SELECT [YEAR],MONTH ,DPID,NAME

,AMCCHARGE AMCCHARGE

,NOOFACCT NOOFACCT

,TRXCHARGE  TRXCHARGE

,NOOFTRX NOOFTRX , OTHERS VALUATION

 FROM fINALDATAFOR_qTR_sEBI 

 WHERE (AMCCHARGE) <> 0 OR (NOOFACCT) <>0  OR (TRXCHARGE)<>0 OR (NOOFTRX) <>0

 ORDER BY YEAR,DPID,month







END

GO
