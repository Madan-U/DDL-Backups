-- Object: PROCEDURE dbo.CBO_ExcessSharePayoutEdit
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/*
    --select * from deltrans  
--insert into deltrans(Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo ,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDat
e,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5) select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,QTY,FromNo,ToNo,CertNo,FolioNo ,HolderName,Reason,'D',Delivered,OrgQty,'NSDL','IN001002','01234567',BranchCd,Partipant
Code,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,1,0,BDpType,BDpId,BCltDpId,Filler4,Filler5 From DelTrans  Where Sno = '18890' and Scrip_cd = 'DIVISLAB' and RefNo = '110'  

sp_helptext CBO_ExcessSharePayoutEdit

Sql = " insert into deltrans(Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo"
Sql = Sql + " ,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5)"
Sql = Sql + " select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,QTY,FromNo,ToNo,CertNo,FolioNo"
Sql = Sql + " ,HolderName,Reason,'D',Delivered,OrgQty,'" & TxtDpType.Text & "','" & Trim(TxtBankId.Text) & "','" & Trim(TxtAccNo.Text) & "',BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,1,0,BDpType,BDpId,BCltDpId,Filler4,Filler5"
Sql = Sql + " From DelTrans "
Sql = Sql + " Where Sno = " & MSDemat.Resultset("Sno") & " and Scrip_cd = '" & Trim(TxtScrip.Text) & "' and RefNo = " & RefNo
Cn.Execute (Sql)

Sql = " Update DelTrans Set Filler2 = 0 , Filler3 = 70 ,Reason = '" & Trim(TxtReason.Text) & "', HolderName = 'CHANGED DEFAULT PAYOUT ID'"
Sql = Sql + " Where Sno = " & MSDemat.Resultset("Sno") & " and Scrip_cd = '" & Trim(TxtScrip.Text) & "' and RefNo = " & RefNo
Cn.Execute (Sql)

Cn.CommitTran

*/

CREATE PROCEDURE CBO_ExcessSharePayoutEdit  
(  
   @SNo int,  
   @DpType varchar(10),  
   @AccNo  varchar(20),  
   @BankId varchar(10),  
   @Reason varchar(10),  
   @Scrip varchar(10),  
   @RefNo varchar(10),  
 @SuccessFlag CHAR(1) OUTPUT,  
   @STATUSID   VARCHAR(25) = 'BROKER',  
 @STATUSNAME VARCHAR(25) = 'BROKER'  
)  
AS  
BEGIN  
   
    IF @STATUSID <> 'BROKER'  
  BEGIN  
   RAISERROR ('This Procedure is accessible to Broker', 16, 1)  
   RETURN  
  END  
  
 SET @SuccessFlag = 'Y'  
  
   ---- Record Type C   
   INSERT INTO DelTrans  
    (  
    Sett_No,  
    Sett_Type,  
    Refno,  
    Tcode,  
    Trtype,  
    Party_Code,  
    Scrip_Cd,  
    Series,  
    Qty,  
    Fromno,  
    Tono,  
    Certno,  
    Foliono,  
    Holdername,  
    Reason,  
    Drcr,  
    Delivered,  
    Orgqty,  
    Dptype,  
    Dpid,  
    Cltdpid,  
    Branchcd,  
    Partipantcode,  
    Slipno,  
    Batchno,  
    Isett_No,  
    Isett_Type,  
    Sharetype,  
    Transdate,  
    Filler1,  
    Filler2,  
    Filler3,  
    Bdptype,  
    Bdpid,  
    Bcltdpid,  
    Filler4,  
    Filler5  
    )  
     select   
           Sett_No,  
           Sett_type,  
           RefNo,  
           TCode,  
           TrType,  
           Party_Code,  
           scrip_cd,  
           series,  
           QTY,  
           FromNo,  
           ToNo,  
           CertNo,  
           FolioNo ,  
           HolderName,  
           Reason,  
           'D',  
           Delivered,  
           OrgQty,  
           Dptype=@DpType,  
     Dpid=@BankId,  
     Cltdpid = @AccNo,  
           BranchCd,  
           PartipantCode,  
           SlipNo,  
           BatchNo,  
           ISett_No,  
           ISett_Type,  
           ShareType,  
           TransDate,  
           Filler1,  
           1,  
           0,  
           BDpType,  
           BDpId,  
           BCltDpId,Filler4,Filler5 From DelTrans  Where Sno =@SNo and Scrip_cd = @Scrip and RefNo = @RefNo  
  
          Update DelTrans Set  
        Filler2 = 0 ,  
    Filler3 = 70,  
    Reason =@Reason,  
          HolderName = 'CHANGED DEFAULT PAYOUT ID'  
          Where Sno = @SNo and Scrip_cd = @Scrip and RefNo = @RefNo  
  
  
     
END

GO
