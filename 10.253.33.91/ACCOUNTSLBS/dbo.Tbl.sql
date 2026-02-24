-- Object: PROCEDURE dbo.Tbl
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------


CREATE PROC Tbl @TblName VARCHAR(25)AS           
Select * from sysobjects where name Like '%' + @TblName + '%' and xtype='U' Order By Name

GO
