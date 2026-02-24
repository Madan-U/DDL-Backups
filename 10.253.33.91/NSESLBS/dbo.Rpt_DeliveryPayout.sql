-- Object: PROCEDURE dbo.Rpt_DeliveryPayout
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Rpt_DeliveryPayout  
(@Sett_No Varchar(7),      
 @Sett_Type Varchar(2),      
 @FromParty Varchar(10),      
 @ToParty Varchar(10),      
 @FromScrip Varchar(12),      
 @ToScrip Varchar(12),      
 @DpType Varchar(4),      
 @DpId Varchar(8),      
 @CltDpId Varchar(16) )      
AS      
      
Set Transaction Isolation Level Read Uncommitted      
  
Select A.Cltcode, Amount = Sum(A.Credit)-Sum(A.Debit), Payflag = 0 Into #delaccbalance From   
(      
 Select   
  A.Cltcode,   
  Debit = (Case When L.Drcr = 'D' Then Sum(Vamt) Else 0 End),         
  Credit = (Case When L.Drcr = 'C' Then Sum(Vamt) Else 0 End)  
 From   
  Account.Dbo.Ledger L with(nolock),  
  (Select CltCode From Account.Dbo.Acmast with(nolock) Where AcCat = '4') A,  
  Account.Dbo.Parameter P with(nolock)  
 where   
  a.cltcode >= @Fromparty   
  and a.cltcode <= @Toparty  
  and a.cltcode = l.cltcode   
  and Edt <= Left(Getdate(),11) + ' 23:59:59'        
  And EDT >= SdtCur               
  And EDT <= Ldtcur               
  And CurYear = 1  
 Group By A.Cltcode, L.Drcr  
 Union All  
 Select   
  A.Cltcode,   
  Debit = (Case When L.Drcr = 'D' Then Sum(Vamt) Else 0 End),         
  Credit = (Case When L.Drcr = 'C' Then Sum(Vamt) Else 0 End)  
 From   
  Account.Dbo.Ledger L with(nolock),  
  (Select CltCode From Account.Dbo.Acmast with(nolock) Where AcCat = '4') A,  
  Account.Dbo.Parameter P with(nolock)  
 where   
  a.cltcode >= @Fromparty   
  and a.cltcode <= @Toparty  
  and a.cltcode = l.cltcode   
  and Edt <= Left(Getdate(),11) + ' 23:59:59'        
  And EDT >= SdtCur               
  And VDT < Sdtcur               
  And CurYear = 1  
 Group By A.Cltcode, L.Drcr  
) A         
Group By A.Cltcode        
      
Update #DelAccBalance Set Amount = 0, PayFlag=1 Where CltCode in ( Select Party_Code From DelPartyFlag Where DebitFlag = 1 )      
Update #DelAccBalance Set Amount = -1, PayFlag=2 Where CltCode in ( Select Party_Code From DelPartyFlag Where DebitFlag = 2 )      
      
select D.Scrip_cd,Series=D.Scrip_CD,D.Party_Code,Long_Name=IsNull(Introducer,''),TrType,D.DpType,CltDpId,      
D.DpId,CertNo,Qty=sum(qty),bdptype,bdpid,bcltdpid,Amount=IsNull(Amount,0),      
ISett_No,Isett_Type,Flag=(Case When TrType = 907 Then 1 When TrType = 908 Then 2 Else 3 End),      
InExc=0, PayFlag = IsNull(A.PayFlag,0) from MultiCltId M, DelTrans D Left Outer Join #DelAccBalance A       
On ( A.CltCode = D.Party_Code )       
where Sett_no = @Sett_No and sett_type = @Sett_Type And TrType <> 906      
and D.Party_code = M.Party_code and M.DpId = D.DpId And M.CltDpNo = D.CltDpId And M.DpType = D.DpType      
And Delivered = '0' And D.Party_Code <> 'BROKER'       
And BDpType = @DpType And BDpId = @DpId and BCltDpId = @CltDpId And DrCr = 'D' And Filler2 = 1       
And D.Party_Code >= @FromParty And D.Party_Code <= @ToParty      
And D.Scrip_Cd >= @FromScrip And D.Scrip_Cd <= @ToScrip And TrType in (904,905)       
Group by D.Scrip_cd,D.Series,D.Party_Code,Introducer,TrType,CltDpId,D.DpId,       
CertNo, bdptype,bdpid,bcltdpid,Amount,ISett_No,Isett_Type,D.DpType,PayFlag order by       
Flag,ISett_No,ISett_Type,D.DpType,D.Party_Code,D.Scrip_Cd

GO
