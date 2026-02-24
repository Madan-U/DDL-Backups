-- Object: PROCEDURE dbo.CBO_InterBenTrans
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE Proc CBO_InterBenTrans ( @Sett_no Varchar(7),@Sett_Type Varchar(2),@RefNo Int) As
Declare 
 @@Scrip_Cd Varchar(12),
 @@series Varchar(3),
 @@Party_Code Varchar(10),
 @@TargetParty Varchar(10),
 @@PSett_No Varchar(7),
 @@Psett_type Varchar(2),
 @@SDate Varchar(11),
 @@Cqty Int,
 @@DQty Int,
 @@IQty Int,
 @@XQty Int,
 @@BCqty Int,
 @@BDQty Int,
 @@BIQty Int,
 @@BXQty Int,
 @@FromNo Varchar(15),
 @@ToNo Varchar(16),
 @@FolioNo Varchar(16),
 @@SNo Numeric(18,0),
 @@TCode Numeric(18,0),
 @@CertNo Varchar(15),
 @@TrType int,
 @@TQty int, 
 @@Exchg Varchar(3),
 @@BSECODE Varchar(12),
 @@IsIn Varchar(12),
 @@Cfwd Cursor,
 @@Cfwd1 Cursor,
 @@Inter Cursor,
 @@InterPart Cursor
Select @@CQty = 0
Select @@IQty = 0
Select @@DQty = 0
Select @@XQty = 0
Select @@BCQty = 0
Select @@BIQty = 0
Select @@BDQty = 0
Select @@BXQty = 0

Truncate Table DelInterBen
Insert into DelInterBen
SELECT Sett_no,Sett_Type,PARTY_CODE,SCRIP_CD,Series,BSECODE,Psettno,psetttype,Exchg,0,0,0,0,0,0,IsIn 
FROM InsInterBenTrans where sett_no = @Sett_no
and sett_type = @sett_type And Party_Code Not in ( Select Party_code From DelPartyFlag Where InterFlag = 1 And Party_code = InsInterBenTrans.Party_Code) 
And Sett_Type Not In ('A','X','AD','AC')

Update DelInterBen Set Scrip_Cd = M.Scrip_cd, Series = M.Series
From MultiIsIn M
Where M.IsIn = DelInterBen.IsIn
And M.Valid = 1 

Insert Into DelInterBen
Select DT.Sett_No,DT.Sett_Type,DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,DT.Psettno,DT.Psetttype,DT.Exchg,BCQty=IsNull(Sum(Qty),0),0,0,0,0,0,IsIn
From BSEDB.DBO.DelTrans D, DelInterBen DT where D.SETT_NO = DT.Sett_no
And D.sett_type = DT.Sett_Type and D.party_code = DT.Party_Code
and D.CertNo = DT.IsIn and DrCr = 'C' and sharetype <> 'auction'
and Filler2 = 1 And BCQty = 0 And CQty = 0 And XQty = 0 And IQty = 0 And BDQty = 0 And DQty = 0 
Group By DT.Sett_No,DT.Sett_Type,DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,DT.Psettno,DT.Psetttype,DT.Exchg,IsIn

Insert Into DelInterBen
Select DT.Sett_No,DT.Sett_Type,DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,DT.Psettno,DT.Psetttype,DT.Exchg,BCQty=0,
CQty=IsNull(Sum(Qty),0),0,0,0,0,IsIn
From MSAJAG.DBO.DelTrans D, DelInterBen DT where D.SETT_NO = DT.Sett_no
And D.sett_type = DT.Sett_Type and D.party_code = DT.Party_Code
and D.CertNo = DT.IsIn and DrCr = 'C' and sharetype <> 'auction'
and Filler2 = 1 And BCQty = 0 And CQty = 0 And XQty = 0 And IQty = 0 And BDQty = 0 And DQty = 0 
Group By DT.Sett_No,DT.Sett_Type,DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,DT.Psettno,DT.Psetttype,DT.Exchg,IsIn

