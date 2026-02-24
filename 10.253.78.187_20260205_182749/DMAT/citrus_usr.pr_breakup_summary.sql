-- Object: PROCEDURE citrus_usr.pr_breakup_summary
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE procedure [citrus_usr].[pr_breakup_summary](@pa_from_dt datetime,@pa_to_dt datetime,@pa_login_name varchar(100))
as
begin 

TRUNCATE TABLE cdsl_holding_dtls_bak_forreve
insert into cdsl_holding_dtls_bak_forreve  
select * from CDSL_HOLDING_DTLS with(nolock) where CDSHM_TRAS_DT between @pa_from_dt and @pa_to_dt 
and (CDSHM_TRATM_CD ='2277'   or  CDSHM_CDAS_SUB_TRAS_TYPE in ('1002' ,'810','1103'))
--and CDSHM_BEN_ACCT_NO ='1203320000016304'


select *   into #chargesummary from (
select dpam_sba_no  , brom_desc 
, case when citrus_usr.ufn_countstring(CLIC_CHARGE_NAME,'_') >=1 then citrus_usr.fn_splitval_by(CLIC_CHARGE_NAME ,2 ,'_') else CLIC_CHARGE_NAME end  charge_name 
,SUM(clic_charge_amt) amt 
from client_charges_cdsl with(nolock),dp_acct_mstr  with(nolock) ,client_dp_brkg  with(nolock) ,BROKERAGE_MSTR  with(nolock) 
 where CLIC_TRANS_DT between @pa_from_dt  and @pa_to_dt
and CLIC_CHARGE_NAME not in ('SERVICE TAX'
,'TRANSACTION CHARGES')
and BROM_ID = CLIDB_BROM_ID 
and CLIDB_DPAM_ID= DPAM_ID 
and CLIC_DPAM_ID = DPAM_ID-- and DPAM_SBA_NO ='1203320000016304'
and CLIC_TRANS_DT between clidb_eff_from_dt  and ISNULL(clidb_eff_to_dt ,'dec 31 2100')
group by dpam_sba_no,brom_desc,case when citrus_usr.ufn_countstring(CLIC_CHARGE_NAME,'_') >=1 then citrus_usr.fn_splitval_by(CLIC_CHARGE_NAME ,2 ,'_') else CLIC_CHARGE_NAME end 
union all 
select dpam_sba_no  , brom_desc 
, cdshm_internal_trastm
,SUM(cdshm_charge) amt
from cdsl_holding_dtls  with(nolock) ,dp_acct_mstr  with(nolock) ,client_dp_brkg  with(nolock) ,BROKERAGE_MSTR   with(nolock) 
where cdshm_TRAS_DT between @pa_from_dt and @pa_to_dt
and BROM_ID = CLIDB_BROM_ID 
and CLIDB_DPAM_ID= DPAM_ID 
and CDSHM_DPAM_ID  = DPAM_ID --and DPAM_SBA_NO ='1203320000016304'
and cdshm_tras_dt between clidb_eff_from_dt  and ISNULL(clidb_eff_to_dt ,'dec 31 2100')
group by dpam_sba_no,brom_desc,cdshm_internal_trastm
) a  


declare @l_amount numeric(18,3) 
set @l_amount = 4.25

