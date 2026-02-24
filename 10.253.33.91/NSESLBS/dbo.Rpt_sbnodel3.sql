-- Object: PROCEDURE dbo.Rpt_sbnodel3
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure Dbo.rpt_sbnodel3    Script Date: 01/15/2005 1:45:22 Pm ******/

/****** Object:  Stored Procedure Dbo.rpt_sbnodel3    Script Date: 12/16/2003 2:31:58 Pm ******/

/****** Object:  Stored Procedure Dbo.rpt_sbnodel3    Script Date: 05/08/2002 12:35:18 Pm ******/

/****** Object:  Stored Procedure Dbo.rpt_sbnodel3    Script Date: 01/14/2002 20:33:11 ******/

/****** Object:  Stored Procedure Dbo.rpt_sbnodel3    Script Date: 12/26/2001 1:23:40 Pm ******/

/****** Object:  Stored Procedure Dbo.rpt_sbnodel3    Script Date: 04/27/2001 4:32:49 Pm ******/

/****** Object:  Stored Procedure Dbo.rpt_sbnodel3    Script Date: 3/21/01 12:50:23 Pm ******/

/****** Object:  Stored Procedure Dbo.rpt_sbnodel3    Script Date: 20-mar-01 11:39:03 Pm ******/

/****** Object:  Stored Procedure Dbo.rpt_sbnodel3    Script Date: 2/5/01 12:06:23 Pm ******/

/****** Object:  Stored Procedure Dbo.rpt_sbnodel3    Script Date: 12/27/00 8:58:58 Pm ******/

/** Report : Nodelivery
File :dispinfo.asp **/

CREATE Procedure Rpt_sbnodel3
	(
	@settno Varchar(7)
	)

	As

	Set Transaction Isolation Level Read Uncommitted
	Set NoCount On

	Select 
		Srno,
		scrip_cd,
		series,
		sett_no,
		sett_type,
		Start_date=left(convert(varchar,start_date,109),11),
		End_date=left(convert(varchar,end_date,109),11),
		settled_in 
	From 
		Nodel(NoLock)
	Where 
		Sett_no = @settno

	Order By 
		scrip_cd

GO
