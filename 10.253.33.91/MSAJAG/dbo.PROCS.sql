-- Object: PROCEDURE dbo.PROCS
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE PROCS 
(@NAME VARCHAR(40))
AS  
SELECT * FROM SYS.PROCEDURES WHERE NAME LIKE '%' + @NAME + '%'

GO
