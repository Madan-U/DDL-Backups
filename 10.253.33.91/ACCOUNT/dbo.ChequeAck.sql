-- Object: PROCEDURE dbo.ChequeAck
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ChequeAck    Script Date: 01/04/1980 1:40:36 AM ******/



/****** Object:  Stored Procedure dbo.ChequeAck    Script Date: 11/28/2001 12:23:42 PM ******/

/****** Object:  Stored Procedure dbo.ChequeAck    Script Date: 29-Sep-01 8:12:03 PM ******/

/****** Object:  Stored Procedure dbo.ChequeAck    Script Date: 8/8/01 1:37:29 PM ******/

/****** Object:  Stored Procedure dbo.ChequeAck    Script Date: 8/7/01 6:03:48 PM ******/

/****** Object:  Stored Procedure dbo.ChequeAck    Script Date: 7/8/01 3:22:48 PM ******/

/****** Object:  Stored Procedure dbo.ChequeAck    Script Date: 2/17/01 3:34:14 PM ******/


/****** Object:  Stored Procedure dbo.ChequeAck    Script Date: 20-Mar-01 11:43:32 PM ******/

/*
control name  : ChqAckPrintCtl
Use : To get all chequet details  in order to print receipt
Written by : Kalpana
Date : 14/02/2001
*/
CREATE PROCEDURE ChequeAck
@ReceiptNo integer
AS
select l1.receiptno, acname ,vamt ,bnkname ,dddt ,ddno,brnname ,l.vno,l.vtyp, l.lno,l.drcr ,narr
from ledger1 l1,ledger l , ledger3 l3
where receiptno = @ReceiptNo and l.vno = l1.vno and l.vtyp = l1.vtyp and l.lno = l1.lno and  l.drcr = 'c'  and l.vtyp = '2'
 and l.vno = l3.vno 
 and l.vtyp = l3.vtyp

GO
