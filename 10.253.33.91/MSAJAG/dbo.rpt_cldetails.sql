-- Object: PROCEDURE dbo.rpt_cldetails
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_cldetails    Script Date: 04/27/2001 4:32:34 PM ******/

/****** Object:  Stored Procedure dbo.rpt_cldetails    Script Date: 3/21/01 12:50:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_cldetails    Script Date: 20-Mar-01 11:38:54 PM ******/

/****** Object:  Stored Procedure dbo.rpt_cldetails    Script Date: 12/27/00 8:59:17 PM ******/
/* report bill report
   file walbmbill.asp
  finds details of party
*/
 
CREATE PROCEDURE rpt_cldetails
@partycode varchar(10),
@settno varchar(7)
AS
if ( select Count(sett_no) from settlement where sett_no =@settno and sett_type ='p' ) > 0 
begin
select h.BillNo,h.Party_Code,c1.short_name, c1.L_Address1,c1.L_Address2,c1.L_Address3 ,
c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,h.NSerTax,st.start_date,st.end_date,h.sett_type, h.sett_no
from settlement h,client1 c1,client2 c2,sett_mst st 
where h.party_code=@partycode and h.sett_no=@settno 
and st.sett_no=h.sett_no and
st.sett_type=h.sett_type
and c1.cl_code=c2.cl_code
and c2.party_code=h.party_code
end 
else
begin
select h.BillNo,h.Party_Code,c1.short_name, c1.L_Address1,c1.L_Address2,c1.L_Address3 ,
c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,h.NSerTax,st.start_date,st.end_date, h.sett_type,h.sett_no
from history h,client1 c1,client2 c2,sett_mst st 
where h.party_code=@partycode and h.sett_no=@settno 
and st.sett_no=h.sett_no and
st.sett_type=h.sett_type
and c1.cl_code=c2.cl_code
and c2.party_code=h.party_code
end

GO
