-- Object: PROCEDURE dbo.USP_GetNRIBankMaster
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

-- =============================================
-- Author:		Sunita More
-- Create date: 2024-02-01
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE USP_GetNRIBankMaster
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  Fld_Srno,Fld_BankName=Fld_BankName +' ['+ CAST(Fld_Srno AS VARCHAR) +']' 
	FROM intranet.risk.dbo.tbl_NRIBankMaster WITH (NOLOCK) ORDER BY Fld_BankName
END

GO
