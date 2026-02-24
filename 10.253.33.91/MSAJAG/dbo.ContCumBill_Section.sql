-- Object: PROCEDURE dbo.ContCumBill_Section
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE Proc ContCumBill_Section 
(@StatusId Varchar(15), @StatusName Varchar(25), @Sauda_Date Varchar(11), @Sett_No Varchar(7), @Sett_Type Varchar(2), @FromParty_code Varchar(10) ,@ToParty_code Varchar(10), @Branch Varchar(10), @Sub_broker Varchar(10))
As
/*For Last Day of the Settlement or one Day Settlement Record */
Select ContractNo, S.Party_code, Order_No, TM=Convert(Varchar,Sauda_Date,108), Trade_no, Sauda_Date, S.Scrip_Cd, 
ScripName = S1.Short_Name, SDT = Convert(Varchar,Sauda_date,103), Sell_Buy, S.MarketType, Broker_Chrg, 
Service_Tax = (Case When Service_chrg = 0 Then NSerTax Else 0 End ),
Sauda_Date1 = Left(Convert(Varchar,Sauda_date,109),11),
PQty = (Case When Sell_Buy = 1 Then TradeQty Else 0 End),
SQty = (Case When Sell_Buy = 2 Then TradeQty Else 0 End),
PRate = (Case When Sell_Buy = 1 Then MarketRate Else 0 End),
SRate = (Case When Sell_Buy = 2 Then MarketRate Else 0 End),
PBrok = (Case When Sell_Buy = 1 
	      Then NBrokApp + (Case When Service_Chrg = 1 
			            Then NSertax/TradeQty 
			            Else 0 
				End)
	      Else 0 
	End),
SBrok = (Case When Sell_Buy = 2 
	      Then NBrokApp + (Case When Service_Chrg = 1 
			            Then NSertax/TradeQty 
			            Else 0 
				End)
	      Else 0 
	End),
PNetRate = (Case When Sell_Buy = 1 	
		 Then N_NetRate +
	             (Case When Service_Chrg = 1 
		  	   Then NSertax/TradeQty 
			   Else 0 
		      End)
	         Else 0 
     	    End),
SNetRate = (Case When Sell_Buy = 2 	
		 Then N_NetRate -
	             (Case When Service_Chrg = 1 
		  	   Then NSertax/TradeQty 
			   Else 0 
		      End)
	         Else 0 
     	    End),
PAmt = (Case When Sell_Buy = 1 
	     Then TradeQty*(N_NetRate +
	             (Case When Service_Chrg = 1 
		  	   Then NSertax/TradeQty 
			   Else 0 
		      End)) 
	     Else 0 
	End),
SAmt = (Case When Sell_Buy = 2
	     Then TradeQty*(N_NetRate -
	             (Case When Service_Chrg = 1 
		  	   Then NSertax/TradeQty 
			   Else 0 
		      End)) 
	     Else 0 
	End),
Brokerage = TradeQty*NBrokApp+(Case When Service_Chrg = 1 Then NserTax Else 0 End),
S.Sett_No, S.Sett_Type, TradeType = '  ',
Tmark = case when BillFlag = 1 or BillFlag = 4 or BillFlag = 5 then 'D' else '' end ,
/*To display the header part*/
Partyname = c1.Long_name,
c1.l_address1,c1.l_address2,c1.l_address3,
c1.l_city,c1.l_zip, c2.service_chrg,c1.Branch_cd ,c1.sub_broker,c1.pan_gir_no,
c1.Off_Phone1,c1.Off_Phone2 Into #ContSett
From Settlement S, Sett_Mst M, Scrip1 S1, Scrip2 S2, client1 c1, client2 c2
Where Sauda_date <= @Sauda_Date + ' 23:59' 
And s.Party_code between @FromParty_Code And  @ToParty_Code
And S.Sett_No = @Sett_No And S.Sett_Type = @Sett_Type
And S.Sett_No = M.Sett_No And S.Sett_Type = M.Sett_Type
And M.End_date Like @Sauda_Date + '%' And S1.Co_Code = S2.Co_Code
And S2.Series = S1.Series And S2.Scrip_Cd = S.Scrip_CD And S2.Series = S.Series
and c1.cl_code = c2.cl_code 
and s.party_code = c2.party_code
and s.tradeqty > 0
and Branch_cd Like (Case When @StatusId = 'branch' Then @statusname else '%' End)
and Sub_broker Like (Case When @StatusId = 'subbroker' Then @statusname else '%' End)
and Trader Like (Case When @StatusId = 'trader' Then @statusname else '%' End)
and Family Like (Case When @StatusId = 'family' Then @statusname else '%' End)
and C2.Party_Code Like (Case When @StatusId = 'client' Then @statusname else '%' End)
and Branch_cd like @Branch
and Sub_Broker like @Sub_Broker

