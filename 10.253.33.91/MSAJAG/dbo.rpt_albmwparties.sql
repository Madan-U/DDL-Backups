-- Object: PROCEDURE dbo.rpt_albmwparties
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_albmwparties    Script Date: 04/27/2001 4:32:32 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmwparties    Script Date: 3/21/01 12:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmwparties    Script Date: 20-Mar-01 11:38:53 PM ******/







/* REPORT : partywiseturnover
   file: partywiseturn.asp
   inserts data from a view called albmhist for those trades which settles in this settlement
*/
CREATE PROCEDURE rpt_albmwparties

@wsettno varchar(7)

AS


delete  from albmwparty
insert into albmwparty select distinct party_code, cl_code from albmhist where  sett_no=@wsettno and ser <> '01'

GO
