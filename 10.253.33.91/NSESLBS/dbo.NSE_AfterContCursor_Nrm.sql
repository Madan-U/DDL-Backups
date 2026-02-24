-- Object: PROCEDURE dbo.NSE_AfterContCursor_Nrm
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc NSE_AfterContCursor_Nrm (  
@Sett_No Varchar(7),  
@Sett_Type Varchar(2),  
@Sauda_Date  Varchar(11),  
@FromParty Varchar(10),  
@ToParty Varchar(10),  
@Scrip_Cd Varchar(12),  
@Series  Varchar(3),  
@Sell_Buy Int,  
@OrgContractNo Varchar(7),  
@MarketRate Float,  
@PartiPantCode Varchar(15),  
@TerminalId   varchar(10),  
@Branch_Id varchar(10),  
@Order_No  varchar(16),    
@Trade_No  varchar(14),  
@TQty   Int,  
@NewContractNo Varchar(7),
@StatusName  VarChar(50),    
@FromWhere  VarChar(50)  
) As  
  
Declare   
@Cl_Type Varchar(3),  
@ContractNo Varchar(10),  
@TradeQty Int,  
@XTrade_No Varchar(14),  
@BillNo  Int,  
@TFlag  Int,  
@SettCur Cursor  
  
Select @Cl_Type = Cl_Type From Client1 C1, Client2 C2  
Where C1.Cl_Code = C2.Cl_Code  
And C2.Party_Code = @ToParty  
  
If @Cl_Type = 'PRO'   
 Select @ContractNo = '0000000'  
Else  
Begin  
 Select @ContractNo = 0   
  
 Select Top 1 @ContractNo = ContractNo From Settlement  
 Where Sett_Type = @Sett_Type  
 And Sauda_Date Like @Sauda_Date + '%'  
 And Party_Code = @ToParty  
 And Trade_No Not Like '%C%'  
  
 If @ContractNo = '0' Or @ContractNo Is Null  
 Begin   
  Select @ContractNo = Contractno + 1  From Contgen  
  Where @Sauda_Date Between Start_Date And End_Date  
  
  Update Contgen Set ContractNo = @ContractNo  
  Where @Sauda_Date Between Start_Date And End_Date  
 End  
End  
   
Select @Contractno = STUFF('0000000', 8 - Len(@Contractno), Len(@Contractno), @Contractno)  
  
Select @BillNo = 0  
  
Select Top 1 @BillNo = BillNo  
From Settlement  
Where Sett_No = @Sett_No  
And Sett_Type = @Sett_Type  
And Party_Code = @ToParty
  
If @BillNo = 0 Or @BillNo Is Null  
Begin  
 Select @BillNo = Max(Convert(Int,BillNo))   
 From Settlement  
 Where Sett_No = @Sett_No  
 And Sett_Type = @Sett_Type   
End  
  
If @BillNo > 0   
 Select @BillNo = @BillNo + 1  
  
if @TQty = 0 
Begin
	Insert into  
	     Settlement  
	    Select  
	     @Contractno,  
	     @Billno,  
	     Trade_No = 'T' + Trade_No,  
	     @ToParty,
	     Scrip_Cd,
	     User_Id,  
	     TradeQty,  
	     Auctionpart,  
	     Markettype,  
	     Series,  
	     Order_No,  
	     Marketrate,  
	     Sauda_Date,  
	     Table_No,  
	     Line_No,  
	     Val_Perc,  
	     Normal,  
	     Day_Puc,  
	     Day_Sales,  
	     Sett_Purch,  
	     Sett_Sales,  
	     Sell_Buy,  
	     Settflag,  
	     Brokapplied,  
	     Netrate,  
	     Amount,  
	     Ins_Chrg,  
	     Turn_Tax,  
	     Other_Chrg,  
	     Sebi_Tax,  
	     Broker_Chrg,  
	     Service_Tax,  
	     Trade_Amount,  
	     Billflag,  
	     Sett_No,  
	     Nbrokapp,  
	     Nsertax,  
	     N_Netrate,  
	     Sett_Type,  
	     Partipantcode,  
	     Status,  
	     Pro_Cli,  
	     Cpid,  
	     Instrument,  
	     Booktype,  
	     Branch_Id,  
	     Tmark,  
	     Scheme,  
	     Dummy1,  
	     Dummy2
	From  
		Settlement  
	Where  
		Sett_No = @Sett_No  
		And Sett_Type = @Sett_Type  
		And Sauda_Date Like @Sauda_Date + '%'  
		And Party_Code = @FromParty  
		And Scrip_Cd Like @Scrip_Cd  
		And Series Like @Series  
		And ContractNo = @OrgContractNo  
		And TradeQty > 0 

	Update Settlement Set TradeQty = 0, MarketRate = 0, NetRate = 0, Brokapplied = 0, Service_Tax = 0,
	N_NetRate = 0, NBrokapp = 0, NSerTax = 0, Trade_Amount = 0, Amount = 0,
        Ins_Chrg = 0, Turn_Tax = 0, Other_Chrg = 0, Sebi_Tax = 0, Broker_Chrg = 0
	Where  
		Sett_No = @Sett_No  
		And Sett_Type = @Sett_Type  
		And Sauda_Date Like @Sauda_Date + '%'  
		And Party_Code = @FromParty  
		And Scrip_Cd Like @Scrip_Cd  
		And Series Like @Series  
		And ContractNo = @OrgContractNo  
		And TradeQty > 0 
