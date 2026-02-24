-- Object: PROCEDURE dbo.sub_rpt_newalbmbill
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sub_rpt_newalbmbill    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_newalbmbill    Script Date: 3/21/01 12:50:32 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_newalbmbill    Script Date: 20-Mar-01 11:39:10 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_newalbmbill    Script Date: 12/27/00 8:59:17 PM ******/
/* report : bills report
   file : billreport.asp */
/*displays albmbill for a particular  settlement  type and number for a client or clients*/
CREATE PROCEDURE sub_rpt_newalbmbill
@nextlsettno varchar(7),
@prevlsettno varchar(7),
@membercode varchar(15),
@name varchar(21),
@billno varchar(5)
AS
 
/*
select  h.sett_no,h.party_code,h.scrip_cd,h.sell_buy,h.tradeqty,h.netrate,h.sauda_date, 
h.Brokapplied,h.NBrokApp,h.NSerTax,h.sett_type ,st.start_date,st.end_date , h.billno
from trdbackup h,multibroker m , sett_mst st
where ((h.sett_no=@prevlsettno and h.sett_type='L')or (h.sett_no=@nextlsettno and h.sett_type='L')) 
and h.partipantcode like ltrim(@membercode)+'%' and m.name like ltrim(@name)+ '%' and
h.partipantcode=m.cltcode and 
h.BillNo like  ltrim(@billno)+'%' and st.sett_no=h.sett_no and
st.sett_type=h.sett_type
*/
/*Modified by neelambari on 5 feb
here partycode was selected instead of partipantcode so chnages are made in query below
*/
select  h.sett_no, party_code =h.partipantcode , h.scrip_cd,h.sell_buy,h.tradeqty,h.netrate,h.sauda_date, 
h.Brokapplied,h.NBrokApp,h.NSerTax,h.sett_type ,st.start_date,st.end_date , h.billno
from trdbackup h,multibroker m , sett_mst st
where ((h.sett_no=@prevlsettno and h.sett_type='L')or (h.sett_no=@nextlsettno and h.sett_type='L')) 
and h.partipantcode like ltrim(@membercode)+'%' and m.name like ltrim(@name)+ '%' and
h.partipantcode=m.cltcode and 
h.BillNo like  ltrim(@billno)+'%' and st.sett_no=h.sett_no and
st.sett_type=h.sett_type

GO
