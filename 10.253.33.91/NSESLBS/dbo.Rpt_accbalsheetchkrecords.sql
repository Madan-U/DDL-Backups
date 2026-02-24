-- Object: PROCEDURE dbo.Rpt_accbalsheetchkrecords
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure Dbo.rpt_accbalsheetchkrecords    Script Date: 01/15/2005 1:25:32 Pm ******/

/****** Object:  Stored Procedure Dbo.rpt_accbalsheetchkrecords    Script Date: 12/16/2003 2:31:40 Pm ******/
Create Procedure Rpt_accbalsheetchkrecords

@incomeorexp Char(1),
@statusid Char(15),
@statuname Char(15)



As


Select Count(*) From Account.dbo.acmast A, Account.dbo.ledger L 
Where A.cltcode=l.cltcode And A.grpcode Like @incomeorexp+ '%'

GO
