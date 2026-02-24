-- Object: PROCEDURE dbo.brtypenet
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brtypenet    Script Date: 3/17/01 9:55:48 PM ******/

/****** Object:  Stored Procedure dbo.brtypenet    Script Date: 3/21/01 12:50:04 PM ******/

/****** Object:  Stored Procedure dbo.brtypenet    Script Date: 20-Mar-01 11:38:47 PM ******/

/****** Object:  Stored Procedure dbo.brtypenet    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.brtypenet    Script Date: 12/27/00 8:58:46 PM ******/

/* Report : Netposition Trader
    File : net.asp
*/
CREATE PROCEDURE brtypenet
@br varchar(3)
AS
select distinct s.sett_type 
from sett_mst s, client1 c1, client2 c2, branches b
where c1.cl_code = c2.cl_code
and b.short_name = c1.trader
and b.branch_cd = @br

GO
