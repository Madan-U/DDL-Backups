-- Object: PROCEDURE dbo.sub_rpt_billreport
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sub_rpt_billreport    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_billreport    Script Date: 3/21/01 12:50:32 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_billreport    Script Date: 20-Mar-01 11:39:10 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_billreport    Script Date: 2/5/01 12:06:29 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_billreport    Script Date: 12/27/00 8:59:17 PM ******/




/* report : bills report
   file : billreport.asp */

/* displays bill for a particular  settlement  type and number for a client or clients*/
CREATE PROCEDURE sub_rpt_billreport
 
@membercode varchar(15),
@partyname varchar(21),
@settno varchar(7),
@settype varchar(3),
@billno varchar(10)
AS
select h.BillNo,h.PartipantCode,m.name,h.Scrip_Cd ,h.Tradeqty,h.Sauda_date,h.Sell_buy ,
h.Brokapplied,h.sett_no,h.NBrokApp , h. NetRate,h.sett_type,
h.NSerTax,st.start_date,st.end_date
from TrdBackUp h,multibroker m,sett_mst st 
where h.sett_no = st.sett_no and h.sett_type = st.sett_type and h.partipantcode = m.cltcode and
h.partipantcode like ltrim(@membercode)+'%' and m.name like  ltrim(@partyname)+'%' and
h.sett_no like  ltrim(@settno)+'%' and h.sett_type like  ltrim(@settype)+'%' 
and h.BillNo like  ltrim(@billno)+'%' 
order by h.sett_no,h.sett_type,h.partipantCode,m.name,h.Scrip_Cd,h.sell_buy

GO
