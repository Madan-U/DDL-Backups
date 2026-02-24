-- Object: PROCEDURE dbo.cumbaldetailledger
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.cumbaldetailledger    Script Date: 01/04/1980 1:40:36 AM ******/



/****** Object:  Stored Procedure dbo.cumbaldetailledger    Script Date: 11/28/2001 12:23:42 PM ******/

/****** Object:  Stored Procedure dbo.cumbaldetailledger    Script Date: 29-Sep-01 8:12:03 PM ******/

/****** Object:  Stored Procedure dbo.cumbaldetailledger    Script Date: 8/8/01 1:37:30 PM ******/

/****** Object:  Stored Procedure dbo.cumbaldetailledger    Script Date: 8/7/01 6:03:48 PM ******/

/****** Object:  Stored Procedure dbo.cumbaldetailledger    Script Date: 7/8/01 3:22:48 PM ******/

/****** Object:  Stored Procedure dbo.cumbaldetailledger    Script Date: 2/17/01 3:34:14 PM ******/


/****** Object:  Stored Procedure dbo.cumbaldetailledger    Script Date: 20-Mar-01 11:43:33 PM ******/

CREATE PROCEDURE cumbaldetailledger
@partycode varchar(10)
 AS
select convert(varchar,VDT,103), refno, vtyp,dramt=isnull((case drcr when 'd' then vamt end),0),
cramt=isnull((case drcr when 'c' then vamt end),0), balamt,Vdesc,
nar=isnull((select l3.narr from ledger3 l3 where l3.refno=left(ledger.refno,7)),'') 
from ledger , vmast WHERE VDT <= getdate()+ "11:59PM" and 
CLTCODE=@partycode and ledger.vtyp=vmast.vtype order by vdt, drcr,vtyp

GO
