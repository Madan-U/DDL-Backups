-- Object: PROCEDURE dbo.sp_AddEditScrip_Execute_bkp11022025
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROC [dbo].[sp_AddEditScrip_Execute_bkp11022025]  
@strSQL VarChar(8000)  
AS  
 --Print @strSQL  
 Exec (@strSQL)

GO
