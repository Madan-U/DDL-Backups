-- Object: PROCEDURE dbo.getLedgerAmount
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.getLedgerAmount    Script Date: 3/17/01 9:55:52 PM ******/

/****** Object:  Stored Procedure dbo.getLedgerAmount    Script Date: 3/21/01 12:50:09 PM ******/

/****** Object:  Stored Procedure dbo.getLedgerAmount    Script Date: 20-Mar-01 11:38:51 PM ******/

/****** Object:  Stored Procedure dbo.getLedgerAmount    Script Date: 2/5/01 12:06:13 PM ******/

/****** Object:  Stored Procedure dbo.getLedgerAmount    Script Date: 12/27/00 8:58:51 PM ******/

CREATE PROCEDURE getLedgerAmount(@partycode varchar(10)) AS
select l.cltcode , Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode and vdt <= GETDATE())- 
(select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode and vdt <= GETDATE()) 
From Ledger l 
where vdt <= GETDATE()
and cltcode = @partycode
group by l.Cltcode, l.acname 
/* This procedure is written to get the ledger amount which is used for MTOM report */

GO
