-- Object: PROCEDURE dbo.rpt_albmwuserid
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_albmwuserid    Script Date: 04/27/2001 4:32:33 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmwuserid    Script Date: 3/21/01 12:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmwuserid    Script Date: 20-Mar-01 11:38:53 PM ******/



/* 
report : userid turnover
file : useridturn.asp
fills a table with userids's  whose trades are getting settled in this current w albm  settlement
*/
CREATE PROCEDURE rpt_albmwuserid

@wsettno varchar(7)

AS


delete  from albmwuserid
insert into albmwuserid select * from albmhist where  sett_no=@wsettno and ser <> '01'

GO
