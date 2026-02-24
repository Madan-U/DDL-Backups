-- Object: PROCEDURE dbo.rpt_fomodcollateral2
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fomodcollateral2    Script Date: 5/11/01 6:19:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomodcollateral2    Script Date: 5/7/2001 9:02:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomodcollateral2    Script Date: 5/5/2001 2:43:38 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomodcollateral2    Script Date: 5/5/2001 1:24:14 PM ******/
CREATE PROCEDURE rpt_fomodcollateral2

@code varchar(10),
@sdate varchar(12),
@cltype varchar(3)

AS


select c.party_code, coll_date, cash, noncash , cl_type
from focollateral c, client1 c1, client2 c2
where c.party_code like ltrim(@code)+'%' 
and c.exchange = 'NSE' 
and markettype like 'F%'
and c1.cl_type = @cltype
and c1.cl_code = c2.cl_code
and c.party_code = c2.party_code
and left(convert(varchar,coll_date,109),11) = @sdate

/*
select party_code, coll_date, cash, noncash from focollateral
where party_code like ltrim(@code)+'%' 
and exchange = 'NSE' and markettype like 'F%'
and left(convert(varchar,coll_date,109),11) = @sdate
*/

GO
