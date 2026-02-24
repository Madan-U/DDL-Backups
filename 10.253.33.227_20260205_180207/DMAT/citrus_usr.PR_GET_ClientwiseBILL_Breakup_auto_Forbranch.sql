-- Object: PROCEDURE citrus_usr.PR_GET_ClientwiseBILL_Breakup_auto_Forbranch
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------



--EXEC [PR_GET_ClientwiseBILL_Breakup] 'dec 01 2013','dec 31 2013'  

CREATE PROC [citrus_usr].[PR_GET_ClientwiseBILL_Breakup_auto_Forbranch](@pa_from_dt DATETIME, @pa_to_dt DATETIME,@pa_LOGIN varchar(1000))  


AS          

BEGIN          

--select * into #tmp_dp_acct_mstr  from dp_acct_mstr           

--where dpam_id in (select distinct clic_dpam_id from client_charges_cdsl            

--where clic_trans_dt between @pa_from_dt and @pa_to_dt)          

--          

--          select 1 dsfd,2 fdfdfd

--

--return 



--exec PR_GET_ClientwiseBILL_Breakup_auto  @pa_from_dt,@pa_to_dt

  
select DPAM_ID FILTERED_DPAMID into #acctlist_br from dp_acct_mstr , entity_relationship
where entr_sba = dpam_sba_no
and   (ENTR_BR IN (SELECT ENTM_ID FROM ENTITY_MSTR WHERE ENTM_SHORT_NAME IN (SELECT LOGN_SHORT_NAME FROM LOGIN_NAMES WHERE LOGN_NAME = @pa_LOGIN AND LOGN_DELETED_IND = 1) AND ENTM_DELETED_IND = 1)
OR ENTR_SB IN (SELECT ENTM_ID FROM ENTITY_MSTR WHERE ENTM_SHORT_NAME IN (SELECT LOGN_SHORT_NAME FROM LOGIN_NAMES WHERE LOGN_NAME = @pa_LOGIN AND LOGN_DELETED_IND = 1) AND ENTM_DELETED_IND = 1))
  
    

select distinct convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd           

into #account_properties from account_properties   with (nolock)         ,#acctlist_br  
  

where accp_accpm_prop_cd = 'BILL_START_DT'           

and accp_value not in ('')          
AND ACCP_CLISBA_ID = FILTERED_DPAMID

          

select distinct convert(datetime,accp_value,103) accp_value_cl          

, accp_clisba_id accp_clisba_id_cl , accp_accpm_prop_cd accp_accpm_prop_cd_cl           

into #account_properties_close from account_properties   with (nolock)      ,#acctlist_br  
     

where accp_accpm_prop_cd = 'ACC_CLOSE_DT'           

and accp_value not in ('','//')          
AND ACCP_CLISBA_ID = FILTERED_DPAMID

          

create index ix_1 on #account_properties(accp_clisba_id , accp_value )          

create index ix_2 on #account_properties_close(accp_clisba_id_cl , accp_value_cl )          

        

--        

--select * into #cdslboid from         

--(SELECT distinct boid FROM cdslbill_cisa_clos_bal where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and (bill_amt <> '0' or isin like '%inf%')--cisa_closing_bal        

--        

--union all        

--SELECT distinct boid  FROM cdslbill_off where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and (bill_amount <> '0' or isin like '%inf%')--OFF        

--and dr_cr='D'        

--union all        

--SELECT distinct boid  FROM cdslbill_off2 where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and (bill_amount <> '0'or isin like '%inf%')--OFF        

--and dr_cr='D'        

--union all        

--SELECT distinct  fr_bo_id FROM cdslbill_ep where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt)         

--and (bill_amt <> '0')--EP         

--union all        

--SELECT distinct boid  FROM cdslbill_on where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and (bill_amount <> '0'or isin like '%inf%')--ON        

--and dr_cr='D'        

--union all        

--SELECT distinct boid  FROM cdslbill_id where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and (bill_Amt <> '0'or isin like '%inf%')--ID        

--union all        

