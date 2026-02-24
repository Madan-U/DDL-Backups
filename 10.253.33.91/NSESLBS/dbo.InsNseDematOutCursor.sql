-- Object: PROCEDURE dbo.InsNseDematOutCursor
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/* Drop Proc InsNseDematOutCursor */  
CREATE  Proc InsNseDematOutCursor As  
Declare   
@@SNo int,  
@@DelSNo int,  
@@Party_Code Varchar(10),  
@@Scrip_Cd Varchar(12),  
@@Series Varchar(3),  
@@Qty int,  
@@TCode int,  
@@TransNo int,  
@@TrDate Varchar(11),  
@@Sett_No Varchar(7),  
@@Sett_Type Varchar(2),  
@@SettDelQty int,  
@@SettDelTransQty int,  
@@DematCur Cursor,  
@@SettDel Cursor,  
@@SettDelTrans Cursor  
  
Select @@SettDelQty = 0   
Select @@SettDelTransQty = 0  
  
/*Delete From DematTransOut Where Sett_No <= '2002174' */  
IF (SELECT ALLOCATIONTYPE FROM DELSEGMENT ) > 0
begin  
update DematTransOut set scrip_cd = s2.scrip_cd,Series=S2.Series    
from multiisin s2 Where s2.isin =  DematTransOut.isin And Valid = 1   
  
Set @@DematCur = Cursor For  
Select SNo,D.Scrip_CD,D.Series,Qty,TCode,TrDate=Left(Convert(Varchar,TrDate,109),11),D.Sett_No,D.sett_Type,TransNo  
From DematTransOut D, MultiIsIn M Where TrType = 906 And BDpType = 'NSDL' And M.IsIn = D.IsIn And Valid = 1   
Order By D.Scrip_CD,D.Series,Qty Desc,D.Sett_No,D.sett_Type  
Open @@DematCur   
Fetch Next From @@DematCur Into @@SNo,@@Scrip_Cd,@@Series,@@Qty,@@TCode,@@TrDate,@@Sett_No,@@Sett_Type,@@TransNo  
While @@Fetch_Status = 0  
Begin   
 Set @@SettDel = Cursor For  
 Select SNO,Qty,Party_Code From DelTrans Where Sett_No = @@Sett_No  
 And Sett_Type = @@Sett_Type And Scrip_Cd = @@Scrip_Cd And Series = @@Series And   
 Filler2 = 1 And DrCr = 'D' and Delivered = 'G' And TrType = 906 And BDpType = 'NSDL'  
 Order By Qty Desc  
 Open @@SettDel  
 Fetch Next From @@SettDel into @@DelSno,@@SettDelQty,@@Party_Code  
 While @@Fetch_Status = 0 And @@Qty > 0    
 Begin     
  If @@SettDelQty > 0 and @@Qty > 0   
  Begin  
   If @@SettDelQty >= @@Qty   
   Begin  
    Update DematTransOut Set TrType = 909 Where SNo = @@SNo And Sett_No = @@Sett_No  
    And Sett_Type = @@Sett_Type And Scrip_Cd = @@Scrip_Cd and Series = @@Series   
    And SNo = @@SNo And DrCr = 'D' And TrType = 906   
  
    if @@SettDelQty > @@Qty   
    Begin  
     insert into DelTrans   
     Select Sett_No,Sett_type,RefNo,TCode,906,'EXE',scrip_cd,series,@@Qty,@@TransNo,ToNo,CertNo,@@TransNo,HolderName,Reason,DrCr,'D',OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,@@TrDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5  
     From DelTrans Where SNo = @@DelSNo And Sett_No = @@Sett_No  
     And Sett_Type = @@Sett_Type And Scrip_Cd = @@Scrip_Cd and Series = @@Series   
     And Party_Code = @@Party_Code and Filler2 = 1 And DrCr = 'D'   
   
     Update DelTrans Set Qty=@@SettDelQty-@@Qty Where SNo = @@DelSNo And Sett_No = @@Sett_No  
     And Sett_Type = @@Sett_Type And Scrip_Cd = @@Scrip_Cd and Series = @@Series   
     And Party_Code = @@Party_Code And Filler2 = 1 And DrCr = 'D'        
     Select @@Qty = 0  
    End  
    Else   
    Begin   
     Update DelTrans Set Delivered = 'D',Party_Code='EXE',TrType=906,FromNo=@@TransNo,FolioNo=@@TransNo,TransDate=@@TrDate Where SNo = @@DelSNo And Sett_No = @@Sett_No  
     And Sett_Type = @@Sett_Type And Scrip_Cd = @@Scrip_Cd and Series = @@Series   
     And Party_Code = @@Party_Code and Filler2 = 1 And DrCr = 'D'   
     Select @@Qty = 0  
    End       
    Select @@SettDelQty = 0    
   End  
   Else  
   Begin  
    Insert Into DematTransOut Select Sett_No,Sett_Type,RefNo,TCode,909,Party_Code,Scrip_Cd,  
    Series,@@SettDelQty,TrDate,CltAccNo,DpId,DpName,IsIn,Branch_Cd,PartiPantCode,DpType,TransNo,  
    DrCr,BDpType,BDpId,BCltAccNo,Filler1,Filler2,Filler3,Filler4,Filler5 From DematTransOut   
    Where SNo = @@SNo And Sett_No = @@Sett_No And Sett_Type = @@Sett_Type And   
    Scrip_Cd = @@Scrip_Cd and Series = @@Series And DrCr = 'D'   
    And TrType = 906   
      
    Update DematTransOut Set Qty = @@Qty-@@SettDelQty  
    Where SNo = @@SNo And Sett_No = @@Sett_No And Sett_Type = @@Sett_Type And   
    Scrip_Cd = @@Scrip_Cd and Series = @@Series And SNo = @@SNo And DrCr = 'D'   
    And TrType = 906   
      
    Update DelTrans Set Delivered = 'D',Party_Code='EXE',TrType=906,FromNo=@@TransNo,FolioNo=@@TransNo,TransDate=@@TrDate Where SNo = @@DelSNo And Sett_No = @@Sett_No  
    And Sett_Type = @@Sett_Type And Scrip_Cd = @@Scrip_Cd and Series = @@Series   
    And Party_Code = @@Party_Code And Filler2 = 1 And DrCr = 'D'      
  
    Select @@Qty = @@Qty-@@SettDelQty  
    Select @@SettDelQty = 0    
   End  
  End  
  Fetch Next From @@SettDel into @@DelSno,@@SettDelQty,@@Party_Code   
 End  
 Close @@SettDel   
 DeAllocate @@SettDel  
 Fetch Next From @@DematCur Into @@SNo,@@Scrip_Cd,@@Series,@@Qty,@@TCode,@@TrDate,@@Sett_No,@@Sett_Type,@@TransNo  
