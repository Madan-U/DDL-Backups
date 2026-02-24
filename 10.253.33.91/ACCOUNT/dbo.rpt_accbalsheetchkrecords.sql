-- Object: PROCEDURE dbo.rpt_accbalsheetchkrecords
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_accbalsheetchkrecords    Script Date: 01/04/1980 1:40:39 AM ******/


/* checks whether there are any records for aseets or expenses or not */


CREATE PROCEDURE rpt_accbalsheetchkrecords

@incomeorexp char(1)

AS


select count(*) from account.dbo.acmast a, account.dbo.ledger l 
where a.cltcode=l.cltcode and a.grpcode like @incomeorexp+ '%'

GO
