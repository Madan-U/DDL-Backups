-- Object: PROCEDURE dbo.usp_Quarterly_FetchPNLStatement_Mimansa
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

-- =============================================
-- Author:		AngelBSECM Dhumal
-- Create date: Apr 2 2016
-- Description:	Sp to fetch PNL report data for quarterly statements

-- exec [usp_Quarterly_FetchPNLStatement_Mimansa] 'PNL','Apr 1 2016','Sep 30 2016'

-- =============================================
CREATE PROCEDURE [dbo].[usp_Quarterly_FetchPNLStatement_Mimansa]
	@flag varchar(50),
	@fromDate varchar(20),
	@toDate varchar(20)
AS
BEGIN
	
	SET NOCOUNT ON;

   IF (@flag = 'PNL')
	BEGIN
			Truncate table INHOUSE.dbo.tbl_Quarterly_PNLStatement_Mimansa

			Insert into INHOUSE.dbo.tbl_Quarterly_PNLStatement_Mimansa
			EXEC msajag.dbo.RPT_PNL_SHRT_LONG_ANG 'BROKER', 'BROKER', @fromDate, @toDate, 'A', 'ZZZZZZZZZZ', '', 'Y', 'S', 'W', ''
	END
END

GO
