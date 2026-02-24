-- Object: PROCEDURE citrus_usr.pr_breakup_bak_221220210
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


CREATE   procedure [citrus_usr].[pr_breakup_bak_221220210](@pa_from_dt datetime,@pa_to_dt datetime,@pa_login_name varchar(100))
as
begin 

insert into bbrlog
select 'start', GETDATE () 

insert into bbrlog
select 'TRUNCATE and insert start', GETDATE () 

TRUNCATE TABLE cdsl_holding_dtls_bak_forreve
insert into cdsl_holding_dtls_bak_forreve  
select * from CDSL_HOLDING_DTLS with(nolock) where CDSHM_TRAS_DT between @pa_from_dt and @pa_to_dt 
and (CDSHM_TRATM_CD ='2277'   or  CDSHM_CDAS_SUB_TRAS_TYPE in ('1002' ,'905','802','829','1012','838','816','1102'))---,'810'
--and CDSHM_BEN_ACCT_NO ='1203320000016304'



insert into bbrlog
select 'TRUNCATE and insert end', GETDATE ()

insert into bbrlog
select 'delete start', GETDATE ()

-- ADDED FOR WAIVE OF ON GOV SEC BY LATESH P W ON AUG 4 16
delete a FROM cdsl_holding_dtls_bak_forreve a , ISIN_MSTR
where CDSHM_ISIN =ISIN_CD AND ISIN_SEC_TYPE in( '20','03') AND ISIN_SECURITY_TYPE_DESCRIPTION='Government Securities'
and   cdshm_tras_dt between  @pa_from_dt and @pa_to_dt
--and isnull(cdshm_charge,0) <> 0
-- ADDED FOR WAIVE OF ON GOV SEC BY LATESH P W ON AUG 4 16	

-- added to delete PMS pool account from nov 2019 month only mail dated 04122019
delete   FROM cdsl_holding_dtls_bak_forreve   
where  CDSHM_BEN_ACCT_NO in( '1203320019917044','1203320008188083')
and   cdshm_tras_dt between  @pa_from_dt and @pa_to_dt

delete   from cdsl_holding_dtls_bak_forreve  where CDSHM_TRAS_DT 
between @pa_from_dt and @pa_to_dt
and CDSHM_COUNTER_BOID = '1203320019917044'

-- added to delete PMS pool account from nov 2019 month only mail dated 04122019

--added as per mail from jagannath kadam dated 03012020 for pledge trxn
delete   from cdsl_holding_dtls_bak_forreve  where CDSHM_COUNTER_BOID = '1601480000243735'
and CDSHM_TRATM_CD='2280'
AND CDSHM_TRAS_DT='DEC 28 2019'
--added as per mail from jagannath kadam dated 03012020 for pledge trxn



--delete   FROM cdsl_holding_dtls_bak_forreve   
--where  CDSHM_BEN_ACCT_NO = '1203320000006564'
--and   cdshm_tras_dt between  @pa_from_dt and @pa_to_dt


--add as per call from vishal raut dated 05032020 -- pool to cusa not to be charged
delete   FROM cdsl_holding_dtls_bak_forreve   
where  CDSHM_BEN_ACCT_NO in( '1203320006951435', '1203320000006564','1203320000006579')
and   cdshm_tras_dt between  @pa_from_dt and @pa_to_dt
and CDSHM_COUNTER_BOID = '1203320018512051'
--add as per call from vishal raut dated 05032020 -- pool to cusa not to be charged

insert into bbrlog
select 'delete end', GETDATE ()

insert into bbrlog
select 'insert into  #chargesummary start', GETDATE ()

select * , '0' FLG  into #chargesummary from (
select dpam_sba_no  , brom_desc 
, case when citrus_usr.ufn_countstring(CLIC_CHARGE_NAME,'_') >=1
 then citrus_usr.fn_splitval_by(CLIC_CHARGE_NAME ,2 ,'_') else CLIC_CHARGE_NAME end  charge_name 
