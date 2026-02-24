-- Object: PROCEDURE dbo.rpt_list
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_list    Script Date: 04/27/2001 4:32:44 PM ******/

/****** Object:  Stored Procedure dbo.rpt_list    Script Date: 3/21/01 12:50:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_list    Script Date: 20-Mar-01 11:38:59 PM ******/





/****** Object:  Stored Procedure dbo.rpt_list    Script Date: 2/5/01 12:06:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_list    Script Date: 12/27/00 8:59:13 PM ******/
/****** Object:  Stored Procedure dbo.rpt_list    Script Date: 1/12/01 9:25:04 PM ******/
/****** Object:  Stored Procedure dbo.rpt_list    Script Date: 1/9/2001 12:03:35 PM ******/
/* changed by mousami on 
/* report: bill report 20/03/2001
    added family login
*/
   file :  
*/
CREATE PROCEDURE rpt_list
@settno varchar(7),
@settype varchar(3),
@name varchar(21),
@partycode varchar(10),
@statusid varchar(15),
@statusname varchar(25)
AS
if ( select Count(sett_no) from settlement where sett_no =@settno and sett_type =@settype ) > 0 
begin
if @statusid='broker'
begin
SELECT distinct s.party_code,c1.short_name from client1 c1,client2 c2, settlement s
where c1.cl_code=c2.cl_code and c2.party_code=s.party_code and 
s.sett_no=@settno and s.sett_type=@settype 
and c1.short_name like ltrim(@name)+'%'
and s.party_code like ltrim(@partycode)+'%' and tradeqty > 0 
end
if @statusid='branch'
begin
SELECT distinct s.party_code,c1.short_name from client1 c1,client2 c2, settlement s, branches b
where c1.cl_code=c2.cl_code and c2.party_code=s.party_code and 
s.sett_no=@settno and s.sett_type=@settype 
and c1.short_name like ltrim(@name)+'%'
and b.branch_cd=@statusname and b.short_name=c1.trader
and s.party_code like ltrim(@partycode)+'%' and tradeqty > 0 
end
if @statusid='trader'
begin
SELECT distinct s.party_code,c1.short_name from client1 c1,client2 c2, settlement s
where c1.cl_code=c2.cl_code and c2.party_code=s.party_code and 
s.sett_no=@settno and s.sett_type=@settype 
and c1.short_name like ltrim(@name)+'%'
and c1.trader=@statusname
and s.party_code like ltrim(@partycode)+'%' and tradeqty > 0 
end
if @statusid='client'
begin
SELECT distinct s.party_code,c1.short_name from client1 c1,client2 c2, settlement s
where c1.cl_code=c2.cl_code and c2.party_code=s.party_code and 
s.sett_no=@settno and s.sett_type=@settype 
and c1.short_name like ltrim(@name)+'%'
and s.party_code=@statusname
and s.party_code like ltrim(@partycode)+'%' and tradeqty > 0 
end
if @statusid='subbroker'
begin
SELECT distinct s.party_code,c1.short_name from client1 c1,client2 c2, settlement s
where c1.cl_code=c2.cl_code and c2.party_code=s.party_code and 
s.sett_no=@settno and s.sett_type=@settype 
and c1.short_name like ltrim(@name)+'%'
and s.party_code like ltrim(@partycode)+'%' and tradeqty > 0 
end
end
else
begin
if @statusid='broker'
begin
SELECT distinct s.party_code,c1.short_name from client1 c1,client2 c2, history s
where c1.cl_code=c2.cl_code and c2.party_code=s.party_code and 
s.sett_no=@settno and s.sett_type=@settype 
and c1.short_name like ltrim(@name)+'%'
and s.party_code like ltrim(@partycode)+'%' and tradeqty > 0 
end
if @statusid='branch'
begin
SELECT distinct s.party_code,c1.short_name from client1 c1,client2 c2, history s, branches b
where c1.cl_code=c2.cl_code and c2.party_code=s.party_code and 
s.sett_no=@settno and s.sett_type=@settype 
and c1.short_name like ltrim(@name)+'%'
and b.branch_cd=@statusname and b.short_name=c1.trader
and s.party_code like ltrim(@partycode)+'%' and tradeqty > 0 
end
if @statusid='trader'
begin
SELECT distinct s.party_code,c1.short_name from client1 c1,client2 c2, history s
where c1.cl_code=c2.cl_code and c2.party_code=s.party_code and 
s.sett_no=@settno and s.sett_type=@settype 
and c1.short_name like ltrim(@name)+'%'
and c1.trader=@statusname
and s.party_code like ltrim(@partycode)+'%' and tradeqty > 0 
end
if @statusid='client'
begin
SELECT distinct s.party_code,c1.short_name from client1 c1,client2 c2, history s
where c1.cl_code=c2.cl_code and c2.party_code=s.party_code and 
s.sett_no=@settno and s.sett_type=@settype 
and c1.short_name like ltrim(@name)+'%'
and s.party_code=@statusname
and s.party_code like ltrim(@partycode)+'%' and tradeqty > 0 
end
if @statusid='subbroker'
begin
SELECT distinct s.party_code,c1.short_name from client1 c1,client2 c2, history s
where c1.cl_code=c2.cl_code and c2.party_code=s.party_code and 
s.sett_no=@settno and s.sett_type=@settype 
and c1.short_name like ltrim(@name)+'%'
and s.party_code like ltrim(@partycode)+'%' and tradeqty > 0 
end
end

if @statusid='family'
begin
SELECT distinct s.party_code,c1.short_name from client1 c1,client2 c2, settlement s
where c1.cl_code=c2.cl_code and c2.party_code=s.party_code and 
s.sett_no=@settno and s.sett_type=@settype 
and c1.family=@statusname and tradeqty > 0 
end

GO
