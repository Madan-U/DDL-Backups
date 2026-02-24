-- Object: PROCEDURE dbo.RPT_DELSALE
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


    
CREATE PROC [DBO].[RPT_DELSALE]             
(@PROCESS_DATE VARCHAR(11))            
AS            

SELECT * FROM TBL_RMS_SALE                  
WHERE PROCESS_DATE LIKE @PROCESS_DATE + '%'      
ORDER BY PARTY_CODE, START_DATE,             
CL_RATE, SCRIP_CD, SERIES

GO