Insert Into DelInterBen
Select DT.Sett_No,DT.Sett_Type,DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,DT.Psettno,DT.Psetttype,DT.Exchg,BCQty=0,0,
XQty=IsNull(Sum(Qty),0),0,0,0,IsIn
From BSEDB.DBO.DelTrans D, DelInterBen DT where D.ISETT_NO = DT.Sett_no
And D.Isett_type = DT.Sett_Type and D.party_code = DT.Party_Code
and D.CertNo = DT.IsIn and DrCr = 'D' and sharetype <> 'auction'
and Filler2 = 1 And Delivered <> 'D' And BCQty = 0 And CQty = 0 And XQty = 0 And IQty = 0 And BDQty = 0 And DQty = 0 
Group By DT.Sett_No,DT.Sett_Type,DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,DT.Psettno,DT.Psetttype,DT.Exchg,IsIn

Insert Into DelInterBen
Select DT.Sett_No,DT.Sett_Type,DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,DT.Psettno,DT.Psetttype,DT.Exchg,BCQty=0,0,XQty=0,
IQty=IsNull(Sum(Qty),0),0,0,IsIn
From MSAJAG.DBO.DelTrans D, DelInterBen DT where D.ISETT_NO = DT.Sett_no
And D.Isett_type = DT.Sett_Type and D.party_code = DT.Party_Code
and D.CertNo = DT.IsIn and DrCr = 'D' and sharetype <> 'auction'
and Filler2 = 1 And Delivered <> 'D' And BCQty = 0 And CQty = 0 And XQty = 0 And IQty = 0 And BDQty = 0 And DQty = 0 
Group By DT.Sett_No,DT.Sett_Type,DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,DT.Psettno,DT.Psetttype,DT.Exchg,IsIn

Insert Into DelInterBen
Select DT.Sett_No,DT.Sett_Type,DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,DT.Psettno,DT.Psetttype,DT.Exchg,BCQty=0,0,XQty=0,0,
BDQty=IsNull(Sum(Qty),0),0,IsIn
From BSEDB.DBO.deliveryclt D, DelInterBen DT where D.SETT_NO = DT.Sett_no
And D.sett_type = DT.Sett_Type and D.party_code = DT.Party_Code
and D.scrip_cd = DT.BseCode and InOut = 'I'
and BCQty = 0 And CQty = 0 And XQty = 0 And IQty = 0 And BDQty = 0 And DQty = 0 
Group By DT.Sett_No,DT.Sett_Type,DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,DT.Psettno,DT.Psetttype,DT.Exchg,IsIn

Insert Into DelInterBen
Select DT.Sett_No,DT.Sett_Type,DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,DT.Psettno,DT.Psetttype,DT.Exchg,BCQty=0,0,
XQty=0,0,BDQty=0,DQty=IsNull(Sum(Qty),0),IsIn
From MSAJAG.DBO.deliveryclt D, DelInterBen DT where D.SETT_NO = DT.Sett_no
And D.sett_type = DT.Sett_Type and D.party_code = DT.Party_Code
and D.scrip_cd = DT.Scrip_Cd And D.Series = DT.Series and InOut = 'I'
and BCQty = 0 And CQty = 0 And XQty = 0 And IQty = 0 And BDQty = 0 And DQty = 0 
Group By DT.Sett_No,DT.Sett_Type,DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,DT.Psettno,DT.Psetttype,DT.Exchg,IsIn


Set @@InterPart = CurSor for
Select Distinct PARTY_CODE,SCRIP_CD,Series,BSECODE,DQty From 
DelInterBen where DQty > 0 
And sett_no = @Sett_no and sett_type = @sett_type 
Order By PARTY_CODE,SCRIP_CD,Series,BSECODE
Open @@InterPart 
Fetch Next From @@InterPart into @@PARTY_CODE,@@SCRIP_CD,@@Series,@@BSECODE,@@DQty
While @@Fetch_Status = 0 
Begin
set @@inter = cursor for
Select PARTY_CODE,SCRIP_CD,Series,BSECODE,Psettno,psetttype,Exchg,Sum(BCQty),Sum(CQty),Sum(XQty),Sum(IQty),Sum(BDQty),IsIn
From DelInterBen where sett_no = @Sett_no and sett_type = @sett_type
And Party_Code = @@Party_Code And Scrip_CD = @@Scrip_Cd And Series = @@Series And BseCode = @@BseCode 
Group By PARTY_CODE,SCRIP_CD,Series,BSECODE,Psettno,psetttype,Exchg, IsIn 
ORDER BY PARTY_CODE,SCRIP_CD,Series, Exchg desc , Psettno,psetttype 
open @@inter
fetch next from @@inter into @@Party_Code,@@Scrip_Cd,@@Series,@@BseCode,@@PSett_No,@@Psett_type,@@Exchg,@@BCQty,@@CQty,@@XQty,@@IQty,@@BDQty,@@IsIn
select @@DQty = @@BDQty + @@DQty - @@BCQty - @@CQty - @@IQty - @@XQty
while @@fetch_status = 0
begin 

