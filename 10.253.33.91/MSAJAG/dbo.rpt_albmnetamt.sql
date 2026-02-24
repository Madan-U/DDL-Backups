-- Object: PROCEDURE dbo.rpt_albmnetamt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_albmnetamt    Script Date: 04/27/2001 4:32:32 PM ******/

/* report : bill report 
     file : bill report.asp
*/
/*
    finds net amount for a particular party and scrip for a settlement number		
*/
/* changed by mousami on 9/4/2001
     selects net amount for  a party and scrip for a settlement number with albm rate
*/
/* changed by mousami on 2/4/2001 
     removed like for party code and added = */	


/****** Object:  Stored Procedure dbo.rpt_albmnetamt    Script Date: 12/27/00 8:59:08 PM ******/
CREATE PROCEDURE rpt_albmnetamt 
@partycode varchar(10),
@scripcd varchar(12),
@settno varchar(7)
AS

if ( select Count(sett_no) from settlement where sett_no =@settno and sett_type ='L' ) > 0 
begin

	select netamt = isnull((select amt from rpt_albmtradesett where sett_no=@settno 
	and party_code=@partycode and scrip_cd=@scripcd  and sell_buy= 1),0) 
	- isnull((select amt  from rpt_albmtradesett where sett_no=@settno 
	and party_code=@partycode and scrip_cd=@scripcd  and sell_buy= 2 ),0)
	
	
end 
else
begin 
	
	select netamt = isnull((select amt from rpt_albmtradehist  where sett_no=@settno  
	and party_code=@partycode and scrip_cd=@scripcd  and sell_buy= 1 
	 ),0) 
	- isnull((select amt  from rpt_albmtradehist where sett_no=@settno
	and party_code=@partycode and scrip_cd=@scripcd  and sell_buy= 2 
	 ),0) 
	

end

/*
if ( select Count(sett_no) from settlement where sett_no =@settno and sett_type ='L' ) > 0 
begin
select s.sett_no, s.series, s.scrip_cd,
netamt = isnull((select sum(tradeqty*marketrate) from settlement where sett_no=s.sett_no and sett_type=s.sett_type
and party_code=s.party_code and scrip_cd=s.scrip_cd and series=s.series and sell_buy= 1 and order_no not  like 'p%'
group by sett_no,sett_type,party_code,scrip_cd,series,sell_buy ),0) 
- isnull((select sum(tradeqty*marketrate) from settlement  where sett_no=s.sett_no and sett_type=s.sett_type
and party_code=s.party_code and scrip_cd=s.scrip_cd and series=s.series and sell_buy= 2 and  order_no not  like 'p%'
group by sett_no,sett_type,party_code,scrip_cd,series,sell_buy ),0) 
from settlement  s 
where s.sett_type='L' and s.order_no not  like 'p%'
and s.party_code =@partycode  and s.sett_no=@settno
and s.scrip_cd=@scripcd
group by s.sett_no,s.sett_type,s.party_code,s.series,s.scrip_cd
order by s.sett_no,s.sett_type,s.party_code,s.series,s.scrip_cd
end
else
begin
select s.sett_no, s.series, s.scrip_cd,
netamt = isnull((select sum(tradeqty*marketrate) from history where sett_no=s.sett_no and sett_type=s.sett_type
and party_code=s.party_code and scrip_cd=s.scrip_cd and series=s.series and sell_buy= 1 and order_no not  like 'p%'
group by sett_no,sett_type,party_code,scrip_cd,series,sell_buy ),0) 
- isnull((select sum(tradeqty*marketrate) from history where sett_no=s.sett_no and sett_type=s.sett_type
and party_code=s.party_code and scrip_cd=s.scrip_cd and series=s.series and sell_buy= 2 and order_no not  like 'p%'
group by sett_no,sett_type,party_code,scrip_cd,series,sell_buy ),0) 
from history  s 
where s.sett_type='L' and s.order_no not  like 'p%'
and s.party_code =@partycode  and s.sett_no=@settno
and s.scrip_cd=@scripcd
group by s.sett_no,s.sett_type,s.party_code,s.series,s.scrip_cd
order by s.sett_no,s.sett_type,s.party_code,s.series,s.scrip_cd
end
*/

GO
