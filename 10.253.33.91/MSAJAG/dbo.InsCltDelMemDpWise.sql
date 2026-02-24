-- Object: PROCEDURE dbo.InsCltDelMemDpWise
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.InsCltDelMemDpWise    Script Date: 05/08/2002 12:35:03 PM ******/




/****** Object:  Stored Procedure dbo.InsCltDelMemDpWise    Script Date: 4/12/01 1:05:15 PM ******/
CREATE Proc InsCltDelMemDpWise ( @Sett_no Varchar(7),@Sett_Type Varchar(2),@RefNo int) as
Declare @@Scrip_Cd Varchar(12),
 @@Series Varchar(3),
 @@Party_code Varchar(10),
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
 @@DpId Varchar(5),
 @@PartiPantCode Varchar(12),
 @@PCount Int,
 @@RemQty Int,
 @@OldQty Int,
 @@QtyCur Cursor,
 @@DelClt Cursor,
 @@CertCur Cursor
Set @@DelClt = CurSor for
 select scrip_cd,series,D.Party_code,Qty,Depository,PartiPantCode from DeliveryClt D,Client4 C where inout = 'O'
 and sett_no = @Sett_No and Sett_Type = @Sett_Type
 and d.party_code = c.party_code and c.DefDp = 1 
 order by scrip_cd,series,qty,D.party_code,Depository desc
