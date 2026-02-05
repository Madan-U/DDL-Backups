-- Object: PROCEDURE citrus_usr.DP_DETAILS
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


CREATE PROC DP_DETAILS
(
@DPM_DPID VARCHAR(20)

)
AS BEGIN   
SELECT DPM_DPID,DPM_NAME FROM DP_MSTR WHERE DPM_DPID=@DPM_DPID


END

GO
