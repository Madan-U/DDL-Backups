-- Object: PROCEDURE dbo.rpt_contotofsbrkp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/*this gives us the total  broekrage and delivery charge collected  by paricular subbroker

modified by neelambari 27 mar 2001
changed the date format. beforechanging it was 103 foarmat
now that format is removed and  date is passed in mm/dd/yyyy format
*/
CREATE proc rpt_contotofsbrkp
@fdate varchar(12),
@tdate varchar(12),
@subbroker varchar(13)
as
/*if data present in settlement then  union of settlement and history else just take data from history*/
if (select count(*) from settlement where sauda_date >= @fdate   and 
	 sauda_date  <= @tdate + ' 23:59:59') > 0 
begin
	select    Brok=isnull(sum(s.brokapplied * s.tradeqty),0),
	DeliveryCharge =isnull( sum((s.Nbrokapp - s.Brokapplied) * s.tradeqty ),0) 
	from settlement s , client1 c1 , client2 c2 , subbrokers sb where
	c1.cl_code=c2.cl_code 
	and sb.sub_broker = c1.sub_broker
	and s.party_code=c2.party_code
	and s.sauda_date  >= @fdate   and 
	 s.sauda_date  <= @tdate + ' 23:59:59'
	and c1.sub_broker = @subbroker
	union all
	select    Brok=isnull(sum(s.brokapplied * s.tradeqty),0),
	DeliveryCharge = isnull(sum((s.Nbrokapp - s.Brokapplied) * s.tradeqty ),0)
	from history s , client1 c1 , client2 c2 , subbrokers sb where
	c1.cl_code=c2.cl_code 
	and sb.sub_broker = c1.sub_broker
	and s.party_code=c2.party_code
	and s.sauda_date >= @fdate   and 
	s.sauda_date <= @tdate + ' 23:59:59'
	and c1.sub_broker = @subbroker
end
else
begin

select    Brok=isnull(sum(s.brokapplied * s.tradeqty),0),
	DeliveryCharge =isnull( sum((s.Nbrokapp - s.Brokapplied) * s.tradeqty ),0)
	from history s , client1 c1 , client2 c2 , subbrokers sb where
	c1.cl_code=c2.cl_code 
	and sb.sub_broker = c1.sub_broker
	and s.party_code=c2.party_code
	and s.sauda_date >= @fdate   and 
	s.sauda_date <= @tdate + ' 23:59:59'
	and c1.sub_broker = @subbroker
end

GO
