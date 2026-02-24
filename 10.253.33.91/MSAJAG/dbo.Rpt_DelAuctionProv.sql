-- Object: PROCEDURE dbo.Rpt_DelAuctionProv
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc Rpt_DelAuctionProv (      
@Statusid Varchar(15),@Statusname Varchar(25),@Sett_No Varchar(7),@Sett_Type Varchar(2),@FromParty Varchar(10),@ToParty Varchar(10)) As      
Declare @Remark Varchar(15)      
      
Select @Remark = 'Provisional'      
      
Select S.Sett_No, S.Sett_Type,PayIn=Convert(Varchar,Sec_Payin,103),      
PayOut=Convert(Varchar,Sec_Payout,103),Sauda_Date=Convert(Varchar,Sauda_Date,103),      
A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,C1.L_Address3,L_City,      
L_State,L_Zip,BillNo,ScripName=A.Scrip_CD,Qty=Sum(TradeQty),      
Amount=Round(Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NSerTax Else 0 End),2),      
MarketRate=Round((Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NSerTax Else 0 End))/Sum(TradeQty),2),      
Sell_buy,Service_Tax=Sum(Case When Service_Chrg = 0 Then NSerTax Else 0 End),      
Ins_Chrg = Sum(Case When C2.Insurance_Chrg = 1 Then Ins_Chrg Else 0 End),      
Turn_Tax = Sum(Case When Turnover_tax = 1 Then Turn_Tax Else 0 End),      
Other_Chrg = Sum(Case When C2.Other_Chrg = 1 Then (Case When AuctionPart Not Like 'F%' Then A.Other_Chrg Else 0 End) Else 0 End),      
Sabi_Tax = Sum(Case When Sebi_Turn_tax = 1 Then sebi_tax Else 0 End),      
Broker_Chrg = Sum(Case When BrokerNote = 1 Then Broker_chrg Else 0 End),Remark = @Remark,  
Penalty = Round(Sum(Case When AuctionPart Like 'AP%' Then A.Other_Chrg Else 0 End),2),AuctionPart,PenaltyPer=AuctionChrg,C1.Branch_Cd,C1.sub_broker      
From Client2 C2, Client1 C1, Settlement A, Sett_Mst S  , DelSegment      
Where S.Sett_No = A.Sett_No And S.Sett_Type = A.Sett_Type And C1.Cl_Code = C2.Cl_Code      
And C2.Party_code = A.Party_Code And MarketRate > 0 And TradeQty > 0       
And A.Sett_No = @Sett_No And A.Sett_Type = @Sett_Type       
And A.Party_Code >= @FromParty And A.Party_Code <= @ToParty And AuctionPart Like 'AP'      
And C1.Branch_Cd Like (Case When @Statusid = 'branch' Then @StatusName Else '%' End)      
And C1.sub_broker Like (Case When @Statusid = 'subbroker' Then @StatusName Else '%' End)      
And C1.trader Like (Case When @Statusid = 'trader' Then @StatusName Else '%' End)      
And C1.family Like (Case When @Statusid = 'family' Then @StatusName Else '%' End)      
And C2.Party_Code Like (Case When @Statusid = 'client' Then @StatusName Else '%' End)      
Group by S.Sett_No, S.Sett_Type,Start_date,end_date,C1.Branch_Cd,C1.sub_broker,A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,      
C1.L_Address3,L_City,L_State,L_Zip,BillNo,A.Scrip_CD,Sell_buy ,AuctionPart,AuctionChrg,s.sec_payin,s.sec_payout,Convert(Varchar,Sauda_Date,103)      
union all
Select S.Sett_No, S.Sett_Type,PayIn=Convert(Varchar,Sec_Payin,103),      
PayOut=Convert(Varchar,Sec_Payout,103),Sauda_Date=Convert(Varchar,Sauda_Date,103),      
A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,C1.L_Address3,L_City,      
L_State,L_Zip,BillNo,ScripName=A.Scrip_CD,Qty=Sum(TradeQty),      
Amount=Round(Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NSerTax Else 0 End),2),      
MarketRate=Round((Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NSerTax Else 0 End))/Sum(TradeQty),2),      
Sell_buy,Service_Tax=Sum(Case When Service_Chrg = 0 Then NSerTax Else 0 End),      
Ins_Chrg = Sum(Case When C2.Insurance_Chrg = 1 Then Ins_Chrg Else 0 End),      
Turn_Tax = Sum(Case When Turnover_tax = 1 Then Turn_Tax Else 0 End),      
Other_Chrg = Sum(Case When C2.Other_Chrg = 1 Then (Case When AuctionPart Not Like 'F%' Then A.Other_Chrg Else 0 End) Else 0 End),      
Sabi_Tax = Sum(Case When Sebi_Turn_tax = 1 Then sebi_tax Else 0 End),      
Broker_Chrg = Sum(Case When BrokerNote = 1 Then Broker_chrg Else 0 End),Remark = @Remark,  
Penalty = Round(Sum(Case When AuctionPart Like 'AP%' Then A.Other_Chrg Else 0 End),2),AuctionPart,PenaltyPer=AuctionChrg,C1.Branch_Cd,C1.sub_broker      
From Client2 C2, Client1 C1, History A, Sett_Mst S  , DelSegment      
Where S.Sett_No = A.Sett_No And S.Sett_Type = A.Sett_Type And C1.Cl_Code = C2.Cl_Code      
And C2.Party_code = A.Party_Code And MarketRate > 0 And TradeQty > 0       
And A.Sett_No = @Sett_No And A.Sett_Type = @Sett_Type       
And A.Party_Code >= @FromParty And A.Party_Code <= @ToParty And AuctionPart Like 'AP'      
And C1.Branch_Cd Like (Case When @Statusid = 'branch' Then @StatusName Else '%' End)      
And C1.sub_broker Like (Case When @Statusid = 'subbroker' Then @StatusName Else '%' End)      
And C1.trader Like (Case When @Statusid = 'trader' Then @StatusName Else '%' End)      
And C1.family Like (Case When @Statusid = 'family' Then @StatusName Else '%' End)      
And C2.Party_Code Like (Case When @Statusid = 'client' Then @StatusName Else '%' End)      
Group by S.Sett_No, S.Sett_Type,Start_date,end_date,C1.Branch_Cd,C1.sub_broker,A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,      
C1.L_Address3,L_City,L_State,L_Zip,BillNo,A.Scrip_CD,Sell_buy ,AuctionPart,AuctionChrg,s.sec_payin,s.sec_payout,Convert(Varchar,Sauda_Date,103)      
Order by S.Sett_No, S.Sett_Type,C1.Branch_Cd,C1.sub_broker,A.Party_Code,A.Scrip_CD,Sell_buy ,AuctionPart

GO
