-- Object: PROCEDURE dbo.GenerateAgeing
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

--EXEC GenerateAgeing    
CREATE proc [dbo].[GenerateAgeing]        
AS        
      
set transaction isolation level read uncommitted      
      
truncate table ledger_temp_New        
        
Select party_code, branch_cd, Family, sub_broker,trader, short_name       
Into #Client      
From msajag.dbo.client1 c1, msajag.dbo.client2 c2        
where c1.cl_code = c2.cl_code      
and exists (select Party_code from mtftrade.dbo.TblClientMargin t
			where c1.Cl_Code = t.Party_Code 
			and GETDATE() between From_Date and To_Date)
      
ALTER TABLE [dbo].[#Client] ADD       
 CONSTRAINT [pk_client] PRIMARY KEY  CLUSTERED       
 (      
  [Party_code]      
 )  ON [PRIMARY]       
      
Insert Into Ledger_Temp_New      
select CltCode, Vdt = left(Vdt,11), Edt = left(Edt,11), VTyp, Vamt = Sum(Vamt), DrCr, branch_cd, Family, sub_broker,trader, short_name       
from ledger l With(index(ledind),nolock), #Client C      
where c.party_code=l.cltcode       
Group By CltCode, left(Vdt,11), left(Edt,11), VTyp, DrCr, branch_cd, Family, sub_broker,trader, short_name          
Order By 7,1,2   
   
Insert Into Ledger_Temp_New      
select CltCode, Vdt = left(Vdt,11), Edt = left(Edt,11), VTyp, Vamt = Sum(Vamt), DrCr, branch_cd, Family, sub_broker,trader, short_name       
from AngelBSECM.account_ab.dbo.ledger l, #Client C      
where c.party_code=l.cltcode       
Group By CltCode, left(Vdt,11), left(Edt,11), VTyp, DrCr, branch_cd, Family, sub_broker,trader, short_name          
Order By 7,1,2

GO
