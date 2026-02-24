-- Object: PROCEDURE dbo.rpt_conbrokcltlistfortrd
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE procedure rpt_conbrokcltlistfortrd
@settno varchar(7),
@settype varchar(3),
@trader varchar(20)
as
if (select count(*) from settlement where sett_no = @settno and sett_type=@settype )>0
begin
	select distinct h.Party_code,c1.Short_Name ,Brok=sum(h.brokapplied * h.tradeqty),
	DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
	from settlement h,client1 c1,client2 c2 
	where h.party_code = c2.party_code and c1.cl_code = c2.cl_code 
	and h.sett_no =@settno
	and h.sett_type = @settype
	and c1.trader =@trader
	group by h.party_code,c1.Short_Name,c1.trader 
end
else
begin
	select distinct h.Party_code,c1.Short_Name ,Brok=sum(h.brokapplied * h.tradeqty),
	DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
	from history h,client1 c1,client2 c2 
	where h.party_code = c2.party_code and c1.cl_code = c2.cl_code 
	and h.sett_no =@settno
	and h.sett_type = @settype
	and c1.trader =@trader
	group by h.party_code,c1.Short_Name,c1.trader 
end

GO
