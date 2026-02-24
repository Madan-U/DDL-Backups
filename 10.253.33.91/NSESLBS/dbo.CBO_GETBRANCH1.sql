-- Object: PROCEDURE dbo.CBO_GETBRANCH1
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE  PROCEDURE CBO_GETBRANCH1
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
	Select
		*
	From
		 BRANCH
	Where
		BRANCH_CODE = (Case When Len(@branchcode) > 0 And @branchcode <> '%' Then @branchcode Else BRANCH_CODE End)

GO
