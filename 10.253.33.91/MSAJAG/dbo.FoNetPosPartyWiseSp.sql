-- Object: PROCEDURE dbo.FoNetPosPartyWiseSp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


Create Proc FoNetPosPartyWiseSp 
@sdate varchar(12),
@party varchar(10)
as
select s.party_code,s.inst_type,s.symbol,s.Strike_price,s.Option_type,s.sec_name,s.expirydate,
OpenPos = sum(pqty) - sum(sqty),
netamt = sum(pqty * netrate) - sum(sqty * netrate),
rate = (case when s.inst_type like 'FUT%' then abs(sum(pqty * netrate) - sum(sqty * netrate))/abs(sum(pqty) - sum(sqty))
        else
	( select isnull(foclosing.cl_rate,0) from foclosing
        where left(convert(varchar,foclosing.trade_date,109),11)  like @sdate + '%'
        and foclosing.Inst_Type = s.inst_type and foclosing.symbol=s.symbol 
	and foclosing.strike_price = s.strike_price and foclosing.option_type = s.option_type
        and left(convert(varchar,foclosing.expirydate,109),11) = left(convert(varchar,s.expirydate,109),11))
	end)
from FoNetPosView s, foscrip2 s2 where  s.Sauda_date <= @sdate + ' 23:59:59' and party_code like '%'
and s2.inst_type = s.inst_type and s2.symbol = s.symbol and s.strike_price = s2.strike_price
and s.option_type = s2.option_type and
left(convert(varchar,s.expirydate,109),11) = left(convert(varchar,s2.expirydate,109),11)
and s2.maturitydate >= @sdate + ' 23:59:00'
group by s.party_code,s.inst_type,s.symbol,s.Strike_price,s.Option_type,s.sec_name,s.expirydate
having sum(pqty) - sum(sqty) > 0

GO
