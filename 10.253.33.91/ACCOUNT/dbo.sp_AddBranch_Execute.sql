-- Object: PROCEDURE dbo.sp_AddBranch_Execute
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROC sp_AddBranch_Execute
@strSQL VarChar(8000)
AS
	Print @strSQL
	Exec (@strSQL)

GO
