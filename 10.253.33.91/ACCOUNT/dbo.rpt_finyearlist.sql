-- Object: PROCEDURE dbo.rpt_finyearlist
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_finyearlist    Script Date: 01/04/1980 1:40:41 AM ******/



/****** Object:  Stored Procedure dbo.rpt_finyearlist    Script Date: 11/28/2001 12:23:50 PM ******/


CREATE PROCEDURE  rpt_finyearlist

AS

select distinct  smonth=datename(month, sdtcur), syear=datename(year, sdtcur), emonth=datename(month, ldtcur),
 lyear=datename(year, ldtcur) ,sdt=convert(varchar,sdtcur,103),
ldt=convert(varchar,ldtcur,103), curyear from account.dbo.parameter
order by curyear desc

GO
