-- Object: PROCEDURE dbo.rpt_conbroksubbrokerwise
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/*created by neelambari on 21 mar 2001*/

CREATE proc rpt_conbroksubbrokerwise 
@settno varchar(7),
@settype varchar(3)as
if( select count(*) from settlement where sett_no = @settno and sett_type=@settype)>0
begin
	select  c1.sub_broker , Brok=sum(s.brokapplied * s.tradeqty),
	DeliveryCharge = sum((s.Nbrokapp - s.Brokapplied) * s.tradeqty ) 
	from settlement s , client1 c1 , client2 c2 ,subbrokers sb where
	c1.cl_code=c2.cl_code 
	and sb.sub_broker = c1.sub_broker
	and s.party_code=c2.party_code
	and s.sett_no = @settno
	and s.sett_type = @settype
	group by c1.sub_broker
	order by c1.sub_broker
end
else
begin
	select  c1.sub_broker , Brok=sum(s.brokapplied * s.tradeqty),
	DeliveryCharge = sum((s.Nbrokapp - s.Brokapplied) * s.tradeqty ) 
	from history s , client1 c1 , client2 c2 ,subbrokers sb where
	c1.cl_code=c2.cl_code 
	and sb.sub_broker = c1.sub_broker
	and s.party_code=c2.party_code
	and s.sett_no = @settno
	and s.sett_type = @settype
	group by c1.sub_broker
	order by c1.sub_broker
end

GO
