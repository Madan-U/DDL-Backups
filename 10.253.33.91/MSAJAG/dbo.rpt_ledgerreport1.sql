-- Object: PROCEDURE dbo.rpt_ledgerreport1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_ledgerreport1    Script Date: 01/19/2002 12:15:15 ******/

/****** Object:  Stored Procedure dbo.rpt_ledgerreport1    Script Date: 12/26/2001 1:23:34 PM ******/
create procedure rpt_ledgerreport1

@partycode as varchar(20),
@estart as varchar(20),
@eenddt as varchar(20),
@acat as int

as

select distinct condt= (case when l1.reldt like 'Jan  1 1900%' then 'Uncleared' else left(convert(varchar,l1.reldt,106),11) end),
l.cltcode,l.acname,left(convert(varchar,l.edt,106),11) as edt,l.vtyp,l.vno,l1.ddno,ltrim(l3.narr),l.drcr,l.vamt,ac.accat,l.edt as edt1
from account.dbo.ledger l,account.dbo.ledger3 l3,account.dbo.ledger1 l1,account.dbo.acmast ac
where l3.vtyp=l.vtyp
and l3.vno=l.vno
and l1.vtyp = l.vtyp
and l1.vno = l.vno
and l1.vtyp = l3.vtyp
and l1.vno = l3.vno
and ac.cltcode = l.cltcode
and ac.accat = @acat
and l.cltcode like @partycode
and l.edt >= @estart
and l.edt <= @eenddt+' 23:59:59'
/*and l1.reldt like 'Jan  1 1900%'*/
order by 1 desc,l.cltcode,l.edt,l.vno

GO
