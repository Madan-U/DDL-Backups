-- Object: PROCEDURE dbo.rpt_CostMaster
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE  Procedure rpt_CostMaster as

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Select 
	branchname,
	brcontrolac,
	maincontrolac,
	Costname ,
	grpcode
From
	CostMast (nolock),
	BranchAccounts (nolock)
Where 
	CostName=BranchName 
Order by 
	branchname,costname

GO
