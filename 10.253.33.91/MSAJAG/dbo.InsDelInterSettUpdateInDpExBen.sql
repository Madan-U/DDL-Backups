-- Object: PROCEDURE dbo.InsDelInterSettUpdateInDpExBen
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/* Drop Proc InsDelInterSettUpdateInDpExBen */
CREATE Proc InsDelInterSettUpdateInDpExBen As
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
@@Sett_Type Varchar(2),
@@SettDelQty int,
@@SettDelTransQty int,
@@XSett_No Varchar(7),
@@XSett_Type Varchar(2),
@@DematCur Cursor,
@@SettDel Cursor,
@@SettDelTrans Cursor

Select @@SettDelQty = 0 
Select @@SettDelTransQty = 0
/* Getting All The Records From DematTrans For InterSettlement */
Set @@DematCur = Cursor For
Select D.SNo,IsIn,Qty,TCode,TrDate=Left(Convert(Varchar,TrDate,109),11),D.Sett_No,D.sett_Type,D.CltAccNo,Exchg='NSE'
From DematTrans D, DeliveryDp Dp Where D.DpId = Dp.DpId And D.CltAccNo = Dp.DpCltNo And Party_Code = 'Party'  
Union All
Select D.SNo,IsIn,Qty,TCode,TrDate=Left(Convert(Varchar,TrDate,109),11),D.Sett_No,D.sett_Type,D.CltAccNo,Exchg='BSE'
From DematTrans D, BSEDB.DBO.DeliveryDp Dp Where D.DpId = Dp.DpId And D.CltAccNo = Dp.DpCltNo And Party_Code = 'Party'  
Order By IsIn,Qty Desc,D.Sett_No,D.sett_Type,D.CltAccNo
Open @@DematCur 
Fetch Next From @@DematCur Into @@SNo,@@IsIn,@@Qty,@@TCode,@@TrDate,@@Sett_No,@@Sett_Type,@@BCltDpId,@@Exchg
While @@Fetch_Status = 0
Begin	
	/* Taking Party's Sell Position for That Scrip from DeliveryClt Table. */
	If @@Exchg = 'BSE' 
	Begin 
		Set @@SettDel = Cursor For
		Select SNO,Qty,Party_Code,Sett_No,Sett_Type From BSEDB.DBO.DelTrans Where BCltDpId = @@BCltDpId
		And CertNo = @@IsIn And ISett_No = @@Sett_No and Filler2 = 1 And DrCr = 'D' and Delivered = 'G'  And TrType <> 908 
		And Reason Not Like 'POA%'
		Order By Qty Desc,Party_Code,Sett_No,Sett_Type
	End
	Else
	Begin
		Set @@SettDel = Cursor For
		Select SNO,Qty,Party_Code,Sett_No,Sett_Type From MSAJAG.DBO.DelTrans Where BCltDpId = @@BCltDpId
		And CertNo = @@IsIn And ISett_No = @@Sett_No and Filler2 = 1 And DrCr = 'D' and Delivered = 'G'  And TrType <> 908 
		And Reason Not Like 'POA%'
		Order By Qty Desc,Party_Code,Sett_No,Sett_Type	
	End
	Open @@SettDel
	Fetch Next From @@SettDel into @@DelSno,@@SettDelQty,@@Party_Code,@@XSett_No,@@XSett_Type
	While @@Fetch_Status = 0 And @@Qty > 0 	
	Begin
		
		If @@SettDelQty > 0 and @@Qty > 0 
		Begin
			If @@SettDelQty >= @@Qty 
			Begin
				/* Update the Record and Exit From current Loop */
				Update DematTrans Set Party_Code = @@Party_Code,DpName=@@XSett_No+@@XSett_Type Where SNo = @@SNo And Sett_No = @@Sett_No
				And IsIn = @@IsIn And SNo = @@SNo And DrCr = 'C' and 
				CltAccNo = @@BCltDpId And TrType = 904

				if @@SettDelQty > @@Qty 
				Begin
					If @@Exchg = 'BSE' 
					Begin
						insert into BSEDB.DBO.DelTrans 
						Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,@@Qty,FromNo,ToNo,CertNo,FolioNo,HolderName,Reason,DrCr,'D',OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
						From DelTrans Where SNo = @@DelSNo And BCltDpId = @@BCltDpId And CertNo = @@IsIn 
						And Party_Code = @@Party_Code And ISett_No = @@Sett_No and Filler2 = 1 And DrCr = 'D' 
	
						Update BSEDB.DBO.DelTrans Set Qty=@@SettDelQty-@@Qty Where SNo = @@DelSNo And BCltDpId = @@BCltDpId
						And CertNo = @@IsIn And Party_Code = @@Party_Code And ISett_No = @@Sett_No and 
						Filler2 = 1 And DrCr = 'D' 
					End
					Else
					Begin
						insert into MSAJAG.DBO.DelTrans 
						Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,@@Qty,FromNo,ToNo,CertNo,FolioNo,HolderName,Reason,DrCr,'D',OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
						From DelTrans Where SNo = @@DelSNo And BCltDpId = @@BCltDpId And CertNo = @@IsIn 
						And Party_Code = @@Party_Code And ISett_No = @@Sett_No and Filler2 = 1 And DrCr = 'D' 
		
						Update MSAJAG.DBO.DelTrans Set Qty=@@SettDelQty-@@Qty Where SNo = @@DelSNo And BCltDpId = @@BCltDpId
						And CertNo = @@IsIn And Party_Code = @@Party_Code And ISett_No = @@Sett_No and 
						Filler2 = 1 And DrCr = 'D' 
					End
					Select @@Qty = 0
				End
				Else	
				Begin	
					If @@Exchg = 'BSE' 
					Begin
						Update BSEDB.DBO.DelTrans Set Delivered = 'D' Where SNo = @@DelSNo And BCltDpId = @@BCltDpId
						And CertNo = @@IsIn And Party_Code = @@Party_Code And ISett_No = @@Sett_No and Filler2 = 1 
						And DrCr = 'D' 
					End
					Else
					Begin
						Update MSAJAG.DBO.DelTrans Set Delivered = 'D' Where SNo = @@DelSNo And BCltDpId = @@BCltDpId
						And CertNo = @@IsIn And Party_Code = @@Party_Code And ISett_No = @@Sett_No and Filler2 = 1 
						And DrCr = 'D' 
					End
					Select @@Qty = 0
				End 				
				Select @@SettDelQty = 0		
			End
			Else
			Begin
				/* Update the Record with @@Qty - @@SettDelQty and Fetch the Next 
				   Record From current Loop */
				Insert Into DematTrans Select Sett_No,Sett_Type,RefNo,TCode,TrType,@@Party_Code,Scrip_Cd,
				Series,@@SettDelQty,TrDate,CltAccNo,DpId,DpName=@@XSett_No+@@XSett_Type,IsIn,Branch_Cd,PartiPantCode,DpType,TransNo,
				DrCr,BDpType,BDpId,BCltAccNo,Filler1,Filler2,Filler3,Filler4,Filler5 From DematTrans 
				Where SNo = @@SNo And Sett_No = @@Sett_No And IsIn = @@IsIn And SNo = @@SNo And DrCr = 'C' 
				And CltAccNo = @@BCltDpId 
				
				Update DematTrans Set Qty = @@Qty-@@SettDelQty
				Where SNo = @@SNo And Sett_No = @@Sett_No And IsIn = @@IsIn And SNo = @@SNo And DrCr = 'C' 
				And CltAccNo = @@BCltDpId 
				
				If @@Exchg = 'BSE' 
				Begin			
					Update BSEDB.DBO.DelTrans Set Delivered = 'D' Where SNo = @@DelSNo And BCltDpId = @@BCltDpId
					And CertNo = @@IsIn 
					And Party_Code = @@Party_Code And ISett_No = @@Sett_No and Filler2 = 1 And DrCr = 'D'				
				End 
				Else				
				Begin			
					Update MSAJAG.DBO.DelTrans Set Delivered = 'D' Where SNo = @@DelSNo And BCltDpId = @@BCltDpId
					And CertNo = @@IsIn 
					And Party_Code = @@Party_Code And ISett_No = @@Sett_No and Filler2 = 1 And DrCr = 'D'				
				End 
				Select @@Qty = @@Qty-@@SettDelQty
				Select @@SettDelQty = 0		
			End
		End
		Fetch Next From @@SettDel into @@DelSno,@@SettDelQty,@@Party_Code,@@XSett_No,@@XSett_Type	
	End
	Close @@SettDel	
	DeAllocate @@SettDel
	Fetch Next From @@DematCur Into @@SNo,@@IsIn,@@Qty,@@TCode,@@TrDate,@@Sett_No,@@Sett_Type,@@BCltDpId,@@Exchg 
End
Close @@DematCur
DeAllocate @@DematCur

GO
