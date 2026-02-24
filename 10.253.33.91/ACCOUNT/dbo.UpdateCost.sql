-- Object: PROCEDURE dbo.UpdateCost
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE Proc UpdateCost
As
Declare
@@Branch_Code As Varchar(10),
@@CostCode As Varchar(10),
@@BrCnt As Int,
@@BrCurs As Cursor

Set @@BrCurs = Cursor For
	select Distinct Branch_Code from msajag.dbo.branch where branch_code not in (select distinct costname from Account.Dbo.costmast)
Open @@BrCurs
Fetch Next From @@BrCurs Into @@Branch_Code
While @@Fetch_Status = 0
	Begin
		Select @@CostCode = Convert(Varchar(10), IsNull(Max(CostCode)+1, 1)) From Account.Dbo.CostMast
--		Begin Transaction
		Insert Into Account.Dbo.CostMast Values (@@Branch_Code, @@CostCode, 1, '10000000000')
		Select @@BrCnt = IsNull(Count(*),0) From Account.Dbo.BranchAccounts Where BranchName = @@Branch_Code
		If @@BrCnt = 0
			Begin
				Insert Into Account.Dbo.BranchAccounts Values (@@Branch_Code, @@Branch_Code, 'HOCTRL', 0)
			End
--		Commit Transaction
		Fetch Next From @@BrCurs Into @@Branch_Code
	End
select Branch_Code from msajag.dbo.branch where branch_code not in (select distinct costname from Account.Dbo.costmast)
/*
Set @@BrCurs = Cursor For
	select Distinct Branch_Code from msajag.dbo.branch where branch_code not in (select distinct costname from AccountBse.Dbo.costmast)
Open @@BrCurs
Fetch Next From @@BrCurs Into @@Branch_Code
While @@Fetch_Status = 0
	Begin
		Select @@CostCode = Convert(Varchar(10), IsNull(Max(CostCode)+1, 1)) From AccountBse.Dbo.CostMast
--		Begin Transaction
		Insert Into AccountBse.Dbo.CostMast Values (@@Branch_Code, @@CostCode, 1, '10000000000')
		Select @@BrCnt = IsNull(Count(*),0) From AccountBse.Dbo.BranchAccounts Where BranchName = @@Branch_Code
		If @@BrCnt = 0
			Begin
				Insert Into AccountBse.Dbo.BranchAccounts Values (@@Branch_Code, @@Branch_Code, 'HOCTRL', 0)
			End
--		Commit Transaction
		Fetch Next From @@BrCurs Into @@Branch_Code
	End
select Branch_Code from msajag.dbo.branch where branch_code not in (select distinct costname from AccountBse.Dbo.costmast)

Set @@BrCurs = Cursor For
	select Distinct Branch_Code from msajag.dbo.branch where branch_code not in (select distinct costname from AccountFo.Dbo.costmast)
Open @@BrCurs
Fetch Next From @@BrCurs Into @@Branch_Code
While @@Fetch_Status = 0
	Begin
		Select @@CostCode = Convert(Varchar(10), IsNull(Max(CostCode)+1, 1)) From AccountFo.Dbo.CostMast
--		Begin Transaction
		Insert Into AccountFo.Dbo.CostMast Values (@@Branch_Code, @@CostCode, 1, '10000000000')
		Select @@BrCnt = IsNull(Count(*),0) From AccountFo.Dbo.BranchAccounts Where BranchName = @@Branch_Code
		If @@BrCnt = 0
			Begin
				Insert Into AccountFo.Dbo.BranchAccounts Values (@@Branch_Code, @@Branch_Code, 'HOCTRL', 0)
			End
--		Commit Transaction
		Fetch Next From @@BrCurs Into @@Branch_Code
	End
select Branch_Code from msajag.dbo.branch where branch_code not in (select distinct costname from AccountFo.Dbo.costmast)*/

GO
