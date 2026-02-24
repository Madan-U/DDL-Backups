-- Object: PROCEDURE dbo.ANGEL_UPDATE_TBL_SEARCH
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC ANGEL_UPDATE_TBL_SEARCH    
AS    
BEGIN   
      UPDATE INTRANET.MISC.DBO.TBL_SEARCH SET DUMMY1 = 'N' WHERE id in (98,94,97,95,96)   
END

GO
