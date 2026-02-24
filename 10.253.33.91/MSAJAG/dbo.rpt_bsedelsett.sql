-- Object: PROCEDURE dbo.rpt_bsedelsett
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_bsedelsett    Script Date: 04/27/2001 4:32:34 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsedelsett    Script Date: 3/21/01 12:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsedelsett    Script Date: 20-Mar-01 11:38:54 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsedelsett    Script Date: 2/5/01 12:06:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsedelsett    Script Date: 12/27/00 8:58:53 PM ******/

/* Report : Delivery
   File : nsedelanyscripmain.asp
   To display settlement number 
*/
CREATE PROCEDURE rpt_bsedelsett 
@statusid varchar(15),
@statusname varchar(25)
AS
if @statusid = 'broker'
begin
select distinct sett_no from deliveryclt group by sett_no order by sett_no
end
if @statusid = 'subbroker'
begin
select distinct sett_no 
from deliveryclt , msajag.dbo.client1 c1, msajag.dbo.subbrokers sb
where sb.sub_broker = @statusname and sb.sub_broker = c1.sub_broker
group by sett_no
order by sett_no
end
if @statusid = 'branch'
begin
select distinct sett_no 
from deliveryclt , msajag.dbo.client1 c1, msajag.dbo.branches b
where b.branch_cd = @statusname and b.short_name = c1.trader
group by sett_no
order by sett_no
end
if @statusid = 'client'
begin
select distinct sett_no 
from deliveryclt d , msajag.dbo.client1 c1, msajag.dbo.client2 c2
where c1.cl_code = c2.cl_code and 
c2.party_code = d.party_code and
d.party_code = @statusname
group by sett_no
order by sett_no
end
if @statusid = 'trader'
begin
select distinct sett_no 
from deliveryclt d , msajag.dbo.client1 c1
where c1.trader = @statusname
group by sett_no
order by sett_no
end

GO
