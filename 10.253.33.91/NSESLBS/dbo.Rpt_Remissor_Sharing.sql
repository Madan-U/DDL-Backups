-- Object: PROCEDURE dbo.Rpt_Remissor_Sharing
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Rpt_Remissor_Sharing    
(@StatusId Varchar(15), @Statusname Varchar(25),    
 @Sett_No Varchar(7), @Sett_Type Varchar(2), @Flag Varchar(1))     
As    
    
Declare @Service_Tax Numeric(18,4)    
    
Select @Service_Tax = Service_Tax From Globals, Rem_Sett_Mst    
Where Sett_No = @Sett_No And Sett_Type = @Sett_Type    
And End_Date BetWeen Year_Start_Dt And Year_End_Dt    
    
If @Flag = 'R'    
Begin    
 Select Sett_No, Sett_Type, RemPartyCd, RemCode, RemName = Left(Name,20), Branch_Cd,    
 SlabType, NSECMBrok, BSECMBrok, NSEFOBrok, TotalBrok = Cl_Brokerage,  
 Rem_NSECMBrok, Rem_BSECMBrok, Rem_NSEFOBrok,      
 BrokAmt = REM_PayBrokerage, Service_Tax = REM_PayBrokerage*@Service_Tax/100    
 From Rem_brok_Trans, SubBrokers    
 Where Sett_no = @Sett_No And Sett_Type = @Sett_Type    
 And RemCode <> '' And RemCode = Sub_Broker And Branch_Cd = Branch_Code    
 And @Statusname = (Case When @StatusId = 'BROKER' Then 'BROKER'     
          When @StatusId = 'BRANCH' Then  Branch_Cd    
          When @StatusId = 'subbroker' Then  RemCode    
       Else ''    
           End)    
 Order By Branch_Cd, RemCode    
End    
Else    
Begin    
 Select R1.Sett_No, R1.Sett_Type, RemPartyCd, RemCode=R1.Branch_Cd, RemName = Left(Branch,20), R1.Branch_Cd,     
 SlabType, NSECMBrok, BSECMBrok, NSEFOBrok, TotalBrok = Cl_Brokerage,     
 RemBrok = IsNull(RemBrok, 0), Share_Per, BrokAmt = REM_PayBrokerage,     
 Service_Tax = REM_PayBrokerage*@Service_Tax/100,    
 NsecmPost = NSECMBrok * REM_PayBrokerage / Cl_Brokerage,    
 BsecmPost = BSECMBrok * REM_PayBrokerage / Cl_Brokerage,    
 NsefoPost = NSEFOBrok * REM_PayBrokerage / Cl_Brokerage    
 From Branch, Rem_brok_Trans R1 Left Outer Join     
 (Select Sett_No, Sett_Type, Branch_Cd, RemBrok = Sum(REM_PayBrokerage)    
 From Rem_brok_Trans R2    
 Where Sett_no = @Sett_No And Sett_Type = @Sett_Type    
 And RemCode <> ''     
 Group By Sett_No, Sett_Type, Branch_Cd ) R2    
 On ( R1.Sett_No = R2.Sett_No And R1.Sett_Type = R2.Sett_Type    
      And R1.Branch_Cd = R2.Branch_Cd)    
 Where R1.Sett_no = @Sett_No And R1.Sett_Type = @Sett_Type    
 And RemCode = '' And R1.Branch_Cd = Branch_Code    
 And @Statusname = (Case When @StatusId = 'BROKER' Then 'BROKER'     
          When @StatusId = 'BRANCH' Then  R1.Branch_Cd    
       Else ''    
           End)    
 Order By R1.Sett_No, R1.Sett_Type, R1.Branch_Cd    
End

GO
