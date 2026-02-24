-- Object: PROCEDURE dbo.SP
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE PROC SP @spName VARCHAR(25)AS             
Select * from sysobjects where name Like '%' + @spName + '%' and xtype='P' Order By Name

GO
