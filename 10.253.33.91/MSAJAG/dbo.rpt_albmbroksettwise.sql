-- Object: PROCEDURE dbo.rpt_albmbroksettwise
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_albmbroksettwise    Script Date: 04/27/2001 4:32:32 PM ******/

/* report : albm settlementwise brokerage */
/* file : brokreport.asp */
/* displays brokerage for normal and its respective albm */

CREATE PROCEDURE rpt_albmbroksettwise
@statusid varchar(15),
@statusname varchar(25),
@settno varchar(7),
@prevlsettno varchar(7),
@nextlsettno varchar(7),
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
and ((h.sett_no=@prevlsettno and h.sett_type=@albmsettype) or (h.sett_no=@nextlsettno and h.sett_type=@albmsettype) or (h.sett_type = @settype and  h.sett_no =@settno )) 
group by c1.trader,h.party_code,c1.Short_Name, h.sett_type, h.sett_no
union all
select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty), h.sett_no, h.sett_type,
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
from history  h,client1 c1,client2 c2 
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code 
and h.party_code like ltrim(@partycode)+'%' and c1.short_name like  ltrim(@partyname)+'%' 
and  c1.trader like  ltrim(@trader)+'%' 
and ((h.sett_no=@prevlsettno and h.sett_type=@albmsettype) or (h.sett_no=@nextlsettno and h.sett_type=@albmsettype) or (h.sett_type = @settype and  h.sett_no =@settno )) 
group by c1.trader,h.party_code,c1.Short_Name, h.sett_type, h.sett_no
order by h.party_code,c1.Short_Name,C1.TRADER, h.sett_type, h.sett_no

GO
