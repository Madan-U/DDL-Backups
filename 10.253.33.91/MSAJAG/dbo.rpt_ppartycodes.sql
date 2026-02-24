-- Object: PROCEDURE dbo.rpt_ppartycodes
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_ppartycodes    Script Date: 04/27/2001 4:32:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ppartycodes    Script Date: 3/21/01 12:50:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ppartycodes    Script Date: 20-Mar-01 11:39:02 PM ******/





/****** Object:  Stored Procedure dbo.rpt_ppartycodes    Script Date: 12/27/00 8:59:14 PM ******/
/* changed by mousami on 10/02/2001 added family login
*/

CREATE PROCEDURE rpt_ppartycodes
@settno varchar(7),
@settype varchar(3),
@statusid varchar(15),
@statusname varchar(25),
@partycode varchar(10),
@partyname varchar(25)
AS

if @statusid='broker' 
begin
if ( select Count(sett_no) from settlement where sett_no =@settno and sett_type =@settype ) > 0
 begin
  select distinct h.party_code, c1.short_name  from settlement h , client1 c1, client2 c2 
  where sett_no=@settno and sett_type='p' and
  c1.cl_code=c2.cl_code
  and h.party_code=c2.party_code
  and c1.short_name like ltrim(@partyname)+'%'
  and h.party_code like ltrim(@partycode)+'%'
  and h.party_code not in(
  select distinct party_code from settlement  where sett_no=@settno and sett_type='w')
 end 
else
 begin
  select distinct h.party_code , c1.short_name from history h, client1 c1, client2 c2 
  where h.sett_no=@settno and h.sett_type='p' and 
  c1.cl_code=c2.cl_code
  and h.party_code=c2.party_code 
  and c1.short_name like ltrim(@partyname)+'%'
  and h.party_code like ltrim(@partycode)+'%'
  and h.party_code not in(
  select distinct party_code from history  where sett_no=@settno and sett_type='w')
  
 end 
end

if @statusid='branch' 
begin
if ( select Count(sett_no) from settlement where sett_no =@settno and sett_type =@settype ) > 0
 begin
  select distinct s.party_code , c1.short_name from settlement s, branches b, client1 c1, client2 c2
   where s.sett_no=@settno and s.sett_type='p'  
  and  s.party_code=c2.party_code and c1.cl_code=c2.cl_code
  and b.branch_cd=@statusname and b.short_name=c1.trader
  and c1.short_name like ltrim(@partyname)+'%'
  and s.party_code like ltrim(@partycode)+'%'
  and s.party_code not in(select distinct party_code from settlement  where sett_no=@settno and sett_type='w')
 end 
else
 begin
  select distinct h.party_code, c1.short_name from history  h, branches b, client1 c1, client2 c2
  where h.sett_no=@settno and h.sett_type='p' and 
  h.party_code=c2.party_code and c1.cl_code=c2.cl_code
  and b.branch_cd=@statusname and b.short_name=c1.trader
  and c1.short_name like ltrim(@partyname)+'%'
  and h.party_code like ltrim(@partycode)+'%' and
  h.party_code not in(select distinct party_code from history  where sett_no=@settno and sett_type='w')
 end 
end

if @statusid='trader' 
begin
if ( select Count(sett_no) from settlement where sett_no =@settno and sett_type =@settype ) > 0
 begin
  select distinct h.party_code ,c1.short_name from settlement h , client1 c1, client2 c2
  where h.sett_no=@settno and h.sett_type='p' 
  and c1.cl_code=c2.cl_code and
  c2.party_code=h.party_code
  and c1.trader=@statusname
  and c1.short_name like ltrim(@partyname)+'%'
  and h.party_code like ltrim(@partycode)+'%'
  and h.party_code not in(
  select distinct party_code from settlement  where sett_no=@settno and sett_type='w')
 end 
