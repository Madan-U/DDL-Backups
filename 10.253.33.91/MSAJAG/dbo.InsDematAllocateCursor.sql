-- Object: PROCEDURE dbo.InsDematAllocateCursor
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc InsDematAllocateCursor (@RefNo int) As
Declare
 @@SerialNo Numeric(18,0),	
 @@Sno Varchar(7),
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
 @@ExecDate varchar(20),
 @@CertQty int,
 @@DeliverQty int,
 @@RemQty int,
 @@ExcessQty int,
 @@BranchCd varchar(10),         
 @@PartipantCode varchar(10),  
 @@TCode Numeric(18,0),
 @@TrType Numeric(18,0),
 @@DpType Varchar(10),
 @@DpName Varchar(25),
 @@DematCur Cursor, 
 @@DematMov Cursor,
 @@BDpType Varchar(5),
 @@BDpId Varchar(16),
 @@BCltDpId varchar(16),
 @@Filler1 Varchar(100)

delete from DematTrans where DrCr = 'D' and DpId <> 'Pay-Out' and RefNo = @RefNo

Update DematTrans Set DpId = Left(CltAccNo,8) From DematTrans where Len(CltAccNo) = 16
And DpId <> Left(CltAccNo,8)

Update DematTrans Set DpName = '' where DpName Is Null

/*
update demattrans set Sett_no = s.sett_no,sett_type = s.sett_Type from sett_mst s where
Sec_Payin >= trdate and Sec_Payout <= trdate + ' 23:59:59'
and DematTrans.sett_no = '9999999' and DematTrans.sett_type = 'No'
and s.sett_Type = 'N'
*/

Exec InsDelSettNoUpdate @RefNo 					   
Exec InsDelInterSettUpdate @RefNo
Exec InsDelInterSettUpdateInDpExBen
Exec InsDelInterSettUpdateInEx 
Exec InsDelInterSettUpdateInPool

update DematTrans set scrip_cd = s2.scrip_cd,Series=S2.Series  
from multiisin s2, DematTrans d Where s2.isin = d.isin and RefNo = @RefNo
Set @@DematCur = Cursor For
 	select distinct sno,d.sett_no ,d.sett_type,d.party_code , d.scrip_cd , d.series ,d.qty ,
	d.DpId ,d.isin,d.DrCr ,d.cltaccno, d.TransNo , d.TrDate,D.Branch_Cd,D.PartipantCode,TCode,TrType,DpType,BDpType,BDpId,BCltAccNo,Filler1,dpname from DematTrans d 
	where d.party_code not in ('Party','BSE', 'NSE','') and RefNo = @RefNo 
	And IsIn in ( Select IsIn From MultiIsIn M Where D.IsIn = M.IsIn And D.Scrip_Cd = M.Scrip_CD And D.Series = M.Series And M.Valid = 1 )	
	order by d.sett_no , d.sett_type ,d.scrip_Cd 
Open @@DematCur
Fetch next from @@DematCur into @@SerialNo,@@Sno,@@SType,@@PartyCd,@@ScripCd,@@Series,@@DematQty,@@BankCode,@@Isin,@@Inout,@@CltAccNo,@@TransNo,@@ExecDate,@@BranchCd,@@PartipantCode,@@TCode,@@TrType,@@DpType,@@BDpType,@@BDpId,@@BCltDpId,@@Filler1,@@dpname





