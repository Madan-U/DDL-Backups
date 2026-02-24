-- Object: VIEW citrus_usr.View_AML_Client_BankDetails_1
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create  View [citrus_usr].[View_AML_Client_BankDetails_1]
As
Select 
DPID = Left(cm_cd,8),
BOID = cm_cd,
HldFlag = 'FH',  
BankName = cm_bankname,
BranchName = cm_divbankcode, 
MICR = cm_divbankcode, 
AccountNo = cm_divbankacno, 
FirstHolder ='',
FstHoldPAN ='',
SecondHolder ='',
SecHoldPAN ='',
ThirdHolder ='',
TrdHolderPAN ='',
POAHolder ='',
POAPAN ='',
RelationPeriod =''
From Acer_Client_Master

GO