else
 begin
  select distinct h.party_code from history h, client1 c1, client2 c2
  where h.sett_no=@settno and h.sett_type='p'  
  and c1.cl_code=c2.cl_code and
  c2.party_code=h.party_code
  and c1.trader=@statusname
  and c1.short_name like ltrim(@partyname)+'%'
  and h.party_code like ltrim(@partycode)+'%'
  and h.party_code not in(
  select distinct party_code from history  where sett_no=@settno and sett_type='w')
 end 
end

if @statusid='subbroker' 
begin
if ( select Count(sett_no) from settlement where sett_no =@settno and sett_type =@settype ) > 0
 begin
  select distinct s.party_code from settlement s, subbrokers sb,  client1 c1, client2 c2
  where s.sett_no=@settno and s.sett_type='p' 
  and sb.sub_broker=c1.sub_broker
  and sb.sub_broker=@statusname    
  and c1.cl_code=c2.cl_code
  and c2.party_code=s.party_code 
  and c1.short_name like ltrim(@partyname)+'%'
  and s.party_code like ltrim(@partycode)+'%'
  and s.party_code not in(
  select distinct party_code from settlement  where sett_no=@settno and sett_type='w')
 end 
else
 begin
  select distinct h.party_code from history h , subbrokers sb, client1 c1, client2 c2
  where h.sett_no=@settno and h.sett_type='p' 
   and sb.sub_broker=c1.sub_broker
  and sb.sub_broker=@statusname    
  and c1.cl_code=c2.cl_code
  and c2.party_code=h.party_code
  and c1.short_name like ltrim(@partyname)+'%'
  and h.party_code like ltrim(@partycode)+'%'
  and h.party_code not in(
  select distinct party_code from history  where sett_no=@settno and sett_type='w')
 end 
end

if @statusid='client' 
begin
if ( select Count(sett_no) from settlement where sett_no =@settno and sett_type =@settype ) > 0
 begin
  select distinct s.party_code from settlement s, client1 c1, client2 c2
  where s.sett_no=@settno and s.sett_type='p' 
  and c1.cl_code=c2.cl_code
  and c2.party_code=s.party_code
  and s.party_code=@statusname 
  and c1.short_name like ltrim(@partyname)+'%'
  and s.party_code like ltrim(@partycode)+'%'
  and s.party_code not in(
  select distinct party_code from settlement  where sett_no=@settno and sett_type='w')
 end 
else
 begin
  select distinct h.party_code from history h, client1 c1, client2 c2
  where h.sett_no=@settno and h.sett_type='p' 
  and c1.cl_code=c2.cl_code
  and c2.party_code=h.party_code
  and h.party_code=@statusname
  and c1.short_name like ltrim(@partyname)+'%'
  and h.party_code like ltrim(@partycode)+'%'
  and h.party_code not in(
  select distinct party_code from history  where sett_no=@settno and sett_type='w')
 end 
end
 
if @statusid='family' 
begin
if ( select Count(sett_no) from settlement where sett_no =@settno and sett_type =@settype ) > 0
 begin
	  select distinct h.party_code, c1.short_name  from settlement h , client1 c1, client2 c2 
	  where sett_no=@settno and sett_type='p' and
	  c1.cl_code=c2.cl_code
	  and h.party_code=c2.party_code
	  and c1.short_name like ltrim(@partyname)+'%'
	  and h.party_code like ltrim(@partycode)+'%'
	  and c1.family=@statusname
	  and h.party_code not in(
	  select distinct party_code from settlement  where sett_no=@settno and sett_type='w')
 end 
else
 begin
	  select distinct h.party_code , c1.short_name from history h, client1 c1, client2 c2 
	  where h.sett_no=@settno and h.sett_type='p' and 
	  c1.cl_code=c2.cl_code
	  and h.party_code=c2.party_code 
	  and c1.short_name like ltrim(@partyname)+'%'
	  and h.party_code like ltrim(@partycode)+'%'
	  and c1.family=@statusname	
	  and h.party_code not in(
	  select distinct party_code from history  where sett_no=@settno and sett_type='w')
  
 end 
end

GO
