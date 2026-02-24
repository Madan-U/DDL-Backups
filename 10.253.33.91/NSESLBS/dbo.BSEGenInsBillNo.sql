-- Object: PROCEDURE dbo.BSEGenInsBillNo
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE Procedure BSEGenInsBillNo (@Sett_No Varchar(7), @Sett_Type Varchar(3)) As   

Truncate Table Trd_BillNo

Insert Into Trd_BillNo (Sett_No, Sett_Type, Party_Code) 
Select Sett_No, Sett_Type, Party_Code From ISettlement  
Where Sett_No = @Sett_No And Sett_Type = @Sett_Type    
Group By Sett_No, Sett_Type, Party_Code   
Order By Sett_No, Sett_Type, Party_Code

Update ISettlement Set Billno = Trd_BillNo.BillNo 
From Trd_BillNo
Where ISettlement.Sett_No = @Sett_No And ISettlement.Sett_Type = @Sett_Type
And ISettlement.Sett_No = Trd_BillNo.Sett_No And ISettlement.Sett_Type = Trd_BillNo.Sett_Type 
And ISettlement.Party_Code = Trd_BillNo.Party_Code

GO
