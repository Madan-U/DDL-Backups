-- Object: PROCEDURE dbo.brrepd
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brrepd    Script Date: 3/17/01 9:55:47 PM ******/

/****** Object:  Stored Procedure dbo.brrepd    Script Date: 3/21/01 12:50:02 PM ******/

/****** Object:  Stored Procedure dbo.brrepd    Script Date: 20-Mar-01 11:38:46 PM ******/

/****** Object:  Stored Procedure dbo.brrepd    Script Date: 2/5/01 12:06:09 PM ******/

/****** Object:  Stored Procedure dbo.brrepd    Script Date: 12/27/00 8:58:45 PM ******/

/* report : brokerage(p)
file: brokreportdate.asp
displays brokerage for a particular period for a client
*/
CREATE PROCEDURE brrepd
@br varchar(3),
@partycode varchar(10),
@shortname varchar(21),
@sdate varchar(12),
@fdate varchar(12),
@trader varchar(15)
AS
select distinct h.Party_code,c1.short_name,c1.Trader,brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
from history h,client1 c1,client2 c2, branches b 
where h.party_code = c2.party_code 
and b.short_name = c1.trader and b.branch_cd =@br
and c1.cl_code = c2.cl_code and h.party_code like ltrim(@partycode)+'%' 
and c1.short_name like ltrim(@shortname)+'%' and sauda_date >= @sdate 
and sauda_date <= @fdate and c1.trader like ltrim(@trader)+'%' 
group by c1.short_name, h.party_code,c1.trader 
order by c1.trader,c1.short_name,h.Party_code,DeliveryCharge

GO
