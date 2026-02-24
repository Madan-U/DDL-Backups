-- Object: PROCEDURE dbo.rpt_mtomclrate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_mtomclrate    Script Date: 04/27/2001 4:32:45 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomclrate    Script Date: 3/21/01 12:50:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomclrate    Script Date: 20-Mar-01 11:39:00 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomclrate    Script Date: 2/5/01 12:06:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomclrate    Script Date: 12/27/00 8:59:13 PM ******/


/* report :  newmtom 
    file : mtom50.asp
    displays closing rate for a scrip
*/ 
CREATE PROCEDURE rpt_mtomclrate
@scripcd varchar(12),
@series varchar(3)
AS
select Cl_Rate from closing where scrip_cd = @scripcd and series = @series  and MARKET='NORMAL'

GO
