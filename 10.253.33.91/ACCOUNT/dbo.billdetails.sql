-- Object: PROCEDURE dbo.billdetails
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.billdetails    Script Date: 01/04/1980 1:40:35 AM ******/



/****** Object:  Stored Procedure dbo.billdetails    Script Date: 11/28/2001 12:23:40 PM ******/

/****** Object:  Stored Procedure dbo.billdetails    Script Date: 29-Sep-01 8:12:02 PM ******/

/****** Object:  Stored Procedure dbo.billdetails    Script Date: 8/8/01 1:37:29 PM ******/

/****** Object:  Stored Procedure dbo.billdetails    Script Date: 8/7/01 6:03:47 PM ******/

/****** Object:  Stored Procedure dbo.billdetails    Script Date: 7/8/01 3:22:48 PM ******/

/****** Object:  Stored Procedure dbo.billdetails    Script Date: 2/17/01 3:34:13 PM ******/


/****** Object:  Stored Procedure dbo.billdetails    Script Date: 20-Mar-01 11:43:32 PM ******/

CREATE PROCEDURE billdetails
@ourrefno varchar(12),
@partycode varchar(10)
AS
SELECT BNKNAME, L.REFNO, L.CLTCODE FROM LEDGER L, LEDGER1 L1 
WHERE l1.REFNO=@ourrefno and l.vtyp='15' and cltcode=@partycode
and left(l.refno,7)=left(l1.refno,7)

GO
