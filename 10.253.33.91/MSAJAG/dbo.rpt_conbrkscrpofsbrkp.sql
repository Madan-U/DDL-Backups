-- Object: PROCEDURE dbo.rpt_conbrkscrpofsbrkp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE proc rpt_conbrkscrpofsbrkp
@fdate varchar(12),
@tdate varchar(12),
@subbrokername varchar(13)
as
/*if data present in settlement then  union of settlement and history else just take data from history*/
if (select count(*) from settlement where sauda_date>= @fdate   and 
	sauda_date  <= @tdate + ' 23:59:59') > 0 
begin
	select distinct h.scrip_cd ,Brok=sum(h.brokapplied * h.tradeqty),
	DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
	from settlement h,client1 c1,client2 c2 ,subbrokers sb
	where h.party_code = c2.party_code 
	and c1.cl_code = c2.cl_code 
	and c1.sub_broker = sb.sub_broker
	and h.sauda_date >= @fdate   and 
	h.sauda_date  <= @tdate + ' 23:59:59'
	and c1.sub_broker = @subbrokername
	group by h.scrip_cd
	 
	union all
	select distinct h.scrip_cd ,Brok=sum(h.brokapplied * h.tradeqty),
	DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
	from history h,client1 c1,client2 c2 ,subbrokers sb
	where h.party_code = c2.party_code 
	and c1.cl_code = c2.cl_code 
	and c1.sub_broker = sb.sub_broker and
	h.sauda_date>= @fdate   and 
	h.sauda_date  <= @tdate + ' 23:59:59'
	and c1.sub_broker = @subbrokername
	group by h.scrip_cd
	order by h.scrip_cd
end
else
begin
	select distinct h.scrip_cd ,Brok=sum(h.brokapplied * h.tradeqty),
	DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
	from history h,client1 c1,client2 c2 ,subbrokers sb
	where h.party_code = c2.party_code 
	and c1.cl_code = c2.cl_code 
	and c1.sub_broker = sb.sub_broker
	and h.sauda_date >= @fdate   and 
	h.sauda_date  <= @tdate + ' 23:59:59'
	and c1.sub_broker = @subbrokername
	group by h.scrip_cd
	order by h.scrip_cd

end

GO
