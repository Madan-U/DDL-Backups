-- Object: PROCEDURE dbo.rpt_nnextsettno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_nnextsettno    Script Date: 04/27/2001 4:32:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_nnextsettno    Script Date: 3/21/01 12:50:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_nnextsettno    Script Date: 20-Mar-01 11:39:01 PM ******/





/****** Object:  Stored Procedure dbo.rpt_nnextsettno    Script Date: 12/27/00 8:58:56 PM ******/
/* report : bill report
   file : billreport.asp
   gives next settlement number 
*/
CREATE PROCEDURE rpt_nnextsettno 
@settno varchar(7)
AS

select min(sett_no) from sett_mst where sett_no > @settno and sett_type = 'N'

/*
select distinct sett_no+1  from history where sett_no=@settno
union
select distinct sett_no +1 from settlement where sett_no=@settno
*/

GO
