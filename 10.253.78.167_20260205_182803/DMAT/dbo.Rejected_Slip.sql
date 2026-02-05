-- Object: VIEW dbo.Rejected_Slip
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE VIEW  Rejected_Slip

AS

SELECT '' AS SERIES,SLIP_NO,CLIENT_CODE AS BOID,SLIP_DATE AS REJECTION_DATE FROM [196.1.115.199].SYNERGY.DBO.Rejected_Slip WITH(nolock)

GO
