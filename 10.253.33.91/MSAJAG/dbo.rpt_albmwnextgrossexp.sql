-- Object: PROCEDURE dbo.rpt_albmwnextgrossexp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_albmwnextgrossexp    Script Date: 04/27/2001 4:32:32 PM ******/


/****** Object:  Stored Procedure dbo.rpt_albmwnextgrossexp    Script Date: 04/21/2001 6:05:15 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmwnextgrossexp    Script Date: 3/21/01 12:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmwnextgrossexp    Script Date: 20-Mar-01 11:38:53 PM ******/






/* bill report
*/
    
CREATE PROCEDURE rpt_albmwnextgrossexp
@partycode varchar(10),
@name varchar(21),
@settno varchar(7),
@statusid varchar(15),
@statusname varchar(25)
AS
if @statusid='broker'
begin
select s.party_code, s.sell_buy, s.scrip_cd, names= rtrim(s1.short_name), s.series, 
s.tradeqty, s.marketrate, s.netrate, s.brokapplied  
,s.nsertax,s.nbrokapp,a.rate,s.Sett_no, s.sett_type, s.billno, s.user_id, 
c1.short_name, c1.L_Address1,
c1.L_Address2,c1.L_Address3 ,c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,
st.start_date,st.end_date, s.sauda_date,
scripmargin=isnull((select addmargin from margin2 where sett_no=@settno and sett_type='P' and scrip_cd=s.scrip_cd) ,0),
fixmargin=isnull((select fixmargin from margin1 where sett_no=@settno and sett_type='p' ),0)
from settlement s, client2 c2, client1 c1, sett_mst st, albmrate a, scrip1 s1, scrip2 s2
where s.party_code like ltrim(@partycode)+'%' and c1.short_name like  ltrim(@name)+'%' 
and c2.party_code=s.party_code and c1.cl_code=c2.cl_code  and st.sett_no=s.sett_no and
st.sett_type=s.sett_type
and s.sett_no=@settno
and s.sett_type='p'
and a.sett_no=s.sett_no
and a.sett_type=s.sett_type
and a.scrip_cd=s.scrip_cd
and a.series=s.series
and s1.co_code=s2.co_code
and s2.scrip_cd=s.scrip_cd
and s.series=s2.series
and s2.series=s1.series
order by s.party_code,  s1.short_name,s.series,s.sell_buy 
end 
if @statusid='branch'
begin
select s.party_code, s.sell_buy, s.scrip_cd, s.series,names=s1.short_name, 
s.tradeqty, s.marketrate, s.netrate, s.brokapplied  
,s.nsertax,s.nbrokapp,a.rate,s.Sett_no, s.sett_type, s.billno, s.user_id, 
c1.short_name, c1.L_Address1,
c1.L_Address2,c1.L_Address3 ,c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,
st.start_date,st.end_date, s.sauda_date,
scripmargin=isnull((select addmargin from margin2 where sett_no=@settno and sett_type='P' and scrip_cd=s.scrip_cd) ,0),
fixmargin=isnull((select fixmargin from margin1 where sett_no=@settno and sett_type='p' ),0)
from settlement s, client2 c2, client1 c1, sett_mst st, albmrate a, branches b,scrip1 s1, scrip2 s2
where s.party_code like ltrim(@partycode)+'%' and c1.short_name like  ltrim(@name)+'%' 
and c2.party_code=s.party_code and c1.cl_code=c2.cl_code  and st.sett_no=s.sett_no and
st.sett_type=s.sett_type
and s.sett_no=@settno
and s.sett_type='p'
and a.sett_no=s.sett_no
and a.sett_type=s.sett_type
and a.scrip_cd=s.scrip_cd
and a.series=s.series
and b.branch_cd=@statusname
and b.short_name=c1.trader
and s1.co_code=s2.co_code
and s2.scrip_cd=s.scrip_cd
and s.series=s2.series
and s2.series=s1.series
order by s.party_code,  s1.short_name,s.series,s.sell_buy 
end 
if @statusid='trader'
begin
select s.party_code, s.sell_buy, s.scrip_cd, names=s1.short_name,s.series, 
s.tradeqty, s.marketrate, s.netrate, s.brokapplied  
,s.nsertax,s.nbrokapp,a.rate,s.Sett_no, s.sett_type, s.billno, s.user_id, 
c1.short_name, c1.L_Address1,
c1.L_Address2,c1.L_Address3 ,c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,
st.start_date,st.end_date, s.sauda_date,
scripmargin=isnull((select addmargin from margin2 where sett_no=@settno and sett_type='P' and scrip_cd=s.scrip_cd) ,0),
fixmargin=isnull((select fixmargin from margin1 where sett_no=@settno and sett_type='p' ),0)
from settlement s, client2 c2, client1 c1, sett_mst st, albmrate a ,scrip1 s1, scrip2 s2
where s.party_code like ltrim(@partycode)+'%' and c1.short_name like  ltrim(@name)+'%' 
and c2.party_code=s.party_code and c1.cl_code=c2.cl_code  and st.sett_no=s.sett_no and
st.sett_type=s.sett_type
and s.sett_no=@settno
and s.sett_type='p'
and a.sett_no=s.sett_no
and a.sett_type=s.sett_type
and a.scrip_cd=s.scrip_cd
and a.series=s.series
and c1.trader=@statusname
and s1.co_code=s2.co_code
and s2.scrip_cd=s.scrip_cd
and s.series=s2.series
and s2.series=s1.series
order by s.party_code,  s1.short_name,s.series,s.sell_buy 
end 
if @statusid='subbroker'
begin
select s.party_code, s.sell_buy, s.scrip_cd,names=s1.short_name, s.series, 
s.tradeqty, s.marketrate, s.netrate, s.brokapplied  
,s.nsertax,s.nbrokapp,a.rate,s.Sett_no, s.sett_type, s.billno, s.user_id, 
c1.short_name, c1.L_Address1,
c1.L_Address2,c1.L_Address3 ,c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,
st.start_date,st.end_date, s.sauda_date,
scripmargin=isnull((select addmargin from margin2 where sett_no=@settno and sett_type='P' and scrip_cd=s.scrip_cd) ,0),
fixmargin=isnull((select fixmargin from margin1 where sett_no=@settno and sett_type='p' ),0)
from settlement s, client2 c2, client1 c1, sett_mst st, albmrate a, subbrokers sb,scrip1 s1, scrip2 s2
where s.party_code like ltrim(@partycode)+'%' and c1.short_name like  ltrim(@name)+'%' 
and c2.party_code=s.party_code and c1.cl_code=c2.cl_code  and st.sett_no=s.sett_no and
st.sett_type=s.sett_type
and s.sett_no=@settno
and s.sett_type='p'
and a.sett_no=s.sett_no
and a.sett_type=s.sett_type
and a.scrip_cd=s.scrip_cd
and a.series=s.series
and sb.sub_broker=c1.sub_broker
and sb.sub_broker=@statusname
and s1.co_code=s2.co_code
and s2.scrip_cd=s.scrip_cd
and s.series=s2.series
and s2.series=s1.series
order by s.party_code,  s1.short_name,s.series,s.sell_buy 
end 
if @statusid='client'
begin
select s.party_code, s.sell_buy, s.scrip_cd, names=s1.short_name,s.series, 
s.tradeqty, s.marketrate, s.netrate, s.brokapplied  
,s.nsertax,s.nbrokapp,a.rate,s.Sett_no, s.sett_type, s.billno, s.user_id, 
c1.short_name, c1.L_Address1,
c1.L_Address2,c1.L_Address3 ,c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,
st.start_date,st.end_date, s.sauda_date,
scripmargin=isnull((select addmargin from margin2 where sett_no=@settno and sett_type='P' and scrip_cd=s.scrip_cd) ,0),
fixmargin=isnull((select fixmargin from margin1 where sett_no=@settno and sett_type='p' ),0)
from settlement s, client2 c2, client1 c1, sett_mst st, albmrate a,scrip1 s1, scrip2 s2
where s.party_code like ltrim(@partycode)+'%' and c1.short_name like  ltrim(@name)+'%' 
and c2.party_code=s.party_code and c1.cl_code=c2.cl_code  and st.sett_no=s.sett_no and
st.sett_type=s.sett_type
and s.sett_no=@settno
and s.sett_type='p'
and a.sett_no=s.sett_no
and a.sett_type=s.sett_type
and a.scrip_cd=s.scrip_cd
and a.series=s.series
and s.party_code=@statusname
and s1.co_code=s2.co_code
and s2.scrip_cd=s.scrip_cd
and s.series=s2.series
and s2.series=s1.series
order by s.party_code,  s1.short_name,s.series,s.sell_buy 
end 


