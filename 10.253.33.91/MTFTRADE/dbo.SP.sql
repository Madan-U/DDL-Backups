-- Object: PROCEDURE dbo.SP
-- Server: 10.253.33.91 | DB: MTFTRADE
--------------------------------------------------

    
CREATE PROC SP @SPNAME VARCHAR(25)AS                 
SELECT * FROM SYSOBJECTS WHERE NAME LIKE '%' + @SPNAME + '%' AND XTYPE='P' ORDER BY NAME

GO
