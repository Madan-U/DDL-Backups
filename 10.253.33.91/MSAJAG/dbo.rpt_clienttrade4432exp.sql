-- Object: PROCEDURE dbo.rpt_clienttrade4432exp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_clienttrade4432exp    Script Date: 04/27/2001 4:32:34 PM ******/

/****** Object:  Stored Procedure dbo.rpt_clienttrade4432exp    Script Date: 3/21/01 12:50:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_clienttrade4432exp    Script Date: 20-Mar-01 11:38:55 PM ******/







/* report : misnews
   file : detailgrossexpo.asp
*/
/* displays all records of a particular client from trade4432 */

CREATE PROCEDURE rpt_clienttrade4432exp

@clcode varchar (6),
@series varchar(3),
@markettype  varchar(2)

AS



if (@series='BE' ) 
begin
select series=(case when s.series in('01','02','03','04','05') then 'BE' else s.series end)
,s.scrip_Cd,s.sell_buy,  s.trade_no , s.tradeqty, amt=(s.tradeqty*s.marketrate), c1.cl_code,c1.short_name,
s.markettype
from trade4432 s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
and c2.cl_code=@clcode
and (s.series=@series or s.series in ('01','02','03','04','05')) 
and s.markettype like ltrim(@markettype)+'%'
order by c1.short_name,c1.cl_code,s.series,s.scrip_cd,s.markettype,s.sell_buy
end
else
begin
select s.series,s.scrip_Cd,s.sell_buy,  s.trade_no , s.tradeqty, amt=(s.tradeqty*s.marketrate), c1.cl_code,c1.short_name,
s.markettype
from trade4432 s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
and c2.cl_code=@clcode
and s.series=@series
and s.markettype like ltrim(@markettype)+'%'
order by c1.short_name,c1.cl_code,s.series,s.scrip_cd,s.markettype,s.sell_buy
end

GO
