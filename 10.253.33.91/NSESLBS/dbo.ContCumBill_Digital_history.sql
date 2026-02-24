-- Object: PROCEDURE dbo.ContCumBill_Digital_history
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



Create Proc ContCumBill_Digital_history
(@StatusId Varchar(15), @StatusName Varchar(25), @Sauda_Date Varchar(11), @Sett_No Varchar(7), @Sett_Type Varchar(2), @FromParty_code Varchar(10) ,@ToParty_code Varchar(10), @Branch Varchar(10), @Sub_broker Varchar(10))
As

set transaction isolation level read uncommitted

Select ContractNo, S.Party_code, Order_No, TM=Convert(Varchar,Sauda_Date,108), Trade_no, Sauda_Date, S.Scrip_Cd, S.Series, 
ScripName = S1.Short_Name + (Case When Left(Convert(Varchar,Sauda_date,109),11) = @Sauda_Date Then '   ' Else '-BF' End), SDT = Convert(Varchar,Sauda_date,103), Sell_Buy, S.MarketType,
Broker_Chrg =(Case When BrokerNote = 1 Then Broker_Chrg Else 0 End ),
turn_tax =(Case When Turnover_tax = 1 Then turn_tax Else 0 End),
sebi_tax =(Case When Sebi_Turn_tax = 1 Then sebi_tax Else 0 End),
other_chrg =(Case When c2.Other_chrg = 1 Then S.other_chrg Else 0 End) , 
Ins_Chrg = (Case When Insurance_Chrg = 1 Then Ins_chrg Else 0 End ), 
Service_Tax = (Case When Service_chrg = 0 Then NSerTax Else 0 End ),
NSerTax = (Case When Service_chrg = 0 Then NSerTax Else 0 End ),
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
c1.Off_Phone1,c1.Off_Phone2,Printf,mapidid, OrderFlag = 0, ScripName1 = S1.Short_Name Into #ContSett
From History S left outer join  ucc_client uc on s.party_code = uc.party_code,
Sett_Mst M, Scrip1 S1, Scrip2 S2, client1 c1, client2 c2
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
/*For Other Day Except the Last day of the History for not one Day History Record */
Select ContractNo, S.Party_code, Order_No, TM=Convert(Varchar,Sauda_Date,108), Trade_no, Sauda_Date, S.Scrip_Cd, S.Series, 
ScripName = S1.Short_Name + ' ', SDT = Convert(Varchar,Sauda_date,103), Sell_Buy, S.MarketType,
Broker_Chrg =(Case When BrokerNote = 1 Then Broker_Chrg Else 0 End ),
turn_tax =(Case When Turnover_tax = 1 Then turn_tax Else 0 End),
sebi_tax =(Case When Sebi_Turn_tax = 1 Then sebi_tax Else 0 End),
other_chrg =(Case When c2.Other_chrg = 1 Then S.other_chrg Else 0 End) ,
Ins_Chrg = (Case When Insurance_Chrg = 1 Then Ins_chrg Else 0 End ),
Service_Tax = (Case When Service_chrg = 0 Then NSerTax Else 0 End ),
NSerTax = (Case When Service_chrg = 0 Then service_Tax Else 0 End ),
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
c1.Off_Phone1,c1.Off_Phone2 ,Printf,mapidid, OrderFlag = 0, ScripName1 = S1.Short_Name

From History S left outer join  ucc_client uc on s.party_code = uc.party_code,
Sett_Mst M, Scrip1 S1, Scrip2 S2, client1 c1, client2 c2
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
Select ContractNo, S.Party_code, Order_No, TM=Convert(Varchar,Sauda_Date,108), Trade_no, Sauda_Date, S.Scrip_Cd, S.Series, 
ScripName = S1.Short_Name + (Case When Left(Convert(Varchar,Sauda_date,109),11) = @Sauda_Date Then '-ND' Else '-BF' End), SDT = Convert(Varchar,Sauda_date,103), Sell_Buy, S.MarketType,
Broker_Chrg =0, turn_tax=0,sebi_tax=0,s.other_chrg,Ins_Chrg =0,Service_Tax = 0,NSerTax=0,
Sauda_Date1 = Left(Convert(Varchar,Sauda_date,109),11),
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
c1.Off_Phone1,c1.Off_Phone2 ,Printf,mapidid,OrderFlag = 0, ScripName1 = S1.Short_Name

