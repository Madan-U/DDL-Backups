-- Object: PROCEDURE dbo.brshortno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brshortno    Script Date: 3/17/01 9:55:47 PM ******/

/****** Object:  Stored Procedure dbo.brshortno    Script Date: 3/21/01 12:50:03 PM ******/

/****** Object:  Stored Procedure dbo.brshortno    Script Date: 20-Mar-01 11:38:46 PM ******/

/****** Object:  Stored Procedure dbo.brshortno    Script Date: 2/5/01 12:06:09 PM ******/

/****** Object:  Stored Procedure dbo.brshortno    Script Date: 12/27/00 8:58:46 PM ******/

/* Report : rec Shortage
   File : settnotype
displays sett types in which a particular branch has done trading
*/
CREATE PROCEDURE brshortno
@br varchar(3)
AS
select distinct d.sett_type 
from deliveryclt d, client1 c1,client2 c2, branches b
where c1.cl_code = c2.cl_code 
and b.short_name = c1.trader
and b.branch_cd = @br
and d.party_code = c2.party_code
order by d.sett_type

GO
