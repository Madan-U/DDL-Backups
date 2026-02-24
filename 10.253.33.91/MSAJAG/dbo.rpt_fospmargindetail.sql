-- Object: PROCEDURE dbo.rpt_fospmargindetail
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fospmargindetail    Script Date: 5/11/01 6:19:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fospmargindetail    Script Date: 5/7/2001 9:02:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fospmargindetail    Script Date: 5/5/2001 2:43:39 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fospmargindetail    Script Date: 5/5/2001 1:24:17 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fospmargindetail    Script Date: 4/30/01 5:50:17 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fospmargindetail    Script Date: 10/26/00 6:04:44 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fospmargindetail    Script Date: 12/27/00 8:59:11 PM ******/
/*
Used In      : NSE FO
Report Name  : Margin Report
File Name    : spmargindetail.asp
Tables Used  : fonsespmargin, client3
Function     : Returns spreadmargin of a particular contract descriptor
Written By   : Amolika Patil 
*/
CREATE PROCEDURE rpt_fospmargindetail
@inst varchar(6),
@symbol varchar(12),
@near varchar(12),
@far varchar(12),
@sdate varchar(12)
AS
select distinct spreadmargin
from fonsespmargin f
where f.inst_type = @inst
and f.symbol = @symbol
and convert(varchar,f.near_expirydate,106) = @near
and convert(varchar,f.far_expirydate,106) = @far
and convert(varchar,f.date,106) = @sdate

GO
