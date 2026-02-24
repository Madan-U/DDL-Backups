-- Object: PROCEDURE dbo.rpt_clientlist
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_clientlist    Script Date: 10/13/01 3:12:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_clientlist    Script Date: 10/11/01 3:10:10 PM ******/
create  procedure rpt_clientlist

@order_by as varchar(9)

as

if @order_by='Branch'

begin

select distinct c1.short_name,c1.long_name,c1.res_phone1,c1.off_phone1,c1.cl_code,c1.email,
c1.branch_cd,c1.family,c1.sub_broker,c1.trader,
c2.party_code,c2.turnover_tax,c2.sebi_turn_tax,insurance_chrg,brokernote,other_chrg,
c3.branch,c4.short_name as trader_name,c5.name,c5.com_perc,c1.pan_gir_no
from client1 c1,client2 c2,branch c3,branches c4,subbrokers c5
where c1.cl_code=c2.cl_code and
c1.branch_cd=c3.branch_code and
c1.trader=c4.short_name and
c1.sub_broker=c5.sub_broker and
c3.branch_code=c4.branch_cd

order by c1.branch_cd,c2.party_code

end


if @order_by='SubBroker'

begin

select distinct c1.short_name,c1.long_name,c1.res_phone1,c1.off_phone1,c1.cl_code,c1.email,
c1.branch_cd,c1.family,c1.sub_broker,c1.trader,
c2.party_code,c2.turnover_tax,c2.sebi_turn_tax,insurance_chrg,brokernote,other_chrg,
c3.branch,c4.short_name as trader_name,c5.name,c5.com_perc,c1.pan_gir_no
from client1 c1,client2 c2,branch c3,branches c4,subbrokers c5
where c1.cl_code=c2.cl_code and
c1.branch_cd=c3.branch_code and
c1.trader=c4.short_name and
c1.sub_broker=c5.sub_broker and
c3.branch_code=c4.branch_cd

order by c1.sub_broker,c2.party_code

end

if @order_by='Client'

begin

select distinct c1.short_name,c1.long_name,c1.res_phone1,c1.off_phone1,c1.cl_code,c1.email,
c1.branch_cd,c1.family,c1.sub_broker,c1.trader,
c2.party_code,c2.turnover_tax,c2.sebi_turn_tax,insurance_chrg,brokernote,other_chrg,
c3.branch,c4.short_name as trader_name,c5.name,c5.com_perc,c1.pan_gir_no
from client1 c1,client2 c2,branch c3,branches c4,subbrokers c5
where c1.cl_code=c2.cl_code and
c1.branch_cd=c3.branch_code and
c1.trader=c4.short_name and
c1.sub_broker=c5.sub_broker and
c3.branch_code=c4.branch_cd

order by c1.short_name

end

GO
