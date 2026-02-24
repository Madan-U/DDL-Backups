-- Object: PROCEDURE dbo.rpt_ibillreport
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_ibillreport    Script Date: 04/27/2001 4:32:43 PM ******/





/****** Object:  Stored Procedure dbo.rpt_ibillreport    Script Date: 2/5/01 12:06:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ibillreport    Script Date: 12/27/00 8:59:12 PM ******/

/* institutional trades */
/* report : bills report for institutions
   file : billreport.asp */
/* displays bill for a particular  settlement  type and number for a client or clients*/
/* changed by mousami on 21/04/2001 added service_chrg column */
CREATE PROCEDURE rpt_ibillreport
@statusid varchar(15),
@statusname varchar(25),
@partycode varchar(10),
@partyname varchar(21),
@settno varchar(7),
@settype varchar(3),
@billno varchar(10),
@pcode varchar(15)
AS
if @statusid = 'broker' 
begin
if ( select Count(sett_no) from isettlement where sett_no =@settno and sett_type =@settype ) > 0 
begin
select h.BillNo,h.Party_Code,c1.short_name,h.Scrip_Cd ,h.Tradeqty,h.Sauda_date,h.Sell_buy ,
h.Brokapplied,h.sett_no,h.NBrokApp , h. NetRate,h.sett_type, c1.L_Address1,c1.L_Address2,c1.L_Address3 ,
c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,h.NSerTax,st.start_date,st.end_date, service_chrg
from iSettlement h,client1 c1,client2 c2,sett_mst st 
where h.sett_no = st.sett_no and h.sett_type = st.sett_type and c1.cl_code=c2.cl_code and
c2.party_code=h.party_code and h.party_code like ltrim(@partycode)+'%' and c1.short_name like  ltrim(@partyname)+'%' and
h.sett_no like  ltrim(@settno)+'%' and h.sett_type like  ltrim(@settype)+'%' and h.BillNo like  ltrim(@billno)+'%' 
and h.partipantcode like ltrim(@pcode)+'%'
order by h.sett_no,h.sett_type,h.Party_Code,c1.short_name,h.Scrip_Cd,h.sell_buy 
end
else
begin
 select h.BillNo,h.Party_Code,c1.short_name,h.Scrip_Cd ,h.Tradeqty,h.Sauda_date,h.Sell_buy ,
 h.Brokapplied,h.sett_no,h.NBrokApp , h. NetRate,h.sett_type, c1.L_Address1,c1.L_Address2,c1.L_Address3 ,
 c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,h.NSerTax,st.start_date,st.end_date,service_chrg
 from ihistory h,client1 c1,client2 c2,sett_mst st 
 where h.sett_no = st.sett_no and h.sett_type = st.sett_type and c1.cl_code=c2.cl_code and
 c2.party_code=h.party_code and h.party_code like ltrim(@partycode)+'%' and c1.short_name like  ltrim(@partyname)+'%' and
 h.sett_no like  ltrim(@settno)+'%' and h.sett_type like  ltrim(@settype)+'%' and h.BillNo like  ltrim(@billno)+'%' 
 and h.partipantcode like ltrim(@pcode)+'%'
 order by h.sett_no,h.sett_type,h.Party_Code,c1.short_name,h.Scrip_Cd,h.sell_buy 
end
end
if @statusid = 'branch' 
begin
if ( select Count(sett_no) from isettlement where sett_no =@settno and sett_type =@settype ) > 0 
 begin
 select h.BillNo,h.Party_Code,c1.short_name,h.Scrip_Cd ,h.Tradeqty,h.Sauda_date,h.Sell_buy ,
 h.Brokapplied,h.sett_no,h.NBrokApp , h. NetRate,h.sett_type, c1.L_Address1,c1.L_Address2,c1.L_Address3 ,
 c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,h.NSerTax,st.start_date,st.end_date,service_chrg
 from iSettlement h,client1 c1,client2 c2,sett_mst st , branches b
 where h.sett_no = st.sett_no and h.sett_type = st.sett_type and c1.cl_code=c2.cl_code and
 c2.party_code=h.party_code and h.party_code like ltrim(@partycode)+'%' and c1.short_name like  ltrim(@partyname)+'%' and
 h.sett_no like  ltrim(@settno)+'%' and h.sett_type like  ltrim(@settype)+'%' and h.BillNo like  ltrim(@billno)+'%' 
  and b.short_name=c1.trader and b.branch_cd=@statusname
 and h.partipantcode like ltrim(@pcode)+'%'
 order by h.sett_no,h.sett_type,h.Party_Code,c1.short_name,h.Scrip_Cd,h.sell_buy 
 end
