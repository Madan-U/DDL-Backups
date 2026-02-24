-- Object: PROCEDURE dbo.rpt_bseledger7
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_bseledger7    Script Date: 04/27/2001 4:32:34 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger7    Script Date: 3/21/01 12:50:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger7    Script Date: 20-Mar-01 11:38:54 PM ******/


/*Modified by amolika on 2nd march'2001 : removed bsedb.dbo. & added account.dbo. to all accounts report*/
/* Report : Confirmation Report
   File : Tconfirmationreport.asp
   Displays the bankname, refno, cltcode for a particular client
*/
CREATE PROCEDURE rpt_bseledger7
@ourrefno varchar(12),
@partycode varchar(10)
AS
SELECT BNKNAME, L.REFNO, L.CLTCODE 
FROM account.dbo.LEDGER L, account.dbo.LEDGER1 L1 
WHERE l1.REFNO=@ourrefno
and l.vtyp='15' and cltcode=@partycode
and left(l.refno,7)=left(l1.refno,7)

GO
