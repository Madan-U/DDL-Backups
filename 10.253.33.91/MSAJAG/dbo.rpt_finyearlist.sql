-- Object: PROCEDURE dbo.rpt_finyearlist
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_finyearlist    Script Date: 01/19/2002 12:15:14 ******/

/****** Object:  Stored Procedure dbo.rpt_finyearlist    Script Date: 01/04/1980 5:06:27 AM ******/



CREATE PROCEDURE  rpt_finyearlist

AS

select distinct  smonth=datename(month, sdtcur), syear=datename(year, sdtcur), emonth=datename(month, ldtcur),
 lyear=datename(year, ldtcur) ,sdt=convert(varchar,sdtcur,103),
ldt=convert(varchar,ldtcur,103), curyear from account.dbo.parameter
order by curyear desc

GO
