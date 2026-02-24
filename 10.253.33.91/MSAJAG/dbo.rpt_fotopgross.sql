-- Object: PROCEDURE dbo.rpt_fotopgross
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fotopgross    Script Date: 5/11/01 6:19:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotopgross    Script Date: 5/7/2001 9:02:52 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotopgross    Script Date: 5/5/2001 2:43:40 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotopgross    Script Date: 5/5/2001 1:24:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotopgross    Script Date: 4/30/01 5:50:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotopgross    Script Date: 10/26/00 6:04:45 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fotopgross    Script Date: 12/27/00 8:59:11 PM ******/
CREATE PROCEDURE rpt_fotopgross
@topgross varchar(15)
AS
/*select inst_type, symbol, convert(varchar,expirydate,106)'expirydate', amount,sell_buy , s.party_code
from fosettlement s, client1 c1, client2 c2
where c1.cl_code = c2.cl_code
and c2.party_code = s.party_code
and amount > convert(money,@topgross) 
group by inst_type, symbol, expirydate, amount,sell_buy ,s.party_code
union
select inst_type, symbol, convert(varchar,expirydate,106)'expirydate', amount,sell_buy , s.party_code
from fotrade4432 s, client1 c1, client2 c2
where c1.cl_code = c2.cl_code
and c2.party_code = s.party_code
and amount > convert(money,@topgross)
group by inst_type, symbol, expirydate, amount,sell_buy ,s.party_code
order by s.party_code, inst_type, symbol, expirydate,sell_buy 
*/






select s.inst_type, s.symbol, CONVERT(varchar,s.expirydate,106)'expirydate', tradeqty ,amount,sell_buy  , s.party_code, sauda_date
from fosettlement s, client1 c1, client2 c2, foscrip2 s2
where c1.cl_code = c2.cl_code
and c2.party_code = s.party_code
and s.inst_type = s2.inst_type
and s.symbol = s2.symbol
and s.expirydate = s2.expirydate
and s2.Maturitydate >= (select left(convert(varchar,getdate(),109),11) )
and amount > convert(money,@topgross) 
group by s.inst_type, s.symbol, s.expirydate, tradeqty ,amount,sell_buy , s.party_code, sauda_date
union all
select s.inst_type, s.symbol, CONVERT(varchar,s.expirydate,106)'expirydate', tradeqty ,amount,sell_buy , s.party_code, sauda_date = " "
from fotrade4432 s, client1 c1, client2 c2, foscrip2 s2
where c1.cl_code = c2.cl_code
and c2.party_code = s.party_code
and s.inst_type = s2.inst_type
and s.symbol = s2.symbol
and s.expirydate = s2.expirydate
and s2.Maturitydate >= (select left(convert(varchar,getdate(),109),11) )
and amount > convert(money,@topgross) 
group by s.inst_type, s.symbol, s.expirydate, tradeqty ,amount,sell_buy , s.party_code 
order by  s.party_code, s.inst_type, s.symbol, s.expirydate,sell_buy

GO
