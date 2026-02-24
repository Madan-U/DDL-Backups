-- Object: PROCEDURE dbo.Finaloblmatch
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Finaloblmatch (@sett_no Varchar(7),@sett_type Varchar(2)) As  
Delete From Tempfinalobl   
Insert Into Tempfinalobl   
Select Scrip_cd,series,sell_buy,  
Pqty= (case When Sell_buy = 1 Then   
   Isnull(sum(tradeqty),0) End),  
Sqty = (case When Sell_buy = 2 Then   
   Isnull(sum(tradeqty),0) End),  
Pamt = (case When Sell_buy = 1 Then   
   Isnull(sum(tradeqty*dummy1),0) End),  
Samt = (case When Sell_buy = 2 Then   
   Isnull(sum(tradeqty*dummy1),0) End),  
Sett_no,sett_type  From Settlement  
Where Sett_no = @sett_no And Sett_type = @sett_type   
Group By Sett_no,sett_type,scrip_cd,series,sell_buy

GO
