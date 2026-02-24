-- Object: PROCEDURE dbo.rpt_focollateralnoncash
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_focollateralnoncash    Script Date: 5/11/01 6:19:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focollateralnoncash    Script Date: 5/7/2001 9:02:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focollateralnoncash    Script Date: 5/5/2001 2:43:36 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focollateralnoncash    Script Date: 5/5/2001 1:24:11 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focollateralnoncash    Script Date: 10/18/00 9:14:25 PM ******/






/****** Object:  Stored Procedure dbo.rpt_focollateralnoncash    Script Date: 12/27/00 8:59:09 PM ******/
CREATE PROCEDURE rpt_focollateralnoncash
@code varchar(10)
AS
select s2.scrip_cd, sum(s.qty*c.cl_rate) as amount, s.qty, c.cl_rate
from securities s, scrip2 s2, closing c
where s.scrip_cd = s2.scrip_cd
and s.series = s2.series
and party_code like ltrim(@code)+'%'
and s.scrip_cd = c.scrip_cd
and exch_indicator = 'NSE' 
and seg_indicator like 'F%'
and left(convert(varchar,sysdate,109),11)  = (select max(left(convert(varchar,sysdate,109),11)) from closing where left(convert(varchar,sysdate,109),11) <= left(convert(varchar,getdate(),109),11))
group by s2.scrip_cd, s.qty, c.cl_rate

GO
