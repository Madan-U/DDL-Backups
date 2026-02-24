-- Object: PROCEDURE dbo.rpt_conbrkgtotoftrd
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/*written by neelambri on 21 mar 2001*/
CREATE proc rpt_conbrkgtotoftrd 
@settno varchar(7),
@settype varchar(3),
@trader varchar(20)
as
if( select count(*) from settlement where sett_no = @settno and sett_type=@settype )>0
begin
	select  c1.trader  , Brok=sum(s.brokapplied * s.tradeqty),
	DeliveryCharge = sum((s.Nbrokapp - s.Brokapplied) * s.tradeqty ) 
	from settlement s , client1 c1 , client2 c2 , branches br where
	c1.cl_code=c2.cl_code 
	and br.short_name = c1.trader
	and s.party_code=c2.party_code
	and s.sett_no =@settno
	and s.sett_type =@settype
	 and c1.trader =@trader
	group by c1.trader 
	order by c1.trader 
end
else
begin
	select  c1.trader  , Brok=sum(s.brokapplied * s.tradeqty),
	DeliveryCharge = sum((s.Nbrokapp - s.Brokapplied) * s.tradeqty ) 
	from history s , client1 c1 , client2 c2 , branches br where
	c1.cl_code=c2.cl_code 
	and br.short_name = c1.trader
	and s.party_code=c2.party_code
	and s.sett_no =@settno
	and s.sett_type =@settype
	 and c1.trader =@trader
	group by c1.trader 
	order by c1.trader 
end

GO
