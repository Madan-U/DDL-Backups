-- Object: PROCEDURE dbo.InsDelInterSettUpdateInPool
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/* Drop Proc InsDelInterSettUpdateInPool */
CREATE Proc InsDelInterSettUpdateInPool As
Declare 
@@SNo int,
@@DelSNo int,
@@Party_Code Varchar(10),
@@IsIn Varchar(12),
@@Qty int,
@@TCode int,
@@Exchg Varchar(3),
@@TrDate Varchar(11),
@@Sett_No Varchar(7),
@@BCltDpId Varchar(16),
@@BDpId Varchar(8),
@@Sett_Type Varchar(2),
@@SettDelQty int,
@@SettDelTransQty int,
@@DematCur Cursor,
@@SettDel Cursor,
@@SettDelTrans Cursor

Select @@SettDelQty = 0 
Select @@SettDelTransQty = 0
/* Getting All The Records From DematTrans For InterSettlement */
Set @@DematCur = Cursor For
Select D.SNo,IsIn,Qty,TCode,TrDate=Left(Convert(Varchar,TrDate,109),11),D.Sett_No,D.sett_Type,DP.DpCltNo,Dp.DpId,Exchg='BSE'
From DematTrans D, DelSegment Ds, BSEDB.DBO.DeliveryDp DP Where D.CltAccNo = Ds.BSECMBpId And Party_Code = 'Party'  
And Dp.DpType = 'NSDL' And Dp.Description Like '%POOL%'
Order By IsIn,Qty Desc,D.Sett_No,D.sett_Type,DP.DpCltNo,Dp.DpID
Open @@DematCur 
Fetch Next From @@DematCur Into @@SNo,@@IsIn,@@Qty,@@TCode,@@TrDate,@@Sett_No,@@Sett_Type,@@BCltDpId,@@BDpId,@@Exchg
While @@Fetch_Status = 0
Begin	
	/* Taking Party's Sell Position for That Scrip from DeliveryClt Table. */
	Set @@SettDel = Cursor For
	Select SNO,Qty,Party_Code From BSEDB.DBO.DelTrans Where BCltDpId = @@BCltDpId And BDpId = @@BDpId
	And CertNo = @@IsIn And ISett_No = @@Sett_No and Filler2 = 1 And DrCr = 'D' and Delivered <> 'D'  And TrType <> 908 
	Order By Qty Desc,Party_Code
	Open @@SettDel
	Fetch Next From @@SettDel into @@DelSno,@@SettDelQty,@@Party_Code
	While @@Fetch_Status = 0 And @@Qty > 0 	
	Begin
		Select @@DelSno,@@SettDelQty,@@Party_Code,@@Qty
		
		If @@SettDelQty > 0 and @@Qty > 0 
		Begin
			If @@SettDelQty >= @@Qty 
			Begin
				/* Update the Record and Exit From current Loop */
				Update DematTrans Set Party_Code = @@Party_Code Where SNo = @@SNo And Sett_No = @@Sett_No
				And IsIn = @@IsIn And SNo = @@SNo And DrCr = 'C' and TrType = 904

				if @@SettDelQty > @@Qty 
				Begin
					insert into BSEDB.DBO.DelTrans 
					Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,@@Qty,FromNo,ToNo,CertNo,FolioNo,HolderName,Reason,DrCr,'D',OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
					From DelTrans Where SNo = @@DelSNo And BCltDpId = @@BCltDpId And BDpId = @@BDpId And CertNo = @@IsIn 
					And Party_Code = @@Party_Code And ISett_No = @@Sett_No and Filler2 = 1 And DrCr = 'D' 

					Update BSEDB.DBO.DelTrans Set Qty=@@SettDelQty-@@Qty Where SNo = @@DelSNo And BCltDpId = @@BCltDpId And BDpId = @@BDpId
					And CertNo = @@IsIn And Party_Code = @@Party_Code And ISett_No = @@Sett_No and 
					Filler2 = 1 And DrCr = 'D' 
					Select @@Qty = 0
				End
				Else	
				Begin	
					Update BSEDB.DBO.DelTrans Set Delivered = 'D' Where SNo = @@DelSNo And BCltDpId = @@BCltDpId And BDpId = @@BDpId
					And CertNo = @@IsIn And Party_Code = @@Party_Code And ISett_No = @@Sett_No and Filler2 = 1 
					And DrCr = 'D' 
					Select @@Qty = 0
				End 				
				Select @@SettDelQty = 0		
			End
			Else
			Begin
				/* Update the Record with @@Qty - @@SettDelQty and Fetch the Next 
				   Record From current Loop */
				Insert Into DematTrans Select Sett_No,Sett_Type,RefNo,TCode,TrType,@@Party_Code,Scrip_Cd,
				Series,@@SettDelQty,TrDate,CltAccNo,DpId,DpName,IsIn,Branch_Cd,PartiPantCode,DpType,TransNo,
				DrCr,BDpType,BDpId,BCltAccNo,Filler1,Filler2,Filler3,Filler4,Filler5 From DematTrans 
				Where SNo = @@SNo And Sett_No = @@Sett_No And IsIn = @@IsIn And SNo = @@SNo And DrCr = 'C' 				
				
				Update DematTrans Set Qty = @@Qty-@@SettDelQty
				Where SNo = @@SNo And Sett_No = @@Sett_No And IsIn = @@IsIn And SNo = @@SNo And DrCr = 'C' 

				Update BSEDB.DBO.DelTrans Set Delivered = 'D' Where SNo = @@DelSNo And BCltDpId = @@BCltDpId And BDpId = @@BDpId
				And CertNo = @@IsIn 
				And Party_Code = @@Party_Code And ISett_No = @@Sett_No and Filler2 = 1 And DrCr = 'D'				

				Select @@Qty = @@Qty-@@SettDelQty
				Select @@SettDelQty = 0		
			End
		End
		Fetch Next From @@SettDel into @@DelSno,@@SettDelQty,@@Party_Code	
	End
	Close @@SettDel	
	DeAllocate @@SettDel
	Fetch Next From @@DematCur Into @@SNo,@@IsIn,@@Qty,@@TCode,@@TrDate,@@Sett_No,@@Sett_Type,@@BCltDpId,@@BDpId,@@Exchg 
End
Close @@DematCur
DeAllocate @@DematCur

GO
