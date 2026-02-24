-- Object: PROCEDURE dbo.AngelClientSummaryRpt_DelAuction
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc AngelClientSummaryRpt_DelAuction (
@Statusid Varchar(15),@Statusname Varchar(25),@Sett_No Varchar(7),@Sett_Type Varchar(2),@FromParty Varchar(10),@ToParty Varchar(10)) As
Select A.Sett_No, A.Sett_Type,Start_date,ScripName=s2.Scrip_CD,Qty=Sum(TradeQty),
Amount=Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NSertax Else 0 End)+Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End),
MarketRate=Round((Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NSertax Else 0 End)
+Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End))/Sum(TradeQty),4),
Sell_buy
From Client2 C2 With(Index(Pk_Client2), Nolock), Client1 C1 With(Index(Clcode),Nolock), 
Settlement A With(Index(Party),Nolock),  
Scrip2 S2 With(Nolock),Sett_Mst S With(Nolock),
(Select Top 2 Sett_no = Sett_no From Accbill With(Nolock) Where party_code = @StatusName and Sett_type = 'A' Order By Sett_no Desc)Sa
Where 
C1.Cl_Code = C2.Cl_Code
And C2.Party_code = A.Party_Code And MarketRate > 0 And TradeQty > 0 
And A.Sett_No = Sa.Sett_No 
And A.Sett_Type = 'A' and s2.Scrip_Cd = A.scrip_cd
and s2.series = A.Series
And A.Party_Code >= @FromParty And A.Party_Code <= @ToParty And AuctionPart Not Like 'A%'
And c2.party_code = @statusname 
And A.Sett_no = S.Sett_no And A.Sett_type = S.Sett_type
Group by A.Sett_No, A.Sett_Type,A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,
C1.L_Address3,L_City,L_State,L_Zip,BillNo,s2.Scrip_CD,Sell_buy,S.Start_date
Order by A.Sett_no Desc,A.Sett_type,s2.Scrip_CD,Sell_buy

GO