if @statusid='family'
begin
select s.party_code, s.sell_buy, s.scrip_cd, names= rtrim(s1.short_name), s.series, 
s.tradeqty, s.marketrate, s.netrate, s.brokapplied  
,s.nsertax,s.nbrokapp,a.rate,s.Sett_no, s.sett_type, s.billno, s.user_id, 
c1.short_name, c1.L_Address1,
c1.L_Address2,c1.L_Address3 ,c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,
st.start_date,st.end_date, s.sauda_date,
scripmargin=isnull((select addmargin from margin2 where sett_no=@settno and sett_type='P' and scrip_cd=s.scrip_cd) ,0),
fixmargin=isnull((select fixmargin from margin1 where sett_no=@settno and sett_type='p' ),0)
from settlement s, client2 c2, client1 c1, sett_mst st, albmrate a, scrip1 s1, scrip2 s2
where s.party_code like ltrim(@partycode)+'%' and c1.short_name like  ltrim(@name)+'%' 
and c2.party_code=s.party_code and c1.cl_code=c2.cl_code  and st.sett_no=s.sett_no and
st.sett_type=s.sett_type
and s.sett_no=@settno
and s.sett_type='p'
and a.sett_no=s.sett_no
and a.sett_type=s.sett_type
and a.scrip_cd=s.scrip_cd
and a.series=s.series
and s1.co_code=s2.co_code
and s2.scrip_cd=s.scrip_cd
and s.series=s2.series
and s2.series=s1.series
and c1.family=@statusname
order by s.party_code,  s1.short_name,s.series,s.sell_buy 
end

GO