select boid,cdshm_internal_trastm ,sum(convert(numeric(18,3),AMT)) bill_amt , 'N' flag into #totalcost from (
SELECT boid,@l_amount   AMT ,'OffMkt Settlement Ann 1 **' cdshm_internal_trastm FROM (SELECT cdshm_ben_acct_no BOID 
FROM cdsl_holding_dtls_bak_forreve with (nolock)
where cdshm_tras_dt between @PA_from_DT and @PA_to_DT
AND CDSHM_CDAS_TRAS_TYPE='5'
AND CDSHM_CDAS_SUB_TRAS_TYPE ='521'
and CDSHM_TRATM_CD ='2277'
and CDSHM_INT_REF_NO <>'TRF'
and (isdate(right(CDSHM_INT_REF_NO,4)+'-'+substring( CDSHM_INT_REF_NO,3,2) + '-' + left(CDSHM_INT_REF_NO,2) )=0 or CDSHM_INT_REF_NO like '%/%' ) 
--and not exists (select 1 from dps8_pc1 where boid = cdshm_ben_acct_no and replace(CONVERT(varchar(11),cdshm_tras_dt,103),'/','') = ClosAppDt)
and (case when cdshm_ben_acct_no in (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active')
		 then 8 else len(CDSHM_COUNTER_DPID) end = len(CDSHM_COUNTER_DPID)
--	or cdshm_isin like 'inf%'
and cdshm_isin not in ('INF732E01037')
)
) A

union all
SELECT boid,@l_amount  act_AMT, 'OffMkt Settlement Ann 2 **' dsc FROM (SELECT cdshm_ben_acct_no BOID 
FROM cdsl_holding_dtls_bak_forreve with (nolock)
where cdshm_tras_dt between @PA_from_DT and @PA_to_DT
AND CDSHM_CDAS_SUB_TRAS_TYPE ='305'
and CDSHM_TRATM_CD ='2277'
and (case when cdshm_ben_acct_no in (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active')
		 then 8 else len(CDSHM_COUNTER_DPID) end = len(CDSHM_COUNTER_DPID)
--	or cdshm_isin like 'inf%'
and cdshm_isin not in ('INF732E01037')
)
) B
UNION ALL
select CDSHM_BEN_ACCT_NO,@l_amount  act_AMT,'Early Payin **' dsc from cdsl_holding_dtls_bak_forreve where cdshm_tratm_cd ='2277'
and cdshm_cdas_sub_tras_type ='409'
AND cdshm_tras_dt between @PA_from_DT and @PA_to_DT
and CITRUS_USR.fn_splitval_by(cdshm_trans_cdas_code,34,'~')='31'
and cdshm_isin not in ('INF732E01037')

UNION ALL 

select CDSHM_BEN_ACCT_NO  ,@l_amount  act_AMT ,'OnMkt Settlement **' dsc from cdsl_holding_dtls_bak_forreve
 where cdshm_tratm_cd ='2277'
and cdshm_cdas_sub_tras_type ='109'
AND CDSHM_BEN_ACCT_NO NOT IN (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active')
and cdshm_isin not in ('INF732E01037')
UNION ALL 
SELECT CDSHM_BEN_ACCT_NO ,@l_amount  act_AMT ,'NSCCL **' dsc FROM cdsl_holding_dtls_bak_forreve 
WHERE CDSHM_TRATM_CD ='2277'
AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('107','1503','105')
AND CDSHM_BEN_ACCT_NO NOT IN (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active')
and cdshm_isin not in ('INF732E01037')
--UNION ALL 
--SELECT CDSHM_BEN_ACCT_NO ,@l_amount  act_AMT,'NSCCL **' dsc  FROM cdsl_holding_dtls_bak_forreve 
--WHERE CDSHM_TRATM_CD ='2277'
--AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('107','1503','105')
--AND CDSHM_BEN_ACCT_NO IN (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active')
--AND CDSHM_ISIN LIKE 'INF%'
--and cdshm_isin not in ('INF732E01037')
UNION ALL
SELECT CDSHM_BEN_ACCT_NO ,CONVERT(NUMERIC(18,3),5.5) act_AMT  ,'Remat Charges' dsc
FROM cdsl_holding_dtls_bak_forreve WHERE CDSHM_TRATM_CD ='2277'
AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('707','3304') AND citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,26,'~') <> 'j'
and cdshm_isin not in ('INF732E01037')
and cdshm_isin like 'inF%'
union all
SELECT CDSHM_BEN_ACCT_NO ,CONVERT(NUMERIC(18,3),50) act_AMT  ,'Remat Charges' dsc
FROM cdsl_holding_dtls_bak_forreve WHERE CDSHM_TRATM_CD ='2277'
AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('707','3304') AND citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,26,'~')= 'j'
and cdshm_isin not in ('INF732E01037')
and cdshm_isin like 'inC%'
union all
SELECT CDSHM_BEN_ACCT_NO ,CONVERT(NUMERIC(18,3)
,CEILING(ABS(CDSHM_QTY)/100.00)* CASE WHEN CDSHM_ISIN LIKE 'INC%' THEN 50 ELSE 10 END ) act_AMT  ,'Remat Charges' dsc
FROM cdsl_holding_dtls_bak_forreve WHERE CDSHM_TRATM_CD ='2277'
AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('707','3304') AND citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,26,'~') <> 'j'
and cdshm_isin not in ('INF732E01037')
and cdshm_isin not like 'inc%'
and cdshm_isin not like 'inF%'
UNION ALL
SELECT CDSHM_BEN_ACCT_NO 
--,citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,26,'~'),ABS(CDSHM_QTY), citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,21,'~'), CONVERT(NUMERIC(18,3),CEILING(ABS(CDSHM_QTY)/100.00)*10) AMT  
,CONVERT(NUMERIC(18,3),CASE WHEN ABS(convert(numeric,CDSHM_QTY))/CASE WHEN  citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,21,'~') ='0' THEN  ABS(CDSHM_QTY) ELSE  citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,21,'~') END = 1 THEN  CONVERT(NUMERIC(18,3),CEILING(ABS(CDSHM_QTY)/100.00)*CASE WHEN CDSHM_ISIN LIKE 'INC%' THEN 50 ELSE 10 END)  
ELSE ABS(CDSHM_QTY)/CASE WHEN  citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,21,'~') ='0' THEN  ABS(CDSHM_QTY) ELSE  citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,21,'~') END * CASE WHEN CDSHM_ISIN LIKE 'INC%' THEN 50 ELSE 10 END  END ) act_AMT
,'Remat Charges' dsc
FROM cdsl_holding_dtls_bak_forreve WHERE CDSHM_TRATM_CD ='2277'
AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('707','3304') AND citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,26,'~') = 'J'
and cdshm_isin not in ('INF732E01037')
and cdshm_isin not like 'inc%'
and cdshm_isin not like 'inF%'
UNION ALL 
SELECT CDSHM_BEN_ACCT_NO , '12' act_AMT,'Pledge' dsc FROM cdsl_holding_dtls_bak_forreve WHERE CDSHM_CDAS_SUB_TRAS_TYPE in ('810')
and cdshm_isin not in ('INF732E01037')
UNION ALL
SELECT CDSHM_BEN_ACCT_NO, '12' act_AMT ,'Pledge' dsc FROM cdsl_holding_dtls_bak_forreve WHERE CDSHM_CDAS_SUB_TRAS_TYPE in ('1002','1103')
and cdshm_isin not in ('INF732E01037')

) a 
group by boid,cdshm_internal_trastm


