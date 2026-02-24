-- Object: PROCEDURE dbo.Updatetrade
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE Proc Updatetrade As    
Update Trade_imp Set Cpid = Left(cpid, 3), OrderTime = Left(OrderTime, 20)
Truncate Table Trademissing    
Insert Into Fttrade    
Select Trade_no,order_no,status,scrip_cd,series,scripname,instrument,booktype,markettype,user_id,partipantcode,    
Branch_id,sell_buy,tradeqty,marketrate,pro_cli,party_code,auctionpart,auctionno,settno,sauda_date,trademodified,    
Cpid=OrderTime,1,'n','',marketrate,'0'    
From Trade_imp

GO
