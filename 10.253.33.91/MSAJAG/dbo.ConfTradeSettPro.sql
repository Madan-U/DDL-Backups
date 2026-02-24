-- Object: PROCEDURE dbo.ConfTradeSettPro
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ConfTradeSettPro    Script Date: 3/17/01 9:55:49 PM ******/

/****** Object:  Stored Procedure dbo.ConfTradeSettPro    Script Date: 3/21/01 12:50:05 PM ******/

/****** Object:  Stored Procedure dbo.ConfTradeSettPro    Script Date: 20-Mar-01 11:38:48 PM ******/

/****** Object:  Stored Procedure dbo.ConfTradeSettPro    Script Date: 2/5/01 12:06:11 PM ******/

/****** Object:  Stored Procedure dbo.ConfTradeSettPro    Script Date: 12/27/00 8:58:48 PM ******/

/****** Object:  Stored Procedure dbo.ConfTradeSettPro    Script Date: 12/18/99 8:24:12 AM ******/
CREATE PROCEDURE ConfTradeSettPro (@party varchar(30),@scrip varchar(12)) AS
select t1.party_code,t1.scrip_cd,t1.series,sum(t1.qty),sum(t1.amt),t1.sell_buy,c1.short_name
from confsetttradeview t1, client1 c1, client2 c2
where t1.party_code = c2.party_code 
and c1.cl_code = c2.cl_code
and c1.short_name like @party+'%' 
and t1.scrip_cd like @scrip+'%'
group by t1.party_code,c1.short_name,t1.scrip_cd,t1.series,t1.sell_buy

GO
