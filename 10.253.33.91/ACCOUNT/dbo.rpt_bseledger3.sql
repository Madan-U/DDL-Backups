-- Object: PROCEDURE dbo.rpt_bseledger3
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_bseledger3    Script Date: 01/04/1980 1:40:40 AM ******/



/****** Object:  Stored Procedure dbo.rpt_bseledger3    Script Date: 11/28/2001 12:23:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger3    Script Date: 29-Sep-01 8:12:06 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger3    Script Date: 8/8/01 1:37:31 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger3    Script Date: 8/7/01 6:03:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger3    Script Date: 7/8/01 3:22:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger3    Script Date: 2/17/01 3:34:16 PM ******/


/****** Object:  Stored Procedure dbo.rpt_bseledger3    Script Date: 20-Mar-01 11:43:34 PM ******/

/* Report : Confirmation Report
   File : Tconfirmationreport.asp
   Displays the bankname,refno, cltcode for a particular client
*/
CREATE PROCEDURE rpt_bseledger3
@refno varchar(12),
@cltcode varchar(10)
AS
SELECT BNKNAME, L.REFNO, L.CLTCODE FROM LEDGER L, LEDGER1 L1 
WHERE l1.REFNO=@refno  and l.vtyp='15' and cltcode=@cltcode
and left(l.refno,7)=left(l1.refno,7)

GO
