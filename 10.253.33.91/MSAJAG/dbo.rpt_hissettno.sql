-- Object: PROCEDURE dbo.rpt_hissettno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_hissettno    Script Date: 04/27/2001 4:32:43 PM ******/

/****** Object:  Stored Procedure dbo.rpt_hissettno    Script Date: 3/21/01 12:50:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_hissettno    Script Date: 20-Mar-01 11:38:58 PM ******/

/****** Object:  Stored Procedure dbo.rpt_hissettno    Script Date: 2/5/01 12:06:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_hissettno    Script Date: 12/27/00 8:58:54 PM ******/

/* report : historyposition report 
   file : hispositionmain.asp
   report : bills report
   file : hbillmain.asp
*/
/* displays settlement numbers from history */
CREATE PROCEDURE rpt_hissettno
@statusid varchar(15),
@statusname varchar(25)
AS
if @statusid = 'broker' 
begin
select distinct sett_no from history 
order by sett_no
end
if @statusid = 'branch' 
begin
select distinct sett_no from history h,  CLIENT1 C1, CLIENT2 C2, BRANCHES B
WHERE B.SHORT_NAME=C1.TRADER AND h.party_code=c2.party_code and C1.CL_CODE=C2.CL_CODE AND 
B.BRANCH_CD= @statusname
order by sett_no
end
if @statusid = 'trader' 
begin
select distinct sett_no from history h,  CLIENT1 C1, CLIENT2 C2
WHERE h.party_code=c2.party_code and C1.CL_CODE=C2.CL_CODE and c1.trader=@statusname
order by sett_no
end 
if @statusid = 'subbroker' 
begin
select distinct sett_no from history h, client1 c1, client2 c2, subbrokers sb
where h.party_code=c2.party_code and c2.cl_code=c1.cl_code and c1.sub_broker=sb.sub_broker and 
sb.sub_broker=@statusname
order by sett_no
end 
if @statusid = 'client' 
begin
select distinct sett_no from history h, client1 c1, client2 c2
where  h.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and h.party_code=@statusname
order by sett_no
end

GO
