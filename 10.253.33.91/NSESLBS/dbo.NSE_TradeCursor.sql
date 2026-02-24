-- Object: PROCEDURE dbo.NSE_TradeCursor
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE Proc NSE_TradeCursor
	@Sauda_Date Varchar(11),
	@FromParty Varchar(10),
	@ToParty Varchar(10),
	@Scrip_Cd Varchar(12),
	@Series Varchar(3),
	@Sell_Buy Int,
	@MarketRate Numeric(18,4),
	@PartiPantCode Varchar(15),
	@TerminalId varchar(10),
	@Branch_Id varchar(10),
	@Order_No varchar(16),
	@Trade_No varchar(14),
	@TQty Int,	
	@StatusName VarChar(50),
	@FromWhere VarChar(50),
	@INSTFLAG INT = 0

As
/*
T1|0A146|||0|20/04/2007|Trade||||Z02153|AshokS/Broker/127.0.0.1|/InsApp/innerTrdTrf.aspx

BEGIN TRAN
Select * From Trade WHere Party_Code = 'FID' And Sauda_Date Like 'Apr 20 2007%'
Select * From Trade WHere Party_Code = 'Z02153' And Sauda_Date Like 'Apr 20 2007%'
Exec NSE_TradeCursor '20/04/2007', 'FID', 'Z02153', '%', '%', 0, 0, '%', '%', '%', '%', '%', 0, 'ASHOKS/BROKER/127.0.0.1', '/INSAPP/INNERTRDTRF.ASPX', 0

EXEC NSE_TradeCursor 'Aug  4 2006', 'Z02153', 'UTIBK', 'SYNDIBANK', 'EQ', 2, 65.264, '%', '%', '%', '200608045040020', '%', 20000, 'AshokS/Broker/127.0.0.1', 'InsApp .NET Module(/InsApp/TranDetails.aspx)'
EXEC NSE_TradeCursor 'Aug  4 2006', 'Z02153', 'UTIBK', 'SYNDIBANK', 'EQ', 2, 65.264, '%', '%', '%', '200608045055589', '%', 10000, 'AshokS/Broker/127.0.0.1', 'InsApp .NET Module(/InsApp/TranDetails.aspx)'
ROLLBACK
*/
Declare
	@TradeQty Int,
	@XTrade_No Varchar(14),
	@TFlag Int,
	@SettCur Cursor

If Len(Ltrim(RTrim(@Sauda_Date))) = 10 AND charIndex('/', @Sauda_Date) > 0
	Begin
		Set @Sauda_Date = Convert(Varchar(11), Convert(DateTime, @Sauda_Date, 103), 109)
	End

If @TQty = 0 
Begin
	Update 	
		Trade
	Set Party_Code = @ToParty
	Where
		Sauda_Date Like @Sauda_Date + '%'
		And Party_Code = @FromParty
		And Scrip_Cd Like @Scrip_Cd
		And Series Like @Series
		And TradeQty > 0 	
