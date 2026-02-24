-- Object: PROCEDURE dbo.rpt_wnextsettno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_wnextsettno    Script Date: 04/27/2001 4:32:51 PM ******/


/****** Object:  Stored Procedure dbo.rpt_wnextsettno    Script Date: 04/21/2001 6:05:34 PM ******/

/****** Object:  Stored Procedure dbo.rpt_wnextsettno    Script Date: 3/21/01 12:50:25 PM ******/

/****** Object:  Stored Procedure dbo.rpt_wnextsettno    Script Date: 20-Mar-01 11:39:04 PM ******/







/* report : bill report
   file : billreport.asp
   gives next settlement number 
*/
CREATE PROCEDURE rpt_wnextsettno 
@settno varchar(7)
AS
/*
select distinct sett_no+1  from history where sett_no=@settno
union
select distinct sett_no +1 from settlement where sett_no=@settno
*/
select min(sett_no) from sett_mst where sett_no > @settno and sett_type = 'W'

GO
