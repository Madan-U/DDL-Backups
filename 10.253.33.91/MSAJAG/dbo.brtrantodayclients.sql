-- Object: PROCEDURE dbo.brtrantodayclients
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brtrantodayclients    Script Date: 3/17/01 9:55:48 PM ******/

/****** Object:  Stored Procedure dbo.brtrantodayclients    Script Date: 3/21/01 12:50:04 PM ******/

/****** Object:  Stored Procedure dbo.brtrantodayclients    Script Date: 20-Mar-01 11:38:47 PM ******/

/****** Object:  Stored Procedure dbo.brtrantodayclients    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.brtrantodayclients    Script Date: 12/27/00 8:58:46 PM ******/

/* report : client transaction
file :todaysclient.asp
displays orders confirmed
*/
CREATE PROCEDURE brtrantodayclients
@br varchar(3),
@trader varchar(15),
@sdate varchar(10)
AS
select distinct t.party_code,c1.short_name 
from Trade4432 t, client1 c1,client2 c2, branches b 
where c1.cl_code = c2.cl_code 
and c2.party_code = t.party_code 
and b.short_name = c1.trader
and b.branch_cd = @br
and c1.trader like ltrim(@trader)+'%' 
and convert(varchar,t.sauda_date,1)like ltrim(@sdate)+'%' 
order by c1.short_name,t.party_code

GO
