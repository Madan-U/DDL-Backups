-- Object: PROCEDURE dbo.Spbilldrcrtotal
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.Spbilldrcrtotal    Script Date: 01/04/1980 1:40:43 AM ******/


/****** Object:  Stored Procedure dbo.Spbilldrcrtotal    Script Date: 12/12/2001 6:42:36 PM ******/
/* it gets the total dr and total cr for a particular voucher entry  ,used in transferbills*/

CREATE PROCEDURE  Spbilldrcrtotal  
@vtyp  smallint,
@vno  varchar(12),
@booktype varchar(2)

AS
select crtotal= isnull(sum(vamt),0), 
drtotal=isnull((select  sum(vamt) from ledger where drcr='d' and vtyp = @vtyp and vno = @vno and booktype = @booktype ) ,0)
from ledger 
where drcr='c' and  vtyp = @vtyp and vno = @vno and booktype = @booktype

GO