select pc1.DPAM_SBA_NO 
,  brom.brom_desc 
,  isnull(charge_name ,'') charge_name 
,  isnull(amt,0) amt
,  isnull(amt*0.1400,0.0000) service_tax_amt
, convert(numeric(18,3),'0') dp_charge  into #final 
from dp_acct_mstr pc1 with(nolock) left outer join #chargesummary summ on pc1.DPAM_SBA_NO = summ.dpam_sba_no 
,CLIENT_DP_BRKG with(nolock)
,BROKERAGE_MSTR brom with(nolock)
where CLIDB_DPAM_ID = DPAM_ID 
and CLIDB_BROM_ID = BROM_ID 
and @pa_to_dt between clidb_eff_from_dt and ISNULL(clidb_eff_to_dt ,'dec 31 2100')
and CLIDB_DELETED_IND = 1 


update a set dp_charge = bill_amt 
from #final a , #totalcost where boid = DPAM_SBA_NO
and charge_name = cdshm_internal_trastm


update b   set  flag  = 'Y'
from #final a , #totalcost b where boid = DPAM_SBA_NO
and charge_name = cdshm_internal_trastm



insert into #final 
select boid , '',cdshm_internal_trastm , 0,0,bill_amt 
from #totalcost where flag ='N'

--select * into temtushar1 from #final

select charge_name,sum(dp_charge) charge
from #final 
where amt + service_tax_amt + dp_charge <> 0
group by charge_name
order by 1 


 


end

GO
