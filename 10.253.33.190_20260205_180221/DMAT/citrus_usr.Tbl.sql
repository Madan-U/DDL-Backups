-- Object: PROCEDURE citrus_usr.Tbl
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROC [citrus_usr].[Tbl] @TblName VARCHAR(25)AS       
Select * from sysobjects where name Like '%' + @TblName + '%' and xtype='U' Order By Name

GO
