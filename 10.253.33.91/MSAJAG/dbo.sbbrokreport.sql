-- Object: PROCEDURE dbo.sbbrokreport
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbbrokreport    Script Date: 3/17/01 9:56:06 PM ******/

/****** Object:  Stored Procedure dbo.sbbrokreport    Script Date: 3/21/01 12:50:25 PM ******/

/****** Object:  Stored Procedure dbo.sbbrokreport    Script Date: 20-Mar-01 11:39:04 PM ******/

/****** Object:  Stored Procedure dbo.sbbrokreport    Script Date: 2/5/01 12:06:24 PM ******/

/****** Object:  Stored Procedure dbo.sbbrokreport    Script Date: 12/27/00 8:58:59 PM ******/

/* displays settlementwise subbrokerage */
CREATE PROCEDURE 
sbbrokreport
@subbroker varchar(15),
@partycode varchar(10),
@partyname varchar(21),
@settno  varchar(7),
@settype varchar(3)
AS
select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
from settlement h,client1 c1,client2 c2 ,subbrokers sb
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and
sb.sub_broker=c1.sub_broker and sb.sub_broker=@subbroker and
 h.party_code like ltrim(@partycode)+'%' and c1.short_name like ltrim(@partyname)+'%' and h.sett_no = @settno 
 and h.sett_type like ltrim(@settype) +'%' 
group by h.party_code,c1.Short_Name,c1.trader 
Union all
 select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
from history h,client1 c1,client2 c2 ,subbrokers sb
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code like ltrim(@partycode)+'%' and
sb.sub_broker=c1.sub_broker and sb.sub_broker=@subbroker and 
c1.short_name like ltrim(@partyname)+'%' and h.sett_no =@settno and h.sett_type like ltrim(@settype)+'%' 
 group by h.party_code,c1.Short_Name,c1.trader
 order by c1.trader,h.Party_code,c1.Short_Name,h.DeliveryCharge

GO
