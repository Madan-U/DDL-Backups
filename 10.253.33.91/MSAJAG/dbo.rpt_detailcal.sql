-- Object: PROCEDURE dbo.rpt_detailcal
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_detailcal    Script Date: 04/27/2001 4:32:38 PM ******/

/****** Object:  Stored Procedure dbo.rpt_detailcal    Script Date: 3/21/01 12:50:14 PM ******/

/****** Object:  Stored Procedure dbo.rpt_detailcal    Script Date: 20-Mar-01 11:38:55 PM ******/

/****** Object:  Stored Procedure dbo.rpt_detailcal    Script Date: 2/5/01 12:06:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_detailcal    Script Date: 12/27/00 8:58:54 PM ******/

/* Report : Settlement calender
   File : detaildisplay.asp
to display the deatils of a particular settlement type
*/
CREATE PROCEDURE rpt_detailcal
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
