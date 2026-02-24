-- Object: PROCEDURE dbo.rpt_diff10000
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_diff10000    Script Date: 04/27/2001 4:32:38 PM ******/

/****** Object:  Stored Procedure dbo.rpt_diff10000    Script Date: 3/21/01 12:50:14 PM ******/

/****** Object:  Stored Procedure dbo.rpt_diff10000    Script Date: 20-Mar-01 11:38:55 PM ******/

/****** Object:  Stored Procedure dbo.rpt_diff10000    Script Date: 2/5/01 12:06:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_diff10000    Script Date: 12/27/00 8:59:08 PM ******/

/* report : newmtom report
   file : diff10000
*/
CREATE PROCEDURE rpt_diff10000
@statusid varchar(15),
@statusname varchar(25),
@selval varchar(9)
as
if @statusid='broker' 
begin
select m.party_code,m.short_name,isnull(m.clsdiff,0),isnull(m.grossamt,0),isnull(c2.exposure_lim,0),
isnull(m.LedgerAmt,0)
 from tblmtomdetail m,client2 c2,client1 c1  
where m.party_code=c2.party_code   and c2.cl_code =c1.cl_code  and m.clsdiff <= convert(money,@selval)
order by m.clsdiff
end
if @statusid='branch' 
begin
select m.party_code,m.short_name,isnull(m.clsdiff,0),isnull(m.grossamt,0),isnull(c2.exposure_lim,0),
isnull(m.LedgerAmt,0)
from tblmtomdetail m,client2 c2,client1 c1 , branches b
where m.party_code=c2.party_code   and c2.cl_code =c1.cl_code  and m.clsdiff <= convert(money,@selval)
and b.branch_cd=@statusname and b.short_name=c1.trader
order by m.clsdiff
end
if @statusid='trader' 
begin
select m.party_code,m.short_name,isnull(m.clsdiff,0),isnull(m.grossamt,0),isnull(c2.exposure_lim,0),
isnull(m.LedgerAmt,0)
from tblmtomdetail m,client2 c2,client1 c1  
where m.party_code=c2.party_code   and c2.cl_code =c1.cl_code  and m.clsdiff <= convert(money,@selval)
and c1.trader=@statusname
order by m.clsdiff
end
if @statusid='subbroker' 
begin
select m.party_code,m.short_name,isnull(m.clsdiff,0),isnull(m.grossamt,0),isnull(c2.exposure_lim,0),
isnull(m.LedgerAmt,0)
from tblmtomdetail m,client2 c2,client1 c1  , subbrokers sb
where m.party_code=c2.party_code   and c2.cl_code =c1.cl_code  and m.clsdiff <= convert(money,@selval)
and sb.sub_broker =@statusname and c1.sub_broker=sb.sub_broker
order by m.clsdiff
end
if @statusid='client' 
begin
select m.party_code,m.short_name,isnull(m.clsdiff,0),isnull(m.grossamt,0),isnull(c2.exposure_lim,0),
isnull(m.LedgerAmt,0)
 from tblmtomdetail m,client2 c2,client1 c1  
where m.party_code=c2.party_code   and c2.cl_code =c1.cl_code  and m.clsdiff <= convert(money,@selval)
and m.party_code=@statusname
order by m.clsdiff
end

GO
