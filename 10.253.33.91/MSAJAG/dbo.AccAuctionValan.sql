-- Object: PROCEDURE dbo.AccAuctionValan
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------








/****** Object:  Stored Procedure dbo.AccAuctionValan    Script Date: 5/5/01 2:51:53 PM ******/
/****** Object:  Stored Procedure dbo.AccAuctionValan    Script Date: 3/21/01 12:49:58 PM ******/
/****** Object:  Stored Procedure dbo.AccAuctionValan    Script Date: 20-Mar-01 11:38:41 PM ******/
CREATE Proc AccAuctionValan(@Sett_No Varchar(7),@Sett_Type Varchar(2)) As
if (Select Distinct count(*) from Auction where ASett_No = @Sett_No and ASett_Type = @Sett_type and final = 0 ) > 0 
begin
	Delete From AccBill Where Sett_No = @Sett_No and Sett_Type = @Sett_type

	Insert Into AccBill
	select party_code,Bill_No,Sell_Buy=(Case When Sum(PAmt) > Sum(SAmt) Then 1 Else 2 End),
	sett_no,sett_type,Start_Date,End_date,Sec_Payin,Sec_Payout,
	Amount = Abs(Sum(PAmt)-Sum(SAmt)),Branch_Cd,'Valuation Auction'
	From AccValanAuction Where Sett_No = @Sett_No and Sett_Type = @Sett_type
	Group by sett_no,sett_type,party_code,Bill_No,Start_Date,End_date,Sec_Payin,Sec_Payout,Branch_Cd

	Insert Into AccBill
	select '99985','0',Sell_Buy = (Case When Sum(PRate) > Sum(SRate) Then 2 Else 1 End),
	sett_no,sett_type,Start_Date,End_date,Sec_Payin,Sec_Payout,
	Amount = Abs(Sum(PRate)-Sum(SRate)),Branch_Cd,'Valuation Auction'
	From AccValanAuction Where Sett_No = @Sett_No and Sett_Type = @Sett_type
	Group by sett_no,sett_type,Start_Date,End_date,Sec_Payin,Sec_Payout,Branch_Cd 

	Insert Into AccBill
	select '99985','0',Sell_Buy = (Case When Sum(PRate) > Sum(SRate) Then 2 Else 1 End),
	sett_no,sett_type,Start_Date,End_date,Sec_Payin,Sec_Payout,
	Amount = Abs(Sum(PRate)-Sum(SRate)),'ZZZ','Valuation Auction'
	From AccValanAuction Where Sett_No = @Sett_No and Sett_Type = @Sett_type
	Group by sett_no,sett_type,Start_Date,End_date,Sec_Payin,Sec_Payout 

