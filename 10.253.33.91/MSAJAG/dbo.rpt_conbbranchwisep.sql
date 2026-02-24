-- Object: PROCEDURE dbo.rpt_conbbranchwisep
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/*written by neelambari on 22 mar 2001
modified by neelambari 27 mar 2001
changed the date format. beforechanging it was 103 foarmat
now that format is removed and  date is passed in mm/dd/yyyy format
*/

CREATE proc  rpt_conbbranchwisep
@fdate varchar(12),
@tdate	varchar(12)
as
if (select count(*) from settlement where sauda_date >= @fdate   and 
	sauda_date <= @tdate + ' 23:59:59') > 0 
/*if data present in settlement then  union of settlement and history else just take data from history*/
begin
	select  br.branch_cd , Brok=sum(s.brokapplied * s.tradeqty),
	DeliveryCharge = sum((s.Nbrokapp - s.Brokapplied) * s.tradeqty ) 
	from settlement s , client1 c1 , client2 c2 , branches br where
	s.sauda_date >= @fdate   and 
	s.sauda_date  <= @tdate + ' 23:59:59'
	and c1.cl_code=c2.cl_code 
	and c1.trader=br.short_name
	and s.party_code=c2.party_code
	group by br.branch_cd
	
	union all
	select  br.branch_cd , Brok=sum(s.brokapplied * s.tradeqty),
	DeliveryCharge = sum((s.Nbrokapp - s.Brokapplied) * s.tradeqty ) 
	from history s , client1 c1 , client2 c2 , branches br where
	s.sauda_date >= @fdate   and 
	s.sauda_date  <= @tdate + ' 23:59:59'
	and c1.cl_code=c2.cl_code 
	and c1.trader=br.short_name
	and s.party_code=c2.party_code
	group by br.branch_cd
	order by br.branch_cd
end 
else

begin
	select  br.branch_cd , Brok=sum(s.brokapplied * s.tradeqty),
	DeliveryCharge = sum((s.Nbrokapp - s.Brokapplied) * s.tradeqty ) 
	from history s , client1 c1 , client2 c2 , branches br where
	s.sauda_date >= @fdate   and 
	s.sauda_date  <= @tdate + ' 23:59:59'
	and c1.cl_code=c2.cl_code 
	and c1.trader=br.short_name
	and s.party_code=c2.party_code
	group by br.branch_cd
	order by br.branch_cd
end

GO
