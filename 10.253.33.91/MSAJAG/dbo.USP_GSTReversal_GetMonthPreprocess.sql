-- Object: PROCEDURE dbo.USP_GSTReversal_GetMonthPreprocess
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




CREATE proc [dbo].[USP_GSTReversal_GetMonthPreprocess]
AS
begin

SELECT '--Select--'  as inv_date 
UNION ALL
SELECT distinct inv_date
FROM GSTReversal_Preprocess
WHERE [status] = 'P'
		AND IsThirDParty = 'N'

end

GO
