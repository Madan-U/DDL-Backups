-- Object: PROCEDURE dbo.OrderTime_Update
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE  Proc OrderTime_Update (@Sauda_Date Varchar(11))
As

Begin Tran
Truncate Table Trade_Order_Bulk
Insert into Trade_Order_Bulk
Select * From Trade_Order Where Order_Entry_Date Like @Sauda_Date + '%'

Update Settlement Set CpId = convert(varchar,Order_Entry_Date,108) from Trade_Order_Bulk O
Where Settlement.Sauda_Date Like Left(convert(varchar,Order_Entry_Date,109),11) + '%' 
And Sauda_Date Like @Sauda_Date + '%'
And Settlement.Order_No = O.Order_No
And Settlement.CpId <> convert(varchar,Order_Entry_Date,108)

Update ISettlement Set CpId = convert(varchar,Order_Entry_Date,108) from Trade_Order_Bulk O
Where ISettlement.Sauda_Date Like Left(convert(varchar,Order_Entry_Date,109),11) + '%' 
And Sauda_Date Like @Sauda_Date + '%'
And ISettlement.Order_No = O.Order_No
And ISettlement.CpId <> convert(varchar,Order_Entry_Date,108)
Commit

GO
