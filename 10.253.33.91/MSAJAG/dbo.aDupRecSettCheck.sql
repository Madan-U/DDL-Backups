-- Object: PROCEDURE dbo.aDupRecSettCheck
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE procedure aDupRecSettCheck
@statusid varchar(12),
@statusname varchar(12)
as

delete from atrade where trade_no in 
(select S.trade_no from Settlement S
where convert(varchar,atrade.sauda_date,106) = convert(varchar,s.sauda_date,106)
and ( atrade.trade_no = s.trade_no or atrade.trade_no like '%' + s.trade_no or s.trade_no like '%' + atrade.trade_no )
and atrade.order_no = ( Case when Order_no Like 'P%' then Right(s.order_no,15) else S.Order_no end )
and atrade.scrip_cd = s.scrip_cd
and atrade.series = s.series
and atrade.marketrate = s.marketrate
and atrade.sell_buy = s.sell_buy
and atrade.markettype = s.markettype )

delete from atrade where trade_no in 
(select S.trade_no from ISettlement S
where convert(varchar,atrade.sauda_date,106) = convert(varchar,s.sauda_date,106)
and ( atrade.trade_no = s.trade_no or atrade.trade_no like '%' + s.trade_no or s.trade_no like 'A' + atrade.trade_no )
and atrade.order_no = ( Case when Order_no Like 'P%' then Right(s.order_no,15) else S.Order_no end )
and atrade.scrip_cd = s.scrip_cd
and atrade.series = s.series
and atrade.marketrate = s.marketrate
and atrade.sell_buy = s.sell_buy
and atrade.markettype = s.markettype
)


/* delete from atrade where trade_no in 
(select S.trade_no from History S
where convert(varchar,atrade.sauda_date,106) = convert(varchar,s.sauda_date,106)
and ( atrade.trade_no = s.trade_no or atrade.trade_no like '%' + s.trade_no or s.trade_no like '%' + atrade.trade_no )
and atrade.order_no = ( Case when Order_no Like 'P%' then Right(s.order_no,15) else S.Order_no end )
and atrade.scrip_cd = s.scrip_cd
and atrade.series = s.series
and atrade.marketrate = s.marketrate
and atrade.sell_buy = s.sell_buy
and atrade.markettype = s.markettype 
)

delete from atrade where trade_no in 
(select S.trade_no from IHistory S
where convert(varchar,atrade.sauda_date,106) = convert(varchar,s.sauda_date,106)
and ( atrade.trade_no = s.trade_no or atrade.trade_no like '%' + s.trade_no or s.trade_no like '%' + atrade.trade_no )
and atrade.order_no = ( Case when Order_no Like 'P%' then Right(s.order_no,15) else S.Order_no end )
and atrade.scrip_cd = s.scrip_cd
and atrade.series = s.series
and atrade.marketrate = s.marketrate
and atrade.sell_buy = s.sell_buy
and atrade.markettype = s.markettype )

*/

GO
