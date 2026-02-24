-- Object: PROCEDURE dbo.Rpt_DelProvAuction
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

--NSE--  
CREATE Proc Rpt_DelProvAuction (  
@Statusid Varchar(15),@Statusname Varchar(25),@Sett_No Varchar(7),@Sett_Type Varchar(2),@FromParty Varchar(10),@ToParty Varchar(10)) As  
  
Select S.Sett_No, S.Sett_Type,PayIn=Convert(Varchar,Start_date,103),SaudaDate=Convert(Varchar,Sauda_date,103),  
PayOut=Convert(Varchar,End_date,103),A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,C1.L_Address3,L_City,  
L_State,L_Zip,BillNo,ScripName=A.Scrip_CD,Qty=Sum(TradeQty),  
Amount=Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then Service_Tax Else 0 End)+Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End),  
MarketRate=Round((Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then Service_Tax Else 0 End)  
+Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End))/Sum(TradeQty),4),  
Sell_buy,Service_Tax=0,  
Ins_Chrg = 0,  
Turn_Tax = 0,  
Other_Chrg = 0,  
Sabi_Tax = 0,  
Broker_Chrg = 0   
From Client2 C2, Client1 C1, Settlement A, Sett_Mst S   
Where S.Sett_No = A.Sett_No And S.Sett_Type = A.Sett_Type And C1.Cl_Code = C2.Cl_Code  
And C2.Party_code = A.Party_Code And MarketRate > 0 And TradeQty > 0   
And A.Sett_No = @Sett_No And A.Sett_Type = @Sett_Type   
And A.Party_Code >= @FromParty And A.Party_Code <= @ToParty   
And AuctionPart Like 'AP%'  
And C1.Branch_Cd Like (Case When @Statusid = 'branch' Then @StatusName Else '%' End)  
And C1.sub_broker Like (Case When @Statusid = 'subbroker' Then @StatusName Else '%' End)  
And C1.trader Like (Case When @Statusid = 'trader' Then @StatusName Else '%' End)  
And C1.family Like (Case When @Statusid = 'family' Then @StatusName Else '%' End)  
And C2.Party_code Like (Case When @Statusid = 'client' Then @StatusName Else '%' End)  
and C2.PArty_Code not in ( Select AuctionParty From DelSegment )   
Group by S.Sett_No, S.Sett_Type,Start_date,Sauda_date,end_date,A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,  
C1.L_Address3,L_City,L_State,L_Zip,BillNo,A.Scrip_CD,Sell_buy   
Order by S.Sett_No, S.Sett_Type,A.Party_Code,A.Scrip_CD,Sell_buy

GO
