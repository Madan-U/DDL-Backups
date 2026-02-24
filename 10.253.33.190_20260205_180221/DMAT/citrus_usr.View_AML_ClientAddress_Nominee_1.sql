-- Object: VIEW citrus_usr.View_AML_ClientAddress_Nominee_1
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

Create View [citrus_usr].[View_AML_ClientAddress_Nominee_1]
As
Select 
DPID = Left(cm_cd,8),
BOID = cm_cd,
HldFlag = 'NM' , 
Add1 = cb_nomineeadd1, 
Add2 = cb_nomineeadd2,  
Add3 = cb_nomineeadd3,  
City = cb_nomineecity, 
State = cb_nomineestate, 
Country = cb_nomineecountry, 
cb_nomineepin
From Acer_Client_Master

GO
