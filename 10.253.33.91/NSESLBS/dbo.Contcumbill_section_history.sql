-- Object: PROCEDURE dbo.Contcumbill_section_history
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Proc Contcumbill_section_history 
(@statusid Varchar(15), @statusname Varchar(25), @sauda_date Varchar(11), @sett_no Varchar(7), @sett_type Varchar(2), @fromparty_code Varchar(10) ,@toparty_code Varchar(10), @branch Varchar(10), @sub_broker Varchar(10))
As

Set Transaction Isolation Level Read Uncommitted
/*for Last Day Of The History Or One Day History Record */
Select Contractno, S.party_code, Order_no, Tm=convert(varchar,sauda_date,108), Trade_no, Sauda_date, S.scrip_cd, S.series,  
Scripname = S1.short_name, Sdt = Convert(varchar,sauda_date,103), Sell_buy, S.markettype,broker_chrg= (case When C2.brokernote = 1 Then Broker_chrg Else 0 End), 
Service_tax = (case When Service_chrg = 0 Then Nsertax Else 0 End ),
Turn_tax = (case When Turnover_tax = 1 Then Turn_tax Else 0 End),  
Ins_chrg = (case When Insurance_chrg = 1 Then Ins_chrg Else 0 End),  
Sauda_date1 = Left(convert(varchar,sauda_date,109),11),
Pqty = (case When Sell_buy = 1 Then Tradeqty Else 0 End),
Sqty = (case When Sell_buy = 2 Then Tradeqty Else 0 End),
Prate = (case When Sell_buy = 1 Then Marketrate Else 0 End),
Srate = (case When Sell_buy = 2 Then Marketrate Else 0 End),
Pbrok = (case When Sell_buy = 1 
	      Then Nbrokapp + (case When Service_chrg = 1 
			            Then Nsertax/tradeqty 
			            Else 0 
				End)
	      Else 0 
	End),
Sbrok = (case When Sell_buy = 2 
	      Then Nbrokapp + (case When Service_chrg = 1 
			            Then Nsertax/tradeqty 
			            Else 0 
				End)
	      Else 0 
	End),
Pnetrate = (case When Sell_buy = 1 	
		 Then N_netrate +
	             (case When Service_chrg = 1 
		  	   Then Nsertax/tradeqty 
			   Else 0 
		      End)
	         Else 0 
     	    End),
Snetrate = (case When Sell_buy = 2 	
		 Then N_netrate -
	             (case When Service_chrg = 1 
		  	   Then Nsertax/tradeqty 
			   Else 0 
		      End)
	         Else 0 
     	    End),
Pamt = (case When Sell_buy = 1 
	     Then Tradeqty*(n_netrate +
	             (case When Service_chrg = 1 
		  	   Then Nsertax/tradeqty 
			   Else 0 
		      End)) 
	     Else 0 
	End),
Samt = (case When Sell_buy = 2
	     Then Tradeqty*(n_netrate -
	             (case When Service_chrg = 1 
		  	   Then Nsertax/tradeqty 
			   Else 0 
		      End)) 
	     Else 0 
	End),
