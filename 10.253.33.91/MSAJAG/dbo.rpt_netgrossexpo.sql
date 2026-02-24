-- Object: PROCEDURE dbo.rpt_netgrossexpo
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_netgrossexpo    Script Date: 04/27/2001 4:32:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_netgrossexpo    Script Date: 3/21/01 12:50:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_netgrossexpo    Script Date: 20-Mar-01 11:39:01 PM ******/

/****** Object:  Stored Procedure dbo.rpt_netgrossexpo    Script Date: 2/5/01 12:06:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_netgrossexpo    Script Date: 12/27/00 8:58:56 PM ******/

/* report : misnews
   file: topclient_scrisett.asp
*/
/* shows netexposure of all clients for current settlement plus today's trading */
CREATE PROCEDURE rpt_netgrossexpo
@settno varchar (7)
as
select s.series,s.sell_buy,grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name 
from settlement s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and  s.billno = '0' and (s.sett_type='N' or s.sett_type='W' or s.sett_type='M')
and s.sett_no=@settno
group by s.sett_type,c1.cl_code,c1.short_name,s.sell_buy,s.series
union all
select s.series,s.sell_buy,grossexp=sum(s.tradeqty*s.marketrate),c1.cl_code,c1.short_name 
from trade4432 s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
group by c1.cl_code,c1.short_name,s.sell_buy,s.series
order by c1.short_name,s.series,s.sell_buy

GO
