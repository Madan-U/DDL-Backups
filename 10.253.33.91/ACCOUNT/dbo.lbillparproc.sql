-- Object: PROCEDURE dbo.lbillparproc
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.lbillparproc    Script Date: 01/04/1980 1:40:38 AM ******/



/****** Object:  Stored Procedure dbo.lbillparproc    Script Date: 11/28/2001 12:23:44 PM ******/

/****** Object:  Stored Procedure dbo.lbillparproc    Script Date: 29-Sep-01 8:12:04 PM ******/

/****** Object:  Stored Procedure dbo.lbillparproc    Script Date: 8/8/01 1:37:30 PM ******/

/****** Object:  Stored Procedure dbo.lbillparproc    Script Date: 8/7/01 6:03:49 PM ******/

/****** Object:  Stored Procedure dbo.lbillparproc    Script Date: 7/8/01 3:22:49 PM ******/

/****** Object:  Stored Procedure dbo.lbillparproc    Script Date: 2/17/01 3:34:15 PM ******/


/****** Object:  Stored Procedure dbo.lbillparproc    Script Date: 20-Mar-01 11:43:33 PM ******/

/*This procedure gets bnkname field from which sett no, sett type , billno can be extracted */
create procedure lbillparproc @reno varchar(12), @vtype smallint , @code varchar(10) as
SELECT BNKNAME, L.REFNO, L.CLTCODE FROM LEDGER L, LEDGER1 L1 WHERE
l1.REFNO=@reno and l.vtyp=@vtype and cltcode=@code and 
left(l.refno,7)=left(l1.refno,7) 
return

GO
