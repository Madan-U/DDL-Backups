-- Object: PROCEDURE citrus_usr.UPDATE_Synergy_CM_FROM_TBL_CM
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROC [citrus_usr].[UPDATE_Synergy_CM_FROM_TBL_CM]
	AS
	
	UPDATE Synergy_Client_Master set CM_EMAIL = EMAIL_ADD 
	FROM
	TBL_CLIENT_MASTER , inhouse.dbo.Synergy_Client_Master 
	WHERE  CLIENT_CODE= cm_cd

GO
