-- Object: PROCEDURE dbo.rpt_conbrokeragebranchwise
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/*written by neelambari on 20 mar 2001*/
CREATE procedure rpt_conbrokeragebranchwise
@settno varchar(7),
@settype varchar(3)
as
if (select count(*) from settlement where sett_no = @settno and sett_type=@settype) > 0 
begin
	select  br.branch_cd , Brok=sum(s.brokapplied * s.tradeqty),
	DeliveryCharge = sum((s.Nbrokapp - s.Brokapplied) * s.tradeqty ) 
	from settlement s , client1 c1 , client2 c2 , branches br where
	s.sett_no =@settno
	and s.sett_type =@settype
	and c1.cl_code=c2.cl_code 
	and c1.trader=br.short_name
	and s.party_code=c2.party_code
	group by br.branch_cd
end
else
begin
	select  br.branch_cd , Brok=sum(s.brokapplied * s.tradeqty),
	DeliveryCharge = sum((s.Nbrokapp - s.Brokapplied) * s.tradeqty ) 
	from history s , client1 c1 , client2 c2 , branches br where
	s.sett_no =@settno
	and s.sett_type =@settype
	and c1.cl_code=c2.cl_code 
	and c1.trader=br.short_name
	and s.party_code=c2.party_code
	group by br.branch_cd
end

GO
