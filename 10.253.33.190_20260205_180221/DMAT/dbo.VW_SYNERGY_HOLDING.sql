-- Object: VIEW dbo.VW_SYNERGY_HOLDING
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------





CREATE VIEW VW_SYNERGY_HOLDING 

AS 

SELECT * FROM synergy_holding WITH(NOLOCK)  WHERE HLD_HOLD_DATE >='2015-09-01'

UNION ALL  

SELECT * FROM [172.31.16.30].SYNERGY.DBO.synergy_holding WITH(NOLOCK) WHERE HLD_HOLD_DATE <'2015-09-01'

GO
