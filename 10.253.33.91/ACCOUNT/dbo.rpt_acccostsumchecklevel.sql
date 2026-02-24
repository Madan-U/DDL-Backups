-- Object: PROCEDURE dbo.rpt_acccostsumchecklevel
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_acccostsumchecklevel    Script Date: 01/04/1980 1:40:39 AM ******/



/*
  checks whether there is any level below selected level	
*/

CREATE PROCEDURE  rpt_acccostsumchecklevel

@grpcode varchar(20),
@nextgrpcode varchar(20)



AS

select grpcode from account.dbo.costmast where grpcode like @nextgrpcode and grpcode not like @grpcode

GO
