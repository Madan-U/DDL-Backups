-- Object: PROCEDURE dbo.Onlinedpmaaping
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE proc [dbo].[Onlinedpmaaping]
as

Select Distinct BO_PArtyCode,CDSL_ID ,poa_flag into #Temp1 
from ABVSCITRUS.CRMDB_A.DBO.Online_DP_Mapping where Process_date >=convert(varchar(11),getdate(),120)

Alter table #Temp1
Add long_Name varchar(100),Client_Status Varchar(1)

Update T set Client_Status=1 from #Temp1 t,Client5 c where BO_PArtyCode=Cl_code 

Update T set Long_name=c.Long_Name from #Temp1 t,Client1 c where BO_PArtyCode=Cl_code 
 

Begin Tran

Update C Set DefDp=0
--Select * 
from client4 C,#Temp1 T where party_code in (Select BO_PArtyCode from #Temp1)
And Depository ='NSDL' and BankID <>'12033200'
and C.Cl_code=T.BO_PArtyCode and DefDp =1 and isnull(Client_Status,0)=1  



Update C Set BankID=left(cdsl_id,8),Cltdpid=cdsl_id 
--Select * 
from client4 C,#Temp1 T where party_code in (Select BO_PArtyCode from #Temp1)
And Depository ='CDSL' and BankID Not in ('12033200','12033201')
and C.Cl_code=T.BO_PArtyCode and DefDp =1 and isnull(Client_Status,0)=1  

INSERT INTO client4
Select BO_PArtyCode,BO_PArtyCode,0,left(cdsl_id,8),cdsl_id,Depository ='CDSL','1' from #Temp1
where BO_PArtyCode Not in (
Select cl_code from client4 where Depository ='CDSL' and BankID  in ('12033200','12033201'))
 and isnull(Client_Status,0)=1  


Insert into Multicltid 
Select Distinct BO_PArtyCode,Cdsl_id,left(cdsl_id,8),Long_Name,DpType ='CDSL',
Def=(Case when isnull(poa_flag,0) in (1,2)
Then 1 Else 0 End) from #Temp1
where Not exists (
Select Party_code from Multicltid where Party_Code=BO_PArtyCode and cdsl_id=CltDpNo)
 and isnull(Client_Status,0)=1   

 Commit

GO
