-- Object: PROCEDURE dbo.rpt_conbrklstofcltforsbrkp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/*this gives list of clients of a particualr subbroker

modified by neelambari 27 mar 2001
changed the date format. beforechanging it was 103 foarmat
now that format is removed and  date is passed in mm/dd/yyyy format
*/

CREATE proc rpt_conbrklstofcltforsbrkp
@fdate varchar(12),
@tdate varchar(12),
@subbroker varchar(13)
as
/*if data present in settlement then  union of settlement and history else just take data from history*/
if (select count(*) from settlement where sauda_date >= @fdate   and 
	sauda_date <= @tdate + ' 23:59:59') > 0 
begin
	select distinct h.Party_code,c1.Short_Name ,Brok=sum(h.brokapplied * h.tradeqty),
	DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
	from settlement h,client1 c1,client2 c2 ,subbrokers sb
	where h.party_code = c2.party_code
	and c1.cl_code = c2.cl_code 
	and sb.sub_broker =c1.sub_broker
	and h.sauda_date >= @fdate   and 
	h.sauda_date  <= @tdate + ' 23:59:59'
	and c1.sub_broker = @subbroker
	group by h.party_code , c1.short_name
union all
	select distinct h.Party_code,c1.Short_Name ,Brok=sum(h.brokapplied * h.tradeqty),
	DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
	from history h,client1 c1,client2 c2 ,subbrokers sb
	where h.party_code = c2.party_code
	and c1.cl_code = c2.cl_code 
	and sb.sub_broker =c1.sub_broker
	and h.sauda_date >= @fdate   and 
	h.sauda_date <= @tdate + ' 23:59:59'
	and c1.sub_broker = @subbroker
	group by h.party_code , c1.short_name
	order by h.party_code , c1.short_name

end
else
begin
	select distinct h.Party_code,c1.Short_Name ,Brok=sum(h.brokapplied * h.tradeqty),
	DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
	from history h,client1 c1,client2 c2 ,subbrokers sb
	where h.party_code = c2.party_code
	and c1.cl_code = c2.cl_code 
	and sb.sub_broker =c1.sub_broker
	and h.sauda_date >= @fdate   and 
	h.sauda_date  <= @tdate + ' 23:59:59'
	and c1.sub_broker = @subbroker
	group by h.party_code , c1.short_name
	order by h.party_code , c1.short_name
 end

GO
