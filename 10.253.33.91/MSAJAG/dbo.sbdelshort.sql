-- Object: PROCEDURE dbo.sbdelshort
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbdelshort    Script Date: 3/17/01 9:56:07 PM ******/

/****** Object:  Stored Procedure dbo.sbdelshort    Script Date: 3/21/01 12:50:26 PM ******/

/****** Object:  Stored Procedure dbo.sbdelshort    Script Date: 20-Mar-01 11:39:05 PM ******/

/****** Object:  Stored Procedure dbo.sbdelshort    Script Date: 2/5/01 12:06:24 PM ******/

/****** Object:  Stored Procedure dbo.sbdelshort    Script Date: 12/27/00 8:59:15 PM ******/

/* displays settlementwise scripwise shortage report for a subbroker */
CREATE PROCEDURE sbdelshort
@settno varchar(7),
@settype varchar(3),
@broker varchar(15)
AS
select d.scrip_Cd,d.series, d.entitycode,d.name, d.Deliver_Qty, d.Delivered_Qty, 
qty=isnull((select sum(qty)from certinfo c where c.sett_no=d.sett_no and c.sett_type=d.sett_type and c.scrip_cd=d.scrip_Cd and 
c.series=d.series and c.targetparty=d.entitycode group by c.sett_no,c.sett_type, c.scrip_Cd,c.series),0), 
demat=isnull((select distinct scrip_cd from scrip2 s2, scrip1 s1 where s1.demat_date<=getdate() and s1.co_code=s2.co_code and s2.scrip_cd=d.scrip_cd
and s2.series=d.series ), '')
from delivery d , deliveryclt clt, client1 c1, client2 c2, subbrokers sb   where d.sett_no=@settno and d.sett_type=@settype and
clt.sett_no=d.sett_no and clt.sett_type=d.sett_type and clt.series=d.series and clt.scrip_cd=d.scrip_Cd and
sb.sub_broker=c1.sub_broker and c2.party_code=clt.party_code and c1.cl_code=c2.cl_code and sb.sub_broker=@broker
Group by d.sett_no,d.sett_Type,d.scrip_Cd,d.series, d.entitycode,d.name, d.Deliver_Qty, d.Delivered_Qty

GO
