-- Object: PROCEDURE dbo.newbill1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.newbill1    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.newbill1    Script Date: 3/21/01 12:50:10 PM ******/

/****** Object:  Stored Procedure dbo.newbill1    Script Date: 20-Mar-01 11:38:52 PM ******/

/****** Object:  Stored Procedure dbo.newbill1    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.newbill1    Script Date: 12/27/00 8:58:52 PM ******/

CREATE PROCEDURE newbill1
@code varchar(10),
@name varchar(21),
@settno varchar(7),
@settype varchar(3),
@billno varchar(10)
AS
select h.BillNo,h.Party_Code,c1.short_name,h.Scrip_Cd ,h.Tradeqty,h.Sauda_date,h.Sell_buy ,
h.Brokapplied,h.sett_no,h.NBrokApp , h. NetRate,h.sett_type, c1.L_Address1,c1.L_Address2,c1.L_Address3 ,
c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,h.NSerTax,st.start_date,st.end_date 
from Settlement h,client1 c1,client2 c2,sett_mst st
 where h.sett_no = st.sett_no and h.sett_type = st.sett_type and c1.cl_code=c2.cl_code 
and c2.party_code=h.party_code and h.party_code like ltrim(@code)+'%' and c1.short_name like ltrim(@name)+ '%' and 
h.sett_no like ltrim(@settno)+'%' and h.sett_type like ltrim(@settype) + '%' and h.BillNo like ltrim(@billno)+ '%'
order by h.sett_no,h.sett_type,h.Party_Code,c1.short_name,h.Scrip_Cd,h.sell_buy

GO
