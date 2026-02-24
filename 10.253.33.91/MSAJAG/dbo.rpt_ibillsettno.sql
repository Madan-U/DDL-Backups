-- Object: PROCEDURE dbo.rpt_ibillsettno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_ibillsettno    Script Date: 04/27/2001 4:32:43 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ibillsettno    Script Date: 3/21/01 12:50:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ibillsettno    Script Date: 20-Mar-01 11:38:58 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ibillsettno    Script Date: 2/5/01 12:06:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ibillsettno    Script Date: 12/27/00 8:59:12 PM ******/

/* institutional trading */
/* report : bill report
    file : billmain.asp 
    report : settlementwise brokerage
    file : brokmain.asp  
 */
/* displays settlement numbers from settlement  and history */
CREATE PROCEDURE rpt_ibillsettno
@statusid varchar(15),
@statusname varchar(25),
@settype varchar(3)
AS
if @statusid = 'broker' 
begin
select distinct s.sett_no, end_date from isettlement s , sett_mst st where s.sett_type=@settype
and s.sett_type=st.sett_type and s.sett_no=st.sett_no
union
select distinct s.sett_no , end_date from ihistory s, sett_mst st where s.sett_type=@settype
and s.sett_type=st.sett_type and s.sett_no=st.sett_no
order by end_date desc
end
if @statusid = 'branch' 
begin
select distinct h.sett_no , end_date from isettlement h,  sett_mst st ,CLIENT1 C1, CLIENT2 C2, BRANCHES B
WHERE B.SHORT_NAME=C1.TRADER AND h.party_code=c2.party_code and C1.CL_CODE=C2.CL_CODE AND 
B.BRANCH_CD= @statusname and h.sett_type=@settype
and h.sett_type=st.sett_type and h.sett_no=st.sett_no
union
select distinct h.sett_no , end_date from ihistory h,  sett_mst st, CLIENT1 C1, CLIENT2 C2, BRANCHES B
WHERE B.SHORT_NAME=C1.TRADER AND h.party_code=c2.party_code and C1.CL_CODE=C2.CL_CODE AND 
B.BRANCH_CD= @statusname and h.sett_type=@settype
and h.sett_type=st.sett_type and h.sett_no=st.sett_no
order by end_date desc
end
if @statusid = 'trader' 
begin
select distinct h.sett_no , end_date from isettlement h,  sett_mst st, CLIENT1 C1, CLIENT2 C2
WHERE h.party_code=c2.party_code and C1.CL_CODE=C2.CL_CODE and c1.trader=@statusname
and h.sett_type=@settype
and h.sett_type=st.sett_type and h.sett_no=st.sett_no
union
select distinct h.sett_no , end_date from ihistory h,  sett_mst st, CLIENT1 C1, CLIENT2 C2
WHERE h.party_code=c2.party_code and C1.CL_CODE=C2.CL_CODE and c1.trader=@statusname
and h.sett_type=@settype
and h.sett_type=st.sett_type and h.sett_no=st.sett_no
order by end_date desc
end 
if @statusid = 'subbroker' 
begin
select distinct h.sett_no, end_date from isettlement h, sett_mst st, client1 c1, client2 c2, subbrokers sb
where h.party_code=c2.party_code and c2.cl_code=c1.cl_code and c1.sub_broker=sb.sub_broker and 
sb.sub_broker=@statusname
and h.sett_type=@settype
and h.sett_type=st.sett_type and h.sett_no=st.sett_no
union
select distinct h.sett_no, end_date from ihistory h, sett_mst st, client1 c1, client2 c2, subbrokers sb
where h.party_code=c2.party_code and c2.cl_code=c1.cl_code and c1.sub_broker=sb.sub_broker and 
sb.sub_broker=@statusname
and h.sett_type=@settype
and h.sett_type=st.sett_type and h.sett_no=st.sett_no
order by end_date desc
end 
if @statusid = 'client' 
begin
select distinct h.sett_no , end_date from isettlement h, sett_mst st, client1 c1, client2 c2
where h.party_code=c2.party_code and c2.cl_code=c1.cl_code and 
h.party_code=@statusname
and h.sett_type=@settype
and h.sett_type=st.sett_type and h.sett_no=st.sett_no
union
select distinct h.sett_no , end_date from ihistory h, sett_mst st, client1 c1, client2 c2
where h.party_code=c2.party_code and c2.cl_code=c1.cl_code and 
h.party_code=@statusname
and h.sett_type=@settype
and h.sett_type=st.sett_type and h.sett_no=st.sett_no
order by end_date desc
end

GO
