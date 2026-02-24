-- Object: PROCEDURE dbo.getLedgerAmt
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.getLedgerAmt    Script Date: 01/04/1980 1:40:37 AM ******/



/****** Object:  Stored Procedure dbo.getLedgerAmt    Script Date: 11/28/2001 12:23:44 PM ******/

/****** Object:  Stored Procedure dbo.getLedgerAmt    Script Date: 29-Sep-01 8:12:04 PM ******/

/****** Object:  Stored Procedure dbo.getLedgerAmt    Script Date: 8/8/01 1:37:30 PM ******/

/****** Object:  Stored Procedure dbo.getLedgerAmt    Script Date: 8/7/01 6:03:49 PM ******/

/****** Object:  Stored Procedure dbo.getLedgerAmt    Script Date: 7/8/01 3:22:49 PM ******/

/****** Object:  Stored Procedure dbo.getLedgerAmt    Script Date: 2/17/01 3:34:15 PM ******/


/****** Object:  Stored Procedure dbo.getLedgerAmt    Script Date: 20-Mar-01 11:43:33 PM ******/

CREATE PROCEDURE  getLedgerAmt   @partycode  varchar(10) ,@getdate  varchar(20)
AS
  select l.cltcode ,Amount  = ( select isnull(sum(vamt),0) from ledger 
 where drcr = 'D' and cltcode = l.cltcode and vdt <= @getdate)
 - (select isnull(sum(vamt),0) from ledger where drcr = 'C' and 
 cltcode = l.cltcode and vdt <= @getdate) From Ledger l 
 where vdt <= @getdate  and l.cltcode = @partycode  group by l.Cltcode, l.acname

GO
