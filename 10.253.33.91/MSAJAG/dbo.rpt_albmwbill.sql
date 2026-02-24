-- Object: PROCEDURE dbo.rpt_albmwbill
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_albmwbill    Script Date: 04/27/2001 4:32:32 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmwbill    Script Date: 3/21/01 12:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmwbill    Script Date: 20-Mar-01 11:38:53 PM ******/





/****** Object:  Stored Procedure dbo.rpt_albmwbill    Script Date: 12/27/00 8:58:53 PM ******/
/* report : bill report
    file : billreport
*/
/* displays bill details for albm w transactions  for a particular settlement */
    
CREATE PROCEDURE rpt_albmwbill
@partycode varchar(10),
@name varchar(21),
@billno varchar(10),
@settno varchar(7)
AS
select a.SETT, a.SER, a.party_code, a.sell_buy, a.scrip_cd, a.series, a.tradeqty, a.marketrate, a.netrate, a.brokapplied  
,a.nsertax,a.nbrokapp,a.rate,a.Sett_no, a.sett_type, a.billno, a.user_id, c1.short_name, c1.L_Address1,
c1.L_Address2,c1.L_Address3 ,c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,
st.start_date,st.end_date,a.sauda_date , names=a.short_name, c2.service_chrg
from albm a, client2 c2, client1 c1, sett_mst st
where a.party_code like ltrim(@partycode) +'%' and c1.short_name like  ltrim(@name)+'%' 
and c2.party_code=a.party_code and c1.cl_code=c2.cl_code and a.BillNo like ltrim(@billno)+'%' and st.sett_no=a.sett and
st.sett_type=a.sett_type
and a.sett=@settno
order by a.sett,a.ser,a.party_code,a.scrip_cd,a.sell_buy

GO
