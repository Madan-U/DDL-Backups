-- Object: PROCEDURE dbo.rpt_focheck
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_focheck    Script Date: 5/11/01 6:19:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focheck    Script Date: 5/7/2001 9:02:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focheck    Script Date: 5/5/2001 2:43:36 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focheck    Script Date: 5/5/2001 1:24:09 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focheck    Script Date: 4/30/01 5:50:07 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focheck    Script Date: 10/26/00 6:04:41 PM ******/






/****** Object:  Stored Procedure dbo.rpt_focheck    Script Date: 12/27/00 8:59:09 PM ******/
/*
Used In      : NSE FO
Report Name  : Bill Report
File Name    : billreport.asp
Tables Used  : fosettlement
Function     : Returns data of a particular partycode & date
Written By   : Amolika Patil 
*/
CREATE PROCEDURE rpt_focheck
@code varchar(10),
@sdate varchar(12)
AS
select * 
from fosettlement 
where party_code = @code and convert(varchar,sauda_date,106) = @sdate

GO
