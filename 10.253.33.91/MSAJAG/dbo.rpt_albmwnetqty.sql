-- Object: PROCEDURE dbo.rpt_albmwnetqty
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_albmwnetqty    Script Date: 04/27/2001 4:32:32 PM ******/




/* report: bill report
   file : albmwbill.asp
   displays settlement wise,  partywise, scripwise,seriewise net quantity
*/
/* changed  by mousami on 9/4/2001
     added tradeqty * albmrate instead of marketrate in calculation 
     Following two views do it	 
   */
CREATE PROCEDURE rpt_albmwnetqty 
@partycode varchar(10),
@scripcd  varchar(21),
@settno varchar(7)
 AS


if ( select Count(sett_no) from settlement where sett_no =@settno and sett_type ='L' ) > 0 
begin

	select netamt = isnull((select amt from rpt_albmwsett where sett_no=@settno 
	and party_code=@partycode and scrip_cd=@scripcd  and sell_buy= 1),0) 
	- isnull((select amt  from rpt_albmwsett where sett_no=@settno 
	and party_code=@partycode and scrip_cd=@scripcd  and sell_buy= 2 ),0)
	
	
end 
else
begin 
	
	select netamt = isnull((select amt from rpt_albmwhist  where sett_no=@settno  
	and party_code=@partycode and scrip_cd=@scripcd  and sell_buy= 1 
	 ),0) 
	- isnull((select amt  from rpt_albmwhist where sett_no=@settno
	and party_code=@partycode and scrip_cd=@scripcd  and sell_buy= 2 
	 ),0) 
	

end

/*
if ( select Count(sett_no) from settlement where sett_no =@settno and sett_type ='p' ) > 0 
begin
select s.sett_no,s1.short_name, s.series,s.scrip_cd,
netamt = isnull((select sum(tradeqty*marketrate) from settlement where sett_no=s.sett_no and sett_type=s.sett_type
and party_code=s.party_code and scrip_cd=s.scrip_cd and series=s.series and sell_buy= 1 
group by sett_no,sett_type,party_code,scrip_cd,series,sell_buy ),0) 
- isnull((select sum(tradeqty*marketrate) from settlement where sett_no=s.sett_no and sett_type=s.sett_type
and party_code=s.party_code and scrip_cd=s.scrip_cd and series=s.series and sell_buy= 2 
group by sett_no,sett_type,party_code,scrip_cd,series,sell_buy ),0) 
from settlement  s , scrip1 s1 , scrip2 s2 
where s.sett_type='p' and s.order_no not  like 'p%'
and s.party_code like ltrim(@partycode)+'%' and s1.short_name=@shortname and s.sett_no=@settno
and s1.co_code=s2.co_code
and s2.scrip_cd=s.scrip_cd
and s.series=s2.series
and s2.series=s1.series
order by s.sett_no,s.sett_type,s.party_code,s.series,s1.short_name
end
else
begin
select s.sett_no,s1.short_name, s.series,s.scrip_cd,
netamt = isnull((select sum(tradeqty*marketrate) from history where sett_no=s.sett_no and sett_type=s.sett_type
and party_code=s.party_code and scrip_cd=s.scrip_cd and series=s.series and sell_buy= 1 
group by sett_no,sett_type,party_code,scrip_cd,series,sell_buy ),0) 
- isnull((select sum(tradeqty*marketrate) from history where sett_no=s.sett_no and sett_type=s.sett_type
and party_code=s.party_code and scrip_cd=s.scrip_cd and series=s.series and sell_buy= 2 
group by sett_no,sett_type,party_code,scrip_cd,series,sell_buy ),0) 
from history s , scrip1 s1 , scrip2 s2 
where s.sett_type='p' and s.order_no not  like 'p%'
and s.party_code like ltrim(@partycode) +'%'
 and s1.short_name=@shortname and s.sett_no=@settno
and s1.co_code=s2.co_code
and s2.scrip_cd=s.scrip_cd
and s.series=s2.series
and s2.series=s1.series
order by s.sett_no,s.sett_type,s.party_code,s.series,s1.short_name
end

*/

GO
