-- Object: PROCEDURE dbo.rpt_trader
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_trader    Script Date: 01/04/1980 1:40:42 AM ******/



/****** Object:  Stored Procedure dbo.rpt_trader    Script Date: 11/28/2001 12:23:51 PM ******/




/****** Object:  Stored Procedure dbo.rpt_trader    Script Date: 2/17/01 5:19:55 PM ******/


/****** Object:  Stored Procedure dbo.rpt_trader    Script Date: 3/21/01 12:50:24 PM ******/

/****** Object:  Stored Procedure dbo.rpt_trader    Script Date: 20-Mar-01 11:39:04 PM ******/





/****** Object:  Stored Procedure dbo.rpt_trader    Script Date: 12/27/00 8:58:58 PM ******/
/* report : confirmation report
   file : confirmationmain.asp
   selects distinct traders from client1
*/
CREATE PROCEDURE rpt_trader
@statusid varchar(15),
@statusname varchar(25)
AS
if @statusid = 'broker' 
begin
select distinct trader from client1 order by trader
end
if @statusid = 'branch' 
begin
select distinct trader from client1 c1, client2 c2 ,branches b
where b.short_name=c1.trader and b.branch_cd=@statusname
and c1.cl_code=c2.cl_code
order by trader
end
if @statusid = 'subbroker' 
begin
select distinct trader from client1 c1, client2 c2, subbrokers sb
where sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
and c1.cl_code=c2.cl_code
order by trader
end 
if @statusid='trader'
begin
select distinct trader from client1 where trader=@statusname
end
if @statusid='client'
begin
select distinct trader from client1 c1, client2  c2 where 
c2.cl_code=c1.cl_code and c2.party_code=@statusname
end

GO
