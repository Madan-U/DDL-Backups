-- Object: PROCEDURE dbo.rpt_bsecltcodelist
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_bsecltcodelist    Script Date: 01/04/1980 1:40:40 AM ******/



/****** Object:  Stored Procedure dbo.rpt_bsecltcodelist    Script Date: 11/28/2001 12:23:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsecltcodelist    Script Date: 29-Sep-01 8:12:06 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsecltcodelist    Script Date: 8/8/01 1:37:31 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsecltcodelist    Script Date: 8/7/01 6:03:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsecltcodelist    Script Date: 7/8/01 3:22:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsecltcodelist    Script Date: 2/17/01 3:34:16 PM ******/


/****** Object:  Stored Procedure dbo.rpt_bsecltcodelist    Script Date: 20-Mar-01 11:43:34 PM ******/

/* report : allpartyledger
   file : clientlist.asp
*/
/* calculates list of all clients from ledger*/
CREATE PROCEDURE rpt_bsecltcodelist
@statusid varchar(15),
@statusname varchar(25)
AS
if @statusid = 'broker' 
begin
select distinct cltcode from ledger 
order by cltcode
end
if @statusid = 'branch' 
begin
select distinct cltcode 
from ledger l, bsedb.dbo.client1 c1, bsedb.dbo.client2 c2, bsedb.dbo.branches b
where b.branch_cd=@statusname and b.short_name=c1.trader and l.cltcode=c2.party_code and
c1.cl_code=c2.cl_code
order by cltcode
end
if @statusid = 'trader' 
begin
select distinct cltcode 
from ledger l, bsedb.dbo.client1 c1, bsedb.dbo.client2 c2
where c1.trader=@statusname  and c1.cl_code=c2.cl_code and l.cltcode=c2.party_code
order by cltcode
end 
if @statusid = 'subbroker' 
begin
select distinct cltcode 
from ledger l, bsedb.dbo.client1 c1, bsedb.dbo.client2 c2, bsedb.dbo.subbrokers sb
where sb.sub_broker=@statusname and sb.sub_broker=c1.sub_broker and
c1.cl_code=c2.cl_code and l.cltcode=c2.party_code
order by cltcode
end 
if @statusid = 'client' 
begin
select distinct cltcode 
from ledger l, bsedb.dbo.client1 c1, bsedb.dbo.client2 c2
where l.cltcode=@statusname and  c1.cl_code=c2.cl_code and l.cltcode=c2.party_code
order by cltcode
end

GO
