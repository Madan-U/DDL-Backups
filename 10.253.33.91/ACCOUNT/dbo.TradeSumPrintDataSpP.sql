-- Object: PROCEDURE dbo.TradeSumPrintDataSpP
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.TradeSumPrintDataSpP    Script Date: 01/04/1980 1:40:43 AM ******/



/****** Object:  Stored Procedure dbo.TradeSumPrintDataSpP    Script Date: 11/28/2001 12:23:53 PM ******/

/****** Object:  Stored Procedure dbo.TradeSumPrintDataSpP    Script Date: 29-Sep-01 8:12:08 PM ******/

/****** Object:  Stored Procedure dbo.TradeSumPrintDataSpP    Script Date: 8/8/01 1:37:33 PM ******/

/****** Object:  Stored Procedure dbo.TradeSumPrintDataSpP    Script Date: 8/7/01 6:03:54 PM ******/

/****** Object:  Stored Procedure dbo.TradeSumPrintDataSpP    Script Date: 7/8/01 3:22:52 PM ******/

/****** Object:  Stored Procedure dbo.TradeSumPrintDataSpP    Script Date: 2/17/01 3:34:19 PM ******/


/****** Object:  Stored Procedure dbo.TradeSumPrintDataSpP    Script Date: 20-Mar-01 11:43:36 PM ******/

CREATE PROCEDURE TradeSumPrintDataSpP
@tradername varchar(20),
@genddate varchar(11),
@minamount varchar(15),
@maxamount  varchar(15)
 AS
select distinct l1.cltcode,l1.acname ,  
Debit = (select isnull(sum(vamt),0) from ledger l where l.drcr='d' and  l1.cltcode =  l.cltcode ), 
Credit = (select isnull(sum(vamt),0) from ledger l where l.drcr='c' and  l1.cltcode = l.cltcode ), amount = ((select isnull(sum(vamt),0) 
from ledger l where l.drcr='d' and  l1.cltcode =  l.cltcode ) - (select isnull(sum(vamt),0)
from ledger l where l.drcr='c' and  l1.cltcode = l.cltcode ))  
from ledger l1  , MSAJAG.DBO.client1 c1 , MSAJAG.DBO.client2 c2  where c1.cl_Code = c2.cl_Code 
and c2.party_code = l1.cltcode and c1.trader=@tradername  and l1.vdt <=@genddate
group by l1.cltcode,l1.acname  
having  ABS((select isnull(sum(vamt),0) from ledger l 
where l.drcr='d' and  l1.cltcode =  l.cltcode  and l.vdt <=@genddate )-  
(select isnull(sum(vamt),0) from ledger l where l.drcr='c' and  l1.cltcode = l.cltcode  
and l.vdt <=@genddate )) > convert(money,@minamount)  and ABS((select isnull(sum(vamt),0) 
from ledger l where l.drcr='d' and  l1.cltcode =  l.cltcode  
and l.vdt <=@genddate )- (select isnull(sum(vamt),0) from ledger l where l.drcr='c' 
and  l1.cltcode = l.cltcode  and l.vdt <=@genddate ))  <   convert(money,@maxamount)
order by l1.acname

GO
