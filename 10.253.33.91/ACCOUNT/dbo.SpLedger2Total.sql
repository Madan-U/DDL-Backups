-- Object: PROCEDURE dbo.SpLedger2Total
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE Procedure  SpLedger2Total 
@vtyp  smallint,
@vno  varchar(12),
@booktype varchar(2)

AS
select sum( case when upper(drcr)='D' then camt else -camt end)
from ledger2 where vtype = @vtyp and vno = @vno and booktype = @booktype

GO