Brokerage = Tradeqty*nbrokapp+(case When Service_chrg = 1 Then Nsertax Else 0 End),
S.sett_no, S.sett_type, Tradetype = '  ',
Tmark = Case When Billflag = 1 Or Billflag = 4 Or Billflag = 5 Then 'd' Else '' End ,
/*to Display The Header Part*/
Partyname = C1.long_name,
C1.l_address1,c1.l_address2,c1.l_address3,
C1.l_city,c1.l_zip, C2.service_chrg,c1.branch_cd ,c1.sub_broker,c1.pan_gir_no,
C1.off_phone1,c1.off_phone2,printf Into #contsett
From History S, Sett_mst M, Scrip1 S1, Scrip2 S2, Client1 C1, Client2 C2
Where C1.cl_code = C2.cl_code 
And C2.party_code = S.party_code
And S.scrip_cd = S2.scrip_cd
And S.series = S2.series
And S1.co_code = S2.co_code
And S1.series = S2.series
And S.sett_no = M.sett_no 
And S.sett_type = M.sett_type
And M.end_date Like @sauda_date + '%'
And S.sett_type = @sett_type
And Sauda_date <= @sauda_date + ' 23:59' 
And S.party_code Between @fromparty_code And  @toparty_code
And S.tradeqty > 0
And Branch_cd Like (case When @statusid = 'branch' Then @statusname Else '%' End)
And Sub_broker Like (case When @statusid = 'subbroker' Then @statusname Else '%' End)
And Trader Like (case When @statusid = 'trader' Then @statusname Else '%' End)
And Family Like (case When @statusid = 'family' Then @statusname Else '%' End)
And Region Like (case When @statusid = 'region' Then @statusname Else '%' End)
And Area Like (case When @statusid = 'area' Then @statusname Else '%' End)
And C2.party_code Like (case When @statusid = 'client' Then @statusname Else '%' End)
And Branch_cd Like @branch
And Sub_broker Like @sub_broker

Set Transaction Isolation Level Read Uncommitted
Insert Into #contsett
/*for Other Day Except The Last Day Of The History For Not One Day History Record */
Select Contractno, S.party_code, Order_no, Tm=convert(varchar,sauda_date,108), Trade_no, Sauda_date, S.scrip_cd, S.series,
Scripname = S1.short_name, Sdt = Convert(varchar,sauda_date,103), Sell_buy, S.markettype, Broker_chrg= (case When C2.brokernote = 1 Then Broker_chrg Else 0 End), 
Service_tax = (case When Service_chrg = 0 Then Service_tax Else 0 End ),
Turn_tax = (case When Turnover_tax = 1 Then Turn_tax Else 0 End),  
Ins_chrg = (case When Insurance_chrg = 1 Then Ins_chrg Else 0 End),  
Sauda_date1 = Left(convert(varchar,sauda_date,109),11),
Pqty = (case When Sell_buy = 1 Then Tradeqty Else 0 End),
Sqty = (case When Sell_buy = 2 Then Tradeqty Else 0 End),
Prate = (case When Sell_buy = 1 Then Marketrate Else 0 End),
Srate = (case When Sell_buy = 2 Then Marketrate Else 0 End),
Pbrok = (case When Sell_buy = 1 
	      Then Brokapplied + (case When Service_chrg = 1 
			            Then Service_tax/tradeqty 
			            Else 0 
				End)
	      Else 0 
	End),
Sbrok = (case When Sell_buy = 2 
	      Then Brokapplied + (case When Service_chrg = 1 
			            Then Service_tax/tradeqty 
			            Else 0 
				End)
	      Else 0 
	End),
Pnetrate = (case When Sell_buy = 1 	
		 Then Netrate +
	             (case When Service_chrg = 1 
		  	   Then Service_tax/tradeqty 
			   Else 0 
		      End)
	         Else 0 
     	    End),
Snetrate = (case When Sell_buy = 2 	
		 Then Netrate -
	             (case When Service_chrg = 1 
		  	   Then Service_tax/tradeqty 
			   Else 0 
		      End)
	         Else 0 
     	    End),
Pamt = (case When Sell_buy = 1 
	     Then Tradeqty*(netrate +
	             (case When Service_chrg = 1 
		  	   Then Service_tax/tradeqty 
			   Else 0 
		      End)) 
	     Else 0 
	End),
Samt = (case When Sell_buy = 2
	     Then Tradeqty*(netrate -
	             (case When Service_chrg = 1 
		  	   Then Service_tax/tradeqty 
			   Else 0 
		      End)) 
	     Else 0 
	End),