End
Else
Begin
	Set @SettCur = Cursor For  
	Select Trade_No, Order_No, TradeQty  
	From Settlement  
	Where Sett_No = @Sett_No  
	And Sett_Type = @Sett_Type  
	And Sauda_Date Like @Sauda_Date + '%'  
	And Party_Code = @FromParty  
	And Scrip_Cd = @Scrip_Cd  
	And Series = @Series  
	And Sell_Buy = @Sell_Buy  
	And ContractNo = @OrgContractNo  
	And PartipantCode = @PartipantCode  
	And User_Id Like (Case When Len(@TerminalId) > 0 Then @TerminalId Else '%' End)  
	And Branch_Id Like (Case When Len(@Branch_Id) > 0 Then @Branch_Id Else '%' End)  
	And Order_No Like (Case When Len(@Order_No) > 0 Then @Order_No Else '%' End)  
	And Trade_no Like (Case When Len(@Trade_No) > 0 Then @Trade_No Else '%' End)  
	And Trade_No Not Like '%C%'  
	Open @SettCur  
	Fetch Next From @SettCur Into @Trade_No, @Order_No, @TradeQty  
	While @@Fetch_Status = 0 And @TQty > 0   
	Begin  
	 Set @TFlag = 1   
	 Select @XTrade_No = 'A' + @Trade_No  
	 While @TFlag = 1  
	 Begin  
	  If (Select IsNull(Count(1),0) From Settlement  
	      Where Sett_No = @Sett_No  
	      And Sett_Type = @Sett_Type  
	      And Sauda_Date Like @Sauda_Date + '%'  
	      And Scrip_Cd = @Scrip_Cd  
	      And Series = @Series  
	      And Sell_Buy = @Sell_Buy   
	      And Trade_No = @XTrade_No) > 0   
	  Begin  
	   IF LEFT(@XTrade_No, 1) = 'B'     
	   BEGIN    
	    SELECT @XTrade_No = CHAR(ASCII(LEFT(@XTrade_No, 1))+2) + RIGHT(RTRIM(@XTrade_No),LEN(RTRIM(@XTrade_No))-1)              
	   END    
	   ELSE IF LEFT(@XTrade_No, 1) = 'Z'     
	   BEGIN    
	    SELECT @XTrade_No = 'A' + @XTrade_No    
	   END    
	   ELSE     
	   BEGIN    
	    SELECT @XTrade_No = CHAR(ASCII(LEFT(@XTrade_No, 1))+1) + RIGHT(RTRIM(@XTrade_No),LEN(RTRIM(@XTrade_No))-1)              
	   END  
	  End  
	  Else  
	  Begin  
	   Set @TFlag = 0  
	  End   
	 End  
	  
	 If @TradeQty >= @TQty  
	 Begin  
	  Insert into Settlement  
	  Select @Contractno,@Billno,@XTrade_No,@ToParty,Scrip_Cd,User_Id,@TQty,Auctionpart,Markettype,  
	  Series,Order_No,Marketrate=(Case When @MarketRate = 0 Then MarketRate Else @MarketRate End),  
	  Sauda_Date,Table_No,Line_No,Val_Perc,Normal,Day_Puc,Day_Sales,  
	  Sett_Purch,Sett_Sales,Sell_Buy,Settflag,Brokapplied,  
	  Netrate,Amount,Ins_Chrg,Turn_Tax,Other_Chrg,  
	  Sebi_Tax,Broker_Chrg,Service_Tax,Trade_Amount,Billflag,Sett_No,Nbrokapp,Nsertax,N_Netrate,  
	  Sett_Type,Partipantcode,Status,Pro_Cli,Cpid,Instrument,Booktype,Branch_Id,Tmark,Scheme,Dummy1,Dummy2  
	  From Settlement  
	  Where Sett_No = @Sett_No  
	  And Sett_Type = @Sett_Type  
	  And Sauda_Date Like @Sauda_Date + '%'  
	  And Party_Code = @FromParty  
	  And Scrip_Cd = @Scrip_Cd  
	  And Series = @Series  
	  And Sell_Buy = @Sell_Buy  
	  And ContractNo = @OrgContractNo  
	  And PartipantCode = @PartipantCode  
	  And User_Id Like (Case When Len(@TerminalId) > 0 Then @TerminalId Else '%' End)  
	  And Branch_Id Like (Case When Len(@Branch_Id) > 0 Then @Branch_Id Else '%' End)  
	  And Order_No Like (Case When Len(@Order_No) > 0 Then @Order_No Else '%' End)  
	  And Trade_no Like (Case When Len(@Trade_No) > 0 Then @Trade_No Else '%' End)  
	  And TradeQty = @TradeQty  
	   
	  if @TradeQty > @TQty  
	  Begin  
	   Update Settlement Set TradeQty = @TradeQty - @TQty  
	   Where Sett_No = @Sett_No  
	   And Sett_Type = @Sett_Type  
	   And Sauda_Date Like @Sauda_Date + '%'  
	   And Party_Code = @FromParty  
	   And Scrip_Cd = @Scrip_Cd  
	   And Series = @Series  
	   And Sell_Buy = @Sell_Buy  
	   And ContractNo = @OrgContractNo  
	   And PartipantCode = @PartipantCode  
	   And User_Id Like (Case When Len(@TerminalId) > 0 Then @TerminalId Else '%' End)  
	   And Branch_Id Like (Case When Len(@Branch_Id) > 0 Then @Branch_Id Else '%' End)  
	   And Order_No Like (Case When Len(@Order_No) > 0 Then @Order_No Else '%' End)  
	   And Trade_no Like (Case When Len(@Trade_No) > 0 Then @Trade_No Else '%' End)  
	   And TradeQty = @TradeQty  
	  End  
	  Else  
	  Begin  
	   Update Settlement Set TradeQty = 0,  
	   Normal = 0,Day_puc = 0,day_sales = 0,Sett_purch = 0,Sett_sales  = 0,    
	                        marketrate = 0,Brokapplied = 0,NetRate = 0,Amount = 0,Ins_chrg = 0,  
	   turn_tax = 0,other_chrg = 0,sebi_tax = 0,Broker_chrg = 0,Service_tax = 0,  
	   Trade_amount = 0,NBrokApp = 0,NSerTax = 0,N_NetRate = 0   
	   Where Sett_No = @Sett_No  
	   And Sett_Type = @Sett_Type  
	   And Sauda_Date Like @Sauda_Date + '%'  
	   And Party_Code = @FromParty  
	   And Scrip_Cd = @Scrip_Cd  
	   And Series = @Series  
	   And Sell_Buy = @Sell_Buy  
	   And ContractNo = @OrgContractNo  
	   And PartipantCode = @PartipantCode  
	   And User_Id Like (Case When Len(@TerminalId) > 0 Then @TerminalId Else '%' End)  
	   And Branch_Id Like (Case When Len(@Branch_Id) > 0 Then @Branch_Id Else '%' End)  
	   And Order_No Like (Case When Len(@Order_No) > 0 Then @Order_No Else '%' End)  
	   And Trade_no Like (Case When Len(@Trade_No) > 0 Then @Trade_No Else '%' End)  
	   And TradeQty = @TradeQty  
	  End  
	  Select @TQty = 0   
	 End   
	 Else  
	 Begin  
	  Insert into Settlement  
	  Select @Contractno,@Billno,@XTrade_No,@ToParty,Scrip_Cd,User_Id,TradeQty,Auctionpart,Markettype,  
	  Series,Order_No,Marketrate=(Case When @MarketRate = 0 Then MarketRate Else @MarketRate End),  
	  Sauda_Date,Table_No,Line_No,Val_Perc,Normal,Day_Puc,Day_Sales,  
	  Sett_Purch,Sett_Sales,Sell_Buy,Settflag,Brokapplied,  
	  Netrate,Amount,Ins_Chrg,Turn_Tax,Other_Chrg,  
	  Sebi_Tax,Broker_Chrg,Service_Tax,Trade_Amount,Billflag,Sett_No,Nbrokapp,Nsertax,N_Netrate,  
	  Sett_Type,Partipantcode,Status,Pro_Cli,Cpid,Instrument,Booktype,Branch_Id,Tmark,Scheme,Dummy1,Dummy2  
	  From Settlement  
	  Where Sett_No = @Sett_No  
	  And Sett_Type = @Sett_Type  
	  And Sauda_Date Like @Sauda_Date + '%'  
	  And Party_Code = @FromParty  
	  And Scrip_Cd = @Scrip_Cd  
	  And Series = @Series  
	  And Sell_Buy = @Sell_Buy  
	  And ContractNo = @OrgContractNo  
	  And PartipantCode = @PartipantCode  
	  And User_Id Like (Case When Len(@TerminalId) > 0 Then @TerminalId Else '%' End)  
	  And Branch_Id Like (Case When Len(@Branch_Id) > 0 Then @Branch_Id Else '%' End)  
	  And Order_No Like (Case When Len(@Order_No) > 0 Then @Order_No Else '%' End)  
	  And Trade_no Like (Case When Len(@Trade_No) > 0 Then @Trade_No Else '%' End)  
	  And TradeQty = @TradeQty  
	  
	  Update Settlement Set TradeQty = 0,  
	  Normal = 0,Day_puc = 0,day_sales = 0,Sett_purch = 0,Sett_sales  = 0,    
	                marketrate = 0,Brokapplied = 0,NetRate = 0,Amount = 0,Ins_chrg = 0,  
	  turn_tax = 0,other_chrg = 0,sebi_tax = 0,Broker_chrg = 0,Service_tax = 0,  
	  Trade_amount = 0,NBrokApp = 0,NSerTax = 0,N_NetRate = 0   
	  Where Sett_No = @Sett_No  
	  And Sett_Type = @Sett_Type  
	  And Sauda_Date Like @Sauda_Date + '%'  
	  And Party_Code = @FromParty  
	  And Scrip_Cd = @Scrip_Cd  
	  And Series = @Series  
	  And Sell_Buy = @Sell_Buy  
	  And ContractNo = @OrgContractNo  
	  And PartipantCode = @PartipantCode  
	  And User_Id Like (Case When Len(@TerminalId) > 0 Then @TerminalId Else '%' End)  
	  And Branch_Id Like (Case When Len(@Branch_Id) > 0 Then @Branch_Id Else '%' End)  
	  And Order_No Like (Case When Len(@Order_No) > 0 Then @Order_No Else '%' End)  
	  And Trade_no Like (Case When Len(@Trade_No) > 0 Then @Trade_No Else '%' End)  
	  And TradeQty = @TradeQty  
	    
	  Select @TQty = @TQty - @TradeQty  
	 End  
	 Fetch Next From @SettCur Into @Trade_No, @Order_No, @TradeQty  
	End  
	Close @SettCur  
	DeAllocate @SettCur  
