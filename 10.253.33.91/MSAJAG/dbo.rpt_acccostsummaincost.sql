-- Object: PROCEDURE dbo.rpt_acccostsummaincost
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_acccostsummaincost    Script Date: 01/19/2002 12:15:11 ******/

/****** Object:  Stored Procedure dbo.rpt_acccostsummaincost    Script Date: 01/04/1980 5:06:25 AM ******/


/*cost center summary */
/* finds main cost centers from costmast */
CREATE PROCEDURE rpt_acccostsummaincost

@catcode smallint 

AS
select catcode,grpcode,costname,costcode from account.dbo.costmast
where right(grpcode,8) = '00000000'
and catcode=@catcode
order by catcode,costname,costcode,grpcode

GO
