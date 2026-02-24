-- Object: PROCEDURE dbo.insertfromaccbill
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

create proc insertfromaccbill
as
select vtype=15, vno=200108270063, lno, drcr=(case when sell_buy = 1 then 'd' else 'c' end), amount, costcode, booktype
from ledger l, msajag.dbo.accbill b, costmast c
where sett_no = '2001091' and sett_type = 'N' and branchcd <> 'ZZZ'
and vtyp = 15 and vno = 200108270063
and vdt = '2001-10-04 23:59:59.000' and l.cltcode = b.party_code
and branchcd = costname

GO
