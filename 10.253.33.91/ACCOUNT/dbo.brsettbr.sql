-- Object: PROCEDURE dbo.brsettbr
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brsettbr    Script Date: 01/04/1980 1:40:35 AM ******/



/****** Object:  Stored Procedure dbo.brsettbr    Script Date: 11/28/2001 12:23:41 PM ******/

/****** Object:  Stored Procedure dbo.brsettbr    Script Date: 29-Sep-01 8:12:02 PM ******/

/****** Object:  Stored Procedure dbo.brsettbr    Script Date: 8/8/01 1:37:29 PM ******/

/****** Object:  Stored Procedure dbo.brsettbr    Script Date: 8/7/01 6:03:48 PM ******/

/****** Object:  Stored Procedure dbo.brsettbr    Script Date: 7/8/01 3:22:48 PM ******/

/****** Object:  Stored Procedure dbo.brsettbr    Script Date: 2/17/01 3:34:14 PM ******/


/****** Object:  Stored Procedure dbo.brsettbr    Script Date: 20-Mar-01 11:43:32 PM ******/

CREATE PROCEDURE brsettbr
@br varchar(3)
AS
select distinct sett_no 
from settlement s, client1 c1,client2 c2,branches b 
where c1.cl_code = c2.cl_code
and b.short_name = c1.trader
and s.party_code = c2.party_code
and b.branch_cd = @br
group by sett_no

GO
