-- Object: PROCEDURE dbo.Stp_HeaderNSEiTSp
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE  PROCEDURE Stp_HeaderNSEiTSp
@FromDate Varchar(11),
@FromContract Varchar(7),
@ToContract Varchar(7),
@FromParty Varchar(10),
@ToParty Varchar(10),
@BatchNo Varchar(7),
@BrokerSebiRegNo Varchar(12),
@GroupCode Varchar(10)

As

Declare
@@FromParty Varchar(10),
@@ToParty Varchar(10),
@@FromContract Varchar(7),
@@ToContract Varchar(7)

Select @@FromParty =  @FromParty
Select @@ToParty = @ToParty

If Ltrim(Rtrim(@@FromParty)) = '' And Ltrim(Rtrim(@@ToParty)) = ''
Begin
	Select @@FromParty = Min(Party_Code), @@ToParty = Max(Party_Code)  From Client2
End

Select @@FromContract =  @FromContract
Select @@ToContract = @ToContract

If Ltrim(Rtrim(@@FromContract)) = '' And Ltrim(Rtrim(@@ToContract)) = ''
Begin
	Select @@FromContract = '0000000', @@ToContract = '9999999' 
End

Select Header = @BatchNo + '|11', '1'+@BrokerSebiRegNo, TotalContract=isnull(Sum(ContractNo),0),
FDateTime = left(Replace(Replace(Replace(Convert(Varchar,Getdate(),120),'-',''),':',''),' ',''),8) +'|' + Right(Replace(Replace(Replace(Convert(Varchar,Getdate(),120),'-',''),':',''),' ',''),6)
From (
Select ContractNo=Count(DISTINCT ContractNo)
/*
From ISettlement I, Client2 C2
Where Tradeqty <> 0 And Sauda_Date Like @FromDate + '%' And ContractNo Between @@FromContract
and @@ToContract And I.Party_Code Between @@FromParty and @@ToParty
And C2.Party_code = I.Party_Code And C2.Dummy6 = 'NSEIT'
And ContractNo NOT IN (SELECT ContractNo FROM stp_header_New WHERE serviceProvider ='NSEIT')
*/
From Isettlement I, Multiisin M, Sett_Mst S, Owner O, Client1 C1, Client2 C2, Custodian C,  instclient_tbl T, scrip1 s1, scrip2 s2
Where ContractNo Between @@FromContract and @@ToContract and Sauda_Date Like @FromDate + '%'  
and I.Party_Code Between @@FromParty and @@ToParty and I.Scrip_Cd = M.Scrip_Cd and I.Series = M.Series and M.Valid=1 and 
I.Sett_no = S.Sett_No and I.Sett_type = S.Sett_Type and Tradeqty <> 0 and I.Party_Code = T.PartyCode
and I.Party_Code =  C2.Party_Code and C1.Cl_Code = C2.Cl_Code And C2.Dummy6 = 'NSEIT'
And C2.CltDpNo = C.custodiancode
And S1.Co_Code = S2.Co_Code
And S2.Series = S1.Series And S2.SCRIP_CD = I.Scrip_CD And S2.Series = I.Series
and C1.Family like (Case When @GroupCode = '' Then '%' Else @GroupCode End)
And ContractNo NOT IN (SELECT ContractNo FROM stp_header_New WHERE serviceProvider ='NSEIT')
Group By I.Scrip_Cd
Union All
Select ContractNo=Count(DISTINCT ContractNo)
/*
From Settlement I, Client2 C2
Where Tradeqty <> 0 And Sauda_Date Like @FromDate + '%' And ContractNo Between @@FromContract
and @@ToContract And I.Party_Code Between @@FromParty and @@ToParty
And C2.Party_code = I.Party_Code And C2.Dummy6 = 'NSEIT' 
And ContractNo NOT IN (SELECT ContractNo FROM stp_header_New WHERE serviceProvider ='NSEIT')*/
From settlement I, Multiisin M, Sett_Mst S, Owner O, Client1 C1, Client2 C2, Custodian C,  instclient_tbl T, scrip1 s1, scrip2 s2
Where ContractNo Between @@FromContract and @@ToContract and Sauda_Date Like @FromDate + '%'  
and I.Party_Code Between @@FromParty and @@ToParty and I.Scrip_Cd = M.Scrip_Cd and I.Series = M.Series and M.Valid=1 and 
I.Sett_no = S.Sett_No and I.Sett_type = S.Sett_Type and Tradeqty <> 0 and I.Party_Code = T.PartyCode
and I.Party_Code =  C2.Party_Code and C1.Cl_Code = C2.Cl_Code And C2.Dummy6 = 'NSEIT'
And C2.CltDpNo = C.custodiancode
And S1.Co_Code = S2.Co_Code
And S2.Series = S1.Series And S2.SCRIP_CD = I.Scrip_CD And S2.Series = I.Series
and C1.Family like (Case When @GroupCode = '' Then '%' Else @GroupCode End)
And ContractNo NOT IN (SELECT ContractNo FROM stp_header_New WHERE serviceProvider ='NSEIT')
Group By I.Scrip_Cd ) A

GO
