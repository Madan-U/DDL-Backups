-- Object: PROCEDURE dbo.Finalcont
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.Finalcont    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.Finalcont    Script Date: 3/21/01 12:50:07 PM ******/

/****** Object:  Stored Procedure dbo.Finalcont    Script Date: 20-Mar-01 11:38:49 PM ******/

/****** Object:  Stored Procedure dbo.Finalcont    Script Date: 2/5/01 12:06:12 PM ******/

/****** Object:  Stored Procedure dbo.Finalcont    Script Date: 12/27/00 8:58:49 PM ******/

/****** Object:  Stored Procedure dbo.Finalcont    Script Date: 12/18/99 8:24:13 AM ******/
CREATE PROCEDURE Finalcont
(@date varchar(10),@party1 varchar(10), @party2 varchar(10) )
 AS
IF (SELECT COUNT(TRADE_NO) FROM SETTLEMENT WHERE CONVERT(VARCHAR,SAUDA_DATE,3) = convert(char,@date,3) and party_code = @party1 ) 
>0 
EXEC SETTcon @DATE,@party1,@party2
ELSE 
EXEC HISTORYcon @DATe,@party1,@party2

GO
