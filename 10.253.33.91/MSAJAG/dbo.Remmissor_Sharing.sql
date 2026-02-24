-- Object: PROCEDURE dbo.Remmissor_Sharing
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE Proc Remmissor_Sharing (@Sett_No Varchar(7), @Sett_Type Varchar(2))
As

Delete From Remissor_Trans Where Sett_no = @Sett_No And Sett_Type = @Sett_Type

Insert Into Remissor_Trans
Select Sett_No,Sett_Type,RemCode,Branch_Cd,
ClientBrokerage=Sum(ClientBrokerage),
RemShareBrokerage=Sum(Case When RemShareBrokerage > 0 Then RemShareBrokerage Else 0 End)
From (
Select Sett_No,Sett_Type,RemCode,C1.Branch_Cd,
ClientBrokerage=Sum(PBrokTrd+SBrokTrd+PBrokDel+SBrokDel),
RemShareBrokerage=(Case When SharingType = 'G' 
			Then (Case When Val_Per = 'P' 
				   Then Round(Sum(PBrokTrd+SBrokTrd+PBrokDel+SBrokDel)*Sharing/100,2)
				   Else Round(Sum(PBrokTrd+SBrokTrd+PBrokDel+SBrokDel)*Sharing,2)
		              End)	
			When SharingType = 'R' 
			Then (Case When Val_Per = 'P' 
				   Then Round(Sum(PBrokTrd+SBrokTrd+PBrokDel+SBrokDel)-Sum(TrdAmt)*Sharing/100,2)
				   Else Round(Sum(PBrokTrd+SBrokTrd+PBrokDel+SBrokDel)-Sum(TrdAmt)*Sharing,2)
			      End)
			Else (Case When Val_Per = 'P' 
				   Then Round(Sum(PBrokTrd+SBrokTrd+PBrokDel+SBrokDel)*Sharing/100,2)
				   Else Round(Sum(PBrokTrd+SBrokTrd+PBrokDel+SBrokDel)*Sharing,2)
		              End)	
			End),
SharingType,Val_Per,Sharing,LowerLimit,UpperLimit
from CmBillValan S, Remissor_Master R, Client1 C1, Client2 C2
Where S.Party_Code = R.Party_Code
And S.Sauda_Date Between FromDate And ToDate
And Sett_no = @Sett_No And Sett_Type = @Sett_Type
And C1.Cl_Code = C2.Cl_Code And C2.Party_Code = R.RemCode
Group By Sett_No,Sett_Type,RemCode,C1.Branch_Cd,SharingType,Val_Per,Sharing,LowerLimit,UpperLimit
Having Sum(TrdAmt) Between LowerLimit And UpperLimit ) A
Group By Sett_No,Sett_Type,RemCode,Branch_Cd

GO
