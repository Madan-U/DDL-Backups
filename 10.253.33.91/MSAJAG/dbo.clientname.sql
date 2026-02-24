-- Object: PROCEDURE dbo.clientname
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.clientname    Script Date: 3/17/01 9:55:48 PM ******/

/****** Object:  Stored Procedure dbo.clientname    Script Date: 3/21/01 12:50:04 PM ******/

/****** Object:  Stored Procedure dbo.clientname    Script Date: 20-Mar-01 11:38:47 PM ******/

/****** Object:  Stored Procedure dbo.clientname    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.clientname    Script Date: 12/27/00 8:58:47 PM ******/

CREATE PROCEDURE clientname
@partycode varchar(10)
 AS
select c1.short_name, isnull(c2.bankid,''), isnull(c2.cltdpno,'') from client1 c1, client2 c2  where  c2.party_code=@partycode
and c1.cl_code=c2.cl_code

GO
