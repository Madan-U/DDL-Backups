-- Object: PROCEDURE dbo.rpt_nextsettno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_nextsettno    Script Date: 04/27/2001 4:32:46 PM ******/





/****** Object:  Stored Procedure dbo.rpt_nextsettno    Script Date: 2/5/01 12:06:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_nextsettno    Script Date: 12/27/00 8:58:56 PM ******/


/****** Object:  Stored Procedure dbo.rpt_nextsettno    Script Date: 1/6/2001 3:59:12 PM ******/



/* report : bill report
   file : billreport.asp
   gives next settlement number 
*/
CREATE PROCEDURE rpt_nextsettno 
@settno varchar(7)
AS


select distinct sett_no+1  from history where sett_no=@settno
union
select distinct sett_no +1 from settlement where sett_no=@settno

GO
