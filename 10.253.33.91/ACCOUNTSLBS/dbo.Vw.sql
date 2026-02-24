-- Object: PROCEDURE dbo.Vw
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------


CREATE PROC Vw @VwName VARCHAR(25)AS                 
Select * from sysobjects where name Like '%' + @VwName + '%' and xtype='V' Order By Name

GO
