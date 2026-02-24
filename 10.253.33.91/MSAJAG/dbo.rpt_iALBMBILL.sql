-- Object: PROCEDURE dbo.rpt_iALBMBILL
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_iALBMBILL    Script Date: 04/27/2001 4:32:43 PM ******/





/****** Object:  Stored Procedure dbo.rpt_iALBMBILL    Script Date: 2/5/01 12:06:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_iALBMBILL    Script Date: 12/27/00 8:59:11 PM ******/

/* institutional trades*/
/* report : bill report 
    file :billreport.asp
    displays albmbill for a particular settlement for institutional trading
*/  
/* changed by mousami on 21/04/2001 
     added service_chrg column*/
CREATE PROCEDURE rpt_iALBMBILL 
@nextlsettno varchar(7),
@prevlsettno varchar(7),
@partycode varchar(10),
@name varchar(21),
@billno varchar(5),
@pcode varchar(15)
AS
select  h.sett_no,h.party_code,h.scrip_cd,h.sell_buy,h.tradeqty,h.netrate,h.sauda_date, 
h.Brokapplied,h.NBrokApp,h.NSerTax,h.sett_type ,c1.short_name, c1.L_Address1,
c1.L_Address2,c1.L_Address3 ,c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,
st.start_date,st.end_date , h.billno, c2.service_chrg
from isettlement h, client1 c1, client2 c2 , sett_mst st
where ((h.sett_no=@prevlsettno and h.sett_type='L')or (h.sett_no=@nextlsettno and h.sett_type='L')) 
and h.party_code like ltrim(@partycode)+'%' and c1.short_name like ltrim(@name)+ '%' 
and c2.party_code=h.party_code and c1.cl_code=c2.cl_code and h.BillNo like ltrim(@billno)+'%' and st.sett_no=h.sett_no and
st.sett_type=h.sett_type and h.partipantcode like ltrim(@pcode)+'%'
union all
select  h.sett_no,h.party_code,h.scrip_cd,h.sell_buy,h.tradeqty,h.netrate,h.sauda_date, 
h.Brokapplied,h.NBrokApp,h.NSerTax,h.sett_type ,c1.short_name, c1.L_Address1,
c1.L_Address2,c1.L_Address3 ,c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,
st.start_date,st.end_date ,  h.billno , c2.service_chrg
from ihistory h, client1 c1, client2 c2  , sett_mst st 
where ((h.sett_no=@prevlsettno and h.sett_type='L')or (h.sett_no=@nextlsettno and h.sett_type='L')) 
and h.party_code like ltrim(@partycode)+'%' 
and c1.short_name like ltrim(@name)+'%'and c2.party_code=h.party_code and c1.cl_code=c2.cl_code 
and h.BillNo like ltrim(@billno)+'%' and st.sett_no=h.sett_no and
st.sett_type=h.sett_type
and h.partipantcode like ltrim(@pcode)+'%'
order by h.scrip_cd, h.sell_buy

GO
