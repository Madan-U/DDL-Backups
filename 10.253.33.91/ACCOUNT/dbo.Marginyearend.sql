-- Object: PROCEDURE dbo.Marginyearend
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

/****** Object:  Stored Procedure dbo.Marginyearend    Script Date: 03/28/2003 4:34:58 PM ******/
CREATE Procedure Marginyearend
@sdtcur varchar(11),
@ldtcur varchar(11),
@vtyp   smallint,
@vno varchar(12),
@BookType char(2),
@vdt    datetime

as
declare
@@cltcode  as varchar(10),
@@lno      as int,
@@rcursor  as cursor

insert into marginledger
select @vtyp, @vno, 0, (case when t.bal >= 0 then 'D' else 'C' end), @vdt, abs(t.bal), t.party_code,
t.exchange, rtrim(t.segment), 0, '', @booktype, t.mcltcode
from
(select mcltcode, exchange, segment, party_code, bal=sum( case when upper(drcr) = 'D' then amount else -amount end)
from marginledger where vdt >= @sdtcur + ' 00:00:00' and vdt <= @ldtcur + ' 23:59:59'
group by mcltcode, exchange, segment, party_code) t


set @@rcursor = cursor for
select cltcode, lno from ledger where vtyp = @vtyp and booktype = @booktype and vno = @vno
order by cltcode

open @@rcursor
fetch next from @@rcursor 
into @@cltcode, @@lno

while @@fetch_status = 0
begin
   update marginledger set lno = @@lno where vtyp = @vtyp and booktype = @booktype and vno = @vno and mcltcode = @@cltcode

   fetch next from @@rcursor 
   into @@cltcode, @@lno
end

close @@rcursor
deallocate @@rcursor

/* For effective datewise Margin O/p Balances */

update marginledger set sett_no = t.bal
from
(
select mcltcode, exchange, segment, party_code, bal=sum( case when upper(m.drcr) = 'D' then amount else -amount end)
from marginledger m, ledger l
where m.vtyp = l.vtyp and m.booktype = l.booktype and m.vno = l.vno and m.lno = l.lno
and l.edt >= @sdtcur + ' 00:00:00'and l.edt <= @ldtcur + ' 23:59:59'
group by mcltcode, exchange, segment, party_code) t
where marginledger.mcltcode = t.mcltcode and marginledger.exchange = t.exchange and marginledger.segment=t.segment
and marginledger.party_code = t.party_code and marginledger.vtyp = 18

GO
