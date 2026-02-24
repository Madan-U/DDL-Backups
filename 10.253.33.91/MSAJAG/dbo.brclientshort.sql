-- Object: PROCEDURE dbo.brclientshort
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brclientshort    Script Date: 3/17/01 9:55:45 PM ******/

/****** Object:  Stored Procedure dbo.brclientshort    Script Date: 3/21/01 12:50:01 PM ******/

/****** Object:  Stored Procedure dbo.brclientshort    Script Date: 20-Mar-01 11:38:44 PM ******/

/****** Object:  Stored Procedure dbo.brclientshort    Script Date: 2/5/01 12:06:07 PM ******/

/****** Object:  Stored Procedure dbo.brclientshort    Script Date: 12/27/00 8:58:44 PM ******/

/* displays list of shares who have not received shares for a settlement */
CREATE PROCEDURE brclientshort
@settno varchar(6),
@settype varchar(3),
@scrip varchar(12),
@br varchar(3)
AS
select d.sett_no,d.sett_type,d.party_code,d.scrip_cd,reqqty=sum(qty), 
actualqty=isnull((select sum(qty) from certinfo c where 
d.sett_no=c.sett_no and d.sett_type=c.sett_type and 
d.party_code=c.party_code and d.scrip_cd=c.scrip_Cd and 
d.series=c.series group by c.party_code,c.scrip_cd,c.series),0)
from deliveryclt d ,  client1 c1, client2 c2, branches b  where d.sett_no=@settno
 and d.sett_type=@settype 
and d.inout='i' and d.scrip_Cd=@scrip and
b.short_name=c1.trader and c2.party_code=d.party_code and c1.cl_code=c2.cl_code and b.branch_cd=@br
group by d.sett_no,d.sett_type,d.party_code,d.scrip_Cd,d.series

GO
