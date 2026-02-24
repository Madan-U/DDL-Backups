-- Object: PROCEDURE dbo.DematNseAllocateCursor
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.DematNseAllocateCursor    Script Date: 3/21/01 12:50:06 PM ******/
/****** Object:  Stored Procedure dbo.DematNseAllocateCursor    Script Date: 20-Mar-01 11:38:49 PM ******/
/****** Object:  Stored Procedure dbo.DematNseAllocateCursor    Script Date: 2/5/01 12:06:12 PM ******/
/****** Object:  Stored Procedure dbo.DematNseAllocateCursor    Script Date: 12/27/00 8:59:07 PM ******/
/****** Object:  Stored Procedure dbo.DematNseAllocateCursor    Script Date: 11/29/2000 10:49:28 AM ******/
CREATE Proc DematNseAllocateCursor /* ( @Sett_No Varchar(7),@Sett_Type Varchar(2)) */ As
Declare @@Sno varchar(7),
 @@SType Varchar(2),
 @@PartyCd Varchar(10),
 @@ScripCd Varchar(12),
 @@Series Varchar(2),
 @@BankCode Varchar(30),
 @@Isin Varchar(12),
 @@CltAccNo Varchar(12),
 @@TransNo Varchar(12),
 @@InOut Varchar(1),
 @@DematQty int,
 @@CertQty int,
 @@DeliverQty int,
 @@RemQty int,
 @@ExcessQty int,
 @@DematCur Cursor, 
 @@DematMov Cursor
Set @@DematCur = Cursor For
 select sett_no ,sett_type,party_code , scrip_cd , series ,qty ,
 bankcode ,isin,inout ,cltaccno, TransNo from dematdelivery where party_code = 'NSE' 
 order by sett_no , sett_Type,party_Code,scrip_Cd
Open @@DematCur
Fetch next from @@DematCur into @@Sno,@@SType,@@PartyCd,@@ScripCd,@@Series,@@DematQty,@@BankCode,@@Isin,@@Inout,@@CltAccNo,@@TransNo
While @@Fetch_Status = 0
Begin
 Set @@DematMov = Cursor For
  select IsNull(sum(qty),0) from certinfo 
  where  party_code  = @@PartyCd and scrip_cd = @@ScripCd 
  and series = @@Series and sett_no = @@SNo
  and sett_type = @@SType 
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
 if @@RemQty >= @@DematQty
 Begin 
  insert into certinfo values (@@SNo,@@SType,@@scripcd,@@series,@@dematqty,@@Partycd,GetDate(),
         @@transno,Left(@@BankCode,16),'Demat',@@Isin,@@CltAccNo,' ','1',@@inout,'0','','',0,@@dematqty,0,'NSDL','','',0)
 
  delete from dematdelivery where party_code = @@PartyCd and scrip_cd = @@ScripCd
         and series = @@Series and sett_no = @@Sno and transno = @@transno and isin = @@isin
 End
 Else If (@@remqty <= @@dematqty And @@remqty > 0)
 Begin
  Select @@excessqty = @@dematqty - @@remqty
  insert into certinfo values (@@SNo,@@SType,@@scripcd,@@series,@@remqty,@@Partycd,GetDate(),
         'X'+@@transno,Left(@@BankCode,16),'Demat',@@Isin,@@CltAccNo,' ','1',@@inout,'0','','',0,@@dematqty,0,'NSDL','','',0)
 
  update dematdelivery set qty = @@ExcessQty where party_code = @@partycd 
         and scrip_cd = @@scripcd and series = @@series and sett_no = @@Sno and transno = @@Transno  and isin = @@isin
 End
 Fetch next from @@DematCur into @@Sno,@@SType,@@PartyCd,@@ScripCd,@@Series,@@DematQty,@@BankCode,@@Isin,@@Inout,@@CltAccNo,@@TransNo
End
Close @@DematCur
DeAllocate @@DematCur

GO
