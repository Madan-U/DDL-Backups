-- Object: VIEW dbo.ANGTB
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


CREATE VIEW [dbo].[ANGTB] 
AS
SELECT * FROM [ABCSOORACLEMDLW].SYNERGY.DBO.ANG_TB
WHERE OPEN_BAL <>'0.00'

GO
