-- Object: PROCEDURE dbo.rpt_conbrklistofcltforsubrk
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/*
written by neelambari on 22 mar 2001
*/

CREATE proc rpt_conbrklistofcltforsubrk 
@settno varchar(7),
@settype varchar(3),
@subbroker varchar(13)
as 
if(select count(*) from  settlement where sett_no = @settno and sett_type=@settype) > 0 
begin
	select distinct h.Party_code,c1.Short_Name ,Brok=sum(h.brokapplied * h.tradeqty),
	DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
	from settlement h,client1 c1,client2 c2 ,subbrokers sb
	where h.party_code = c2.party_code
	and c1.cl_code = c2.cl_code 
	and sb.sub_broker =c1.sub_broker
	and h.sett_no = @settno
	and h.sett_type =@settype
	and c1.sub_broker = @subbroker
	group by h.party_code , c1.short_name
end 
else
begin
	select distinct h.Party_code,c1.Short_Name ,Brok=sum(h.brokapplied * h.tradeqty),
	DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
	from history h,client1 c1,client2 c2 ,subbrokers sb
	where h.party_code = c2.party_code
	and c1.cl_code = c2.cl_code 
	and sb.sub_broker =c1.sub_broker
	and h.sett_no = @settno
	and h.sett_type =@settype
	and c1.sub_broker = @subbroker
	group by h.party_code , c1.short_name
end

GO
