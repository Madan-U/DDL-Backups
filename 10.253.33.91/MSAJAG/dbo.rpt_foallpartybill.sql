-- Object: PROCEDURE dbo.rpt_foallpartybill
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_foallpartybill    Script Date: 5/11/01 6:19:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foallpartybill    Script Date: 5/7/2001 9:02:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foallpartybill    Script Date: 5/5/2001 2:43:35 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foallpartybill    Script Date: 5/5/2001 1:24:08 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foallpartybill    Script Date: 4/30/01 5:50:06 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foallpartybill    Script Date: 10/26/00 6:04:40 PM ******/






/****** Object:  Stored Procedure dbo.rpt_foallpartybill    Script Date: 12/27/00 8:59:17 PM ******/
CREATE PROCEDURE rpt_foallpartybill
@code varchar(10),
@name varchar(21),
@settno varchar(7),
@settype varchar(3),
@billno varchar(15)
AS
select h.BillNo,h.Party_Code,c1.short_name, sc1.short_name, 
h.Tradeqty,h.Sauda_date,h.Sell_buy , 
h.Brokapplied,h.sett_no,h.NBrokApp , h. NetRate,h.sett_type, 
c1.L_Address1,c1.L_Address2,c1.L_Address3 , 
c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,h.NSerTax,st.start_date,st.end_date 
from history h,client1 c1,client2 c2,sett_mst st, scrip1 sc1, scrip2 sc2  
where h.sett_no = st.sett_no and h.sett_type = st.sett_type 
and c1.cl_code=c2.cl_code and c2.party_code=h.party_code 
and h.party_code like ltrim(@code)+'%' 
and c1.short_name like ltrim(@name)+'%' 
and h.sett_no like ltrim(@settno)+'%' 
and h.sett_type like ltrim(@settype)+'%' 
and h.BillNo like ltrim(@billno)+'%' 
and h.scrip_cd=sc2.scrip_cd and sc2.co_code=sc1.co_code and h.series=sc1.series 
and sc1.series=sc2.series 
order by h.sett_no,h.sett_type,h.Party_Code,c1.short_name,h.Scrip_Cd,h.sell_buy

GO
