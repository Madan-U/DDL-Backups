-- Object: PROCEDURE dbo.Rpt_settdisp
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure Dbo.rpt_settdisp    Script Date: 01/15/2005 1:45:51 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_settdisp    Script Date: 12/16/2003 2:31:58 Pm ******/  
  
  
  
/****** Object:  Stored Procedure Dbo.rpt_settdisp    Script Date: 05/08/2002 12:35:18 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_settdisp    Script Date: 01/14/2002 20:33:12 ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_settdisp    Script Date: 12/26/2001 1:23:41 Pm ******/  
  
  
/****** Object:  Stored Procedure Dbo.rpt_settdisp    Script Date: 04/27/2001 4:32:49 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_settdisp    Script Date: 3/21/01 12:50:23 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_settdisp    Script Date: 20-mar-01 11:39:03 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_settdisp    Script Date: 2/5/01 12:06:23 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_settdisp    Script Date: 12/27/00 8:58:58 Pm ******/  
  
/* Report : Settlement Calender  
   File : Displaysett.asp  
To Display The Settlement Types  
*/  
Create Procedure Rpt_settdisp  
As  
Select Distinct Sett_type   
From Sett_mst

GO
