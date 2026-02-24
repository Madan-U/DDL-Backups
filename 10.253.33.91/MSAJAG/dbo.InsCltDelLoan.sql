-- Object: PROCEDURE dbo.InsCltDelLoan
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc InsCltDelLoan ( @Sett_no Varchar(7),@Sett_Type Varchar(2),@RefNo int) as
Declare @@Scrip_Cd Varchar(12),
 @@Series Varchar(3),
 @@FromParty Varchar(10),
 @@ToParty Varchar(10),
 @@DelQty int,
 @@Qty Int,
 @@TradeQty int,
 @@CertNo Varchar(15),
 @@FromNo Varchar(15),
 @@FolioNo Varchar(15),
 @@Reason Varchar(25),
 @@TCode Numeric(18,0),
 @@CertParty Varchar(10),
 @@OrgQty int,
 @@SDate Varchar(11),
 @@SNo Numeric(18,0),
 @@Flag varchar(1),
 @@PCount Int,
 @@RemQty Int,
 @@OldQty Int,
 @@Exg Varchar(3),
 @@QtyCur Cursor,
 @@DelClt Cursor,
 @@CertCur Cursor
Set @@DelClt = CurSor for
 Select M.Scrip_Cd,M.Series,FromParty,TradeQty=Sum(Case When LoanFlag = 'LG' Then Qty Else -Qty End),ToParty,Exg='NSE' From DelLoan M
 Where LoanFlag Like 'L%'
 Group By M.Scrip_Cd,M.Series,FromParty,ToParty
 Having Sum(Case When LoanFlag = 'LG' Then Qty Else -Qty End ) > 0 	
 Union All
 Select M.Scrip_Cd,M.Series,FromParty,TradeQty=Sum(Case When LoanFlag = 'LG' Then Qty Else -Qty End),ToParty,Exg='BSE' 
 From BSEDB.DBO.DelLoan D, BSEDB.DBO.MultiIsIn BM , MultiIsIn M
 Where LoanFlag Like 'L%'
 And M.IsIn = BM.IsIn And M.Valid = 1 And BM.Valid = 1 	
 And Bm.Scrip_Cd = D.Scrip_CD And BM.Series = D.Series
 Group By M.Scrip_Cd,M.Series,FromParty,ToParty
 Having Sum(Case When LoanFlag = 'LG' Then Qty Else -Qty End ) > 0 	
 order by Scrip_Cd,Series,FromParty,ToParty
Open @@DelClt
fetch next from @@DelClt into @@Scrip_Cd,@@Series,@@FromParty,@@DelQty,@@ToParty,@@Exg

