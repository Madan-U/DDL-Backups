-- Object: PROCEDURE dbo.InstContCumBill_Section_NSECM
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE  Proc InstContCumBill_Section_NSECM
(
@StatusId Varchar(15), 
@StatusName Varchar(25), 
@Sauda_Date Varchar(11), 
@Sett_No Varchar(7), 
@Sett_Type Varchar(2), 
@FromParty_code Varchar(10),
@ToParty_code Varchar(10), 
@FromContractno Varchar(12),
@ToContractno Varchar(12),
@Branch Varchar(10), 
@Sub_broker Varchar(10)
)

As

set transaction isolation level read uncommitted          

Select ContractNo, S.Party_code, 
Order_No    = Min(Order_No), TM=Convert(Varchar,Min(Sauda_Date),108), 
Trade_no    = Min(Trade_no), /*S.Sauda_Date,*/ S.Scrip_Cd, S.Series,            
ScripName   = S1.Short_Name, SDT = Convert(Varchar,Min(Sauda_date),103), Sell_Buy, S.MarketType,
Broker_Chrg = Sum(Case When C2.BrokerNote = 1 Then Broker_Chrg Else 0 End),           
Service_Tax = Sum(Case When Service_chrg = 0 Then NSerTax Else 0 End ),          
turn_tax    = Sum(Case when TurnOver_tax = 1 then turn_tax else 0 end),            
Ins_chrg    = Sum(Case when Insurance_chrg = 1 then Ins_chrg else 0 end),            
other_chrg  = Sum(Case When c2.Other_chrg = 1 Then S.other_chrg Else 0 End) ,    
sebi_tax    = Sum(Case When Sebi_Turn_tax = 1 Then sebi_tax Else 0 End),      
Sauda_Date1 = Left(Convert(Varchar,Sauda_date,109),11),          
PQty 	    = Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End),          
SQty 	    = Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End),          
PRate       = (Case When Sell_Buy = 1 Then Sum(MarketRate*TradeQty)/Sum(TradeQty) Else 0 End),          
SRate       = (Case When Sell_Buy = 2 Then Sum(MarketRate*TradeQty)/Sum(TradeQty) Else 0 End),          
PBrok       = (Case When Sell_Buy = 1           
       		Then Sum(NBrokApp*TradeQty)/Sum(TradeQty) + (Case When Service_Chrg = 1           
               		Then Sum(NSertax)/Sum(TradeQty)           
               		Else 0           
	    		End)          
	       	Else 0           
		End),          
SBrok 	    = (Case When Sell_Buy = 2           
       		Then Sum(NBrokApp*TradeQty)/Sum(TradeQty) + (Case When Service_Chrg = 1           
               		Then Sum(NSertax)/Sum(TradeQty)           
               		Else 0           
			End)          
	        Else 0           
	        End),          
PNetRate    = (Case When Sell_Buy = 1            
   		Then Sum(N_NetRate*TradeQty)/Sum(TradeQty) + (Case When Service_Chrg = 1           
        		Then Sum(NSertax)/Sum(TradeQty)           
      			Else 0           
        		End)          
          	Else 0           
          	End),          
SNetRate    = (Case When Sell_Buy = 2            
   		Then Sum(N_NetRate*TradeQty)/Sum(TradeQty) - (Case When Service_Chrg = 1           
        		Then Sum(NSertax)/Sum(TradeQty)           
      			Else 0           
        		End)          
          	Else 0           
          	End),          
PAmt 	    = (Case When Sell_Buy = 1           
      		Then Sum(TradeQty*N_NetRate) + ((Case When Service_Chrg = 1           
        		Then Sum(NSertax)/Sum(TradeQty)           
      			Else 0           
        		End))           
      		Else 0           
 		End),          
SAmt 	    = (Case When Sell_Buy = 2          
      		Then Sum(TradeQty*N_NetRate) - ((Case When Service_Chrg = 1           
        		Then Sum(NSertax)/Sum(TradeQty)           
      			Else 0           
        		End))           
      		Else 0           
		End),          
Brokerage   = Sum(TradeQty*NBrokApp) + (Case When Service_Chrg = 1 Then Sum(NserTax) Else 0 End),

S.Sett_No, S.Sett_Type, TradeType = '  ',          
--Tmark     = (case when BillFlag = 1 or BillFlag = 4 or BillFlag = 5 then 'D' else '' end),          
Tmark	    = '',	
/*To display the header part*/          
Partyname = c1.Long_name,          
c1.l_address1,c1.l_address2,c1.l_address3,          
c1.l_city,c1.l_zip, c2.service_chrg,c1.Branch_cd ,c1.sub_broker,c1.pan_gir_no,          
c1.Off_Phone1,c1.Off_Phone2,Printf,Mapidid          

From ISettlement S
left outer join ucc_client uc on (s.party_code = uc.party_code), 
Sett_Mst M, Scrip1 S1, Scrip2 S2, client1 c1, client2 c2          

Where c1.cl_code = c2.cl_code           
And C2.party_code = S.party_code          
And S.Scrip_Cd = S2.Scrip_CD          
And S.Series = S2.Series          
And S1.Co_Code = S2.Co_Code          
And S1.Series = S2.Series          
And S.Sett_No = M.Sett_No           
And S.Sett_Type = M.Sett_Type          
And S.Sett_Type = @Sett_Type          
And Sauda_date Like @Sauda_Date + '%'           
And s.Party_code between @FromParty_Code And  @ToParty_Code    
And S.Contractno between @FromContractno And  @ToContractno 
And s.tradeqty > 0          
And Branch_cd 	  Like (Case When @StatusId = 'branch' Then @statusname else '%' End)          
And Sub_broker 	  Like (Case When @StatusId = 'subbroker' Then @statusname else '%' End)          
And Trader 	  Like (Case When @StatusId = 'trader' Then @statusname else '%' End)          
And Family 	  Like (Case When @StatusId = 'family' Then @statusname else '%' End)          
And C2.Party_Code Like (Case When @StatusId = 'client' Then @statusname else '%' End)          
And Region 	  Like (Case When @StatusId = 'Region' Then @statusname else '%' End)          
And Branch_cd     Like @Branch          
And Sub_Broker    Like @Sub_Broker          

Group By ContractNo,S.Party_code,Left(Convert(Varchar,Sauda_Date,109),11),S.Scrip_Cd,S.Series,S1.Short_Name,          
Sell_Buy,S.MarketType,S.Sett_No,S.Sett_Type,/*BillFlag,*/c1.Long_name,l_address1,l_address2,l_address3,          
l_city,l_zip,service_chrg,Branch_cd,sub_broker,pan_gir_no,Off_Phone1,Off_Phone2,Printf,Mapidid

Order by Branch_cd, sub_broker, S.Party_code, S1.Short_Name, ContractNo, S.Sett_No, S.Sett_Type, Order_No, Trade_No

GO
