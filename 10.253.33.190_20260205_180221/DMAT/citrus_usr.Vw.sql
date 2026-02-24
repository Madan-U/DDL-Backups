-- Object: PROCEDURE citrus_usr.Vw
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROC [citrus_usr].[Vw] @VwName VARCHAR(25)AS             
Select * from sysobjects where name Like '%' + @VwName + '%' and xtype='V' Order By Name

GO
