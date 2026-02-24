-- Object: PROCEDURE dbo.brbillno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brbillno    Script Date: 3/17/01 9:55:45 PM ******/

/****** Object:  Stored Procedure dbo.brbillno    Script Date: 3/21/01 12:50:01 PM ******/

/****** Object:  Stored Procedure dbo.brbillno    Script Date: 20-Mar-01 11:38:44 PM ******/

/****** Object:  Stored Procedure dbo.brbillno    Script Date: 2/5/01 12:06:07 PM ******/

/****** Object:  Stored Procedure dbo.brbillno    Script Date: 12/27/00 8:58:43 PM ******/

/* Report : Before Bill
    File :sbillreport.asp
displays bill for a particular settlement no and type and party
*/ 
CREATE PROCEDURE brbillno
@partycode varchar(10),
@shortname varchar(21),
@settno varchar(7),
@settype varchar(3),
@billno varchar(10),
@br varchar(3)
AS
select h.BillNo,h.Party_Code,c1.short_name,h.Scrip_Cd ,h.Tradeqty,h.Sauda_date,
h.Sell_buy ,h.Brokapplied,h.sett_no,h.NBrokApp , h. NetRate,h.sett_type, c1.L_Address1,
c1.L_Address2,c1.L_Address3 ,c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,h.NSerTax,
st.start_date,st.end_date
from Settlement h,client1 c1,client2 c2,sett_mst st,branches b 
where h.sett_no = st.sett_no and h.sett_type = st.sett_type and b.short_name = c1.trader and
c1.cl_code=c2.cl_code and c2.party_code=h.party_code and h.party_code like ltrim(@partycode)+'%' 
and c1.short_name like ltrim(@shortname)+'%' and h.sett_no like ltrim(@settno)+'%' and h.sett_type like ltrim(@settype)+'%' and
h.BillNo like ltrim(@billno)+ '%' and b.branch_cd = @br
order by h.sett_no,h.sett_type,h.Party_Code,c1.short_name,h.Scrip_Cd,
h.sell_buy

GO
