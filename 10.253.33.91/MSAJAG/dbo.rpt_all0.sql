-- Object: PROCEDURE dbo.rpt_all0
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_all0    Script Date: 04/27/2001 4:32:33 PM ******/

/****** Object:  Stored Procedure dbo.rpt_all0    Script Date: 3/21/01 12:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_all0    Script Date: 20-Mar-01 11:38:53 PM ******/

/****** Object:  Stored Procedure dbo.rpt_all0    Script Date: 2/5/01 12:06:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_all0    Script Date: 12/27/00 8:59:08 PM ******/

/* report : newmtom
   file : all0.asp
*/
/* shows gross exposure of clients who have no margin */   
CREATE PROCEDURE rpt_all0
@statusid varchar(15),
@statusname varchar(25)
AS
if @statusid='broker'
begin
select m.party_code,m.short_name,m.clsdiff,m.grossamt
from tblmtomdetail m,client2 c2,client1 c1 
where m.party_code=c2.party_code   and c2.cl_code =c1.cl_code  and c2.exposure_lim = 0  
order by m.clsdiff
end 
if @statusid='branch'
begin
select m.party_code,m.short_name,m.clsdiff,m.grossamt
from tblmtomdetail m,client2 c2,client1 c1 , branches b
where m.party_code=c2.party_code   and c2.cl_code =c1.cl_code  and c2.exposure_lim = 0  
and b.branch_cd=@statusname and b.short_name=c1.trader
order by m.clsdiff
end 
if @statusid='trader'
begin
select m.party_code,m.short_name,m.clsdiff,m.grossamt
from tblmtomdetail m,client2 c2,client1 c1 
where m.party_code=c2.party_code   and c2.cl_code =c1.cl_code  and c2.exposure_lim = 0  
and c1.trader=@statusname
order by m.clsdiff
end 
if @statusid='subbroker'
begin
select m.party_code,m.short_name,m.clsdiff,m.grossamt
from tblmtomdetail m,client2 c2,client1 c1 , subbrokers sb
where m.party_code=c2.party_code   and c2.cl_code =c1.cl_code  and c2.exposure_lim = 0  
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
order by m.clsdiff
end 
if @statusid='client'
begin
select m.party_code,m.short_name,m.clsdiff,m.grossamt
from tblmtomdetail m,client2 c2,client1 c1 
where m.party_code=c2.party_code   and c2.cl_code =c1.cl_code  and c2.exposure_lim = 0  
and m.party_code=@statusname
order by m.clsdiff
end

GO
