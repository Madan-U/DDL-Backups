-- Object: PROCEDURE dbo.rpt_acccostsumchecklevel
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_acccostsumchecklevel    Script Date: 01/19/2002 12:15:11 ******/

/****** Object:  Stored Procedure dbo.rpt_acccostsumchecklevel    Script Date: 01/04/1980 5:06:25 AM ******/


/*
  checks whether there is any level below selected level	
*/

CREATE PROCEDURE  rpt_acccostsumchecklevel

@grpcode varchar(20),
@nextgrpcode varchar(20)



AS

select grpcode from account.dbo.costmast where grpcode like @nextgrpcode and grpcode not like @grpcode

GO
