-- Object: VIEW citrus_usr.View_AML_ClientAddress
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE View [citrus_usr].[View_AML_ClientAddress]
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
pin = cm_pin,
Last_Modified_Date From dp_client_master_1

GO
