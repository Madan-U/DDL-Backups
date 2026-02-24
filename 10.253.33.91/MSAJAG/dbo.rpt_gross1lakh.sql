-- Object: PROCEDURE dbo.rpt_gross1lakh
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_gross1lakh    Script Date: 04/27/2001 4:32:42 PM ******/

/****** Object:  Stored Procedure dbo.rpt_gross1lakh    Script Date: 3/21/01 12:50:17 PM ******/

/****** Object:  Stored Procedure dbo.rpt_gross1lakh    Script Date: 20-Mar-01 11:38:58 PM ******/

/****** Object:  Stored Procedure dbo.rpt_gross1lakh    Script Date: 2/5/01 12:06:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_gross1lakh    Script Date: 12/27/00 8:59:11 PM ******/

/* report : newmtom
   file :  gross1lakhs.asp
*/
/*displays gross exposure greater than a particular amount */
CREATE PROCEDURE  rpt_gross1lakh
@statusid varchar(15),
@statusname varchar(25),
@selval varchar(10)
AS
if @statusid='broker'
begin
select party_code,short_name,clsdiff,grossamt
from tblmtomdetail  
where grossamt > convert(money,@selval)
order by grossamt desc
end 
if @statusid='branch'
begin
select m.party_code,m.short_name,clsdiff,grossamt
from tblmtomdetail m, client1 c1, client2 c2, branches b 
where grossamt > convert(money,@selval)
and b.branch_Cd=@statusname and b.short_name=c1.trader
and c2.party_code=m.party_code
and c1.cl_code=c2.cl_code
order by grossamt desc
end 
if @statusid='subbroker'
begin
select m.party_code,m.short_name,clsdiff,grossamt
from tblmtomdetail m, subbrokers sb, client1 c1,client2 c2
where grossamt > convert(money,@selval)
and sb.sub_broker=@statusname and sb.sub_broker=c1.sub_broker
and c2.party_code=m.party_code
and c1.cl_code=c2.cl_code
order by grossamt desc
end 
if @statusid='trader'
begin
select m.party_code, m.short_name,clsdiff,grossamt
from tblmtomdetail  m, client1 c1,client2 c2
where grossamt > convert(money,@selval)
and c1.trader=@statusname
and c2.party_code=m.party_code
and c1.cl_code=c2.cl_code
order by grossamt desc
end 
if @statusid='client'
begin
select m.party_code,m.short_name,clsdiff,grossamt
from tblmtomdetail  m, client1 c1,client2 c2
where grossamt > convert(money,@selval)
and m.party_code=@statusname
and c2.party_code=m.party_code
and c1.cl_code=c2.cl_code
order by grossamt desc
end

GO
