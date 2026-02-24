-- Object: PROCEDURE dbo.rpt_posalbm
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_posalbm    Script Date: 04/27/2001 4:32:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_posalbm    Script Date: 3/21/01 12:50:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_posalbm    Script Date: 20-Mar-01 11:39:02 PM ******/

/****** Object:  Stored Procedure dbo.rpt_posalbm    Script Date: 2/5/01 12:06:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_posalbm    Script Date: 12/27/00 8:58:57 PM ******/

CREATE PROCEDURE rpt_posalbm
@nextsettno varchar(7),
@settno varchar(7),
@code varchar(7),
@name varchar(21)
AS
select distinct h.sett_no,h.party_code,h.scrip_cd,h.sell_buy,h.tradeqty,h.netrate,h.sauda_date, 
h.Brokapplied,h.NBrokApp,h.NSerTax,h.sett_type ,c1.short_name, c1.L_Address1,
c1.L_Address2,c1.L_Address3 ,c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,
st.start_date,st.end_date ,h.series
from settlement h, client1 c1, client2 c2 , sett_mst st
where ((h.sett_no=  @settno and h.sett_type='L')or (h.sett_no = @nextsettno and h.sett_type='L')) 
and h.party_code like ltrim(@code)+'%' and c1.short_name like  ltrim(@name)+'%' 
and c2.party_code=h.party_code and c1.cl_code=c2.cl_code 
and st.sett_no=h.sett_no and
st.sett_type=h.sett_type
union all
select distinct h.sett_no,h.party_code,h.scrip_cd,h.sell_buy,h.tradeqty,h.netrate,h.sauda_date, 
h.Brokapplied,h.NBrokApp,h.NSerTax,h.sett_type ,c1.short_name, c1.L_Address1,
c1.L_Address2,c1.L_Address3 ,c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,
st.start_date,st.end_date ,h.series
from history h, client1 c1, client2 c2  , sett_mst st 
where ((h.sett_no=@Settno  and h.sett_type='L')or (h.sett_no= @nextsettno and h.sett_type='L')) 
and h.party_code like ltrim(@code)+'%' 
and c1.short_name like ltrim(@name)+'%'and c2.party_code=h.party_code and c1.cl_code=c2.cl_code 
and st.sett_no=h.sett_no and st.sett_type=h.sett_type
order by h.scrip_cd, h.sell_buy

GO
