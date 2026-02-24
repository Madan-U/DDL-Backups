-- Object: PROCEDURE dbo.rpt_billsettype
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_billsettype    Script Date: 04/27/2001 4:32:33 PM ******/

/****** Object:  Stored Procedure dbo.rpt_billsettype    Script Date: 3/21/01 12:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_billsettype    Script Date: 20-Mar-01 11:38:54 PM ******/





/****** Object:  Stored Procedure dbo.rpt_billsettype    Script Date: 2/5/01 12:06:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_billsettype    Script Date: 12/27/00 8:58:53 PM ******/

/* report : bills report
   file : billmain.asp 
 */
/* displays settlement types from settlement and history*/
/* changed by mousami on 05/03/2001
     added family login 
*/

CREATE PROCEDURE rpt_billsettype
@statusid varchar(15),
@statusname varchar(25)
AS
if @statusid = 'broker' 
begin
select distinct sett_type from settlement 
union
select distinct sett_type from history
order by sett_type
end
if @statusid = 'branch' 
begin
select distinct sett_type from settlement h,  CLIENT1 C1, CLIENT2 C2, BRANCHES B
WHERE B.SHORT_NAME=C1.TRADER AND h.party_code=c2.party_code and C1.CL_CODE=C2.CL_CODE AND 
B.BRANCH_CD= @statusname
union
select distinct sett_type from history h,  CLIENT1 C1, CLIENT2 C2, BRANCHES B
WHERE B.SHORT_NAME=C1.TRADER AND h.party_code=c2.party_code and C1.CL_CODE=C2.CL_CODE AND 
B.BRANCH_CD= @statusname
order by sett_type
end
if @statusid = 'trader' 
begin
select distinct sett_type from settlement h,  CLIENT1 C1, CLIENT2 C2
WHERE h.party_code=c2.party_code and C1.CL_CODE=C2.CL_CODE and c1.trader=@statusname
union
select distinct sett_type from history h,  CLIENT1 C1, CLIENT2 C2
WHERE h.party_code=c2.party_code and C1.CL_CODE=C2.CL_CODE and c1.trader=@statusname
order by sett_type
end 
if @statusid = 'subbroker' 
begin
select distinct sett_type from settlement h, client1 c1, client2 c2, subbrokers sb
where h.party_code=c2.party_code and c2.cl_code=c1.cl_code and c1.sub_broker=sb.sub_broker and 
sb.sub_broker=@statusname
union
select distinct sett_type from history h, client1 c1, client2 c2, subbrokers sb
where h.party_code=c2.party_code and c2.cl_code=c1.cl_code and c1.sub_broker=sb.sub_broker and 
sb.sub_broker=@statusname
order by sett_type
end 
if @statusid = 'client' 
begin
select distinct sett_type from settlement h, client1 c1, client2 c2
where h.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and h.party_code=@statusname
union
select distinct sett_type from history h, client1 c1, client2 c2
where h.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and h.party_code=@statusname
order by sett_type
end 

if @statusid = 'family' 
begin
select distinct sett_type from settlement s , client1 c1, client2 c2
where c1.cl_code=c2.cl_code and s.party_code=c2.party_code
and c1.family=@statusname
union
select distinct sett_type from history s , client1 c1, client2 c2
where c1.cl_code=c2.cl_code and s.party_code=c2.party_code
and c1.family=@statusname
order by sett_type
end

GO
