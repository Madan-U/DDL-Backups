-- Object: PROCEDURE dbo.RPT_CLIENT_COLL_ALLOC_CC
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROC [dbo].[RPT_CLIENT_COLL_ALLOC_CC]
(
	@RUNDATE	VARCHAR(11) 
)
AS

EXEC RPT_CLIENT_COLL_ALLOC @RUNDATE, 2

GO
