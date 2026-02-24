-- Object: VIEW citrus_usr.View_AML_ClientAddress_Nominee
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE View [citrus_usr].[View_AML_ClientAddress_Nominee]
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
cb_nomineepin,
Last_Modified_Date
From dp_client_master_1

GO
