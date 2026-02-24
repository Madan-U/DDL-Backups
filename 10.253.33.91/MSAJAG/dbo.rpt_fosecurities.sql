-- Object: PROCEDURE dbo.rpt_fosecurities
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fosecurities    Script Date: 5/11/01 6:19:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fosecurities    Script Date: 5/7/2001 9:02:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fosecurities    Script Date: 5/5/2001 2:43:39 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fosecurities    Script Date: 5/5/2001 1:24:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fosecurities    Script Date: 4/30/01 5:50:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fosecurities    Script Date: 10/26/00 6:04:44 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fosecurities    Script Date: 12/27/00 8:59:11 PM ******/

CREATE PROCEDURE rpt_fosecurities

@code varchar(10),
@sdate varchar(12)

AS
/*
select s.scrip_cd, sum(qty) as qty, c.cl_rate , sum(qty*c.cl_rate) as amount
from securities s, scrip2 s2, closing c
where s.scrip_cd = s2.scrip_cd
and s.series = s2.series
and s.party_code = @code
and s.scrip_cd = c.scrip_cd
and convert(varchar,sysdate,103)  = convert(varchar,getdate(),103)
group by s.scrip_cd, c.cl_rate 
*/
select  party_code,security_type ,s.series,s.scrip_cd, qty, 
left(convert(varchar,sysdate,109),11) , cl_rate
from  securities s, closing c
where party_code = @code
and exch_indicator = 'NSE' 
and seg_indicator like 'F%'
and s.scrip_cd = c.scrip_cd
and s.series = c.series
/*and left(convert(varchar,sysdate,109),11) = @sdate*/
and left(convert(varchar,sysdate,109),11) = 
(select max(left(convert(varchar,sysdate,109),11)) from closing where left(convert(varchar,sysdate,109),11) <=@sdate)

GO
