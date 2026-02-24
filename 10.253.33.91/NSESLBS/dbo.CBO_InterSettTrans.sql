-- Object: PROCEDURE dbo.CBO_InterSettTrans
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


--exec CBO_InterSettTrans 
CREATE Proc CBO_InterSettTrans(@Sett_Type Varchar(2),@Sett_no Varchar(7),@RefNo int )
 AS
DECLARE
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
 @STATUSID VARCHAR(25),  
 @STATUSNAME VARCHAR(25),
 @@IsIn Varchar(12),  
 @@Cfwd Cursor,  
 @@Cfwd1 Cursor,  
 @@Inter Cursor

Select @@CQty = 0  
Select @@IQty = 0  
Select @@DQty = 0  
Select @@XQty = 0  
  
Truncate Table DelInterSett  
Insert Into DelInterSett  
SELECT PARTY_CODE,SCRIP_CD,Series,BSECODE,sett_no,sett_type,Exchg,Sec_PayIn,0,0,0,0,IsIn FROM InsInterTrans where Psettno = @Sett_no  
and Psetttype = @sett_type And Party_Code Not in ( Select Party_code From DelPartyFlag Where InterFlag = 1 And Party_code = InsInterTrans.Party_Code)   
  
Insert Into DelInterSett  
Select DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,DT.sett_no,DT.sett_type,DT.Exchg,DT.Sec_PayIn,CQty=IsNull(Sum(Qty),0),0,0,0,IsIn  
From BSEDB.DBO.DelTrans D, DelInterSett DT where D.SETT_NO = DT.Sett_no  
And D.sett_type = DT.Sett_Type and D.party_code = DT.Party_Code  
and D.CertNo = DT.IsIn and DrCr = 'C'  
and Filler2 = 1 /* And DT.Exchg = 'BSE' */ and sharetype <> 'auction'  
And DQty = 0 And CQty = 0 And XQty = 0 And IQty = 0   
Group By DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,DT.sett_no,DT.sett_type,DT.Exchg,DT.Sec_PayIn,IsIn  
  
Insert Into DelInterSett  
Select DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,DT.sett_no,DT.sett_type,DT.Exchg,DT.Sec_PayIn,CQty=IsNull(Sum(Qty),0),0,0,0,IsIn  
From MSAJAG.DBO.DelTrans D, DelInterSett DT where D.SETT_NO = DT.Sett_no  
And D.sett_type = DT.Sett_Type and D.party_code = DT.Party_Code  
and D.CertNo = DT.IsIn and DrCr = 'C'  
and Filler2 = 1 /*And DT.Exchg = 'NSE' */ and sharetype <> 'auction'  
And DQty = 0 And CQty = 0 And XQty = 0 And IQty = 0   
Group By DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,DT.sett_no,DT.sett_type,DT.Exchg,DT.Sec_PayIn,IsIn  
  
Insert Into DelInterSett  
Select DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,DT.sett_no,DT.sett_type,DT.Exchg,DT.Sec_PayIn,CQty=0,XQty=IsNull(Sum(Qty),0),0,0,IsIn  
From BSEDB.DBO.DelTrans D, DelInterSett DT where D.ISETT_NO = DT.Sett_no  
And D.Isett_type = DT.Sett_Type and D.party_code = DT.Party_Code  
and D.CertNo = DT.IsIn and DrCr = 'D'  
and Filler2 = 1 And Delivered <> 'D'  /*And DT.Exchg = 'BSE' */ and sharetype <> 'auction'  
And DQty = 0 And CQty = 0 And XQty = 0 And IQty = 0   
Group By DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,DT.sett_no,DT.sett_type,DT.Exchg,DT.Sec_PayIn,IsIn  
  
Insert Into DelInterSett  
Select DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,DT.sett_no,DT.sett_type,DT.Exchg,DT.Sec_PayIn,0,0,IQty=IsNull(Sum(Qty),0),0,IsIn  
From MSAJAG.DBO.DelTrans D, DelInterSett DT where D.ISETT_NO = DT.Sett_no  
And D.Isett_type = DT.Sett_Type and D.party_code = DT.Party_Code  
and D.CertNo = DT.IsIn and DrCr = 'D'  
and Filler2 = 1 And Delivered <> 'D'  /*And DT.Exchg = 'NSE'*/ and sharetype <> 'auction'  
And DQty = 0 And CQty = 0 And XQty = 0 And IQty = 0   
Group By DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,DT.sett_no,DT.sett_type,DT.Exchg,DT.Sec_PayIn,IsIn  
  
