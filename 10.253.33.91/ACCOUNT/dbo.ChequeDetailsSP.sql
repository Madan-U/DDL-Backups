-- Object: PROCEDURE dbo.ChequeDetailsSP
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


CREATE Proc ChequeDetailsSP 
@cltcode varchar(10),
@option varchar(2),
@vdt varchar(11)
As
select acname , bnkname = isnull(bnkname,''), brnname = isnull(brnname,'') 
,vamt=relamt, ddno = isnull(ddno,'') , l.vtyp, l.vno, l.lno, l.drcr, vdt = left(convert(varchar, l.vdt,103),10), l.booktype, l.cltcode
from ledger l, ledger1 l1 
where  l1.vtyp=l.vtyp and l1.vno=l.vno and l.lno = l1.lno
and l.vtyp in (select vtyp from ledger 
where l.vtyp = vtyp and l.vno = vno and l.booktype = booktype and vtyp ='2' and cltcode =@cltcode) 
 and l.vno in (select vno from ledger where l.vtyp = vtyp and l.vno = vno and l.booktype = booktype and ( vtyp = '2' or vtyp = '5' ) and cltcode =@cltcode) 
 and clear_mode like @option and l.cltcode <> @cltcode and l.vdt like @vdt + '%' and l.booktype=l1.booktype and (slipno =0 or slipno = '')
union all
select a.acname ,bnkname  = isnull(bnkname,'') , brnname  = isnull(brnname,'') , vamt=relamt,ddno = isnull(ddno,'') ,
l.vtyp, l.vno, l.lno, l.drcr, vdt = left(convert(varchar, l.vdt,103),10) , l.booktype, m.party_code
from ledger l, ledger1 l1, marginledger m, acmast a
where  l1.vtyp=l.vtyp and l1.vno=l.vno and l.lno = l1.lno
and l.vtyp in (select vtyp from ledger where
 l.vtyp = vtyp and l.vno = vno and l.booktype = booktype and vtyp ='19' and cltcode =@cltcode) 
and l.vno in (select vno from ledger where l.vtyp = vtyp and l.vno = vno and l.booktype = booktype and vtyp ='19'  and cltcode =@cltcode) 
and clear_mode like @option and l.cltcode <> @cltcode and l.vdt like @vdt+ '%'
and m.vtyp = l.vtyp and m.booktype = l.booktype and m.vno = l.vno 
and m.lno = l.lno and a.cltcode = m.party_code and l.booktype=l1.booktype and (slipno =0 or slipno = '')
order by l.vno, l.lno

GO
