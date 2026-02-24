-- Object: PROCEDURE dbo.ActiveClt
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

Create Proc ActiveClt as
Select Party_Code, Long_Name From Client2 C2, Client1 C1
Where C1.Cl_Code = C2.Cl_Code
And Party_Code In (Select Party_Code From AccBill
Where Start_Date >= 'Aug  1 2006')
And Party_Code Not In (Select Party_Code From AccBill
Where Start_Date < 'Aug  1 2006')

GO
