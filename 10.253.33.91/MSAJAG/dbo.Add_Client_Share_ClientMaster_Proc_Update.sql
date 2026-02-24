-- Object: PROCEDURE dbo.Add_Client_Share_ClientMaster_Proc_Update
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc [dbo].[Add_Client_Share_ClientMaster_Proc_Update] (        
@Branch_Cd Varchar(10),        
@FromParty Varchar(10),        
@ToParty Varchar(10),        
@MainDate Varchar(30),        
@DetDate Varchar(30)        
) As        


Select Party_Code      INto #tmp   
       From Client_Details C  with (nolock)       
                     Where C.Imp_Status = '0' And C.Status = 'U'        
      -- And C.Branch_Cd Like @Branch_Cd        
       And C.Party_Code Between @FromParty And @ToParty        
                     And C.ModifidedOn <= @MainDate
        
Create index #c on #tmp (party_code) 

Delete c From ClientMaster  c  
Inner Join   #tmp t On c.Party_Code=t.party_code        
        
Insert into ClientMaster        
Select C.Cl_Code, C.Party_Code, C.Short_Name, C.Long_name, C.L_Address1, C.L_Address2, C.L_city, C.L_State,         
C.L_Nation, C.L_Zip, C.Fax, C.Res_Phone1, C.Res_Phone2, C.Off_Phone1, C.Off_Phone2, C.Email, C.Branch_cd,         
Credit_Limit=0, C.Cl_type, C.Cl_status, GL_code='', Fd_code='', C.Family, Penalty=0, Confirm_Fax=0,         
PhoneOld='', C.L_Address3, C.Mobile_Pager, C.pan_gir_no        
From Client_Details C with (nolock) --, Client1 C1        
Where C.Imp_Status = '0' And C.Status = 'U'        
---And C.Branch_Cd Like @Branch_Cd        
And C.Party_Code Between @FromParty And @ToParty        
And C.ModifidedOn <= @MainDate         
And Not Exists (Select Cl_Code From ClientMaster A WHERE A.CL_CODE=C.CL_CODE)        
      
Update ClientMaster  Set Credit_Limit = D.Credit_Limit       
From CLIENT_DETAILS with (nolock) , Client_Brok_Details D with (nolock)         
Where Client_Details.Cl_Code = D.Cl_Code         
AND ClientMaster.Cl_Code = D.Cl_Code         
And (Client_Details.Imp_Status = '0' Or D.Imp_Status = '0')         
And (Client_Details.Status = 'U' Or D.Status = 'U')        
--And Client_Details.Branch_Cd Like @Branch_Cd        
And Client_Details.Party_Code Between @FromParty And @ToParty        
And Client_Details.ModifidedOn <= @MainDate And D.ModifiedOn <= @DetDate        
And Exists (Select Cl_Code From ClientMaster WHERE ClientMaster.Cl_code=Client_Details.Cl_Code)        
      
Update Client_Details Set Imp_Status = '1', Status = 'U'        
From Client_Brok_Details D  with (nolock)       
Where Client_Details.Cl_Code = D.Cl_Code         
And (Client_Details.Imp_Status = '0' Or D.Imp_Status = '0')         
And (Client_Details.Status = 'U' Or D.Status = 'U')    
AND D.Imp_Status <> '2' AND Client_Details.Imp_Status <> '2'        
--And Client_Details.Branch_Cd Like @Branch_Cd        
And Client_Details.Party_Code Between @FromParty And @ToParty        
And Client_Details.ModifidedOn <= @MainDate And D.ModifiedOn <= @DetDate        
And Exists (Select Cl_Code From ClientMaster WHERE ClientMaster.Cl_code=D.Cl_Code)               
        
Update Client_Brok_Details Set Imp_Status = '1', Status = 'U'        
From Client_Details D   with (nolock)      
Where D.Cl_Code = Client_Brok_Details.Cl_Code         
And (Client_Brok_Details.Imp_Status = '0' Or D.Imp_Status = '0')         
And (Client_Brok_Details.Status = 'U' Or D.Status = 'U')   
AND D.Imp_Status <> '2' AND Client_Brok_Details.Imp_Status <> '2'         
--And D.Branch_Cd Like @Branch_Cd        
And D.Party_Code Between @FromParty And @ToParty        
And D.ModifidedOn <= @MainDate And Client_Brok_Details.ModifiedOn <= @DetDate        
And Exists (Select Cl_Code From ClientMaster WHERE ClientMaster.Cl_code=D.Cl_Code)

GO
