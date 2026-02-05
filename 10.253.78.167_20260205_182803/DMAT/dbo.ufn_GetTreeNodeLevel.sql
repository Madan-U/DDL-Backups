-- Object: FUNCTION dbo.ufn_GetTreeNodeLevel
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE FUNCTION [dbo].[ufn_GetTreeNodeLevel] ( @pCurrentNode    INT )
RETURNS INT
AS
BEGIN

    DECLARE @vParentID            INT

    IF @pCurrentNode = 0 OR @pCurrentNode IS NULL
        RETURN 0

    SELECT @vParentID = [ParentID]
    FROM [dbo].[Hierarchy]
    WHERE [ID] = @pCurrentNode

    RETURN [dbo].[ufn_GetTreeNodeLevel] ( @vParentID ) + 1

END

GO
