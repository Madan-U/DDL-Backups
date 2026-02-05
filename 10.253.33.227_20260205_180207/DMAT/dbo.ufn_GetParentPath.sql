-- Object: FUNCTION dbo.ufn_GetParentPath
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE FUNCTION [dbo].[ufn_GetParentPath] ( @pCurrentNodeID    INT )
RETURNS VARCHAR(1000)
AS
BEGIN

    DECLARE @vCurrentNodeName     VARCHAR(50)
    DECLARE @vParentID            INT

    IF @pCurrentNodeID IS NULL OR @pCurrentNodeID = 0
        RETURN NULL

    SELECT @vCurrentNodeName = [Name], @vParentID = [ParentID]
    FROM [dbo].[Hierarchy]
    WHERE [ID] = @pCurrentNodeID

    RETURN ISNULL([dbo].[ufn_GetParentPath] ( @vParentID ) + '/', '') + @vCurrentNodeName

END

GO
