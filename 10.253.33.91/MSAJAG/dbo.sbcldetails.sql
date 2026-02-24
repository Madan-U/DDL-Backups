-- Object: PROCEDURE dbo.sbcldetails
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbcldetails    Script Date: 3/17/01 9:56:06 PM ******/

/****** Object:  Stored Procedure dbo.sbcldetails    Script Date: 3/21/01 12:50:25 PM ******/

/****** Object:  Stored Procedure dbo.sbcldetails    Script Date: 20-Mar-01 11:39:04 PM ******/

/****** Object:  Stored Procedure dbo.sbcldetails    Script Date: 2/5/01 12:06:24 PM ******/

/****** Object:  Stored Procedure dbo.sbcldetails    Script Date: 12/27/00 8:58:59 PM ******/

/* Report Confirmation
File : Cl.asp
 displays details of clients
*/
CREATE PROCEDURE sbcldetails
@partycode varchar(10)
AS
select c2.bankid, c2.cltdpno,c1.cl_code,c1.short_name,c1.Fax,c1.Res_Phone1,c1.res_Phone2,c1.Off_Phone1,c1.Off_Phone2,
c1.Email from client1 c1, client2 c2 where c1.cl_code=c2.cl_code and c2.party_code=@partycode

GO
