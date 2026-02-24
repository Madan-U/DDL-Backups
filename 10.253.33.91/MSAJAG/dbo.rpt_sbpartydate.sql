-- Object: PROCEDURE dbo.rpt_sbpartydate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_sbpartydate    Script Date: 04/27/2001 4:32:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sbpartydate    Script Date: 3/21/01 12:50:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sbpartydate    Script Date: 20-Mar-01 11:39:03 PM ******/





/****** Object:  Stored Procedure dbo.rpt_sbpartydate    Script Date: 2/5/01 12:06:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sbpartydate    Script Date: 12/27/00 8:58:58 PM ******/

/* report : misnews
   file : allparty.asp
*/
/* displays list of clients who have done trading today */
/* changed by mousami on 6th March 2001 
     added family login */

CREATE PROCEDURE rpt_sbpartydate
@statusid varchar(15),
@statusname varchar(25),
@trader varchar(15),
@sdate varchar(12)
AS
if @statusid='broker'
begin
select distinct t.party_code,c1.short_name 
from Trade4432 t, client1 c1,client2 c2
where c1.cl_code = c2.cl_code and c2.party_code = t.party_code 
and c1.trader like ltrim(@trader)+'%'
and convert(varchar,t.sauda_date,101)=@sdate
order by c1.short_name,t.party_code 
end
if @statusid='branch'
begin
select distinct t.party_code,c1.short_name 
from Trade4432 t, client1 c1,client2 c2, branches b
where c1.cl_code = c2.cl_code and c2.party_code = t.party_code 
and c1.trader like ltrim(@trader)+'%'
and convert(varchar,t.sauda_date,101)=@sdate
and b.branch_cd=@statusname and b.short_name=c1.trader
order by c1.short_name,t.party_code 
end
if @statusid='subbroker'
begin
select distinct t.party_code,c1.short_name 
from Trade4432 t, client1 c1,client2 c2, subbrokers sb
where c1.cl_code = c2.cl_code and c2.party_code = t.party_code 
and c1.trader like ltrim(@trader)+'%'
and convert(varchar,t.sauda_date,101)=@sdate
and sb.sub_broker=c1.sub_broker and 
sb.sub_broker=@statusname
order by c1.short_name,t.party_code 
end
if @statusid='trader'
begin
select distinct t.party_code,c1.short_name 
from Trade4432 t, client1 c1,client2 c2
where c1.cl_code = c2.cl_code and c2.party_code = t.party_code 
and c1.trader like ltrim(@trader)+'%'
and convert(varchar,t.sauda_date,101)=@sdate
and c1.trader=@statusname
order by c1.short_name,t.party_code 
end
if @statusid='client'
begin
select distinct t.party_code,c1.short_name 
from Trade4432 t, client1 c1,client2 c2
where c1.cl_code = c2.cl_code and c2.party_code = t.party_code 
and c1.trader like ltrim(@trader)+'%'
and convert(varchar,t.sauda_date,101)=@sdate
and t.party_code=@statusname
order by c1.short_name,t.party_code 
end

if @statusid='family'
begin
select distinct t.party_code,c1.short_name 
from Trade4432 t, client1 c1,client2 c2
where c1.cl_code = c2.cl_code and c2.party_code = t.party_code 
and c1.trader like ltrim(@trader)+'%'
and convert(varchar,t.sauda_date,101)=@sdate
and c1.family=@statusname
order by c1.short_name,t.party_code 
end

GO
