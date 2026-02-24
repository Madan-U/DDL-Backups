-- Object: PROCEDURE dbo.rpt_fofd
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fofd    Script Date: 5/11/01 6:19:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fofd    Script Date: 5/7/2001 9:02:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fofd    Script Date: 5/5/2001 2:43:37 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fofd    Script Date: 5/5/2001 1:24:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fofd    Script Date: 4/30/01 5:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fofd    Script Date: 10/26/00 6:04:42 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fofd    Script Date: 12/27/00 8:59:10 PM ******/
CREATE PROCEDURE rpt_fofd
@code varchar(10)
AS
select party_code,fd_name, fdr_no, first_holder, fd_amt, 
convert(varchar,maturity_dt,106) as maturitydate
from fixeddeposits 
where exch_indicator = 'NSE'
and seg_indicator like 'Fut%'
and party_code = @code

GO
