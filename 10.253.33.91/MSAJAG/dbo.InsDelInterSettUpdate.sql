-- Object: PROCEDURE dbo.InsDelInterSettUpdate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc InsDelInterSettUpdate(@RefNo int) As
Declare 
@@SNo int,
@@DelSNo int,
@@Party_Code Varchar(10),
@@Scrip_Cd Varchar(12),
@@Series Varchar(3),
@@Qty int,
@@TCode int,
@@TrDate Varchar(11),
@@Sett_No Varchar(7),
@@ISett_No Varchar(7),
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
Select SNo,Scrip_CD,D.Series,Qty,TCode,TrDate=Left(Convert(Varchar,TrDate,109),11),D.Sett_No,D.sett_Type,D.CltAccNo
From DematTrans D, Sett_Mst S Where D.CltAccNo = S.Sett_No And D.Sett_Type = S.Sett_Type And Party_Code = 'Party'
And BDpType = 'NSDL'
And RefNo = @RefNo
Order By Scrip_CD,D.Series,Qty Desc,D.Sett_No,D.sett_Type,D.CltAccNo
Open @@DematCur 
Fetch Next From @@DematCur Into @@SNo,@@Scrip_Cd,@@Series,@@Qty,@@TCode,@@TrDate,@@Sett_No,@@Sett_Type,@@ISett_No 
While @@Fetch_Status = 0
Begin	
	/* Taking Party's Sell Position for That Scrip from DeliveryClt Table. */
	Set @@SettDel = Cursor For
	Select SNO,Qty,Party_Code From DelTrans Where Sett_No = @@ISett_No
	And ISett_Type = @@Sett_Type And Scrip_Cd = @@Scrip_Cd And Series = @@Series  
	And ISett_No = @@Sett_No and Filler2 = 1 And DrCr = 'D' And RefNo = @RefNo and Delivered = 'G'
	And TrType = 907 And BDpType = 'NSDL'
	Order By Qty Desc,Party_Code
	Open @@SettDel
	Fetch Next From @@SettDel into @@DelSno,@@SettDelQty,@@Party_Code
	While @@Fetch_Status = 0 And @@Qty > 0 	
	Begin
		
		If @@SettDelQty > 0 and @@Qty > 0 
		Begin
			If @@SettDelQty >= @@Qty 
			Begin
				/* Update the Record and Exit From current Loop */

				Update DematTrans Set Party_Code = @@Party_Code Where SNo = @@SNo And Sett_No = @@Sett_No
				And Sett_Type = @@Sett_Type And Scrip_Cd = @@Scrip_Cd and Series = @@Series 
				And SNo = @@SNo And DrCr = 'C' and CltAccNo = @@ISett_No And TrType = 907 And RefNo = @RefNo
				
				if @@SettDelQty > @@Qty 
				Begin
					insert into DelTrans 
					Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,@@Qty,FromNo,ToNo,CertNo,FolioNo,HolderName,Reason,DrCr,'D',OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
					From DelTrans Where SNo = @@DelSNo And Sett_No = @@ISett_No
					And ISett_Type = @@Sett_Type And Scrip_Cd = @@Scrip_Cd and Series = @@Series 
					And Party_Code = @@Party_Code And ISett_No = @@Sett_No and Filler2 = 1 And DrCr = 'D' And RefNo = @RefNo

					Update DelTrans Set Qty=@@SettDelQty-@@Qty Where SNo = @@DelSNo And Sett_No = @@ISett_No
					And ISett_Type = @@Sett_Type And Scrip_Cd = @@Scrip_Cd and Series = @@Series 
					And Party_Code = @@Party_Code And ISett_No = @@Sett_No and Filler2 = 1 And DrCr = 'D' And RefNo = @RefNo
					Select @@Qty = 0	
				End
				Else	
				Begin	
					Update DelTrans Set Delivered = 'D' Where SNo = @@DelSNo And Sett_No = @@ISett_No
					And ISett_Type = @@Sett_Type And Scrip_Cd = @@Scrip_Cd and Series = @@Series 
					And Party_Code = @@Party_Code And ISett_No = @@Sett_No and Filler2 = 1 And DrCr = 'D' And RefNo = @RefNo
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
				Where SNo = @@SNo And Sett_No = @@Sett_No And Sett_Type = @@Sett_Type And 
				Scrip_Cd = @@Scrip_Cd and Series = @@Series And SNo = @@SNo And DrCr = 'C' 
				And CltAccNo = @@ISett_No And TrType = 907 And RefNo = @RefNo
				
				Update DematTrans Set Qty = @@Qty-@@SettDelQty
				Where SNo = @@SNo And Sett_No = @@Sett_No And Sett_Type = @@Sett_Type And 
				Scrip_Cd = @@Scrip_Cd and Series = @@Series And SNo = @@SNo And DrCr = 'C' 
				And CltAccNo = @@ISett_No And TrType = 907 And RefNo = @RefNo

				Update DelTrans Set Delivered = 'D' Where SNo = @@DelSNo And Sett_No = @@ISett_No
				And ISett_Type = @@Sett_Type And Scrip_Cd = @@Scrip_Cd and Series = @@Series 
				And Party_Code = @@Party_Code And ISett_No = @@Sett_No and Filler2 = 1 And DrCr = 'D'				
				And RefNo = @RefNo

				Select @@Qty = @@Qty-@@SettDelQty
				Select @@SettDelQty = 0		
			End
		End
		Fetch Next From @@SettDel into @@DelSno,@@SettDelQty,@@Party_Code	
	End
	Close @@SettDel	
	DeAllocate @@SettDel
	Fetch Next From @@DematCur Into @@SNo,@@Scrip_Cd,@@Series,@@Qty,@@TCode,@@TrDate,@@Sett_No,@@Sett_Type,@@ISett_No 
End
Close @@DematCur
DeAllocate @@DematCur

GO
