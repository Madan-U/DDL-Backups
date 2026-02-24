-- Object: PROCEDURE dbo.RepostLedger2_vin
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

/*BEGIN TRAN          
exec RepostLedger2_vin 8,'dec 24 2005'  
COMMIT          
ROLLBACK          
*/          
              
/*set transaction isolation level read uncommitted                  
select distinct vno from ledger where vno not in(select vno from ledger2 where vtype = 8)                         
and vtyp = 8 and vdt like 'aug 16 2008%' and vno between '208081613153' and '208081617117'*/                  
CREATE Proc [dbo].[RepostLedger2_vin]              
@vtyp smallint,        
@vdt varchar(11)                            
                            
As              
Declare                            
 @@Vno As Varchar(12),                            
 @@Data As Cursor                            
                            
Set @@Data = Cursor For                            
SELECT DISTINCT VNO            
            
FROM LEDGER L WHERE VTYP NOT IN(15, 21, 18) AND NOT EXISTS(            
            
SELECT VNO FROM LEDGER2 L2 WHERE L.VNO = L2.VNO AND L.VTYP = L2.VTYPE AND L.BOOKTYPE = L2.BOOKTYPE)            
AND VTYP = @vtyp           
and vdt >= @vdt      
                          
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
