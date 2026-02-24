-- Object: PROCEDURE dbo.Report_Rpt_NseDelClientId
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------







CREATE Proc Report_Rpt_NseDelClientId 
(@StatusId Varchar(15),
 @StatusName Varchar(25),	
 @Party_Code Varchar(10),
 @DpId Varchar(8),
 @CltDpNo Varchar(16)
)
As
if @statusid = 'broker'
Begin

select Distinct M.Party_code,Introducer,M.DpId,BankName=IsNull(BankName,''),M.CltDpNo,M.DpType,Def=(Case When Def = 1 Then 'Received' Else 'Not Received' End),ACType='Pay_In'
from MultiCltId M Left Outer Join Bank B On (BankId = M.DpId ) 
where M.Party_code like @Party_code+'%' and M.DpId like @DpId+'%' and M.CltDpNo like @CltDpNo +'%'
UNION ALL 
select Distinct M.Party_code,Introducer=Long_Name,DpId=M.BankId,BankName=IsNull(BankName,''),CltDpNo=CltDpId,
DpType=Depository,Def=(Case When DefDp = 1 Then 'Default' Else '-' End),ACType='Pay_Out' 
from Client1_Report C1, Client4 M Left Outer Join Bank On (M.BankId = Bank.BankId) 
where C1.Cl_Code = M.Cl_Code And Party_code like @Party_code+'%' and M.BankId like @DpId+'%' 
and CltDpId like @CltDpNo+'%'
order by M.Party_code
End
if @statusid = 'branch'
Begin
select Distinct M.Party_code,Introducer,M.DpId,BankName=IsNull(BankName,''),M.CltDpNo,M.DpType,Def=(Case When Def = 1 Then 'Received' Else 'Not Received' End),ACType='Pay_In'
from branches br,Client1_Report C1,Client2_Report C2, MultiCltId M Left Outer Join Bank B On (BankId = DpId ) 
where M.Party_code like @Party_code+'%' and M.DpId like @DpId+'%' and M.CltDpNo like @CltDpNo +'%'
And C1.Cl_Code = C2.Cl_Code And C2.Party_Code = M.Party_Code
and br.short_name = c1.trader and br.branch_cd = @statusname
UNION ALL 
select Distinct M.Party_code,Introducer=C1.Long_Name,DpId=M.BankId,BankName=IsNull(BankName,''),CltDpNo=CltDpId,
DpType=Depository,Def=(Case When DefDp = 1 Then 'Default' Else '-' End),ACType='Pay_Out' 
from branches br, Client1_Report C1, Client2_Report C2, Client4 M Left Outer Join Bank On (M.BankId = Bank.BankId) 
where C1.Cl_Code = M.Cl_Code And M.Party_code like @Party_code+'%' and M.BankId like @DpId+'%' 
and CltDpId like @CltDpNo+'%'
And C1.Cl_Code = C2.Cl_Code And C2.Party_Code = M.Party_Code
and br.short_name = c1.trader and br.branch_cd = @statusname
order by M.Party_code
End
if @statusid = 'subbroker'
Begin
select Distinct M.Party_code,Introducer,M.DpId,BankName=IsNull(BankName,''),M.CltDpNo,M.DpType,Def=(Case When Def = 1 Then 'Received' Else 'Not Received' End),ACType='Pay_In'
from subbrokers sb,Client1_Report C1,Client2_Report C2, MultiCltId M Left Outer Join Bank B On (BankId = DpId ) 
where M.Party_code like @Party_code+'%' and M.DpId like @DpId+'%' and M.CltDpNo like @CltDpNo +'%'
And C1.Cl_Code = C2.Cl_Code And C2.Party_Code = M.Party_Code
and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname
UNION ALL 
select Distinct M.Party_code,Introducer=C1.Long_Name,DpId=M.BankId,BankName=IsNull(BankName,''),CltDpNo=CltDpId,
DpType=Depository,Def=(Case When DefDp = 1 Then 'Default' Else '-' End),ACType='Pay_Out' 
from subbrokers sb, Client1_Report C1, Client2_Report C2, Client4 M Left Outer Join Bank On (M.BankId = Bank.BankId) 
where C1.Cl_Code = M.Cl_Code And M.Party_code like @Party_code+'%' and M.BankId like @DpId+'%' 
and CltDpId like @CltDpNo+'%'
And C1.Cl_Code = C2.Cl_Code And C2.Party_Code = M.Party_Code
and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname
order by M.Party_code
End
if @statusid = 'trader'
Begin
select Distinct M.Party_code,Introducer,M.DpId,BankName=IsNull(BankName,''),M.CltDpNo,M.DpType,Def=(Case When Def = 1 Then 'Received' Else 'Not Received' End),ACType='Pay_In'
from Client1_Report C1,Client2_Report C2, MultiCltId M Left Outer Join Bank B On (BankId = DpId ) 
where M.Party_code like @Party_code+'%' and M.DpId like @DpId+'%' and M.CltDpNo like @CltDpNo +'%'
And C1.Cl_Code = C2.Cl_Code And C2.Party_Code = M.Party_Code
and c1.trader = @statusname
UNION ALL 
select Distinct M.Party_code,Introducer=Long_Name,DpId=M.BankId,BankName=IsNull(BankName,''),CltDpNo=CltDpId,
DpType=Depository,Def=(Case When DefDp = 1 Then 'Default' Else '-' End),ACType='Pay_Out' 
from Client1_Report C1, Client2_Report C2, Client4 M Left Outer Join Bank On (M.BankId = Bank.BankId) 
where C1.Cl_Code = M.Cl_Code And M.Party_code like @Party_code+'%' and M.BankId like @DpId+'%' 
and CltDpId like @CltDpNo+'%'
And C1.Cl_Code = C2.Cl_Code And C2.Party_Code = M.Party_Code
and c1.trader = @statusname
order by M.Party_code
End
if @statusid = 'family'
Begin
select Distinct M.Party_code,Introducer,M.DpId,BankName=IsNull(BankName,''),M.CltDpNo,M.DpType,Def=(Case When Def = 1 Then 'Received' Else 'Not Received' End),ACType='Pay_In'
from Client1_Report C1,Client2_Report C2, MultiCltId M Left Outer Join Bank B On (BankId = DpId ) 
where M.Party_code like @Party_code+'%' and M.DpId like @DpId+'%' and M.CltDpNo like @CltDpNo +'%'
And C1.Cl_Code = C2.Cl_Code And C2.Party_Code = M.Party_Code
and c1.family = @statusname
UNION ALL 
select Distinct M.Party_code,Introducer=Long_Name,DpId=M.BankId,BankName=IsNull(BankName,''),CltDpNo=CltDpId,
DpType=Depository,Def=(Case When DefDp = 1 Then 'Default' Else '-' End),ACType='Pay_Out' 
from Client1_Report C1, Client2_Report C2, Client4 M Left Outer Join Bank On (M.BankId = Bank.BankId) 
where C1.Cl_Code = M.Cl_Code And M.Party_code like @Party_code+'%' and M.BankId like @DpId+'%' 
and CltDpId like @CltDpNo+'%'
And C1.Cl_Code = C2.Cl_Code And C2.Party_Code = M.Party_Code
and c1.family = @statusname
order by M.Party_code
End
if @statusid = 'client'
Begin
select Distinct M.Party_code,Introducer,M.DpId,BankName=IsNull(BankName,''),M.CltDpNo,M.DpType,Def=(Case When Def = 1 Then 'Received' Else 'Not Received' End),ACType='Pay_In'
from MultiCltId M Left Outer Join Bank B On (BankId = DpId ) 
where M.Party_code like @Party_code+'%' and M.DpId like @DpId+'%' and M.CltDpNo like @CltDpNo +'%'
and M.Party_Code = @Statusname
UNION ALL 
select Distinct M.Party_code,Introducer=Long_Name,DpId=M.BankId,BankName=IsNull(BankName,''),CltDpNo=CltDpId,
DpType=Depository,Def=(Case When DefDp = 1 Then 'Default' Else '-' End),ACType='Pay_Out' 
from Client1_Report C1, Client4 M Left Outer Join Bank On (M.BankId = Bank.BankId) 
where C1.Cl_Code = M.Cl_Code And Party_code like @Party_code+'%' and M.BankId like @DpId+'%' 
and CltDpId like @CltDpNo+'%'
and M.Party_Code = @Statusname
order by M.Party_code
End

GO
