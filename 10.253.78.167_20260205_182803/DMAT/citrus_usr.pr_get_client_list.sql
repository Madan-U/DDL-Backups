-- Object: PROCEDURE citrus_usr.pr_get_client_list
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


CREATE proc [citrus_usr].[pr_get_client_list](@pa_dt datetime)  
as  
begin   
  
declare @l_last_dt datetime  
declare @l_first_dt datetime  
set @l_last_dt = citrus_usr.LastMonthDay(DATEADD(mm,-1,@pa_dt))  
set @l_first_dt = citrus_usr.ufn_GetFirstDayOfMonth(DATEADD(mm,-1,@pa_dt))  
--*********Data for Inv To Zero*************----------  
PRINT @l_last_dt
PRINT @l_first_dt

--RETURN 

select DPAM_SBA_NO,DPAM_BBO_CODE ,DPAM_ID , CLIC_CHARGE_NAME,CLIC_CHARGE_AMT,CLIC_TRANS_DT    
into #amcaug2015    
from client_charges_cdsl,dp_acct_mstr  
--where CLIC_TRANS_DT between 'Feb  1 2016' and  'feb 29 2016'  
where CLIC_TRANS_DT between @l_first_dt and  @l_last_dt 
and (CLIC_CHARGE_NAME like '%acmain%'   or CLIC_CHARGE_NAME like 'VERSON 2.5 NORMAL_AC%'
or CLIC_CHARGE_NAME like 'ANGEL PREFERRED_ACMA'
 or CLIC_CHARGE_NAME like 'ANGEL PREMIER_ACMA'
 or CLIC_CHARGE_NAME like 'DIY 699_ACMA'
 or CLIC_CHARGE_NAME like 'ANGEL CLASSIC 699 VBB_ACMA'
 or CLIC_CHARGE_NAME like 'ANGEL CLASSIC 10000 VBB_ACMA'
 or CLIC_CHARGE_NAME like 'ANGEL PREFERRED VBB_ACMA'
 or CLIC_CHARGE_NAME like 'ITRADE PRIME_ACMA')
and DPAM_ID = CLIC_DPAM_ID   
--and dpam_sba_no = '1203320012975185'
   
---select * from #amcaug2015 WHERE  clic_dpam_id  = '670294'  
  
--DROP TABLE  #ledgerminusamcaug2015  
  
  
--****************REcovery check *************-  
 SELECT *   
INTO #ledgerminusamcaug2015   
 FROM #amcaug2015 WHERE NOT exists (  
 select LDG_ACCOUNT_ID  from ledger10  
  where DPAM_ID   = LDG_ACCOUNT_ID   and LDG_VOUCHER_DT >= @l_last_dt and LDG_DELETED_IND = '1' and LDG_VOUCHER_TYPE in ( '2','3')  
   and LDG_AMOUNT >'0'  
and LDG_ACCOUNT_TYPE = 'P')  
   
   
 --select * from #ledgerminusamcaug2015 WHERE  DPAM_ID = '549912'  
   
-- DROP TABLE #ledgerminusamcaug2015  
  --create clustered index ix_1 on #ledgerminusamcaug2015(DPAM_ID)  
 ---***Remove client who have done transaction in last 6 months*************----  
 select *  
 into #trxminusledger   
  from #ledgerminusamcaug2015 where  not exists  (  
 select distinct CDSHM_DPAM_ID  from cdsl_holding_dtls with(nolock) where cdshm_dpam_id = DPAM_ID    
 and CDSHM_TRAS_DT between DATEADD(mm,-6,@pa_dt) and @pa_dt)  
   
 --select * from cdsl_holding_dtls where CDSHM_TRAS_DT between 'feb 28 2015' and 'sep  1 2015' and CDSHM_DPAM_ID = '851929'  
   
 ---select * from #trxminusledger WHERE  DPAM_ID = '549912'  
------- till here it is ok for client with no transaction .     
    
--  DROP TABLE YTEMPHOLDINGVALUE  
    
