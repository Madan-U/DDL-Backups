-- Object: PROCEDURE dbo.Rpt_DelAuction
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc Rpt_DelAuction (      
@Statusid Varchar(15),@Statusname Varchar(25),@Sett_No Varchar(7),@Sett_Type Varchar(2),@FromParty Varchar(10),@ToParty Varchar(10)) As      
      
      
Declare @CountRec int      
      
set transaction isolation level read uncommitted      
Select @CountRec = Count(1) from Settlement (nolock) where sett_no= @Sett_no and Sett_type= @Sett_type      
      
      
if @CountRec > 0       
begin      
 if @Statusid = 'broker'       
 Begin      
  Select S.Sett_No, S.Sett_Type,PayIn=Convert(Varchar,Start_date,103),      
  PayOut=Convert(Varchar,End_date,103),A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,C1.L_Address3,L_City,      
  L_State,L_Zip,BillNo,ScripName=Scrip_CD,Qty=Sum(TradeQty),      
  /*Amount=Round((Sum(TradeQty*N_NetRate)+Sum(A.Other_Chrg))/Sum(TradeQty),4)*Sum(TradeQty),*/      
  Amount=Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)+      
                   Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End) ,      
  MarketRate=Round((Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)      
  +Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End))/Sum(TradeQty),4),      
  Sell_buy,Service_Tax=Sum(Case When Service_Chrg = 0 Then NserTax Else 0 End),      
  Ins_Chrg = Sum(Case When C2.Insurance_Chrg = 1 Then Ins_Chrg Else 0 End),      
  Turn_Tax = Sum(Case When Turnover_tax = 1 Then Turn_Tax Else 0 End),      
  Other_Chrg = Sum(Case When C2.Other_Chrg = 1 Then (Case When AuctionPart Not Like 'F%' Then A.Other_Chrg Else 0 End) Else 0 End),      
  Sabi_Tax = Sum(Case When Sebi_Turn_tax = 1 Then sebi_tax Else 0 End),      
  Broker_Chrg = Sum(Case When BrokerNote = 1 Then Broker_chrg Else 0 End)      
  From Client2 C2, Client1 C1, Settlement A, Sett_Mst S       
  Where S.Sett_No = A.Sett_No And S.Sett_Type = A.Sett_Type And C1.Cl_Code = C2.Cl_Code      
  And C2.Party_code = A.Party_Code And MarketRate > 0 And TradeQty > 0       
  And A.Sett_No = @Sett_No And A.Sett_Type = @Sett_Type      
  And A.Party_Code >= @FromParty And A.Party_Code <= @ToParty And AuctionPart Not Like 'A%'      
  Group by S.Sett_No, S.Sett_Type,Start_date,end_date,A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,      
  C1.L_Address3,L_City,L_State,L_Zip,BillNo,Scrip_CD,Sell_buy      
  Order by S.Sett_No, S.Sett_Type,A.Party_Code,Scrip_CD,Sell_buy      
 End      
 if @Statusid = 'branch'       
 Begin      
  Select S.Sett_No, S.Sett_Type,PayIn=Convert(Varchar,Start_date,103),      
  PayOut=Convert(Varchar,End_date,103),A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,C1.L_Address3,L_City,      
  L_State,L_Zip,BillNo,ScripName=Scrip_CD,Qty=Sum(TradeQty),      
  /*Amount=Round((Sum(TradeQty*N_NetRate)+Sum(A.Other_Chrg))/Sum(TradeQty),4)*Sum(TradeQty),*/      
  Amount=Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)+Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End),      
  MarketRate=Round((Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)      
  +Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End))/Sum(TradeQty),4),      
  Sell_buy,Service_Tax=Sum(Case When Service_Chrg = 0 Then NserTax Else 0 End),      
  Ins_Chrg = Sum(Case When C2.Insurance_Chrg = 1 Then Ins_Chrg Else 0 End),      
  Turn_Tax = Sum(Case When Turnover_tax = 1 Then Turn_Tax Else 0 End),      
  Other_Chrg = Sum(Case When C2.Other_Chrg = 1 Then (Case When AuctionPart Not Like 'F%' Then A.Other_Chrg Else 0 End) Else 0 End),      
  Sabi_Tax = Sum(Case When Sebi_Turn_tax = 1 Then sebi_tax Else 0 End),      
  Broker_Chrg = Sum(Case When BrokerNote = 1 Then Broker_chrg Else 0 End)      
  From Client2 C2, Client1 C1, Settlement A, Sett_Mst S,  branches br       
  Where S.Sett_No = A.Sett_No And S.Sett_Type = A.Sett_Type And C1.Cl_Code = C2.Cl_Code      
  And C2.Party_code = A.Party_Code And MarketRate > 0 And TradeQty > 0       
  And A.Sett_No = @Sett_No And A.Sett_Type = @Sett_Type      
  And A.Party_Code >= @FromParty And A.Party_Code <= @ToParty And AuctionPart Not Like 'A%'      
  And Br.short_name = c1.trader and br.branch_cd = @statusname      
  Group by S.Sett_No, S.Sett_Type,Start_date,end_date,A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,      
  C1.L_Address3,L_City,L_State,L_Zip,BillNo,Scrip_CD,Sell_buy      
  Order by S.Sett_No, S.Sett_Type,A.Party_Code,Scrip_CD,Sell_buy      
 End      
 if @Statusid = 'subbroker'       
 Begin      
  Select S.Sett_No, S.Sett_Type,PayIn=Convert(Varchar,Start_date,103),      
  PayOut=Convert(Varchar,End_date,103),A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,C1.L_Address3,L_City,      
  L_State,L_Zip,BillNo,ScripName=Scrip_CD,Qty=Sum(TradeQty),      
  /*Amount=Round((Sum(TradeQty*N_NetRate)+Sum(A.Other_Chrg))/Sum(TradeQty),4)*Sum(TradeQty),*/      
  Amount=Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)+Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End),      
  MarketRate=Round((Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)      
  +Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End))/Sum(TradeQty),4),      
  Sell_buy,Service_Tax=Sum(Case When Service_Chrg = 0 Then NserTax Else 0 End),      
  Ins_Chrg = Sum(Case When C2.Insurance_Chrg = 1 Then Ins_Chrg Else 0 End),      
  Turn_Tax = Sum(Case When Turnover_tax = 1 Then Turn_Tax Else 0 End),      
  Other_Chrg = Sum(Case When C2.Other_Chrg = 1 Then (Case When AuctionPart Not Like 'F%' Then A.Other_Chrg Else 0 End) Else 0 End),      
  Sabi_Tax = Sum(Case When Sebi_Turn_tax = 1 Then sebi_tax Else 0 End),      
  Broker_Chrg = Sum(Case When BrokerNote = 1 Then Broker_chrg Else 0 End)      
  From Client2 C2, Client1 C1, Settlement A, Sett_Mst S, subbrokers sb        
  Where S.Sett_No = A.Sett_No And S.Sett_Type = A.Sett_Type And C1.Cl_Code = C2.Cl_Code      
  And C2.Party_code = A.Party_Code And MarketRate > 0 And TradeQty > 0       
  And A.Sett_No = @Sett_No And A.Sett_Type = @Sett_Type      
  And A.Party_Code >= @FromParty And A.Party_Code <= @ToParty And AuctionPart Not Like 'A%'      
  and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname      
  Group by S.Sett_No, S.Sett_Type,Start_date,end_date,A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,      
  C1.L_Address3,L_City,L_State,L_Zip,BillNo,Scrip_CD,Sell_buy      
  Order by S.Sett_No, S.Sett_Type,A.Party_Code,Scrip_CD,Sell_buy      
 End      
 if @Statusid = 'trader'       
 Begin      
  Select S.Sett_No, S.Sett_Type,PayIn=Convert(Varchar,Start_date,103),      
  PayOut=Convert(Varchar,End_date,103),A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,C1.L_Address3,L_City,      
  L_State,L_Zip,BillNo,ScripName=Scrip_CD,Qty=Sum(TradeQty),      
  /*Amount=Round((Sum(TradeQty*N_NetRate)+Sum(A.Other_Chrg))/Sum(TradeQty),4)*Sum(TradeQty),*/      
  Amount=Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)+Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End),      
  MarketRate=Round((Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)      
  +Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End))/Sum(TradeQty),4),      
  Sell_buy,Service_Tax=Sum(Case When Service_Chrg = 0 Then NserTax Else 0 End),      
  Ins_Chrg = Sum(Case When C2.Insurance_Chrg = 1 Then Ins_Chrg Else 0 End),      
  Turn_Tax = Sum(Case When Turnover_tax = 1 Then Turn_Tax Else 0 End),      
  Other_Chrg = Sum(Case When C2.Other_Chrg = 1 Then (Case When AuctionPart Not Like 'F%' Then A.Other_Chrg Else 0 End) Else 0 End),      
  Sabi_Tax = Sum(Case When Sebi_Turn_tax = 1 Then sebi_tax Else 0 End),      
  Broker_Chrg = Sum(Case When BrokerNote = 1 Then Broker_chrg Else 0 End)      
  From Client2 C2, Client1 C1, Settlement A, Sett_Mst S       
  Where S.Sett_No = A.Sett_No And S.Sett_Type = A.Sett_Type And C1.Cl_Code = C2.Cl_Code      
  And C2.Party_code = A.Party_Code And MarketRate > 0 And TradeQty > 0       
  And A.Sett_No = @Sett_No And A.Sett_Type = @Sett_Type      
  And A.Party_Code >= @FromParty And A.Party_Code <= @ToParty And AuctionPart Not Like 'A%'      
  And c1.trader = @statusname      
  Group by S.Sett_No, S.Sett_Type,Start_date,end_date,A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,      
  C1.L_Address3,L_City,L_State,L_Zip,BillNo,Scrip_CD,Sell_buy      
  Order by S.Sett_No, S.Sett_Type,A.Party_Code,Scrip_CD,Sell_buy      
 End      
 if @Statusid = 'family'       
 Begin      
  Select S.Sett_No, S.Sett_Type,PayIn=Convert(Varchar,Start_date,103),      
  PayOut=Convert(Varchar,End_date,103),A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,C1.L_Address3,L_City,      
  L_State,L_Zip,BillNo,ScripName=Scrip_CD,Qty=Sum(TradeQty),      
  /*Amount=Round((Sum(TradeQty*N_NetRate)+Sum(A.Other_Chrg))/Sum(TradeQty),4)*Sum(TradeQty),*/      
  Amount=Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)+Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End),      
  MarketRate=Round((Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)      
  +Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End))/Sum(TradeQty),4),      
  Sell_buy,Service_Tax=Sum(Case When Service_Chrg = 0 Then NserTax Else 0 End),      
  Ins_Chrg = Sum(Case When C2.Insurance_Chrg = 1 Then Ins_Chrg Else 0 End),      
  Turn_Tax = Sum(Case When Turnover_tax = 1 Then Turn_Tax Else 0 End),      
  Other_Chrg = Sum(Case When C2.Other_Chrg = 1 Then (Case When AuctionPart Not Like 'F%' Then A.Other_Chrg Else 0 End) Else 0 End),      
  Sabi_Tax = Sum(Case When Sebi_Turn_tax = 1 Then sebi_tax Else 0 End),      
  Broker_Chrg = Sum(Case When BrokerNote = 1 Then Broker_chrg Else 0 End)      
  From Client2 C2, Client1 C1, Settlement A, Sett_Mst S       
  Where S.Sett_No = A.Sett_No And S.Sett_Type = A.Sett_Type And C1.Cl_Code = C2.Cl_Code      
  And C2.Party_code = A.Party_Code And MarketRate > 0 And TradeQty > 0       
  And A.Sett_No = @Sett_No And A.Sett_Type = @Sett_Type      
  And A.Party_Code >= @FromParty And A.Party_Code <= @ToParty And AuctionPart Not Like 'A%'      
  And c1.family = @statusname      
  Group by S.Sett_No, S.Sett_Type,Start_date,end_date,A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,      
  C1.L_Address3,L_City,L_State,L_Zip,BillNo,Scrip_CD,Sell_buy      
  Order by S.Sett_No, S.Sett_Type,A.Party_Code,Scrip_CD,Sell_buy      
 End      
  
 if @Statusid = 'client'       
 Begin      
  Select S.Sett_No, S.Sett_Type,PayIn=Convert(Varchar,Start_date,103),      
  PayOut=Convert(Varchar,End_date,103),A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,C1.L_Address3,L_City,      
  L_State,L_Zip,BillNo,ScripName=Scrip_CD,Qty=Sum(TradeQty),      
  /*Amount=Round((Sum(TradeQty*N_NetRate)+Sum(A.Other_Chrg))/Sum(TradeQty),4)*Sum(TradeQty),*/      
  Amount=Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)+Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End),      
  MarketRate=Round((Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)      
  +Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End))/Sum(TradeQty),4),      
  Sell_buy,Service_Tax=Sum(Case When Service_Chrg = 0 Then NserTax Else 0 End),      
  Ins_Chrg = Sum(Case When C2.Insurance_Chrg = 1 Then Ins_Chrg Else 0 End),      
  Turn_Tax = Sum(Case When Turnover_tax = 1 Then Turn_Tax Else 0 End),      
  Other_Chrg = Sum(Case When C2.Other_Chrg = 1 Then (Case When AuctionPart Not Like 'F%' Then A.Other_Chrg Else 0 End) Else 0 End),      
  Sabi_Tax = Sum(Case When Sebi_Turn_tax = 1 Then sebi_tax Else 0 End),      
  Broker_Chrg = Sum(Case When BrokerNote = 1 Then Broker_chrg Else 0 End)      
  From Client2 C2, Client1 C1, Settlement A, Sett_Mst S       
  Where S.Sett_No = A.Sett_No And S.Sett_Type = A.Sett_Type And C1.Cl_Code = C2.Cl_Code      
  And C2.Party_code = A.Party_Code And MarketRate > 0 And TradeQty > 0       
  And A.Sett_No = @Sett_No And A.Sett_Type = @Sett_Type      
  And A.Party_Code >= @FromParty And A.Party_Code <= @ToParty And AuctionPart Not Like 'A%'      
  And c2.party_code = @statusname      
  Group by S.Sett_No, S.Sett_Type,Start_date,end_date,A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,      
  C1.L_Address3,L_City,L_State,L_Zip,BillNo,Scrip_CD,Sell_buy      
  Order by S.Sett_No, S.Sett_Type,A.Party_Code,Scrip_CD,Sell_buy      
 End    
    
  
 if @Statusid = 'area'       
 Begin      
  Select S.Sett_No, S.Sett_Type,PayIn=Convert(Varchar,Start_date,103),      
  PayOut=Convert(Varchar,End_date,103),A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,C1.L_Address3,L_City,      
  L_State,L_Zip,BillNo,ScripName=Scrip_CD,Qty=Sum(TradeQty),      
  /*Amount=Round((Sum(TradeQty*N_NetRate)+Sum(A.Other_Chrg))/Sum(TradeQty),4)*Sum(TradeQty),*/      
  Amount=Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)+Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End),      
  MarketRate=Round((Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)      
  +Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End))/Sum(TradeQty),4),      
  Sell_buy,Service_Tax=Sum(Case When Service_Chrg = 0 Then NserTax Else 0 End),      
  Ins_Chrg = Sum(Case When C2.Insurance_Chrg = 1 Then Ins_Chrg Else 0 End),      
  Turn_Tax = Sum(Case When Turnover_tax = 1 Then Turn_Tax Else 0 End),      
  Other_Chrg = Sum(Case When C2.Other_Chrg = 1 Then (Case When AuctionPart Not Like 'F%' Then A.Other_Chrg Else 0 End) Else 0 End),      
  Sabi_Tax = Sum(Case When Sebi_Turn_tax = 1 Then sebi_tax Else 0 End),      
  Broker_Chrg = Sum(Case When BrokerNote = 1 Then Broker_chrg Else 0 End)      
  From Client2 C2, Client1 C1, Settlement A, Sett_Mst S       
  Where S.Sett_No = A.Sett_No And S.Sett_Type = A.Sett_Type And C1.Cl_Code = C2.Cl_Code      
  And C2.Party_code = A.Party_Code And MarketRate > 0 And TradeQty > 0       
  And A.Sett_No = @Sett_No And A.Sett_Type = @Sett_Type      
  And A.Party_Code >= @FromParty And A.Party_Code <= @ToParty And AuctionPart Not Like 'A%'      
  And c1.area = @statusname      
  Group by S.Sett_No, S.Sett_Type,Start_date,end_date,A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,      
  C1.L_Address3,L_City,L_State,L_Zip,BillNo,Scrip_CD,Sell_buy      
  Order by S.Sett_No, S.Sett_Type,A.Party_Code,Scrip_CD,Sell_buy      
 End    
  
  
 if @Statusid = 'region'       
 Begin      
  Select S.Sett_No, S.Sett_Type,PayIn=Convert(Varchar,Start_date,103),      
  PayOut=Convert(Varchar,End_date,103),A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,C1.L_Address3,L_City,      
  L_State,L_Zip,BillNo,ScripName=Scrip_CD,Qty=Sum(TradeQty),      
  /*Amount=Round((Sum(TradeQty*N_NetRate)+Sum(A.Other_Chrg))/Sum(TradeQty),4)*Sum(TradeQty),*/      
  Amount=Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)+Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End),      
  MarketRate=Round((Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)      
  +Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End))/Sum(TradeQty),4),      
  Sell_buy,Service_Tax=Sum(Case When Service_Chrg = 0 Then NserTax Else 0 End),      
  Ins_Chrg = Sum(Case When C2.Insurance_Chrg = 1 Then Ins_Chrg Else 0 End),      
  Turn_Tax = Sum(Case When Turnover_tax = 1 Then Turn_Tax Else 0 End),      
  Other_Chrg = Sum(Case When C2.Other_Chrg = 1 Then (Case When AuctionPart Not Like 'F%' Then A.Other_Chrg Else 0 End) Else 0 End),      
  Sabi_Tax = Sum(Case When Sebi_Turn_tax = 1 Then sebi_tax Else 0 End),      
  Broker_Chrg = Sum(Case When BrokerNote = 1 Then Broker_chrg Else 0 End)      
  From Client2 C2, Client1 C1, Settlement A, Sett_Mst S       
  Where S.Sett_No = A.Sett_No And S.Sett_Type = A.Sett_Type And C1.Cl_Code = C2.Cl_Code      
  And C2.Party_code = A.Party_Code And MarketRate > 0 And TradeQty > 0       
  And A.Sett_No = @Sett_No And A.Sett_Type = @Sett_Type      
  And A.Party_Code >= @FromParty And A.Party_Code <= @ToParty And AuctionPart Not Like 'A%'      
  And c1.region = @statusname      
  Group by S.Sett_No, S.Sett_Type,Start_date,end_date,A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,      
  C1.L_Address3,L_City,L_State,L_Zip,BillNo,Scrip_CD,Sell_buy      
  Order by S.Sett_No, S.Sett_Type,A.Party_Code,Scrip_CD,Sell_buy      
 End    
  
