-- Object: PROCEDURE dbo.sp_AddEditScrip_Execute
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

-- Alter this sp under SRE-34143
CREATE PROC [dbo].[sp_AddEditScrip_Execute]  
@strSQL VarChar(8000)  
AS 
SET NOCOUNT ON;
 --Print @strSQL  
 Exec (@strSQL)

GO
