-- Object: PROCEDURE dbo.rpt_albmnextnetamt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_albmnextnetamt    Script Date: 04/27/2001 4:32:32 PM ******/

/* report : bill report 
     file : billreport.asp
*/
/* finds net amount for next albm settlement for a particular party and scripcd */
/* changed by mousami on 02/04/2001
     added = to partycode instead of like */


/****** Object:  Stored Procedure dbo.rpt_albmnextnetamt    Script Date: 12/27/00 8:59:08 PM ******/

CREATE PROCEDURE rpt_albmnextnetamt 
@partycode varchar(10),
@settno varchar(7)
AS

if ( select Count(sett_no) from settlement where sett_no =@settno and sett_type ='L' ) > 0 
begin

	select s.scrip_cd,s.party_code ,netamt = abs(isnull((select amt from rpt_albmnewmarginamt where s.sett_no=sett_no
	and s.party_code=party_code  and sell_buy = 1 and s.scrip_cd=scrip_cd and s.sett_type=sett_type and s.series=series),0) 
	- isnull((select amt  from rpt_albmnewmarginamt where s.sett_no=sett_no
	and s.party_code=party_code  and sell_buy = 2 and s.scrip_cd=scrip_cd and s.sett_type=sett_type and s.series=series),0))
	from  rpt_albmnewmarginamt s 
	where s.party_code=@partycode and s.sett_no=@settno
	order by s.sett_type,s.sett_no,s.party_code,s.series,s.scrip_cd , s.sell_buy 
	/*
	select netamt =abs( isnull((select amt from rpt_albmnewmarginamt where sett_no=@settno 
	and party_code=@partycode  and sell_buy= 1),0) 
	- isnull((select amt  from rpt_albmnewmarginamt where sett_no=@settno 
	and party_code=@partycode  and sell_buy= 2 ),0))
	*/
	
end 
else
begin 
	select s.scrip_cd,s.party_code ,netamt = abs(isnull((select amt from  rpt_albmnewmarginamthist where s.sett_no=sett_no
	and s.party_code=party_code  and sell_buy = 1 and s.scrip_cd=scrip_cd and s.sett_type=sett_type and s.series=series),0) 
	- isnull((select amt  from  rpt_albmnewmarginamthist where s.sett_no=sett_no
	and s.party_code=party_code  and sell_buy = 2 and s.scrip_cd=scrip_cd and s.sett_type=sett_type and s.series=series),0))
	from  rpt_albmnewmarginamt s 
	where s.party_code=@partycode  and s.sett_no=@settno
	order by s.sett_type,s.sett_no,s.party_code,s.series,s.scrip_cd , s.sell_buy 
	/*
	select netamt = abs(isnull((select amt from rpt_albmnewmarginamthist  where sett_no=@settno  
	and party_code=@partycode and  sell_buy= 1 
	 ),0) 
	- isnull((select amt  from rpt_albmnewmarginamthist where sett_no=@settno
	and party_code=@partycode and  sell_buy= 2 
	 ),0) )
	*/

end


/*
if ( select Count(sett_no) from settlement where sett_no =@settno and sett_type ='L' ) > 0 
begin
select s.sett_no, s.series, s.scrip_cd, s.party_code,
netamt = isnull((select sum(tradeqty*marketrate) from settlement where sett_no=s.sett_no and sett_type=s.sett_type
and party_code=s.party_code and series=s.series and sell_buy= 1 and scrip_cd = s.scrip_cd  AND order_no not  like 'p%'
group by sett_no,sett_type,party_code,series,sell_buy ),0) 
- isnull((select sum(tradeqty*marketrate) from settlement  where sett_no=s.sett_no and sett_type=s.sett_type
and party_code=s.party_code  and series=s.series and sell_buy= 2 and scrip_cd = s.scrip_cd and order_no not  like 'p%'
group by sett_no,sett_type,party_code,series,sell_buy ),0) 
from settlement  s 
where s.sett_type='L' and s.order_no not  like 'p%'
and s.party_code =@partycode  and s.sett_no=@settno
group by s.sett_no,s.sett_type,s.party_code,s.scrip_cd,s.series
order by s.sett_no,s.sett_type,s.party_code,s.series
end
else
begin
select s.sett_no, s.series, s.scrip_cd, s.party_code,
netamt = isnull((select sum(tradeqty*marketrate) from history where sett_no=s.sett_no and sett_type=s.sett_type
and party_code=s.party_code and series=s.series and sell_buy= 1 and scrip_cd = s.scrip_cd and order_no not  like 'p%'
group by sett_no,sett_type,party_code,series,sell_buy ),0) 
- isnull((select sum(tradeqty*marketrate) from history  where sett_no=s.sett_no and sett_type=s.sett_type
and party_code=s.party_code  and series=s.series and sell_buy= 2 and scrip_cd = s.scrip_cd and order_no not  like 'p%'
group by sett_no,sett_type,party_code,series,sell_buy ),0) 
from history  s 
where s.sett_type='L' and s.order_no not  like 'p%'
and s.party_code =@partycode and s.sett_no=@settno
group by s.sett_no,s.sett_type,s.party_code,s.scrip_cd,s.series
order by s.sett_no,s.sett_type,s.party_code,s.series
end
*/

GO
