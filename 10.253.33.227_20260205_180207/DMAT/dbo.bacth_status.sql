-- Object: PROCEDURE dbo.bacth_status
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE PROC bacth_status (@APP_NO VARCHAR(20))
AS
SELECT DPAM_ACCT_NO as Application_No,DPAM_BATCH_NO as Batch_No FROM citrus_usr.DP_ACCT_MSTR WITH(NOLOCK) WHERE DPAM_ACCT_NO = @APP_NO

GO
