-- Object: PROCEDURE dbo.rpt_nodel
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_nodel    Script Date: 04/27/2001 4:32:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_nodel    Script Date: 3/21/01 12:50:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_nodel    Script Date: 20-Mar-01 11:39:01 PM ******/

/****** Object:  Stored Procedure dbo.rpt_nodel    Script Date: 2/5/01 12:06:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_nodel    Script Date: 12/27/00 8:58:56 PM ******/

/* report : nodelivery calendar
   file : dispinput.asp
*/
/* displays list of nodelivery scrips for a particular settlement and type */
CREATE PROCEDURE rpt_nodel
@settype varchar(3)
AS
select distinct sett_no, end_date from sett_mst  where sett_type = @settype
order by end_date desc

GO