End
  
insert into details Values  (@Sauda_Date, @Sett_no, @sett_type, @ToParty, 'S')   
  
 insert into inst_log values    
 (    
  ltrim(rtrim(@FromParty)), /*party_code*/    
  ltrim(rtrim(@ToParty)), /*new_party_code*/    
  convert(datetime, ltrim(rtrim(@Sauda_Date))),  /*sauda_date*/    
  ltrim(rtrim('')),  /*sett_no*/    
  ltrim(rtrim(@sett_type)),  /*sett_type*/    
  ltrim(rtrim(@scrip_cd)), /*scrip_cd*/    
  ltrim(rtrim('NSE')), /*series*/    
  ltrim(rtrim(@order_no)),  /*order_no*/    
  ltrim(rtrim(@trade_no)),  /*trade_no*/    
  ltrim(rtrim(@sell_buy)), /*sell_buy*/    
  ltrim(rtrim(@OrgContractNo)), /*contract_no*/    
  ltrim(rtrim(@OrgContractNo)), /*new_contract_no*/    
  0,  /*brokerage*/    
  0,  /*new_brokerage*/    
  @MarketRate,  /*market_rate*/    
  @MarketRate,  /*new_market_rate*/    
  0,  /*net_rate*/    
  0,  /*new_net_rate*/    
  @TQty,  /*qty*/    
  @TQty,  /*new_qty*/    
  ltrim(rtrim(@PartipantCode)),  /*participant_code*/    
  ltrim(rtrim(@PartipantCode)),  /*new_participant_code*/    
  ltrim(rtrim(@StatusName)),  /*username*/    
  ltrim((@FromWhere)),  /*module*/    
  'NSE_AfterContCursor_Nrm', /*called_from*/    
  getdate(), /*timestamp*/    
  ltrim(rtrim('')), /*extrafield3*/    
  ltrim(rtrim('')), /*extrafield4*/    
  ltrim(rtrim(''))  /*extrafield5*/    
 )

GO
