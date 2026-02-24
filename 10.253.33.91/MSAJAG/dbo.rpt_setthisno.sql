-- Object: PROCEDURE dbo.rpt_setthisno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_setthisno    Script Date: 05/20/2002 5:24:32 PM ******/
/****** Object:  Stored Procedure dbo.rpt_setthisno    Script Date: 12/14/2001 1:25:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_setthisno    Script Date: 11/30/01 4:49:01 PM ******/

/****** Object:  Stored Procedure dbo.rpt_setthisno    Script Date: 11/5/01 1:29:34 PM ******/





/****** Object:  Stored Procedure dbo.rpt_setthisno    Script Date: 09/07/2001 11:09:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_setthisno    Script Date: 7/1/01 2:26:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_setthisno    Script Date: 06/26/2001 8:49:18 PM ******/


/****** Object:  Stored Procedure dbo.rpt_setthisno    Script Date: 04/27/2001 4:32:49 PM ******/



/****** Object:  Stored Procedure dbo.rpt_setthisno    Script Date: 2/5/01 12:06:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_setthisno    Script Date: 12/27/00 8:58:58 PM ******/

/* Report : Position Report
   File : Positiomain.asp
  To display the settlement number from settlement and history
*/
CREATE PROCEDURE rpt_setthisno
@statusid varchar(15),
@statusname varchar(25),
@settype varchar(3)
AS
if @statusid = 'broker'
begin
select distinct s.sett_no,start_date from settlement s, sett_mst st
where s.sett_type like ltrim(@settype)+'%'
and s.sett_type=st.sett_type and s.sett_no=st.sett_no
union all
select distinct s.sett_no, start_date from history s, sett_mst st
where s.sett_type like ltrim(@settype)+'%'
and s.sett_type=st.sett_type and s.sett_no=st.sett_no
order by start_date desc
end
if @statusid = 'subbroker'
begin
select distinct h.sett_no,start_date from settlement h, client1 c1, client2 c2, subbrokers sb, sett_mst st
where h.party_code=c2.party_code and c2.cl_code=c1.cl_code and c1.sub_broker=sb.sub_broker and 
sb.sub_broker = @statusname
and h.sett_type like ltrim(@settype)+'%'
and h.sett_type=st.sett_type and h.sett_no=st.sett_no
union all
select distinct h.sett_no , start_date from history h, client1 c1, client2 c2, subbrokers sb, sett_mst st
where h.party_code=c2.party_code and c2.cl_code=c1.cl_code and c1.sub_broker=sb.sub_broker and 
sb.sub_broker = @statusname
and h.sett_type like ltrim(@settype)+'%'
and h.sett_type=st.sett_type and h.sett_no=st.sett_no
order by start_date desc
end
if @statusid = 'branch'
begin
select distinct h.sett_no ,start_date from settlement h, client1 c1, client2 c2, branches b, sett_mst st
where b.short_name = c1.trader and h.party_code=c2.party_code and c1.cl_code = c2.cl_code and
b.branch_cd = @statusname
and h.sett_type like ltrim(@settype)+'%'
and h.sett_type=st.sett_type and h.sett_no=st.sett_no
union
select distinct h.sett_no , start_date from history h,  client1 c1, client2 c2, branches b, sett_mst st
where b.short_name = c1.trader and h.party_code=c2.party_code and c1.cl_code = c2.cl_code and
b.branch_cd = @statusname
and h.sett_type like ltrim(@settype)+'%'
and h.sett_type=st.sett_type and h.sett_no=st.sett_no
order by start_date desc
end
if @statusid = 'client'
begin
select distinct h.sett_no , start_date from settlement h, client1 c1, client2 c2, sett_mst st
where h.party_code=c2.party_code and c2.cl_code=c1.cl_code and 
h.party_code = @statusname
and h.sett_type like ltrim(@settype)+'%'
and h.sett_type=st.sett_type and h.sett_no=st.sett_no
union
select distinct h.sett_no , start_date from history h, client1 c1, client2 c2, sett_mst st
where  h.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and h.party_code = @statusname
and h.sett_type like ltrim(@settype)+'%'
and h.sett_type=st.sett_type and h.sett_no=st.sett_no
order by start_date desc
end
if @statusid = 'trader'
begin
select distinct h.sett_no , start_date from settlement h,  CLIENT1 C1, CLIENT2 C2, sett_mst st
where h.party_code=c2.party_code and C1.CL_CODE=C2.CL_CODE 
and c1.trader = @statusname
and h.sett_type like ltrim(@settype)+'%'
and h.sett_type=st.sett_type and h.sett_no=st.sett_no
union
select distinct h.sett_no , start_date from history h,  CLIENT1 C1, CLIENT2 C2, sett_mst st
where h.party_code=c2.party_code and C1.CL_CODE=C2.CL_CODE 
and c1.trader = @statusname
and h.sett_type like ltrim(@settype)+'%'
and h.sett_type=st.sett_type and h.sett_no=st.sett_no
order by start_date desc
end
if @statusid = 'family'
begin
select distinct h.sett_no , start_date from settlement h, client1 c1, client2 c2, branches b, sett_mst st
where h.party_code=c2.party_code and c1.cl_code = c2.cl_code and
h.sett_type like ltrim(@settype)+'%'
and h.sett_type=st.sett_type and h.sett_no=st.sett_no
and c1.family = @statusname
union
select distinct h.sett_no , start_date from history h,  client1 c1, client2 c2, branches b, sett_mst st
where  h.party_code=c2.party_code and c1.cl_code = c2.cl_code and
c1.family = @statusname
and h.sett_type like ltrim(@settype)+'%'
and h.sett_type=st.sett_type and h.sett_no=st.sett_no
order by start_date desc
end

GO