While @@Fetch_Status = 0
Begin

 	Set @@DematMov = Cursor For
  	select IsNull(sum(qty),0) from DelTrans 
  	where  party_code  = @@PartyCd and scrip_cd = @@ScripCd 
  	and series = @@Series and sett_no = @@SNo 
  	and sett_type = @@SType and RefNo = @RefNo and DrCr = 'C'
  	and PartipantCode = @@PartipantCode And filler2 = 1
 Open @@DematMov
 Fetch Next From @@DematMov into @@CertQty

 Close @@DematMov
 DeAllocate @@DematMov
 Set @@DematMov = Cursor For
  	select IsNull(sum(qty),0) from deliveryclt 
	where  party_code  = @@PartyCd and scrip_cd = @@ScripCd 
	and series = @@Series and sett_no = @@SNo
	and sett_type = @@SType and InOut = 'I'
	and PartipantCode = @@PartipantCode
 Open @@DematMov
 Fetch Next From @@DematMov into @@DeliverQty
 Close @@DematMov
 DeAllocate @@DematMov
 Select @@RemQty = @@DeliverQty - @@CertQty
 if @@RemQty >= @@DematQty
 Begin 

	insert into deltrans(Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo
	,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5)
	Select @@SNo,@@SType,@RefNo,@@TCode,@@TrType,@@PartyCd,@@scripcd,@@series,@@dematqty,@@transno,'',@@isin,@@transno
                   ,@@DpName,'Demat','C','0',@@DematQty,@@DpType,@@BankCode,@@CltAccNo,@@BranchCd,@@PartipantCode,0,'','','','DEMAT',@@execdate,@@filler1,1,0,@@BDpType,@@BDpId,@@BCltDpId,0,0

	insert into deltrans(Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo
	,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5)
	select @@SNo,@@SType,@RefNo,@@TCode,904,'BROKER',@@scripcd,@@series,@@dematqty,@@transno,'',@@isin,@@transno
	,'','Demat','D','0',@@DematQty,@@DpType,@@BankCode,@@CltAccNo,@@BranchCd,@@PartipantCode,0,'','','','DEMAT',@@execdate,@@Filler1,1,0,@@BDpType,@@BDpId,@@BCltDpId,0,0
 
 	delete from DematTrans where Sno = @@SerialNo and party_code = @@PartyCd and scrip_cd = @@ScripCd
                and series = @@Series and sett_no = @@Sno and transno = @@transno and isin = @@isin and RefNo = @RefNo
	and TCode = @@TCode and TrType = @@TrType and Branch_Cd = @@BranchCd and PartipantCode = @@PartipantCode
 End

/* else If (@@remqty <= @@dematqty And @@remqty > 0) */
 Else If (@@remqty < @@dematqty And @@remqty > 0) 
 Begin

	Select @@excessqty = @@dematqty - @@remqty
	insert into deltrans(Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo
	,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5)
	select @@SNo,@@SType,@RefNo,@@TCode,@@TrType,@@PartyCd,@@scripcd,@@series,@@remqty,@@transno,'',@@isin,@@transno
	,@@DpName,'Demat','C','0',@@DematQty,@@DpType,@@BankCode,@@CltAccNo,@@BranchCd,@@PartipantCode,0,'','','','DEMAT',@@execdate,@@Filler1,1,0,@@BDpType,@@BDpId,@@BCltDpId,0,0

	insert into deltrans(Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo
	,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5)
	select @@SNo,@@SType,@RefNo,@@TCode,904,'BROKER',@@scripcd,@@series,@@remqty,@@transno,'',@@isin,@@transno
	,'','Demat','D','0',@@DematQty,@@DpType,@@BankCode,@@CltAccNo,@@BranchCd,@@PartipantCode,0,'','','','DEMAT',@@execdate,@@Filler1,1,0,@@BDpType,@@BDpId,@@BCltDpId,0,0
 
 	update DematTrans set qty = @@ExcessQty where Sno = @@SerialNo and party_code = @@PartyCd and scrip_cd = @@ScripCd
                and series = @@Series and sett_no = @@Sno and transno = @@transno and isin = @@isin and RefNo = @RefNo
	and TCode = @@TCode and TrType = @@TrType   and PartipantCode = @@PartipantCode
 End
 Fetch next from @@DematCur into @@SerialNo,@@Sno,@@SType,@@PartyCd,@@ScripCd,@@Series,@@DematQty,@@BankCode,@@Isin,@@Inout,@@CltAccNo,@@TransNo,@@ExecDate,@@BranchCd,@@PartipantCode,@@TCode,@@TrType,@@DpType,@@BDpType,@@BDpId,@@BCltDpId,@@Filler1,@@dpname

End
Close @@DematCur
DeAllocate @@DematCur

Update DelTrans Set DpType = C.Depository,DpId = C.BankID, CltDpId = C.Cltdpid from Client4 C , DeliveryDp DP
where C.Party_Code = DelTrans.Party_Code And DefDp = 1 and Filler2 = 1 and DrCr = 'D' And Delivered = '0' 
And TrType In (904,905) And DP.DpId = DelTrans.BDpId And DP.DpCltNo = DelTrans.BCltDpId And DP.DpType = DelTrans.BDpType 
And DP.Description Not Like '%POOL%'

GO
