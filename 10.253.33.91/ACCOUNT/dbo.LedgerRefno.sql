-- Object: PROCEDURE dbo.LedgerRefno
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.LedgerRefno    Script Date: 01/04/1980 1:40:38 AM ******/



/****** Object:  Stored Procedure dbo.LedgerRefno    Script Date: 11/28/2001 12:23:45 PM ******/

/****** Object:  Stored Procedure dbo.LedgerRefno    Script Date: 29-Sep-01 8:12:05 PM ******/

/****** Object:  Stored Procedure dbo.LedgerRefno    Script Date: 8/8/01 1:37:30 PM ******/

/****** Object:  Stored Procedure dbo.LedgerRefno    Script Date: 8/7/01 6:03:49 PM ******/

/****** Object:  Stored Procedure dbo.LedgerRefno    Script Date: 7/8/01 3:22:49 PM ******/

/****** Object:  Stored Procedure dbo.LedgerRefno    Script Date: 2/17/01 3:34:15 PM ******/


/****** Object:  Stored Procedure dbo.LedgerRefno    Script Date: 20-Mar-01 11:43:34 PM ******/

/* THIS PROCEDURE UPDATES THE LEDGERTEMP TABLE WITH THE MAX OF THE VNO AND VNO1 FOR A PARTICULAR VOUCHER TYPE*/
CREATE proc LedgerRefno 
@inpgvptype smallint
/*@refno varchar(12)  OUTPUT*/
as
declare @@tempvno int,
@@tempvno1 int
select vno,vno1 from ledgertemp  where vtype = @inpgvptype
update ledgertemp set vno = vno + 1,vno1 = vno1 + 1 where vtype = @inpgvptype

GO
