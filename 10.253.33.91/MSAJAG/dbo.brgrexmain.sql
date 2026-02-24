-- Object: PROCEDURE dbo.brgrexmain
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brgrexmain    Script Date: 3/17/01 9:55:45 PM ******/

/****** Object:  Stored Procedure dbo.brgrexmain    Script Date: 3/21/01 12:50:01 PM ******/

/****** Object:  Stored Procedure dbo.brgrexmain    Script Date: 20-Mar-01 11:38:44 PM ******/

/****** Object:  Stored Procedure dbo.brgrexmain    Script Date: 2/5/01 12:06:08 PM ******/

/****** Object:  Stored Procedure dbo.brgrexmain    Script Date: 12/27/00 8:58:44 PM ******/

/* Report : grossexposure report
   File : grossexptrd
displays details of today's trades for a party
*/
CREATE PROCEDURE brgrexmain
@br varchar(3),
@shortname varchar(21),
@scripcd varchar(10),
@partycode varchar(10),
@trader varchar (15)
AS
select c1.short_name,t4.party_code,t4.scrip_cd,t4.series,sum(t4.tradeqty),
Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
from trade t4,client1 c1,client2 c2,branches b 
where c2.party_code = t4.party_code 
and b.short_name = c1.trader and b.branch_cd = @br
and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@shortname)+'%' 
and t4.scrip_cd like ltrim(@scripcd)+'%' and t4.party_code like ltrim(@partycode)+'%' 
and c1.trader like ltrim(@trader)+'%' and series not in ('AE','BE','N1') 
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy

GO
