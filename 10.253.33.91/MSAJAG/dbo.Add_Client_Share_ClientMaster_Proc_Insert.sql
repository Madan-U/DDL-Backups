-- Object: PROCEDURE dbo.Add_Client_Share_ClientMaster_Proc_Insert
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE  Proc [dbo].[Add_Client_Share_ClientMaster_Proc_Insert] (      
@Branch_Cd Varchar(10),      
@FromParty Varchar(10),      
@ToParty Varchar(10),      
@MainDate Varchar(30),      
@DetDate Varchar(30)      
) 

As      
      
Insert into ClientMaster      
Select C.Cl_Code, C.Party_Code, C.Short_Name, C.Long_name, C.L_Address1, C.L_Address2, C.L_city, C.L_State,       
C.L_Nation, C.L_Zip, C.Fax, C.Res_Phone1, C.Res_Phone2, C.Off_Phone1, C.Off_Phone2, C.Email, C.Branch_cd,       
Credit_Limit=0, C.Cl_type, C.Cl_status, GL_code='', Fd_code='', C.Family, Penalty=0, Confirm_Fax=0,       
PhoneOld='', C.L_Address3, C.Mobile_Pager, C.pan_gir_no      
From Client_Details C(NOLOCK)--, Client1 C1      
Where C.Imp_Status = '0' And C.Status = 'I'      
And C.Branch_Cd Like @Branch_Cd      
And C.Party_Code Between @FromParty And @ToParty      
And C.ModifidedOn <= @MainDate       
And Cl_Code Not In (Select Cl_Code From ClientMaster)      
    
Update ClientMaster  Set Credit_Limit = D.Credit_Limit     
From CLIENT_DETAILS (NOLOCK), Client_Brok_Details D (NOLOCK)     
Where Client_Details.Cl_Code = D.Cl_Code       
AND ClientMaster.Cl_Code = D.Cl_Code       
And (Client_Details.Imp_Status = '0' Or D.Imp_Status = '0')       
And (Client_Details.Status = 'I' Or D.Status = 'I')      
And Client_Details.Branch_Cd Like @Branch_Cd      
And Client_Details.Party_Code Between @FromParty And @ToParty      
And Client_Details.ModifidedOn <= @MainDate And D.ModifiedOn <= @DetDate      
And Client_Details.Cl_Code In (Select Cl_Code From ClientMaster)      
    
Update Client_Details Set Imp_Status = '1', Status = 'U'      
From Client_Brok_Details D  (NOLOCK)     
Where Client_Details.Cl_Code = D.Cl_Code       
And (Client_Details.Imp_Status = '0' Or D.Imp_Status = '0')       
And (Client_Details.Status = 'I' Or D.Status = 'I') 
AND D.Imp_Status <> '2' AND Client_Details.Imp_Status <> '2'       
And Client_Details.Branch_Cd Like @Branch_Cd      
And Client_Details.Party_Code Between @FromParty And @ToParty      
And Client_Details.ModifidedOn <= @MainDate And D.ModifiedOn <= @DetDate      
And Client_Details.Cl_Code In (Select Cl_Code From ClientMaster)      
      
Update Client_Brok_Details Set Imp_Status = '1', Status = 'U'      
From Client_Details D    (NOLOCK)  
Where D.Cl_Code = Client_Brok_Details.Cl_Code       
And (Client_Brok_Details.Imp_Status = '0' Or D.Imp_Status = '0')       
And (Client_Brok_Details.Status = 'I' Or D.Status = 'I') 
AND D.Imp_Status <> '2' AND Client_Brok_Details.Imp_Status <> '2'       
And D.Branch_Cd Like @Branch_Cd      
And D.Party_Code Between @FromParty And @ToParty      
And D.ModifidedOn <= @MainDate And Client_Brok_Details.ModifiedOn <= @DetDate      
And D.Cl_Code In (Select Cl_Code From ClientMaster)

GO
