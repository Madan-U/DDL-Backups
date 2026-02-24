-- Object: PROCEDURE dbo.InsDematNseCursor
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.InsDematNseCursor    Script Date: 05/08/2002 3:33:24 PM ******/

/****** Object:  Stored Procedure dbo.InsDematNseCursor    Script Date: 05/02/2002 3:42:18 PM ******/

/****** Object:  Stored Procedure dbo.InsDematNseCursor    Script Date: 01/24/2002 14:26:29 ******/



/****** Object:  Stored Procedure dbo.InsDematNseCursor    Script Date: 4/12/01 1:05:15 PM ******/
CREATE Proc InsDematNseCursor ( @RefNo int) As

Insert Into DelTrans
Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,M.scrip_cd,M.series,Qty,TransNo,TransNo,D.IsIn,TransNo,'',
'Pay-Out','C','0',Qty,DpType,DpId,CltAccNo,Branch_Cd,PartipantCode,0,'','','','DEMAT',
TrDate,Filler1,1,Filler3,BDpType,BDpId,BCltAccNo,filler4,filler5
From DematTrans D, MultiIsIn M Where TrType = 906 And DrCr = 'C' And M.IsIn = D.IsIn

Insert Into DelTrans
Select Sett_No,Sett_type,RefNo,TCode,904,'BROKER',M.scrip_cd,M.series,Qty,TransNo,TransNo,D.IsIn,TransNo,'',
'Pay-Out','D','0',Qty,DpType,DpId,CltAccNo,Branch_Cd,PartipantCode,0,'','','','DEMAT',
TrDate,Filler1,1,Filler3,BDpType,BDpId,BCltAccNo,filler4,filler5
From DematTrans D, MultiIsIn M Where TrType = 906 And DrCr = 'C' And M.IsIn = D.IsIn

Delete from DematTrans Where TrType = 906 And DrCr = 'C' And IsIn = ( Select IsIn From MultiIsIn Where Scrip_cd = DematTrans.Scrip_cd And Series = DematTrans.Series  And IsIn = DematTrans.IsIn) 

Exec InsNseDematOutCursor

