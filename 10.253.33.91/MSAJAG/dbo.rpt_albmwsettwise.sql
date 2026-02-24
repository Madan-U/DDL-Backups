-- Object: PROCEDURE dbo.rpt_albmwsettwise
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_albmwsettwise    Script Date: 04/27/2001 4:32:32 PM ******/

/* report :  albm brokerage  
     file : brokreport.asp
*/
/* finds brokerage for current and next albm settlement from settlement and history and previous settlements settling in this settlement from albm view */


CREATE PROCEDURE rpt_albmwsettwise
@statusid varchar(15),
@statusname varchar(25),
@settno varchar(7),
@nextwsettno varchar(7),
@settype varchar(3),
@albmsettype varchar(3),
@trader varchar(15),
@partycode varchar(10),
@partyname varchar(21)

AS

select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty), h.sett_no, h.sett_type,
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
from settlement h,client1 c1,client2 c2 
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code 
and h.party_code like ltrim(@partycode)+'%' and c1.short_name like  ltrim(@partyname)+'%' 
and  c1.trader like  ltrim(@trader)+'%' 
and ((h.sett_no=@settno and h.sett_type=@settype) or (h.sett_no=@nextwsettno and h.sett_type=@albmsettype))
group by c1.trader,h.party_code,c1.Short_Name, h.sett_type, h.sett_no
union all
select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty), h.sett_no, h.sett_type,
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
from history h,client1 c1,client2 c2 
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code 
and h.party_code like ltrim(@partycode)+'%' and c1.short_name like  ltrim(@partyname)+'%' 
and  c1.trader like  ltrim(@trader)+'%' 
and ((h.sett_no=@settno and h.sett_type=@settype) or (h.sett_no=@nextwsettno and h.sett_type=@albmsettype))
group by c1.trader,h.party_code,c1.Short_Name, h.sett_type, h.sett_no
union all
select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty), h.sett_no, h.sett_type,
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
from albm h,client1 c1,client2 c2 
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code 
and h.party_code like ltrim(@partycode)+'%' and c1.short_name like  ltrim(@partyname)+'%' 
and  c1.trader like ltrim(@trader)+ '%' 
and ((h.sett_no=@settno and h.sett_type=@albmsettype)) 
group by c1.trader,h.party_code,c1.Short_Name, h.sett_type, h.sett_no
order by h.party_code,c1.Short_Name,c1.trader, h.sett_type, h.sett_no

GO
