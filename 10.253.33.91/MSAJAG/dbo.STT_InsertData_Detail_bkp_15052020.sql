-- Object: PROCEDURE dbo.STT_InsertData_Detail_bkp_15052020
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



Create Proc [dbo].[STT_InsertData_Detail_bkp_15052020] 
(
	@Sett_Type Varchar(2), 
	@Sauda_Date Varchar(11), 
	@FromParty Varchar(10), 
	@ToParty Varchar(10)
) 

As   
  
Delete From STT_ClientDetail   
Where 
	RecType = 30   
	--And Sauda_Date Like @Sauda_Date + '%'  
	And Sauda_Date >=@Sauda_Date And Sauda_Date <=@Sauda_Date + ' 23:59'
	And Sett_Type = @Sett_Type   
	And Party_Code >= @FromParty   
	And Party_Code <= @ToParty  

Delete From Stt_clientdetail_NEW  
Where Rectype = 30   
And Sauda_date Like @sauda_date + '%'  
And Sett_type IN (SELECT ORG_SETT_TYPE FROM COMBINE_SETTLEMENT
				  WHERE Stt_clientdetail_NEW.PARTY_CODE = COMBINE_SETTLEMENT.PARTY_CODE 
				  AND Stt_clientdetail_NEW.CONTRACTNO = COMBINE_SETTLEMENT.ORG_CONTRACTNO)
				    
