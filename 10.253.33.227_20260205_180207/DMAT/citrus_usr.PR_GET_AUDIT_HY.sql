-- Object: PROCEDURE citrus_usr.PR_GET_AUDIT_HY
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE PROC [citrus_usr].[PR_GET_AUDIT_HY](@PA_TAB VARCHAR(100),@PA_FROM_DT DATETIME,@PA_TO_DT DATETIME,@PA_OUT VARCHAR(8000) OUT)
AS
BEGIN 

IF @PA_TAB = '1'
select COUNT(1) NOOFRECORD  from dps8_pc1 
where  AcctCreatDt <> ''  and convert(datetime,left(AcctCreatDt ,2) + '/'+substring(AcctCreatDt,3,2)+'/' 
+right(AcctCreatDt,4),103) 
between @PA_FROM_DT and @PA_TO_DT
and left(boid,5)='12010'

IF @PA_TAB = '2'
select COUNT(1) NOOFRECORD  from dps8_pc1 
where  ClosDt <> ''  and convert(datetime,left(ClosDt ,2) + '/'+substring(ClosDt,3,2)+'/' +right(ClosDt,4),103) 
between @PA_FROM_DT and @PA_TO_DT
and left(boid,5)='12010'


IF @PA_TAB = '3'
select COUNT(1) from dps8_pc1 
where  ClosDt <> ''  and convert(datetime,left(ClosDt ,2) + '/'+substring(ClosDt,3,2)+'/' +right(ClosDt,4),103) 
between @PA_FROM_DT and @PA_TO_DT
and ClosInitBy ='1'
and left(boid,5)='12010'

IF @PA_TAB = '4'
select count(1) from dps8_pc1 
where  ClosDt <> ''  and convert(datetime,left(ClosDt ,2) + '/'+substring(ClosDt,3,2)+'/' +right(ClosDt,4),103) 
between @PA_FROM_DT and @PA_TO_DT
and ClosInitBy in (2,3)
and left(boid,5)='12010'
--and BOAcctStatus <> '1'



IF @PA_TAB = '5'
select count(1) from dps8_pc1 
where  BOAcctStatus ='1'
and left(boid,5)='12010'

IF @PA_TAB = '6'
select  count(1) from cdsl_holding_dtls with (nolock)
where CDSHM_TRAS_DT between @PA_FROM_DT and @PA_TO_DT 
and CDSHM_CDAS_TRAS_TYPE in (17,18)
and CDSHM_TRATM_CD ='2277'



IF @PA_TAB = '7'
select left(boid,8),count(1) from dps8_pc1 
where  AcctCreatDt <> ''  and convert(datetime,left(AcctCreatDt ,2) + '/'+substring(AcctCreatDt,3,2)+'/' +right(AcctCreatDt,4),103) 
between @PA_FROM_DT and @PA_TO_DT
and left(boid,5)='12010'
group by left(boid,8)
ORDER BY 1 


IF @PA_TAB = '8'
select left(boid,8),count(1) from dps8_pc1 
where  ClosDt <> ''  and convert(datetime,left(ClosDt ,2) + '/'+substring(ClosDt,3,2)+'/' +right(ClosDt,4),103) 
between @PA_FROM_DT and @PA_TO_DT
and ClosInitBy ='1'
and left(boid,5)='12010'
and BOAcctStatus in (2,3)
group by left(boid,8)
ORDER BY 1


IF @PA_TAB = '9'
select left(boid,8),count(1) from dps8_pc1 
where  ClosDt <> ''  and convert(datetime,left(ClosDt ,2) + '/'+substring(ClosDt,3,2)+'/' +right(ClosDt,4),103) 
between @PA_FROM_DT and @PA_TO_DT
and ClosInitBy in (2,3)
and left(boid,5)='12010'
group by left(boid,8)
ORDER BY 1



IF @PA_TAB = '10'
select  left(cdshm_ben_acct_no ,8),count(1) from cdsl_holding_dtls 
where CDSHM_TRAS_DT between @PA_FROM_DT and @PA_TO_DT 
and CDSHM_CDAS_TRAS_TYPE ='6'
and CDSHM_CDAS_SUB_TRAS_TYPE ='601'
group by left(cdshm_ben_acct_no ,8)
ORDER BY 1


IF @PA_TAB = '13'
select  left(cdshm_ben_acct_no ,8),count(1) from cdsl_holding_dtls 
where CDSHM_TRAS_DT between @PA_FROM_DT and @PA_TO_DT 
and CDSHM_CDAS_TRAS_TYPE ='7'
and CDSHM_CDAS_SUB_TRAS_TYPE ='701'
group by left(cdshm_ben_acct_no ,8)
ORDER BY 1



IF @PA_TAB = '11'
select  left(cdshm_ben_acct_no ,8),count(1) from cdsl_holding_dtls with (nolock)
where CDSHM_TRAS_DT between @PA_FROM_DT and @PA_TO_DT 
and CDSHM_CDAS_TRAS_TYPE in (2,3,4,5)
and CDSHM_TRATM_CD ='2277'
group by left(cdshm_ben_acct_no ,8)
ORDER BY 1 

--TRNASC
IF @PA_TAB = '14'
select  left(cdshm_ben_acct_no ,8),count(1) from cdsl_holding_dtls with (nolock)
where CDSHM_TRAS_DT between @PA_FROM_DT and @PA_TO_DT 
and CDSHM_CDAS_TRAS_TYPE in (17,18)
and CDSHM_TRATM_CD ='2277'
group by left(cdshm_ben_acct_no ,8)
ORDER BY 1 
--PLEDGE
IF @PA_TAB = '12'
select  left(cdshm_ben_acct_no ,8),count(1) from cdsl_holding_dtls with (nolock)
where CDSHM_TRAS_DT between @PA_FROM_DT and @PA_TO_DT 
and CDSHM_CDAS_TRAS_TYPE in (8,9,10,11)
--and CDSHM_CDAS_SUB_TRAS_TYPE in ('801','901','1001','1101')
group by left(cdshm_ben_acct_no ,8)--,CDSHM_CDAS_SUB_TRAS_TYPE
order by left(cdshm_ben_acct_no ,8)

--FREEZE
IF @PA_TAB = '15'
select  left(cdshm_ben_acct_no ,8),count(1) from cdsl_holding_dtls with (nolock)
where CDSHM_TRAS_DT between @PA_FROM_DT and @PA_TO_DT 
and CDSHM_CDAS_TRAS_TYPE in (12)
and CDSHM_CDAS_SUB_TRAS_TYPE in ('1201')
group by left(cdshm_ben_acct_no ,8)
ORDER BY 1 

END

GO
