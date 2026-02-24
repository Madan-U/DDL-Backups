-- Object: PROCEDURE dbo.rpt_focolmargin
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_focolmargin    Script Date: 01/04/1980 1:40:41 AM ******/



/****** Object:  Stored Procedure dbo.rpt_focolmargin    Script Date: 11/28/2001 12:23:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focolmargin    Script Date: 29-Sep-01 8:12:07 PM ******/


/****** Object:  Stored Procedure dbo.rpt_focolmargin    Script Date: 9/7/2001 6:05:58 PM ******/


/****** Object:  Stored Procedure dbo.rpt_focolmargin    Script Date: 08/10/2001 5:05:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focolmargin    Script Date: 7/18/2001 6:24:05 PM ******/
CREATE PROCEDURE rpt_focolmargin

@code varchar(10),
@sdate varchar(12)

AS


select party_code,amount=sum(amount),drcr
from marginledger
where party_code = @code
and exchange = 'NSE'  
and segment like 'FUT%'
and vdt <= @sdate + ' 23:59'
group by  party_code, drcr

GO
