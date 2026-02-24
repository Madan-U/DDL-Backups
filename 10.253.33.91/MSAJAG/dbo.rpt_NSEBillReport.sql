-- Object: PROCEDURE dbo.rpt_NSEBillReport
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_NSEBillReport    Script Date: 04/27/2001 4:32:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_NSEBillReport    Script Date: 3/21/01 12:50:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_NSEBillReport    Script Date: 20-Mar-01 11:39:01 PM ******/

/****** Object:  Stored Procedure dbo.rpt_NSEBillReport    Script Date: 2/5/01 12:06:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_NSEBillReport    Script Date: 12/27/00 8:58:56 PM ******/

/* report : bills report
   file : billreport.asp */
/* displays bill for a particular  settlement  type and number for a client or clients*/
CREATE PROCEDURE rpt_NSEBillReport
@partycode varchar(10),
@partyname varchar(21),
@settno varchar(7),
@settype varchar(3),
@billno varchar(10)
AS
if ( select Count(sett_no) from settlement where sett_no =@settno and sett_type =@settype ) > 0 
 begin
 select h.BillNo,h.Party_Code,c1.short_name,h.Scrip_Cd ,h.Tradeqty,h.Sauda_date,h.Sell_buy ,
 h.Brokapplied,h.sett_no,h.NBrokApp , h. NetRate,h.sett_type, c1.L_Address1,c1.L_Address2,c1.L_Address3 ,
 c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,h.NSerTax,st.start_date,st.end_date
 from Settlement h,client1 c1,client2 c2,sett_mst st 
 where h.sett_no = st.sett_no and h.sett_type = st.sett_type and c1.cl_code=c2.cl_code and
 c2.party_code=h.party_code and h.party_code like ltrim(@partycode)+'%' and c1.short_name like  ltrim(@partyname)+'%' and
 h.sett_no like  ltrim(@settno)+'%' and h.sett_type like  ltrim(@settype)+'%' and h.BillNo like  ltrim(@billno)+'%' 
 order by h.sett_no,h.sett_type,h.Party_Code,c1.short_name,h.Scrip_Cd,h.sell_buy 
 end
else
 begin
 select h.BillNo,h.Party_Code,c1.short_name,h.Scrip_Cd ,h.Tradeqty,h.Sauda_date,h.Sell_buy ,
 h.Brokapplied,h.sett_no,h.NBrokApp , h. NetRate,h.sett_type, c1.L_Address1,c1.L_Address2,c1.L_Address3 ,
 c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,h.NSerTax,st.start_date,st.end_date
 from history h,client1 c1,client2 c2,sett_mst st 
 where h.sett_no = st.sett_no and h.sett_type = st.sett_type and c1.cl_code=c2.cl_code and
 c2.party_code=h.party_code and h.party_code like ltrim(@partycode)+'%' and c1.short_name like  ltrim(@partyname)+'%' and
 h.sett_no like  ltrim(@settno)+'%' and h.sett_type like  ltrim(@settype)+'%' and h.BillNo like  ltrim(@billno)+'%' 
 order by h.sett_no,h.sett_type,h.Party_Code,c1.short_name,h.Scrip_Cd,h.sell_buy 
 end

GO
