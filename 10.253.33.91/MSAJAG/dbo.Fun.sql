-- Object: PROCEDURE dbo.Fun
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROC Fun @fun VARCHAR(25)AS           
Select * from sysobjects where name Like '%' + @fun + '%' and xtype='FN' Order By Name

GO
