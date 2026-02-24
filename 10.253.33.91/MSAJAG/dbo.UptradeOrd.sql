-- Object: PROCEDURE dbo.UptradeOrd
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.UptradeOrd    Script Date: 3/17/01 9:56:13 PM ******/

/****** Object:  Stored Procedure dbo.UptradeOrd    Script Date: 3/21/01 12:50:33 PM ******/

/****** Object:  Stored Procedure dbo.UptradeOrd    Script Date: 20-Mar-01 11:39:11 PM ******/
CREATE PROCEDURE UptradeOrd  AS
Delete trade4432 where sauda_date < Left(Convert(varchar,getdate(),109),11)
Delete orders where ordertime < Left(Convert(varchar,getdate(),109),11)
insert into trade4432 select * from neatup
insert into orders select * from ordersup
Update orders
set effrate = t.marketrate
from msajag.dbo.trade4432 t (nolock),orders o (nolock)
 where
 t.order_no = o.order_no

GO
