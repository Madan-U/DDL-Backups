-- Object: PROCEDURE dbo.rpt_mtom3dpartycodes
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_mtom3dpartycodes    Script Date: 04/27/2001 4:32:45 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtom3dpartycodes    Script Date: 3/21/01 12:50:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtom3dpartycodes    Script Date: 20-Mar-01 11:39:00 PM ******/



/****** Object:  Stored Procedure dbo.rpt_mtom3dpartycodes    Script Date: 12/27/00 8:59:13 PM ******/
/* report : mtom report
    file : mtomparty.asp
*/
/* displays partycodes */
CREATE PROCEDURE rpt_mtom3dpartycodes
@statusid varchar(15),
@statusname varchar(25)
AS
if @statusid = 'broker' 
begin
select  distinct  party = "<OPTION value="+rtrim(s.party_code)+">"+rtrim(s.party_code)+"</OPTION>" 
from settlement s
where s.billno='0' and s.series='AE'  
order by  party
end
if @statusid = 'branch' 
begin
select distinct  party = "<OPTION value="+rtrim(s.party_code)+">"+rtrim(s.party_code)+"</OPTION>" 
from settlement s, branches b, client1 c1, client2 c2
where s.billno='0' and s.series='AE'
and b.branch_cd=@statusname
and b.short_name=c1.trader
and c1.cl_code=c2.cl_code
and c2.party_code=s.party_code
order by  party 
end
if @statusid = 'trader' 
begin
select  distinct  party = "<OPTION value="+rtrim(s.party_code)+">"+rtrim(s.party_code)+"</OPTION>" 
from settlement s, client1 c1, client2 c2
where s.billno='0' and s.series='AE'
and c1.cl_code=c2.cl_code
and c2.party_code=s.party_code
and c1.trader=@statusname
order by party 
end 
if @statusid = 'subbroker' 
begin
select  distinct  party = "<OPTION value="+rtrim(s.party_code)+">"+rtrim(s.party_code)+"</OPTION>" 
from settlement s, subbrokers sb,client1 c1 ,client2 c2
where billno='0' and s.series='AE'
and sb.sub_broker=c1.sub_broker
and sb.sub_broker=@statusname  
and c1.cl_code=c2.cl_code
and c2.party_code=s.party_code
order by party 
end

GO
