-- Object: PROCEDURE dbo.rpt_inewalbmbill
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_inewalbmbill    Script Date: 04/27/2001 4:32:43 PM ******/





/****** Object:  Stored Procedure dbo.rpt_inewalbmbill    Script Date: 2/5/01 12:06:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_inewalbmbill    Script Date: 12/27/00 8:59:12 PM ******/

/* institutional trading */
/* report : bills report
   file : billreport.asp */
/*displays albmbill for a particular  settlement  type and number for a client or clients for institution*/
/* added service_chrg field by mousami on 21/04/2001*/
CREATE PROCEDURE rpt_inewalbmbill
@statusid varchar(15),
@statusname varchar(25),
@nextlsettno varchar(7),
@prevlsettno varchar(7),
@partycode varchar(10),
@name varchar(21),
@billno varchar(5),
@pcode varchar(15)
AS
if @statusid = 'broker' 
begin
select distinct h.sett_no,h.party_code,h.scrip_cd,h.sell_buy,h.tradeqty,h.netrate,h.sauda_date, 
h.Brokapplied,h.NBrokApp,h.NSerTax,h.sett_type ,c1.short_name, c1.L_Address1,
c1.L_Address2,c1.L_Address3 ,c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,
st.start_date,st.end_date , h.billno, c2.service_chrg
from isettlement h, client1 c1, client2 c2 , sett_mst st
where ((h.sett_no=@prevlsettno and h.sett_type='L')or (h.sett_no=@nextlsettno and h.sett_type='L')) 
and h.party_code like ltrim(@partycode)+'%' and c1.short_name like ltrim(@name)+ '%' 
and c2.party_code=h.party_code and c1.cl_code=c2.cl_code and 
h.BillNo like  ltrim(@billno)+'%' and st.sett_no=h.sett_no and
st.sett_type=h.sett_type
and h.partipantcode like ltrim(@pcode)+ '%'
union all
select distinct h.sett_no,h.party_code,h.scrip_cd,h.sell_buy,h.tradeqty,h.netrate,h.sauda_date, 
h.Brokapplied,h.NBrokApp,h.NSerTax,h.sett_type ,c1.short_name, c1.L_Address1,
c1.L_Address2,c1.L_Address3 ,c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,
st.start_date,st.end_date ,  h.billno , c2.service_chrg
from ihistory h, client1 c1, client2 c2  , sett_mst st
where ((h.sett_no=@prevlsettno and h.sett_type='L')or (h.sett_no=@nextlsettno and h.sett_type='L')) 
and h.party_code like  ltrim(@partycode)+'%' 
and c1.short_name like  ltrim(@name)+'%'and c2.party_code=h.party_code and c1.cl_code=c2.cl_code 
and h.BillNo like  ltrim(@billno)+'%' and st.sett_no=h.sett_no and
st.sett_type=h.sett_type
and h.partipantcode like ltrim(@pcode)+ '%'
order by h.scrip_cd, h.sell_buy
end
if @statusid='branch'
begin
select distinct h.sett_no,h.party_code,h.scrip_cd,h.sell_buy,h.tradeqty,h.netrate,h.sauda_date, 
h.Brokapplied,h.NBrokApp,h.NSerTax,h.sett_type ,c1.short_name, c1.L_Address1,
c1.L_Address2,c1.L_Address3 ,c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,
st.start_date,st.end_date , h.billno, c2.service_chrg
from isettlement h, client1 c1, client2 c2 , sett_mst st , branches b
where ((h.sett_no=@prevlsettno and h.sett_type='L')or (h.sett_no=@nextlsettno and h.sett_type='L')) 
and h.party_code like ltrim(@partycode)+'%' and c1.short_name like ltrim(@name)+ '%' 
and c2.party_code=h.party_code and c1.cl_code=c2.cl_code and h.BillNo like  ltrim(@billno)+'%'
and st.sett_no=h.sett_no and
st.sett_type=h.sett_type and b.branch_cd=@statusname and b.short_name=c1.trader
and h.partipantcode=@pcode
union all
select distinct h.sett_no,h.party_code,h.scrip_cd,h.sell_buy,h.tradeqty,h.netrate,h.sauda_date, 
h.Brokapplied,h.NBrokApp,h.NSerTax,h.sett_type ,c1.short_name, c1.L_Address1,
c1.L_Address2,c1.L_Address3 ,c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,
st.start_date,st.end_date ,  h.billno , c2.service_chrg
from ihistory h, client1 c1, client2 c2  , sett_mst st , branches b
where ((h.sett_no=@prevlsettno and h.sett_type='L')or (h.sett_no=@nextlsettno and h.sett_type='L')) 
and h.party_code like  ltrim(@partycode)+'%' 
and c1.short_name like  ltrim(@name)+'%' and c2.party_code=h.party_code and c1.cl_code=c2.cl_code 
and h.BillNo like  ltrim(@billno)+'%' and st.sett_no=h.sett_no and
st.sett_type=h.sett_type and b.branch_cd=@statusname and b.short_name=c1.trader
order by h.scrip_cd, h.sell_buy
end
if @statusid = 'trader' 
begin
select distinct h.sett_no,h.party_code,h.scrip_cd,h.sell_buy,h.tradeqty,h.netrate,h.sauda_date, 
h.Brokapplied,h.NBrokApp,h.NSerTax,h.sett_type ,c1.short_name, c1.L_Address1,
c1.L_Address2,c1.L_Address3 ,c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,
st.start_date,st.end_date , h.billno, c2.service_chrg
from isettlement h, client1 c1, client2 c2 , sett_mst st
where ((h.sett_no=@prevlsettno and h.sett_type='L')or (h.sett_no=@nextlsettno and h.sett_type='L')) 
and h.party_code like ltrim(@partycode)+'%' and c1.short_name like ltrim(@name)+ '%' 
and c2.party_code=h.party_code and c1.cl_code=c2.cl_code and 
h.BillNo like  ltrim(@billno)+'%' and st.sett_no=h.sett_no and
st.sett_type=h.sett_type and c1.trader=@statusname
and h.partipantcode=@pcode
union all
select distinct h.sett_no,h.party_code,h.scrip_cd,h.sell_buy,h.tradeqty,h.netrate,h.sauda_date, 
h.Brokapplied,h.NBrokApp,h.NSerTax,h.sett_type ,c1.short_name, c1.L_Address1,
c1.L_Address2,c1.L_Address3 ,c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,
st.start_date,st.end_date ,  h.billno , c2.service_chrg
from ihistory h, client1 c1, client2 c2  , sett_mst st 
where ((h.sett_no=@prevlsettno and h.sett_type='L')or (h.sett_no=@nextlsettno and h.sett_type='L')) 
and h.party_code like  ltrim(@partycode)+'%' 
and c1.short_name like  ltrim(@name)+'%'and c2.party_code=h.party_code and c1.cl_code=c2.cl_code 
and h.BillNo like  ltrim(@billno)+'%' and st.sett_no=h.sett_no and
st.sett_type=h.sett_type  and c1.trader=@statusname
order by h.scrip_cd, h.sell_buy
end 
if @statusid = 'subbroker' 
begin
select distinct h.sett_no,h.party_code,h.scrip_cd,h.sell_buy,h.tradeqty,h.netrate,h.sauda_date, 
h.Brokapplied,h.NBrokApp,h.NSerTax,h.sett_type ,c1.short_name, c1.L_Address1,
c1.L_Address2,c1.L_Address3 ,c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,
st.start_date,st.end_date , h.billno, c2.service_chrg
from isettlement h, client1 c1, client2 c2 , sett_mst st, subbrokers sb
where ((h.sett_no=@prevlsettno and h.sett_type='L')or (h.sett_no=@nextlsettno and h.sett_type='L')) 
and h.party_code like ltrim(@partycode)+'%' and c1.short_name like ltrim(@name)+ '%' 
and c2.party_code=h.party_code and c1.cl_code=c2.cl_code and h.BillNo like  ltrim(@billno)+'%' and st.sett_no=h.sett_no 
and sb.sub_broker=@statusname and sb.sub_broker=c1.sub_broker and
st.sett_type=h.sett_type
and h.partipantcode=@pcode
union all
select distinct h.sett_no,h.party_code,h.scrip_cd,h.sell_buy,h.tradeqty,h.netrate,h.sauda_date, 
h.Brokapplied,h.NBrokApp,h.NSerTax,h.sett_type ,c1.short_name, c1.L_Address1,
c1.L_Address2,c1.L_Address3 ,c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,
st.start_date,st.end_date ,  h.billno , c2.service_chrg
from ihistory h, client1 c1, client2 c2  , sett_mst st , subbrokers sb
where ((h.sett_no=@prevlsettno and h.sett_type='L')or (h.sett_no=@nextlsettno and h.sett_type='L')) 
and h.party_code like  ltrim(@partycode)+'%' 
and c1.short_name like  ltrim(@name)+'%'and c2.party_code=h.party_code and c1.cl_code=c2.cl_code 
and h.BillNo like  ltrim(@billno)+'%' and st.sett_no=h.sett_no and
st.sett_type=h.sett_type and  sb.sub_broker=@statusname and sb.sub_broker=c1.sub_broker
order by h.scrip_cd, h.sell_buy
end 
if @statusid = 'client'
begin
select distinct h.sett_no,h.party_code,h.scrip_cd,h.sell_buy,h.tradeqty,h.netrate,h.sauda_date, 
h.Brokapplied,h.NBrokApp,h.NSerTax,h.sett_type ,c1.short_name, c1.L_Address1,
c1.L_Address2,c1.L_Address3 ,c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,
st.start_date,st.end_date , h.billno, c2.service_chrg
from isettlement h, client1 c1, client2 c2 , sett_mst st 
where ((h.sett_no=@prevlsettno and h.sett_type='L')or (h.sett_no=@nextlsettno and h.sett_type='L')) 
and h.party_code =@statusname
and c2.party_code=h.party_code and c1.cl_code=c2.cl_code and h.BillNo like  ltrim(@billno)+'%' and st.sett_no=h.sett_no and
st.sett_type=h.sett_type 
and h.partipantcode=@pcode
union all
select distinct h.sett_no,h.party_code,h.scrip_cd,h.sell_buy,h.tradeqty,h.netrate,h.sauda_date, 
h.Brokapplied,h.NBrokApp,h.NSerTax,h.sett_type ,c1.short_name, c1.L_Address1,
c1.L_Address2,c1.L_Address3 ,c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,
st.start_date,st.end_date ,  h.billno , c2.service_chrg
from ihistory h, client1 c1, client2 c2  , sett_mst st 
where ((h.sett_no=@prevlsettno and h.sett_type='L')or (h.sett_no=@nextlsettno and h.sett_type='L')) 
and h.party_code =@statusname
and c2.party_code=h.party_code and c1.cl_code=c2.cl_code 
and h.BillNo like  ltrim(@billno)+'%' and st.sett_no=h.sett_no and
st.sett_type=h.sett_type 
order by h.scrip_cd, h.sell_buy
end

GO
