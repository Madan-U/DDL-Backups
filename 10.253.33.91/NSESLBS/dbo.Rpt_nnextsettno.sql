-- Object: PROCEDURE dbo.Rpt_nnextsettno
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure Dbo.rpt_nnextsettno    Script Date: 01/15/2005 1:42:54 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_nnextsettno    Script Date: 12/16/2003 2:31:55 Pm ******/  
  
  
  
/****** Object:  Stored Procedure Dbo.rpt_nnextsettno    Script Date: 05/08/2002 12:35:16 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_nnextsettno    Script Date: 01/14/2002 20:33:07 ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_nnextsettno    Script Date: 12/14/2001 1:25:17 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_nnextsettno    Script Date: 11/30/01 4:48:54 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_nnextsettno    Script Date: 11/5/01 1:29:16 Pm ******/  
  
  
  
  
  
/****** Object:  Stored Procedure Dbo.rpt_nnextsettno    Script Date: 09/07/2001 11:09:20 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_nnextsettno    Script Date: 7/1/01 2:26:46 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_nnextsettno    Script Date: 06/26/2001 8:49:10 Pm ******/  
  
  
/****** Object:  Stored Procedure Dbo.rpt_nnextsettno    Script Date: 04/27/2001 4:32:47 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_nnextsettno    Script Date: 3/21/01 12:50:21 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_nnextsettno    Script Date: 20-mar-01 11:39:01 Pm ******/  
  
  
  
  
  
/****** Object:  Stored Procedure Dbo.rpt_nnextsettno    Script Date: 12/27/00 8:58:56 Pm ******/  
/* Report : Bill Report  
   File : Billreport.asp  
   Gives Next Settlement Number   
*/  
Create Procedure Rpt_nnextsettno   
@settno Varchar(7)  
As  
  
Select Min(sett_no) From Sett_mst Where Sett_no > @settno And Sett_type = 'n'  
  
/*  
Select Distinct Sett_no+1  From History Where Sett_no=@settno  
Union  
Select Distinct Sett_no +1 From Settlement Where Sett_no=@settno  
*/

GO
