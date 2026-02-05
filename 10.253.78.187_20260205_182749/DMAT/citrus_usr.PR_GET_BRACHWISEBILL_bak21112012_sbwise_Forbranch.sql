-- Object: PROCEDURE citrus_usr.PR_GET_BRACHWISEBILL_bak21112012_sbwise_Forbranch
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------









--EXEC [PR_GET_BRACHWISEBILL_bak21112012_sbwise] 'jul 01 2013','jul 31 2013'  

CREATE PROC [citrus_usr].[PR_GET_BRACHWISEBILL_bak21112012_sbwise_Forbranch](@PA_FROM_DT DATETIME, @PA_TO_DT DATETIME,@pa_LOGIN varchar(1000))  

AS  

BEGIN  

--select * into #tmp_dp_acct_mstr  from dp_acct_mstr   

--where dpam_id in (select distinct clic_dpam_id from client_charges_cdsl    

--where clic_trans_dt between @PA_FROM_DT and @PA_TO_DT)  
--select * from enttm_entr_mapping 
  
select DPAM_ID FILTERED_DPAMID into #acctlist_br from dp_acct_mstr , entity_relationship
where entr_sba = dpam_sba_no
and   (ENTR_BR IN (SELECT ENTM_ID FROM ENTITY_MSTR WHERE ENTM_SHORT_NAME IN (SELECT LOGN_SHORT_NAME FROM LOGIN_NAMES WHERE LOGN_NAME = @pa_LOGIN AND LOGN_DELETED_IND = 1) AND ENTM_DELETED_IND = 1)
OR ENTR_SB IN (SELECT ENTM_ID FROM ENTITY_MSTR WHERE ENTM_SHORT_NAME IN (SELECT LOGN_SHORT_NAME FROM LOGIN_NAMES WHERE LOGN_NAME = @pa_LOGIN AND LOGN_DELETED_IND = 1) AND ENTM_DELETED_IND = 1))
  

  

select distinct convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd   

into #account_properties from account_properties   ,#acctlist_br  

where accp_accpm_prop_cd = 'BILL_START_DT'   

and accp_value not in ('')  
AND ACCP_CLISBA_ID = FILTERED_DPAMID

  

select distinct convert(datetime,accp_value,103) accp_value_cl  

, accp_clisba_id accp_clisba_id_cl , accp_accpm_prop_cd accp_accpm_prop_cd_cl   

into #account_properties_close from account_properties  ,#acctlist_br   

where accp_accpm_prop_cd = 'ACC_CLOSE_DT'   

and accp_value not in ('','//')  

AND ACCP_CLISBA_ID = FILTERED_DPAMID
  

create index ix_1 on #account_properties(accp_clisba_id , accp_value )  

create index ix_2 on #account_properties_close(accp_clisba_id_cl , accp_value_cl )  

--

--

--select * into #cdslboid from 

--(SELECT distinct boid FROM cdslbill_cisa_clos_bal where billmonth = month(@PA_FROM_DT) and billyear =year(@PA_FROM_DT) and (bill_amt <> '0' or isin like '%inf%')--cisa_closing_bal

--

--union all

--SELECT distinct boid  FROM cdslbill_off where billmonth = month(@PA_FROM_DT) and billyear =year(@PA_FROM_DT) and (bill_amount <> '0' or isin like '%inf%')--OFF

--and dr_cr='D'

--union all

--SELECT distinct boid  FROM cdslbill_off2 where billmonth = month(@PA_FROM_DT) and billyear =year(@PA_FROM_DT) and (bill_amount <> '0'or isin like '%inf%')--OFF

--and dr_cr='D'

--union all

--SELECT distinct  fr_bo_id FROM cdslbill_ep where billmonth = month(@PA_FROM_DT) and billyear =year(@PA_FROM_DT) 

--and (bill_amt <> '0')--EP	

--union all

--SELECT distinct boid  FROM cdslbill_on where billmonth = month(@PA_FROM_DT) and billyear =year(@PA_FROM_DT) and (bill_amount <> '0'or isin like '%inf%')--ON

--and dr_cr='D'

--union all

--SELECT distinct boid  FROM cdslbill_id where billmonth = month(@PA_FROM_DT) and billyear =year(@PA_FROM_DT) and (bill_Amt <> '0'or isin like '%inf%')--ID

--union all

--SELECT distinct bo_id  FROM cdslbill_nsccl where billmonth = month(@PA_FROM_DT) 

--and billyear =year(@PA_FROM_DT) and (bill_amount <> '0')--NSCCL

--and dr_cr='D'

--union all

--SELECT distinct bo_id  FROM cdslbill_nsccl where billmonth = month(@PA_FROM_DT) 

--and billyear =year(@PA_FROM_DT) and (isin like '%inf%')--NSCCL

--and (settl_id not like '%1201090000003024%' and  settl_id not like '%1201090000000116%')

--and dr_cr='D'

--union all

--SELECT distinct bo_id  FROM cdslbill_nsccl where billmonth = month(@PA_FROM_DT) 

--and billyear =year(@PA_FROM_DT) and bill_amount = '0'

--and dr_cr ='D'

--and (settl_id like '%1201090000003024%' or settl_id like '%1201090000000116%')

--union all

--SELECT distinct bo_id  FROM cdslbill_remat where billmonth = month(@PA_FROM_DT) and billyear =year(@PA_FROM_DT) and bill_amount <> '0'--REMAT

--union all

--SELECT distinct boid  FROM cdslbill_cisa_ovrd_cr where billmonth = month(@PA_FROM_DT) and billyear =year(@PA_FROM_DT) and bill_amt <> '0'--cisa_ovrd_cr

--union all

--SELECT distinct pledgor_bo_id FROM cdslbill_pldg_setup_pledgor where billmonth = month(@PA_FROM_DT) and billyear =year(@PA_FROM_DT) and pledgor_bill_amt <> '0' --plg_setup_pledgor		

--union all

--SELECT distinct pledgee_bo_id FROM cdslbill_pldg_setup_pledgee where billmonth = month(@PA_FROM_DT) and billyear =year(@PA_FROM_DT) and pledgee_bill_amt <> '0'--pldg_setup_pledgee

--union all

--SELECT distinct pledgor_bo_id FROM cdslbill_pldg_setup_pledgee where billmonth = month(@PA_FROM_DT) and billyear =year(@PA_FROM_DT) and pledgor_bill_amt <> '0'--pldg_setup_pledgee

--union all

--SELECT distinct pledgor_bo_id FROM cdslbill_pldg_inv_pledgor where billmonth = month(@PA_FROM_DT) and billyear =year(@PA_FROM_DT) and pledgor_bill_amt <> '0'--pldg_inv_pledgor

--union all

--SELECT distinct pledgee_bo_id FROM cdslbill_pldg_inv_pledgee where billmonth = month(@PA_FROM_DT) and billyear =year(@PA_FROM_DT) and pledgor_bill_amt <> '0'--pldg_inv_pledgee

--union all

--SELECT distinct pledgor_bo_id FROM cdslbill_unpldg where billmonth = month(@PA_FROM_DT) and billyear =year(@PA_FROM_DT) and pledgor_bill_amt <> '0'--unpldg 

--) a 