If Upper(LTrim(RTrim(@Sett_Type))) = 'N' Or Upper(LTrim(RTrim(@Sett_Type))) = 'D'  
Begin  
  
 /* Normal Clients Start Here */  
 Insert Into Stt_clientdetail_NEW    
 Select 30, EXCHG, Sett_no=ORG_SETT_NO, Sett_type=ORG_SETT_TYPE, Contractno=ORG_CONTRACTNO, Party_code, 
 Scrip_cd=ORG_SCRIP_CD, Series=ORG_SERIES, Sauda_date=left(convert(varchar,sauda_date,109),11),branch_id=party_code,  
 Pdelprice=round(sum(tradeqty*marketrate)/sum(tradeqty),2),  
 Pqtydel=sum(case When Sell_buy = 1 And Settflag  In  (1,4) Then Tradeqty Else 0 End),  
 Pamtdel=sum(case When Sell_buy = 1 And Settflag In  (1,4) Then Tradeqty Else 0 End)*round(sum(tradeqty*marketrate)/sum(tradeqty),2),  
 Psttdel=round(sum(case When Sell_buy = 1 And Settflag In (1,4) Then Ins_chrg Else 0 End),2),  
 Sdelprice=round(sum(tradeqty*marketrate)/sum(tradeqty),2),  
 Sqtydel=sum(case When Sell_buy = 2 And Settflag In (1,5) Then Tradeqty Else 0 End),  
 Samtdel=sum(case When Sell_buy = 2 And Settflag In (1,5) Then Tradeqty Else 0 End)*round(sum(tradeqty*marketrate)/sum(tradeqty),2),  
 Ssttdel=round(sum(case When Sell_buy = 2 And Settflag In (1,5) Then Ins_chrg Else 0 End),2),  
 Strdprice=round(sum(tradeqty*marketrate)/sum(tradeqty),2),  
 Sqtytrd=sum(case When Sell_buy = 2 And Settflag = 3 Then Tradeqty Else 0 End),  
 Samttrd=sum(case When Sell_buy = 2 And Settflag = 3 Then Tradeqty Else 0 End)*round(sum(tradeqty*marketrate)/sum(tradeqty),2),  
 Sstttrd=round(sum(case When Sell_buy = 2 And Settflag = 3 Then Ins_chrg Else 0 End),2),  
 Totalstt=round(sum(case When Sell_buy = 1 And Settflag In (1,4) Then Ins_chrg Else 0 End),2) +   
          Round(sum(case When Sell_buy = 2 And Settflag In (1,5) Then Ins_chrg Else 0 End),2) +  
          Round(sum(case When Sell_buy = 2 And Settflag = 3 Then Ins_chrg Else 0 End),2)  
 From STT_SETT_TABLE S, (SELECT SRNO,EXCHG, ORG_CONTRACTNO, ORG_SETT_NO, ORG_SETT_TYPE, ORG_SCRIP_CD, ORG_SERIES FROM COMBINE_SETTLEMENT) S1
 Where Sett_type = @sett_type And Sauda_date Like @sauda_date + '%'  
 And Party_code >= @fromparty And Party_code <= @toparty   
 And Auctionpart Not In ('ap','ar','fp','fl','fa','fc')  
 And Tradeqty > 0 And Trade_no Not Like '%c%'  
 AND S.srno = S1.SrNo
 Group By EXCHG, ORG_Sett_no, ORG_Sett_type, ORG_Contractno, Party_code, ORG_Scrip_cd, ORG_SERIES, Left(convert(varchar,sauda_date,109),11)  
 
	Insert Into STT_ClientDetail   
	Select 
		30, 
		Sett_no, 
		Sett_Type, 
		ContractNo, 
		Party_Code, 
		Scrip_Cd, 
		Series, 
		Sauda_Date=Left(Convert(Varchar,Sauda_Date,109),11),
		Branch_Id=Party_Code,  
		PDelPrice=Round(Sum(TradeQty*MarketRate)/Sum(TradeQty),2),  
		PQtyDel=Sum(Case When Sell_Buy = 1 And SettFlag  In  (1,4) Then TradeQty Else 0 End),  
		PAmtDel=Sum(Case When Sell_Buy = 1 And SettFlag In  (1,4) Then TradeQty Else 0 End)*Round(Sum(TradeQty*MarketRate)/Sum(TradeQty),2),  
		PSTTDel=Round(Sum(Case When Sell_Buy = 1 And SettFlag In (1,4) Then Ins_Chrg Else 0 End),2),  
		SDelPrice=Round(Sum(TradeQty*MarketRate)/Sum(TradeQty),2),  
		SQtyDel=Sum(Case When Sell_Buy = 2 And SettFlag in (1,5) Then TradeQty Else 0 End),  
		SAmtDel=Sum(Case When Sell_Buy = 2 And SettFlag in (1,5) Then TradeQty Else 0 End)*Round(Sum(TradeQty*MarketRate)/Sum(TradeQty),2),  
		SSTTDel=Round(Sum(Case When Sell_Buy = 2 And SettFlag in (1,5) Then Ins_Chrg Else 0 End),2),  
		STrdPrice=Round(Sum(TradeQty*MarketRate)/Sum(TradeQty),2),  
		SQtyTrd=Sum(Case When Sell_Buy = 2 And SettFlag = 3 Then TradeQty Else 0 End),  
		SAmtTrd=Sum(Case When Sell_Buy = 2 And SettFlag = 3 Then TradeQty Else 0 End)*Round(Sum(TradeQty*MarketRate)/Sum(TradeQty),2),  
		SSTTTrd=Round(Sum(Case When Sell_Buy = 2 And SettFlag = 3 Then Ins_Chrg Else 0 End),2),  
		TotalSTT=Round(Sum(Case When Sell_Buy = 1 And SettFlag In (1,4) Then Ins_Chrg Else 0 End),2) + Round(Sum(Case When Sell_Buy = 2 And SettFlag In (1,5) Then Ins_Chrg Else 0 End),2) + Round(Sum(Case When Sell_Buy = 2 And SettFlag = 3 Then Ins_Chrg Else 0 End),2)  
	From 
		STT_SETT_TABLE (nolock)
	Where 
		TradeQty > 0 
		--And Trade_No Not Like '%C%'  
		And User_Id Not In ( Select UserId From TermParty )  
	Group By Sett_no, Sett_Type, ContractNo, Party_Code, Scrip_Cd, Series, Left(Convert(Varchar,Sauda_Date,109),11)  
   

	 /* Inst Clients Start here */  
	 Insert Into STT_ClientDetail   
	 Select 
	30, 
	Sett_no, 
	Sett_Type, 
	ContractNo, 
	Party_Code, 
	Scrip_Cd, 
	Series, 
	Sauda_Date=Left(Convert(Varchar,Sauda_Date,109),11),
	Branch_Id=Party_Code,  
	PDelPrice=Round(Sum(TradeQty*MarketRate)/Sum(TradeQty),2),   
	PQtyDel=Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End),  
	PAmtDel=Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End)*Round(Sum(TradeQty*MarketRate)/Sum(TradeQty),2),  
	PSTTDel=Round(Sum(Case When Sell_Buy = 1 Then Ins_Chrg Else 0 End),2),  
	SDelPrice=Round(Sum(TradeQty*MarketRate)/Sum(TradeQty),2),  
	SQtyDel=Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End),  
	SAmtDel=Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End)*Round(Sum(TradeQty*MarketRate)/Sum(TradeQty),2),  
	SSTTDel=Round(Sum(Case When Sell_Buy = 2 Then Ins_Chrg Else 0 End),2),  
	STrdPrice=0,  
	SQtyTrd=0,  
	SAmtTrd=0,  
	SSTTTrd=0,  
	TotalSTT=Round(Sum(Case When Sell_Buy = 1 Then Ins_Chrg Else 0 End),2) + Round(Sum(Case When Sell_Buy = 2 Then Ins_Chrg Else 0 End),2)  
	From 
		STT_ISETT_TABLE (nolock)
	Where 
		TradeQty > 0 
	--And Trade_No Not Like '%C%'  
	Group By Sett_no, Sett_Type, ContractNo, Party_Code, Scrip_Cd, Series, Left(Convert(Varchar,Sauda_Date,109),11)  

