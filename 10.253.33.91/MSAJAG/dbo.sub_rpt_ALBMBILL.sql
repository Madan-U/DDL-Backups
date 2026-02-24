-- Object: PROCEDURE dbo.sub_rpt_ALBMBILL
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sub_rpt_ALBMBILL    Script Date: 3/17/01 9:56:11 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_ALBMBILL    Script Date: 3/21/01 12:50:32 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_ALBMBILL    Script Date: 20-Mar-01 11:39:10 PM ******/

/*billreport.asp of subbills
modified by neelambari on 5 feb
here partipant code from trdbackup was not selected . instead party_code as selected so modified the partycode to partipant code for selection


*/


CREATE PROCEDURE sub_rpt_ALBMBILL 
@nextlsettno varchar(7),
@prevlsettno varchar(7),
@membercode varchar(10),
@name varchar(21),
@billno varchar(5)
AS
select h.sett_no,Party_Code=h.PartiPantCode,h.scrip_cd,h.sell_buy,h.tradeqty,h.n_netrate,h.sauda_date, 
h.Brokapplied,h.NBrokApp,h.NSerTax,h.sett_type ,
st.start_date,st.end_date , h.billno
from trdbackup h, multibroker m , sett_mst st
where ((h.sett_no=@prevlsettno and h.sett_type='L')or (h.sett_no=@nextlsettno and h.sett_type='L')) 
and h.partipantcode like ltrim(@membercode)+'%' and m.name like ltrim(@name)+ '%' 
and h.partipantcode=m.cltcode and h.BillNo like ltrim(@billno)+'%' and st.sett_no=h.sett_no and
st.sett_type=h.sett_type
order by h.sett_no,h.PartiPantCode,h.scrip_cd,h.sell_buy

GO
