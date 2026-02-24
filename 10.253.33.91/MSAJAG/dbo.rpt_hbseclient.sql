-- Object: PROCEDURE dbo.rpt_hbseclient
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_hbseclient    Script Date: 04/27/2001 4:32:42 PM ******/

/****** Object:  Stored Procedure dbo.rpt_hbseclient    Script Date: 3/21/01 12:50:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_hbseclient    Script Date: 20-Mar-01 11:38:58 PM ******/

/****** Object:  Stored Procedure dbo.rpt_hbseclient    Script Date: 2/5/01 12:06:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_hbseclient    Script Date: 12/27/00 8:58:54 PM ******/

CREATE PROCEDURE rpt_hbseclient
@code varchar(10)
AS
select c2.bankid, c2.cltdpno,c1.cl_code,c1.short_name,c1.Fax,c1.Res_Phone1,
c1.res_Phone2,c1.Off_Phone1,c1.Off_Phone2,c1.Email 
from msajag.dbo.client1 c1, msajag.dbo.client2 c2 
where c1.cl_code=c2.cl_code and c2.party_code = @code

GO