Insert Into #ContSett
/*For Other Day Except the Last day of the Settlement for not one Day Settlement Record */
Select ContractNo, S.Party_code, Order_No, TM=Convert(Varchar,Sauda_Date,108), Trade_no, Sauda_Date, S.Scrip_Cd, 
ScripName = S1.Short_Name, SDT = Convert(Varchar,Sauda_date,103), Sell_Buy, S.MarketType, Broker_Chrg, 
Service_Tax = (Case When Service_chrg = 0 Then service_Tax Else 0 End ),
Sauda_Date1 = Left(Convert(Varchar,Sauda_date,109),11),
PQty = (Case When Sell_Buy = 1 Then TradeQty Else 0 End),
SQty = (Case When Sell_Buy = 2 Then TradeQty Else 0 End),
PRate = (Case When Sell_Buy = 1 Then MarketRate Else 0 End),
SRate = (Case When Sell_Buy = 2 Then MarketRate Else 0 End),
PBrok = (Case When Sell_Buy = 1 
	      Then BrokApplied + (Case When Service_Chrg = 1 
			            Then service_Tax/TradeQty 
			            Else 0 
				End)
	      Else 0 
	End),
SBrok = (Case When Sell_Buy = 2 
	      Then BrokApplied + (Case When Service_Chrg = 1 
			            Then service_Tax/TradeQty 
			            Else 0 
				End)
	      Else 0 
	End),
PNetRate = (Case When Sell_Buy = 1 	
		 Then NetRate +
	             (Case When Service_Chrg = 1 
		  	   Then service_Tax/TradeQty 
			   Else 0 
		      End)
	         Else 0 
     	    End),
SNetRate = (Case When Sell_Buy = 2 	
		 Then NetRate -
	             (Case When Service_Chrg = 1 
		  	   Then service_Tax/TradeQty 
			   Else 0 
		      End)
	         Else 0 
     	    End),
PAmt = (Case When Sell_Buy = 1 
	     Then TradeQty*(NetRate +
	             (Case When Service_Chrg = 1 
		  	   Then service_Tax/TradeQty 
			   Else 0 
		      End)) 
	     Else 0 
	End),
SAmt = (Case When Sell_Buy = 2
	     Then TradeQty*(NetRate -
	             (Case When Service_Chrg = 1 
		  	   Then service_Tax/TradeQty 
			   Else 0 
		      End)) 
	     Else 0 
	End),
Brokerage = TradeQty*BrokApplied+(Case When Service_Chrg = 1 Then service_Tax Else 0 End),
S.Sett_No, S.Sett_Type, TradeType = '  ',
Tmark = case when BillFlag = 1 or BillFlag = 4 or BillFlag = 5 then 'D' else '' end ,
/*To display the header part*/
Partyname = c1.Long_name,
c1.l_address1,c1.l_address2,c1.l_address3,
c1.l_city,c1.l_zip, c2.service_chrg,c1.Branch_cd ,c1.sub_broker,c1.pan_gir_no,
c1.Off_Phone1,c1.Off_Phone2 

