-- Object: PROCEDURE dbo.rpt_foserieswiseinfo1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_foserieswiseinfo1    Script Date: 5/11/01 6:19:49 PM ******/


/****** Object:  Stored Procedure dbo.rpt_foserieswiseinfo1    Script Date: 5/7/2001 9:02:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foserieswiseinfo1    Script Date: 5/5/2001 2:43:39 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foserieswiseinfo1    Script Date: 5/5/2001 1:24:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foserieswiseinfo1    Script Date: 4/30/01 5:50:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foserieswiseinfo1    Script Date: 10/26/00 6:04:44 PM ******/


CREATE PROCEDURE rpt_foserieswiseinfo1

@sdate varchar(12)
AS

select Inst_Type, Symbol, sec_name, 
start_date = convert(varchar,startdate,106),
expirydate = convert(varchar,Expirydate,106),
maturitydate = convert(varchar,Maturitydate,106), expirydate as expdate,
strike_price,
option_type
from foscrip2
where convert(varchar,Expirydate,106) like (case when lTrim(@sdate) = '%' then '%' else @sdate end )
order by expdate desc

GO