While @@Fetch_status = 0 
begin
       set @@QtyCur = Cursor for 
       select Isnull(sum(qty),0) from DelTrans 
       where sett_no = @sett_no 
       and sett_type = @sett_type 
       and RefNo = @RefNo
       and party_code = @@ToParty
       and scrip_cd  = @@scrip_cd 
       and series = @@series 
       and DrCr = 'D' And Filler2 = 1 
       And Delivered = '0' And TrType = 904
       Open @@QtyCur 
       Fetch Next From @@QtyCur into @@Qty   
       if @@DelQty >= @@Qty And @@Qty > 0 And @@DelQty > 0 
       Begin  
		Insert into DelTrans
		Select Sett_No,Sett_type,RefNo,TCode, 904,@@FromParty,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo,
	        	HolderName='Loan Rec From ' + @@ToParty,Reason='Loan Rec From ' + @@ToParty,'C',
		'0',OrgQty,'','','',BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,
		TransDate,Filler1,1,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
		From DelTrans
		where sett_no = @sett_no 
                and sett_type = @sett_type 
                and RefNo = @RefNo
                and party_code = @@ToParty
                and scrip_cd  = @@scrip_cd 
                and series = @@series 
                and DrCr = 'D' And Filler2 = 1 
                And Delivered = '0' And TrType = 904

		Insert into DelTrans
		Select Sett_No,Sett_type,RefNo,TCode, 904,@@FromParty,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo,
	        	HolderName='Loan Rec From ' + @@ToParty,Reason='Loan Rec From ' + @@ToParty,'D',
		Delivered,OrgQty,'','','',BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,
		TransDate,Filler1,1,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
		From DelTrans
		where sett_no = @sett_no 
                and sett_type = @sett_type 
                and RefNo = @RefNo
                and party_code = @@ToParty
                and scrip_cd  = @@scrip_cd 
                and series = @@series 
                and DrCr = 'D' And Filler2 = 1 
                And Delivered = '0' And TrType = 904

		Update DelTrans Set HolderName = 'Loan Return To ' + @@FromParty, Reason = 'Loan Return To ' + @@FromParty, Delivered = 'D'
		where sett_no = @sett_no 
                and sett_type = @sett_type 
                and RefNo = @RefNo
                and party_code = @@ToParty
                and scrip_cd  = @@scrip_cd 
                and series = @@series 
                and DrCr = 'D' And Filler2 = 1 
                And Delivered = '0' And TrType = 904

		If @@Exg = 'NSE'
	 		Insert Into DelLoan Values (@@FromParty,@@Scrip_Cd,@@Series,@@Qty,@@ToParty,@Sett_No,@Sett_Type,'LR',@Sett_no,@Sett_Type,Left(GetDate(),11))		
		Else
	 		Insert Into BSEDB.DBO.DelLoan Values (@@FromParty,@@Scrip_Cd,@@Series,@@Qty,@@ToParty,@Sett_No,@Sett_Type,'LR',@Sett_no,@Sett_Type,Left(GetDate(),11))		
	End
	Else
	Begin
		Set @@CertCur = Cursor For
		Select Qty,CertNo,FromNo,FolioNo,SNo,TCode From DelTrans
		where sett_no = @sett_no 
	        and sett_type = @sett_type 
	        and RefNo = @RefNo
	        and party_code = @@ToParty
	        and scrip_cd  = @@scrip_cd 
	        and series = @@series 
	        and DrCr = 'D' And Filler2 = 1 
	        And Delivered = '0' And TrType = 904				
		order by Qty Desc 
 		open @@CertCur
		Fetch Next From @@CertCur into @@TradeQty,@@CertNo,@@FromNo,@@FolioNo,@@SNo,@@TCode
		if @@Fetch_Status = 0 
 		begin
			Select @@PCount = 0
	  		while @@PCount < @@DelQty and @@Fetch_Status = 0 
	  		begin
				Select @@PCount = @@PCount + @@TradeQty				
				if @@PCount <= @@DelQty 
				begin
					Insert into DelTrans
					Select Sett_No,Sett_type,RefNo,TCode, 904,@@FromParty,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo,
				        HolderName='Loan Rec From ' + @@ToParty,Reason='Loan Rec From ' + @@ToParty,'C',
					'0',OrgQty,'','','',BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,
					TransDate,Filler1,1,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
					From DelTrans
					where sett_no = @sett_no 
			                and sett_type = @sett_type 
			                and RefNo = @RefNo
			                and party_code = @@ToParty
			                and scrip_cd  = @@scrip_cd 
			                and series = @@series 
			                and DrCr = 'D' And Filler2 = 1 
			                And Delivered = '0' And TrType = 904
					And SNo = @@SNo And CertNo = @@CertNo And FromNo = @@FromNo 
					And FolioNo = @@FolioNo And TCode = @@TCode

					Insert into DelTrans
					Select Sett_No,Sett_type,RefNo,TCode, 904,@@FromParty,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo,
				        HolderName='Loan Rec From ' + @@ToParty,Reason='Loan Rec From ' + @@ToParty,'D',
					Delivered,OrgQty,'','','',BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,
					TransDate,Filler1,1,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
					From DelTrans
					where sett_no = @sett_no 
			                and sett_type = @sett_type 
			                and RefNo = @RefNo
			                and party_code = @@ToParty
			                and scrip_cd  = @@scrip_cd 
			                and series = @@series 
			                and DrCr = 'D' And Filler2 = 1 
			                And Delivered = '0' And TrType = 904
					And SNo = @@SNo And CertNo = @@CertNo And FromNo = @@FromNo 
					And FolioNo = @@FolioNo And TCode = @@TCode

					Update DelTrans Set HolderName = 'Loan Return To ' + @@FromParty, Reason = 'Loan Return To ' + @@FromParty, Delivered = 'D'
					where sett_no = @sett_no 
			                and sett_type = @sett_type 
			                and RefNo = @RefNo
			                and party_code = @@ToParty
			                and scrip_cd  = @@scrip_cd 
			                and series = @@series 
			                and DrCr = 'D' And Filler2 = 1 
			                And Delivered = '0' And TrType = 904	    		
					And SNo = @@SNo And CertNo = @@CertNo And FromNo = @@FromNo 
					And FolioNo = @@FolioNo And TCode = @@TCode
				End						
				Else
				Begin
					select @@PCount = @@PCount - @@TradeQty
    		     			select @@RemQty = @@DelQty - @@PCount
    		     			select @@OldQty = @@TradeQty - @@RemQty
		     			select @@PCount = @@PCount + @@RemQty  

					Insert into DelTrans
					Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,@@OldQty,FromNo,ToNo,CertNo,FolioNo,
				        HolderName,Reason,'D',
					Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,
					TransDate,Filler1,1,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
					From DelTrans
					where sett_no = @sett_no 
			                and sett_type = @sett_type 
			                and RefNo = @RefNo
			                and party_code = @@ToParty
			                and scrip_cd  = @@scrip_cd 
			                and series = @@series 
			                and DrCr = 'D' And Filler2 = 1 
			                And Delivered = '0' And TrType = 904
					And SNo = @@SNo And CertNo = @@CertNo And FromNo = @@FromNo 
					And FolioNo = @@FolioNo And TCode = @@TCode											

					Insert into DelTrans
					Select Sett_No,Sett_type,RefNo,TCode, 904,@@FromParty,scrip_cd,series,@@RemQty,FromNo,ToNo,CertNo,FolioNo,
				        HolderName='Loan Rec From ' + @@ToParty,Reason='Loan Rec From ' + @@ToParty,'C',
					'0',OrgQty,'','','',BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,
					TransDate,Filler1,1,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
					From DelTrans
					where sett_no = @sett_no 
			                and sett_type = @sett_type 
			                and RefNo = @RefNo
			                and party_code = @@ToParty
			                and scrip_cd  = @@scrip_cd 
			                and series = @@series 
			                and DrCr = 'D' And Filler2 = 1 
			                And Delivered = '0' And TrType = 904
					And SNo = @@SNo And CertNo = @@CertNo And FromNo = @@FromNo 
					And FolioNo = @@FolioNo And TCode = @@TCode

					Insert into DelTrans
					Select Sett_No,Sett_type,RefNo,TCode, 904,@@FromParty,scrip_cd,series,@@RemQty,FromNo,ToNo,CertNo,FolioNo,
				        HolderName='Loan Rec From ' + @@ToParty,Reason='Loan Rec From ' + @@ToParty,'D',
					Delivered,OrgQty,'','','',BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,
					TransDate,Filler1,1,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
					From DelTrans
					where sett_no = @sett_no 
			                and sett_type = @sett_type 
			                and RefNo = @RefNo
			                and party_code = @@ToParty
			                and scrip_cd  = @@scrip_cd 
			                and series = @@series 
			                and DrCr = 'D' And Filler2 = 1 
			                And Delivered = '0' And TrType = 904
					And SNo = @@SNo And CertNo = @@CertNo And FromNo = @@FromNo 
					And FolioNo = @@FolioNo And TCode = @@TCode

					Update DelTrans Set HolderName = 'Loan Return To ' + @@FromParty, Reason = 'Loan Return To ' + @@FromParty, 
					Delivered = 'D', Qty = @@RemQty
					where sett_no = @sett_no 
			                and sett_type = @sett_type 
			                and RefNo = @RefNo
			                and party_code = @@ToParty
			                and scrip_cd  = @@scrip_cd 
			                and series = @@series 
			                and DrCr = 'D' And Filler2 = 1 
			                And Delivered = '0' And TrType = 904	    		
					And SNo = @@SNo And CertNo = @@CertNo And FromNo = @@FromNo 
					And FolioNo = @@FolioNo And TCode = @@TCode
				End
				Fetch Next From @@CertCur into @@TradeQty,@@CertNo,@@FromNo,@@FolioNo,@@SNo,@@TCode
			End
			If @@Exg = 'NSE'
				Insert Into DelLoan Values (@@FromParty,@@Scrip_Cd,@@Series,@@DelQty,@@ToParty,@Sett_No,@Sett_Type,'LR',@Sett_no,@Sett_Type,Left(GetDate(),11))
			Else
				Insert Into DelLoan Values (@@FromParty,@@Scrip_Cd,@@Series,@@DelQty,@@ToParty,@Sett_No,@Sett_Type,'LR',@Sett_no,@Sett_Type,Left(GetDate(),11))	
		End
	End
	fetch next from @@DelClt into @@Scrip_Cd,@@Series,@@FromParty,@@DelQty,@@ToParty,@@Exg
End
	
Close @@DelClt
Deallocate @@DelClt

Update DelTrans Set  DpType = C.Depository,DpId = C.BankID, CltDpId = C.Cltdpid from Client4 c where C.party_Code  =  DelTrans.Party_Code
and Sett_no = @Sett_No and Sett_Type = @Sett_Type And DefDp =1 and DpId = '' and Filler2 = 1 and DrCr = 'D'
And Delivered = '0' And TrType = 904 And Reason Like 'Loan%'

GO
