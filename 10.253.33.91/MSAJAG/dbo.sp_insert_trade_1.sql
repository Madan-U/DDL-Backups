-- Object: PROCEDURE dbo.sp_insert_trade_1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sp_insert_trade_1    Script Date: 3/17/01 9:56:11 PM ******/

/****** Object:  Stored Procedure dbo.sp_insert_trade_1    Script Date: 3/21/01 12:50:31 PM ******/

/****** Object:  Stored Procedure dbo.sp_insert_trade_1    Script Date: 20-Mar-01 11:39:09 PM ******/

CREATE PROCEDURE [sp_insert_trade_1]
	(@Trade_No_1 	[char](12),
	 @Order_No_2 	[char](15),
	 @Status_3 	[varchar](2),
	 @Scrip_Cd_4 	[varchar](10),
	 @series_5 	[varchar](2),
	 @ScripName_6 	[char](25),
	 @Instrument_7 	[varchar](2),
	 @BookType_8 	[varchar](2),
	 @MarketType_9 	[varchar](2),
	 @User_Id_10 	[int],
	 @PartipantCode_11 	[char](15),
	 @Branch_Id_12 	[varchar](2),
	 @Sell_Buy_13 	[int],
	 @TradeQty_14 	[int],
	 @MarketRate_15 	[money],
	 @Pro_Cli_16 	[int],
	 @Party_Code_17 	[char](10),
	 @AuctionPart_18 	[varchar](2),
	 @AuctionNo_19 	[int],
	 @SettNo_20 	[int],
	 @Sauda_Date_21 	[smalldatetime],
	 @TradeModified_22 	[smalldatetime],
	 @CpId_23 	[char](3),
	 @settflag_24 	[int],
	 @Dummy1_25 	[money],
	 @Dummy2_26 	[money])

AS INSERT INTO [MSAJAG].[dbo].[trade] 
	 ( [Trade_No],
	 [Order_No],
	 [Status],
	 [Scrip_Cd],
	 [series],
	 [ScripName],
	 [Instrument],
	 [BookType],
	 [MarketType],
	 [User_Id],
	 [PartipantCode],
	 [Branch_Id],
	 [Sell_Buy],
	 [TradeQty],
	 [MarketRate],
	 [Pro_Cli],
	 [Party_Code],
	 [AuctionPart],
	 [AuctionNo],
	 [SettNo],
	 [Sauda_Date],
	 [TradeModified],
	 [CpId],
	 [settflag],
	 [Dummy1],
	 [Dummy2]) 
 
VALUES 
	( @Trade_No_1,
	 @Order_No_2,
	 @Status_3,
	 @Scrip_Cd_4,
	 @series_5,
	 @ScripName_6,
	 @Instrument_7,
	 @BookType_8,
	 @MarketType_9,
	 @User_Id_10,
	 @PartipantCode_11,
	 @Branch_Id_12,
	 @Sell_Buy_13,
	 @TradeQty_14,
	 @MarketRate_15,
	 @Pro_Cli_16,
	 @Party_Code_17,
	 @AuctionPart_18,
	 @AuctionNo_19,
	 @SettNo_20,
	 @Sauda_Date_21,
	 @TradeModified_22,
	 @CpId_23,
	 @settflag_24,
	 @Dummy1_25,
	 @Dummy2_26)

GO
