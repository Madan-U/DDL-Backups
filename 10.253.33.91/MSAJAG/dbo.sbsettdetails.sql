-- Object: PROCEDURE dbo.sbsettdetails
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbsettdetails    Script Date: 3/17/01 9:56:08 PM ******/

/****** Object:  Stored Procedure dbo.sbsettdetails    Script Date: 3/21/01 12:50:28 PM ******/

/****** Object:  Stored Procedure dbo.sbsettdetails    Script Date: 20-Mar-01 11:39:07 PM ******/

/****** Object:  Stored Procedure dbo.sbsettdetails    Script Date: 2/5/01 12:06:26 PM ******/

/****** Object:  Stored Procedure dbo.sbsettdetails    Script Date: 12/27/00 8:59:01 PM ******/

CREATE PROCEDURE sbsettdetails 
@clcode varchar(6),
@series varchar(3)
AS
select  s.scrip_Cd,s.series,s.sell_buy,qty=sum(s.tradeqty),amount=sum(s.tradeqty*s.N_NetRate),
c1.cl_code,c1.short_name
from settlement s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and c1.cl_code=@clcode
and  s.billno = '0' and (s.sett_type='N' or s.sett_type='W' or s.sett_type = 'M')
and s.series=@series
group by c1.cl_code,c1.short_name,s.scrip_cd,s.series,s.sell_buy
union
select s.scrip_Cd,s.series,s.sell_buy,qty=sum(s.tradeqty),amount=sum(s.tradeqty*s.marketrate),
c1.cl_code,c1.short_name 
from trade4432 s,client1 c1,client2 c2
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and c1.cl_code=@clcode
and s.series=@series
group by c1.cl_code,c1.short_name,s.scrip_cd,s.series,s.sell_buy
order by c1.short_name,s.scrip_cd,s.sell_buy

GO