--SELECT distinct bo_id  FROM cdslbill_nsccl where billmonth = month(@pa_from_dt)         

--and billyear =year(@pa_from_dt) and (bill_amount <> '0')--NSCCL        

--and dr_cr='D'        

--union all        

--SELECT distinct bo_id  FROM cdslbill_nsccl where billmonth = month(@pa_from_dt)         

--and billyear =year(@pa_from_dt) and (isin like '%inf%')--NSCCL        

--and (settl_id not like '%1201090000003024%' and  settl_id not like '%1201090000000116%')        

--and dr_cr='D'        

--union all        

--SELECT distinct bo_id  FROM cdslbill_nsccl where billmonth = month(@pa_from_dt)         

--and billyear =year(@pa_from_dt) and bill_amount = '0'        

--and dr_cr ='D'        

--and (settl_id like '%1201090000003024%' or settl_id like '%1201090000000116%')        

--union all        

--SELECT distinct bo_id  FROM cdslbill_remat where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and bill_amount <> '0'--REMAT        

--union all        

--SELECT distinct boid  FROM cdslbill_cisa_ovrd_cr where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and bill_amt <> '0'--cisa_ovrd_cr        

--union all        

--SELECT distinct pledgor_bo_id FROM cdslbill_pldg_setup_pledgor where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgor_bill_amt <> '0' --plg_setup_pledgor          

--union all        

--SELECT distinct pledgee_bo_id FROM cdslbill_pldg_setup_pledgee where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgee_bill_amt <> '0'--pldg_setup_pledgee        

--union all        

--SELECT distinct pledgor_bo_id FROM cdslbill_pldg_setup_pledgee where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgor_bill_amt <> '0'--pldg_setup_pledgee        

--union all        

--SELECT distinct pledgor_bo_id FROM cdslbill_pldg_inv_pledgor where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgor_bill_amt <> '0'--pldg_inv_pledgor        

--union all        

--SELECT distinct pledgee_bo_id FROM cdslbill_pldg_inv_pledgee where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgor_bill_amt <> '0'--pldg_inv_pledgee        

--union all        

--SELECT distinct pledgor_bo_id FROM cdslbill_unpldg where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgor_bill_amt <> '0'--unpldg         

--) a         

--        







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

select DISTINCT CDSHM_BEN_ACCT_NO  from cdsl_holding_dtls_bak_forreve with (nolock),#acctlist_br   where cdshm_tratm_cd ='2277'

and cdshm_cdas_sub_tras_type ='409'
AND CDSHM_DPAM_ID  = FILTERED_DPAMID


AND cdshm_tras_dt between @pa_from_dt and @pa_to_dt

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

SELECT DISTINCT CDSHM_BEN_ACCT_NO FROM cdsl_holding_dtls_bak_forreve with (nolock),#acctlist_br  

WHERE CDSHM_TRATM_CD ='2277'
AND CDSHM_DPAM_ID  = FILTERED_DPAMID

AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('107','1503','105')

AND CDSHM_BEN_ACCT_NO IN (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active')

AND CDSHM_ISIN LIKE 'INF%'

UNION ALL

SELECT DISTINCT CDSHM_BEN_ACCT_NO FROM cdsl_holding_dtls_bak_forreve with (nolock),#acctlist_br  WHERE CDSHM_TRATM_CD ='2277'

AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('707','3304') 
AND CDSHM_DPAM_ID  = FILTERED_DPAMID

AND citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,26,'~') <> 'j'

UNION ALL

SELECT DISTINCT CDSHM_BEN_ACCT_NO

FROM cdsl_holding_dtls_bak_forreve with (nolock),#acctlist_br  WHERE CDSHM_TRATM_CD ='2277'

AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('707','3304') AND CDSHM_DPAM_ID  = FILTERED_DPAMID
AND citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,26,'~') = 'J'

UNION ALL 

SELECT DISTINCT CDSHM_BEN_ACCT_NO FROM cdsl_holding_dtls_bak_forreve with (nolock),#acctlist_br  WHERE CDSHM_CDAS_SUB_TRAS_TYPE ='802'AND CDSHM_DPAM_ID  = FILTERED_DPAMID


