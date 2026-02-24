-- Object: PROCEDURE dbo.usp_RPT_PNL_SHRT_LONG_ANG_Mimansa
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>

-- Exec [dbo].[usp_RPT_PNL_SHRT_LONG_ANG_Mimansa] 'Jan 21 2020'

-- =============================================
CREATE PROCEDURE [dbo].[usp_RPT_PNL_SHRT_LONG_ANG_Mimansa]
	@Sauda_Date datetime
AS
BEGIN

	SET NOCOUNT ON;

    Truncate table INHOUSE.dbo.tbl_FDRisk_PNLStmtM2M

	Insert into INHOUSE.dbo.tbl_FDRisk_PNLStmtM2M
	--EXEC msajag.dbo.RPT_PNL_SHRT_LONG_ANG 'BROKER','BROKER',@Sauda_Date,@Sauda_Date,'A','ZZZZZZZ','','Y', 'S','W',''
	EXEC msajag.dbo.RPT_PNL_SHRT_LONG_ANG_UAT_Optimisation 'BROKER','BROKER',@Sauda_Date,@Sauda_Date,'A','ZZZZZZZ','','Y', 'S','W',''




END

GO
