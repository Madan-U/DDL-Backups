-- Object: PROCEDURE dbo.Acc_addacmast1
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

Create Procedure Acc_addacmast1 As   
Select Grpname, Grpcode , Grpmain ,   
Maingrpname = (Case   
  When  Left(Grpmain, 2) = 'A0' Then (Select Grpname From Grpmast Where Grpcode = 'A0000000000')   
         Else  
          (Case When  Left(Grpmain, 2) = 'L0' Then (Select Grpname From Grpmast Where Grpcode = 'L0000000000')    
   Else   
    (Case When  Left(Grpmain, 2) = 'N0' Then (Select Grpname From Grpmast Where Grpcode = 'N0000000000')  
    Else   
     (Case When  Left(Grpmain, 2) = 'X0' Then (Select Grpname From Grpmast Where Grpcode = 'X0000000000')  
      End)  
      End)     
    End )   
      End)  
From Grpmast Order By Grpcode

GO
