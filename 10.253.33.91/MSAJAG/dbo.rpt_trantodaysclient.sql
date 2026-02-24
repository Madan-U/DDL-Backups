-- Object: PROCEDURE dbo.rpt_trantodaysclient
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_trantodaysclient    Script Date: 04/27/2001 4:32:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_trantodaysclient    Script Date: 3/21/01 12:50:24 PM ******/

/****** Object:  Stored Procedure dbo.rpt_trantodaysclient    Script Date: 20-Mar-01 11:39:04 PM ******/





/****** Object:  Stored Procedure dbo.rpt_trantodaysclient    Script Date: 2/5/01 12:06:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_trantodaysclient    Script Date: 12/27/00 8:58:58 PM ******/

/* report : client transactions report 
   file : todaysclients.asp
*/
/* displays list of clients who have done trading today */
CREATE PROCEDURE rpt_trantodaysclient
@statusid varchar(15),
@statusname varchar(25),
@trader varchar(15),
@tdate varchar(10)
AS
if @statusid = "broker" 
begin
select distinct t.party_code,c1.short_name 
from Trade t, client1 c1,client2 c2 
where c1.cl_code = c2.cl_code and c2.party_code = t.party_code and 
c1.trader like ltrim(@trader)+'%' and convert(varchar,t.sauda_date,103) like ltrim(@tdate)+'%' 
order by c1.short_name,t.party_code 
end
if @statusid = "branch" 
begin
select distinct t.party_code,c1.short_name 
from Trade t, client1 c1,client2 c2 , branches b
where c1.cl_code = c2.cl_code and c2.party_code = t.party_code and 
c1.trader like ltrim(@trader)+'%' and convert(varchar,t.sauda_date,103) like ltrim(@tdate)+'%' 
and b.branch_cd=@statusname and b.short_name=c1.trader
order by c1.short_name,t.party_code 
end
if @statusid = "trader" 
begin
select distinct t.party_code,c1.short_name 
from Trade t, client1 c1,client2 c2 
where c1.cl_code = c2.cl_code and c2.party_code = t.party_code and 
c1.trader =@statusname and convert(varchar,t.sauda_date,103) like ltrim(@tdate)+'%' 
order by c1.short_name,t.party_code 
end 
if @statusid = "subbroker" 
begin
select distinct t.party_code,c1.short_name 
from Trade t, client1 c1,client2 c2, subbrokers sb 
where c1.cl_code = c2.cl_code and c2.party_code = t.party_code and 
c1.trader like ltrim(@trader)+'%' and convert(varchar,t.sauda_date,103) like ltrim(@tdate)+'%' 
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
order by c1.short_name,t.party_code 
end 
 if @statusid = "client" 
begin
select distinct t.party_code,c1.short_name 
from Trade t, client1 c1,client2 c2 
where c1.cl_code = c2.cl_code and c2.party_code = t.party_code
and convert(varchar,t.sauda_date,103) like ltrim(@tdate)+'%' 
and t.party_code=@statusname
order by c1.short_name,t.party_code 
end

GO
