-- Object: PROCEDURE dbo.rpt_fonetposition3_new
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fonetposition3_new    Script Date: 5/11/01 6:19:49 PM ******/



CREATE procedure rpt_fonetposition3_new

@inst varchar(6),
@symbol varchar(12),
@expdate varchar(12),
@stprice varchar(10),
@optype varchar(12)


AS

select party_code,inst_type,symbol,sec_name,left(convert(varchar,expirydate,106),11) as expirydate,
pqty = ( case when sell_buy = 1 then sum(tradeqty) else 0 end ),
sqty = ( case when sell_buy = 2 then sum(tradeqty) else 0 end ),
option_type,strike_price
from fosettlement 
where left(convert(varchar,expirydate,106),11) like ltrim(@expdate) + '%'
and inst_type like ltrim(@inst) + '%'
and symbol like ltrim(@symbol) + '%'
and convert(varchar,strike_price) like @stprice + '%'
and option_type like ltrim(@optype) + '%'
group by party_code,inst_type,symbol,sec_name,left(convert(varchar,expirydate,106),11),sell_buy,option_type,strike_price

GO
