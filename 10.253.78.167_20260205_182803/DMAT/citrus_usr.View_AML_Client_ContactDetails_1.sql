-- Object: VIEW citrus_usr.View_AML_Client_ContactDetails_1
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

Create View [citrus_usr].[View_AML_Client_ContactDetails_1]
As
Select
DPID = Left(cm_cd,8),
BOID = cm_cd,
HldFlag = 'FH',
Email =  cm_email, 
Mobile1 = cm_mobile, 
Mobile2 = cm_tele1, 
Mobile3 = cb_tele1, 
DefaultCon = 0 
From Acer_Client_Master

GO
