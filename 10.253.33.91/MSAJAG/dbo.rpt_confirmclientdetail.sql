-- Object: PROCEDURE dbo.rpt_confirmclientdetail
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_confirmclientdetail    Script Date: 04/21/2001 6:05:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_confirmclientdetail    Script Date: 3/21/01 12:50:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_confirmclientdetail    Script Date: 20-Mar-01 11:38:55 PM ******/





/****** Object:  Stored Procedure dbo.rpt_confirmclientdetail    Script Date: 2/5/01 12:06:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_confirmclientdetail    Script Date: 12/27/00 8:58:54 PM ******/

/* 
report :confirmation report
file : cl.asp
*/
/* displays client details */
CREATE PROCEDURE rpt_confirmclientdetail
@partycode varchar(10)
AS
select c2.bankid, c2.cltdpno,c1.cl_code,c1.short_name,c1.Fax,c1.Res_Phone1,c1.res_Phone2,c1.Off_Phone1,
c1.Off_Phone2,c1.Email
from client1 c1, client2 c2
where c1.cl_code=c2.cl_code and c2.party_code=@partycode

GO
