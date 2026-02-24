-- Object: PROCEDURE dbo.CLS_AGTS_COMMONDETAILS
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------





CREATE PROC [dbo].[CLS_AGTS_COMMONDETAILS]
		(
		@DETAIL_FLAG	VARCHAR(20)
		
		)
		
		AS
		  exec MSAJAG..CLS_AGTS_COMMONDETAILS  @DETAIL_FLAG

GO
