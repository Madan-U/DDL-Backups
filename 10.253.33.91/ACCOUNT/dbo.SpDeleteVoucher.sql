-- Object: PROCEDURE dbo.SpDeleteVoucher
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SpDeleteVoucher    Script Date: 01/04/1980 1:40:43 AM ******/


/****** Object:  Stored Procedure dbo.SpDeleteVoucher    Script Date: 12/12/2001 6:42:36 PM ******/
/*deletes a voucher entry from ledger,ledger1,ledger3 table  depending on the vtyp passed */


CREATE PROCEDURE SpDeleteVoucher
@vtyp  smallint,
@vno varchar(12),
@booktype varchar(2)
AS

delete from ledger    where vtyp = @vtyp and vno = @vno and booktype = @booktype
delete from ledger1  where vtyp = @vtyp and vno = @vno and booktype = @booktype
delete from ledger2  where vtype = @vtyp and vno = @vno and booktype = @booktype
delete from ledger3  where vtyp = @vtyp and vno = @vno and booktype = @booktype

GO
