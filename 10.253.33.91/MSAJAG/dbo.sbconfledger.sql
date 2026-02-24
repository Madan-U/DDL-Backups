-- Object: PROCEDURE dbo.sbconfledger
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbconfledger    Script Date: 3/17/01 9:56:06 PM ******/

/****** Object:  Stored Procedure dbo.sbconfledger    Script Date: 3/21/01 12:50:25 PM ******/

/****** Object:  Stored Procedure dbo.sbconfledger    Script Date: 20-Mar-01 11:39:05 PM ******/

/****** Object:  Stored Procedure dbo.sbconfledger    Script Date: 2/5/01 12:06:24 PM ******/

/****** Object:  Stored Procedure dbo.sbconfledger    Script Date: 12/27/00 8:58:59 PM ******/

CREATE PROCEDURE sbconfledger
@cname varchar(35)
as
select convert(varchar,l.vdt,103), c2.party_code, 
vdesc,dramt=isnull((case drcr when 'd' then vamt end),0), 
cramt=isnull((case drcr when 'c' then vamt end),0), l.vamt, 
l.refno, balamt,vtyp, 
nar=isnull((select l3.narr from ledger3 l3 where l3.refno=left(l.refno,7)), '') from ledger l, 
vmast, msajag.dbo.client2 c2, msajag.dbo.client1 c1 
where l.acname = c1.short_Name and c1.cl_code = c2.cl_code and c2.party_code=l.cltcode and vtyp=vtype 
and l.acname =ltrim(@cname)
order by l.vdt

GO
