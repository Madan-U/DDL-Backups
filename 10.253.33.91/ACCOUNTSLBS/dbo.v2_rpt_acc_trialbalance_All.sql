-- Object: PROCEDURE dbo.v2_rpt_acc_trialbalance_All
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

/*  
v2_rpt_acc_trialbalance_All 'Dec 15 2006', 'codewise','partywise','normal','Apr 1 2006', 'Apr 1 2006', 1,'Apr 1 2006', 'BRANCH', '01', 'vdt', 'Y', ''  
*/  
/****** Object:  Stored Procedure dbo.v2_rpt_acc_trialbalance_All    Script Date: 03/28/2005 2:41:12 PM ******/  
CREATE PROCEDURE v2_rpt_acc_trialbalance_All  
 @vdt varchar(11),    /* As on date entered by user */  
 @flag varchar(15),    /* sort order for report - Codewise or Namewise */  
 @viewoption varchar(10),  /* options for accounts selection - ALL, GL, PARTY */  
 @balance varchar(10),   /* Normal or Withopbal */  
 @stdate varchar(11),   /* Start date entered by user */  
 @curryrstdate varchar(11),  /* start date of financial year */  
 @openentryflag int,  
 @openingentrydate varchar(11), /* O/p entry date ( vtyp = 18 ) fround from ledger for vdt <= last date entered by user */  
 @statusid varchar(20),   /* As Broker/Branch/Client etc. */  
 @statusname varchar(20),  /* In case of Branch login branchcode */  
 @sortbydate varchar(3),   /* Whether report is based on VDT or EDT */  
 @showzerobal varchar(1),  /* Show Zero Bal   */  
 @showmargin varchar(1)   /* Show Margin Ledger   */  
AS  
/*  
 v2_rpt_acc_trialbalance_All 'Dec 14 2006', 'codewise','partywise','normal','Apr  1 2006', 'Apr  1 2006', 1,'Apr  1 2006', 'BROKER', '%', 'vdt', 'Y', ''  
 v2_rpt_acc_trialbalance_All_Test 'Dec 14 2006', 'codewise','partywise','normal','Apr  1 2006', 'Apr  1 2006', 1,'Apr  1 2006', 'BROKER', '%', 'vdt', 'Y', ''  
*/  
BEGIN  
  
