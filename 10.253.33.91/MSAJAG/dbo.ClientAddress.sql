-- Object: PROCEDURE dbo.ClientAddress
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ClientAddress    Script Date: 3/17/01 9:55:48 PM ******/

/****** Object:  Stored Procedure dbo.ClientAddress    Script Date: 3/21/01 12:50:04 PM ******/

/****** Object:  Stored Procedure dbo.ClientAddress    Script Date: 20-Mar-01 11:38:47 PM ******/

/****** Object:  Stored Procedure dbo.ClientAddress    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.ClientAddress    Script Date: 12/27/00 8:58:47 PM ******/

/****** Object:  Stored Procedure dbo.ClientAddress    Script Date: 12/18/99 8:24:07 AM ******/
CREATE PROCEDURE ClientAddress
@fromBranchCd char(3),
@toBranchCd char(3) ,
@fromclient char(6) ,
@toclient char(6) 
AS
select a.Cl_code, a.long_name, a.l_address1, a.l_address2, a.l_address3, a.l_city,
 a.l_state, a.l_nation, a.l_zip,a.Res_Phone1,a.Res_Phone2,a.off_phone1,
a.off_phone2,a.Email,a.Mobile_Pager, a.branch_cd, b.short_name
from client1 a, branches b
where a.branch_cd >= @fromBranchCd 
 and a.branch_cd <= @toBranchCd 
  and a.Cl_Code  >= @fromclient 
   and a.Cl_Code <= @toclient 
    and a.branch_cd = b.branch_cd

GO