end
ELSE
begin

	Delete From AccBill Where Sett_No = @Sett_No and Sett_Type = @Sett_type

	Insert Into AccBill
	select party_code,Bill_No,Sell_Buy=(Case When Sum(PAmt) > Sum(SAmt) Then 1 Else 2 End),
	sett_no,sett_type,Start_Date,End_date,Sec_Payin,Sec_Payout,
	Amount = Abs(Sum(PAmt)-Sum(SAmt)),Branch_Cd,'Valuation Auction'
	From AccValanAuction Where Sett_No = @Sett_No and Sett_Type = @Sett_type
	Group by sett_no,sett_type,party_code,Bill_No,Start_Date,End_date,Sec_Payin,Sec_Payout,Branch_Cd

	Insert Into AccBill
	select '99985','0',Sell_Buy = (Case When Sum(PRate) > Sum(SRate) Then 2 Else 1 End),
	sett_no,sett_type,Start_Date,End_date,Sec_Payin,Sec_Payout,
	Amount = Abs(Sum(PRate)-Sum(SRate)),Branch_Cd,'Valuation Auction'
	From AccValanAuction Where Sett_No = @Sett_No and Sett_Type = @Sett_type
	Group by sett_no,sett_type,Start_Date,End_date,Sec_Payin,Sec_Payout,Branch_Cd 

	Insert Into AccBill
	select '99985','0',Sell_Buy = (Case When Sum(PRate) > Sum(SRate) Then 2 Else 1 End),
	sett_no,sett_type,Start_Date,End_date,Sec_Payin,Sec_Payout,
	Amount = Abs(Sum(PRate)-Sum(SRate)),'ZZZ','Valuation Auction'
	From AccValanAuction Where Sett_No = @Sett_No and Sett_Type = @Sett_type
	Group by sett_no,sett_type,Start_Date,End_date,Sec_Payin,Sec_Payout

	Insert Into AccBill
	select party_code,Bill_No,Sell_Buy=(Case When Sum(PAmt) < Sum(SAmt) Then 1 Else 2 End),
	sett_no,sett_type,Start_Date,End_date,Sec_Payin,Sec_Payout,
	Amount = Abs(Sum(PAmt)-Sum(SAmt)),Branch_Cd,'Reversed Valuation Auction'
	From AccValanAuction Where Sett_No = @Sett_No and Sett_Type = @Sett_type
	Group by sett_no,sett_type,party_code,Bill_No,Start_Date,End_date,Sec_Payin,Sec_Payout,Branch_Cd

	Insert Into AccBill
	select '99985','0',Sell_Buy = (Case When Sum(PRate) < Sum(SRate) Then 2 Else 1 End),
	sett_no,sett_type,Start_Date,End_date,Sec_Payin,Sec_Payout,
	Amount = Abs(Sum(PRate)-Sum(SRate)),Branch_Cd,'Reversed Valuation Auction'
	From AccValanAuction Where Sett_No = @Sett_No and Sett_Type = @Sett_type
	Group by sett_no,sett_type,Start_Date,End_date,Sec_Payin,Sec_Payout,Branch_Cd 

	Insert Into AccBill
	select '99985','0',Sell_Buy = (Case When Sum(PRate) < Sum(SRate) Then 2 Else 1 End),
	sett_no,sett_type,Start_Date,End_date,Sec_Payin,Sec_Payout,
	Amount = Abs(Sum(PRate)-Sum(SRate)),'ZZZ','Reversed Valuation Auction'
	From AccValanAuction Where Sett_No = @Sett_No and Sett_Type = @Sett_type
	Group by sett_no,sett_type,Start_Date,End_date,Sec_Payin,Sec_Payout

	Insert Into AccBill
	select party_code,Bill_No,Sell_Buy=(Case When Sum(PAmt) > Sum(SAmt) Then 1 Else 2 End),
	sett_no,sett_type,Start_Date,End_date,Sec_Payin,Sec_Payout,
	Amount = Abs(Sum(PAmt)-Sum(SAmt)),Branch_Cd,'Final Auction'
	From AccValanAuctionFin Where Sett_No = @Sett_No and Sett_Type = @Sett_type
	Group by sett_no,sett_type,party_code,Bill_No,Start_Date,End_date,Sec_Payin,Sec_Payout,Branch_Cd

	Insert Into AccBill
	select '99985','0',Sell_Buy = (Case When Sum(PRate) > Sum(SRate) Then 2 Else 1 End),
	sett_no,sett_type,Start_Date,End_date,Sec_Payin,Sec_Payout,
	Amount = Abs(Sum(PRate)-Sum(SRate)),Branch_Cd,'Final Auction'
	From AccValanAuctionFin Where Sett_No = @Sett_No and Sett_Type = @Sett_type
	Group by sett_no,sett_type,Start_Date,End_date,Sec_Payin,Sec_Payout,Branch_Cd 

	Insert Into AccBill
	select '99975','0',Sell_Buy = 2,Sett_no,sett_type,Start_Date,End_date,Sec_Payin,Sec_Payout,
	Amount = Sum(APer),Branch_Cd,'Final Auction'
	From AccValanAuctionFin Where Sett_No = @Sett_No and Sett_Type = @Sett_type
	Group by sett_no,sett_type,Start_Date,End_date,Sec_Payin,Sec_Payout,Branch_Cd

	Insert Into AccBill
	select '99985','0',Sell_Buy = (Case When Sum(PRate) > Sum(SRate) Then 2 Else 1 End),
	sett_no,sett_type,Start_Date,End_date,Sec_Payin,Sec_Payout,
	Amount = Abs(Sum(PRate)-Sum(SRate)),'ZZZ','Final Auction'
	From AccValanAuctionFin Where Sett_No = @Sett_No and Sett_Type = @Sett_type
	Group by sett_no,sett_type,Start_Date,End_date,Sec_Payin,Sec_Payout

	Insert Into AccBill
	select '99975','0',Sell_Buy = 2,Sett_no,sett_type,Start_Date,End_date,Sec_Payin,Sec_Payout,
	Amount = Sum(APer),'ZZZ','Final Auction'
	From AccValanAuctionFin Where Sett_No = @Sett_No and Sett_Type = @Sett_type
	Group by sett_no,sett_type,Start_Date,End_date,Sec_Payin,Sec_Payout

END

GO
