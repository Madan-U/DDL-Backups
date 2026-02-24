-- Object: PROCEDURE dbo.Rpt_NseDebitStock
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/*  DROP Proc Rpt_NseDebitStock  */
CREATE Proc Rpt_NseDebitStock (@FParty_Code Varchar(10),@TParty_Code Varchar(10)) As
Truncate Table DelDebitSummary 

Insert Into DelDebitSummary
select Branch_Cd='',D.Party_Code,Long_Name='',Scrip_Name=D.Scrip_Cd,D.Scrip_cd,D.Series,D.CertNo,DebitQty=Sum(D.Qty),PayQty=0,FutQty=0,ShrtQty=0,
LedBal=0,EffBal=0,Cash=0,NonCash=0,Cl_Rate=1.00 ,Family='','','','' 
from deltrans D, DeliveryDp Dp where drcr = 'D'
And Filler2 = 1 And Delivered = '0' and BCltDpId = Dp.DpCltNo And BDpId = Dp.DpId 
And Description Not Like '%POOL%' 
And D.Party_Code >= @FParty_Code And D.Party_Code <= @TParty_Code and ShareType <> 'AUCTION'
Group By D.Party_Code,D.Scrip_Cd,D.Scrip_Cd,D.Series,D.CertNo

Insert Into DelDebitSummary
Select Branch_Cd='',D.Party_Code,Long_Name='',Scrip_Name=D.Scrip_Cd,D.Scrip_cd,D.Series,CertNo='',DebitQty=0,PayQty=Sum(D.Qty),FutQty=0,ShrtQty=0,
LedBal=0,EffBal=0,Cash=0,NonCash=0,Cl_Rate=1.00,Family='','','',''
from DeliveryClt D, Sett_mst S where 
S.Sett_No = D.Sett_No And S.Sett_Type = D.Sett_Type And InOut = 'O' 
And Sec_PayOut Like Left(Convert(Varchar,GetDate(),109),11) + '%'
And D.Party_Code >= @FParty_Code And D.Party_Code <= @TParty_Code and D.Sett_Type <> 'A'
Group By D.Party_Code,D.Scrip_Cd,D.Scrip_Cd,D.Series

Insert Into DelDebitSummary
Select Branch_Cd='',D.Party_Code,Long_Name='',Scrip_Name=D.Scrip_Cd,D.Scrip_cd,D.Series,CertNo='',DebitQty=0,PayQty=0,FutQty=Sum(D.Qty),ShrtQty=0,
LedBal=0,EffBal=0,Cash=0,NonCash=0,Cl_Rate=1.00,Family='','','','' 
from DeliveryClt D, Sett_mst S where 
S.Sett_No = D.Sett_No And S.Sett_Type = D.Sett_Type And InOut = 'O' And
Sec_PayOut > Left(Convert(Varchar,GetDate(),109),11) + ' 23:59:59' 
And D.Party_Code >= @FParty_Code And D.Party_Code <= @TParty_Code and D.Sett_Type <> 'A'
Group By D.Party_Code,D.Scrip_Cd,D.Scrip_Cd,D.Series

Insert Into DelDebitSummary
select Branch_Cd='',D.Party_Code,Long_Name='',Scrip_Name=D.Scrip_Cd,D.Scrip_cd,D.Series,CertNo='',
DebitQty=0,PayQty=0,FutQty=0,ShrtQty=D.Qty-Sum(isnull(De.qty,0)),LedBal=0,EffBal=0,Cash=0,NonCash=0,Cl_Rate=1.00,Family='','','','' 
from Sett_Mst S,deliveryClt d Left Outer Join DelTrans de 
On ( de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd 
     and de.series = d.series and de.party_code = d.party_code And DrCr = 'C' and filler2 = 1 and ShareType <> 'AUCTION')
where d.inout = 'I' and D.qty > 0 
and d.sett_no = S.Sett_no and d.sett_type = S.Sett_Type 
And Sec_PayOut Like Left(Convert(Varchar,GetDate(),109),11) + '%' and D.Sett_Type <> 'A' 
And D.Party_Code >= @FParty_Code And D.Party_Code <= @TParty_Code
group by D.Party_Code,D.Scrip_Cd,D.Scrip_cd,D.Series,D.Qty,D.InOut
having D.Qty > Sum(isnull(De.qty,0))