UNION ALL

SELECT DISTINCT CDSHM_BEN_ACCT_NO FROM cdsl_holding_dtls_bak_forreve with (nolock),#acctlist_br  WHERE CDSHM_CDAS_SUB_TRAS_TYPE ='1002'AND CDSHM_DPAM_ID  = FILTERED_DPAMID














) a 



         

        

select * into #tmp_dp_acct_mstr  from dp_acct_mstr with (nolock)    ,#acctlist_br      

where dpam_id in (select distinct clic_dpam_id from client_charges_cdsl  with (nolock)            

     where clic_trans_dt between @pa_from_dt and @pa_to_dt)          

or  exists(select accp_clisba_id from #account_properties where accp_value between @pa_from_dt and @pa_to_dt and dpam_id = accp_clisba_id)          

or exists(select accp_clisba_id_cl from #account_properties_close where accp_value_cl between @pa_from_dt and @pa_to_dt and dpam_id  = accp_clisba_id_cl)          

or exists(SELECT boid FROM #cdslboid where dpam_sba_no  = boid)    

AND DPAM_ID = FILTERED_DPAMID
    

        

        

       

        

          

--select * from #account_properties_close where accp_value_cl between @pa_from_dt and @pa_to_dt          

--and accp_clisba_id_cl in (select distinct dpam_id from #tmp_dp_acct_mstr)          

          

select  dpam_id , dpam_sba_no ,dpam_bbo_code,isnull(CLIC_TRANS_DT ,@pa_from_dt)   CLIC_TRANS_DT ,        

--isnull(entm_name1,'') [branch code],           

case when clic_flg  ='M' then '***' + clic_charge_name else clic_charge_name end clic_charge_name, sum(CLIC_CHARGE_AMT)  charge_amt          

,isnull(accp_value,'') accp_value ,isnull(accp_value_cl   ,'') accp_value_cl           

into #tempdata   from #tmp_dp_acct_mstr with (nolock)         

left outer join #account_properties on accp_clisba_id = dpam_id           

left outer join #account_properties_close on accp_clisba_id_cl = dpam_id          

left outer join  client_charges_cdsl with (nolock)   on clic_dpam_id = dpam_id           

and   clic_trans_dt between @pa_from_dt and @pa_to_dt          

and isnull(CLIC_FLG,'B') not in ('B')        

--left outer join  entity_relationship  with (nolock) on  CLIC_TRANS_DT between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2100')               

--left outer join  entity_mstr with (nolock) on    (entr_br = entm_id or entr_sb = entm_id )              

--and   isnull(entr_sba,dpam_sba_no) =  dpam_sba_no           

group by dpam_id , dpam_sba_no, DPAM_BBO_CODE ,        

--isnull(entm_name1,''),          

clic_charge_name ,          

CLIC_TRANS_DT,accp_value,accp_value_cl  ,clic_flg        

     



    

--select * from #tmp_dp_acct_mstr where dpam_sba_no ='1201090005082991'        

--        

        

--          

--select boid,entm_short_name ,sum(convert(numeric(18,3),bill_amt)) bill_amt  into #totalcost from (        

--SELECT boid , bill_amt FROM cdslbill_cisa_clos_bal where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and (bill_amt <> '0' or isin like '%inf%')--cisa_closing_bal        

--        

--union all        

--SELECT boid,'5.5' FROM cdslbill_off where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and (bill_amount <> '0' or isin like '%inf%')--OFF        

--and dr_cr='D'        

--union all        

--SELECT boid,'5.5' FROM cdslbill_off2 where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and (bill_amount <> '0'or isin like '%inf%')--OFF        

--and dr_cr='D'        

--union all        

--SELECT fr_bo_id,'5.5' FROM cdslbill_ep where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt)         

--and (bill_amt <> '0')--EP         

--union all        

--SELECT boid,'5.5' FROM cdslbill_on where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and (bill_amount <> '0'or isin like '%inf%')--ON        

--and dr_cr='D'        

--union all        

--SELECT boid,'5.5' FROM cdslbill_id where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and (bill_Amt <> '0'or isin like '%inf%')--ID       

--union all       

--SELECT bo_id,'5.5' FROM cdslbill_nsccl where billmonth = month(@pa_from_dt)         

--and billyear =year(@pa_from_dt) and (bill_amount <> '0')--NSCCL        

--and dr_cr='D'        

--union all        

--SELECT bo_id,'5.5' FROM cdslbill_nsccl where billmonth = month(@pa_from_dt)         

--and billyear =year(@pa_from_dt) and (isin like '%inf%')--NSCCL        

--and (settl_id not like '%1201090000003024%' and  settl_id not like '%1201090000000116%')        

--and dr_cr='D'        

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

--) a left outer join  entity_relationship  on boid = entr_sba          

--and @pa_to_dt between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2900')        

--left outer join  entity_mstr         

--on (entm_id = entr_br or entr_sb = entm_id )        

--group by boid,entm_short_name        

        





select boid,entm_short_name ,sum(convert(numeric(18,3),AMT)) bill_amt  into #totalcost from (

--SELECT boid , bill_amt FROM cdslbill_cisa_clos_bal 

--where billmonth = month(@PA_FROM_DT) and billyear =year(@PA_FROM_DT) 

--and (bill_amt <> '0' or isin like '%inf%')--cisa_closing_bal

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

SELECT boid,'5.5' AMT FROM (SELECT cdshm_ben_acct_no BOID 

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

FROM cdsl_holding_dtls_bak_forreve with (nolock)  ,#acctlist_br

where cdshm_tras_dt between @pa_from_dt and @pa_to_dt

AND CDSHM_CDAS_SUB_TRAS_TYPE ='305'
AND CDSHM_DPAM_ID  = FILTERED_DPAMID

and CDSHM_TRATM_CD ='2277'

and (case when cdshm_ben_acct_no in (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active')

		 then 8 else len(CDSHM_COUNTER_DPID) end = len(CDSHM_COUNTER_DPID)

	or cdshm_isin like 'inf%')) B

UNION ALL

select CDSHM_BEN_ACCT_NO,'5.5' AMT from cdsl_holding_dtls_bak_forreve with (nolock)  ,#acctlist_br
where cdshm_tratm_cd ='2277'

and cdshm_cdas_sub_tras_type ='409'
AND CDSHM_DPAM_ID  = FILTERED_DPAMID

AND cdshm_tras_dt between @pa_from_dt and @pa_to_dt

and CITRUS_USR.fn_splitval_by(cdshm_trans_cdas_code,34,'~')='31'

UNION ALL 



select CDSHM_BEN_ACCT_NO ,'5.5' AMT from cdsl_holding_dtls_bak_forreve with (nolock)  ,#acctlist_br

 where cdshm_tratm_cd ='2277'

and cdshm_cdas_sub_tras_type ='109'
AND CDSHM_DPAM_ID  = FILTERED_DPAMID

AND CDSHM_BEN_ACCT_NO NOT IN (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active')

UNION ALL

select CDSHM_BEN_ACCT_NO  ,'5.5' AMT  from cdsl_holding_dtls_bak_forreve with (nolock)  ,#acctlist_br

 where cdshm_tratm_cd ='2277'

and cdshm_cdas_sub_tras_type ='109'
AND CDSHM_DPAM_ID  = FILTERED_DPAMID

AND CDSHM_BEN_ACCT_NO IN (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active')

AND CDSHM_ISIN LIKE 'INF%'

UNION ALL 

SELECT CDSHM_BEN_ACCT_NO , '5.5' AMT  FROM cdsl_holding_dtls_bak_forreve  with (nolock)  ,#acctlist_br

WHERE CDSHM_TRATM_CD ='2277'

AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('107','1503','105')
AND CDSHM_DPAM_ID  = FILTERED_DPAMID

AND CDSHM_BEN_ACCT_NO NOT IN (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active')

UNION ALL 

SELECT CDSHM_BEN_ACCT_NO , '5.5' AMT  FROM cdsl_holding_dtls_bak_forreve  with (nolock)  ,#acctlist_br

WHERE CDSHM_TRATM_CD ='2277'

AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('107','1503','105')
AND CDSHM_DPAM_ID  = FILTERED_DPAMID

AND CDSHM_BEN_ACCT_NO IN (select dpam_sba_no from dp_acct_mstr where dpam_clicm_Cd ='26' and dpam_stam_cd ='active')

AND CDSHM_ISIN LIKE 'INF%'

UNION ALL

SELECT CDSHM_BEN_ACCT_NO , CONVERT(NUMERIC(18,3),CEILING(ABS(CDSHM_QTY)/100.00)* CASE WHEN CDSHM_ISIN LIKE 'INC%' THEN 50 ELSE 10 END ) AMT  
FROM cdsl_holding_dtls_bak_forreve with (nolock)  ,#acctlist_br
WHERE CDSHM_TRATM_CD ='2277'
AND CDSHM_DPAM_ID  = FILTERED_DPAMID

AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('707','3304') AND citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,26,'~') <> 'j'

UNION ALL

SELECT CDSHM_BEN_ACCT_NO 

--,citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,26,'~'),ABS(CDSHM_QTY), citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,21,'~'), CONVERT(NUMERIC(18,3),CEILING(ABS(CDSHM_QTY)/100.00)*10) AMT  

,CONVERT(NUMERIC(18,3),CASE WHEN ABS(convert(numeric,CDSHM_QTY))/CASE WHEN  citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,21,'~') ='0' THEN  ABS(CDSHM_QTY) ELSE  citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,21,'~') END = 1 THEN  CONVERT(NUMERIC(18,3
),CEILING(ABS(CDSHM_QTY)/100.00)*CASE WHEN CDSHM_ISIN LIKE 'INC%' THEN 50 ELSE 10 END)  

ELSE ABS(CDSHM_QTY)/CASE WHEN  citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,21,'~') ='0' THEN  ABS(CDSHM_QTY) ELSE  citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,21,'~') END * CASE WHEN CDSHM_ISIN LIKE 'INC%' THEN 50 ELSE 10 END  END ) AMT

