-- Object: VIEW dbo.LEDGER
-- Server: 10.253.33.227 | DB: inhouse
--------------------------------------------------

 CREATE VIEW [dbo].[LEDGER]                
AS                

SELECT DISTINCT * FROM SYNERGY_LEDGER WITH (NOLOCK)

GO
