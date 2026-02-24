-- Object: PROCEDURE citrus_usr.PR_GET_BRACHWISEBILL_bak21112012_clientwise
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--EXEC [PR_GET_BRACHWISEBILL_bak21112012_clientwise] 'jan 01 2013','jan 31 2013' ,'RETAILJOD','AO' 
CREATE PROC [citrus_usr].[PR_GET_BRACHWISEBILL_bak21112012_clientwise]
(@PA_FROM_DT DATETIME, @PA_TO_DT DATETIME
,@pa_branch varchar(50)
,@pa_action varchar(100)
)  
AS  
BEGIN  

  
  
  
  
select distinct convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd   
into #account_properties from account_properties   
where accp_accpm_prop_cd = 'BILL_START_DT'   
and accp_value not in ('')  
  
select distinct convert(datetime,accp_value,103) accp_value_cl  
, accp_clisba_id accp_clisba_id_cl , accp_accpm_prop_cd accp_accpm_prop_cd_cl   
into #account_properties_close from account_properties   
where accp_accpm_prop_cd = 'ACC_CLOSE_DT'   
and accp_value not in ('','//')  



  
create index ix_1 on #account_properties(accp_clisba_id , accp_value )  
create index ix_2 on #account_properties_close(accp_clisba_id_cl , accp_value_cl )  
  


select * into #tmp_dp_acct_mstr  from dp_acct_mstr   
where dpam_id in (select distinct clic_dpam_id from client_charges_cdsl    
					where clic_trans_dt between @PA_FROM_DT and @PA_TO_DT)  