,SUM(clic_charge_amt) amt 
from client_charges_cdsl with(nolock),dp_acct_mstr  with(nolock) ,client_dp_brkg  with(nolock) ,BROKERAGE_MSTR  with(nolock) 
 where CLIC_TRANS_DT between @pa_from_dt  and @pa_to_dt
and CLIC_CHARGE_NAME not in ('SERVICE TAX','SWACHH BHARAT CESS','KRISHI KALYAN CESS @ 0.50%'
,'TRANSACTION CHARGES','CGST @9%','SGST @9%','IGST @18%','UGST')
and BROM_ID = CLIDB_BROM_ID 
and CLIDB_DPAM_ID= DPAM_ID and CLIDB_DELETED_IND =1 
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
and CLIDB_DPAM_ID= DPAM_ID and CLIDB_DELETED_IND =1 
and CDSHM_DPAM_ID  = DPAM_ID --and DPAM_SBA_NO ='1203320000016304'
and cdshm_tras_dt between clidb_eff_from_dt  and ISNULL(clidb_eff_to_dt ,'dec 31 2100')
group by dpam_sba_no,brom_desc,cdshm_internal_trastm
) a  

insert into bbrlog
select 'insert into  #chargesummary end', GETDATE ()

insert into bbrlog
select 'update start ', GETDATE ()

update a set flg = '1' from #chargesummary   a
where exists(select 1 from client_charges_Cdsl , dp_Acct_mstr b where a.dpam_sba_no= b.dpam_sba_no 
and clic_dpam_id = dpam_id 
and CLIC_TRANS_DT between @pa_from_dt and @pa_to_dt and clic_charge_name like '%CGST%')


update a set flg = '2' from #chargesummary   a
where exists(select 1 from client_charges_Cdsl , dp_Acct_mstr b where a.dpam_sba_no= b.dpam_sba_no 
and clic_dpam_id = dpam_id 
and CLIC_TRANS_DT between @pa_from_dt and @pa_to_dt and clic_charge_name like '%UGST%')


update a set flg = '3' from #chargesummary   a
where exists(select 1 from client_charges_Cdsl , dp_Acct_mstr b where a.dpam_sba_no= b.dpam_sba_no 
and clic_dpam_id = dpam_id 
and CLIC_TRANS_DT between @pa_from_dt and @pa_to_dt and clic_charge_name like '%IGST%')


insert into bbrlog
select 'update end ', GETDATE ()



insert into bbrlog
select 'insert into  #totalcost start ', GETDATE ()
declare @l_amount numeric(18,3) 
set @l_amount = 4.25
--set @l_amount = 4.50

