-- Object: PROCEDURE dbo.rpt_grossexpalbm
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/* report : gross exposure report
    file : grossexptrdset.asp 
 */
/* displays details of trades of a particular previous albm settlement */
/* added family login  on 05/03/2001 by mousami */
CREATE PROCEDURE rpt_grossexpalbm
@statusid varchar(15),
@statusname varchar(25),
@partyname varchar(21),
@scripcd varchar(12),
@partycode varchar(10),
@settno varchar(7)
AS
if @statusid = 'broker' 
begin
select party=(s.party_code),s.scrip_cd,s.series,qty=sum(s.tradeqty),Amount=sum(s.tradeqty*s.marketrate),s.sell_buy 
from settlement s,client1 c1,client2 c2 
where c2.party_code = s.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%' 
and s.scrip_cd like  ltrim(@scripcd)+'%' and s.party_code like  ltrim(@partycode)+'%' and sett_no=@settno
and sett_type='l' 
group by c1.short_name,s.party_code,s.scrip_cd,s.series,s.sell_buy 
end
if @statusid = 'branch' 
begin
select party=(s.party_code),s.scrip_cd,s.series,qty=sum(s.tradeqty),Amount=sum(s.tradeqty*s.marketrate),s.sell_buy 
from settlement s,client1 c1,client2 c2 , branches b
where c2.party_code = s.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%' 
and s.scrip_cd like  ltrim(@scripcd)+'%' and s.party_code like  ltrim(@partycode)+'%' and sett_no=@settno
and sett_type='l' 
and b.branch_cd=@statusname and b.short_name=c1.trader
group by c1.short_name,s.party_code,s.scrip_cd,s.series,s.sell_buy 
end
if @statusid = 'trader' 
begin
select party=(s.party_code),s.scrip_cd,s.series,qty=sum(s.tradeqty),Amount=sum(s.tradeqty*s.marketrate),s.sell_buy 
from settlement s,client1 c1,client2 c2 
where c2.party_code = s.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%' 
and s.scrip_cd like  ltrim(@scripcd)+'%' and s.party_code like  ltrim(@partycode)+'%' and sett_no=@settno
and sett_type='l' 
and c1.trader=@statusname
group by c1.short_name,s.party_code,s.scrip_cd,s.series,s.sell_buy 
end 
if @statusid = 'subbroker' 
begin
select party=(s.party_code),s.scrip_cd,s.series,qty=sum(s.tradeqty),Amount=sum(s.tradeqty*s.marketrate),s.sell_buy 
from settlement s,client1 c1,client2 c2 , subbrokers sb
where c2.party_code = s.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%' 
and s.scrip_cd like  ltrim(@scripcd)+'%' and s.party_code like  ltrim(@partycode)+'%' and sett_no=@settno
and sett_type='l' 
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
group by c1.short_name,s.party_code,s.scrip_cd,s.series,s.sell_buy 
end 
if @statusid = 'client' 
begin
select party=(s.party_code),s.scrip_cd,s.series,qty=sum(s.tradeqty),Amount=sum(s.tradeqty*s.marketrate),s.sell_buy 
from settlement s,client1 c1,client2 c2 
where c2.party_code = s.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%' 
and s.scrip_cd like  ltrim(@scripcd)+'%' and s.party_code =@statusname and sett_no=@settno
and sett_type='l' 
group by c1.short_name,s.party_code,s.scrip_cd,s.series,s.sell_buy 
end 
if @statusid = 'family' 
begin
select party=(s.party_code),s.scrip_cd,s.series,qty=sum(s.tradeqty),Amount=sum(s.tradeqty*s.marketrate),s.sell_buy 
from settlement s,client1 c1,client2 c2 
where c2.party_code = s.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%' 
and s.scrip_cd like  ltrim(@scripcd)+'%' and s.party_code like  ltrim(@partycode)+'%' and sett_no=@settno
and sett_type='l' 
and  c1.family=@statusname
group by c1.short_name,s.party_code,s.scrip_cd,s.series,s.sell_buy 
end

GO
