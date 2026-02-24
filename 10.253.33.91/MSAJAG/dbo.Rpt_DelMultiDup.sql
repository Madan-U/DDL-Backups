-- Object: PROCEDURE dbo.Rpt_DelMultiDup
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc Rpt_DelMultiDup As 
Truncate Table MultiTemp 

Insert into MultiTemp
Select Party_Code, CltDpNo, DpId, '', DpType,0 From MultiCltId  
Group By Party_Code, CltDpNo, DpId, DpType
Having Count(Party_Code) > 1 

Update MultiTemp Set Introducer = M.Introducer,Def=M.Def From MultiCltId M
Where M.Party_Code = MultiTemp.Party_Code
And M.CltDpNo = MultiTemp.CltDpNo
And M.DpId = MultiTemp.DpId
And M.DpType = MultiTemp.DpType

Delete From MultiCltId Where Party_Code In ( Select Party_Code From MultiTemp
Where MultiCltId.Party_Code = MultiTemp.Party_Code
And MultiCltId.CltDpNo = MultiTemp.CltDpNo
And MultiCltId.DpId = MultiTemp.DpId
And MultiCltId.DpType = MultiTemp.DpType )

Insert into MultiCltId 
Select * From MultiTemp

GO