FROM cdsl_holding_dtls_bak_forreve with (nolock)  ,#acctlist_br
WHERE CDSHM_TRATM_CD ='2277'
AND CDSHM_DPAM_ID  = FILTERED_DPAMID

AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('707','3304') AND citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,26,'~') = 'J'

UNION ALL 

SELECT CDSHM_BEN_ACCT_NO , '12' AMT FROM cdsl_holding_dtls_bak_forreve with (nolock)  ,#acctlist_br WHERE CDSHM_CDAS_SUB_TRAS_TYPE ='802'
AND CDSHM_DPAM_ID  = FILTERED_DPAMID


UNION ALL

SELECT CDSHM_BEN_ACCT_NO,'12'AMT FROM cdsl_holding_dtls_bak_forreve with (nolock)  ,#acctlist_br WHERE CDSHM_CDAS_SUB_TRAS_TYPE in ('1002','905')
AND CDSHM_DPAM_ID  = FILTERED_DPAMID






) a left outer join  entity_relationship  on boid = entr_sba  

and @PA_to_DT between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2900')

left outer join  entity_mstr 

on (entm_id = entr_br or entr_sb = entm_id )

group by boid,entm_short_name





        

        

select boid,entm_short_name,sum(bill_amt) bill_amt into #branchwisetc from #totalcost group by entm_short_name,boid        

       

        

