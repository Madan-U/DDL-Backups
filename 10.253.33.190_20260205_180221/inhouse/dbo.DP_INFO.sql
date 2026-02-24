-- Object: PROCEDURE dbo.DP_INFO
-- Server: 10.253.33.190 | DB: inhouse
--------------------------------------------------



CREATE  PROC DP_INFO 
AS 
SELECT [cm_blsavingcd]  
      ,[CM_CD]  
      ,[CM_ACTIVE]  
FROM  dmat.citrus_usr.Synergy_Client_Master with (nolock)
WHERE [cm_blsavingcd] IS NOT NULL
order by cm_blsavingcd



 SELECT CONVERT(VARCHAR(11),GETDATE(),120) AS PROCESS_DATE

GO
