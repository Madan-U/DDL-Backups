-- Object: PROCEDURE dbo.brcheq2
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brcheq2    Script Date: 01/04/1980 1:40:35 AM ******/



/****** Object:  Stored Procedure dbo.brcheq2    Script Date: 11/28/2001 12:23:41 PM ******/

/****** Object:  Stored Procedure dbo.brcheq2    Script Date: 29-Sep-01 8:12:02 PM ******/

/****** Object:  Stored Procedure dbo.brcheq2    Script Date: 8/8/01 1:37:29 PM ******/

/****** Object:  Stored Procedure dbo.brcheq2    Script Date: 8/7/01 6:03:47 PM ******/

/****** Object:  Stored Procedure dbo.brcheq2    Script Date: 7/8/01 3:22:48 PM ******/

/****** Object:  Stored Procedure dbo.brcheq2    Script Date: 2/17/01 3:34:14 PM ******/


/****** Object:  Stored Procedure dbo.brcheq2    Script Date: 20-Mar-01 11:43:32 PM ******/

cREATE PROCEDURE brcheq2
@cltcode varchar(10),
@vdt varchar(10),
@br varchar(3)
 AS
select l1.acname,l1.vamt,l1.refno,l1.cltcode,l1.vtyp, 
bank=isnull((select bnkname from ledger1 le1 where le1.refno=l1.refno),''),
ddno=isnull((select ddno from ledger1 le1 where 
le1.refno=l1.refno),''), nar=isnull((select l3.narr from ledger3 l3 where 
l3.refno=left(l1.refno,7)),'') from ledger l1,  MSAJAG.DBO.client1 c1, MSAJAG.DBO.client2 c2, MSAJAG.DBO.branches b 
where  left(l1.refno,7) in ( 
select left(refno,7) from ledger l where convert(varchar,l.vdt,103) = @vdt
and l.vtyp=2 and l.cltcode=@cltcode) 
and l1.cltcode <> @cltcode 
and c2.party_code=l1.cltcode and c1.cl_code=c2.cl_code and b.short_name=c1.trader and b.branch_cd=@br
order by l1.acname

GO
