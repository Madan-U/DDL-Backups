-- Object: PROCEDURE dbo.SP
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

    
CREATE PROC [dbo].[SP] @SPNAME VARCHAR(25)AS                 
SELECT * FROM SYSOBJECTS WHERE NAME LIKE '%' + @SPNAME + '%' AND XTYPE='P' ORDER BY NAME

GO
