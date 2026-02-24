-- Object: PROCEDURE dbo.rpt_isetthisno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_isetthisno    Script Date: 04/27/2001 4:32:44 PM ******/

/****** Object:  Stored Procedure dbo.rpt_isetthisno    Script Date: 3/21/01 12:50:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_isetthisno    Script Date: 20-Mar-01 11:38:59 PM ******/

/****** Object:  Stored Procedure dbo.rpt_isetthisno    Script Date: 2/5/01 12:06:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_isetthisno    Script Date: 12/27/00 8:59:12 PM ******/

/* institutional trading */
/* Report : Position Report
   File : Positiomain.asp
  To display the settlement number from settlement and history
*/
CREATE PROCEDURE rpt_isetthisno
@statusid varchar(15),
@statusname varchar(25),
@settype varchar(3)
AS
if @statusid = 'broker'
begin
select distinct sett_no from isettlement 
where sett_type like @settype+'%'
union
select distinct sett_no from ihistory 
where sett_type like @settype+'%'
order by sett_no
end
if @statusid = 'subbroker'
begin
select distinct sett_no from isettlement h, client1 c1, client2 c2, subbrokers sb
where h.party_code=c2.party_code and c2.cl_code=c1.cl_code and c1.sub_broker=sb.sub_broker and 
sb.sub_broker = @statusname
and h.sett_type like @settype+'%'
union
select distinct sett_no from ihistory h, client1 c1, client2 c2, subbrokers sb
where h.party_code=c2.party_code and c2.cl_code=c1.cl_code and c1.sub_broker=sb.sub_broker and 
sb.sub_broker = @statusname
and h.sett_type like @settype+'%'
order by sett_no
end
if @statusid = 'branch'
begin
select distinct sett_no from isettlement h, client1 c1, client2 c2, branches b
where b.short_name = c1.trader and h.party_code=c2.party_code and c1.cl_code = c2.cl_code and
b.branch_cd = @statusname
and h.sett_type like @settype+'%'
union
select distinct sett_no from ihistory h,  client1 c1, client2 c2, branches b
where b.short_name = c1.trader and h.party_code=c2.party_code and c1.cl_code = c2.cl_code and
b.branch_cd = @statusname
and h.sett_type like @settype+'%'
order by sett_no
end
if @statusid = 'client'
begin
select distinct sett_no from isettlement h, client1 c1, client2 c2
where h.party_code=c2.party_code and c2.cl_code=c1.cl_code and 
h.party_code = @statusname
and h.sett_type like @settype+'%'
union
select distinct sett_no from ihistory h, client1 c1, client2 c2
where  h.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and h.party_code = @statusname
and h.sett_type like @settype+'%'
order by sett_no
end
if @statusid = 'trader'
begin
select distinct sett_no from isettlement h,  CLIENT1 C1, CLIENT2 C2
where h.party_code=c2.party_code and C1.CL_CODE=C2.CL_CODE 
and c1.trader = @statusname
and h.sett_type like @settype+'%'
union
select distinct sett_no from ihistory h,  CLIENT1 C1, CLIENT2 C2
where h.party_code=c2.party_code and C1.CL_CODE=C2.CL_CODE 
and c1.trader = @statusname
and h.sett_type like @settype+'%'
order by sett_no
end

GO
