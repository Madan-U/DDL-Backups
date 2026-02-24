-- Object: PROCEDURE dbo.newsbclientlist
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.newsbclientlist    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.newsbclientlist    Script Date: 3/21/01 12:50:10 PM ******/

/****** Object:  Stored Procedure dbo.newsbclientlist    Script Date: 20-Mar-01 11:38:52 PM ******/

/****** Object:  Stored Procedure dbo.newsbclientlist    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.newsbclientlist    Script Date: 12/27/00 8:58:52 PM ******/

CREATE PROCEDURE newsbclientlist 
AS
select c2.party_code from client1 c1, client2 c2
where c2.cl_code=c1.cl_code
order by c2.party_code

GO
