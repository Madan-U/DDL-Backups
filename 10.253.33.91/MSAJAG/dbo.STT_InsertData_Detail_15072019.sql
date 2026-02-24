-- Object: PROCEDURE dbo.STT_InsertData_Detail_15072019
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE Proc STT_InsertData_Detail 
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
	And Sauda_Date = @Sauda_Date 
	And Sett_Type = @Sett_Type   
	And Party_Code >= @FromParty   
	And Party_Code <= @ToParty  
  
If Upper(LTrim(RTrim(@Sett_Type))) = 'N' Or Upper(LTrim(RTrim(@Sett_Type))) = 'D'  
Begin  

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

GO
