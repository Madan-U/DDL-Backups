-- Object: PROCEDURE dbo.rpt_normalalbmturn
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_normalalbmturn    Script Date: 04/27/2001 4:32:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_normalalbmturn    Script Date: 3/21/01 12:50:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_normalalbmturn    Script Date: 20-Mar-01 11:39:01 PM ******/

/****** Object:  Stored Procedure dbo.rpt_normalalbmturn    Script Date: 2/5/01 12:06:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_normalalbmturn    Script Date: 12/27/00 8:58:56 PM ******/

/* report : traderwiseturn
   file : traderwiseturn.asp
*/
/* displays user id wise, serieswise,sell_buy wise and settlement number and type wise details for a particular
n type settlement including albm*/
CREATE PROCEDURE rpt_normalalbmturn 
@settno varchar(7),
@currentl varchar(7),
@nextl varchar(7),
@settype varchar(3),
@lsettype varchar(3)
AS
if (select count(*) from settlement where sett_no=@settno and sett_type=@settype) > 0
begin
select Scrip_Cd,User_id, amount=sum(tradeqty*marketrate),Series,Sell_buy, sett_no,sett_type
from settlement
where ((sett_no=@settno and sett_type=@settype) or (sett_no=@currentl and sett_type=@lsettype) or (sett_no=@nextl and sett_type=@lsettype))
and trade_no not like 'p%' 
group by user_id,Scrip_Cd,series,sell_buy,sett_type,sett_no
order by user_id,series,scrip_cd,sell_buy,sett_type
end
else
begin
select Scrip_Cd,User_id, amount= sum(tradeqty*marketrate),Series,Sell_buy, sett_no,sett_type
from history
where ((sett_no=@settno and sett_type=@settype) or (sett_no=@currentl and sett_type=@lsettype) or (sett_no=@nextl and sett_type=@lsettype))
and trade_no not like 'p%'
group by user_id,Scrip_Cd,series,sell_buy,sett_type,sett_no
order by user_id,series,scrip_cd,sell_buy,sett_type
end

GO
