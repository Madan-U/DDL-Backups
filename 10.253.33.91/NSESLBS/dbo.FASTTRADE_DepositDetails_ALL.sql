-- Object: PROCEDURE dbo.FASTTRADE_DepositDetails_ALL
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Procedure FASTTRADE_DepositDetails_ALL (@TradeDate Varchar(11)) AS  
  
/*  
 -------------------------------------------------------------------------------------------  
 Procedure Name  : sp_DepositDetails for F&O  
 Arguments  : Trade Date in MMM DD YYYY format   
 Description : Fetching Client's Deposit Details for a given date  
     Total Deposit  = Cash Collateral + Non Cash Collateral   
      + Effective Date Wise Ledger Balance  
     Ledger Financial Year Over Lapping vouchers are not considering for the   
    Computation of ledger balance  
     NSEFO, NCDX and MCDX is considering (if available).     
     Assuming all the databases are at same database server  
 -------------------------------------------------------------------------------------------  
*/  
  
if @TradeDate <> ''  
begin  
Set Transaction Isolation Level Read Uncommitted  
Declare @@opendate varchar(11)  
Declare @DataBaseName Varchar(20)  
  
  
CREATE TABLE [#DepostDetails]   
(  
 [BackOfficeId] [varchar] (10)  ,  
 [TotalDeposit] [money]  ,  
 [UserLevelDeposit] [varchar] (1)    
)  
  
CREATE TABLE [#LedgerBalance]   
(  
 [PartyCode] [varchar] (10)  ,  
 [LedgerBalance] [money]   
)  
  
CREATE INDEX [idxParty] ON [dbo].[#DepostDetails] ([BackOfficeId])  
CREATE INDEX [idxParty] ON [dbo].[#LedgerBalance] ([PartyCode])  
  
INSERT INTO #DepostDetails  
SELECT DISTINCT BackOfficeId = C.Cl_Code,  
       TotalDeposit = 0,  
       UserLevelDeposit = 1  
FROM CLIENT_DETAILS C, CLIENT_BROK_DETAILS C1
WHERE C.CL_CODE = C1.CL_CODE
AND LEN(C.CL_CODE) <= 8
  
/* Getting Collateral Details */  
Select   
 BackOfficeId = C.BackOfficeIdA,  
 TotalDeposit = SUM(Cash+NonCash)  
Into #CollDetails  
From  
 Msajag.Dbo.Collateral Cl(nolock),  
 #DepostDetails C (nolock)  
Where  
 Cl.Party_Code = C.BackOfficeId  
 And Trans_Date Like @TradeDate + '%'  
GROUP BY C.BackOfficeId  
  
CREATE INDEX [idxParty] ON [dbo].[#CollDetails] ([BackOfficeId])  
  
/*Getting Ledger Balance from MSAJAG AccountDatabase, if available*/  
Select @DataBaseName = Name  from Master.Dbo.SysdataBases Where Name = 'ACCOUNT'  
If @DataBaseName <> ''  
Begin  
	Insert Into #LedgerBalance
	SELECT L.CLTCODE, IsNull(sum( case when DrCr = 'C' then Vamt else - Vamt end),0) 
	FROM ACCOUNT.DBO.LEDGER L, ACCOUNT.DBO.PARAMETER P, #DepostDetails D
	WHERE L.VDT >= SDTCUR AND L.VDT <= @TradeDate + ' 23:59:59'
	AND @TradeDate BETWEEN SDTCUR AND LDTCUR AND CLTCODE = D.BackOfficeId
	GROUP BY CLTCODE
End  
  
/*Getting Ledger Balance from BSEDB AccountDatabase, if available*/  
Select @DataBaseName = Name  from Master.Dbo.SysdataBases Where Name = 'AccountBSE'  
If @DataBaseName <> ''  
Begin  
	Insert Into #LedgerBalance
	SELECT L.CLTCODE, IsNull(sum( case when DrCr = 'C' then Vamt else - Vamt end),0) 
	FROM ACCOUNTBSE.DBO.LEDGER L, ACCOUNTBSE.DBO.PARAMETER P, #DepostDetails D
	WHERE L.VDT >= SDTCUR AND L.VDT <= @TradeDate + ' 23:59:59'
	AND @TradeDate BETWEEN SDTCUR AND LDTCUR AND CLTCODE = D.BackOfficeId
	GROUP BY CLTCODE
End  

/*Getting Ledger Balance from NSEFO AccountDatabase, if available*/  
Select @DataBaseName = Name  from Master.Dbo.SysdataBases Where Name = 'ACCOUNTFO'  
If @DataBaseName <> ''  
Begin  
	Insert Into #LedgerBalance
	SELECT L.CLTCODE, IsNull(sum( case when DrCr = 'C' then Vamt else - Vamt end),0) 
	FROM ACCOUNTFO.DBO.LEDGER L, ACCOUNTFO.DBO.PARAMETER P, #DepostDetails D
	WHERE L.VDT >= SDTCUR AND L.VDT <= @TradeDate + ' 23:59:59'
	AND @TradeDate BETWEEN SDTCUR AND LDTCUR AND CLTCODE = D.BackOfficeId
	GROUP BY CLTCODE
End  
  
/*Getting Ledger Balance from NCDX AccountDatabase, if available*/  
Select @DataBaseName = Name  from Master.Dbo.SysdataBases Where Name = 'ACCOUNTNCDX'  
If @DataBaseName <> ''  
Begin  
	Insert Into #LedgerBalance
	SELECT L.CLTCODE, IsNull(sum( case when DrCr = 'C' then Vamt else - Vamt end),0) 
	FROM ACCOUNTNCDX.DBO.LEDGER L, ACCOUNTNCDX.DBO.PARAMETER P, #DepostDetails D
	WHERE L.VDT >= SDTCUR AND L.VDT <= @TradeDate + ' 23:59:59'
	AND @TradeDate BETWEEN SDTCUR AND LDTCUR AND CLTCODE = D.BackOfficeId
	GROUP BY CLTCODE
End  
  
/*Getting Ledger Balance from MCDX AccountDatabase, if available*/  
Select @DataBaseName = Name  from Master.Dbo.SysdataBases Where Name = 'ACCOUNTMCDX'  
If @DataBaseName <> ''  
Begin  
	Insert Into #LedgerBalance
	SELECT L.CLTCODE, IsNull(sum( case when DrCr = 'C' then Vamt else - Vamt end),0) 
	FROM ACCOUNTMCDX.DBO.LEDGER L, ACCOUNTMCDX.DBO.PARAMETER P, #DepostDetails D
	WHERE L.VDT >= SDTCUR AND L.VDT <= @TradeDate + ' 23:59:59'
	AND @TradeDate BETWEEN SDTCUR AND LDTCUR AND CLTCODE = D.BackOfficeId
	GROUP BY CLTCODE
End  

/*Getting Ledger Balance from NMCE AccountDatabase, if available*/  
Select @DataBaseName = Name  from Master.Dbo.SysdataBases Where Name = 'ACCOUNTNMCE'  
If @DataBaseName <> ''  
Begin  
	Insert Into #LedgerBalance
	SELECT L.CLTCODE, IsNull(sum( case when DrCr = 'C' then Vamt else - Vamt end),0) 
	FROM ACCOUNTNMCE.DBO.LEDGER L, ACCOUNTNMCE.DBO.PARAMETER P, #DepostDetails D
	WHERE L.VDT >= SDTCUR AND L.VDT <= @TradeDate + ' 23:59:59'
	AND @TradeDate BETWEEN SDTCUR AND LDTCUR AND CLTCODE = D.BackOfficeId
	GROUP BY CLTCODE
End 

/*updating COLLTERAL balance at Total Deposit*/  
Update  
 #DepostDetails  
Set   
 TotalDeposit = #DepostDetails.TotalDeposit + #COLLBal.TotalDeposit  
From   
 (  
 Select   
  BackOfficeId,  
  TotalDeposit = Sum(TotalDeposit)  
 From    
  #CollDetails  
 Group By  
  BackOfficeId  
 ) #COLLBal  
Where  
 #COLLBal.BackOfficeId = #DepostDetails.BackOfficeId  
  
/*updating ledger balance at Total Deposit*/  
Update  
 #DepostDetails  
Set   
 TotalDeposit = TotalDeposit + LedgerBalance  
From   
 (  
 Select   
  PartyCode,  
  LedgerBalance = Sum(LedgerBalance)  
 From    
  #LedgerBalance  
 Group By  
  PartyCode  
 ) #LdBal  
Where  
 PartyCode = BackOfficeId  
  
select party_code, margin=sum(totalmargin+mtom+addmargin),CL_TYPE  
INTO #FOMARGIN from nsefo.dbo.fomarginnew  
where mdate like @TradeDate + '%'   
group by party_code,CL_TYPE  
  
UPDATE #FOMARGIN SET PARTY_CODE = NEWPARTY_CODE  
FROM NSEFO.DBO.PARTYMAPPING M  
WHERE M.OLDPARTY_CODE = #FOMARGIN.PARTY_CODE  
AND CL_TYPE = 'C'  
  
update #DepostDetails set totaldeposit = totaldeposit - margin  
from #FOMARGIN A  
Where A.Party_code = #DepostDetails.BackOfficeId  
  
select party_code, margin=sum(totalmargin+addmargin),CL_TYPE  
INTO #NCDXMARGIN from NCDX.dbo.fomarginnew  
where mdate like @TradeDate + '%'   
group by party_code,CL_TYPE  
  
UPDATE #NCDXMARGIN SET PARTY_CODE = NEWPARTY_CODE  
FROM NCDX.DBO.PARTYMAPPING M  
WHERE M.OLDPARTY_CODE = #NCDXMARGIN.PARTY_CODE  
AND CL_TYPE = 'C'  
  
update #DepostDetails set totaldeposit = totaldeposit - margin  
from #NCDXMARGIN A  
Where A.Party_code = #DepostDetails.BackOfficeId  
  
select party_code, margin=sum(totalmargin+addmargin),CL_TYPE  
INTO #MCDXMARGIN from NCDX.dbo.fomarginnew  
where mdate like @TradeDate + '%'   
group by party_code,CL_TYPE  
  
UPDATE #MCDXMARGIN SET PARTY_CODE = NEWPARTY_CODE  
FROM MCDX.DBO.PARTYMAPPING M  
WHERE M.OLDPARTY_CODE = #MCDXMARGIN.PARTY_CODE  
AND CL_TYPE = 'C'  
  
update #DepostDetails set totaldeposit = totaldeposit - margin  
from #MCDXMARGIN A  
Where A.Party_code = #DepostDetails.BackOfficeId  
  
Drop table #LedgerBalance  
  
/* Fetching final output */  
Select   
 BackOfficeId,  
 UserLevelDeposit,'','',  
 TotalDeposit,  
 0,  
 0,  
 0   
From  
 #DepostDetails  
Order By  
 BackOfficeId  
  
end

GO
