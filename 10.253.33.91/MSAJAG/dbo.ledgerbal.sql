-- Object: PROCEDURE dbo.ledgerbal
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ledgerbal    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.ledgerbal    Script Date: 3/21/01 12:50:09 PM ******/

/****** Object:  Stored Procedure dbo.ledgerbal    Script Date: 20-Mar-01 11:38:51 PM ******/

/****** Object:  Stored Procedure dbo.ledgerbal    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.ledgerbal    Script Date: 12/27/00 8:58:51 PM ******/

CREATE PROCEDURE ledgerbal
@todt smalldatetime,
@partycode varchar(10)
as
select drtot=isnull((case drcr when 'd' then sum(vamt) end),0), crtot=isnull((case drcr when 'c' then sum(vamt) end),0) 
from account.dbo.ledger WHERE VDT <=@todt +'11:59PM' and CLTCODE=@partycode
group by drcr

GO
