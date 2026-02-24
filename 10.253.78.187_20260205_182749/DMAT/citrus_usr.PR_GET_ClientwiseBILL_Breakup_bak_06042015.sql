-- Object: PROCEDURE citrus_usr.PR_GET_ClientwiseBILL_Breakup_bak_06042015
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------







--EXEC [PR_GET_ClientwiseBILL_Breakup] 'jun 01 2013','jun 30 2013'  
create PROC [citrus_usr].[PR_GET_ClientwiseBILL_Breakup_bak_06042015](@pa_from_dt DATETIME, @pa_to_dt DATETIME    
--,@pa_branch_cd varchar(100)    
)          
AS          
BEGIN          
--select * into #tmp_dp_acct_mstr  from dp_acct_mstr           
--where dpam_id in (select distinct clic_dpam_id from client_charges_cdsl            
--where clic_trans_dt between @pa_from_dt and @pa_to_dt)          
--          
--          select 1 dsfd,2 fdfdfd
--
--return 
--
exec PR_GET_ClientwiseBILL_Breakup_auto_brwisefilter  @pa_from_dt,@pa_to_dt
return           

select distinct convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd           
into #account_properties from account_properties   with (nolock)        
where accp_accpm_prop_cd = 'BILL_START_DT'           
and accp_value not in ('')          
          
select distinct convert(datetime,accp_value,103) accp_value_cl          
, accp_clisba_id accp_clisba_id_cl , accp_accpm_prop_cd accp_accpm_prop_cd_cl           
into #account_properties_close from account_properties  with (nolock)         
where accp_accpm_prop_cd = 'ACC_CLOSE_DT'           
and accp_value not in ('','//')          
          
create index ix_1 on #account_properties(accp_clisba_id , accp_value )          
create index ix_2 on #account_properties_close(accp_clisba_id_cl , accp_value_cl )          
        
        
select * into #cdslboid from         
(SELECT distinct boid FROM cdslbill_cisa_clos_bal where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and (bill_amt <> '0' or isin like '%inf%')--cisa_closing_bal        
        
union all        
SELECT distinct boid  FROM cdslbill_off where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and (bill_amount <> '0' or isin like '%inf%')--OFF        
and dr_cr='D'        
union all        
SELECT distinct boid  FROM cdslbill_off2 where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and (bill_amount <> '0'or isin like '%inf%')--OFF        
and dr_cr='D'        
union all        
SELECT distinct  fr_bo_id FROM cdslbill_ep where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt)         
and (bill_amt <> '0')--EP         
union all        
SELECT distinct boid  FROM cdslbill_on where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and (bill_amount <> '0'or isin like '%inf%')--ON        
and dr_cr='D'        
union all        
SELECT distinct boid  FROM cdslbill_id where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and (bill_Amt <> '0'or isin like '%inf%')--ID        
union all        
SELECT distinct bo_id  FROM cdslbill_nsccl where billmonth = month(@pa_from_dt)         
and billyear =year(@pa_from_dt) and (bill_amount <> '0')--NSCCL        
and dr_cr='D'        
union all        
SELECT distinct bo_id  FROM cdslbill_nsccl where billmonth = month(@pa_from_dt)         
and billyear =year(@pa_from_dt) and (isin like '%inf%')--NSCCL        
and (settl_id not like '%1201090000003024%' and  settl_id not like '%1201090000000116%')        
and dr_cr='D'        
union all        
SELECT distinct bo_id  FROM cdslbill_nsccl where billmonth = month(@pa_from_dt)         
and billyear =year(@pa_from_dt) and bill_amount = '0'        
and dr_cr ='D'        
and (settl_id like '%1201090000003024%' or settl_id like '%1201090000000116%')        
union all        
SELECT distinct bo_id  FROM cdslbill_remat where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and bill_amount <> '0'--REMAT        
union all        
SELECT distinct boid  FROM cdslbill_cisa_ovrd_cr where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and bill_amt <> '0'--cisa_ovrd_cr        
union all        
SELECT distinct pledgor_bo_id FROM cdslbill_pldg_setup_pledgor where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgor_bill_amt <> '0' --plg_setup_pledgor          
union all        
SELECT distinct pledgee_bo_id FROM cdslbill_pldg_setup_pledgee where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgee_bill_amt <> '0'--pldg_setup_pledgee        
union all        
SELECT distinct pledgor_bo_id FROM cdslbill_pldg_setup_pledgee where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgor_bill_amt <> '0'--pldg_setup_pledgee        
union all        
SELECT distinct pledgor_bo_id FROM cdslbill_pldg_inv_pledgor where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgor_bill_amt <> '0'--pldg_inv_pledgor        
union all        
SELECT distinct pledgee_bo_id FROM cdslbill_pldg_inv_pledgee where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgor_bill_amt <> '0'--pldg_inv_pledgee        
union all        
SELECT distinct pledgor_bo_id FROM cdslbill_unpldg where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgor_bill_amt <> '0'--unpldg         
) a         
        
        
        
