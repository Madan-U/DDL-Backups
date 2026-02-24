-- Object: PROCEDURE dbo.CLS_GET_BRANCHES
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------



CREATE PROC [dbo].[CLS_GET_BRANCHES]
AS
SELECT BRANCH_CODE, BRANCH FROM MSAJAG..BRANCH

GO
