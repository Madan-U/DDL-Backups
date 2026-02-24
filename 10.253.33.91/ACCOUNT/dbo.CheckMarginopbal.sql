-- Object: PROCEDURE dbo.CheckMarginopbal
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.CheckMarginopbal    Script Date: 04/13/2003 12:08:04 PM ******/
/****** Object:  Stored Procedure dbo.CheckMarginopbal    Script Date: 03/28/2003 4:33:12 PM ******/
CREATE Procedure CheckMarginopbal
@sdtcur varchar(11),
@ldtcur varchar(11),
@vtyp   smallint,
@vno varchar(12),
@BookType char(2),
@vdt    datetime

as

select l.lno, l.cltcode, amt=(case when upper(drcr) = 'D' then vamt else -vamt end), t.bal
from ledger l left outer join acmast a on l.cltcode = a.cltcode,
(select mcltcode, bal=sum( case when upper(drcr) = 'D' then amount else -amount end)
from marginledger where vdt >= @sdtcur + ' 00:00:00' and vdt <= @ldtcur + ' 23:59:59'
group by mcltcode) t
where l.vtyp = @vtyp and l.booktype = @booktype and l.vno = @vno
and vdt >= @sdtcur + ' 00:00:00' and vdt <= @ldtcur + ' 23:59:59'
and a.accat = 14 and t.mcltcode = l.cltcode and 
(case when upper(drcr) = 'D' then vamt else -vamt end) <> bal

GO
