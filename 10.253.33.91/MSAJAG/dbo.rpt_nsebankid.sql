-- Object: PROCEDURE dbo.rpt_nsebankid
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_nsebankid    Script Date: 04/27/2001 4:32:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_nsebankid    Script Date: 3/21/01 12:50:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_nsebankid    Script Date: 20-Mar-01 11:39:01 PM ******/





/****** Object:  Stored Procedure dbo.rpt_nsebankid    Script Date: 2/5/01 12:06:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_nsebankid    Script Date: 12/27/00 8:58:56 PM ******/

/* changed by mousami on 17th mar 2001
     added logins to query
*/

/*** report : client  details
file:  clients .asp */


CREATE PROCEDURE rpt_nsebankid 
@statusid varchar(15),
@statusname varchar(25)

as

if @statusid='broker'
begin
	select distinct bankid from bank
end 
 
if @statusid='branch'
begin
	select distinct  b.bankid  from multicltid m, client1 c1, client2 c2 , bank b , branches br
	where c2.party_code=m.party_code
	and c1.cl_code=c2.cl_code
	and b.bankid=m.dpid
	and br.short_name=c1.trader
	and br.branch_cd=@statusname
end
if @statusid='trader'
begin
	select distinct b.bankid from multicltid m, client1 c1, client2 c2 , bank b
	where c2.party_code=m.party_code
	and c1.cl_code=c2.cl_code
	and b.bankid=m.dpid
	and c1.trader=@statusname
end

if @statusid='subbroker'
begin
	select distinct b.bankid from multicltid m, client1 c1, client2 c2 , bank b , subbrokers s
	where c2.party_code=m.party_code
	and c1.cl_code=c2.cl_code
	and b.bankid=m.dpid
	and s.sub_broker=c1.sub_broker
	and s.sub_broker=@statusname
end
if @statusid='client'
begin
	select distinct b.bankid  from multicltid m, client1 c1, client2 c2 , bank b
	where c2.party_code=m.party_code
	and c1.cl_code=c2.cl_code
	and b.bankid=m.dpid
	and c2.party_code=@statusname
end
if @statusid='family'
begin
	select distinct b.bankid from multicltid m, client1 c1, client2 c2 , bank b
	where c2.party_code=m.party_code
	and c1.cl_code=c2.cl_code
	and c1.family=@statusname
	and b.bankid=m.dpid
end

GO
