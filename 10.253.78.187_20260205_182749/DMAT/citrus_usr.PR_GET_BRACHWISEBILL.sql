-- Object: PROCEDURE citrus_usr.PR_GET_BRACHWISEBILL
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--EXEC PR_GET_BRACHWISEBILL 'jun 01 2012','jun 30 2012'  
CREATE PROC [citrus_usr].[PR_GET_BRACHWISEBILL](@PA_FROM_DT DATETIME, @PA_TO_DT DATETIME)  
AS  
BEGIN  
select * into #tmp_dp_acct_mstr  from dp_acct_mstr   
where dpam_id in (select distinct clic_dpam_id from client_charges_cdsl    
where clic_trans_dt between @PA_FROM_DT and @PA_TO_DT)  
  
  
  
  
  
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
  
--select * from #account_properties_close where accp_value_cl between @PA_FROM_DT and @PA_TO_DT  
--and accp_clisba_id_cl in (select distinct dpam_id from #tmp_dp_acct_mstr)  
  
select  dpam_id , dpam_sba_no ,CLIC_TRANS_DT ,  
--isnull(entm_name1,'') [branch code],   
clic_charge_name , sum(CLIC_CHARGE_AMT)  charge_amt  
,isnull(accp_value,'') accp_value ,isnull(accp_value_cl   ,'') accp_value_cl   
into #tempdata  from #tmp_dp_acct_mstr with (nolock), client_charges_cdsl with (nolock)   
--left outer join  entity_relationship  with (nolock) on  CLIC_TRANS_DT between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2100')       
--left outer join  entity_mstr with (nolock) on    (entr_br = entm_id or entr_sb = entm_id )      
left outer join #account_properties on accp_clisba_id = clic_dpam_id   
left outer join #account_properties_close on accp_clisba_id_cl = clic_dpam_id   
where clic_dpam_id = dpam_id   
and   clic_trans_dt between @PA_FROM_DT and @PA_TO_DT  
--and   isnull(entr_sba,dpam_sba_no) =  dpam_sba_no   
group by dpam_id , dpam_sba_no,  
--isnull(entm_name1,''),  
clic_charge_name ,  
CLIC_TRANS_DT,accp_value,accp_value_cl  
  
select entm_short_name brcdopn,count(distinct b.dpam_sba_no) noofacctopn into #acctopn from #tmp_dp_acct_mstr a ,#tempdata b  left outer join entity_relationship   
on entr_sba = b.dpam_sba_no   
left outer join entity_mstr on  (entr_br = entm_id or entr_sb = entm_id )   
and accp_value between  ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2900')   
where  accp_value between @PA_FROM_DT and @PA_TO_DT   
and a.dpam_sba_no = b.dpam_sba_no   
and a.dpam_subcm_Cd not  in ('022552','022551','022543','022541'  
    ,'022538','022536','022523','022522','022521','022520'  
    ,'022519','022518','022517','022516','022515','022514'  
    ,'022513','022512','022567','022576','042207','042206'  
    ,'042205','052309','052308','052334','062826','242977','242927')   
group by entm_short_name  
  
select entm_short_name brcdopn_corp,count(distinct b.dpam_sba_no) noofacctopn_corp into #acctopn_corp from #tmp_dp_acct_mstr a ,#tempdata b  left outer join entity_relationship   
on entr_sba = b.dpam_sba_no   
left outer join entity_mstr on  (entr_br = entm_id or entr_sb = entm_id )   
and accp_value between  ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2900')   
where  accp_value between @PA_FROM_DT and @PA_TO_DT   
and a.dpam_sba_no = b.dpam_sba_no   
and a.dpam_subcm_Cd   in ('022552','022551','022543','022541'  
    ,'022538','022536','022523','022522','022521','022520'  
    ,'022519','022518','022517','022516','022515','022514'  
    ,'022513','022512','022567','022576','042207','042206'  
    ,'042205','052309','052308','052334','062826','242977','242927')   
group by entm_short_name  
  
  
select entm_short_name brcdoclos,count(distinct dpam_sba_no) noofacctclos into #acctclos from #tempdata left outer join  
 entity_relationship   
on entr_sba = dpam_sba_no   
left outer join entity_mstr on  (entr_br = entm_id or entr_sb = entm_id )   
and accp_value_cl between  ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2900')   
where  accp_value_cl between @PA_FROM_DT and @PA_TO_DT     
group by entm_short_name  
  
  
  
   
  
select  REPLACE(RIGHT(CONVERT(VARCHAR(11), @PA_FROM_DT, 106), 8), ' ', '-') AS [Month]  
,entm_short_name [BranchCode]   
,entm_name1 [Branchname]   
,'0' [TradingCode]  
,isnull(noofacctopn,'0') [AccountOpnedinMonth]  
,isnull(noofacctclos,'0') [ClosedDuringmonth]  
,isnull(noofacctopn_corp,'0') [CorporateAccountopenedduringthemonth]  
,0.000 [Cost]  
,0.000 [TotalCost]  
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
,0.000 [DematOursharing]  
,0.000  [FR-Sharing]  
,0.000 [OurSharing]  
,0.000[AmconclosedA/c]  
,0.000 [TotalChargesTODEBITEDIN1200A/C]  
,0.000 [Franchiseesharing]  
,0.000 [Tdsonfrincome]  
,0.000 [FRAMCSHARING]  
into #finaldata from #tempdata left outer join entity_relationship   
on entr_sba = dpam_sba_no   
and CLIC_TRANS_DT between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2900')   
left outer join entity_mstr on  (entr_br = entm_id or entr_sb = entm_id )   
left outer join #acctopn on entm_short_name  = brcdopn  
left outer join #acctclos on entm_short_name  = brcdoclos  
left outer join #acctopn_corp on entm_short_name  = brcdopn_corp  
left outer join charge_mstr cham on cham.cham_slab_name = clic_charge_name  
group by entm_short_name,entm_name1,noofacctopn,noofacctclos,noofacctopn_corp,clic_charge_name,cham_charge_type  
  
   
select [Month]  
,[BranchCode]  
,[Branchname]  
,[TradingCode]  
,[AccountOpnedinMonth]  
,[ClosedDuringmonth]  
,[CorporateAccountopenedduringthemonth]  
,abs(sum([Cost]))  
,abs(sum([TotalCost])) [TotalCost]  
,abs(sum([TotalRev]))[TotalRev]  
,abs(sum([AMCBilled])) [AMCBilled]  
,abs(sum( [AccountOpeingCharge+Document]))  [AccountOpeingCharge+Document]  
,abs(sum([TransactionBilled])) [TransactionBilled]  
,abs(sum([DematcouirerChargeBilled])) [DematcouirerChargeBilled]  
,abs(sum([DematRejection])) [DematRejection]  
,abs(sum([CorporateAMC])) [CorporateAMC]  
,abs(sum([AdministrationCharge+Cdslcorporateamccharges])) [AdministrationCharge+Cdslcorporateamccharges]  
,abs(sum([ServiceTax])) [ServiceTax]  
,abs([DematOursharing])  
,abs([FR-Sharing])  
,abs([OurSharing])  
,abs([AmconclosedA/c])  
,abs([TotalChargesTODEBITEDIN1200A/C])  
,abs([Franchiseesharing])  
,abs([Tdsonfrincome])  
,abs([FRAMCSHARING])  
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
