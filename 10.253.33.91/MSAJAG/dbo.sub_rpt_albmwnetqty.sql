-- Object: PROCEDURE dbo.sub_rpt_albmwnetqty
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sub_rpt_albmwnetqty    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_albmwnetqty    Script Date: 3/21/01 12:50:32 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_albmwnetqty    Script Date: 20-Mar-01 11:39:10 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_albmwnetqty    Script Date: 2/5/01 12:06:29 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_albmwnetqty    Script Date: 12/27/00 8:59:16 PM ******/




/* report: bill report
   file : albmwbill.asp
   displays settlement wise,  partywise, scripwise,seriewise net quantity
*/
CREATE PROCEDURE sub_rpt_albmwnetqty 
@membercode varchar(10),
@shortname varchar(21),
@settno varchar(7)
 AS
select s.sett_no,s1.short_name, s.series,s.scrip_cd,
netamt = isnull((select sum(tradeqty*marketrate) 
from trdbackup where sett_no=s.sett_no and sett_type=s.sett_type
and partipantcode=s.partipantcode and scrip_cd=s.scrip_cd 
and series=s.series and sell_buy= 1 
group by sett_no,sett_type,partipantcode,scrip_cd,series,sell_buy ),0)	
- isnull((select sum(tradeqty*marketrate) from trdbackup
 where sett_no=s.sett_no and sett_type=s.sett_type
and partipantcode=s.partipantcode and scrip_cd=s.scrip_cd 
and series=s.series and sell_buy= 2 
group by sett_no,sett_type,partipantcode,scrip_cd,series,sell_buy ),0)	
from trdbackup s , scrip1 s1 , scrip2 s2 
where s.sett_type='p' and s.order_no not  like 'p%'
and s.partipantcode like ltrim(@membercode)+'%' and
 s1.short_name=@shortname and s.sett_no=@settno
and s1.co_code=s2.co_code
and s2.scrip_cd=s.scrip_cd
and s.series=s2.series
and s2.series=s1.series
order by s.sett_no,s.sett_type,s.partipantcode,s.series,s1.short_name

GO
