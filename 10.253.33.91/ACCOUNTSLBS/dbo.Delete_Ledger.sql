-- Object: PROCEDURE dbo.Delete_Ledger
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------


CREATE Procedure Delete_Ledger
@vno varchar(12)
as
delete from ledger where vtyp = '18' and booktype = '01' and vno= @vno

delete from ledger2 where vtype = '18' and booktype = '01' and vno= @vno

delete from ledger3 where vtyp = '18' and booktype = '01' and vno= @vno

delete from marginledger where vtyp = '18' and booktype = '01' and vno= @vno

GO
