-- Object: PROCEDURE dbo.rpt_confirmclients
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_confirmclients    Script Date: 04/21/2001 6:05:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_confirmclients    Script Date: 3/21/01 12:50:14 PM ******/

/****** Object:  Stored Procedure dbo.rpt_confirmclients    Script Date: 20-Mar-01 11:38:55 PM ******/





/****** Object:  Stored Procedure dbo.rpt_confirmclients    Script Date: 12/27/00 8:58:54 PM ******/
/* report :confirmation report
   file : confirmationclients.asp
*/
/* displays list of clients who have done trading today*/
CREATE PROCEDURE rpt_confirmclients
@statusid varchar(15),
@statusname varchar(25),
@partycode varchar(10),
@partyname varchar(21),
@trader varchar(12),
@tdate varchar(10)
AS

if @statusid = 'broker' 
begin
select distinct t.party_code,c1.short_name,c1.Cl_Code 
from Trade t, client1 c1,client2 c2 
where c1.cl_code = c2.cl_code and c2.party_code = t.party_code 
and t.party_code like ltrim(@partycode)+'%' and c1.short_name like ltrim(@partyname)+'%' 
and c1.trader like  ltrim(@trader)+'%' 
and convert(varchar,t.sauda_date,103)like  ltrim(@tdate)+'%' 
union all 
select distinct s.party_code,c1.short_name,c1.Cl_Code 
from settlement s, client1 c1,client2 c2 
where c1.cl_code = c2.cl_code and c2.party_code = s.party_code and s.party_code like  ltrim(@partycode)+'%' 
and c1.short_name like  ltrim(@partyname)+'%' and c1.trader like  ltrim(@trader)+'%' 
and convert(varchar,s.sauda_date,103)like  ltrim(@tdate)+'%' 
order by c1.short_name,t.party_code
end

if @statusid = 'branch' 
begin
select distinct t.party_code,c1.short_name,c1.Cl_Code 
from Trade t, client1 c1,client2 c2 , branches b
where c1.cl_code = c2.cl_code and c2.party_code = t.party_code 
and t.party_code like ltrim(@partycode)+'%' and c1.short_name like ltrim(@partyname)+'%' 
and c1.trader like  ltrim(@trader)+'%' 
and convert(varchar,t.sauda_date,103)like  ltrim(@tdate)+'%' 
and b.branch_cd=@statusname and b.short_name=c1.trader
union all 
select distinct s.party_code,c1.short_name,c1.Cl_Code 
from settlement s, client1 c1,client2 c2, branches b
where c1.cl_code = c2.cl_code and c2.party_code = s.party_code and s.party_code like  ltrim(@partycode)+'%' 
and c1.short_name like  ltrim(@partyname)+'%' and c1.trader like  ltrim(@trader)+'%' 
and convert(varchar,s.sauda_date,103)like  ltrim(@tdate)+'%' 
and b.branch_cd=@statusname and b.short_name=c1.trader
order by c1.short_name,t.party_code
end

if @statusid = 'trader' 
begin
select distinct t.party_code,c1.short_name,c1.Cl_Code 
from Trade t, client1 c1,client2 c2 
where c1.cl_code = c2.cl_code and c2.party_code = t.party_code 
and t.party_code like ltrim(@partycode)+'%' and c1.short_name like ltrim(@partyname)+'%' 
and c1.trader =@statusname 
and convert(varchar,t.sauda_date,103)like  ltrim(@tdate)+'%' 
union all 
select distinct s.party_code,c1.short_name,c1.Cl_Code 
from settlement s, client1 c1,client2 c2 
where c1.cl_code = c2.cl_code and c2.party_code = s.party_code and s.party_code like  ltrim(@partycode)+'%' 
and c1.short_name like  ltrim(@partyname)+'%' 
and c1.trader =@statusname and 
convert(varchar,s.sauda_date,103)like  ltrim(@tdate)+'%' 
order by c1.short_name,t.party_code
end 

if @statusid = 'subbroker' 
begin
select distinct t.party_code,c1.short_name,c1.Cl_Code 
from Trade t, client1 c1,client2 c2 , subbrokers sb
where c1.cl_code = c2.cl_code and c2.party_code = t.party_code 
and t.party_code like ltrim(@partycode)+'%' and c1.short_name like ltrim(@partyname)+'%' 
and c1.trader like  ltrim(@trader)+'%' 
and convert(varchar,t.sauda_date,103)like  ltrim(@tdate)+'%' 
and sb.sub_broker=@statusname and sb.sub_broker=c1.sub_broker
union all 
select distinct s.party_code,c1.short_name,c1.Cl_Code 
from settlement s, client1 c1,client2 c2 ,subbrokers sb
where c1.cl_code = c2.cl_code and c2.party_code = s.party_code and s.party_code like  ltrim(@partycode)+'%' 
and c1.short_name like  ltrim(@partyname)+'%' and c1.trader like  ltrim(@trader)+'%' 
and convert(varchar,s.sauda_date,103)like  ltrim(@tdate)+'%' 
and sb.sub_broker=@statusname and sb.sub_broker=c1.sub_broker
order by c1.short_name,t.party_code
end 

if @statusid = 'client'
begin
select distinct t.party_code,c1.short_name,c1.Cl_Code 
from Trade t, client1 c1,client2 c2 
where c1.cl_code = c2.cl_code and c2.party_code = t.party_code 
and t.party_code =@statusname 
and convert(varchar,t.sauda_date,103)like  ltrim(@tdate)+'%' 
union all 
select distinct s.party_code,c1.short_name,c1.Cl_Code 
from settlement s, client1 c1,client2 c2 
where c1.cl_code = c2.cl_code and c2.party_code = s.party_code and s.party_code =@statusname
and convert(varchar,s.sauda_date,103)like  ltrim(@tdate)+'%' 
order by c1.short_name,t.party_code
end

GO
