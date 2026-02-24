-- Object: PROCEDURE dbo.rpt_conbroktraderwisep
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/*
this query gie us the list of traders and total brokerage and delivery charge collected by each of then

modified by neelambari 27 mar 2001
changed the date format. beforechanging it was 103 foarmat
now that format is removed and  date is passed in mm/dd/yyyy format
*/

CREATE proc rpt_conbroktraderwisep
@fdate varchar(12),
@tdate varchar(12),
@branchcd varchar(3)
as

/*if data present in settlement then  union of settlement and history else just take data from history*/
if (select count(*) from settlement where sauda_date >= @fdate   and 
	sauda_date <= @tdate + ' 23:59:59') > 0 
begin
	select  c1.trader  , Brok=sum(s.brokapplied * s.tradeqty),
	DeliveryCharge = sum((s.Nbrokapp - s.Brokapplied) * s.tradeqty ) 
	from settlement s , client1 c1 , client2 c2 , branches br where
	c1.cl_code=c2.cl_code 
	and br.short_name = c1.trader
	and s.party_code=c2.party_code and
	s.sauda_date >= @fdate   and 
	s.sauda_date  <= @tdate + ' 23:59:59'
	and br.branch_cd = @branchcd
	group by c1.trader 
	union all
	select  c1.trader  , Brok=sum(s.brokapplied * s.tradeqty),
	DeliveryCharge = sum((s.Nbrokapp - s.Brokapplied) * s.tradeqty ) 
	from history s , client1 c1 , client2 c2 , branches br where
	c1.cl_code=c2.cl_code 
	and br.short_name = c1.trader
	and s.party_code=c2.party_code and
	s.sauda_date >= @fdate   and 
	s.sauda_date  <= @tdate + ' 23:59:59'
	and br.branch_cd = @branchcd
	group by c1.trader 
	order by c1.trader 
end
else
begin
	select  c1.trader  , Brok=sum(s.brokapplied * s.tradeqty),
	DeliveryCharge = sum((s.Nbrokapp - s.Brokapplied) * s.tradeqty ) 
	from settlement s , client1 c1 , client2 c2 , branches br where
	c1.cl_code=c2.cl_code 
	and br.short_name = c1.trader
	and s.party_code=c2.party_code and
	s.sauda_date >= @fdate   and 
	s.sauda_date  <= @tdate + ' 23:59:59'
	and br.branch_cd = @branchcd
	group by c1.trader 
	order by c1.trader 
end

GO
