-- Object: PROCEDURE dbo.brtopscrip
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brtopscrip    Script Date: 3/17/01 9:55:47 PM ******/

/****** Object:  Stored Procedure dbo.brtopscrip    Script Date: 3/21/01 12:50:03 PM ******/

/****** Object:  Stored Procedure dbo.brtopscrip    Script Date: 20-Mar-01 11:38:46 PM ******/

/****** Object:  Stored Procedure dbo.brtopscrip    Script Date: 2/5/01 12:06:09 PM ******/

/****** Object:  Stored Procedure dbo.brtopscrip    Script Date: 12/27/00 8:58:46 PM ******/

/* Report : management info
   File : topclient_scrip
displays top scrips who have been traded above 500000
*/
CREATE PROCEDURE brtopscrip
@br varchar(3)
AS
select t.scrip_cd,t.series,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy 
from trade4432 t, client2 c2, client1 c1, branches b 
where t.party_code=c2.party_code 
and c2.cl_code=c1.cl_code 
and b.short_name = c1.trader
and b.branch_cd = @br
group by t.scrip_cd,t.series ,t.sell_Buy having sum(t.tradeqty * t.marketrate) >500000

GO
