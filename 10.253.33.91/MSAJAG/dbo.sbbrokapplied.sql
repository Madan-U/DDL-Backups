-- Object: PROCEDURE dbo.sbbrokapplied
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbbrokapplied    Script Date: 3/17/01 9:56:06 PM ******/

/****** Object:  Stored Procedure dbo.sbbrokapplied    Script Date: 3/21/01 12:50:25 PM ******/

/****** Object:  Stored Procedure dbo.sbbrokapplied    Script Date: 20-Mar-01 11:39:04 PM ******/

/****** Object:  Stored Procedure dbo.sbbrokapplied    Script Date: 2/5/01 12:06:24 PM ******/

/****** Object:  Stored Procedure dbo.sbbrokapplied    Script Date: 12/27/00 8:58:59 PM ******/

CREATE PROCEDURE  sbbrokapplied 
@subbroker varchar(15),
@partycode varchar(10),
@partyname varchar(21),
@hsettno varchar(7),
@hsetttype varchar(3),
@hbillno varchar(10)
AS
select h.BillNo,h.Party_Code,c1.short_name,h.Scrip_Cd ,h.Tradeqty,h.Sauda_date,h.Sell_buy ,h.Brokapplied,
h.sett_no,h.NBrokApp , h. NetRate,h.sett_type, c1.L_Address1,c1.L_Address2,c1.L_Address3 ,c1.L_city,
c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,h.NSerTax,st.start_date,st.end_date from Settlement h,client1 c1,
client2 c2,sett_mst st, subbrokers sb where h.sett_no = st.sett_no and h.sett_type = st.sett_type and 
c1.cl_code=c2.cl_code 
and c2.party_code=h.party_code and c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker
and h.party_code like ltrim(@partycode)+'%' and c1.short_name like ltrim(@partyname)+'%'
and h.sett_no like ltrim(@hsettno)+'%%' and 
h.sett_type like ltrim(@hsetttype)+ '%%' and 
h.BillNo like ltrim(@hbillno)+ '%' 
order by h.sett_no,h.sett_type,h.Party_Code,c1.short_name,h.Scrip_Cd,
h.sell_buy

GO
