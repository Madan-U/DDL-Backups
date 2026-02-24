-- Object: PROCEDURE dbo.brtopcl
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brtopcl    Script Date: 3/17/01 9:55:47 PM ******/

/****** Object:  Stored Procedure dbo.brtopcl    Script Date: 3/21/01 12:50:03 PM ******/

/****** Object:  Stored Procedure dbo.brtopcl    Script Date: 20-Mar-01 11:38:46 PM ******/

/****** Object:  Stored Procedure dbo.brtopcl    Script Date: 2/5/01 12:06:09 PM ******/

/****** Object:  Stored Procedure dbo.brtopcl    Script Date: 12/27/00 8:58:46 PM ******/

/* report : mgt info
   file topclients.asp
displays list of top clients who have done trading above 500000
*/
CREATE PROCEDURE brtopcl
@br varchar(3)
AS
select c1.short_name,t.party_code,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy 
from trade4432 t,client1 c1,client2 c2,branches b 
where t.party_code = c2.party_code 
and c1.cl_code = c2.cl_code 
and b.short_name = c1.trader
and b.branch_cd = @br
group by c1.short_name,t.party_code,t.sell_Buy
having sum(t.tradeqty * t.marketrate) >500000

GO
