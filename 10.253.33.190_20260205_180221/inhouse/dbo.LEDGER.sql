-- Object: VIEW dbo.LEDGER
-- Server: 10.253.33.190 | DB: inhouse
--------------------------------------------------

 CREATE VIEW [dbo].[LEDGER]                
AS                

SELECT DISTINCT * FROM SYNERGY_LEDGER WITH (NOLOCK)

GO
