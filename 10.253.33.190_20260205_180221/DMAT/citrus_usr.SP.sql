-- Object: PROCEDURE citrus_usr.SP
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROC [citrus_usr].[SP] @spName VARCHAR(25)AS         
Select * from sysobjects where name Like '%' + @spName + '%' and xtype='P' Order By Name

GO
