-- Object: PROCEDURE dbo.brbroktr
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brbroktr    Script Date: 3/17/01 9:55:45 PM ******/

/****** Object:  Stored Procedure dbo.brbroktr    Script Date: 3/21/01 12:50:01 PM ******/

/****** Object:  Stored Procedure dbo.brbroktr    Script Date: 20-Mar-01 11:38:44 PM ******/

/****** Object:  Stored Procedure dbo.brbroktr    Script Date: 2/5/01 12:06:07 PM ******/

/****** Object:  Stored Procedure dbo.brbroktr    Script Date: 12/27/00 8:58:44 PM ******/

/* Report : Brokerage report
     File : brokreport.asp
displays settlementwise brokerage
*/
CREATE PROCEDURE brbroktr
@br varchar(3),
@partycode varchar(10),
@shortname varchar(21),
@settno varchar(7),
@settype varchar(3),
@trader varchar(15)
AS
select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
from settlement h,client1 c1,client2 c2, branches b 
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code
and b.short_name = c1.trader and b.branch_cd = @br
and h.party_code like @partycode +'%' and c1.short_name like ltrim(@shortname)+'%' 
and h.sett_no = @settno and h.sett_type like ltrim(@settype)+'%'  and c1.trader like ltrim(@trader)+'%' 
group by h.party_code,c1.Short_Name,c1.trader 
Union all 
select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
from history h,client1 c1,client2 c2,branches b 
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code 
and b.short_name = c1.trader and b.branch_cd = @br
and h.party_code like ltrim(@partycode)+'%' and c1.short_name like ltrim(@shortname)+'%' 
and h.sett_no =  @settno and h.sett_type like ltrim(@settype)+ '%'  and c1.trader like ltrim(@trader)+'%' 
group by h.party_code,c1.Short_Name,c1.trader 
order by c1.trader,h.Party_code,c1.Short_Name,h.DeliveryCharge

GO