else
 begin
 select h.BillNo,h.Party_Code,c1.short_name,h.Scrip_Cd ,h.Tradeqty,h.Sauda_date,h.Sell_buy ,
 h.Brokapplied,h.sett_no,h.NBrokApp , h. NetRate,h.sett_type, c1.L_Address1,c1.L_Address2,c1.L_Address3 ,
 c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,h.NSerTax,st.start_date,st.end_date,service_chrg
 from ihistory h,client1 c1,client2 c2,sett_mst st , branches b
 where h.sett_no = st.sett_no and h.sett_type = st.sett_type and c1.cl_code=c2.cl_code and
 c2.party_code=h.party_code and h.party_code like ltrim(@partycode)+'%' and c1.short_name like  ltrim(@partyname)+'%' and
 h.sett_no like  ltrim(@settno)+'%' and h.sett_type like  ltrim(@settype)+'%' and h.BillNo like  ltrim(@billno)+'%' 
  and b.short_name=c1.trader and b.branch_cd=@statusname
 and h.partipantcode like ltrim(@pcode)+'%'
 order by h.sett_no,h.sett_type,h.Party_Code,c1.short_name,h.Scrip_Cd,h.sell_buy 
end
end
if @statusid = 'trader' 
begin
if ( select Count(sett_no) from isettlement where sett_no =@settno and sett_type =@settype ) > 0 
 begin
 select h.BillNo,h.Party_Code,c1.short_name,h.Scrip_Cd ,h.Tradeqty,h.Sauda_date,h.Sell_buy ,
 h.Brokapplied,h.sett_no,h.NBrokApp , h. NetRate,h.sett_type, c1.L_Address1,c1.L_Address2,c1.L_Address3 ,
 c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,h.NSerTax,st.start_date,st.end_date,service_chrg
 from iSettlement h,client1 c1,client2 c2,sett_mst st 
 where h.sett_no = st.sett_no and h.sett_type = st.sett_type and c1.cl_code=c2.cl_code and
 c2.party_code=h.party_code and h.party_code like ltrim(@partycode)+'%' and c1.short_name like  ltrim(@partyname)+'%' and
 h.sett_no like  ltrim(@settno)+'%' and h.sett_type like  ltrim(@settype)+'%' and h.BillNo like  ltrim(@billno)+'%' 
 and h.partipantcode like ltrim(@pcode)+'%'
 order by h.sett_no,h.sett_type,h.Party_Code,c1.short_name,h.Scrip_Cd,h.sell_buy 
 end
else
 begin
 select h.BillNo,h.Party_Code,c1.short_name,h.Scrip_Cd ,h.Tradeqty,h.Sauda_date,h.Sell_buy ,
 h.Brokapplied,h.sett_no,h.NBrokApp , h. NetRate,h.sett_type, c1.L_Address1,c1.L_Address2,c1.L_Address3 ,
 c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,h.NSerTax,st.start_date,st.end_date,service_chrg
 from ihistory h,client1 c1,client2 c2,sett_mst st 
 where h.sett_no = st.sett_no and h.sett_type = st.sett_type and c1.cl_code=c2.cl_code and
 c2.party_code=h.party_code and h.party_code like ltrim(@partycode)+'%' and c1.short_name like  ltrim(@partyname)+'%' and
 h.sett_no like  ltrim(@settno)+'%' and h.sett_type like  ltrim(@settype)+'%' and h.BillNo like  ltrim(@billno)+'%' 
 and h.partipantcode like ltrim(@pcode)+'%'
 order by h.sett_no,h.sett_type,h.Party_Code,c1.short_name,h.Scrip_Cd,h.sell_buy 
