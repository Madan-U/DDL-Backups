-- Object: PROCEDURE dbo.rpt_conbrokcltlstfortrdp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/*this qury gives us the list of all clients for a particular trader

modified by neelambari 27 mar 2001
changed the date format. beforechanging it was 103 foarmat
now that format is removed and  date is passed in mm/dd/yyyy format
 */

CREATE procedure rpt_conbrokcltlstfortrdp
@fdate varchar(12),
@tdate varchar(12),
@trader varchar(20)
as

/*if data present in settlement then  union of settlement and history else just take data from history*/
if (select count(*) from settlement where sauda_date >= @fdate   and 
	sauda_date  <= @tdate + ' 23:59:59') > 0 
begin
	select distinct h.Party_code,c1.Short_Name ,Brok=sum(h.brokapplied * h.tradeqty),
	DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
	from settlement h,client1 c1,client2 c2 
	where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and
	h.sauda_date >= @fdate   and 
 	h.sauda_date  <= @tdate + ' 23:59:59'
	and c1.trader =@trader
	group by h.party_code,c1.Short_Name,c1.trader 
	union all
	select distinct h.Party_code,c1.Short_Name ,Brok=sum(h.brokapplied * h.tradeqty),
	DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
	from history h,client1 c1,client2 c2 
	where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and
	h.sauda_date >= @fdate   and 
 	h.sauda_date  <= @tdate + ' 23:59:59'
	and c1.trader =@trader
	group by h.party_code,c1.Short_Name
	order by h.party_code,c1.Short_Name
end
else
begin
select distinct h.Party_code,c1.Short_Name ,Brok=sum(h.brokapplied * h.tradeqty),
	DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
	from history h,client1 c1,client2 c2 
	where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and
	h.sauda_date >= @fdate   and 
 	h.sauda_date <= @tdate + ' 23:59:59'
	and c1.trader =@trader
	group by h.party_code,c1.Short_Name 
	order by  h.party_code,c1.Short_Name 
end

GO
