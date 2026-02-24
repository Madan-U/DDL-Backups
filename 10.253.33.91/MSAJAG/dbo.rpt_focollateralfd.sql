-- Object: PROCEDURE dbo.rpt_focollateralfd
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_focollateralfd    Script Date: 5/11/01 6:19:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focollateralfd    Script Date: 5/7/2001 9:02:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focollateralfd    Script Date: 5/5/2001 2:43:36 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focollateralfd    Script Date: 5/5/2001 1:24:11 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focollateralfd    Script Date: 10/18/00 9:14:25 PM ******/






/****** Object:  Stored Procedure dbo.rpt_focollateralfd    Script Date: 12/27/00 8:59:09 PM ******/
CREATE PROCEDURE rpt_focollateralfd
@code varchar(10)
AS
select isnull(sum(fd_amt),0)
from fixeddeposits 
where exch_indicator = 'NSE'
and seg_indicator like 'Future%'
and party_code like ltrim(@code)+'%'

GO
