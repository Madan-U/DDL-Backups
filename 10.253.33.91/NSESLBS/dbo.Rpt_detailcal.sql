-- Object: PROCEDURE dbo.Rpt_detailcal
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure Dbo.rpt_detailcal    Script Date: 01/15/2005 1:35:58 Pm ******/

/****** Object:  Stored Procedure Dbo.rpt_detailcal    Script Date: 12/16/2003 2:31:50 Pm ******/



/****** Object:  Stored Procedure Dbo.rpt_detailcal    Script Date: 05/08/2002 12:35:12 Pm ******/

/****** Object:  Stored Procedure Dbo.rpt_detailcal    Script Date: 01/14/2002 20:33:00 ******/

/****** Object:  Stored Procedure Dbo.rpt_detailcal    Script Date: 12/26/2001 1:23:24 Pm ******/


/****** Object:  Stored Procedure Dbo.rpt_detailcal    Script Date: 04/27/2001 4:32:38 Pm ******/

/****** Object:  Stored Procedure Dbo.rpt_detailcal    Script Date: 3/21/01 12:50:14 Pm ******/

/****** Object:  Stored Procedure Dbo.rpt_detailcal    Script Date: 20-mar-01 11:38:55 Pm ******/

/****** Object:  Stored Procedure Dbo.rpt_detailcal    Script Date: 2/5/01 12:06:16 Pm ******/

/****** Object:  Stored Procedure Dbo.rpt_detailcal    Script Date: 12/27/00 8:58:54 Pm ******/

/* Report : Settlement Calender
   File : Detaildisplay.asp
To Display The Deatils Of A Particular Settlement Type
*/
Create Procedure Rpt_detailcal
@settype Varchar(3)
As
Select Sett_no,start_date=left(convert(varchar,start_date,109),11),
End_date=left(convert(varchar,end_date,109),11),
Funds_payin=left(convert(varchar,funds_payin,109),11),
Funds_payout=left(convert(varchar,funds_payout,109),11),
Sec_payin=left(convert(varchar,sec_payin,109),11),
Sec_payout=left(convert(varchar,sec_payout,109),11)
From Sett_mst 
Where Sett_type = @settype
Order By Sett_no Desc

GO
