-- Object: VIEW citrus_usr.View_AML_Client_BankDetails
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE View [citrus_usr].[View_AML_Client_BankDetails]
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
RelationPeriod ='',
Last_Modified_Date
From dp_client_master_1

GO