Brokerage = Tradeqty*brokapplied+(case When Service_chrg = 1 Then Service_tax Else 0 End),
S.sett_no, S.sett_type, Tradetype = '  ',
Tmark = Case When Billflag = 1 Or Billflag = 4 Or Billflag = 5 Then 'd' Else '' End ,
/*to Display The Header Part*/
Partyname = C1.long_name,
C1.l_address1,c1.l_address2,c1.l_address3,
C1.l_city,c1.l_zip, C2.service_chrg,c1.branch_cd ,c1.sub_broker,c1.pan_gir_no,
C1.off_phone1,c1.off_phone2 ,printf
From History S, Sett_mst M, Scrip1 S1, Scrip2 S2, Client1 C1, Client2 C2
Where C1.cl_code = C2.cl_code 
And C2.party_code = S.party_code
And S.scrip_cd = S2.scrip_cd
And S.series = S2.series
And S1.co_code = S2.co_code
And S1.series = S2.series
And S.sett_no = M.sett_no And S.sett_type = M.sett_type
And M.end_date Not Like @sauda_date + '%' 
And S.sett_no = @sett_no And S.sett_type = @sett_type
And Sauda_date <= @sauda_date + ' 23:59'
And S.party_code Between @fromparty_code And  @toparty_code
And S.tradeqty > 0
And Branch_cd Like (case When @statusid = 'branch' Then @statusname Else '%' End)
And Sub_broker Like (case When @statusid = 'subbroker' Then @statusname Else '%' End)
And Trader Like (case When @statusid = 'trader' Then @statusname Else '%' End)
And Family Like (case When @statusid = 'family' Then @statusname Else '%' End)
And Region Like (case When @statusid = 'region' Then @statusname Else '%' End)
And Area Like (case When @statusid = 'area' Then @statusname Else '%' End)
And C2.party_code Like (case When @statusid = 'client' Then @statusname Else '%' End)
And Branch_cd Like @branch
And Sub_broker Like @sub_broker

Set Transaction Isolation Level Read Uncommitted
Insert Into #contsett

/* Nd Record Brought Forward For Same Day Or Previous Days */
Select Contractno, S.party_code, Order_no, Tm=convert(varchar,sauda_date,108), Trade_no, Sauda_date, S.scrip_cd, S.series,
Scripname = S1.short_name, Sdt = Convert(varchar,sauda_date,103), Sell_buy, S.markettype, 
Broker_chrg= (case When C2.brokernote = 1 Then Broker_chrg Else 0 End), 
Service_tax = 0,turn_tax = (case When Turnover_tax = 1 Then Turn_tax Else 0 End),  
Ins_chrg = (case When Insurance_chrg = 1 Then Ins_chrg Else 0 End),  
Sauda_date1 = Left(convert(varchar,sauda_date,109),11),
Pqty = (case When Sell_buy = 1 Then Tradeqty Else 0 End),
Sqty = (case When Sell_buy = 2 Then Tradeqty Else 0 End),
Prate = (case When Sell_buy = 1 Then Marketrate Else 0 End),
Srate = (case When Sell_buy = 2 Then Marketrate Else 0 End),
Pbrok = 0, 
Sbrok = 0, 
Pnetrate = (case When Sell_buy = 1 Then Marketrate Else 0 End),
Snetrate = (case When Sell_buy = 2 Then Marketrate Else 0 End),
Pamt = (case When Sell_buy = 1 Then Tradeqty*marketrate Else 0 End),
Samt = (case When Sell_buy = 2 Then Tradeqty*marketrate Else 0 End),
Brokerage = 0, S.sett_no, S.sett_type, Tradetype = 'bf',
Tmark = Case When Billflag = 1 Or Billflag = 4 Or Billflag = 5 Then '' Else '' End ,
/*to Display The Header Part*/
Partyname = C1.long_name,
C1.l_address1,c1.l_address2,c1.l_address3,
C1.l_city,c1.l_zip, C2.service_chrg,c1.branch_cd ,c1.sub_broker,c1.pan_gir_no,
C1.off_phone1,c1.off_phone2 ,printf
From History S, Sett_mst M, Scrip1 S1, Scrip2 S2, Client1 C1, Client2 C2
Where C1.cl_code = C2.cl_code 
And C2.party_code = S.party_code
And S.scrip_cd = S2.scrip_cd
And S.series = S2.series
And S1.co_code = S2.co_code
And S1.series = S2.series
And S.sett_no = M.sett_no And S.sett_type = M.sett_type
And M.end_date > @sauda_date + ' 23:59:59' 
And M.end_date Not Like @sauda_date + '%' 
And S.sett_type = @sett_type
And Sauda_date <= @sauda_date + ' 23:59' 
And S.party_code Between @fromparty_code And  @toparty_code
And S.tradeqty > 0
And Branch_cd Like (case When @statusid = 'branch' Then @statusname Else '%' End)
And Sub_broker Like (case When @statusid = 'subbroker' Then @statusname Else '%' End)
And Trader Like (case When @statusid = 'trader' Then @statusname Else '%' End)
And Family Like (case When @statusid = 'family' Then @statusname Else '%' End)
And Region Like (case When @statusid = 'region' Then @statusname Else '%' End)
And Area Like (case When @statusid = 'area' Then @statusname Else '%' End)
And C2.party_code Like (case When @statusid = 'client' Then @statusname Else '%' End)
And Branch_cd Like @branch
And Sub_broker Like @sub_broker

