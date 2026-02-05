-- Object: PROCEDURE citrus_usr.pr_get_cdsl_bill
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------




--exec pr_get_cdsl_bill 'jul 01 2015','jul 31 2015','HO'
CREATE proc [citrus_usr].[pr_get_cdsl_bill](@pa_from_dt datetime,@pa_to_dt datetime,@pa_login_name varchar(100))
as
begin 

declare @rate numeric(18,3)
set @rate ='4.25'

TRUNCATE TABLE cdsl_holding_dtls_bak_forreve
insert into cdsl_holding_dtls_bak_forreve  
select * from CDSL_HOLDING_DTLS with(nolock) where CDSHM_TRAS_DT between @pa_from_dt and @pa_to_dt 
and (CDSHM_TRATM_CD ='2277'   or  CDSHM_CDAS_SUB_TRAS_TYPE in ('1002' ,'810','1103'))
--and CDSHM_BEN_ACCT_NO ='1203320000016304'


select left(boid,8) dp ,convert(varchar(1000),dsc) dsc ,sum(convert(numeric(18,3),act_AMT)) actual_bill_amt  into #actualcost from (
SELECT boid,@rate   act_AMT ,'OffMkt Settlement Ann 1 **' dsc FROM (SELECT cdshm_ben_acct_no BOID 
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
SELECT boid,@rate  act_AMT, 'OffMkt Settlement Ann 2 **' dsc FROM (SELECT cdshm_ben_acct_no BOID 
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
select CDSHM_BEN_ACCT_NO,@rate  act_AMT,'Early Payin **' dsc from cdsl_holding_dtls_bak_forreve where cdshm_tratm_cd ='2277'
and cdshm_cdas_sub_tras_type ='409'
AND cdshm_tras_dt between @PA_from_DT and @PA_to_DT
and CITRUS_USR.fn_splitval_by(cdshm_trans_cdas_code,34,'~')='31'
and cdshm_isin not in ('INF732E01037')

UNION ALL 

select CDSHM_BEN_ACCT_NO  ,@rate  act_AMT ,'OnMkt Settlement **' dsc from cdsl_holding_dtls_bak_forreve
 where cdshm_tratm_cd ='2277'
and cdshm_cdas_sub_tras_type ='109'
AND CDSHM_BEN_ACCT_NO NOT IN (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active')
and cdshm_isin not in ('INF732E01037')
UNION ALL 
SELECT CDSHM_BEN_ACCT_NO ,@rate  act_AMT ,'NSCCL **' dsc FROM cdsl_holding_dtls_bak_forreve 
WHERE CDSHM_TRATM_CD ='2277'
AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('107','1503','105')
AND CDSHM_BEN_ACCT_NO NOT IN (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active')
and cdshm_isin not in ('INF732E01037')
--UNION ALL 
--SELECT CDSHM_BEN_ACCT_NO ,@rate  act_AMT,'NSCCL **' dsc  FROM cdsl_holding_dtls_bak_forreve 
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
group by left(boid,8),dsc  


--
--if (select sum(actual_bill_amt) from #actualcost where dp not in ('12010900')  )<5000
--begin 

insert into #actualcost
select dp,'Round off Amount',5000-sum(actual_bill_amt)
from #actualcost
where dp not in ('12010900')
group by dp
having sum(actual_bill_amt) < 5000


--end 


select distinct convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd 
into #account_properties from account_properties 
where accp_accpm_prop_cd = 'BILL_START_DT' 
and accp_value not in ('','//')

create index ix_1 on #account_properties(accp_clisba_id , accp_value )


insert into #actualcost
select dp,dsc,sum(amt) from (
select  left(dpam_sba_no,8) dp ,'Account Maintenance charges' dsc ,((500.00/12.00)*isnull((select datediff(m,@pa_to_dt,fin_end_dt) + 1 
from financial_yr_mstr where  @pa_to_dt between fin_start_dt and fin_end_dt and fin_deleted_ind = 1),0)) amt
from dp_acct_mstr,#account_properties 
where accp_clisba_id = dpam_id
and accp_value between @pa_from_dt and @pa_to_dt
and dpam_clicm_cd ='25'
) a group by dp,dsc


insert into #actualcost
select dp,dsc,sum(amt) from (
select  left(dpam_sba_no,8) dp ,'Settlement Charges' dsc ,case when stockexch in ('12')
 then 500 else 250 end amt
from dp_acct_mstr,dps8_pc1
where dpam_clicm_cd = '26' 
and BOID = DPAM_SBA_NO 

and dpam_stam_cd='active'

--union all 
--SELECT left(cdshm_ben_acct_no,8) BOID ,'Settlement Charges' dsc,(count(1)-90)*5.5
--FROM cdsl_holding_dtls_bak_forreve with (nolock)
--where cdshm_tras_dt between 'jan 01 2014' and 'jan 31 2014'
--AND CDSHM_CDAS_SUB_TRAS_TYPE ='305'
--and CDSHM_TRATM_CD ='2277'
--and cdshm_isin not in ('INF732E01037')
--and cdshm_ben_acct_no in (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active' and dpam_subcm_cd ='502624')
--group by cdshm_ben_acct_no
--having count(1)>90

) a group by dp,dsc



select identity(numeric,1,1) id , * into #actualcost_id from #actualcost  order by dsc

select id,dp,head,[Bill amount]  from (
select id , dsc head,actual_bill_amt [Bill amount],dp  from #actualcost_id  
union 
select 60 id ,'Total Bill Amount' head,sum(actual_bill_amt ),dp from #actualcost_id group by dp
union 
select 61 id,'Service Tax (@14%)' head,sum(actual_bill_amt )*0.14,dp from #actualcost_id group by dp
union 
--select 62 id,'Education Cess (@2%) of Service Tax' head,sum(actual_bill_amt )*0.12*0.02,dp from #actualcost_id group by dp
--union 
--select 63 id,'Secondary and Higher Secondary Cess (@1%) of Service Tax' head,sum(actual_bill_amt )*0.12*0.01,dp from #actualcost_id group by dp
--union 
select 65 id,'Total Amount Payable' head, sum(actual_bill_amt),dp from (select 'Total Bill Amount' head,sum(actual_bill_amt ) actual_bill_amt,dp from #actualcost_id group by dp
																		union 
																		select 'Service Tax (@14%)' head,sum(actual_bill_amt )*0.14,dp from #actualcost_id group by dp
																		--union 
																		--select 'Education Cess (@2%) of Service Tax' head,sum(actual_bill_amt )*0.12*0.02,dp from #actualcost_id group by dp
																		--union 
																		--select 'Secondary and Higher Secondary Cess (@1%) of Service Tax' head,sum(actual_bill_amt )*0.12*0.01 ,dp from #actualcost_id group by dp 
																		) a 
group by dp
union 
select 0 id,'** For all debit transaction Bill Amount @' , @rate,'' dp 
) a 
order by dp,id 

--
--select * from #actualcost

drop table #actualcost

end

GO