or dpam_id in (select accp_clisba_id from #account_properties where accp_value between @PA_FROM_DT and @PA_TO_DT)  
or dpam_id in (select accp_clisba_id_cl from #account_properties_close where accp_value_cl between @PA_FROM_DT and @PA_TO_DT)  

--select * from #account_properties_close where accp_value_cl between @PA_FROM_DT and @PA_TO_DT  
--and accp_clisba_id_cl in (select distinct dpam_id from #tmp_dp_acct_mstr)  
  
select  dpam_id , dpam_sba_no ,CLIC_TRANS_DT ,  
--isnull(entm_name1,'') [branch code],   
clic_charge_name , sum(CLIC_CHARGE_AMT)  charge_amt  
,isnull(accp_value,'') accp_value ,isnull(accp_value_cl   ,'') accp_value_cl   
into #tempdata  from #tmp_dp_acct_mstr with (nolock) 
left outer join #account_properties on accp_clisba_id = dpam_id   
left outer join #account_properties_close on accp_clisba_id_cl = dpam_id  
left outer join  client_charges_cdsl with (nolock)   on clic_dpam_id = dpam_id   
and   clic_trans_dt between @PA_FROM_DT and @PA_TO_DT  
--left outer join  entity_relationship  with (nolock) on  CLIC_TRANS_DT between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2100')       
--left outer join  entity_mstr with (nolock) on    (entr_br = entm_id or entr_sb = entm_id )      
 
where 
 isnull(CLIC_FLG,'') not in ('B')
--and   isnull(entr_sba,dpam_sba_no) =  dpam_sba_no   
group by dpam_id , dpam_sba_no,  
--isnull(entm_name1,''),  
clic_charge_name ,  
CLIC_TRANS_DT,accp_value,accp_value_cl  

  
select entm_short_name brcdopn,entr_sba,count(distinct b.dpam_sba_no) noofacctopn into #acctopn 
from #tmp_dp_acct_mstr a ,#tempdata b  left outer join entity_relationship   
on entr_sba = b.dpam_sba_no   
and @PA_to_DT  between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2100')
left outer join entity_mstr on  (entr_br = entm_id or entr_sb = entm_id )   
where  accp_value between @PA_FROM_DT and @PA_TO_DT   
and a.dpam_sba_no = b.dpam_sba_no   
and a.dpam_subcm_Cd not  in ('022552','022551','022543','022541'  
    ,'022538','022536','022523','022522','022521','022520'  
    ,'022519','022518','022517','022516','022515','022514'  
    ,'022513','022512','022567','022576','042207','042206'  
    ,'042205','052309','052308','052334','062826','242977','242927')   
and entm_short_name = @pa_branch
group by entm_short_name ,entr_sba 





  
select entm_short_name brcdopn_corp,entr_sba,count(distinct b.dpam_sba_no) noofacctopn_corp into #acctopn_corp from #tmp_dp_acct_mstr a ,#tempdata b  left outer join entity_relationship   
on entr_sba = b.dpam_sba_no   
left outer join entity_mstr on  (entr_br = entm_id or entr_sb = entm_id )   
where  accp_value between @PA_FROM_DT and @PA_TO_DT   
and a.dpam_sba_no = b.dpam_sba_no  
and accp_value between  isnull(ENTR_FROM_DT,'jan 01 1900') and isnull(ENTR_TO_DT,'dec 31 2900')   
and a.dpam_subcm_Cd   in ('022552','022551','022543','022541'  
    ,'022538','022536','022523','022522','022521','022520'  
    ,'022519','022518','022517','022516','022515','022514'  
    ,'022513','022512','022567','022576','042207','042206'  
    ,'042205','052309','052308','052334','062826','242977','242927')  
and entm_short_name = @pa_branch 
group by entm_short_name,entr_sba  
  
  
select entm_short_name brcdoclos,entr_sba,count(distinct dpam_sba_no) noofacctclos into #acctclos from #tempdata 
left outer join  
 entity_relationship   
on entr_sba = dpam_sba_no   
left outer join entity_mstr on  (entr_br = entm_id or entr_sb = entm_id )   
where  accp_value_cl between @PA_FROM_DT and @PA_TO_DT  
and accp_value_cl between  isnull(ENTR_FROM_DT,'jan 01 1900') and isnull(ENTR_TO_DT,'dec 31 2900')  
   and entm_short_name = @pa_branch
group by entm_short_name  ,entr_sba

if @pa_action ='AO'
begin 
select * from #acctopn 
return 
end 
if @pa_action ='CO'
begin 
select * from #acctopn_corp
return 
end 
if @pa_action ='AC'
begin 
select * from  #acctclos
return 
end 




  
 

select boid,entm_short_name ,descr,sum(convert(numeric(18,3),bill_amt)) bill_amt into #totalcost from (
SELECT boid , bill_amt,'cdslbill_cisa_clos_bal' descr FROM cdslbill_cisa_clos_bal where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and bill_amt <> '0' --cisa_closing_bal
union all
SELECT boid,'5.5','cdslbill_off' descr FROM cdslbill_off where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and bill_amount <> '0'--OFF
union all
SELECT boid,'5.5','cdslbill_off2' descr FROM cdslbill_off2 where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and bill_amount <> '0'--OFF
union all
SELECT fr_bo_id,'5.5','cdslbill_ep' descr FROM cdslbill_ep where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and bill_amt <> '0'--EP	
union all
SELECT boid,'5.5','cdslbill_on' descr FROM cdslbill_on where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and bill_amount <> '0'--ON
union all
SELECT boid,'5.5','cdslbill_id' descr FROM cdslbill_id where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and bill_Amt <> '0'--ID
union all
SELECT bo_id,'5.5','cdslbill_nsccl' descr FROM cdslbill_nsccl where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and bill_amount <> '0'--NSCCL
union all
SELECT bo_id,'5.5','cdslbill_nsccl' descr FROM cdslbill_nsccl where billmonth = month(@pa_from_dt) 
and billyear =year(@pa_from_dt) and bill_amount = '0'
and dr_cr ='D'
and (settl_id like '%1201090000003024%' or settl_id like '%1201090000000116%')
union all
SELECT bo_id,bill_amount,'cdslbill_remat' descr FROM cdslbill_remat where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and bill_amount <> '0'--REMAT
union all
SELECT boid,bill_amt,'cdslbill_cisa_ovrd_cr' descr FROM cdslbill_cisa_ovrd_cr where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and bill_amt <> '0'--cisa_ovrd_cr
union all
SELECT pledgor_bo_id,pledgor_bill_amt,'cdslbill_pldg_setup_pledgor' descr FROM cdslbill_pldg_setup_pledgor where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgor_bill_amt <> '0' --plg_setup_pledgor		
union all
SELECT pledgee_bo_id,pledgee_bill_amt,'cdslbill_pldg_setup_pledgee' descr FROM cdslbill_pldg_setup_pledgee where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgee_bill_amt <> '0'--pldg_setup_pledgee
union all
SELECT pledgor_bo_id,pledgor_bill_amt,'cdslbill_pldg_setup_pledgee' descr FROM cdslbill_pldg_setup_pledgee where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgor_bill_amt <> '0'--pldg_setup_pledgee
union all
SELECT pledgor_bo_id,pledgor_bill_amt,'cdslbill_pldg_inv_pledgor' descr FROM cdslbill_pldg_inv_pledgor where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgor_bill_amt <> '0'--pldg_inv_pledgor
union all
SELECT pledgee_bo_id,pledgor_bill_amt,'cdslbill_pldg_inv_pledgee' descr FROM cdslbill_pldg_inv_pledgee where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgor_bill_amt <> '0'--pldg_inv_pledgee
union all
SELECT pledgor_bo_id,pledgor_bill_amt,'cdslbill_unpldg' descr FROM cdslbill_unpldg where billmonth = month(@pa_from_dt) and billyear =year(@pa_from_dt) and pledgor_bill_amt <> '0'--unpldg 
) a , entity_relationship, entity_mstr where boid = entr_sba 
and @PA_FROM_DT between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2900')
and entm_short_name =@pa_branch
and (entm_id = entr_br or entr_sb = entm_id )
group by boid,entm_short_name,descr

if @pa_action ='COST'
begin 
select * from  #totalcost 
select boid,sum(bill_amt)+sum(bill_amt)*.1236 from  #totalcost  group by boid order by boid
return 
end 


select entm_short_name,sum(bill_amt) bill_amt into #branchwisetc from #totalcost group by entm_short_name

select  REPLACE(RIGHT(CONVERT(VARCHAR(11), @PA_FROM_DT, 106), 8), ' ', '-') AS [Month]  
,entm_short_name [BranchCode]   
,entm_name1 [Branchname]   
,'0' [TradingCode]  
,isnull(noofacctopn,'0') [AccountOpnedinMonth]  
,isnull(noofacctclos,'0') [ClosedDuringmonth]  
,isnull(noofacctopn_corp,'0') [CorporateAccountopenedduringthemonth]  
,convert(numeric(18,3),0.000) [Cost]  
,convert(numeric(18,3),0.000)  [TotalCost]  
,sum(charge_amt)  [TotalRev]  
,case when (cham_charge_type ='F' or cham_charge_type ='AMCPRO' or cham_charge_type ='O' )  and (clic_charge_name not like '%admin%' and clic_charge_name not like '%acop%' ) then sum(charge_amt)  else 0.000 end   [AMCBilled]  
,case when ( clic_charge_name  like '%acop%' ) and cham_charge_type ='O'  then sum(charge_amt)  else 0.000 end  [AccountOpeingCharge+Document]  
,case when clic_charge_name ='TRANSACTION CHARGES' then sum(charge_amt) else 0.000 end [TransactionBilled]  
,case when clic_charge_name ='DEMAT COURIER CHARGE' then sum(charge_amt) else 0.000 end [DematcouirerChargeBilled]  
,case when clic_charge_name ='DEMAT REJECTION CHARGE' then sum(charge_amt) else 0.000 end [DematRejection]  
,case when clic_charge_name ='CORPORATE AMC' then sum(charge_amt) else 0.000 end  [CorporateAMC]  
,case when (clic_charge_name  like '%admin%'  ) and (cham_charge_type ='O' or cham_charge_type ='AMCPRO')  then sum(charge_amt)  else 0.000 end   [AdministrationCharge+Cdslcorporateamccharges]  
,case when clic_charge_name = 'SERVICE TAX' then sum(charge_amt) else 0.000 end [ServiceTax]  
--,'' [FR-Sharing]  
,convert(numeric(18,3),0.000) [DematOursharing]  
,convert(numeric(18,3),0.000) [FR-Sharing]  
,convert(numeric(18,3),0.000) [OurSharing]  
,convert(numeric(18,3),0.000) [AmconclosedA/c]  
,convert(numeric(18,3),0.000) [TotalChargesTODEBITEDIN1200A/C]  
,convert(numeric(18,3),0.000) [Franchiseesharing]  
,convert(numeric(18,3),0.000) [Tdsonfrincome]  
,convert(numeric(18,3),0.000) [FRAMCSHARING]  , dpam_sba_no
into #finaldata1 from #tempdata left outer join entity_relationship   
on entr_sba = dpam_sba_no   
and CLIC_TRANS_DT between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2900')   
left outer join entity_mstr on  (entr_br = entm_id or entr_sb = entm_id )   
left outer join #acctopn on entm_short_name  = brcdopn  
left outer join #acctclos on entm_short_name  = brcdoclos  
left outer join #acctopn_corp on entm_short_name  = brcdopn_corp  
left outer join charge_mstr cham on cham.cham_slab_name = clic_charge_name  
group by entm_short_name,entm_name1,noofacctopn,noofacctclos,noofacctopn_corp,clic_charge_name,cham_charge_type  ,dpam_sba_no
  


select  [Month],[BranchCode],[Branchname],[TradingCode],[AccountOpnedinMonth] [AccountOpnedinMonth] ,[ClosedDuringmonth] [ClosedDuringmonth]
,[CorporateAccountopenedduringthemonth] [CorporateAccountopenedduringthemonth]
,abs(sum([Cost])) [Cost],abs(sum([TotalCost])) [TotalCost],abs(sum([TotalRev]) ) [TotalRev]
,abs(sum([AMCBilled]  )) [AMCBilled]
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
,abs(sum([FRAMCSHARING]  )) [FRAMCSHARING]  ,dpam_sba_no 
into #finaldata from #finaldata1 
group by [month], [BranchCode],[TradingCode]
,[Branchname]
,[AccountOpnedinMonth]
,[ClosedDuringmonth]
,[CorporateAccountopenedduringthemonth],dpam_sba_no



if @pa_action ='TOTALREV'
begin 
--select dpam_sba_no,[TotalRev] TotalRev  
--from  #finaldata  where [BranchCode] = @pa_branch 

SELECT DPAM_SBA_NO , SUM(CLIC_CHARGE_AMT) CLIC_CHARGE_AMT  FROM CLIENT_CHARGES_CDSL, DP_ACCT_MSTR  WHERE CLIC_DPAM_ID = DPAM_ID AND CLIC_DPAM_ID IN (
select DPAM_ID from entity_relationship , DP_ACCT_MSTR, ENTITY_MSTR  where (ENTR_SB = ENTM_ID OR ENTR_BR = ENTM_ID )
AND DPAM_SBA_NO = ENTR_SBA 
AND ENTM_SHORT_NAME = @PA_BRANCH
AND GETDATE() BETWEEN ENTR_FROM_DT AND ISNULL(ENTR_TO_DT,'DEC 31 2100'))
AND CLIC_FLG <> 'B'
and clic_trans_dt between @PA_FROM_DT and @PA_TO_DT 
GROUP BY DPAM_SBA_NO


return 
end 



delete from #finaldata where [BranchCode] is null 

update a
set [Cost]     = convert(numeric(18,3),bill_amt)
,[totalCost]   = convert(numeric(18,3),bill_amt)
from #branchwisetc, #finaldata a
where entm_short_name = [BranchCode]



update a set [FR-Sharing] = isnull(RAVD_AMT ,0)
,[OurSharing] = 100 - isnull(RAVD_AMT ,0) from #finaldata a
left outer join revenue_dtls on RAVD_ENTITY  = substring([BranchCode] ,1,len([BranchCode])-3)
and @PA_FROM_DT between RAVD_FROM_DT and isnull(RAVD_TO_DT,'dec 31 2100')



   
select [Month]  
,[BranchCode]  
,[Branchname]  
,[TradingCode]  
,[AccountOpnedinMonth]  
,[ClosedDuringmonth]  
,[CorporateAccountopenedduringthemonth]  
,abs(sum([Cost]))   [Cost]
,abs(sum([TotalCost])) [TotalCost]  
,abs(sum([TotalRev]))+ abs(sum([ServiceTax]))  [TotalRev]  
,abs(sum([AMCBilled])) [AMCBilled]  
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
,abs(((sum([cost])*sum([FR-Sharing]))/100) + (((sum([totalrev])-sum([ServiceTax]))*sum([OurSharing]))/100) + sum([ServiceTax] ))   [TotalChargesTODEBITEDIN1200A/C]
,abs(sum([TotalRev])) - abs(((sum([cost])*sum([FR-Sharing]))/100) + (((sum([totalrev])-sum([ServiceTax]))*sum([OurSharing]))/100) + sum([ServiceTax]) )  [Franchiseesharing]
,(abs(sum([TotalRev])) - abs(((sum([cost])*sum([FR-Sharing]))/100) + (((sum([totalrev])-sum([ServiceTax]))*sum([OurSharing]))/100) + sum([ServiceTax] )))*.10 [Tdsonfrincome]
,abs([FRAMCSHARING])   [FRAMCSHARING]
 from #finaldata group by [Month]  
,[BranchCode],[Branchname],[TradingCode],[AccountOpnedinMonth]  
,[ClosedDuringmonth],[CorporateAccountopenedduringthemonth],[DematOursharing]  
,[FR-Sharing],[OurSharing],[AmconclosedA/c],[TotalChargesTODEBITEDIN1200A/C]  
,[Franchiseesharing],[Tdsonfrincome],[FRAMCSHARING]
 
  
  
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
