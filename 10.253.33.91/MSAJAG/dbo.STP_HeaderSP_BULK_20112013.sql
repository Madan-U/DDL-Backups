-- Object: PROCEDURE dbo.STP_HeaderSP_BULK_20112013
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

    
CREATE     PROCEDURE [dbo].[STP_HeaderSP_BULK_20112013]        
@FromDate Varchar(11),        
@FromContract Varchar(7),        
@ToContract Varchar(7),        
@FromParty Varchar(10),        
@ToParty Varchar(10),        
@BatchNo Varchar(7),        
@BrokerSebiRegNo Varchar(12),        
@FromCustodian Varchar(20),        
@ToCustodian Varchar(20),        
@FromCP Varchar(8),        
@ToCP Varchar(8),        
@GroupCode Varchar(10)        
        
As        
        
If Ltrim(Rtrim(@FromCustodian)) = '' And Ltrim(Rtrim(@ToCustodian)) = ''        
Begin        
 Select @FromCustodian = Min(custodiancode), @ToCustodian = Max(custodiancode)  From Custodian        
End        
        
If Ltrim(Rtrim(@FromCP)) = '' And Ltrim(Rtrim(@ToCP)) = ''        
Begin        
 Select @FromCP = Min(DPId), @ToCp = Max(DPId)  From Custodian        
End        
        
Select Header = @BatchNo + '11', Filler=Space(6), Sebi=Left(@BrokerSebiRegNo+'            ',12), Filler1=Space(2),        
TotalContract=Replace(Space(5-Len(Sum(ContractNo))) + Rtrim(lTrim(Sum(ContractNo))),' ','0'),        
FDateTime = left(Replace(Replace(Replace(Convert(Varchar,Getdate(),120),'-',''),':',''),' ',''),12), Filler2=space(2)        
From (        
Select ContractNo=Count(DISTINCT ContractNo)         
From ISettlement I, Multiisin M, custodian C, Client1 C1, Client2 C2, instclient_tbl T        
Where C1.Cl_Code = C2.Cl_Code and C1.Cl_Type = 'INS' And C2.Dummy6 = 'NSDL'         
And C2.CltDpNo = C.CustodianCode And C.DpId Between @FromCp And @ToCp         
And Tradeqty <> 0 And Sauda_Date Like @FromDate + '%' And ContractNo Between @FromContract        
and @ToContract And I.Party_Code Between @FromParty and @ToParty        
And CustodianCode Between @FromCustodian And @ToCustodian        
And I.Party_Code = T.PartyCode And I.Party_Code = C2.Party_Code        
and I.Scrip_Cd = M.Scrip_Cd       
and M.Series = (Case When I.Series = 'BL' Then 'EQ'       
                     When I.Series = 'IL' Then 'EQ'       
                     When I.Series = 'IS' Then 'EQ'       
                     Else I.Series      
                End)      
and M.Valid=1         
and C1.Family like (Case When @GroupCode = '' Then '%' Else @GroupCode End)        
Group By I.Scrip_Cd        
        
Union All        
        
Select ContractNo=Count(DISTINCT ContractNo)        
From Settlement I, Multiisin M, custodian C, Client1 C1, Client2 C2, instclient_tbl T        
Where C1.Cl_Code = C2.Cl_Code and C1.Cl_Type = 'INS' And C2.Dummy6 = 'NSDL'         
And C2.CltDpNo = CustodianCode And C.DpId Between @FromCp And @ToCp         
And Tradeqty <> 0 And Sauda_Date Like @FromDate + '%' And ContractNo Between @FromContract        
and @ToContract And I.Party_Code Between @FromParty and @ToParty        
And CustodianCode Between @FromCustodian And @ToCustodian        
And I.Party_Code = T.PartyCode And I.Party_Code = C2.Party_Code         
and I.Scrip_Cd = M.Scrip_Cd       
and M.Series = (Case When I.Series = 'BL' Then 'EQ'       
                     When I.Series = 'IL' Then 'EQ'       
                     When I.Series = 'IS' Then 'EQ'       
                     Else I.Series      
                End)      
and M.Valid=1         
and C1.Family like (Case When @GroupCode = '' Then '%' Else @GroupCode End)        
Group By I.Scrip_Cd ) A

GO
