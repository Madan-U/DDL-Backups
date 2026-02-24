-- Object: PROCEDURE dbo.Rpt_Trade_CSV
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Rpt_Trade_CSV (
@StatusId Varchar(15),
@Statusname Varchar(20),
@FromSauda_Date Varchar(11),
@ToSauda_Date Varchar(11),
@FromSett_No Varchar(7),
@ToSett_No Varchar(7),
@Sett_Type Varchar(2),
@FromParty Varchar(10),
@ToParty Varchar(10))
As

Set @FromSauda_Date = (Case When Len(@FromSauda_Date) = 0 
			    Then 'Jan  1 2004'
			    Else @FromSauda_Date
		       End)
Set @ToSauda_Date = (Case When Len(@ToSauda_Date) = 0 
			    Then 'Dec 31 2049'
			    Else @ToSauda_Date
		       End)
Set @FromSett_No = (Case When Len(@FromSett_No) = 0 
			    Then '0'
			    Else @FromSett_No
		       End)
Set @ToSett_No = (Case When Len(@ToSett_No) = 0 
			    Then '9999999'
			    Else @ToSett_No
		       End)
Set @FromParty = (Case When Len(@FromParty) = 0 
			    Then '0'
			    Else @FromParty
		       End)
Set @ToParty = (Case When Len(@ToParty) = 0 
			    Then 'ZZZZZZZZZZ'
			    Else @ToParty
		       End)

Select S.Party_Code, Party_Name=C1.Long_Name, Trade_Date=Left(Sauda_date,11), 
S.Sett_No, S.Sett_Type, S.Scrip_Cd, S.Series, Scrip_Name=S1.Long_Name, 
MarketRate=(Case When Sum(TradeQty) > 0 
		 Then Sum(TradeQty*MarketRate)
		     /Sum(TradeQty)
		 Else 0 
	    End),
NetRate=(Case When Sum(TradeQty) > 0 
		 Then Sum(TradeQty*N_NetRate)
		     /Sum(TradeQty)
		 Else 0 
	    End),
PQty = Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End), 
PAmt = Sum(Case When Sell_Buy = 1 Then TradeQty*MarketRate Else 0 End), 
SQty = Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End),
SAmt = Sum(Case When Sell_Buy = 2 Then TradeQty*MarketRate Else 0 End),  
TClCode=Branch_Id, TermCode=User_Id,
Brok = Sum(NBrokApp*TradeQty), 
STax = Sum(NSerTax)
From Settlement S, Client1 C1, Client2 C2, Sett_Mst SM, Scrip1 S1, Scrip2 S2
Where S.Sett_No = SM.Sett_No
And S.Sett_Type = SM.Sett_Type
And C1.Cl_Code = C2.Cl_Code
And C2.Party_Code = S.Party_Code
And S1.Co_Code = S2.Co_Code
And S1.Series = S2.Series
And S.Scrip_Cd = S2.Scrip_Cd
And S.Series = S2.Series
And Cl_Type <> 'INS'
And S.Sett_No Between @FromSett_No And @ToSett_No
And S.Sett_Type = @Sett_Type
And Start_date Between @FromSauda_Date And @ToSauda_Date + ' 23:59'
And S.Party_Code Between @FromParty And @ToParty
And AuctionPart Not Like 'F%' 
And AuctionPart Not Like 'A%' 
And TradeQty > 0 
And             @StatusName = 
                  (case 
                        when @StatusId = 'BRANCH' then c1.branch_cd
                        when @StatusId = 'SUBBROKER' then c1.sub_broker
                        when @StatusId = 'Trader' then c1.Trader
                        when @StatusId = 'Family' then c1.Family
                        when @StatusId = 'Area' then c1.Area
                        when @StatusId = 'Region' then c1.Region
                        when @StatusId = 'Client' then c2.party_code
                  else 
                        'BROKER'
                  End)
Group By S.Party_Code, C1.Long_Name, Left(Sauda_date,11), Left(Start_date,11), 
S.Sett_No, S.Sett_Type, S.Scrip_Cd, S.Series, S1.Long_Name, Branch_Id, User_Id, Sell_Buy

GO