Open @@DelClt
fetch next from @@DelClt into @@Scrip_Cd,@@Series,@@Party_code,@@DelQty,@@DpId,@@PartiPantCode
While @@Fetch_status = 0 
begin
       set @@QtyCur = Cursor for 
       select Isnull(sum(qty),0) from DelTrans 
       where sett_no = @sett_no 
       and sett_type = @sett_type 
       and RefNo = @RefNo
       and party_code = @@party_code
       and scrip_cd  = @@scrip_cd 
       and series = @@series 
       and DrCr = 'D'  and Filler2 = 1 
       Open @@QtyCur 
       Fetch next from @@QtyCur into @@Qty   
       if @@DelQty > @@Qty
       Begin  
		select @@DelQty = @@DelQty - @@Qty
		Set @@CertCur = Cursor For
		select qty,certno, fromno,foliono,TDate=left(convert(varchar,TransDate,109),11),orgqty,Sno,TCode
		from DelTrans 
		where sett_no = @sett_no 
         		and sett_type = @sett_type 
         		and RefNo = @RefNo
         		and party_code = 'BROKER'
         		and scrip_cd  = @@scrip_cd 
       	 	and series = @@series 
	 	and DrCr = 'D' and PartiPantCode = @@PartiPantCode and TrType <> 1000		
         		and DpType = ( Case When ShareType = 'DEMAT' then @@DpId else 'PHY' end) and Filler2 = 1 
         		order by TransDate Asc,Qty Desc 
 		open @@CertCur
 		Fetch next from @@CertCur into @@TradeQty,@@certno,@@fromno,@@foliono,@@sdate,@@OrgQty,@@sno,@@TCode
 		if @@Fetch_Status = 0 
 		begin
	  		Select @@PCount = 0
	  		while @@PCount < @@DelQty and @@Fetch_Status = 0 
	  		begin
				Select @@PCount = @@PCount + @@TradeQty
				if @@PCount <= @@DelQty 
				begin    

					insert into deltrans(Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo
					,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5)
					select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo
					,HolderName,Reason,'C',Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,0,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
					from DelTrans Where sett_no  = @sett_no and sett_type = @sett_type
		     			and RefNo = @RefNo 
	      	     			AND SNO = @@SNo and TCode = @@TCode	
	     	     			and scrip_cd = @@Scrip_Cd and series = @@Series 
		     			and certno  = @@certno and fromno = @@fromno 
	   	     			and FolioNo = @@foliono and TransDate Like @@SDate + '%' 
   	             				and Party_Code = 'BROKER' 	
	   	             			and DrCr = 'D' and orgqty = @@orgqty and filler2 = 1

					insert into deltrans(Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo
					,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5)
					select Sett_No,Sett_type,RefNo,TCode, 904,@@party_code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo
					,HolderName,Reason,'D',Delivered,OrgQty,DpType,'','',BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,1,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
					from DelTrans Where sett_no  = @sett_no and sett_type = @sett_type
		     			and RefNo = @RefNo 
	      	     			AND SNO = @@SNo and TCode = @@TCode	
	     	     			and scrip_cd = @@Scrip_Cd and series = @@Series 
		     			and certno  = @@certno and fromno = @@fromno 
	   	     			and FolioNo = @@foliono and TransDate Like @@SDate + '%' 
   	             				and Party_Code = 'BROKER' 	
	   	             			and DrCr = 'D' and orgqty = @@orgqty and filler2 = 1
			
					update DelTrans set Filler2 = 0 
	     	     			where sett_no  = @sett_no and sett_type = @sett_type
		     			and RefNo = @RefNo 
	      	     			AND SNO = @@SNo and TCode = @@TCode	
	     	     			and scrip_cd = @@Scrip_Cd and series = @@Series 
		     			and certno  = @@certno and fromno = @@fromno 
	   	     			and FolioNo = @@foliono and TransDate Like @@SDate + '%' 
   	             				and Party_Code = 'BROKER' 	
	   	             			and DrCr = 'D' and orgqty = @@orgqty and filler2 = 1
					
		     			update DelTrans set Filler3 = 30
	     	     			where sett_no  = @sett_no and sett_type = @sett_type
		     			and RefNo = @RefNo and TCode = @@TCode	
	     	     			and scrip_cd = @@Scrip_Cd and series = @@Series 
		     			and certno  = @@certno And Filler2 = 1 	

				end    
   				else  
   				begin
    		     			select @@PCount = @@PCount - @@TradeQty
    		     			select @@RemQty = @@DelQty - @@PCount
    		     			select @@OldQty = @@TradeQty - @@RemQty
		     			select @@PCount = @@PCount + @@RemQty  
					
					insert into deltrans(Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo
					,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5)
					select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty=@@OldQty,FromNo,ToNo,CertNo,FolioNo
					,HolderName,Reason,'C',Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,0,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
					from DelTrans Where sett_no  = @sett_no and sett_type = @sett_type
		     			and RefNo = @RefNo 
	      	     			AND SNO = @@SNo and TCode = @@TCode	
	     	     			and scrip_cd = @@Scrip_Cd and series = @@Series 
		     			and certno  = @@certno and fromno = @@fromno 
	   	     			and FolioNo = @@foliono and TransDate Like @@SDate + '%' 
   	             				and Party_Code = 'BROKER' 	
	   	             			and DrCr = 'D' and orgqty = @@orgqty and filler2 = 1

					insert into deltrans(Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo
					,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5)
					select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty=@@OldQty,FromNo,ToNo,CertNo,FolioNo
					,HolderName,Reason,'D',Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,1,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
					from DelTrans Where sett_no  = @sett_no and sett_type = @sett_type
		     			and RefNo = @RefNo 
	      	     			AND SNO = @@SNo and TCode = @@TCode	
	     	     			and scrip_cd = @@Scrip_Cd and series = @@Series 
		     			and certno  = @@certno and fromno = @@fromno 
	   	     			and FolioNo = @@foliono and TransDate Like @@SDate + '%' 
   	             				and Party_Code = 'BROKER' 	
	   	             			and DrCr = 'D' and orgqty = @@orgqty and filler2 = 1


					insert into deltrans(Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo
					,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5)
					select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty=@@RemQty,FromNo,ToNo,CertNo,FolioNo
					,HolderName,Reason,'C',Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,0,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
					from DelTrans Where sett_no  = @sett_no and sett_type = @sett_type
		     			and RefNo = @RefNo 
	      	     			AND SNO = @@SNo and TCode = @@TCode	
	     	     			and scrip_cd = @@Scrip_Cd and series = @@Series 
		     			and certno  = @@certno and fromno = @@fromno 
	   	     			and FolioNo = @@foliono and TransDate Like @@SDate + '%' 
   	             				and Party_Code = 'BROKER' 	
	   	             			and DrCr = 'D' and orgqty = @@orgqty and filler2 = 1

					insert into deltrans(Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo
					,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5)
					select Sett_No,Sett_type,RefNo,TCode,904,@@Party_Code,scrip_cd,series,Qty=@@RemQty,FromNo,ToNo,CertNo,FolioNo
					,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,'','',BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,1,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
					from DelTrans
					where sett_no  = @sett_no and sett_type = @sett_type
   					and RefNo = @RefNo 
   					AND SNO = @@SNo and TCode = @@TCode	
   					and scrip_cd = @@Scrip_Cd and series = @@Series 
   					and certno  = @@certno and fromno = @@fromno 
   					and FolioNo = @@foliono and TransDate Like @@SDate + '%'
   					and Party_Code = 'BROKER' 
   					and DrCr = 'D' and orgqty = @@orgqty 
			
					update DelTrans set Filler2 = 0  , Filler3 = 40
	     	     			where sett_no  = @sett_no and sett_type = @sett_type
		     			and RefNo = @RefNo 
	      	     			AND SNO = @@SNo and TCode = @@TCode	
	     	     			and scrip_cd = @@Scrip_Cd and series = @@Series 
		     			and certno  = @@certno and fromno = @@fromno 
	   	     			and FolioNo = @@foliono and TransDate Like @@SDate + '%' 
   	             				and Party_Code = 'BROKER' 	
	   	             			and DrCr = 'D' and orgqty = @@orgqty and filler2 = 1
					
		     			update DelTrans set Filler3 = 30
	     	     			where sett_no  = @sett_no and sett_type = @sett_type
		     			and RefNo = @RefNo and TCode = @@TCode	
	     	     			and scrip_cd = @@Scrip_Cd and series = @@Series 
		     			and certno  = @@certno And Filler2 = 1 and Party_Code <> 'BROKER'
				end
				Fetch next from @@CertCur into @@TradeQty,@@certno,@@fromno,@@foliono,@@sdate,@@OrgQty,@@sno,@@TCode
	  		end
 		end
 		Close @@CertCur
 		DeAllocate @@CertCur 
      end
      Close @@QtyCur
      Deallocate @@QtyCur
      fetch next from @@DelClt into @@Scrip_Cd,@@Series,@@Party_code,@@DelQty,@@DpId,@@PartiPantCode
end
Close @@DelClt
Deallocate @@DelClt

Update DelTrans Set DpId = C.BankID, CltDpId = C.Cltdpid from Client4 c where C.party_Code  =  DelTrans.Party_Code
and Sett_no = @Sett_No and Sett_Type = @Sett_Type And DefDp =1 and DpId = '' and DpType = C.Depository and Filler2 = 1 and DrCr = 'D'

GO
