-- Object: PROCEDURE dbo.bill1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.bill1    Script Date: 3/17/01 9:55:44 PM ******/

/****** Object:  Stored Procedure dbo.bill1    Script Date: 3/21/01 12:50:00 PM ******/

/****** Object:  Stored Procedure dbo.bill1    Script Date: 20-Mar-01 11:38:43 PM ******/
CREATE PROCEDURE bill1
@partycode varchar(10),
@settno varchar(7),
@settype varchar(3) 
AS
select l.vamt,l.drcr from account.dbo.ledger l,account.dbo.ledger1 l1 where l.refno=l1.refno
and l.cltcode=@partycode and l1.bnkname like @settno + @settype + '%'

GO
