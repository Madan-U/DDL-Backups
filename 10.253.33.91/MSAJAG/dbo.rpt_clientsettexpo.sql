-- Object: PROCEDURE dbo.rpt_clientsettexpo
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_clientsettexpo    Script Date: 04/27/2001 4:32:34 PM ******/

/****** Object:  Stored Procedure dbo.rpt_clientsettexpo    Script Date: 3/21/01 12:50:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_clientsettexpo    Script Date: 20-Mar-01 11:38:55 PM ******/










/* report : misnews
   file : detailgrossexp.asp
*/
/* displays gross exposure of a client for current settlement */
CREATE PROCEDURE  rpt_clientsettexpo

@clcode varchar(6),
@settno varchar(7),
@series varchar(3),
@markettype varchar(2)

AS


select  s.sett_type,s.series, s.scrip_cd , s.sell_buy, s.trade_no, s.tradeqty, s.N_NetRate,c1.cl_code,c1.short_name ,
rate=isnull((case s.markettype when '3'  then (select distinct rate from albmrate a 
where a.scrip_cd=s.scrip_Cd and a.sett_type=s.sett_type and s.series=a.series
and a.sett_no=@settno) else (0) end ),0), s.markettype
from settlement s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and c2.cl_code=@clcode
and s.series=@series
and (( s.billno = '0' and (s.sett_type='N' or s.sett_type='W' or s.sett_type='M')) 
or (s.sett_no=@settno and s.sett_type='l')) 
and s.sett_no=@settno
and s.markettype like ltrim(@markettype)+'%'
order by c1.short_name,c1.cl_code,s.series,s.markettype,s.scrip_cd,s.sell_buy

GO
