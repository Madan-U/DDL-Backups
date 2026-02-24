-- Object: PROCEDURE dbo.sbbrokrepdate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbbrokrepdate    Script Date: 3/17/01 9:56:06 PM ******/

/****** Object:  Stored Procedure dbo.sbbrokrepdate    Script Date: 3/21/01 12:50:25 PM ******/

/****** Object:  Stored Procedure dbo.sbbrokrepdate    Script Date: 20-Mar-01 11:39:04 PM ******/

/****** Object:  Stored Procedure dbo.sbbrokrepdate    Script Date: 2/5/01 12:06:24 PM ******/

/****** Object:  Stored Procedure dbo.sbbrokrepdate    Script Date: 12/27/00 8:58:59 PM ******/

/***  file :Brokreportdate.asp
 report : Brokerage Report  
    displays period wise brokerage ***/
CREATE PROCEDURE 
sbbrokrepdate
@subbroker varchar(15),
@partycode varchar(10),
@partyname varchar(21),
@fdate varchar(11),
@tdate varchar(11),
@trader varchar(15)
AS
select distinct h.Party_code,c1.short_name,c1.Trader,
brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty )
from history h,client1 c1,client2 c2 ,subbrokers sb
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code
and c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker
 and h.party_code like ltrim(@partycode)+'%'
 and c1.short_name like ltrim(@partyname)+'%' and 
sauda_date >= @fdate and sauda_date <= @tdate and 
c1.trader like ltrim(@trader) + '%' 
group by c1.short_name, h.party_code,c1.trader 
order by c1.trader,c1.short_name,h.Party_code,DeliveryCharge

GO
