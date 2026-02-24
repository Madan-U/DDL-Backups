-- Object: PROCEDURE dbo.traderallpartyled
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.traderallpartyled    Script Date: 01/04/1980 1:40:43 AM ******/



/****** Object:  Stored Procedure dbo.traderallpartyled    Script Date: 11/28/2001 12:23:53 PM ******/

/****** Object:  Stored Procedure dbo.traderallpartyled    Script Date: 29-Sep-01 8:12:08 PM ******/

/****** Object:  Stored Procedure dbo.traderallpartyled    Script Date: 8/8/01 1:37:33 PM ******/

/****** Object:  Stored Procedure dbo.traderallpartyled    Script Date: 8/7/01 6:03:53 PM ******/

/****** Object:  Stored Procedure dbo.traderallpartyled    Script Date: 7/8/01 3:22:51 PM ******/

/****** Object:  Stored Procedure dbo.traderallpartyled    Script Date: 2/17/01 3:34:19 PM ******/


/****** Object:  Stored Procedure dbo.traderallpartyled    Script Date: 20-Mar-01 11:43:36 PM ******/

CREATE PROCEDURE traderallpartyled
@cname varchar(35)
AS
select convert(varchar,l.vdt,103), c2.party_code, 
vdesc,dramt=isnull((case drcr when 'd' then vamt end),0), 
cramt=isnull((case drcr when 'c' then vamt end),0), l.vamt, 
l.refno, balamt,vtyp, 
nar=isnull((select l3.narr from ledger3 l3 where l3.refno=left(l.refno,7)), '') from ledger l,
vmast, MSAJAG.DBO.client2 c2, MSAJAG.DBO.client1 c1
where l.acname = c1.short_Name and c1.cl_code = c2.cl_code and c2.party_code=l.cltcode and vtyp=vtype 
and l.acname =@cname
order by l.vdt

GO
