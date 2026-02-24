-- Object: PROCEDURE dbo.DematAllocateCursor
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.DematAllocateCursor    Script Date: 3/21/01 12:50:06 PM ******/
/****** Object:  Stored Procedure dbo.DematAllocateCursor    Script Date: 20-Mar-01 11:38:49 PM ******/
/****** Object:  Stored Procedure dbo.DematAllocateCursor    Script Date: 3/7/01 1:31:19 PM ******/
/****** Object:  Stored Procedure dbo.DematAllocateCursor    Script Date: 2/5/01 12:06:11 PM ******/
/****** Object:  Stored Procedure dbo.DematAllocateCursor    Script Date: 12/27/00 8:59:07 PM ******/
/****** Object:  Stored Procedure dbo.DematAllocateCursor    Script Date: 11/29/2000 10:49:28 AM ******/
CREATE Proc DematAllocateCursor /* ( @Sett_No Varchar(7),@Sett_Type Varchar(2)) */ As
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
 @@DpId Varchar(5),
 @@DematQty int,
 @@ExecDate varchar(20),
 @@CertQty int,
 @@DeliverQty int,
 @@RemQty int,
 @@ExcessQty int,
 @@DematCur Cursor, 
 @@DematMov Cursor
/* Added by Animesh on Date 19/12/2000 */
insert into dematout select * from dematdelivery where inout = 'O' and BankCode <> 'Pay-Out'
delete from dematdelivery where inout = 'O' and BankCode <> 'Pay-Out'
/*-------------*/
update dematdelivery set scrip_cd = s2.scrip_cd 
from multiisin s2 ,dematdelivery d Where s2.isin = d.isin 
Set @@DematCur = Cursor For
 select d.sett_no ,d.sett_type,d.party_code , d.scrip_cd , d.series ,d.qty ,
 d.bankcode ,d.isin,d.inout ,d.cltaccno, d.TransNo , d.date,DpType from dematdelivery d , multiisin m 
 where d.party_code not in ('Party', '') and d.isin = m.isin 
/* and sett_no = @Sett_No and sett_Type = @Sett_Type*/
 order by d.sett_no , d.sett_type ,d.scrip_Cd 
Open @@DematCur
Fetch next from @@DematCur into @@Sno,@@SType,@@PartyCd,@@ScripCd,@@Series,@@DematQty,@@BankCode,@@Isin,@@Inout,@@CltAccNo,@@TransNo,@@ExecDate,@@DpId
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
  select IsNull(sum(qty),0) from deliveryclt 
  where  party_code  = @@PartyCd and scrip_cd = @@ScripCd 
  and series = @@Series and sett_no = @@SNo
  and sett_type = @@SType and InOut = 'I'
 Open @@DematMov
 Fetch Next From @@DematMov into @@DeliverQty
 Close @@DematMov
 DeAllocate @@DematMov
 Select @@RemQty = @@DeliverQty - @@CertQty
 if @@RemQty >= @@DematQty
 Begin 
  insert into certinfo values (@@SNo,@@SType,@@scripcd,@@series,@@dematqty,@@Partycd,@@execdate,
         @@transno,Left(@@BankCode,16),'Demat',@@Isin,@@CltAccNo,' ','1',@@inout,'0','','',0,@@dematqty,0,@@DpId,'','',0)
 
  delete from dematdelivery where party_code = @@PartyCd and scrip_cd = @@ScripCd
         and series = @@Series and sett_no = @@Sno and transno = @@transno and isin = @@isin
 End
 Else If (@@remqty <= @@dematqty And @@remqty > 0)
 Begin
  Select @@excessqty = @@dematqty - @@remqty
  insert into certinfo values (@@SNo,@@SType,@@scripcd,@@series,@@remqty,@@Partycd,@@execdate,
         'X'+@@transno,Left(@@BankCode,16),'Demat',@@Isin,@@CltAccNo,' ','1',@@inout,'0','','',0,@@dematqty,0,@@DpId,'','',0)
 
  update dematdelivery set qty = @@ExcessQty where party_code = @@partycd 
               and scrip_cd = @@scripcd and series = @@series and sett_no = @@Sno and transno = @@Transno   and isin = @@isin
 End
 Fetch next from @@DematCur into @@Sno,@@SType,@@PartyCd,@@ScripCd,@@Series,@@DematQty,@@BankCode,@@Isin,@@Inout,@@CltAccNo,@@TransNo,@@ExecDate,@@DpId
 /*select @@Sno,@@SType,@@PartyCd,@@ScripCd,@@Series,@@DematQty,@@BankCode,@@Isin,@@Inout,@@CltAccNo,@@TransNo,@@ExecDate*/
End
Close @@DematCur
DeAllocate @@DematCur

GO
