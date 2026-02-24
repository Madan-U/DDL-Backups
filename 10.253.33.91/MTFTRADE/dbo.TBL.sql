-- Object: PROCEDURE dbo.TBL
-- Server: 10.253.33.91 | DB: MTFTRADE
--------------------------------------------------

    
CREATE PROC TBL @TBLNAME VARCHAR(25)AS               
SELECT * FROM SYSOBJECTS WHERE NAME LIKE '%' + @TBLNAME + '%' AND XTYPE='U' ORDER BY NAME

GO
