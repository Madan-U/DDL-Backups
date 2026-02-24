-- Object: PROCEDURE dbo.brbrokd
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brbrokd    Script Date: 3/17/01 9:55:45 PM ******/

/****** Object:  Stored Procedure dbo.brbrokd    Script Date: 3/21/01 12:50:01 PM ******/

/****** Object:  Stored Procedure dbo.brbrokd    Script Date: 20-Mar-01 11:38:44 PM ******/

/****** Object:  Stored Procedure dbo.brbrokd    Script Date: 2/5/01 12:06:07 PM ******/

/****** Object:  Stored Procedure dbo.brbrokd    Script Date: 12/27/00 8:58:43 PM ******/

/* Report : Brokerage report
    File : brokmaindate.asp
displays list of traders of a branch
*/
CREATE PROCEDURE brbrokd
@br varchar(3)
AS
select distinct trader 
from client1 c1, client2 c2,branches b
where c1.cl_code = c2.cl_code 
and b.short_name = c1.trader
and b.branch_cd = @br

GO
