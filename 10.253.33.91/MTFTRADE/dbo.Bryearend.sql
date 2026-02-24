-- Object: PROCEDURE dbo.Bryearend
-- Server: 10.253.33.91 | DB: MTFTRADE
--------------------------------------------------


CREATE Procedure [dbo].[Bryearend]   
@sdtcur varchar(11),  
@ldtcur varchar(11),  
@vtyp   smallint,  
@vno varchar(12),  
@BookType char(2),  
@vdt    datetime  
  
AS  
declare  
@@mainctrlac as varchar(10),  
@@mainacname as varchar(35),  
@@placname   as varchar(35),  
@@lno        as int,  
@@costcode   as int,  
@@ctrlac     as varchar(10),  
@@ctrlname   as varchar(35),  
@@amt        as money,  
@@maincc     as int,  
@@plamt      as money,  
@@rcursor    as cursor  
  
  
select @@lno = ( select lno from ledger where vtyp = @vtyp and booktype = @booktype and vno = @vno and cltcode = '99999' )  
select @@mainctrlac = ( select MainControlAc from branchaccounts where defaultac = 1)  
select @@mainacname = ( select acname from acmast where cltcode = @@mainctrlac )  
select @@maincc = ( select costcode from costmast, branchaccounts where defaultac = 1 and branchname = costname )  
select @@placname = ( select acname from acmast where cltcode = '99999' )  
  
truncate table branchwiseclbal  
  
insert into branchwiseclbal  
select l2.cltcode, a.acname , costcode, balance=sum( case when upper(l2.drcr) = 'D' then camt else -camt end)  
from ledger2 l2 left outer join acmast a on l2.cltcode = a.cltcode, ledger l  
where l2.vtype = l.vtyp and l2.booktype = l.booktype and l2.vno = l.vno and l2.lno = l.lno  
and l.vdt > = @sdtcur + ' 00:00:00' and l.vdt <= @ldtcur + ' 23:59:59'  
and (a.actyp like 'ASS%' or a.actyp like 'LIAB%')   
group by costcode, l2.cltcode, a.acname  
  
delete from branchwiseclbal where cltcode in (select brcontrolac from branchaccounts)  
delete from branchwiseclbal where cltcode = '99999'  
  
set @@rcursor = cursor for  
select b.costcode, brcontrolac, a.acname, sum(balance)  
from branchwiseclbal b, costmast c, branchaccounts ba, acmast a  
where b.costcode = c.costcode and c.costname = ba.branchname and ba.brcontrolac = a.cltcode  
group by b.costcode, brcontrolac, a.acname  
order by b.costcode, brcontrolac, a.acname  
  
open @@rcursor  
fetch next from @@rcursor   
into @@costcode, @@ctrlac, @@ctrlname, @@amt  
  
while @@fetch_status = 0  
begin  
  if @@costcode <> @@maincc  
/*     begin  
        insert into branchwiseclbal values( '99999', @@placname, @@costcode, -(@@amt) )  
     end  
  else */  
     begin  
        insert into branchwiseclbal values( @@mainctrlac, @@mainacname, @@costcode, -(@@amt) )  
        insert into branchwiseclbal values( @@ctrlac, @@ctrlname, @@maincc, (@@amt) )  
     end  
  
  fetch next from @@rcursor   
  into @@costcode, @@ctrlac, @@ctrlname, @@amt  
end  
  
close @@rcursor  
deallocate @@rcursor  
  
select @@plamt = ( select sum(balance) from branchwiseclbal where costcode = @@maincc )  
/* print convert(varchar,@@plamt) */  
insert into branchwiseclbal values( '99999', @@placname, @@maincc, -(@@plamt) )  
  
insert into ledger2  
select l.vtyp, l.vno, l.lno, ( Case when balance >= 0 then 'D' else 'C' end),  
abs(balance), costcode, l.booktype, b.cltcode  
from ledger l, branchwiseclbal b  
where l.vtyp = @vtyp and l.booktype = @booktype and l.vno = @vno and l.cltcode = b.cltcode  
and b.cltcode not in ( select brcontrolac from branchaccounts )  
  
insert into ledger2   
select @vtyp, @vno, @@lno, (case when balance >= 0 then 'D' else 'C' end), abs(balance), costcode, @booktype, cltcode  
from branchwiseclbal b  
where cltcode in ( select brcontrolac from branchaccounts )

GO
