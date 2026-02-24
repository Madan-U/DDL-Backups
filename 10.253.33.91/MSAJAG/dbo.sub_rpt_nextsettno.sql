-- Object: PROCEDURE dbo.sub_rpt_nextsettno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sub_rpt_nextsettno    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_nextsettno    Script Date: 3/21/01 12:50:32 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_nextsettno    Script Date: 20-Mar-01 11:39:10 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_nextsettno    Script Date: 2/5/01 12:06:29 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_nextsettno    Script Date: 12/27/00 8:59:17 PM ******/



/* report : subbill report
   file : billreport.asp
   gives next settlement number 
*/
CREATE PROCEDURE sub_rpt_nextsettno 
@settno varchar(7),
@settype varchar(3)
AS
select min(sett_no) from 
sett_mst where sett_no > @settno
 and sett_type = @settype

GO
