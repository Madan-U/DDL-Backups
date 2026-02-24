-- Object: PROCEDURE dbo.brnetno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brnetno    Script Date: 3/17/01 9:55:46 PM ******/

/****** Object:  Stored Procedure dbo.brnetno    Script Date: 3/21/01 12:50:02 PM ******/

/****** Object:  Stored Procedure dbo.brnetno    Script Date: 20-Mar-01 11:38:45 PM ******/

/****** Object:  Stored Procedure dbo.brnetno    Script Date: 2/5/01 12:06:08 PM ******/

/****** Object:  Stored Procedure dbo.brnetno    Script Date: 12/27/00 8:58:45 PM ******/

/* Report : Netposition trader
    File : net.asp
*/
CREATE PROCEDURE brnetno
@br varchar(3)
AS
select distinct s1.sett_no , s1.Sett_type 
from settlement s1, sett_mst s2, client1 c1, client2 c2, branches b 
where s1.sauda_date >= s2.start_date and s1.sauda_date <= s2.end_date 
and c1.cl_code = c2.cl_code and b.short_name = c1.trader 
and s1.party_code = c2.party_code and b.branch_cd = @br

GO
