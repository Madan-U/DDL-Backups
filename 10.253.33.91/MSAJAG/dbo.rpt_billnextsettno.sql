-- Object: PROCEDURE dbo.rpt_billnextsettno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_billnextsettno    Script Date: 04/27/2001 4:32:33 PM ******/

/****** Object:  Stored Procedure dbo.rpt_billnextsettno    Script Date: 3/21/01 12:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_billnextsettno    Script Date: 20-Mar-01 11:38:54 PM ******/

/****** Object:  Stored Procedure dbo.rpt_billnextsettno    Script Date: 2/5/01 12:06:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_billnextsettno    Script Date: 12/27/00 8:59:17 PM ******/
/* report : bill report
   file : billreport.asp
   gives next settlement number 
*/
CREATE PROCEDURE rpt_billnextsettno 
@settno varchar(7)
AS
select Min(sett_no) from sett_mst where  sett_no > @settno and sett_type = 'N'

GO