---*********** take only clients who have holding value less than 500*************-----    
SELECT DPHMCD_DPAM_ID,  SUM(CONVERT (NUMERIC (18,2),RATE)*DPHMCD_FREE_QTY) [HOLDING VALUE]   
INTO #tempvalue  
FROM HOLDINGALLFORVIEW-- WHERE DPHMCD_DPAM_ID  = '496542'  
GROUP BY DPHMCD_DPAM_ID  
--HAVING SUM(RATE*DPHMCD_FREE_QTY )<500  
  
--select * from YTEMPHOLDINGVALUE where DPHMCD_DPAM_ID=549912  
  
---DROP TABLE ytempexclddphold  
  
--SELECT * FROM ytempexclddphold WHERE  DPAM_ID = '557560'  
--  
--into ytempexclddphold   
select t.* into #holdwithclienttrxexclude from   
(  
select  DPAM_SBA_NO,DPAM_BBO_CODE,DPAM_ID,CLIC_CHARGE_NAME  
 from #trxminusledger where DPAM_ID in (select DPHMCD_DPAM_ID from  #tempvalue  where [HOLDING VALUE]<500 )  
union  
select  DPAM_SBA_NO,DPAM_BBO_CODE,DPAM_ID,CLIC_CHARGE_NAME  
 from #trxminusledger where DPAM_ID not in (select DPHMCD_DPAM_ID from  #tempvalue  )  
) t  
  print '23'
--select * from #holdwithclienttrxexclude where DPAM_ID=549912  
    
    
    
  ------ with holding less than 500  
  --drop table ytempexcldclasstrx ytempsaudadate  
    
  -----------******* Remmove clients who have done transaction in Trading code in last 6 months************-------  
  select * into #tempclasstrx1 from AngelNseCM.msajag.dbo.MAXSAUDADATE where sauda_date between DATEADD(mm,-6,@pa_dt) and @pa_dt  
    
    
    
  select  * into #holdminusclasstrx1 from #holdwithclienttrxexclude where DPAM_BBO_CODE not in (  
  select PARTY_CODE from  #tempclasstrx1)  
    
  -- 5447  
    
  --select * from #holdminusclasstrx where  DPAM_ID in   
  --(select clic_dpam_id from client_charges_cdsl where CLIC_TRANS_DT between 'aug 01 2015' and 'aug 31 2015')  
  --and CLIC_CHARGE_NAME like '%acmain%')  
    
    
  -----*********** Remove account opening of current year ***********---------  
   
select distinct convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd into #account_properties
from account_properties O
where accp_accpm_prop_cd = 'BILL_START_DT' 
and accp_value not in ('','//','Jan  1 1900')
--AND NOT EXISTS (SELECT 1 FROM account_properties I WHERE O.ACCP_CLISBA_ID = I.ACCP_CLISBA_ID AND I.ACCP_ACCPM_PROP_CD ='AMC_DT'
-- AND ACCP_VALUE <> '' and accp_value not in ('','//')
--and accp_value not in ('','//','Jan  1 1900')
    
  select DPAM_SBA_NO    from #holdminusclasstrx1  
   ,client_dp_brkg,BROKERAGE_MSTR  ,#account_properties
  where   
  --isnumeric(convert(datetime,citrus_usr.fn_acct_entp(dpam_id,'Bill_start_dt'),103))=1 and 
  --year(convert(datetime,citrus_usr.fn_acct_entp(dpam_id,'Bill_start_dt'),103))<>YEAR(@pa_dt)   
  year(convert(datetime,accp_value,103))<>YEAR(@pa_dt)   
  and ACCP_CLISBA_ID=DPAM_ID
  and CLIDB_DPAM_ID=DPAM_ID   
  and @pa_dt between clidb_eff_from_dt   and   isnull(clidb_eff_to_dt,'2100-12-31 00:00:00.000')    
  and brom_id=clidb_brom_id and clidb_deleted_ind=1 and brom_deleted_ind=1  
  and BROM_DESC not like '%zero%' and BROM_DESC not like '%lif%'  
  and brom_id not in (18,19,73,74,46)--,71)--69 removed as per mail from vishal dated 24/04/2020
    
 end

GO
