-- Object: PROCEDURE dbo.FN
-- Server: 10.253.33.91 | DB: MTFTRADE
--------------------------------------------------

  
CREATE PROC FN @FUN VARCHAR(25)AS             
SELECT * FROM SYSOBJECTS WHERE NAME LIKE '%' + @FUN + '%' AND XTYPE='FN' ORDER BY NAME

GO