If @@DQty > 0 
Begin
 select @@CQty = 0 

 if @@Exchg = 'NSE' 
 Begin
 Set @@Cfwd = Cursor for 
 select IsNull(Sum(Qty),0) from MSAJAG.DBO.DelTrans D, MSAJAG.DBO.DeliveryDp DP where delivered = '0' And SETT_NO = @@PSett_No
 And sett_type = @@PSett_Type and Party_Code = @@Party_Code
 and CertNo = @@IsIn and DrCr = 'D' 
 and Filler2 = 1 and TrType = 904 and sharetype <> 'auction'
 And Dp.DpId = D.BDpId And Dp.DpCltNo = D.BCltDpId And Dp.Description Not Like '%POOL%' And Description not Like '%PLEDGE%' AND ACCOUNTTYPE <> 'MAR'
 End
 Else
 Begin
 Set @@Cfwd = Cursor for 
 select IsNull(Sum(Qty),0) from BSEDB.DBO.DelTrans D, BSEDB.DBO.DeliveryDP DP where delivered = '0' And SETT_NO = @@PSett_No
 And sett_type = @@PSett_Type and Party_Code = @@Party_Code
 and CertNo = @@IsIn and DrCr = 'D' 
 and Filler2 = 1 and TrType = 904 and sharetype <> 'auction'
 And Dp.DpId = D.BDpId And Dp.DpCltNo = D.BCltDpId And Dp.Description Not Like '%POOL%' and Description not Like '%PLEDGE%' AND ACCOUNTTYPE <> 'MAR'
 End
 Open @@Cfwd
 fetch next from @@Cfwd into @@CQty

 Close @@Cfwd
 deallocate @@Cfwd

 If @@CQty > @@Dqty  
 begin
	if @@Exchg = 'NSE'
	Begin
	Set @@Cfwd = Cursor for 	
	Select Qty,FromNo,ToNo,CertNo,FolioNo,D.Sno,TrType,TCode from MSAJAG.DBO.DelTrans D, MSAJAG.DBO.DeliveryDP Dp where delivered = '0' 
	And SETT_NO = @@PSett_No And sett_type = @@PSett_Type and Party_Code = @@Party_Code
 	and CertNo = @@IsIn and DrCr = 'D' and Filler2 = 1 and TrType = 904  and sharetype <> 'auction'
             And Dp.DpId = D.BDpId And Dp.DpCltNo = D.BCltDpId And Dp.Description Not Like '%POOL%' and Description not Like '%PLEDGE%' AND ACCOUNTTYPE <> 'MAR'
	order by Qty asc
	End
	Else
	Begin
	Set @@Cfwd = Cursor for 	
	Select Qty,FromNo,ToNo,CertNo,FolioNo,D.Sno,TrType,TCode from BSEDB.DBO.DelTrans D, BSEDB.DBO.DeliveryDp Dp where delivered = '0' 
	And SETT_NO = @@PSett_No And sett_type = @@PSett_Type and Party_Code = @@Party_Code
 	and CertNo = @@IsIn and DrCr = 'D' and Filler2 = 1 and TrType = 904  and sharetype <> 'auction'
             And Dp.DpId = D.BDpId And Dp.DpCltNo = D.BCltDpId And Dp.Description Not Like '%POOL%' and Description not Like '%PLEDGE%' AND ACCOUNTTYPE <> 'MAR'
	order by Qty asc
	End
	Open @@Cfwd
	fetch next from @@Cfwd into @@TQty,@@FromNo,@@ToNo,@@CertNo,@@FolioNo,@@SNo,@@TrType,@@TCode 

        While @@Fetch_status = 0 And @@DQty > 0
	Begin

		If @@DQty > 0 			
		Begin
			if @@DQty - @@TQty >= 0 
			Begin
				if @@Exchg = 'NSE' 
				Begin 
				update MSAJAG.DBO.DelTrans set ISett_no=@Sett_No,ISett_Type=@Sett_Type,TrType=1000,Reason = 'Inter Ben Transfer' 
				Where Sett_no = @@PSett_No and sett_type = @@PSett_Type and party_code = @@Party_Code and 
				CertNo = @@IsIn and Qty = @@TQty and fromno = @@FromNo and tono = @@ToNo and 
				certno = @@CertNo and foliono = @@FolioNo and sno = @@SNo and TCode = @@TCode and 
				TrType = @@TrType and DrCr = 'D' and Filler2 = 1  
				End
				Else
				Begin 
				update BSEDB.DBO.DelTrans set ISett_no=@Sett_No,ISett_Type=@Sett_Type,TrType=1000,Reason = 'Inter Exc Ben Transfer' 
				Where Sett_no = @@PSett_No and sett_type = @@PSett_Type and party_code = @@Party_Code and 
				CertNo = @@IsIn and Qty = @@TQty and fromno = @@FromNo and tono = @@ToNo and 
				certno = @@CertNo and foliono = @@FolioNo and sno = @@SNo and TCode = @@TCode and 
				TrType = @@TrType and DrCr = 'D' and Filler2 = 1  
				End
				select @@Dqty = @@DQty - @@TQty 
			end
			else
			begin
				if @@Exchg = 'NSE' 
				Begin 				
				insert into MSAJAG.DBO.deltrans(Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo
				,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5)
				Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,@@TQty - @@DQty,FromNo,ToNo,CertNo,FolioNo
				,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
				from  MSAJAG.DBO.DelTrans Where Sett_no = @@PSett_No and sett_type = @@PSett_Type and party_code = @@Party_Code and 
				CertNo = @@IsIn and Qty = @@TQty and fromno = @@FromNo and tono = @@ToNo and 
				certno = @@CertNo and foliono = @@FolioNo and sno = @@sNo and TCode = @@TCode and 
				TrType = @@TrType And DrCr = 'D' and Filler2 = 1  			

				update MSAJAG.DBO.DelTrans set ISett_no=@Sett_No,ISett_Type=@Sett_Type,TrType=1000,Reason = 'Inter Ben Transfer' ,
				 Qty = @@DQty
				Where Sett_no = @@PSett_No and sett_type = @@PSett_Type and party_code = @@Party_Code and 
				CertNo = @@IsIn and Qty = @@TQty and fromno = @@FromNo and tono = @@ToNo and 
				certno = @@CertNo and foliono = @@FolioNo and sno = @@SNo and TCode = @@TCode and 
				TrType = @@TrType and DrCr = 'D' and Filler2 = 1  
				End
				Else
				Begin
				insert into BSEDB.DBO.deltrans(Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo
				,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5)
				Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,@@TQty - @@DQty,FromNo,ToNo,CertNo,FolioNo
				,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
				from BSEDB.DBO.DelTrans Where Sett_no = @@PSett_No and sett_type = @@PSett_Type and party_code = @@Party_Code and 
				CertNo = @@IsIn and Qty = @@TQty and fromno = @@FromNo and tono = @@ToNo and 
				certno = @@CertNo and foliono = @@FolioNo and sno = @@sNo and TCode = @@TCode and 
				TrType = @@TrType And DrCr = 'D' and Filler2 = 1  			

				update BSEDB.DBO.DelTrans set ISett_no=@Sett_No,ISett_Type=@Sett_Type,TrType=1000,Reason = 'Inter Exc Ben Transfer' ,
				Qty = @@DQty
				Where Sett_no = @@PSett_No and sett_type = @@PSett_Type and party_code = @@Party_Code and 
				CertNo = @@IsIn and Qty = @@TQty and fromno = @@FromNo and tono = @@ToNo and 
				certno = @@CertNo and foliono = @@FolioNo and sno = @@SNo and TCode = @@TCode and 
				TrType = @@TrType and DrCr = 'D' and Filler2 = 1  
				End    			
				Select @@DQty = 0 
			end
		End
		fetch next from @@Cfwd into @@TQty,@@FromNo,@@ToNo,@@CertNo,@@FolioNo,@@SNo,@@TrType,@@TCode 
	end
        Close @@Cfwd
	deallocate @@Cfwd

 end
 else
 Begin
	If @@Exchg = 'NSE'  
	update MSAJAG.DBO.DelTrans set ISett_no=@Sett_No,ISett_Type=@Sett_Type,TrType=1000,Reason = 'Inter Ben Transfer' 
	From MSAJAG.DBO.DeliveryDp D Where Sett_no = @@PSett_No and sett_type = @@PSett_Type and party_code = @@Party_Code and 
	CertNo = @@IsIn and DrCr = 'D' and Filler2 = 1  and TrType = 904 and delivered = '0'
        and sharetype <> 'auction' And D.DpId = MSAJAG.DBO.DelTrans.BDpId And D.DpCltNo = MSAJAG.DBO.DelTrans.BCltDpId 
	And Description Not Like '%POOL%' and Description not Like '%PLEDGE%' AND ACCOUNTTYPE <> 'MAR'
	Else
	update BSEDB.DBO.DelTrans set ISett_no=@Sett_No,ISett_Type=@Sett_Type,TrType=1000,Reason = 'Inter Exc Ben Transfer' 
	From BSEDB.DBO.DeliveryDp D Where Sett_no = @@PSett_No and sett_type = @@PSett_Type and party_code = @@Party_Code and 
	CertNo = @@IsIn and DrCr = 'D' and Filler2 = 1  and TrType = 904 and delivered = '0'
        and sharetype <> 'auction' And D.DpId = BSEDB.DBO.DelTrans.BDpId And D.DpCltNo = BSEDB.DBO.DelTrans.BCltDpId 
	And Description Not Like '%POOL%' and Description not Like '%PLEDGE%' AND ACCOUNTTYPE <> 'MAR'
	Select @@DQty = @@DQty - @@CQty 
 end 