Insert Into DelDebitSummary
select Branch_Cd='',L.CltCode,Long_Name='',Scrip_Name='',Scrip_cd='',Series='',CertNo='',
DebitQty=0,PayQty=0,FutQty=0,ShrtQty=0,LedBal=0,EffBal=Sum(Case When L.DrCr = 'D' Then -Vamt Else Vamt end),
Cash=0,NonCash=0,Cl_Rate=1.00,Family='','','','' 
from Account.Dbo.Ledger L, Account.DBO.Parameter P, Account.DBO.AcMast M
Where EDt <= Left(Convert(Varchar,GetDate(),109),11) + ' 23:59:59'
And Edt >= SdtCur And CurYear = 1 And M.CltCode = L.CltCode And M.AcCat = 4 
And L.CltCode >= @FParty_Code And L.CltCode <= @TParty_Code
Group by L.CltCode
Having Sum(Case When L.DrCr = 'D' Then -Vamt Else Vamt end) <> 0 

Insert Into DelDebitSummary
select Branch_Cd='',L.CltCode,Long_Name='',Scrip_Name='',Scrip_cd='',Series='',CertNo='',
DebitQty=0,PayQty=0,FutQty=0,ShrtQty=0,LedBal=Sum(Case When L.DrCr = 'D' Then -Vamt Else Vamt end),EffBal=0,
Cash=0,NonCash=0,Cl_Rate=1.00,Family='','','','' 
from Account.Dbo.Ledger L, Account.DBO.Parameter P,Account.DBo.Acmast M
Where VDt <= Left(Convert(Varchar,GetDate(),109),11) + ' 23:59:59'
And Vdt >= SdtCur And CurYear = 1 And M.CltCode = L.CltCode And M.AcCat = 4 
And L.CltCode >= @FParty_Code And L.CltCode <= @TParty_Code
Group by L.CltCode
Having Sum(Case When L.DrCr = 'D' Then -Vamt Else Vamt end) <> 0 

Insert Into DelDebitSummary
select Branch_Cd='',Party_Code,Long_Name='',Scrip_Name='',Scrip_cd='',Series='',CertNo='',
DebitQty=0,PayQty=0,FutQty=0,ShrtQty=0,LedBal=0,EffBal=0,
Cash=IsNull(Sum(Cash),0),NonCash=IsNull(Sum(NonCash),0),Cl_Rate=1.00,Family='','','','' 
from Collateral C Where Segment = 'Capital' And Trans_Date Like Left(Convert(Varchar,GetDate(),109),11) + '%'
And Party_Code >= @FParty_Code And Party_Code <= @TParty_Code
Group By Party_Code

delete From DelDebitSummary Where DebitQty = 0 
And PayQty = 0 And FutQty = 0 And ShrtQty = 0 And 
LedBal = 0 And EffBal = 0 And Cash = 0 And NonCash = 0


UPDATE DELDEBITSUMMARY SET Cl_Rate = C.Cl_Rate From Closing C ,
( Select Closing.Scrip_cd,Closing.Series,Sysdate = Max(SysDate) From Closing ,Deldebitsummary 
Where DelDebitSummary.Scrip_Cd = Closing.Scrip_Cd And DelDebitSummary.series = Closing.Series 
And Market = 'NORMAL' group by Closing.Scrip_cd,Closing.series) D
Where C.Sysdate = D.sysdate and C.scrip_cd = D.Scrip_cd and c.Series = D.Series
AND C.scrip_cd = DelDebitSummary.Scrip_cd and c.Series = DelDebitSummary.Series
And Market = 'NORMAL'

Update DelDebitSummary Set Long_Name = C1.Long_Name,Branch_Cd=C1.Branch_Cd,Family=C1.Family
From ClientMaster C1
Where C1.Party_Code = DelDebitSummary.Party_Code

Update DelDebitSummary Set FamilyName = C1.Long_Name From ClientMaster C1 
Where C1.Party_Code = DelDebitSummary.Family

Update DelDebitSummary Set Sub_Broker = C1.Sub_Broker,Trader=C1.Trader
From Client1 C1, Client2 C2
Where C2.Party_Code = DelDebitSummary.Party_Code
And C1.Cl_Code = C2.Cl_Code

Update DelDebitSummary Set CertNo = IsIn From MultiIsIn M
Where DelDebitSummary.Scrip_Cd = M.Scrip_CD And DelDebitSummary.Series = M.Series
And Valid = 1 And CertNo = ''

GO
