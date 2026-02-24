-- Object: PROCEDURE dbo.clientlist
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.clientlist    Script Date: 3/17/01 9:55:48 PM ******/

/****** Object:  Stored Procedure dbo.clientlist    Script Date: 3/21/01 12:50:04 PM ******/

/****** Object:  Stored Procedure dbo.clientlist    Script Date: 20-Mar-01 11:38:47 PM ******/

/****** Object:  Stored Procedure dbo.clientlist    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.clientlist    Script Date: 12/27/00 8:58:47 PM ******/

CREATE PROCEDURE clientlist 
AS
select distinct party_code from deliveryclt 
order by party_code

GO
