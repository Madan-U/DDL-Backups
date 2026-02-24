-- Object: PROCEDURE dbo.rpt_margins
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_margins    Script Date: 04/27/2001 4:32:44 PM ******/

/****** Object:  Stored Procedure dbo.rpt_margins    Script Date: 3/21/01 12:50:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_margins    Script Date: 20-Mar-01 11:38:59 PM ******/

/****** Object:  Stored Procedure dbo.rpt_margins    Script Date: 2/5/01 12:06:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_margins    Script Date: 12/27/00 8:59:13 PM ******/

/* report : newmtom report
   file : rpt_margins.asp
*/
CREATE PROCEDURE rpt_margins
@statusid varchar(15),
@statusname varchar(25)
AS
if @statusid='broker' 
begin
select m.party_code,m.short_name,m.clsdiff,m.grossamt,c2.exposure_lim
from tblmtomdetail m,client2 c2,client1 c1  
where m.party_code=c2.party_code   and c2.cl_code =c1.cl_code  and c2.exposure_lim <> 0 
order by c2.exposure_lim desc
end
if @statusid='branch' 
begin
select m.party_code,m.short_name,m.clsdiff,m.grossamt,c2.exposure_lim
from tblmtomdetail m,client2 c2,client1 c1 , branches b
where m.party_code=c2.party_code   and c2.cl_code =c1.cl_code  and c2.exposure_lim <> 0 
and b.branch_cd=@statusname and b.short_name=c1.trader
order by c2.exposure_lim desc
end
if @statusid='subbroker' 
begin
select m.party_code,m.short_name,m.clsdiff,m.grossamt,c2.exposure_lim
from tblmtomdetail m,client2 c2,client1 c1 , subbrokers sb 
where m.party_code=c2.party_code   and c2.cl_code =c1.cl_code  and c2.exposure_lim <> 0 
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
order by c2.exposure_lim desc
end
if @statusid='trader' 
begin
select m.party_code,m.short_name,m.clsdiff,m.grossamt,c2.exposure_lim
from tblmtomdetail m,client2 c2,client1 c1  
where m.party_code=c2.party_code   and c2.cl_code =c1.cl_code  and c2.exposure_lim <> 0 
and c1.trader=@statusname
order by c2.exposure_lim desc
end
if @statusid='client' 
begin
select m.party_code,m.short_name,m.clsdiff,m.grossamt,c2.exposure_lim
from tblmtomdetail m,client2 c2,client1 c1  
where m.party_code=c2.party_code   and c2.cl_code =c1.cl_code  and c2.exposure_lim <> 0 
and m.party_code=@statusname
order by c2.exposure_lim desc
end

GO
