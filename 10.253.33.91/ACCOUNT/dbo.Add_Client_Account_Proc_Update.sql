-- Object: PROCEDURE dbo.Add_Client_Account_Proc_Update
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE   Proc [dbo].[Add_Client_Account_Proc_Update] (    

@Exchange Varchar(3),     

@Segment Varchar(7),     

@Branch_Cd Varchar(10),     

@FromParty Varchar(10),    

@ToParty Varchar(10),    

@MainDate Varchar(30),    

@DetDate Varchar(30)    

) As    

    



Delete From AcMast    

Where CltCode In ( Select Party_Code     

                   From MSAJAG.DBO.Client_Details_Tmp C, MSAJAG.DBO.Client_Brok_Details_Tmp D    

                   Where D.Exchange = @Exchange And D.Segment = @Segment      

     And C.Cl_Code = D.Cl_Code)    

    

Insert into AcMast    

Select ACName = Long_Name, LongName = Long_Name, 

ACTyp = (Case When Cl_Type ='SBD' Then 'LIABILITIE' Else 'ASSET' End),     

ACCat = (Case When Cl_Type ='SBD' Then '3' Else '4' End), 

FamilyCd = '', CltCode = Party_Code, AccDtls = '', 

GrpCode = (Case When Cl_Type ='SBD' Then 'L0704000000' Else 'A0307000000' End),     

BookType = '', MicrNo = Micr_No, BranchCode = Branch_Cd, BtoBPayment = Pay_B3B_Payment,     

PayMode = Pay_Payment_Mode, POBankName = Pay_Bank_Name, POBranch = LEFT(Pay_Branch_Name,25), POBankcode = Pay_Ac_No    

From MSAJAG.DBO.Client_Details_Tmp C, MSAJAG.DBO.Client_Brok_Details_Tmp D    

Where D.Exchange = @Exchange And D.Segment = @Segment      

And C.Cl_Code = D.Cl_Code 

 

Insert into MultiBankId

SELECT Party_code,max(P.BankID)as BankID,CltDpId=AC_Num,      

Depository=IsNull((Case When Ac_Type = 'S' Then 'SAVING'       

                        When Ac_Type = 'C' Then 'CURRENT'       

                        Else 'OTHER' End), 'OTHER'),

Long_Name, DEF=1

From MSAJAG.DBO.Client_Details_Tmp C, MSAJAG.DBO.Client_Brok_Details_Tmp D, MSAJAG.DBO.POBank P      

Where D.Exchange = @Exchange And D.Segment = @Segment        

And C.Cl_Code = D.Cl_Code      

And Ac_Type <> ''      

And C.Party_Code Not In (Select CltCode From MultiBankId )

And P.Bank_Name = C.Bank_Name And P.Branch_Name = C.Branch_Name 

GROUP BY Party_code,AC_NUM,AC_TYPE,Long_Name--added by suresh to add singel record



exec MSAJAG.DBO.MULTIBANKINSERT_CI

GO