end      
else      
begin      
      
 if @Statusid = 'broker'       
 Begin      
  Select S.Sett_No, S.Sett_Type,PayIn=Convert(Varchar,Start_date,103),      
  PayOut=Convert(Varchar,End_date,103),A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,C1.L_Address3,L_City,      
  L_State,L_Zip,BillNo,ScripName=Scrip_CD,Qty=Sum(TradeQty),      
  /*Amount=Round((Sum(TradeQty*N_NetRate)+Sum(A.Other_Chrg))/Sum(TradeQty),4)*Sum(TradeQty),*/      
  Amount=Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)+      
                   Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End) ,      
  MarketRate=Round((Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)      
  +Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End))/Sum(TradeQty),4),      
  Sell_buy,Service_Tax=Sum(Case When Service_Chrg = 0 Then NserTax Else 0 End),      
  Ins_Chrg = Sum(Case When C2.Insurance_Chrg = 1 Then Ins_Chrg Else 0 End),      
  Turn_Tax = Sum(Case When Turnover_tax = 1 Then Turn_Tax Else 0 End),      
  Other_Chrg = Sum(Case When C2.Other_Chrg = 1 Then (Case When AuctionPart Not Like 'F%' Then A.Other_Chrg Else 0 End) Else 0 End),      
  Sabi_Tax = Sum(Case When Sebi_Turn_tax = 1 Then sebi_tax Else 0 End),      
  Broker_Chrg = Sum(Case When BrokerNote = 1 Then Broker_chrg Else 0 End)      
  From Client2 C2, Client1 C1, History A, Sett_Mst S       
  Where S.Sett_No = A.Sett_No And S.Sett_Type = A.Sett_Type And C1.Cl_Code = C2.Cl_Code      
  And C2.Party_code = A.Party_Code And MarketRate > 0 And TradeQty > 0       
  And A.Sett_No = @Sett_No And A.Sett_Type = @Sett_Type      
  And A.Party_Code >= @FromParty And A.Party_Code <= @ToParty And AuctionPart Not Like 'A%'      
  Group by S.Sett_No, S.Sett_Type,Start_date,end_date,A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,      
  C1.L_Address3,L_City,L_State,L_Zip,BillNo,Scrip_CD,Sell_buy      
  Order by S.Sett_No, S.Sett_Type,A.Party_Code,Scrip_CD,Sell_buy      
 End      
 if @Statusid = 'branch'       
 Begin      
  Select S.Sett_No, S.Sett_Type,PayIn=Convert(Varchar,Start_date,103),      
  PayOut=Convert(Varchar,End_date,103),A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,C1.L_Address3,L_City,      
  L_State,L_Zip,BillNo,ScripName=Scrip_CD,Qty=Sum(TradeQty),      
  /*Amount=Round((Sum(TradeQty*N_NetRate)+Sum(A.Other_Chrg))/Sum(TradeQty),4)*Sum(TradeQty),*/      
  Amount=Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)+Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End),      
  MarketRate=Round((Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)      
  +Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End))/Sum(TradeQty),4),      
  Sell_buy,Service_Tax=Sum(Case When Service_Chrg = 0 Then NserTax Else 0 End),      
  Ins_Chrg = Sum(Case When C2.Insurance_Chrg = 1 Then Ins_Chrg Else 0 End),      
  Turn_Tax = Sum(Case When Turnover_tax = 1 Then Turn_Tax Else 0 End),      
  Other_Chrg = Sum(Case When C2.Other_Chrg = 1 Then (Case When AuctionPart Not Like 'F%' Then A.Other_Chrg Else 0 End) Else 0 End),      
  Sabi_Tax = Sum(Case When Sebi_Turn_tax = 1 Then sebi_tax Else 0 End),      
  Broker_Chrg = Sum(Case When BrokerNote = 1 Then Broker_chrg Else 0 End)      
  From Client2 C2, Client1 C1, History A, Sett_Mst S,  branches br       
  Where S.Sett_No = A.Sett_No And S.Sett_Type = A.Sett_Type And C1.Cl_Code = C2.Cl_Code      
  And C2.Party_code = A.Party_Code And MarketRate > 0 And TradeQty > 0       
  And A.Sett_No = @Sett_No And A.Sett_Type = @Sett_Type      
  And A.Party_Code >= @FromParty And A.Party_Code <= @ToParty And AuctionPart Not Like 'A%'      
  And Br.short_name = c1.trader and br.branch_cd = @statusname      
  Group by S.Sett_No, S.Sett_Type,Start_date,end_date,A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,      
  C1.L_Address3,L_City,L_State,L_Zip,BillNo,Scrip_CD,Sell_buy      
  Order by S.Sett_No, S.Sett_Type,A.Party_Code,Scrip_CD,Sell_buy      
 End      
 if @Statusid = 'subbroker'       
 Begin      
  Select S.Sett_No, S.Sett_Type,PayIn=Convert(Varchar,Start_date,103),      
  PayOut=Convert(Varchar,End_date,103),A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,C1.L_Address3,L_City,      
  L_State,L_Zip,BillNo,ScripName=Scrip_CD,Qty=Sum(TradeQty),      
  /*Amount=Round((Sum(TradeQty*N_NetRate)+Sum(A.Other_Chrg))/Sum(TradeQty),4)*Sum(TradeQty),*/      
  Amount=Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)+Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End),      
  MarketRate=Round((Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)      
  +Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End))/Sum(TradeQty),4),      
  Sell_buy,Service_Tax=Sum(Case When Service_Chrg = 0 Then NserTax Else 0 End),      
  Ins_Chrg = Sum(Case When C2.Insurance_Chrg = 1 Then Ins_Chrg Else 0 End),      
  Turn_Tax = Sum(Case When Turnover_tax = 1 Then Turn_Tax Else 0 End),      
  Other_Chrg = Sum(Case When C2.Other_Chrg = 1 Then (Case When AuctionPart Not Like 'F%' Then A.Other_Chrg Else 0 End) Else 0 End),      
  Sabi_Tax = Sum(Case When Sebi_Turn_tax = 1 Then sebi_tax Else 0 End),      
  Broker_Chrg = Sum(Case When BrokerNote = 1 Then Broker_chrg Else 0 End)      
  From Client2 C2, Client1 C1, History A, Sett_Mst S, subbrokers sb        
  Where S.Sett_No = A.Sett_No And S.Sett_Type = A.Sett_Type And C1.Cl_Code = C2.Cl_Code      
  And C2.Party_code = A.Party_Code And MarketRate > 0 And TradeQty > 0       
  And A.Sett_No = @Sett_No And A.Sett_Type = @Sett_Type      
  And A.Party_Code >= @FromParty And A.Party_Code <= @ToParty And AuctionPart Not Like 'A%'      
  and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname      
  Group by S.Sett_No, S.Sett_Type,Start_date,end_date,A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,      
  C1.L_Address3,L_City,L_State,L_Zip,BillNo,Scrip_CD,Sell_buy      
  Order by S.Sett_No, S.Sett_Type,A.Party_Code,Scrip_CD,Sell_buy      
 End      
 if @Statusid = 'trader'       
 Begin      
  Select S.Sett_No, S.Sett_Type,PayIn=Convert(Varchar,Start_date,103),      
  PayOut=Convert(Varchar,End_date,103),A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,C1.L_Address3,L_City,      
  L_State,L_Zip,BillNo,ScripName=Scrip_CD,Qty=Sum(TradeQty),      
  /*Amount=Round((Sum(TradeQty*N_NetRate)+Sum(A.Other_Chrg))/Sum(TradeQty),4)*Sum(TradeQty),*/      
  Amount=Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)+Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End),      
  MarketRate=Round((Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)      
  +Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End))/Sum(TradeQty),4),      
  Sell_buy,Service_Tax=Sum(Case When Service_Chrg = 0 Then NserTax Else 0 End),      
  Ins_Chrg = Sum(Case When C2.Insurance_Chrg = 1 Then Ins_Chrg Else 0 End),      
  Turn_Tax = Sum(Case When Turnover_tax = 1 Then Turn_Tax Else 0 End),      
  Other_Chrg = Sum(Case When C2.Other_Chrg = 1 Then (Case When AuctionPart Not Like 'F%' Then A.Other_Chrg Else 0 End) Else 0 End),      
  Sabi_Tax = Sum(Case When Sebi_Turn_tax = 1 Then sebi_tax Else 0 End),      
  Broker_Chrg = Sum(Case When BrokerNote = 1 Then Broker_chrg Else 0 End)      
  From Client2 C2, Client1 C1, History A, Sett_Mst S       
  Where S.Sett_No = A.Sett_No And S.Sett_Type = A.Sett_Type And C1.Cl_Code = C2.Cl_Code      
  And C2.Party_code = A.Party_Code And MarketRate > 0 And TradeQty > 0       
  And A.Sett_No = @Sett_No And A.Sett_Type = @Sett_Type      
  And A.Party_Code >= @FromParty And A.Party_Code <= @ToParty And AuctionPart Not Like 'A%'      
  And c1.trader = @statusname      
  Group by S.Sett_No, S.Sett_Type,Start_date,end_date,A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,      
  C1.L_Address3,L_City,L_State,L_Zip,BillNo,Scrip_CD,Sell_buy      
  Order by S.Sett_No, S.Sett_Type,A.Party_Code,Scrip_CD,Sell_buy      
 End      
 if @Statusid = 'family'       
 Begin      
  Select S.Sett_No, S.Sett_Type,PayIn=Convert(Varchar,Start_date,103),      
  PayOut=Convert(Varchar,End_date,103),A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,C1.L_Address3,L_City,      
  L_State,L_Zip,BillNo,ScripName=Scrip_CD,Qty=Sum(TradeQty),      
  /*Amount=Round((Sum(TradeQty*N_NetRate)+Sum(A.Other_Chrg))/Sum(TradeQty),4)*Sum(TradeQty),*/      
  Amount=Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)+Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End),      
  MarketRate=Round((Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)      
  +Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End))/Sum(TradeQty),4),      
  Sell_buy,Service_Tax=Sum(Case When Service_Chrg = 0 Then NserTax Else 0 End),      
  Ins_Chrg = Sum(Case When C2.Insurance_Chrg = 1 Then Ins_Chrg Else 0 End),      
  Turn_Tax = Sum(Case When Turnover_tax = 1 Then Turn_Tax Else 0 End),      
  Other_Chrg = Sum(Case When C2.Other_Chrg = 1 Then (Case When AuctionPart Not Like 'F%' Then A.Other_Chrg Else 0 End) Else 0 End),      
  Sabi_Tax = Sum(Case When Sebi_Turn_tax = 1 Then sebi_tax Else 0 End),      
  Broker_Chrg = Sum(Case When BrokerNote = 1 Then Broker_chrg Else 0 End)      
  From Client2 C2, Client1 C1, History A, Sett_Mst S       
  Where S.Sett_No = A.Sett_No And S.Sett_Type = A.Sett_Type And C1.Cl_Code = C2.Cl_Code      
  And C2.Party_code = A.Party_Code And MarketRate > 0 And TradeQty > 0       
  And A.Sett_No = @Sett_No And A.Sett_Type = @Sett_Type      
  And A.Party_Code >= @FromParty And A.Party_Code <= @ToParty And AuctionPart Not Like 'A%'      
  And c1.family = @statusname      
  Group by S.Sett_No, S.Sett_Type,Start_date,end_date,A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,      
  C1.L_Address3,L_City,L_State,L_Zip,BillNo,Scrip_CD,Sell_buy      
  Order by S.Sett_No, S.Sett_Type,A.Party_Code,Scrip_CD,Sell_buy      
 End      
 if @Statusid = 'client'       
 Begin      
  Select S.Sett_No, S.Sett_Type,PayIn=Convert(Varchar,Start_date,103),      
  PayOut=Convert(Varchar,End_date,103),A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,C1.L_Address3,L_City,      
  L_State,L_Zip,BillNo,ScripName=Scrip_CD,Qty=Sum(TradeQty),      
  /*Amount=Round((Sum(TradeQty*N_NetRate)+Sum(A.Other_Chrg))/Sum(TradeQty),4)*Sum(TradeQty),*/      
  Amount=Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)+Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End),      
  MarketRate=Round((Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)      
  +Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End))/Sum(TradeQty),4),      
  Sell_buy,Service_Tax=Sum(Case When Service_Chrg = 0 Then NserTax Else 0 End),      
  Ins_Chrg = Sum(Case When C2.Insurance_Chrg = 1 Then Ins_Chrg Else 0 End),      
  Turn_Tax = Sum(Case When Turnover_tax = 1 Then Turn_Tax Else 0 End),      
  Other_Chrg = Sum(Case When C2.Other_Chrg = 1 Then (Case When AuctionPart Not Like 'F%' Then A.Other_Chrg Else 0 End) Else 0 End),      
  Sabi_Tax = Sum(Case When Sebi_Turn_tax = 1 Then sebi_tax Else 0 End),      
  Broker_Chrg = Sum(Case When BrokerNote = 1 Then Broker_chrg Else 0 End)      
  From Client2 C2, Client1 C1, History A, Sett_Mst S       
  Where S.Sett_No = A.Sett_No And S.Sett_Type = A.Sett_Type And C1.Cl_Code = C2.Cl_Code      
  And C2.Party_code = A.Party_Code And MarketRate > 0 And TradeQty > 0       
  And A.Sett_No = @Sett_No And A.Sett_Type = @Sett_Type      
  And A.Party_Code >= @FromParty And A.Party_Code <= @ToParty And AuctionPart Not Like 'A%'      
  And c2.party_code = @statusname      
  Group by S.Sett_No, S.Sett_Type,Start_date,end_date,A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,      
  C1.L_Address3,L_City,L_State,L_Zip,BillNo,Scrip_CD,Sell_buy      
  Order by S.Sett_No, S.Sett_Type,A.Party_Code,Scrip_CD,Sell_buy      
 End      
      
 if @Statusid = 'area'       
 Begin      
  Select S.Sett_No, S.Sett_Type,PayIn=Convert(Varchar,Start_date,103),      
  PayOut=Convert(Varchar,End_date,103),A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,C1.L_Address3,L_City,      
  L_State,L_Zip,BillNo,ScripName=Scrip_CD,Qty=Sum(TradeQty),      
  /*Amount=Round((Sum(TradeQty*N_NetRate)+Sum(A.Other_Chrg))/Sum(TradeQty),4)*Sum(TradeQty),*/      
  Amount=Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)+Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End),      
  MarketRate=Round((Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)      
  +Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End))/Sum(TradeQty),4),      
  Sell_buy,Service_Tax=Sum(Case When Service_Chrg = 0 Then NserTax Else 0 End),      
  Ins_Chrg = Sum(Case When C2.Insurance_Chrg = 1 Then Ins_Chrg Else 0 End),      
  Turn_Tax = Sum(Case When Turnover_tax = 1 Then Turn_Tax Else 0 End),      
  Other_Chrg = Sum(Case When C2.Other_Chrg = 1 Then (Case When AuctionPart Not Like 'F%' Then A.Other_Chrg Else 0 End) Else 0 End),      
  Sabi_Tax = Sum(Case When Sebi_Turn_tax = 1 Then sebi_tax Else 0 End),      
  Broker_Chrg = Sum(Case When BrokerNote = 1 Then Broker_chrg Else 0 End)      
  From Client2 C2, Client1 C1, History A, Sett_Mst S       
  Where S.Sett_No = A.Sett_No And S.Sett_Type = A.Sett_Type And C1.Cl_Code = C2.Cl_Code      
  And C2.Party_code = A.Party_Code And MarketRate > 0 And TradeQty > 0       
  And A.Sett_No = @Sett_No And A.Sett_Type = @Sett_Type      
  And A.Party_Code >= @FromParty And A.Party_Code <= @ToParty And AuctionPart Not Like 'A%'      
  And c1.area = @statusname      
  Group by S.Sett_No, S.Sett_Type,Start_date,end_date,A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,      
  C1.L_Address3,L_City,L_State,L_Zip,BillNo,Scrip_CD,Sell_buy      
  Order by S.Sett_No, S.Sett_Type,A.Party_Code,Scrip_CD,Sell_buy      
 End      
  
 if @Statusid = 'region'       
 Begin      
  Select S.Sett_No, S.Sett_Type,PayIn=Convert(Varchar,Start_date,103),      
  PayOut=Convert(Varchar,End_date,103),A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,C1.L_Address3,L_City,      
  L_State,L_Zip,BillNo,ScripName=Scrip_CD,Qty=Sum(TradeQty),      
  /*Amount=Round((Sum(TradeQty*N_NetRate)+Sum(A.Other_Chrg))/Sum(TradeQty),4)*Sum(TradeQty),*/      
  Amount=Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)+Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End),      
  MarketRate=Round((Sum(TradeQty*N_NetRate)+Sum(Case When Service_Chrg = 1 Then NserTax Else 0 End)      
  +Sum(Case When AuctionPart Like 'F%' Then A.Other_Chrg Else 0 End))/Sum(TradeQty),4),      
  Sell_buy,Service_Tax=Sum(Case When Service_Chrg = 0 Then NserTax Else 0 End),      
  Ins_Chrg = Sum(Case When C2.Insurance_Chrg = 1 Then Ins_Chrg Else 0 End),      
  Turn_Tax = Sum(Case When Turnover_tax = 1 Then Turn_Tax Else 0 End),      
  Other_Chrg = Sum(Case When C2.Other_Chrg = 1 Then (Case When AuctionPart Not Like 'F%' Then A.Other_Chrg Else 0 End) Else 0 End),      
  Sabi_Tax = Sum(Case When Sebi_Turn_tax = 1 Then sebi_tax Else 0 End),      
  Broker_Chrg = Sum(Case When BrokerNote = 1 Then Broker_chrg Else 0 End)      
  From Client2 C2, Client1 C1, History A, Sett_Mst S       
  Where S.Sett_No = A.Sett_No And S.Sett_Type = A.Sett_Type And C1.Cl_Code = C2.Cl_Code      
  And C2.Party_code = A.Party_Code And MarketRate > 0 And TradeQty > 0       
  And A.Sett_No = @Sett_No And A.Sett_Type = @Sett_Type      
  And A.Party_Code >= @FromParty And A.Party_Code <= @ToParty And AuctionPart Not Like 'A%'      
  And c1.region = @statusname      
  Group by S.Sett_No, S.Sett_Type,Start_date,end_date,A.Party_Code,C1.Long_Name,C1.L_Address1,C1.L_Address2,      
  C1.L_Address3,L_City,L_State,L_Zip,BillNo,Scrip_CD,Sell_buy      
  Order by S.Sett_No, S.Sett_Type,A.Party_Code,Scrip_CD,Sell_buy      
 End      
      
End

GO
