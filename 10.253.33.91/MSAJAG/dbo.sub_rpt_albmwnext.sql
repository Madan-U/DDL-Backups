-- Object: PROCEDURE dbo.sub_rpt_albmwnext
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sub_rpt_albmwnext    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_albmwnext    Script Date: 3/21/01 12:50:32 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_albmwnext    Script Date: 20-Mar-01 11:39:10 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_albmwnext    Script Date: 2/5/01 12:06:29 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_albmwnext    Script Date: 12/27/00 8:59:17 PM ******/




/* bill report
*/
    
CREATE PROCEDURE sub_rpt_albmwnext

@partipantcode varchar(10),
@name varchar(21),
@settno varchar(7),
@statusid varchar(15),
@statusname varchar(25)
AS
select s.partipantcode, s.sell_buy, s.scrip_cd, names= s1.short_name,s.series, s.tradeqty, s.marketrate, s.netrate, s.brokapplied  
,s.nsertax,s.nbrokapp,a.rate,s.Sett_no, s.sett_type, s.billno, s.user_id, 
st.start_date,st.end_date, s.sauda_date
from trdbackup s,multibroker m ,sett_mst st, albmrate a, scrip1 s1, scrip2 s2
where s.partipantcode like ltrim(@partipantcode)+'%' and m.name like  ltrim(@name)+'%' 
and m.cltcode=s.partipantcode  and st.sett_no=s.sett_no and
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

GO
