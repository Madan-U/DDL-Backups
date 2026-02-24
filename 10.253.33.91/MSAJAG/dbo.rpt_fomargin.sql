-- Object: PROCEDURE dbo.rpt_fomargin
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fomargin    Script Date: 5/11/01 6:19:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomargin    Script Date: 5/7/2001 9:02:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomargin    Script Date: 5/5/2001 2:43:37 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomargin    Script Date: 5/5/2001 1:24:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomargin    Script Date: 4/30/01 5:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomargin    Script Date: 10/26/00 6:04:42 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fomargin    Script Date: 12/27/00 8:59:10 PM ******/
/*
Used In      : NSE FO
Report Name  : Margin Report
File Name    : margin.asp
Tables Used  : client1, client2, margin
Function     : Returns partycode, shortname, spread & nonspread qty of a particular trader
Written By   : Amolika Patil 
*/
CREATE PROCEDURE rpt_fomargin
@trader varchar(15),
@sdate varchar(12)
AS
select distinct c2.party_code, c1.short_name ,sum(m.spreadmargin) as spreadmargin ,sum(m.nonspreadmargin) as nonspreadmargin
from client1 c1, client2 c2, fomargin m
where c1.cl_code = c2.cl_code
and m.party_code = c2.party_code
and c1.trader = @trader
and convert(varchar,margin_date,106) = @sdate
group by c2.party_code,c1.short_name

GO