/*
Declare 
 @@SerialNo numeric(18,0),	
 @@Sno varchar(7),
 @@SType Varchar(2),
 @@PartyCd Varchar(10),
 @@ScripCd Varchar(12),
 @@Series Varchar(3),
 @@BankCode Varchar(30),
 @@Isin Varchar(12),
 @@CltAccNo Varchar(16),
 @@TransNo Varchar(15),
 @@InOut Varchar(1),
 @@DematQty int,
 @@CertQty int,
 @@DeliverQty int,
 @@RemQty int,
 @@ExcessQty int,
 @@DematCur Cursor, 
 @@DematMov Cursor,
@@Filler1 varchar(100)

Set @@DematCur = Cursor For
 select sett_no ,sett_type,party_code , scrip_cd , series ,qty ,
 DpId ,isin ,cltaccno, TransNo,Sno,filler1  from demattrans where TrType = 906
 and DrCr = 'C' and RefNo = @RefNo  
 order by sett_no, sett_Type,party_Code,scrip_Cd
Open @@DematCur
Fetch next from @@DematCur into @@Sno,@@SType,@@PartyCd,@@ScripCd,@@Series,@@DematQty,@@BankCode,@@Isin,@@CltAccNo,@@TransNo,@@SerialNo ,@@filler1
While @@Fetch_Status = 0
Begin

 Set @@DematMov = Cursor For
  select IsNull(sum(qty),0) from DelTrans 
  where  Scrip_cd = @@ScripCd And TrType = 906
  and series = @@Series and sett_no = @@SNo And Filler2 = 1
  and sett_type = @@SType and DrCr = 'C' and RefNo = @RefNo 
 Open @@DematMov
 Fetch Next From @@DematMov into @@CertQty
 Close @@DematMov
 DeAllocate @@DematMov

 Set @@DematMov = Cursor For
  select IsNull(sum(qty),0) from DelNet
  where scrip_cd = @@ScripCd and series = @@Series and sett_no = @@SNo
  and sett_type = @@SType and InOut = 'O'
 Open @@DematMov
 Fetch Next From @@DematMov into @@DeliverQty
 Close @@DematMov
 DeAllocate @@DematMov

 Select @@RemQty = @@DeliverQty - @@CertQty

 Set @@DematMov = Cursor For
  select IsNull(sum(qty),0) from DelTrans 
  where  scrip_cd = @@ScripCd And TrType = 906
  and series = @@Series and sett_no = @@SNo And Filler2 = 1
  and sett_type = @@SType and DrCr = 'D' and RefNo = @RefNo 
 Open @@DematMov
 Fetch Next From @@DematMov into @@CertQty
 Close @@DematMov
 DeAllocate @@DematMov
 
 Select @@RemQty = @@RemQty + @@CertQty  

 if @@RemQty >= @@DematQty
 Begin 

	  insert into deltrans(Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo
	,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,filler4,filler5)

	Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,@@transno,'',isin,@@transno
        ,'','PAY_OUT','C','0',Qty,DpType,DpId,CltAccNo,Branch_Cd,PartipantCode,0,'','','','DEMAT',trdate,@@Filler1,1,0,BDpType,BDpId,BCltAccNo,0,0
	from DematTrans where party_code = @@PartyCd and scrip_cd = @@ScripCd
         and series = @@Series and sett_no = @@Sno and transno = @@transno and DrCr = 'C' and RefNo = @RefNo and Sno = @@SerialNo

  insert into deltrans(Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo
	,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,filler4,filler5)
	Select Sett_No,Sett_type,RefNo,TCode,904,'BROKER',scrip_cd,series,Qty,@@transno,'',isin,@@transno
        ,'','PAY_OUT','D','0',Qty,DpType,DpId,CltAccNo,Branch_Cd,PartipantCode,0,'','','','DEMAT',trdate,@@Filler1,1,0,BDpType,BDpId,BCltAccNo,0,0
	from DematTrans where party_code = @@PartyCd and scrip_cd = @@ScripCd
         and series = @@Series and sett_no = @@Sno and transno = @@transno and DrCr = 'C' and RefNo = @RefNo and Sno = @@SerialNo

  delete from DematTrans where party_code = @@PartyCd and scrip_cd = @@ScripCd
         and series = @@Series and sett_no = @@Sno and transno = @@transno and DrCr = 'C' and RefNo = @RefNo and Sno = @@SerialNo
 End
 Else If (@@remqty <= @@dematqty And @@remqty > 0)
 Begin
  Select @@excessqty = @@dematqty - @@remqty
  insert into deltrans(Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo
	,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,filler4,filler5)
	Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,@@remqty,@@transno,'',isin,@@transno
        ,'','PAY_OUT','C','0',Qty,DpType,DpId,CltAccNo,Branch_Cd,PartipantCode,0,'','','','DEMAT',trdate,@@Filler1,1,0,BDpType,BDpId,BCltAccNo,0,0

	from DematTrans where party_code = @@PartyCd and scrip_cd = @@ScripCd
         and series = @@Series and sett_no = @@Sno and transno = @@transno and DrCr = 'C' and RefNo = @RefNo and Sno = @@SerialNo

  insert into deltrans(Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo
	,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,filler4,filler5)
	Select Sett_No,Sett_type,RefNo,TCode,904,'BROKER',scrip_cd,series,@@remqty,@@transno,'',isin,@@transno
        ,'','PAY_OUT','D','0',Qty,DpType,DpId,CltAccNo,Branch_Cd,PartipantCode,0,'','','','DEMAT',trdate,@@Filler1,1,0,BDpType,BDpId,BCltAccNo,0,0
	from DematTrans where party_code = @@PartyCd and scrip_cd = @@ScripCd
         and series = @@Series and sett_no = @@Sno and transno = @@transno and DrCr = 'C' and RefNo = @RefNo and Sno = @@SerialNo

  update DematTrans set qty = @@ExcessQty where party_code = @@PartyCd and scrip_cd = @@ScripCd
         and series = @@Series and sett_no = @@Sno and transno = @@transno and DrCr = 'C' and RefNo = @RefNo and Sno = @@SerialNo
 End
 Fetch next from @@DematCur into @@Sno,@@SType,@@PartyCd,@@ScripCd,@@Series,@@DematQty,@@BankCode,@@Isin,@@CltAccNo,@@TransNo,@@SerialNo,@@filler1
End
Close @@DematCur
DeAllocate @@DematCur
*/

GO
