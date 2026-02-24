-- Object: PROCEDURE dbo.Edtyearend
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

/****** Object:  Stored Procedure dbo.Edtyearend    Script Date: 03/27/2003 11:33:03 AM ******/
/****** Object:  Stored Procedure dbo.Edtyearend    Script Date: 02/18/2003 10:26:56 AM ******/
CREATE Procedure Edtyearend
@sdtcur varchar(11),
@ldtcur varchar(11),
@vtyp   smallint,
@vno varchar(12),
@BookType char(2),
@vdt    datetime,
@msg1   varchar(234)
AS
declare
@@netdiff as money


truncate table edtclbal

insert into edtclbal
select l.cltcode,l.acname , balance=isnull(sum( case when upper(drcr) = 'D' then vamt else -vamt end),0)
from ledger l left outer join acmast a on l.cltcode = a.cltcode
where l.edt > = @sdtcur + ' 00:00:00' and l.edt <= @ldtcur + ' 23:59:59'
and (a.actyp like 'ASS%' or a.actyp like 'LIAB%') and l.cltcode <> '99999'
group by l.cltcode,l.acname
order by l.cltcode,l.acname

update ledger set balamt = e.balance from edtclbal e
where ledger.vtyp = @vtyp and ledger.booktype = @booktype and ledger.vno = @vno and ledger.cltcode = e.cltcode

select @@netdiff = ( select sum(balance) from edtclbal )

update ledger set balamt = isnull( case when @@netdiff > = 0 then -(@@netdiff) else abs(@@netdiff) end,0)
where vtyp = @vtyp and booktype = @booktype and vno = @vno and cltcode = '99999'

GO
