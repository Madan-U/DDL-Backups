-- Object: PROCEDURE dbo.rpt_accbalsheetchkrecords
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/****** Object:  Stored Procedure dbo.rpt_accbalsheetchkrecords    Script Date: 01/19/2002 12:15:11 ******/

/****** Object:  Stored Procedure dbo.rpt_accbalsheetchkrecords    Script Date: 01/04/1980 5:06:24 AM ******/
/* checks whether there are any records for aseets or expenses or not */
CREATE PROCEDURE rpt_accbalsheetchkrecords
@incomeorexp char(1),
@statusid varchar(30),
@statusname varchar(30)

AS


select count(*) from account.dbo.acmast a, account.dbo.ledger l 
where a.cltcode=l.cltcode and a.grpcode like @incomeorexp

GO
