-- Object: PROCEDURE dbo.RPT_COMB_REPORT_CSV
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE PROC [dbo].[RPT_COMB_REPORT_CSV]
(
                @MARGINDATE    VARCHAR(11)
)
  AS

EXEC [SP_COMBINE_REPORTING] 'BROKER', 'BROKER', @MARGINDATE,@MARGINDATE, 'K48446', 'K48446', '', '', 1

GO
