-- Object: PROCEDURE dbo.rpt_foname1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_foname1    Script Date: 5/11/01 6:19:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foname1    Script Date: 5/7/2001 9:02:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foname1    Script Date: 5/5/2001 2:43:38 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foname1    Script Date: 5/5/2001 1:24:15 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foname1    Script Date: 4/30/01 5:50:14 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foname1    Script Date: 10/26/00 6:04:43 PM ******/






/****** Object:  Stored Procedure dbo.rpt_foname1    Script Date: 12/27/00 8:59:10 PM ******/
/*
Used In      : NSE FO
Report Name  : Confirmation Report
File Name    : confirmationmain.asp
Tables Used  : client1, client2
Function     : Returns shortname
Written By   : Amolika Patil 
*/
CREATE PROCEDURE rpt_foname1
@code varchar(10)
AS
if @code <> 'All'
begin
select short_name 
from client1 c1, client2 c2 
where c2.party_code = @code and c1.cl_code = c2.cl_code
end

GO
