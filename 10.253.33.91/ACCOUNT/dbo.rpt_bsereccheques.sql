-- Object: PROCEDURE dbo.rpt_bsereccheques
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_bsereccheques    Script Date: 01/04/1980 1:40:40 AM ******/



/****** Object:  Stored Procedure dbo.rpt_bsereccheques    Script Date: 11/28/2001 12:23:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsereccheques    Script Date: 29-Sep-01 8:12:06 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsereccheques    Script Date: 8/8/01 1:37:32 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsereccheques    Script Date: 8/7/01 6:03:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsereccheques    Script Date: 7/8/01 3:22:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsereccheques    Script Date: 2/17/01 3:34:17 PM ******/


/****** Object:  Stored Procedure dbo.rpt_bsereccheques    Script Date: 20-Mar-01 11:43:35 PM ******/

/* report : cheques
   file : todayscheq.asp
*/
/* displays list of cheques  received as on particular date on a particular bank */
CREATE PROCEDURE rpt_bsereccheques 
@bankcode varchar(6),
@tdate varchar(10),
@statusid varchar(15),
@statusname varchar(25)
AS
if @statusid = 'broker' 
begin
select l1.acname,l1.vamt,l1.refno,l1.cltcode,l1.vtyp, 
bank=isnull((select bnkname from ledger1 le1 where le1.refno=l1.refno),''), 
ddno=isnull((select ddno from ledger1 le1 where le1.refno=l1.refno),''),
nar=isnull((select l3.narr from ledger3 l3 where l3.refno=left(l1.refno,7)),'')
from ledger l1 where left(l1.refno,7) in ( select left(refno,7) from ledger l where convert(varchar,l.vdt,103) 
like ltrim(@tdate)+'%' and l.vtyp=2 and l.cltcode=@bankcode)
and l1.cltcode <> @bankcode
order by l1.acname 
end
if @statusid = 'branch' 
begin
select l1.acname,l1.vamt,l1.refno,l1.cltcode,l1.vtyp, 
bank=isnull((select bnkname from ledger1 le1 where le1.refno=l1.refno),''), 
ddno=isnull((select ddno from ledger1 le1 where le1.refno=l1.refno),''),
nar=isnull((select l3.narr from ledger3 l3 where l3.refno=left(l1.refno,7)),'')
from ledger l1, bsedb.dbo.branches b, bsedb.dbo.client1 c1, bsedb.dbo.client2 c2 
where left(l1.refno,7) in ( select left(refno,7) from ledger l where convert(varchar,l.vdt,103) 
like ltrim(@tdate)+'%' and l.vtyp=2 and l.cltcode=@bankcode)
and l1.cltcode <> @bankcode  and l1.cltcode=c2.party_code and 
b.branch_cd=@statusname and b.short_name=c1.trader 
and c1.cl_code=c2.cl_code
order by l1.acname 
end
if @statusid = 'trader'
begin
select l1.acname,l1.vamt,l1.refno,l1.cltcode,l1.vtyp, 
bank=isnull((select bnkname from ledger1 le1 where le1.refno=l1.refno),''), 
ddno=isnull((select ddno from ledger1 le1 where le1.refno=l1.refno),''),
nar=isnull((select l3.narr from ledger3 l3 where l3.refno=left(l1.refno,7)),'')
from ledger l1 , bsedb.dbo.client1 c1, bsedb.dbo.client2 c2
where left(l1.refno,7) in ( select left(refno,7) from ledger l where convert(varchar,l.vdt,103) 
like ltrim(@tdate)+'%' and l.vtyp=2 and l.cltcode=@bankcode)
and l1.cltcode <> @bankcode and c1.cl_code=c2.cl_code and c2.party_code=l1.cltcode
and c1.trader=@statusname
order by l1.acname 
end
if @statusid = 'subbroker'
begin
select l1.acname,l1.vamt,l1.refno,l1.cltcode,l1.vtyp, 
bank=isnull((select bnkname from ledger1 le1 where le1.refno=l1.refno),''), 
ddno=isnull((select ddno from ledger1 le1 where le1.refno=l1.refno),''),
nar=isnull((select l3.narr from ledger3 l3 where l3.refno=left(l1.refno,7)),'')
from ledger l1 , bsedb.dbo.client1 c1, bsedb.dbo.client2 c2, bsedb.dbo.subbrokers sb
where left(l1.refno,7) in ( select left(refno,7) from ledger l where convert(varchar,l.vdt,103) 
like ltrim(@tdate)+'%' and l.vtyp=2 and l.cltcode=@bankcode)
and l1.cltcode <> @bankcode and c1.cl_code=c2.cl_code and c2.party_code=l1.cltcode
and sb.sub_broker=@statusname and sb.sub_broker=c1.sub_broker 
order by l1.acname 
end
if @statusid = 'client'
begin
select l1.acname,l1.vamt,l1.refno,l1.cltcode,l1.vtyp, 
bank=isnull((select bnkname from ledger1 le1 where le1.refno=l1.refno),''), 
ddno=isnull((select ddno from ledger1 le1 where le1.refno=l1.refno),''),
nar=isnull((select l3.narr from ledger3 l3 where l3.refno=left(l1.refno,7)),'')
from ledger l1 , bsedb.dbo.client1 c1, bsedb.dbo.client2 c2
where left(l1.refno,7) in ( select left(refno,7) from ledger l where convert(varchar,l.vdt,103) 
like ltrim(@tdate)+'%' and l.vtyp=2 and l.cltcode=@bankcode)
and l1.cltcode <> @bankcode and c1.cl_code=c2.cl_code and c2.party_code=l1.cltcode and
l1.cltcode=@statusname 
order by l1.acname 
end

GO