end
end 
if @statusid = 'subbroker' 
begin
if ( select Count(sett_no) from isettlement where sett_no =@settno and sett_type =@settype ) > 0 
 begin
 select h.BillNo,h.Party_Code,c1.short_name,h.Scrip_Cd ,h.Tradeqty,h.Sauda_date,h.Sell_buy ,
 h.Brokapplied,h.sett_no,h.NBrokApp , h. NetRate,h.sett_type, c1.L_Address1,c1.L_Address2,c1.L_Address3 ,
 c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,h.NSerTax,st.start_date,st.end_date,service_chrg
 from iSettlement h,client1 c1,client2 c2,sett_mst st , subbrokers sb
 where h.sett_no = st.sett_no and h.sett_type = st.sett_type and c1.cl_code=c2.cl_code and
 c2.party_code=h.party_code and h.party_code like ltrim(@partycode)+'%' and c1.short_name like  ltrim(@partyname)+'%' and
 h.sett_no like  ltrim(@settno)+'%' and h.sett_type like  ltrim(@settype)+'%' and h.BillNo like  ltrim(@billno)+'%' 
 and sb.sub_broker=@statusname and sb.sub_broker=c1.sub_broker 
 and h.partipantcode like ltrim(@pcode)+'%'
 order by h.sett_no,h.sett_type,h.Party_Code,c1.short_name,h.Scrip_Cd,h.sell_buy 
 end
else
 begin
 select h.BillNo,h.Party_Code,c1.short_name,h.Scrip_Cd ,h.Tradeqty,h.Sauda_date,h.Sell_buy ,
 h.Brokapplied,h.sett_no,h.NBrokApp , h. NetRate,h.sett_type, c1.L_Address1,c1.L_Address2,c1.L_Address3 ,
 c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,h.NSerTax,st.start_date,st.end_date,service_chrg
 from ihistory h,client1 c1,client2 c2,sett_mst st  , subbrokers sb
 where h.sett_no = st.sett_no and h.sett_type = st.sett_type and c1.cl_code=c2.cl_code and
 c2.party_code=h.party_code and h.party_code like ltrim(@partycode)+'%' and c1.short_name like  ltrim(@partyname)+'%' and
 h.sett_no like  ltrim(@settno)+'%' and h.sett_type like  ltrim(@settype)+'%' and h.BillNo like  ltrim(@billno)+'%' 
 and sb.sub_broker=@statusname and sb.sub_broker=c1.sub_broker
 and h.partipantcode like ltrim(@pcode)+'%'
 order by h.sett_no,h.sett_type,h.Party_Code,c1.short_name,h.Scrip_Cd,h.sell_buy 
end
end 

if @statusid = 'client'
begin
if ( select Count(sett_no) from isettlement where sett_no =@settno and sett_type =@settype ) > 0 
 begin
 select h.BillNo,h.Party_Code,c1.short_name,h.Scrip_Cd ,h.Tradeqty,h.Sauda_date,h.Sell_buy ,
 h.Brokapplied,h.sett_no,h.NBrokApp , h. NetRate,h.sett_type, c1.L_Address1,c1.L_Address2,c1.L_Address3 ,
 c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,h.NSerTax,st.start_date,st.end_date,service_chrg
 from iSettlement h,client1 c1,client2 c2,sett_mst st 
 where h.sett_no = st.sett_no and h.sett_type = st.sett_type and c1.cl_code=c2.cl_code and
 c2.party_code=h.party_code and h.party_code =@statusname and
 h.sett_no like  ltrim(@settno)+'%' and h.sett_type like  ltrim(@settype)+'%' and h.BillNo like  ltrim(@billno)+'%' 
 and h.partipantcode like ltrim(@pcode)+'%'
end 
else
begin
 select h.BillNo,h.Party_Code,c1.short_name,h.Scrip_Cd ,h.Tradeqty,h.Sauda_date,h.Sell_buy ,
 h.Brokapplied,h.sett_no,h.NBrokApp , h. NetRate,h.sett_type, c1.L_Address1,c1.L_Address2,c1.L_Address3 ,
 c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,h.NSerTax,st.start_date,st.end_date,service_chrg
 from ihistory h,client1 c1,client2 c2,sett_mst st 
 where h.sett_no = st.sett_no and h.sett_type = st.sett_type and c1.cl_code=c2.cl_code and
 c2.party_code=h.party_code and h.party_code =@statusname and
 h.sett_no like  ltrim(@settno)+'%' and h.sett_type like  ltrim(@settype)+'%' and h.BillNo like  ltrim(@billno)+'%' 
 and h.partipantcode like ltrim(@pcode)+'%'
 order by h.sett_no,h.sett_type,h.Party_Code,c1.short_name,h.Scrip_Cd,h.sell_buy 
end
end

GO
