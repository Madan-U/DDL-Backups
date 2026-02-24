-- Object: PROCEDURE dbo.rpt_acccostsummaincost
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_acccostsummaincost    Script Date: 01/04/1980 1:40:39 AM ******/



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
