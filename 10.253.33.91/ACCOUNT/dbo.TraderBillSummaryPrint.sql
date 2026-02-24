-- Object: PROCEDURE dbo.TraderBillSummaryPrint
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.TraderBillSummaryPrint    Script Date: 01/04/1980 1:40:43 AM ******/



/****** Object:  Stored Procedure dbo.TraderBillSummaryPrint    Script Date: 11/28/2001 12:23:53 PM ******/

/****** Object:  Stored Procedure dbo.TraderBillSummaryPrint    Script Date: 29-Sep-01 8:12:08 PM ******/

/****** Object:  Stored Procedure dbo.TraderBillSummaryPrint    Script Date: 8/8/01 1:37:33 PM ******/

/****** Object:  Stored Procedure dbo.TraderBillSummaryPrint    Script Date: 8/7/01 6:03:53 PM ******/

/****** Object:  Stored Procedure dbo.TraderBillSummaryPrint    Script Date: 7/8/01 3:22:52 PM ******/

/****** Object:  Stored Procedure dbo.TraderBillSummaryPrint    Script Date: 2/17/01 3:34:19 PM ******/


/****** Object:  Stored Procedure dbo.TraderBillSummaryPrint    Script Date: 20-Mar-01 11:43:36 PM ******/

CREATE PROCEDURE TraderBillSummaryPrint 
@tradername varchar(15),
@settnosetttype varchar(12)
AS
select distinct l.cltcode, l.acname, 
DEBIT =(select isnull(sum(vamt),0) from ledger  where drcr='d' AND LEDGER.CLTCODE = L.CLTCODE   
and cltcode not in ('99990' ,'61310', '99985' ,'99988','100') 
and substring(refno,1,7) = (l3.refno + ' ' )), 
CREDIT = (select isnull(sum(vamt),0) from ledger  where drcr='c' AND LEDGER.CLTCODE = L.CLTCODE 
and cltcode not in ('99990' ,'61310', '99985' ,'99988','100')  
and substring(refno,1,7) = (l3.refno + ' ' ))   
from ledger l,ledger l1,ledger3 l3 , MSAJAG.DBO.client1 c1 , MSAJAG.DBO.client2 c2 
where  c1.cl_Code = c2.cl_Code and c2.party_code = l.cltcode  and c1.trader like @tradername 
and substring(l.refno,1,11) = substring(l1.refno,1,11) 
and substring(l.refno,1,7) = (l3.refno + ' ' )and l.vtyp='15' 
and l.vtyp=l1.vtyp and l3.narr like @settnosetttype
and l.cltcode not in ('99990' ,'61310', '99985' ,'99988','100') 
order by l.cltcode

GO
