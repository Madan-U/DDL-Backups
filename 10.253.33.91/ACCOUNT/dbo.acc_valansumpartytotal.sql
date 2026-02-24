-- Object: PROCEDURE dbo.acc_valansumpartytotal
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


CREATE PROC acc_valansumpartytotal
@branchcd as varchar(10),
@opendate as varchar(11),
@closdate as varchar(11),
@vtyp smallint,
@booktype varchar(2),
@vno  varchar(12),
@reportoption char(1),
@baloption char(1),
@sortby varchar(10)
as

if rtrim(@branchcd) = '%' 
   begin
	select dramt = isnull(sum((case when upper(drcr) = 'D' then vamt else 0 end )),0),
	cramt = isnull(sum((case when upper(drcr) = 'C' then vamt else 0 end )),0) 
	from ledger l left outer join acmast a on l.cltcode = a.cltcode 
	where ( a.accat = '4'  or a.accat = '104' )
	and l.vtyp= @vtyp and l.booktype = @booktype and l.vno = @vno 
   end
else
   begin
	select dramt = isnull(sum((case when upper(drcr) = 'D' then camt else 0 end )),0),
	cramt = isnull(sum((case when upper(drcr) = 'C' then camt else 0 end )),0) 
	from ledger2 l2 left outer join acmast a on l2.cltcode = a.cltcode, costmast c 
	where a.accat = '4' 
	and l2.vtype= @vtyp and l2.booktype = @booktype and l2.vno = @vno 
	and l2.costcode = c.costcode and c.costname = rtrim(@branchcd)
   end

GO
