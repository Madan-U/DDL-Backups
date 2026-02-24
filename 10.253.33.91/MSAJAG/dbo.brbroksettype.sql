-- Object: PROCEDURE dbo.brbroksettype
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brbroksettype    Script Date: 3/17/01 9:55:45 PM ******/

/****** Object:  Stored Procedure dbo.brbroksettype    Script Date: 3/21/01 12:50:01 PM ******/

/****** Object:  Stored Procedure dbo.brbroksettype    Script Date: 20-Mar-01 11:38:44 PM ******/

/****** Object:  Stored Procedure dbo.brbroksettype    Script Date: 2/5/01 12:06:07 PM ******/

/****** Object:  Stored Procedure dbo.brbroksettype    Script Date: 12/27/00 8:58:44 PM ******/

/* Report : Brokerage Report
     File : brokmain.asp
displays settlement types in which branch done trading
*/
CREATE PROCEDURE brbroksettype
@br varchar(3)
AS
select distinct sett_type 
from settlement s, client1 c1, client2 c2, branches b
where c1.cl_code = c2.cl_code
and s.party_code = c2.party_code
and b.short_name = c1.trader
and b.branch_cd = @br
union 
select distinct sett_type 
from history h, client1 c1, client2 c2, branches b
where c1.cl_code = c2.cl_code
and h.party_code = c2.party_code
and b.short_name = c1.trader
and b.branch_cd = @br
order by sett_type

GO