select boid,cdshm_internal_trastm ,sum(convert(numeric(18,3),AMT)) bill_amt , 'N' flag into #totalcost from (
SELECT boid,@l_amount   AMT ,'OffMkt Settlement Ann 1 **' cdshm_internal_trastm FROM (SELECT cdshm_ben_acct_no BOID 
FROM cdsl_holding_dtls_bak_forreve with (nolock)
where cdshm_tras_dt between @PA_from_DT and @PA_to_DT
AND CDSHM_CDAS_TRAS_TYPE='5'
AND CDSHM_CDAS_SUB_TRAS_TYPE ='521'
and CDSHM_TRATM_CD ='2277'
and ISNULL(CDSHM_TRADE_NO  ,'') = ''
--and (isdate(right(CDSHM_INT_REF_NO,4)+'-'+substring( CDSHM_INT_REF_NO,3,2) + '-' + left(CDSHM_INT_REF_NO,2) )=0 or CDSHM_INT_REF_NO like '%/%' ) 
----and not exists (select 1 from dps8_pc1 where boid = cdshm_ben_acct_no and replace(CONVERT(varchar(11),cdshm_tras_dt,103),'/','') = ClosAppDt)
--and (case when cdshm_ben_acct_no in (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active')
--		 then 8 else len(CDSHM_COUNTER_DPID) end = len(CDSHM_COUNTER_DPID)
----	or cdshm_isin like 'inf%'
--and cdshm_isin not in ('INF732E01037','IN0020120062')
--)
--and (isdate(right(CDSHM_INT_REF_NO,4)+'-'+substring( CDSHM_INT_REF_NO,3,2) + '-' + left(CDSHM_INT_REF_NO,2) )=0 or CDSHM_INT_REF_NO like '%/%' ) 
----and not exists (select 1 from dps8_pc1 where boid = cdshm_ben_acct_no and replace(CONVERT(varchar(11),cdshm_tras_dt,103),'/','') = ClosAppDt)
and ((case when cdshm_ben_acct_no in (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active')
		 then 8 else len(CDSHM_COUNTER_DPID) end = len(CDSHM_COUNTER_DPID)  or CDSHM_COUNTER_DPID not like 'in556929%'
		 and CDSHM_BEN_ACCT_NO not in  ('1203320006951435'))) 
--	or cdshm_isin like 'inf%'
and (cdshm_isin not in ('INF732E01037','IN0020120062')
)

) A

union all
SELECT boid,@l_amount  act_AMT, 'OffMkt Settlement Ann 2 **' dsc FROM (SELECT cdshm_ben_acct_no BOID 
FROM cdsl_holding_dtls_bak_forreve with (nolock)
where cdshm_tras_dt between @PA_from_DT and @PA_to_DT
AND CDSHM_CDAS_SUB_TRAS_TYPE ='305'
and CDSHM_TRATM_CD ='2277'
and (case when cdshm_ben_acct_no in (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active')
		 then 8 else len(CDSHM_COUNTER_DPID) end = len(CDSHM_COUNTER_DPID )  or (CDSHM_COUNTER_DPID not like 'in556929%'
		 and CDSHM_BEN_ACCT_NO not in  ('1203320006951435','1203320000006564'))
		 or (CDSHM_COUNTER_boid  = '1203320018512051'
		 and CDSHM_BEN_ACCT_NO  in  ('1203320006951435'))
		 or (CDSHM_COUNTER_boid  in ( '1203320006951435')
		 and CDSHM_BEN_ACCT_NO  in  ('1203320000006579') and  CDSHM_COUNTER_DPID <> ''
		 		 ))
--	or cdshm_isin like 'inf%'
and (cdshm_isin not in ('INF732E01037','IN0020120062')
)
) B
UNION ALL
select CDSHM_BEN_ACCT_NO,@l_amount  act_AMT,'Early Payin **' dsc from cdsl_holding_dtls_bak_forreve where cdshm_tratm_cd ='2277'
and cdshm_cdas_sub_tras_type ='409'
AND cdshm_tras_dt between @PA_from_DT and @PA_to_DT
and CITRUS_USR.fn_splitval_by(cdshm_trans_cdas_code,34,'~')='31'
and cdshm_isin not in ('INF732E01037' ,'IN0020120062') 
and  not exists (SELECT dpam_sba_no FROM DP_ACCT_MSTR WHERE dpam_subcm_cd IN ( '102624','192624') and CDSHM_BEN_ACCT_NO=dpam_sba_no)

UNION ALL 

select CDSHM_BEN_ACCT_NO  ,@l_amount  act_AMT ,'OnMkt Settlement **' dsc from cdsl_holding_dtls_bak_forreve
 where cdshm_tratm_cd ='2277'
and cdshm_cdas_sub_tras_type ='109'
AND  NOT exists (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active' and CDSHM_BEN_ACCT_NO=dpam_sba_no)
and cdshm_isin not in ('INF732E01037 ','IN0020120062')
UNION ALL 
SELECT CDSHM_BEN_ACCT_NO ,@l_amount  act_AMT ,'NSCCL **' dsc FROM cdsl_holding_dtls_bak_forreve 
WHERE CDSHM_TRATM_CD ='2277'
AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('107','1503','105')
AND  NOT exists (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active' and CDSHM_BEN_ACCT_NO=dpam_sba_no )
and cdshm_isin not in ('INF732E01037' ,'IN0020120062')
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
and cdshm_isin not in ('INF732E01037' ,'IN0020120062')
and cdshm_isin like 'inF%'
union all
SELECT CDSHM_BEN_ACCT_NO ,CONVERT(NUMERIC(18,3),50) act_AMT  ,'Remat Charges' dsc
FROM cdsl_holding_dtls_bak_forreve WHERE CDSHM_TRATM_CD ='2277'
AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('707','3304') AND citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,26,'~')= 'j'
and cdshm_isin not in ('INF732E01037' ,'IN0020120062')
and cdshm_isin like 'inC%'
union all
SELECT CDSHM_BEN_ACCT_NO ,CONVERT(NUMERIC(18,3)
,CEILING(ABS(CDSHM_QTY)/100.00)* CASE WHEN CDSHM_ISIN LIKE 'INC%' THEN 50 ELSE 10 END ) act_AMT  ,'Remat Charges' dsc
FROM cdsl_holding_dtls_bak_forreve WHERE CDSHM_TRATM_CD ='2277'
AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('707','3304') AND citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,26,'~') <> 'j'
and cdshm_isin not in ('INF732E01037' ,'IN0020120062')
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
and cdshm_isin not in ('INF732E01037','IN0020120062')
and cdshm_isin not like 'inc%'
and cdshm_isin not like 'inF%'
--UNION ALL 
--SELECT CDSHM_BEN_ACCT_NO , '12' act_AMT,'Pledge' dsc FROM cdsl_holding_dtls_bak_forreve WHERE CDSHM_CDAS_SUB_TRAS_TYPE in ('810')
--and cdshm_isin not in ('INF732E01037','IN0020120062')
UNION ALL
SELECT CDSHM_BEN_ACCT_NO, '12' act_AMT ,'Pledge' dsc FROM cdsl_holding_dtls_bak_forreve WHERE CDSHM_CDAS_SUB_TRAS_TYPE in ('1002')
and cdshm_isin not in ('INF732E01037','IN0020120062')
UNION ALL
SELECT CDSHM_BEN_ACCT_NO, '12' act_AMT ,'Pledge' dsc FROM cdsl_holding_dtls_bak_forreve WHERE CDSHM_CDAS_SUB_TRAS_TYPE in ('905')
and cdshm_isin not in ('INF732E01037','IN0020120062')
UNION ALL
SELECT CDSHM_BEN_ACCT_NO, '12' act_AMT ,'Pledge' dsc FROM cdsl_holding_dtls_bak_forreve WHERE CDSHM_CDAS_SUB_TRAS_TYPE in ('802')
and cdshm_isin not in ('INF732E01037','IN0020120062')
UNION ALL
SELECT CDSHM_BEN_ACCT_NO, '5' act_AMT ,'Margin Pledge' dsc FROM cdsl_holding_dtls_bak_forreve a WHERE CDSHM_CDAS_SUB_TRAS_TYPE in ('829')
and cdshm_isin not in ('INF732E01037','IN0020120062')
and case
when  CDSHM_CDAS_SUB_TRAS_TYPE in ('829') and exists (select top 1 * from cdsl_holding_dtls_bak_forreve b  where 
a.CDSHM_BEN_ACCT_NO = b.CDSHM_BEN_ACCT_NO   and a.cdshm_isin  = b.CDSHM_ISIN and b.CDSHM_TRAS_DT between @pa_from_dt and @pa_from_dt
and a.cdshm_qty = b.CDSHM_QTY and a.CDSHM_TRANS_NO = b.cdshm_trans_no and b.CDSHM_CDAS_SUB_TRAS_TYPE = 816 )then '1.000' 
when CDSHM_CDAS_SUB_TRAS_TYPE in ('829') then citrus_usr.fn_splitval_by(cdshm_trans_cdas_code ,31,'~')

else '1.000' end  <> '0.000' 
UNION ALL
SELECT CDSHM_BEN_ACCT_NO, '5' act_AMT ,'Margin Pledge' dsc FROM cdsl_holding_dtls_bak_forreve WHERE CDSHM_CDAS_SUB_TRAS_TYPE in ('1012')
and cdshm_isin not in ('INF732E01037','IN0020120062')
--and citrus_usr.fn_splitval_by(cdshm_trans_cdas_code ,31,'~') <> '0.000'
UNION ALL
SELECT CDSHM_BEN_ACCT_NO, '1' act_AMT ,'Margin Re-Pledge' dsc FROM cdsl_holding_dtls_bak_forreve WHERE CDSHM_CDAS_SUB_TRAS_TYPE in ('838')
and cdshm_isin not in ('INF732E01037','IN0020120062')

UNION ALL
SELECT CDSHM_BEN_ACCT_NO, '5' act_AMT ,'Confiscate' dsc FROM cdsl_holding_dtls_bak_forreve WHERE CDSHM_CDAS_SUB_TRAS_TYPE in ('1102')
and cdshm_isin not in ('INF732E01037','IN0020120062')
--added as per finding with vishal dated 06/05/2021
and CDSHM_COUNTER_BOID like '12033200%'
--added as per finding with vishal dated 06/05/2021

) a 
group by boid,cdshm_internal_trastm

insert into bbrlog
select 'insert into  #totalcost end', GETDATE ()



insert into bbrlog
select 'insert into  #final  start ', GETDATE ()
select pc1.DPAM_SBA_NO 
,  brom.brom_desc 
,  isnull(charge_name ,'') charge_name 
,  isnull(amt,0) amt
,  isnull(amt*case when charge_name  in ('POAFIXED','POA','VERSION 2.5 LIFETIMEPOA') then 0 else case when @pa_from_dt<'JUL  1 2017' then 0.1400  else 0 end end ,0.0000) service_tax_amt
,  isnull(amt*case when charge_name  in ('POAFIXED','POA','VERSION 2.5 LIFETIMEPOA') then 0 else case when @pa_from_dt<'JUL  1 2017' then 0.005  else 0 end   end ,0.000000) sbt_amt
,  isnull(amt*case when charge_name  in ('POAFIXED','POA','VERSION 2.5 LIFETIMEPOA') then 0 else case when @pa_from_dt<'JUL  1 2017' then 0.005  else 0 end   end ,0.000000) KKC_amt
,  isnull(amt*case when charge_name  in ('POAFIXED','POA','VERSION 2.5 LIFETIMEPOA') then 0 else case when @pa_from_dt>='JUL  1 2017' and flg ='1' then 0.0900  else 0 end end ,0.0000) SGST
,  isnull(amt*case when charge_name  in ('POAFIXED','POA','VERSION 2.5 LIFETIMEPOA') then 0 else case when @pa_from_dt>='JUL  1 2017' and flg ='1' then 0.0900  else 0 end   end ,0.000000) CGST
,  isnull(amt*case when charge_name  in ('POAFIXED','POA','VERSION 2.5 LIFETIMEPOA') then 0 else case when @pa_from_dt>='JUL  1 2017' and flg ='3' then 0.1800  else 0 end   end ,0.000000) IGST
,  isnull(amt*case when charge_name  in ('POAFIXED','POA','VERSION 2.5 LIFETIMEPOA') then 0 else case when @pa_from_dt>='JUL  1 2017' and flg ='2' then 0.1800  else 0 end   end ,0.000000) UGST

, convert(numeric(18,3),'0') dp_charge  into #final 
from dp_acct_mstr pc1 with(nolock) left outer join #chargesummary summ on pc1.DPAM_SBA_NO = summ.dpam_sba_no 
,CLIENT_DP_BRKG with(nolock)
,BROKERAGE_MSTR brom with(nolock)
where CLIDB_DPAM_ID = DPAM_ID 
and CLIDB_BROM_ID = BROM_ID 
and @pa_to_dt between clidb_eff_from_dt and ISNULL(clidb_eff_to_dt ,'dec 31 2100')
and CLIDB_DELETED_IND = 1 


insert into bbrlog
select 'insert into  #final  end ', GETDATE ()


insert into bbrlog
select 'update   #final  start ', GETDATE ()

update a set dp_charge = bill_amt 
from #final a , #totalcost where boid = DPAM_SBA_NO
and charge_name = cdshm_internal_trastm


update b   set  flag  = 'Y'
from #final a , #totalcost b where boid = DPAM_SBA_NO
and charge_name = cdshm_internal_trastm


insert into bbrlog
select 'update   #final  end  ', GETDATE ()

insert into #final 
select boid , '',cdshm_internal_trastm , 0,0,0,0,0,0,0,0,bill_amt 
from #totalcost where flag ='N'

--select * into ytemp01092021 from #final

create clustered index ix_1 on  #final(dpam_Sba_no)

select distinct t.boid,BOActDt,state into #tmpdps8_pc1  from #final F , dps8_pc1 T where F.DPAM_SBA_NO=T.boid

create clustered index ix_1 on  #tmpdps8_pc1(boid)

insert into bbrlog
select 'last select start ', GETDATE ()


if @pa_from_dt<'JUL  1 2017' 
begin 

select '''' +  dpam.dpam_sba_no dpam_sba_no,dpam.DPAM_BBO_CODE tradingid
 , case when charge_name  in ('Account Maintenance charges'
,	'NSCCL **'
,	'OffMkt Settlement Ann 1 **'
,	'OffMkt Settlement Ann 2 **'
,	'OnMkt Settlement **'
,	'Pledge'
,	'Remat Charges'
,	'Settlement Charges'
,	'Margin Pledge'
,   'Margin Re-Pledge'
,   'Confiscate'
) then 'CDSL CHARGE' else brom_desc end brom_desc ,charge_name,amt*-1 amt,service_tax_amt*-1 service_tax_amt
,sbt_amt*-1 sbt_amt
,KKC_amt*-1 KKC_amt
 ,dp_charge cdslcharge 
, LEFT(pc1.BOActDt ,2) + '/'+SUBSTRING(pc1.BOActDt ,3,2)+'/'+RIGHT(pc1.BOActDt ,4) activationdt
from #final f , dp_Acct_mstr dpam 
--, dps8_pc1 pc1 
,#tmpdps8_pc1 pc1
where pc1.boid = dpam.dpam_sba_no and pc1.BOId = f.DPAM_SBA_NO 
and dpam.dpam_sba_no = f.dpam_sba_no and amt + service_tax_amt + dp_charge <> 0
order by 1 
end 
else
begin 
select '''' +  dpam.dpam_sba_no dpam_sba_no,dpam.DPAM_BBO_CODE tradingid
 , case when charge_name  in ('Account Maintenance charges'
,	'NSCCL **'
,	'OffMkt Settlement Ann 1 **'
,	'OffMkt Settlement Ann 2 **'
,	'OnMkt Settlement **'
,	'Pledge'
,	'Remat Charges'
,	'Settlement Charges'
,	'Margin Pledge'
,	'Margin Re-Pledge'
,   'Confiscate'
) then 'CDSL CHARGE' else brom_desc end brom_desc ,charge_name,amt*-1 amt
,SGST*-1 SGST
,CGST*-1 CGST
,IGST*-1 IGST
,UGST*-1 UGST
--,sbt_amt*-1 sbt_amt
--,KKC_amt*-1 KKC_amt
 ,dp_charge cdslcharge 
, LEFT(pc1.BOActDt ,2) + '/'+SUBSTRING(pc1.BOActDt ,3,2)+'/'+RIGHT(pc1.BOActDt ,4) activationdt
,state 
--,citrus_usr.fn_find_relations_ACCT_nm(boid , 'bl') [BASE LOCATION]

from #final f , dp_Acct_mstr dpam 
--, dps8_pc1 pc1 
,#tmpdps8_pc1 pc1
where pc1.boid = dpam.dpam_sba_no  and pc1.BOId = f.DPAM_SBA_NO 
and dpam.dpam_sba_no = f.dpam_sba_no and abs(amt) + abs(sgst) + abs(ugst) + abs(igst) +abs(cgst)+ abs(dp_charge) <> 0
order by 1 

end 


 
insert into bbrlog
select 'last select end ', GETDATE ()

insert into bbrlog
select 'END', GETDATE () 

end

GO