select * into #cdslboid from 

(SELECT DISTINCT boid FROM (SELECT cdshm_ben_acct_no BOID 

FROM cdsl_holding_dtls_bak_forreve with (nolock),#acctlist_br  

where cdshm_tras_dt between @pa_from_dt and @pa_to_dt

AND CDSHM_CDAS_TRAS_TYPE='5'

AND CDSHM_CDAS_SUB_TRAS_TYPE ='521'

and CDSHM_TRATM_CD ='2277'

AND CDSHM_DPAM_ID  = FILTERED_DPAMID

and (case when cdshm_ben_acct_no in (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active')

		 then 8 else len(CDSHM_COUNTER_DPID) end = len(CDSHM_COUNTER_DPID)

	or cdshm_isin like 'inf%')) A



union all

SELECT DISTINCT boid FROM (SELECT cdshm_ben_acct_no BOID 

FROM cdsl_holding_dtls_bak_forreve with (nolock),#acctlist_br 

where cdshm_tras_dt between @pa_from_dt and @pa_to_dt

AND CDSHM_CDAS_SUB_TRAS_TYPE ='305'

and CDSHM_TRATM_CD ='2277'

AND CDSHM_DPAM_ID  = FILTERED_DPAMID


and (case when cdshm_ben_acct_no in (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active')

		 then 8 else len(CDSHM_COUNTER_DPID) end = len(CDSHM_COUNTER_DPID)

	or cdshm_isin like 'inf%')) B

UNION ALL

select DISTINCT CDSHM_BEN_ACCT_NO  from cdsl_holding_dtls_bak_forreve  with (nolock),#acctlist_br  where cdshm_tratm_cd ='2277'

and cdshm_cdas_sub_tras_type ='409'

AND cdshm_tras_dt between @pa_from_dt and @pa_to_dt

AND CDSHM_DPAM_ID  = FILTERED_DPAMID


and CITRUS_USR.fn_splitval_by(cdshm_trans_cdas_code,34,'~')='31'

UNION ALL 



select DISTINCT CDSHM_BEN_ACCT_NO from cdsl_holding_dtls_bak_forreve with (nolock),#acctlist_br

 where cdshm_tratm_cd ='2277'

and cdshm_cdas_sub_tras_type ='109'
AND CDSHM_DPAM_ID  = FILTERED_DPAMID


AND CDSHM_BEN_ACCT_NO NOT IN (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active')

UNION ALL

select DISTINCT CDSHM_BEN_ACCT_NO from cdsl_holding_dtls_bak_forreve with (nolock),#acctlist_br

 where cdshm_tratm_cd ='2277'

and cdshm_cdas_sub_tras_type ='109'
AND CDSHM_DPAM_ID  = FILTERED_DPAMID


AND CDSHM_BEN_ACCT_NO IN (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active')

AND CDSHM_ISIN LIKE 'INF%'

UNION ALL 

SELECT DISTINCT CDSHM_BEN_ACCT_NO   FROM cdsl_holding_dtls_bak_forreve with (nolock),#acctlist_br

WHERE CDSHM_TRATM_CD ='2277'
AND CDSHM_DPAM_ID  = FILTERED_DPAMID


AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('107','1503','105')

AND CDSHM_BEN_ACCT_NO NOT IN (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active')

UNION ALL 

SELECT DISTINCT CDSHM_BEN_ACCT_NO FROM cdsl_holding_dtls_bak_forreve  with (nolock),#acctlist_br

WHERE CDSHM_TRATM_CD ='2277'

AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('107','1503','105')
AND CDSHM_DPAM_ID  = FILTERED_DPAMID


AND CDSHM_BEN_ACCT_NO IN (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active')

AND CDSHM_ISIN LIKE 'INF%'

UNION ALL

SELECT DISTINCT CDSHM_BEN_ACCT_NO FROM cdsl_holding_dtls_bak_forreve with (nolock),#acctlist_br WHERE CDSHM_TRATM_CD ='2277'

AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('707','3304')
AND CDSHM_DPAM_ID  = FILTERED_DPAMID

 AND citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,26,'~') <> 'j'

UNION ALL

SELECT DISTINCT CDSHM_BEN_ACCT_NO

FROM cdsl_holding_dtls_bak_forreve with (nolock),#acctlist_br WHERE CDSHM_TRATM_CD ='2277'

AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('707','3304') 
AND CDSHM_DPAM_ID  = FILTERED_DPAMID

AND citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,26,'~') = 'J'

UNION ALL 

SELECT DISTINCT CDSHM_BEN_ACCT_NO FROM cdsl_holding_dtls_bak_forreve with (nolock),#acctlist_br WHERE CDSHM_CDAS_SUB_TRAS_TYPE ='802'
AND CDSHM_DPAM_ID  = FILTERED_DPAMID


UNION ALL

SELECT DISTINCT CDSHM_BEN_ACCT_NO FROM cdsl_holding_dtls_bak_forreve with (nolock),#acctlist_br WHERE CDSHM_CDAS_SUB_TRAS_TYPE ='1002'
AND CDSHM_DPAM_ID  = FILTERED_DPAMID














) a 









select * into #tmp_dp_acct_mstr  from dp_acct_mstr with (nolock),#acctlist_br

where dpam_id in (select distinct clic_dpam_id from client_charges_cdsl  with (nolock)    

					where clic_trans_dt between @PA_FROM_DT and @PA_TO_DT)  

or dpam_id in (select accp_clisba_id from #account_properties where accp_value between @PA_FROM_DT and @PA_TO_DT)  

or dpam_id in (select accp_clisba_id_cl from #account_properties_close where accp_value_cl between @PA_FROM_DT and @PA_TO_DT)  

or dpam_sba_no in (SELECT boid FROM #cdslboid)

AND DPAM_ID = FILTERED_DPAMID


--select * from #account_properties_close where accp_value_cl between @PA_FROM_DT and @PA_TO_DT  

--and accp_clisba_id_cl in (select distinct dpam_id from #tmp_dp_acct_mstr)  

  

select  dpam_id , dpam_sba_no ,isnull(CLIC_TRANS_DT ,@PA_FROM_DT)   CLIC_TRANS_DT ,

--isnull(entm_name1,'') [branch code],   

case when clic_flg  ='M' then '***' + clic_charge_name else clic_charge_name end clic_charge_name, sum(CLIC_CHARGE_AMT)  charge_amt  

,isnull(accp_value,'') accp_value ,isnull(accp_value_cl   ,'') accp_value_cl   

into #tempdata   from #tmp_dp_acct_mstr with (nolock) 

left outer join #account_properties on accp_clisba_id = dpam_id   

left outer join #account_properties_close on accp_clisba_id_cl = dpam_id  

left outer join  client_charges_cdsl with (nolock)   on clic_dpam_id = dpam_id   

and   clic_trans_dt between @PA_FROM_DT and @PA_TO_DT  

and isnull(CLIC_FLG,'B') not in ('B')

--left outer join  entity_relationship  with (nolock) on  CLIC_TRANS_DT between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2100')       

--left outer join  entity_mstr with (nolock) on    (entr_br = entm_id or entr_sb = entm_id )      

--and   isnull(entr_sba,dpam_sba_no) =  dpam_sba_no   

group by dpam_id , dpam_sba_no,  

--isnull(entm_name1,''),  

clic_charge_name ,  

CLIC_TRANS_DT,accp_value,accp_value_cl  ,clic_flg



--select * from #tmp_dp_acct_mstr where dpam_sba_no ='1201090005082991'

--



--RUMAINVEZE







  

select br.entm_short_name brcdopn,isnull(sb.entm_short_name,'') sbcdopn,count(distinct b.dpam_sba_no) noofacctopn

 into #acctopn 

from #tmp_dp_acct_mstr a ,#tempdata b  left outer join entity_relationship   

on entr_sba = b.dpam_sba_no   

and @PA_to_DT  between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2100')

left outer join entity_mstr br on  (entr_br = br.entm_id or entr_sb = br.entm_id )   

left outer join entity_mstr sb on  (entr_dummy1 = sb.entm_id or entr_dummy3 = sb.entm_id )   

where  accp_value between @PA_FROM_DT and @PA_TO_DT   

and a.dpam_sba_no = b.dpam_sba_no   

and a.dpam_subcm_Cd not  in ('022552','022551','022543','022541'  

    ,'022538','022536','022523','022522','022521','022520'  

    ,'022519','022518','022517','022516','022515','022514'  

    ,'022513','022512','022567','022576','042207','042206'  

    ,'042205','052309','052308','052334','062826','242977','242927')   

group by br.entm_short_name ,sb.entm_short_name





--select * from #acctopn where brcdopn  = 'RMEGHADPTL_BA'

--

 



  

select br.entm_short_name brcdopn_corp,isnull(sb.entm_short_name,'') sbcdopn_corp 
,count(distinct b.dpam_sba_no) noofacctopn_corp into #acctopn_corp from #tmp_dp_acct_mstr a ,#tempdata b  left outer join entity_relationship   

on entr_sba = b.dpam_sba_no   

left outer join entity_mstr br on  (entr_br = br.entm_id or entr_sb = br.entm_id )   

left outer join entity_mstr sb on  (entr_dummy1 = sb.entm_id or entr_dummy3 = sb.entm_id )   

where  accp_value between @PA_FROM_DT and @PA_TO_DT   

and a.dpam_sba_no = b.dpam_sba_no  

and accp_value between  isnull(ENTR_FROM_DT,'jan 01 1900') and isnull(ENTR_TO_DT,'dec 31 2900')   

and a.dpam_subcm_Cd   in ('022552','022551','022543','022541'  

    ,'022538','022536','022523','022522','022521','022520'  

    ,'022519','022518','022517','022516','022515','022514'  

    ,'022513','022512','022567','022576','042207','042206'  

    ,'042205','052309','052308','052334','062826','242977','242927')   

group by br.entm_short_name  ,sb.entm_short_name

  

  





select br.entm_short_name brcdoclos,isnull(sb.entm_short_name,'') sbcdoclos,count(distinct dpam_sba_no) noofacctclos into #acctclos from #tempdata 

left outer join  

 entity_relationship   

on entr_sba = dpam_sba_no   

left outer join entity_mstr br on  (entr_br = entm_id or entr_sb = entm_id )   

left outer join entity_mstr sb on  (entr_dummy1 = sb.entm_id or entr_dummy3 = sb.entm_id )   

where  accp_value_cl between @PA_FROM_DT and @PA_TO_DT  

and accp_value_cl between  isnull(ENTR_FROM_DT,'jan 01 1900') and isnull(ENTR_TO_DT,'dec 31 2900')  

group by br.entm_short_name  ,sb.entm_short_name

  

select boid,br.entm_short_name br,isnull(sb.entm_short_name,'') sb,sum(convert(numeric(18,3),bill_amt)) bill_amt  into #totalcost from (

--SELECT boid , bill_amt FROM cdslbill_cisa_clos_bal where billmonth = month(@PA_FROM_DT) and billyear =year(@PA_FROM_DT) and (bill_amt <> '0' or isin like '%inf%')--cisa_closing_bal

--

--union all

--SELECT boid,'5.5' FROM cdslbill_off where billmonth = month(@PA_FROM_DT) and billyear =year(@PA_FROM_DT) and (bill_amount <> '0' or isin like '%inf%')--OFF

--and dr_cr='D'

--union all

--SELECT boid,'5.5' FROM cdslbill_off2 where billmonth = month(@PA_FROM_DT) and billyear =year(@PA_FROM_DT) and (bill_amount <> '0'or isin like '%inf%')--OFF

--and dr_cr='D'

--union all

--SELECT fr_bo_id,'5.5' FROM cdslbill_ep where billmonth = month(@PA_FROM_DT) and billyear =year(@PA_FROM_DT) 

--and (bill_amt <> '0')--EP	

--union all

--SELECT boid,'5.5' FROM cdslbill_on where billmonth = month(@PA_FROM_DT) and billyear =year(@PA_FROM_DT) and (bill_amount <> '0'or isin like '%inf%')--ON

--and dr_cr='D'

--union all

--SELECT boid,'5.5' FROM cdslbill_id where billmonth = month(@PA_FROM_DT) and billyear =year(@PA_FROM_DT) and (bill_Amt <> '0'or isin like '%inf%')--ID

--union all

--SELECT bo_id,'5.5' FROM cdslbill_nsccl where billmonth = month(@PA_FROM_DT) 

--and billyear =year(@PA_FROM_DT) and (bill_amount <> '0')--NSCCL

--and dr_cr='D'

--union all

--SELECT bo_id,'5.5' FROM cdslbill_nsccl where billmonth = month(@PA_FROM_DT) 

--and billyear =year(@PA_FROM_DT) and (isin like '%inf%')--NSCCL

--and (settl_id not like '%1201090000003024%' and  settl_id not like '%1201090000000116%')

--and dr_cr='D'

--union all

--SELECT bo_id,'5.5' FROM cdslbill_nsccl where billmonth = month(@PA_FROM_DT) 

--and billyear =year(@PA_FROM_DT) and bill_amount = '0'

--and dr_cr ='D'

--and (settl_id like '%1201090000003024%' or settl_id like '%1201090000000116%')

--union all

--SELECT bo_id,bill_amount FROM cdslbill_remat where billmonth = month(@PA_FROM_DT) and billyear =year(@PA_FROM_DT) and bill_amount <> '0'--REMAT

--union all

--SELECT boid,bill_amt FROM cdslbill_cisa_ovrd_cr where billmonth = month(@PA_FROM_DT) and billyear =year(@PA_FROM_DT) and bill_amt <> '0'--cisa_ovrd_cr

--union all

--SELECT pledgor_bo_id,pledgor_bill_amt FROM cdslbill_pldg_setup_pledgor where billmonth = month(@PA_FROM_DT) and billyear =year(@PA_FROM_DT) and pledgor_bill_amt <> '0' --plg_setup_pledgor		

--union all

--SELECT pledgee_bo_id,pledgee_bill_amt FROM cdslbill_pldg_setup_pledgee where billmonth = month(@PA_FROM_DT) and billyear =year(@PA_FROM_DT) and pledgee_bill_amt <> '0'--pldg_setup_pledgee

--union all

--SELECT pledgor_bo_id,pledgor_bill_amt FROM cdslbill_pldg_setup_pledgee where billmonth = month(@PA_FROM_DT) and billyear =year(@PA_FROM_DT) and pledgor_bill_amt <> '0'--pldg_setup_pledgee

--union all

--SELECT pledgor_bo_id,pledgor_bill_amt FROM cdslbill_pldg_inv_pledgor where billmonth = month(@PA_FROM_DT) and billyear =year(@PA_FROM_DT) and pledgor_bill_amt <> '0'--pldg_inv_pledgor

--union all

--SELECT pledgee_bo_id,pledgor_bill_amt FROM cdslbill_pldg_inv_pledgee where billmonth = month(@PA_FROM_DT) and billyear =year(@PA_FROM_DT) and pledgor_bill_amt <> '0'--pldg_inv_pledgee

--union all

--SELECT pledgor_bo_id,pledgor_bill_amt FROM cdslbill_unpldg where billmonth = month(@PA_FROM_DT) and billyear =year(@PA_FROM_DT) and pledgor_bill_amt <> '0'--unpldg 

SELECT boid,'5.5' bill_amt FROM (SELECT cdshm_ben_acct_no BOID 

FROM cdsl_holding_dtls_bak_forreve with (nolock)  ,#acctlist_br


where cdshm_tras_dt between @pa_from_dt and @pa_to_dt

AND CDSHM_CDAS_TRAS_TYPE='5'

AND CDSHM_CDAS_SUB_TRAS_TYPE ='521'

AND CDSHM_DPAM_ID  = FILTERED_DPAMID



and CDSHM_TRATM_CD ='2277'

and (case when cdshm_ben_acct_no in (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active')

		 then 8 else len(CDSHM_COUNTER_DPID) end = len(CDSHM_COUNTER_DPID)

	or cdshm_isin like 'inf%')) A



union all

SELECT boid,'5.5' AMT FROM (SELECT cdshm_ben_acct_no BOID 

FROM cdsl_holding_dtls_bak_forreve with (nolock),#acctlist_br

where cdshm_tras_dt between @pa_from_dt and @pa_to_dt

AND CDSHM_CDAS_SUB_TRAS_TYPE ='305'

and CDSHM_TRATM_CD ='2277'

AND CDSHM_DPAM_ID  = FILTERED_DPAMID



and (case when cdshm_ben_acct_no in (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active')

		 then 8 else len(CDSHM_COUNTER_DPID) end = len(CDSHM_COUNTER_DPID)

	or cdshm_isin like 'inf%')) B

UNION ALL

select CDSHM_BEN_ACCT_NO,'5.5' AMT from cdsl_holding_dtls_bak_forreve with (nolock),#acctlist_br where cdshm_tratm_cd ='2277'

and cdshm_cdas_sub_tras_type ='409'

AND CDSHM_DPAM_ID  = FILTERED_DPAMID


AND cdshm_tras_dt between @pa_from_dt and @pa_to_dt

and CITRUS_USR.fn_splitval_by(cdshm_trans_cdas_code,34,'~')='31'

UNION ALL 



select CDSHM_BEN_ACCT_NO ,'5.5' AMT  from cdsl_holding_dtls_bak_forreve with (nolock),#acctlist_br

 where cdshm_tratm_cd ='2277'

and cdshm_cdas_sub_tras_type ='109'
AND CDSHM_DPAM_ID  = FILTERED_DPAMID


AND CDSHM_BEN_ACCT_NO NOT IN (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active')

UNION ALL

select CDSHM_BEN_ACCT_NO  ,'5.5' AMT  from cdsl_holding_dtls_bak_forreve  with (nolock),#acctlist_br

 where cdshm_tratm_cd ='2277'

and cdshm_cdas_sub_tras_type ='109'
AND CDSHM_DPAM_ID  = FILTERED_DPAMID


AND CDSHM_BEN_ACCT_NO IN (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active')

AND CDSHM_ISIN LIKE 'INF%'

UNION ALL 

SELECT CDSHM_BEN_ACCT_NO , '5.5' AMT  FROM cdsl_holding_dtls_bak_forreve  with (nolock),#acctlist_br

WHERE CDSHM_TRATM_CD ='2277'

AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('107','1503','105')
AND CDSHM_DPAM_ID  = FILTERED_DPAMID


AND CDSHM_BEN_ACCT_NO NOT IN (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active')

UNION ALL 

SELECT CDSHM_BEN_ACCT_NO , '5.5' AMT FROM cdsl_holding_dtls_bak_forreve  with (nolock),#acctlist_br

WHERE CDSHM_TRATM_CD ='2277'

AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('107','1503','105')
AND CDSHM_DPAM_ID  = FILTERED_DPAMID


AND CDSHM_BEN_ACCT_NO IN (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active')

AND CDSHM_ISIN LIKE 'INF%'

UNION ALL

SELECT CDSHM_BEN_ACCT_NO , CONVERT(NUMERIC(18,3),CEILING(ABS(CDSHM_QTY)/100.00)* CASE WHEN CDSHM_ISIN LIKE 'INC%' THEN 50 ELSE 10 END ) AMT  
FROM cdsl_holding_dtls_bak_forreve with (nolock),#acctlist_br 
WHERE CDSHM_TRATM_CD ='2277'

AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('707','3304') 
AND CDSHM_DPAM_ID  = FILTERED_DPAMID

AND citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,26,'~') <> 'j'

UNION ALL

SELECT CDSHM_BEN_ACCT_NO 

--,citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,26,'~'),ABS(CDSHM_QTY), citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,21,'~'), CONVERT(NUMERIC(18,3),CEILING(ABS(CDSHM_QTY)/100.00)*10) AMT  

,CONVERT(NUMERIC(18,3),CASE WHEN ABS(convert(numeric,CDSHM_QTY))/CASE WHEN  citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,21,'~') ='0' THEN  ABS(CDSHM_QTY) ELSE  citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,21,'~') END = 1 THEN  CONVERT(NUMERIC(18,3)
,CEILING(ABS(CDSHM_QTY)/100.00)*CASE WHEN CDSHM_ISIN LIKE 'INC%' THEN 50 ELSE 10 END)  

ELSE ABS(CDSHM_QTY)/CASE WHEN  citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,21,'~') ='0' THEN  ABS(CDSHM_QTY) ELSE  citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,21,'~') END * CASE WHEN CDSHM_ISIN LIKE 'INC%' THEN 50 ELSE 10 END  END ) AMT

FROM cdsl_holding_dtls_bak_forreve with (nolock),#acctlist_br
WHERE CDSHM_TRATM_CD ='2277'

AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('707','3304') 
AND CDSHM_DPAM_ID  = FILTERED_DPAMID

AND citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,26,'~') = 'J'

UNION ALL 

SELECT CDSHM_BEN_ACCT_NO , '12' AMT FROM cdsl_holding_dtls_bak_forreve with (nolock),#acctlist_br
WHERE CDSHM_CDAS_SUB_TRAS_TYPE ='802'
AND CDSHM_DPAM_ID  = FILTERED_DPAMID


UNION ALL

SELECT CDSHM_BEN_ACCT_NO,'12'AMT FROM cdsl_holding_dtls_bak_forreve with (nolock),#acctlist_br WHERE CDSHM_CDAS_SUB_TRAS_TYPE in ('1002','905')
AND CDSHM_DPAM_ID  = FILTERED_DPAMID










) a left outer join  entity_relationship  on boid = entr_sba  

and @PA_to_DT between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2900')

left outer join  entity_mstr br

on (br.entm_id = entr_br or entr_sb = br.entm_id )

left outer join entity_mstr sb on  (entr_dummy1 = sb.entm_id or entr_dummy3 = sb.entm_id )   

group by boid,br.entm_short_name,sb.entm_short_name





--

--

--select boid,entm_short_name ,sum(convert(numeric(18,3),bill_amt)) bill_amt into #totalcost from (

--SELECT boid , bill_amt FROM cdslbill_cisa_clos_bal where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and bill_amt <> '0' --cisa_closing_bal

--union all

--SELECT boid,'5.5' FROM cdslbill_off where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and bill_amount <> '0'--OFF

--union all

--SELECT boid,'5.5' FROM cdslbill_off2 where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and bill_amount <> '0'--OFF

--union all

--SELECT fr_bo_id,'5.5' FROM cdslbill_ep where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and bill_amt <> '0'--EP	

--union all

--SELECT boid,'5.5' FROM cdslbill_on where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and bill_amount <> '0'--ON

--union all

--SELECT boid,'5.5' FROM cdslbill_id where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and bill_Amt <> '0'--ID

--union all

--SELECT bo_id,'5.5' FROM cdslbill_nsccl where billmonth = month(@pa_from_dt) 

--and billyear =year(@pa_from_dt) and bill_amount <> '0'--NSCCL

--union all

--SELECT bo_id,'5.5' FROM cdslbill_nsccl where billmonth = month(@pa_from_dt) 

--and billyear =year(@pa_from_dt) and bill_amount = '0'

--and dr_cr ='D'

--and (settl_id like '%1201090000003024%' or settl_id like '%1201090000000116%')

--union all

--SELECT bo_id,bill_amount FROM cdslbill_remat where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and bill_amount <> '0'--REMAT

--union all

--SELECT boid,bill_amt FROM cdslbill_cisa_ovrd_cr where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and bill_amt <> '0'--cisa_ovrd_cr

--union all

--SELECT pledgor_bo_id,pledgor_bill_amt FROM cdslbill_pldg_setup_pledgor where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgor_bill_amt <> '0' --plg_setup_pledgor		

--union all

--SELECT pledgee_bo_id,pledgee_bill_amt FROM cdslbill_pldg_setup_pledgee where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgee_bill_amt <> '0'--pldg_setup_pledgee

--union all

--SELECT pledgor_bo_id,pledgor_bill_amt FROM cdslbill_pldg_setup_pledgee where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgor_bill_amt <> '0'--pldg_setup_pledgee

--union all

--SELECT pledgor_bo_id,pledgor_bill_amt FROM cdslbill_pldg_inv_pledgor where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgor_bill_amt <> '0'--pldg_inv_pledgor

--union all

--SELECT pledgee_bo_id,pledgor_bill_amt FROM cdslbill_pldg_inv_pledgee where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgor_bill_amt <> '0'--pldg_inv_pledgee

--union all

--SELECT pledgor_bo_id,pledgor_bill_amt FROM cdslbill_unpldg where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgor_bill_amt <> '0'--unpldg 

--) a , entity_relationship, entity_mstr where boid = entr_sba 

--and @PA_FROM_DT between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2900')

--and (entm_id = entr_br or entr_sb = entm_id )

--group by boid,entm_short_name







select br,sb,sum(bill_amt) bill_amt into #branchwisetc from #totalcost group by br,sb



--

--

--

--select * from #tempdata left outer join entity_relationship   

--on entr_sba = dpam_sba_no   

--and @PA_TO_DT  between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2900')   

--left outer join entity_mstr on  (entr_br = entm_id or entr_sb = entm_id )   

--left outer join #acctopn on entm_short_name  = brcdopn  

--left outer join #acctclos on entm_short_name  = brcdoclos  

--left outer join #acctopn_corp on entm_short_name  = brcdopn_corp  

--left outer join charge_mstr cham on cham.cham_slab_name = clic_charge_name  

--where entm_short_name ='RSACHINBS_BA'  

--group by entm_short_name,entm_name1,noofacctopn,noofacctclos,noofacctopn_corp,clic_charge_name,cham_charge_type  

--select * from #tempdata where dpam_sba_no ='1201090005106061'

--

--select entr_sba , sum(charge_amt)  , ENTM_SHORT_NAME

--from #tempdata left outer join entity_relationship   

--on entr_sba = dpam_sba_no   

--and @PA_to_DT  between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2900')   

--left outer join entity_mstr on  (entr_br = entm_id or entr_sb = entm_id )   

--left outer join #acctopn on entm_short_name  = brcdopn  

--left outer join #acctclos on entm_short_name  = brcdoclos  

--left outer join #acctopn_corp on entm_short_name  = brcdopn_corp  

--left outer join charge_mstr cham on cham.cham_slab_name = clic_charge_name  

--where ENTR_SBA ='1201090005106061'

--group by entr_sba,ENTM_SHORT_NAME

--

--

--select *   from #tempdata left outer join entity_relationship with (nolock)   

--on entr_sba = dpam_sba_no   

--and @PA_to_DT  between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2900')   

--left outer join entity_mstr br with (nolock)  on  (entr_br = br.entm_id or entr_sb = br.entm_id )   

--left outer join entity_mstr sb with (nolock) on  (entr_dummy1 = sb.entm_id or entr_dummy3 = sb.entm_id )   

--left outer join #acctopn on br.entm_short_name  = brcdopn  and  sb.entm_short_name  = sbcdopn  

--return









select  REPLACE(RIGHT(CONVERT(VARCHAR(11), @PA_FROM_DT, 106), 8), ' ', '-') AS [Month]  

,br.entm_short_name [BranchCode]   

,br.entm_name1 [Branchname]   

,isnull(sb.entm_short_name,'') [subbCode]   

,isnull(sb.entm_name1,'') [subname]   



,'0' [TradingCode]  

,isnull(noofacctopn,'0') [AccountOpnedinMonth]  

,isnull(noofacctclos,'0') [ClosedDuringmonth]  

,isnull(noofacctopn_corp,'0') [CorporateAccountopenedduringthemonth]  

,convert(numeric(18,3),0.000) [Cost]  

,convert(numeric(18,3),0.000)  [TotalCost]  

,sum(charge_amt)  [TotalRev]  

,case when ((cham_charge_type ='F' or cham_charge_type ='AMCPRO' or cham_charge_type ='O' )  and (clic_charge_name not like '%admin%' and clic_charge_name not like '%11LIFETI_AMC%' and clic_charge_name not like '%acop%' )) or (clic_charge_name ='***AMC') 
 then sum(charge_amt)  else 0.000 end   [AMCBilled]  

,case when (cham_charge_type ='F' or cham_charge_type ='AMCPRO' or cham_charge_type ='O' )  and (clic_charge_name like '%11LIFETI_AMC%' ) then sum(charge_amt)  else 0.000 end   [LIfetimeamc] 

,case when ( clic_charge_name  like '%acop%' ) and cham_charge_type ='O'  then sum(charge_amt)  else 0.000 end  [AccountOpeingCharge+Document]  

,case when clic_charge_name ='TRANSACTION CHARGES' then sum(charge_amt) else 0.000 end [TransactionBilled]  

,case when clic_charge_name ='DEMAT COURIER CHARGE' then sum(charge_amt) else 0.000 end [DematcouirerChargeBilled]  

,case when clic_charge_name ='DEMAT REJECTION CHARGE' then sum(charge_amt) else 0.000 end [DematRejection]  

,case when clic_charge_name ='CORPORATE AMC' then sum(charge_amt) else 0.000 end  [CorporateAMC]  

,case when ((clic_charge_name  like '%admin%'  ) and (cham_charge_type ='O' or cham_charge_type ='AMCPRO')) or (clic_charge_name ='***Admin Charge')  then sum(charge_amt)  else 0.000 end   [AdministrationCharge+Cdslcorporateamccharges]  

,case when (clic_charge_name = 'SERVICE TAX')  or (clic_charge_name ='***service tax')  then sum(charge_amt) else 0.000 end [ServiceTax]  

--,'' [FR-Sharing]  

,convert(numeric(18,3),0.000) [DematOursharing]  

,convert(numeric(18,3),0.000) [FR-Sharing]  

,convert(numeric(18,3),0.000) [OurSharing]  

,convert(numeric(18,3),0.000) [AmconclosedA/c]  

,convert(numeric(18,3),0.000) [TotalChargesTODEBITEDIN1200A/C]  

,convert(numeric(18,3),0.000) [Franchiseesharing]  

,convert(numeric(18,3),0.000) [Tdsonfrincome]  

,convert(numeric(18,3),0.000) [FRAMCSHARING] 

 

into #finaldata1 from #tempdata left outer join entity_relationship with (nolock)   

on entr_sba = dpam_sba_no   

and @PA_to_DT  between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2900')   

left outer join entity_mstr br with (nolock)  on  (entr_br = br.entm_id or entr_sb = br.entm_id )   

left outer join entity_mstr sb with (nolock) on  (entr_dummy1 = sb.entm_id or entr_dummy3 = sb.entm_id )   

left outer join #acctopn on br.entm_short_name  = brcdopn  and  isnull(sb.entm_short_name ,'') = sbcdopn 

left outer join #acctclos on br.entm_short_name  = brcdoclos  and  isnull(sb.entm_short_name ,'') = sbcdoclos

left outer join #acctopn_corp on br.entm_short_name  = brcdopn_corp and  isnull(sb.entm_short_name ,'')  = sbcdopn_corp 

left outer join charge_mstr cham on cham.cham_slab_name = clic_charge_name  

group by br.entm_short_name,sb.entm_short_name,br.entm_name1,sb.entm_name1,noofacctopn,noofacctclos,noofacctopn_corp,clic_charge_name,cham_charge_type  

--





--select dpam_sba_no,REPLACE(RIGHT(CONVERT(VARCHAR(11), @PA_FROM_DT, 106), 8), ' ', '-') AS [Month]  

--,entm_short_name [BranchCode]   

--,entm_name1 [Branchname]   

--,'0' [TradingCode]  

--,isnull(noofacctopn,'0') [AccountOpnedinMonth]  

--,isnull(noofacctclos,'0') [ClosedDuringmonth]  

--,isnull(noofacctopn_corp,'0') [CorporateAccountopenedduringthemonth]  

--,convert(numeric(18,3),0.000) [Cost]  

--,convert(numeric(18,3),0.000)  [TotalCost]  

--,sum(charge_amt)  [TotalRev]  

--,case when (cham_charge_type ='F' or cham_charge_type ='AMCPRO' or cham_charge_type ='O' )  and (clic_charge_name not like '%admin%' and clic_charge_name not like '%11LIFETI_AMC%' and clic_charge_name not like '%acop%' ) then sum(charge_amt)  else 0.000 end   [AMCBilled]  

--,case when ( clic_charge_name  like '%acop%' ) and cham_charge_type ='O'  then sum(charge_amt)  else 0.000 end  [AccountOpeingCharge+Document]  

--,case when clic_charge_name ='TRANSACTION CHARGES' then sum(charge_amt) else 0.000 end [TransactionBilled]  

--,case when clic_charge_name ='DEMAT COURIER CHARGE' then sum(charge_amt) else 0.000 end [DematcouirerChargeBilled]  

--,case when clic_charge_name ='DEMAT REJECTION CHARGE' then sum(charge_amt) else 0.000 end [DematRejection]  

--,case when clic_charge_name ='CORPORATE AMC' then sum(charge_amt) else 0.000 end  [CorporateAMC]  

--,case when (clic_charge_name  like '%admin%'  ) and (cham_charge_type ='O' or cham_charge_type ='AMCPRO')  then sum(charge_amt)  else 0.000 end   [AdministrationCharge+Cdslcorporateamccharges]  

--,case when clic_charge_name = 'SERVICE TAX' then sum(charge_amt) else 0.000 end [ServiceTax]  

----,'' [FR-Sharing]   

-- from #tempdata left outer join entity_relationship   

--on entr_sba = dpam_sba_no   

--and @PA_TO_DT  between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2900')   

--left outer join entity_mstr on  (entr_br = entm_id or entr_sb = entm_id )   

--left outer join #acctopn on entm_short_name  = brcdopn  

--left outer join #acctclos on entm_short_name  = brcdoclos  

--left outer join #acctopn_corp on entm_short_name  = brcdopn_corp  

--left outer join charge_mstr cham on cham.cham_slab_name = clic_charge_name  

--where entm_short_name ='RRANCPATNA_BA' --and dpam_sba_no ='1201092400113700'

--group by entm_short_name,entm_name1,noofacctopn,noofacctclos,noofacctopn_corp,clic_charge_name,cham_charge_type  ,dpam_sba_no

--

--

----select * from #tempdata where dpam_sba_no ='1201092400113700'

--

--

--return 





--return

  



select  [Month],[BranchCode],[Branchname]

,isnull([subbCode]   ,'') [subbCode]

,isnull([subname]   ,'') [subname]

,[TradingCode],[AccountOpnedinMonth] [AccountOpnedinMonth] ,[ClosedDuringmonth] [ClosedDuringmonth]

,[CorporateAccountopenedduringthemonth] [CorporateAccountopenedduringthemonth]

,abs(sum([Cost])) [Cost],abs(sum([TotalCost])) [TotalCost],abs(sum([TotalRev]) ) [TotalRev]

,abs(sum([AMCBilled]  )) [AMCBilled]

,abs(sum([LIfetimeamc] )) [LIfetimeamc]

,abs(sum([AccountOpeingCharge+Document])  ) [AccountOpeingCharge+Document]  

,abs(sum([TransactionBilled]))  [TransactionBilled]

,abs(sum([DematcouirerChargeBilled]  )) [DematcouirerChargeBilled]  

,abs(sum([DematRejection] ) ) [DematRejection]  

,abs(sum([CorporateAMC]  )) [CorporateAMC]  

,abs(sum([AdministrationCharge+Cdslcorporateamccharges]  )) [AdministrationCharge+Cdslcorporateamccharges]  

,abs(sum([ServiceTax]  ) )[ServiceTax]  

,abs(sum([DematOursharing])  ) [DematOursharing]  

,abs(sum([FR-Sharing] ) ) [FR-Sharing]   

,abs(sum([OurSharing]) ) [OurSharing]  

,abs(sum([AmconclosedA/c]  )) [AmconclosedA/c]

,abs(sum([TotalChargesTODEBITEDIN1200A/C] ) ) [TotalChargesTODEBITEDIN1200A/C]  

,abs(sum([Franchiseesharing])  ) [Franchiseesharing]  

,abs(sum([Tdsonfrincome]  ))  [Tdsonfrincome]  

,abs(sum([FRAMCSHARING]  )) [FRAMCSHARING]   

,'' dematflag   

,'' rematflag

into #finaldata from #finaldata1 

group by [month], [BranchCode],[TradingCode]

,[Branchname]

,[AccountOpnedinMonth]

,[ClosedDuringmonth]

,[CorporateAccountopenedduringthemonth]

,isnull([subbCode]   ,'')

,isnull([subname]  ,'') 







delete from #finaldata where [BranchCode] is null 



update a

set [Cost]     = convert(numeric(18,3),bill_amt)

,[totalCost]   = convert(numeric(18,3),bill_amt)



from #branchwisetc, #finaldata a

where br = [BranchCode]

and sb = [subbCode]



update a set [FR-Sharing] = isnull(RAVD_AMT ,0)

,[OurSharing] = 100 - isnull(RAVD_AMT ,0) 

,dematflag = isnull(RAVD_DEMATYN ,'')

,rematflag = isnull(RAVD_REMATYN ,'')  

from #finaldata a

left outer join revenue_dtls on RAVD_ENTITY  = substring([BranchCode] ,1,len([BranchCode])-3)

and @PA_FROM_DT between RAVD_FROM_DT and isnull(RAVD_TO_DT,'dec 31 2100')







   

select [Month]  

,[BranchCode]  

,[Branchname]  

,isnull([subbCode]   ,'') [subbCode]

,isnull([subname]   ,'') [subname]



,[TradingCode]  

,[AccountOpnedinMonth]  

,[ClosedDuringmonth]  

,[CorporateAccountopenedduringthemonth]  

,abs(sum([Cost])+sum([Cost]*0.1236))   [Cost]

,abs(sum([TotalCost])+sum([TotalCost]*0.1236)) [TotalCost]  

,abs(sum([TotalRev]))  [TotalRev]  

,abs(sum([AMCBilled])) [AMCBilled]  

,abs(sum([LIfetimeamc])) [LIfetimeamc]  

,abs(sum( [AccountOpeingCharge+Document]))  [AccountOpeingCharge+Document]  

,abs(sum([TransactionBilled])) [TransactionBilled]  

,abs(sum([DematcouirerChargeBilled])) [DematcouirerChargeBilled]  

,abs(sum([DematRejection])) [DematRejection]  

,abs(sum([CorporateAMC])) [CorporateAMC]  

,abs(sum([AdministrationCharge+Cdslcorporateamccharges])) [AdministrationCharge+Cdslcorporateamccharges]  

,abs(sum([ServiceTax])) [ServiceTax]  

,abs([DematOursharing])  [DematOursharing] 

,abs([FR-Sharing])   [FR-Sharing]

,abs([OurSharing]) [OurSharing]  

,abs([AmconclosedA/c])   [AmconclosedA/c]

,abs(

		(

			(

				(sum([Cost])+sum([Cost]*0.1236))

				*

				sum([FR-Sharing])

			)/100

		) 

	+ 

		(

			(

				(sum([totalrev])

				-sum([ServiceTax])

				-sum([AdministrationCharge+Cdslcorporateamccharges])

				- case when dematflag ='Y' then sum([DematcouirerChargeBilled]) else 0 end 

				- case when dematflag ='Y' then sum([DematRejection]) else 0 end 

				)

				*

				sum([OurSharing])

			)/100

		) 

	+ sum([ServiceTax])

    + sum([AdministrationCharge+Cdslcorporateamccharges]) 

--+ case when dematflag ='y' then sum([DematcouirerChargeBilled]) else 0 end 

--				+ case when dematflag ='Y' then sum([DematRejection]) else 0 end 

	)   [TotalChargesTODEBITEDIN1200A/C]

,abs(sum([TotalRev])) - abs((((sum([Cost])+sum([Cost]*0.1236))*sum([FR-Sharing]))/100) + (((sum([totalrev])-sum([ServiceTax])- sum([AdministrationCharge+Cdslcorporateamccharges]) - case when dematflag ='y' then sum([DematcouirerChargeBilled]) else 0 end 


				- case when dematflag ='Y' then sum([DematRejection]) else 0 end  )*sum([OurSharing]))/100) + sum([ServiceTax]) + sum([AdministrationCharge+Cdslcorporateamccharges]) 

-- + case when dematflag ='y' then sum([DematcouirerChargeBilled]) else 0 end 

--				+ case when dematflag ='Y' then sum([DematRejection]) else 0 end  

) 

 [Franchiseesharing]

,(abs(sum([TotalRev])) - abs((((sum([Cost])+sum([Cost]*0.1236))*sum([FR-Sharing]))/100) + (((sum([totalrev])-sum([ServiceTax])- sum([AdministrationCharge+Cdslcorporateamccharges]) - case when dematflag ='y' then sum([DematcouirerChargeBilled]) else 0 end 


				- case when dematflag ='Y' then sum([DematRejection]) else 0 end )*sum([OurSharing]))/100) + sum([ServiceTax] )+ sum([AdministrationCharge+Cdslcorporateamccharges])

-- + case when dematflag ='y' then sum([DematcouirerChargeBilled]) else 0 end 

--				+ case when dematflag ='Y' then sum([DematRejection]) else 0 end  

))*.10

 [Tdsonfrincome]

,abs([FRAMCSHARING])   [FRAMCSHARING]



 from #finaldata group by [Month]  

,[BranchCode],[Branchname],[TradingCode],[AccountOpnedinMonth]  

,[ClosedDuringmonth],[CorporateAccountopenedduringthemonth],[DematOursharing]  

,[FR-Sharing],[OurSharing],[AmconclosedA/c],[TotalChargesTODEBITEDIN1200A/C]  

,[Franchiseesharing],[Tdsonfrincome],[FRAMCSHARING]

,[subbCode]   

,[subname]  

,dematflag,rematflag 



  

  

drop table #tmp_dp_acct_mstr  

drop table #tempdata  

drop table #account_properties  

drop table #account_properties_close  

drop table #acctclos  

drop table #acctopn  

drop table  #acctopn_corp  

drop table #finaldata  

  

END

GO
