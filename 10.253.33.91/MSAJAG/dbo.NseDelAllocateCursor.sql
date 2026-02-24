-- Object: PROCEDURE dbo.NseDelAllocateCursor
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.NseDelAllocateCursor    Script Date: 4/27/01 5:41:06 PM ******/

/****** Object:  Stored Procedure dbo.NseDelAllocateCursor    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.NseDelAllocateCursor    Script Date: 3/21/01 12:50:10 PM ******/

/****** Object:  Stored Procedure dbo.NseDelAllocateCursor    Script Date: 20-Mar-01 11:38:52 PM ******/



/****** Object:  Stored Procedure dbo.NseDelAllocateCursor    Script Date: 2/5/01 12:06:15 PM ******/

/****** Object:  Stored Procedure dbo.NseDelAllocateCursor    Script Date: 12/27/00 8:58:52 PM ******/

/****** Object:  Stored Procedure dbo.NseDelAllocateCursor    Script Date: 11/30/2000 4:13:36 PM ******/
CREATE Proc NseDelAllocateCursor (@Sett_No Varchar(7),@Sett_Type Varchar(2),@ScripCd Varchar(12),@Series Varchar(2),@EntityCode Varchar(10),@DelQty int,@CQty int) As
Declare @@Qty int,
 @@CertNo Varchar(15),
 @@FromNo Varchar(15),
 @@FolioNo Varchar(15),
 @@RecieptNo int,
 @@SubRecieptNo int,
 @@Date Varchar(11),
 @@OrgQty int,
 @@PCount int,
 @@DelMov Cursor
 Set @@DelMov = Cursor For 
  select qty,certno, fromno,foliono,recieptno,subrecno,Date=left(convert(varchar,date,109),11),orgqty 
  from certinfo where scrip_cd = @ScripCd 
         and sett_no = @sett_no
         and sett_type = @sett_type 
         and series = @Series 
         and targetParty = '1' and reason NOT LIKE  'Demat' 
  order by date , RecieptNo, subrecno , foliono , certno, qty desc 
 Open @@DelMov
 Fetch Next From @@DelMov into @@Qty,@@CertNo,@@FromNo,@@FolioNo,@@RecieptNo,@@SubRecieptNo,@@Date,@@OrgQty
 if @@Fetch_Status = 0 
 Begin
  Select @@PCount = 0  
  while @@PCount < @DelQty and @@Fetch_Status = 0 
  Begin
   Select @@PCount = @@PCount + @@Qty
   update certinfo set TargetParty  = @EntityCode,inout = 'I',delivered = 'D',reason = 'Given To Nse'
   where scrip_cd = @ScripCd and sett_no  = @sett_no and sett_type = @sett_type
   and series = @Series and certno  = @@certno and fromno = @@fromno
   and FolioNo = @@foliono and recieptno = @@recieptno and Subrecno = @@subrecieptno
   and Date Like @@Date + '%'
   and orgqty = @@orgqty
   Fetch Next From @@DelMov into @@Qty,@@CertNo,@@FromNo,@@FolioNo,@@RecieptNo,@@SubRecieptNo,@@Date,@@OrgQty   
  end
  Close @@DelMov
  DeAllocate @@DelMov
 end
 Else
 Begin
  Close @@DelMov
  DeAllocate @@DelMov
  Set @@DelMov = Cursor For 
  select qty,certno, fromno,foliono,recieptno,subrecno,Date=left(convert(varchar,date,109),11),orgqty 
  from certinfo where scrip_cd = @ScripCd 
         and sett_no = @sett_no
         and sett_type = @sett_type 
         and series = @Series 
         and targetParty = '1' and reason LIKE  'Demat' 
  order by qty desc 
  open @@DelMov
  Fetch Next From @@DelMov into @@Qty,@@CertNo,@@FromNo,@@FolioNo,@@RecieptNo,@@SubRecieptNo,@@Date,@@OrgQty
  if @@Fetch_Status = 0 
  Begin
   Select @@PCount = 0  
   while @@PCount < @DelQty and @@Fetch_Status = 0 
   Begin
    Select @@PCount = @@PCount + @@Qty
    if @@PCount > @DelQty 
    Begin
     Insert into certinfo select Sett_no,Sett_type,scrip_cd,series,qty = @@PCount-@DelQty,party_code,date,
     fromno,tono,reason,certno,foliono,holdername,TargetParty,inout,Delivered,PSettNo,Psett_Type,RecieptNo,OrgQty,@@SubRecieptNo+1,DpType, PODpId, POCltNo, SlipNo    
     from certinfo where Qty = @@Qty and scrip_cd = @ScripCd and series = @Series
                   and sett_no  = @sett_no and sett_type = @sett_type and certno  = @@certno
                   and fromno = @@fromno and targetParty = '1' and reason = 'Demat' and qty = @@Qty
                   and FolioNo = @@FolioNo and recieptno = @@recieptno and Subrecno  = @@SubRecieptNo
                   and Date Like @@Date + '%' and orgqty = @@orgqty
     update certinfo set TargetParty  = @EntityCode,Qty=@@qty-@@PCount+@DelQty,inout = 'I',delivered = 'D',
     reason = 'Given To Nse Demat' where scrip_cd = @ScripCd and sett_no = @sett_no 
     and sett_type = @sett_type and series = @Series and certno  = @@certno 
     and fromno = @@fromno and targetParty = '1' and reason = 'Demat' and qty = @@Qty
                   and FolioNo = @@FolioNo and recieptno = @@recieptno and Subrecno  = @@SubRecieptNo
                   and Date Like @@Date + '%' and orgqty = @@orgqty
    end
    else
    Begin
     update certinfo set TargetParty  = @EntityCode,inout = 'I',delivered = 'D',
     reason = 'Given To Nse Demat' where scrip_cd = @ScripCd and sett_no = @sett_no 
     and sett_type = @sett_type and series = @Series and certno  = @@certno 
     and fromno = @@fromno and targetParty = '1' and reason = 'Demat' and qty = @@Qty
                   and FolioNo = @@FolioNo and recieptno = @@recieptno and Subrecno  = @@SubRecieptNo
                   and Date Like @@Date + '%' and orgqty = @@orgqty
    End
    Fetch Next From @@DelMov into @@Qty,@@CertNo,@@FromNo,@@FolioNo,@@RecieptNo,@@SubRecieptNo,@@Date,@@OrgQty
   end
  end
  Close @@DelMov
  DeAllocate @@DelMov
 end

GO