End
fetch next from @@inter into @@Party_Code,@@Scrip_Cd,@@Series,@@BseCode,@@PSett_No,@@Psett_type,@@Exchg,@@BCQty,@@CQty,@@XQty,@@IQty,@@BDQty,@@isIn
end
Fetch Next From @@InterPart into @@PARTY_CODE,@@SCRIP_CD,@@Series,@@BSECODE,@@DQty
End

/*Update DelTrans Set DpType = D.DpType,DpId=D.DpId,CtlDpId=D.DpCltNo */
Update DelTrans Set DPType =D.DpType,DPId = D.DPID,CltDpid=D.DpCltNo From Sett_Mst S, DeliveryDp D
Where S.Sett_No = ISett_No And S.Sett_Type = ISett_Type And TrType = 1000 
And D.DpType = 'NSDL' And Description Like '%POOL%' And Delivered = '0'
And ISett_no=@Sett_No And ISett_Type=@Sett_Type And Filler2 = 1 And Reason Like 'Inter Ben%'

Update BSEDB.DBO.DelTrans Set DPType =D.DpType,DPId = D.DPID,CltDpid=D.DpCltNo From Sett_Mst S, DeliveryDp D
Where S.Sett_No = ISett_No And S.Sett_Type = ISett_Type And TrType = 1000 
And D.DpType = 'NSDL' And Description Like '%POOL%' And Delivered = '0'
And ISett_no=@Sett_No And ISett_Type=@Sett_Type And Filler2 = 1 And Reason Like 'Inter Exc%'
/*
Update DelTrans Set DPType = M.DpType,DPId = M.DPID,CltDpid=M.CltDpNo,Reason='POA Inter Ben Transfer' From MultiCltId M, Sett_Mst S
Where S.Sett_No = ISett_No And S.Sett_Type = ISett_Type And DelTrans.Party_Code = M.Party_Code And Def = 1 And TrType = 1000 And Delivered = '0'
And ISett_no=@Sett_No And ISett_Type=@Sett_Type And Filler2 = 1 And Reason Like 'Inter Ben%'
AND M.dptype= 'CDSL'

Update BSEDB.DBO.DelTrans Set DPType = M.DpType,DPId = M.DPID,CltDpid=M.CltDpNo,Reason='POA Inter Exc Ben Transfer' From MultiCltId M, Sett_Mst S
Where S.Sett_No = ISett_No And S.Sett_Type = ISett_Type And BSEDB.DBO.DelTrans.Party_Code = M.Party_Code And Def = 1 And TrType = 1000 And Delivered = '0'
And ISett_no=@Sett_No And ISett_Type=@Sett_Type And Filler2 = 1 And Reason Like 'Inter Exc%'
AND M.dptype= 'CDSL'
*/

GO
