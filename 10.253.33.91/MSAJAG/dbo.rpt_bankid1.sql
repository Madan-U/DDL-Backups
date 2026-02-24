-- Object: PROCEDURE dbo.rpt_bankid1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_bankid1    Script Date: 04/27/2001 4:32:33 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bankid1    Script Date: 3/21/01 12:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bankid1    Script Date: 20-Mar-01 11:38:54 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bankid1    Script Date: 2/5/01 12:06:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bankid1    Script Date: 12/27/00 8:58:53 PM ******/

CREATE PROCEDURE rpt_bankid1
@statusid varchar(15),
@statusname varchar(25)
AS
if @statusid = 'broker'
begin
select distinct bankid from bank
end
if @statusid = 'subbroker'
begin
select distinct bankid 
from bank, subbrokers sb, client1 c1
where sb.sub_broker = @statusname
and sb.sub_broker = c1.sub_broker
end
if @statusid = 'branch'
begin
select distinct bankid 
from bank, branches b, client1 c1
where b.branch_cd = @statusname
and b.short_name = c1.trader
end
if @statusid = 'client'
begin
select distinct b.bankid 
from bank b, client1 c1, client2 c2
where c2.cl_code = c1.cl_code
end
if @statusid = 'trader'
begin
select distinct b.bankid 
from bank b, client1 c1
where c1.trader = @statusname
end

GO
