-- Object: PROCEDURE dbo.rpt_foclientdetail1
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_foclientdetail1    Script Date: 01/04/1980 1:40:41 AM ******/



/****** Object:  Stored Procedure dbo.rpt_foclientdetail1    Script Date: 11/28/2001 12:23:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclientdetail1    Script Date: 29-Sep-01 8:12:07 PM ******/


/****** Object:  Stored Procedure dbo.rpt_foclientdetail1    Script Date: 9/7/2001 6:05:58 PM ******/

CREATE PROCEDURE rpt_foclientdetail1

@code varchar(10),
@sdate varchar(12),
@tdate varchar(12)
AS

select dramt =  sum(dramt), cramt = sum(cramt), cltcode
from rpt_focldetail
where vdt <= @tdate + ' 23:59:59' and vtyp not Like ( Case When Convert(varchar,Vdt,106) = @Tdate Then '15' else '' end )
and cltcode = @code
group by  cltcode
order by cltcode

GO