From Settlement S, Sett_Mst M, Scrip1 S1, Scrip2 S2, client1 c1, client2 c2
Where Sauda_date <= @Sauda_Date + ' 23:59'
And s.Party_code between @FromParty_Code And  @ToParty_Code
And S.Sett_No = @Sett_No And S.Sett_Type = @Sett_Type
And S.Sett_No = M.Sett_No And S.Sett_Type = M.Sett_Type
And M.End_date Not Like @Sauda_Date + '%' And S1.Co_Code = S2.Co_Code
And S2.Series = S1.Series And S2.Scrip_Cd = S.Scrip_CD And S2.Series = S.Series
and c1.cl_code = c2.cl_code 
and s.party_code = c2.party_code
and s.tradeqty > 0
and Branch_cd Like (Case When @StatusId = 'branch' Then @statusname else '%' End)
and Sub_broker Like (Case When @StatusId = 'subbroker' Then @statusname else '%' End)
and Trader Like (Case When @StatusId = 'trader' Then @statusname else '%' End)
and Family Like (Case When @StatusId = 'family' Then @statusname else '%' End)
and C2.Party_Code Like (Case When @StatusId = 'client' Then @statusname else '%' End)
and Branch_cd like @Branch
and Sub_Broker like @Sub_Broker

Insert Into #ContSett

/* ND Record Brought Forward For Same Day Or Previous Days */
Select ContractNo, S.Party_code, Order_No, TM=Convert(Varchar,Sauda_Date,108), Trade_no, Sauda_Date, S.Scrip_Cd, 
ScripName = S1.Short_Name, SDT = Convert(Varchar,Sauda_date,103), Sell_Buy, S.MarketType, Broker_Chrg, 
Service_Tax = 0, Sauda_Date1 = Left(Convert(Varchar,Sauda_date,109),11),
PQty = (Case When Sell_Buy = 1 Then TradeQty Else 0 End),
SQty = (Case When Sell_Buy = 2 Then TradeQty Else 0 End),
PRate = (Case When Sell_Buy = 1 Then MarketRate Else 0 End),
SRate = (Case When Sell_Buy = 2 Then MarketRate Else 0 End),
PBrok = 0, 
SBrok = 0, 
PNetRate = (Case When Sell_Buy = 1 Then MarketRate Else 0 End),
SNetRate = (Case When Sell_Buy = 2 Then MarketRate Else 0 End),
PAmt = (Case When Sell_Buy = 1 Then TradeQty*MarketRate Else 0 End),
SAmt = (Case When Sell_Buy = 2 Then TradeQty*MarketRate Else 0 End),
Brokerage = 0, S.Sett_No, S.Sett_Type, TradeType = 'BF',
Tmark = case when BillFlag = 1 or BillFlag = 4 or BillFlag = 5 then '' else '' end ,
/*To display the header part*/
Partyname = c1.Long_name,
c1.l_address1,c1.l_address2,c1.l_address3,
c1.l_city,c1.l_zip, c2.service_chrg,c1.Branch_cd ,c1.sub_broker,c1.pan_gir_no,
c1.Off_Phone1,c1.Off_Phone2 

From Settlement S, Sett_Mst M, Scrip1 S1, Scrip2 S2, client1 c1, client2 c2
Where Sauda_date <= @Sauda_Date + ' 23:59' 
And s.Party_code between @FromParty_Code And  @ToParty_Code
And S.Sett_No > @Sett_No And S.Sett_Type = @Sett_Type
And S.Sett_No = M.Sett_No And S.Sett_Type = M.Sett_Type
And M.End_date Not Like @Sauda_Date + '%' And S1.Co_Code = S2.Co_Code
And S2.Series = S1.Series And S2.Scrip_Cd = S.Scrip_CD And S2.Series = S.Series
and c1.cl_code = c2.cl_code 
and s.party_code = c2.party_code
and s.tradeqty > 0
and Branch_cd Like (Case When @StatusId = 'branch' Then @statusname else '%' End)
and Sub_broker Like (Case When @StatusId = 'subbroker' Then @statusname else '%' End)
and Trader Like (Case When @StatusId = 'trader' Then @statusname else '%' End)
and Family Like (Case When @StatusId = 'family' Then @statusname else '%' End)
and C2.Party_Code Like (Case When @StatusId = 'client' Then @statusname else '%' End)
and Branch_cd like @Branch
and Sub_Broker like @Sub_Broker