select  REPLACE(RIGHT(CONVERT(VARCHAR(11), @pa_from_dt, 106), 8), ' ', '-') AS [Month]          

,dpam_sba_no        

,dpam_bbo_code        

,entm_short_name [BranchCode]           

,entm_name1 [Branchname]           

,'0' [TradingCode]          

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

into #finaldata1 from #tempdata left outer join entity_relationship           

on entr_sba = dpam_sba_no           

and @pa_to_dt  between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2900')           

left outer join entity_mstr on  (entr_br = entm_id or entr_sb = entm_id )           

left outer join charge_mstr cham on cham.cham_slab_name = clic_charge_name          

group by dpam_sba_no,dpam_bbo_code,entm_short_name,entm_name1,clic_charge_name,cham_charge_type          

        

        

select  [Month],cast(dpam_sba_no as varchar(20)) dpam_sba_no,dpam_bbo_code [TradingCode],[BranchCode],[Branchname]        

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

into #finaldata from #finaldata1         

group by dpam_sba_no,dpam_bbo_code,[month], [BranchCode],[TradingCode]        

,[Branchname]        

        

        

delete from #finaldata where [BranchCode] is null         

        

update a        

set [Cost]     = convert(numeric(18,3),bill_amt)        

,[totalCost]   = convert(numeric(18,3),bill_amt)        

