-- Object: VIEW dbo.ANG_Lost_slip
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


CREATE VIEW  [dbo].[ANG_Lost_slip]   
  
AS  
  
SELECT '' SERIES,SLIP_NO,CONVERT(VARCHAR(16),1203320000000000+BENEF_ACCNO) AS BOID,LOST_DATE  FROM [ABCSOORACLEMDLW].SYNERGY.DBO.Lost_slip WITH(nolock)

GO
