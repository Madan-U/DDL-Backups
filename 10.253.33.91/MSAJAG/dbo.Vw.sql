-- Object: PROCEDURE dbo.Vw
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROC Vw @VwName VARCHAR(25)AS                 
Select * from sysobjects where name Like '%' + @VwName + '%' and xtype='V' Order By Name

GO
