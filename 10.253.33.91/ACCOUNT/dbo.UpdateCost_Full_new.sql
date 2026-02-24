-- Object: PROCEDURE dbo.UpdateCost_Full_new
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

--exec UpdateCost_Full 
Create Proc UpdateCost_Full_new  
As  
Declare  
@@Branch_Code As Varchar(10),  
@@CostCode As Varchar(10),  
@@BrCnt As Int,  
@@BrCurs As Cursor  
  
Set @@BrCurs = Cursor For  
 select Distinct Branch_Code from msajag.Dbo.Branch where branch_code not in (select distinct costname from account.Dbo.Costmast)  
Open @@BrCurs  
Fetch Next From @@BrCurs Into @@Branch_Code  
While @@Fetch_Status = 0  
 Begin  
  Select @@CostCode = Convert(Varchar(10), IsNull(Max(CostCode)+1, 1)) From account.DBO.CostMast  
  Insert Into account.Dbo.CostMast Values (@@Branch_Code, @@CostCode, 1, '10000000000')  
  Fetch Next From @@BrCurs Into @@Branch_Code  
 End  
Close @@BrCurs  
Set @@BrCurs = Cursor For  
 select Distinct CostName from account.Dbo.CostMast where CostName not in (select distinct Branchname from account.Dbo.BranchAccounts)  
Open @@BrCurs  
Fetch Next From @@BrCurs Into @@Branch_Code  
 While @@Fetch_Status = 0  
  Begin  
   Insert Into account.Dbo.BranchAccounts Values (@@Branch_Code, @@Branch_Code, 'HOCTRL', 0)  
   Fetch Next From @@BrCurs Into @@Branch_Code  
  End  
Close @@BrCurs  
Insert Into account.Dbo.AcMast  
Select LTrim(RTrim(BranchName)) + ' Control A/c', LTrim(RTrim(BranchName)) + ' Control A/c',  
 'ASSET', '4', '', LTrim(RTrim(BrControlAc)), '', 'A0000000000', '', '0', LTrim(RTrim(BranchName)),  
 '0', 'C', '', '', ''  
From account.Dbo.BranchAccounts Where BrControlAc Not In (Select Distinct CltCode From account.Dbo.AcMast)

GO
