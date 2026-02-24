-- Object: PROCEDURE dbo.TABLES
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE TABLES
(@NAME VARCHAR(40))
AS  
SELECT * FROM SYS.TABLES WHERE NAME LIKE '%' + @NAME + '%'

GO
