-- Object: PROCEDURE dbo.brtrantoday
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brtrantoday    Script Date: 3/17/01 9:55:48 PM ******/

/****** Object:  Stored Procedure dbo.brtrantoday    Script Date: 3/21/01 12:50:04 PM ******/

/****** Object:  Stored Procedure dbo.brtrantoday    Script Date: 20-Mar-01 11:38:47 PM ******/

/****** Object:  Stored Procedure dbo.brtrantoday    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.brtrantoday    Script Date: 12/27/00 8:58:46 PM ******/

/* Report : Client Transaction
    File : todaysclients.asp
displays list of clients who have done trading today
*/
CREATE PROCEDURE brtrantoday
@br varchar(3),
@trader varchar(15),
@sdate varchar(10)
AS
select distinct t.party_code,c1.short_name 
from Trade t, client1 c1,client2 c2,branches b 
where c1.cl_code = c2.cl_code 
and b.short_name = c1.trader
and b.branch_cd = @br
and c2.party_code = t.party_code 
and c1.trader like ltrim(@trader)+'%' 
and convert(varchar,t.sauda_date,101)=@sdate
order by c1.short_name,t.party_code

GO
