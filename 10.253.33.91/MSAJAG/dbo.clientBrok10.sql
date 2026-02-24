-- Object: PROCEDURE dbo.clientBrok10
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.clientBrok10    Script Date: 3/17/01 9:55:48 PM ******/

/****** Object:  Stored Procedure dbo.clientBrok10    Script Date: 3/21/01 12:50:04 PM ******/

/****** Object:  Stored Procedure dbo.clientBrok10    Script Date: 20-Mar-01 11:38:47 PM ******/

/****** Object:  Stored Procedure dbo.clientBrok10    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.clientBrok10    Script Date: 12/27/00 8:58:47 PM ******/

/****** Object:  Stored Procedure dbo.clientBrok10    Script Date: 12/18/99 8:24:12 AM ******/
create procedure clientBrok10 as
SET ROWCOUNT 10
SELECT PartyCode,PARTYNAME,  SUM(Brokerage) FROM BROKTOP
GROUP BY PARTYCODE,PARTYNAME
ORDER BY SUM(  Brokerage ) DESC

GO