Insert Into DelInterSett  
Select DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,DT.sett_no,DT.sett_type,DT.Exchg,DT.Sec_PayIn,0,0,0,DQty=IsNull(Sum(Qty),0),IsIn   
From BseDb.Dbo.deliveryclt D, DelInterSett DT where D.SETT_NO = DT.Sett_no  
And D.sett_type = DT.Sett_Type and D.party_code = DT.Party_Code  
and D.scrip_cd = DT.BseCode and InOut = 'I'  
/*And DT.Exchg = 'BSE' */ And DQty = 0 And CQty = 0 And XQty = 0 And IQty = 0   
Group By DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,DT.sett_no,DT.sett_type,DT.Exchg,DT.Sec_PayIn,IsIn  
  
Insert Into DelInterSett  
Select DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,DT.sett_no,DT.sett_type,DT.Exchg,DT.Sec_PayIn,0,0,0,DQty=IsNull(Sum(Qty),0),IsIn   
From MSAJAG.Dbo.deliveryclt D, DelInterSett DT where D.SETT_NO = DT.Sett_no  
And D.sett_type = DT.Sett_Type and D.party_code = DT.Party_Code  
and D.scrip_cd = DT.Scrip_Cd And D.Series = DT.Series and InOut = 'I'  
/*And DT.Exchg = 'NSE' */ And DQty = 0 And CQty = 0 And XQty = 0 And IQty = 0   
Group By DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,DT.sett_no,DT.sett_type,DT.Exchg,DT.Sec_PayIn,IsIn  
  
set @@inter = cursor for  
SELECT PARTY_CODE,SCRIP_CD,Series,BSECODE,sett_no,sett_type,Exchg,DQty=Sum(DQty)-Sum(CQty)-Sum(XQty)-Sum(IQty),IsIn FROM DelInterSett  
Group By PARTY_CODE,SCRIP_CD,Series,BSECODE,sett_no,sett_type,Exchg,SEC_PAYIN,IsIn  
ORDER BY SEC_PAYIN,Exchg DESC,PARTY_CODE,SCRIP_CD,Series,sett_no,sett_type  
open @@inter  
fetch next from @@inter into @@Party_Code,@@Scrip_Cd,@@Series,@@BseCode,@@PSett_No,@@Psett_type,@@Exchg,@@DQty,@@IsIn  
  