Insert Into #ContSett

/* ND Record Carry Forward For Same Day Or Previous Days */
Select ContractNo, S.Party_code, Order_No, TM=Convert(Varchar,Sauda_Date,108), Trade_no, Sauda_Date, S.Scrip_Cd, 
ScripName = S1.Short_Name, SDT = Convert(Varchar,Sauda_date,103), Sell_Buy=(CASE WHEN SELL_BUY = 1 THEN 2 ELSE 1 END), S.MarketType, Broker_Chrg, 
Service_Tax = 0, Sauda_Date1 = Left(Convert(Varchar,Sauda_date,109),11),
PQty = (Case When Sell_Buy = 2 Then TradeQty Else 0 End),
SQty = (Case When Sell_Buy = 1 Then TradeQty Else 0 End),
PRate = (Case When Sell_Buy = 2 Then MarketRate Else 0 End),
SRate = (Case When Sell_Buy = 1 Then MarketRate Else 0 End),
PBrok = 0, 
SBrok = 0, 
PNetRate = (Case When Sell_Buy = 2 Then MarketRate Else 0 End),
SNetRate = (Case When Sell_Buy = 1 Then MarketRate Else 0 End),
PAmt = (Case When Sell_Buy = 2 Then TradeQty*MarketRate Else 0 End),
SAmt = (Case When Sell_Buy = 1 Then TradeQty*MarketRate Else 0 End),
Brokerage = 0, S.Sett_No, S.Sett_Type, TradeType = 'CF',
Tmark = case when BillFlag = 1 or BillFlag = 4 or BillFlag = 5 then '' else '' end ,
/*To display the header part*/
Partyname = c1.Long_name,
c1.l_address1,c1.l_address2,c1.l_address3,
c1.l_city,c1.l_zip, c2.service_chrg,c1.Branch_cd ,c1.sub_broker,c1.pan_gir_no,
c1.Off_Phone1,c1.Off_Phone2 

From Settlement S, Sett_Mst M, Scrip1 S1, Scrip2 S2, client1 c1, client2 c2
Where Sauda_date <= @Sauda_Date + ' 23:59' 
And s.Party_code between @FromParty_Code And  @ToParty_Code
And S.Sett_No > @Sett_No And S.Sett_Type = @Sett_Type
And S.Sett_No = M.Sett_No And S.Sett_Type = M.Sett_Type
And M.End_date Not Like @Sauda_Date + '%' And S1.Co_Code = S2.Co_Code
And S2.Series = S1.Series And S2.Scrip_Cd = S.Scrip_CD And S2.Series = S.Series
and c1.cl_code = c2.cl_code 
and s.party_code = c2.party_code
and s.tradeqty > 0
and Branch_cd Like (Case When @StatusId = 'branch' Then @statusname else '%' End)
and Sub_broker Like (Case When @StatusId = 'subbroker' Then @statusname else '%' End)
and Trader Like (Case When @StatusId = 'trader' Then @statusname else '%' End)
and Family Like (Case When @StatusId = 'family' Then @statusname else '%' End)
and C2.Party_Code Like (Case When @StatusId = 'client' Then @statusname else '%' End)
and Branch_cd like @Branch
and Sub_Broker like @Sub_Broker

Select * From #ContSett
order by Sett_No, Sett_Type, Party_code,ScripName, Order_No, Trade_No

GO
