-- Object: PROCEDURE dbo.rpt_positionsettype
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_positionsettype    Script Date: 05/20/2002 5:24:32 PM ******/
/****** Object:  Stored Procedure dbo.rpt_positionsettype    Script Date: 12/14/2001 1:25:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_positionsettype    Script Date: 11/30/01 4:48:59 PM ******/

/****** Object:  Stored Procedure dbo.rpt_positionsettype    Script Date: 11/5/01 1:29:27 PM ******/





/****** Object:  Stored Procedure dbo.rpt_positionsettype    Script Date: 09/07/2001 11:09:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_positionsettype    Script Date: 7/1/01 2:26:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_positionsettype    Script Date: 06/26/2001 8:49:15 PM ******/


/****** Object:  Stored Procedure dbo.rpt_positionsettype    Script Date: 04/27/2001 4:32:48 PM ******/


/****** Object:  Stored Procedure dbo.rpt_positionsettype    Script Date: 04/21/2001 6:05:31 PM ******/





/****** Object:  Stored Procedure dbo.rpt_positionsettype    Script Date: 2/5/01 12:06:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_positionsettype    Script Date: 12/27/00 8:58:57 PM ******/

/* report : position report 
   file : positionmain.asp
*/
CREATE PROCEDURE rpt_positionsettype
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
select distinct sett_type from settlement h,  CLIENT1 C1, CLIENT2 C2
WHERE h.party_code=c2.party_code and C1.CL_CODE=C2.CL_CODE AND 
c1.family= @statusname
union
select distinct sett_type from history h,  CLIENT1 C1, CLIENT2 C2
WHERE   h.party_code=c2.party_code and C1.CL_CODE=C2.CL_CODE AND 
c1.family= @statusname
order by sett_type
end

GO
