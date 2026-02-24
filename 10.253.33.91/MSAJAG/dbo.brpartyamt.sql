-- Object: PROCEDURE dbo.brpartyamt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brpartyamt    Script Date: 3/17/01 9:55:46 PM ******/

/****** Object:  Stored Procedure dbo.brpartyamt    Script Date: 3/21/01 12:50:02 PM ******/

/****** Object:  Stored Procedure dbo.brpartyamt    Script Date: 20-Mar-01 11:38:45 PM ******/

/****** Object:  Stored Procedure dbo.brpartyamt    Script Date: 2/5/01 12:06:09 PM ******/

/****** Object:  Stored Procedure dbo.brpartyamt    Script Date: 12/27/00 8:58:45 PM ******/

/*  Report : history position
     File : hispositionreport.asp
displays detailed scripwise position for a particular branch's client and settlement 
*/
CREATE PROCEDURE brpartyamt
@br varchar(3),
@partycode varchar(10),
@shortname varchar(21),
@trader varchar(15),
@scripcd varchar(10),
@settno varchar(7),
@setttype varchar(3)
AS
select s.party_code,c1.short_name,s.scrip_cd,s.series,Quantity = sum(s.tradeqty),
Amount = sum(s.amount),s.sell_buy,s.sett_no,s.sett_type 
from history s,client1 c1,client2 c2,branches b 
where s.party_code = c2.party_code 
and c1.cl_code = c2.cl_code 
and b.short_name = c1.trader 
and b.branch_cd = @br
and s.party_code like ltrim(@partycode)+'%' 
and c1.short_name like ltrim(@shortname)+'%' 
and c1.trader like ltrim(@trader)+'%' 
and s.scrip_cd like ltrim(@scripcd)+'%'
and s.sett_no= @settno 
and s.sett_type = @setttype 
group by s.party_code,c1.short_name,s.scrip_cd,s.series,s.sett_no,s.sett_type,s.sell_buy
order by c1.short_name,s.party_code,s.scrip_cd,s.series,s.sett_no,s.sett_type,s.sell_buy

GO
