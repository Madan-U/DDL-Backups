-- Object: PROCEDURE dbo.sbcheq1
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbcheq1    Script Date: 01/04/1980 1:40:42 AM ******/



/****** Object:  Stored Procedure dbo.sbcheq1    Script Date: 11/28/2001 12:23:51 PM ******/

/****** Object:  Stored Procedure dbo.sbcheq1    Script Date: 29-Sep-01 8:12:07 PM ******/

/****** Object:  Stored Procedure dbo.sbcheq1    Script Date: 8/8/01 1:37:33 PM ******/

/****** Object:  Stored Procedure dbo.sbcheq1    Script Date: 8/7/01 6:03:53 PM ******/

/****** Object:  Stored Procedure dbo.sbcheq1    Script Date: 7/8/01 3:22:51 PM ******/

/****** Object:  Stored Procedure dbo.sbcheq1    Script Date: 2/17/01 3:34:18 PM ******/


/****** Object:  Stored Procedure dbo.sbcheq1    Script Date: 20-Mar-01 11:43:36 PM ******/

CREATE PROCEDURE sbcheq1
@cltcode varchar(10),
@vdt varchar(10),
@broker varchar(15)
AS
select l1.acname,l1.vamt,l1.refno,l1.cltcode,l1.vtyp, 
bank=isnull((select bnkname from ledger1 le1 where le1.refno=l1.refno),''),
ddno=isnull((select ddno from ledger1 le1 where 
le1.refno=l1.refno),''), nar=isnull((select l3.narr from ledger3 l3 where 
l3.refno=left(l1.refno,7)),'') from ledger l1,  MSAJAG.DBO.client1 c1, MSAJAG.DBO.client2 c2, MSAJAG.DBO.subbrokers sb 
where  left(l1.refno,7) in ( 
select left(refno,7) from ledger l where convert(varchar,l.vdt,103) = @vdt
and l.vtyp=3 and l.cltcode=@cltcode) 
and l1.cltcode <> @cltcode 
and c2.party_code=l1.cltcode and c1.cl_code=c2.cl_code and sb.sub_broker=c1.sub_broker and sb.sub_broker=@broker
order by l1.acname

GO
