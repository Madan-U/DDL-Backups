-- Object: PROCEDURE dbo.brsettparty
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brsettparty    Script Date: 3/17/01 9:55:47 PM ******/

/****** Object:  Stored Procedure dbo.brsettparty    Script Date: 3/21/01 12:50:03 PM ******/

/****** Object:  Stored Procedure dbo.brsettparty    Script Date: 20-Mar-01 11:38:46 PM ******/

/****** Object:  Stored Procedure dbo.brsettparty    Script Date: 2/5/01 12:06:09 PM ******/

/****** Object:  Stored Procedure dbo.brsettparty    Script Date: 12/27/00 8:58:46 PM ******/

/* Report : Netnsereport
    File :  dematscrips.asp
displays settwise, clientwise netposition report
*/
CREATE PROCEDURE brsettparty
@br varchar(3),
@settno varchar(7),
@setttype varchar(3),
@scripcd varchar(10),
@series varchar(2)
AS
select s.sett_no,s.sett_type,s.scrip_cd,s.series,c1.short_name,
s.party_code,sum(s.tradeqty),sum(s.tradeqty*s.marketrate),s.sell_buy
from settlement s,client1 c1, client2 c2,branches b 
where c1.cl_code = c2.cl_code 
and c2.party_code = s.party_code 
and b.short_name = c1.trader
and b.branch_cd = @br
and s.sett_no = @settno and s.sett_type = @setttype
and s.scrip_cd = @scripcd and s.series = @series
group by c1.short_name,s.party_code,s.scrip_cd,s.series,s.sett_no,s.sett_type,s.sell_buy 
order by s.sett_no,s.sett_type,s.scrip_cd,s.series,c1.short_name,s.party_code,s.sell_buy

GO
