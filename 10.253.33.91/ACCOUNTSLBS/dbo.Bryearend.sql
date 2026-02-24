-- Object: PROCEDURE dbo.Bryearend
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

/****** Object:  Stored Procedure dbo.Bryearend    Script Date: 05/10/2004 5:29:30 PM ******/
/****** Object:  Stored Procedure dbo.Bryearend    Script Date: 03/27/2003 11:33:03 AM ******/
/****** Object:  Stored Procedure dbo.Bryearend    Script Date: 02/18/2003 10:26:56 AM ******/
CREATE Procedure Bryearend
@sdtcur varchar(11),
@ldtcur varchar(11),
@vtyp   smallint,
@vno varchar(12),
@BookType char(2),
@vdt    datetime

AS

set transaction isolation level read uncommitted


declare
@@mainctrlac as varchar(10),
@@mainacname as varchar(100),
@@lno        as int,
@@costcode   as tinyint,
@@amt        as money,
@@rcursor    as cursor


select @@lno = ( select lno from ledger where vtyp = @vtyp and booktype = @booktype and vno = @vno and cltcode = '999999' )
select @@mainctrlac = ( select MainControlAc from branchaccounts where defaultac = 1)
select @@mainacname = ( select acname from acmast where cltcode = @@mainctrlac )

truncate table branchwiseclbal

insert into branchwiseclbal
select l2.cltcode, a.acname , costcode, balance=sum( case when upper(l2.drcr) = 'D' then camt else -camt end)
from ledger2 l2 left outer join acmast a on l2.cltcode = a.cltcode, ledger l
where l2.vtype = l.vtyp and l2.booktype = l.booktype and l2.vno = l.vno and l2.lno = l.lno
and l.vdt > = @sdtcur + ' 00:00:00' and l.vdt <= @ldtcur + ' 23:59:59'
and (a.actyp like 'ASS%' or a.actyp like 'LIAB%') and l2.cltcode not in (@@mainctrlac, '999999')
group by costcode, l2.cltcode, a.acname

set @@rcursor = cursor for
select costcode, sum(balance)
from branchwiseclbal
group by costcode

open @@rcursor
fetch next from @@rcursor 
into @@costcode, @@amt

while @@fetch_status = 0
begin
  insert into branchwiseclbal values( @@mainctrlac, @@mainacname, @@costcode, -(@@amt) )

  fetch next from @@rcursor 
  into @@costcode, @@amt
end

close @@rcursor
deallocate @@rcursor

insert into ledger2 
select l.vtyp, l.vno, l.lno, (case when balance >= 0 then 'D' else 'C' end), abs(balance), costcode, l.booktype, b.cltcode
from ledger l, branchwiseclbal b
where l.vtyp = @vtyp and l.booktype = @booktype and l.vno = @vno and l.cltcode = b.cltcode 

insert into ledger2 
select @vtyp, @vno, @@lno, (case when balance >= 0 then 'D' else 'C' end), abs(balance), costcode, @booktype, cltcode
from branchwiseclbal b
where cltcode in ( select brcontrolac from branchaccounts )

GO
