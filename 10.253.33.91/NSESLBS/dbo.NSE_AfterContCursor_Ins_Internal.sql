-- Object: PROCEDURE dbo.NSE_AfterContCursor_Ins_Internal
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE  Proc NSE_AfterContCursor_Ins_Internal
(
	@Sett_No Varchar(7),
	@Sett_Type Varchar(2),
	@Sauda_Date Varchar(11),
	@FromParty Varchar(10),
	@ToParty Varchar(10),
	@Scrip_Cd Varchar(12),
	@Series Varchar(3),
	@Sell_Buy Int,
	@OrgContractNo Varchar(7),
	@MarketRate Numeric(18,4),
	@PartiPantCode Varchar(15),
	@TerminalId varchar(10),
	@Branch_Id varchar(10),
	@Order_No varchar(16),
	@Trade_No varchar(14),
	@TQty Int,
	@NewContractNo Varchar(7),
	@StatusName VarChar(50),
	@FromWhere VarChar(50)
)
As

/*  
*/  
	Declare
		@billNo Varchar(10)

	If Len(LTrim(RTrim(@Sauda_Date))) = 10 And charIndex('/', @Sauda_Date) > 0
		Begin
			Set @Sauda_Date = Convert(Varchar(11), Convert(DateTime, @Sauda_Date, 103), 109)
		End

	Exec NSE_AfterContCursor_Ins	@Sett_No, @Sett_Type, @Sauda_Date, @FromParty, @ToParty, @Scrip_Cd, @Series, @Sell_Buy, 
						@OrgContractNo, @MarketRate, @PartiPantCode, @TerminalId, @Branch_Id, @Order_No, @Trade_No,
						@TQty, @NewContractNo, @StatusName, @FromWhere
	Exec BBGINSSETTBROKRECAL @Sett_no, @Sett_type, @ToParty, @Scrip_Cd, @series, @Sauda_date, @StatusName, @FromWhere

	Select Top 1 @billNo = Max(BillNo) From ISettlement Where Sett_No = @Sett_No And Sett_Type = @Sett_Type
	If Convert(Numeric(10), @billNo) > 0
		Begin
			Exec NewUpdBillTaxReCalIns @Sett_No, @Sett_Type, @ToParty, @Scrip_Cd, @series, @Sauda_date, @StatusName, @FromWhere
		End

GO
