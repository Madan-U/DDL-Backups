-- Object: PROCEDURE dbo.RecalcBrokerage_Ins_Internal
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------





Create procedure RecalcBrokerage_Ins_Internal
(
	@Sett_no Varchar(7),
	@Sett_type Varchar(2),
	@Party_Code varchar(10),
	@Scrip_Cd Varchar(12),
	@series Varchar(3),
	@Sauda_date Varchar(11),
	@StatusName VarChar(50)='BROKER',
	@FromWhere VarChar(50)='BROKER'
)

AS

If Len(LTrim(RTrim(@Sauda_date))) = 10 And charIndex('/', @Sauda_date) > 0
	Begin
		Set @Sauda_date = Convert(Varchar(11), Convert(DateTime, @Sauda_date, 103), 109)
	End

Declare
	@billNo As Varchar(10)

	Exec BBGINSSETTBROKRECAL @Sett_No, @Sett_Type, @Party_Code, @Scrip_Cd, @Series, @Sauda_Date, @StatusName, @FromWhere

	Select Top 1 @billNo = Max(BillNo) From ISettlement Where Sett_No = @Sett_No And Sett_Type = @Sett_Type
	If Convert(Numeric(10), @billNo) > 0
		Begin
			Exec NewUpdBillTaxReCalIns @Sett_No, @Sett_Type, @Party_Code, @Scrip_Cd, @Series, @Sauda_Date, @StatusName, @FromWhere
		End

GO