End   
Else  
Begin   
  
 /* Normal Clients Start Here */  
 Insert Into Stt_clientdetail_NEW    
 Select 30, EXCHG, Sett_no=ORG_SETT_NO, Sett_type=ORG_SETT_TYPE, Contractno=ORG_CONTRACTNO, Party_code, 
 Scrip_cd=ORG_SCRIP_CD, Series=ORG_SERIES, Sauda_date=left(convert(varchar,sauda_date,109),11),branch_id=party_code,  
 Pdelprice=round(sum(tradeqty*marketrate)/sum(tradeqty),2),  
 Pqtydel=sum(case When Sell_buy = 1 And Settflag  In  (1,4) Then Tradeqty Else 0 End),  
 Pamtdel=sum(case When Sell_buy = 1 And Settflag In  (1,4) Then Tradeqty Else 0 End)*round(sum(tradeqty*marketrate)/sum(tradeqty),2),  
 Psttdel=round(sum(case When Sell_buy = 1 And Settflag In (1,4) Then Ins_chrg Else 0 End),2),  
 Sdelprice=round(sum(tradeqty*marketrate)/sum(tradeqty),2),  
 Sqtydel=sum(case When Sell_buy = 2 And Settflag In (1,5) Then Tradeqty Else 0 End),  
 Samtdel=sum(case When Sell_buy = 2 And Settflag In (1,5) Then Tradeqty Else 0 End)*round(sum(tradeqty*marketrate)/sum(tradeqty),2),  
 Ssttdel=round(sum(case When Sell_buy = 2 And Settflag In (1,5) Then Ins_chrg Else 0 End),2),  
 Strdprice=round(sum(tradeqty*marketrate)/sum(tradeqty),2),  
 Sqtytrd=sum(case When Sell_buy = 2 And Settflag = 3 Then Tradeqty Else 0 End),  
 Samttrd=sum(case When Sell_buy = 2 And Settflag = 3 Then Tradeqty Else 0 End)*round(sum(tradeqty*marketrate)/sum(tradeqty),2),  
 Sstttrd=round(sum(case When Sell_buy = 2 And Settflag = 3 Then Ins_chrg Else 0 End),2),  
 Totalstt=round(sum(case When Sell_buy = 1 And Settflag In (1,4) Then Ins_chrg Else 0 End),2) +   
          Round(sum(case When Sell_buy = 2 And Settflag In (1,5) Then Ins_chrg Else 0 End),2) +  
          Round(sum(case When Sell_buy = 2 And Settflag = 3 Then Ins_chrg Else 0 End),2)  
 From STT_SETT_TABLE S, (SELECT SRNO,EXCHG, ORG_CONTRACTNO, ORG_SETT_NO, ORG_SETT_TYPE, ORG_SCRIP_CD, ORG_SERIES FROM COMBINE_SETTLEMENT) S1
 Where Sett_type = @sett_type And Sauda_date Like @sauda_date + '%'  
 And Party_code >= @fromparty And Party_code <= @toparty   
 And Auctionpart Not In ('ap','ar','fp','fl','fa','fc')  
 And Tradeqty > 0 And Trade_no Not Like '%c%'  
 AND S.srno = S1.SrNo
 Group By EXCHG, ORG_Sett_no, ORG_Sett_type, ORG_Contractno, Party_code, ORG_Scrip_cd, ORG_SERIES, Left(convert(varchar,sauda_date,109),11)  
 
	Insert Into STT_ClientDetail   
	Select 
		30, 
		Sett_no, 
		Sett_Type, 
		ContractNo, 
		Party_Code, 
		Scrip_Cd, 
		Series, 
		Sauda_Date=Left(Convert(Varchar,Sauda_Date,109),11),
		Branch_Id=Party_Code,  
		PDelPrice=	(Case When Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End) > 0   
					Then Round(Sum(Case When Sell_Buy = 1 Then TradeQty*MarketRate Else 0 End)/  Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End),2)  Else 0  
			 	End),  
		PQtyDel=Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End),  
		PAmtDel=Round(Sum(Case When Sell_Buy = 1 Then TradeQty*MarketRate Else 0 End),2),  
		PSTTDel=Round(Sum(Case When Sell_Buy = 1 Then Ins_Chrg Else 0 End),2),  
		SDelPrice=	(Case When Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) > 0   
					Then Round(Sum(Case When Sell_Buy = 2 Then TradeQty*MarketRate Else 0 End)/  Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End),2)  
				Else 0   
				End),  
		SQtyDel=Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End),  
		SAmtDel=Round(Sum(Case When Sell_Buy = 2 Then TradeQty*MarketRate Else 0 End),2),  
		SSTTDel=Round(Sum(Case When Sell_Buy = 2 Then Ins_Chrg Else 0 End),2),  
		STrdPrice=0,  
		SQtyTrd=0,  
		SAmtTrd=0,  
		SSTTTrd=0,  
		TotalSTT=Round(Sum(Case When Sell_Buy = 1 Then Ins_Chrg Else 0 End),2) + Round(Sum(Case When Sell_Buy = 2 Then Ins_Chrg Else 0 End),2)  
	From 
		STT_SETT_TABLE (NOLOCK) 
	Where 
		TradeQty > 0 
		--And Trade_No Not Like '%C%' 
		And User_Id Not In ( Select UserId From TermParty )  
	Group By Sett_no, Sett_Type, ContractNo, Party_Code, Scrip_Cd, Series, Left(Convert(Varchar,Sauda_Date,109),11)  
	 /* Normal Clients End here */  


   
	Insert Into STT_ClientDetail   
	Select 
		30, 
		Sett_no, 
		Sett_Type, 
		ContractNo, 
		Party_Code, 
		Scrip_Cd, 
		Series, 
		Sauda_Date=Left(Convert(Varchar,Sauda_Date,109),11),
		Branch_Id=Party_Code,  
		PDelPrice=	(Case When Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End) > 0   
					Then Round(Sum(Case When Sell_Buy = 1 Then TradeQty*MarketRate Else 0 End)/  Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End),2)  
				Else 0   
				End),  
		PQtyDel=Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End),  
		PAmtDel=Round(Sum(Case When Sell_Buy = 1 Then TradeQty*MarketRate Else 0 End),2),  
		PSTTDel=Round(Sum(Case When Sell_Buy = 1 Then Ins_Chrg Else 0 End),2),  
		SDelPrice=	(Case When Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) > 0   
					Then Round(Sum(Case When Sell_Buy = 2 Then TradeQty*MarketRate Else 0 End)/  Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End),2)  
				Else 0   
				End),  
		SQtyDel=Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End),  
		SAmtDel=Round(Sum(Case When Sell_Buy = 2 Then TradeQty*MarketRate Else 0 End),2),  
		SSTTDel=Round(Sum(Case When Sell_Buy = 2 Then Ins_Chrg Else 0 End),2),  
		STrdPrice=0,  
		SQtyTrd=0,  
		SAmtTrd=0,  
		SSTTTrd=0,  
		TotalSTT=Round(Sum(Case When Sell_Buy = 1 Then Ins_Chrg Else 0 End),2) + Round(Sum(Case When Sell_Buy = 2 Then Ins_Chrg Else 0 End),2)  
	From 
		STT_ISETT_TABLE (NOLOCK)
	Where 
		TradeQty > 0 
		--And Trade_No Not Like '%C%' 
		And User_Id Not In ( Select UserId From TermParty )  
	Group By Sett_no, Sett_Type, ContractNo, Party_Code, Scrip_Cd, Series, Left(Convert(Varchar,Sauda_Date,109),11)  
	/* Inst Clients End here */    
  


	/* Terminal Clients Start here */  
	Insert Into STT_ClientDetail   
	Select 
		30, 
		Sett_no, 
		Sett_Type, 
		ContractNo, 
		Party_Code, 
		Scrip_Cd, 
		Series, 
		Sauda_Date=Left(Convert(Varchar,Sauda_Date,109),11), 
		Branch_Id,  
		PDelPrice=	(Case When Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End) > 0   
					Then Round(Sum(Case When Sell_Buy = 1 Then TradeQty*MarketRate Else 0 End)/  Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End),2)  
				Else 0   
				End),  
		PQtyDel=Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End),  
		PAmtDel=Round(Sum(Case When Sell_Buy = 1 Then TradeQty*MarketRate Else 0 End),2),  
		PSTTDel=Round(Sum(Case When Sell_Buy = 1 Then Ins_Chrg Else 0 End),2),  
		SDelPrice=	(Case When Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) > 0   
					Then Round(Sum(Case When Sell_Buy = 2 Then TradeQty*MarketRate Else 0 End)/  Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End),2)  
				Else 0   
				End),  
		SQtyDel=Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End),  
		SAmtDel=Round(Sum(Case When Sell_Buy = 2 Then TradeQty*MarketRate Else 0 End),2),  
		SSTTDel=Round(Sum(Case When Sell_Buy = 2 Then Ins_Chrg Else 0 End),2),  
		STrdPrice=0,  
		SQtyTrd=0,  
		SAmtTrd=0,  
		SSTTTrd=0,  
		TotalSTT=Round(Sum(Case When Sell_Buy = 1 Then Ins_Chrg Else 0 End),2) + Round(Sum(Case When Sell_Buy = 2 Then Ins_Chrg Else 0 End),2)  
	From 
		STT_SETT_TABLE (nolock)
	Where 
		TradeQty > 0 
		--And Trade_No Not Like '%C%' 
		And User_Id In ( Select UserId From TermParty )  
		Group By Sett_no, Sett_Type, ContractNo, Party_Code, Branch_Id, Scrip_Cd, Series, Left(Convert(Varchar,Sauda_Date,109),11)  

End  
  
  
  
  
---------------------------------------------

GO
