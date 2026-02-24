-- Object: PROCEDURE dbo.RMSALLSEG_SelectSaudaDT
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC RMSALLSEG_SelectSaudaDT AS

SELECT DISTINCT LEFT(CONVERT(VARCHAR,sysdate,109),11) as sysdate FROM msajag.dbo.[closing] 
union
SELECT DISTINCT LEFT(CONVERT(VARCHAR,sysdate,109),11) as sysdate FROM bsedb.dbo.[closing] 
ORDER BY sysdate

GO
