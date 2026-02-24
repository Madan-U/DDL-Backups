-- Object: PROCEDURE dbo.VW
-- Server: 10.253.33.91 | DB: PRADNYA
--------------------------------------------------

      
CREATE PROC VW @VWNAME VARCHAR(25)AS                     
SELECT * FROM SYSOBJECTS WHERE NAME LIKE '%' + @VWNAME + '%' AND XTYPE='V' ORDER BY NAME

GO
