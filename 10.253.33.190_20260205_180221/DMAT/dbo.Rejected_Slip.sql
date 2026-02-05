-- Object: VIEW dbo.Rejected_Slip
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


CREATE VIEW  [dbo].[Rejected_Slip]

AS

SELECT '' AS SERIES,SLIP_NO,CLIENT_CODE AS BOID,SLIP_DATE AS REJECTION_DATE FROM [ABCSOORACLEMDLW].SYNERGY.DBO.Rejected_Slip WITH(nolock)

GO
