-- Object: PROCEDURE dbo.rpt_fotopscrip
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fotopscrip    Script Date: 5/11/01 6:19:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotopscrip    Script Date: 5/7/2001 9:02:52 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotopscrip    Script Date: 5/5/2001 2:43:40 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotopscrip    Script Date: 5/5/2001 1:24:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotopscrip    Script Date: 4/30/01 5:50:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotopscrip    Script Date: 10/26/00 6:04:45 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fotopscrip    Script Date: 12/27/00 8:59:11 PM ******/
CREATE PROCEDURE rpt_fotopscrip
@topscrip varchar(15)
AS
select s2.inst_type, s2.symbol, convert(varchar,s2.expirydate,106)'expirydate',s2.series, 
nettamt = sum(t.tradeqty *t.price),sell_Buy 
from fotrade4432 t, client2 c2, client1 c1, foscrip2 s2 
where t.party_code=c2.party_code and c2.cl_code=c1.cl_code  
and t.inst_type = s2.inst_type 
and t.symbol = s2.symbol 
and convert(varchar,t.expirydate,103) = convert(varchar,s2.expirydate,103) 
group by s2.inst_type, s2.symbol, s2.expirydate,s2.series, sell_buy 
having sum(t.tradeqty * t.price) >convert(money,@topscrip)

GO
