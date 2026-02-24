-- Object: PROCEDURE dbo.InsNseDelAllocate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.InsNseDelAllocate    Script Date: 4/12/01 1:05:15 PM ******/
CREATE Proc InsNseDelAllocate (@Sett_No Varchar(7),@Sett_Type Varchar(2),@RefNo int,@ScripCd Varchar(12),@Series Varchar(3),@EntityCode Varchar(10),@DelQty int,@CQty int,@TrType int) As
Declare @@Qty int,
 @@CertNo Varchar(15),
 @@FromNo Varchar(15),
 @@FolioNo Varchar(15),
 @@Date Varchar(11),
 @@SNo numeric(18,0),
 @@TCode numeric(18,0),
 @@OrgQty int,
 @@PCount int,
 @@DelMov Cursor
 Set @@DelMov = Cursor For 
	 select qty,certno, fromno,foliono,TDate=left(convert(varchar,TransDate,109),11),orgqty,Sno,TCode 
	 from DelTrans , DelSegment
	 where sett_no = @sett_no
         and sett_type = @sett_type 
	 and DelTrans.RefNo = @RefNo
	 and TrType = @TrType
         and scrip_cd = @ScripCd 
         and series = @Series 
         and Party_Code = 'BROKER' 
	 and DrCr = 'D' and Filler2 = 1 And DelTrans.BDpType Like (Case When AllocationType = 0 Then '%' Else 'CDSL' End )
 order by DelTrans.BDpType Desc,TransDate , foliono , certno, qty desc 
 Open @@DelMov
 Fetch Next From @@DelMov into @@Qty,@@CertNo,@@FromNo,@@FolioNo,@@Date,@@OrgQty,@@SNo,@@TCode

 if @@Fetch_Status = 0 
 Begin
  Select @@PCount = 0  
  while @@PCount < @DelQty and @@Fetch_Status = 0 
  Begin
   	Select @@PCount = @@PCount + @@Qty
    if @@PCount > @DelQty 
    Begin

	insert into deltrans(Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo
	,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5)
	select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty=@@PCount-@DelQty,FromNo,ToNo,CertNo,FolioNo
	,HolderName,Reason,'C',Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,0,0,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
	from DelTrans
   	where sett_no  = @sett_no and sett_type = @sett_type
   	and RefNo = @RefNo and TrType = @TrType
   	AND SNO = @@SNo and TCode = @@TCode	
   	and scrip_cd = @ScripCd and series = @Series 
   	and certno  = @@certno and fromno = @@fromno 
   	and FolioNo = @@foliono and TransDate Like @@Date + '%'
   	and Party_Code = 'BROKER' 
   	and DrCr = 'D' and orgqty = @@orgqty

	insert into deltrans(Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo
	,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5)
	select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty=@@PCount-@DelQty,FromNo,ToNo,CertNo,FolioNo
	,HolderName,Reason,'D',Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,0,1,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
	from DelTrans
	where sett_no  = @sett_no and sett_type = @sett_type
   	and RefNo = @RefNo and TrType = @TrType
   	AND SNO = @@SNo and TCode = @@TCode	
   	and scrip_cd = @ScripCd and series = @Series 
   	and certno  = @@certno and fromno = @@fromno 
   	and FolioNo = @@foliono and TransDate Like @@Date + '%'
   	and Party_Code = 'BROKER' 
   	and DrCr = 'D' and orgqty = @@orgqty

	insert into deltrans(Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo
	,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5)
	select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty=@@qty-@@PCount+@DelQty,FromNo,ToNo,CertNo,FolioNo
	,HolderName,Reason,'C',Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,0,0,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
	from DelTrans
	where sett_no  = @sett_no and sett_type = @sett_type
   	and RefNo = @RefNo and TrType = @TrType
   	AND SNO = @@SNo and TCode = @@TCode	
   	and scrip_cd = @ScripCd and series = @Series 
   	and certno  = @@certno and fromno = @@fromno 
   	and FolioNo = @@foliono and TransDate Like @@Date + '%'
   	and Party_Code = 'BROKER' 
   	and DrCr = 'D' and orgqty = @@orgqty

	insert into deltrans(Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo
	,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5)
	select Sett_No,Sett_type,RefNo,TCode,906,@EntityCode,scrip_cd,series,Qty=@@qty-@@PCount+@DelQty,FromNo,ToNo,CertNo,FolioNo
	,HolderName,Reason,'D',Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,0,1,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
	from DelTrans
	where sett_no  = @sett_no and sett_type = @sett_type
   	and RefNo = @RefNo and TrType = @TrType
   	AND SNO = @@SNo and TCode = @@TCode	
   	and scrip_cd = @ScripCd and series = @Series 
   	and certno  = @@certno and fromno = @@fromno 
   	and FolioNo = @@foliono and TransDate Like @@Date + '%'
   	and Party_Code = 'BROKER' 
   	and DrCr = 'D' and orgqty = @@orgqty

	update DelTrans set Filler2 = 0 ,Filler3 = 40
   	where sett_no  = @sett_no and sett_type = @sett_type
   	and RefNo = @RefNo and TrType = @TrType
   	AND SNO = @@SNo and TCode = @@TCode	
   	and scrip_cd = @ScripCd and series = @Series 
   	and certno  = @@certno and fromno = @@fromno 
   	and FolioNo = @@foliono and TransDate Like @@Date + '%'
   	and Party_Code = 'BROKER' 
   	and DrCr = 'D' and orgqty = @@orgqty

	update DelTrans set Filler3 = 30
   	where sett_no  = @sett_no and sett_type = @sett_type
   	and RefNo = @RefNo and TrType = @TrType
   	AND SNO = @@SNo and TCode = @@TCode	
   	and scrip_cd = @ScripCd and series = @Series 
   	and certno  = @@certno and fromno = @@fromno 
   	and FolioNo = @@foliono and TransDate Like @@Date + '%'   	
   	and DrCr = 'D' and orgqty = @@orgqty and Filler2 = 1

    end
    else
    Begin

	insert into deltrans(Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo
	,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5)
	select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo
	,HolderName,Reason,'C',Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,0,0,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
	from DelTrans
   	where sett_no  = @sett_no and sett_type = @sett_type
   	and RefNo = @RefNo and TrType = @TrType
   	AND SNO = @@SNo and TCode = @@TCode	
   	and scrip_cd = @ScripCd and series = @Series 
   	and certno  = @@certno and fromno = @@fromno 
   	and FolioNo = @@foliono and TransDate Like @@Date + '%'
   	and Party_Code = 'BROKER' 
   	and DrCr = 'D' and orgqty = @@orgqty

	insert into deltrans(Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo
	,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5)
	select Sett_No,Sett_type,RefNo,TCode,906,@EntityCode,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo
	,HolderName,Reason,'D',Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,0,1,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
	from DelTrans
   	where sett_no  = @sett_no and sett_type = @sett_type

   	and RefNo = @RefNo and TrType = @TrType
   	AND SNO = @@SNo and TCode = @@TCode	
   	and scrip_cd = @ScripCd and series = @Series 
   	and certno  = @@certno and fromno = @@fromno 
   	and FolioNo = @@foliono and TransDate Like @@Date + '%'
   	and Party_Code = 'BROKER' 
   	and DrCr = 'D' and orgqty = @@orgqty

     	update DelTrans set Filler2 = 0
   	where sett_no  = @sett_no and sett_type = @sett_type
   	and RefNo = @RefNo and TrType = @TrType
   	AND SNO = @@SNo and TCode = @@TCode	
   	and scrip_cd = @ScripCd and series = @Series 
   	and certno  = @@certno and fromno = @@fromno 
   	and FolioNo = @@foliono and TransDate Like @@Date + '%'
   	and Party_Code = 'BROKER' 
   	and DrCr = 'D' and orgqty = @@orgqty

    End
   Fetch Next From @@DelMov into @@Qty,@@CertNo,@@FromNo,@@FolioNo,@@Date,@@OrgQty,@@SNo,@@TCode
  end
  Close @@DelMov
  DeAllocate @@DelMov
 end

GO
