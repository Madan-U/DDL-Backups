-- Object: PROCEDURE dbo.rpt_tempclrate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_tempclrate    Script Date: 04/27/2001 4:32:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_tempclrate    Script Date: 3/21/01 12:50:24 PM ******/

/****** Object:  Stored Procedure dbo.rpt_tempclrate    Script Date: 20-Mar-01 11:39:03 PM ******/

/****** Object:  Stored Procedure dbo.rpt_tempclrate    Script Date: 2/5/01 12:06:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_tempclrate    Script Date: 12/27/00 8:59:14 PM ******/
/* report : newmtom report 
   file :mtomrepot.asp
   selects closing rate for a particular scrip and series  */
CREATE PROCEDURE rpt_tempclrate
@scripcd varchar(21),
@series varchar(3)
AS
select isnull(cl_rate,0) from closing 
where scrip_cd like  ltrim(@scripcd)+'%' and series like ltrim(@series)+'%'
and MARKET = 'NORMAL' and Sysdate like left(convert(varchar,getdate(),109),11) + '%'

GO
