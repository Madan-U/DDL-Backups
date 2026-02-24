-- Object: PROCEDURE dbo.InsDebitPayOut
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


/****** Object:  Stored Procedure dbo.InsDebitPayOut    Script Date: 05/10/2004 5:41:50 PM ******/  
  
/*  DROP Proc InsDebitPayOut */  
CREATE Proc InsDebitPayOut As  
set transaction isolation level read uncommitted  
TRUNCATE TABLE DelPayOut   
/* Getting Holding from All Beneficiary Account From NSE */  
Insert Into DelPayOut  
select 'NSE',D.Sett_No,D.Sett_Type,D.Party_Code,D.Scrip_cd,D.Series,D.CertNo,DebitQty=Sum(D.Qty),PayQty=0,ShrtQty=0,  
0,'',LedBal=0,EffBal=0,Cl_Rate=0,GetDate(),0   
from deltrans D, DeliveryDp Dp where drcr = 'D'  
And Filler2 = 1 And Delivered = '0' and BCltDpId = Dp.DpCltNo And BDpId = Dp.DpId   
And Description Not Like '%POOL%'   
And TrType = 904 And CertNo Like 'IN%'  
Group By D.Sett_No,D.Sett_Type,D.Party_Code,D.Scrip_Cd,D.Series,D.CertNo  
  
/* Getting Holding from All Beneficiary Account From BSE */  
Insert Into DelPayOut  
select 'BSE',D.Sett_No,D.Sett_Type,D.Party_Code,D.Scrip_cd,D.Series,D.CertNo,DebitQty=Sum(D.Qty),PayQty=0,ShrtQty=0,  
0,'',LedBal=0,EffBal=0,Cl_Rate=0,GetDate(),0    
from BSEDB.DBO.deltrans D, BSEDB.DBO.DeliveryDp Dp where drcr = 'D'  
And Filler2 = 1 And Delivered = '0' and BCltDpId = Dp.DpCltNo And BDpId = Dp.DpId   
And Description Not Like '%POOL%'   
And TrType = 904 And CertNo Like 'IN%'  
Group By D.Sett_No,D.Sett_Type,D.Party_Code,D.Scrip_Cd,D.Scrip_Cd,D.Series,D.CertNo  
  
  
/* Getting PayOut from All Open Settlement From NSE */  
Insert Into DelPayOut  
Select 'NSE',D.Sett_No,D.Sett_Type,D.Party_Code,D.Scrip_cd,D.Series,CertNo=M.IsIn,DebitQty=0,PayQty=Sum(D.Qty),ShrtQty=0,  
0,'',LedBal=0,EffBal=0,Cl_Rate=0,GetDate(),0  
from DeliveryClt D, Sett_mst S, MultiIsin M where   
S.Sett_No = D.Sett_No And S.Sett_Type = D.Sett_Type And InOut = 'O' And  
D.Scrip_Cd = M.Scrip_cd And Sec_PayOut >= Left(Convert(Varchar,GetDate(),109),11) And D.Sett_Type Not Like 'A%'  
And Valid = 1   
Group By D.Sett_No,D.Sett_Type,D.Party_Code,D.Scrip_Cd,D.Series,M.IsIn  
  
/* Getting PayOut from All Open Settlement From BSE */  
Insert Into DelPayOut  
Select 'BSE',D.Sett_No,D.Sett_Type,D.Party_Code,D.Scrip_cd,D.Series,CertNo=M.IsIn,DebitQty=0,PayQty=Sum(D.Qty),ShrtQty=0,  
0,'',LedBal=0,EffBal=0,Cl_Rate=0,GetDate(),0   
from BSEDB.DBO.DeliveryClt D, BSEDB.DBO.Sett_mst S, BSEDB.DBO.MultiIsin M where   
S.Sett_No = D.Sett_No And S.Sett_Type = D.Sett_Type And InOut = 'O' And  
D.Scrip_Cd = M.Scrip_cd And Sec_PayOut >= Left(Convert(Varchar,GetDate(),109),11)   
And Valid = 1  and D.Sett_Type Not Like 'A%'  
Group By D.Sett_No,D.Sett_Type,D.Party_Code,D.Scrip_Cd,D.Scrip_Cd,D.Series,M.IsIn  
  
/* Getting Shortages from All Open Settlement From NSE */  
Insert Into DelPayOut  
select 'NSE',D.Sett_No,D.Sett_Type,D.Party_Code,D.Scrip_cd,D.Series,CertNo=M.IsIn,  
DebitQty=0,PayQty=0,ShrtQty=D.Qty-Sum(isnull(De.qty,0)),0,'',LedBal=0,EffBal=0,Cl_Rate=0,GetDate(),0   
from Sett_Mst S, MultiIsIn M, deliveryClt d Left Outer Join DelTrans de   
On ( de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd   
     and de.series = d.series and de.party_code = d.party_code And DrCr = 'C' and filler2 = 1 )  
where d.inout = 'I' and D.qty > 0 And M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series And Valid = 1   
and d.sett_no = S.Sett_no and d.sett_type = S.Sett_Type   
And Sec_PayOut >= Left(Convert(Varchar,GetDate(),109),11) and D.Sett_Type Not Like 'A%'  
  
group by D.Sett_No,D.Sett_Type,D.Party_Code,D.Scrip_cd,D.Series,M.IsIn,D.Qty,D.InOut  
having D.Qty > Sum(isnull(De.qty,0))  
  
