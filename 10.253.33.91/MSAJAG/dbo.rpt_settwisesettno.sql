-- Object: PROCEDURE dbo.rpt_settwisesettno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_settwisesettno    Script Date: 04/27/2001 4:32:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_setthisno    Script Date: 2/5/01 12:06:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_setthisno    Script Date: 12/27/00 8:58:58 PM ******/

/* 
  To display the settlement number from settlement and history
*/
CREATE PROCEDURE rpt_settwisesettno
@statusid varchar(15),
@statusname varchar(25),
@settype varchar(3)
AS
if @statusid = 'broker'
begin
select distinct s.sett_no from settlement s, sett_mst st
where s.sett_type like ltrim(@settype)+'%'
and s.sett_type=st.sett_type and s.sett_no=st.sett_no
union
select distinct s.sett_no from history s, sett_mst st
where s.sett_type like ltrim(@settype)+'%'
and s.sett_type=st.sett_type and s.sett_no=st.sett_no
order by s.sett_no desc
end
if @statusid = 'subbroker'
begin
select distinct h.sett_no from settlement h, client1 c1, client2 c2, subbrokers sb, sett_mst st
where h.party_code=c2.party_code and c2.cl_code=c1.cl_code and c1.sub_broker=sb.sub_broker and 
sb.sub_broker = @statusname
and h.sett_type like ltrim(@settype)+'%'
and h.sett_type=st.sett_type and h.sett_no=st.sett_no
union
select distinct h.sett_no from history h, client1 c1, client2 c2, subbrokers sb, sett_mst st
where h.party_code=c2.party_code and c2.cl_code=c1.cl_code and c1.sub_broker=sb.sub_broker and 
sb.sub_broker = @statusname
and h.sett_type like ltrim(@settype)+'%'
and h.sett_type=st.sett_type and h.sett_no=st.sett_no
order by h.sett_no desc
end
if @statusid = 'branch'
begin
select distinct h.sett_no from settlement h, client1 c1, client2 c2, branches b, sett_mst st
where b.short_name = c1.trader and h.party_code=c2.party_code and c1.cl_code = c2.cl_code and
b.branch_cd = @statusname
and h.sett_type like ltrim(@settype)+'%'
and h.sett_type=st.sett_type and h.sett_no=st.sett_no
union
select distinct h.sett_no from history h,  client1 c1, client2 c2, branches b, sett_mst st
where b.short_name = c1.trader and h.party_code=c2.party_code and c1.cl_code = c2.cl_code and
b.branch_cd = @statusname
and h.sett_type like ltrim(@settype)+'%'
and h.sett_type=st.sett_type and h.sett_no=st.sett_no
order by h.sett_no  desc
end
if @statusid = 'client'
begin
select distinct h.sett_no from settlement h, client1 c1, client2 c2, sett_mst st
where h.party_code=c2.party_code and c2.cl_code=c1.cl_code and 
h.party_code = @statusname
and h.sett_type like ltrim(@settype)+'%'
and h.sett_type=st.sett_type and h.sett_no=st.sett_no
union
select distinct h.sett_no from history h, client1 c1, client2 c2, sett_mst st
where  h.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and h.party_code = @statusname
and h.sett_type like ltrim(@settype)+'%'
and h.sett_type=st.sett_type and h.sett_no=st.sett_no
order by h.sett_no  desc
end
if @statusid = 'trader'
begin
select distinct h.sett_no  from settlement h,  CLIENT1 C1, CLIENT2 C2, sett_mst st
where h.party_code=c2.party_code and C1.CL_CODE=C2.CL_CODE 
and c1.trader = @statusname
and h.sett_type like ltrim(@settype)+'%'
and h.sett_type=st.sett_type and h.sett_no=st.sett_no
union
select distinct h.sett_no from history h,  CLIENT1 C1, CLIENT2 C2, sett_mst st
where h.party_code=c2.party_code and C1.CL_CODE=C2.CL_CODE 
and c1.trader = @statusname
and h.sett_type like ltrim(@settype)+'%'
and h.sett_type=st.sett_type and h.sett_no=st.sett_no
order by h.sett_no  desc
end
if @statusid = 'family'
begin
select distinct h.sett_no  from settlement h, client1 c1, client2 c2, branches b, sett_mst st
where h.party_code=c2.party_code and c1.cl_code = c2.cl_code and
h.sett_type like ltrim(@settype)+'%'
and h.sett_type=st.sett_type and h.sett_no=st.sett_no
and c1.family = @statusname
union
select distinct h.sett_no  from history h,  client1 c1, client2 c2, branches b, sett_mst st
where  h.party_code=c2.party_code and c1.cl_code = c2.cl_code and
c1.family = @statusname
and h.sett_type like ltrim(@settype)+'%'
and h.sett_type=st.sett_type and h.sett_no=st.sett_no
order by h.sett_no  desc
end

GO