CREATE TABLE [dbo].[#tmpTrialBalance]  
 (  
 [cltcode] [varchar] (10) ,  
 [Acname] [varchar] (100) NULL ,  
 [branchcode] [varchar] (10) NULL,  
 [amount] [money] NULL ,  
 [Segment] [varchar] (4) NULL,  
 [Entity] [varchar] (50) NULL  
 ) ON [PRIMARY]  
  
  
  
INSERT INTO #tmpTrialBalance(cltcode,Acname,branchcode,amount)  
Exec ACCOUNT.DBO.newasp_trialbalance @vdt,@flag,@viewoption,@balance,@stdate,@curryrstdate,@openentryflag,@openingentrydate,@statusid,@statusname,@sortbydate  
  
if @viewoption='gl'  
 begin  
  INSERT INTO #tmpTrialBalance(amount)  
  exec ACCOUNT.DBO.newasp_trialbalancepartytotal @vdt,@flag,@viewoption,@balance,@stdate,@curryrstdate,@openentryflag,@openingentrydate,@statusid,@statusname,@sortbydate  
 end  
  
UPDATE #tmpTrialBalance set Segment='1NSE',Entity='CAPITAL - NSE' where Segment is NULL  
  
  
INSERT INTO #tmpTrialBalance(cltcode,Acname,branchcode,amount)  
Exec ACCOUNTBSE.DBO.newasp_trialbalance @vdt,@flag,@viewoption,@balance,@stdate,@curryrstdate,@openentryflag,@openingentrydate,@statusid,@statusname,@sortbydate  
  
if @viewoption='gl'  
 begin  
  INSERT INTO #tmpTrialBalance(amount)  
  exec ACCOUNTBSE.DBO.newasp_trialbalancepartytotal @vdt,@flag,@viewoption,@balance,@stdate,@curryrstdate,@openentryflag,@openingentrydate,@statusid,@statusname,@sortbydate  
 end  
  
UPDATE #tmpTrialBalance set Segment='2BSE',Entity='CAPITAL - BSE' where Segment is NULL  
  
----------------------------------------------COMMENTED SPECIFICALLY FOR VERSION---------------------------------------  
--Nsefo start  
INSERT INTO #tmpTrialBalance(cltcode,Acname,branchcode,amount)  
Exec ACCOUNTFO.DBO.newasp_trialbalance @vdt,@flag,@viewoption,@balance,@stdate,@curryrstdate,@openentryflag,@openingentrydate,@statusid,@statusname,@sortbydate  
  
if @viewoption='gl'  
 begin  
  INSERT INTO #tmpTrialBalance(amount)  
  exec ACCOUNTFO.DBO.newasp_trialbalancepartytotal @vdt,@flag,@viewoption,@balance,@stdate,@curryrstdate,@openentryflag,@openingentrydate,@statusid,@statusname,@sortbydate  
 end  
  
UPDATE #tmpTrialBalance set Segment='3NFO',Entity='DERIVATIVES - NSE' where Segment is NULL  
  
-- Nsefo end  
--Margin Trial Balance  
/*-------------------------------------------------------------------------------------------------------------------------*/  
--Bsefo start  
INSERT INTO #tmpTrialBalance(cltcode,Acname,branchcode,amount)  
Exec ACCOUNTBFO.DBO.newasp_trialbalance @vdt,@flag,@viewoption,@balance,@stdate,@curryrstdate,@openentryflag,@openingentrydate,@statusid,@statusname,@sortbydate  
  
if @viewoption='gl'  
 begin  
  INSERT INTO #tmpTrialBalance(amount)  
  exec ACCOUNTBFO.DBO.newasp_trialbalancepartytotal @vdt,@flag,@viewoption,@balance,@stdate,@curryrstdate,@openentryflag,@openingentrydate,@statusid,@statusname,@sortbydate  
 end  
  
UPDATE #tmpTrialBalance set Segment='3BFO',Entity='DERIVATIVES - BSE' where Segment is NULL  
  
--Bsefo end  
/*-------------------------------------------------------------------------------------------------------------------------*/  
  
  
INSERT INTO #tmpTrialBalance(cltcode,Acname,branchcode,amount)  
Exec ACCOUNT.DBO.newasp_MarginTrialbalance @vdt,@flag,@viewoption,@balance,@stdate,@curryrstdate,@openentryflag,@openingentrydate,@statusid,@statusname,@sortbydate  
  
if @viewoption='gl'  
 begin  
  INSERT INTO #tmpTrialBalance(amount)  
  exec ACCOUNT.DBO.newasp_MarginTrialbalancepartytotal @vdt,@flag,@viewoption,@balance,@stdate,@curryrstdate,@openentryflag,@openingentrydate,@statusid,@statusname,@sortbydate  
 end  
  
UPDATE #tmpTrialBalance set Segment='4NSE',Entity='MARGIN CAPITAL - NSE' where Segment is NULL  
  
INSERT INTO #tmpTrialBalance(cltcode,Acname,branchcode,amount)  
Exec ACCOUNTBSE.DBO.newasp_MarginTrialbalance @vdt,@flag,@viewoption,@balance,@stdate,@curryrstdate,@openentryflag,@openingentrydate,@statusid,@statusname,@sortbydate  
  
if @viewoption='gl'  
 begin  
  INSERT INTO #tmpTrialBalance(amount)  
  exec ACCOUNTBSE.DBO.newasp_MarginTrialbalancepartytotal @vdt,@flag,@viewoption,@balance,@stdate,@curryrstdate,@openentryflag,@openingentrydate,@statusid,@statusname,@sortbydate  
 end  
  
UPDATE #tmpTrialBalance set Segment='5BSE',Entity='MARGIN CAPITAL - BSE' where Segment is NULL  
  
----------------------------------------------COMMENTED SPECIFICALLY FOR VERSION---------------------------------------  
--Nsefo start  
INSERT INTO #tmpTrialBalance(cltcode,Acname,branchcode,amount)  
Exec ACCOUNTFO.DBO.newasp_MarginTrialbalance @vdt,@flag,@viewoption,@balance,@stdate,@curryrstdate,@openentryflag,@openingentrydate,@statusid,@statusname,@sortbydate  
  
if @viewoption='gl'  
 begin  
  INSERT INTO #tmpTrialBalance(amount)  
  exec ACCOUNTFO.DBO.newasp_MarginTrialbalancepartytotal @vdt,@flag,@viewoption,@balance,@stdate,@curryrstdate,@openentryflag,@openingentrydate,@statusid,@statusname,@sortbydate  
 end  
  
UPDATE #tmpTrialBalance set Segment='6NFO',Entity='MARGIN DERIVATIVES - NSE' where Segment is NULL  
--Nsefo end  
  
--Bsefo start  
INSERT INTO #tmpTrialBalance(cltcode,Acname,branchcode,amount)  
Exec ACCOUNTBFO.DBO.newasp_MarginTrialbalance @vdt,@flag,@viewoption,@balance,@stdate,@curryrstdate,@openentryflag,@openingentrydate,@statusid,@statusname,@sortbydate  
  
if @viewoption='gl'  
 begin  
  INSERT INTO #tmpTrialBalance(amount)  
  exec ACCOUNTBFO.DBO.newasp_MarginTrialbalancepartytotal @vdt,@flag,@viewoption,@balance,@stdate,@curryrstdate,@openentryflag,@openingentrydate,@statusid,@statusname,@sortbydate  
 end  
  
UPDATE #tmpTrialBalance set Segment='6BFO',Entity='MARGIN DERIVATIVES - BSE' where Segment is NULL  
--Nsefo end  
  

INSERT INTO #tmpTrialBalance(cltcode,Acname,branchcode,amount)  
Exec ACCCOMMON.DBO.newasp_trialbalance @vdt,@flag,@viewoption,@balance,@stdate,@curryrstdate,@openentryflag,@openingentrydate,@statusid,@statusname,@sortbydate  
  
if @viewoption='gl'  
 begin  
  INSERT INTO #tmpTrialBalance(amount)  
  exec ACCCOMMON.DBO.newasp_trialbalancepartytotal @vdt,@flag,@viewoption,@balance,@stdate,@curryrstdate,@openentryflag,@openingentrydate,@statusid,@statusname,@sortbydate  
 end  
  
UPDATE #tmpTrialBalance set Segment='7COM',Entity='COMMON - COMMON' where Segment is NULL  

  
if @viewoption='gl'  
 begin  
  UPDATE #tmpTrialBalance set Acname='Client Balances',cltcode=' ',branchcode=' ' where cltcode is NULL  
 end  
  
/* Added by UPPILIK */  
  
update #tmpTrialBalance  
set Amount = isnull(amount,0)  
  
  
Delete from #tmpTrialBalance  
where isnull(cltcode,'') = '' and isnull(Acname,'') = ''  
  
/*if @statusid = 'BRANCH'  
begin  
 delete from #TmpTrialBalance  
 where branchcode <> @statusname  
 and branchcode <> 'ALL'  
end */  
  
if @statusid = 'CLIENT'  
begin  
 delete from #TmpTrialBalance  
 where cltcode <> @statusname  
end  
/*  
v2_rpt_acc_trialbalance_All 'Dec 15 2006', 'codewise','partywise','normal','Apr 1 2006', 'Apr 1 2006', 1,'Apr 1 2006', 'BRANCH', '01', 'vdt', 'N', ''  
*/  
--select * From #tmpTrialBalance  
--where amount <> 0  
--return  
  
  
  
  
/* Added by UPPILIK */  
  
if @flag = 'codewise'  
 begin  
  
  
  if @showzerobal='Y'  
   begin  
  
    select cltcode,acname,branchcode,  
    sum(case when Segment='1NSE' then amount else 0 end) as NetNSECM,  
    sum(case when Segment='4NSE' then amount else 0 end) as NetNSECMML,  
    sum(case when Segment='2BSE' then amount else 0 end) as NetBSECM,  
    sum(case when Segment='5BSE' then amount else 0 end) as NetBSECMML,  
    sum(case when Segment='3NFO' then amount else 0 end) as NetNSEFO,  
    sum(case when Segment='6NFO' then amount else 0 end) as NetNSEFOML,  
    sum(case when Segment='3BFO' then amount else 0 end) as NetBSEFO,  
    sum(case when Segment='6BFO' then amount else 0 end) as NetBSEFOML,
    sum(case when Segment='7COM' then amount else 0 end) as NetCOMMON  
    from #tmpTrialBalance  
    group by cltcode,acname,branchcode  
    order by cltcode  
   end  
  else  
   begin  
    if @showmargin='Y'  
     begin  
  
      select cltcode,acname,branchcode,  
      sum(case when Segment='1NSE' then amount else 0 end) as NetNSECM,  
      sum(case when Segment='4NSE' then amount else 0 end) as NetNSECMML,  
      sum(case when Segment='2BSE' then amount else 0 end) as NetBSECM,  
      sum(case when Segment='5BSE' then amount else 0 end) as NetBSECMML,  
      sum(case when Segment='3NFO' then amount else 0 end) as NetNSEFO,  
      sum(case when Segment='6NFO' then amount else 0 end) as NetNSEFOML,  
      sum(case when Segment='3BFO' then amount else 0 end) as NetBSEFO,  
      sum(case when Segment='6BFO' then amount else 0 end) as NetBSEFOML,
      sum(case when Segment='7COM' then amount else 0 end) as NetCOMMON  
      from #tmpTrialBalance  
      group by cltcode,acname,branchcode  
      having  (  
      sum(case when Segment='1NSE' then amount else 0 end)<>0 OR  
      sum(case when Segment='4NSE' then amount else 0 end)<>0 OR  
      sum(case when Segment='2BSE' then amount else 0 end)<>0 OR  
      sum(case when Segment='5BSE' then amount else 0 end)<>0 OR  
      sum(case when Segment='3NFO' then amount else 0 end)<>0 OR  
      sum(case when Segment='6NFO' then amount else 0 end)<>0 OR  
      sum(case when Segment='3BFO' then amount else 0 end)<>0 OR  
      sum(case when Segment='6BFO' then amount else 0 end)<>0 OR
      sum(case when Segment='7COM' then amount else 0 end) <>0)  
      order by cltcode  
     end  
    else  
     begin  
  
      select cltcode,acname,branchcode,  
      sum(case when Segment='1NSE' then amount else 0 end) as NetNSECM,  
      sum(case when Segment='4NSE' then amount else 0 end) as NetNSECMML,  
      sum(case when Segment='2BSE' then amount else 0 end) as NetBSECM,  
      sum(case when Segment='5BSE' then amount else 0 end) as NetBSECMML,  
      sum(case when Segment='3NFO' then amount else 0 end) as NetNSEFO,  
      sum(case when Segment='6NFO' then amount else 0 end) as NetNSEFOML,  
      sum(case when Segment='3BFO' then amount else 0 end) as NetBSEFO,  
      sum(case when Segment='6BFO' then amount else 0 end) as NetBSEFOML,
      sum(case when Segment='7COM' then amount else 0 end) as NetCOMMON  
      from #tmpTrialBalance  
      group by cltcode,acname,branchcode  
      having    (  
      sum(case when Segment='1NSE' then amount else 0 end)<>0 OR  
      sum(case when Segment='2BSE' then amount else 0 end)<>0 OR  
      sum(case when Segment='3NFO' then amount else 0 end)<>0 OR  
      sum(case when Segment='3BFO' then amount else 0 end)<>0 OR
      sum(case when Segment='7COM' then amount else 0 end)<>0   )  
      order by cltcode  
     end  
   end  
 end  
else  
begin  
  if @showzerobal='Y'  
   begin  
    select cltcode,acname,branchcode,  
    sum(case when Segment='1NSE' then amount else 0 end) as NetNSECM,  
    sum(case when Segment='4NSE' then amount else 0 end) as NetNSECMML,  
    sum(case when Segment='2BSE' then amount else 0 end) as NetBSECM,  
    sum(case when Segment='5BSE' then amount else 0 end) as NetBSECMML,  
    sum(case when Segment='3NFO' then amount else 0 end) as NetNSEFO,  
    sum(case when Segment='6NFO' then amount else 0 end) as NetNSEFOML,  
    sum(case when Segment='3BFO' then amount else 0 end) as NetBSEFO,  
    sum(case when Segment='6BFO' then amount else 0 end) as NetBSEFOML,
    sum(case when Segment='7COM' then amount else 0 end) as NetCOMMON  
    from #tmpTrialBalance  
    group by cltcode,acname,branchcode  
    order by acname  
   end  
  else  
   begin  
    if @showmargin='Y'  
     begin  
      select cltcode,acname,branchcode,  
      sum(case when Segment='1NSE' then amount else 0 end) as NetNSECM,  
      sum(case when Segment='4NSE' then amount else 0 end) as NetNSECMML,  
      sum(case when Segment='2BSE' then amount else 0 end) as NetBSECM,  
      sum(case when Segment='5BSE' then amount else 0 end) as NetBSECMML,  
      sum(case when Segment='3NFO' then amount else 0 end) as NetNSEFO,  
      sum(case when Segment='6NFO' then amount else 0 end) as NetNSEFOML,  
      sum(case when Segment='3BFO' then amount else 0 end) as NetBSEFO,  
      sum(case when Segment='6BFO' then amount else 0 end) as NetBSEFOML,
      sum(case when Segment='7COM' then amount else 0 end) as NetCOMMON  
      from #tmpTrialBalance  
      group by cltcode,acname,branchcode  
      having    (  
      sum(case when Segment='1NSE' then amount else 0 end)<>0 OR  
      sum(case when Segment='4NSE' then amount else 0 end)<>0 OR  
      sum(case when Segment='2BSE' then amount else 0 end)<>0 OR  
      sum(case when Segment='5BSE' then amount else 0 end)<>0 OR  
      sum(case when Segment='3NFO' then amount else 0 end)<>0 OR  
      sum(case when Segment='6NFO' then amount else 0 end)<>0 OR  
      sum(case when Segment='3BFO' then amount else 0 end)<>0 OR  
      sum(case when Segment='6BFO' then amount else 0 end)<>0 OR
      sum(case when Segment='7COM' then amount else 0 end)<>0  )  
      order by acname  
     end  
    else  
     begin  
      select cltcode,acname,branchcode,  
      sum(case when Segment='1NSE' then amount else 0 end) as NetNSECM,  
      sum(case when Segment='4NSE' then amount else 0 end) as NetNSECMML,  
      sum(case when Segment='2BSE' then amount else 0 end) as NetBSECM,  
      sum(case when Segment='5BSE' then amount else 0 end) as NetBSECMML,  
      sum(case when Segment='3NFO' then amount else 0 end) as NetNSEFO,  
      sum(case when Segment='6NFO' then amount else 0 end) as NetNSEFOML,
      sum(case when Segment='7COM' then amount else 0 end) as NetCOMMON  
      from #tmpTrialBalance  
      group by cltcode,acname,branchcode  
      having    (  
      sum(case when Segment='1NSE' then amount else 0 end)<>0 OR  
      sum(case when Segment='2BSE' then amount else 0 end)<>0 OR  
      sum(case when Segment='3NFO' then amount else 0 end)<>0 OR  
      sum(case when Segment='3BFO' then amount else 0 end)<>0 OR
      sum(case when Segment='7COM' then amount else 0 end)<>0  )  
      order by acname  
     end  
   end  
 end  
END

GO
