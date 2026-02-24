-- Object: PROCEDURE dbo.rpt_angelledger
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/****** Object:  Stored Procedure dbo.rpt_angelledger    Script Date: 12/25/2001 3:03:23 PM ******/
/****** Object:  Stored Procedure dbo.rpt_angelledger    Script Date: 08/21/2001 1:42:59 PM ******/
CREATE PROCEDURE rpt_angelledger
@fromdt varchar(11),
@todt varchar(11),
@partycode varchar(10),
@toparty varchar(10)
AS

select l.cltcode, l.acname, convert(varchar,VDT,103), vtyp,vno,lno,drcr,
 dramt=isnull((case drcr when 'd' then vamt end),0), 
 cramt=isnull((case drcr when 'c' then vamt end),0), balamt,Vdesc,
edt, edtdiff=datediff(d, l.edt , getdate() ), c1.branch_cd, c1.sub_broker, c1.family, c1.trader,
nar=isnull((case when (select l3.narr from account.dbo.ledger3 l3 where l3.vtyp=l.vtyp and l3.vno = l.vno and l.lno = l3.naratno) is not null
		then (select l3.narr from account.dbo.ledger3 l3 where l3.vtyp=l.vtyp  and l3.vno = l.vno and l.lno = l3.naratno)
		else (select l3.narr from account.dbo.ledger3 l3 where l3.vtyp=l.vtyp  and l3.vno = l.vno and l3.naratno = 0)
	end),''),
left(convert(varchar,edt,109),11) as edate1,c1.l_address1,c1.l_address2,c1.l_address3,c1.l_city,c1.l_state,c1.l_nation,c1.l_zip,c1.res_phone1,c1.off_phone1,c1.res_phone2,c1.off_phone2,c1.email

 from account.dbo. ledger l, account.dbo.vmast v, client2 c2, client1 c1  WHERE l.cltcode >= @partycode and l.cltcode <= @toparty 
 and  VDT >= @fromdt and vdt<=@todt + ' 11:59pm'
 and l.vtyp=v.vtype and l.cltcode = c2.party_code
 and c1.cl_code=c2.cl_code
 order by l.cltcode, vdt, drcr,vtyp

GO
