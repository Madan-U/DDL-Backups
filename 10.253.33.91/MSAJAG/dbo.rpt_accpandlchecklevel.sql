-- Object: PROCEDURE dbo.rpt_accpandlchecklevel
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_accpandlchecklevel    Script Date: 01/19/2002 12:15:11 ******/

/****** Object:  Stored Procedure dbo.rpt_accpandlchecklevel    Script Date: 01/04/1980 5:06:25 AM ******/


/*
  checks whether there is any level below selected level	
*/

CREATE PROCEDURE  rpt_accpandlchecklevel

@grpcode varchar(20),
@nextgrpcode varchar(20)



AS

select distinct g.grpcode from account.dbo.grpmast g, account.dbo.acmast a
where g.grpcode like @nextgrpcode and g.grpcode not like @grpcode
and a.grpcode=g.grpcode

GO