End  
Close @@DematCur  
DeAllocate @@DematCur  
  
Set @@DematCur = Cursor For  
Select SNo,D.Scrip_CD,D.Series,Qty,TCode,TrDate=Left(Convert(Varchar,TrDate,109),11),D.Sett_No,D.sett_Type,TransNo  
From DematTransOut D, MultiIsIn M Where TrType = 906 And BDpType = 'NSDL' And M.IsIn = D.IsIn  
Order By D.Scrip_CD,D.Series,Qty Desc,D.Sett_No,D.sett_Type  
Open @@DematCur   
Fetch Next From @@DematCur Into @@SNo,@@Scrip_Cd,@@Series,@@Qty,@@TCode,@@TrDate,@@Sett_No,@@Sett_Type,@@TransNo  
While @@Fetch_Status = 0  
Begin   
 Set @@SettDel = Cursor For  
 Select SNO,Qty,Party_Code From DelTrans Where Sett_No = @@Sett_No  
 And Sett_Type = @@Sett_Type And Scrip_Cd = @@Scrip_Cd And Series = @@Series And   
 Filler2 = 1 And DrCr = 'D' and Delivered = '0' And Party_Code = 'BROKER' And BDpType = 'NSDL'  
 Order By Qty Desc  
 Open @@SettDel  
 Fetch Next From @@SettDel into @@DelSno,@@SettDelQty,@@Party_Code  
 While @@Fetch_Status = 0 And @@Qty > 0    
 Begin     
  If @@SettDelQty > 0 and @@Qty > 0   
  Begin  
   If @@SettDelQty >= @@Qty   
   Begin  
    Update DematTransOut Set TrType = 909 Where SNo = @@SNo And Sett_No = @@Sett_No  
    And Sett_Type = @@Sett_Type And Scrip_Cd = @@Scrip_Cd and Series = @@Series   
    And SNo = @@SNo And DrCr = 'D' And TrType = 906   
  
    if @@SettDelQty > @@Qty   
    Begin  
     insert into DelTrans   
     Select Sett_No,Sett_type,RefNo,TCode,906,'EXE',scrip_cd,series,@@Qty,@@TransNo,ToNo,CertNo,@@TransNo,HolderName,Reason,DrCr,'D',OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,@@TrDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5  
     From DelTrans Where SNo = @@DelSNo And Sett_No = @@Sett_No  
     And Sett_Type = @@Sett_Type And Scrip_Cd = @@Scrip_Cd and Series = @@Series   
     And Party_Code = @@Party_Code and Filler2 = 1 And DrCr = 'D'   
   
     Update DelTrans Set Qty=@@SettDelQty-@@Qty Where SNo = @@DelSNo And Sett_No = @@Sett_No  
     And Sett_Type = @@Sett_Type And Scrip_Cd = @@Scrip_Cd and Series = @@Series   
     And Party_Code = @@Party_Code And Filler2 = 1 And DrCr = 'D'        
     Select @@Qty = 0  
    End  
    Else   
    Begin   
     Update DelTrans Set Delivered = 'D',Party_Code='EXE',TrType=906,FromNo=@@TransNo,FolioNo=@@TransNo,TransDate=@@TrDate Where SNo = @@DelSNo And Sett_No = @@Sett_No  
     And Sett_Type = @@Sett_Type And Scrip_Cd = @@Scrip_Cd and Series = @@Series   
     And Party_Code = @@Party_Code and Filler2 = 1 And DrCr = 'D'   
     Select @@Qty = 0  
    End       
    Select @@SettDelQty = 0    
   End  
   Else  
   Begin  
    Insert Into DematTransOut Select Sett_No,Sett_Type,RefNo,TCode,909,Party_Code,Scrip_Cd,  
    Series,@@SettDelQty,TrDate,CltAccNo,DpId,DpName,IsIn,Branch_Cd,PartiPantCode,DpType,TransNo,  
    DrCr,BDpType,BDpId,BCltAccNo,Filler1,Filler2,Filler3,Filler4,Filler5 From DematTransOut   
    Where SNo = @@SNo And Sett_No = @@Sett_No And Sett_Type = @@Sett_Type And   
    Scrip_Cd = @@Scrip_Cd and Series = @@Series And DrCr = 'D'   
    And TrType = 906   
      
    Update DematTransOut Set Qty = @@Qty-@@SettDelQty  
    Where SNo = @@SNo And Sett_No = @@Sett_No And Sett_Type = @@Sett_Type And   
    Scrip_Cd = @@Scrip_Cd and Series = @@Series And SNo = @@SNo And DrCr = 'D'   
    And TrType = 906   
      
    Update DelTrans Set Delivered = 'D',Party_Code='EXE',TrType=906,FromNo=@@TransNo,FolioNo=@@TransNo,TransDate=@@TrDate Where SNo = @@DelSNo And Sett_No = @@Sett_No  
    And Sett_Type = @@Sett_Type And Scrip_Cd = @@Scrip_Cd and Series = @@Series   
    And Party_Code = @@Party_Code And Filler2 = 1 And DrCr = 'D'      
  
    Select @@Qty = @@Qty-@@SettDelQty  
    Select @@SettDelQty = 0    
   End  
  End  
  Fetch Next From @@SettDel into @@DelSno,@@SettDelQty,@@Party_Code   
 End  
 Close @@SettDel   
 DeAllocate @@SettDel  
 Fetch Next From @@DematCur Into @@SNo,@@Scrip_Cd,@@Series,@@Qty,@@TCode,@@TrDate,@@Sett_No,@@Sett_Type,@@TransNo  
End  
Close @@DematCur  
DeAllocate @@DematCur  
end

GO
