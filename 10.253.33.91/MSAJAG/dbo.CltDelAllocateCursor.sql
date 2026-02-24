-- Object: PROCEDURE dbo.CltDelAllocateCursor
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.CltDelAllocateCursor    Script Date: 3/21/01 12:50:04 PM ******/
/****** Object:  Stored Procedure dbo.CltDelAllocateCursor    Script Date: 20-Mar-01 11:38:47 PM ******/
/****** Object:  Stored Procedure dbo.CltDelAllocateCursor    Script Date: 2/5/01 12:06:10 PM ******/
/****** Object:  Stored Procedure dbo.CltDelAllocateCursor    Script Date: 12/27/00 8:59:17 PM ******/
/****** Object:  Stored Procedure dbo.CltDelAllocateCursor    Script Date: 11/29/2000 10:49:27 AM ******/
CREATE Proc CltDelAllocateCursor ( @Sett_no Varchar(7),@Sett_Type Varchar(2)) as
Declare @@Scrip_Cd Varchar(12),
 @@Series Varchar(2),
 @@Party_code Varchar(10),
 @@DelQty int,
 @@Qty Int,
 @@TradeQty int,
 @@CertNo Varchar(15),
 @@FromNo Varchar(15),
 @@FolioNo Varchar(10),
 @@Reason Varchar(25),
 @@RecieptNo int,
 @@CertParty Varchar(10),
 @@OrgQty int,
 @@SDate Varchar(11),
 @@SubRecNo int,
 @@PCount Int,
 @@RemQty Int,
 @@OldQty Int,
 @@QtyCur Cursor,
 @@DelClt Cursor,
 @@CertCur Cursor
Set @@DelClt = CurSor for
 select scrip_cd,series,Party_code,Qty from DeliveryClt where inout = 'O'
 and sett_no = @Sett_No and Sett_Type = @Sett_Type
 order by scrip_cd,series,qty,party_code desc
Open @@DelClt
fetch next from @@DelClt into @@Scrip_Cd,@@Series,@@Party_code,@@DelQty
While @@Fetch_status = 0 
begin
      set @@QtyCur = Cursor for 
       select Isnull(sum(qty),0) from certinfo where 
       targetparty = @@party_code
       and sett_no = @sett_no 
       and sett_type = @sett_type 
       and scrip_cd  = @@scrip_cd 
       and series = @@series 
      Open @@QtyCur 
      Fetch next from @@QtyCur into @@Qty   
      select @@Qty,@@DelQty 
      if @@DelQty > @@Qty
      Begin  
 select @@DelQty = @@DelQty - @@Qty
 Set @@CertCur = Cursor For
  select qty,certno,fromno,foliono,reason,recieptno,Party_code,OrgQty,sdate=Left(convert(varchar,date,109),11),subrecno from certinfo 
  where sett_no = @Sett_no
          and sett_type = @sett_type
          and scrip_cd  = @@scrip_cd
          and series = @@series
          and targetparty = '1' 
          order by recieptno , subrecno , date 
 open @@CertCur
 Fetch next from @@CertCur into @@TradeQty,@@certno,@@fromno,@@foliono,@@reason,@@recieptno,@@CertParty,@@OrgQty,@@sdate,@@subrecno 
 if @@Fetch_Status = 0 
 begin
  Select @@PCount = 0
  while @@PCount < @@DelQty and @@Fetch_Status = 0 
  begin
   Select @@PCount = @@PCount + @@TradeQty
   select @@TradeQty,@@certno,@@fromno,@@foliono,@@reason,@@recieptno,@@CertParty,@@OrgQty,@@sdate,@@subrecno 
   if @@PCount <= @@DelQty 
   begin
    if @@Reason = 'Demat' 
     execute DAInsertCertinfo 2,@sett_no,@sett_type,@@party_code,@@scrip_cd,@@series,
                           @@certno,@@foliono,@@FromNo,'Given Demat',0,0,@@recieptno,@@CertParty,@@SDate,@@orgqty,
     @@subrecno,@@TradeQty   
    else
     execute DAInsertCertinfo 2,@sett_no,@sett_type,@@party_code,@@scrip_cd,@@series,
                           @@certno,@@foliono,@@FromNo,'',0,0,@@recieptno,@@CertParty,@@SDate,@@orgqty,
     @@subrecno,@@TradeQty 
   end
   else if @@Reason = 'Demat' 
   begin
    select @@PCount = @@PCount - @@TradeQty
    select @@RemQty = @@DelQty - @@PCount
    select @@OldQty = @@TradeQty - @@RemQty
    select @@PCount = @@PCount + @@RemQty  
    execute DAInsertCertinfo 1,@sett_no,@sett_type,@@party_code,@@scrip_cd,@@series,
                                           @@certno,@@foliono,@@FromNo,'Given Demat',@@RemQty,@@OldQty,@@recieptno,@@CertParty,@@SDate,@@orgqty,
    @@subrecno,@@TradeQty    
   end
   select @@Reason,@@PCount,@@DelQty
   Fetch next from @@CertCur into @@TradeQty,@@certno,@@fromno,@@foliono,@@reason,@@recieptno,@@CertParty,@@OrgQty,@@sdate,@@subrecno       
  end
 end
 Close @@CertCur
 DeAllocate @@CertCur 
      end
      Close @@QtyCur
      Deallocate @@QtyCur
      fetch next from @@DelClt into @@Scrip_Cd,@@Series,@@Party_code,@@DelQty 
end
Close @@DelClt
Deallocate @@DelClt

GO
