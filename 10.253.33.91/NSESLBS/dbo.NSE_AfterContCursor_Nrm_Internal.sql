-- Object: PROCEDURE dbo.NSE_AfterContCursor_Nrm_Internal
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc NSE_AfterContCursor_Nrm_Internal
(
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

/*
Begin Tran
Exec NSE_AfterContCursor_Nrm_Internal '2006031', 'N', '16/02/2006', 'UTIBK', '0A146', '%', '%', 0, '0000014', 0, '%', '%', '%', '%', '%', 0, '', 'AshokS/Broker/127.0.0.1', '/InsApp/innerTrdTrf.aspx' 
RollBack
*/
Declare
	@billNo Varchar(10)

If Len(Ltrim(RTrim(@Sauda_Date))) = 10 AND charIndex('/', @Sauda_Date) > 0
	Begin
		Set @Sauda_Date = Convert(Varchar(11), Convert(DateTime, @Sauda_Date, 103), 109)
	End

	Exec NSE_AfterContCursor_Nrm 	@Sett_No, @Sett_Type, @Sauda_Date, @FromParty, @ToParty, @Scrip_Cd, @Series, @Sell_Buy,
							@OrgContractNo, @MarketRate, @PartiPantCode, @TerminalId, @Branch_Id, @Order_No,
							@Trade_No, @TQty, @NewContractNo, @StatusName, @FromWhere
	--ReArrange For Old
	Exec BSEReArrangeAfterContFlag	@Sett_Type, @FromParty, @Scrip_cd, @Series, @Sauda_Date, '%', @PartiPantCode,
							@StatusName, @FromWhere
	--Brokerage For Old
	Exec BBGSETTBROKRECAL	@Sett_no, @Sett_type, @FromParty, @Scrip_Cd, @series, @Sauda_date, @StatusName, @FromWhere

	--ReArrange For New
	Exec BSEReArrangeAfterContFlag	@Sett_Type, @ToParty, @Scrip_cd, @Series, @Sauda_Date, '%', @PartiPantCode,
							@StatusName, @FromWhere
	--Brokerage For New
	Exec BBGSETTBROKRECAL	@Sett_no, @Sett_type, @ToParty, @Scrip_Cd, @series, @Sauda_date, @StatusName, @FromWhere


	Select Top 1 @billNo = Max(BillNo) From Settlement Where Sett_No = @Sett_No And Sett_Type = @Sett_Type
	If Convert(Numeric(10), @billNo) > 0
		Begin
			--ReArrange After Bill For Old
			Exec BSERearrangeAfterBillFlag @Sett_No, @Sett_Type, @FromParty, @Scrip_cd, @Series, '%', @PartiPantCode, @StatusName, @FromWhere
			--ReArrange After Bill Brokerage For Old
			Exec NewUpdBillTaxReCal @Sett_No, @Sett_Type, @FromParty, @Scrip_cd, @Series, @Sauda_Date, @StatusName, @FromWhere
			--STT Calculation For Old
			Exec STT_CHARGES_FINAL @Sett_type, @Sauda_date, @FromParty, @FromParty

			--ReArrange After Bill For New
			Exec BSERearrangeAfterBillFlag @Sett_No, @Sett_Type, @ToParty, @Scrip_cd, @Series, '%', @PartiPantCode, @StatusName, @FromWhere
			--ReArrange After Bill Brokerage For New
			Exec NewUpdBillTaxReCal @Sett_No, @Sett_Type, @ToParty, @Scrip_cd, @Series, @Sauda_Date, @StatusName, @FromWhere
			--STT Calculation For New
			Exec STT_CHARGES_FINAL @Sett_type, @Sauda_date, @ToParty, @ToParty
		End
	Else
		Begin
			--STT Calculation For Old
			Exec STT_CHARGES_FINAL @Sett_type, @Sauda_date, @FromParty, @FromParty

			--STT Calculation For New
			Exec STT_CHARGES_FINAL @Sett_type, @Sauda_date, @ToParty, @ToParty
		End

GO
