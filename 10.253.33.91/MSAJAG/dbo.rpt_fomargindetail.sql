-- Object: PROCEDURE dbo.rpt_fomargindetail
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fomargindetail    Script Date: 5/11/01 6:19:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomargindetail    Script Date: 5/7/2001 9:02:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomargindetail    Script Date: 5/5/2001 2:43:37 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomargindetail    Script Date: 5/5/2001 1:24:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomargindetail    Script Date: 4/30/01 5:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomargindetail    Script Date: 10/26/00 6:04:42 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fomargindetail    Script Date: 12/27/00 8:59:10 PM ******/
/*Modified by Amolika on 13th April'2001 : Added like to partycode */
/*
Used In      : NSE FO
Report Name  : Margin Report
File Name    : margin.asp
Tables Used  : margin, fosettlement
Function     : Returns details for a particular date
Written By   : Amolika Patil 
Modified by AMolika on 9thfeb'2001 :  Changed the date format
*/
CREATE PROCEDURE rpt_fomargindetail
@code varchar(10),
@sdate varchar(12)
AS
/*select m.party_code, m.inst_type, m.symbol, convert(varchar,m.expirydate,106) as expirydate 
,spreadqty, nonspreadqty, spreadmargin, nonspreadmargin,isnull(spreadmth,0) as spreadmth,totalqty,cl_rate
from fomargin m
where m.party_code = @code
and convert(varchar,m.margin_date,106) = @sdate
order by inst_type, symbol
*/

select m.party_code, m.inst_type, m.symbol, convert(varchar,m.expirydate,106) as expirydate 
,spreadqty, nonspreadqty, spreadmargin, nonspreadmargin,isnull(spreadmth,0) as spreadmth,totalqty,cl_rate
from fomargin m
where m.party_code LIKE LTRIM(@code)+'%'
and  LEFT(convert(varchar,m.margin_date,109),11)  = @sdate
order by inst_type, symbol

GO
