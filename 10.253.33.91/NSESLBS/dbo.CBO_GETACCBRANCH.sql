-- Object: PROCEDURE dbo.CBO_GETACCBRANCH
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

create PROCEDURE CBO_GETACCBRANCH
(
	@branchcode VARCHAR(80) = '',
  @branch VARCHAR(20)='',
	@STATUSID VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'
)
AS
	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
 begin
SELECT
	Branch_Code,
	branch,
	Address1,
	Address2,
	City,
	State,
	Nation,
	Zip,
	Phone1,
	Phone2,
	Fax,
	Email,
	Remote,
	Security_Net,
	Money_Net,
	Excise_Reg,
	Contact_Person,
	Prefix,
	RemPartyCode,
	MainControlAc = IsNull(A.MainControlAc, 'HOCTRL')
From
	Branch B
		Left Outer Join
			Account.DBO.BranchAccounts A
			On (B.Branch_Code = A.BranchName)
Where
	Branch_Code like
	 (
		Case 
			When Len(@branchcode) > 0 And @branchcode <> '%' 
				Then @branchcode+'%' 
			Else 
			'%' End)
		
			And Branch like (Case When Len(@branch) > 0 And @branch <> '%' Then @branch+'%' Else '%' End)
end

GO