Set Transaction Isolation Level Read Uncommitted
Insert Into #contsett

/* Nd Record Carry Forward For Same Day Or Previous Days */
Select Contractno, S.party_code, Order_no, Tm=convert(varchar,sauda_date,108), Trade_no, Sauda_date, S.scrip_cd, S.series,
Scripname = S1.short_name, Sdt = Convert(varchar,sauda_date,103), Sell_buy=(case When Sell_buy = 1 Then 2 Else 1 End), S
.markettype, Broker_chrg= (case When C2.brokernote = 1 Then Broker_chrg Else 0 End), 
Service_tax = 0,turn_tax = (case When Turnover_tax = 1 Then Turn_tax Else 0 End),  
Ins_chrg = (case When Insurance_chrg = 1 Then Ins_chrg Else 0 End),  
Sauda_date1 = Left(convert(varchar,sauda_date,109),11),
Pqty = (case When Sell_buy = 2 Then Tradeqty Else 0 End),
Sqty = (case When Sell_buy = 1 Then Tradeqty Else 0 End),
Prate = (case When Sell_buy = 2 Then Marketrate Else 0 End),
Srate = (case When Sell_buy = 1 Then Marketrate Else 0 End),
Pbrok = 0, 
Sbrok = 0, 
Pnetrate = (case When Sell_buy = 2 Then Marketrate Else 0 End),
Snetrate = (case When Sell_buy = 1 Then Marketrate Else 0 End),
Pamt = (case When Sell_buy = 2 Then Tradeqty*marketrate Else 0 End),
Samt = (case When Sell_buy = 1 Then Tradeqty*marketrate Else 0 End),
Brokerage = 0, S.sett_no, S.sett_type, Tradetype = 'cf',
Tmark = Case When Billflag = 1 Or Billflag = 4 Or Billflag = 5 Then '' Else '' End ,
/*to Display The Header Part*/
Partyname = C1.long_name,
C1.l_address1,c1.l_address2,c1.l_address3,
C1.l_city,c1.l_zip, C2.service_chrg,c1.branch_cd ,c1.sub_broker,c1.pan_gir_no,
C1.off_phone1,c1.off_phone2 ,printf

From History S, Sett_mst M, Scrip1 S1, Scrip2 S2, Client1 C1, Client2 C2
Where C1.cl_code = C2.cl_code 
And C2.party_code = S.party_code
And S.scrip_cd = S2.scrip_cd
And S.series = S2.series
And S1.co_code = S2.co_code
And S1.series = S2.series
And S.sett_no = M.sett_no And S.sett_type = M.sett_type
And M.end_date > @sauda_date + ' 23:59:59' 
And M.end_date Not Like @sauda_date + '%' 
And S.sett_type = @sett_type
And Sauda_date <= @sauda_date + ' 23:59' 
And S.party_code Between @fromparty_code And  @toparty_code
And S.tradeqty > 0
And Branch_cd Like (case When @statusid = 'branch' Then @statusname Else '%' End)
And Sub_broker Like (case When @statusid = 'subbroker' Then @statusname Else '%' End)
And Trader Like (case When @statusid = 'trader' Then @statusname Else '%' End)
And Family Like (case When @statusid = 'family' Then @statusname Else '%' End)
And Region Like (case When @statusid = 'region' Then @statusname Else '%' End)
And Area Like (case When @statusid = 'area' Then @statusname Else '%' End)
And C2.party_code Like (case When @statusid = 'client' Then @statusname Else '%' End)
And Branch_cd Like @branch
And Sub_broker Like @sub_broker

