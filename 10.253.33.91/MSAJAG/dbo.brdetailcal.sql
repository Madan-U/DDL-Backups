-- Object: PROCEDURE dbo.brdetailcal
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brdetailcal    Script Date: 3/17/01 9:55:45 PM ******/

/****** Object:  Stored Procedure dbo.brdetailcal    Script Date: 3/21/01 12:50:01 PM ******/

/****** Object:  Stored Procedure dbo.brdetailcal    Script Date: 20-Mar-01 11:38:44 PM ******/

/****** Object:  Stored Procedure dbo.brdetailcal    Script Date: 2/5/01 12:06:08 PM ******/

/****** Object:  Stored Procedure dbo.brdetailcal    Script Date: 12/27/00 8:58:44 PM ******/

CREATE PROCEDURE brdetailcal
@settype varchar(3)
AS
select sett_no,start_date=Left(convert(varchar,start_date,109),11),
end_date=Left(convert(varchar,end_date,109),11),
funds_payin=Left(convert(varchar,funds_payin,109),11),
funds_payout=Left(convert(varchar,funds_payout,109),11),
sec_payin=Left(convert(varchar,sec_payin,109),11),
sec_payout=Left(convert(varchar,sec_payout,109),11)
from sett_mst 
where sett_type = @settype
order by sett_no desc

GO
