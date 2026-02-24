-- Object: PROCEDURE dbo.sp_AddClient_Execute
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.sp_AddClient_Execute    Script Date: May 12 2003 11:20:53 ******/
CREATE  PROC sp_AddClient_Execute
@strSQL VarChar(8000)
AS
	Print @strSQL
	Exec (@strSQL)

GO
