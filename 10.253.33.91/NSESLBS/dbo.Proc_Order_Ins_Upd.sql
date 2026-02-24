-- Object: PROCEDURE dbo.Proc_Order_Ins_Upd
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


Create Proc Proc_Order_Ins_Upd AS 

Delete Trade_Order From Trade_Order_Bulk
Where
        Trade_Order.Order_No = Trade_Order_Bulk.Order_No
        and Trade_Order.Scrip_Cd = Trade_Order_Bulk.Scrip_Cd
        and Trade_Order.Series = Trade_Order_Bulk.Series
        and Trade_Order.Sell_Buy = Trade_Order_Bulk.Sell_Buy 
        and Convert(Varchar,Trade_Order.Order_Entry_Date,103) = Convert(Varchar,Trade_Order_Bulk.Order_Entry_Date,103)

Insert Into Trade_Order Select * From Trade_Order_Bulk

Truncate Table Trade_Order_Bulk

GO
