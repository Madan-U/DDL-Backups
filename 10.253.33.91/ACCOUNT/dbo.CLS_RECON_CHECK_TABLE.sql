-- Object: PROCEDURE dbo.CLS_RECON_CHECK_TABLE
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------



CREATE PROCEDURE [dbo].[CLS_RECON_CHECK_TABLE] (
@SQLQUERY NVARCHAR(3000) ) 
AS
BEGIN

EXEC(@SQLQUERY)

END

GO
