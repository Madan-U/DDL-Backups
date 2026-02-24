-- Object: PROCEDURE dbo.rpt_settno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_settno    Script Date: 04/27/2001 4:32:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settno    Script Date: 3/21/01 12:50:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settno    Script Date: 20-Mar-01 11:39:03 PM ******/






/* report : position report 
   file : positionmain.asp
   report : bills report
   file : billmain.asp 
 */
/* report : netposition (nse) report 
   file : netnsemain.asp */
/* displays settlement numbers from settlement */
/*  added family login */

CREATE PROCEDURE rpt_settno
@statusid varchar(15),
@statusname varchar(25),
@settype varchar(3)
AS
if @statusid = 'broker' 
begin
select distinct sett_no  from settlement
where sett_type=@settype
order by sett_no desc
end
if @statusid = 'branch' 
begin
select distinct h.sett_no from settlement h,  CLIENT1 C1, CLIENT2 C2, BRANCHES B
WHERE B.SHORT_NAME=C1.TRADER AND h.party_code=c2.party_code and C1.CL_CODE=C2.CL_CODE AND 
B.BRANCH_CD= @statusname
and h.sett_type=@settype
order by h.sett_no  desc
end
if @statusid = 'trader' 
begin
select distinct h.sett_no from settlement h,  CLIENT1 C1, CLIENT2 C2
WHERE h.party_code=c2.party_code and C1.CL_CODE=C2.CL_CODE and c1.trader=@statusname
and h.sett_type=@settype
order by h.sett_no desc
end 
if @statusid = 'subbroker' 
begin
select distinct h.sett_no from settlement h, client1 c1, client2 c2, subbrokers sb
where h.party_code=c2.party_code and c2.cl_code=c1.cl_code and c1.sub_broker=sb.sub_broker and 
sb.sub_broker=@statusname
and h.sett_type=@settype
order by h.sett_no desc
end 
if @statusid = 'client' 
begin
select distinct h.sett_no from settlement h, client1 c1, client2 c2
where h.party_code=c2.party_code and c2.cl_code=c1.cl_code and 
h.party_code=@statusname
and h.sett_type=@settype
order by h.sett_no desc
end 
if @statusid = 'family' 
begin
select distinct sett_no  from settlement h,client1 c1, client2 c2
where sett_type=@settype
and c1.cl_code=c2.cl_code
and c1.family=@statusname
and h.party_code=c2.party_code
order by sett_no desc
end

GO
