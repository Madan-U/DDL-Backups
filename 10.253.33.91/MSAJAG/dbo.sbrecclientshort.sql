-- Object: PROCEDURE dbo.sbrecclientshort
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbrecclientshort    Script Date: 3/17/01 9:56:08 PM ******/

/****** Object:  Stored Procedure dbo.sbrecclientshort    Script Date: 3/21/01 12:50:27 PM ******/

/****** Object:  Stored Procedure dbo.sbrecclientshort    Script Date: 20-Mar-01 11:39:07 PM ******/

/****** Object:  Stored Procedure dbo.sbrecclientshort    Script Date: 2/5/01 12:06:26 PM ******/

/****** Object:  Stored Procedure dbo.sbrecclientshort    Script Date: 12/27/00 8:59:01 PM ******/

/***  report : nse shortage
       file :  client shortage.asp   ***/
CREATE PROCEDURE  sbrecclientshort 
@settno varchar(8),
@settype varchar(3),
@scripcd varchar(12),
@subbroker varchar(15)
as
select d.sett_no,d.sett_type,d.party_code,d.scrip_cd,reqqty=sum(qty), 
actualqty=isnull((select sum(qty) from certinfo c where 
d.sett_no=c.sett_no and d.sett_type=c.sett_type and 
d.party_code=c.party_code and d.scrip_cd=c.scrip_Cd and 
d.series=c.series group by c.party_code,c.scrip_cd,c.series),0)
from deliveryclt d,client1 c1,client2 c2,subbrokers sb  where d.sett_no=@settno and d.sett_type=@settype 
and d.inout='i' and d.scrip_Cd=@scripcd and c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker
and c1.cl_code=c2.cl_code and d.party_code=c2.party_code
group by d.sett_no,d.sett_type,d.party_code,d.scrip_Cd,d.series

GO
