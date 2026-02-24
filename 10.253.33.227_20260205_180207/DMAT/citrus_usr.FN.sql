-- Object: PROCEDURE citrus_usr.FN
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

  
CREATE PROC FN @FUN VARCHAR(25)AS             
SELECT * FROM SYSOBJECTS WHERE NAME LIKE '%' + @FUN + '%' AND XTYPE='FN' ORDER BY NAME

GO
