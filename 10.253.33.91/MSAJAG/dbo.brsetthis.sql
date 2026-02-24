-- Object: PROCEDURE dbo.brsetthis
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brsetthis    Script Date: 3/17/01 9:55:47 PM ******/

/****** Object:  Stored Procedure dbo.brsetthis    Script Date: 3/21/01 12:50:03 PM ******/

/****** Object:  Stored Procedure dbo.brsetthis    Script Date: 20-Mar-01 11:38:46 PM ******/

/****** Object:  Stored Procedure dbo.brsetthis    Script Date: 2/5/01 12:06:09 PM ******/

/****** Object:  Stored Procedure dbo.brsetthis    Script Date: 12/27/00 8:58:45 PM ******/

/* Report : Netposition Trader
    File : net.asp
*/
CREATE PROCEDURE brsetthis
@br varchar(3)
AS
select distinct s.sett_no 
from settlement s,client1 c1, client2 c2, branches b
where c1.cl_code = c2.cl_code and b.short_name = c1.trader
and s.party_code = c2.party_code and b.branch_cd = @br
union 
select distinct h.sett_no 
from history h,client1 c1, client2 c2, branches b
where c1.cl_code = c2.cl_code and b.short_name = c1.trader
and h.party_code = c2.party_code and b.branch_cd = @br

GO
