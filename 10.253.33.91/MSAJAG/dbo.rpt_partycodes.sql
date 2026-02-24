-- Object: PROCEDURE dbo.rpt_partycodes
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_partycodes    Script Date: 04/27/2001 4:32:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_partycodes    Script Date: 3/21/01 12:50:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_partycodes    Script Date: 20-Mar-01 11:39:02 PM ******/





/****** Object:  Stored Procedure dbo.rpt_partycodes    Script Date: 2/5/01 12:06:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_partycodes    Script Date: 12/27/00 8:58:57 PM ******/

/* report :  position report 
    file : positionmain.asp
*/
/* displays partycodes */
/* changed by mousami on 6th mar 2001  
     added family login	
*/

CREATE PROCEDURE rpt_partycodes
@statusid varchar(15),
@statusname varchar(25)
AS
if @statusid = 'broker' 
begin
select "<OPTION value="+rtrim(c2.party_code)+">"+rtrim(c2.party_code)+"</OPTION>" 
from client1 c1, client2 c2
where c2.cl_code=c1.cl_code  
order by c2.party_code
end
if @statusid = 'branch' 
begin
select "<OPTION value="+rtrim(c2.party_code)+">"+rtrim(c2.party_code)+"</OPTION>" from client1 c1, client2 c2, branches b
where c2.cl_code=c1.cl_code and b.branch_cd=@statusname and
b.short_name=c1.trader
order by c2.party_code
end
if @statusid = 'trader' 
begin
select "<OPTION value="+rtrim(c2.party_code)+">"+rtrim(c2.party_code)+"</OPTION>" from client1 c1, client2 c2
where c2.cl_code=c1.cl_code and c1.trader=@statusname
order by c2.party_code
end 
if @statusid = 'subbroker' 
begin
select "<OPTION value="+rtrim(c2.party_code)+">"+rtrim(c2.party_code)+"</OPTION>" from client1 c1, client2 c2, subbrokers s
where c2.cl_code=c1.cl_code and s.sub_broker=@statusname and
c1.sub_broker=s.sub_broker
order by c2.party_code
end 
if @statusid = 'client' 
begin
select  "<OPTION value="+rtrim(c2.party_code)+">"+rtrim(c2.party_code)+"</OPTION>" from client1 c1, client2 c2
where c2.cl_code=c1.cl_code  
and c2.party_code=@statusname
end

if @statusid = 'family' 
begin
select "<OPTION value="+rtrim(c2.party_code)+">"+rtrim(c2.party_code)+"</OPTION>" 
from client1 c1, client2 c2
where c2.cl_code=c1.cl_code  
and c1.family=@statusname
order by c2.party_code
end

GO
