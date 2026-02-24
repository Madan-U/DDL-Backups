-- Object: PROCEDURE dbo.brhissetttype
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brhissetttype    Script Date: 3/17/01 9:55:46 PM ******/

/****** Object:  Stored Procedure dbo.brhissetttype    Script Date: 3/21/01 12:50:01 PM ******/

/****** Object:  Stored Procedure dbo.brhissetttype    Script Date: 20-Mar-01 11:38:45 PM ******/

/****** Object:  Stored Procedure dbo.brhissetttype    Script Date: 2/5/01 12:06:08 PM ******/

/****** Object:  Stored Procedure dbo.brhissetttype    Script Date: 12/27/00 8:58:44 PM ******/

/*  Report : history position
     File : hispositionmain.asp
displays sett types  for a particular branch
*/
CREATE PROCEDURE brhissetttype
@br varchar(3)
AS
select distinct sett_type 
from history h, client1 c1,client2 c2, branches b
where c1.cl_code = c2.cl_code
and b.short_name = c1.trader
and h.party_code = c2.party_code 
and b.branch_cd =@br
order by sett_type

GO
