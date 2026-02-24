-- Object: PROCEDURE dbo.rpt_albmgrossexpo
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_albmgrossexpo    Script Date: 04/27/2001 4:32:32 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmgrossexpo    Script Date: 3/21/01 12:50:11 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmgrossexpo    Script Date: 20-Mar-01 11:38:53 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmgrossexpo    Script Date: 2/5/01 12:06:15 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmgrossexpo    Script Date: 12/27/00 8:58:53 PM ******/

/* report : misnews 
   file : topclient_scrip.asp
*/
/* finds gross exposure of all clients for current settlement as well as today's day */
CREATE PROCEDURE rpt_albmgrossexpo
@settno varchar(7)
AS
select  s.series, s.scrip_cd ,  s.trade_no, s.tradeqty, grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name ,
rate=isnull((case s.sett_type when 'l' then (select distinct rate from albmrate a 
where a.scrip_cd=s.scrip_Cd and a.sett_type=s.sett_type and s.series=a.series
and a.sett_no=@settno) else (0) end ),0)
from settlement s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and s.sett_no=@settno
and (( s.billno = '0' and (s.sett_type='N' or s.sett_type='W' or s.sett_type='M')) 
or (s.sett_no=@settno and s.sett_type='l')) 
group by  c1.cl_code,c1.short_name,s.sett_type,s.scrip_Cd,s.series, s.tradeqty ,s.trade_no
union all
select s.series,s.scrip_Cd,  s.trade_no , s.tradeqty, grossexp=sum(s.tradeqty* s.marketrate),c1.cl_code,c1.short_name , rate=s.marketrate
from trade4432 s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
group by c1.cl_code,c1.short_name,s.scrip_Cd,s.series, s.marketrate, s.tradeqty,s.trade_no
order by c1.short_name,c1.cl_code,s.series,s.scrip_cd

GO