select * into #tmp_dp_acct_mstr  from dp_acct_mstr with (nolock)          
where dpam_id in (select distinct clic_dpam_id from client_charges_cdsl  with (nolock)            
     where clic_trans_dt between @pa_from_dt and @pa_to_dt)          
or dpam_id in (select accp_clisba_id from #account_properties where accp_value between @pa_from_dt and @pa_to_dt)          
or dpam_id in (select accp_clisba_id_cl from #account_properties_close where accp_value_cl between @pa_from_dt and @pa_to_dt)          
or dpam_sba_no in (SELECT boid FROM #cdslboid)        
        
        
        
        
          
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
        
          
select boid,entm_short_name ,sum(convert(numeric(18,3),bill_amt)) bill_amt  into #totalcost from (        
SELECT boid , bill_amt FROM cdslbill_cisa_clos_bal where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and (bill_amt <> '0' or isin like '%inf%')--cisa_closing_bal        
        
union all        
SELECT boid,'5.5' FROM cdslbill_off where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and (bill_amount <> '0' or isin like '%inf%')--OFF        
and dr_cr='D'        
union all        
SELECT boid,'5.5' FROM cdslbill_off2 where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and (bill_amount <> '0'or isin like '%inf%')--OFF        
and dr_cr='D'        
union all        
SELECT fr_bo_id,'5.5' FROM cdslbill_ep where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt)         
and (bill_amt <> '0')--EP         
union all        
SELECT boid,'5.5' FROM cdslbill_on where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and (bill_amount <> '0'or isin like '%inf%')--ON        
and dr_cr='D'        
union all        
SELECT boid,'5.5' FROM cdslbill_id where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and (bill_Amt <> '0'or isin like '%inf%')--ID        
union all       
SELECT bo_id,'5.5' FROM cdslbill_nsccl where billmonth = month(@pa_from_dt)         
and billyear =year(@pa_from_dt) and (bill_amount <> '0')--NSCCL        
and dr_cr='D'        
union all        
SELECT bo_id,'5.5' FROM cdslbill_nsccl where billmonth = month(@pa_from_dt)         
and billyear =year(@pa_from_dt) and (isin like '%inf%')--NSCCL        
and (settl_id not like '%1201090000003024%' and  settl_id not like '%1201090000000116%')        
and dr_cr='D'        
union all        
SELECT bo_id,'5.5' FROM cdslbill_nsccl where billmonth = month(@pa_from_dt)         
and billyear =year(@pa_from_dt) and bill_amount = '0'        
and dr_cr ='D'        
and (settl_id like '%1201090000003024%' or settl_id like '%1201090000000116%')        
union all        
SELECT bo_id,bill_amount FROM cdslbill_remat where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and bill_amount <> '0'--REMAT        
union all        
SELECT boid,bill_amt FROM cdslbill_cisa_ovrd_cr where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and bill_amt <> '0'--cisa_ovrd_cr        
union all        
SELECT pledgor_bo_id,pledgor_bill_amt FROM cdslbill_pldg_setup_pledgor where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgor_bill_amt <> '0' --plg_setup_pledgor          
union all        
SELECT pledgee_bo_id,pledgee_bill_amt FROM cdslbill_pldg_setup_pledgee where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgee_bill_amt <> '0'--pldg_setup_pledgee        
union all        
SELECT pledgor_bo_id,pledgor_bill_amt FROM cdslbill_pldg_setup_pledgee where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgor_bill_amt <> '0'--pldg_setup_pledgee        
union all        
SELECT pledgor_bo_id,pledgor_bill_amt FROM cdslbill_pldg_inv_pledgor where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgor_bill_amt <> '0'--pldg_inv_pledgor        
union all        
SELECT pledgee_bo_id,pledgor_bill_amt FROM cdslbill_pldg_inv_pledgee where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgor_bill_amt <> '0'--pldg_inv_pledgee        
union all        
SELECT pledgor_bo_id,pledgor_bill_amt FROM cdslbill_unpldg where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgor_bill_amt <> '0'--unpldg         
) a left outer join  entity_relationship  on boid = entr_sba          
and @pa_to_dt between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2900')        
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
left outer join client_dp_brkg clidb with (nolock) on clidb_dpam_id = dpam_id         
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
