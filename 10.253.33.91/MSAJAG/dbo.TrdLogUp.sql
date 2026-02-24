-- Object: PROCEDURE dbo.TrdLogUp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.TrdLogUp    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.TrdLogUp    Script Date: 3/21/01 12:50:33 PM ******/

/****** Object:  Stored Procedure dbo.TrdLogUp    Script Date: 20-Mar-01 11:39:11 PM ******/

/****** Object:  Stored Procedure dbo.TrdLogUp    Script Date: 2/5/01 12:06:30 PM ******/

/****** Object:  Stored Procedure dbo.TrdLogUp    Script Date: 12/27/00 8:59:17 PM ******/

CREATE Procedure TrdLogUp as
insert into TrdLog
select t.User_Id,Sauda_Date=left(convert(varchar,t.sauda_date,109),11), Time = convert(char,getdate(),108),
       PQty = ( select isnull(sum(tradeqty),0) from trade where sell_buy = 1 and user_id = t.user_id ),
       SQty = ( select isnull(sum(tradeqty),0) from trade where sell_buy = 2 and user_id = t.user_id ),
       PRate = ( select isnull(sum(tradeqty*marketrate),0) from trade where sell_buy = 1 and user_id = t.user_id ),
       SRate = ( select isnull(sum(tradeqty*marketrate),0) from trade where sell_buy = 2 and user_id = t.user_id ),0,''     
from trade t 
group by user_id,left(convert(varchar,t.sauda_date,109),11)

GO
