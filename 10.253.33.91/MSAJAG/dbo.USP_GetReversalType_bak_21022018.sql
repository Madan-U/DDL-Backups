-- Object: PROCEDURE dbo.USP_GetReversalType_bak_21022018
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE  PROC USP_GetReversalType_bak_21022018
@ParamID  INT = ''
AS
BEGIN

	SELECT ReversalType  
	FROM TBL_GST_Reversal_Type
	WHERE paramID = @ParamID 
			AND IsActive = 1
	ORDER BY 1


END

GO
