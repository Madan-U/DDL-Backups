-- Object: PROCEDURE dbo.brhissettno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brhissettno    Script Date: 3/17/01 9:55:46 PM ******/

/****** Object:  Stored Procedure dbo.brhissettno    Script Date: 3/21/01 12:50:01 PM ******/

/****** Object:  Stored Procedure dbo.brhissettno    Script Date: 20-Mar-01 11:38:45 PM ******/

/****** Object:  Stored Procedure dbo.brhissettno    Script Date: 2/5/01 12:06:08 PM ******/

/****** Object:  Stored Procedure dbo.brhissettno    Script Date: 12/27/00 8:58:44 PM ******/

/* Report :History position
    File : hispositionmain.asp
displays settlement numbers for a particular branch
*/
CREATE PROCEDURE brhissettno
@br varchar(3)
AS
select distinct sett_no 
from history h,client1 c1, client2 c2, branches b
where c1.cl_code = c2.cl_code 
and b.short_name = c1.trader
and b.branch_cd= @br
and h.party_code = c2.party_code
order by sett_no

GO
