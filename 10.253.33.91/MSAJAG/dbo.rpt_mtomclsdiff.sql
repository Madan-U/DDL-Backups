-- Object: PROCEDURE dbo.rpt_mtomclsdiff
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_mtomclsdiff    Script Date: 04/27/2001 4:32:45 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomclsdiff    Script Date: 3/21/01 12:50:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomclsdiff    Script Date: 20-Mar-01 11:39:00 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomclsdiff    Script Date: 2/5/01 12:06:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomclsdiff    Script Date: 12/27/00 8:59:13 PM ******/


/* report : mtom report
   file : mtom_all.asp
*/
CREATE PROCEDURE rpt_mtomclsdiff
@noramount int,
@statusid varchar(15),
@statusname varchar(25)
AS
if @statusid='broker' 
begin
select m.party_code,m.short_name,isnull(m.clsdiff,0)
from tblmtomdetail m,client2 c2,client1 c1
where m.party_code=c2.party_code and c2.cl_code =c1.cl_code
and m.clsdiff <= @noramount
order by m.clsdiff
end 
if @statusid='branch'
begin
select m.party_code,m.short_name,isnull(m.clsdiff,0)
from tblmtomdetail m,client2 c2,client1 c1, branches b
where m.party_code=c2.party_code and c2.cl_code =c1.cl_code
and m.clsdiff <= @noramount
and b.short_name=c1.trader
and b.branch_cd=@statusname
order by m.clsdiff
end
if @statusid='trader'
begin
select m.party_code,m.short_name,isnull(m.clsdiff,0)
from tblmtomdetail m,client2 c2,client1 c1
where m.party_code=c2.party_code and c2.cl_code =c1.cl_code
and m.clsdiff <= @noramount
and c1.trader=@statusname
order by m.clsdiff
end
if @statusid='subbroker'
begin
select m.party_code,m.short_name,isnull(m.clsdiff,0)
from tblmtomdetail m,client2 c2,client1 c1, subbrokers sb
where m.party_code=c2.party_code and c2.cl_code =c1.cl_code
and m.clsdiff <= @noramount
and sb.sub_broker=c1.sub_broker
and sb.sub_broker=@statusname
order by m.clsdiff
end

GO
