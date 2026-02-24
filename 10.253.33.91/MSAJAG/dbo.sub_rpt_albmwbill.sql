-- Object: PROCEDURE dbo.sub_rpt_albmwbill
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sub_rpt_albmwbill    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_albmwbill    Script Date: 3/21/01 12:50:32 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_albmwbill    Script Date: 20-Mar-01 11:39:10 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_albmwbill    Script Date: 2/5/01 12:06:29 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_albmwbill    Script Date: 12/27/00 8:59:18 PM ******/




/* report : bill report
    file : billreport
*/
/* displays bill details for albm w transactions  for a particular settlement */
    
CREATE PROCEDURE sub_rpt_albmwbill
 
@membercode varchar(15),
@names varchar(21),
@billno varchar(10),
@settno varchar(7)

AS

select a.SETT, a.SER, a.partipantcode, a.sell_buy, 
a.scrip_cd, a.series, a.tradeqty, a.marketrate, a.netrate, a.brokapplied  
,a.nsertax,a.nbrokapp,a.rate,a.Sett_no, a.sett_type, a.billno, a.user_id, 
st.start_date,st.end_date,a.sauda_date 
from sub_albm a,multibroker m, sett_mst st
where a.partipantcode like ltrim(@membercode) +'%' 
and m.name like  ltrim(@names)+'%' 
and m.cltcode=a.partipantcode and 
a.BillNo like ltrim(@billno)+'%'
and st.sett_no=a.sett and
st.sett_type=a.sett_type
and a.sett=@settno
order by a.sett,a.ser,a.partipantcode,a.scrip_cd,a.sell_buy

GO
