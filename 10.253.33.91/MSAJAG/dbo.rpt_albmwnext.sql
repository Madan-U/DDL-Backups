-- Object: PROCEDURE dbo.rpt_albmwnext
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_albmwnext    Script Date: 04/27/2001 4:32:32 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmwnext    Script Date: 3/21/01 12:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmwnext    Script Date: 20-Mar-01 11:38:53 PM ******/





/****** Object:  Stored Procedure dbo.rpt_albmwnext    Script Date: 12/27/00 8:58:53 PM ******/
/* chaged by  mousami  added c2.service_chrg to  query*/
/* changed by mousami on 09/03/2001 
     added sebi_tax, other_chrg ,Broker_chrg, Ins_chrg , turn_tax columns to query */
CREATE PROCEDURE rpt_albmwnext
@partycode varchar(10),
@name varchar(21),
@settno varchar(7)
AS
select s.party_code, s.sell_buy, s.scrip_cd, s.series, 
s.tradeqty, s.marketrate, s.netrate, s.brokapplied  
,s.nsertax,s.nbrokapp,a.rate,s.Sett_no, s.sett_type, s.billno, s.user_id, 
c1.short_name, c1.L_Address1,
c1.L_Address2,c1.L_Address3 ,c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,
st.start_date,st.end_date, s.sauda_date, c2.service_chrg,
s.sebi_tax, s.other_chrg ,s.Broker_chrg,s. Ins_chrg ,s. turn_tax
from settlement s, client2 c2, client1 c1, sett_mst st, albmrate a
where s.party_code like ltrim(@partycode)+'%' and c1.short_name like  ltrim(@name)+'%' 
and c2.party_code=s.party_code and c1.cl_code=c2.cl_code  and st.sett_no=s.sett_no and
st.sett_type=s.sett_type
and s.sett_no=@settno
and s.sett_type='p'
and a.sett_no=s.sett_no
and a.sett_type=s.sett_type
and a.scrip_cd=s.scrip_cd
and a.series=s.series
/*
union all
select s.party_code, s.sell_buy, s.scrip_cd, s.series, 
s.tradeqty, s.marketrate, s.netrate, s.brokapplied  
,s.nsertax,s.nbrokapp,a.rate,s.Sett_no, s.sett_type, s.billno, s.user_id, 
c1.short_name, c1.L_Address1,
c1.L_Address2,c1.L_Address3 ,c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,
st.start_date,st.end_date 
from history s, client2 c2, client1 c1, sett_mst st, albmrate a
where s.party_code like ltrim(@partycode)+'%' and c1.short_name like  ltrim(@name)+'%' 
and c2.party_code=s.party_code and c1.cl_code=c2.cl_code  and st.sett_no=s.sett_no and
st.sett_type=s.sett_type
and s.sett_no=@settno
and s.sett_type='p'
and a.sett_no=s.sett_no
and a.sett_type=s.sett_type
and a.scrip_cd=s.scrip_cd
and a.series=s.series
order by s.sett_no,s.series,s.party_code,s.scrip_cd,s.sell_buy
*/

GO
