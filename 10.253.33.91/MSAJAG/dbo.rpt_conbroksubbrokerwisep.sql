-- Object: PROCEDURE dbo.rpt_conbroksubbrokerwisep
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/*
gives us details about all subbrokers
i.e subbrokername , total brokerage  and delivery charge collected by each of them

modified by neelambari 27 mar 2001
changed the date format. beforechanging it was 103 foarmat
now that format is removed and  date is passed in mm/dd/yyyy format
*/

CREATE procedure rpt_conbroksubbrokerwisep
@fdate varchar(12),
@tdate varchar(12)
as
/*if data present in settlement then  union of settlement and history else just take data from history*/
if (select count(*) from settlement where sauda_date>= @fdate   and 
	sauda_date <= @tdate + ' 23:59:59') > 0 
begin
	select  c1.sub_broker , Brok=sum(s.brokapplied * s.tradeqty),
	DeliveryCharge = sum((s.Nbrokapp - s.Brokapplied) * s.tradeqty ) 
	from settlement s , client1 c1 , client2 c2 ,subbrokers sb where
	c1.cl_code=c2.cl_code 
	and sb.sub_broker = c1.sub_broker
	and s.party_code=c2.party_code
	and s.sauda_date >= @fdate   and 
	s.sauda_date  <= @tdate + ' 23:59:59'
	group by c1.sub_broker
	
	union all
	select  c1.sub_broker , Brok=sum(s.brokapplied * s.tradeqty),
	DeliveryCharge = sum((s.Nbrokapp - s.Brokapplied) * s.tradeqty ) 
	from history s , client1 c1 , client2 c2 ,subbrokers sb where
	c1.cl_code=c2.cl_code 
	and sb.sub_broker = c1.sub_broker
	and s.party_code=c2.party_code
	and s.sauda_date >= @fdate   and 
	s.sauda_date  <= @tdate + ' 23:59'
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
	and s.sauda_date >= @fdate   and 
	 s.sauda_date<= @tdate + ' 23:59:59'
	group by c1.sub_broker
	order by c1.sub_broker
end

GO
