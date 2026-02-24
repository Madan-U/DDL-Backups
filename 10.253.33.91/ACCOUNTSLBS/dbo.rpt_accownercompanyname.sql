-- Object: PROCEDURE dbo.rpt_accownercompanyname
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

/****** Object:  Stored Procedure dbo.rpt_accownercompanyname    Script Date: 06/24/2004 8:32:37 PM ******/  
  
/****** Object:  Stored Procedure dbo.rpt_accownercompanyname    Script Date: 05/10/2004 5:29:41 PM ******/  
  
  
/****** Object:  Stored Procedure dbo.rpt_accownercompanyname    Script Date: 01/14/2002 20:39:18 ******/  
  
/****** Object:  Stored Procedure dbo.rpt_accownercompanyname    Script Date: 01/04/1980 1:40:39 AM ******/  
  
  
  
/****** Object:  Stored Procedure dbo.rpt_accownercompanyname    Script Date: 11/28/2001 12:23:46 PM ******/  
  
CREATE proc rpt_accownercompanyname  
@sharedb varchar(15)  
as  
select companyname from accountbse.dbo.owner where sharedb = @sharedb

GO