while @@fetch_status = 0  
begin   
  
 select @@CQty = 0   
 Set @@Cfwd = Cursor for   
 select IsNull(Sum(Qty),0) from DelTrans D, DeliveryDP DP where delivered = '0' And SETT_NO = @Sett_No  
 And sett_type = @Sett_Type and Party_Code = @@Party_Code  
 And CertNo = @@IsIn and DrCr = 'D' and RefNo = @RefNo  
 and Filler2 = 1 and TrType = 904 and sharetype <> 'auction'  
 And Dp.DpId = D.BDpId And Dp.DpCltNo = D.BCltDpId And Dp.Description Like '%POOL%'  
 Open @@Cfwd  
 fetch next from @@Cfwd into @@CQty  
  
 Close @@Cfwd  
 deallocate @@Cfwd  
  
 If @@CQty > @@Dqty   
 begin  
 Set @@Cfwd = Cursor for    
 Select Qty,FromNo,ToNo,CertNo,FolioNo,D.Sno,TrType,TCode from DelTrans D, DeliveryDp Dp where delivered = '0'   
 And SETT_NO = @Sett_No And sett_type = @Sett_Type and Party_Code = @@Party_Code  
  And CertNo = @@IsIn and RefNo = @RefNo and DrCr = 'D' and Filler2 = 1 and TrType = 904 and sharetype <> 'auction'  
  And Dp.DpId = D.BDpId And Dp.DpCltNo = D.BCltDpId And Dp.Description Like '%POOL%'  
 order by Qty asc  
  
 Open @@Cfwd  
 fetch next from @@Cfwd into @@TQty,@@FromNo,@@ToNo,@@CertNo,@@FolioNo,@@SNo,@@TrType,@@TCode   
   
        While @@Fetch_status = 0   
 Begin  
  
  If @@DQty > 0      
  Begin  
   if @@DQty - @@TQty >= 0   
   Begin  
    update DelTrans set ISett_no=@@PSett_No,ISett_Type=@@PSett_Type,TrType=907,Reason = (Case When @@Exchg = 'BSE' Then 'Inter Exchange Transfer'  Else 'Inter Settlement Transfer' End )  
    Where Sett_no = @Sett_No and sett_type = @Sett_Type and party_code = @@Party_Code   
    And CertNo = @@IsIn and Qty = @@TQty and fromno = @@FromNo and tono = @@ToNo and   
    certno = @@CertNo and foliono = @@FolioNo and sno = @@SNo and TCode = @@TCode and   
    TrType = @@TrType and RefNo = @RefNo and DrCr = 'D' and Filler2 = 1    
     
    select @@Dqty = @@DQty - @@TQty   
   end  
   else  
   begin  
      
    insert into deltrans(Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo  
    ,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5)  
    Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,@@TQty - @@DQty,FromNo,ToNo,CertNo,FolioNo  
    ,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5  
    from DelTrans Where Sett_no = @Sett_No and sett_type = @Sett_Type and party_code = @@Party_Code and   
    CertNo = @@IsIn and Qty = @@TQty and fromno = @@FromNo and tono = @@ToNo and   
    certno = @@CertNo and foliono = @@FolioNo and sno = @@sNo and TCode = @@TCode and   
    TrType = @@TrType and RefNo = @RefNo and DrCr = 'D' and Filler2 = 1       
  
    update DelTrans set ISett_no=@@PSett_No,ISett_Type=@@PSett_Type,TrType=907,Reason = (Case When @@Exchg = 'BSE' Then 'Inter Exchange Transfer'  Else 'Inter Settlement Transfer' End ),  
    Qty = @@DQty  
    Where Sett_no = @Sett_No and sett_type = @Sett_Type and party_code = @@Party_Code and   
    CertNo = @@IsIn and Qty = @@TQty and fromno = @@FromNo and tono = @@ToNo and   
    certno = @@CertNo and foliono = @@FolioNo and sno = @@SNo and TCode = @@TCode and   
    TrType = @@TrType and RefNo = @RefNo and DrCr = 'D' and Filler2 = 1    
         
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
 update DelTrans set ISett_no=@@PSett_No,ISett_Type=@@PSett_Type,TrType=907,Reason =(Case When @@Exchg = 'BSE' Then 'Inter Exchange Transfer'  Else 'Inter Settlement Transfer' End )  
 from deliverydp dp Where Sett_no = @Sett_No and sett_type = @Sett_Type and party_code = @@Party_Code and   
 CertNo = @@IsIn and RefNo = @RefNo and DrCr = 'D' and Filler2 = 1  and TrType = 904 and Delivered = '0'  
             and sharetype <> 'auction' And Dp.DpId = DelTrans.BDpId And Dp.DpCltNo = DelTrans.BCltDpId And Dp.Description Like '%POOL%'  
 end   
fetch next from @@inter into @@Party_Code,@@Scrip_Cd,@@Series,@@BseCode,@@PSett_No,@@Psett_type,@@Exchg,@@DQty,@@IsIn  
end  
/*  
Update DelTrans Set DPType =M.DpType,DPId = M.DPID,CltDpid=M.CltDpNo,Reason='POA Inter Settlement',TrType=908 From BSEDB.DBO.MultiCltId M, BSEDB.DBO.Sett_Mst S  
Where S.Sett_No = ISett_No And S.Sett_Type = ISett_Type And DelTrans.Party_Code = M.Party_Code And Def = 1 And M.DpType = 'CDSL' And TrType = 907 And Delivered = '0'  
and sharetype <> 'auction'  
  
Update DelTrans Set DPType =M.DpType,DPId = M.DPID,CltDpid=M.CltDpNo,Reason='POA Inter Settlement',TrType=908 From MultiCltId M, Sett_Mst S  
Where S.Sett_No = ISett_No And S.Sett_Type = ISett_Type And DelTrans.Party_Code = M.Party_Code And Def = 1 And M.DpType = 'CDSL' And TrType = 907 And Delivered = '0'  
and sharetype <> 'auction'  
*/

GO
