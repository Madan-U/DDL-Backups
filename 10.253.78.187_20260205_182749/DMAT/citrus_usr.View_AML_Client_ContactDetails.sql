-- Object: VIEW citrus_usr.View_AML_Client_ContactDetails
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE View [citrus_usr].[View_AML_Client_ContactDetails] 
As
Select
DPID = Left(cm_cd,8),
BOID = cm_cd,
HldFlag = 'FH',
Email =  cm_email, 
Mobile1 = cm_mobile, 
Mobile2 = cm_tele1, 
Mobile3 = cb_tele1, 
DefaultCon = 0 ,
Last_Modified_Date
From dp_client_master_1

GO
