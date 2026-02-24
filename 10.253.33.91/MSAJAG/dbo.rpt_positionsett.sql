-- Object: PROCEDURE dbo.rpt_positionsett
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_positionsett    Script Date: 04/27/2001 4:32:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_positionsett    Script Date: 3/21/01 12:50:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_positionsett    Script Date: 20-Mar-01 11:39:02 PM ******/

/****** Object:  Stored Procedure dbo.rpt_positionsett    Script Date: 2/5/01 12:06:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_positionsett    Script Date: 12/27/00 8:58:57 PM ******/

/* report : position report 
   file : positionreport.asp */
/* displays scripwise position of a party code for a particular settlement */
CREATE PROCEDURE rpt_positionsett
@statusid varchar(15),
@statusname varchar(25),
@partycode varchar(10),
@partyname varchar(21),
@settno varchar(7),
@settype varchar(3),
@scripcd varchar(12)
AS
if @statusid = "broker" 
begin
select s.party_code,c1.short_name,s.scrip_cd,s.series,
Quantity = sum(s.tradeqty),Amount = sum(s.amount),s.sell_buy 
from settlement s,client1 c1,client2 c2 
where s.party_code = c2.party_code and c1.cl_code = c2.cl_code 
and s.party_code like ltrim(@partycode)+'%' and c1.short_name like ltrim(@partyname)+'%' 
and s.scrip_cd like ltrim(@scripcd)+'%' and s.sett_no like ltrim(@settno)+'%' 
and s.sett_type like ltrim(@settype)+'%' 
group by s.party_code,c1.short_name,s.scrip_cd,s.series,s.sell_buy 
order by c1.short_name,s.party_code,s.scrip_cd,s.series,s.sell_buy 
end
if @statusid = "branch" 
begin
select s.party_code,c1.short_name,s.scrip_cd,s.series,
Quantity = sum(s.tradeqty),Amount = sum(s.amount),s.sell_buy 
from settlement s,client1 c1,client2 c2 , branches b
where s.party_code = c2.party_code and c1.cl_code = c2.cl_code 
and s.party_code like ltrim(@partycode)+'%' and c1.short_name like ltrim(@partyname)+'%' 
and s.scrip_cd like ltrim(@scripcd)+'%' and s.sett_no like ltrim(@settno)+'%' 
and s.sett_type like ltrim(@settype)+'%' 
and b.short_name=c1.trader and b.branch_cd=@statusname
group by s.party_code,c1.short_name,s.scrip_cd,s.series,s.sell_buy 
order by c1.short_name,s.party_code,s.scrip_cd,s.series,s.sell_buy 
end
if @statusid = "trader" 
begin
select s.party_code,c1.short_name,s.scrip_cd,s.series,
Quantity = sum(s.tradeqty),Amount = sum(s.amount),s.sell_buy 
from settlement s,client1 c1,client2 c2 
where s.party_code = c2.party_code and c1.cl_code = c2.cl_code 
and s.party_code like ltrim(@partycode)+'%' and c1.short_name like ltrim(@partyname)+'%' 
and s.scrip_cd like ltrim(@scripcd)+'%' and s.sett_no like ltrim(@settno)+'%' 
and s.sett_type like ltrim(@settype)+'%' and c1.trader=@statusname
group by s.party_code,c1.short_name,s.scrip_cd,s.series,s.sell_buy 
order by c1.short_name,s.party_code,s.scrip_cd,s.series,s.sell_buy 
end 
if @statusid = "subbroker" 
begin
select s.party_code,c1.short_name,s.scrip_cd,s.series,
Quantity = sum(s.tradeqty),Amount = sum(s.amount),s.sell_buy 
from settlement s,client1 c1,client2 c2 , subbrokers sb
where s.party_code = c2.party_code and c1.cl_code = c2.cl_code 
and s.party_code like ltrim(@partycode)+'%' and c1.short_name like ltrim(@partyname)+'%' 
and s.scrip_cd like ltrim(@scripcd)+'%' and s.sett_no like ltrim(@settno)+'%' 
and s.sett_type like ltrim(@settype)+'%' 
and sb.sub_broker=c1.sub_broker
and sb.sub_broker=@statusname
group by s.party_code,c1.short_name,s.scrip_cd,s.series,s.sell_buy 
order by c1.short_name,s.party_code,s.scrip_cd,s.series,s.sell_buy 
end 
if @statusid = "client" 
begin
select s.party_code,c1.short_name,s.scrip_cd,s.series,
Quantity = sum(s.tradeqty),Amount = sum(s.amount),s.sell_buy 
from settlement s,client1 c1,client2 c2 
where s.party_code = c2.party_code and c1.cl_code = c2.cl_code 
and s.party_code = @statusname
and s.scrip_cd like ltrim(@scripcd)+'%' and s.sett_no like ltrim(@settno)+'%' 
and s.sett_type like ltrim(@settype)+'%' 
group by s.party_code,c1.short_name,s.scrip_cd,s.series,s.sell_buy 
order by c1.short_name,s.party_code,s.scrip_cd,s.series,s.sell_buy 
end

GO
