-- Object: PROCEDURE dbo.rpt_grossexpalbmw
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_grossexpalbmw    Script Date: 04/27/2001 4:32:42 PM ******/


/****** Object:  Stored Procedure dbo.rpt_grossexpalbmw    Script Date: 04/21/2001 6:05:25 PM ******/

/****** Object:  Stored Procedure dbo.rpt_grossexpalbmw    Script Date: 3/21/01 12:50:17 PM ******/

/****** Object:  Stored Procedure dbo.rpt_grossexpalbmw    Script Date: 20-Mar-01 11:38:58 PM ******/






/* report : gross exposure report
    file : wgrossexp.asp
 */
/* displays details of trades of a particular previous albm settlement */
/* changed by mousami on 05/03/2001
     added family login 
*/
CREATE PROCEDURE rpt_grossexpalbmw
@statusid varchar(15),
@statusname varchar(25),
@partyname varchar(21),
@scripcd varchar(12),
@partycode varchar(10),
@settno varchar(7)
AS
if @statusid = 'broker' 
begin
select party=(s.party_code),qty=sum(s.tradeqty),Amount=sum(s.tradeqty*s.rate),s.sell_buy,s.ser , c1.short_name, s.scrip_cd,
name=s.short_name, scripmargin=isnull((select addmargin from margin2 where sett_no=@settno and sett_type='P' and scrip_cd=s.scrip_cd) ,0),
fixmargin=isnull((select fixmargin from margin1 where sett_no=@settno and sett_type='p'),0)
from albmgrossexp s,client1 c1,client2 c2 
where c2.party_code = s.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%' 
and s.scrip_cd like  ltrim(@scripcd)+'%' and s.party_code like  ltrim(@partycode)+'%' and sett_no=@settno
group by c1.short_name,s.party_code,s.short_name,s.ser, s.scrip_cd,s.sell_buy 
order by c1.short_name,s.party_code,s.short_name,s.ser, s.scrip_cd,s.sell_buy 
end
if @statusid = 'branch' 
begin
select party=(s.party_code),qty=sum(s.tradeqty),Amount=sum(s.tradeqty*s.rate),s.sell_buy , s.ser , c1.short_name,  s.scrip_cd,
name=s.short_name, scripmargin=isnull((select addmargin from margin2 where sett_no=@settno and sett_type='p' and scrip_cd=s.scrip_cd) ,0),
fixmargin=isnull((select fixmargin from margin1 where sett_no=@settno and sett_type='p'),0)
from albmgrossexp s,client1 c1,client2 c2 , branches b
where c2.party_code = s.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%' 
and s.scrip_cd like  ltrim(@scripcd)+'%' and s.party_code like  ltrim(@partycode)+'%' and sett_no=@settno
and b.branch_cd=@statusname and b.short_name=c1.trader
group by c1.short_name,s.party_code,s.short_name,s.ser, s.scrip_cd,s.sell_buy 
order by c1.short_name,s.party_code,s.short_name,s.ser, s.scrip_cd,s.sell_buy 
end
if @statusid = 'trader' 
begin
select party=(s.party_code),qty=sum(s.tradeqty),Amount=sum(s.tradeqty*s.rate),s.sell_buy , s.ser, c1.short_name,  s.scrip_cd,
name=s.short_name, scripmargin=isnull((select addmargin from margin2 where sett_no=@settno and sett_type='p' and scrip_cd=s.scrip_cd) ,0),
fixmargin=isnull((select fixmargin from margin1 where sett_no=@settno and sett_type='p'),0)
from albmgrossexp s,client1 c1,client2 c2 
where c2.party_code = s.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%' 
and s.scrip_cd like  ltrim(@scripcd)+'%' and s.party_code like  ltrim(@partycode)+'%' and sett_no=@settno
and c1.trader=@statusname
group by c1.short_name,s.party_code,s.short_name,s.ser, s.scrip_cd,s.sell_buy 
order by c1.short_name,s.party_code,s.short_name,s.ser, s.scrip_cd,s.sell_buy 
end 
if @statusid = 'subbroker' 
begin
select party=(s.party_code),qty=sum(s.tradeqty),Amount=sum(s.tradeqty*s.rate),s.sell_buy ,s.ser,  c1.short_name, s.scrip_cd,
name=s.short_name, scripmargin=isnull((select addmargin from margin2 where sett_no=@settno and sett_type='p' and scrip_cd=s.scrip_cd) ,0),
fixmargin=isnull((select fixmargin from margin1 where sett_no=@settno and sett_type='p'),0)
from albmgrossexp s,client1 c1,client2 c2 , subbrokers sb
where c2.party_code = s.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%' 
and s.scrip_cd like  ltrim(@scripcd)+'%' and s.party_code like  ltrim(@partycode)+'%' and sett_no=@settno
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
group by c1.short_name,s.party_code,s.short_name,s.ser, s.scrip_cd,s.sell_buy 
order by c1.short_name,s.party_code,s.short_name,s.ser, s.scrip_cd,s.sell_buy 
end 
if @statusid = 'client' 
begin
select party=(s.party_code),qty=sum(s.tradeqty),Amount=sum(s.tradeqty*s.rate),s.sell_buy ,s.ser, c1.short_name,  s.scrip_cd,
name=s.short_name, scripmargin=isnull((select addmargin from margin2 where sett_no=@settno and sett_type='p' and scrip_cd=s.scrip_cd) ,0),
fixmargin=isnull((select fixmargin from margin1 where sett_no=@settno and sett_type='p'),0)
from albmgrossexp s,client1 c1,client2 c2 
where c2.party_code = s.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%' 
and s.scrip_cd like  ltrim(@scripcd)+'%' and s.party_code =@statusname and sett_no=@settno
group by c1.short_name,s.party_code,s.short_name,s.ser, s.scrip_cd,s.sell_buy 
order by c1.short_name,s.party_code,s.short_name,s.ser, s.scrip_cd,s.sell_buy 
end 

if @statusid = 'family' 
begin
select party=(s.party_code),qty=sum(s.tradeqty),Amount=sum(s.tradeqty*s.rate),s.sell_buy,s.ser , c1.short_name, s.scrip_cd,
name=s.short_name, scripmargin=isnull((select addmargin from margin2 where sett_no=@settno and sett_type='P' and scrip_cd=s.scrip_cd) ,0),
fixmargin=isnull((select fixmargin from margin1 where sett_no=@settno and sett_type='p'),0)
from albmgrossexp s,client1 c1,client2 c2 
where c2.party_code = s.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%' 
and s.scrip_cd like  ltrim(@scripcd)+'%' and s.party_code like  ltrim(@partycode)+'%' and sett_no=@settno
and c1.family=@statusname
group by c1.short_name,s.party_code,s.short_name,s.ser, s.scrip_cd,s.sell_buy 
order by c1.short_name,s.party_code,s.short_name,s.ser, s.scrip_cd,s.sell_buy 
end

GO
