-- Object: PROCEDURE dbo.BSEGenBillNo
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE Procedure BSEGenBillNo (@Sett_No Varchar(7), @Sett_Type Varchar(3)) As   

Truncate Table Trd_BillNo

Insert Into Trd_BillNo (Sett_No, Sett_Type, Party_Code) 
Select Sett_No, Sett_Type, Party_Code From Settlement  
Where Sett_No = @Sett_No And Sett_Type = @Sett_Type    
Group By Sett_No, Sett_Type, Party_Code   
Order By Sett_No, Sett_Type, Party_Code

Update Settlement Set Billno = Trd_BillNo.BillNo 
From Trd_BillNo
Where Settlement.Sett_No = @Sett_No And Settlement.Sett_Type = @Sett_Type
And Settlement.Sett_No = Trd_BillNo.Sett_No And Settlement.Sett_Type = Trd_BillNo.Sett_Type 
And Settlement.Party_Code = Trd_BillNo.Party_Code

GO
