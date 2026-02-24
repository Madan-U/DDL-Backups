-- Object: PROCEDURE dbo.Rpt_nodel
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure Dbo.rpt_nodel    Script Date: 01/15/2005 1:42:54 Pm ******/

/****** Object:  Stored Procedure Dbo.rpt_nodel    Script Date: 12/16/2003 2:31:55 Pm ******/



/****** Object:  Stored Procedure Dbo.rpt_nodel    Script Date: 05/08/2002 12:35:16 Pm ******/

/****** Object:  Stored Procedure Dbo.rpt_nodel    Script Date: 01/14/2002 20:33:07 ******/

/****** Object:  Stored Procedure Dbo.rpt_nodel    Script Date: 12/26/2001 1:23:37 Pm ******/


/****** Object:  Stored Procedure Dbo.rpt_nodel    Script Date: 04/27/2001 4:32:47 Pm ******/

/****** Object:  Stored Procedure Dbo.rpt_nodel    Script Date: 3/21/01 12:50:21 Pm ******/

/****** Object:  Stored Procedure Dbo.rpt_nodel    Script Date: 20-mar-01 11:39:01 Pm ******/

/****** Object:  Stored Procedure Dbo.rpt_nodel    Script Date: 2/5/01 12:06:22 Pm ******/

/****** Object:  Stored Procedure Dbo.rpt_nodel    Script Date: 12/27/00 8:58:56 Pm ******/

/* Report : Nodelivery Calendar
   File : Dispinput.asp
*/
/* Displays List Of Nodelivery Scrips For A Particular Settlement And Type */
Create Procedure Rpt_nodel
@settype Varchar(3)
As
Select Distinct Sett_no, End_date From Sett_mst  Where Sett_type = @settype
Order By End_date Desc

GO