from #branchwisetc, #finaldata a        

where entm_short_name = [BranchCode]        

and boid = dpam_sba_no        

--        

--update a set [FR-Sharing] = isnull(RAVD_AMT ,0)        

--,[OurSharing] = 100 - isnull(RAVD_AMT ,0) from #finaldata a        

--left outer join revenue_dtls on RAVD_ENTITY  = substring([BranchCode] ,1,len([BranchCode])-3)        

--and @pa_from_dt between RAVD_FROM_DT and isnull(RAVD_TO_DT,'dec 31 2100')        

--        

      

        

           

select [Month]          

,[BranchCode]          

,[Branchname]          

,isnull([entm_short_name],'') subbroker        

,isnull([entm_name1],'') subbrokername        

,''''+cast(a.[dpam_sba_no] as varchar(20)) [dpam_sba_no]

,isnull([TradingCode]  ,'') [TradingCode]        

,brom_desc [scheme]        

,abs(sum([TotalRev]))  [Bill amt]         

,abs(sum([AdministrationCharge+Cdslcorporateamccharges])) [Administraton Charges]           

,abs(sum( [AccountOpeingCharge+Document]))  [DP DOCUMENT]        

,abs(sum([AMCBilled]))+abs(sum([LIfetimeamc]))+abs(sum([CorporateAMC])) [AMC charge]          

,abs(sum([TransactionBilled])) [TransactionBilled]          

,abs(sum([DematcouirerChargeBilled])) [DEMAT/REMAT (set up)]          

,abs(sum([DematRejection])) [DEMAT/REMAT (rejection)]          

,abs(sum([ServiceTax])) [ServiceTax]          

,abs(sum([TotalCost])+sum([TotalCost]*0.1236)) [Total CDSL TRX Charge with service tax]  -- into tempdataclient        

from #finaldata a, dp_acct_mstr b with (nolock)left outer join entity_relationship with (nolock)       

on entr_sba = dpam_sba_no         

 left outer join entity_mstr with (nolock) on entr_dummy1 = entm_id or entr_dummy3 = entm_id         

left outer join client_dp_brkg clidb with (nolock) on clidb_dpam_id = dpam_id    and clidb_deleted_ind = 1     

left outer join brokerage_mstr brom  with (nolock) on brom_id = clidb_brom_id          

where a.dpam_sba_no = b.dpam_sba_no         

and @pa_to_dt between isnull(clidb_eff_from_dt,'jan 01 1900') and isnull(clidb_eff_to_dt,'jan 01 2100')         

and @pa_to_dt between isnull(entr_from_dt,'jan 01 1900') and isnull(entr_to_dt,'jan 01 2100')         

--and [BranchCode] = 'RBHARATAT_BA'      

group by [Month]  ,a.[dpam_sba_no],[TradingCode]        

,[BranchCode],[Branchname]        

,[entm_short_name]         

,[entm_name1] ,brom_desc        

        

         

          

          

drop table #tmp_dp_acct_mstr          

drop table #tempdata          

drop table #account_properties          

drop table #account_properties_close          

drop table #finaldata          

          

END

GO