/* Getting Shortages from All Open Settlement From BSE */  
Insert Into DelPayOut  
select 'BSE',D.Sett_No,D.Sett_Type,D.Party_Code,D.Scrip_cd,D.Series,CertNo=M.IsIn,  
DebitQty=0,PayQty=0,ShrtQty=D.Qty-Sum(isnull(De.qty,0)),0,'',LedBal=0,EffBal=0,Cl_Rate=0,GetDate(),0   
from BSEDB.DBO.Sett_Mst S, BSEDB.DBO.MultiIsIn M, BSEDB.DBO.deliveryClt d Left Outer Join BSEDB.DBO.DelTrans de   
On ( de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd   
     and de.series = d.series and de.party_code = d.party_code And DrCr = 'C' and filler2 = 1 )  
where d.inout = 'I' and D.qty > 0   
And M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series And Valid = 1   
and d.sett_no = S.Sett_no and d.sett_type = S.Sett_Type   
And Sec_PayOut >= Left(Convert(Varchar,GetDate(),109),11) and D.Sett_Type Not Like 'A%'  
group by D.Sett_No,D.Sett_Type,D.Party_Code,D.Scrip_Cd,D.Scrip_cd,D.Series,M.IsIn,D.Qty,D.InOut  
having D.Qty > Sum(isnull(De.qty,0))  
  
  
/* Getting Holding from All Pool Account From NSE */  
Insert Into DelPayOut  
select 'NSE',D.Sett_No,D.Sett_Type,D.Party_Code,D.Scrip_cd,D.Series,D.CertNo,DebitQty=0,PayQty=0,ShrtQty=0,  
Sum(D.Qty),BDpType,LedBal=0.00,EffBal=0.00,Cl_Rate=0.00,GetDate(),0   
from deltrans D, DeliveryDp Dp where drcr = 'D'  
And Filler2 = 1 And Delivered = '0' and BCltDpId = Dp.DpCltNo And BDpId = Dp.DpId   
And Description Like '%POOL%'   
And TrType = 904 And CertNo Like 'IN%'  
Group By D.Sett_No,D.Sett_Type,D.Party_Code,D.Scrip_Cd,D.Series,D.CertNo,BDpType  
  
/* Getting Holding from All Beneficiary Account From BSE */  
Insert Into DelPayOut  
select 'BSE',D.Sett_No,D.Sett_Type,D.Party_Code,D.Scrip_cd,D.Series,D.CertNo,DebitQty=0,PayQty=0,ShrtQty=0,  
Sum(D.Qty),BDpType,LedBal=0,EffBal=0,Cl_Rate=0,GetDate(),0    
from BSEDB.DBO.deltrans D, BSEDB.DBO.DeliveryDp Dp where drcr = 'D'  
And Filler2 = 1 And Delivered = '0' and BCltDpId = Dp.DpCltNo And BDpId = Dp.DpId   
And Description Like '%POOL%'   
And TrType = 904 And CertNo Like 'IN%'  
Group By D.Sett_No,D.Sett_Type,D.Party_Code,D.Scrip_Cd,D.Scrip_Cd,D.Series,D.CertNo, BDpType  
  
Update DelPayOut Set Cl_Rate = C.Cl_Rate From Closing C Where   
Sysdate = (Select Max(SysDate) From Closing Where C.Scrip_Cd = Scrip_Cd   
And C.Series = Series ) And C.Scrip_Cd = DelPayOut.Scrip_Cd  
And C.Series = DelPayOut.Series  
  
Update DelPayOut Set Cl_Rate = C.Cl_Rate From BSEDB.DBO.Closing C Where   
Sysdate = (Select Max(SysDate) From BSEDB.DBO.Closing Where C.Scrip_Cd = Scrip_Cd   
And C.Series = Series ) And C.Scrip_Cd = DelPayOut.Scrip_Cd  
And C.Series = DelPayOut.Series  
  
Update DelPayOut Set PayOutDate = Sec_PayOut From Sett_Mst S Where   
S.Sett_No = DelPayOut.Sett_No And S.Sett_Type = DelPayOut.Sett_Type   
And DelPayout.Exchange = 'NSE'  
  
Update DelPayOut Set PayOutDate = Sec_PayOut From BSEDB.DBO.Sett_Mst S Where   
S.Sett_No = DelPayOut.Sett_No And S.Sett_Type = DelPayOut.Sett_Type   
And DelPayout.Exchange = 'BSE'   
  
Update DelPayOut Set EffBal = Amount From (  
select CltCode,Amount=Sum(Case When L.DrCr = 'D' Then -Vamt Else Vamt end)  
from Account.Dbo.Ledger L, Account.DBO.Parameter P  
Where EDt <= Left(Convert(Varchar,GetDate(),109),11) + ' 23:59:59'  
And Edt >= SdtCur And CurYear = 1   
Group by CltCode) A Where A.CltCode = DelPayOut.Party_Code   
  
Update DelPayOut Set LedBal = Amount From (  
select CltCode,Amount=Sum(Case When L.DrCr = 'D' Then -Vamt Else +Vamt end)  
from Account.Dbo.Ledger L, Account.DBO.Parameter P  
Where VDt <= Left(Convert(Varchar,GetDate(),109),11) + ' 23:59:59'  
And Vdt >= SdtCur And CurYear = 1 And VTyp <> '2'  
Group by CltCode) A Where A.CltCode = DelPayOut.Party_Code   
  
Update DelPayOut Set LedBal = LedBal + Amount From (  
select CltCode,Amount=Sum(Case When L.DrCr = 'D' Then -Vamt Else +Vamt end)  
from Account.Dbo.Ledger L, Account.DBO.Parameter P  
Where EDt <= Left(Convert(Varchar,GetDate(),109),11) + ' 23:59:59'  
And Edt >= SdtCur And CurYear = 1 And VTyp = '2'  
Group by CltCode) A Where A.CltCode = DelPayOut.Party_Code

GO
