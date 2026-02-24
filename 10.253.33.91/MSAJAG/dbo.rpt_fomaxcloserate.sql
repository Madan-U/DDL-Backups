-- Object: PROCEDURE dbo.rpt_fomaxcloserate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fomaxcloserate    Script Date: 5/11/01 6:19:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomaxcloserate    Script Date: 5/7/2001 9:02:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomaxcloserate    Script Date: 5/5/2001 2:43:37 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomaxcloserate    Script Date: 5/5/2001 1:24:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomaxcloserate    Script Date: 4/30/01 5:50:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomaxcloserate    Script Date: 10/26/00 6:04:42 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fomaxcloserate    Script Date: 12/27/00 8:59:10 PM ******/
CREATE PROCEDURE rpt_fomaxcloserate
@inst varchar(12),
@symbol varchar(21),
@expdate varchar(12),
@sdate varchar(12)
AS
select cl_rate 
from foclosing
where convert(varchar,expirydate,106) = @expdate
and convert(varchar,trade_date,106) = @sdate
and inst_type = @inst
and symbol = @symbol

GO
