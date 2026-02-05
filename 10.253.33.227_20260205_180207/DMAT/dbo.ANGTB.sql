-- Object: VIEW dbo.ANGTB
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE VIEW ANGTB 
AS
SELECT * FROM [196.1.115.199].SYNERGY.DBO.ANG_TB
WHERE OPEN_BAL <>'0.00'

GO
