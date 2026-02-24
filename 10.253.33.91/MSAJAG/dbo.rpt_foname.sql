-- Object: PROCEDURE dbo.rpt_foname
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_foname    Script Date: 5/11/01 6:19:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foname    Script Date: 5/7/2001 9:02:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foname    Script Date: 5/5/2001 2:43:38 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foname    Script Date: 5/5/2001 1:24:15 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foname    Script Date: 4/30/01 5:50:14 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foname    Script Date: 10/26/00 6:04:43 PM ******/






/****** Object:  Stored Procedure dbo.rpt_foname    Script Date: 12/27/00 8:59:10 PM ******/
/*
Used In      : NSE FO
Report Name  : Bill Report
File Name    : BillReport
Tables Used  : client1, client2
Function     : Returns name of the given partycode
Written By   : Amolika Patil 
*/
CREATE PROCEDURE rpt_foname
@code varchar(10)
AS
select c1.short_name 
from client1 c1, client2 c2 
where c1.cl_code = c2.cl_code
and c2.party_code = @code

GO