Set Transaction Isolation Level Read Uncommitted
Select Contractno,party_code,order_no='0000000000000000',tm='0000000000000',trade_no='00000000000000',
Sauda_date=left(convert(varchar,sauda_date,109),11),scrip_cd,series,scripname,sdt,
Sell_buy,markettype,broker_chrg=sum(broker_chrg),service_tax=sum(service_tax),turn_tax = Sum(turn_tax),  
Ins_chrg = Sum(ins_chrg),  
Sauda_date1,pqty=sum(pqty),sqty=sum(sqty),
Prate=(case When Sum(pqty) > 0 Then Sum(prate*pqty)/sum(pqty) Else 0 End),
Srate=(case When Sum(sqty) > 0 Then Sum(srate*sqty)/sum(sqty) Else 0 End),
Pbrok=(case When Sum(pqty) > 0 Then Sum(pbrok*pqty)/sum(pqty) Else 0 End),
Sbrok=(case When Sum(sqty) > 0 Then Sum(sbrok*sqty)/sum(sqty) Else 0 End),
Pnetrate=(case When Sum(pqty) > 0 Then Sum(pnetrate*pqty)/sum(pqty) Else 0 End),
Snetrate=(case When Sum(sqty) > 0 Then Sum(snetrate*sqty)/sum(sqty) Else 0 End),
Pamt=sum(pamt),samt=sum(samt),brokerage=sum(brokerage),sett_no,sett_type,tradetype,tmark,partyname,
L_address1,l_address2,l_address3,l_city,l_zip,service_chrg,branch_cd,sub_broker,pan_gir_no,off_phone1,off_phone2,printf, Roundto = 4
Into #contsettnew From #contsett Where Printf = '3' 
Group By Contractno,party_code,left(convert(varchar,sauda_date,109),11),scrip_cd,series,scripname,sdt,
Sell_buy,markettype,sett_no,sett_type,sauda_date1,tradetype,tmark,partyname,l_address1,l_address2,l_address3,
L_city,l_zip,service_chrg,branch_cd,sub_broker,pan_gir_no,off_phone1,off_phone2,printf

Set Transaction Isolation Level Read Uncommitted
Update #contsettnew Set Order_no = S.order_no, Tm = Convert(varchar,s.sauda_date,108), Trade_no = S.trade_no
From #contsett S Where S.sauda_date Like @sauda_date + '%'
And S.scrip_cd = #contsettnew.scrip_cd
And S.party_code = #contsettnew.party_code
And S.sell_buy = #contsettnew.sell_buy
And S.sauda_date = (select Min(sauda_date) From #contsett Isett
Where Isett.sauda_date Like @sauda_date + '%'
And S.scrip_cd = Isett.scrip_cd
And S.series = Isett.series
And S.party_code = Isett.party_code
And S.sell_buy = Isett.sell_buy And S.contractno = Isett.contractno)

Set Transaction Isolation Level Read Uncommitted
Insert Into #contsettnew 
Select *,roundto = 2 From #contsett Where Printf <> '3'

Set Transaction Isolation Level Read Uncommitted
Update #contsettnew Set Contractno = C.contractno From 
(select Party_code, Contractno = Max(contractno) From #contsett
 Group By Party_code ) C
Where #contsettnew.party_code = C.party_code

Set Transaction Isolation Level Read Uncommitted
Select * From #contsettnew
Order By Party_code,scripname,sett_no, Sett_type, Tradetype, Order_no, Trade_no
Option (fast 1)

GO
