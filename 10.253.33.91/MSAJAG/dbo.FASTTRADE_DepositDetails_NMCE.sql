-- Object: PROCEDURE dbo.FASTTRADE_DepositDetails_NMCE
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


Create Procedure FASTTRADE_DepositDetails_NMCE (@TradeDate Varchar(11)) AS  
  
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
 [ClientName] [varchar] (30)  ,  
 [ExchangeSegment] [varchar] (10)  ,  
 [TotalDeposit] [money]  ,  
 [NonCashComponentDeposit] [money] ,  
 [UnRelealizedAmount] [int]  ,  
 [PendingRequestFor] [int]  ,  
 [UserLevelDeposit] [varchar] (1)    
)  
  
CREATE TABLE [#LedgerBalance]   
(  
 [PartyCode] [varchar] (10)  ,  
 [LedgerBalance] [money]   
)  
  
CREATE INDEX [idxParty] ON [dbo].[#DepostDetails] ([BackOfficeId])  
CREATE INDEX [idxParty] ON [dbo].[#LedgerBalance] ([PartyCode])  
  
/* Getting Collateral Details */  
Insert Into #DepostDetails  
Select   
 BackOfficeId = C.Cl_Code,  
 ClientName = C.Short_Name,  
 ExchangeSegment = 'NMC',  
 TotalDeposit = Cash+NonCash,  
 NonCashComponentDeposit = NonCash,  
 UnRelealizedAmount = 0,  
 PendingRequestFor = 0,  
 UserLevelDeposit = '5'  
  
From  
 Msajag.Dbo.Collateral Cl(nolock),  
 Msajag.Dbo.ClientMaster C (nolock)  
Where  
 Cl.Party_Code = C.Party_Code  
 And Trans_Date Like @TradeDate + '%'  
 And Exchange = 'NMC'
 And Segment = 'FUTURES'  
  
/*Getting Ledger Balance from NSEFO AccountDatabase, if available*/  
Select @DataBaseName = Name  from Master.Dbo.SysdataBases Where Name = 'ACCOUNTNMC'  
If @DataBaseName <> ''  
Begin  
 Select @@opendate = Max(vdt) From ACCOUNTNMCE.dbo.Ledger (nolock) Where Vdt < @TradeDate  
 if @@opendate <> ''  
  Begin  
   Insert Into #LedgerBalance  
   Select  
    CltCode,  
    LedBal = IsNull(sum( case when DrCr = 'C' then Vamt else - Vamt end),0)      
   From   
    AccountFo.dbo.Ledger (nolock)  
   Where   
    Edt Like @@opendate + '%'   
    And vtyp = 18  
   Group By CltCode      
     
   Union All    
     
   Select   
    CltCode,  
    LedBal = IsNull(sum( case when DrCr = 'C' then Vamt else - Vamt end),0)        
   From  
    ACCOUNTNMCE.dbo.Ledger (nolock)  
   Where   
    Edt >=  @@opendate   
    And Edt <= @TradeDate + ' 23:59'   
    And vtyp <> 18  
   Group By CltCode  
  End  
 Else  
  Begin  
   
   Insert Into #LedgerBalance  
   Select  
    CltCode,  
    LedBal = IsNull(sum( case when DrCr = 'C' then Vamt else - Vamt end),0)        
   From  
    ACCOUNTNMCE.Dbo.Ledger b  
   Where  
    Edt  <= @TradeDate + ' 23:59'   
   Group By  
    CltCode      
  End  
End  
  
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
  
Drop table #LedgerBalance  
  
/* Fetching final output */  
Select   
 BackOfficeId,  
 ClientName,  
 ExchangeSegment='',  
 Market = '',
 TotalDeposit,  
 NonCashComponentDeposit,  
 UnRelealizedAmount,  
 PendingRequestFor
From  
 #DepostDetails  
Order By  
 BackOfficeId   

  
  
end

GO
