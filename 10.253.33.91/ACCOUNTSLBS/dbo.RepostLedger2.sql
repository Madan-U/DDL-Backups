-- Object: PROCEDURE dbo.RepostLedger2
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE Proc RepostLedger2      
@vtyp smallint      
      
As      
Declare      
 @@Vno As Varchar(12),      
 @@Data As Cursor      
      
Set @@Data = Cursor For      
select distinct vno from ledger where vno not in(select vno from ledger2 where vtype = @vtyp)    
and vtyp = @vtyp    
    
Open @@Data      
Fetch Next From @@Data Into @@VNO      
Set NoCount ON      
While @@Fetch_Status = 0      
 Begin      
  Delete From TempLedger2 Where SessionId = '9999999999'      
  Insert Into TempLedger2      
  Select 'BRANCH', Case When A.BranchCode <> 'ALL' Then A.BranchCode Else 'HO' End,      
    L.VAmt, L.Vtyp, L.Vno, L.Lno, L.DrCr, '0', L.BookType, '9999999999',      
    L.CltCode, 'A', 0      
   From      
    Ledger L, AcMast A      
   Where      
    L.Cltcode = A.CltCode      
    And L.Vno = @@Vno And L.Vtyp = @vtyp And L.BookType = '01'      
    
  Exec InsertToLedger2 '9999999999', @@VNO, 1, 1, '', 'BROKER', 'BROKER'      
    
  Print 'Updated Voucher No. ' + @@VNO      
  Fetch Next From @@Data Into @@VNO      
 End

GO
