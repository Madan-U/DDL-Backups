-- Object: PROCEDURE dbo.sp_DetailHelp
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE proc sp_DetailHelp
(
	@FromAmount int,
	@ToAmount int,
	@BranchCd char(10),
	@ToDate varchar(25),
	@DayDiff int,
	@DrCr char(1)
)
as
Declare @@FromDate AS varchar(25)
Declare @@Date_Diff As varchar(25)
Declare @@Sell_Buy As char(1)

set @ToDate = @ToDate + ' 23:59:59'
set @@Date_Diff = left(convert(varchar, dateadd(dd, -@DayDiff, convert(datetime,@ToDate)), 109), 11) + ' 00:00:00'
Set @@FromDate = 'APR  1 '

If DatePart(Month,getDate())<= 3
	Set @@FromDate = @@FromDate + Cast((DatePart(Year,GetDate())-1) as varchar)
Else
	Set @@FromDate = @@FromDate + Cast(DatePart(Year,GetDate()) as varchar)

Set @@FromDate = @@FromDate + ' 00:00:00 '

--print '@@FromDate: ' + @@FromDate
--print '@ToDate: ' + @ToDate
--print '@@Date_Diff: ' + @@Date_Diff

if(@DrCr = 'C')
	Begin
		set @@Sell_Buy = '1'
	End
if(@DrCr = 'D')
	Begin
		set @@Sell_Buy = '2'
	End

	Select Party_Code,Sett_no,Sett_type,Amount,BranchCd,LedgerAmount,DebitCredit = (Case When LedgerAmount < 0 Then 'Credit' Else 'Debit' End) 
	from 
	( 
		Select Cltcode,ledgeramount = IsNull(sum(case when Led.drcr = 'd' then Led.vamt else Led.vamt*-1 end),0)
	     From Anand1.account.dbo.ledger led 
	     Where 
	     Led.CltCode In ( 
			  Select Party_Code From anand1.msajag.dbo.accbill where amount between @FromAmount and @ToAmount and branchcd = @BranchCd
		     and start_date <= @ToDate
			  and start_date >= @@Date_Diff and sell_buy = @@Sell_Buy
        )

	     And Led.Vdt >= @@FromDate
	     And Led.vdt <=  @ToDate
	     Group By CltCode 
	) B,
     
     (
		Select Party_Code,Sett_no,Sett_type,Amount,BranchCd from anand1.msajag.dbo.accbill where amount between @FromAmount and @ToAmount and branchcd = @BranchCd
	     and start_date <= @ToDate and start_date >= @@Date_Diff and sell_buy = @@Sell_Buy 
	) A
     Where
     A.Party_code = B.Cltcode
     Order By DebitCredit desc,Amount,LedgerAmount desc,Party_code

--exec sp_DetailHelp 1000,2000, 'HO','Sep 12 2005', 7,'C'

GO
