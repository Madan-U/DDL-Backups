-- Object: PROCEDURE dbo.sp_update_trade_1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sp_update_trade_1    Script Date: 3/17/01 9:56:11 PM ******/

/****** Object:  Stored Procedure dbo.sp_update_trade_1    Script Date: 3/21/01 12:50:31 PM ******/

/****** Object:  Stored Procedure dbo.sp_update_trade_1    Script Date: 20-Mar-01 11:39:09 PM ******/

CREATE PROCEDURE [sp_update_trade_1]
	(@Trade_No_1 	[char],
	 @Order_No_2 	[char],
	 @Status_3 	[varchar],
	 @Scrip_Cd_4 	[varchar],
	 @series_5 	[varchar],
	 @ScripName_6 	[char],
	 @Instrument_7 	[varchar],
	 @BookType_8 	[varchar],
	 @MarketType_9 	[varchar],
	 @User_Id_10 	[int],
	 @PartipantCode_11 	[char],
	 @Branch_Id_12 	[varchar],
	 @Sell_Buy_13 	[int],
	 @TradeQty_14 	[int],
	 @MarketRate_15 	[money],
	 @Pro_Cli_16 	[int],
	 @Party_Code_17 	[char],
	 @AuctionPart_18 	[varchar],
	 @AuctionNo_19 	[int],
	 @SettNo_20 	[int],
	 @Sauda_Date_21 	[smalldatetime],
	 @TradeModified_22 	[smalldatetime],
	 @CpId_23 	[char],
	 @settflag_24 	[int],
	 @Dummy1_25 	[money],
	 @Dummy2_26 	[money],
	 @Trade_No_27 	[char](12),
	 @Order_No_28 	[char](15),
	 @Status_29 	[varchar](2),
	 @Scrip_Cd_30 	[varchar](10),
	 @series_31 	[varchar](2),
	 @ScripName_32 	[char](25),
	 @Instrument_33 	[varchar](2),
	 @BookType_34 	[varchar](2),
	 @MarketType_35 	[varchar](2),
	 @User_Id_36 	[int],
	 @PartipantCode_37 	[char](15),
	 @Branch_Id_38 	[varchar](2),
	 @Sell_Buy_39 	[int],
	 @TradeQty_40 	[int],
	 @MarketRate_41 	[money],
	 @Pro_Cli_42 	[int],
	 @Party_Code_43 	[char](10),
	 @AuctionPart_44 	[varchar](2),
	 @AuctionNo_45 	[int],
	 @SettNo_46 	[int],
	 @Sauda_Date_47 	[smalldatetime],
	 @TradeModified_48 	[smalldatetime],
	 @CpId_49 	[char](3),
	 @settflag_50 	[int],
	 @Dummy1_51 	[money],
	 @Dummy2_52 	[money])

AS UPDATE [MSAJAG].[dbo].[trade] 

SET  [Trade_No]	 = @Trade_No_27,
	 [Order_No]	 = @Order_No_28,
	 [Status]	 = @Status_29,
	 [Scrip_Cd]	 = @Scrip_Cd_30,
	 [series]	 = @series_31,
	 [ScripName]	 = @ScripName_32,
	 [Instrument]	 = @Instrument_33,
	 [BookType]	 = @BookType_34,
	 [MarketType]	 = @MarketType_35,
	 [User_Id]	 = @User_Id_36,
	 [PartipantCode]	 = @PartipantCode_37,
	 [Branch_Id]	 = @Branch_Id_38,
	 [Sell_Buy]	 = @Sell_Buy_39,
	 [TradeQty]	 = @TradeQty_40,
	 [MarketRate]	 = @MarketRate_41,
	 [Pro_Cli]	 = @Pro_Cli_42,
	 [Party_Code]	 = @Party_Code_43,
	 [AuctionPart]	 = @AuctionPart_44,
	 [AuctionNo]	 = @AuctionNo_45,
	 [SettNo]	 = @SettNo_46,
	 [Sauda_Date]	 = @Sauda_Date_47,
	 [TradeModified]	 = @TradeModified_48,
	 [CpId]	 = @CpId_49,
	 [settflag]	 = @settflag_50,
	 [Dummy1]	 = @Dummy1_51,
	 [Dummy2]	 = @Dummy2_52 

WHERE 
	( [Trade_No]	 = @Trade_No_1 AND
	 [Order_No]	 = @Order_No_2 AND
	 [Status]	 = @Status_3 AND
	 [Scrip_Cd]	 = @Scrip_Cd_4 AND
	 [series]	 = @series_5 AND
	 [ScripName]	 = @ScripName_6 AND
	 [Instrument]	 = @Instrument_7 AND
	 [BookType]	 = @BookType_8 AND
	 [MarketType]	 = @MarketType_9 AND
	 [User_Id]	 = @User_Id_10 AND
	 [PartipantCode]	 = @PartipantCode_11 AND
	 [Branch_Id]	 = @Branch_Id_12 AND
	 [Sell_Buy]	 = @Sell_Buy_13 AND
	 [TradeQty]	 = @TradeQty_14 AND
	 [MarketRate]	 = @MarketRate_15 AND
	 [Pro_Cli]	 = @Pro_Cli_16 AND
	 [Party_Code]	 = @Party_Code_17 AND
	 [AuctionPart]	 = @AuctionPart_18 AND
	 [AuctionNo]	 = @AuctionNo_19 AND
	 [SettNo]	 = @SettNo_20 AND
	 [Sauda_Date]	 = @Sauda_Date_21 AND
	 [TradeModified]	 = @TradeModified_22 AND
	 [CpId]	 = @CpId_23 AND
	 [settflag]	 = @settflag_24 AND
	 [Dummy1]	 = @Dummy1_25 AND
	 [Dummy2]	 = @Dummy2_26)

GO
