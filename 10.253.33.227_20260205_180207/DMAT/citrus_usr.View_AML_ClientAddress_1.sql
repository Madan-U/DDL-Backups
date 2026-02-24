-- Object: VIEW citrus_usr.View_AML_ClientAddress_1
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

Create View [citrus_usr].[View_AML_ClientAddress_1]
As
Select 
DPID = Left(cm_cd,8),
BOID = cm_cd,
HldFlag = 'FH' , 
ADD1 = cm_add1, 
ADD2 = cm_add2,
ADD3 = cm_add3,
City = cm_city,
state = cm_state, 
Country = cm_country, 
pin = cm_pin From Acer_Client_Master

GO