End
Else
Begin
	Set @SettCur = Cursor For
	Select
		Trade_No,
		Order_No,
		TradeQty
	From
		Trade
	Where
		Sauda_Date Like @Sauda_Date + '%'
		And Party_Code = @FromParty
		And Scrip_Cd Like @Scrip_Cd
		And Series Like @Series
		And Sell_Buy Like Case @Sell_Buy When 0 Then '%' Else @Sell_Buy End
		And PartipantCode LIKE (CASE WHEN LEN(@PartipantCode) > 0 THEN @PartipantCode ELSE '%' END)
		And User_Id Like (Case When Len(@TerminalId) > 0 Then @TerminalId Else '%' End)
		And Branch_Id Like (Case When Len(@Branch_Id) > 0 Then @Branch_Id Else '%' End)
		And Order_No Like (Case When Len(@Order_No) > 0 Then @Order_No Else '%' End)
		And Trade_no Like (Case When Len(@Trade_No) > 0 Then @Trade_No Else '%' End)
		And TradeQty > 0 
	Open @SettCur
	Fetch Next From @SettCur Into @Trade_No, @Order_No, @TradeQty
	While @@Fetch_Status = 0 And @TQty > 0
		Begin
			Set @TFlag = 1
			Select @XTrade_No = 'A' + @Trade_No
			While @TFlag = 1
			Begin
				If (Select IsNull(Count(1),0) From Trade
					Where Sauda_Date Like @Sauda_Date + '%'
					And Scrip_Cd Like @Scrip_Cd
					And Series Like @Series
					And Sell_Buy Like Case @Sell_Buy When 0 Then '%' Else @Sell_Buy End
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
			If @TradeQty > @TQty
			Begin
				Insert into Trade
				Select
					@XTrade_No,
					Order_No,
					Status,
					Scrip_Cd,
					Series,
					Scripname,
					Instrument,
					Booktype,
					Markettype,
					User_Id,
					Partipantcode,
					Branch_Id,
					Sell_Buy,
					@TQty,
					Marketrate=(Case When @MarketRate = 0 Then MarketRate Else @MarketRate End),
					Pro_Cli,
					@ToParty,
					Auctionpart,
					Auctionno,
					Settno,
					Sauda_Date,
					Trademodified,
					Cpid,
					Settflag,
					Tmark,
					Scheme,
					Dummy1,
					Dummy2=@INSTFLAG
				From
					Trade
				Where
					Sauda_Date Like @Sauda_Date + '%'
					And Party_Code = @FromParty
					And Scrip_Cd Like @Scrip_Cd
					And Series Like @Series
					And Sell_Buy Like Case @Sell_Buy When 0 Then '%' Else @Sell_Buy End
					And PartipantCode LIKE (CASE WHEN LEN(@PartipantCode) > 0 THEN @PartipantCode ELSE '%' END)
					And User_Id Like (Case When Len(@TerminalId) > 0 Then @TerminalId Else '%' End)
					And Branch_Id Like (Case When Len(@Branch_Id) > 0 Then @Branch_Id Else '%' End)
					And Order_No Like (Case When Len(@Order_No) > 0 Then @Order_No Else '%' End)
					And Trade_no Like (Case When Len(@Trade_No) > 0 Then @Trade_No Else '%' End)
					And TradeQty = @TradeQty
			
					Update Trade
					Set TradeQty = @TradeQty - @TQty
					Where
						Sauda_Date Like @Sauda_Date + '%'
						And Party_Code = @FromParty
						And Scrip_Cd Like @Scrip_Cd
						And Series Like @Series
						And Sell_Buy Like Case @Sell_Buy When 0 Then '%' Else @Sell_Buy End
						And PartipantCode LIKE (CASE WHEN LEN(@PartipantCode) > 0 THEN @PartipantCode ELSE '%' END)
						And User_Id Like (Case When Len(@TerminalId) > 0 Then @TerminalId Else '%' End)
						And Branch_Id Like (Case When Len(@Branch_Id) > 0 Then @Branch_Id Else '%' End)
						And Order_No Like (Case When Len(@Order_No) > 0 Then @Order_No Else '%' End)
						And Trade_no Like (Case When Len(@Trade_No) > 0 Then @Trade_No Else '%' End)
						And TradeQty = @TradeQty
			
					SET @TQTY =  0
			END
			Else
			Begin
				Update Trade set Party_Code =  @ToParty, Marketrate=(Case When @MarketRate = 0 Then MarketRate Else @MarketRate End), DUMMY2 = @INSTFLAG
				Where
					Sauda_Date Like @Sauda_Date + '%'
					And Party_Code = @FromParty
					And Scrip_Cd Like @Scrip_Cd
					And Series Like @Series
					And Sell_Buy Like Case @Sell_Buy When 0 Then '%' Else @Sell_Buy End
					And PartipantCode LIKE (CASE WHEN LEN(@PartipantCode) > 0 THEN @PartipantCode ELSE '%' END)
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

insert into inst_log values
(
	ltrim(rtrim(@FromParty)), /*party_code*/
	ltrim(rtrim(@ToParty)), /*new_party_code*/
	convert(datetime, ltrim(rtrim(@Sauda_Date))),  /*sauda_date*/
	ltrim(rtrim('')),  /*sett_no*/
	ltrim(rtrim('')),  /*sett_type*/
	ltrim(rtrim(@scrip_cd)), /*scrip_cd*/
	ltrim(rtrim('NSE')), /*series*/
	ltrim(rtrim(@order_no)),  /*order_no*/
	ltrim(rtrim(@trade_no)),  /*trade_no*/
	ltrim(rtrim(@sell_buy)), /*sell_buy*/
	ltrim(rtrim('')), /*contract_no*/
	ltrim(rtrim('')), /*new_contract_no*/
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
	'NSE_TradeCursor', /*called_from*/
	getdate(), /*timestamp*/
	ltrim(rtrim('')), /*extrafield3*/
	ltrim(rtrim('')), /*extrafield4*/
	ltrim(rtrim(''))  /*extrafield5*/
)

SELECT RESULT = '0,NO ERROR'

GO