From History S left outer join  ucc_client uc on s.party_code = uc.party_code,
Sett_Mst M, Scrip1 S1, Scrip2 S2, client1 c1, client2 c2
Where Sauda_date <= @Sauda_Date + ' 23:59' 
And s.Party_code between @FromParty_Code And  @ToParty_Code
And M.End_Date > @Sauda_Date + ' 23:59:59' And s.Sett_Type = @Sett_Type
--And S.Sett_No > @Sett_No And S.Sett_Type = @Sett_Type
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
Select ContractNo, S.Party_code, Order_No, TM=Convert(Varchar,Sauda_Date,108), Trade_no, Sauda_Date, S.Scrip_Cd, S.Series, 
ScripName = S1.Short_Name + '-CF' , SDT = Convert(Varchar,Sauda_date,103), Sell_Buy=(CASE WHEN SELL_BUY = 1 THEN 2 ELSE 1 END), S.MarketType,
Broker_Chrg =0, turn_tax=0,sebi_tax=0,s.other_chrg,Ins_Chrg = 0,Service_Tax = 0,NSerTax=0,
Sauda_Date1 = Left(Convert(Varchar,Sauda_date,109),11),
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
c1.Off_Phone1,c1.Off_Phone2 ,Printf,mapidid,OrderFlag = 1, ScripName1 = S1.Short_Name

From History S left outer join  ucc_client uc on s.party_code = uc.party_code,
Sett_Mst M, Scrip1 S1, Scrip2 S2, client1 c1, client2 c2
Where Sauda_date <= @Sauda_Date + ' 23:59' 
And s.Party_code between @FromParty_Code And  @ToParty_Code
And M.End_Date > @Sauda_Date + ' 23:59:59' And s.Sett_Type = @Sett_Type
--And S.Sett_No > @Sett_No And S.Sett_Type = @Sett_Type
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


select ContractNo,Party_code,Order_No='0000000000000000',TM='0000000000000',Trade_no='00000000000000',
Sauda_Date=Left(Convert(Varchar,Sauda_Date,109),11),Scrip_Cd,Series,ScripName,SDT,
Sell_Buy,MarketType,Broker_Chrg=Sum(Broker_Chrg),turn_tax=Sum(Turn_Tax),sebi_tax=Sum(sebi_tax),
other_chrg=Sum(Other_Chrg),Ins_Chrg = sum(Ins_chrg),Service_Tax = sum(Service_Tax),NSerTax=Sum(NSerTax),Sauda_Date1,PQty=Sum(PQty),SQty=Sum(SQty),
PRate=(Case When Sum(PQty) > 0 Then Sum(PRate*PQty)/Sum(PQty) Else 0 End),
SRate=(Case When Sum(SQty) > 0 Then Sum(SRate*SQty)/Sum(SQty) Else 0 End),
PBrok=(Case When Sum(PQty) > 0 Then Sum(PBrok*PQty)/Sum(PQty) Else 0 End),
SBrok=(Case When Sum(SQty) > 0 Then Sum(SBrok*SQty)/Sum(SQty) Else 0 End),
PNetRate=(Case When Sum(PQty) > 0 Then Sum(PNetRate*PQty)/Sum(PQty) Else 0 End),
SNetRate=(Case When Sum(SQty) > 0 Then Sum(SNetRate*SQty)/Sum(SQty) Else 0 End),
PAmt=Sum(PAmt),SAmt=Sum(SAmt),Brokerage=Sum(Brokerage),Sett_No,Sett_Type,TradeType,Tmark,Partyname,
l_address1,l_address2,l_address3,l_city,l_zip,service_chrg,Branch_cd,sub_broker,pan_gir_no,Off_Phone1,Off_Phone2,Printf,mapidid,OrderFlag,
ScripName1
Into #ContSettNew From #ContSett Where Printf = '3' 
Group By ContractNo,Party_code,Left(Convert(Varchar,Sauda_Date,109),11),Scrip_Cd,Series,ScripName,SDT,
Sell_Buy,MarketType,Sett_No,Sett_Type,Sauda_Date1,TradeType,Tmark,Partyname,l_address1,l_address2,l_address3,
l_city,l_zip,service_chrg,Branch_cd,sub_broker,pan_gir_no,Off_Phone1,Off_Phone2,Printf,mapidid, OrderFlag,ScripName1
Insert into #ContSettNew 
Select * From #ContSett Where Printf <> '3' 

Update #ContSettNew Set Order_No = S.Order_No, TM = Convert(Varchar,S.Sauda_Date,108), Trade_No = S.Trade_No
From #ContSett S Where 
S.PrintF = #ContSettNew.PrintF And 
S.PrintF = '3' And 
S.Sauda_Date Like @Sauda_Date + '%'
And S.Scrip_cd = #ContSettNew.Scrip_CD
And S.Series = #ContSettNew.Series
And S.Party_Code = #ContSettNew.Party_Code
And S.ContractNo = #ContSettNew.ContractNo
And S.Sell_Buy = #ContSettNew.Sell_Buy
And S.Sauda_Date = (Select Min(Sauda_Date) From #ContSett ISett
Where PrintF = '3' And
ISett.Sauda_Date Like @Sauda_Date + '%'
And S.Scrip_cd = ISett.Scrip_CD
And S.Series = ISett.Series
And S.Party_Code = ISett.Party_Code
And S.ContractNo = ISett.ContractNo
And S.Sell_Buy = ISett.Sell_Buy )

Select * From #ContSettNew 
order by Party_code,Partyname,Branch_cd,ScripName1,OrderFlag,Sett_No, Sett_Type,  Order_No, Trade_No

GO
