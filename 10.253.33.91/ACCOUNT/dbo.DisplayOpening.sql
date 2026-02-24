-- Object: PROCEDURE dbo.DisplayOpening
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


CREATE Proc DisplayOpening
As

select vtyp,l.vno,l.lno,acname,cltcode, l2.drcr, vamt = camt ,
costcode= isnull((Select costcode from costmast  where costcode = l2.costcode),''),
branch = isnull((Select costname from costmast  where costcode = l2.costcode),'')
 from ledger l,ledger2 l2 , parameter where vtyp = 18  and vdt = sdtcur and curyear = 1
and vtype = vtyp and l2.vno = l.vno and l2.lno = l.lno

union all

select vtyp,l.vno,l.lno,acname,cltcode,drcr,vamt, 0 ,'' from ledger l , parameter where vtyp = 18  and vdt = sdtcur and curyear = 1
and lno not in (select l2.lno from ledger l1,ledger2 l2 , parameter where vtyp = 18  and vdt = sdtcur and curyear = 1
and vtype = vtyp and l2.vno = l1.vno )
order by l.lno

GO
