-- Object: PROCEDURE dbo.InsCltDelAuction
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc [dbo].[InsCltDelAuction] ( @Sett_no Varchar(7),@Sett_Type Varchar(2),@RefNo int) as      
      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED       
      
Declare @@Scrip_Cd Varchar(12),      
 @@Series Varchar(3),      
 @@Party_code Varchar(10),      
 @@AuctionParty Varchar(10),      
 @@ASett_No Varchar(7),      
 @@ASett_Type Varchar(2),       
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
 @@QtyCur Cursor,      
 @@DelClt Cursor,      
 @@CertCur Cursor      
Set @@DelClt = CurSor for      
 Select Scrip_Cd,Series,Party_Code,TradeQty,ASett_no,ASett_Type From DelAuctionPos Where Sett_No = @Sett_No And Sett_Type = @Sett_Type      
 order by Scrip_Cd,Series,Party_Code,TradeQty Desc      
Open @@DelClt      
fetch next from @@DelClt into @@Scrip_Cd,@@Series,@@Party_code,@@DelQty,@@ASett_No,@@ASett_Type      
      
While @@Fetch_status = 0       
begin      
       set @@QtyCur = Cursor for       
       select Isnull(sum(qty),0) FROM dELTRANS WITH(INDEX(DELHOLD))       
       where sett_no = @sett_no       
       and sett_type = @sett_type       
       and RefNo = @RefNo      
       and party_code = @@party_code      
       and scrip_cd  = @@scrip_cd       
       and series = @@series       
       and DrCr = 'D' And Filler2 = 1       
       And Reason Like 'Auc%'      
       Open @@QtyCur       
       Fetch next from @@QtyCur into @@Qty         
       if @@DelQty > @@Qty      
       Begin        
  select @@DelQty = @@DelQty - @@Qty      
  Set @@CertCur = Cursor For      
  select qty,certno, fromno,foliono,TDate=left(convert(varchar,TransDate,109),11),orgqty,Sno,TCode,AuctionParty      
  from DelTrans,DelSegment       
  where sett_no = @sett_no       
           and sett_type = @sett_type       
           and party_code = AuctionParty      
           and scrip_cd  = @@scrip_cd       
          and series = @@series And Delivered = '0'      
   and DrCr = 'D' and TrType = 904 and Filler2 = 1          
           order by TransDate Asc,Qty Desc       
   open @@CertCur      
   Fetch next from @@CertCur into @@TradeQty,@@certno,@@fromno,@@foliono,@@sdate,@@OrgQty,@@sno,@@TCode,@@AuctionParty        
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
     select Sett_No,Sett_type,RefNo,TCode, 904,@@party_code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo      
     ,HolderName='Auc PayOut '+Right(@@ASett_no,3)+'-'+@@ASett_Type,Reason='Auc PayOut '+Right(@@ASett_no,3)+'-'+@@ASett_Type,'C',Delivered,OrgQty,DpType,'','',BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,'Auc PayOut '+Right(@@ASett_no,3)+'-'+@@ASett_Type,1,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5      
     from dELTRANS WITH(INDEX(DELHOLD)) Where sett_no  = @sett_no and sett_type = @sett_type      
          and RefNo = @RefNo       
                AND SNO = @@SNo and TCode = @@TCode       
               and scrip_cd = @@Scrip_Cd and series = @@Series       
          and certno  = @@certno and fromno = @@fromno       
             and FolioNo = @@foliono and TransDate Like @@SDate + '%'       
                     and Party_Code = @@AuctionParty      
                     and DrCr = 'D' and orgqty = @@orgqty and filler2 = 1      
      
     insert into dELTRANS (Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo      
     ,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5)      
     select Sett_No,Sett_type,RefNo,TCode, 904,@@party_code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo      
     ,HolderName='Auc PayOut '+Right(@@ASett_no,3)+'-'+@@ASett_Type,Reason='Auc PayOut '+Right(@@ASett_no,3)+'-'+@@ASett_Type,'D',Delivered,OrgQty,DpType,'','',BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,'Auc PayOut '+Right(@@ASett_no,3)+'-'+@@ASett_Type,1,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5      
     from dELTRANS WITH(INDEX(DELHOLD)) Where sett_no  = @sett_no and sett_type = @sett_type      
          and RefNo = @RefNo       
                AND SNO = @@SNo and TCode = @@TCode       
               and scrip_cd = @@Scrip_Cd and series = @@Series       
          and certno  = @@certno and fromno = @@fromno       
             and FolioNo = @@foliono and TransDate Like @@SDate + '%'       
                     and Party_Code = @@AuctionParty      
                     and DrCr = 'D' and orgqty = @@orgqty and filler2 = 1      
         
     update dELTRANS  set Reason='Transfered To Auc PayOut',Delivered='D'      
               where sett_no  = @sett_no and sett_type = @sett_type      
          and RefNo = @RefNo       
                AND SNO = @@SNo and TCode = @@TCode       
               and scrip_cd = @@Scrip_Cd and series = @@Series       
          and certno  = @@certno and fromno = @@fromno       
             and FolioNo = @@foliono and TransDate Like @@SDate + '%'       
                 and Party_Code = @@AuctionParty      
          and DrCr = 'D' and orgqty = @@orgqty and filler2 = 1      
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
     ,HolderName,Reason,'D',Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,1,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5      
     FROM dELTRANS WITH(INDEX(DELHOLD)) Where sett_no  = @sett_no and sett_type = @sett_type      
          and RefNo = @RefNo       
                AND SNO = @@SNo and TCode = @@TCode       
               and scrip_cd = @@Scrip_Cd and series = @@Series       
          and certno  = @@certno and fromno = @@fromno       
             and FolioNo = @@foliono and TransDate Like @@SDate + '%'       
                     and Party_Code = @@AuctionParty      
                     and DrCr = 'D' and orgqty = @@orgqty and filler2 = 1      
      
     insert into deltrans(Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo      
     ,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5)      
     select Sett_No,Sett_type,RefNo,TCode,904,@@Party_Code,scrip_cd,series,Qty=@@RemQty,FromNo,ToNo,CertNo,FolioNo      
     ,HolderName='Auc PayOut '+Right(@@ASett_no,3)+'-'+@@ASett_Type,Reason='Auc PayOut '+Right(@@ASett_no,3)+'-'+@@ASett_Type,'C',Delivered,OrgQty,DpType,'','',BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,'Auc PayOut '+Right(@@ASett_no,3)+'-'+@@ASett_Type,1,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5      
     FROM dELTRANS WITH(INDEX(DELHOLD))      
     where sett_no  = @sett_no and sett_type = @sett_type      
        and RefNo = @RefNo       
        AND SNO = @@SNo and TCode = @@TCode       
        and scrip_cd = @@Scrip_Cd and series = @@Series       
        and certno  = @@certno and fromno = @@fromno       
        and FolioNo = @@foliono and TransDate Like @@SDate + '%'      
        and Party_Code = @@AuctionParty      
        and DrCr = 'D' and orgqty = @@orgqty       
      
     insert into deltrans(Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo      
     ,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5)      
     select Sett_No,Sett_type,RefNo,TCode,904,@@Party_Code,scrip_cd,series,Qty=@@RemQty,FromNo,ToNo,CertNo,FolioNo      
     ,HolderName='Auc PayOut '+Right(@@ASett_no,3)+'-'+@@ASett_Type,Reason='Auc PayOut '+Right(@@ASett_no,3)+'-'+@@ASett_Type,DrCr,Delivered,OrgQty,DpType,'','',BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,'Auc PayOut '+Right(@@ASett_no,3)+'-'+@@ASett_Type,1,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5      
     FROM dELTRANS WITH(INDEX(DELHOLD))      
     where sett_no  = @sett_no and sett_type = @sett_type      
        and RefNo = @RefNo       
        AND SNO = @@SNo and TCode = @@TCode       
        and scrip_cd = @@Scrip_Cd and series = @@Series       
        and certno  = @@certno and fromno = @@fromno       
        and FolioNo = @@foliono and TransDate Like @@SDate + '%'      
        and Party_Code = @@AuctionParty      
        and DrCr = 'D' and orgqty = @@orgqty       
         
     update DelTrans set Reason='Transfered To Auc PayOut',Delivered='D', Qty=@@RemQty      
               where sett_no  = @sett_no and sett_type = @sett_type      
          and RefNo = @RefNo       
                AND SNO = @@SNo and TCode = @@TCode       
               and scrip_cd = @@Scrip_Cd and series = @@Series       
          and certno  = @@certno and fromno = @@fromno       
             and FolioNo = @@foliono and TransDate Like @@SDate + '%'       
                 and Party_Code = @@AuctionParty      
                    and DrCr = 'D' and orgqty = @@orgqty and filler2 = 1      
         
    end      
    Fetch next from @@CertCur into @@TradeQty,@@certno,@@fromno,@@foliono,@@sdate,@@OrgQty,@@sno,@@TCode,@@AuctionParty      
     end      
   end      
   Close @@CertCur      
   DeAllocate @@CertCur       
      end      
      Close @@QtyCur      
      Deallocate @@QtyCur      
      fetch next from @@DelClt into @@Scrip_Cd,@@Series,@@Party_code,@@DelQty,@@ASett_No,@@ASett_Type      
end      
Close @@DelClt      
Deallocate @@DelClt      
      
Update DelTrans Set  DpType = C.Depository,DpId = C.BankID, CltDpId = C.Cltdpid from   
DelTrans With(Index(DelHold)), Client4 c where C.party_Code  =  DelTrans.Party_Code      
and Sett_no = @Sett_No and Sett_Type = @Sett_Type And DefDp =1 and DpId = '' and Filler2 = 1 and DrCr = 'D'      
And Delivered = '0' And TrType = 904 /*And Reason Like 'Auc PayOut%'  */    
  /*    
update DelTrans Set DpId = M.DpId, DpType = M.DpType, CltDpId=CltDpNo From MultiCltId M       
Where M.Party_code = DelTrans.Party_Code And Def = 1 And Filler2 = 1 And DrCr = 'D' And Delivered = '0'      
And Sett_No = @Sett_no And Sett_Type = @Sett_Type And Reason Like 'Excess %' And TrType = 904 And Reason Like 'Auc PayOut%'    
    
*/

GO
